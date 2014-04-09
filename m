Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261AbaDIJLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 05:11:31 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62141 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaDIJL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 05:11:28 -0400
Date: Wed, 9 Apr 2014 10:11:23 +0100
From: Steve Capper <steve.capper@linaro.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Rabin Vincent <rabin@rab.in>, Alexander Holler <holler@ahsoftware.de>
Subject: Re: [PATCH v2 1/2] ARM: mm: allow non-text sections to be
 non-executable
Message-ID: <20140409091122.GB6583@linaro.org>
References: <1396926910-11227-1-git-send-email-keescook@chromium.org>
 <1396926910-11227-2-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396926910-11227-2-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 08:15:09PM -0700, Kees Cook wrote:
> Adds CONFIG_ARM_KERNMEM_PERMS to separate the kernel memory regions
> into section-sized areas that can have different permisions. Performs
> the NX permission changes during free_initmem, so that init memory can be
> reclaimed.
> 
> This uses section size instead of PMD size to reduce memory lost to
> padding on non-LPAE systems.
> 
> Based on work by Brad Spengler, Larry Bassel, and Laura Abbott.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---

[ ... ]

> diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
> index 2a77ba8796ae..66a7283583cd 100644
> --- a/arch/arm/mm/init.c
> +++ b/arch/arm/mm/init.c
> @@ -31,6 +31,11 @@
>  #include <asm/tlb.h>
>  #include <asm/fixmap.h>
>  
> +#ifdef CONFIG_ARM_KERNMEM_PERMS
> +#include <asm/system_info.h>
> +#include <asm/cp15.h>
> +#endif
> +
>  #include <asm/mach/arch.h>
>  #include <asm/mach/map.h>
>  
> @@ -623,11 +628,112 @@ void __init mem_init(void)
>  	}
>  }
>  
> +#ifdef CONFIG_ARM_KERNMEM_PERMS
> +struct section_perm {
> +	unsigned long start;
> +	unsigned long end;
> +	pmdval_t mask;
> +	pmdval_t prot;
> +};
> +
> +struct section_perm nx_perms[] = {
> +	/* Make pages tables, etc before _stext RW (set NX). */
> +	{
> +		.start	= PAGE_OFFSET,
> +		.end	= (unsigned long)_stext,
> +		.mask	= ~PMD_SECT_XN,
> +		.prot	= PMD_SECT_XN,
> +	},
> +	/* Make init RW (set NX). */
> +	{
> +		.start	= (unsigned long)__init_begin,
> +		.end	= (unsigned long)_sdata,
> +		.mask	= ~PMD_SECT_XN,
> +		.prot	= PMD_SECT_XN,
> +	},
> +};
> +
> +/*
> + * Updates section permissions only for the current mm (sections are
> + * copied into each mm). During startup, this is the init_mm.
> + */
> +static inline void section_update(unsigned long addr, pmdval_t mask,
> +				  pmdval_t prot)
> +{
> +	struct mm_struct *mm;
> +	pmd_t *pmd;
> +
> +	mm = current->active_mm;
> +	pmd = pmd_offset(pud_offset(pgd_offset(mm, addr), addr), addr);
> +
> +#ifdef CONFIG_ARM_LPAE
> +	pmd[0] = __pmd((pmd_val(pmd[0]) & mask) | prot);
> +#else
> +	if (addr & SECTION_SIZE)
> +		pmd[1] = __pmd((pmd_val(pmd[1]) & mask) | prot);
> +	else
> +		pmd[0] = __pmd((pmd_val(pmd[0]) & mask) | prot);
> +#endif
> +	flush_pmd_entry(pmd);
> +	local_flush_tlb_kernel_range(addr, addr + SECTION_SIZE);
> +}
> +
> +/* Make sure extended page tables are in use. */
> +static inline bool arch_has_strict_perms(void)
> +{
> +	unsigned int cr;
> +
> +	if (cpu_architecture() < CPU_ARCH_ARMv6)
> +		return false;
> +
> +	cr = get_cr();
> +	if (!(cr & CR_XP))
> +		return false;
> +
> +	return true;
> +}
> +
> +#define set_section_perms(perms, field)	{				\
> +	size_t i;							\
> +	unsigned long addr;						\
> +									\
> +	if (!arch_has_strict_perms())					\
> +		return;							\
> +									\
> +	for (i = 0; i < ARRAY_SIZE(perms); i++) {			\
> +		if (!IS_ALIGNED(perms[i].start, SECTION_SIZE) ||	\
> +		    !IS_ALIGNED(perms[i].end, SECTION_SIZE)) {		\
> +			pr_err("BUG: section %lx-%lx not aligned to %lx\n", \
> +				perms[i].start, perms[i].end,		\
> +				SECTION_SIZE);				\
> +			continue;					\
> +		}							\
> +									\
> +		for (addr = perms[i].start;				\
> +		     addr < perms[i].end;				\
> +		     addr += SECTION_SIZE)				\
> +			section_update(addr, perms[i].mask,		\
> +				       perms[i].field);			\
> +	}								\
> +}
> +
> +static inline void fix_kernmem_perms(void)
> +{
> +	set_section_perms(nx_perms, prot);
> +}
> +#else
> +static inline void fix_kernmem_perms(void) { }
> +#endif /* CONFIG_ARM_KERNMEM_PERMS */
> +
>  void free_initmem(void)
>  {
>  #ifdef CONFIG_HAVE_TCM
>  	extern char __tcm_start, __tcm_end;
> +#endif
> +
> +	fix_kernmem_perms();

If it's practical to allow kprobes to modify the underlying .text
without changing the section mappings; then I think it would be lot
cleaner to put down read only .text sections from the beginning, and
not have any section modification code.

Cheers,
-- 
Steve

