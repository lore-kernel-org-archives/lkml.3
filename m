Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab3LMWm3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:42:29 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:37578 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796Ab3LMW1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:27:09 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 039/115] gpu: ion: Fix several issues with page pool
Date: Fri, 13 Dec 2013 14:24:13 -0800
Message-Id: <1386973529-4884-40-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

Split out low and high mem pages so they are correctly reported
when the shrinker is called.
Fix potential deadlock caused by holding the page pool lock while
allocationg and also needing that lock from the shrink function

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_page_pool.c   | 77 ++++++++++++++++++---------
 drivers/staging/android/ion/ion_priv.h        | 12 +++--
 drivers/staging/android/ion/ion_system_heap.c |  9 ++--
 3 files changed, 65 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/android/ion/ion_page_pool.c b/drivers/staging/android/ion/ion_page_pool.c
index 78f39f7..ea45380 100644
--- a/drivers/staging/android/ion/ion_page_pool.c
+++ b/drivers/staging/android/ion/ion_page_pool.c
@@ -54,24 +54,36 @@ static int ion_page_pool_add(struct ion_page_pool *pool, struct page *page)
 	if (!item)
 		return -ENOMEM;
 	item->page = page;
-	list_add_tail(&item->list, &pool->items);
-	pool->count++;
+	if (PageHighMem(page)) {
+		list_add_tail(&item->list, &pool->high_items);
+		pool->high_count++;
+	} else {
+		list_add_tail(&item->list, &pool->low_items);
+		pool->low_count++;
+	}
 	return 0;
 }
 
-static struct page *ion_page_pool_remove(struct ion_page_pool *pool)
+static struct page *ion_page_pool_remove(struct ion_page_pool *pool, bool high)
 {
 	struct ion_page_pool_item *item;
 	struct page *page;
 
-	BUG_ON(!pool->count);
-	BUG_ON(list_empty(&pool->items));
+	if (high) {
+		BUG_ON(!pool->high_count);
+		item = list_first_entry(&pool->high_items,
+					struct ion_page_pool_item, list);
+		pool->high_count--;
+	} else {
+		BUG_ON(!pool->low_count);
+		item = list_first_entry(&pool->low_items,
+					struct ion_page_pool_item, list);
+		pool->low_count--;
+	}
 
-	item = list_first_entry(&pool->items, struct ion_page_pool_item, list);
 	list_del(&item->list);
 	page = item->page;
 	kfree(item);
-	pool->count--;
 	return page;
 }
 
@@ -82,12 +94,15 @@ void *ion_page_pool_alloc(struct ion_page_pool *pool)
 	BUG_ON(!pool);
 
 	mutex_lock(&pool->mutex);
-	if (pool->count)
-		page = ion_page_pool_remove(pool);
-	else
-		page = ion_page_pool_alloc_pages(pool);
+	if (pool->high_count)
+		page = ion_page_pool_remove(pool, true);
+	else if (pool->low_count)
+		page = ion_page_pool_remove(pool, false);
 	mutex_unlock(&pool->mutex);
 
+	if (!page)
+		page = ion_page_pool_alloc_pages(pool);
+
 	return page;
 }
 
@@ -97,9 +112,9 @@ void ion_page_pool_free(struct ion_page_pool *pool, struct page* page)
 
 	mutex_lock(&pool->mutex);
 	ret = ion_page_pool_add(pool, page);
+	mutex_unlock(&pool->mutex);
 	if (ret)
 		ion_page_pool_free_pages(pool, page);
