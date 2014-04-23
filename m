Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777AbaDWQCK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 12:02:10 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:60240 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757319AbaDWQCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 12:02:01 -0400
Date: Wed, 23 Apr 2014 17:01:50 +0100
From: Steve Capper <steve.capper@linaro.org>
To: Jungseok Lee <jays.lee@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        sungjinn.chung@samsung.com, Arnd Bergmann <arnd@arndb.de>,
        kgene.kim@samsung.com, ilho215.lee@samsung.com
Subject: Re: [PATCH v3 6/7] arm64: mm: Implement 4 levels of translation
 tables
Message-ID: <20140423160149.GA2895@linaro.org>
References: <000701cf5adc$1aa35350$4fe9f9f0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000701cf5adc$1aa35350$4fe9f9f0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 04:59:20PM +0900, Jungseok Lee wrote:
> This patch implements 4 levels of translation tables since 3 levels
> of page tables with 4KB pages cannot support 40-bit physical address
> space described in [1] due to the following issue.
> 
> It is a restriction that kernel logical memory map with 4KB + 3 levels
> (0xffffffc000000000-0xffffffffffffffff) cannot cover RAM region from
> 544GB to 1024GB in [1]. Specifically, ARM64 kernel fails to create
> mapping for this region in map_mem function since __phys_to_virt for
> this region reaches to address overflow.
> 
> If SoC design follows the document, [1], over 32GB RAM would be placed
> from 544GB. Even 64GB system is supposed to use the region from 544GB
> to 576GB for only 32GB RAM. Naturally, it would reach to enable 4 levels
> of page tables to avoid hacking __virt_to_phys and __phys_to_virt.
> 
> However, it is recommended 4 levels of page table should be only enabled
> if memory map is too sparse or there is about 512GB RAM.

Hello Jungseok,
A few comments can be found inline...

