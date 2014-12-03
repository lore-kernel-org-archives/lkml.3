Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbaLCHsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 02:48:45 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:43383 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbaLCHsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 02:48:43 -0500
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 1/3] mm/compaction: enhance trace output to know more about compaction internals
Date: Wed,  3 Dec 2014 16:52:05 +0900
Message-Id: <1417593127-6819-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It'd be useful to know where the both scanner is start. And, it also be
useful to know current range where compaction work. It will help to find
odd behaviour or problem on compaction.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 include/linux/compaction.h        |    2 +
 include/trace/events/compaction.h |   79 +++++++++++++++++++++++++++----------
 mm/compaction.c                   |   23 ++++++++---
 3 files changed, 78 insertions(+), 26 deletions(-)

diff --git a/include/linux/compaction.h b/include/linux/compaction.h
index 3238ffa..a9547b6 100644
--- a/include/linux/compaction.h
+++ b/include/linux/compaction.h
@@ -12,6 +12,7 @@
 #define COMPACT_PARTIAL		3
 /* The full zone was compacted */
 #define COMPACT_COMPLETE	4
+/* When adding new state, please change compaction_status_string, too */
 
 /* Used to signal whether compaction detected need_sched() or lock contention */
 /* No contention detected */
@@ -22,6 +23,7 @@
 #define COMPACT_CONTENDED_LOCK	2
 
 #ifdef CONFIG_COMPACTION
+extern char *compaction_status_string[];
 extern int sysctl_compact_memory;
 extern int sysctl_compaction_handler(struct ctl_table *table, int write,
 			void __user *buffer, size_t *length, loff_t *ppos);
