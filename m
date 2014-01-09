Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbaAIHFR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 02:05:17 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:43856 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaAIHEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 02:04:32 -0500
X-AuditID: 9c930197-b7b37ae000002e5a-c3-52ce49fdb87f
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
Subject: [PATCH 2/7] mm/cma: fix cma free page accounting
Date: Thu,  9 Jan 2014 16:04:42 +0900
Message-Id: <1389251087-10224-3-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389251087-10224-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1389251087-10224-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cma pages can be allocated by not only order 0 request but also high order
request. So, we should consider to account free cma page in the both
places.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b36aa5a..1489c301 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1091,6 +1091,12 @@ __rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
 							  start_migratetype,
 							  migratetype);
 
+			/* CMA pages cannot be stolen */
+			if (is_migrate_cma(migratetype)) {
+				__mod_zone_page_state(zone,
+					NR_FREE_CMA_PAGES, -(1 << order));
+			}
+
 			/* Remove the page from the freelists */
 			list_del(&page->lru);
 			rmv_page_order(page);
@@ -1175,9 +1181,6 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
 		}
 		set_freepage_migratetype(page, mt);
 		list = &page->lru;
-		if (is_migrate_cma(mt))
-			__mod_zone_page_state(zone, NR_FREE_CMA_PAGES,
-					      -(1 << order));
 	}
 	__mod_zone_page_state(zone, NR_FREE_PAGES, -(i << order));
 	spin_unlock(&zone->lock);
-- 
1.7.9.5

