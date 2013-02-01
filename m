Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab3BADsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 22:48:32 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:33550 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab3BADsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 22:48:30 -0500
Date: Thu, 31 Jan 2013 22:48:27 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Cyril Chemparathy <cyril@ti.com>
cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, sboyd@codeaurora.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        catalin.marinas@arm.com, marc.zyngier@arm.com,
        linus.walleij@linaro.org, Vitaly Andrianov <vitalya@ti.com>
Subject: Re: [PATCH v4 09/13] ARM: LPAE: accomodate >32-bit addresses for
 page table base
In-Reply-To: <1359669512-31276-10-git-send-email-cyril@ti.com>
Message-ID: <alpine.LFD.2.02.1301312247460.6300@xanadu.home>
References: <1359669512-31276-1-git-send-email-cyril@ti.com> <1359669512-31276-10-git-send-email-cyril@ti.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2013, Cyril Chemparathy wrote:

> This patch redefines the early boot time use of the R4 register to steal a few
> low order bits (ARCH_PGD_SHIFT bits) on LPAE systems.  This allows for up to
> 38-bit physical addresses.
> 
> Signed-off-by: Cyril Chemparathy <cyril@ti.com>
> Signed-off-by: Vitaly Andrianov <vitalya@ti.com>

Acked-by: Nicolas Pitre <nico@linaro.org>

