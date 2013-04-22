Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab3DVIb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 04:31:57 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:62734 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080Ab3DVIbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 04:31:55 -0400
X-AuditID: 9c930197-b7bb3ae000000fa9-2c-5174f576ff15
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [RFC PATCH 2/3] mm, page_alloc: change __rmqueue_fallback() to drain_fallback()
Date: Mon, 22 Apr 2013 17:33:09 +0900
Message-Id: <1366619590-31526-2-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1366619590-31526-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1366619590-31526-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we run move_freepages_block() in __rmqueue_fallback(), it is possible
that there is smaller order page than current_order in migratetype area.
If we use it, we can reduce to break large order page as much as possible.
For this purpose, we just move pages from fallback to target area. And
then do retry __rmqueue_smallest(). This ensure that smallest page in area
is returned, so that we can achieve our goal.

In addition, this makes smaller code because we can remove wrongly inlined
code in __rmqueue_fallback().

Below is result of "size mm/page_alloc.o"

* Before *
   text	   data	    bss	    dec	    hex	filename
  34729	   1309	    640	  36678	   8f46	mm/page_alloc.o

* After *
   text	   data	    bss	    dec	    hex	filename
  34315	   1285	    640	  36240	   8d90	mm/page_alloc.o

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a822389..b212554 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1009,14 +1009,15 @@ static void change_pageblock_range(struct page *pageblock_page,
 	}
 }
 
-/* Remove an element from the buddy allocator from the fallback list */
-static inline struct page *
-__rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
+/* Drain elements from the buddy allocator from the fallback list */
+static inline bool
+drain_fallback(struct zone *zone, int order, int start_migratetype)
 {
 	struct free_area *area = NULL;
 	int current_order;
 	struct page *page;
 	int migratetype = 0, i;
+	bool moved = false;
 
 	/* Find the largest possible block of pages in the other list */
 	for (current_order = MAX_ORDER-1; current_order >= order;
@@ -1034,14 +1035,13 @@ __rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
 		}
 	}
 
-	return NULL;
+	return false;
 
 found:
 	page = list_entry(area->free_list[migratetype].next, struct page, lru);
-	area->nr_free--;
 
 	/*
-	 * If breaking a large block of pages, move all free pages to the
+	 * If draining a large block of pages, move all free pages to the
 	 * preferred allocation list. If falling back for a reclaimable
 	 * kernel allocation, be more aggressive about taking ownership
 	 * of free pages
@@ -1055,33 +1055,26 @@ found:
 			 start_migratetype == MIGRATE_RECLAIMABLE ||
 			 page_group_by_mobility_disabled)) {
 		int pages;
+
 		pages = move_freepages_block(zone, page, start_migratetype);
+		if (likely(pages))
+			moved = true;
 
 		/* Claim the whole block if over half of it is free */
 		if (pages >= (1 << (pageblock_order-1)) ||
 				page_group_by_mobility_disabled)
 			set_pageblock_migratetype(page, start_migratetype);
-
-		migratetype = start_migratetype;
 	}
 
-	/* Remove the page from the freelists */
-	list_del(&page->lru);
-	rmv_page_order(page);
-
 	/* Take ownership for orders >= pageblock_order */
 	if (current_order >= pageblock_order &&
-			!is_migrate_cma(migratetype))
+			!is_migrate_cma(start_migratetype))
 		change_pageblock_range(page, current_order, start_migratetype);
 
-	expand(zone, page, order, current_order, area,
-			is_migrate_cma(migratetype)
-			? migratetype : start_migratetype);
+	if (!moved)
+		move_freepages(zone, page, page, start_migratetype);
 
-	trace_mm_page_alloc_extfrag(page, order, current_order,
-			start_migratetype, migratetype);
-
-	return page;
+	return true;
 }
 
 /*
@@ -1092,22 +1085,23 @@ static struct page *__rmqueue(struct zone *zone, unsigned int order,
 						int migratetype)
 {
 	struct page *page;
+	bool drained;
 
-retry_reserve:
+retry:
 	page = __rmqueue_smallest(zone, order, migratetype);
 
 	if (unlikely(!page) && migratetype != MIGRATE_RESERVE) {
-		page = __rmqueue_fallback(zone, order, migratetype);
+		drained = drain_fallback(zone, order, migratetype);
 
 		/*
 		 * Use MIGRATE_RESERVE rather than fail an allocation. goto
 		 * is used because __rmqueue_smallest is an inline function
 		 * and we want just one call site
 		 */
-		if (!page) {
+		if (!drained)
 			migratetype = MIGRATE_RESERVE;
-			goto retry_reserve;
-		}
+
+		goto retry;
 	}
 
 	trace_mm_page_alloc_zone_locked(page, order, migratetype);
-- 
1.7.9.5

