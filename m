Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab3LMW14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:27:56 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:57437 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab3LMW1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:27:50 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 065/115] gpu: ion: Also shrink memory cached in the deferred free list
Date: Fri, 13 Dec 2013 14:24:39 -0800
Message-Id: <1386973529-4884-66-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

When the system is low on memory, we want to shrink any cached
system memory ion is holding.  Previously we were shrinking memory
in the page pools, but not in the deferred free list.  This patch
makes it possible to shrink both.  It also moves the shrinker
code into the heaps so they can correctly manage any caches they
might contain.

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c             | 115 +++++++++--------------
 drivers/staging/android/ion/ion_heap.c        | 107 ++++++++++++++++++++++
 drivers/staging/android/ion/ion_page_pool.c   | 126 +++++---------------------
 drivers/staging/android/ion/ion_priv.h        |  57 +++++++++++-
 drivers/staging/android/ion/ion_system_heap.c |  49 ++++++++++
 5 files changed, 278 insertions(+), 176 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index b2dcee5..ddf8fde 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -28,8 +28,6 @@
 #include <linux/mm.h>
 #include <linux/mm_types.h>
 #include <linux/rbtree.h>
-#include <linux/rtmutex.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
 #include <linux/uaccess.h>
@@ -143,7 +141,6 @@ static void ion_buffer_add(struct ion_device *dev,
 
 static int ion_buffer_alloc_dirty(struct ion_buffer *buffer);
 
-static bool ion_heap_drain_freelist(struct ion_heap *heap);
 /* this function should only be called while dev->lock is held */
 static struct ion_buffer *ion_buffer_create(struct ion_heap *heap,
 				     struct ion_device *dev,
@@ -170,7 +167,7 @@ static struct ion_buffer *ion_buffer_create(struct ion_heap *heap,
 		if (!(heap->flags & ION_HEAP_FLAG_DEFER_FREE))
 			goto err2;
 
-		ion_heap_drain_freelist(heap);
+		ion_heap_freelist_drain(heap, 0);
 		ret = heap->ops->allocate(heap, buffer, len, align,
 					  flags);
 		if (ret)
@@ -230,7 +227,7 @@ err2:
 	return ERR_PTR(ret);
 }
 
-static void _ion_buffer_destroy(struct ion_buffer *buffer)
+void ion_buffer_destroy(struct ion_buffer *buffer)
 {
 	if (WARN_ON(buffer->kmap_cnt > 0))
 		buffer->heap->ops->unmap_kernel(buffer->heap, buffer);
@@ -241,7 +238,7 @@ static void _ion_buffer_destroy(struct ion_buffer *buffer)
 	kfree(buffer);
 }
 
-static void ion_buffer_destroy(struct kref *kref)
+static void _ion_buffer_destroy(struct kref *kref)
 {
 	struct ion_buffer *buffer = container_of(kref, struct ion_buffer, ref);
 	struct ion_heap *heap = buffer->heap;
@@ -251,14 +248,10 @@ static void ion_buffer_destroy(struct kref *kref)
 	rb_erase(&buffer->node, &dev->buffers);
 	mutex_unlock(&dev->buffer_lock);
 
-	if (heap->flags & ION_HEAP_FLAG_DEFER_FREE) {
-		rt_mutex_lock(&heap->lock);
-		list_add(&buffer->list, &heap->free_list);
-		rt_mutex_unlock(&heap->lock);
-		wake_up(&heap->waitqueue);
-		return;
-	}
-	_ion_buffer_destroy(buffer);
+	if (heap->flags & ION_HEAP_FLAG_DEFER_FREE)
+		ion_heap_freelist_add(heap, buffer);
+	else
+		ion_buffer_destroy(buffer);
 }
 
 static void ion_buffer_get(struct ion_buffer *buffer)
@@ -268,7 +261,7 @@ static void ion_buffer_get(struct ion_buffer *buffer)
 
 static int ion_buffer_put(struct ion_buffer *buffer)
 {
-	return kref_put(&buffer->ref, ion_buffer_destroy);
+	return kref_put(&buffer->ref, _ion_buffer_destroy);
 }
 
 static void ion_buffer_add_to_handle(struct ion_buffer *buffer)
@@ -1298,80 +1291,53 @@ static const struct file_operations debug_heap_fops = {
 	.release = single_release,
 };
 
-static size_t ion_heap_free_list_is_empty(struct ion_heap *heap)
+#ifdef DEBUG_HEAP_SHRINKER
+static int debug_shrink_set(void *data, u64 val)
 {
-	bool is_empty;
+        struct ion_heap *heap = data;
+        struct shrink_control sc;
+        int objs;
 
-	rt_mutex_lock(&heap->lock);
-	is_empty = list_empty(&heap->free_list);
-	rt_mutex_unlock(&heap->lock);
+        sc.gfp_mask = -1;
+        sc.nr_to_scan = 0;
 
-	return is_empty;
-}
-
-static int ion_heap_deferred_free(void *data)
-{
-	struct ion_heap *heap = data;
+        if (!val)
+                return 0;
 
-	while (true) {
-		struct ion_buffer *buffer;
+        objs = heap->shrinker.shrink(&heap->shrinker, &sc);
+        sc.nr_to_scan = objs;
 
-		wait_event_freezable(heap->waitqueue,
-				     !ion_heap_free_list_is_empty(heap));
-
-		rt_mutex_lock(&heap->lock);
-		if (list_empty(&heap->free_list)) {
-			rt_mutex_unlock(&heap->lock);
-			continue;
-		}
-		buffer = list_first_entry(&heap->free_list, struct ion_buffer,
-					  list);
-		list_del(&buffer->list);
-		rt_mutex_unlock(&heap->lock);
-		_ion_buffer_destroy(buffer);
-	}
-
-	return 0;
+        heap->shrinker.shrink(&heap->shrinker, &sc);
+        return 0;
 }
 
-static bool ion_heap_drain_freelist(struct ion_heap *heap)
+static int debug_shrink_get(void *data, u64 *val)
 {
-	struct ion_buffer *buffer, *tmp;
-
-	if (ion_heap_free_list_is_empty(heap))
-		return false;
-	rt_mutex_lock(&heap->lock);
-	list_for_each_entry_safe(buffer, tmp, &heap->free_list, list) {
-		list_del(&buffer->list);
-		_ion_buffer_destroy(buffer);
-	}
-	BUG_ON(!list_empty(&heap->free_list));
-	rt_mutex_unlock(&heap->lock);
+        struct ion_heap *heap = data;
+        struct shrink_control sc;
+        int objs;
 
+        sc.gfp_mask = -1;
+        sc.nr_to_scan = 0;
 
-	return true;
+        objs = heap->shrinker.shrink(&heap->shrinker, &sc);
+        *val = objs;
+        return 0;
 }
 
+DEFINE_SIMPLE_ATTRIBUTE(debug_shrink_fops, debug_shrink_get,
+                        debug_shrink_set, "%llu\n");
+#endif
+
 void ion_device_add_heap(struct ion_device *dev, struct ion_heap *heap)
 {
-	struct sched_param param = { .sched_priority = 0 };
-
 	if (!heap->ops->allocate || !heap->ops->free || !heap->ops->map_dma ||
 	    !heap->ops->unmap_dma)
 		pr_err("%s: can not add heap with invalid ops struct.\n",
 		       __func__);
 
-	if (heap->flags & ION_HEAP_FLAG_DEFER_FREE) {
-		INIT_LIST_HEAD(&heap->free_list);
-		rt_mutex_init(&heap->lock);
-		init_waitqueue_head(&heap->waitqueue);
-		heap->task = kthread_run(ion_heap_deferred_free, heap,
-					 "%s", heap->name);
-		sched_setscheduler(heap->task, SCHED_IDLE, &param);
-		if (IS_ERR(heap->task))
-			pr_err("%s: creating thread for deferred free failed\n",
-			       __func__);
-	}
+	if (heap->flags & ION_HEAP_FLAG_DEFER_FREE)
+		ion_heap_init_deferred_free(heap);
 
 	heap->dev = dev;
 	down_write(&dev->lock);
@@ -1381,6 +1347,15 @@ void ion_device_add_heap(struct ion_device *dev, struct ion_heap *heap)
 	plist_add(&heap->node, &dev->heaps);
 	debugfs_create_file(heap->name, 0664, dev->debug_root, heap,
 			    &debug_heap_fops);
+#ifdef DEBUG_HEAP_SHRINKER
+	if (heap->shrinker.shrink) {
+		char debug_name[64];
+
+		snprintf(debug_name, 64, "%s_shrink", heap->name);
+		debugfs_create_file(debug_name, 0644, dev->debug_root, heap,
+				    &debug_shrink_fops);
+	}
+#endif
 	up_write(&dev->lock);
 }
 
diff --git a/drivers/staging/android/ion/ion_heap.c b/drivers/staging/android/ion/ion_heap.c
index 11066a2..f541bff 100644
--- a/drivers/staging/android/ion/ion_heap.c
+++ b/drivers/staging/android/ion/ion_heap.c
@@ -15,7 +15,11 @@
  */
 
 #include <linux/err.h>
+#include <linux/freezer.h>
+#include <linux/kthread.h>
 #include <linux/mm.h>
+#include <linux/rtmutex.h>
+#include <linux/sched.h>
 #include <linux/scatterlist.h>
 #include <linux/vmalloc.h>
 #include "ion.h"
@@ -130,6 +134,109 @@ end:
 	return ret;
 }
 
+void ion_heap_free_page(struct ion_buffer *buffer, struct page *page,
+		       unsigned int order)
+{
+	int i;
+
+	if (!ion_buffer_fault_user_mappings(buffer)) {
+		__free_pages(page, order);
+		return;
+	}
+	for (i = 0; i < (1 << order); i++)
+		__free_page(page + i);
+}
+
+void ion_heap_freelist_add(struct ion_heap *heap, struct ion_buffer * buffer)
+{
+	rt_mutex_lock(&heap->lock);
+	list_add(&buffer->list, &heap->free_list);
+	heap->free_list_size += buffer->size;
+	rt_mutex_unlock(&heap->lock);
+	wake_up(&heap->waitqueue);
+}
+
+size_t ion_heap_freelist_size(struct ion_heap *heap)
+{
+	size_t size;
+
+	rt_mutex_lock(&heap->lock);
+	size = heap->free_list_size;
+	rt_mutex_unlock(&heap->lock);
+
+	return size;
+}
+
+size_t ion_heap_freelist_drain(struct ion_heap *heap, size_t size)
+{
+	struct ion_buffer *buffer, *tmp;
+	size_t total_drained = 0;
+
+	if (ion_heap_freelist_size(heap) == 0)
+		return 0;
+
+	rt_mutex_lock(&heap->lock);
+	if (size == 0)
+		size = heap->free_list_size;
+
+	list_for_each_entry_safe(buffer, tmp, &heap->free_list, list) {
+		if (total_drained >= size)
+			break;
+		list_del(&buffer->list);
+		ion_buffer_destroy(buffer);
+		heap->free_list_size -= buffer->size;
+		total_drained += buffer->size;
+	}
+	rt_mutex_unlock(&heap->lock);
+
+	return total_drained;
+}
+
+int ion_heap_deferred_free(void *data)
+{
+	struct ion_heap *heap = data;
+
+	while (true) {
+		struct ion_buffer *buffer;
+
+		wait_event_freezable(heap->waitqueue,
+				     ion_heap_freelist_size(heap) > 0);
+
+		rt_mutex_lock(&heap->lock);
+		if (list_empty(&heap->free_list)) {
+			rt_mutex_unlock(&heap->lock);
+			continue;
+		}
+		buffer = list_first_entry(&heap->free_list, struct ion_buffer,
+					  list);
+		list_del(&buffer->list);
+		heap->free_list_size -= buffer->size;
+		rt_mutex_unlock(&heap->lock);
+		ion_buffer_destroy(buffer);
+	}
+
+	return 0;
+}
+
+int ion_heap_init_deferred_free(struct ion_heap *heap)
+{
+	struct sched_param param = { .sched_priority = 0 };
+
+	INIT_LIST_HEAD(&heap->free_list);
+	heap->free_list_size = 0;
+	rt_mutex_init(&heap->lock);
+	init_waitqueue_head(&heap->waitqueue);
+	heap->task = kthread_run(ion_heap_deferred_free, heap,
+				 "%s", heap->name);
+	sched_setscheduler(heap->task, SCHED_IDLE, &param);
+	if (IS_ERR(heap->task)) {
+		pr_err("%s: creating thread for deferred free failed\n",
+		       __func__);
+		return PTR_RET(heap->task);
+	}
+	return 0;
+}
+
 struct ion_heap *ion_heap_create(struct ion_platform_heap *heap_data)
 {
 	struct ion_heap *heap = NULL;
diff --git a/drivers/staging/android/ion/ion_page_pool.c b/drivers/staging/android/ion/ion_page_pool.c
index df6e29c..d624dee 100644
--- a/drivers/staging/android/ion/ion_page_pool.c
+++ b/drivers/staging/android/ion/ion_page_pool.c
@@ -21,14 +21,8 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/shrinker.h>
 #include "ion_priv.h"
 
-/* #define DEBUG_PAGE_POOL_SHRINKER */
-
-static struct plist_head pools = PLIST_HEAD_INIT(pools);
-static struct shrinker shrinker;
-
 struct ion_page_pool_item {
 	struct page *page;
 	struct list_head list;
@@ -126,109 +120,46 @@ void ion_page_pool_free(struct ion_page_pool *pool, struct page* page)
 		ion_page_pool_free_pages(pool, page);
 }
 
-#ifdef DEBUG_PAGE_POOL_SHRINKER
-static int debug_drop_pools_set(void *data, u64 val)
-{
-	struct shrink_control sc;
-	int objs;
-
-	sc.gfp_mask = -1;
-	sc.nr_to_scan = 0;
-
-	if (!val)
-		return 0;
-
-	objs = shrinker.shrink(&shrinker, &sc);
-	sc.nr_to_scan = objs;
-
-	shrinker.shrink(&shrinker, &sc);
-	return 0;
-}
-
-static int debug_drop_pools_get(void *data, u64 *val)
+static int ion_page_pool_total(struct ion_page_pool *pool, bool high)
 {
-	struct shrink_control sc;
-	int objs;
-
-	sc.gfp_mask = -1;
-	sc.nr_to_scan = 0;
-
-	objs = shrinker.shrink(&shrinker, &sc);
-	*val = objs;
-	return 0;
-}
-
-DEFINE_SIMPLE_ATTRIBUTE(debug_drop_pools_fops, debug_drop_pools_get,
-                        debug_drop_pools_set, "%llu\n");
-
-static int debug_grow_pools_set(void *data, u64 val)
-{
-	struct ion_page_pool *pool;
-	struct page *page;
-
-	plist_for_each_entry(pool, &pools, list) {
-		if (val != pool->list.prio)
-			continue;
-		page = ion_page_pool_alloc_pages(pool);
-		if (page)
-			ion_page_pool_add(pool, page);
-	}
-
-	return 0;
-}
-
-DEFINE_SIMPLE_ATTRIBUTE(debug_grow_pools_fops, debug_drop_pools_get,
-			debug_grow_pools_set, "%llu\n");
-#endif
-
-static int ion_page_pool_total(bool high)
-{
-	struct ion_page_pool *pool;
 	int total = 0;
 
-	plist_for_each_entry(pool, &pools, list) {
-		total += high ? (pool->high_count + pool->low_count) *
-			(1 << pool->order) :
+	total += high ? (pool->high_count + pool->low_count) *
+		(1 << pool->order) :
 			pool->low_count * (1 << pool->order);
-	}
 	return total;
 }
 
-static int ion_page_pool_shrink(struct shrinker *shrinker,
-				 struct shrink_control *sc)
+int ion_page_pool_shrink(struct ion_page_pool *pool, gfp_t gfp_mask,
+				int nr_to_scan)
 {
-	struct ion_page_pool *pool;
 	int nr_freed = 0;
 	int i;
 	bool high;
-	int nr_to_scan = sc->nr_to_scan;
 
-	high = sc->gfp_mask & __GFP_HIGHMEM;
+	high = gfp_mask & __GFP_HIGHMEM;
 
 	if (nr_to_scan == 0)
-		return ion_page_pool_total(high);
-
-	plist_for_each_entry(pool, &pools, list) {
-		for (i = 0; i < nr_to_scan; i++) {
-			struct page *page;
-
-			mutex_lock(&pool->mutex);
-			if (high && pool->high_count) {
-				page = ion_page_pool_remove(pool, true);
-			} else if (pool->low_count) {
-				page = ion_page_pool_remove(pool, false);
-			} else {
-				mutex_unlock(&pool->mutex);
-				break;
-			}
+		return ion_page_pool_total(pool, high);
+
+	for (i = 0; i < nr_to_scan; i++) {
+		struct page *page;
+
+		mutex_lock(&pool->mutex);
+		if (high && pool->high_count) {
+			page = ion_page_pool_remove(pool, true);
+		} else if (pool->low_count) {
+			page = ion_page_pool_remove(pool, false);
+		} else {
 			mutex_unlock(&pool->mutex);
-			ion_page_pool_free_pages(pool, page);
-			nr_freed += (1 << pool->order);
+			break;
 		}
-		nr_to_scan -= i;
+		mutex_unlock(&pool->mutex);
+		ion_page_pool_free_pages(pool, page);
+		nr_freed += (1 << pool->order);
 	}
 
-	return ion_page_pool_total(high);
+	return nr_freed;
 }
 
 struct ion_page_pool *ion_page_pool_create(gfp_t gfp_mask, unsigned int order)
@@ -245,35 +176,22 @@ struct ion_page_pool *ion_page_pool_create(gfp_t gfp_mask, unsigned int order)
 	pool->order = order;
 	mutex_init(&pool->mutex);
 	plist_node_init(&pool->list, order);
-	plist_add(&pool->list, &pools);
 
 	return pool;
 }
 
 void ion_page_pool_destroy(struct ion_page_pool *pool)
 {
-	plist_del(&pool->list, &pools);
 	kfree(pool);
 }
 
 static int __init ion_page_pool_init(void)
 {
-	shrinker.shrink = ion_page_pool_shrink;
-	shrinker.seeks = DEFAULT_SEEKS;
-	shrinker.batch = 0;
-	register_shrinker(&shrinker);
-#ifdef DEBUG_PAGE_POOL_SHRINKER
-	debugfs_create_file("ion_pools_shrink", 0644, NULL, NULL,
-			    &debug_drop_pools_fops);
-	debugfs_create_file("ion_pools_grow", 0644, NULL, NULL,
-			    &debug_grow_pools_fops);
-#endif
 	return 0;
 }
 
 static void __exit ion_page_pool_exit(void)
 {
-	unregister_shrinker(&shrinker);
 }
 
 module_init(ion_page_pool_init);
diff --git a/drivers/staging/android/ion/ion_priv.h b/drivers/staging/android/ion/ion_priv.h
index ab1a8d9..bdc1e34 100644
--- a/drivers/staging/android/ion/ion_priv.h
+++ b/drivers/staging/android/ion/ion_priv.h
@@ -82,6 +82,7 @@ struct ion_buffer {
 	char task_comm[TASK_COMM_LEN];
 	pid_t pid;
 };
+void ion_buffer_destroy(struct ion_buffer *buffer);
 
 /**
  * struct ion_heap_ops - ops to operate on a given heap
@@ -127,7 +128,12 @@ struct ion_heap_ops {
  *			allocating.  These are specified by platform data and
  *			MUST be unique
  * @name:		used for debugging
+ * @shrinker:		a shrinker for the heap, if the heap caches system
+ *			memory, it must define a shrinker to return it on low
+ *			memory conditions, this includes system memory cached
+ *			in the deferred free lists for heaps that support it
  * @free_list:		free list head if deferred free is used
+ * @free_list_size	size of the deferred free list in bytes
  * @lock:		protects the free list
  * @waitqueue:		queue to wait on from deferred free thread
  * @task:		task struct of deferred free thread
@@ -147,7 +153,9 @@ struct ion_heap {
 	unsigned long flags;
 	unsigned int id;
 	const char *name;
+	struct shrinker shrinker;
 	struct list_head free_list;
+	size_t free_list_size;
 	struct rt_mutex lock;
 	wait_queue_head_t waitqueue;
 	struct task_struct *task;
@@ -205,6 +213,43 @@ int ion_heap_map_user(struct ion_heap *, struct ion_buffer *,
 			struct vm_area_struct *);
 int ion_heap_buffer_zero(struct ion_buffer *buffer);
 
+/**
+ * ion_heap_init_deferred_free -- initialize deferred free functionality
+ * @heap:		the heap
+ *
+ * If a heap sets the ION_HEAP_FLAG_DEFER_FREE flag this function will
+ * be called to setup deferred frees. Calls to free the buffer will
+ * return immediately and the actual free will occur some time later
+ */
+int ion_heap_init_deferred_free(struct ion_heap *heap);
+
+/**
+ * ion_heap_freelist_add - add a buffer to the deferred free list
+ * @heap:		the heap
+ * @buffer: 		the buffer
+ *
+ * Adds an item to the deferred freelist.
+ */
+void ion_heap_freelist_add(struct ion_heap *heap, struct ion_buffer *buffer);
+
+/**
+ * ion_heap_freelist_drain - drain the deferred free list
+ * @heap:		the heap
+ * @size:		ammount of memory to drain in bytes
+ *
+ * Drains the indicated amount of memory from the deferred freelist immediately.
+ * Returns the total amount freed.  The total freed may be higher depending
+ * on the size of the items in the list, or lower if there is insufficient
+ * total memory on the freelist.
+ */
+size_t ion_heap_freelist_drain(struct ion_heap *heap, size_t size);
+
+/**
+ * ion_heap_freelist_size - returns the size of the freelist in bytes
+ * @heap:		the heap
+ */
+size_t ion_heap_freelist_size(struct ion_heap *heap);
+
 
 /**
  * functions for creating and destroying the built in ion heaps.
@@ -274,8 +319,6 @@ struct ion_page_pool {
 	struct list_head high_items;
 	struct list_head low_items;
 	struct mutex mutex;
-	void *(*alloc)(struct ion_page_pool *pool);
-	void (*free)(struct ion_page_pool *pool, struct page *page);
 	gfp_t gfp_mask;
 	unsigned int order;
 	struct plist_node list;
@@ -286,4 +329,14 @@ void ion_page_pool_destroy(struct ion_page_pool *);
 void *ion_page_pool_alloc(struct ion_page_pool *);
 void ion_page_pool_free(struct ion_page_pool *, struct page *);
 
+/** ion_page_pool_shrink - shrinks the size of the memory cached in the pool
+ * @pool:		the pool
+ * @gfp_mask:		the memory type to reclaim
+ * @nr_to_scan:		number of items to shrink in pages
+ *
+ * returns the number of items freed in pages
+ */
+int ion_page_pool_shrink(struct ion_page_pool *pool, gfp_t gfp_mask,
+			  int nr_to_scan);
+
 #endif /* _ION_PRIV_H */
diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 6665797..fedbc0d 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -253,6 +253,50 @@ static struct ion_heap_ops system_heap_ops = {
 	.map_user = ion_heap_map_user,
 };
 
+static int ion_system_heap_shrink(struct shrinker *shrinker,
+				  struct shrink_control *sc) {
+
+	struct ion_heap *heap = container_of(shrinker, struct ion_heap,
+					     shrinker);
+	struct ion_system_heap *sys_heap = container_of(heap,
+							struct ion_system_heap,
+							heap);
+	int nr_total = 0;
+	int nr_freed = 0;
+	int i;
+
+	if (sc->nr_to_scan == 0)
+		goto end;
+
+	/* shrink the free list first, no point in zeroing the memory if
+	   we're just going to reclaim it */
+	nr_freed += ion_heap_freelist_drain(heap, sc->nr_to_scan * PAGE_SIZE) /
+		PAGE_SIZE;
+
+	if (nr_freed >= sc->nr_to_scan)
+		goto end;
+
+	for (i = 0; i < num_orders; i++) {
+		struct ion_page_pool *pool = sys_heap->pools[i];
+
+		nr_freed += ion_page_pool_shrink(pool, sc->gfp_mask,
+						 sc->nr_to_scan);
+		if (nr_freed >= sc->nr_to_scan)
+			break;
+	}
+
+end:
+	/* total number of items is whatever the page pools are holding
+	   plus whatever's in the freelist */
+	for (i = 0; i < num_orders; i++) {
+		struct ion_page_pool *pool = sys_heap->pools[i];
+		nr_total += ion_page_pool_shrink(pool, sc->gfp_mask, 0);
+	}
+	nr_total += ion_heap_freelist_size(heap) / PAGE_SIZE;
+	return nr_total;
+
+}
+
 static int ion_system_heap_debug_show(struct ion_heap *heap, struct seq_file *s,
 				      void *unused)
 {
@@ -299,6 +343,11 @@ struct ion_heap *ion_system_heap_create(struct ion_platform_heap *unused)
 			goto err_create_pool;
 		heap->pools[i] = pool;
 	}
+
+	heap->heap.shrinker.shrink = ion_system_heap_shrink;
+	heap->heap.shrinker.seeks = DEFAULT_SEEKS;
+	heap->heap.shrinker.batch = 0;
+	register_shrinker(&heap->heap.shrinker);
 	heap->heap.debug_show = ion_system_heap_debug_show;
 	return &heap->heap;
 err_create_pool:
-- 
1.8.3.2

