Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab3LMW2E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:28:04 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:44598 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab3LMW17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:27:59 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 071/115] gpu: ion: Fix performance issue in faulting code
Date: Fri, 13 Dec 2013 14:24:45 -0800
Message-Id: <1386973529-4884-72-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

Previously the code to fault ion buffers in one page at a time had a
performance problem caused by the requirement to traverse the sg list
looking for the right page to load in (a result of the fact that the items in
the list may not be of uniform size).  To fix the problem, for buffers
that will be faulted in, also keep a flat array of all the pages in the buffer
to use from the fault handler.  To recover some of the additional memory
footprint this creates per buffer, dirty bits used to indicate which
pages have been faulted in to the cpu are now stored in the low bit of each
page struct pointer in the page array.

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c             | 105 +++++++++++++++-----------
 drivers/staging/android/ion/ion_cma_heap.c    |  35 +--------
 drivers/staging/android/ion/ion_heap.c        |  18 ++++-
 drivers/staging/android/ion/ion_priv.h        |  20 ++++-
 drivers/staging/android/ion/ion_system_heap.c |  25 +-----
 5 files changed, 99 insertions(+), 104 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index ddf8fde..38d65c2 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -31,6 +31,7 @@
 #include <linux/slab.h>
 #include <linux/seq_file.h>
 #include <linux/uaccess.h>
+#include <linux/vmalloc.h>
 #include <linux/debugfs.h>
 #include <linux/dma-buf.h>
 
