Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbaAIHFK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 02:05:10 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:54034 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbaAIHEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 02:04:35 -0500
X-AuditID: 9c930197-b7b37ae000002e5a-d0-52ce49ffc5ee
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
Subject: [PATCH 7/7] mm/page_alloc: don't merge MIGRATE_(CMA|ISOLATE) pages on buddy
Date: Thu,  9 Jan 2014 16:04:47 +0900
Message-Id: <1389251087-10224-8-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389251087-10224-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1389251087-10224-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If (MAX_ORDER-1) is greater than pageblock order, there is a possibility
to merge different migratetype pages and to be linked in unintended
freelist.

While I test CMA, CMA pages are merged and linked into MOVABLE freelist
by above issue and then, the pages change their migratetype to UNMOVABLE by
try_to_steal_freepages(). After that, CMA to this region always fail.

To prevent this, we should not merge the page on MIGRATE_(CMA|ISOLATE)
freelist.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2548b42..ea99cee 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -581,6 +581,15 @@ static inline void __free_one_page(struct page *page,
 			__mod_zone_freepage_state(zone, 1 << order,
 						  migratetype);
 		} else {
+			int buddy_mt = get_buddy_migratetype(buddy);
+
+			/* We don't want to merge cma, isolate pages */
+			if (unlikely(order >= pageblock_order) &&
+				migratetype != buddy_mt &&
+				(migratetype >= MIGRATE_PCPTYPES ||
+				buddy_mt >= MIGRATE_PCPTYPES)) {
+				break;
+			}
 			list_del(&buddy->lru);
 			zone->free_area[order].nr_free--;
 			rmv_page_order(buddy);
-- 
1.7.9.5

