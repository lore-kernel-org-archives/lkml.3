Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbaBPSg4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 13:36:56 -0500
Received: from smtp.citrix.com ([66.165.176.89]:28481 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833AbaBPSgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 13:36:54 -0500
X-IronPort-AV: E=Sophos;i="4.95,856,1384300800"; 
   d="scan'208";a="103000657"
Date: Sun, 16 Feb 2014 18:36:48 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Zoltan Kiss <zoltan.kiss@citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
        Jan Beulich <jbeulich@suse.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH v9] xen/grant-table: Avoid m2p_override during mapping
In-Reply-To: <1392238453-26147-1-git-send-email-zoltan.kiss@citrix.com>
Message-ID: <alpine.DEB.2.02.1402161828380.4307@kaball.uk.xensource.com>
References: <1392238453-26147-1-git-send-email-zoltan.kiss@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Feb 2014, Zoltan Kiss wrote:
> The grant mapping API does m2p_override unnecessarily: only gntdev needs it,
> for blkback and future netback patches it just cause a lock contention, as
> those pages never go to userspace. Therefore this series does the following:
> - the original functions were renamed to __gnttab_[un]map_refs, with a new
>   parameter m2p_override
> - arch specific functions *_foreign_p2m_mapping do everything after the
>   hypercall
> - it cuts out common parts from m2p_*_override functions to
>   *_foreign_p2m_mapping functions
> - gnttab_[un]map_refs are now a wrapper to call __gnttab_[un]map_refs with
>   m2p_override false
> - a new function gnttab_[un]map_refs_userspace provides the old behaviour
> 
> It also removes a stray space from page.h and change ret to 0 if
> XENFEAT_auto_translated_physmap, as that is the only possible return value
> there.
> 
> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
> Original-by: Anthony Liguori <aliguori@amazon.com>
> ---
> v2:
> - move the storing of the old mfn in page->index to gnttab_map_refs
> - move the function header update to a separate patch
> 
> v3:
> - a new approach to retain old behaviour where it needed
> - squash the patches into one
> 
> v4:
> - move out the common bits from m2p* functions, and pass pfn/mfn as parameter
> - clear page->private before doing anything with the page, so m2p_find_override
>   won't race with this
> 
> v5:
> - change return value handling in __gnttab_[un]map_refs
> - remove a stray space in page.h
> - add detail why ret = 0 now at some places
> 
> v6:
> - don't pass pfn to m2p* functions, just get it locally
> 
> v7:
> - the previous version broke build on ARM, as there is no need for those p2m
>   changes. I've put them into arch specific functions, which are stubs on arm
> 
> v8:
> - give credit to Anthony Liguori who submitted a very similar patch originally:
> http://marc.info/?i=1384307336-5328-1-git-send-email-anthony%40codemonkey.ws
> - create ARM stub for get_phys_to_machine
> - move definition of mfn in __gnttab_unmap_refs to the right place
> 
> v9:
> - move everything after the hypercalls into set/clear_foreign_p2m_mapping
> - m2p override functions became unnecessary on ARM therefore
> 
>  arch/arm/include/asm/xen/page.h     |   19 +++---
>  arch/arm/xen/p2m.c                  |   34 ++++++++++
>  arch/x86/include/asm/xen/page.h     |   13 +++-
>  arch/x86/xen/p2m.c                  |  127 ++++++++++++++++++++++++++++++-----
>  drivers/block/xen-blkback/blkback.c |   15 ++---
>  drivers/xen/gntdev.c                |   13 ++--
>  drivers/xen/grant-table.c           |  115 +++++++++++--------------------
>  include/xen/grant_table.h           |    8 ++-
>  8 files changed, 227 insertions(+), 117 deletions(-)
> 
> diff --git a/arch/arm/include/asm/xen/page.h b/arch/arm/include/asm/xen/page.h
> index e0965ab..4eaeb3f 100644
> --- a/arch/arm/include/asm/xen/page.h
> +++ b/arch/arm/include/asm/xen/page.h
> @@ -97,16 +97,15 @@ static inline pte_t *lookup_address(unsigned long address, unsigned int *level)
>  	return NULL;
>  }
>  
> -static inline int m2p_add_override(unsigned long mfn, struct page *page,
> -		struct gnttab_map_grant_ref *kmap_op)
> -{
> -	return 0;
> -}
> -
> -static inline int m2p_remove_override(struct page *page, bool clear_pte)
> -{
> -	return 0;
> -}
> +extern int set_foreign_p2m_mapping(struct gnttab_map_grant_ref *map_ops,
> +				   struct gnttab_map_grant_ref *kmap_ops,
> +				   struct page **pages, unsigned int count,
> +				   bool m2p_override);
> +
> +extern int clear_foreign_p2m_mapping(struct gnttab_unmap_grant_ref *unmap_ops,
> +				     struct gnttab_map_grant_ref *kmap_ops,
> +				     struct page **pages, unsigned int count,
> +				     bool m2p_override);

