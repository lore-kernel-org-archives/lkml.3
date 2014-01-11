Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbaAKMgt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 07:36:49 -0500
Received: from relay.parallels.com ([195.214.232.42]:40309 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaAKMgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 07:36:46 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <devel@openvz.org>,
        Glauber Costa <glommer@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 4/5] mm: vmscan: move call to shrink_slab() to shrink_zones()
Date: Sat, 11 Jan 2014 16:36:34 +0400
Message-ID: <1e31dd389002eca2533e6b112a774855426b1703.1389443272.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <7d37542211678a637dc6b4d995fd6f1e89100538.1389443272.git.vdavydov@parallels.com>
References: <7d37542211678a637dc6b4d995fd6f1e89100538.1389443272.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.24.24.175]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reduces the indentation level of do_try_to_free_pages() and removes
extra loop over all eligible zones counting the number of on-LRU pages.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Reviewed-by: Glauber Costa <glommer@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Dave Chinner <dchinner@redhat.com>
---
 mm/vmscan.c |   56 +++++++++++++++++++++++++-------------------------------
 1 file changed, 25 insertions(+), 31 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index ae6518d..b364f3c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2291,13 +2291,16 @@ static inline bool compaction_ready(struct zone *zone, struct scan_control *sc)
  * the caller that it should consider retrying the allocation instead of
  * further reclaim.
  */
-static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
+static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc,
+			 struct shrink_control *shrink)
 {
 	struct zoneref *z;
 	struct zone *zone;
 	unsigned long nr_soft_reclaimed;
 	unsigned long nr_soft_scanned;
+	unsigned long lru_pages = 0;
 	bool aborted_reclaim = false;
+	struct reclaim_state *reclaim_state = current->reclaim_state;
 
 	/*
 	 * If the number of buffer_heads in the machine exceeds the maximum
@@ -2307,6 +2310,8 @@ static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
 	if (buffer_heads_over_limit)
 		sc->gfp_mask |= __GFP_HIGHMEM;
 
+	nodes_clear(shrink->nodes_to_scan);
+
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 					gfp_zone(sc->gfp_mask), sc->nodemask) {
 		if (!populated_zone(zone))
@@ -2318,6 +2323,10 @@ static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
 		if (global_reclaim(sc)) {
 			if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
 				continue;
+
+			lru_pages += zone_reclaimable_pages(zone);
+			node_set(zone_to_nid(zone), shrink->nodes_to_scan);
+
 			if (sc->priority != DEF_PRIORITY &&
 			    !zone_reclaimable(zone))
 				continue;	/* Let kswapd poll it */
@@ -2354,6 +2363,20 @@ static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
 		shrink_zone(zone, sc);
 	}
 
+	/*
+	 * Don't shrink slabs when reclaiming memory from over limit cgroups
+	 * but do shrink slab at least once when aborting reclaim for
+	 * compaction to avoid unevenly scanning file/anon LRU pages over slab
+	 * pages.
+	 */
+	if (global_reclaim(sc)) {
+		shrink_slab(shrink, sc->nr_scanned, lru_pages);
+		if (reclaim_state) {
+			sc->nr_reclaimed += reclaim_state->reclaimed_slab;
+			reclaim_state->reclaimed_slab = 0;
+		}
+	}
+
 	return aborted_reclaim;
 }
 
@@ -2398,9 +2421,6 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 					struct shrink_control *shrink)
 {
 	unsigned long total_scanned = 0;
-	struct reclaim_state *reclaim_state = current->reclaim_state;
-	struct zoneref *z;
-	struct zone *zone;
 	unsigned long writeback_threshold;
 	bool aborted_reclaim;
 
@@ -2413,34 +2433,8 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 		vmpressure_prio(sc->gfp_mask, sc->target_mem_cgroup,
 				sc->priority);
 		sc->nr_scanned = 0;
-		aborted_reclaim = shrink_zones(zonelist, sc);
-
-		/*
-		 * Don't shrink slabs when reclaiming memory from over limit
-		 * cgroups but do shrink slab at least once when aborting
-		 * reclaim for compaction to avoid unevenly scanning file/anon
-		 * LRU pages over slab pages.
-		 */
-		if (global_reclaim(sc)) {
-			unsigned long lru_pages = 0;
-
-			nodes_clear(shrink->nodes_to_scan);
-			for_each_zone_zonelist_nodemask(zone, z, zonelist,
-					gfp_zone(sc->gfp_mask), sc->nodemask) {
-				if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
-					continue;
-
-				lru_pages += zone_reclaimable_pages(zone);
-				node_set(zone_to_nid(zone),
-					 shrink->nodes_to_scan);
-			}
+		aborted_reclaim = shrink_zones(zonelist, sc, shrink);
 
-			shrink_slab(shrink, sc->nr_scanned, lru_pages);
-			if (reclaim_state) {
-				sc->nr_reclaimed += reclaim_state->reclaimed_slab;
-				reclaim_state->reclaimed_slab = 0;
-			}
-		}
 		total_scanned += sc->nr_scanned;
 		if (sc->nr_reclaimed >= sc->nr_to_reclaim)
 			goto out;
-- 
1.7.10.4

