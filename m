Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab3IYXUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:20:48 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:49960 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685Ab3IYXUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:20:46 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v4 12/40] mm: Add support to accurately track
 per-memory-region allocation
To: akpm@linux-foundation.org, mgorman@suse.de, dave@sr71.net,
        hannes@cmpxchg.org, tony.luck@intel.com, matthew.garrett@nebula.com,
        riel@redhat.com, arjan@linux.intel.com,
        srinivas.pandruvada@linux.intel.com, willy@linux.intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, lenb@kernel.org, rjw@sisk.pl
Cc: gargankita@gmail.com, paulmck@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, andi@firstfloor.org,
        isimatu.yasuaki@jp.fujitsu.com, santosh.shilimkar@ti.com,
        kosaki.motohiro@gmail.com, srivatsa.bhat@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Thu, 26 Sep 2013 04:46:28 +0530
Message-ID: <20130925231626.26184.25777.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
References: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092523-7014-0000-0000-000003AB4ED7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The page allocator can make smarter decisions to influence memory power
management, if we track the per-region memory allocations closely.
So add the necessary support to accurately track allocations on a per-region
basis.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/mmzone.h |    2 +
 mm/page_alloc.c        |   65 +++++++++++++++++++++++++++++++++++-------------
 2 files changed, 50 insertions(+), 17 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 472c76a..155c1a1 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -86,6 +86,7 @@ static inline int get_pageblock_migratetype(struct page *page)
 struct mem_region_list {
 	struct list_head	*page_block;
 	unsigned long		nr_free;
+	struct zone_mem_region	*zone_region;
 };
 
 struct free_list {
@@ -342,6 +343,7 @@ struct zone_mem_region {
 	unsigned long end_pfn;
 	unsigned long present_pages;
 	unsigned long spanned_pages;
+	unsigned long nr_free;
 };
 
 struct zone {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index daac5fd..fbaa2dc 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -635,7 +635,8 @@ out:
 	return prev_region_id;
 }
 
-static void add_to_freelist(struct page *page, struct free_list *free_list)
+static void add_to_freelist(struct page *page, struct free_list *free_list,
+			    int order)
 {
 	struct list_head *prev_region_list, *lru;
 	struct mem_region_list *region;
@@ -646,6 +647,7 @@ static void add_to_freelist(struct page *page, struct free_list *free_list)
 
 	region = &free_list->mr_list[region_id];
 	region->nr_free++;
+	region->zone_region->nr_free += 1 << order;
 
 	if (region->page_block) {
 		list_add_tail(lru, region->page_block);
@@ -700,9 +702,10 @@ out:
  * inside the freelist.
  */
 static void rmqueue_del_from_freelist(struct page *page,
-				      struct free_list *free_list)
+				      struct free_list *free_list, int order)
 {
 	struct list_head *lru = &page->lru;
+	struct mem_region_list *mr_list;
 	int region_id;
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
@@ -712,8 +715,11 @@ static void rmqueue_del_from_freelist(struct page *page,
 
 	list_del(lru);
 
+	mr_list = free_list->next_region;
+	mr_list->zone_region->nr_free -= 1 << order;
+
 	/* Fastpath */
-	if (--(free_list->next_region->nr_free)) {
+	if (--(mr_list->nr_free)) {
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
 		WARN(free_list->next_region->nr_free < 0,
@@ -735,7 +741,8 @@ static void rmqueue_del_from_freelist(struct page *page,
 }
 
 /* Generic delete function for region-aware buddy allocator. */
-static void del_from_freelist(struct page *page, struct free_list *free_list)
+static void del_from_freelist(struct page *page, struct free_list *free_list,
+			      int order)
 {
 	struct list_head *prev_page_lru, *lru, *p;
 	struct mem_region_list *region;
@@ -745,11 +752,12 @@ static void del_from_freelist(struct page *page, struct free_list *free_list)
 
 	/* Try to fastpath, if deleting from the head of the list */
 	if (lru == free_list->list.next)
-		return rmqueue_del_from_freelist(page, free_list);
+		return rmqueue_del_from_freelist(page, free_list, order);
 
 	region_id = page_zone_region_id(page);
 	region = &free_list->mr_list[region_id];
 	region->nr_free--;
+	region->zone_region->nr_free -= 1 << order;
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
 	WARN(region->nr_free < 0, "%s: nr_free is negative\n", __func__);
@@ -804,10 +812,10 @@ page_found:
  * Move a given page from one freelist to another.
  */
 static void move_page_freelist(struct page *page, struct free_list *old_list,
-			       struct free_list *new_list)
+			       struct free_list *new_list, int order)
 {
-	del_from_freelist(page, old_list);
-	add_to_freelist(page, new_list);
+	del_from_freelist(page, old_list, order);
+	add_to_freelist(page, new_list, order);
 }
 
 /*
@@ -877,7 +885,7 @@ static inline void __free_one_page(struct page *page,
 
 			area = &zone->free_area[order];
 			mt = get_freepage_migratetype(buddy);
-			del_from_freelist(buddy, &area->free_list[mt]);
+			del_from_freelist(buddy, &area->free_list[mt], order);
 			area->nr_free--;
 			rmv_page_order(buddy);
 			set_freepage_migratetype(buddy, migratetype);
@@ -913,12 +921,13 @@ static inline void __free_one_page(struct page *page,
 			 * switch off this entire "is next-higher buddy free?"
 			 * logic when memory regions are used.
 			 */
-			add_to_freelist(page, &area->free_list[migratetype]);
+			add_to_freelist(page, &area->free_list[migratetype],
+					order);
 			goto out;
 		}
 	}
 
-	add_to_freelist(page, &area->free_list[migratetype]);
+	add_to_freelist(page, &area->free_list[migratetype], order);
 out:
 	area->nr_free++;
 }
@@ -1139,7 +1148,8 @@ static inline void expand(struct zone *zone, struct page *page,
 			continue;
 		}
 #endif
-		add_to_freelist(&page[size], &area->free_list[migratetype]);
+		add_to_freelist(&page[size], &area->free_list[migratetype],
+				high);
 		area->nr_free++;
 		set_page_order(&page[size], high);
 
@@ -1213,7 +1223,8 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 
 		page = list_entry(area->free_list[migratetype].list.next,
 							struct page, lru);
-		rmqueue_del_from_freelist(page, &area->free_list[migratetype]);
+		rmqueue_del_from_freelist(page, &area->free_list[migratetype],
+					  current_order);
 		rmv_page_order(page);
 		area->nr_free--;
 		expand(zone, page, order, current_order, area, migratetype);
@@ -1286,7 +1297,7 @@ int move_freepages(struct zone *zone,
 		old_mt = get_freepage_migratetype(page);
 		area = &zone->free_area[order];
 		move_page_freelist(page, &area->free_list[old_mt],
-				    &area->free_list[migratetype]);
+				    &area->free_list[migratetype], order);
 		set_freepage_migratetype(page, migratetype);
 		page += 1 << order;
 		pages_moved += 1 << order;
@@ -1406,7 +1417,8 @@ __rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
 
 			/* Remove the page from the freelists */
 			mt = get_freepage_migratetype(page);
-			del_from_freelist(page, &area->free_list[mt]);
+			del_from_freelist(page, &area->free_list[mt],
+					  current_order);
 			rmv_page_order(page);
 
 			/*
@@ -1767,7 +1779,7 @@ static int __isolate_free_page(struct page *page, unsigned int order)
 
 	/* Remove page from free list */
 	mt = get_freepage_migratetype(page);
-	del_from_freelist(page, &zone->free_area[order].free_list[mt]);
+	del_from_freelist(page, &zone->free_area[order].free_list[mt], order);
 	zone->free_area[order].nr_free--;
 	rmv_page_order(page);
 
@@ -5204,6 +5216,22 @@ static void __meminit init_node_memory_regions(struct pglist_data *pgdat)
 	pgdat->nr_node_regions = idx;
 }
 
+static void __meminit zone_init_free_lists_late(struct zone *zone)
+{
+	struct mem_region_list *mr_list;
+	int order, t, i;
+
+	for_each_migratetype_order(order, t) {
+		for (i = 0; i < zone->nr_zone_regions; i++) {
+			mr_list =
+				&zone->free_area[order].free_list[t].mr_list[i];
+
+			mr_list->nr_free = 0;
+			mr_list->zone_region = &zone->zone_regions[i];
+		}
+	}
+}
+
 /*
  * Zone-region indices are used to map node-memory-regions to
  * zone-memory-regions. Initialize all of them to an invalid value (-1),
@@ -5272,6 +5300,8 @@ static void __meminit init_zone_memory_regions(struct pglist_data *pgdat)
 
 		z->nr_zone_regions = idx;
 
+		zone_init_free_lists_late(z);
+
 		/*
 		 * Revisit the last visited node memory region, in case it
 		 * spans multiple zones.
@@ -6795,7 +6825,8 @@ __offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn)
 		       pfn, 1 << order, end_pfn);
 #endif
 		mt = get_freepage_migratetype(page);
-		del_from_freelist(page, &zone->free_area[order].free_list[mt]);
+		del_from_freelist(page, &zone->free_area[order].free_list[mt],
+				  order);
 		rmv_page_order(page);
 		zone->free_area[order].nr_free--;
 #ifdef CONFIG_HIGHMEM

