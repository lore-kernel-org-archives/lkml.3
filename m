Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab3LEQ2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 11:28:12 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:14471 "EHLO
	highbank-bc01-b06.austin.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751145Ab3LEQ2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 11:28:07 -0500
Date: Thu, 5 Dec 2013 16:28:01 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Salter <msalter@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, Rob Landley <rob@landley.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 4/4] arm64: add early_ioremap support
Message-ID: <20131205162800.GB1495@darko.cambridge.arm.com>
References: <1385606679-30446-1-git-send-email-msalter@redhat.com>
 <1385606679-30446-5-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385606679-30446-5-git-send-email-msalter@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 02:44:39AM +0000, Mark Salter wrote:
> --- /dev/null
> +++ b/arch/arm64/include/asm/fixmap.h
> @@ -0,0 +1,68 @@
> +/*
> + * fixmap.h: compile-time virtual memory allocation
> + *
> + * This file is subject to the terms and conditions of the GNU General Public
> + * License.  See the file "COPYING" in the main directory of this archive
> + * for more details.
> + *
> + * Copyright (C) 1998 Ingo Molnar
> + * Copyright (C) 2013 Mark Salter <msalter@redhat.com>
> + *
> + * Adapted from arch/x86_64 version.
> + *
> + */
> +
> +#ifndef _ASM_ARM64_FIXMAP_H
> +#define _ASM_ARM64_FIXMAP_H
> +
> +#ifndef __ASSEMBLY__
> +#include <linux/kernel.h>
> +#include <asm/page.h>
> +
> +/*
> + * Here we define all the compile-time 'special' virtual
> + * addresses. The point is to have a constant address at
> + * compile time, but to set the physical address only
> + * in the boot process.
> + *
> + * These 'compile-time allocated' memory buffers are
> + * page-sized. Use set_fixmap(idx,phys) to associate
> + * physical memory with fixmap indices.
> + *
> + */
> +enum fixed_addresses {
> +	FIX_EARLYCON,
> +	__end_of_permanent_fixed_addresses,
> +
> +	/*
> +	 * Temporary boot-time mappings, used by early_ioremap(),
> +	 * before ioremap() is functional.
> +	 */

How temporary are this mappings? The early console may not be disabled
at run-time, so it still needs the mapping.

> +#ifdef CONFIG_ARM64_64K_PAGES
> +#define NR_FIX_BTMAPS		4
> +#else
> +#define NR_FIX_BTMAPS		64
> +#endif
> +#define FIX_BTMAPS_SLOTS	7
> +#define TOTAL_FIX_BTMAPS	(NR_FIX_BTMAPS * FIX_BTMAPS_SLOTS)
> +
> +	FIX_BTMAP_END = __end_of_permanent_fixed_addresses,
> +	FIX_BTMAP_BEGIN = FIX_BTMAP_END + TOTAL_FIX_BTMAPS - 1,
> +	__end_of_fixed_addresses
> +};
> +
> +#define FIXADDR_SIZE	(__end_of_permanent_fixed_addresses << PAGE_SHIFT)
> +#define FIXADDR_START	(FIXADDR_TOP - FIXADDR_SIZE)
> +
> +#define FIXMAP_PAGE_NORMAL __pgprot(PROT_NORMAL | PTE_PXN | PTE_UXN)

I'll push a fix to change PROT_DEFAULT to (pgprot_default | PTE_DIRTY).

> diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
> index 3776217..4a6d7ec 100644
> --- a/arch/arm64/include/asm/memory.h
> +++ b/arch/arm64/include/asm/memory.h
> @@ -50,6 +50,7 @@
>  #define MODULES_END		(PAGE_OFFSET)
>  #define MODULES_VADDR		(MODULES_END - SZ_64M)
>  #define EARLYCON_IOBASE		(MODULES_VADDR - SZ_4M)
> +#define FIXADDR_TOP		(MODULES_VADDR - SZ_2M - PAGE_SIZE)
>  #define TASK_SIZE_64		(UL(1) << VA_BITS)

Can we remove EARLYCON_IOBASE?

> --- a/arch/arm64/mm/ioremap.c
> +++ b/arch/arm64/mm/ioremap.c
> @@ -25,6 +25,10 @@
>  #include <linux/vmalloc.h>
>  #include <linux/io.h>
>  
> +#include <asm/fixmap.h>
> +#include <asm/tlbflush.h>
> +#include <asm/pgalloc.h>
> +
>  static void __iomem *__ioremap_caller(phys_addr_t phys_addr, size_t size,
>  				      pgprot_t prot, void *caller)
>  {
> @@ -98,3 +102,76 @@ void __iomem *ioremap_cache(phys_addr_t phys_addr, size_t size)
>  				__builtin_return_address(0));
>  }
>  EXPORT_SYMBOL(ioremap_cache);
> +
> +#ifndef CONFIG_ARM64_64K_PAGES
> +static pte_t bm_pte[PTRS_PER_PTE] __page_aligned_bss;
> +#endif
> +
> +static inline pmd_t * __init early_ioremap_pmd(unsigned long addr)
> +{
> +	pgd_t *pgd = pgd_offset_k(addr);
> +	pud_t *pud = pud_offset(pgd, addr);
> +	pmd_t *pmd = pmd_offset(pud, addr);
> +
> +	return pmd;
> +}
> +
> +static inline pte_t * __init early_ioremap_pte(unsigned long addr)
> +{
> +	pmd_t *pmd = early_ioremap_pmd(addr);
> +	return pte_offset_kernel(pmd, addr);
> +}
> +
> +void __init early_ioremap_init(void)
> +{
> +	pmd_t *pmd;
> +
> +	pmd = early_ioremap_pmd(fix_to_virt(FIX_BTMAP_BEGIN));
> +#ifndef CONFIG_ARM64_64K_PAGES
> +	/* need to populate pmd for 4k pagesize only */
> +	pmd_populate_kernel(&init_mm, pmd, bm_pte);
> +#endif

Can we use some of the standard pmd_none() etc. checks which would be
eliminated for 2-level page tables?

-- 
Catalin
