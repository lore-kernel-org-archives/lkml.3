Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbaF3QsO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:48:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47447 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754652AbaF3QsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:48:10 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 4/4] mm: page_alloc: Reduce cost of the fair zone allocation policy
Date: Mon, 30 Jun 2014 17:48:03 +0100
Message-Id: <1404146883-21414-5-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1404146883-21414-1-git-send-email-mgorman@suse.de>
References: <1404146883-21414-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fair zone allocation policy round-robins allocations between zones
within a node to avoid age inversion problems during reclaim. If the
first allocation fails, the batch counts is reset and a second attempt
made before entering the slow path.

One assumption made with this scheme is that batches expire at roughly the
same time and the resets each time are justified. This assumption does not
hold when zones reach their low watermark as the batches will be consumed
at uneven rates.  Allocation failure due to watermark depletion result in
additional zonelist scans for the reset and another watermark check before
hitting the slowpath.

This patch makes a number of changes that should reduce the overall cost

o Abort the fair zone allocation policy once remote zones are encountered
o Use a simplier scan when resetting NR_ALLOC_BATCH
o Use a simple flag to identify depleted zones instead of accessing a
  potentially write-intensive cache line for counters

On UMA machines, the effect on overall performance is marginal. The main
impact is on system CPU usage which is small enough on UMA to begin with.
This comparison shows the system CPu usage between vanilla, the previous
patch and this patch.

          3.16.0-rc2  3.16.0-rc2  3.16.0-rc2
             vanilla checklow-v4 fairzone-v4
User          390.13      400.85      396.13
System        404.41      393.60      389.61
Elapsed      5412.45     5166.12     5163.49

There is a small reduction and it appears consistent.

On NUMA machines, the scanning overhead is higher as zones are scanned
that are ineligible for use by zone allocation policy. This patch fixes
the zone-order zonelist policy and reduces the numbers of zones scanned
by the allocator leading to an overall reduction of CPU usage.

          3.16.0-rc2  3.16.0-rc2  3.16.0-rc2
             vanilla checklow-v4 fairzone-v4
User          744.05      763.26      778.53
System      70148.60    49331.48    44905.73
Elapsed     28094.08    27476.72    27378.98

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 include/linux/mmzone.h |   6 +++
 mm/page_alloc.c        | 113 ++++++++++++++++++++++++++++---------------------
 2 files changed, 70 insertions(+), 49 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index a2f6443..9e9ddc4 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -534,6 +534,7 @@ typedef enum {
 	ZONE_WRITEBACK,			/* reclaim scanning has recently found
 					 * many pages under writeback
 					 */
+	ZONE_FAIR_DEPLETED,		/* fair zone policy batch depleted */
 } zone_flags_t;
 
 static inline void zone_set_flag(struct zone *zone, zone_flags_t flag)
@@ -571,6 +572,11 @@ static inline int zone_is_reclaim_locked(const struct zone *zone)
 	return test_bit(ZONE_RECLAIM_LOCKED, &zone->flags);
 }
 
+static inline int zone_is_fair_depleted(const struct zone *zone)
+{
+	return test_bit(ZONE_FAIR_DEPLETED, &zone->flags);
+}
+
 static inline int zone_is_oom_locked(const struct zone *zone)
 {
 	return test_bit(ZONE_OOM_LOCKED, &zone->flags);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ebbdbcd..3fbe995 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1597,6 +1597,8 @@ again:
 	}
 
 	__mod_zone_page_state(zone, NR_ALLOC_BATCH, -(1 << order));
+	if (zone_page_state(zone, NR_ALLOC_BATCH) == 0)
+		zone_set_flag(zone, ZONE_FAIR_DEPLETED);
 
 	__count_zone_vm_events(PGALLOC, zone, 1 << order);
 	zone_statistics(preferred_zone, zone, gfp_flags);
@@ -1908,6 +1910,20 @@ static bool zone_allows_reclaim(struct zone *local_zone, struct zone *zone)
 
 #endif	/* CONFIG_NUMA */
 
+static void reset_alloc_batches(struct zone *preferred_zone)
+{
+	struct zone *zone = preferred_zone->zone_pgdat->node_zones;
+
+	do {
+		if (!zone_is_fair_depleted(zone))
+			continue;
+		mod_zone_page_state(zone, NR_ALLOC_BATCH,
+			high_wmark_pages(zone) - low_wmark_pages(zone) -
+			atomic_long_read(&zone->vm_stat[NR_ALLOC_BATCH]));
+		zone_clear_flag(zone, ZONE_FAIR_DEPLETED);
+	} while (zone++ != preferred_zone);
+}
+
 /*
  * get_page_from_freelist goes through the zonelist trying to allocate
  * a page.
@@ -1925,8 +1941,11 @@ get_page_from_freelist(gfp_t gfp_mask, nodemask_t *nodemask, unsigned int order,
 	int did_zlc_setup = 0;		/* just call zlc_setup() one time */
 	bool consider_zone_dirty = (alloc_flags & ALLOC_WMARK_LOW) &&
 				(gfp_mask & __GFP_WRITE);
+	int nr_fair_skipped = 0;
+	bool zonelist_rescan;
 
 zonelist_scan:
