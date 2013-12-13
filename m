Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab3LMW1X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:27:23 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:48643 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab3LMW1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:27:14 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 041/115] gpu: ion: Switch to using a single shrink function
Date: Fri, 13 Dec 2013 14:24:15 -0800
Message-Id: <1386973529-4884-42-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

The single shrink function will free lower order pages first. This
enables compaction to work properly.

[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_page_pool.c | 150 ++++++++++++++++++++++------
 drivers/staging/android/ion/ion_priv.h      |   3 +-
 2 files changed, 123 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/android/ion/ion_page_pool.c b/drivers/staging/android/ion/ion_page_pool.c
index 20790eb..e59da3a 100644
--- a/drivers/staging/android/ion/ion_page_pool.c
+++ b/drivers/staging/android/ion/ion_page_pool.c
@@ -14,13 +14,21 @@
  *
  */
 
+#include <linux/debugfs.h>
 #include <linux/dma-mapping.h>
 #include <linux/err.h>
+#include <linux/fs.h>
 #include <linux/list.h>
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/shrinker.h>
 #include "ion_priv.h"
 
+/* #define DEBUG_PAGE_POOL_SHRINKER */
+
+static struct plist_head pools = PLIST_HEAD_INIT(pools);
+static struct shrinker shrinker;
+
 struct ion_page_pool_item {
 	struct page *page;
 	struct list_head list;
@@ -118,46 +126,110 @@ void ion_page_pool_free(struct ion_page_pool *pool, struct page* page)
 		ion_page_pool_free_pages(pool, page);
 }
 
+#ifdef DEBUG_PAGE_POOL_SHRINKER
+static int debug_drop_pools_set(void *data, u64 val)
+{
+	struct shrink_control sc;
+	int objs;
+
+	sc.gfp_mask = -1;
+	sc.nr_to_scan = 0;
+
+	if (!val)
+		return 0;
+
+	objs = shrinker.shrink(&shrinker, &sc);
+	sc.nr_to_scan = objs;
+
+	shrinker.shrink(&shrinker, &sc);
+	return 0;
+}
+
+static int debug_drop_pools_get(void *data, u64 *val)
+{
+	struct shrink_control sc;
+	int objs;
+
+	sc.gfp_mask = -1;
+	sc.nr_to_scan = 0;
+
+	objs = shrinker.shrink(&shrinker, &sc);
+	*val = objs;
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(debug_drop_pools_fops, debug_drop_pools_get,
+                        debug_drop_pools_set, "%llu\n");
+
+static int debug_grow_pools_set(void *data, u64 val)
+{
+	struct ion_page_pool *pool;
+	struct page *page;
+
+	plist_for_each_entry(pool, &pools, list) {
+		if (val != pool->list.prio)
+			continue;
+		page = ion_page_pool_alloc_pages(pool);
+		if (page)
+			ion_page_pool_add(pool, page);
+	}
+
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(debug_grow_pools_fops, debug_drop_pools_get,
+			debug_grow_pools_set, "%llu\n");
+#endif
+
+static int ion_page_pool_total(bool high)
+{
+	struct ion_page_pool *pool;
+	int total = 0;
+
+	plist_for_each_entry(pool, &pools, list) {
+		total += high ? (pool->high_count + pool->low_count) *
+			(1 << pool->order) :
+			pool->low_count * (1 << pool->order);
+	}
+	return total;
+}
+
 static int ion_page_pool_shrink(struct shrinker *shrinker,
 				 struct shrink_control *sc)
 {
-	struct ion_page_pool *pool = container_of(shrinker,
-						 struct ion_page_pool,
-						 shrinker);
+	struct ion_page_pool *pool;
 	int nr_freed = 0;
 	int i;
 	bool high;
+	int nr_to_scan = sc->nr_to_scan;
 
 	if (sc->gfp_mask & __GFP_HIGHMEM)
 		high = true;
 
-	if (sc->nr_to_scan == 0)
-		return high ? (pool->high_count + pool->low_count) *
-			(1 << pool->order) :
-			pool->low_count * (1 << pool->order);
+	if (nr_to_scan == 0)
+		return ion_page_pool_total(high);
 
-	for (i = 0; i < sc->nr_to_scan; i++) {
-		struct page *page;
+	plist_for_each_entry(pool, &pools, list) {
+		for (i = 0; i < nr_to_scan; i++) {
+			struct page *page;
 
-		mutex_lock(&pool->mutex);
-		if (high && pool->high_count) {
-			page = ion_page_pool_remove(pool, true);
-		} else if (pool->low_count) {
-			page = ion_page_pool_remove(pool, false);
-		} else {
+			mutex_lock(&pool->mutex);
+			if (high && pool->high_count) {
+				page = ion_page_pool_remove(pool, true);
+			} else if (pool->low_count) {
+				page = ion_page_pool_remove(pool, false);
+			} else {
+				mutex_unlock(&pool->mutex);
+				break;
+			}
 			mutex_unlock(&pool->mutex);
-			break;
+			ion_page_pool_free_pages(pool, page);
+			nr_freed += (1 << pool->order);
 		}
-		mutex_unlock(&pool->mutex);
-		ion_page_pool_free_pages(pool, page);
-		nr_freed += (1 << pool->order);
+		nr_to_scan -= i;
 	}
-	pr_info("%s: shrunk page_pool of order %d by %d pages\n", __func__,
-		pool->order, nr_freed);
 
-	return high ? (pool->high_count + pool->low_count) *
-		(1 << pool->order) :
-		pool->low_count * (1 << pool->order);
+	return ion_page_pool_total(high);
 }
 
 struct ion_page_pool *ion_page_pool_create(gfp_t gfp_mask, unsigned int order)
@@ -170,20 +242,40 @@ struct ion_page_pool *ion_page_pool_create(gfp_t gfp_mask, unsigned int order)
 	pool->low_count = 0;
 	INIT_LIST_HEAD(&pool->low_items);
 	INIT_LIST_HEAD(&pool->high_items);
-	pool->shrinker.shrink = ion_page_pool_shrink;
-	pool->shrinker.seeks = DEFAULT_SEEKS * 16;
-	pool->shrinker.batch = 0;
-	register_shrinker(&pool->shrinker);
 	pool->gfp_mask = gfp_mask;
 	pool->order = order;
 	mutex_init(&pool->mutex);
+	plist_node_init(&pool->list, order);
+	plist_add(&pool->list, &pools);
 
 	return pool;
 }
 
 void ion_page_pool_destroy(struct ion_page_pool *pool)
 {
-	unregister_shrinker(&pool->shrinker);
+	plist_del(&pool->list, &pools);
 	kfree(pool);
 }
 
+static int __init ion_page_pool_init(void)
+{
+	shrinker.shrink = ion_page_pool_shrink;
+	shrinker.seeks = DEFAULT_SEEKS;
+	shrinker.batch = 0;
+	register_shrinker(&shrinker);
+#ifdef DEBUG_PAGE_POOL_SHRINKER
+	debugfs_create_file("ion_pools_shrink", 0644, NULL, NULL,
+			    &debug_drop_pools_fops);
+	debugfs_create_file("ion_pools_grow", 0644, NULL, NULL,
+			    &debug_grow_pools_fops);
+#endif
+	return 0;
+}
+
+static void __exit ion_page_pool_exit(void)
+{
+	unregister_shrinker(&shrinker);
+}
+
+module_init(ion_page_pool_init);
+module_exit(ion_page_pool_exit);
diff --git a/drivers/staging/android/ion/ion_priv.h b/drivers/staging/android/ion/ion_priv.h
index beb1595..77e2ac0 100644
--- a/drivers/staging/android/ion/ion_priv.h
+++ b/drivers/staging/android/ion/ion_priv.h
@@ -230,6 +230,7 @@ void ion_carveout_free(struct ion_heap *heap, ion_phys_addr_t addr,
  *			when the shrinker fires
  * @gfp_mask:		gfp_mask to use from alloc
  * @order:		order of pages in the pool
+ * @list:		plist node for list of pools
  *
  * Allows you to keep a pool of pre allocated pages to use from your heap.
  * Keeping a pool of pages that is ready for dma, ie any cached mapping have
@@ -241,12 +242,12 @@ struct ion_page_pool {
 	int low_count;
 	struct list_head high_items;
 	struct list_head low_items;
-	struct shrinker shrinker;
 	struct mutex mutex;
 	void *(*alloc)(struct ion_page_pool *pool);
 	void (*free)(struct ion_page_pool *pool, struct page *page);
 	gfp_t gfp_mask;
 	unsigned int order;
+	struct plist_node list;
 };
 
 struct ion_page_pool *ion_page_pool_create(gfp_t gfp_mask, unsigned int order);
-- 
1.8.3.2

