Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab3EaIl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 04:41:26 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33399 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184Ab3EaIlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 04:41:22 -0400
Date: Fri, 31 May 2013 10:41:33 +0200
From: Borislav Petkov <bp@alien8.de>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, jacob.shin@amd.com, tglx@linutronix.de,
        hpa@linux.intel.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/microcode] x86, microcode, amd: Early microcode patch
 loading support for AMD
Message-ID: <20130531084133.GA14076@nazgul.tnic>
References: <1369940959-2077-5-git-send-email-jacob.shin@amd.com>
 <tip-757885e94a22bcc82beb9b1445c95218cb20ceab@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <tip-757885e94a22bcc82beb9b1445c95218cb20ceab@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 08:31:08PM -0700, tip-bot for Jacob Shin wrote:
> Commit-ID:  757885e94a22bcc82beb9b1445c95218cb20ceab
> Gitweb:     http://git.kernel.org/tip/757885e94a22bcc82beb9b1445c95218cb20ceab
> Author:     Jacob Shin <jacob.shin@amd.com>
> AuthorDate: Thu, 30 May 2013 14:09:19 -0500
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Thu, 30 May 2013 20:19:25 -0700
> 
> x86, microcode, amd: Early microcode patch loading support for AMD
> 
> Add early microcode patch loading support for AMD.
> 
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> Link: http://lkml.kernel.org/r/1369940959-2077-5-git-send-email-jacob.shin@amd.com
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> ---

...

> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index 7bd3bd3..6c3fcea 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -93,6 +93,7 @@ obj-$(CONFIG_MICROCODE_INTEL_LIB)	+= microcode_intel_lib.o
>  microcode-y				:= microcode_core.o
>  microcode-$(CONFIG_MICROCODE_INTEL)	+= microcode_intel.o
>  microcode-$(CONFIG_MICROCODE_AMD)	+= microcode_amd.o
> +obj-$(CONFIG_MICROCODE_AMD_EARLY)	+= microcode_amd_early.o
>  obj-$(CONFIG_MICROCODE)			+= microcode.o

This can't be right:

WARNING: modpost: Found 1 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
arch/x86/built-in.o: In function `apply_ucode_in_initrd':
/home/boris/kernel/linux-2.6/arch/x86/kernel/microcode_amd_early.c:118: undefined reference to `__apply_microcode_amd'
arch/x86/built-in.o: In function `save_microcode_in_initrd_amd':
/home/boris/kernel/linux-2.6/arch/x86/kernel/microcode_amd_early.c:216: undefined reference to `load_microcode_amd'
arch/x86/built-in.o: In function `collect_cpu_info_amd_early':
/home/boris/kernel/linux-2.6/arch/x86/kernel/microcode_amd_early.c:171: undefined reference to `ucode_cpu_info'
/home/boris/kernel/linux-2.6/arch/x86/kernel/microcode_amd_early.c:172: undefined reference to `ucode_cpu_info'
arch/x86/built-in.o: In function `load_ucode_amd_ap':
/home/boris/kernel/linux-2.6/arch/x86/kernel/microcode_amd_early.c:185: undefined reference to `load_microcode_amd'
/home/boris/kernel/linux-2.6/arch/x86/kernel/microcode_amd_early.c:190: undefined reference to `apply_microcode_amd'
make: *** [vmlinux] Error 1

$ grep MICROCODE .config
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_LIB=y
CONFIG_MICROCODE_INTEL_EARLY=y
CONFIG_MICROCODE_AMD_EARLY=y
CONFIG_MICROCODE_EARLY=y

Jacob, as a tip for you: before sending out patches, always do a

for ARCH in "i386" "x86_64"
do
        for cfg in "defconfig" "allnoconfig" "allyesconfig" "allmodconfig"
        do
                make -j<something> $ARCH $cfg
        done
done

to smoke-test your patches. I'm not saying this should catch all build
errors but still...

Thanks.
