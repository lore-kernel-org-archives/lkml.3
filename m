Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab3HZNJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 09:09:50 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:37619 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493Ab3HZNJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 09:09:48 -0400
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
Subject: Re: [PATCH v2 13/20] mm, hugetlb: mm, hugetlb: unify chg and avoid_reserve to use_reserve
In-Reply-To: <1376040398-11212-14-git-send-email-iamjoonsoo.kim@lge.com>
References: <1376040398-11212-1-git-send-email-iamjoonsoo.kim@lge.com> <1376040398-11212-14-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.15.2+167~g5306b2b (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Mon, 26 Aug 2013 18:39:35 +0530
Message-ID: <87y57od2eo.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082612-1618-0000-0000-000004841D82
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:

> Currently, we have two variable to represent whether we can use reserved
> page or not, chg and avoid_reserve, respectively. With aggregating these,
> we can have more clean code. This makes no functinoal difference.
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 22ceb04..8dff972 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -531,8 +531,7 @@ static struct page *dequeue_huge_page_node(struct hstate *h, int nid)
>
>  static struct page *dequeue_huge_page_vma(struct hstate *h,
>  				struct vm_area_struct *vma,
> -				unsigned long address, int avoid_reserve,
> -				long chg)
> +				unsigned long address, bool use_reserve)
>  {
>  	struct page *page = NULL;
>  	struct mempolicy *mpol;
> @@ -546,12 +545,10 @@ static struct page *dequeue_huge_page_vma(struct hstate *h,
>  	 * A child process with MAP_PRIVATE mappings created by their parent
>  	 * have no page reserves. This check ensures that reservations are
>  	 * not "stolen". The child may still get SIGKILLed
> +	 * Or, when parent process do COW, we cannot use reserved page.
> +	 * In this case, ensure enough pages are in the pool.
>  	 */
> -	if (chg && h->free_huge_pages - h->resv_huge_pages == 0)
> -		return NULL;

This hunk would be much easier if you were changing. 

	if (!vma_has_reserves(vma) &&
			h->free_huge_pages - h->resv_huge_pages == 0)
		goto err;

ie, !vma_has_reserves(vma) == !use_reserve.

So may be a patch rearragment would help ?. But neverthless. 

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

> -
> -	/* If reserves cannot be used, ensure enough pages are in the pool */
> -	if (avoid_reserve && h->free_huge_pages - h->resv_huge_pages == 0)
> +	if (!use_reserve && h->free_huge_pages - h->resv_huge_pages == 0)
>  		return NULL;



>
>  retry_cpuset:
> @@ -564,9 +561,7 @@ retry_cpuset:
>  		if (cpuset_zone_allowed_softwall(zone, htlb_alloc_mask)) {
>  			page = dequeue_huge_page_node(h, zone_to_nid(zone));
>  			if (page) {
> -				if (avoid_reserve)
> -					break;
> -				if (chg)
> +				if (!use_reserve)
>  					break;
>
>  				SetPagePrivate(page);
> @@ -1121,6 +1116,7 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
>  	struct hstate *h = hstate_vma(vma);
>  	struct page *page;
>  	long chg;
> +	bool use_reserve;
>  	int ret, idx;
>  	struct hugetlb_cgroup *h_cg;
>
> @@ -1136,18 +1132,19 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
>  	chg = vma_needs_reservation(h, vma, addr);
>  	if (chg < 0)
>  		return ERR_PTR(-ENOMEM);
> -	if (chg || avoid_reserve)
> +	use_reserve = (!chg && !avoid_reserve);
> +	if (!use_reserve)
>  		if (hugepage_subpool_get_pages(spool, 1))
>  			return ERR_PTR(-ENOSPC);
>
>  	ret = hugetlb_cgroup_charge_cgroup(idx, pages_per_huge_page(h), &h_cg);
>  	if (ret) {
> -		if (chg || avoid_reserve)
> +		if (!use_reserve)
>  			hugepage_subpool_put_pages(spool, 1);
>  		return ERR_PTR(-ENOSPC);
>  	}
>  	spin_lock(&hugetlb_lock);
> -	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve, chg);
> +	page = dequeue_huge_page_vma(h, vma, addr, use_reserve);
>  	if (!page) {
>  		spin_unlock(&hugetlb_lock);
>  		page = alloc_buddy_huge_page(h, NUMA_NO_NODE);
> @@ -1155,7 +1152,7 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
>  			hugetlb_cgroup_uncharge_cgroup(idx,
>  						       pages_per_huge_page(h),
>  						       h_cg);
> -			if (chg || avoid_reserve)
> +			if (!use_reserve)
>  				hugepage_subpool_put_pages(spool, 1);
>  			return ERR_PTR(-ENOSPC);
>  		}
> -- 
> 1.7.9.5

