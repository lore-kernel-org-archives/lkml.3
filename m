Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbaJXGrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 02:47:22 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:39515 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbaJXGqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 02:46:40 -0400
X-Original-SENDERIP: 165.186.175.39
X-Original-MAILFROM: gioh.kim@lge.com
From: Gioh Kim <gioh.kim@lge.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        gunho.lee@lge.com, gioh.kim@lge.com
Subject: [RFCv2 1/3] staging: ion: shrink page-pool by page unit
Date: Fri, 24 Oct 2014 15:47:26 +0900
Message-Id: <1414133248-639-2-git-send-email-gioh.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414133248-639-1-git-send-email-gioh.kim@lge.com>
References: <1414133248-639-1-git-send-email-gioh.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch shrink page-pool by page unit.

Signed-off-by: Gioh Kim <gioh.kim@lge.com>
---
 drivers/staging/android/ion/ion_page_pool.c   |    5 +++--
 drivers/staging/android/ion/ion_system_heap.c |    7 +++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

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
index da2a63c..91d862f 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -211,7 +211,7 @@ static int ion_system_heap_shrink(struct ion_heap *heap, gfp_t gfp_mask,
 					int nr_to_scan)
 {
 	struct ion_system_heap *sys_heap;
-	int nr_total = 0;
+	int nr_total = 0, nr_freed;
 	int i;
 
 	sys_heap = container_of(heap, struct ion_system_heap, heap);
@@ -219,7 +219,10 @@ static int ion_system_heap_shrink(struct ion_heap *heap, gfp_t gfp_mask,
 	for (i = 0; i < num_orders; i++) {
 		struct ion_page_pool *pool = sys_heap->pools[i];
 
-		nr_total += ion_page_pool_shrink(pool, gfp_mask, nr_to_scan);
+		nr_freed = ion_page_pool_shrink(pool, gfp_mask, nr_to_scan);
+		nr_total += nr_freed;
+		/* nr_to_scan can be negative */
+		nr_to_scan -= nr_freed;
 	}
 
 	return nr_total;
-- 
1.7.9.5

