Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaLYKIO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 05:08:14 -0500
Received: from mx1.mxmail.xiaomi.com ([58.68.235.87]:19578 "EHLO
	mx1.mxmail.xiaomi.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751637AbaLYKIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 05:08:09 -0500
X-Greylist: delayed 875 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Dec 2014 05:08:08 EST
From: Hui Zhu <zhuhui@xiaomi.com>
To: <m.szyprowski@samsung.com>, <mina86@mina86.com>,
        <akpm@linux-foundation.org>, <iamjoonsoo.kim@lge.com>,
        <aneesh.kumar@linux.vnet.ibm.com>, <pintu.k@samsung.com>,
        <weijie.yang@samsung.com>, <mgorman@suse.de>, <hannes@cmpxchg.org>,
        <riel@redhat.com>, <vbabka@suse.cz>,
        <laurent.pinchart+renesas@ideasonboard.com>, <rientjes@google.com>,
        <sasha.levin@oracle.com>, <liuweixing@xiaomi.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <teawater@gmail.com>, Hui Zhu <zhuhui@xiaomi.com>
Subject: [PATCH 2/3] CMA: Fix the issue that nr_try_movable just count MIGRATE_MOVABLE memory
Date: Thu, 25 Dec 2014 17:43:27 +0800
Message-ID: <1419500608-11656-3-git-send-email-zhuhui@xiaomi.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419500608-11656-1-git-send-email-zhuhui@xiaomi.com>
References: <1419500608-11656-1-git-send-email-zhuhui@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.27.14.101]
X-ClientProxiedBy: CNCAS3.mioffice.cn (10.237.8.133) To cnbox4.mioffice.cn
 (10.237.8.144)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of my plotform that use Joonsoo's CMA patch [1] has a device that
will alloc a lot of MIGRATE_UNMOVABLE memory when it works in a zone.
When this device works, the memory status of this zone is not OK.  Most of
CMA is not allocated but most normal memory is allocated.
This issue is because in __rmqueue:
	if (IS_ENABLED(CONFIG_CMA) &&
		migratetype == MIGRATE_MOVABLE && zone->managed_cma_pages)
		page = __rmqueue_cma(zone, order);
Just allocated MIGRATE_MOVABLE will be record in nr_try_movable in function
__rmqueue_cma but not the others.  This device allocated a lot of
MIGRATE_UNMOVABLE memory affect the behavior of this zone memory allocation.

This patch change __rmqueue to let nr_try_movable record all the memory
allocation of normal memory.

[1] https://lkml.org/lkml/2014/5/28/64

Signed-off-by: Hui Zhu <zhuhui@xiaomi.com>
Signed-off-by: Weixing Liu <liuweixing@xiaomi.com>
---
 mm/page_alloc.c | 41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a8d9f03..a5bbc38 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1301,28 +1301,23 @@ static struct page *__rmqueue_cma(struct zone *zone, unsigned int order)
 {
 	struct page *page;
 
-	if (zone->nr_try_movable > 0)
-		goto alloc_movable;
+	if (zone->nr_try_cma <= 0) {
+		/* Reset counter */
+		zone->nr_try_movable = zone->max_try_movable;
+		zone->nr_try_cma = zone->max_try_cma;
 
-	if (zone->nr_try_cma > 0) {
-		/* Okay. Now, we can try to allocate the page from cma region */
-		zone->nr_try_cma -= 1 << order;
-		page = __rmqueue_smallest(zone, order, MIGRATE_CMA);
-
-		/* CMA pages can vanish through CMA allocation */
-		if (unlikely(!page && order == 0))
-			zone->nr_try_cma = 0;
-
-		return page;
+		return NULL;
 	}
 
-	/* Reset counter */
-	zone->nr_try_movable = zone->max_try_movable;
-	zone->nr_try_cma = zone->max_try_cma;
+	/* Okay. Now, we can try to allocate the page from cma region */
+	zone->nr_try_cma -= 1 << order;
+	page = __rmqueue_smallest(zone, order, MIGRATE_CMA);
 
-alloc_movable:
-	zone->nr_try_movable -= 1 << order;
-	return NULL;
+	/* CMA pages can vanish through CMA allocation */
+	if (unlikely(!page && order == 0))
+		zone->nr_try_cma = 0;
+
+	return page;
 }
 #endif
 
@@ -1335,9 +1330,13 @@ static struct page *__rmqueue(struct zone *zone, unsigned int order,
 {
 	struct page *page = NULL;
 
-	if (IS_ENABLED(CONFIG_CMA) &&
-		migratetype == MIGRATE_MOVABLE && zone->managed_cma_pages)
-		page = __rmqueue_cma(zone, order);
+	if (IS_ENABLED(CONFIG_CMA) && zone->managed_cma_pages) {
+		if (migratetype == MIGRATE_MOVABLE
+		    && zone->nr_try_movable <= 0)
+			page = __rmqueue_cma(zone, order);
+		else
+			zone->nr_try_movable -= 1 << order;
+	}
 
 retry_reserve:
 	if (!page)
-- 
1.9.1

