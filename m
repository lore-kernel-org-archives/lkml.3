Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbaL3KR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 05:17:59 -0500
Received: from mx1.mxmail.xiaomi.com ([58.68.235.87]:45147 "EHLO
	mx1.mxmail.xiaomi.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751993AbaL3KR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 05:17:58 -0500
From: Hui Zhu <zhuhui@xiaomi.com>
To: <akpm@linux-foundation.org>, <mgorman@suse.de>, <hannes@cmpxchg.org>,
        <riel@redhat.com>, <vbabka@suse.cz>, <iamjoonsoo.kim@lge.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <rientjes@google.com>,
        <sasha.levin@oracle.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>
CC: <teawater@gmail.com>, Hui Zhu <zhuhui@xiaomi.com>,
        Weixing Liu <liuweixing@xiaomi.com>
Subject: [PATCH] CMA: Fix CMA's page number is substructed twice in __zone_watermark_ok
Date: Tue, 30 Dec 2014 18:17:25 +0800
Message-ID: <1419934645-20106-1-git-send-email-zhuhui@xiaomi.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.27.14.101]
X-ClientProxiedBy: CNCAS3.mioffice.cn (10.237.8.133) To cnbox3.mioffice.cn
 (10.237.8.143)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original of this patch [1] is used to fix the issue in Joonsoo's CMA patch
"CMA: always treat free cma pages as non-free on watermark checking" [2].

Joonsoo reminded me that this issue affect current kernel too.  So made a new
one for upstream.

Function __zone_watermark_ok substruct CMA pages number from free_pages
if system allocation can't use CMA areas:
	/* If allocation can't use CMA areas don't use free CMA pages */
	if (!(alloc_flags & ALLOC_CMA))
		free_cma = zone_page_state(z, NR_FREE_CMA_PAGES);

But after this part of code
	for (o = 0; o < order; o++) {
		/* At the next order, this order's pages become unavailable */
		free_pages -= z->free_area[o].nr_free << o;
CMA memory in each order is part of z->free_area[o].nr_free, then the CMA
page number of this order is substructed twice.  This bug will make
__zone_watermark_ok return more false.

This patch add cma_free_area to struct free_area that just record the number
of CMA pages.  And add it back in the order loop to handle the substruct
twice issue.

[1] https://lkml.org/lkml/2014/12/25/43
[2] https://lkml.org/lkml/2014/5/28/110

Signed-off-by: Hui Zhu <zhuhui@xiaomi.com>
Signed-off-by: Weixing Liu <liuweixing@xiaomi.com>
---
 include/linux/mmzone.h |  3 +++
 mm/page_alloc.c        | 22 ++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 2f0856d..094476b 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -92,6 +92,9 @@ static inline int get_pfnblock_migratetype(struct page *page, unsigned long pfn)
 struct free_area {
 	struct list_head	free_list[MIGRATE_TYPES];
 	unsigned long		nr_free;
+#ifdef CONFIG_CMA
+	unsigned long		cma_nr_free;
+#endif
 };
 
 struct pglist_data;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 7633c50..026cf27 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -650,6 +650,8 @@ static inline void __free_one_page(struct page *page,
 		} else {
 			list_del(&buddy->lru);
 			zone->free_area[order].nr_free--;
+			if (is_migrate_cma(migratetype))
+				zone->free_area[order].cma_nr_free--;
 			rmv_page_order(buddy);
 		}
 		combined_idx = buddy_idx & page_idx;
@@ -683,6 +685,8 @@ static inline void __free_one_page(struct page *page,
 	list_add(&page->lru, &zone->free_area[order].free_list[migratetype]);
 out:
 	zone->free_area[order].nr_free++;
+	if (is_migrate_cma(migratetype))
+		zone->free_area[order].cma_nr_free++;
 }
 
 static inline int free_pages_check(struct page *page)
@@ -937,6 +941,8 @@ static inline void expand(struct zone *zone, struct page *page,
 		}
 		list_add(&page[size].lru, &area->free_list[migratetype]);
 		area->nr_free++;
+		if (is_migrate_cma(migratetype))
+			area->cma_nr_free++;
 		set_page_order(&page[size], high);
 	}
 }
@@ -1020,6 +1026,8 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 		list_del(&page->lru);
 		rmv_page_order(page);
 		area->nr_free--;
+		if (is_migrate_cma(migratetype))
+			area->cma_nr_free--;
 		expand(zone, page, order, current_order, area, migratetype);
 		set_freepage_migratetype(page, migratetype);
 		return page;
@@ -1208,6 +1216,8 @@ __rmqueue_fallback(struct zone *zone, unsigned int order, int start_migratetype)
 			page = list_entry(area->free_list[migratetype].next,
 					struct page, lru);
 			area->nr_free--;
+			if (is_migrate_cma(migratetype))
+				area->cma_nr_free--;
 
 			new_type = try_to_steal_freepages(zone, page,
 							  start_migratetype,
@@ -1597,6 +1607,8 @@ int __isolate_free_page(struct page *page, unsigned int order)
 	/* Remove page from free list */
 	list_del(&page->lru);
 	zone->free_area[order].nr_free--;
+	if (is_migrate_cma(mt))
+		zone->free_area[order].cma_nr_free--;
 	rmv_page_order(page);
 
 	/* Set the pageblock if the isolated page is at least a pageblock */
@@ -1827,6 +1839,13 @@ static bool __zone_watermark_ok(struct zone *z, unsigned int order,
 		/* At the next order, this order's pages become unavailable */
 		free_pages -= z->free_area[o].nr_free << o;
 
+		/* If CMA's page number of this order was substructed as part
+		   of "zone_page_state(z, NR_FREE_CMA_PAGES)", subtracting
+		   "z->free_area[o].nr_free << o" substructed CMA's page
+		   number of this order again.  So add it back.  */
+		if (IS_ENABLED(CONFIG_CMA) && free_cma)
+			free_pages += z->free_area[o].cma_nr_free << o;
+
 		/* Require fewer higher order pages to be free */
 		min >>= 1;
 
@@ -4238,6 +4257,7 @@ static void __meminit zone_init_free_lists(struct zone *zone)
 	for_each_migratetype_order(order, t) {
 		INIT_LIST_HEAD(&zone->free_area[order].free_list[t]);
 		zone->free_area[order].nr_free = 0;
+		zone->free_area[order].cma_nr_free = 0;
 	}
 }
 
@@ -6610,6 +6630,8 @@ __offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn)
 		list_del(&page->lru);
 		rmv_page_order(page);
 		zone->free_area[order].nr_free--;
+		if (is_migrate_cma(get_pageblock_migratetype(page)))
+			zone->free_area[order].cma_nr_free--;
 		for (i = 0; i < (1 << order); i++)
 			SetPageReserved((page+i));
 		pfn += (1 << order);
-- 
1.9.1

