Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab3LMW1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:27:46 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:47246 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab3LMW1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:27:43 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 061/115] gpu: ion: Make ion_free asynchronous
Date: Fri, 13 Dec 2013 14:24:35 -0800
Message-Id: <1386973529-4884-62-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

Add the ability for a heap to free buffers asynchrounously.  Freed buffers
are placed on a free list and freed from a low priority background thread.
If allocations from a particular heap fail, the free list is drained.  This
patch also enable asynchronous frees from the chunk heap.

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c             | 112 +++++++++++++++++++++++---
 drivers/staging/android/ion/ion.h             |   2 +-
 drivers/staging/android/ion/ion_chunk_heap.c  |   3 +-
 drivers/staging/android/ion/ion_priv.h        |  20 ++++-
 drivers/staging/android/ion/ion_system_heap.c |   1 +
 5 files changed, 126 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index ba65bef..b965f15 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -17,8 +17,10 @@
 
 #include <linux/device.h>
 #include <linux/file.h>
+#include <linux/freezer.h>
 #include <linux/fs.h>
 #include <linux/anon_inodes.h>
+#include <linux/kthread.h>
 #include <linux/list.h>
 #include <linux/memblock.h>
 #include <linux/miscdevice.h>
@@ -26,6 +28,7 @@
 #include <linux/mm.h>
 #include <linux/mm_types.h>
 #include <linux/rbtree.h>