Much much better.
The only comment I have is about this m2p_override boolean parameter.
m2p_override is now meaningless in this context, what we really want to
let the arch specific implementation know is whether the mapping is a
kernel only mapping or a userspace mapping.
Testing for kmap_ops != NULL might even be enough, but it would not
improve the interface.

Is it possible to realize if the mapping is a userspace mapping by
checking for GNTMAP_application_map in map_ops?
Otherwise I would keep the boolean and rename it to user_mapping.


>  bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn);
>  bool __set_phys_to_machine_multi(unsigned long pfn, unsigned long mfn,
> diff --git a/arch/arm/xen/p2m.c b/arch/arm/xen/p2m.c
> index b31ee1b2..74d977c 100644
> --- a/arch/arm/xen/p2m.c
> +++ b/arch/arm/xen/p2m.c
> @@ -146,6 +146,40 @@ unsigned long __mfn_to_pfn(unsigned long mfn)
>  }
>  EXPORT_SYMBOL_GPL(__mfn_to_pfn);
>  
> +int set_foreign_p2m_mapping(struct gnttab_map_grant_ref *map_ops,
> +			    struct gnttab_map_grant_ref *kmap_ops,
> +			    struct page **pages, unsigned int count,
> +			    bool m2p_override)
> +{
> +	int i;
> +
> +	for (i = 0; i < count; i++) {
> +		if (map_ops[i].status)
> +			continue;
> +		set_phys_to_machine(map_ops[i].host_addr >> PAGE_SHIFT,
> +				    map_ops[i].dev_bus_addr >> PAGE_SHIFT);
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(set_foreign_p2m_mapping);
> +
> +int clear_foreign_p2m_mapping(struct gnttab_unmap_grant_ref *unmap_ops,
> +			      struct gnttab_map_grant_ref *kmap_ops,
> +			      struct page **pages, unsigned int count,
> +			      bool m2p_override)
> +{
> +	int i;
> +
> +	for (i = 0; i < count; i++) {
> +		set_phys_to_machine(unmap_ops[i].host_addr >> PAGE_SHIFT,
> +				    INVALID_P2M_ENTRY);
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(clear_foreign_p2m_mapping);
> +
>  bool __set_phys_to_machine_multi(unsigned long pfn,
>  		unsigned long mfn, unsigned long nr_pages)
>  {
> diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
> index 3e276eb..9edc8a8 100644
> --- a/arch/x86/include/asm/xen/page.h
> +++ b/arch/x86/include/asm/xen/page.h
> @@ -49,10 +49,19 @@ extern bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn);
>  extern unsigned long set_phys_range_identity(unsigned long pfn_s,
>  					     unsigned long pfn_e);
>  
> +extern int set_foreign_p2m_mapping(struct gnttab_map_grant_ref *map_ops,
> +				   struct gnttab_map_grant_ref *kmap_ops,
> +				   struct page **pages, unsigned int count,
> +				   bool m2p_override);
>  extern int m2p_add_override(unsigned long mfn, struct page *page,
>  			    struct gnttab_map_grant_ref *kmap_op);
> +extern int clear_foreign_p2m_mapping(struct gnttab_unmap_grant_ref *unmap_ops,
> +				     struct gnttab_map_grant_ref *kmap_ops,
> +				     struct page **pages, unsigned int count,
> +				     bool m2p_override);
>  extern int m2p_remove_override(struct page *page,
> -				struct gnttab_map_grant_ref *kmap_op);
> +			       struct gnttab_map_grant_ref *kmap_op,
> +			       unsigned long mfn);
>  extern struct page *m2p_find_override(unsigned long mfn);
>  extern unsigned long m2p_find_override_pfn(unsigned long mfn, unsigned long pfn);
>  
> @@ -121,7 +130,7 @@ static inline unsigned long mfn_to_pfn(unsigned long mfn)
>  		pfn = m2p_find_override_pfn(mfn, ~0);
>  	}
>  
> -	/* 
> +	/*
>  	 * pfn is ~0 if there are no entries in the m2p for mfn or if the
>  	 * entry doesn't map back to the mfn and m2p_override doesn't have a
>  	 * valid entry for it.
> diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
> index 696c694..305af27 100644
> --- a/arch/x86/xen/p2m.c
> +++ b/arch/x86/xen/p2m.c
> @@ -881,6 +881,67 @@ static unsigned long mfn_hash(unsigned long mfn)
>  	return hash_long(mfn, M2P_OVERRIDE_HASH_SHIFT);
>  }
>  
> +int set_foreign_p2m_mapping(struct gnttab_map_grant_ref *map_ops,
> +			    struct gnttab_map_grant_ref *kmap_ops,
> +			    struct page **pages, unsigned int count,
> +			    bool m2p_override)
> +{
> +	int i, ret = 0;
> +	bool lazy = false;
> +	pte_t *pte;
> +
> +	if (xen_feature(XENFEAT_auto_translated_physmap))
> +		return 0;
> +
> +	if (m2p_override &&
> +	    !in_interrupt() &&
> +	    paravirt_get_lazy_mode() == PARAVIRT_LAZY_NONE) {
> +		arch_enter_lazy_mmu_mode();
> +		lazy = true;
> +	}
> +
> +	for (i = 0; i < count; i++) {
> +		unsigned long mfn, pfn;
> +
> +		/* Do not add to override if the map failed. */
> +		if (map_ops[i].status)
> +			continue;
> +
> +		if (map_ops[i].flags & GNTMAP_contains_pte) {
> +			pte = (pte_t *) (mfn_to_virt(PFN_DOWN(map_ops[i].host_addr)) +
> +				(map_ops[i].host_addr & ~PAGE_MASK));
> +			mfn = pte_mfn(*pte);
> +		} else {
> +			mfn = PFN_DOWN(map_ops[i].dev_bus_addr);
> +		}
> +		pfn = page_to_pfn(pages[i]);
> +
> +		WARN_ON(PagePrivate(pages[i]));
> +		SetPagePrivate(pages[i]);
> +		set_page_private(pages[i], mfn);
> +		pages[i]->index = pfn_to_mfn(pfn);
> +
> +		if (unlikely(!set_phys_to_machine(pfn, FOREIGN_FRAME(mfn)))) {
> +			ret = -ENOMEM;
> +			goto out;
> +		}
> +
> +		if (m2p_override) {
> +			ret = m2p_add_override(mfn, pages[i], kmap_ops ?
> +					       &kmap_ops[i] : NULL);
> +			if (ret)
> +				goto out;
> +		}
> +	}
> +
> +out:
> +	if (lazy)
> +		arch_leave_lazy_mmu_mode();
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(set_foreign_p2m_mapping);
> +
>  /* Add an MFN override for a particular page */
>  int m2p_add_override(unsigned long mfn, struct page *page,
>  		struct gnttab_map_grant_ref *kmap_op)
> @@ -899,13 +960,6 @@ int m2p_add_override(unsigned long mfn, struct page *page,
>  					"m2p_add_override: pfn %lx not mapped", pfn))
>  			return -EINVAL;
>  	}
> -	WARN_ON(PagePrivate(page));
> -	SetPagePrivate(page);
> -	set_page_private(page, mfn);
> -	page->index = pfn_to_mfn(pfn);
> -
> -	if (unlikely(!set_phys_to_machine(pfn, FOREIGN_FRAME(mfn))))
> -		return -ENOMEM;
>  
>  	if (kmap_op != NULL) {
>  		if (!PageHighMem(page)) {
> @@ -943,20 +997,66 @@ int m2p_add_override(unsigned long mfn, struct page *page,
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(m2p_add_override);
> +
> +int clear_foreign_p2m_mapping(struct gnttab_unmap_grant_ref *unmap_ops,
> +			      struct gnttab_map_grant_ref *kmap_ops,
> +			      struct page **pages, unsigned int count,
> +			      bool m2p_override)
> +{
> +	int i, ret = 0;
> +	bool lazy = false;
> +
> +	if (xen_feature(XENFEAT_auto_translated_physmap))
> +		return 0;
> +
> +	if (m2p_override &&
> +	    !in_interrupt() &&
> +	    paravirt_get_lazy_mode() == PARAVIRT_LAZY_NONE) {
> +		arch_enter_lazy_mmu_mode();
> +		lazy = true;
> +	}
> +
> +	for (i = 0; i < count; i++) {
> +		unsigned long mfn = get_phys_to_machine(page_to_pfn(pages[i]));
> +		unsigned long pfn = page_to_pfn(pages[i]);
> +
> +		if (mfn == INVALID_P2M_ENTRY || !(mfn & FOREIGN_FRAME_BIT)) {
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +
> +		set_page_private(pages[i], INVALID_P2M_ENTRY);
> +		WARN_ON(!PagePrivate(pages[i]));
> +		ClearPagePrivate(pages[i]);
> +		set_phys_to_machine(pfn, pages[i]->index);
> +
> +		if (m2p_override)
> +			ret = m2p_remove_override(pages[i],
> +						  kmap_ops ?
> +						  &kmap_ops[i] : NULL,
> +						  mfn);
> +		if (ret)
> +			goto out;
> +	}
> +
> +out:
> +	if (lazy)
> +		arch_leave_lazy_mmu_mode();
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(clear_foreign_p2m_mapping);
> +
>  int m2p_remove_override(struct page *page,
> -		struct gnttab_map_grant_ref *kmap_op)
> +			struct gnttab_map_grant_ref *kmap_op,
> +			unsigned long mfn)
>  {
>  	unsigned long flags;
> -	unsigned long mfn;
>  	unsigned long pfn;
>  	unsigned long uninitialized_var(address);
>  	unsigned level;
>  	pte_t *ptep = NULL;
>  
>  	pfn = page_to_pfn(page);
> -	mfn = get_phys_to_machine(pfn);
> -	if (mfn == INVALID_P2M_ENTRY || !(mfn & FOREIGN_FRAME_BIT))
> -		return -EINVAL;
>  
>  	if (!PageHighMem(page)) {
>  		address = (unsigned long)__va(pfn << PAGE_SHIFT);
> @@ -970,10 +1070,7 @@ int m2p_remove_override(struct page *page,
>  	spin_lock_irqsave(&m2p_override_lock, flags);
>  	list_del(&page->lru);
>  	spin_unlock_irqrestore(&m2p_override_lock, flags);
> -	WARN_ON(!PagePrivate(page));
> -	ClearPagePrivate(page);
>  
> -	set_phys_to_machine(pfn, page->index);
>  	if (kmap_op != NULL) {
>  		if (!PageHighMem(page)) {
>  			struct multicall_space mcs;
> diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
> index 6620b73..875025f 100644
> --- a/drivers/block/xen-blkback/blkback.c
> +++ b/drivers/block/xen-blkback/blkback.c
> @@ -285,8 +285,7 @@ static void free_persistent_gnts(struct xen_blkif *blkif, struct rb_root *root,
>  
>  		if (++segs_to_unmap == BLKIF_MAX_SEGMENTS_PER_REQUEST ||
>  			!rb_next(&persistent_gnt->node)) {
> -			ret = gnttab_unmap_refs(unmap, NULL, pages,
> -				segs_to_unmap);
> +			ret = gnttab_unmap_refs(unmap, pages, segs_to_unmap);
>  			BUG_ON(ret);
>  			put_free_pages(blkif, pages, segs_to_unmap);
>  			segs_to_unmap = 0;
> @@ -321,8 +320,7 @@ static void unmap_purged_grants(struct work_struct *work)
>  		pages[segs_to_unmap] = persistent_gnt->page;
>  
>  		if (++segs_to_unmap == BLKIF_MAX_SEGMENTS_PER_REQUEST) {
> -			ret = gnttab_unmap_refs(unmap, NULL, pages,
> -				segs_to_unmap);
> +			ret = gnttab_unmap_refs(unmap, pages, segs_to_unmap);
>  			BUG_ON(ret);
>  			put_free_pages(blkif, pages, segs_to_unmap);
>  			segs_to_unmap = 0;
> @@ -330,7 +328,7 @@ static void unmap_purged_grants(struct work_struct *work)
>  		kfree(persistent_gnt);
>  	}
>  	if (segs_to_unmap > 0) {
> -		ret = gnttab_unmap_refs(unmap, NULL, pages, segs_to_unmap);
> +		ret = gnttab_unmap_refs(unmap, pages, segs_to_unmap);
>  		BUG_ON(ret);
>  		put_free_pages(blkif, pages, segs_to_unmap);
>  	}
> @@ -670,15 +668,14 @@ static void xen_blkbk_unmap(struct xen_blkif *blkif,
>  				    GNTMAP_host_map, pages[i]->handle);
>  		pages[i]->handle = BLKBACK_INVALID_HANDLE;
>  		if (++invcount == BLKIF_MAX_SEGMENTS_PER_REQUEST) {
> -			ret = gnttab_unmap_refs(unmap, NULL, unmap_pages,
> -			                        invcount);
> +			ret = gnttab_unmap_refs(unmap, unmap_pages, invcount);
>  			BUG_ON(ret);
>  			put_free_pages(blkif, unmap_pages, invcount);
>  			invcount = 0;
>  		}
>  	}
>  	if (invcount) {
> -		ret = gnttab_unmap_refs(unmap, NULL, unmap_pages, invcount);
> +		ret = gnttab_unmap_refs(unmap, unmap_pages, invcount);
>  		BUG_ON(ret);
>  		put_free_pages(blkif, unmap_pages, invcount);
>  	}
> @@ -740,7 +737,7 @@ again:
>  	}
>  
>  	if (segs_to_map) {
> -		ret = gnttab_map_refs(map, NULL, pages_to_gnt, segs_to_map);
> +		ret = gnttab_map_refs(map, pages_to_gnt, segs_to_map);
>  		BUG_ON(ret);
>  	}
>  
> diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
> index 073b4a1..34a2704 100644
> --- a/drivers/xen/gntdev.c
> +++ b/drivers/xen/gntdev.c
> @@ -284,8 +284,10 @@ static int map_grant_pages(struct grant_map *map)
>  	}
>  
>  	pr_debug("map %d+%d\n", map->index, map->count);
> -	err = gnttab_map_refs(map->map_ops, use_ptemod ? map->kmap_ops : NULL,
> -			map->pages, map->count);
> +	err = gnttab_map_refs_userspace(map->map_ops,
> +					use_ptemod ? map->kmap_ops : NULL,
> +					map->pages,
> +					map->count);
>  	if (err)
>  		return err;
>  
> @@ -315,9 +317,10 @@ static int __unmap_grant_pages(struct grant_map *map, int offset, int pages)
>  		}
>  	}
>  
> -	err = gnttab_unmap_refs(map->unmap_ops + offset,
> -			use_ptemod ? map->kmap_ops + offset : NULL, map->pages + offset,
> -			pages);
> +	err = gnttab_unmap_refs_userspace(map->unmap_ops + offset,
> +					  use_ptemod ? map->kmap_ops + offset : NULL,
> +					  map->pages + offset,
> +					  pages);
>  	if (err)
>  		return err;
>  
> diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> index 1ce1c40..5efacf8 100644
> --- a/drivers/xen/grant-table.c
> +++ b/drivers/xen/grant-table.c
> @@ -928,15 +928,14 @@ void gnttab_batch_copy(struct gnttab_copy *batch, unsigned count)
>  }
>  EXPORT_SYMBOL_GPL(gnttab_batch_copy);
>  
> -int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
> -		    struct gnttab_map_grant_ref *kmap_ops,
> -		    struct page **pages, unsigned int count)
> +static int __gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
> +			     struct gnttab_map_grant_ref *kmap_ops,
> +			     struct page **pages, unsigned int count,
> +			     bool m2p_override)
>  {
>  	int i, ret;
> -	bool lazy = false;
> -	pte_t *pte;
> -	unsigned long mfn;
>  
> +	BUG_ON(kmap_ops && !m2p_override);
>  	ret = HYPERVISOR_grant_table_op(GNTTABOP_map_grant_ref, map_ops, count);
>  	if (ret)
>  		return ret;
> @@ -947,88 +946,56 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
>  			gnttab_retry_eagain_gop(GNTTABOP_map_grant_ref, map_ops + i,
>  						&map_ops[i].status, __func__);
>  
> -	/* this is basically a nop on x86 */
> -	if (xen_feature(XENFEAT_auto_translated_physmap)) {
> -		for (i = 0; i < count; i++) {
> -			if (map_ops[i].status)
> -				continue;
> -			set_phys_to_machine(map_ops[i].host_addr >> PAGE_SHIFT,
> -					map_ops[i].dev_bus_addr >> PAGE_SHIFT);
> -		}
> -		return ret;
> -	}
> -
> -	if (!in_interrupt() && paravirt_get_lazy_mode() == PARAVIRT_LAZY_NONE) {
> -		arch_enter_lazy_mmu_mode();
> -		lazy = true;
> -	}
> -
> -	for (i = 0; i < count; i++) {
> -		/* Do not add to override if the map failed. */
> -		if (map_ops[i].status)
> -			continue;
> -
> -		if (map_ops[i].flags & GNTMAP_contains_pte) {
> -			pte = (pte_t *) (mfn_to_virt(PFN_DOWN(map_ops[i].host_addr)) +
> -				(map_ops[i].host_addr & ~PAGE_MASK));
> -			mfn = pte_mfn(*pte);
> -		} else {
> -			mfn = PFN_DOWN(map_ops[i].dev_bus_addr);
> -		}
> -		ret = m2p_add_override(mfn, pages[i], kmap_ops ?
> -				       &kmap_ops[i] : NULL);
> -		if (ret)
> -			goto out;
> -	}
> -
> - out:
> -	if (lazy)
> -		arch_leave_lazy_mmu_mode();
> +	return set_foreign_p2m_mapping(map_ops, kmap_ops, pages, count,
> +				       m2p_override);
> +}
>  
> -	return ret;
> +int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
> +		    struct page **pages, unsigned int count)
> +{
> +	return __gnttab_map_refs(map_ops, NULL, pages, count, false);
>  }
>  EXPORT_SYMBOL_GPL(gnttab_map_refs);
>  
> -int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
> -		      struct gnttab_map_grant_ref *kmap_ops,
> -		      struct page **pages, unsigned int count)
> +int gnttab_map_refs_userspace(struct gnttab_map_grant_ref *map_ops,
> +			      struct gnttab_map_grant_ref *kmap_ops,
> +			      struct page **pages, unsigned int count)
>  {
> -	int i, ret;
> -	bool lazy = false;
> +	return __gnttab_map_refs(map_ops, kmap_ops, pages, count, true);
> +}
> +EXPORT_SYMBOL_GPL(gnttab_map_refs_userspace);
> +
> +static int __gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
> +			       struct gnttab_map_grant_ref *kmap_ops,
> +			       struct page **pages, unsigned int count,
> +			       bool m2p_override)
> +{
> +	int ret;
>  
> +	BUG_ON(kmap_ops && !m2p_override);
>  	ret = HYPERVISOR_grant_table_op(GNTTABOP_unmap_grant_ref, unmap_ops, count);
>  	if (ret)
>  		return ret;
>  
> -	/* this is basically a nop on x86 */
> -	if (xen_feature(XENFEAT_auto_translated_physmap)) {
> -		for (i = 0; i < count; i++) {
> -			set_phys_to_machine(unmap_ops[i].host_addr >> PAGE_SHIFT,
> -					INVALID_P2M_ENTRY);
> -		}
> -		return ret;
> -	}
> -
> -	if (!in_interrupt() && paravirt_get_lazy_mode() == PARAVIRT_LAZY_NONE) {
> -		arch_enter_lazy_mmu_mode();
> -		lazy = true;
> -	}
> -
> -	for (i = 0; i < count; i++) {
> -		ret = m2p_remove_override(pages[i], kmap_ops ?
> -				       &kmap_ops[i] : NULL);
> -		if (ret)
> -			goto out;
> -	}
> -
> - out:
> -	if (lazy)
> -		arch_leave_lazy_mmu_mode();
> +	return clear_foreign_p2m_mapping(unmap_ops, kmap_ops, pages, count,
> +					 m2p_override);
> +}
>  
> -	return ret;
> +int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *map_ops,
> +		    struct page **pages, unsigned int count)
> +{
> +	return __gnttab_unmap_refs(map_ops, NULL, pages, count, false);
>  }
>  EXPORT_SYMBOL_GPL(gnttab_unmap_refs);
>  
> +int gnttab_unmap_refs_userspace(struct gnttab_unmap_grant_ref *map_ops,
> +				struct gnttab_map_grant_ref *kmap_ops,
> +				struct page **pages, unsigned int count)
> +{
> +	return __gnttab_unmap_refs(map_ops, kmap_ops, pages, count, true);
> +}
> +EXPORT_SYMBOL_GPL(gnttab_unmap_refs_userspace);
> +
>  static unsigned nr_status_frames(unsigned nr_grant_frames)
>  {
>  	BUG_ON(grefs_per_grant_frame == 0);
> diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
> index 5acb1e4..2541c96 100644
> --- a/include/xen/grant_table.h
> +++ b/include/xen/grant_table.h
> @@ -191,11 +191,15 @@ void gnttab_free_auto_xlat_frames(void);
>  #define gnttab_map_vaddr(map) ((void *)(map.host_virt_addr))
>  
>  int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
> -		    struct gnttab_map_grant_ref *kmap_ops,
>  		    struct page **pages, unsigned int count);
> +int gnttab_map_refs_userspace(struct gnttab_map_grant_ref *map_ops,
> +			      struct gnttab_map_grant_ref *kmap_ops,
> +			      struct page **pages, unsigned int count);
>  int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
> -		      struct gnttab_map_grant_ref *kunmap_ops,
>  		      struct page **pages, unsigned int count);
> +int gnttab_unmap_refs_userspace(struct gnttab_unmap_grant_ref *unmap_ops,
> +				struct gnttab_map_grant_ref *kunmap_ops,
> +				struct page **pages, unsigned int count);
>  
>  /* Perform a batch of grant map/copy operations. Retry every batch slot
>   * for which the hypervisor returns GNTST_eagain. This is typically due
> 
