Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab3B0Ucu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 15:32:50 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:58569 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab3B0Ucs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 15:32:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH] Consolidate CONFIG_DEBUG_STRICT_USER_COPY_CHECK
Date: Wed, 27 Feb 2013 20:32:20 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org,
        Arjan van de Ven <arjan@linux.intel.com>, Helge Deller <deller@gmx.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Chris Metcalf <cmetcalf@tilera.com>
References: <1361934016-22630-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1361934016-22630-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302272032.21014.arnd@arndb.de>
X-Provags-ID: V02:K0:KdRqLIm2MHRSi+Ma49YnuBYLoPy4ywUwDgCninoe0LI
 jI6EkwIYSwjlk+cQpZWzyu2Plki+Bn6SEty/a4iEcKhU9HBkNF
 HjbnAi29AuQ30EgO7gt8jIw4BFEfUd2pswTPrWyOuNyVGqFRX1
 CXZ780gJio0OpE8NG/Q1/IahICGejbs8adE0SxqwGGVTwVqIq8
 gZIlN9E3zvN1bIPnY6EPpyHXYigZ+CNyQZ+vORBPqT94R6PZZw
 YWsvJpxhyQganKEcsibFb5HfDI2XUFZYraM0Yj4Aldlc//yvJr
 nOyfMWUss2l16JvtVnhCij4ZzgvMyNCJ+0twIoJarD/L4sMUNC
 RG3/vGmtQbxLgdOjPBYw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 February 2013, Stephen Boyd wrote:
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 28be08c..ae80518 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -1292,6 +1292,24 @@ config LATENCYTOP
>  	  Enable this option if you want to use the LatencyTOP tool
>  	  to find out which userspace is blocking on what kernel operations.
>  
> +config ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
> +	bool
> +
> +config DEBUG_STRICT_USER_COPY_CHECKS
> +	bool "Strict user copy size checks"
> +	depends on ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
> +	depends on DEBUG_KERNEL && !TRACE_BRANCH_PROFILING
> +	help
> +	  Enabling this option turns a certain set of sanity checks for user
> +	  copy operations into compile time failures.
> +
> +	  The copy_from_user() etc checks are there to help test if there
> +	  are sufficient security checks on the length argument of
> +	  the copy operation, by having gcc prove that the argument is
> +	  within bounds.
> +
> +	  If unsure, say N.
> +

Is there actually any architecture dependency left after this?
I wonder if we actually need the ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
symbol, or could just show the DEBUG_STRICT_USER_COPY_CHECKS option
on all architectures.

It's fine to do your patch as a first step though, which would not
change the behavior.

> diff --git a/lib/Makefile b/lib/Makefile
> index 32f4455..59fabd0 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -15,6 +15,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
>  	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
>  	 earlycpio.o percpu-refcount.o
>  
> +lib-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
>  lib-$(CONFIG_MMU) += ioremap.o
>  lib-$(CONFIG_SMP) += cpumask.o
>

I think this should instead be

+lib-$(DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o

No point building that file if we are not using it.

Other than that, 

Acked-by: Arnd Bergmann <arnd@arndb.de>