diff --git a/include/trace/events/compaction.h b/include/trace/events/compaction.h
index c6814b9..139020b 100644
--- a/include/trace/events/compaction.h
+++ b/include/trace/events/compaction.h
@@ -11,39 +11,55 @@
 
 DECLARE_EVENT_CLASS(mm_compaction_isolate_template,
 
-	TP_PROTO(unsigned long nr_scanned,
+	TP_PROTO(
+		unsigned long start_pfn,
+		unsigned long end_pfn,
+		unsigned long nr_scanned,
 		unsigned long nr_taken),
 
-	TP_ARGS(nr_scanned, nr_taken),
+	TP_ARGS(start_pfn, end_pfn, nr_scanned, nr_taken),
 
 	TP_STRUCT__entry(
+		__field(unsigned long, start_pfn)
+		__field(unsigned long, end_pfn)
 		__field(unsigned long, nr_scanned)
 		__field(unsigned long, nr_taken)
 	),
 
 	TP_fast_assign(
+		__entry->start_pfn = start_pfn;
+		__entry->end_pfn = end_pfn;
 		__entry->nr_scanned = nr_scanned;
 		__entry->nr_taken = nr_taken;
 	),
 
-	TP_printk("nr_scanned=%lu nr_taken=%lu",
+	TP_printk("range=(0x%lx ~ 0x%lx) nr_scanned=%lu nr_taken=%lu",
+		__entry->start_pfn,
+		__entry->end_pfn,
 		__entry->nr_scanned,
 		__entry->nr_taken)
 );
 
 DEFINE_EVENT(mm_compaction_isolate_template, mm_compaction_isolate_migratepages,
 
-	TP_PROTO(unsigned long nr_scanned,
+	TP_PROTO(
+		unsigned long start_pfn,
+		unsigned long end_pfn,
+		unsigned long nr_scanned,
 		unsigned long nr_taken),
 
-	TP_ARGS(nr_scanned, nr_taken)
+	TP_ARGS(start_pfn, end_pfn, nr_scanned, nr_taken)
 );
 
 DEFINE_EVENT(mm_compaction_isolate_template, mm_compaction_isolate_freepages,
-	TP_PROTO(unsigned long nr_scanned,
+
+	TP_PROTO(
+		unsigned long start_pfn,
+		unsigned long end_pfn,
+		unsigned long nr_scanned,
 		unsigned long nr_taken),
 
-	TP_ARGS(nr_scanned, nr_taken)
+	TP_ARGS(start_pfn, end_pfn, nr_scanned, nr_taken)
 );
 
 TRACE_EVENT(mm_compaction_migratepages,
@@ -85,46 +101,67 @@ TRACE_EVENT(mm_compaction_migratepages,
 );
 
 TRACE_EVENT(mm_compaction_begin,
-	TP_PROTO(unsigned long zone_start, unsigned long migrate_start,
-		unsigned long free_start, unsigned long zone_end),
+	TP_PROTO(unsigned long zone_start, unsigned long migrate_pfn,
+		unsigned long free_pfn, unsigned long zone_end, bool sync),
 
-	TP_ARGS(zone_start, migrate_start, free_start, zone_end),
+	TP_ARGS(zone_start, migrate_pfn, free_pfn, zone_end, sync),
 
 	TP_STRUCT__entry(
 		__field(unsigned long, zone_start)
-		__field(unsigned long, migrate_start)
-		__field(unsigned long, free_start)
+		__field(unsigned long, migrate_pfn)
+		__field(unsigned long, free_pfn)
 		__field(unsigned long, zone_end)
+		__field(bool, sync)
 	),
 
 	TP_fast_assign(
 		__entry->zone_start = zone_start;
-		__entry->migrate_start = migrate_start;
-		__entry->free_start = free_start;
+		__entry->migrate_pfn = migrate_pfn;
+		__entry->free_pfn = free_pfn;
 		__entry->zone_end = zone_end;
+		__entry->sync = sync;
 	),
 
-	TP_printk("zone_start=%lu migrate_start=%lu free_start=%lu zone_end=%lu",
+	TP_printk("zone_start=0x%lx migrate_pfn=0x%lx free_pfn=0x%lx zone_end=0x%lx, mode=%s",
 		__entry->zone_start,
-		__entry->migrate_start,
-		__entry->free_start,
-		__entry->zone_end)
+		__entry->migrate_pfn,
+		__entry->free_pfn,
+		__entry->zone_end,
+		__entry->sync ? "sync" : "async")
 );
 
 TRACE_EVENT(mm_compaction_end,
-	TP_PROTO(int status),
+	TP_PROTO(unsigned long zone_start, unsigned long migrate_pfn,
+		unsigned long free_pfn, unsigned long zone_end, bool sync,
+		int status),
 
-	TP_ARGS(status),
+	TP_ARGS(zone_start, migrate_pfn, free_pfn, zone_end, sync, status),
 
 	TP_STRUCT__entry(
+		__field(unsigned long, zone_start)
+		__field(unsigned long, migrate_pfn)
+		__field(unsigned long, free_pfn)
+		__field(unsigned long, zone_end)
+		__field(bool, sync)
 		__field(int, status)
 	),
 
 	TP_fast_assign(
+		__entry->zone_start = zone_start;
+		__entry->migrate_pfn = migrate_pfn;
+		__entry->free_pfn = free_pfn;
+		__entry->zone_end = zone_end;
+		__entry->sync = sync;
 		__entry->status = status;
 	),
 
-	TP_printk("status=%d", __entry->status)
+	TP_printk("zone_start=0x%lx migrate_pfn=0x%lx free_pfn=0x%lx zone_end=0x%lx, mode=%s status=%s",
+		__entry->zone_start,
+		__entry->migrate_pfn,
+		__entry->free_pfn,
+		__entry->zone_end,
+		__entry->sync ? "sync" : "async",
+		compaction_status_string[__entry->status])
 );
 
 #endif /* _TRACE_COMPACTION_H */
diff --git a/mm/compaction.c b/mm/compaction.c
index a857225..4c7b837 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -19,6 +19,14 @@
 #include "internal.h"
 
 #ifdef CONFIG_COMPACTION
+char *compaction_status_string[] = {
+	"deferred",
+	"skipped",
+	"continue",
+	"partial",
+	"complete",
+};
+
 static inline void count_compact_event(enum vm_event_item item)
 {
 	count_vm_event(item);
@@ -421,11 +429,12 @@ isolate_fail:
 
 	}
 
+	trace_mm_compaction_isolate_freepages(*start_pfn, end_pfn,
+					nr_scanned, total_isolated);
+
 	/* Record how far we have got within the block */
 	*start_pfn = blockpfn;
 
-	trace_mm_compaction_isolate_freepages(nr_scanned, total_isolated);
-
 	/*
 	 * If strict isolation is requested by CMA then check that all the
 	 * pages requested were isolated. If there were any failures, 0 is
@@ -581,6 +590,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 	unsigned long flags = 0;
 	bool locked = false;
 	struct page *page = NULL, *valid_page = NULL;
+	unsigned long start_pfn = low_pfn;
 
 	/*
 	 * Ensure that there are not too many pages isolated from the LRU
@@ -741,7 +751,8 @@ isolate_success:
 	if (low_pfn == end_pfn)
 		update_pageblock_skip(cc, valid_page, nr_isolated, true);
 
-	trace_mm_compaction_isolate_migratepages(nr_scanned, nr_isolated);
+	trace_mm_compaction_isolate_migratepages(start_pfn, end_pfn,
+						nr_scanned, nr_isolated);
 
 	count_compact_events(COMPACTMIGRATE_SCANNED, nr_scanned);
 	if (nr_isolated)
@@ -1196,7 +1207,8 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
 		zone->compact_cached_migrate_pfn[1] = cc->migrate_pfn;
 	}
 
-	trace_mm_compaction_begin(start_pfn, cc->migrate_pfn, cc->free_pfn, end_pfn);
+	trace_mm_compaction_begin(start_pfn, cc->migrate_pfn,
+				cc->free_pfn, end_pfn, sync);
 
 	migrate_prep_local();
 
@@ -1297,7 +1309,8 @@ out:
 			zone->compact_cached_free_pfn = free_pfn;
 	}
 
-	trace_mm_compaction_end(ret);
+	trace_mm_compaction_end(start_pfn, cc->migrate_pfn,
+				cc->free_pfn, end_pfn, sync, ret);
 
 	return ret;
 }
-- 
1.7.9.5

