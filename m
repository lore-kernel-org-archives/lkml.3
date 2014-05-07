Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbaEGMJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 08:09:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60159 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbaEGMJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 08:09:34 -0400
From: Vlastimil Babka <vbabka@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>, Greg Thelen <gthelen@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Vlastimil Babka <vbabka@suse.cz>, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: [PATCH v2 2/2] mm/compaction: avoid rescanning pageblocks in isolate_freepages
Date: Wed,  7 May 2014 14:09:10 +0200
Message-Id: <1399464550-26447-2-git-send-email-vbabka@suse.cz>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1399464550-26447-1-git-send-email-vbabka@suse.cz>
References: <alpine.DEB.2.02.1405061922220.18635@chino.kir.corp.google.com>
 <1399464550-26447-1-git-send-email-vbabka@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The compaction free scanner in isolate_freepages() currently remembers PFN of
the highest pageblock where it successfully isolates, to be used as the
starting pageblock for the next invocation. The rationale behind this is that
page migration might return free pages to the allocator when migration fails
and we don't want to skip them if the compaction continues.

Since migration now returns free pages back to compaction code where they can
be reused, this is no longer a concern. This patch changes isolate_freepages()
so that the PFN for restarting is updated with each pageblock where isolation
is attempted. Using stress-highalloc from mmtests, this resulted in 10%
reduction of the pages scanned by the free scanner.

Note that the somewhat similar functionality that records highest successful
pageblock in zone->compact_cached_free_pfn, remains unchanged. This cache is
used when the whole compaction is restarted, not for multiple invocations of
the free scanner during single compaction.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
---
 v2: no changes, just keep patches together

 mm/compaction.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 383d562..83ca6f9 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -706,12 +706,6 @@ static void isolate_freepages(struct zone *zone,
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
@@ -751,19 +745,19 @@ static void isolate_freepages(struct zone *zone,
 			continue;
 
 		/* Found a block suitable for isolating free pages from */
+		next_free_pfn = block_start_pfn;
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
-- 
1.8.4.5

