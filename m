Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030705AbaLLQOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 11:14:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53632 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934943AbaLLQNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 11:13:43 -0500
From: Vlastimil Babka <vbabka@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>, David Rientjes <rientjes@google.com>,
        Rik van Riel <riel@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Michal Hocko <mhocko@suse.cz>
Subject: [PATCH V3 3/4] mm: reduce try_to_compact_pages parameters
Date: Fri, 12 Dec 2014 17:13:24 +0100
Message-Id: <1418400805-4661-4-git-send-email-vbabka@suse.cz>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1418400805-4661-1-git-send-email-vbabka@suse.cz>
References: <1418400805-4661-1-git-send-email-vbabka@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expand the usage of the struct alloc_context introduced in the previous patch
also for calling try_to_compact_pages(), to reduce the number of its
parameters. Since the function is in different compilation module, the
definition of the alloc_context struct is moved to mm.h.

With this change we get simpler code and small savings of code size and stack
usage.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@suse.cz>
---
 include/linux/compaction.h | 15 +++++++--------
 include/linux/mm.h         | 14 ++++++++++++++
 mm/compaction.c            | 23 +++++++++++------------
 mm/page_alloc.c            | 19 ++-----------------
 4 files changed, 34 insertions(+), 37 deletions(-)

diff --git a/include/linux/compaction.h b/include/linux/compaction.h
index 3238ffa..44478a2 100644
--- a/include/linux/compaction.h
+++ b/include/linux/compaction.h
@@ -30,10 +30,9 @@ extern int sysctl_extfrag_handler(struct ctl_table *table, int write,
 			void __user *buffer, size_t *length, loff_t *ppos);
 
 extern int fragmentation_index(struct zone *zone, unsigned int order);
-extern unsigned long try_to_compact_pages(struct zonelist *zonelist,
-			int order, gfp_t gfp_mask, nodemask_t *mask,
-			enum migrate_mode mode, int *contended,
-			int alloc_flags, int classzone_idx);
+extern unsigned long try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
+			int alloc_flags, const struct alloc_context *ac,
+			enum migrate_mode mode, int *contended);
 extern void compact_pgdat(pg_data_t *pgdat, int order);
 extern void reset_isolation_suitable(pg_data_t *pgdat);
 extern unsigned long compaction_suitable(struct zone *zone, int order,
@@ -101,10 +100,10 @@ static inline bool compaction_restarting(struct zone *zone, int order)
 }
 
 #else
-static inline unsigned long try_to_compact_pages(struct zonelist *zonelist,
-			int order, gfp_t gfp_mask, nodemask_t *nodemask,
-			enum migrate_mode mode, int *contended,
-			int alloc_flags, int classzone_idx)
+static inline unsigned long try_to_compact_pages(gfp_t gfp_mask,
+			unsigned int order, int alloc_flags,
+			const struct alloc_context *ac,
+			enum migrate_mode mode, int *contended)
 {
 	return COMPACT_CONTINUE;
 }
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 38cf1d6..b3a9244 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -296,6 +296,20 @@ static inline int get_freepage_migratetype(struct page *page)
 }
 
 /*
+ * Structure for holding the mostly immutable allocation parameters passed
+ * between functions involved in allocations, including the alloc_pages*
+ * family of functions.
+ */
+struct alloc_context {
+	struct zonelist *zonelist;
+	nodemask_t *nodemask;
+	struct zone *preferred_zone;
+	int classzone_idx;
+	int migratetype;
+	enum zone_type high_zoneidx;
+};
+
+/*
  * FIXME: take this include out, include page-flags.h in
  * files which need it (119 of them)
  */
diff --git a/mm/compaction.c b/mm/compaction.c
index 546e571..9c7e690 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1335,22 +1335,20 @@ int sysctl_extfrag_threshold = 500;
 
 /**
  * try_to_compact_pages - Direct compact to satisfy a high-order allocation
- * @zonelist: The zonelist used for the current allocation
- * @order: The order of the current allocation
  * @gfp_mask: The GFP mask of the current allocation
- * @nodemask: The allowed nodes to allocate from
+ * @order: The order of the current allocation
+ * @alloc_flags: The allocation flags of the current allocation
+ * @ac: The context of current allocation
  * @mode: The migration mode for async, sync light, or sync migration
  * @contended: Return value that determines if compaction was aborted due to
  *	       need_resched() or lock contention
  *
  * This is the main entry point for direct page compaction.
  */
-unsigned long try_to_compact_pages(struct zonelist *zonelist,
-			int order, gfp_t gfp_mask, nodemask_t *nodemask,
-			enum migrate_mode mode, int *contended,
-			int alloc_flags, int classzone_idx)
+unsigned long try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
+			int alloc_flags, const struct alloc_context *ac,
+			enum migrate_mode mode, int *contended)
 {
-	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
 	int may_enter_fs = gfp_mask & __GFP_FS;
 	int may_perform_io = gfp_mask & __GFP_IO;
 	struct zoneref *z;
@@ -1365,8 +1363,8 @@ unsigned long try_to_compact_pages(struct zonelist *zonelist,
 		return COMPACT_SKIPPED;
 
 	/* Compact each zone in the list */
-	for_each_zone_zonelist_nodemask(zone, z, zonelist, high_zoneidx,
-								nodemask) {
+	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist, ac->high_zoneidx,
+								ac->nodemask) {
 		int status;
 		int zone_contended;
 
@@ -1374,7 +1372,8 @@ unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			continue;
 
 		status = compact_zone_order(zone, order, gfp_mask, mode,
-				&zone_contended, alloc_flags, classzone_idx);
+				&zone_contended, alloc_flags,
+				ac->classzone_idx);
 		rc = max(status, rc);
 		/*
 		 * It takes at least one zone that wasn't lock contended
@@ -1384,7 +1383,7 @@ unsigned long try_to_compact_pages(struct zonelist *zonelist,
 
 		/* If a normal allocation would succeed, stop compacting */
 		if (zone_watermark_ok(zone, order, low_wmark_pages(zone),
-					classzone_idx, alloc_flags)) {
+					ac->classzone_idx, alloc_flags)) {
 			/*
 			 * We think the allocation will succeed in this zone,
 			 * but it is not certain, hence the false. The caller
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 963f9c0..9416ed2 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -232,19 +232,6 @@ EXPORT_SYMBOL(nr_node_ids);
 EXPORT_SYMBOL(nr_online_nodes);
 #endif
 
-/*
- * Structure for holding the mostly immutable allocation parameters passed
- * between alloc_pages* family of functions.
- */
-struct alloc_context {
-	struct zonelist *zonelist;
-	nodemask_t *nodemask;
-	struct zone *preferred_zone;
-	int classzone_idx;
-	int migratetype;
-	enum zone_type high_zoneidx;
-};
-
 int page_group_by_mobility_disabled __read_mostly;
 
 void set_pageblock_migratetype(struct page *page, int migratetype)
@@ -2398,10 +2385,8 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 		return NULL;
 
 	current->flags |= PF_MEMALLOC;
-	compact_result = try_to_compact_pages(ac->zonelist, order, gfp_mask,
-						ac->nodemask, mode,
-						contended_compaction,
-						alloc_flags, ac->classzone_idx);
+	compact_result = try_to_compact_pages(gfp_mask, order, alloc_flags, ac,
+						mode, contended_compaction);
 	current->flags &= ~PF_MEMALLOC;
 
 	switch (compact_result) {
-- 
2.1.2

