Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbaH1Sxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:53:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32865 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052AbaH1Sgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:36:45 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 56/97] mm, compaction: embed migration mode in compact_control
Date: Thu, 28 Aug 2014 19:35:04 +0100
Message-Id: <1409250945-30874-57-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Rientjes <rientjes@google.com>

commit e0b9daeb453e602a95ea43853dc12d385558ce1f upstream.

We're going to want to manipulate the migration mode for compaction in the
page allocator, and currently compact_control's sync field is only a bool.

Currently, we only do MIGRATE_ASYNC or MIGRATE_SYNC_LIGHT compaction
depending on the value of this bool.  Convert the bool to enum
migrate_mode and pass the migration mode in directly.  Later, we'll want
to avoid MIGRATE_SYNC_LIGHT for thp allocations in the pagefault patch to
avoid unnecessary latency.

This also alters compaction triggered from sysfs, either for the entire
system or for a node, to force MIGRATE_SYNC.

[akpm@linux-foundation.org: fix build]
[iamjoonsoo.kim@lge.com: use MIGRATE_SYNC in alloc_contig_range()]
Signed-off-by: David Rientjes <rientjes@google.com>
Suggested-by: Mel Gorman <mgorman@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Greg Thelen <gthelen@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 include/linux/compaction.h |  4 ++--
 mm/compaction.c            | 36 +++++++++++++++++++-----------------
 mm/internal.h              |  2 +-
 mm/page_alloc.c            | 39 +++++++++++++++++----------------------
 4 files changed, 39 insertions(+), 42 deletions(-)

diff --git a/include/linux/compaction.h b/include/linux/compaction.h
index 7e1c76e..01e3132 100644
--- a/include/linux/compaction.h
+++ b/include/linux/compaction.h
@@ -22,7 +22,7 @@ extern int sysctl_extfrag_handler(struct ctl_table *table, int write,
 extern int fragmentation_index(struct zone *zone, unsigned int order);
 extern unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			int order, gfp_t gfp_mask, nodemask_t *mask,
-			bool sync, bool *contended);
+			enum migrate_mode mode, bool *contended);
 extern void compact_pgdat(pg_data_t *pgdat, int order);
 extern void reset_isolation_suitable(pg_data_t *pgdat);
 extern unsigned long compaction_suitable(struct zone *zone, int order);
@@ -91,7 +91,7 @@ static inline bool compaction_restarting(struct zone *zone, int order)
 #else
 static inline unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			int order, gfp_t gfp_mask, nodemask_t *nodemask,
-			bool sync, bool *contended)
+			enum migrate_mode mode, bool *contended)
 {
 	return COMPACT_CONTINUE;
 }
