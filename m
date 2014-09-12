Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbaILTM2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 15:12:28 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32573 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbaILTM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 15:12:27 -0400
Date: Fri, 12 Sep 2014 15:12:07 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Juergen Gross <jgross@suse.com>
Cc: stefan.bader@canonical.com, toshi.kani@hp.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        ville.syrjala@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        david.vrabel@citrix.com, jbeulich@suse.com
Subject: Re: [PATCH V3 1/3] x86: Make page cache mode a real type
Message-ID: <20140912191207.GC15656@laptop.dumpdata.com>
References: <1410518112-2625-1-git-send-email-jgross@suse.com>
 <1410518112-2625-2-git-send-email-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410518112-2625-2-git-send-email-jgross@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 12:35:10PM +0200, Juergen Gross wrote:
> At the moment there are a lot of places that handle setting or getting
> the page cache mode by treating the pgprot bits equal to the cache mode.
> This is only true because there are a lot of assumptions about the setup
> of the PAT MSR. Otherwise the cache type needs to get translated into
> pgprot bits and vice versa.
> 
> This patch tries to prepare for that by introducing a seperate type
> for the cache mode and adding functions to translate between those and
> pgprot values.
> 
> To avoid too much performance penalty the translation between cache mode
> and pgprot values is done via tables which contain the relevant
> information.  Write-back cache mode is hard-wired to be 0, all other
> modes are configurable via those tables. For large pages there are
> translation functions as the PAT bit is located at different positions
> in the ptes of 4k and large pages.
> 
> Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
> Signed-off-by: Juergen Gross <jgross@suse.com>
> Reviewed-by: Toshi Kani <toshi.kani@hp.com>

Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

