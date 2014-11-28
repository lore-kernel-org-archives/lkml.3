Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbaK1QGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:06:47 -0500
Received: from mx2.parallels.com ([199.115.105.18]:46158 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaK1QGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:06:46 -0500
Date: Fri, 28 Nov 2014 19:06:37 +0300
From: Vladimir Davydov <vdavydov@parallels.com>
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [patch] mm: vmscan: invoke slab shrinkers from shrink_zone()
Message-ID: <20141128160637.GH6948@esperanza>
References: <1416939830-20289-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1416939830-20289-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

The patch generally looks good to me, because it simplifies the code
flow significantly and makes it easier for me to introduce per memcg
slab reclaim (thanks!). However, it has one serious flaw. Please see the
comment inline.

On Tue, Nov 25, 2014 at 01:23:50PM -0500, Johannes Weiner wrote:
[...]
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index a384339bf718..8c2b45bfe610 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
[...]
> @@ -2376,12 +2407,7 @@ static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
>  	struct zone *zone;
>  	unsigned long nr_soft_reclaimed;
>  	unsigned long nr_soft_scanned;
> -	unsigned long lru_pages = 0;
> -	struct reclaim_state *reclaim_state = current->reclaim_state;
>  	gfp_t orig_mask;
> -	struct shrink_control shrink = {
> -		.gfp_mask = sc->gfp_mask,
> -	};
>  	enum zone_type requested_highidx = gfp_zone(sc->gfp_mask);
>  	bool reclaimable = false;
>  
> @@ -2394,10 +2420,8 @@ static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
>  	if (buffer_heads_over_limit)
>  		sc->gfp_mask |= __GFP_HIGHMEM;
>  
> -	nodes_clear(shrink.nodes_to_scan);
> -
>  	for_each_zone_zonelist_nodemask(zone, z, zonelist,
> -					gfp_zone(sc->gfp_mask), sc->nodemask) {
> +					requested_highidx, sc->nodemask) {
>  		if (!populated_zone(zone))
>  			continue;
>  		/*
> @@ -2409,9 +2433,6 @@ static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
>  						 GFP_KERNEL | __GFP_HARDWALL))
>  				continue;
>  
> -			lru_pages += zone_reclaimable_pages(zone);
> -			node_set(zone_to_nid(zone), shrink.nodes_to_scan);
> -
>  			if (sc->priority != DEF_PRIORITY &&
>  			    !zone_reclaimable(zone))
>  				continue;	/* Let kswapd poll it */
> @@ -2450,7 +2471,7 @@ static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
>  			/* need some check for avoid more shrink_zone() */
>  		}
>  
> -		if (shrink_zone(zone, sc))
> +		if (shrink_zone(zone, sc, zone_idx(zone) == requested_highidx))
>  			reclaimable = true;
>  
>  		if (global_reclaim(sc) &&

If the highest zone (zone_idx=requested_highidx) is not populated, we
won't scan slab caches on direct reclaim, which may result in OOM kill
even if there are plenty of freeable dentries available.

It's especially relevant for VMs, which often have less than 4G of RAM,
in which case we will only have ZONE_DMA and ZONE_DMA32 populated and
empty ZONE_NORMAL on x86_64.

What about distributing the pressure proportionally to the number of
present pages on the zone? Something like this:

>From 5face0e29300950575bf9ccbd995828e2f183da1 Mon Sep 17 00:00:00 2001
From: Vladimir Davydov <vdavydov@parallels.com>
Date: Fri, 28 Nov 2014 17:58:43 +0300
Subject: [PATCH] vmscan: fix slab vs page cache reclaim balance

Though page cache reclaim is done per-zone, the finest granularity for
slab cache reclaim is per node. To achieve proportional pressure being
put on them, we therefore shrink slab caches only when scanning the
class zone, which is the highest zone suitable for allocations. However,
the class zone may be empty, e.g. ZONE_NORMAL/ZONE_HIGH, which are class
zones for most allocations, are empty on x86_64 with < 4G of RAM. This
will result in slab cache being scanned only by kswapd, which in turn
may lead to a premature OOM kill.

This patch attempts to fix this by calling shrink_node_slabs per each
zone eligible while distributing the pressure between zones
proportionally to the number of present pages.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9130cf67bac1..dd80625a1be5 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2298,8 +2298,7 @@ static inline bool should_continue_reclaim(struct zone *zone,
 	}
 }
 
-static bool shrink_zone(struct zone *zone, struct scan_control *sc,
-			bool is_classzone)
+static bool shrink_zone(struct zone *zone, struct scan_control *sc)
 {
 	unsigned long nr_reclaimed, nr_scanned;
 	bool reclaimable = false;
@@ -2310,7 +2309,7 @@ static bool shrink_zone(struct zone *zone, struct scan_control *sc,
 			.zone = zone,
 			.priority = sc->priority,
 		};
-		unsigned long zone_lru_pages = 0;
+		unsigned long nr_eligible = 0;
 		struct mem_cgroup *memcg;
 
 		nr_reclaimed = sc->nr_reclaimed;
@@ -2319,6 +2318,7 @@ static bool shrink_zone(struct zone *zone, struct scan_control *sc,
 		memcg = mem_cgroup_iter(root, NULL, &reclaim);
 		do {
 			unsigned long lru_pages;
+			unsigned long long tmp;
 			struct lruvec *lruvec;
 			int swappiness;
 
@@ -2326,7 +2326,17 @@ static bool shrink_zone(struct zone *zone, struct scan_control *sc,
 			swappiness = mem_cgroup_swappiness(memcg);
 
 			shrink_lruvec(lruvec, swappiness, sc, &lru_pages);
-			zone_lru_pages += lru_pages;
+
+			/*
+			 * Scale lru_pages inversely proportionally to the zone
+			 * size in order to not over-reclaim slab caches, which
+			 * are zone unaware.
+			 */
+			tmp = lru_pages;
+			tmp *= zone->zone_pgdat->node_present_pages;
+			do_div(tmp, zone->present_pages);
+
+			nr_eligible += tmp;
 
 			/*
 			 * Direct reclaim and kswapd have to scan all memory
@@ -2350,12 +2360,12 @@ static bool shrink_zone(struct zone *zone, struct scan_control *sc,
 		 * Shrink the slab caches in the same proportion that
 		 * the eligible LRU pages were scanned.
 		 */
-		if (global_reclaim(sc) && is_classzone) {
+		if (global_reclaim(sc)) {
 			struct reclaim_state *reclaim_state;
 
 			shrink_node_slabs(sc->gfp_mask, zone_to_nid(zone),
 					  sc->nr_scanned - nr_scanned,
-					  zone_lru_pages);
+					  nr_eligible);
 
 			reclaim_state = current->reclaim_state;
 			if (reclaim_state) {
@@ -2503,7 +2513,7 @@ static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
 			/* need some check for avoid more shrink_zone() */
 		}
 
-		if (shrink_zone(zone, sc, zone_idx(zone) == requested_highidx))
+		if (shrink_zone(zone, sc))
 			reclaimable = true;
 
 		if (global_reclaim(sc) &&
@@ -3010,7 +3020,7 @@ static bool kswapd_shrink_zone(struct zone *zone,
 						balance_gap, classzone_idx))
 		return true;
 
-	shrink_zone(zone, sc, zone_idx(zone) == classzone_idx);
+	shrink_zone(zone, sc);
 
 	/* Account for the number of pages attempted to reclaim */
 	*nr_attempted += sc->nr_to_reclaim;
@@ -3656,7 +3666,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 		 * priorities until we have enough memory freed.
 		 */
 		do {
-			shrink_zone(zone, &sc, true);
+			shrink_zone(zone, &sc);
 		} while (sc.nr_reclaimed < nr_pages && --sc.priority >= 0);
 	}
 
