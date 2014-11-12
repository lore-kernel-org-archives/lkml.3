Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbaKLVph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 16:45:37 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:41190 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbaKLVpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 16:45:36 -0500
Date: Wed, 12 Nov 2014 16:45:06 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Juergen Gross <jgross@suse.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH V3 2/8] xen: Delay remapping memory of pv-domain
Message-ID: <20141112214506.GA5922@laptop.dumpdata.com>
References: <1415684626-18590-1-git-send-email-jgross@suse.com>
 <1415684626-18590-3-git-send-email-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415684626-18590-3-git-send-email-jgross@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 06:43:40AM +0100, Juergen Gross wrote:
> Early in the boot process the memory layout of a pv-domain is changed
> to match the E820 map (either the host one for Dom0 or the Xen one)
> regarding placement of RAM and PCI holes. This requires removing memory
> pages initially located at positions not suitable for RAM and adding
> them later at higher addresses where no restrictions apply.
> 
> To be able to operate on the hypervisor supported p2m list until a
> virtual mapped linear p2m list can be constructed, remapping must
> be delayed until virtual memory management is initialized, as the
> initial p2m list can't be extended unlimited at physical memory
> initialization time due to it's fixed structure.
> 
> A further advantage is the reduction in complexity and code volume as
> we don't have to be careful regarding memory restrictions during p2m
> updates.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>
> Reviewed-by: David Vrabel <david.vrabel@citrix.com>
> ---
>  arch/x86/include/asm/xen/page.h |   1 -
>  arch/x86/xen/mmu.c              |   4 +
>  arch/x86/xen/p2m.c              | 149 ++++------------
>  arch/x86/xen/setup.c            | 385 +++++++++++++++++++---------------------
>  arch/x86/xen/xen-ops.h          |   1 +
>  5 files changed, 223 insertions(+), 317 deletions(-)
> 
> diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
> index 6c16451..b475297 100644
> --- a/arch/x86/include/asm/xen/page.h
> +++ b/arch/x86/include/asm/xen/page.h
> @@ -44,7 +44,6 @@ extern unsigned long  machine_to_phys_nr;
>  
>  extern unsigned long get_phys_to_machine(unsigned long pfn);
>  extern bool set_phys_to_machine(unsigned long pfn, unsigned long mfn);
> -extern bool __init early_set_phys_to_machine(unsigned long pfn, unsigned long mfn);
>  extern bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn);
>  extern unsigned long set_phys_range_identity(unsigned long pfn_s,
>  					     unsigned long pfn_e);
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index a8a1a3d..d3e492b 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -1223,6 +1223,10 @@ static void __init xen_pagetable_init(void)
>  	/* Allocate and initialize top and mid mfn levels for p2m structure */
>  	xen_build_mfn_list_list();
>  
> +	/* Remap memory freed because of conflicts with E820 map */

