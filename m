Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab3HUJ2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 05:28:42 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:54867 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab3HUJ2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 05:28:40 -0400
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
Subject: Re: [PATCH v2 03/20] mm, hugetlb: fix subpool accounting handling
In-Reply-To: <1376040398-11212-4-git-send-email-iamjoonsoo.kim@lge.com>
References: <1376040398-11212-1-git-send-email-iamjoonsoo.kim@lge.com> <1376040398-11212-4-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.15.2+167~g5306b2b (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Wed, 21 Aug 2013 14:58:20 +0530
Message-ID: <87vc2zgzpn.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082109-9264-0000-0000-0000045DD9EE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:

> If we alloc hugepage with avoid_reserve, we don't dequeue reserved one.
> So, we should check subpool counter when avoid_reserve.
> This patch implement it.

Can you explain this better ? ie, if we don't have a reservation in the
area chg != 0. So why look at avoid_reserve. 

Also the code will become if you did

if (!chg && avoid_reserve)
   chg = 1;

and then rest of the code will be able to handle the case.

>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 12b6581..ea1ae0a 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1144,13 +1144,14 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
>  	chg = vma_needs_reservation(h, vma, addr);
>  	if (chg < 0)
>  		return ERR_PTR(-ENOMEM);
> -	if (chg)
> -		if (hugepage_subpool_get_pages(spool, chg))
> +	if (chg || avoid_reserve)
> +		if (hugepage_subpool_get_pages(spool, 1))
>  			return ERR_PTR(-ENOSPC);
>
>  	ret = hugetlb_cgroup_charge_cgroup(idx, pages_per_huge_page(h), &h_cg);
>  	if (ret) {
> -		hugepage_subpool_put_pages(spool, chg);
> +		if (chg || avoid_reserve)
> +			hugepage_subpool_put_pages(spool, 1);
>  		return ERR_PTR(-ENOSPC);
>  	}
>  	spin_lock(&hugetlb_lock);
> @@ -1162,7 +1163,8 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
>  			hugetlb_cgroup_uncharge_cgroup(idx,
>  						       pages_per_huge_page(h),
>  						       h_cg);
> -			hugepage_subpool_put_pages(spool, chg);
> +			if (chg || avoid_reserve)
> +				hugepage_subpool_put_pages(spool, 1);
>  			return ERR_PTR(-ENOSPC);
>  		}
>  		spin_lock(&hugetlb_lock);
> -- 
> 1.7.9.5

