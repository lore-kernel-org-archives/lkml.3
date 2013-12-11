Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab3LKKZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 05:25:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42316 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667Ab3LKKYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 05:24:55 -0500
From: Vlastimil Babka <vbabka@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH V2 5/6] mm: compaction: do not mark unmovable pageblocks as skipped in async compaction
Date: Wed, 11 Dec 2013 11:24:36 +0100
Message-Id: <1386757477-10333-6-git-send-email-vbabka@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386757477-10333-1-git-send-email-vbabka@suse.cz>
References: <1386757477-10333-1-git-send-email-vbabka@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compaction temporarily marks pageblocks where it fails to isolate pages as
to-be-skipped in further compactions, in order to improve efficiency. One of
the reasons to fail isolating pages is that isolation is not attempted in
pageblocks that are not of MIGRATE_MOVABLE (or CMA) type.

The problem is that blocks skipped due to not being MIGRATE_MOVABLE in async
compaction become skipped due to the temporary mark also in future sync
compaction. Moreover, this may follow quite soon during __alloc_page_slowpath,
without much time for kswapd to clear the pageblock skip marks. This goes
against the idea that sync compaction should try to scan these blocks more
thoroughly than the async compaction.

The fix is to ensure in async compaction that these !MIGRATE_MOVABLE blocks are
not marked to be skipped. Note this should not affect performance or locking
impact of further async compactions, as skipping a block due to being
!MIGRATE_MOVABLE is done soon after skipping a block marked to be skipped, both
without locking.

Cc: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/compaction.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index ae83a1c..a3ee851 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -455,6 +455,7 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 	unsigned long flags;
 	bool locked = false;
 	struct page *page = NULL, *valid_page = NULL;
+	bool skipped_async_unsuitable = false;
 
 	/*
 	 * Ensure that there are not too many pages isolated from the LRU
@@ -530,6 +531,7 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 		if (!cc->sync && last_pageblock_nr != pageblock_nr &&
 		    !migrate_async_suitable(get_pageblock_migratetype(page))) {
 			cc->finished_update_migrate = true;
+			skipped_async_unsuitable = true;
 			goto next_pageblock;
 		}
 
@@ -623,8 +625,13 @@ next_pageblock:
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
1.8.4

