Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbaDHBTI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 21:19:08 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:35083 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754690AbaDHBTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 21:19:03 -0400
X-IronPort-AV: E=Sophos;i="4.97,814,1389715200"; 
   d="scan'208";a="28974183"
Message-ID: <53434E41.1010306@cn.fujitsu.com>
Date: Tue, 8 Apr 2014 09:17:53 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131030 Thunderbird/17.0.10
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Robert Haas <robertmhaas@gmail.com>, Josh Berkus <josh@agliodbs.com>,
        Andres Freund <andres@2ndquadrant.com>,
        Christoph Lameter <cl@linux.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mm: page_alloc: Do not cache reclaim distances
References: <1396910068-11637-1-git-send-email-mgorman@suse.de> <1396910068-11637-3-git-send-email-mgorman@suse.de>
In-Reply-To: <1396910068-11637-3-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.197]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2014 06:34 AM, Mel Gorman wrote:
> pgdat->reclaim_nodes tracks if a remote node is allowed to be reclaimed by
> zone_reclaim due to its distance. As it is expected that zone_reclaim_mode
> will be rarely enabled it is unreasonable for all machines to take a penalty.
> Fortunately, the zone_reclaim_mode() path is already slow and it is the path
> that takes the hit.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

> ---
>  include/linux/mmzone.h |  1 -
>  mm/page_alloc.c        | 15 +--------------
>  2 files changed, 1 insertion(+), 15 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 9b61b9b..564b169 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -757,7 +757,6 @@ typedef struct pglist_data {
>  	unsigned long node_spanned_pages; /* total size of physical page
>  					     range, including holes */
>  	int node_id;
> -	nodemask_t reclaim_nodes;	/* Nodes allowed to reclaim from */
>  	wait_queue_head_t kswapd_wait;
>  	wait_queue_head_t pfmemalloc_wait;
>  	struct task_struct *kswapd;	/* Protected by lock_memory_hotplug() */
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index a256f85..574928e 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1863,16 +1863,7 @@ static bool zone_local(struct zone *local_zone, struct zone *zone)
>  
>  static bool zone_allows_reclaim(struct zone *local_zone, struct zone *zone)
>  {
> -	return node_isset(local_zone->node, zone->zone_pgdat->reclaim_nodes);
> -}
> -
> -static void __paginginit init_zone_allows_reclaim(int nid)
> -{
> -	int i;
> -
> -	for_each_online_node(i)
> -		if (node_distance(nid, i) <= RECLAIM_DISTANCE)
> -			node_set(i, NODE_DATA(nid)->reclaim_nodes);
> +	return node_distance(zone_to_nid(local_zone), zone_to_nid(zone)) < RECLAIM_DISTANCE;
>  }
>  
>  #else	/* CONFIG_NUMA */
> @@ -1906,9 +1897,6 @@ static bool zone_allows_reclaim(struct zone *local_zone, struct zone *zone)
>  	return true;
>  }
>  
> -static inline void init_zone_allows_reclaim(int nid)
> -{
> -}
>  #endif	/* CONFIG_NUMA */
>  
>  /*
> @@ -4917,7 +4905,6 @@ void __paginginit free_area_init_node(int nid, unsigned long *zones_size,
>  
>  	pgdat->node_id = nid;
>  	pgdat->node_start_pfn = node_start_pfn;
> -	init_zone_allows_reclaim(nid);
>  #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
>  	get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
>  #endif
> 


-- 
Thanks.
Zhang Yanfei
