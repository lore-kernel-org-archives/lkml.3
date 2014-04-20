Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbaDTA2Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 20:28:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38272 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594AbaDTA2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 20:28:18 -0400
Date: Sun, 20 Apr 2014 02:28:11 +0200
From: Borislav Petkov <bp@suse.de>
To: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        ricardo.neri-calderon@linux.intel.com, tglx@linutronix.de, bp@suse.de,
        matt.fleming@intel.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/efi] x86/efi: Save and restore FPU context around
 efi_calls (x86_64)
Message-ID: <20140420002811.GA18663@pd.tnic>
References: <tip-de05764e0b2a3d9559e099a2e134f8cef4500fdd@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <tip-de05764e0b2a3d9559e099a2e134f8cef4500fdd@git.kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2014 at 03:50:44PM -0700, tip-bot for Ricardo Neri wrote:
> Commit-ID:  de05764e0b2a3d9559e099a2e134f8cef4500fdd
> Gitweb:     http://git.kernel.org/tip/de05764e0b2a3d9559e099a2e134f8cef4500fdd
> Author:     Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
> AuthorDate: Thu, 27 Mar 2014 15:10:42 -0700
> Committer:  Matt Fleming <matt.fleming@intel.com>
> CommitDate: Thu, 17 Apr 2014 13:26:32 +0100
> 
> x86/efi: Save and restore FPU context around efi_calls (x86_64)
> 
> Do a complete FPU context save/restore around the EFI calls. This required
> as runtime EFI firmware may potentially use the FPU.
> 
> This change covers only the x86_64 configuration.
> 
> Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
> Cc: Borislav Petkov <bp@suse.de>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---
>  arch/x86/include/asm/efi.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
> index 19292e7..0b19187 100644
> --- a/arch/x86/include/asm/efi.h
> +++ b/arch/x86/include/asm/efi.h
> @@ -1,6 +1,7 @@
>  #ifndef _ASM_X86_EFI_H
>  #define _ASM_X86_EFI_H
>  
> +#include <asm/i387.h>
>  /*
>   * We map the EFI regions needed for runtime services non-contiguously,
>   * with preserved alignment on virtual addresses starting from -4G down
> @@ -54,7 +55,9 @@ extern u64 asmlinkage efi_call(void *fp, ...);
>  									\
>  	efi_sync_low_kernel_mappings();					\
>  	preempt_disable();						\
> +	__kernel_fpu_begin();						\
>  	__s = efi_call((void *)efi.systab->runtime->f, __VA_ARGS__);	\
> +	__kernel_fpu_end();						\
>  	preempt_enable();						\

I guess you can use the kernel_fpu_begin/end() variants here (i.e.,
without the "__") which disable and enable preemption and thus drop the
preempt_* calls:

	efi_sync_low_kernel_mappings();
	kernel_fpu_begin();
	 __s = efi_call((void *)efi.systab->runtime->f, __VA_ARGS__);
	 kernel_fpu_end();
	 __s;

I'm not sure about the

	WARN_ON_ONCE(!irq_fpu_usable());

thing in kernel_fpu_begin() though, I guess it wouldn't hurt...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
