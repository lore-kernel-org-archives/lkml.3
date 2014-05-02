Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbaEBP2D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:28:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55951 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbaEBP2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:28:01 -0400
From: Vlastimil Babka <vbabka@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>, Greg Thelen <gthelen@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Vlastimil Babka <vbabka@suse.cz>, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: [PATCH 2/2] mm/compaction: avoid rescanning pageblocks in isolate_freepages
Date: Fri,  2 May 2014 17:27:55 +0200
Message-Id: <1399044475-3154-1-git-send-email-vbabka@suse.cz>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <5363B854.3010401@suse.cz>
References: <5363B854.3010401@suse.cz>
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
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
---
 mm/compaction.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 873d7de..1967850 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -686,12 +686,6 @@ static void isolate_freepages(struct zone *zone,
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
@@ -731,19 +725,19 @@ static void isolate_freepages(struct zone *zone,
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

