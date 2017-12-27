" -----------------------------------------------------------------------------
" file        : init.vim
" description : neovim main configuration file
" author      : Elias Löwe <elias@lowenware.com>
" version     : 2017-12-27-1
" -----------------------------------------------------------------------------

" plugins --------------------------------------------------------------------- 
"
" using Plug ( https://github.com/junegunn/vim-plug )
call plug#begin('~/.config/nvim/plugins')

" begin : list of plugins
Plug 'scrooloose/nerdtree'
" end

call plug#end()

" key mapping -----------------------------------------------------------------

" change the leader key from "\" to ";"
let mapleader=";"

" shortcut to edit config 
nnoremap <silent> <leader>ec :e $MYVIMRC<CR>

" shortcut to reload config
nnoremap <silent> <leader>sc :source $MYVIMRC<CR>

" go to first TAB with Czech KB layout
nmap <Leader>+ 1gt 
" go to first normal KB layout
nmap <Leader>1 1gt 
" go to previous tab
nmap <Leader>, gT  
" go to next tab
nmap <Leader>. gt  

" toggle NERDTree
nnoremap ;; :NERDTreeToggle<CR>

" switch between windows with ALT+arrow keys
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>

" editor settings -------------------------------------------------------------

colorscheme alchemie

set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8
set nobackup
set noswapfile
set autochdir
set cursorline
set cursorcolumn
set autoread                            " reread file changes
set backspace=indent,eol,start          " affect indents eol and begin of line
set clipboard=unnamedplus
set confirm                             " confirm exit
set mouse=a

" format and wrapping ---------------------------------------------------------
set textwidth=80
set autoindent
set smartindent
set nowrap
set nolinebreak
set tabstop=2                           " tab size in symbols
set shiftwidth=2                        " number of spaces for autoindent
set expandtab                           " use spaces instead of tabs
set showbreak=>                         " line continuation symbol

" wildmenu -------------------------------------------------------------------

set wildmenu
set wildmode=full

" ui settings ----------------------------------------------------------------

set termguicolors
set showtabline=2
set laststatus=2
set visualbell
set list                                " show tabs and spec symbols
set listchars=tab:→→,trail:·,extends:>,precedes:< 
set number                              " show line numbers
set numberwidth=4                       " width of line number column
set colorcolumn=81
set guifont=Hack\ Regular\ 12

" Tabs ------------------------------------------------------------------------

function MyTabLine()
  let line = ' ☿'
  let cur_tab = tabpagenr()
  for i in range(tabpagenr('$'))
    let i_tab     = i+1
    let i_win     = tabpagewinnr(i_tab)
    let buffers   = tabpagebuflist(i_tab)
    let i_buf     = buffers[i_win - 1]
    let tab_label = bufname(i_buf)
    let tab_label = (tab_label != '' ? fnamemodify(tab_label, ':t') : '[Neu]')
    let is_mod    = getbufvar(i_buf, "&mod")

    let line .= ' %' . i_tab . 'T'
    let line .= (i_tab == cur_tab ? '%#TabLineSel#' : '%#TabLine#')
    let line .= ' ' . i_tab . ':' . tab_label . ' '
    if is_mod
      let line .= '+ '
    endif
  endfor

  let line .= '%#TabLineFill#'
  if (exists("g:tablineclosebutton"))
    let line .= '%=%999XX'
  endif
  return line
endfunction

set tabline=%!MyTabLine()

" statusline ----------------------------------------------------------------- 

" function to get GIT branch
function! MyGitBranch()
  let l:git_branch = system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
  return strlen(l:git_branch) > 0 ? ' ⌥  '.l:git_branch.' ' : ''
endfunction

set statusline=%#StatusLineSpot# 
set statusline+=>
set statusline+=%#StatusLineBranch# 
set statusline+=%{MyGitBranch()} 
set statusline+=%#StatusLine# 
set statusline+=\ %F
set statusline+=%h
set statusline+=%m
set statusline+=%r
set statusline+=%=
set statusline+=%#StatusLineNC#
set statusline+=\ %{strlen(&fileencoding)?&fileencoding:&encoding}
set statusline+=\ ·\ %{&filetype}
set statusline+=\ ·\ %{&ff}
set statusline+=\ %#StatusLine#
set statusline+=\ ☰
set statusline+=\ %c:
set statusline+=%l\-%L
set statusline+=\ %P
set statusline+=%#StatusLineSpot#
set statusline+=<

" nerdtree settings -----------------------------------------------------------

" close editor on :q if only window open is NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" -----------------------------------------------------------------------------
