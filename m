Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbaEOJBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 05:01:49 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:32869 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbaEOJBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 05:01:46 -0400
Date: Thu, 15 May 2014 11:01:42 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com,
        aneesh.kumar@linux.vnet.ibm.com, n-horiguchi@ah.jp.nec.com,
        aarcange@redhat.com, steve.capper@linaro.org, davidlohr@hp.com,
        kirill.shutemov@linux.intel.com, dave.hansen@linux.intel.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm, hugetlb: move the error handle logic out of normal
 code path
Message-ID: <20140515090142.GB3938@dhcp22.suse.cz>
References: <1400051459-20578-1-git-send-email-nasa4836@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400051459-20578-1-git-send-email-nasa4836@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 14-05-14 15:10:59, Jianyu Zhan wrote:
> alloc_huge_page() now mixes normal code path with error handle logic.
> This patches move out the error handle logic, to make normal code
> path more clean and redue code duplicate.

I don't know. Part of the function returns and cleans up on its own and
other part relies on clean up labels. This is not so much nicer than the
previous state.

> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
> ---
>  mm/hugetlb.c | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 26b1464..e81c69e 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1246,24 +1246,17 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
>  			return ERR_PTR(-ENOSPC);
>  
>  	ret = hugetlb_cgroup_charge_cgroup(idx, pages_per_huge_page(h), &h_cg);
> -	if (ret) {
> -		if (chg || avoid_reserve)
> -			hugepage_subpool_put_pages(spool, 1);
> -		return ERR_PTR(-ENOSPC);
> -	}
> +	if (ret)
> +		goto out_subpool_put;
> +
>  	spin_lock(&hugetlb_lock);
>  	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve, chg);
>  	if (!page) {
>  		spin_unlock(&hugetlb_lock);
>  		page = alloc_buddy_huge_page(h, NUMA_NO_NODE);
> -		if (!page) {
> -			hugetlb_cgroup_uncharge_cgroup(idx,
> -						       pages_per_huge_page(h),
> -						       h_cg);
> -			if (chg || avoid_reserve)
> -				hugepage_subpool_put_pages(spool, 1);
> -			return ERR_PTR(-ENOSPC);
> -		}
> +		if (!page)
> +			goto out_uncharge_cgroup;
> +
>  		spin_lock(&hugetlb_lock);
>  		list_move(&page->lru, &h->hugepage_activelist);
>  		/* Fall through */
> @@ -1275,6 +1268,13 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
>  
>  	vma_commit_reservation(h, vma, addr);
>  	return page;
> +
> +out_uncharge_cgroup:
> +	hugetlb_cgroup_uncharge_cgroup(idx, pages_per_huge_page(h), h_cg);
> +out_subpool_put:
> +	if (chg || avoid_reserve)
> +		hugepage_subpool_put_pages(spool, 1);
> +	return ERR_PTR(-ENOSPC);
>  }
>  
>  /*
> -- 
> 2.0.0-rc3
> 

-- 
Michal Hocko
SUSE Labs