+#include <linux/rtmutex.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
@@ -140,6 +143,7 @@ static void ion_buffer_add(struct ion_device *dev,
 
 static int ion_buffer_alloc_dirty(struct ion_buffer *buffer);
 
+static bool ion_heap_drain_freelist(struct ion_heap *heap);
 /* this function should only be called while dev->lock is held */
 static struct ion_buffer *ion_buffer_create(struct ion_heap *heap,
 				     struct ion_device *dev,
@@ -161,9 +165,16 @@ static struct ion_buffer *ion_buffer_create(struct ion_heap *heap,
 	kref_init(&buffer->ref);
 
 	ret = heap->ops->allocate(heap, buffer, len, align, flags);
+
 	if (ret) {
-		kfree(buffer);
-		return ERR_PTR(ret);
+		if (!(heap->flags & ION_HEAP_FLAG_DEFER_FREE))
+			goto err2;
+
+		ion_heap_drain_freelist(heap);
+		ret = heap->ops->allocate(heap, buffer, len, align,
+					  flags);
+		if (ret)
+			goto err2;
 	}
 
 	buffer->dev = dev;
@@ -214,27 +225,42 @@ static struct ion_buffer *ion_buffer_create(struct ion_heap *heap,
 err:
 	heap->ops->unmap_dma(heap, buffer);
 	heap->ops->free(buffer);
+err2:
 	kfree(buffer);
 	return ERR_PTR(ret);
 }
 
-static void ion_buffer_destroy(struct kref *kref)
+static void _ion_buffer_destroy(struct ion_buffer *buffer)
 {
-	struct ion_buffer *buffer = container_of(kref, struct ion_buffer, ref);
-	struct ion_device *dev = buffer->dev;
-
 	if (WARN_ON(buffer->kmap_cnt > 0))
 		buffer->heap->ops->unmap_kernel(buffer->heap, buffer);
 	buffer->heap->ops->unmap_dma(buffer->heap, buffer);
 	buffer->heap->ops->free(buffer);
-	mutex_lock(&dev->buffer_lock);
-	rb_erase(&buffer->node, &dev->buffers);
-	mutex_unlock(&dev->buffer_lock);
 	if (buffer->flags & ION_FLAG_CACHED)
 		kfree(buffer->dirty);
 	kfree(buffer);
 }
 
+static void ion_buffer_destroy(struct kref *kref)
+{
+	struct ion_buffer *buffer = container_of(kref, struct ion_buffer, ref);
+	struct ion_heap *heap = buffer->heap;
+	struct ion_device *dev = buffer->dev;
+
+	mutex_lock(&dev->buffer_lock);
+	rb_erase(&buffer->node, &dev->buffers);
+	mutex_unlock(&dev->buffer_lock);
+
+	if (heap->flags & ION_HEAP_FLAG_DEFER_FREE) {
+		rt_mutex_lock(&heap->lock);
+		list_add(&buffer->list, &heap->free_list);
+		rt_mutex_unlock(&heap->lock);
+		wake_up(&heap->waitqueue);
+		return;
+	}
+	_ion_buffer_destroy(buffer);
+}
+
 static void ion_buffer_get(struct ion_buffer *buffer)
 {
 	kref_get(&buffer->ref);
@@ -1272,13 +1298,81 @@ static const struct file_operations debug_heap_fops = {
 	.release = single_release,
 };
 
+static size_t ion_heap_free_list_is_empty(struct ion_heap *heap)
+{
+	bool is_empty;
+
+	rt_mutex_lock(&heap->lock);
+	is_empty = list_empty(&heap->free_list);
+	rt_mutex_unlock(&heap->lock);
+
+	return is_empty;
+}
+
+static int ion_heap_deferred_free(void *data)
+{
+	struct ion_heap *heap = data;
+
+	while (true) {
+		struct ion_buffer *buffer;
+
+		wait_event_freezable(heap->waitqueue,
+				     !ion_heap_free_list_is_empty(heap));
+
+		rt_mutex_lock(&heap->lock);
+		if (list_empty(&heap->free_list)) {
+			rt_mutex_unlock(&heap->lock);
+			continue;
+		}
+		buffer = list_first_entry(&heap->free_list, struct ion_buffer,
+					  list);
+		list_del(&buffer->list);
+		rt_mutex_unlock(&heap->lock);
+		_ion_buffer_destroy(buffer);
+	}
+
+	return 0;
+}
+
+static bool ion_heap_drain_freelist(struct ion_heap *heap)
+{
+	struct ion_buffer *buffer, *tmp;
+
+	if (ion_heap_free_list_is_empty(heap))
+		return false;
+	rt_mutex_lock(&heap->lock);
+	list_for_each_entry_safe(buffer, tmp, &heap->free_list, list) {
+		_ion_buffer_destroy(buffer);
+		list_del(&buffer->list);
+	}
+	BUG_ON(!list_empty(&heap->free_list));
+	rt_mutex_unlock(&heap->lock);
+
+
+	return true;
+}
+
 void ion_device_add_heap(struct ion_device *dev, struct ion_heap *heap)
 {
+	struct sched_param param = { .sched_priority = 0 };
+
 	if (!heap->ops->allocate || !heap->ops->free || !heap->ops->map_dma ||
 	    !heap->ops->unmap_dma)
 		pr_err("%s: can not add heap with invalid ops struct.\n",
 		       __func__);
 
+	if (heap->flags & ION_HEAP_FLAG_DEFER_FREE) {
+		INIT_LIST_HEAD(&heap->free_list);
+		rt_mutex_init(&heap->lock);
+		init_waitqueue_head(&heap->waitqueue);
+		heap->task = kthread_run(ion_heap_deferred_free, heap,
+					 "%s", heap->name);
+		sched_setscheduler(heap->task, SCHED_IDLE, &param);
+		if (IS_ERR(heap->task))
+			pr_err("%s: creating thread for deferred free failed\n",
+			       __func__);
+	}
+
 	heap->dev = dev;
 	down_write(&dev->lock);
 	/* use negative heap->id to reverse the priority -- when traversing
diff --git a/drivers/staging/android/ion/ion.h b/drivers/staging/android/ion/ion.h
index 976123b..679031c 100644
--- a/drivers/staging/android/ion/ion.h
+++ b/drivers/staging/android/ion/ion.h
@@ -46,7 +46,7 @@ enum ion_heap_type {
 #define ION_NUM_HEAP_IDS		sizeof(unsigned int) * 8
 
 /**
- * heap flags - the lower 16 bits are used by core ion, the upper 16
+ * allocation flags - the lower 16 bits are used by core ion, the upper 16
  * bits are reserved for use by the heaps themselves.
  */
 #define ION_FLAG_CACHED 1		/* mappings of this buffer should be
diff --git a/drivers/staging/android/ion/ion_chunk_heap.c b/drivers/staging/android/ion/ion_chunk_heap.c
index 60cd91c..ac7cf13 100644
--- a/drivers/staging/android/ion/ion_chunk_heap.c
+++ b/drivers/staging/android/ion/ion_chunk_heap.c
@@ -160,7 +160,8 @@ struct ion_heap *ion_chunk_heap_create(struct ion_platform_heap *heap_data)
 	gen_pool_add(chunk_heap->pool, chunk_heap->base, heap_data->size, -1);
 	chunk_heap->heap.ops = &chunk_heap_ops;
 	chunk_heap->heap.type = ION_HEAP_TYPE_CHUNK;
-	pr_info("%s: base %lu size %ld align %ld\n", __func__, chunk_heap->base,
+	chunk_heap->heap.flags = ION_HEAP_FLAG_DEFER_FREE;
+	pr_info("%s: base %lu size %u align %ld\n", __func__, chunk_heap->base,
 		heap_data->size, heap_data->align);
 
 	return &chunk_heap->heap;
diff --git a/drivers/staging/android/ion/ion_priv.h b/drivers/staging/android/ion/ion_priv.h
index cfb4264..ab1a8d9 100644
--- a/drivers/staging/android/ion/ion_priv.h
+++ b/drivers/staging/android/ion/ion_priv.h
@@ -58,7 +58,10 @@ struct ion_buffer *ion_handle_buffer(struct ion_handle *handle);
 */
 struct ion_buffer {
 	struct kref ref;
-	struct rb_node node;
+	union {
+		struct rb_node node;
+		struct list_head list;
+	};
 	struct ion_device *dev;
 	struct ion_heap *heap;
 	unsigned long flags;
@@ -109,15 +112,25 @@ struct ion_heap_ops {
 };
 
 /**
+ * heap flags - flags between the heaps and core ion code
+ */
+#define ION_HEAP_FLAG_DEFER_FREE (1 << 0)
+
+/**
  * struct ion_heap - represents a heap in the system
  * @node:		rb node to put the heap on the device's tree of heaps
  * @dev:		back pointer to the ion_device
  * @type:		type of heap
  * @ops:		ops struct as above
+ * @flags:		flags
  * @id:			id of heap, also indicates priority of this heap when
  *			allocating.  These are specified by platform data and
  *			MUST be unique
  * @name:		used for debugging
+ * @free_list:		free list head if deferred free is used
+ * @lock:		protects the free list
+ * @waitqueue:		queue to wait on from deferred free thread
+ * @task:		task struct of deferred free thread
  * @debug_show:		called when heap debug file is read to add any
  *			heap specific debug info to output
  *
@@ -131,8 +144,13 @@ struct ion_heap {
 	struct ion_device *dev;
 	enum ion_heap_type type;
 	struct ion_heap_ops *ops;
+	unsigned long flags;
 	unsigned int id;
 	const char *name;
+	struct list_head free_list;
+	struct rt_mutex lock;
+	wait_queue_head_t waitqueue;
+	struct task_struct *task;
 	int (*debug_show)(struct ion_heap *heap, struct seq_file *, void *);
 };
 
diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 3ca704e..6665797 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -283,6 +283,7 @@ struct ion_heap *ion_system_heap_create(struct ion_platform_heap *unused)
 		return ERR_PTR(-ENOMEM);
 	heap->heap.ops = &system_heap_ops;
 	heap->heap.type = ION_HEAP_TYPE_SYSTEM;
+	heap->heap.flags = ION_HEAP_FLAG_DEFER_FREE;
 	heap->pools = kzalloc(sizeof(struct ion_page_pool *) * num_orders,
 			      GFP_KERNEL);
 	if (!heap->pools)
-- 
1.8.3.2

