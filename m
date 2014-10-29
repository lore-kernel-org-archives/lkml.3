Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbaJ2FfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 01:35:12 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:55023 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbaJ2FfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 01:35:06 -0400
X-Original-SENDERIP: 165.186.175.39
X-Original-MAILFROM: gioh.kim@lge.com
From: Gioh Kim <gioh.kim@lge.com>
To: gregkh@linuxfoundation.org, john.stultz@linaro.org, rebecca@android.com,
        lauraa@codeaurora.org, dan.carpenter@oracle.com, minchan@kernel.org,
        iamjoonsoo.kim@lge.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        gunho.lee@lge.com, Gioh Kim <gioh.kim@lge.com>
Subject: [PATCHv2 1/3] staging: ion: shrink page-pool by page unit
Date: Wed, 29 Oct 2014 14:35:58 +0900
Message-Id: <1414560960-21130-2-git-send-email-gioh.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414560960-21130-1-git-send-email-gioh.kim@lge.com>
References: <1414560960-21130-1-git-send-email-gioh.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch shrink page-pool by page unit.

Shrinker usually get the pool size with the pool-scanner
and pass the size to the pool-counter to shrink entire pool.
But the pool-scanner is working in block unit.
and pool-counter page unit.
So it is confused.

Change-Id: If25c693c09f6ebd14c87809feddb72f9058e8308
Signed-off-by: Gioh Kim <gioh.kim@lge.com>
---
 drivers/staging/android/ion/ion_page_pool.c   |    5 +++--
 drivers/staging/android/ion/ion_system_heap.c |   18 +++++++++++++++---
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/android/ion/ion_page_pool.c b/drivers/staging/android/ion/ion_page_pool.c
index 5864f3d..165152f 100644
--- a/drivers/staging/android/ion/ion_page_pool.c
+++ b/drivers/staging/android/ion/ion_page_pool.c
@@ -116,7 +116,7 @@ static int ion_page_pool_total(struct ion_page_pool *pool, bool high)
 int ion_page_pool_shrink(struct ion_page_pool *pool, gfp_t gfp_mask,
 				int nr_to_scan)
 {
-	int freed;
+	int freed = 0;
 	bool high;
 
 	if (current_is_kswapd())
@@ -127,7 +127,7 @@ int ion_page_pool_shrink(struct ion_page_pool *pool, gfp_t gfp_mask,
 	if (nr_to_scan == 0)
 		return ion_page_pool_total(pool, high);
 
-	for (freed = 0; freed < nr_to_scan; freed++) {
+	while (freed <= nr_to_scan) {
 		struct page *page;
 
 		mutex_lock(&pool->mutex);
@@ -141,6 +141,7 @@ int ion_page_pool_shrink(struct ion_page_pool *pool, gfp_t gfp_mask,
 		}
 		mutex_unlock(&pool->mutex);
 		ion_page_pool_free_pages(pool, page);
+		freed += (1 << pool->order);
 	}
 
 	return freed;
diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index da2a63c..0ba8aaf 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -29,7 +29,7 @@
 static gfp_t high_order_gfp_flags = (GFP_HIGHUSER | __GFP_ZERO | __GFP_NOWARN |
 				     __GFP_NORETRY) & ~__GFP_WAIT;
 static gfp_t low_order_gfp_flags  = (GFP_HIGHUSER | __GFP_ZERO | __GFP_NOWARN);
-static const unsigned int orders[] = {8, 4, 0};
+static const unsigned int orders[] = {8, 6, 4, 0};
 static const int num_orders = ARRAY_SIZE(orders);
 static int order_to_index(unsigned int order)
 {
@@ -212,14 +212,26 @@ static int ion_system_heap_shrink(struct ion_heap *heap, gfp_t gfp_mask,
 {
 	struct ion_system_heap *sys_heap;
 	int nr_total = 0;
-	int i;
+	int i, nr_freed;
+	int only_scan = 0;
 
 	sys_heap = container_of(heap, struct ion_system_heap, heap);
 
+	if (!nr_to_scan)
+		only_scan = 1;
+
 	for (i = 0; i < num_orders; i++) {
 		struct ion_page_pool *pool = sys_heap->pools[i];
 
-		nr_total += ion_page_pool_shrink(pool, gfp_mask, nr_to_scan);
+		nr_freed = ion_page_pool_shrink(pool, gfp_mask, nr_to_scan);
+		nr_total += nr_freed;
+
+		if (!only_scan) {
+			nr_to_scan -= nr_freed;
+			/* shrink completed */
+			if (nr_to_scan <= 0)
+				break;
+		}
 	}
 
 	return nr_total;
-- 
1.7.9.5

