Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085AbaGVXKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 19:10:19 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:60937 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978AbaGVXKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 19:10:17 -0400
Date: Tue, 22 Jul 2014 16:08:32 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Kamal Mostafa <kamal@canonical.com>
cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3.8 107/116] hugetlb: fix copy_hugetlb_page_range() to
 handle migration/hwpoisoned entry
In-Reply-To: <1406067727-19683-108-git-send-email-kamal@canonical.com>
Message-ID: <alpine.LSU.2.11.1407221608040.3128@eggly.anvils>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com> <1406067727-19683-108-git-send-email-kamal@canonical.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2014, Kamal Mostafa wrote:

> 3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> 
> commit 4a705fef986231a3e7a6b1a6d3c37025f021f49f upstream.
> 
> There's a race between fork() and hugepage migration, as a result we try
> to "dereference" a swap entry as a normal pte, causing kernel panic.
> The cause of the problem is that copy_hugetlb_page_range() can't handle
> "swap entry" family (migration entry and hwpoisoned entry) so let's fix
> it.
> 
> [akpm@linux-foundation.org: coding-style fixes]
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Acked-by: Hugh Dickins <hughd@google.com>
> Cc: Christoph Lameter <cl@linux.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Kamal Mostafa <kamal@canonical.com>

Please drop this one for now: other -stables have carried it, but it
was found last week to contain a bug of its own, arguably worse than
what it's fixing.  Naoya-san has done the fix for that, it's in mmotm
and should make its way to Linus probably this week: so please hold
this back until that can join it - thanks.

Hugh

> ---
>  mm/hugetlb.c | 71 ++++++++++++++++++++++++++++++++++++------------------------
>  1 file changed, 43 insertions(+), 28 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 35fc5eb..7b180d7 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2291,6 +2291,31 @@ static void set_huge_ptep_writable(struct vm_area_struct *vma,
>  		update_mmu_cache(vma, address, ptep);
>  }
>  
> +static int is_hugetlb_entry_migration(pte_t pte)
> +{
> +	swp_entry_t swp;
> +
> +	if (huge_pte_none(pte) || pte_present(pte))
> +		return 0;
> +	swp = pte_to_swp_entry(pte);
> +	if (non_swap_entry(swp) && is_migration_entry(swp))
> +		return 1;
> +	else
> +		return 0;
> +}
> +
> +static int is_hugetlb_entry_hwpoisoned(pte_t pte)
> +{
> +	swp_entry_t swp;
> +
> +	if (huge_pte_none(pte) || pte_present(pte))
> +		return 0;
> +	swp = pte_to_swp_entry(pte);
> +	if (non_swap_entry(swp) && is_hwpoison_entry(swp))
> +		return 1;
> +	else
> +		return 0;
> +}
>  
>  int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
>  			    struct vm_area_struct *vma)
> @@ -2318,10 +2343,26 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
>  
>  		spin_lock(&dst->page_table_lock);
>  		spin_lock_nested(&src->page_table_lock, SINGLE_DEPTH_NESTING);
> -		if (!huge_pte_none(huge_ptep_get(src_pte))) {
> +		entry = huge_ptep_get(src_pte);
> +		if (huge_pte_none(entry)) { /* skip none entry */
> +			;
> +		} else if (unlikely(is_hugetlb_entry_migration(entry) ||
> +				    is_hugetlb_entry_hwpoisoned(entry))) {
> +			swp_entry_t swp_entry = pte_to_swp_entry(entry);
> +
> +			if (is_write_migration_entry(swp_entry) && cow) {
> +				/*
> +				 * COW mappings require pages in both
> +				 * parent and child to be set to read.
> +				 */
> +				make_migration_entry_read(&swp_entry);
> +				entry = swp_entry_to_pte(swp_entry);
> +				set_huge_pte_at(src, addr, src_pte, entry);
> +			}
> +			set_huge_pte_at(dst, addr, dst_pte, entry);
> +		} else {
>  			if (cow)
>  				huge_ptep_set_wrprotect(src, addr, src_pte);
> -			entry = huge_ptep_get(src_pte);
>  			ptepage = pte_page(entry);
>  			get_page(ptepage);
>  			page_dup_rmap(ptepage);
> @@ -2336,32 +2377,6 @@ nomem:
>  	return -ENOMEM;
>  }
>  
> -static int is_hugetlb_entry_migration(pte_t pte)
> -{
> -	swp_entry_t swp;
> -
> -	if (huge_pte_none(pte) || pte_present(pte))
> -		return 0;
> -	swp = pte_to_swp_entry(pte);
> -	if (non_swap_entry(swp) && is_migration_entry(swp))
> -		return 1;
> -	else
> -		return 0;
> -}
> -
> -static int is_hugetlb_entry_hwpoisoned(pte_t pte)
> -{
> -	swp_entry_t swp;
> -
> -	if (huge_pte_none(pte) || pte_present(pte))
> -		return 0;
> -	swp = pte_to_swp_entry(pte);
> -	if (non_swap_entry(swp) && is_hwpoison_entry(swp))
> -		return 1;
> -	else
> -		return 0;
> -}
> -
>  void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  			    unsigned long start, unsigned long end,
>  			    struct page *ref_page)
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