> 
> References
> ----------
> [1]: Principles of ARM Memory Maps, White Paper, Issue C
> 
> Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
> Reviewed-by: Sungjinn Chung <sungjinn.chung@samsung.com>
> ---
>  arch/arm64/Kconfig                     |    7 +++++
>  arch/arm64/include/asm/memblock.h      |    6 +++++
>  arch/arm64/include/asm/page.h          |    4 ++-
>  arch/arm64/include/asm/pgalloc.h       |   20 +++++++++++++++
>  arch/arm64/include/asm/pgtable-hwdef.h |    6 +++--
>  arch/arm64/include/asm/pgtable.h       |   44 ++++++++++++++++++++++++++++++--
>  arch/arm64/include/asm/tlb.h           |    8 ++++++
>  arch/arm64/kernel/head.S               |   40 ++++++++++++++++++++---------
>  arch/arm64/kernel/traps.c              |    5 ++++
>  arch/arm64/mm/fault.c                  |    1 +
>  arch/arm64/mm/mmu.c                    |   16 +++++++++---
>  11 files changed, 136 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 431acbc..7f5270b 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -184,12 +184,19 @@ config ARM64_3_LEVELS
>  	help
>  	  This feature enables 3 levels of translation tables.
>  
> +config ARM64_4_LEVELS
> +	bool "4 level"
> +	depends on ARM64_4K_PAGES
> +	help
> +	  This feature enables 4 levels of translation tables.
> +
>  endchoice
>  
>  config ARM64_VA_BITS
>  	int "Virtual address space size"
>  	range 39 39 if ARM64_4K_PAGES && ARM64_3_LEVELS
>  	range 42 42 if ARM64_64K_PAGES && ARM64_2_LEVELS
> +	range 48 48 if ARM64_4K_PAGES && ARM64_4_LEVELS
>  	help
>  	  This feature is determined by a combination of page size and
>  	  level of translation tables.
> diff --git a/arch/arm64/include/asm/memblock.h b/arch/arm64/include/asm/memblock.h
> index 6afeed2..e4ac8bf 100644
> --- a/arch/arm64/include/asm/memblock.h
> +++ b/arch/arm64/include/asm/memblock.h
> @@ -16,6 +16,12 @@
>  #ifndef __ASM_MEMBLOCK_H
>  #define __ASM_MEMBLOCK_H
>  
> +#ifndef CONFIG_ARM64_4_LEVELS
> +#define MEMBLOCK_INITIAL_LIMIT	PGDIR_SIZE
> +#else
> +#define MEMBLOCK_INITIAL_LIMIT	PUD_SIZE
> +#endif
> +
>  extern void arm64_memblock_init(void);
>  
>  #endif
> diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
> index 268e53d..83b5289 100644
> --- a/arch/arm64/include/asm/page.h
> +++ b/arch/arm64/include/asm/page.h
> @@ -35,8 +35,10 @@
>  
>  #ifdef CONFIG_ARM64_2_LEVELS
>  #include <asm/pgtable-2level-types.h>
> -#else
> +#elif defined(CONFIG_ARM64_3_LEVELS)
>  #include <asm/pgtable-3level-types.h>
> +#else
> +#include <asm/pgtable-4level-types.h>
>  #endif
>  
>  extern void __cpu_clear_user_page(void *p, unsigned long user);
> diff --git a/arch/arm64/include/asm/pgalloc.h b/arch/arm64/include/asm/pgalloc.h
> index 4829837..8d745fa 100644
> --- a/arch/arm64/include/asm/pgalloc.h
> +++ b/arch/arm64/include/asm/pgalloc.h
> @@ -26,6 +26,26 @@
>  
>  #define check_pgt_cache()		do { } while (0)
>  
> +#ifdef CONFIG_ARM64_4_LEVELS
> +
> +static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long addr)
> +{
> +	return (pud_t *)get_zeroed_page(GFP_KERNEL | __GFP_REPEAT);
> +}
> +
> +static inline void pud_free(struct mm_struct *mm, pud_t *pud)
> +{
> +	BUG_ON((unsigned long)pud & (PAGE_SIZE-1));
> +	free_page((unsigned long)pud);
> +}
> +
> +static inline void pgd_populate(struct mm_struct *mm, pgd_t *pgd, pud_t *pud)
> +{
> +	set_pgd(pgd, __pgd(__pa(pud) | PUD_TYPE_TABLE));
> +}
> +
> +#endif  /* CONFIG_ARM64_4_LEVELS */
> +
>  #ifndef CONFIG_ARM64_2_LEVELS
>  
>  static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
> diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
> index 9cd86c6..ba30053 100644
> --- a/arch/arm64/include/asm/pgtable-hwdef.h
> +++ b/arch/arm64/include/asm/pgtable-hwdef.h
> @@ -18,8 +18,10 @@
>  
>  #ifdef CONFIG_ARM64_2_LEVELS
>  #include <asm/pgtable-2level-hwdef.h>
> -#else
> +#elif defined(CONFIG_ARM64_3_LEVELS)
>  #include <asm/pgtable-3level-hwdef.h>
> +#else
> +#include <asm/pgtable-4level-hwdef.h>
>  #endif
>  
>  /*
> @@ -27,7 +29,7 @@
>   *
>   * Level 1 descriptor (PUD).
>   */
> -
> +#define PUD_TYPE_TABLE		(_AT(pudval_t, 3) << 0)
>  #define PUD_TABLE_BIT		(_AT(pgdval_t, 1) << 1)
>  
>  /*
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index a64ce5e..efc40d1 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -35,7 +35,11 @@
>   * VMALLOC and SPARSEMEM_VMEMMAP ranges.
>   */
>  #define VMALLOC_START		(UL(0xffffffffffffffff) << VA_BITS)
> +#ifndef CONFIG_ARM64_4_LEVELS
>  #define VMALLOC_END		(PAGE_OFFSET - UL(0x400000000) - SZ_64K)
> +#else
> +#define VMALLOC_END		(PAGE_OFFSET - UL(0x40000000000) - SZ_64K)
> +#endif
>  
>  #define vmemmap			((struct page *)(VMALLOC_END + SZ_64K))
>  
> @@ -44,12 +48,16 @@
>  #ifndef __ASSEMBLY__
>  extern void __pte_error(const char *file, int line, unsigned long val);
>  extern void __pmd_error(const char *file, int line, unsigned long val);
> +extern void __pud_error(const char *file, int line, unsigned long val);
>  extern void __pgd_error(const char *file, int line, unsigned long val);
>  
>  #define pte_ERROR(pte)		__pte_error(__FILE__, __LINE__, pte_val(pte))
>  #ifndef CONFIG_ARM64_2_LEVELS
>  #define pmd_ERROR(pmd)		__pmd_error(__FILE__, __LINE__, pmd_val(pmd))
>  #endif
> +#ifdef CONFIG_ARM64_4_LEVELS
> +#define pud_ERROR(pud)		__pud_error(__FILE__, __LINE__, pud_val(pud))
> +#endif
>  #define pgd_ERROR(pgd)		__pgd_error(__FILE__, __LINE__, pgd_val(pgd))
>  
>  /*
> @@ -344,6 +352,30 @@ static inline pmd_t *pud_page_vaddr(pud_t pud)
>  
>  #endif	/* CONFIG_ARM64_2_LEVELS */
>  
> +#ifdef CONFIG_ARM64_4_LEVELS
> +
> +#define pgd_none(pgd)		(!pgd_val(pgd))
> +#define pgd_bad(pgd)		(!(pgd_val(pgd) & 2))
> +#define pgd_present(pgd)	(pgd_val(pgd))
> +
> +static inline void set_pgd(pgd_t *pgdp, pgd_t pgd)
> +{
> +	*pgdp = pgd;
> +	dsb();
> +}
> +
> +static inline void pgd_clear(pgd_t *pgdp)
> +{
> +	set_pgd(pgdp, __pgd(0));
> +}
> +
> +static inline pud_t *pgd_page_vaddr(pgd_t pgd)
> +{
> +	return __va(pgd_val(pgd) & PHYS_MASK & (s32)PAGE_MASK);
> +}
> +
> +#endif  /* CONFIG_ARM64_4_LEVELS */
> +
>  /* to find an entry in a page-table-directory */
>  #define pgd_index(addr)		(((addr) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
>  
> @@ -352,6 +384,14 @@ static inline pmd_t *pud_page_vaddr(pud_t pud)
>  /* to find an entry in a kernel page-table-directory */
>  #define pgd_offset_k(addr)	pgd_offset(&init_mm, addr)
>  
> +#ifdef CONFIG_ARM64_4_LEVELS
> +#define pud_index(addr)		(((addr) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
> +static inline pud_t *pud_offset(pgd_t *pgd, unsigned long addr)
> +{
> +	return (pud_t *)pgd_page_vaddr(*pgd) + pud_index(addr);
> +}
> +#endif
> +
>  /* Find an entry in the second-level page table.. */
>  #ifndef CONFIG_ARM64_2_LEVELS
>  #define pmd_index(addr)		(((addr) >> PMD_SHIFT) & (PTRS_PER_PMD - 1))
> @@ -380,8 +420,8 @@ static inline pmd_t pmd_modify(pmd_t pmd, pgprot_t newprot)
>  extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
>  extern pgd_t idmap_pg_dir[PTRS_PER_PGD];
>  
> -#define SWAPPER_DIR_SIZE	(3 * PAGE_SIZE)
> -#define IDMAP_DIR_SIZE		(2 * PAGE_SIZE)
> +#define SWAPPER_DIR_SIZE	(4 * PAGE_SIZE)
> +#define IDMAP_DIR_SIZE		(3 * PAGE_SIZE)
>  
>  /*
>   * Encode and decode a swap entry:
> diff --git a/arch/arm64/include/asm/tlb.h b/arch/arm64/include/asm/tlb.h
> index df378b2..dedfb04 100644
> --- a/arch/arm64/include/asm/tlb.h
> +++ b/arch/arm64/include/asm/tlb.h
> @@ -99,5 +99,13 @@ static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmdp,
>  }
>  #endif
>  
> +#ifdef CONFIG_ARM64_4_LEVELS
> +static inline void __pud_free_tlb(struct mmu_gather *tlb, pmd_t *pudp,
> +				  unsigned long addr)
> +{
> +	tlb_add_flush(tlb, addr);
> +	tlb_remove_page(tlb, virt_to_page(pudp));
> +}
> +#endif
>  
>  #endif
> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> index 0fd5650..f313a7a 100644
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S
> @@ -37,8 +37,8 @@
>  
>  /*
>   * swapper_pg_dir is the virtual address of the initial page table. We place
> - * the page tables 3 * PAGE_SIZE below KERNEL_RAM_VADDR. The idmap_pg_dir has
> - * 2 pages and is placed below swapper_pg_dir.
> + * the page tables 4 * PAGE_SIZE below KERNEL_RAM_VADDR. The idmap_pg_dir has
> + * 3 pages and is placed below swapper_pg_dir.
>   */
>  #define KERNEL_RAM_VADDR	(PAGE_OFFSET + TEXT_OFFSET)
>  
> @@ -46,8 +46,8 @@
>  #error KERNEL_RAM_VADDR must start at 0xXXX80000
>  #endif
>  
> -#define SWAPPER_DIR_SIZE	(3 * PAGE_SIZE)
> -#define IDMAP_DIR_SIZE		(2 * PAGE_SIZE)
> +#define SWAPPER_DIR_SIZE	(4 * PAGE_SIZE)
> +#define IDMAP_DIR_SIZE		(3 * PAGE_SIZE)
>  
>  	.globl	swapper_pg_dir
>  	.equ	swapper_pg_dir, KERNEL_RAM_VADDR - SWAPPER_DIR_SIZE
> @@ -371,16 +371,29 @@ ENDPROC(__calc_phys_offset)
>  
>  /*
>   * Macro to populate the PGD for the corresponding block entry in the next
> - * level (tbl) for the given virtual address.
> + * levels (tbl1 and tbl2) for the given virtual address.
>   *
> - * Preserves:	pgd, tbl, virt
> + * Preserves:	pgd, tbl1, tbl2, virt

tbl1 and tbl2 are *not* preserved for 4 level. tbl1 is bumped up one
page to make space for the pud, then fed into create_block_mapping
later.

>   * Corrupts:	tmp1, tmp2
>   */
> -	.macro	create_pgd_entry, pgd, tbl, virt, tmp1, tmp2
> +	.macro	create_pgd_entry, pgd, tbl1, tbl2, virt, tmp1, tmp2
>  	lsr	\tmp1, \virt, #PGDIR_SHIFT
>  	and	\tmp1, \tmp1, #PTRS_PER_PGD - 1	// PGD index
> -	orr	\tmp2, \tbl, #3			// PGD entry table type
> +	orr	\tmp2, \tbl1, #3		// PGD entry table type
>  	str	\tmp2, [\pgd, \tmp1, lsl #3]
> +#ifdef CONFIG_ARM64_4_LEVELS
> +	ldr	\tbl2, =FIXADDR_TOP
> +	cmp	\tbl2, \virt

Do we need this extra logic? See my other comment below where the fixed
mapping is placed down.

> +	add	\tbl2, \tbl1, #PAGE_SIZE
> +	b.ne	1f
> +	add	\tbl2, \tbl2, #PAGE_SIZE
> +1:
> +	lsr	\tmp1, \virt, #PUD_SHIFT
> +	and	\tmp1, \tmp1, #PTRS_PER_PUD - 1	// PUD index
> +	orr	\tmp2, \tbl2, #3		// PUD entry table type
> +	str	\tmp2, [\tbl1, \tmp1, lsl #3]
> +	mov	\tbl1, \tbl2
> +#endif

It may be easier to read to have a create_pud_entry macro too?

>  	.endm
>  
>  /*
> @@ -444,7 +457,7 @@ __create_page_tables:
>  	add	x0, x25, #PAGE_SIZE		// section table address
>  	ldr	x3, =KERNEL_START
>  	add	x3, x3, x28			// __pa(KERNEL_START)
> -	create_pgd_entry x25, x0, x3, x5, x6
> +	create_pgd_entry x25, x0, x1, x3, x5, x6
>  	ldr	x6, =KERNEL_END
>  	mov	x5, x3				// __pa(KERNEL_START)
>  	add	x6, x6, x28			// __pa(KERNEL_END)
> @@ -455,7 +468,7 @@ __create_page_tables:
>  	 */
>  	add	x0, x26, #PAGE_SIZE		// section table address
>  	mov	x5, #PAGE_OFFSET
> -	create_pgd_entry x26, x0, x5, x3, x6
> +	create_pgd_entry x26, x0, x1, x5, x3, x6
>  	ldr	x6, =KERNEL_END
>  	mov	x3, x24				// phys offset
>  	create_block_map x0, x7, x3, x5, x6
> @@ -480,8 +493,11 @@ __create_page_tables:
>  	 * Create the pgd entry for the fixed mappings.
>  	 */
>  	ldr	x5, =FIXADDR_TOP		// Fixed mapping virtual address
> -	add	x0, x26, #2 * PAGE_SIZE		// section table address
> -	create_pgd_entry x26, x0, x5, x6, x7
> +	add	x0, x26, #PAGE_SIZE
> +#ifndef CONFIG_ARM64_4_LEVELS
> +	add	x0, x0, #PAGE_SIZE
> +#endif

This is overly complicated. For <4 levels we set x0 to be:
ttbr1 + 2*PAGE_SIZE. For 4-levels, we set x0 to be ttbr1 + PAGE_SIZE,
then inside the create_pgd_entry macro, we check the VA for FIXADDR_TOP
then add another PAGE_SIZE. This is presumably done so the same PUD is
used for the swapper block map and the FIXADDR map.

If you assume that the PUD always follows the PGD for 4-levels, then
you can remove this #ifdef and the conditional VA logic in
set_pgd_entry. To make the logic simpler for <4 levels, you could call
create_pud_entry in the middle of create_pgd_entry, then put down the
actual pgd after.

> +	create_pgd_entry x26, x0, x1, x5, x6, x7
>  

So before this patch we have the following created by
__create_page_tables:

+========================+ <--- TEXT_OFFSET + PHYS_OFFSET
| FIXADDR (pmd or pte)   |
+------------------------+
| block map (pmd or pte) |
+------------------------+
| PGDs for swapper       |
+========================+ <--- TTBR1 swapper_pg_dir
| block map for idmap    |
+------------------------+
| PGDs for idmap         |
+------------------------+ <--- TTBR0 idmap_pg_dir


After the patch, for 4 levels activated we have:
+========================+ <--- TEXT_OFFSET + PHYS_OFFSET
| FIXADDR (ptes)         |
+------------------------+
| block map (ptes)       |
+------------------------+
| PUDs for swapper       |
+------------------------+
| PGDs for swapper       |
+========================+ <--- TTBR1 swapper_pg_dir
| block map for idmap    |
+------------------------+
| PUDs for idmap         |
+------------------------+
| PGDs for idmap         |
+------------------------+ <--- TTBR0 idmap_pg_dir

and without 4 levels activated we have:
+========================+ <--- TEXT_OFFSET + PHYS_OFFSET
| ZERO BYTES             |
+------------------------+
| FIXADDR (pmd or pte)   |
+------------------------+
| block map (pmd or pte) |
+------------------------+
| PGDs for swapper       |
+========================+ <--- TTBR1 swapper_pg_dir
| ZERO BYTES             |
+------------------------+
| block map for idmap    |
+------------------------+
| PGDs for idmap         |
+------------------------+ <--- TTBR0 idmap_pg_dir

This is a pity as we are potentially throwing away 128KB.
I would recommend only extending the sizes of IDMAP_DIR_SIZE and
SWAPPER_DIR_SIZE if necessary.


>  	/*
>  	 * Since the page tables have been populated with non-cacheable
> diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
> index 0484e81..16d5ee5 100644
> --- a/arch/arm64/kernel/traps.c
> +++ b/arch/arm64/kernel/traps.c
> @@ -336,6 +336,11 @@ void __pmd_error(const char *file, int line, unsigned long val)
>  	pr_crit("%s:%d: bad pmd %016lx.\n", file, line, val);
>  }
>  
> +void __pud_error(const char *file, int line, unsigned long val)
> +{
> +	pr_crit("%s:%d: bad pud %016lx.\n", file, line, val);
> +}
> +
>  void __pgd_error(const char *file, int line, unsigned long val)
>  {
>  	pr_crit("%s:%d: bad pgd %016lx.\n", file, line, val);
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index c23751b..ed4a343 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -61,6 +61,7 @@ void show_pte(struct mm_struct *mm, unsigned long addr)
>  			break;
>  
>  		pud = pud_offset(pgd, addr);
> +		printk(", *pud=%016llx", pud_val(*pud));
>  		if (pud_none(*pud) || pud_bad(*pud))
>  			break;
>  
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 6b7e895..4d29332 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -32,6 +32,7 @@
>  #include <asm/setup.h>
>  #include <asm/sizes.h>
>  #include <asm/tlb.h>
> +#include <asm/memblock.h>
>  #include <asm/mmu_context.h>
>  
>  #include "mm.h"
> @@ -222,9 +223,15 @@ static void __init alloc_init_pmd(pud_t *pud, unsigned long addr,
>  static void __init alloc_init_pud(pgd_t *pgd, unsigned long addr,
>  				  unsigned long end, unsigned long phys)
>  {
> -	pud_t *pud = pud_offset(pgd, addr);
> +	pud_t *pud;
>  	unsigned long next;
>  
> +	if (pgd_none(*pgd) || pgd_bad(*pgd)) {
> +		pud = early_alloc(PTRS_PER_PUD * sizeof(pud_t));
> +		pgd_populate(&init_mm, pgd, pud);
> +	}
> +
> +	pud = pud_offset(pgd, addr);
>  	do {
>  		next = pud_addr_end(addr, end);
>  		alloc_init_pmd(pud, addr, next, phys);
> @@ -271,10 +278,11 @@ static void __init map_mem(void)
>  	 * memory addressable from the initial direct kernel mapping.
>  	 *
>  	 * The initial direct kernel mapping, located at swapper_pg_dir,
> -	 * gives us PGDIR_SIZE memory starting from PHYS_OFFSET (which must be
> -	 * aligned to 2MB as per Documentation/arm64/booting.txt).
> +	 * gives us PGDIR_SIZE (2 and 3 levels) or PUD_SIZE (4 levels) memory
> +	 * starting from PHYS_OFFSET (which must be aligned to 2MB as per
> +	 * Documentation/arm64/booting.txt).
>  	 */
> -	limit = PHYS_OFFSET + PGDIR_SIZE;
> +	limit = PHYS_OFFSET + MEMBLOCK_INITIAL_LIMIT;
>  	memblock_set_current_limit(limit);
>  
>  	/* map all the memory banks */
> -- 
> 1.7.10.4
> 
> 
