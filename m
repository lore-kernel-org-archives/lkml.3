Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab3GOOvI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:51:08 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:43604 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757454Ab3GOOvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:51:05 -0400
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
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH 8/9] mm, hugetlb: remove decrement_hugepage_resv_vma()
In-Reply-To: <1373881967-16153-9-git-send-email-iamjoonsoo.kim@lge.com>
References: <1373881967-16153-1-git-send-email-iamjoonsoo.kim@lge.com> <1373881967-16153-9-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.15.2+167~g5306b2b (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Mon, 15 Jul 2013 20:20:47 +0530
Message-ID: <87ppujj2rc.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071514-5140-0000-0000-0000038544DA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:

> Now, Checking condition of decrement_hugepage_resv_vma() and
> vma_has_reserves() is same, so we can clean-up this function with
> vma_has_reserves(). Additionally, decrement_hugepage_resv_vma() has only
> one call site, so we can remove function and embed it into
> dequeue_huge_page_vma() directly. This patch implement it.
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index f6a7a4e..ed2d0af 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -434,25 +434,6 @@ static int is_vma_resv_set(struct vm_area_struct *vma, unsigned long flag)
>  	return (get_vma_private_data(vma) & flag) != 0;
>  }
>
> -/* Decrement the reserved pages in the hugepage pool by one */
> -static void decrement_hugepage_resv_vma(struct hstate *h,
> -			struct vm_area_struct *vma)
> -{
> -	if (vma->vm_flags & VM_NORESERVE)
> -		return;
> -
> -	if (vma->vm_flags & VM_MAYSHARE) {
> -		/* Shared mappings always use reserves */
> -		h->resv_huge_pages--;
> -	} else if (is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
> -		/*
> -		 * Only the process that called mmap() has reserves for
> -		 * private mappings.
> -		 */
> -		h->resv_huge_pages--;
> -	}
> -}
> -
>  /* Reset counters to 0 and clear all HPAGE_RESV_* flags */
>  void reset_vma_resv_huge_pages(struct vm_area_struct *vma)
>  {
> @@ -466,10 +447,18 @@ static int vma_has_reserves(struct vm_area_struct *vma)
>  {
>  	if (vma->vm_flags & VM_NORESERVE)
>  		return 0;
> +
> +	/* Shared mappings always use reserves */
>  	if (vma->vm_flags & VM_MAYSHARE)
>  		return 1;
> +
> +	/*
> +	 * Only the process that called mmap() has reserves for
> +	 * private mappings.
> +	 */
>  	if (is_vma_resv_set(vma, HPAGE_RESV_OWNER))
>  		return 1;
> +
>  	return 0;
>  }
>
> @@ -564,8 +553,8 @@ retry_cpuset:
>  		if (cpuset_zone_allowed_softwall(zone, htlb_alloc_mask)) {
>  			page = dequeue_huge_page_node(h, zone_to_nid(zone));
>  			if (page) {
> -				if (!avoid_reserve)
> -					decrement_hugepage_resv_vma(h, vma);
> +				if (!avoid_reserve && vma_has_reserves(vma))
> +					h->resv_huge_pages--;
>  				break;
>  			}
>  		}
> -- 
> 1.7.9.5

