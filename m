Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257Ab3BYSaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 13:30:30 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41277 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab3BYSa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 13:30:28 -0500
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: linux-kbuild@vger.kernel.org, jlec@gentoo.org
Subject: Re: [PATCH] Use config scripts to detect ncurses libs for, menuconfig/nconfig dialogs
Date: Mon, 25 Feb 2013 19:30:21 +0100
User-Agent: KMail/1.13.5 (Linux/3.8.0-treguer; KDE/4.4.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <512A36BB.9070309@gentoo.org>
In-Reply-To: <512A36BB.9070309@gentoo.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302251930.22293.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin, All,

On Sunday 24 February 2013 Justin wrote:
> when ncurses is build with --with-termlib several symbols are moved to a
> seperate terminfo library (libtinfo.so). Current Kernel buildsystem
> results in a build error with menuconfig and nconfig dialogs.

Do you know of a distribution where this is the case, so I can test?

[--SNIP--]
> Attached patch uses ncurses5-config and pkg-config to detect the libs to
> link with. Please include this to fix the build error.

Next time, please include the patch directly in the mail body, it is easier
to review and comment. Using 'git send-email' does that automatically for
you.

> Subject: [PATCH] Use config scripts to detect ncurses libs for
>  menuconfig/nconfig dialogs
> 
> When building ncurses with --with-termlib several symbols get moved from
> libncurses.so to libtinfo.so. Thus when linking with libncurses.so, one
> additionally needs to link with libtinfo.so.
> 
> Ncurses provides a config script (ncurses5-config) and an interface with
> pkg-config. This patch makes use of those to detect the necessary libs
> for linking of the ncurses menuconfig and nconfig dialogs.

I think I would prefer spearate patches, one for mconf, one for nconf.

> Signed-off-by: Justin Lecher <jlec@gentoo.org>
> ---
> 
>  scripts/kconfig/Makefile                   |  2 +-
>  scripts/kconfig/lxdialog/check-lxdialog.sh | 22 ++++++++++++++--------
>  2 files changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
> index 3091794..7649047 100644
> --- a/scripts/kconfig/Makefile
> +++ b/scripts/kconfig/Makefile
> @@ -216,7 +216,7 @@ HOSTCFLAGS_gconf.o	= `pkg-config --cflags gtk+-2.0
> gmodule-2.0 libglade-2.0` \
> 
>  HOSTLOADLIBES_mconf   = $(shell $(CONFIG_SHELL) $(check-lxdialog) -ldflags
>  $(HOSTCC))
> 
> -HOSTLOADLIBES_nconf	= -lmenu -lpanel -lncurses
> +HOSTLOADLIBES_nconf	= `pkg-config --libs menu panel ncurses`

On my distro (Debian stable) ncurses has no pkg-config file installed, so
this fails.

>  $(obj)/qconf.o: $(obj)/.tmp_qtcheck
>  
>  ifeq ($(qconf-target),1)
> 
> diff --git a/scripts/kconfig/lxdialog/check-lxdialog.sh
> b/scripts/kconfig/lxdialog/check-lxdialog.sh index c8e8a71..4699c1b 100644
> --- a/scripts/kconfig/lxdialog/check-lxdialog.sh
> +++ b/scripts/kconfig/lxdialog/check-lxdialog.sh
> @@ -4,15 +4,21 @@
> 
>  # What library to link
>  ldflags()
>  {
> 
> -	for ext in so a dll.a dylib ; do
> -		for lib in ncursesw ncurses curses ; do
> -			$cc -print-file-name=lib${lib}.${ext} | grep -q /
> -			if [ $? -eq 0 ]; then
> -				echo "-l${lib}"
> -				exit
> -			fi
> +	if type -p ncurses5-config &> /dev/null ; then
                                   ^^
This is a bashism, and will not work on purely POSIX shells.
Please use: >/dev/null 2>&1

> +		ncurses5-config --libs

I'd write:
    if ! ncurses5-config --libs 2>/dev/null; then
        old-code goes here
    fi

> +		exit 0

(nit-picking) I'd prefer you be consistent with existing code which just
calls 'exit' without a number.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
