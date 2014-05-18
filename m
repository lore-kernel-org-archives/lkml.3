Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaERR1i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 13:27:38 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:45713 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbaERR1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 13:27:37 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Jianyu Zhan <nasa4836@gmail.com>, akpm@linux-foundation.org,
        iamjoonsoo.kim@lge.com, n-horiguchi@ah.jp.nec.com, mhocko@suse.cz,
        aarcange@redhat.com, steve.capper@linaro.org, davidlohr@hp.com,
        kirill.shutemov@linux.intel.com, dave.hansen@linux.intel.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, nasa4836@gmail.com
Subject: Re: [PATCH] mm, hugetlb: move the error handle logic out of normal code path
In-Reply-To: <1400051459-20578-1-git-send-email-nasa4836@gmail.com>
References: <1400051459-20578-1-git-send-email-nasa4836@gmail.com>
User-Agent: Notmuch/0.18~rc0+2~gbc64cdc (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Sun, 18 May 2014 22:57:16 +0530
Message-ID: <87oayvngjv.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051817-1396-0000-0000-000004DC6E5B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jianyu Zhan <nasa4836@gmail.com> writes:

> alloc_huge_page() now mixes normal code path with error handle logic.
> This patches move out the error handle logic, to make normal code
> path more clean and redue code duplicate.
>
> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

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
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

