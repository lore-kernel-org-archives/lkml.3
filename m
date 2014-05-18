Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378AbaERXqA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 19:46:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:50356 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152AbaERXp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 19:45:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,864,1392192000"; 
   d="scan'208";a="513623306"
Date: Sun, 18 May 2014 19:45:59 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, dave@sr71.net, riel@redhat.com, mgorman@suse.de,
        aarcange@redhat.com
Subject: Re: [RFC, PATCH] mm: unified interface to handle page table entries
 on different levels?
Message-ID: <20140518234559.GG6121@linux.intel.com>
References: <1400286785-26639-1-git-send-email-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400286785-26639-1-git-send-email-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2014 at 03:33:05AM +0300, Kirill A. Shutemov wrote:
> Below is my attempt to play with the problem. I've took one function --
> page_referenced_one() -- which looks ugly because of different APIs for
> PTE/PMD and convert it to use vpte_t. vpte_t is union for pte_t, pmd_t
> and pud_t.
> 
> Basically, the idea is instead of having different helpers to handle
> PTE/PMD/PUD, we have one, which take pair of vpte_t + pglevel.

I can't find my original attempt at this now (I am lost in a maze of
twisted git trees, all subtly different), but I called it a vpe (Virtual
Page Entry).

Rather than using a pair of vpte_t and pglevel, the vpe_t contained
enough information to discern what level it was; that's only two bits
and I think all the architectures have enough space to squeeze in two
more bits to the PTE (the PMD and PUD obviously have plenty of space).

> +static inline unsigned long vpte_size(vpte_t vptep, enum ptlevel ptlvl)
> +{
> +	switch (ptlvl) {
> +	case PTE:
> +		return PAGE_SIZE;
> +#ifdef PMD_SIZE
> +	case PMD:
> +		return PMD_SIZE;
> +#endif
> +#ifdef PUD_SIZE
> +	case PUD:
> +		return PUD_SIZE;
> +#endif
> +	default:
> +		return 0; /* XXX */

As you say, XXX.  This needs to be an error ... perhaps VM_BUG_ON(1)
in this case?

> @@ -676,59 +676,39 @@ int page_referenced_one(struct page *page, struct vm_area_struct *vma,
>  	spinlock_t *ptl;
>  	int referenced = 0;
>  	struct page_referenced_arg *pra = arg;
> +	vpte_t *vpte;
> +	enum ptlevel ptlvl = PTE;
>  
> -	if (unlikely(PageTransHuge(page))) {
> -		pmd_t *pmd;
> +	ptlvl = unlikely(PageTransHuge(page)) ? PMD : PTE;
>  
> -		/*
> -		 * rmap might return false positives; we must filter
> -		 * these out using page_check_address_pmd().
> -		 */
> -		pmd = page_check_address_pmd(page, mm, address,
> -					     PAGE_CHECK_ADDRESS_PMD_FLAG, &ptl);
> -		if (!pmd)
> -			return SWAP_AGAIN;
> -
> -		if (vma->vm_flags & VM_LOCKED) {
> -			spin_unlock(ptl);
> -			pra->vm_flags |= VM_LOCKED;
> -			return SWAP_FAIL; /* To break the loop */
> -		}
> +	/*
> +	 * rmap might return false positives; we must filter these out using
> +	 * page_check_address_vpte().
> +	 */
> +	vpte = page_check_address_vpte(page, mm, address, &ptl, 0);
> +	if (!vpte)
> +		return SWAP_AGAIN;
> +
> +	if (vma->vm_flags & VM_LOCKED) {
> +		vpte_unmap_unlock(vpte, ptlvl, ptl);
> +		pra->vm_flags |= VM_LOCKED;
> +		return SWAP_FAIL; /* To break the loop */
> +	}
>  
> -		/* go ahead even if the pmd is pmd_trans_splitting() */
> -		if (pmdp_clear_flush_young_notify(vma, address, pmd))
> -			referenced++;
> -		spin_unlock(ptl);
> -	} else {
> -		pte_t *pte;
>  
> +	/* go ahead even if the pmd is pmd_trans_splitting() */
> +	if (vptep_clear_flush_young_notify(vma, address, vpte, ptlvl)) {
>  		/*
> -		 * rmap might return false positives; we must filter
> -		 * these out using page_check_address().
> +		 * Don't treat a reference through a sequentially read
> +		 * mapping as such.  If the page has been used in
> +		 * another mapping, we will catch it; if this other
> +		 * mapping is already gone, the unmap path will have
> +		 * set PG_referenced or activated the page.
>  		 */
> -		pte = page_check_address(page, mm, address, &ptl, 0);
> -		if (!pte)
> -			return SWAP_AGAIN;
> -
> -		if (vma->vm_flags & VM_LOCKED) {
> -			pte_unmap_unlock(pte, ptl);
> -			pra->vm_flags |= VM_LOCKED;
> -			return SWAP_FAIL; /* To break the loop */
> -		}
> -
> -		if (ptep_clear_flush_young_notify(vma, address, pte)) {
> -			/*
> -			 * Don't treat a reference through a sequentially read
> -			 * mapping as such.  If the page has been used in
> -			 * another mapping, we will catch it; if this other
> -			 * mapping is already gone, the unmap path will have
> -			 * set PG_referenced or activated the page.
> -			 */
> -			if (likely(!(vma->vm_flags & VM_SEQ_READ)))
> -				referenced++;
> -		}
> -		pte_unmap_unlock(pte, ptl);
> +		if (likely(!(vma->vm_flags & VM_SEQ_READ)))
> +			referenced++;
>  	}
> +	vpte_unmap_unlock(vpte, ptlvl, ptl);
>  
>  	if (referenced) {
>  		pra->referenced++;
> -- 
> 2.0.0.rc2
