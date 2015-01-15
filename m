Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbbAOHlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 02:41:40 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:39611 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbbAOHkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 02:40:40 -0500
X-Original-SENDERIP: 10.177.222.153
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v3 5/5] mm/compaction: add tracepoint to observe behaviour of compaction defer
Date: Thu, 15 Jan 2015 16:41:13 +0900
Message-Id: <1421307673-24084-5-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1421307673-24084-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1421307673-24084-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

compaction deferring logic is heavy hammer that block the way to
the compaction. It doesn't consider overall system state, so it
could prevent user from doing compaction falsely. In other words,
even if system has enough range of memory to compact, compaction would be
skipped due to compaction deferring logic. This patch add new tracepoint
to understand work of deferring logic. This will also help to check
compaction success and fail.

Changes from v2: Remove reason part from tracepoint output

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 include/linux/compaction.h        |   65 +++------------------------------
 include/trace/events/compaction.h |   54 ++++++++++++++++++++++++++++
 mm/compaction.c                   |   72 +++++++++++++++++++++++++++++++++++++
 3 files changed, 131 insertions(+), 60 deletions(-)

diff --git a/include/linux/compaction.h b/include/linux/compaction.h
index d82181a..026ff64 100644
--- a/include/linux/compaction.h
+++ b/include/linux/compaction.h
@@ -44,66 +44,11 @@ extern void reset_isolation_suitable(pg_data_t *pgdat);
 extern unsigned long compaction_suitable(struct zone *zone, int order,
 					int alloc_flags, int classzone_idx);
 
