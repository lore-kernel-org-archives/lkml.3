Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbaDHIXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 04:23:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54290 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756267AbaDHIXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 04:23:05 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robert Haas <robertmhaas@gmail.com>, Josh Berkus <josh@agliodbs.com>,
        Andres Freund <andres@2ndquadrant.com>,
        Christoph Lameter <cl@linux.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 2/2] mm: page_alloc: Do not cache reclaim distances
Date: Tue,  8 Apr 2014 09:23:00 +0100
Message-Id: <1396945380-18592-3-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1396945380-18592-1-git-send-email-mgorman@suse.de>
References: <1396945380-18592-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pgdat->reclaim_nodes tracks if a remote node is allowed to be reclaimed by
zone_reclaim due to its distance. As it is expected that zone_reclaim_mode
will be rarely enabled it is unreasonable for all machines to take a penalty.
Fortunately, the zone_reclaim_mode() path is already slow and it is the path
that takes the hit.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 include/linux/mmzone.h |  1 -
 mm/page_alloc.c        | 15 +--------------
 2 files changed, 1 insertion(+), 15 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 9b61b9b..564b169 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -757,7 +757,6 @@ typedef struct pglist_data {
 	unsigned long node_spanned_pages; /* total size of physical page
 					     range, including holes */
 	int node_id;
-	nodemask_t reclaim_nodes;	/* Nodes allowed to reclaim from */
 	wait_queue_head_t kswapd_wait;
 	wait_queue_head_t pfmemalloc_wait;
 	struct task_struct *kswapd;	/* Protected by lock_memory_hotplug() */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a256f85..574928e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1863,16 +1863,7 @@ static bool zone_local(struct zone *local_zone, struct zone *zone)
 
 static bool zone_allows_reclaim(struct zone *local_zone, struct zone *zone)
 {
-	return node_isset(local_zone->node, zone->zone_pgdat->reclaim_nodes);
-}
-
-static void __paginginit init_zone_allows_reclaim(int nid)
-{
-	int i;
-
-	for_each_online_node(i)
-		if (node_distance(nid, i) <= RECLAIM_DISTANCE)
-			node_set(i, NODE_DATA(nid)->reclaim_nodes);
+	return node_distance(zone_to_nid(local_zone), zone_to_nid(zone)) < RECLAIM_DISTANCE;
 }
 
 #else	/* CONFIG_NUMA */
@@ -1906,9 +1897,6 @@ static bool zone_allows_reclaim(struct zone *local_zone, struct zone *zone)
 	return true;
 }
 
-static inline void init_zone_allows_reclaim(int nid)
-{
-}
 #endif	/* CONFIG_NUMA */
 
 /*
@@ -4917,7 +4905,6 @@ void __paginginit free_area_init_node(int nid, unsigned long *zones_size,
 
 	pgdat->node_id = nid;
 	pgdat->node_start_pfn = node_start_pfn;
-	init_zone_allows_reclaim(nid);
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 	get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
 #endif
-- 
1.8.4.5

