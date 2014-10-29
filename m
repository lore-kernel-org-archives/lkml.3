Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbaJ2FfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 01:35:11 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:55021 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbaJ2FfG (ORCPT
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
Subject: [PATCHv2 3/3] staging: ion: debugfs to shrink pool
Date: Wed, 29 Oct 2014 14:36:00 +0900
Message-Id: <1414560960-21130-4-git-send-email-gioh.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414560960-21130-1-git-send-email-gioh.kim@lge.com>
References: <1414560960-21130-1-git-send-email-gioh.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables debugfs files /sys/kernel/debug/ion/heaps/system_shrink
,which was commented out, to shrink pool or get pool size
Reading the file returns pool size and writing occurs to shrink pool.

Signed-off-by: Gioh Kim <gioh.kim@lge.com>
---
 drivers/staging/android/ion/ion.c           |   31 +++++++--------------------
 drivers/staging/android/ion/ion_page_pool.c |    5 ++++-
 2 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 036e29b..4879076 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -1463,43 +1463,29 @@ static const struct file_operations debug_heap_fops = {
 	.release = single_release,
 };
 
-#ifdef DEBUG_HEAP_SHRINKER
 static int debug_shrink_set(void *data, u64 val)
 {
 	struct ion_heap *heap = data;
-	struct shrink_control sc;
 	int objs;
 
-	sc.gfp_mask = -1;
-	sc.nr_to_scan = 0;
-
-	if (!val)
-		return 0;
-
-	objs = heap->shrinker.shrink(&heap->shrinker, &sc);
-	sc.nr_to_scan = objs;
+	if (val)
+		objs = val;
+	else
+		objs = heap->ops->shrink(heap, __GFP_HIGHMEM, 0);
 
-	heap->shrinker.shrink(&heap->shrinker, &sc);
+	(void)heap->ops->shrink(heap, __GFP_HIGHMEM, objs);
 	return 0;
 }
 
 static int debug_shrink_get(void *data, u64 *val)
 {
 	struct ion_heap *heap = data;
-	struct shrink_control sc;
-	int objs;
-
-	sc.gfp_mask = -1;
-	sc.nr_to_scan = 0;
-
-	objs = heap->shrinker.shrink(&heap->shrinker, &sc);
-	*val = objs;
+	*val = heap->ops->shrink(heap, __GFP_HIGHMEM, 0);
 	return 0;
 }
 
 DEFINE_SIMPLE_ATTRIBUTE(debug_shrink_fops, debug_shrink_get,
 			debug_shrink_set, "%llu\n");
-#endif
 
 extern int pool_limit;
 extern const int num_orders;
@@ -1553,8 +1539,7 @@ void ion_device_add_heap(struct ion_device *dev, struct ion_heap *heap)
 			path, heap->name);
 	}
 
-#ifdef DEBUG_HEAP_SHRINKER
-	if (heap->shrinker.shrink) {
+	if (heap->ops->shrink) {
 		char debug_name[64];
 
 		snprintf(debug_name, 64, "%s_shrink", heap->name);
@@ -1581,7 +1566,7 @@ void ion_device_add_heap(struct ion_device *dev, struct ion_heap *heap)
 			       path, debug_name);
                 }
 	}
-#endif
+
 	up_write(&dev->lock);
 }
 
diff --git a/drivers/staging/android/ion/ion_page_pool.c b/drivers/staging/android/ion/ion_page_pool.c
index 15d1ac8..c473c2a 100644
--- a/drivers/staging/android/ion/ion_page_pool.c
+++ b/drivers/staging/android/ion/ion_page_pool.c
@@ -25,6 +25,9 @@
 #include <linux/kconfig.h>
 #include "ion_priv.h"
 
+/* limit number of pages each pool can have */
+int pool_limit;
+
 static void *ion_page_pool_alloc_pages(struct ion_page_pool *pool)
 {
 	struct page *page = alloc_pages(pool->gfp_mask, pool->order);
@@ -54,7 +57,7 @@ static int ion_page_pool_total(struct ion_page_pool *pool, bool high)
 
 static int ion_page_pool_add(struct ion_page_pool *pool, struct page *page)
 {
-	if (CONFIG_ION_POOL_LIMIT && ion_page_pool_total(pool, 1) > POOL_LIMIT)
+	if (pool_limit && ion_page_pool_total(pool, 1) > pool_limit)
 		return 1;
 
 	mutex_lock(&pool->mutex);
-- 
1.7.9.5

