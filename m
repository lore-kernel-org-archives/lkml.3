Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbaH1ShF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:37:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32878 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502AbaH1ShC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:37:02 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 72/97] mm: page_alloc: calculate classzone_idx once from the zonelist ref
Date: Thu, 28 Aug 2014 19:35:20 +0100
Message-Id: <1409250945-30874-73-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit d8846374a85f4290a473a4e2a64c1ba046c4a0e1 upstream.

There is no need to calculate zone_idx(preferred_zone) multiple times
or use the pgdat to figure it out.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/page_alloc.c | 60 +++++++++++++++++++++++++++++++++------------------------
 1 file changed, 35 insertions(+), 25 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5e0f137..fd2752a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1897,17 +1897,15 @@ static inline void init_zone_allows_reclaim(int nid)
 static struct page *
 get_page_from_freelist(gfp_t gfp_mask, nodemask_t *nodemask, unsigned int order,
 		struct zonelist *zonelist, int high_zoneidx, int alloc_flags,
-		struct zone *preferred_zone, int migratetype)
+		struct zone *preferred_zone, int classzone_idx, int migratetype)
 {
 	struct zoneref *z;
 	struct page *page = NULL;
-	int classzone_idx;
 	struct zone *zone;
 	nodemask_t *allowednodes = NULL;/* zonelist_cache approximation */
 	int zlc_active = 0;		/* set if using zonelist_cache */
 	int did_zlc_setup = 0;		/* just call zlc_setup() one time */
 
-	classzone_idx = zone_idx(preferred_zone);
 zonelist_scan:
 	/*
 	 * Scan zonelist, looking for a zone with enough free.
@@ -2171,7 +2169,7 @@ static inline struct page *
 __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
 	nodemask_t *nodemask, struct zone *preferred_zone,
-	int migratetype)
+	int classzone_idx, int migratetype)
 {
 	struct page *page;
 
@@ -2189,7 +2187,7 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask,
 		order, zonelist, high_zoneidx,
 		ALLOC_WMARK_HIGH|ALLOC_CPUSET,
-		preferred_zone, migratetype);
+		preferred_zone, classzone_idx, migratetype);
 	if (page)
 		goto out;
 
@@ -2224,7 +2222,7 @@ static struct page *
 __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
 	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
-	int migratetype, enum migrate_mode mode,
+	int classzone_idx, int migratetype, enum migrate_mode mode,
 	bool *contended_compaction, bool *deferred_compaction,
 	unsigned long *did_some_progress)
 {
@@ -2252,7 +2250,7 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 		page = get_page_from_freelist(gfp_mask, nodemask,
 				order, zonelist, high_zoneidx,
 				alloc_flags & ~ALLOC_NO_WATERMARKS,
-				preferred_zone, migratetype);
+				preferred_zone, classzone_idx, migratetype);
 		if (page) {
 			preferred_zone->compact_blockskip_flush = false;
 			compaction_defer_reset(preferred_zone, order, true);
@@ -2284,7 +2282,8 @@ static inline struct page *
 __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
 	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
-	int migratetype, enum migrate_mode mode, bool *contended_compaction,
+	int classzone_idx, int migratetype,
+	enum migrate_mode mode, bool *contended_compaction,
 	bool *deferred_compaction, unsigned long *did_some_progress)
 {
 	return NULL;
@@ -2324,7 +2323,7 @@ static inline struct page *
 __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
 	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
-	int migratetype, unsigned long *did_some_progress)
+	int classzone_idx, int migratetype, unsigned long *did_some_progress)
 {
 	struct page *page = NULL;
 	bool drained = false;
@@ -2342,7 +2341,8 @@ retry:
 	page = get_page_from_freelist(gfp_mask, nodemask, order,
 					zonelist, high_zoneidx,
 					alloc_flags & ~ALLOC_NO_WATERMARKS,
-					preferred_zone, migratetype);
+					preferred_zone, classzone_idx,
+					migratetype);
 
 	/*
 	 * If an allocation failed after direct reclaim, it could be because
@@ -2365,14 +2365,14 @@ static inline struct page *
 __alloc_pages_high_priority(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
 	nodemask_t *nodemask, struct zone *preferred_zone,
-	int migratetype)
+	int classzone_idx, int migratetype)
 {
 	struct page *page;
 
 	do {
 		page = get_page_from_freelist(gfp_mask, nodemask, order,
 			zonelist, high_zoneidx, ALLOC_NO_WATERMARKS,
-			preferred_zone, migratetype);
+			preferred_zone, classzone_idx, migratetype);
 
 		if (!page && gfp_mask & __GFP_NOFAIL)
 			wait_iff_congested(preferred_zone, BLK_RW_ASYNC, HZ/50);
@@ -2473,7 +2473,7 @@ static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
 	nodemask_t *nodemask, struct zone *preferred_zone,
-	int migratetype)
+	int classzone_idx, int migratetype)
 {
 	const gfp_t wait = gfp_mask & __GFP_WAIT;
 	struct page *page = NULL;
@@ -2522,15 +2522,19 @@ restart:
 	 * Find the true preferred zone if the allocation is unconstrained by
 	 * cpusets.
 	 */
-	if (!(alloc_flags & ALLOC_CPUSET) && !nodemask)
-		first_zones_zonelist(zonelist, high_zoneidx, NULL,
-					&preferred_zone);
+	if (!(alloc_flags & ALLOC_CPUSET) && !nodemask) {
+		struct zoneref *preferred_zoneref;
+		preferred_zoneref = first_zones_zonelist(zonelist, high_zoneidx,
+				NULL,
+				&preferred_zone);
+		classzone_idx = zonelist_zone_idx(preferred_zoneref);
+	}
 
 rebalance:
 	/* This is the last chance, in general, before the goto nopage. */
 	page = get_page_from_freelist(gfp_mask, nodemask, order, zonelist,
 			high_zoneidx, alloc_flags & ~ALLOC_NO_WATERMARKS,
-			preferred_zone, migratetype);
+			preferred_zone, classzone_idx, migratetype);
 	if (page)
 		goto got_pg;
 