+	zonelist_rescan = false;
 	/*
 	 * Scan zonelist, looking for a zone with enough free.
 	 * See also __cpuset_node_allowed_softwall() comment in kernel/cpuset.c.
@@ -1950,9 +1969,12 @@ zonelist_scan:
 		 */
 		if (alloc_flags & ALLOC_FAIR) {
 			if (!zone_local(preferred_zone, zone))
+				break;
+
+			if (zone_is_fair_depleted(zone)) {
+				nr_fair_skipped++;
 				continue;
-			if (zone_page_state(zone, NR_ALLOC_BATCH) <= 0)
-				continue;
+			}
 		}
 		/*
 		 * When allocating a page cache page for writing, we
@@ -2058,13 +2080,7 @@ this_zone_full:
 			zlc_mark_zone_full(zonelist, z);
 	}
 
-	if (unlikely(IS_ENABLED(CONFIG_NUMA) && page == NULL && zlc_active)) {
-		/* Disable zlc cache for second zonelist scan */
-		zlc_active = 0;
-		goto zonelist_scan;
-	}
-
-	if (page)
+	if (page) {
 		/*
 		 * page->pfmemalloc is set when ALLOC_NO_WATERMARKS was
 		 * necessary to allocate the page. The expectation is
@@ -2073,8 +2089,37 @@ this_zone_full:
 		 * for !PFMEMALLOC purposes.
 		 */
 		page->pfmemalloc = !!(alloc_flags & ALLOC_NO_WATERMARKS);
+		return page;
+	}
 
-	return page;
+	/*
+	 * The first pass makes sure allocations are spread fairly within the
+	 * local node.  However, the local node might have free pages left
+	 * after the fairness batches are exhausted, and remote zones haven't
+	 * even been considered yet.  Try once more without fairness, and
+	 * include remote zones now, before entering the slowpath and waking
+	 * kswapd: prefer spilling to a remote zone over swapping locally.
+	 */
+	if (alloc_flags & ALLOC_FAIR) {
+		alloc_flags &= ~ALLOC_FAIR;
+		if (nr_fair_skipped) {
+			zonelist_rescan = true;
+			reset_alloc_batches(preferred_zone);
+		}
+		if (nr_online_nodes > 1)
+			zonelist_rescan = true;
+	}
+
+	if (unlikely(IS_ENABLED(CONFIG_NUMA) && zlc_active)) {
+		/* Disable zlc cache for second zonelist scan */
+		zlc_active = 0;
+		zonelist_rescan = true;
+	}
+
+	if (zonelist_rescan)
+		goto zonelist_scan;
+
+	return NULL;
 }
 
 /*
@@ -2395,28 +2440,6 @@ __alloc_pages_high_priority(gfp_t gfp_mask, unsigned int order,
 	return page;
 }
 
-static void reset_alloc_batches(struct zonelist *zonelist,
-				enum zone_type high_zoneidx,
-				struct zone *preferred_zone)
-{
-	struct zoneref *z;
-	struct zone *zone;
-
-	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
-		/*
-		 * Only reset the batches of zones that were actually
-		 * considered in the fairness pass, we don't want to
-		 * trash fairness information for zones that are not
-		 * actually part of this zonelist's round-robin cycle.
-		 */
-		if (!zone_local(preferred_zone, zone))
-			continue;
-		mod_zone_page_state(zone, NR_ALLOC_BATCH,
-			high_wmark_pages(zone) - low_wmark_pages(zone) -
-			atomic_long_read(&zone->vm_stat[NR_ALLOC_BATCH]));
-	}
-}
-
 static void wake_all_kswapds(unsigned int order,
 			     struct zonelist *zonelist,
 			     enum zone_type high_zoneidx,
@@ -2714,6 +2737,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
 	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
 	struct zone *preferred_zone;
 	struct zoneref *preferred_zoneref;
+	struct zoneref *second_zoneref;
 	struct page *page = NULL;
 	int migratetype = allocflags_to_migratetype(gfp_mask);
 	unsigned int cpuset_mems_cookie;
@@ -2748,33 +2772,24 @@ retry_cpuset:
 		goto out;
 	classzone_idx = zonelist_zone_idx(preferred_zoneref);
 
+	/*
+	 * Only apply the fair zone allocation policy if there is more than
+	 * one local eligible zone
+	 */
+	second_zoneref = preferred_zoneref + 1;
+	if (zonelist_zone(second_zoneref) &&
+	    zone_local(preferred_zone, zonelist_zone(second_zoneref)))
+		alloc_flags |= ALLOC_FAIR;
 #ifdef CONFIG_CMA
 	if (allocflags_to_migratetype(gfp_mask) == MIGRATE_MOVABLE)
 		alloc_flags |= ALLOC_CMA;
 #endif
-retry:
 	/* First allocation attempt */
 	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
 			zonelist, high_zoneidx, alloc_flags,
 			preferred_zone, classzone_idx, migratetype);
 	if (unlikely(!page)) {
 		/*
-		 * The first pass makes sure allocations are spread
-		 * fairly within the local node.  However, the local
-		 * node might have free pages left after the fairness
-		 * batches are exhausted, and remote zones haven't
-		 * even been considered yet.  Try once more without
-		 * fairness, and include remote zones now, before
-		 * entering the slowpath and waking kswapd: prefer
-		 * spilling to a remote zone over swapping locally.
-		 */
-		if (alloc_flags & ALLOC_FAIR) {
-			reset_alloc_batches(zonelist, high_zoneidx,
-					    preferred_zone);
-			alloc_flags &= ~ALLOC_FAIR;
-			goto retry;
-		}
-		/*
 		 * Runtime PM, block IO and its error handling path
 		 * can deadlock because I/O on the device might not
 		 * complete.
-- 
1.8.4.5

