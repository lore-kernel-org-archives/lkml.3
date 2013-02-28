Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759963Ab3B1Vuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 16:50:51 -0500
Received: from mout.gmx.net ([212.227.15.19]:52707 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610Ab3B1Vut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 16:50:49 -0500
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX19Sh1wqwndS0571XxrEDPOjlVS1MkTZQ17zcwJ37y
	Hx0PpR4VqNtIzk
From: Sven Joachim <svenjoac@gmx.de>
To: jlec@gentoo.org
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kconfig: use config scripts to detect ncurses libs
References: <jlec@gentoo.org>
	<1362045557-9123-1-git-send-email-jlec@gentoo.org>
Date: Thu, 28 Feb 2013 22:50:45 +0100
In-Reply-To: <1362045557-9123-1-git-send-email-jlec@gentoo.org>
	(jlec@gentoo.org's message of "Thu, 28 Feb 2013 10:59:17 +0100")
Message-ID: <874ngwhzuy.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-02-28 10:59 +0100, jlec@gentoo.org wrote:

> Ncurses provides a config script (ncurses5-config) to assist finding ncurses.
> This patch makes use of it to detect the necessary libs for linking of the
> ncurses nconfig dialog.

That script is not necessarily called ncurses5-config, it might also be
called ncurses6-config is ncurses is configured for a different ABI
(--enable-ext-colors, --enable-ext-mouse).  Although I would suspect
that any distribution who does that provides a compatibility symlink.

>  scripts/kconfig/Makefile | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
> index 3091794..c372976 100644
> --- a/scripts/kconfig/Makefile
> +++ b/scripts/kconfig/Makefile
> @@ -216,7 +216,9 @@ HOSTCFLAGS_gconf.o	= `pkg-config --cflags gtk+-2.0 gmodule-2.0 libglade-2.0` \
>  
>  HOSTLOADLIBES_mconf   = $(shell $(CONFIG_SHELL) $(check-lxdialog) -ldflags $(HOSTCC))
>  
> -HOSTLOADLIBES_nconf	= -lmenu -lpanel -lncurses
> +HOSTLOADLIBES_nconf	= -lmenu -lpanel
> +HOSTLOADLIBES_nconf	+= $(shell    ncursesw5-config --libs 2>/dev/null \
> +				   || ncurses5-config --libs 2>/dev/null  )

This will link with ncursesw, not ncurses.  Probably not what you want,
since nconf.h does not #include the right headers for that.

On Debian/Ubuntu, there's also the problem that ncursesw5-config exists
even if the libncursesw5-dev package is not installed, so this patch
makes the build fail in such cases.

Can we just call ncurses5-config and not ncursesw5-config, or are there
any distros who ship the latter and not the former?

Cheers,
       Sven
