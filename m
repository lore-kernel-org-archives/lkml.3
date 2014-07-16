Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbaGPJkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 05:40:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48586 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053AbaGPJkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 05:40:37 -0400
Date: Wed, 16 Jul 2014 11:40:34 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] mm: vmscan: remove all_unreclaimable() fix
Message-ID: <20140716094034.GE7121@dhcp22.suse.cz>
References: <1405344049-19868-1-git-send-email-hannes@cmpxchg.org>
 <1405344049-19868-3-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405344049-19868-3-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 14-07-14 09:20:48, Johannes Weiner wrote:
> As per Mel, use bool for reclaimability throughout and simplify the
> reclaimability tracking in shrink_zones().
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Looks good to me and it fits better with my low/min limit patches which I
hopefully post soon.

> ---
>  mm/vmscan.c | 29 +++++++++++++++--------------
>  1 file changed, 15 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 6dac1310e5e4..74a9e0ae09b0 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2244,10 +2244,10 @@ static inline bool should_continue_reclaim(struct zone *zone,
>  	}
>  }
>  
> -static unsigned long shrink_zone(struct zone *zone, struct scan_control *sc)
> +static bool shrink_zone(struct zone *zone, struct scan_control *sc)
>  {
>  	unsigned long nr_reclaimed, nr_scanned;
> -	unsigned long zone_reclaimed = 0;
> +	bool reclaimable = false;
>  
>  	do {
>  		struct mem_cgroup *root = sc->target_mem_cgroup;
> @@ -2291,12 +2291,13 @@ static unsigned long shrink_zone(struct zone *zone, struct scan_control *sc)
>  			   sc->nr_scanned - nr_scanned,
>  			   sc->nr_reclaimed - nr_reclaimed);
>  
> -		zone_reclaimed += sc->nr_reclaimed - nr_reclaimed;
> +		if (sc->nr_reclaimed - nr_reclaimed)
> +			reclaimable = true;
>  
>  	} while (should_continue_reclaim(zone, sc->nr_reclaimed - nr_reclaimed,
>  					 sc->nr_scanned - nr_scanned, sc));
>  
> -	return zone_reclaimed;
> +	return reclaimable;
>  }
>  
>  /* Returns true if compaction should go ahead for a high-order request */
> @@ -2346,7 +2347,7 @@ static inline bool compaction_ready(struct zone *zone, int order)
>   * If a zone is deemed to be full of pinned pages then just give it a light
>   * scan then give up on it.
>   *
> - * Returns whether the zones overall are reclaimable or not.
> + * Returns true if a zone was reclaimable.
>   */
>  static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
>  {
> @@ -2361,7 +2362,7 @@ static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
>  		.gfp_mask = sc->gfp_mask,
>  	};
>  	enum zone_type requested_highidx = gfp_zone(sc->gfp_mask);
> -	bool all_unreclaimable = true;
> +	bool reclaimable = false;
>  
>  	/*
>  	 * If the number of buffer_heads in the machine exceeds the maximum
> @@ -2376,8 +2377,6 @@ static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
>  
>  	for_each_zone_zonelist_nodemask(zone, z, zonelist,
>  					gfp_zone(sc->gfp_mask), sc->nodemask) {
> -		unsigned long zone_reclaimed = 0;
> -
>  		if (!populated_zone(zone))
>  			continue;
>  		/*
> @@ -2424,15 +2423,17 @@ static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
>  						&nr_soft_scanned);
>  			sc->nr_reclaimed += nr_soft_reclaimed;
>  			sc->nr_scanned += nr_soft_scanned;
> -			zone_reclaimed += nr_soft_reclaimed;
> +			if (nr_soft_reclaimed)
> +				reclaimable = true;
>  			/* need some check for avoid more shrink_zone() */
>  		}
>  
> -		zone_reclaimed += shrink_zone(zone, sc);
> +		if (shrink_zone(zone, sc))
> +			reclaimable = true;
>  
> -		if (zone_reclaimed ||
> -		    (global_reclaim(sc) && zone_reclaimable(zone)))
> -			all_unreclaimable = false;
> +		if (global_reclaim(sc) &&
> +		    !reclaimable && zone_reclaimable(zone))
> +			reclaimable = true;
>  	}
>  
>  	/*
> @@ -2455,7 +2456,7 @@ static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
>  	 */
>  	sc->gfp_mask = orig_mask;
>  
> -	return !all_unreclaimable;
> +	return reclaimable;
>  }
>  
>  /*
> -- 
> 2.0.0
> 

-- 
Michal Hocko
SUSE Labs
