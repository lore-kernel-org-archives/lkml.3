Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbaJ2FfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 01:35:09 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:55020 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbaJ2FfG (ORCPT
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
Subject: [PATCHv2 2/3] staging: ion: limit pool size
Date: Wed, 29 Oct 2014 14:35:59 +0900
Message-Id: <1414560960-21130-3-git-send-email-gioh.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414560960-21130-1-git-send-email-gioh.kim@lge.com>
References: <1414560960-21130-1-git-send-email-gioh.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch limits pool size by page unit.
And enable a debugfs file to set limit.

Change-Id: Idaef4daa69084e8ec0844ecefc6738afeab79ccb
Signed-off-by: Gioh Kim <gioh.kim@lge.com>
---
 drivers/staging/android/ion/ion.c             |   31 +++++++++++++++++++++++++
 drivers/staging/android/ion/ion_page_pool.c   |   24 +++++++++++--------
 drivers/staging/android/ion/ion_system_heap.c |    2 +-
 3 files changed, 46 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 290d4d2..036e29b 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -1501,6 +1501,25 @@ DEFINE_SIMPLE_ATTRIBUTE(debug_shrink_fops, debug_shrink_get,
 			debug_shrink_set, "%llu\n");
 #endif
 
+extern int pool_limit;
+extern const int num_orders;
+
+static int debug_limit_set(void *data, u64 val)
+{
+        /* val is kb unit, pool_limit is for page limit of individual pool */
+        pool_limit = (int)(val / PAGE_SIZE) / num_orders;
+        return 0;
+}
+
+static int debug_limit_get(void *data, u64 *val)
+{
+        *val = pool_limit * PAGE_SIZE * num_orders;
+        return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(debug_limit_fops, debug_limit_get,
+                        debug_limit_set, "%llu\n");
+
 void ion_device_add_heap(struct ion_device *dev, struct ion_heap *heap)
 {
 	struct dentry *debug_file;
@@ -1549,6 +1568,18 @@ void ion_device_add_heap(struct ion_device *dev, struct ion_heap *heap)
 			pr_err("Failed to create heap shrinker debugfs at %s/%s\n",
 				path, debug_name);
 		}
+
+		snprintf(debug_name, 64, "%s_limit", heap->name);
+                debug_file = debugfs_create_file(
+                        debug_name, 0644, dev->heaps_debug_root, heap,
+                        &debug_limit_fops);
+                if (!debug_file) {
+                        char buf[256], *path;
+
+                        path = dentry_path(dev->heaps_debug_root, buf, 256);
+                        pr_err("Failed to create heap shrinker debugfs at %s/%s\n",
+			       path, debug_name);
+                }
 	}
 #endif
 	up_write(&dev->lock);
diff --git a/drivers/staging/android/ion/ion_page_pool.c b/drivers/staging/android/ion/ion_page_pool.c
index 165152f..15d1ac8 100644
--- a/drivers/staging/android/ion/ion_page_pool.c
+++ b/drivers/staging/android/ion/ion_page_pool.c
@@ -22,6 +22,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/swap.h>
+#include <linux/kconfig.h>
 #include "ion_priv.h"
 
 static void *ion_page_pool_alloc_pages(struct ion_page_pool *pool)
@@ -41,8 +42,21 @@ static void ion_page_pool_free_pages(struct ion_page_pool *pool,
 	__free_pages(page, pool->order);
 }
 
+static int ion_page_pool_total(struct ion_page_pool *pool, bool high)
+{
+	int count = pool->low_count;
+
+	if (high)
+		count += pool->high_count;
+
+	return count << pool->order;
+}
+
 static int ion_page_pool_add(struct ion_page_pool *pool, struct page *page)
 {
+	if (CONFIG_ION_POOL_LIMIT && ion_page_pool_total(pool, 1) > POOL_LIMIT)
+		return 1;
+
 	mutex_lock(&pool->mutex);
 	if (PageHighMem(page)) {
 		list_add_tail(&page->lru, &pool->high_items);
@@ -103,16 +117,6 @@ void ion_page_pool_free(struct ion_page_pool *pool, struct page *page)
 		ion_page_pool_free_pages(pool, page);
 }
 
-static int ion_page_pool_total(struct ion_page_pool *pool, bool high)
-{
-	int count = pool->low_count;
-
-	if (high)
-		count += pool->high_count;
-
-	return count << pool->order;
-}
-
 int ion_page_pool_shrink(struct ion_page_pool *pool, gfp_t gfp_mask,
 				int nr_to_scan)
 {
diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 0ba8aaf..d6c0acd 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -30,7 +30,7 @@ static gfp_t high_order_gfp_flags = (GFP_HIGHUSER | __GFP_ZERO | __GFP_NOWARN |
 				     __GFP_NORETRY) & ~__GFP_WAIT;
 static gfp_t low_order_gfp_flags  = (GFP_HIGHUSER | __GFP_ZERO | __GFP_NOWARN);
 static const unsigned int orders[] = {4, 3, 2, 0};
-static const int num_orders = ARRAY_SIZE(orders);
+const int num_orders = ARRAY_SIZE(orders);
 static int order_to_index(unsigned int order)
 {
 	int i;
-- 
1.7.9.5