-	mutex_unlock(&pool->mutex);
 }
 
 static int ion_page_pool_shrink(struct shrinker *shrinker,
@@ -110,30 +125,38 @@ static int ion_page_pool_shrink(struct shrinker *shrinker,
 						 shrinker);
 	int nr_freed = 0;
 	int i;
+	bool high;
+
+	if (sc->gfp_mask & __GFP_HIGHMEM)
+		high = true;
 
 	if (sc->nr_to_scan == 0)
-		return pool->count * (1 << pool->order);
+		return high ? (pool->high_count + pool->low_count) *
+			(1 << pool->order) :
+			pool->low_count * (1 << pool->order);
 
-	mutex_lock(&pool->mutex);
-	for (i = 0; i < sc->nr_to_scan && pool->count; i++) {
-		struct ion_page_pool_item *item;
+	for (i = 0; i < sc->nr_to_scan; i++) {
 		struct page *page;
 
-		item = list_first_entry(&pool->items, struct ion_page_pool_item, list);
-		page = item->page;
-		if (PageHighMem(page) && !(sc->gfp_mask & __GFP_HIGHMEM)) {
-			list_move_tail(&item->list, &pool->items);
-			continue;
+		mutex_lock(&pool->mutex);
+		if (high && pool->high_count) {
+			page = ion_page_pool_remove(pool, true);
+		} else if (pool->low_count) {
+			page = ion_page_pool_remove(pool, false);
+		} else {
+			mutex_unlock(&pool->mutex);
+			break;
 		}
-		BUG_ON(page != ion_page_pool_remove(pool));
+		mutex_unlock(&pool->mutex);
 		ion_page_pool_free_pages(pool, page);
 		nr_freed += (1 << pool->order);
 	}
 	pr_info("%s: shrunk page_pool of order %d by %d pages\n", __func__,
 		pool->order, nr_freed);
-	mutex_unlock(&pool->mutex);
 
-	return pool->count * (1 << pool->order);
+	return high ? (pool->high_count + pool->low_count) *
+		(1 << pool->order) :
+		pool->low_count * (1 << pool->order);
 }
 
 struct ion_page_pool *ion_page_pool_create(gfp_t gfp_mask, unsigned int order)
@@ -142,8 +165,10 @@ struct ion_page_pool *ion_page_pool_create(gfp_t gfp_mask, unsigned int order)
 					     GFP_KERNEL);
 	if (!pool)
 		return NULL;
-	pool->count = 0;
-	INIT_LIST_HEAD(&pool->items);
+	pool->high_count = 0;
+	pool->low_count = 0;
+	INIT_LIST_HEAD(&pool->low_items);
+	INIT_LIST_HEAD(&pool->high_items);
 	pool->shrinker.shrink = ion_page_pool_shrink;
 	pool->shrinker.seeks = DEFAULT_SEEKS * 16;
 	pool->shrinker.batch = 0;
diff --git a/drivers/staging/android/ion/ion_priv.h b/drivers/staging/android/ion/ion_priv.h
index 9f32634..beb1595 100644
--- a/drivers/staging/android/ion/ion_priv.h
+++ b/drivers/staging/android/ion/ion_priv.h
@@ -217,8 +217,10 @@ void ion_carveout_free(struct ion_heap *heap, ion_phys_addr_t addr,
 
 /**
  * struct ion_page_pool - pagepool struct
- * @count:		number of items in the pool
- * @items:		list of items
+ * @high_count:		number of highmem items in the pool
+ * @low_count:		number of lowmem items in the pool
+ * @high_items:		list of highmem items
+ * @low_items:		list of lowmem items
  * @shrinker:		a shrinker for the items
  * @mutex:		lock protecting this struct and especially the count
  *			item list
@@ -235,8 +237,10 @@ void ion_carveout_free(struct ion_heap *heap, ion_phys_addr_t addr,
  * on many systems
  */
 struct ion_page_pool {
-	int count;
-	struct list_head items;
+	int high_count;
+	int low_count;
+	struct list_head high_items;
+	struct list_head low_items;
 	struct shrinker shrinker;
 	struct mutex mutex;
 	void *(*alloc)(struct ion_page_pool *pool);
diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index b99fa0e..2204206 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -328,9 +328,12 @@ static int ion_system_heap_debug_show(struct ion_heap *heap, struct seq_file *s,
 	int i;
 	for (i = 0; i < num_orders; i++) {
 		struct ion_page_pool *pool = sys_heap->pools[i];
-		seq_printf(s, "%d order %u pages in pool = %lu total\n",
-			   pool->count, pool->order,
-			   (1 << pool->order) * PAGE_SIZE * pool->count);
+		seq_printf(s, "%d order %u highmem pages in pool = %lu total\n",
+			   pool->high_count, pool->order,
+			   (1 << pool->order) * PAGE_SIZE * pool->high_count);
+		seq_printf(s, "%d order %u lowmem pages in pool = %lu total\n",
+			   pool->low_count, pool->order,
+			   (1 << pool->order) * PAGE_SIZE * pool->low_count);
 	}
 	return 0;
 }
-- 
1.8.3.2

