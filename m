Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbaEAVfz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 17:35:55 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:64040 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbaEAVfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 17:35:47 -0400
Date: Thu, 1 May 2014 14:35:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Greg Thelen <gthelen@google.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch v2 3/4] mm, compaction: add per-zone migration pfn cache for
 async compaction
In-Reply-To: <alpine.DEB.2.02.1405011434140.23898@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1405011435000.23898@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1404301744110.8415@chino.kir.corp.google.com> <alpine.DEB.2.02.1405011434140.23898@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each zone has a cached migration scanner pfn for memory compaction so that 
subsequent calls to memory compaction can start where the previous call left 
off.

Currently, the compaction migration scanner only updates the per-zone cached pfn 
when pageblocks were not skipped for async compaction.  This creates a 
dependency on calling sync compaction to avoid having subsequent calls to async 
compaction from scanning an enormous amount of non-MOVABLE pageblocks each time 
it is called.  On large machines, this could be potentially very expensive.

This patch adds a per-zone cached migration scanner pfn only for async 
compaction.  It is updated everytime a pageblock has been scanned in its 
entirety and when no pages from it were successfully isolated.  The cached 
migration scanner pfn for sync compaction is updated only when called for sync 
compaction.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/mmzone.h |  5 +++--
 mm/compaction.c        | 55 ++++++++++++++++++++++++++------------------------
 2 files changed, 32 insertions(+), 28 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -360,9 +360,10 @@ struct zone {
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
 
@@ -134,6 +135,7 @@ static void update_pageblock_skip(struct compact_control *cc,
 			bool migrate_scanner)
 {
 	struct zone *zone = cc->zone;
+	unsigned long pfn;
 
 	if (cc->ignore_skip_hint)
 		return;
@@ -141,20 +143,25 @@ static void update_pageblock_skip(struct compact_control *cc,
 	if (!page)
 		return;
 
-	if (!nr_isolated) {
-		unsigned long pfn = page_to_pfn(page);
-		set_pageblock_skip(page);
-
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
+	if (nr_isolated)
+		return;
+
+	set_pageblock_skip(page);
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
@@ -464,7 +471,6 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 	unsigned long flags;
 	bool locked = false;
 	struct page *page = NULL, *valid_page = NULL;
-	bool skipped_async_unsuitable = false;
 	const isolate_mode_t mode = (!cc->sync ? ISOLATE_ASYNC_MIGRATE : 0) |
 				    (unevictable ? ISOLATE_UNEVICTABLE : 0);
 
@@ -540,11 +546,8 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 			 * the minimum amount of work satisfies the allocation
 			 */
 			mt = get_pageblock_migratetype(page);
-			if (!cc->sync && !migrate_async_suitable(mt)) {
-				cc->finished_update_migrate = true;
-				skipped_async_unsuitable = true;
+			if (!cc->sync && !migrate_async_suitable(mt))
 				goto next_pageblock;
-			}
 		}
 
 		/*
@@ -646,10 +649,8 @@ next_pageblock:
 	/*
 	 * Update the pageblock-skip information and cached scanner pfn,
 	 * if the whole pageblock was scanned without isolating any page.
-	 * This is not done when pageblock was skipped due to being unsuitable
-	 * for async compaction, so that eventual sync compaction can try.
 	 */
-	if (low_pfn == end_pfn && !skipped_async_unsuitable)
+	if (low_pfn == end_pfn)
 		update_pageblock_skip(cc, valid_page, nr_isolated, true);
 
 	trace_mm_compaction_isolate_migratepages(nr_scanned, nr_isolated);
@@ -875,7 +876,8 @@ static int compact_finished(struct zone *zone,
 	/* Compaction run completes if the migrate and free scanner meet */
 	if (cc->free_pfn <= cc->migrate_pfn) {
 		/* Let the next compaction start anew. */
-		zone->compact_cached_migrate_pfn = zone->zone_start_pfn;
+		zone->compact_cached_migrate_pfn[0] = zone->zone_start_pfn;
+		zone->compact_cached_migrate_pfn[1] = zone->zone_start_pfn;
 		zone->compact_cached_free_pfn = zone_end_pfn(zone);
 
 		/*
@@ -1000,7 +1002,7 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
 	 * information on where the scanners should start but check that it
 	 * is initialised by ensuring the values are within zone boundaries.
 	 */
-	cc->migrate_pfn = zone->compact_cached_migrate_pfn;
+	cc->migrate_pfn = zone->compact_cached_migrate_pfn[cc->sync];
 	cc->free_pfn = zone->compact_cached_free_pfn;
 	if (cc->free_pfn < start_pfn || cc->free_pfn > end_pfn) {
 		cc->free_pfn = end_pfn & ~(pageblock_nr_pages-1);
@@ -1008,7 +1010,8 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
 	}
 	if (cc->migrate_pfn < start_pfn || cc->migrate_pfn > end_pfn) {
 		cc->migrate_pfn = start_pfn;
-		zone->compact_cached_migrate_pfn = cc->migrate_pfn;
+		zone->compact_cached_migrate_pfn[0] = cc->migrate_pfn;
+		zone->compact_cached_migrate_pfn[1] = cc->migrate_pfn;
 	}
 
 	trace_mm_compaction_begin(start_pfn, cc->migrate_pfn, cc->free_pfn, end_pfn);