@@ -2545,7 +2549,7 @@ rebalance:
 
 		page = __alloc_pages_high_priority(gfp_mask, order,
 				zonelist, high_zoneidx, nodemask,
-				preferred_zone, migratetype);
+				preferred_zone, classzone_idx, migratetype);
 		if (page) {
 			goto got_pg;
 		}
@@ -2569,7 +2573,8 @@ rebalance:
 	 */
 	page = __alloc_pages_direct_compact(gfp_mask, order, zonelist,
 					high_zoneidx, nodemask, alloc_flags,
-					preferred_zone, migratetype,
+					preferred_zone,
+					classzone_idx, migratetype,
 					migration_mode, &contended_compaction,
 					&deferred_compaction,
 					&did_some_progress);
@@ -2592,7 +2597,8 @@ rebalance:
 					zonelist, high_zoneidx,
 					nodemask,
 					alloc_flags, preferred_zone,
-					migratetype, &did_some_progress);
+					classzone_idx, migratetype,
+					&did_some_progress);
 	if (page)
 		goto got_pg;
 
@@ -2611,7 +2617,7 @@ rebalance:
 			page = __alloc_pages_may_oom(gfp_mask, order,
 					zonelist, high_zoneidx,
 					nodemask, preferred_zone,
-					migratetype);
+					classzone_idx, migratetype);
 			if (page)
 				goto got_pg;
 
@@ -2652,7 +2658,8 @@ rebalance:
 		 */
 		page = __alloc_pages_direct_compact(gfp_mask, order, zonelist,
 					high_zoneidx, nodemask, alloc_flags,
-					preferred_zone, migratetype,
+					preferred_zone,
+					classzone_idx, migratetype,
 					migration_mode, &contended_compaction,
 					&deferred_compaction,
 					&did_some_progress);
@@ -2679,11 +2686,13 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
 {
 	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
 	struct zone *preferred_zone;
+	struct zoneref *preferred_zoneref;
 	struct page *page = NULL;
 	int migratetype = allocflags_to_migratetype(gfp_mask);
 	unsigned int cpuset_mems_cookie;
 	int alloc_flags = ALLOC_WMARK_LOW|ALLOC_CPUSET|ALLOC_FAIR;
 	struct mem_cgroup *memcg = NULL;
+	int classzone_idx;
 
 	gfp_mask &= gfp_allowed_mask;
 
@@ -2713,11 +2722,12 @@ retry_cpuset:
 	cpuset_mems_cookie = read_mems_allowed_begin();
 
 	/* The preferred zone is used for statistics later */
-	first_zones_zonelist(zonelist, high_zoneidx,
+	preferred_zoneref = first_zones_zonelist(zonelist, high_zoneidx,
 				nodemask ? : &cpuset_current_mems_allowed,
 				&preferred_zone);
 	if (!preferred_zone)
 		goto out;
+	classzone_idx = zonelist_zone_idx(preferred_zoneref);
 
 #ifdef CONFIG_CMA
 	if (allocflags_to_migratetype(gfp_mask) == MIGRATE_MOVABLE)
@@ -2727,7 +2737,7 @@ retry:
 	/* First allocation attempt */
 	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
 			zonelist, high_zoneidx, alloc_flags,
-			preferred_zone, migratetype);
+			preferred_zone, classzone_idx, migratetype);
 	if (unlikely(!page)) {
 		/*
 		 * The first pass makes sure allocations are spread
@@ -2753,7 +2763,7 @@ retry:
 		gfp_mask = memalloc_noio_flags(gfp_mask);
 		page = __alloc_pages_slowpath(gfp_mask, order,
 				zonelist, high_zoneidx, nodemask,
-				preferred_zone, migratetype);
+				preferred_zone, classzone_idx, migratetype);
 	}
 
 	trace_mm_page_alloc(page, order, gfp_mask, migratetype);
-- 
1.8.4.5

