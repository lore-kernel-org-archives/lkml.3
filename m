Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbaH1Sgv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:36:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32869 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbaH1Sgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:36:48 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 59/97] mm/compaction: avoid rescanning pageblocks in isolate_freepages
Date: Thu, 28 Aug 2014 19:35:07 +0100
Message-Id: <1409250945-30874-60-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>

commit e9ade569910a82614ff5f2c2cea2b65a8d785da4 upstream.

The compaction free scanner in isolate_freepages() currently remembers PFN
of the highest pageblock where it successfully isolates, to be used as the
starting pageblock for the next invocation.  The rationale behind this is
that page migration might return free pages to the allocator when
migration fails and we don't want to skip them if the compaction
continues.

Since migration now returns free pages back to compaction code where they
can be reused, this is no longer a concern.  This patch changes
isolate_freepages() so that the PFN for restarting is updated with each
pageblock where isolation is attempted.  Using stress-highalloc from
mmtests, this resulted in 10% reduction of the pages scanned by the free
scanner.

Note that the somewhat similar functionality that records highest
successful pageblock in zone->compact_cached_free_pfn, remains unchanged.
This cache is used when the whole compaction is restarted, not for
multiple invocations of the free scanner during single compaction.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/compaction.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 88b33e6..44aa2d4 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -686,7 +686,6 @@ static void isolate_freepages(struct zone *zone,
 	unsigned long block_start_pfn;	/* start of current pageblock */
 	unsigned long block_end_pfn;	/* end of current pageblock */
 	unsigned long low_pfn;	     /* lowest pfn scanner is able to scan */
-	unsigned long next_free_pfn; /* start pfn for scaning at next round */
 	int nr_freepages = cc->nr_freepages;
 	struct list_head *freelist = &cc->freepages;
 
@@ -707,12 +706,6 @@ static void isolate_freepages(struct zone *zone,
 	low_pfn = ALIGN(cc->migrate_pfn + 1, pageblock_nr_pages);
 
 	/*
-	 * If no pages are isolated, the block_start_pfn < low_pfn check
-	 * will kick in.
-	 */
-	next_free_pfn = 0;
-
-	/*
 	 * Isolate free pages until enough are available to migrate the
 	 * pages on cc->migratepages. We stop searching if the migrate
 	 * and free page scanners meet or enough free pages are isolated.
@@ -752,19 +745,19 @@ static void isolate_freepages(struct zone *zone,
 			continue;
 
 		/* Found a block suitable for isolating free pages from */
+		cc->free_pfn = block_start_pfn;
 		isolated = isolate_freepages_block(cc, block_start_pfn,
 					block_end_pfn, freelist, false);
 		nr_freepages += isolated;
 
 		/*
-		 * Record the highest PFN we isolated pages from. When next
-		 * looking for free pages, the search will restart here as
-		 * page migration may have returned some pages to the allocator
+		 * Set a flag that we successfully isolated in this pageblock.
+		 * In the next loop iteration, zone->compact_cached_free_pfn
+		 * will not be updated and thus it will effectively contain the
+		 * highest pageblock we isolated pages from.
 		 */
-		if (isolated && next_free_pfn == 0) {
+		if (isolated)
 			cc->finished_update_free = true;
-			next_free_pfn = block_start_pfn;
-		}
 	}
 
 	/* split_free_page does not map the pages */
@@ -775,9 +768,8 @@ static void isolate_freepages(struct zone *zone,
 	 * so that compact_finished() may detect this
 	 */
 	if (block_start_pfn < low_pfn)
-		next_free_pfn = cc->migrate_pfn;
+		cc->free_pfn = cc->migrate_pfn;
 
-	cc->free_pfn = next_free_pfn;
 	cc->nr_freepages = nr_freepages;
 }
 
-- 
1.8.4.5

