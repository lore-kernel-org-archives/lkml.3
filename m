Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbaH1TIa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:08:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32847 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352AbaH1SgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:36:09 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 21/97] mm: compaction: do not mark unmovable pageblocks as skipped in async compaction
Date: Thu, 28 Aug 2014 19:34:29 +0100
Message-Id: <1409250945-30874-22-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>

commit 50b5b094e683f8e51e82c6dfe97b1608cf97e6c0 upstream.

Compaction temporarily marks pageblocks where it fails to isolate pages
as to-be-skipped in further compactions, in order to improve efficiency.
One of the reasons to fail isolating pages is that isolation is not
attempted in pageblocks that are not of MIGRATE_MOVABLE (or CMA) type.

The problem is that blocks skipped due to not being MIGRATE_MOVABLE in
async compaction become skipped due to the temporary mark also in future
sync compaction.  Moreover, this may follow quite soon during
__alloc_page_slowpath, without much time for kswapd to clear the
pageblock skip marks.  This goes against the idea that sync compaction
should try to scan these blocks more thoroughly than the async
compaction.

The fix is to ensure in async compaction that these !MIGRATE_MOVABLE
blocks are not marked to be skipped.  Note this should not affect
performance or locking impact of further async compactions, as skipping
a block due to being !MIGRATE_MOVABLE is done soon after skipping a
block marked to be skipped, both without locking.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/compaction.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index c55bd45..5cf2d60 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -466,6 +466,7 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 	unsigned long flags;
 	bool locked = false;
 	struct page *page = NULL, *valid_page = NULL;
+	bool skipped_async_unsuitable = false;
 
 	/*
 	 * Ensure that there are not too many pages isolated from the LRU
@@ -541,6 +542,7 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 		if (!cc->sync && last_pageblock_nr != pageblock_nr &&
 		    !migrate_async_suitable(get_pageblock_migratetype(page))) {
 			cc->finished_update_migrate = true;
+			skipped_async_unsuitable = true;
 			goto next_pageblock;
 		}
 
@@ -634,8 +636,13 @@ next_pageblock:
 	if (locked)
 		spin_unlock_irqrestore(&zone->lru_lock, flags);
 
-	/* Update the pageblock-skip if the whole pageblock was scanned */
-	if (low_pfn == end_pfn)
+	/*
+	 * Update the pageblock-skip information and cached scanner pfn,
+	 * if the whole pageblock was scanned without isolating any page.
+	 * This is not done when pageblock was skipped due to being unsuitable
+	 * for async compaction, so that eventual sync compaction can try.
+	 */
+	if (low_pfn == end_pfn && !skipped_async_unsuitable)
 		update_pageblock_skip(cc, valid_page, nr_isolated, true);
 
 	trace_mm_compaction_isolate_migratepages(nr_scanned, nr_isolated);
-- 
1.8.4.5

