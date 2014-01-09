Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140AbaAIHFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 02:05:22 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:54034 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbaAIHEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 02:04:32 -0500
X-AuditID: 9c930197-b7b37ae000002e5a-c6-52ce49fed4b0
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Jiang Liu <jiang.liu@huawei.com>,
        Mel Gorman <mgorman@suse.de>, Cody P Schafer <cody@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Minchan Kim <minchan@kernel.org>,
        Michal Nazarewicz <mina86@mina86.com>, Andi Kleen <ak@linux.intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Tang Chen <tangchen@cn.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 3/7] mm/page_alloc: move set_freepage_migratetype() to better place
Date: Thu,  9 Jan 2014 16:04:43 +0900
Message-Id: <1389251087-10224-4-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389251087-10224-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1389251087-10224-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set_freepage_migratetype() inform us of the buddy freelist where
the page should be linked when it goes to buddy freelist.

Now, it has done in rmqueue_bulk() so that we should call
get_pageblock_migratetype() to know it's migratetype exactly if
CONFIG_CMA is enabled. That function has some overhead so that
removing it is preferable.

To remove it, we move set_freepage_migratetype() to __rmqueue_fallback()
and __rmqueue_smallest(). In those functions, we can know migratetype
easily so that we don't need to call get_pageblock_migratetype().

Removing is_migrate_isolate() is safe since what we want to ensure is
that the page from cma will not go to other migratetype freelist.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1489c301..4913829 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -903,6 +903,7 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 		rmv_page_order(page);
 		area->nr_free--;
 		expand(zone, page, order, current_order, area, migratetype);
+		set_freepage_migratetype(page, migratetype);
 		return page;
 	}
 
@@ -1093,8 +1094,12 @@ __rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
 
 			/* CMA pages cannot be stolen */
 			if (is_migrate_cma(migratetype)) {
+				set_freepage_migratetype(page, migratetype);
 				__mod_zone_page_state(zone,
 					NR_FREE_CMA_PAGES, -(1 << order));
+			} else {
+				set_freepage_migratetype(page,
+							start_migratetype);
 			}
 
 			/* Remove the page from the freelists */
@@ -1153,7 +1158,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
 			unsigned long count, struct list_head *list,
 			int migratetype, int cold)
 {
-	int mt = migratetype, i;
+	int i;
 
 	spin_lock(&zone->lock);
 	for (i = 0; i < count; ++i) {
@@ -1174,12 +1179,6 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
 			list_add(&page->lru, list);
 		else
 			list_add_tail(&page->lru, list);
-		if (IS_ENABLED(CONFIG_CMA)) {
-			mt = get_pageblock_migratetype(page);
-			if (!is_migrate_cma(mt) && !is_migrate_isolate(mt))
-				mt = migratetype;
-		}
-		set_freepage_migratetype(page, mt);
 		list = &page->lru;
 	}
 	__mod_zone_page_state(zone, NR_FREE_PAGES, -(i << order));
-- 
1.7.9.5

