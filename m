Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751186AbaGFJGD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 05:06:03 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:53112 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750897AbaGFJGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 05:06:00 -0400
Message-ID: <1404637557.24853.12.camel@x220>
Subject: Re: [PATCH] kconfig: store default ARCH in .config
From: Paul Bolle <pebolle@tiscali.nl>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org
Date: Sun, 06 Jul 2014 11:05:57 +0200
In-Reply-To: <20140706080234.19520.96704.stgit@zurg>
References: <20140706080234.19520.96704.stgit@zurg>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jul 2014 09:05:57.0429 (UTC) FILETIME=[7FBB3E50:01CF98F9]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-07-06 at 12:02 +0400, Konstantin Khlebnikov wrote:
> This patch makes cross-compilation configuration fully statefull.
> Default ARCH is stored in .config as CONFIG_DEFAULT_ARCH.
> After initial configuration specifying ARCH= is no longer required.
> 
> To avoid recursion it is read directly from .config using scritps/config
> because include/config/auto.conf is not yet included at this point.
> 
> Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
> ---

It this needed because the Kconfig symbol ARCH is set only if ARCH is
set in the environment?

Could the same result be had by saving CONFIG_ARCH in .config (I suppose
it actually already is) and then use its value on builds with
that .config unless ARCH is specified in the environment again? Ie,
change the "option env=[...]" semantics a bit, perhaps by special casing
CONFIG_ARCH. 

>  Documentation/kbuild/makefiles.txt |    2 ++
>  Makefile                           |   19 ++++++++++++++-----
>  init/Kconfig                       |    4 ++++
>  3 files changed, 20 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
> index c600e2f..ced3e42 100644
> --- a/Documentation/kbuild/makefiles.txt
> +++ b/Documentation/kbuild/makefiles.txt
> @@ -1394,6 +1394,8 @@ The top Makefile exports the following variables:
>  
>  	    make ARCH=m68k ...
>  
> +	Default $(ARCH) is stored in .config as CONFIG_DEFAULT_ARCH,
> +	so overriding is required only for initial configuration.
>  
>      INSTALL_PATH
>  
> diff --git a/Makefile b/Makefile
> index 50fb690..76fcd9f 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -171,6 +171,8 @@ VPATH		:= $(srctree)$(if $(KBUILD_EXTMOD),:$(KBUILD_EXTMOD))
>  
>  export srctree objtree VPATH
>  
> +KCONFIG_CONFIG	?= .config
> +export KCONFIG_CONFIG
>  
>  # SUBARCH tells the usermode build what the underlying arch is.  That is set
>  # first, and if a usermode build is happening, the "ARCH=um" on the command
> @@ -193,7 +195,18 @@ SUBARCH := $(shell uname -m | sed -e s/i.86/x86/ -e s/x86_64/x86/ \
>  # ARCH can be set during invocation of make:
>  # make ARCH=ia64
>  # Another way is to have ARCH set in the environment.
> -# The default ARCH is the host where make is executed.
> +# If CONFIG_DEFAULT_ARCH is in .config its value is used as default ARCH,
> +# otherwise the host where make is executed.
> +
> +ifndef ARCH
> +	ARCH := $(shell test -e $(KBUILD_OUTPUT)$(KCONFIG_CONFIG) && \
> +			$(srctree)/scripts/config \
> +			--file $(KBUILD_OUTPUT)$(KCONFIG_CONFIG) \
> +			--state "DEFAULT_ARCH")
> +ifeq ($(filter-out undef,$(ARCH)),)
> +	ARCH := $(SUBARCH)
> +endif
> +endif
>  
>  # CROSS_COMPILE specify the prefix used for all executables used
>  # during compilation. Only gcc and related bin-utils executables
> @@ -205,7 +218,6 @@ SUBARCH := $(shell uname -m | sed -e s/i.86/x86/ -e s/x86_64/x86/ \
>  # "make" in the configured kernel build directory always uses that.
>  # Default value for CROSS_COMPILE is not to prefix executables
>  # Note: Some architectures assign CROSS_COMPILE in their arch/*/Makefile
> -ARCH		?= $(SUBARCH)
>  CROSS_COMPILE	?= $(CONFIG_CROSS_COMPILE:"%"=%)
>  
>  # Architecture as present in compile.h
> @@ -244,9 +256,6 @@ endif
>  # Where to locate arch specific headers
>  hdr-arch  := $(SRCARCH)
>  
> -KCONFIG_CONFIG	?= .config
> -export KCONFIG_CONFIG
> -
>  # SHELL used by kbuild
>  CONFIG_SHELL := $(shell if [ -x "$$BASH" ]; then echo $$BASH; \
>  	  else if [ -x /bin/bash ]; then echo /bin/bash; \
> diff --git a/init/Kconfig b/init/Kconfig
> index 9d76b99..3d58cb7 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -2,6 +2,10 @@ config ARCH
>  	string
>  	option env="ARCH"
>  
> +config DEFAULT_ARCH
> +	string
> +	default ARCH
> +
>  config KERNELVERSION
>  	string
>  	option env="KERNELVERSION"


Paul Bolle

