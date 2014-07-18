Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945974AbaGRSyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 14:54:53 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:57121 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422845AbaGRSyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 14:54:51 -0400
Date: Fri, 18 Jul 2014 11:53:06 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Jiri Slaby <jslaby@suse.cz>
cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3.12 100/170] hugetlb: fix copy_hugetlb_page_range() to
 handle migration/hwpoisoned entry
In-Reply-To: <c56d55d645be041c808e1dc363a4ebbe5228025a.1405685481.git.jslaby@suse.cz>
Message-ID: <alpine.LSU.2.11.1407181146250.3308@eggly.anvils>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz> <c56d55d645be041c808e1dc363a4ebbe5228025a.1405685481.git.jslaby@suse.cz>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2014, Jiri Slaby wrote:

> From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> 
> 3.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ===============
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
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>

Please drop this one for now: other -stables have carried it, but it
was found yesterday to contain a bug of its own, arguably worse than
what it's fixing.  Naoya-san has done the fix for that, it's in mmotm
and should make its way to Linus probably next week: so please hold
this back until that can join it - thanks.

Hugh

> ---
>  mm/hugetlb.c | 71 ++++++++++++++++++++++++++++++++++++------------------------
>  1 file changed, 43 insertions(+), 28 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 92e103b72dcb..11c2b7fed052 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2381,6 +2381,31 @@ static void set_huge_ptep_writable(struct vm_area_struct *vma,
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
> @@ -2408,10 +2433,26 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
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
> @@ -2426,32 +2467,6 @@ nomem:
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
> 2.0.0
