Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab3HUJye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 05:54:34 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:47976 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab3HUJyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 05:54:32 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v2 06/20] mm, hugetlb: return a reserved page to a reserved pool if failed
In-Reply-To: <1376040398-11212-7-git-send-email-iamjoonsoo.kim@lge.com>
References: <1376040398-11212-1-git-send-email-iamjoonsoo.kim@lge.com> <1376040398-11212-7-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.15.2+167~g5306b2b (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Wed, 21 Aug 2013 15:24:13 +0530
Message-ID: <87mwobgyii.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082109-1396-0000-0000-0000036F6A02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:

> If we fail with a reserved page, just calling put_page() is not sufficient,
> because put_page() invoke free_huge_page() at last step and it doesn't
> know whether a page comes from a reserved pool or not. So it doesn't do
> anything related to reserved count. This makes reserve count lower
> than how we need, because reserve count already decrease in
> dequeue_huge_page_vma(). This patch fix this situation.

You may want to document you are using PagePrivate for tracking
reservation and why it is ok to that.

>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 6c8eec2..3f834f1 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -572,6 +572,7 @@ retry_cpuset:
>  				if (!vma_has_reserves(vma, chg))
>  					break;
>
> +				SetPagePrivate(page);
>  				h->resv_huge_pages--;
>  				break;
>  			}
> @@ -626,15 +627,20 @@ static void free_huge_page(struct page *page)
>  	int nid = page_to_nid(page);
>  	struct hugepage_subpool *spool =
>  		(struct hugepage_subpool *)page_private(page);
> +	bool restore_reserve;
>
>  	set_page_private(page, 0);
>  	page->mapping = NULL;
>  	BUG_ON(page_count(page));
>  	BUG_ON(page_mapcount(page));
> +	restore_reserve = PagePrivate(page);
>
>  	spin_lock(&hugetlb_lock);
>  	hugetlb_cgroup_uncharge_page(hstate_index(h),
>  				     pages_per_huge_page(h), page);
> +	if (restore_reserve)
> +		h->resv_huge_pages++;
> +
>  	if (h->surplus_huge_pages_node[nid] && huge_page_order(h) < MAX_ORDER) {
>  		/* remove the page from active list */
>  		list_del(&page->lru);
> @@ -2616,6 +2622,8 @@ retry_avoidcopy:
>  	spin_lock(&mm->page_table_lock);
>  	ptep = huge_pte_offset(mm, address & huge_page_mask(h));
>  	if (likely(pte_same(huge_ptep_get(ptep), pte))) {
> +		ClearPagePrivate(new_page);
> +
>  		/* Break COW */
>  		huge_ptep_clear_flush(vma, address, ptep);
>  		set_huge_pte_at(mm, address, ptep,
> @@ -2727,6 +2735,7 @@ retry:
>  					goto retry;
>  				goto out;
>  			}
> +			ClearPagePrivate(page);
>
>  			spin_lock(&inode->i_lock);
>  			inode->i_blocks += blocks_per_huge_page(h);
> @@ -2773,8 +2782,10 @@ retry:
>  	if (!huge_pte_none(huge_ptep_get(ptep)))
>  		goto backout;
>
> -	if (anon_rmap)
> +	if (anon_rmap) {
> +		ClearPagePrivate(page);
>  		hugepage_add_new_anon_rmap(page, vma, address);
> +	}
>  	else
>  		page_dup_rmap(page);
>  	new_pte = make_huge_pte(vma, page, ((vma->vm_flags & VM_WRITE)
> -- 
> 1.7.9.5

