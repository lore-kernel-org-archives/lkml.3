Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbaH1SyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:54:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32869 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001AbaH1Sgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:36:43 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 55/97] mm, compaction: add per-zone migration pfn cache for async compaction
Date: Thu, 28 Aug 2014 19:35:03 +0100
Message-Id: <1409250945-30874-56-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Rientjes <rientjes@google.com>

commit 35979ef3393110ff3c12c6b94552208d3bdf1a36 upstream.

Each zone has a cached migration scanner pfn for memory compaction so that
subsequent calls to memory compaction can start where the previous call
left off.

Currently, the compaction migration scanner only updates the per-zone
cached pfn when pageblocks were not skipped for async compaction.  This
creates a dependency on calling sync compaction to avoid having subsequent
calls to async compaction from scanning an enormous amount of non-MOVABLE
pageblocks each time it is called.  On large machines, this could be
potentially very expensive.

This patch adds a per-zone cached migration scanner pfn only for async
compaction.  It is updated everytime a pageblock has been scanned in its
entirety and when no pages from it were successfully isolated.  The cached
migration scanner pfn for sync compaction is updated only when called for
sync compaction.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 include/linux/mmzone.h |  5 ++--
 mm/compaction.c        | 66 ++++++++++++++++++++++++++++++--------------------
 2 files changed, 43 insertions(+), 28 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 4719985..e4d1a88 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -361,9 +361,10 @@ struct zone {
 	/* Set to true when the PG_migrate_skip bits should be cleared */
 	bool			compact_blockskip_flush;
 
-	/* pfns where compaction scanners should start */
+	/* pfn where compaction free scanner should start */
 	unsigned long		compact_cached_free_pfn;
-	unsigned long		compact_cached_migrate_pfn;
+	/* pfn where async and sync compaction migration scanner should start */
+	unsigned long		compact_cached_migrate_pfn[2];
 #endif
 #ifdef CONFIG_MEMORY_HOTPLUG
 	/* see spanned/present_pages for more description */
diff --git a/mm/compaction.c b/mm/compaction.c
index e4add42..618c919 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -89,7 +89,8 @@ static void __reset_isolation_suitable(struct zone *zone)
 	unsigned long end_pfn = zone_end_pfn(zone);
 	unsigned long pfn;
 
-	zone->compact_cached_migrate_pfn = start_pfn;
+	zone->compact_cached_migrate_pfn[0] = start_pfn;
+	zone->compact_cached_migrate_pfn[1] = start_pfn;
 	zone->compact_cached_free_pfn = end_pfn;
 	zone->compact_blockskip_flush = false;
 
@@ -131,9 +132,10 @@ void reset_isolation_suitable(pg_data_t *pgdat)
  */
 static void update_pageblock_skip(struct compact_control *cc,
 			struct page *page, unsigned long nr_isolated,
-			bool migrate_scanner)
+			bool set_unsuitable, bool migrate_scanner)
 {
 	struct zone *zone = cc->zone;
+	unsigned long pfn;
 
 	if (cc->ignore_skip_hint)
 		return;
@@ -141,20 +143,31 @@ static void update_pageblock_skip(struct compact_control *cc,
 	if (!page)
 		return;
 
-	if (!nr_isolated) {
-		unsigned long pfn = page_to_pfn(page);
+	if (nr_isolated)
+		return;
+
+	/*
+	 * Only skip pageblocks when all forms of compaction will be known to
+	 * fail in the near future.
+	 */
+	if (set_unsuitable)
 		set_pageblock_skip(page);
 
-		/* Update where compaction should restart */
-		if (migrate_scanner) {
-			if (!cc->finished_update_migrate &&
-			    pfn > zone->compact_cached_migrate_pfn)
-				zone->compact_cached_migrate_pfn = pfn;
-		} else {
-			if (!cc->finished_update_free &&
-			    pfn < zone->compact_cached_free_pfn)
-				zone->compact_cached_free_pfn = pfn;
-		}
+	pfn = page_to_pfn(page);
+
+	/* Update where async and sync compaction should restart */
+	if (migrate_scanner) {
+		if (cc->finished_update_migrate)
+			return;
+		if (pfn > zone->compact_cached_migrate_pfn[0])
+			zone->compact_cached_migrate_pfn[0] = pfn;
+		if (cc->sync && pfn > zone->compact_cached_migrate_pfn[1])
+			zone->compact_cached_migrate_pfn[1] = pfn;
+	} else {
+		if (cc->finished_update_free)
+			return;
+		if (pfn < zone->compact_cached_free_pfn)
+			zone->compact_cached_free_pfn = pfn;
 	}
 }
 #else
@@ -166,7 +179,7 @@ static inline bool isolation_suitable(struct compact_control *cc,
 
 static void update_pageblock_skip(struct compact_control *cc,
 			struct page *page, unsigned long nr_isolated,
-			bool migrate_scanner)
+			bool set_unsuitable, bool migrate_scanner)
 {
 }
 #endif /* CONFIG_COMPACTION */
@@ -324,7 +337,8 @@ isolate_fail:
 
 	/* Update the pageblock-skip if the whole pageblock was scanned */
 	if (blockpfn == end_pfn)
-		update_pageblock_skip(cc, valid_page, total_isolated, false);
+		update_pageblock_skip(cc, valid_page, total_isolated, true,
+				      false);
 
 	count_compact_events(COMPACTFREE_SCANNED, nr_scanned);
 	if (total_isolated)
@@ -459,7 +473,7 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 	unsigned long flags;
 	bool locked = false;
 	struct page *page = NULL, *valid_page = NULL;
-	bool skipped_async_unsuitable = false;
+	bool set_unsuitable = true;
 	const isolate_mode_t mode = (!cc->sync ? ISOLATE_ASYNC_MIGRATE : 0) |
 				    (unevictable ? ISOLATE_UNEVICTABLE : 0);
 
@@ -536,8 +550,7 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 			 */
 			mt = get_pageblock_migratetype(page);
 			if (!cc->sync && !migrate_async_suitable(mt)) {
-				cc->finished_update_migrate = true;
-				skipped_async_unsuitable = true;
+				set_unsuitable = false;
 				goto next_pageblock;
 			}
 		}
@@ -638,11 +651,10 @@ next_pageblock:
 	/*
 	 * Update the pageblock-skip information and cached scanner pfn,
 	 * if the whole pageblock was scanned without isolating any page.
-	 * This is not done when pageblock was skipped due to being unsuitable
-	 * for async compaction, so that eventual sync compaction can try.
 	 */
-	if (low_pfn == end_pfn && !skipped_async_unsuitable)
-		update_pageblock_skip(cc, valid_page, nr_isolated, true);
+	if (low_pfn == end_pfn)
+		update_pageblock_skip(cc, valid_page, nr_isolated,
+				      set_unsuitable, true);
 
 	trace_mm_compaction_isolate_migratepages(nr_scanned, nr_isolated);
 
@@ -866,7 +878,8 @@ static int compact_finished(struct zone *zone,
 	/* Compaction run completes if the migrate and free scanner meet */
 	if (cc->free_pfn <= cc->migrate_pfn) {
 		/* Let the next compaction start anew. */
-		zone->compact_cached_migrate_pfn = zone->zone_start_pfn;
+		zone->compact_cached_migrate_pfn[0] = zone->zone_start_pfn;
+		zone->compact_cached_migrate_pfn[1] = zone->zone_start_pfn;
 		zone->compact_cached_free_pfn = zone_end_pfn(zone);
 
 		/*
@@ -991,7 +1004,7 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
 	 * information on where the scanners should start but check that it
 	 * is initialised by ensuring the values are within zone boundaries.
 	 */
-	cc->migrate_pfn = zone->compact_cached_migrate_pfn;
+	cc->migrate_pfn = zone->compact_cached_migrate_pfn[cc->sync];
 	cc->free_pfn = zone->compact_cached_free_pfn;
 	if (cc->free_pfn < start_pfn || cc->free_pfn > end_pfn) {
 		cc->free_pfn = end_pfn & ~(pageblock_nr_pages-1);
@@ -999,7 +1012,8 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
 	}
 	if (cc->migrate_pfn < start_pfn || cc->migrate_pfn > end_pfn) {
 		cc->migrate_pfn = start_pfn;
-		zone->compact_cached_migrate_pfn = cc->migrate_pfn;
+		zone->compact_cached_migrate_pfn[0] = cc->migrate_pfn;
+		zone->compact_cached_migrate_pfn[1] = cc->migrate_pfn;
 	}
 
 	trace_mm_compaction_begin(start_pfn, cc->migrate_pfn, cc->free_pfn, end_pfn);
-- 
1.8.4.5

