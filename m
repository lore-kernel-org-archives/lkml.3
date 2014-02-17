Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbaBQWAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:00:20 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:55472 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbaBQV7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:59:07 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mitchel Humpherys <mitchelh@codeaurora.org>,
        Greg KH <gregkh@linuxfoundation.org>, Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 11/14] staging: ion: Add private buffer flag to skip page pooling on free
Date: Mon, 17 Feb 2014 13:58:39 -0800
Message-Id: <1392674322-9036-12-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392674322-9036-1-git-send-email-john.stultz@linaro.org>
References: <1392674322-9036-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mitchel Humpherys <mitchelh@codeaurora.org>

Currently, when we free a buffer it might actually just go back into a
heap-specific page pool rather than going back to the system. This poses
a problem because sometimes (like when we're running a shrinker in low
memory conditions) we need to force the memory associated with the
buffer to truly be relinquished to the system rather than just going
back into a page pool.

There isn't a use case for this flag by Ion clients, so make it a
private flag. The main use case right now is to provide a mechanism for
the deferred free code to force stale buffers to bypass page pooling.

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Colin Cross <ccross@android.com>
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Mitchel Humpherys <mitchelh@codeaurora.org>
[jstultz: Minor commit subject tweak]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_heap.c        | 19 ++++++++++--
 drivers/staging/android/ion/ion_priv.h        | 42 ++++++++++++++++++++++++++-
 drivers/staging/android/ion/ion_system_heap.c |  4 +--
 3 files changed, 59 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/android/ion/ion_heap.c b/drivers/staging/android/ion/ion_heap.c
index 49ace13..bdc6a28 100644
--- a/drivers/staging/android/ion/ion_heap.c
+++ b/drivers/staging/android/ion/ion_heap.c
@@ -178,7 +178,8 @@ size_t ion_heap_freelist_size(struct ion_heap *heap)
 	return size;
 }
 
-size_t ion_heap_freelist_drain(struct ion_heap *heap, size_t size)
+static size_t _ion_heap_freelist_drain(struct ion_heap *heap, size_t size,
+				bool skip_pools)
 {
 	struct ion_buffer *buffer;
 	size_t total_drained = 0;
@@ -197,6 +198,8 @@ size_t ion_heap_freelist_drain(struct ion_heap *heap, size_t size)
 					  list);
 		list_del(&buffer->list);
 		heap->free_list_size -= buffer->size;
+		if (skip_pools)
+			buffer->private_flags |= ION_PRIV_FLAG_SHRINKER_FREE;
 		total_drained += buffer->size;
 		spin_unlock(&heap->free_lock);
 		ion_buffer_destroy(buffer);
@@ -207,6 +210,16 @@ size_t ion_heap_freelist_drain(struct ion_heap *heap, size_t size)
 	return total_drained;
 }
 
