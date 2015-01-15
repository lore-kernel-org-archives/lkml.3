Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbbAONRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:17:39 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:34199 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806AbbAONRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 08:17:38 -0500
Date: Thu, 15 Jan 2015 14:17:32 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/2] mm: vmscan: account slab pages on memcg reclaim
Message-ID: <20150115131732.GF7000@dhcp22.suse.cz>
References: <880700a513472a8b86fd3100aef674322c66c68e.1421054931.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <880700a513472a8b86fd3100aef674322c66c68e.1421054931.git.vdavydov@parallels.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 12-01-15 12:30:37, Vladimir Davydov wrote:
> Since try_to_free_mem_cgroup_pages() can now call slab shrinkers, we
> should initialize reclaim_state and account reclaimed slab pages in
> scan_control->nr_reclaimed.

I am sorry, I didn't get to this one yet. As pointed out in othere email
(http://marc.info/?l=linux-mm&m=142132670609578&w=2) reclaim_state might
catch unrelated pages freed from slab. I do not like expanding its usage
for memcg.

> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
> ---
>  mm/vmscan.c |   33 ++++++++++++++++++++++-----------
>  1 file changed, 22 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 16f3e45742d6..b2c041139a51 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -367,13 +367,16 @@ static unsigned long do_shrink_slab(struct shrink_control *shrinkctl,
>   * the ->seeks setting of the shrink function, which indicates the
>   * cost to recreate an object relative to that of an LRU page.
>   *
> - * Returns the number of reclaimed slab objects.
> + * Returns the number of reclaimed slab objects. The number of reclaimed
> + * pages is added to *@ret_nr_reclaimed.
>   */
>  static unsigned long shrink_slab(gfp_t gfp_mask, int nid,
>  				 struct mem_cgroup *memcg,
>  				 unsigned long nr_scanned,
> -				 unsigned long nr_eligible)
> +				 unsigned long nr_eligible,
> +				 unsigned long *ret_nr_reclaimed)
>  {
> +	struct reclaim_state *reclaim_state = current->reclaim_state;
>  	struct shrinker *shrinker;
>  	unsigned long freed = 0;
>  
> @@ -412,6 +415,10 @@ static unsigned long shrink_slab(gfp_t gfp_mask, int nid,
>  
>  	up_read(&shrinker_rwsem);
>  out:
> +	if (reclaim_state) {
> +		*ret_nr_reclaimed += reclaim_state->reclaimed_slab;
> +		reclaim_state->reclaimed_slab = 0;
> +	}
>  	cond_resched();
>  	return freed;
>  }
> @@ -419,6 +426,7 @@ out:
>  void drop_slab_node(int nid)
>  {
>  	unsigned long freed;
> +	unsigned long nr_reclaimed = 0;
>  
>  	do {
>  		struct mem_cgroup *memcg = NULL;
> @@ -426,7 +434,7 @@ void drop_slab_node(int nid)
>  		freed = 0;
>  		do {
>  			freed += shrink_slab(GFP_KERNEL, nid, memcg,
> -					     1000, 1000);
> +					     1000, 1000, &nr_reclaimed);
>  		} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
>  	} while (freed > 10);
>  }
> @@ -2339,7 +2347,6 @@ static inline bool should_continue_reclaim(struct zone *zone,
>  static bool shrink_zone(struct zone *zone, struct scan_control *sc,
>  			bool is_classzone)
>  {
> -	struct reclaim_state *reclaim_state = current->reclaim_state;
>  	unsigned long nr_reclaimed, nr_scanned;
>  	bool reclaimable = false;
>  
> @@ -2371,7 +2378,7 @@ static bool shrink_zone(struct zone *zone, struct scan_control *sc,
>  			if (memcg && is_classzone)
>  				shrink_slab(sc->gfp_mask, zone_to_nid(zone),
>  					    memcg, sc->nr_scanned - scanned,
> -					    lru_pages);
> +					    lru_pages, &sc->nr_reclaimed);
>  
>  			/*
>  			 * Direct reclaim and kswapd have to scan all memory
> @@ -2398,12 +2405,7 @@ static bool shrink_zone(struct zone *zone, struct scan_control *sc,
>  		if (global_reclaim(sc) && is_classzone)
>  			shrink_slab(sc->gfp_mask, zone_to_nid(zone), NULL,
>  				    sc->nr_scanned - nr_scanned,
> -				    zone_lru_pages);
> -
> -		if (reclaim_state) {
> -			sc->nr_reclaimed += reclaim_state->reclaimed_slab;
> -			reclaim_state->reclaimed_slab = 0;
> -		}
> +				    zone_lru_pages, &sc->nr_reclaimed);
>  
>  		vmpressure(sc->gfp_mask, sc->target_mem_cgroup,
>  			   sc->nr_scanned - nr_scanned,
> @@ -2865,6 +2867,9 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
>  		.may_unmap = 1,
>  		.may_swap = may_swap,
>  	};
> +	struct reclaim_state reclaim_state = {
> +		.reclaimed_slab = 0,
> +	};
>  
>  	/*
>  	 * Unlike direct reclaim via alloc_pages(), memcg's reclaim doesn't
> @@ -2875,6 +2880,9 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
>  
>  	zonelist = NODE_DATA(nid)->node_zonelists;
>  
> +	lockdep_set_current_reclaim_state(gfp_mask);
> +	current->reclaim_state = &reclaim_state;
> +
>  	trace_mm_vmscan_memcg_reclaim_begin(0,
>  					    sc.may_writepage,
>  					    sc.gfp_mask);
> @@ -2883,6 +2891,9 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
>  
>  	trace_mm_vmscan_memcg_reclaim_end(nr_reclaimed);
>  
> +	current->reclaim_state = NULL;
> +	lockdep_clear_current_reclaim_state();
> +
>  	return nr_reclaimed;
>  }
>  #endif
> -- 
> 1.7.10.4
> 

-- 
Michal Hocko
SUSE Labs