> ---
>  arch/arm/include/asm/memory.h |   16 ++++++++++++++++
>  arch/arm/kernel/head.S        |   10 ++++------
>  arch/arm/kernel/smp.c         |   11 +++++++++--
>  arch/arm/mm/proc-v7-3level.S  |    8 ++++++++
>  4 files changed, 37 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
> index 8825abb..f3a7f76 100644
> --- a/arch/arm/include/asm/memory.h
> +++ b/arch/arm/include/asm/memory.h
> @@ -18,6 +18,8 @@
>  #include <linux/types.h>
>  #include <linux/sizes.h>
>  
> +#include <asm/cache.h>
> +
>  #ifdef CONFIG_NEED_MACH_MEMORY_H
>  #include <mach/memory.h>
>  #endif
> @@ -141,6 +143,20 @@
>  #define page_to_phys(page)	(__pfn_to_phys(page_to_pfn(page)))
>  #define phys_to_page(phys)	(pfn_to_page(__phys_to_pfn(phys)))
>  
> +/*
> + * Minimum guaranted alignment in pgd_alloc().  The page table pointers passed
> + * around in head.S and proc-*.S are shifted by this amount, in order to
> + * leave spare high bits for systems with physical address extension.  This
> + * does not fully accomodate the 40-bit addressing capability of ARM LPAE, but
> + * gives us about 38-bits or so.
> + */
> +#ifdef CONFIG_ARM_LPAE
> +#define ARCH_PGD_SHIFT		L1_CACHE_SHIFT
> +#else
> +#define ARCH_PGD_SHIFT		0
> +#endif
> +#define ARCH_PGD_MASK		((1 << ARCH_PGD_SHIFT) - 1)
> +
>  #ifndef __ASSEMBLY__
>  
>  /*
> diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
> index 4eee351..916af3e 100644
> --- a/arch/arm/kernel/head.S
> +++ b/arch/arm/kernel/head.S
> @@ -156,7 +156,7 @@ ENDPROC(stext)
>   *
>   * Returns:
>   *  r0, r3, r5-r7 corrupted
> - *  r4 = physical page table address
> + *  r4 = page table (see ARCH_PGD_SHIFT in asm/memory.h)
>   */
>  __create_page_tables:
>  	pgtbl	r4, r8				@ page table address
> @@ -310,6 +310,7 @@ __create_page_tables:
>  #endif
>  #ifdef CONFIG_ARM_LPAE
>  	sub	r4, r4, #0x1000		@ point to the PGD table
> +	mov	r4, r4, lsr #ARCH_PGD_SHIFT
>  #endif
>  	mov	pc, lr
>  ENDPROC(__create_page_tables)
> @@ -387,7 +388,7 @@ __secondary_data:
>   *  r0  = cp#15 control register
>   *  r1  = machine ID
>   *  r2  = atags or dtb pointer
> - *  r4  = page table pointer
> + *  r4  = page table (see ARCH_PGD_SHIFT in asm/memory.h)
>   *  r9  = processor ID
>   *  r13 = *virtual* address to jump to upon completion
>   */
> @@ -406,10 +407,7 @@ __enable_mmu:
>  #ifdef CONFIG_CPU_ICACHE_DISABLE
>  	bic	r0, r0, #CR_I
>  #endif
> -#ifdef CONFIG_ARM_LPAE
> -	mov	r5, #0
> -	mcrr	p15, 0, r4, r5, c2		@ load TTBR0
> -#else
> +#ifndef CONFIG_ARM_LPAE
>  	mov	r5, #(domain_val(DOMAIN_USER, DOMAIN_MANAGER) | \
>  		      domain_val(DOMAIN_KERNEL, DOMAIN_MANAGER) | \
>  		      domain_val(DOMAIN_TABLE, DOMAIN_MANAGER) | \
> diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> index 84f4cbf..042e12d 100644
> --- a/arch/arm/kernel/smp.c
> +++ b/arch/arm/kernel/smp.c
> @@ -78,6 +78,13 @@ void __init smp_set_ops(struct smp_operations *ops)
>  		smp_ops = *ops;
>  };
>  
> +static unsigned long get_arch_pgd(pgd_t *pgd)
> +{
> +	phys_addr_t pgdir = virt_to_phys(pgd);
> +	BUG_ON(pgdir & ARCH_PGD_MASK);
> +	return pgdir >> ARCH_PGD_SHIFT;
> +}
> +
>  int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *idle)
>  {
>  	int ret;
> @@ -87,8 +94,8 @@ int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *idle)
>  	 * its stack and the page tables.
>  	 */
>  	secondary_data.stack = task_stack_page(idle) + THREAD_START_SP;
> -	secondary_data.pgdir = virt_to_phys(idmap_pgd);
> -	secondary_data.swapper_pg_dir = virt_to_phys(swapper_pg_dir);
> +	secondary_data.pgdir = get_arch_pgd(idmap_pgd);
> +	secondary_data.swapper_pg_dir = get_arch_pgd(swapper_pg_dir);
>  	__cpuc_flush_dcache_area(&secondary_data, sizeof(secondary_data));
>  	outer_clean_range(__pa(&secondary_data), __pa(&secondary_data + 1));
>  
> diff --git a/arch/arm/mm/proc-v7-3level.S b/arch/arm/mm/proc-v7-3level.S
> index e6576f5..c02c1cc 100644
> --- a/arch/arm/mm/proc-v7-3level.S
> +++ b/arch/arm/mm/proc-v7-3level.S
> @@ -113,6 +113,7 @@ ENDPROC(cpu_v7_set_pte_ext)
>  	 */
>  	.macro	v7_ttb_setup, zero, ttbr0, ttbr1, tmp
>  	ldr	\tmp, =swapper_pg_dir		@ swapper_pg_dir virtual address
> +	mov	\tmp, \tmp, lsr #ARCH_PGD_SHIFT
>  	cmp	\ttbr1, \tmp			@ PHYS_OFFSET > PAGE_OFFSET?
>  	mrc	p15, 0, \tmp, c2, c0, 2		@ TTB control register
>  	orr	\tmp, \tmp, #TTB_EAE
> @@ -127,8 +128,15 @@ ENDPROC(cpu_v7_set_pte_ext)
>  	 */
>  	orrls	\tmp, \tmp, #TTBR1_SIZE				@ TTBCR.T1SZ
>  	mcr	p15, 0, \tmp, c2, c0, 2				@ TTBCR
> +	mov	\tmp, \ttbr1, lsr #(32 - ARCH_PGD_SHIFT)	@ upper bits
> +	mov	\ttbr1, \ttbr1, lsl #ARCH_PGD_SHIFT		@ lower bits
>  	addls	\ttbr1, \ttbr1, #TTBR1_OFFSET
>  	mcrr	p15, 1, \ttbr1, \zero, c2			@ load TTBR1
> +	mov	\tmp, \ttbr0, lsr #(32 - ARCH_PGD_SHIFT)	@ upper bits
> +	mov	\ttbr0, \ttbr0, lsl #ARCH_PGD_SHIFT		@ lower bits
> +	mcrr	p15, 0, \ttbr0, \zero, c2			@ load TTBR0
> +	mcrr	p15, 1, \ttbr1, \zero, c2			@ load TTBR1
> +	mcrr	p15, 0, \ttbr0, \zero, c2			@ load TTBR0
>  	.endm
>  
>  	__CPUINIT
> -- 
> 1.7.9.5
> 
