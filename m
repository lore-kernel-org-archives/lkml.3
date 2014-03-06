Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbaCFRfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 12:35:30 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:47336 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbaCFRf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 12:35:27 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-bc-5318b1ddb02e
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Yong-Taek Lee <ytk.lee@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] mm/page_alloc: fix freeing of MIGRATE_RESERVE migratetype
 pages
Date: Thu, 06 Mar 2014 18:35:12 +0100
Message-id: <3269714.29dGMiCR2L@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t9jAd27GyWCDZ5NNLV4+qmPxeLyrjls
	FvfW/Ge1WHvkLrvF5HfPGC0er+d2YPNYsKnUY9OnSewefVtWMXpsPl3t8XmTXABrFJdNSmpO
	Zllqkb5dAlfGlMVf2AtmyFd0rb3O0sB4VLKLkZNDQsBE4uerJawQtpjEhXvr2boYuTiEBBYx
	Snyc+4ARwmlhkuiad4gNpIpNwEpiYvsqoAQHh4iAgsTc9+YgNcwCaxklznY+ZAeJCwuESrT+
	rwEpZxFQlWj495oZxOYV0JRY9uIAI4gtKuApsWP7SjaIuKDEj8n3WEBsZgF5iX37p7JC2FoS
	63ceZ5rAyDcLSdksJGWzkJQtYGRexSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREcpM+kdjCu
	bLA4xCjAwajEw9uxSCJYiDWxrLgy9xCjBAezkgjvIpAQb0piZVVqUX58UWlOavEhRmkOFiVx
	3gOt1oFCAumJJanZqakFqUUwWSYOTqkGxkVJN8WYnul9mL2k99J58XV5iYxC+48Lyfqm2PF8
	dJR801a3sp9J5OmUeYbzL93xs0tZfy43tyVetem53/87t/wcUhjjVj1/0qKwbUq0a+Vnw2pr
	S9PjK0+kaB7fqem7ICbo+Tvxixw1u15fzTjNLLx4Xbycg9sPMSHDff/V9RbfnVM1uT1CXoml
	OCPRUIu5qDgRACSpsNtOAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pages allocated from MIGRATE_RESERVE migratetype pageblocks
are not freed back to MIGRATE_RESERVE migratetype free
lists in free_pcppages_bulk()->__free_one_page() if we got
to free_pcppages_bulk() through drain_[zone_]pages().
The freeing through free_hot_cold_page() is okay because
freepage migratetype is set to pageblock migratetype before
calling free_pcppages_bulk().  If pages of MIGRATE_RESERVE
migratetype end up on the free lists of other migratetype
whole Reserved pageblock may be later changed to the other
migratetype in __rmqueue_fallback() and it will be never
changed back to be a Reserved pageblock.  Fix the issue by
moving freepage migratetype setting from rmqueue_bulk() to
__rmqueue[_fallback]() and preserving freepage migratetype
as an original pageblock migratetype for MIGRATE_RESERVE
migratetype pages.

The problem was introduced in v2.6.31 by commit ed0ae21
("page allocator: do not call get_pageblock_migratetype()
more than necessary").

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Reported-by: Yong-Taek Lee <ytk.lee@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
---
v2:
- updated patch description, there is no __zone_pcp_update()
  in newer kernels
v3:
- set freepage migratetype in __rmqueue[_fallback]()
  instead of rmqueue_bulk() (per Mel's request)

 mm/page_alloc.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

Index: b/mm/page_alloc.c
===================================================================
--- a/mm/page_alloc.c	2014-03-06 18:10:21.884422983 +0100
+++ b/mm/page_alloc.c	2014-03-06 18:10:27.016422895 +0100
@@ -1094,7 +1094,7 @@ __rmqueue_fallback(struct zone *zone, in
 	struct free_area *area;
 	int current_order;
 	struct page *page;
-	int migratetype, new_type, i;
+	int migratetype, new_type, mt = start_migratetype, i;
 
 	/* Find the largest possible block of pages in the other list */
 	for (current_order = MAX_ORDER-1; current_order >= order;
@@ -1125,6 +1125,14 @@ __rmqueue_fallback(struct zone *zone, in
 			expand(zone, page, order, current_order, area,
 			       new_type);
 
+			if (IS_ENABLED(CONFIG_CMA)) {
+				mt = get_pageblock_migratetype(page);
+				if (!is_migrate_cma(mt) &&
+				    !is_migrate_isolate(mt))
+					mt = start_migratetype;
+			}
+			set_freepage_migratetype(page, mt);
+
 			trace_mm_page_alloc_extfrag(page, order, current_order,
 				start_migratetype, migratetype, new_type);
 
@@ -1147,7 +1155,9 @@ static struct page *__rmqueue(struct zon
 retry_reserve:
 	page = __rmqueue_smallest(zone, order, migratetype);
 
-	if (unlikely(!page) && migratetype != MIGRATE_RESERVE) {
+	if (likely(page)) {
+		set_freepage_migratetype(page, migratetype);
+	} else if (migratetype != MIGRATE_RESERVE) {
 		page = __rmqueue_fallback(zone, order, migratetype);
 
 		/*
@@ -1174,7 +1184,7 @@ static int rmqueue_bulk(struct zone *zon
 			unsigned long count, struct list_head *list,
 			int migratetype, int cold)
 {
-	int mt = migratetype, i;
+	int i;
 
 	spin_lock(&zone->lock);
 	for (i = 0; i < count; ++i) {
@@ -1195,16 +1205,15 @@ static int rmqueue_bulk(struct zone *zon
 			list_add(&page->lru, list);
 		else
 			list_add_tail(&page->lru, list);
+		list = &page->lru;
 		if (IS_ENABLED(CONFIG_CMA)) {
-			mt = get_pageblock_migratetype(page);
+			int mt = get_pageblock_migratetype(page);
 			if (!is_migrate_cma(mt) && !is_migrate_isolate(mt))
 				mt = migratetype;
+			if (is_migrate_cma(mt))
+				__mod_zone_page_state(zone, NR_FREE_CMA_PAGES,
+						      -(1 << order));
 		}
-		set_freepage_migratetype(page, mt);
-		list = &page->lru;
-		if (is_migrate_cma(mt))
-			__mod_zone_page_state(zone, NR_FREE_CMA_PAGES,
-					      -(1 << order));
 	}
 	__mod_zone_page_state(zone, NR_FREE_PAGES, -(i << order));
 	spin_unlock(&zone->lock);

