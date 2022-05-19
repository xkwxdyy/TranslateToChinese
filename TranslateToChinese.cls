%
% Copyright (c) 2022 Kangwei Xia
% Released under the LaTeX Project Public License v1.3c License.
% Repository: https://github.com/xkwxdyy/TranslateToChinese
% Repository: https://gitee.com/xkwxdyy/TranslateToChinese
%

\NeedsTeXFormat{LaTeX2e}[2017/04/15]
\RequirePackage{expl3}
\RequirePackage{xparse}
\ProvidesExplClass {TranslateToChinese} {2022-05-10} {v0.1a}
  {LaTeX template for translation to Chinese}

% 检查 LaTeX2e kernel 版本
\msg_new:nnn { TranslateToChinese } { latex-too-old }
  { TeX~ Live~ 2020~ or~ later~ version~ is~ required~ to~ compile~ this~ document. }
\@ifl@t@r \fmtversion { 2020/02/02 }
  { }
  { \msg_fatal:nn { TranslateToChinese } { latex-too-old } }

% 检查编译引擎，要求使用 XeLaTeX。
\msg_new:nnn { TranslateToChinese } { incompatible-engine }
  { XeLaTeX~ is~ required~ to~ compile~ this~ document. }

\sys_if_engine_xetex:F
  { \msg_fatal:nn { TranslateToChinese } { incompatible-engine } }


% 使用 l3keys 定义 \translatetochinesesetup 配置命令
\NewDocumentCommand \translatetochinesesetup { m }
  { \keys_set:nn { TranslateToChinese } {#1} }




% 加载文档类和宏包

% 处理文档类选项
\PassOptionsToClass 
  {
    UTF8,
    a4paper, 
    scheme = chinese,
    oneside
  } 
  { ctexbook }
\DeclareOption* { \PassOptionsToClass { \CurrentOption } { ctexbook } }
\ProcessOptions*

\RequirePackage { filehook }
\AtEndOfPackageFile* { fontspec }
  { \msg_redirect_name:nnn { fontspec } { no-script } { none } }
\AtEndOfPackageFile* { xeCJK }
  {
    \msg_redirect_name:nnn { xeCJK } { CJKfamily-redef } { none }
    \defaultCJKfontfeatures
      {
        Script  = CJK
      }
  }

% 载入 \cls{ctexbook} 文档类。
\LoadClass { ctexbook }

% 要求 ctex v2.4.9 2017-04-01 或更高的版本。
\msg_new:nnn { TranslateToChinese } { require-package-version }
  { The~ package~ "#1"~ is~ required. }

\@ifclasslater { ctexbook } { 2017/04/01 }
  { }
  {
    \msg_fatal:nnn { TranslateToChinese } { require-package-version }
      { ctex~ v2.4.9~ 2017-04-01 }
  }

% 建议在模板开始处载入全部宏包，不要轻易改变加载顺序。
\RequirePackage { etoolbox }       % 补丁
\RequirePackage { geometry }       % 页面设置
\RequirePackage { graphicx }       % 插图
\RequirePackage { xcolor }         % 颜色
\RequirePackage { fontspec }       % 字体
\RequirePackage { xeCJK }          % 消除中文警告
\RequirePackage { xeCJKfntef }     % 处理中文下划线
\RequirePackage { fancyhdr }       % 页眉页脚
\RequirePackage { lastpage }       % 页码
\RequirePackage { amsmath }        % 数学
\RequirePackage { enumitem }       % 罗列环境
\RequirePackage { tabularray }     % 表格
\RequirePackage { hyperref }       % 超链接


% 对冲突的宏包报错。
\msg_new:nnn { TranslateToChinese } { package-conflict }
  { The~ "#2"~ package~ is~ incompatible~ with~ "#1". }

\cs_new:Npn \translatetochinese_package_conflict:nn #1#2
  {
    \AtEndOfPackageFile* {#1}
      {
        \AtBeginOfPackageFile* {#2}
          { \msg_error:nnnn { TranslateToChinese } { package-conflict } {#1} {#2} }
      }
  }

\translatetochinese_package_conflict:nn { unicode-math } { amscd }
\translatetochinese_package_conflict:nn { unicode-math } { amsfonts }
\translatetochinese_package_conflict:nn { unicode-math } { amssymb }
\translatetochinese_package_conflict:nn { unicode-math } { bbm }
\translatetochinese_package_conflict:nn { unicode-math } { bm }
\translatetochinese_package_conflict:nn { unicode-math } { eucal }
\translatetochinese_package_conflict:nn { unicode-math } { eufrak }
\translatetochinese_package_conflict:nn { unicode-math } { mathrsfs }
\translatetochinese_package_conflict:nn { unicode-math } { newtxmath }
\translatetochinese_package_conflict:nn { unicode-math } { upgreek }

\translatetochinese_package_conflict:nn { enumitem } { paralist }

% 超链接设置
\hypersetup
  {
    colorlinks,
    linkcolor = blue,
    unicode,
    psdextra
  }

% 图片路径
\graphicspath{{img/}}


% 孤行寡行控制

\int_set:Nn \clubpenalty { 350}
\int_set:Nn \widowpenalty { 350 }


% 重定义的命令环境

\RenewDocumentCommand { \emph } { m }
  {
    \group_begin:
      \bfseries
      #1
    \group_end:
  }

% 处理附录的页码
\fancypagestyle { appendix }
  {
    \fancyhf { }
    \fancyfoot [ C ]
      {
        \bfseries \thepage
      }
    \renewcommand{\headrulewidth}{0pt}
  }
\pretocmd { \appendix }
  {
    \fancypagestyle { plain }
      {
        \fancyhf { }
        \fancyfoot [ C ]
          {
            \bfseries \thepage
          }
        \renewcommand{\headrulewidth}{0pt}
      }
    \pagestyle { appendix }
  }
  {}{}

% 自定义的命令环境


% 名词解释环境 nounexplanation

\cs_new:Npn \__translatetochinese_description_first_labelfont:n #1
  {
    \bfseries #1
    \ignorespaces
  }
\cs_new:Npn \__translatetochinese_description_second_labelfont:n #1
  {
    $\bullet$~
    \bfseries #1
    \ignorespaces
  }
\newlist{nounexplanation}{description}{2}
\setlist[nounexplanation, 1]
  {
    align       = left,
    labelindent = \parindent,
    labelsep    = 0pt,
    leftmargin  = 0pt,
    widest      = 0,
    itemindent  = *,
    font        = \__translatetochinese_description_first_labelfont:n
  }
\setlist[nounexplanation, 2]
  {
    align       = left,
    labelindent = \parindent,
    labelsep    = 0pt,
    leftmargin  = 2em,
    widest      = 0,
    itemindent  = *,
    font        = \__translatetochinese_description_second_labelfont:n
  }


% 翻译命令 \translate

\NewDocumentCommand { \translate } { s m }
  {
    \IfBooleanTF {#1}
      {
        % 带星号
        (\textsl{#2})
      }
      {
        % 不带星号
        (#2)
      }
  }


% 超链接标记 \urlmarker

\keys_define:nn { TranslateToChinese / urlmarker }
  {
    color . tl_set:N = \l__translatetochinese_urlmarker_color_tl
  }
\keys_set:nn { TranslateToChinese / urlmarker }
  {
    color = blue
  }
\NewDocumentCommand { \urlmarker } { O{} m }
  {
    \group_begin:
      \keys_set:nn { TranslateToChinese / urlmarker } {#1}
      \color { \tl_use:N \l__translatetochinese_urlmarker_color_tl }
      \slshape
      #2
      % \CJKunderline{#2}
    \group_end:
  }