+size_t ion_heap_freelist_drain(struct ion_heap *heap, size_t size)
+{
+	return _ion_heap_freelist_drain(heap, size, false);
+}
+
+size_t ion_heap_freelist_shrink(struct ion_heap *heap, size_t size)
+{
+	return _ion_heap_freelist_drain(heap, size, true);
+}
+
 static int ion_heap_deferred_free(void *data)
 {
 	struct ion_heap *heap = data;
@@ -278,10 +291,10 @@ static unsigned long ion_heap_shrink_scan(struct shrinker *shrinker,
 
 	/*
 	 * shrink the free list first, no point in zeroing the memory if we're
-	 * just going to reclaim it
+	 * just going to reclaim it. Also, skip any possible page pooling.
 	 */
 	if (heap->flags & ION_HEAP_FLAG_DEFER_FREE)
-		freed = ion_heap_freelist_drain(heap, to_scan * PAGE_SIZE) /
+		freed = ion_heap_freelist_shrink(heap, to_scan * PAGE_SIZE) /
 				PAGE_SIZE;
 
 	to_scan -= freed;
diff --git a/drivers/staging/android/ion/ion_priv.h b/drivers/staging/android/ion/ion_priv.h
index bcf9d19..1eba3f2 100644
--- a/drivers/staging/android/ion/ion_priv.h
+++ b/drivers/staging/android/ion/ion_priv.h
@@ -38,6 +38,7 @@ struct ion_buffer *ion_handle_buffer(struct ion_handle *handle);
  * @dev:		back pointer to the ion_device
  * @heap:		back pointer to the heap the buffer came from
  * @flags:		buffer specific flags
+ * @private_flags:	internal buffer specific flags
  * @size:		size of the buffer
  * @priv_virt:		private data to the buffer representable as
  *			a void *
@@ -66,6 +67,7 @@ struct ion_buffer {
 	struct ion_device *dev;
 	struct ion_heap *heap;
 	unsigned long flags;
+	unsigned long private_flags;
 	size_t size;
 	union {
 		void *priv_virt;
@@ -98,7 +100,11 @@ void ion_buffer_destroy(struct ion_buffer *buffer);
  * @map_user		map memory to userspace
  *
  * allocate, phys, and map_user return 0 on success, -errno on error.
- * map_dma and map_kernel return pointer on success, ERR_PTR on error.
+ * map_dma and map_kernel return pointer on success, ERR_PTR on
+ * error. @free will be called with ION_PRIV_FLAG_SHRINKER_FREE set in
+ * the buffer's private_flags when called from a shrinker. In that
+ * case, the pages being free'd must be truly free'd back to the
+ * system, not put in a page pool or otherwise cached.
  */
 struct ion_heap_ops {
 	int (*allocate)(struct ion_heap *heap,
@@ -123,6 +129,17 @@ struct ion_heap_ops {
 #define ION_HEAP_FLAG_DEFER_FREE (1 << 0)
 
 /**
+ * private flags - flags internal to ion
+ */
+/*
+ * Buffer is being freed from a shrinker function. Skip any possible
+ * heap-specific caching mechanism (e.g. page pools). Guarantees that
+ * any buffer storage that came from the system allocator will be
+ * returned to the system allocator.
+ */
+#define ION_PRIV_FLAG_SHRINKER_FREE (1 << 0)
+
+/**
  * struct ion_heap - represents a heap in the system
  * @node:		rb node to put the heap on the device's tree of heaps
  * @dev:		back pointer to the ion_device
@@ -258,6 +275,29 @@ void ion_heap_freelist_add(struct ion_heap *heap, struct ion_buffer *buffer);
 size_t ion_heap_freelist_drain(struct ion_heap *heap, size_t size);
 
 /**
+ * ion_heap_freelist_shrink - drain the deferred free
+ *				list, skipping any heap-specific
+ *				pooling or caching mechanisms
+ *
+ * @heap:		the heap
+ * @size:		amount of memory to drain in bytes
+ *
+ * Drains the indicated amount of memory from the deferred freelist immediately.
+ * Returns the total amount freed.  The total freed may be higher depending
+ * on the size of the items in the list, or lower if there is insufficient
+ * total memory on the freelist.
+ *
+ * Unlike with @ion_heap_freelist_drain, don't put any pages back into
+ * page pools or otherwise cache the pages. Everything must be
+ * genuinely free'd back to the system. If you're free'ing from a
+ * shrinker you probably want to use this. Note that this relies on
+ * the heap.ops.free callback honoring the ION_PRIV_FLAG_SHRINKER_FREE
+ * flag.
+ */
+size_t ion_heap_freelist_shrink(struct ion_heap *heap,
+					size_t size);
+
+/**
  * ion_heap_freelist_size - returns the size of the freelist in bytes
  * @heap:		the heap
  */
diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index f453d97..c923633 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -90,7 +90,7 @@ static void free_buffer_page(struct ion_system_heap *heap,
 {
 	bool cached = ion_buffer_cached(buffer);
 
-	if (!cached) {
+	if (!cached && !(buffer->private_flags & ION_PRIV_FLAG_SHRINKER_FREE)) {
 		struct ion_page_pool *pool = heap->pools[order_to_index(order)];
 		ion_page_pool_free(pool, page);
 	} else {
@@ -209,7 +209,7 @@ static void ion_system_heap_free(struct ion_buffer *buffer)
 
 	/* uncached pages come from the page pools, zero them before returning
 	   for security purposes (other allocations are zerod at alloc time */
-	if (!cached)
+	if (!cached && !(buffer->private_flags & ION_PRIV_FLAG_SHRINKER_FREE))
 		ion_heap_buffer_zero(buffer);
 
 	for_each_sg(table->sgl, sg, table->nents, i)
-- 
1.8.3.2

