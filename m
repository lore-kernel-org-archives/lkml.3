Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab3HUO2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:28:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:51319 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694Ab3HUO2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:28:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,928,1367996400"; 
   d="scan'208";a="366230811"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <alpine.DEB.2.02.1308201716510.25665@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1308201716510.25665@chino.kir.corp.google.com>
Subject: RE: [patch] mm, thp: count thp_fault_fallback anytime thp fault fails
Content-Transfer-Encoding: 7bit
Message-Id: <20130821142817.8EB4BE0090@blue.fi.intel.com>
Date: Wed, 21 Aug 2013 17:28:17 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> Currently, thp_fault_fallback in vmstat only gets incremented if a
> hugepage allocation fails.  If current's memcg hits its limit or the page
> fault handler returns an error, it is incorrectly accounted as a
> successful thp_fault_alloc.
> 
> Count thp_fault_fallback anytime the page fault handler falls back to
> using regular pages and only count thp_fault_alloc when a hugepage has
> actually been faulted.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

It's probably a good idea, but please make the behaviour consistent in
do_huge_pmd_wp_page() and collapse path, otherwise it doesn't make sense.

And please make the patch against mm tree: do_huge_pmd_anonymous_page()
was modified recently.

> ---
>  mm/huge_memory.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -801,7 +801,6 @@ int do_huge_pmd_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
>  			zero_page = get_huge_zero_page();
>  			if (unlikely(!zero_page)) {
>  				pte_free(mm, pgtable);
> -				count_vm_event(THP_FAULT_FALLBACK);
>  				goto out;
>  			}
>  			spin_lock(&mm->page_table_lock);
> @@ -816,11 +815,8 @@ int do_huge_pmd_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
>  		}
>  		page = alloc_hugepage_vma(transparent_hugepage_defrag(vma),
>  					  vma, haddr, numa_node_id(), 0);
> -		if (unlikely(!page)) {
> -			count_vm_event(THP_FAULT_FALLBACK);
> +		if (unlikely(!page))
>  			goto out;
> -		}
> -		count_vm_event(THP_FAULT_ALLOC);
>  		if (unlikely(mem_cgroup_newpage_charge(page, mm, GFP_KERNEL))) {
>  			put_page(page);
>  			goto out;
> @@ -832,9 +828,11 @@ int do_huge_pmd_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
>  			goto out;
>  		}
>  
> +		count_vm_event(THP_FAULT_ALLOC);
>  		return 0;
>  	}
>  out:
> +	count_vm_event(THP_FAULT_FALLBACK);
>  	/*
>  	 * Use __pte_alloc instead of pte_alloc_map, because we can't
>  	 * run pte_offset_map on the pmd, if an huge pmd could

-- 
 Kirill A. Shutemov
