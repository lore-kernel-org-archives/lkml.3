Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbaANTPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:15:00 -0500
Received: from mout.gmx.net ([212.227.15.18]:56206 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbaANTO5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:14:57 -0500
From: Jan-Simon =?ISO-8859-1?Q?M=F6ller?= <dl9pf@gmx.de>
To: llvmlinux@lists.linuxfoundation.org
Cc: David Woodhouse <David.Woodhouse@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [llvmlinux] [PATCH 3/4] x86: Allow building 16-bit code with -m16 with toolchains that support it
Date: Tue, 14 Jan 2014 20:14:53 +0100
Message-ID: <3418146.9929lmqnex@aragorn.auenland.lan>
User-Agent: KMail/4.12 (Linux/3.11.6-4-desktop; KDE/4.12.0; x86_64; ; )
In-Reply-To: <1389180083-23249-3-git-send-email-David.Woodhouse@intel.com>
References: <1389180083-23249-1-git-send-email-David.Woodhouse@intel.com> <1389180083-23249-3-git-send-email-David.Woodhouse@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V03:K0:94fFS4xrbb7hbH7az2zXDSIagGNkmrtFc1JeKRiSY6yqiQvkDS4
 BaA5ff0d7rr7DsySIxTvN/PZHVqU26CXy+XaBHVt0mnacmrGgXCmoa8yDTuOx2MrkPfa95P
 DqfB3WnOohV9tEQ5anBgwaHC3GGz2Td0W/zOVagAe6Mskcw6BXuzgMaD6tsmEpHycDOuo3Z
 BcJ62i3uFJ7gR4J2aJfwA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

what version of clang did you use btw ?

-- 

Dipl.-Ing.
Jan-Simon Möller

jansimon.moeller@gmx.de
Am Mittwoch, 8. Januar 2014, 11:21:22 schrieb David Woodhouse:
> I have this working with LLVM/Clang, and a PR is filed for GCC because
> the current hacks we have to do to *try* to ensure that .code16gcc is
> the first thing in the asm output are horrid.
> 
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> ---
>  arch/x86/Makefile | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> index ef19271..60fc67d 100644
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -13,14 +13,21 @@ endif
> 
>  # How to compile the 16-bit code.  Note we always compile for -march=i386;
>  # that way we can complain to the user if the CPU is insufficient.
> -REALMODE_CFLAGS	:= -m32 -g -Os -D__KERNEL__ -DDISABLE_BRANCH_PROFILING \
> +#
> +# We really want GCC to have a -m16 option like clang, so that we don't
> +# have to play these evil and unreliable tricks to ensure that our
> +# asm(".code16gcc") is first in the asm output. http://gcc.gnu.org/PR59672
> +CODE16GCC_CFLAGS := -m32 -include $(srctree)/arch/x86/boot/code16gcc.h \
> +		    $(call cc-option, -fno-toplevel-reorder,\
> +		      $(call cc-option, -fno-unit-at-a-time))
> +M16_CFLAGS	 := -m16
> +
> +REALMODE_CFLAGS	:= -g -Os -D__KERNEL__ -DDISABLE_BRANCH_PROFILING \
> +		   $(call cc-option, $(M16_CFLAGS), $(CODE16GCC_CFLAGS)) \
>  		   -Wall -Wstrict-prototypes -march=i386 -mregparm=3 \
> -		   -include $(srctree)/arch/x86/boot/code16gcc.h \
>  		   -fno-strict-aliasing -fomit-frame-pointer -fno-pic \
>  		   -mno-mmx -mno-sse \
>  		   $(call cc-option, -ffreestanding) \
> -		   $(call cc-option, -fno-toplevel-reorder,\
> -		   $(call cc-option, -fno-unit-at-a-time)) \
>  		   $(call cc-option, -fno-stack-protector) \
>  		   $(call cc-option, -mpreferred-stack-boundary=2)
>  export REALMODE_CFLAGS