-/* Do not skip compaction more than 64 times */
-#define COMPACT_MAX_DEFER_SHIFT 6
-
-/*
- * Compaction is deferred when compaction fails to result in a page
- * allocation success. 1 << compact_defer_limit compactions are skipped up
- * to a limit of 1 << COMPACT_MAX_DEFER_SHIFT
- */
-static inline void defer_compaction(struct zone *zone, int order)
-{
-	zone->compact_considered = 0;
-	zone->compact_defer_shift++;
-
-	if (order < zone->compact_order_failed)
-		zone->compact_order_failed = order;
-
-	if (zone->compact_defer_shift > COMPACT_MAX_DEFER_SHIFT)
-		zone->compact_defer_shift = COMPACT_MAX_DEFER_SHIFT;
-}
-
-/* Returns true if compaction should be skipped this time */
-static inline bool compaction_deferred(struct zone *zone, int order)
-{
-	unsigned long defer_limit = 1UL << zone->compact_defer_shift;
-
-	if (order < zone->compact_order_failed)
-		return false;
-
-	/* Avoid possible overflow */
-	if (++zone->compact_considered > defer_limit)
-		zone->compact_considered = defer_limit;
-
-	return zone->compact_considered < defer_limit;
-}
-
-/*
- * Update defer tracking counters after successful compaction of given order,
- * which means an allocation either succeeded (alloc_success == true) or is
- * expected to succeed.
- */
-static inline void compaction_defer_reset(struct zone *zone, int order,
-		bool alloc_success)
-{
-	if (alloc_success) {
-		zone->compact_considered = 0;
-		zone->compact_defer_shift = 0;
-	}
-	if (order >= zone->compact_order_failed)
-		zone->compact_order_failed = order + 1;
-}
-
-/* Returns true if restarting compaction after many failures */
-static inline bool compaction_restarting(struct zone *zone, int order)
-{
-	if (order < zone->compact_order_failed)
-		return false;
-
-	return zone->compact_defer_shift == COMPACT_MAX_DEFER_SHIFT &&
-		zone->compact_considered >= 1UL << zone->compact_defer_shift;
-}
+extern void defer_compaction(struct zone *zone, int order);
+extern bool compaction_deferred(struct zone *zone, int order);
+extern void compaction_defer_reset(struct zone *zone, int order,
+				bool alloc_success);
+extern bool compaction_restarting(struct zone *zone, int order);
 
 #else
 static inline unsigned long try_to_compact_pages(struct zonelist *zonelist,
diff --git a/include/trace/events/compaction.h b/include/trace/events/compaction.h
index d465358..a770166 100644
--- a/include/trace/events/compaction.h
+++ b/include/trace/events/compaction.h
@@ -238,6 +238,60 @@ DEFINE_EVENT(mm_compaction_suitable_template, mm_compaction_suitable,
 	TP_ARGS(zone, order, ret)
 );
 
+DECLARE_EVENT_CLASS(mm_compaction_defer_template,
+
+	TP_PROTO(struct zone *zone, int order),
+
+	TP_ARGS(zone, order),
+
+	TP_STRUCT__entry(
+		__field(int, nid)
+		__field(char *, name)
+		__field(int, order)
+		__field(unsigned int, considered)
+		__field(unsigned int, defer_shift)
+		__field(int, order_failed)
+	),
+
+	TP_fast_assign(
+		__entry->nid = zone_to_nid(zone);
+		__entry->name = (char *)zone->name;
+		__entry->order = order;
+		__entry->considered = zone->compact_considered;
+		__entry->defer_shift = zone->compact_defer_shift;
+		__entry->order_failed = zone->compact_order_failed;
+	),
+
+	TP_printk("node=%d zone=%-8s order=%d order_failed=%d consider=%u limit=%lu",
+		__entry->nid,
+		__entry->name,
+		__entry->order,
+		__entry->order_failed,
+		__entry->considered,
+		1UL << __entry->defer_shift)
+);
+
+DEFINE_EVENT(mm_compaction_defer_template, mm_compaction_deferred,
+
+	TP_PROTO(struct zone *zone, int order),
+
+	TP_ARGS(zone, order)
+);
+
+DEFINE_EVENT(mm_compaction_defer_template, mm_compaction_defer_compaction,
+
+	TP_PROTO(struct zone *zone, int order),
+
+	TP_ARGS(zone, order)
+);
+
+DEFINE_EVENT(mm_compaction_defer_template, mm_compaction_defer_reset,
+
+	TP_PROTO(struct zone *zone, int order),
+
+	TP_ARGS(zone, order)
+);
+
 #endif /* _TRACE_COMPACTION_H */
 
 /* This part must be outside protection */
diff --git a/mm/compaction.c b/mm/compaction.c
index 97702a8..b753c5a 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -123,6 +123,77 @@ static struct page *pageblock_pfn_to_page(unsigned long start_pfn,
 }
 
 #ifdef CONFIG_COMPACTION
+
+/* Do not skip compaction more than 64 times */
+#define COMPACT_MAX_DEFER_SHIFT 6
+
+/*
+ * Compaction is deferred when compaction fails to result in a page
+ * allocation success. 1 << compact_defer_limit compactions are skipped up
+ * to a limit of 1 << COMPACT_MAX_DEFER_SHIFT
+ */
+void defer_compaction(struct zone *zone, int order)
+{
+	zone->compact_considered = 0;
+	zone->compact_defer_shift++;
+
+	if (order < zone->compact_order_failed)
+		zone->compact_order_failed = order;
+
+	if (zone->compact_defer_shift > COMPACT_MAX_DEFER_SHIFT)
+		zone->compact_defer_shift = COMPACT_MAX_DEFER_SHIFT;
+
+	trace_mm_compaction_defer_compaction(zone, order);
+}
+
+/* Returns true if compaction should be skipped this time */
+bool compaction_deferred(struct zone *zone, int order)
+{
+	unsigned long defer_limit = 1UL << zone->compact_defer_shift;
+
+	if (order < zone->compact_order_failed)
+		return false;
+
+	/* Avoid possible overflow */
+	if (++zone->compact_considered > defer_limit)
+		zone->compact_considered = defer_limit;
+
+	if (zone->compact_considered >= defer_limit)
+		return false;
+
+	trace_mm_compaction_deferred(zone, order);
+
+	return true;
+}
+
+/*
+ * Update defer tracking counters after successful compaction of given order,
+ * which means an allocation either succeeded (alloc_success == true) or is
+ * expected to succeed.
+ */
+void compaction_defer_reset(struct zone *zone, int order,
+		bool alloc_success)
+{
+	if (alloc_success) {
+		zone->compact_considered = 0;
+		zone->compact_defer_shift = 0;
+	}
+	if (order >= zone->compact_order_failed)
+		zone->compact_order_failed = order + 1;
+
+	trace_mm_compaction_defer_reset(zone, order);
+}
+
+/* Returns true if restarting compaction after many failures */
+bool compaction_restarting(struct zone *zone, int order)
+{
+	if (order < zone->compact_order_failed)
+		return false;
+
+	return zone->compact_defer_shift == COMPACT_MAX_DEFER_SHIFT &&
+		zone->compact_considered >= 1UL << zone->compact_defer_shift;
+}
+
 /* Returns true if the pageblock should be scanned for pages to isolate. */
 static inline bool isolation_suitable(struct compact_control *cc,
 					struct page *page)
@@ -1435,6 +1506,7 @@ unsigned long try_to_compact_pages(struct zonelist *zonelist,
 			 * succeeds in this zone.
 			 */
 			compaction_defer_reset(zone, order, false);
+
 			/*
 			 * It is possible that async compaction aborted due to
 			 * need_resched() and the watermarks were ok thanks to
-- 
1.7.9.5

