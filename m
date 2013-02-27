Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760730Ab3B0Sh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 13:37:56 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:33543 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760317Ab3B0Shy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 13:37:54 -0500
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/2] Use config scripts to detect ncurses libs for menuconfig
Date: Wed, 27 Feb 2013 19:37:49 +0100
User-Agent: KMail/1.13.5 (Linux/3.8.0-treguer; KDE/4.4.5; x86_64; ; )
Cc: jlec@gentoo.org, linux-kernel@vger.kernel.org
References: <jlec@gentoo.org> <1361988458-18486-1-git-send-email-jlec@gentoo.org>
In-Reply-To: <1361988458-18486-1-git-send-email-jlec@gentoo.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302271937.49565.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin, All,

On Wednesday 27 February 2013 jlec@gentoo.org wrote:
> When building ncurses with --with-termlib several symbols get moved from
> libncurses.so to libtinfo.so. Thus when linking with libncurses.so, one
> additionally needs to link with libtinfo.so.
> 
> Ncurses provides a config script (ncurses5-config) to assist finding ncurses.
> This patch makes use of it to detect the necessary libs for linking of the
> ncurses menuconfig dialog.
> 
> Signed-off-by: Justin Lecher <jlec@gentoo.org>

Usually, patch subjects are of the form:
  subsystem: subject

So I'd suggest the following subject:
    kconfig/menuconfig: use config scripts to detect ncurses libs

That way, it makes it easy to see at first glance what the patch is
about (kconfig/menuconfig), and what it achieves (use config scripts).

> ---
>  scripts/kconfig/lxdialog/check-lxdialog.sh | 24 ++++++++++++++++--------
>  1 file changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/scripts/kconfig/lxdialog/check-lxdialog.sh b/scripts/kconfig/lxdialog/check-lxdialog.sh
> index c8e8a71..e429207 100644
> --- a/scripts/kconfig/lxdialog/check-lxdialog.sh
> +++ b/scripts/kconfig/lxdialog/check-lxdialog.sh
> @@ -4,15 +4,23 @@
>  # What library to link
>  ldflags()
>  {
> -	for ext in so a dll.a dylib ; do
> -		for lib in ncursesw ncurses curses ; do
> -			$cc -print-file-name=lib${lib}.${ext} | grep -q /
> -			if [ $? -eq 0 ]; then
> -				echo "-l${lib}"
> -				exit
> -			fi
> +	if ncursesw5-config --libs >/dev/null 2>&1; then
> +		ncursesw5-config --libs
> +		exit
> +	elif ncurses5-config --libs >/dev/null 2>&1; then
> +		ncurses5-config --libs
> +		exit

No need to run ncurses{,w}5-config twice each. Just do:

    ncursesw5-config --libs 2>/dev/null && exit
    ncurses5-config --libs 2>/dev/null && exit
    [old code unchanged]

This avoids an ugly re-indent of otherwise unchanged code.

On a side note: is the old code still useful, now we use the config
scripts? In other words: are there cases where a ncurses install would
not provide those scripts?

If the answer is 'no', then just trash the old code away.

I've just tested Debian Squeeze (stable for now), and Cygwin, and they
both do provide ncurses{,w}5-config.

> +	else
> +		for ext in so a dll.a dylib ; do
> +			for lib in ncursesw ncurses curses ; do
> +				$cc -print-file-name=lib${lib}.${ext} | grep -q /
> +				if [ $? -eq 0 ]; then
> +					echo "-l${lib}"
> +					exit
> +				fi
> +			done
>  		done
> -	done
> +	fi
>  	exit 1
>  }

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
