Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab3HFIn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 04:43:57 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:56320 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863Ab3HFInp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 04:43:45 -0400
X-AuditID: 9c93017d-b7b45ae000000e34-4b-5200b73c3588
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <js1304@gmail.com>, Minchan Kim <minchan@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 4/4] mm, page_alloc: optimize batch count in free_pcppages_bulk()
Date: Tue,  6 Aug 2013 17:43:40 +0900
Message-Id: <1375778620-31593-4-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375778620-31593-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1375778620-31593-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we use a division operation, we can compute a batch count more closed
to ideal value. With this value, we can finish our job within
MIGRATE_PCPTYPES iteration. In addition, batching to free more pages
may be helpful to cache usage.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 26ab229..7f145cc 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -634,53 +634,76 @@ static inline int free_pages_check(struct page *page)
 static void free_pcppages_bulk(struct zone *zone, int count,
 					struct per_cpu_pages *pcp)
 {
-	int migratetype = 0;
-	int batch_free = 0;
-	int to_free = count;
+	struct list_head *list;
+	int batch_free;
+	int mt;
+	int nr_list;
+	bool all = false;
+
+	if (pcp->count == count)
+		all = true;
 
 	spin_lock(&zone->lock);
 	zone->all_unreclaimable = 0;
 	zone->pages_scanned = 0;
 
-	while (to_free) {
-		struct page *page;
-		struct list_head *list;
+redo:
+	/* Count non-empty list */
+	nr_list = 0;
+	for (mt = 0; mt < MIGRATE_PCPTYPES; mt++) {
+		list = &pcp->lists[mt];
+		if (!list_empty(list))
+			nr_list++;
+	}
 
-		/*
-		 * Remove pages from lists in a round-robin fashion. A
-		 * batch_free count is maintained that is incremented when an
-		 * empty list is encountered.  This is so more pages are freed
-		 * off fuller lists instead of spinning excessively around empty
-		 * lists
-		 */
-		do {
-			batch_free++;
-			if (++migratetype == MIGRATE_PCPTYPES)
-				migratetype = 0;
-			list = &pcp->lists[migratetype];
-		} while (list_empty(list));
+	/*
+	 * If there is only one non-empty list, free them all.
+	 * Otherwise, remove pages from lists in a round-robin fashion.
+	 * batch_free is set to remove at least one list.
+	 */
+	if (all || nr_list == 1)
+		batch_free = count;
+	else if (count <= nr_list)
+		batch_free = 1;
+	else
+		batch_free = count / nr_list;
 
-		/* This is the only non-empty list. Free them all. */
-		if (batch_free == MIGRATE_PCPTYPES)
-			batch_free = to_free;
+	for (mt = 0; mt < MIGRATE_PCPTYPES; mt++) {
+		struct page *page;
+		int i, page_mt;
 
-		do {
-			int mt;	/* migratetype of the to-be-freed page */
+		list = &pcp->lists[mt];
 
+		for (i = 0; i < batch_free; i++) {
+			if (list_empty(list))
+				break;
+
+			count--;
 			page = list_entry(list->prev, struct page, lru);
+
 			/* must delete as __free_one_page list manipulates */
 			list_del(&page->lru);
-			mt = get_freepage_migratetype(page);
+			page_mt = get_freepage_migratetype(page);
 			/* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
-			__free_one_page(page, zone, 0, mt);
-			trace_mm_page_pcpu_drain(page, 0, mt);
-			if (likely(!is_migrate_isolate_page(page))) {
-				__mod_zone_page_state(zone, NR_FREE_PAGES, 1);
-				if (is_migrate_cma(mt))
-					__mod_zone_page_state(zone, NR_FREE_CMA_PAGES, 1);
-			}
-		} while (--to_free && --batch_free && !list_empty(list));
+			__free_one_page(page, zone, 0, page_mt);
+			trace_mm_page_pcpu_drain(page, 0, page_mt);
+
+			if (unlikely(is_migrate_isolate_page(page)))
+				continue;
+
+			__mod_zone_page_state(zone, NR_FREE_PAGES, 1);
+			if (is_migrate_cma(page_mt))
+				__mod_zone_page_state(zone,
+						NR_FREE_CMA_PAGES, 1);
+		}
+
+		if (!count)
+			break;
 	}
+
+	if (count)
+		goto redo;
+
 	spin_unlock(&zone->lock);
 }
 
-- 
1.7.9.5