diff --git a/mm/compaction.c b/mm/compaction.c
index 618c919..cebdeca 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -161,7 +161,8 @@ static void update_pageblock_skip(struct compact_control *cc,
 			return;
 		if (pfn > zone->compact_cached_migrate_pfn[0])
 			zone->compact_cached_migrate_pfn[0] = pfn;
-		if (cc->sync && pfn > zone->compact_cached_migrate_pfn[1])
+		if (cc->mode != MIGRATE_ASYNC &&
+		    pfn > zone->compact_cached_migrate_pfn[1])
 			zone->compact_cached_migrate_pfn[1] = pfn;
 	} else {
 		if (cc->finished_update_free)
@@ -208,7 +209,7 @@ static bool compact_checklock_irqsave(spinlock_t *lock, unsigned long *flags,
 		}
 
 		/* async aborts if taking too long or contended */
-		if (!cc->sync) {
+		if (cc->mode == MIGRATE_ASYNC) {
 			cc->contended = true;
 			return false;
 		}
@@ -474,7 +475,8 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 	bool locked = false;
 	struct page *page = NULL, *valid_page = NULL;
 	bool set_unsuitable = true;
-	const isolate_mode_t mode = (!cc->sync ? ISOLATE_ASYNC_MIGRATE : 0) |
+	const isolate_mode_t mode = (cc->mode == MIGRATE_ASYNC ?
+					ISOLATE_ASYNC_MIGRATE : 0) |
 				    (unevictable ? ISOLATE_UNEVICTABLE : 0);
 
 	/*
@@ -484,7 +486,7 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 	 */
 	while (unlikely(too_many_isolated(zone))) {
 		/* async migration should just abort */
-		if (!cc->sync)
+		if (cc->mode == MIGRATE_ASYNC)
 			return 0;
 
 		congestion_wait(BLK_RW_ASYNC, HZ/10);
@@ -549,7 +551,8 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 			 * the minimum amount of work satisfies the allocation
 			 */
 			mt = get_pageblock_migratetype(page);
-			if (!cc->sync && !migrate_async_suitable(mt)) {
+			if (cc->mode == MIGRATE_ASYNC &&
+			    !migrate_async_suitable(mt)) {
 				set_unsuitable = false;
 				goto next_pageblock;
 			}
@@ -979,6 +982,7 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
 	int ret;
 	unsigned long start_pfn = zone->zone_start_pfn;
 	unsigned long end_pfn = zone_end_pfn(zone);
+	const bool sync = cc->mode != MIGRATE_ASYNC;
 
 	ret = compaction_suitable(zone, cc->order);
 	switch (ret) {
@@ -1004,7 +1008,7 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
 	 * information on where the scanners should start but check that it
 	 * is initialised by ensuring the values are within zone boundaries.
 	 */
-	cc->migrate_pfn = zone->compact_cached_migrate_pfn[cc->sync];
+	cc->migrate_pfn = zone->compact_cached_migrate_pfn[sync];
 	cc->free_pfn = zone->compact_cached_free_pfn;
 	if (cc->free_pfn < start_pfn || cc->free_pfn > end_pfn) {
 		cc->free_pfn = end_pfn & ~(pageblock_nr_pages-1);
@@ -1038,8 +1042,7 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
 
 		nr_migrate = cc->nr_migratepages;
 		err = migrate_pages(&cc->migratepages, compaction_alloc,
-				compaction_free, (unsigned long)cc,
-				cc->sync ? MIGRATE_SYNC_LIGHT : MIGRATE_ASYNC,
+				compaction_free, (unsigned long)cc, cc->mode,
 				MR_COMPACTION);
 		update_nr_listpages(cc);
 		nr_remaining = cc->nr_migratepages;
@@ -1072,9 +1075,8 @@ out:
 	return ret;
 }
 
-static unsigned long compact_zone_order(struct zone *zone,
-				 int order, gfp_t gfp_mask,
-				 bool sync, bool *contended)
+static unsigned long compact_zone_order(struct zone *zone, int order,
+		gfp_t gfp_mask, enum migrate_mode mode, bool *contended)
 {
 	unsigned long ret;
 	struct compact_control cc = {
@@ -1083,7 +1085,7 @@ static unsigned long compact_zone_order(struct zone *zone,
 		.order = order,
 		.migratetype = allocflags_to_migratetype(gfp_mask),
 		.zone = zone,
-		.sync = sync,
+		.mode = mode,
 	};
 	INIT_LIST_HEAD(&cc.freepages);
 	INIT_LIST_HEAD(&cc.migratepages);
@@ -1105,7 +1107,7 @@ int sysctl_extfrag_threshold = 500;
  * @order: The order of the current allocation
  * @gfp_mask: The GFP mask of the current allocation
  * @nodemask: The allowed nodes to allocate from
- * @sync: Whether migration is synchronous or not
+ * @mode: The migration mode for async, sync light, or sync migration
  * @contended: Return value that is true if compaction was aborted due to lock contention
  * @page: Optionally capture a free page of the requested order during compaction
  *
@@ -1113,7 +1115,7 @@ int sysctl_extfrag_threshold = 500;
  */
 unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			int order, gfp_t gfp_mask, nodemask_t *nodemask,
-			bool sync, bool *contended)
+			enum migrate_mode mode, bool *contended)
 {
 	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
 	int may_enter_fs = gfp_mask & __GFP_FS;
@@ -1138,7 +1140,7 @@ unsigned long try_to_compact_pages(struct zonelist *zonelist,
 								nodemask) {
 		int status;
 
-		status = compact_zone_order(zone, order, gfp_mask, sync,
+		status = compact_zone_order(zone, order, gfp_mask, mode,
 						contended);
 		rc = max(status, rc);
 
@@ -1188,7 +1190,7 @@ void compact_pgdat(pg_data_t *pgdat, int order)
 {
 	struct compact_control cc = {
 		.order = order,
-		.sync = false,
+		.mode = MIGRATE_ASYNC,
 	};
 
 	if (!order)
@@ -1201,7 +1203,7 @@ static void compact_node(int nid)
 {
 	struct compact_control cc = {
 		.order = -1,
-		.sync = true,
+		.mode = MIGRATE_SYNC,
 		.ignore_skip_hint = true,
 	};
 
diff --git a/mm/internal.h b/mm/internal.h
index c1488a3..79ed510 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -135,7 +135,7 @@ struct compact_control {
 	unsigned long nr_migratepages;	/* Number of pages to migrate */
 	unsigned long free_pfn;		/* isolate_freepages search base */
 	unsigned long migrate_pfn;	/* isolate_migratepages search base */
-	bool sync;			/* Synchronous migration */
+	enum migrate_mode mode;		/* Async or sync migration mode */
 	bool ignore_skip_hint;		/* Scan blocks even if marked skip */
 	bool finished_update_free;	/* True when the zone cached pfns are
 					 * no longer being updated
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bfbe0db..08e54b5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2220,7 +2220,7 @@ static struct page *
 __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
 	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
-	int migratetype, bool sync_migration,
+	int migratetype, enum migrate_mode mode,
 	bool *contended_compaction, bool *deferred_compaction,
 	unsigned long *did_some_progress)
 {
@@ -2234,7 +2234,7 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 
 	current->flags |= PF_MEMALLOC;
 	*did_some_progress = try_to_compact_pages(zonelist, order, gfp_mask,
-						nodemask, sync_migration,
+						nodemask, mode,
 						contended_compaction);
 	current->flags &= ~PF_MEMALLOC;
 
@@ -2267,7 +2267,7 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 		 * As async compaction considers a subset of pageblocks, only
 		 * defer if the failure was a sync compaction failure.
 		 */
-		if (sync_migration)
+		if (mode != MIGRATE_ASYNC)
 			defer_compaction(preferred_zone, order);
 
 		cond_resched();
@@ -2280,9 +2280,8 @@ static inline struct page *
 __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
 	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
-	int migratetype, bool sync_migration,
-	bool *contended_compaction, bool *deferred_compaction,
-	unsigned long *did_some_progress)
+	int migratetype, enum migrate_mode mode, bool *contended_compaction,
+	bool *deferred_compaction, unsigned long *did_some_progress)
 {
 	return NULL;
 }
@@ -2477,7 +2476,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	int alloc_flags;
 	unsigned long pages_reclaimed = 0;
 	unsigned long did_some_progress;
-	bool sync_migration = false;
+	enum migrate_mode migration_mode = MIGRATE_ASYNC;
 	bool deferred_compaction = false;
 	bool contended_compaction = false;
 
@@ -2564,17 +2563,15 @@ rebalance:
 	 * Try direct compaction. The first pass is asynchronous. Subsequent
 	 * attempts after direct reclaim are synchronous
 	 */
-	page = __alloc_pages_direct_compact(gfp_mask, order,
-					zonelist, high_zoneidx,
-					nodemask,
-					alloc_flags, preferred_zone,
-					migratetype, sync_migration,
-					&contended_compaction,
+	page = __alloc_pages_direct_compact(gfp_mask, order, zonelist,
+					high_zoneidx, nodemask, alloc_flags,
+					preferred_zone, migratetype,
+					migration_mode, &contended_compaction,
 					&deferred_compaction,
 					&did_some_progress);
 	if (page)
 		goto got_pg;
-	sync_migration = true;
+	migration_mode = MIGRATE_SYNC_LIGHT;
 
 	/*
 	 * If compaction is deferred for high-order allocations, it is because
@@ -2649,12 +2646,10 @@ rebalance:
 		 * direct reclaim and reclaim/compaction depends on compaction
 		 * being called after reclaim so call directly if necessary
 		 */
-		page = __alloc_pages_direct_compact(gfp_mask, order,
-					zonelist, high_zoneidx,
-					nodemask,
-					alloc_flags, preferred_zone,
-					migratetype, sync_migration,
-					&contended_compaction,
+		page = __alloc_pages_direct_compact(gfp_mask, order, zonelist,
+					high_zoneidx, nodemask, alloc_flags,
+					preferred_zone, migratetype,
+					migration_mode, &contended_compaction,
 					&deferred_compaction,
 					&did_some_progress);
 		if (page)
@@ -6204,7 +6199,7 @@ static int __alloc_contig_migrate_range(struct compact_control *cc,
 		cc->nr_migratepages -= nr_reclaimed;
 
 		ret = migrate_pages(&cc->migratepages, alloc_migrate_target,
-				    NULL, 0, MIGRATE_SYNC, MR_CMA);
+				    NULL, 0, cc->mode, MR_CMA);
 	}
 	if (ret < 0) {
 		putback_movable_pages(&cc->migratepages);
@@ -6243,7 +6238,7 @@ int alloc_contig_range(unsigned long start, unsigned long end,
 		.nr_migratepages = 0,
 		.order = -1,
 		.zone = page_zone(pfn_to_page(start)),
-		.sync = true,
+		.mode = MIGRATE_SYNC,
 		.ignore_skip_hint = true,
 	};
 	INIT_LIST_HEAD(&cc.migratepages);
-- 
1.8.4.5

