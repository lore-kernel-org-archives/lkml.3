Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbaIXPxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:53:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60667 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbaIXPxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:53:21 -0400
Message-ID: <5422E8D0.5080705@zytor.com>
Date: Wed, 24 Sep 2014 08:52:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: mingo@kernel.org, linux-kernel@vger.kernel.org,
        pure.logic@nexus-software.ie, tglx@linutronix.de,
        stable@vger.kernel.org, bp@alien8.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/platform] x86/intel/quark: Switch off CR4.PGE so TLB
 flush uses CR3 instead
References: <1411514784-14885-1-git-send-email-pure.logic@nexus-software.ie> <tip-ee1b5b165c0a2f04d2107e634e51f05d0eb107de@git.kernel.org>
In-Reply-To: <tip-ee1b5b165c0a2f04d2107e634e51f05d0eb107de@git.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2014 08:01 AM, tip-bot for Bryan O'Donoghue wrote:
> Commit-ID:  ee1b5b165c0a2f04d2107e634e51f05d0eb107de
> Gitweb:     http://git.kernel.org/tip/ee1b5b165c0a2f04d2107e634e51f05d0eb107de
> Author:     Bryan O'Donoghue <pure.logic@nexus-software.ie>
> AuthorDate: Wed, 24 Sep 2014 00:26:24 +0100
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Wed, 24 Sep 2014 15:06:15 +0200
>
> x86/intel/quark: Switch off CR4.PGE so TLB flush uses CR3 instead
>
> Quark x1000 advertises PGE via the standard CPUID method
> PGE bits exist in Quark X1000's PTEs. In order to flush
> an individual PTE it is necessary to reload CR3 irrespective
> of the PTE.PGE bit.
>
> See Quark Core_DevMan_001.pdf section 6.4.11
>
> This bug was fixed in Galileo kernels, unfixed vanilla kernels are expected to
> crash and burn on this platform.
>
> Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: <stable@vger.kernel.org>
> Link: http://lkml.kernel.org/r/1411514784-14885-1-git-send-email-pure.logic@nexus-software.ie
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>   arch/x86/kernel/cpu/intel.c | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)
>
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index 74e804d..50ce751 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -144,6 +144,21 @@ static void early_init_intel(struct cpuinfo_x86 *c)
>   			setup_clear_cpu_cap(X86_FEATURE_ERMS);
>   		}
>   	}
> +
> +	/*
> +	 * Intel Quark Core DevMan_001.pdf section 6.4.11
> +	 * "The operating system also is required to invalidate (i.e., flush)
> +	 *  the TLB when any changes are made to any of the page table entries.
> +	 *  The operating system must reload CR3 to cause the TLB to be flushed"
> +	 *
> +	 * As a result cpu_has_pge() in arch/x86/include/asm/tlbflush.h should
> +	 * be false so that __flush_tlb_all() causes CR3 insted of CR4.PGE
> +	 * to be modified
> +	 */
> +	if (c->x86 == 5 && c->x86_model == 9) {
> +		pr_info("Disabling PGE capability bit\n");
> +		setup_clear_cpu_cap(X86_FEATURE_PGE);
> +	}
>   }
>
>   #ifdef CONFIG_X86_32
>

I believe there is one more change needed: there is a __flush_tlb_all() 
in the early code which gets executed before the above code runs; the 
easiest fix is to just add a __flush_tlb() immediately after it.

This should have been pushed upstream, and not stayed in the BSP kernel.

	-hpa