with some comments below.
> ---
>  arch/x86/include/asm/cacheflush.h         |  38 +++++----
>  arch/x86/include/asm/fb.h                 |   6 +-
>  arch/x86/include/asm/io.h                 |   2 +-
>  arch/x86/include/asm/pat.h                |   6 +-
>  arch/x86/include/asm/pgtable.h            |  19 ++---
>  arch/x86/include/asm/pgtable_types.h      |  92 +++++++++++++++++-----
>  arch/x86/mm/dump_pagetables.c             |  24 +++---
>  arch/x86/mm/init.c                        |  29 +++++++
>  arch/x86/mm/init_64.c                     |   9 ++-
>  arch/x86/mm/iomap_32.c                    |  15 ++--
>  arch/x86/mm/ioremap.c                     |  63 ++++++++-------
>  arch/x86/mm/pageattr.c                    |  84 ++++++++++++--------
>  arch/x86/mm/pat.c                         | 126 +++++++++++++++---------------
>  arch/x86/mm/pat_internal.h                |  22 +++---
>  arch/x86/mm/pat_rbtree.c                  |   8 +-
>  arch/x86/pci/i386.c                       |   4 +-
>  drivers/video/fbdev/gbefb.c               |   3 +-
>  drivers/video/fbdev/vermilion/vermilion.c |   6 +-
>  18 files changed, 344 insertions(+), 212 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cacheflush.h b/arch/x86/include/asm/cacheflush.h
> index 9863ee3..157644b 100644
> --- a/arch/x86/include/asm/cacheflush.h
> +++ b/arch/x86/include/asm/cacheflush.h
> @@ -9,10 +9,10 @@
>  /*
>   * X86 PAT uses page flags WC and Uncached together to keep track of
>   * memory type of pages that have backing page struct. X86 PAT supports 3
> - * different memory types, _PAGE_CACHE_WB, _PAGE_CACHE_WC and
> - * _PAGE_CACHE_UC_MINUS and fourth state where page's memory type has not
> + * different memory types, _PAGE_CACHE_MODE_WB, _PAGE_CACHE_MODE_WC and
> + * _PAGE_CACHE_MODE_UC_MINUS and fourth state where page's memory type has not
>   * been changed from its default (value of -1 used to denote this).
> - * Note we do not support _PAGE_CACHE_UC here.
> + * Note we do not support _PAGE_CACHE_MODE_UC here.
>   */
>  
>  #define _PGMT_DEFAULT		0
> @@ -22,36 +22,40 @@
>  #define _PGMT_MASK		(1UL << PG_uncached | 1UL << PG_arch_1)
>  #define _PGMT_CLEAR_MASK	(~_PGMT_MASK)
>  
> -static inline unsigned long get_page_memtype(struct page *pg)
> +static inline enum page_cache_mode get_page_memtype(struct page *pg)
>  {
>  	unsigned long pg_flags = pg->flags & _PGMT_MASK;
>  
>  	if (pg_flags == _PGMT_DEFAULT)
>  		return -1;
>  	else if (pg_flags == _PGMT_WC)
> -		return _PAGE_CACHE_WC;
> +		return _PAGE_CACHE_MODE_WC;
>  	else if (pg_flags == _PGMT_UC_MINUS)
> -		return _PAGE_CACHE_UC_MINUS;
> +		return _PAGE_CACHE_MODE_UC_MINUS;
>  	else
> -		return _PAGE_CACHE_WB;
> +		return _PAGE_CACHE_MODE_WB;
>  }
>  
> -static inline void set_page_memtype(struct page *pg, unsigned long memtype)
> +static inline void set_page_memtype(struct page *pg,
> +				    enum page_cache_mode memtype)
>  {
> -	unsigned long memtype_flags = _PGMT_DEFAULT;
> +	unsigned long memtype_flags;
>  	unsigned long old_flags;
>  	unsigned long new_flags;
>  
>  	switch (memtype) {
> -	case _PAGE_CACHE_WC:
> +	case _PAGE_CACHE_MODE_WC:
>  		memtype_flags = _PGMT_WC;
>  		break;
> -	case _PAGE_CACHE_UC_MINUS:
> +	case _PAGE_CACHE_MODE_UC_MINUS:
>  		memtype_flags = _PGMT_UC_MINUS;
>  		break;
> -	case _PAGE_CACHE_WB:
> +	case _PAGE_CACHE_MODE_WB:
>  		memtype_flags = _PGMT_WB;
>  		break;
> +	default:
> +		memtype_flags = _PGMT_DEFAULT;
> +		break;
>  	}
>  
>  	do {
> @@ -60,8 +64,14 @@ static inline void set_page_memtype(struct page *pg, unsigned long memtype)
>  	} while (cmpxchg(&pg->flags, old_flags, new_flags) != old_flags);
>  }
>  #else
> -static inline unsigned long get_page_memtype(struct page *pg) { return -1; }
> -static inline void set_page_memtype(struct page *pg, unsigned long memtype) { }
> +static inline enum page_cache_mode get_page_memtype(struct page *pg)
> +{
> +	return -1;
> +}
> +static inline void set_page_memtype(struct page *pg,
> +				    enum page_cache_mode memtype)
> +{
> +}
>  #endif
>  
>  /*
> diff --git a/arch/x86/include/asm/fb.h b/arch/x86/include/asm/fb.h
> index 2519d06..c3dd5e7 100644
> --- a/arch/x86/include/asm/fb.h
> +++ b/arch/x86/include/asm/fb.h
> @@ -8,8 +8,12 @@
>  static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma,
>  				unsigned long off)
>  {
> +	unsigned long prot;
> +
> +	prot = pgprot_val(vma->vm_page_prot) & ~_PAGE_CACHE_MASK;
>  	if (boot_cpu_data.x86 > 3)
> -		pgprot_val(vma->vm_page_prot) |= _PAGE_PCD;
> +		pgprot_val(vma->vm_page_prot) =
> +			prot | cachemode2protval(_PAGE_CACHE_MODE_UC_MINUS);
>  }
>  
>  extern int fb_is_primary_device(struct fb_info *info);
> diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
> index b8237d8..71b9e65 100644
> --- a/arch/x86/include/asm/io.h
> +++ b/arch/x86/include/asm/io.h
> @@ -314,7 +314,7 @@ extern void *xlate_dev_mem_ptr(unsigned long phys);
>  extern void unxlate_dev_mem_ptr(unsigned long phys, void *addr);
>  
>  extern int ioremap_change_attr(unsigned long vaddr, unsigned long size,
> -				unsigned long prot_val);
> +				enum page_cache_mode pcm);
>  extern void __iomem *ioremap_wc(resource_size_t offset, unsigned long size);
>  
>  extern bool is_early_ioremap_ptep(pte_t *ptep);
> diff --git a/arch/x86/include/asm/pat.h b/arch/x86/include/asm/pat.h
> index e2c1668..150407a 100644
> --- a/arch/x86/include/asm/pat.h
> +++ b/arch/x86/include/asm/pat.h
> @@ -13,14 +13,14 @@ static const int pat_enabled;
>  extern void pat_init(void);
>  
>  extern int reserve_memtype(u64 start, u64 end,
> -		unsigned long req_type, unsigned long *ret_type);
> +		enum page_cache_mode req_pcm, enum page_cache_mode *ret_pcm);
>  extern int free_memtype(u64 start, u64 end);
>  
>  extern int kernel_map_sync_memtype(u64 base, unsigned long size,
> -		unsigned long flag);
> +		enum page_cache_mode pcm);
>  
>  int io_reserve_memtype(resource_size_t start, resource_size_t end,
> -			unsigned long *type);
> +			enum page_cache_mode *pcm);
>  
>  void io_free_memtype(resource_size_t start, resource_size_t end);
>  
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> index aa97a07..c112ea6 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -9,9 +9,10 @@
>  /*
>   * Macro to mark a page protection value as UC-
>   */
> -#define pgprot_noncached(prot)					\
> -	((boot_cpu_data.x86 > 3)				\
> -	 ? (__pgprot(pgprot_val(prot) | _PAGE_CACHE_UC_MINUS))	\
> +#define pgprot_noncached(prot)						\
> +	((boot_cpu_data.x86 > 3)					\
> +	 ? (__pgprot(pgprot_val(prot) |					\
> +		     cachemode2protval(_PAGE_CACHE_MODE_UC_MINUS)))	\
>  	 : (prot))
>  
>  #ifndef __ASSEMBLY__
> @@ -404,8 +405,8 @@ static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
>  #define canon_pgprot(p) __pgprot(massage_pgprot(p))
>  
>  static inline int is_new_memtype_allowed(u64 paddr, unsigned long size,
> -					 unsigned long flags,
> -					 unsigned long new_flags)
> +					 enum page_cache_mode pcm,
> +					 enum page_cache_mode new_pcm)
>  {
>  	/*
>  	 * PAT type is always WB for untracked ranges, so no need to check.
> @@ -419,10 +420,10 @@ static inline int is_new_memtype_allowed(u64 paddr, unsigned long size,
>  	 * - request is uncached, return cannot be write-back
>  	 * - request is write-combine, return cannot be write-back
>  	 */
> -	if ((flags == _PAGE_CACHE_UC_MINUS &&
> -	     new_flags == _PAGE_CACHE_WB) ||
> -	    (flags == _PAGE_CACHE_WC &&
> -	     new_flags == _PAGE_CACHE_WB)) {
> +	if ((pcm == _PAGE_CACHE_MODE_UC_MINUS &&
> +	     new_pcm == _PAGE_CACHE_MODE_WB) ||
> +	    (pcm == _PAGE_CACHE_MODE_WC &&
> +	     new_pcm == _PAGE_CACHE_MODE_WB)) {
>  		return 0;
>  	}
>  
> diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
> index f216963..0d38511 100644
> --- a/arch/x86/include/asm/pgtable_types.h
> +++ b/arch/x86/include/asm/pgtable_types.h
> @@ -129,11 +129,28 @@
>  			 _PAGE_SOFT_DIRTY | _PAGE_NUMA)
>  #define _HPAGE_CHG_MASK (_PAGE_CHG_MASK | _PAGE_PSE | _PAGE_NUMA)
>  
> -#define _PAGE_CACHE_MASK	(_PAGE_PCD | _PAGE_PWT)
> -#define _PAGE_CACHE_WB		(0)
> -#define _PAGE_CACHE_WC		(_PAGE_PWT)
> -#define _PAGE_CACHE_UC_MINUS	(_PAGE_PCD)
> -#define _PAGE_CACHE_UC		(_PAGE_PCD | _PAGE_PWT)
> +/*
> + * The cache modes defined here are used to translate between pure SW usage
> + * and the HW defined cache mode bits and/or PAT entries.
> + *
> + * The resulting bits for PWT, PCD and PAT should be chosen in a way
> + * to have the WB mode at index 0 (all bits clear). This is the default
> + * right now and likely would break too much if changed.
> + */
> +#ifndef __ASSEMBLY__
> +enum page_cache_mode {
> +	_PAGE_CACHE_MODE_WB = 0,
> +	_PAGE_CACHE_MODE_WC = 1,
> +	_PAGE_CACHE_MODE_UC_MINUS = 2,
> +	_PAGE_CACHE_MODE_UC = 3,
> +	_PAGE_CACHE_MODE_WT = 4,
> +	_PAGE_CACHE_MODE_WP = 5,
> +	_PAGE_CACHE_MODE_NUM = 8
> +};
> +#endif
> +
> +#define _PAGE_CACHE_MASK	(_PAGE_PAT | _PAGE_PCD | _PAGE_PWT)
> +#define _PAGE_NOCACHE		(cachemode2protval(_PAGE_CACHE_MODE_UC))
>  
>  #define PAGE_NONE	__pgprot(_PAGE_PROTNONE | _PAGE_ACCESSED)
>  #define PAGE_SHARED	__pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | \
> @@ -157,41 +174,27 @@
>  
>  #define __PAGE_KERNEL_RO		(__PAGE_KERNEL & ~_PAGE_RW)
>  #define __PAGE_KERNEL_RX		(__PAGE_KERNEL_EXEC & ~_PAGE_RW)
> -#define __PAGE_KERNEL_EXEC_NOCACHE	(__PAGE_KERNEL_EXEC | _PAGE_PCD | _PAGE_PWT)
> -#define __PAGE_KERNEL_WC		(__PAGE_KERNEL | _PAGE_CACHE_WC)
> -#define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_PCD | _PAGE_PWT)
> -#define __PAGE_KERNEL_UC_MINUS		(__PAGE_KERNEL | _PAGE_PCD)
> +#define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_NOCACHE)
>  #define __PAGE_KERNEL_VSYSCALL		(__PAGE_KERNEL_RX | _PAGE_USER)
>  #define __PAGE_KERNEL_VVAR		(__PAGE_KERNEL_RO | _PAGE_USER)
> -#define __PAGE_KERNEL_VVAR_NOCACHE	(__PAGE_KERNEL_VVAR | _PAGE_PCD | _PAGE_PWT)
>  #define __PAGE_KERNEL_LARGE		(__PAGE_KERNEL | _PAGE_PSE)
> -#define __PAGE_KERNEL_LARGE_NOCACHE	(__PAGE_KERNEL | _PAGE_CACHE_UC | _PAGE_PSE)
>  #define __PAGE_KERNEL_LARGE_EXEC	(__PAGE_KERNEL_EXEC | _PAGE_PSE)
>  
>  #define __PAGE_KERNEL_IO		(__PAGE_KERNEL | _PAGE_IOMAP)
>  #define __PAGE_KERNEL_IO_NOCACHE	(__PAGE_KERNEL_NOCACHE | _PAGE_IOMAP)
> -#define __PAGE_KERNEL_IO_UC_MINUS	(__PAGE_KERNEL_UC_MINUS | _PAGE_IOMAP)
> -#define __PAGE_KERNEL_IO_WC		(__PAGE_KERNEL_WC | _PAGE_IOMAP)
>  
>  #define PAGE_KERNEL			__pgprot(__PAGE_KERNEL)
>  #define PAGE_KERNEL_RO			__pgprot(__PAGE_KERNEL_RO)
>  #define PAGE_KERNEL_EXEC		__pgprot(__PAGE_KERNEL_EXEC)
>  #define PAGE_KERNEL_RX			__pgprot(__PAGE_KERNEL_RX)
> -#define PAGE_KERNEL_WC			__pgprot(__PAGE_KERNEL_WC)
>  #define PAGE_KERNEL_NOCACHE		__pgprot(__PAGE_KERNEL_NOCACHE)
> -#define PAGE_KERNEL_UC_MINUS		__pgprot(__PAGE_KERNEL_UC_MINUS)
> -#define PAGE_KERNEL_EXEC_NOCACHE	__pgprot(__PAGE_KERNEL_EXEC_NOCACHE)
>  #define PAGE_KERNEL_LARGE		__pgprot(__PAGE_KERNEL_LARGE)
> -#define PAGE_KERNEL_LARGE_NOCACHE	__pgprot(__PAGE_KERNEL_LARGE_NOCACHE)
>  #define PAGE_KERNEL_LARGE_EXEC		__pgprot(__PAGE_KERNEL_LARGE_EXEC)
>  #define PAGE_KERNEL_VSYSCALL		__pgprot(__PAGE_KERNEL_VSYSCALL)
>  #define PAGE_KERNEL_VVAR		__pgprot(__PAGE_KERNEL_VVAR)
> -#define PAGE_KERNEL_VVAR_NOCACHE	__pgprot(__PAGE_KERNEL_VVAR_NOCACHE)
>  
>  #define PAGE_KERNEL_IO			__pgprot(__PAGE_KERNEL_IO)
>  #define PAGE_KERNEL_IO_NOCACHE		__pgprot(__PAGE_KERNEL_IO_NOCACHE)
> -#define PAGE_KERNEL_IO_UC_MINUS		__pgprot(__PAGE_KERNEL_IO_UC_MINUS)
> -#define PAGE_KERNEL_IO_WC		__pgprot(__PAGE_KERNEL_IO_WC)
>  
>  /*         xwr */
>  #define __P000	PAGE_NONE
> @@ -328,6 +331,55 @@ static inline pteval_t pte_flags(pte_t pte)
>  #define pgprot_val(x)	((x).pgprot)
>  #define __pgprot(x)	((pgprot_t) { (x) } )
>  
> +extern uint16_t __cachemode2pte_tbl[_PAGE_CACHE_MODE_NUM];
> +extern uint8_t __pte2cachemode_tbl[8];

You might want to use a #define for the 8 eight value. Or just have 
a comment saying it is to match the PAT0-7 entries.

Maybe mention SDM 11.12.3 and how the PAT, PCT, PWT play a role
in determining which PATi is selected; and how the PATi memory types
match up with the _PAGE_CACHE_MODE_NUM enums?

> +
> +#define __pte2cm_idx(cb)				\
> +	((((cb) >> (_PAGE_BIT_PAT - 2)) & 4) |		\
> +	 (((cb) >> (_PAGE_BIT_PCD - 1)) & 2) |		\
> +	 (((cb) >> _PAGE_BIT_PWT) & 1))

Also I would say:

/* See __pte2cachemode_tbl for an example of how this is used. */

> +
> +static inline unsigned long cachemode2protval(enum page_cache_mode pcm)
> +{
> +	if (likely(pcm == 0))
> +		return 0;
> +	return __cachemode2pte_tbl[pcm];
> +}
> +static inline pgprot_t cachemode2pgprot(enum page_cache_mode pcm)
> +{
> +	return __pgprot(cachemode2protval(pcm));
> +}
> +static inline enum page_cache_mode pgprot2cachemode(pgprot_t pgprot)
> +{
> +	unsigned long masked;
> +
> +	masked = pgprot_val(pgprot) & _PAGE_CACHE_MASK;
> +	if (likely(masked == 0))
> +		return 0;
> +	return __pte2cachemode_tbl[__pte2cm_idx(masked)];
> +}
> +static inline pgprot_t pgprot_4k_2_large(pgprot_t pgprot)
> +{
> +	pgprot_t new;
> +	unsigned long val;
> +
> +	val = pgprot_val(pgprot);
> +	pgprot_val(new) = (val & ~(_PAGE_PAT | _PAGE_PAT_LARGE)) |
> +		((val & _PAGE_PAT) << (_PAGE_BIT_PAT_LARGE - _PAGE_BIT_PAT));
> +	return new;
> +}
> +static inline pgprot_t pgprot_large_2_4k(pgprot_t pgprot)
> +{
> +	pgprot_t new;
> +	unsigned long val;
> +
> +	val = pgprot_val(pgprot);
> +	pgprot_val(new) = (val & ~(_PAGE_PAT | _PAGE_PAT_LARGE)) |
> +		((val & _PAGE_PAT_LARGE) >>
> +		 (_PAGE_BIT_PAT_LARGE - _PAGE_BIT_PAT));
> +	return new;
> +}
> +
>  
>  typedef struct page *pgtable_t;
>  
> diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
> index 167ffca..52a336a 100644
> --- a/arch/x86/mm/dump_pagetables.c
> +++ b/arch/x86/mm/dump_pagetables.c
> @@ -122,7 +122,7 @@ static void printk_prot(struct seq_file *m, pgprot_t prot, int level, bool dmsg)
>  
>  	if (!pgprot_val(prot)) {
>  		/* Not present */
> -		pt_dump_cont_printf(m, dmsg, "                          ");
> +		pt_dump_cont_printf(m, dmsg, "                              ");
>  	} else {
>  		if (pr & _PAGE_USER)
>  			pt_dump_cont_printf(m, dmsg, "USR ");
> @@ -141,18 +141,16 @@ static void printk_prot(struct seq_file *m, pgprot_t prot, int level, bool dmsg)
>  		else
>  			pt_dump_cont_printf(m, dmsg, "    ");
>  
> -		/* Bit 9 has a different meaning on level 3 vs 4 */

HA!
> -		if (level <= 3) {
> -			if (pr & _PAGE_PSE)
> -				pt_dump_cont_printf(m, dmsg, "PSE ");
> -			else
> -				pt_dump_cont_printf(m, dmsg, "    ");
> -		} else {
> -			if (pr & _PAGE_PAT)
> -				pt_dump_cont_printf(m, dmsg, "pat ");
> -			else
> -				pt_dump_cont_printf(m, dmsg, "    ");
> -		}
> +		/* Bit 7 has a different meaning on level 3 vs 4 */

You are fixing this as well (might want to mention that in the description).

> +		if (level <= 3 && pr & _PAGE_PSE)
> +			pt_dump_cont_printf(m, dmsg, "PSE ");
> +		else
> +			pt_dump_cont_printf(m, dmsg, "    ");
> +		if ((level == 4 && pr & _PAGE_PAT) ||
> +		    ((level == 3 || level == 2) && pr & _PAGE_PAT_LARGE))
> +			pt_dump_cont_printf(m, dmsg, "pat ");
> +		else
> +			pt_dump_cont_printf(m, dmsg, "    ");
>  		if (pr & _PAGE_GLOBAL)
>  			pt_dump_cont_printf(m, dmsg, "GLB ");
>  		else
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index 66dba36..a9776ba 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -27,6 +27,35 @@
>  
>  #include "mm_internal.h"
>  
> +/*
> + * Tables translating between page_cache_type_t and pte encoding.
> + * Minimal supported modes are defined statically, modified if more supported
> + * cache modes are available.
> + * Index into __cachemode2pte_tbl is the cachemode.
> + * Index into __pte2cachemode_tbl are the caching attribute bits of the pte
> + * (_PAGE_PWT, _PAGE_PCD, _PAGE_PAT) at index bit positions 0, 1, 2.

Nicely put. Could be replicated in the pte2cm_idx on how it is suppose to work.

> + */
> +uint16_t __cachemode2pte_tbl[_PAGE_CACHE_MODE_NUM] = {
> +	[_PAGE_CACHE_MODE_WB]		= 0,
> +	[_PAGE_CACHE_MODE_WC]		= _PAGE_PWT,
> +	[_PAGE_CACHE_MODE_UC_MINUS]	= _PAGE_PCD,
> +	[_PAGE_CACHE_MODE_UC]		= _PAGE_PCD | _PAGE_PWT,
> +	[_PAGE_CACHE_MODE_WT]		= _PAGE_PCD,
> +	[_PAGE_CACHE_MODE_WP]		= _PAGE_PCD,
> +};
> +EXPORT_SYMBOL_GPL(__cachemode2pte_tbl);
> +uint8_t __pte2cachemode_tbl[8] = {
> +	[__pte2cm_idx(0)] = _PAGE_CACHE_MODE_WB,
> +	[__pte2cm_idx(_PAGE_PWT)] = _PAGE_CACHE_MODE_WC,
> +	[__pte2cm_idx(_PAGE_PCD)] = _PAGE_CACHE_MODE_UC_MINUS,
> +	[__pte2cm_idx(_PAGE_PWT | _PAGE_PCD)] = _PAGE_CACHE_MODE_UC,
> +	[__pte2cm_idx(_PAGE_PAT)] = _PAGE_CACHE_MODE_WB,
> +	[__pte2cm_idx(_PAGE_PWT | _PAGE_PAT)] = _PAGE_CACHE_MODE_WC,
> +	[__pte2cm_idx(_PAGE_PCD | _PAGE_PAT)] = _PAGE_CACHE_MODE_UC_MINUS,
> +	[__pte2cm_idx(_PAGE_PWT | _PAGE_PCD | _PAGE_PAT)] = _PAGE_CACHE_MODE_UC,
> +};
> +EXPORT_SYMBOL_GPL(__pte2cachemode_tbl);
> +
>  static unsigned long __initdata pgt_buf_start;
>  static unsigned long __initdata pgt_buf_end;
>  static unsigned long __initdata pgt_buf_top;
