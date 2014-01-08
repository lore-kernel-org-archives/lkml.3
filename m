Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbaAHNDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 08:03:24 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:53338 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738AbaAHNDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:03:21 -0500
Message-ID: <52CD4C93.70008@linuxfoundation.org>
Date: Wed, 08 Jan 2014 14:03:15 +0100
From: =?ISO-8859-1?Q?Jan-Simon_M=F6ller?= <jsmoeller@linuxfoundation.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Compiling the Linux Kernel with Clang/LLVM 
	<llvmlinux@lists.linuxfoundation.org>,
        x86@kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [llvmlinux] [PATCH 1/4] x86: Remove duplication of 16-bit CFLAGS
References: <1389180083-23249-1-git-send-email-David.Woodhouse@intel.com>
In-Reply-To: <1389180083-23249-1-git-send-email-David.Woodhouse@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

I'll import your patches to our queue and resolve them with the existing
ones.

Thanks.

Best,
Jan-Simon

Am 08.01.2014 12:21, schrieb David Woodhouse:
> Define them once in arch/x86/Makefile instead of twice
>
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> ---
>  arch/x86/Makefile             | 14 ++++++++++++++
>  arch/x86/boot/Makefile        | 15 +--------------
>  arch/x86/realmode/rm/Makefile | 17 ++---------------
>  3 files changed, 17 insertions(+), 29 deletions(-)
>
> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> index 3c54657..ef19271 100644
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -11,6 +11,20 @@ else
>          KBUILD_DEFCONFIG := $(ARCH)_defconfig
>  endif
>  
> +# How to compile the 16-bit code.  Note we always compile for -march=i386;
> +# that way we can complain to the user if the CPU is insufficient.
> +REALMODE_CFLAGS	:= -m32 -g -Os -D__KERNEL__ -DDISABLE_BRANCH_PROFILING \
> +		   -Wall -Wstrict-prototypes -march=i386 -mregparm=3 \
> +		   -include $(srctree)/arch/x86/boot/code16gcc.h \
> +		   -fno-strict-aliasing -fomit-frame-pointer -fno-pic \
> +		   -mno-mmx -mno-sse \
> +		   $(call cc-option, -ffreestanding) \
> +		   $(call cc-option, -fno-toplevel-reorder,\
> +		   $(call cc-option, -fno-unit-at-a-time)) \
> +		   $(call cc-option, -fno-stack-protector) \
> +		   $(call cc-option, -mpreferred-stack-boundary=2)
> +export REALMODE_CFLAGS
> +
>  # BITS is used as extension for files which are available in a 32 bit
>  # and a 64 bit version to simplify shared Makefiles.
>  # e.g.: obj-y += foo_$(BITS).o
> diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
> index d9c1195..7c2b0a1 100644
> --- a/arch/x86/boot/Makefile
> +++ b/arch/x86/boot/Makefile
> @@ -51,20 +51,7 @@ $(obj)/cpustr.h: $(obj)/mkcpustr FORCE
>  
>  # ---------------------------------------------------------------------------
>  
> -# How to compile the 16-bit code.  Note we always compile for -march=i386,
> -# that way we can complain to the user if the CPU is insufficient.
> -KBUILD_CFLAGS	:= $(USERINCLUDE) -m32 -g -Os -D_SETUP -D__KERNEL__ \
> -		   -DDISABLE_BRANCH_PROFILING \
> -		   -Wall -Wstrict-prototypes \
> -		   -march=i386 -mregparm=3 \
> -		   -include $(srctree)/$(src)/code16gcc.h \
> -		   -fno-strict-aliasing -fomit-frame-pointer -fno-pic \
> -		   -mno-mmx -mno-sse \
> -		   $(call cc-option, -ffreestanding) \
> -		   $(call cc-option, -fno-toplevel-reorder,\
> -		   $(call cc-option, -fno-unit-at-a-time)) \
> -		   $(call cc-option, -fno-stack-protector) \
> -		   $(call cc-option, -mpreferred-stack-boundary=2)
> +KBUILD_CFLAGS	:= $(USERINCLUDE) $(REALMODE_CFLAGS) -D_SETUP
>  KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
>  GCOV_PROFILE := n
>  
> diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
> index 9cac825..3497f14 100644
> --- a/arch/x86/realmode/rm/Makefile
> +++ b/arch/x86/realmode/rm/Makefile
> @@ -64,20 +64,7 @@ $(obj)/realmode.relocs: $(obj)/realmode.elf FORCE
>  
>  # ---------------------------------------------------------------------------
>  
> -# How to compile the 16-bit code.  Note we always compile for -march=i386,
> -# that way we can complain to the user if the CPU is insufficient.
> -KBUILD_CFLAGS	:= $(LINUXINCLUDE) -m32 -g -Os -D_SETUP -D__KERNEL__ -D_WAKEUP \
> -		   -I$(srctree)/arch/x86/boot \
> -		   -DDISABLE_BRANCH_PROFILING \
> -		   -Wall -Wstrict-prototypes \
> -		   -march=i386 -mregparm=3 \
> -		   -include $(srctree)/$(src)/../../boot/code16gcc.h \
> -		   -fno-strict-aliasing -fomit-frame-pointer -fno-pic \
> -		   -mno-mmx -mno-sse \
> -		   $(call cc-option, -ffreestanding) \
> -		   $(call cc-option, -fno-toplevel-reorder,\
> -		   $(call cc-option, -fno-unit-at-a-time)) \
> -		   $(call cc-option, -fno-stack-protector) \
> -		   $(call cc-option, -mpreferred-stack-boundary=2)
> +KBUILD_CFLAGS	:= $(LINUXINCLUDE) $(REALMODE_CFLAGS) -D_SETUP -D_WAKEUP \
> +		   -I$(srctree)/arch/x86/boot
>  KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
>  GCOV_PROFILE := n