@@ -104,13 +105,33 @@ struct ion_handle {
 
 bool ion_buffer_fault_user_mappings(struct ion_buffer *buffer)
 {
-        return ((buffer->flags & ION_FLAG_CACHED) &&
-                !(buffer->flags & ION_FLAG_CACHED_NEEDS_SYNC));
+	return ((buffer->flags & ION_FLAG_CACHED) &&
+		!(buffer->flags & ION_FLAG_CACHED_NEEDS_SYNC));
 }
 
 bool ion_buffer_cached(struct ion_buffer *buffer)
 {
-        return !!(buffer->flags & ION_FLAG_CACHED);
+	return !!(buffer->flags & ION_FLAG_CACHED);
+}
+
+static inline struct page *ion_buffer_page(struct page *page)
+{
+	return (struct page *)((unsigned long)page & ~(1UL));
+}
+
+static inline bool ion_buffer_page_is_dirty(struct page *page)
+{
+	return !!((unsigned long)page & 1UL);
+}
+
+static inline void ion_buffer_page_dirty(struct page **page)
+{
+	*page = (struct page *)((unsigned long)(*page) | 1UL);
+}
+
+static inline void ion_buffer_page_clean(struct page **page)
+{
+	*page = (struct page *)((unsigned long)(*page) & ~(1UL));
 }
 
 /* this function should only be called while dev->lock is held */
@@ -139,8 +160,6 @@ static void ion_buffer_add(struct ion_device *dev,
 	rb_insert_color(&buffer->node, &dev->buffers);
 }
 
-static int ion_buffer_alloc_dirty(struct ion_buffer *buffer);
-
 /* this function should only be called while dev->lock is held */
 static struct ion_buffer *ion_buffer_create(struct ion_heap *heap,
 				     struct ion_device *dev,
@@ -185,17 +204,23 @@ static struct ion_buffer *ion_buffer_create(struct ion_heap *heap,
 	}
 	buffer->sg_table = table;
 	if (ion_buffer_fault_user_mappings(buffer)) {
-		for_each_sg(buffer->sg_table->sgl, sg, buffer->sg_table->nents,
-			    i) {
-			if (sg_dma_len(sg) == PAGE_SIZE)
-				continue;
-			pr_err("%s: cached mappings that will be faulted in "
-			       "must have pagewise sg_lists\n", __func__);
-			ret = -EINVAL;
-			goto err;
+		int num_pages = PAGE_ALIGN(buffer->size) / PAGE_SIZE;
+		struct scatterlist *sg;
+		int i, j, k = 0;
+
+		buffer->pages = vmalloc(sizeof(struct page *) * num_pages);
+		if (!buffer->pages) {
+			ret = -ENOMEM;
+			goto err1;
+		}
+
+		for_each_sg(table->sgl, sg, table->nents, i) {
+			struct page *page = sg_page(sg);
+
+			for (j = 0; j < sg_dma_len(sg) / PAGE_SIZE; j++)
+				buffer->pages[k++] = page++;
 		}
 
-		ret = ion_buffer_alloc_dirty(buffer);
 		if (ret)
 			goto err;
 	}
@@ -222,6 +247,9 @@ static struct ion_buffer *ion_buffer_create(struct ion_heap *heap,
 err:
 	heap->ops->unmap_dma(heap, buffer);
 	heap->ops->free(buffer);
+err1:
+	if (buffer->pages)
+		vfree(buffer->pages);
 err2:
 	kfree(buffer);
 	return ERR_PTR(ret);
@@ -233,8 +261,8 @@ void ion_buffer_destroy(struct ion_buffer *buffer)
 		buffer->heap->ops->unmap_kernel(buffer->heap, buffer);
 	buffer->heap->ops->unmap_dma(buffer->heap, buffer);
 	buffer->heap->ops->free(buffer);
-	if (buffer->flags & ION_FLAG_CACHED)
-		kfree(buffer->dirty);
+	if (buffer->pages)
+		vfree(buffer->pages);
 	kfree(buffer);
 }
 
@@ -764,17 +792,6 @@ static void ion_unmap_dma_buf(struct dma_buf_attachment *attachment,
 {
 }
 
-static int ion_buffer_alloc_dirty(struct ion_buffer *buffer)
-{
-	unsigned long pages = buffer->sg_table->nents;
-	unsigned long length = (pages + BITS_PER_LONG - 1)/BITS_PER_LONG;
-
-	buffer->dirty = kzalloc(length * sizeof(unsigned long), GFP_KERNEL);
-	if (!buffer->dirty)
-		return -ENOMEM;
-	return 0;
-}
-
 struct ion_vma_list {
 	struct list_head list;
 	struct vm_area_struct *vma;
@@ -784,9 +801,9 @@ static void ion_buffer_sync_for_device(struct ion_buffer *buffer,
 				       struct device *dev,
 				       enum dma_data_direction dir)
 {
-	struct scatterlist *sg;
-	int i;
 	struct ion_vma_list *vma_list;
+	int pages = PAGE_ALIGN(buffer->size) / PAGE_SIZE;
+	int i;
 
 	pr_debug("%s: syncing for device %s\n", __func__,
 		 dev ? dev_name(dev) : "null");
@@ -795,11 +812,12 @@ static void ion_buffer_sync_for_device(struct ion_buffer *buffer,
 		return;
 
 	mutex_lock(&buffer->lock);
-	for_each_sg(buffer->sg_table->sgl, sg, buffer->sg_table->nents, i) {
-		if (!test_bit(i, buffer->dirty))
-			continue;
-		dma_sync_sg_for_device(dev, sg, 1, dir);
-		clear_bit(i, buffer->dirty);
+	for (i = 0; i < pages; i++) {
+		struct page *page = buffer->pages[i];
+
+		if (ion_buffer_page_is_dirty(page))
+			__dma_page_cpu_to_dev(page, 0, PAGE_SIZE, dir);
+		ion_buffer_page_clean(buffer->pages + i);
 	}
 	list_for_each_entry(vma_list, &buffer->vmas, list) {
 		struct vm_area_struct *vma = vma_list->vma;
@@ -813,21 +831,18 @@ static void ion_buffer_sync_for_device(struct ion_buffer *buffer,
 int ion_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct ion_buffer *buffer = vma->vm_private_data;
-	struct scatterlist *sg;
-	int i;
+	int ret;
 
 	mutex_lock(&buffer->lock);
-	set_bit(vmf->pgoff, buffer->dirty);
+	ion_buffer_page_dirty(buffer->pages + vmf->pgoff);
 
-	for_each_sg(buffer->sg_table->sgl, sg, buffer->sg_table->nents, i) {
-		if (i != vmf->pgoff)
-			continue;
-		dma_sync_sg_for_cpu(NULL, sg, 1, DMA_BIDIRECTIONAL);
-		vm_insert_page(vma, (unsigned long)vmf->virtual_address,
-			       sg_page(sg));
-		break;
-	}
+	BUG_ON(!buffer->pages || !buffer->pages[vmf->pgoff]);
+	ret = vm_insert_page(vma, (unsigned long)vmf->virtual_address,
+			     ion_buffer_page(buffer->pages[vmf->pgoff]));
 	mutex_unlock(&buffer->lock);
+	if (ret)
+		return VM_FAULT_ERROR;
+
 	return VM_FAULT_NOPAGE;
 }
 
diff --git a/drivers/staging/android/ion/ion_cma_heap.c b/drivers/staging/android/ion/ion_cma_heap.c
index 74e3c77..86b6cf5 100644
--- a/drivers/staging/android/ion/ion_cma_heap.c
+++ b/drivers/staging/android/ion/ion_cma_heap.c
@@ -58,29 +58,6 @@ int ion_cma_get_sgtable(struct device *dev, struct sg_table *sgt,
 	return 0;
 }
 
-/*
- * Create scatter-list for each page of the already allocated DMA buffer.
- */
-int ion_cma_get_sgtable_per_page(struct device *dev, struct sg_table *sgt,
-			void *cpu_addr, dma_addr_t handle, size_t size)
-{
-	struct page *page = virt_to_page(cpu_addr);
-	int ret, i;
-	struct scatterlist *sg;
-
-	ret = sg_alloc_table(sgt, PAGE_ALIGN(size) / PAGE_SIZE, GFP_KERNEL);
-	if (unlikely(ret))
-		return ret;
-
-	sg = sgt->sgl;
-	for (i = 0; i < (PAGE_ALIGN(size) / PAGE_SIZE); i++) {
-		page = virt_to_page(cpu_addr + (i * PAGE_SIZE));
-		sg_set_page(sg, page, PAGE_SIZE, 0);
-		sg = sg_next(sg);
-	}
-	return 0;
-}
-
 /* ION CMA heap operations functions */
 static int ion_cma_allocate(struct ion_heap *heap, struct ion_buffer *buffer,
 			    unsigned long len, unsigned long align,
@@ -111,15 +88,9 @@ static int ion_cma_allocate(struct ion_heap *heap, struct ion_buffer *buffer,
 		goto free_mem;
 	}
 
-	if (ion_buffer_fault_user_mappings(buffer)) {
-		if (ion_cma_get_sgtable_per_page
-			(dev, info->table, info->cpu_addr, info->handle, len))
-			goto free_table;
-	} else {
-		if (ion_cma_get_sgtable
-			(dev, info->table, info->cpu_addr, info->handle, len))
-			goto free_table;
-	}
+	if (ion_cma_get_sgtable
+	    (dev, info->table, info->cpu_addr, info->handle, len))
+		goto free_table;
 	/* keep this for memory release */
 	buffer->priv_virt = info;
 	dev_dbg(dev, "Allocate buffer %p\n", buffer);
diff --git a/drivers/staging/android/ion/ion_heap.c b/drivers/staging/android/ion/ion_heap.c
index 3fc1dcc..cc2a425 100644
--- a/drivers/staging/android/ion/ion_heap.c
+++ b/drivers/staging/android/ion/ion_heap.c
@@ -134,8 +134,22 @@ end:
 	return ret;
 }
 
-void ion_heap_free_page(struct ion_buffer *buffer, struct page *page,
-		       unsigned int order)
+struct page *ion_heap_alloc_pages(struct ion_buffer *buffer, gfp_t gfp_flags,
+				  unsigned int order)
+{
+	struct page *page = alloc_pages(gfp_flags, order);
+
+	if (!page)
+		return page;
+
+	if (ion_buffer_fault_user_mappings(buffer))
+		split_page(page, order);
+
+	return page;
+}
+
+void ion_heap_free_pages(struct ion_buffer *buffer, struct page *page,
+			 unsigned int order)
 {
 	int i;
 
diff --git a/drivers/staging/android/ion/ion_priv.h b/drivers/staging/android/ion/ion_priv.h
index f5a09b6..965471a 100644
--- a/drivers/staging/android/ion/ion_priv.h
+++ b/drivers/staging/android/ion/ion_priv.h
@@ -46,9 +46,8 @@ struct ion_buffer *ion_handle_buffer(struct ion_handle *handle);
  * @vaddr:		the kenrel mapping if kmap_cnt is not zero
  * @dmap_cnt:		number of times the buffer is mapped for dma
  * @sg_table:		the sg table for the buffer if dmap_cnt is not zero
- * @dirty:		bitmask representing which pages of this buffer have
- *			been dirtied by the cpu and need cache maintenance
- *			before dma
+ * @pages:		flat array of pages in the buffer -- used by fault
+ *			handler and only valid for buffers that are faulted in
  * @vmas:		list of vma's mapping this buffer
  * @handle_count:	count of handles referencing this buffer
  * @task_comm:		taskcomm of last client to reference this buffer in a
@@ -75,7 +74,7 @@ struct ion_buffer {
 	void *vaddr;
 	int dmap_cnt;
 	struct sg_table *sg_table;
-	unsigned long *dirty;
+	struct page **pages;
 	struct list_head vmas;
 	/* used to track orphaned buffers */
 	int handle_count;
@@ -214,6 +213,19 @@ int ion_heap_map_user(struct ion_heap *, struct ion_buffer *,
 int ion_heap_buffer_zero(struct ion_buffer *buffer);
 
 /**
+ * ion_heap_alloc_pages - allocate pages from alloc_pages
+ * @buffer:		the buffer to allocate for, used to extract the flags
+ * @gfp_flags:		the gfp_t for the allocation
+ * @order:		the order of the allocatoin
+ *
+ * This funciton allocations from alloc pages and also does any other
+ * necessary operations based on the buffer->flags.  For buffers which
+ * will be faulted in the pages are split using split_page
+ */
+struct page *ion_heap_alloc_pages(struct ion_buffer *buffer, gfp_t gfp_flags,
+				  unsigned int order);
+
+/**
  * ion_heap_init_deferred_free -- initialize deferred free functionality
  * @heap:		the heap
  *
diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 344f753..b9b1036 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -64,7 +64,6 @@ static struct page *alloc_buffer_page(struct ion_system_heap *heap,
 				      unsigned long order)
 {
 	bool cached = ion_buffer_cached(buffer);
-	bool split_pages = ion_buffer_fault_user_mappings(buffer);
 	struct ion_page_pool *pool = heap->pools[order_to_index(order)];
 	struct page *page;
 
@@ -75,7 +74,7 @@ static struct page *alloc_buffer_page(struct ion_system_heap *heap,
 
 		if (order > 4)
 			gfp_flags = high_order_gfp_flags;
-		page = alloc_pages(gfp_flags, order);
+		page = ion_heap_alloc_pages(buffer, gfp_flags, order);
 		if (!page)
 			return 0;
 		arm_dma_ops.sync_single_for_device(NULL,
@@ -85,8 +84,6 @@ static struct page *alloc_buffer_page(struct ion_system_heap *heap,
 	if (!page)
 		return 0;
 
-	if (split_pages)
-		split_page(page, order);
 	return page;
 }
 
@@ -153,7 +150,6 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 	int i = 0;
 	long size_remaining = PAGE_ALIGN(size);
 	unsigned int max_order = orders[0];
-	bool split_pages = ion_buffer_fault_user_mappings(buffer);
 
 	INIT_LIST_HEAD(&pages);
 	while (size_remaining > 0) {
@@ -170,28 +166,15 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 	if (!table)
 		goto err;
 
-	if (split_pages)
-		ret = sg_alloc_table(table, PAGE_ALIGN(size) / PAGE_SIZE,
-				     GFP_KERNEL);
-	else
-		ret = sg_alloc_table(table, i, GFP_KERNEL);
-
+	ret = sg_alloc_table(table, i, GFP_KERNEL);
 	if (ret)
 		goto err1;
 
 	sg = table->sgl;
 	list_for_each_entry_safe(info, tmp_info, &pages, list) {
 		struct page *page = info->page;
-		if (split_pages) {
-			for (i = 0; i < (1 << info->order); i++) {
-				sg_set_page(sg, page + i, PAGE_SIZE, 0);
-				sg = sg_next(sg);
-			}
-		} else {
-			sg_set_page(sg, page, (1 << info->order) * PAGE_SIZE,
-				    0);
-			sg = sg_next(sg);
-		}
+		sg_set_page(sg, page, (1 << info->order) * PAGE_SIZE, 0);
+		sg = sg_next(sg);
 		list_del(&info->list);
 		kfree(info);
 	}
-- 
1.8.3.2