s/becasue of/due to
> +	if (!xen_feature(XENFEAT_auto_translated_physmap))
> +		xen_remap_memory();
> +
>  	xen_setup_shared_info();
>  	xen_post_allocator_init();
>  }
> diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
> index fa75842..f67f8cf 100644
> --- a/arch/x86/xen/p2m.c
> +++ b/arch/x86/xen/p2m.c
> @@ -164,6 +164,7 @@
>  #include <linux/sched.h>
>  #include <linux/seq_file.h>
>  #include <linux/bootmem.h>
> +#include <linux/slab.h>
>  
>  #include <asm/cache.h>
>  #include <asm/setup.h>
> @@ -204,6 +205,8 @@ RESERVE_BRK(p2m_mid, PAGE_SIZE * (MAX_DOMAIN_PAGES / (P2M_PER_PAGE * P2M_MID_PER
>   */
>  RESERVE_BRK(p2m_identity_remap, PAGE_SIZE * 2 * 3 * MAX_REMAP_RANGES);
>  
> +static int use_brk = 1;
> +
>  static inline unsigned p2m_top_index(unsigned long pfn)
>  {
>  	BUG_ON(pfn >= MAX_P2M_PFN);
> @@ -268,6 +271,22 @@ static void p2m_init(unsigned long *p2m)
>  		p2m[i] = INVALID_P2M_ENTRY;
>  }
>  
> +static void * __ref alloc_p2m_page(void)
> +{
> +	if (unlikely(use_brk))
> +		return extend_brk(PAGE_SIZE, PAGE_SIZE);
> +
> +	if (unlikely(!slab_is_available()))
> +		return alloc_bootmem_align(PAGE_SIZE, PAGE_SIZE);
> +
> +	return (void *)__get_free_page(GFP_KERNEL | __GFP_REPEAT);
> +}
> +
> +static void free_p2m_page(void *p)
> +{
> +	free_page((unsigned long)p);
> +}
> +
>  /*
>   * Build the parallel p2m_top_mfn and p2m_mid_mfn structures
>   *
> @@ -287,13 +306,13 @@ void __ref xen_build_mfn_list_list(void)
>  
>  	/* Pre-initialize p2m_top_mfn to be completely missing */
>  	if (p2m_top_mfn == NULL) {
> -		p2m_mid_missing_mfn = alloc_bootmem_align(PAGE_SIZE, PAGE_SIZE);
> +		p2m_mid_missing_mfn = alloc_p2m_page();
>  		p2m_mid_mfn_init(p2m_mid_missing_mfn, p2m_missing);
>  
> -		p2m_top_mfn_p = alloc_bootmem_align(PAGE_SIZE, PAGE_SIZE);
> +		p2m_top_mfn_p = alloc_p2m_page();
>  		p2m_top_mfn_p_init(p2m_top_mfn_p);
>  
> -		p2m_top_mfn = alloc_bootmem_align(PAGE_SIZE, PAGE_SIZE);
> +		p2m_top_mfn = alloc_p2m_page();
>  		p2m_top_mfn_init(p2m_top_mfn);
>  	} else {
>  		/* Reinitialise, mfn's all change after migration */
> @@ -327,7 +346,7 @@ void __ref xen_build_mfn_list_list(void)
>  			 * missing parts of the mfn tree after
>  			 * runtime.
>  			 */
> -			mid_mfn_p = alloc_bootmem_align(PAGE_SIZE, PAGE_SIZE);
> +			mid_mfn_p = alloc_p2m_page();
>  			p2m_mid_mfn_init(mid_mfn_p, p2m_missing);
>  
>  			p2m_top_mfn_p[topidx] = mid_mfn_p;
> @@ -364,17 +383,17 @@ void __init xen_build_dynamic_phys_to_machine(void)
>  	max_pfn = min(MAX_DOMAIN_PAGES, xen_start_info->nr_pages);
>  	xen_max_p2m_pfn = max_pfn;
>  
> -	p2m_missing = extend_brk(PAGE_SIZE, PAGE_SIZE);
> +	p2m_missing = alloc_p2m_page();
>  	p2m_init(p2m_missing);
> -	p2m_identity = extend_brk(PAGE_SIZE, PAGE_SIZE);
> +	p2m_identity = alloc_p2m_page();
>  	p2m_init(p2m_identity);
>  
> -	p2m_mid_missing = extend_brk(PAGE_SIZE, PAGE_SIZE);
> +	p2m_mid_missing = alloc_p2m_page();
>  	p2m_mid_init(p2m_mid_missing, p2m_missing);
> -	p2m_mid_identity = extend_brk(PAGE_SIZE, PAGE_SIZE);
> +	p2m_mid_identity = alloc_p2m_page();
>  	p2m_mid_init(p2m_mid_identity, p2m_identity);
>  
> -	p2m_top = extend_brk(PAGE_SIZE, PAGE_SIZE);
> +	p2m_top = alloc_p2m_page();
>  	p2m_top_init(p2m_top);
>  
>  	/*
> @@ -387,7 +406,7 @@ void __init xen_build_dynamic_phys_to_machine(void)
>  		unsigned mididx = p2m_mid_index(pfn);
>  
>  		if (p2m_top[topidx] == p2m_mid_missing) {
> -			unsigned long **mid = extend_brk(PAGE_SIZE, PAGE_SIZE);
> +			unsigned long **mid = alloc_p2m_page();
>  			p2m_mid_init(mid, p2m_missing);
>  
>  			p2m_top[topidx] = mid;
> @@ -420,6 +439,7 @@ unsigned long __init xen_revector_p2m_tree(void)
>  	unsigned long *mfn_list = NULL;
>  	unsigned long size;
>  
> +	use_brk = 0;
>  	va_start = xen_start_info->mfn_list;
>  	/*We copy in increments of P2M_PER_PAGE * sizeof(unsigned long),
>  	 * so make sure it is rounded up to that */
> @@ -484,6 +504,7 @@ unsigned long __init xen_revector_p2m_tree(void)
>  #else
>  unsigned long __init xen_revector_p2m_tree(void)
>  {
> +	use_brk = 0;
>  	return 0;
>  }
>  #endif
> @@ -510,16 +531,6 @@ unsigned long get_phys_to_machine(unsigned long pfn)
>  }
>  EXPORT_SYMBOL_GPL(get_phys_to_machine);
>  
> -static void *alloc_p2m_page(void)
> -{
> -	return (void *)__get_free_page(GFP_KERNEL | __GFP_REPEAT);
> -}
> -
> -static void free_p2m_page(void *p)
> -{
> -	free_page((unsigned long)p);
> -}
> -
>  /*
>   * Fully allocate the p2m structure for a given pfn.  We need to check
>   * that both the top and mid levels are allocated, and make sure the
> @@ -624,7 +635,7 @@ static bool __init early_alloc_p2m(unsigned long pfn, bool check_boundary)
>  		return false;
>  
>  	/* Boundary cross-over for the edges: */
> -	p2m = extend_brk(PAGE_SIZE, PAGE_SIZE);
> +	p2m = alloc_p2m_page();
>  
>  	p2m_init(p2m);
>  
> @@ -640,7 +651,7 @@ static bool __init early_alloc_p2m_middle(unsigned long pfn)
>  
>  	mid = p2m_top[topidx];
>  	if (mid == p2m_mid_missing) {
> -		mid = extend_brk(PAGE_SIZE, PAGE_SIZE);
> +		mid = alloc_p2m_page();
>  
>  		p2m_mid_init(mid, p2m_missing);
>  
> @@ -649,100 +660,6 @@ static bool __init early_alloc_p2m_middle(unsigned long pfn)
>  	return true;
>  }
>  

I would split this patch in two - one for the extend_brk/alloc_page conversation
to alloc_p2m_page and free_page to free_p2m_page.

> -/*
> - * Skim over the P2M tree looking at pages that are either filled with
> - * INVALID_P2M_ENTRY or with 1:1 PFNs. If found, re-use that page and
> - * replace the P2M leaf with a p2m_missing or p2m_identity.
> - * Stick the old page in the new P2M tree location.
> - */
> -static bool __init early_can_reuse_p2m_middle(unsigned long set_pfn)
> -{
> -	unsigned topidx;
> -	unsigned mididx;
> -	unsigned ident_pfns;
> -	unsigned inv_pfns;
> -	unsigned long *p2m;
> -	unsigned idx;
> -	unsigned long pfn;
> -
> -	/* We only look when this entails a P2M middle layer */
> -	if (p2m_index(set_pfn))
> -		return false;
> -
> -	for (pfn = 0; pfn < MAX_DOMAIN_PAGES; pfn += P2M_PER_PAGE) {
> -		topidx = p2m_top_index(pfn);
> -
> -		if (!p2m_top[topidx])
> -			continue;
> -
> -		if (p2m_top[topidx] == p2m_mid_missing)
> -			continue;
> -
> -		mididx = p2m_mid_index(pfn);
> -		p2m = p2m_top[topidx][mididx];
> -		if (!p2m)
> -			continue;
> -
> -		if ((p2m == p2m_missing) || (p2m == p2m_identity))
> -			continue;
> -
> -		if ((unsigned long)p2m == INVALID_P2M_ENTRY)
> -			continue;
> -
> -		ident_pfns = 0;
> -		inv_pfns = 0;
> -		for (idx = 0; idx < P2M_PER_PAGE; idx++) {
> -			/* IDENTITY_PFNs are 1:1 */
> -			if (p2m[idx] == IDENTITY_FRAME(pfn + idx))
> -				ident_pfns++;
> -			else if (p2m[idx] == INVALID_P2M_ENTRY)
> -				inv_pfns++;
> -			else
> -				break;
> -		}
> -		if ((ident_pfns == P2M_PER_PAGE) || (inv_pfns == P2M_PER_PAGE))
> -			goto found;
> -	}
> -	return false;
> -found:
> -	/* Found one, replace old with p2m_identity or p2m_missing */
> -	p2m_top[topidx][mididx] = (ident_pfns ? p2m_identity : p2m_missing);
> -
> -	/* Reset where we want to stick the old page in. */
> -	topidx = p2m_top_index(set_pfn);
> -	mididx = p2m_mid_index(set_pfn);
> -
> -	/* This shouldn't happen */
> -	if (WARN_ON(p2m_top[topidx] == p2m_mid_missing))
> -		early_alloc_p2m_middle(set_pfn);
> -
> -	if (WARN_ON(p2m_top[topidx][mididx] != p2m_missing))
> -		return false;
> -
> -	p2m_init(p2m);
> -	p2m_top[topidx][mididx] = p2m;
> -
> -	return true;
> -}
> -bool __init early_set_phys_to_machine(unsigned long pfn, unsigned long mfn)
> -{
> -	if (unlikely(!__set_phys_to_machine(pfn, mfn)))  {
> -		if (!early_alloc_p2m_middle(pfn))
> -			return false;
> -
> -		if (early_can_reuse_p2m_middle(pfn))
> -			return __set_phys_to_machine(pfn, mfn);
> -
> -		if (!early_alloc_p2m(pfn, false /* boundary crossover OK!*/))
> -			return false;
> -
> -		if (!__set_phys_to_machine(pfn, mfn))
> -			return false;
> -	}
> -
> -	return true;
> -}
> -
>  static void __init early_split_p2m(unsigned long pfn)
>  {
>  	unsigned long mididx, idx;
> diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> index 29834b3..0e5f9b6 100644
> --- a/arch/x86/xen/setup.c
> +++ b/arch/x86/xen/setup.c
> @@ -30,6 +30,7 @@
>  #include "xen-ops.h"
>  #include "vdso.h"
>  #include "p2m.h"
> +#include "mmu.h"
>  
>  /* These are code, but not functions.  Defined in entry.S */
>  extern const char xen_hypervisor_callback[];
> @@ -47,8 +48,18 @@ struct xen_memory_region xen_extra_mem[XEN_EXTRA_MEM_MAX_REGIONS] __initdata;
>  /* Number of pages released from the initial allocation. */
>  unsigned long xen_released_pages;
>  
> -/* Buffer used to remap identity mapped pages */
> -unsigned long xen_remap_buf[P2M_PER_PAGE] __initdata;
> +/*
> + * Buffer used to remap identity mapped pages. We only need the virtual space.

Could you expand on the 'need the virtual space'?


.. snip..
>  /*
>   * This function updates the p2m and m2p tables with an identity map from
> - * start_pfn to start_pfn+size and remaps the underlying RAM of the original
> - * allocation at remap_pfn. It must do so carefully in P2M_PER_PAGE sized blocks
> - * to not exhaust the reserved brk space. Doing it in properly aligned blocks
> - * ensures we only allocate the minimum required leaf pages in the p2m table. It
> - * copies the existing mfns from the p2m table under the 1:1 map, overwrites
> - * them with the identity map and then updates the p2m and m2p tables with the
> - * remapped memory.
> + * start_pfn to start_pfn+size and prepares remapping the underlying RAM of the
> + * original allocation at remap_pfn. The information needed for remapping is
> + * saved in the memory itself to avoid the need for allocating buffers. The
> + * complete remap information is contained in a list of MFNs each containing
> + * up to REMAP_SIZE MFNs and the start target PFN for doing the remap.
> + * This enables to preserve the original mfn sequence while doing the remapping

us to
> + * at a time when the memory management is capable of allocating virtual and
> + * physical memory in arbitrary amounts.

You might want to add, see 'xen_remap_memory' and its callers.

>   */
> -static unsigned long __init xen_do_set_identity_and_remap_chunk(
> +static void __init xen_do_set_identity_and_remap_chunk(
>          unsigned long start_pfn, unsigned long size, unsigned long remap_pfn)
>  {
> +	unsigned long buf = (unsigned long)&xen_remap_buf;
> +	unsigned long mfn_save, mfn;
>  	unsigned long ident_pfn_iter, remap_pfn_iter;
> -	unsigned long ident_start_pfn_align, remap_start_pfn_align;
> -	unsigned long ident_end_pfn_align, remap_end_pfn_align;
> -	unsigned long ident_boundary_pfn, remap_boundary_pfn;
> -	unsigned long ident_cnt = 0;
> -	unsigned long remap_cnt = 0;
> +	unsigned long ident_end_pfn = start_pfn + size;
>  	unsigned long left = size;
> -	unsigned long mod;
> -	int i;
> +	unsigned long ident_cnt = 0;
> +	unsigned int i, chunk;
>  
>  	WARN_ON(size == 0);
>  
>  	BUG_ON(xen_feature(XENFEAT_auto_translated_physmap));
>  
> -	/*
> -	 * Determine the proper alignment to remap memory in P2M_PER_PAGE sized
> -	 * blocks. We need to keep track of both the existing pfn mapping and
> -	 * the new pfn remapping.
> -	 */
> -	mod = start_pfn % P2M_PER_PAGE;
> -	ident_start_pfn_align =
> -		mod ? (start_pfn - mod + P2M_PER_PAGE) : start_pfn;
> -	mod = remap_pfn % P2M_PER_PAGE;
> -	remap_start_pfn_align =
> -		mod ? (remap_pfn - mod + P2M_PER_PAGE) : remap_pfn;
> -	mod = (start_pfn + size) % P2M_PER_PAGE;
> -	ident_end_pfn_align = start_pfn + size - mod;
> -	mod = (remap_pfn + size) % P2M_PER_PAGE;
> -	remap_end_pfn_align = remap_pfn + size - mod;
> -
> -	/* Iterate over each p2m leaf node in each range */
> -	for (ident_pfn_iter = ident_start_pfn_align, remap_pfn_iter = remap_start_pfn_align;
> -	     ident_pfn_iter < ident_end_pfn_align && remap_pfn_iter < remap_end_pfn_align;
> -	     ident_pfn_iter += P2M_PER_PAGE, remap_pfn_iter += P2M_PER_PAGE) {
> -		/* Check we aren't past the end */
> -		BUG_ON(ident_pfn_iter + P2M_PER_PAGE > start_pfn + size);
> -		BUG_ON(remap_pfn_iter + P2M_PER_PAGE > remap_pfn + size);
> -
> -		/* Save p2m mappings */
> -		for (i = 0; i < P2M_PER_PAGE; i++)
> -			xen_remap_buf[i] = pfn_to_mfn(ident_pfn_iter + i);
> -
> -		/* Set identity map which will free a p2m leaf */
> -		ident_cnt += set_phys_range_identity(ident_pfn_iter,
> -			ident_pfn_iter + P2M_PER_PAGE);
> -
> -#ifdef DEBUG
> -		/* Helps verify a p2m leaf has been freed */
> -		for (i = 0; i < P2M_PER_PAGE; i++) {
> -			unsigned int pfn = ident_pfn_iter + i;
> -			BUG_ON(pfn_to_mfn(pfn) != pfn);
> -		}
> -#endif
> -		/* Now remap memory */
> -		for (i = 0; i < P2M_PER_PAGE; i++) {
> -			unsigned long mfn = xen_remap_buf[i];
> -
> -			/* This will use the p2m leaf freed above */
> -			if (!xen_update_mem_tables(remap_pfn_iter + i, mfn)) {
> -				WARN(1, "Failed to update mem mapping for pfn=%ld mfn=%ld\n",
> -					remap_pfn_iter + i, mfn);
> -				return 0;
> -			}
> -
> -			remap_cnt++;
> -		}
> -
> -		left -= P2M_PER_PAGE;
> -	}
> +	/* Don't use memory until remapped */
> +	memblock_reserve(PFN_PHYS(remap_pfn), PFN_PHYS(size));
>  
> -	/* Max boundary space possible */
> -	BUG_ON(left > (P2M_PER_PAGE - 1) * 2);
> +	mfn_save = virt_to_mfn(buf);
>  
> -	/* Now handle the boundary conditions */
> -	ident_boundary_pfn = start_pfn;
> -	remap_boundary_pfn = remap_pfn;
> -	for (i = 0; i < left; i++) {
> -		unsigned long mfn;
> +	for (ident_pfn_iter = start_pfn, remap_pfn_iter = remap_pfn;
> +	     ident_pfn_iter < ident_end_pfn;
> +	     ident_pfn_iter += REMAP_SIZE, remap_pfn_iter += REMAP_SIZE) {
> +		chunk = (left < REMAP_SIZE) ? left : REMAP_SIZE;
>  
> -		/* These two checks move from the start to end boundaries */
> -		if (ident_boundary_pfn == ident_start_pfn_align)
> -			ident_boundary_pfn = ident_pfn_iter;
> -		if (remap_boundary_pfn == remap_start_pfn_align)
> -			remap_boundary_pfn = remap_pfn_iter;
> +		/* Map first pfn to xen_remap_buf */
> +		mfn = pfn_to_mfn(ident_pfn_iter);
> +		set_pte_mfn(buf, mfn, PAGE_KERNEL);

So you set the buf to be point to 'mfn'.
>  
> -		/* Check we aren't past the end */
> -		BUG_ON(ident_boundary_pfn >= start_pfn + size);
> -		BUG_ON(remap_boundary_pfn >= remap_pfn + size);
> +		/* Save mapping information in page */
> +		xen_remap_buf.next_area_mfn = xen_remap_mfn;
> +		xen_remap_buf.target_pfn = remap_pfn_iter;
> +		xen_remap_buf.size = chunk;
> +		for (i = 0; i < chunk; i++)
> +			xen_remap_buf.mfns[i] = pfn_to_mfn(ident_pfn_iter + i);
>  
> -		mfn = pfn_to_mfn(ident_boundary_pfn);
> +		/* New element first in list */

I don't get that comment. Don't you mean the MFN of the last chunk you
had stashed the 'xen_remap_buf' structure in?

The 'xen_remap_mfn' ends up being the the tail value of this
"list".
> +		xen_remap_mfn = mfn;
>  
> -		if (!xen_update_mem_tables(remap_boundary_pfn, mfn)) {
> -			WARN(1, "Failed to update mem mapping for pfn=%ld mfn=%ld\n",
> -				remap_pfn_iter + i, mfn);
> -			return 0;
> -		}
> -		remap_cnt++;
> -
> -		ident_boundary_pfn++;
> -		remap_boundary_pfn++;
> -	}
> +		/* Set identity map */
> +		ident_cnt += set_phys_range_identity(ident_pfn_iter,
> +			ident_pfn_iter + chunk);
>  
> -	/* Finish up the identity map */
> -	if (ident_start_pfn_align >= ident_end_pfn_align) {
> -		/*
> -                 * In this case we have an identity range which does not span an
> -                 * aligned block so everything needs to be identity mapped here.
> -                 * If we didn't check this we might remap too many pages since
> -                 * the align boundaries are not meaningful in this case.
> -	         */
> -		ident_cnt += set_phys_range_identity(start_pfn,
> -			start_pfn + size);
> -	} else {
> -		/* Remapped above so check each end of the chunk */
> -		if (start_pfn < ident_start_pfn_align)
> -			ident_cnt += set_phys_range_identity(start_pfn,
> -				ident_start_pfn_align);
> -		if (start_pfn + size > ident_pfn_iter)
> -			ident_cnt += set_phys_range_identity(ident_pfn_iter,
> -				start_pfn + size);
> +		left -= chunk;
>  	}
>  
> -	BUG_ON(ident_cnt != size);
> -	BUG_ON(remap_cnt != size);
> -
> -	return size;
> +	/* Restore old xen_remap_buf mapping */
> +	set_pte_mfn(buf, mfn_save, PAGE_KERNEL);
>  }
>  
>  /*
> @@ -396,8 +318,7 @@ static unsigned long __init xen_do_set_identity_and_remap_chunk(
>  static unsigned long __init xen_set_identity_and_remap_chunk(
>          const struct e820entry *list, size_t map_size, unsigned long start_pfn,
>  	unsigned long end_pfn, unsigned long nr_pages, unsigned long remap_pfn,
> -	unsigned long *identity, unsigned long *remapped,
> -	unsigned long *released)
> +	unsigned long *identity, unsigned long *released)
>  {
>  	unsigned long pfn;
>  	unsigned long i = 0;
> @@ -431,19 +352,12 @@ static unsigned long __init xen_set_identity_and_remap_chunk(
>  		if (size > remap_range_size)
>  			size = remap_range_size;
>  
> -		if (!xen_do_set_identity_and_remap_chunk(cur_pfn, size, remap_pfn)) {
> -			WARN(1, "Failed to remap 1:1 memory cur_pfn=%ld size=%ld remap_pfn=%ld\n",
> -				cur_pfn, size, remap_pfn);
> -			xen_set_identity_and_release_chunk(cur_pfn,
> -				cur_pfn + left, nr_pages, identity, released);
> -			break;
> -		}
> +		xen_do_set_identity_and_remap_chunk(cur_pfn, size, remap_pfn);
>  
>  		/* Update variables to reflect new mappings. */
>  		i += size;
>  		remap_pfn += size;
>  		*identity += size;
> -		*remapped += size;
>  	}
>  
>  	/*
> @@ -464,7 +378,6 @@ static unsigned long __init xen_set_identity_and_remap(
>  {
>  	phys_addr_t start = 0;
>  	unsigned long identity = 0;
> -	unsigned long remapped = 0;
>  	unsigned long last_pfn = nr_pages;
>  	const struct e820entry *entry;
>  	unsigned long num_released = 0;
> @@ -494,8 +407,7 @@ static unsigned long __init xen_set_identity_and_remap(
>  				last_pfn = xen_set_identity_and_remap_chunk(
>  						list, map_size, start_pfn,
>  						end_pfn, nr_pages, last_pfn,
> -						&identity, &remapped,
> -						&num_released);
> +						&identity, &num_released);
>  			start = end;
>  		}
>  	}
> @@ -503,12 +415,84 @@ static unsigned long __init xen_set_identity_and_remap(
>  	*released = num_released;
>  
>  	pr_info("Set %ld page(s) to 1-1 mapping\n", identity);
> -	pr_info("Remapped %ld page(s), last_pfn=%ld\n", remapped,
> -		last_pfn);
>  	pr_info("Released %ld page(s)\n", num_released);
>  
>  	return last_pfn;
>  }
> +
> +/*
> + * Remap the memory prepared in xen_do_set_identity_and_remap_chunk().
> + */
> +void __init xen_remap_memory(void)
> +{
> +	unsigned long buf = (unsigned long)&xen_remap_buf;
> +	unsigned long mfn_save, mfn, pfn;
> +	unsigned long remapped = 0, released = 0;
> +	unsigned int i, free;
> +	unsigned long pfn_s = ~0UL;
> +	unsigned long len = 0;
> +
> +	mfn_save = virt_to_mfn(buf);
> +
> +	while (xen_remap_mfn != INVALID_P2M_ENTRY) {

So the 'list' is constructed by going forward - that is from low-numbered
PFNs to higher numbered ones. But the 'xen_remap_mfn' is going the
other way - from the highest PFN to the lowest PFN.

Won't that mean we will restore the chunks of memory in the wrong
order? That is we will still restore them in chunks size, but the
chunks will be in descending order instead of ascending?

> +		/* Map the remap information */
> +		set_pte_mfn(buf, xen_remap_mfn, PAGE_KERNEL);
> +
> +		BUG_ON(xen_remap_mfn != xen_remap_buf.mfns[0]);
> +
> +		free = 0;
> +		pfn = xen_remap_buf.target_pfn;
> +		for (i = 0; i < xen_remap_buf.size; i++) {
> +			mfn = xen_remap_buf.mfns[i];
> +			if (!released && xen_update_mem_tables(pfn, mfn)) {
> +				remapped++;

If we fail 'xen_update_mem_tables' we will on the next chunk (so i+1) keep on
freeing pages instead of trying to remap. Is that intentional? Could we
try to remap?
> +			} else {
> +				if (!released) {
> +					if (pfn_s != ~0UL && len)
> +						memblock_free(PFN_PHYS(pfn_s),
> +							      PFN_PHYS(len));
> +					pfn_s = xen_remap_buf.target_pfn;
> +					len = i;
> +				}
> +				/* Don't free the page with our mfn list! */
> +				if (i)
> +					xen_free_mfn(mfn);
> +				else
> +					free = 1;
> +				released++;
> +			}
> +			pfn++;
> +		}
> +		if (!released) {
> +			if (pfn_s == ~0UL || pfn == pfn_s) {
> +				pfn_s = xen_remap_buf.target_pfn;
> +				len += xen_remap_buf.size;
> +			} else if (pfn_s + len == xen_remap_buf.target_pfn) {
> +				len += xen_remap_buf.size;
> +			} else {
> +				memblock_free(PFN_PHYS(pfn_s), PFN_PHYS(len));
> +				pfn_s = xen_remap_buf.target_pfn;
> +				len = xen_remap_buf.size;
> +			}
> +		}
> +
> +		mfn = xen_remap_mfn;
> +		xen_remap_mfn = xen_remap_buf.next_area_mfn;
> +		/* Now it's save to free the page holding our data. */
> +		if (free)
> +			xen_free_mfn(mfn);
> +	}
> +
> +	if (pfn_s != ~0UL && len)
> +		memblock_free(PFN_PHYS(pfn_s), PFN_PHYS(len));
> +
> +	set_pte_mfn(buf, mfn_save, PAGE_KERNEL);
> +
> +	pr_info("Remapped %ld page(s)\n", remapped);
> +	if (released)
> +		pr_info("Released %ld page(s)\n", released);
> +}
> +
>  static unsigned long __init xen_get_max_pages(void)
>  {
>  	unsigned long max_pages = MAX_DOMAIN_PAGES;
> @@ -616,7 +600,8 @@ char * __init xen_memory_setup(void)
>  		extra_pages += max_pages - max_pfn;
>  
>  	/*
> -	 * Set identity map on non-RAM pages and remap the underlying RAM.
> +	 * Set identity map on non-RAM pages and prepare remapping the
> +	 * underlying RAM.
>  	 */
>  	last_pfn = xen_set_identity_and_remap(map, memmap.nr_entries, max_pfn,
>  					      &xen_released_pages);
> diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
> index 28c7e0b..5b72a06 100644
> --- a/arch/x86/xen/xen-ops.h
> +++ b/arch/x86/xen/xen-ops.h
> @@ -35,6 +35,7 @@ void xen_mm_pin_all(void);
>  void xen_mm_unpin_all(void);
>  void xen_set_pat(u64);
>  
> +void __init xen_remap_memory(void);
>  char * __init xen_memory_setup(void);
>  char * xen_auto_xlated_memory_setup(void);
>  void __init xen_arch_setup(void);
> -- 
> 2.1.2
> 
