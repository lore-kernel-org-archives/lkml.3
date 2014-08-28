Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbaH1S45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:56:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32869 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010AbaH1Sgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:36:41 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 52/97] mm/compaction: cleanup isolate_freepages()
Date: Thu, 28 Aug 2014 19:35:00 +0100
Message-Id: <1409250945-30874-53-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>

commit c96b9e508f3d06ddb601dcc9792d62c044ab359e upstream.

isolate_freepages() is currently somewhat hard to follow thanks to many
looks like it is related to the 'low_pfn' variable, but in fact it is not.

This patch renames the 'high_pfn' variable to a hopefully less confusing name,
and slightly changes its handling without a functional change. A comment made
obsolete by recent changes is also updated.

[akpm@linux-foundation.org: comment fixes, per Minchan]
[iamjoonsoo.kim@lge.com: cleanups]
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Dongjun Shin <d.j.shin@samsung.com>
Cc: Sunghwan Yun <sunghwan.yun@samsung.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/compaction.c | 56 +++++++++++++++++++++++++++-----------------------------
 1 file changed, 27 insertions(+), 29 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index c5f2f18..43d37cd 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -663,7 +663,10 @@ static void isolate_freepages(struct zone *zone,
 				struct compact_control *cc)
 {
 	struct page *page;
-	unsigned long high_pfn, low_pfn, pfn, z_end_pfn;
+	unsigned long block_start_pfn;	/* start of current pageblock */
+	unsigned long block_end_pfn;	/* end of current pageblock */
+	unsigned long low_pfn;	     /* lowest pfn scanner is able to scan */
+	unsigned long next_free_pfn; /* start pfn for scaning at next round */
 	int nr_freepages = cc->nr_freepages;
 	struct list_head *freelist = &cc->freepages;
 
@@ -671,32 +674,33 @@ static void isolate_freepages(struct zone *zone,
 	 * Initialise the free scanner. The starting point is where we last
 	 * successfully isolated from, zone-cached value, or the end of the
 	 * zone when isolating for the first time. We need this aligned to
-	 * the pageblock boundary, because we do pfn -= pageblock_nr_pages
-	 * in the for loop.
+	 * the pageblock boundary, because we do
+	 * block_start_pfn -= pageblock_nr_pages in the for loop.
+	 * For ending point, take care when isolating in last pageblock of a
+	 * a zone which ends in the middle of a pageblock.
 	 * The low boundary is the end of the pageblock the migration scanner
 	 * is using.
 	 */
-	pfn = cc->free_pfn & ~(pageblock_nr_pages-1);
+	block_start_pfn = cc->free_pfn & ~(pageblock_nr_pages-1);
+	block_end_pfn = min(block_start_pfn + pageblock_nr_pages,
+						zone_end_pfn(zone));
 	low_pfn = ALIGN(cc->migrate_pfn + 1, pageblock_nr_pages);
 
 	/*
-	 * Take care that if the migration scanner is at the end of the zone
-	 * that the free scanner does not accidentally move to the next zone
-	 * in the next isolation cycle.
+	 * If no pages are isolated, the block_start_pfn < low_pfn check
+	 * will kick in.
 	 */
-	high_pfn = min(low_pfn, pfn);
-
-	z_end_pfn = zone_end_pfn(zone);
+	next_free_pfn = 0;
 
 	/*
 	 * Isolate free pages until enough are available to migrate the
 	 * pages on cc->migratepages. We stop searching if the migrate
 	 * and free page scanners meet or enough free pages are isolated.
 	 */
-	for (; pfn >= low_pfn && cc->nr_migratepages > nr_freepages;
-					pfn -= pageblock_nr_pages) {
+	for (; block_start_pfn >= low_pfn && cc->nr_migratepages > nr_freepages;
+				block_end_pfn = block_start_pfn,
+				block_start_pfn -= pageblock_nr_pages) {
 		unsigned long isolated;
-		unsigned long end_pfn;
 
 		/*
 		 * This can iterate a massively long zone without finding any
@@ -705,7 +709,7 @@ static void isolate_freepages(struct zone *zone,
 		 */
 		cond_resched();
 
-		if (!pfn_valid(pfn))
+		if (!pfn_valid(block_start_pfn))
 			continue;
 
 		/*
@@ -715,7 +719,7 @@ static void isolate_freepages(struct zone *zone,
 		 * i.e. it's possible that all pages within a zones range of
 		 * pages do not belong to a single zone.
 		 */
-		page = pfn_to_page(pfn);
+		page = pfn_to_page(block_start_pfn);
 		if (page_zone(page) != zone)
 			continue;
 
@@ -728,14 +732,8 @@ static void isolate_freepages(struct zone *zone,
 			continue;
 
 		/* Found a block suitable for isolating free pages from */
-
-		/*
-		 * Take care when isolating in last pageblock of a zone which
-		 * ends in the middle of a pageblock.
-		 */
-		end_pfn = min(pfn + pageblock_nr_pages, z_end_pfn);
-		isolated = isolate_freepages_block(cc, pfn, end_pfn,
-						   freelist, false);
+		isolated = isolate_freepages_block(cc, block_start_pfn,
+					block_end_pfn, freelist, false);
 		nr_freepages += isolated;
 
 		/*
@@ -743,9 +741,9 @@ static void isolate_freepages(struct zone *zone,
 		 * looking for free pages, the search will restart here as
 		 * page migration may have returned some pages to the allocator
 		 */
-		if (isolated) {
+		if (isolated && next_free_pfn == 0) {
 			cc->finished_update_free = true;
-			high_pfn = max(high_pfn, pfn);
+			next_free_pfn = block_start_pfn;
 		}
 	}
 
@@ -756,10 +754,10 @@ static void isolate_freepages(struct zone *zone,
 	 * If we crossed the migrate scanner, we want to keep it that way
 	 * so that compact_finished() may detect this
 	 */
-	if (pfn < low_pfn)
-		cc->free_pfn = max(pfn, zone->zone_start_pfn);
-	else
-		cc->free_pfn = high_pfn;
+	if (block_start_pfn < low_pfn)
+		next_free_pfn = cc->migrate_pfn;
+
+	cc->free_pfn = next_free_pfn;
 	cc->nr_freepages = nr_freepages;
 }
 
-- 
1.8.4.5

