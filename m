Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013Ab3GOOBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:01:45 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:44322 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab3GOOBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:01:43 -0400
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
Subject: Re: [PATCH 1/9] mm, hugetlb: move up the code which check availability of free huge page
In-Reply-To: <1373881967-16153-2-git-send-email-iamjoonsoo.kim@lge.com>
References: <1373881967-16153-1-git-send-email-iamjoonsoo.kim@lge.com> <1373881967-16153-2-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.15.2+167~g5306b2b (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Mon, 15 Jul 2013 19:31:33 +0530
Message-ID: <87a9lnkjlu.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071513-5140-0000-0000-000003853A43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:

> We don't need to proceede the processing if we don't have any usable
> free huge page. So move this code up.

I guess you can also mention that since we are holding hugetlb_lock
hstate values can't change.


Also.

>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index e2bfbf7..d87f70b 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -539,10 +539,6 @@ static struct page *dequeue_huge_page_vma(struct hstate *h,
>  	struct zoneref *z;
>  	unsigned int cpuset_mems_cookie;
>
> -retry_cpuset:
> -	cpuset_mems_cookie = get_mems_allowed();
> -	zonelist = huge_zonelist(vma, address,
> -					htlb_alloc_mask, &mpol, &nodemask);
>  	/*
>  	 * A child process with MAP_PRIVATE mappings created by their parent
>  	 * have no page reserves. This check ensures that reservations are
> @@ -550,11 +546,16 @@ retry_cpuset:
>  	 */
>  	if (!vma_has_reserves(vma) &&
>  			h->free_huge_pages - h->resv_huge_pages == 0)
> -		goto err;
> +		return NULL;
>

If you don't do the above change, the patch will be much simpler. 


>  	/* If reserves cannot be used, ensure enough pages are in the pool */
>  	if (avoid_reserve && h->free_huge_pages - h->resv_huge_pages == 0)
> -		goto err;
> +		return NULL;
> +

Same here. 

> +retry_cpuset:
> +	cpuset_mems_cookie = get_mems_allowed();
> +	zonelist = huge_zonelist(vma, address,
> +					htlb_alloc_mask, &mpol, &nodemask);
>
>  	for_each_zone_zonelist_nodemask(zone, z, zonelist,
>  						MAX_NR_ZONES - 1, nodemask) {
> @@ -572,10 +573,6 @@ retry_cpuset:
>  	if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
>  		goto retry_cpuset;
>  	return page;
> -
> -err:
> -	mpol_cond_put(mpol);
> -	return NULL;
>  }
>
>  static void update_and_free_page(struct hstate *h, struct page *page)

-aneesh

