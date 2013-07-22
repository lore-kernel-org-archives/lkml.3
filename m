Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab3GVOpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 10:45:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55892 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756196Ab3GVOpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 10:45:53 -0400
Date: Mon, 22 Jul 2013 16:45:48 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH 1/9] mm, hugetlb: move up the code which check
 availability of free huge page
Message-ID: <20130722144548.GD24400@dhcp22.suse.cz>
References: <1373881967-16153-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1373881967-16153-2-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373881967-16153-2-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 15-07-13 18:52:39, Joonsoo Kim wrote:
> We don't need to proceede the processing if we don't have any usable
> free huge page. So move this code up.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Acked-by: Michal Hocko <mhocko@suse.cz>

after you add a note about hugetlb_lock which stabilizes hstate so the
retry doesn't have to re-check reserves and other stuff as suggested by
Aneesh.

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
>  	/* If reserves cannot be used, ensure enough pages are in the pool */
>  	if (avoid_reserve && h->free_huge_pages - h->resv_huge_pages == 0)
> -		goto err;
> +		return NULL;
> +
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
> -- 
> 1.7.9.5
> 

-- 
Michal Hocko
SUSE Labs
