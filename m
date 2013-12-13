Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab3LMW1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:27:13 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:48709 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab3LMW1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:27:05 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 037/115] gpu: ion: Use the ion_page_pool from the system heap
Date: Fri, 13 Dec 2013 14:24:11 -0800
Message-Id: <1386973529-4884-38-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

With this change the system heap will use pagepools to avoid
having to invalidate memory when it is allocated, a
significant performance improvement on some systems.

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c             |  18 ++-
 drivers/staging/android/ion/ion_priv.h        |  11 ++
 drivers/staging/android/ion/ion_system_heap.c | 191 +++++++++++++++++++++-----
 3 files changed, 180 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 6c589cb..0070c9b 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -106,6 +106,11 @@ bool ion_buffer_fault_user_mappings(struct ion_buffer *buffer)
                 !(buffer->flags & ION_FLAG_CACHED_NEEDS_SYNC));
 }
 
+bool ion_buffer_cached(struct ion_buffer *buffer)
+{
+        return !!(buffer->flags & ION_FLAG_CACHED);
+}
+
 /* this function should only be called while dev->lock is held */
 static void ion_buffer_add(struct ion_device *dev,
 			   struct ion_buffer *buffer)
@@ -1219,11 +1224,12 @@ static int ion_debug_heap_show(struct seq_file *s, void *unused)
 	for (n = rb_first(&dev->buffers); n; n = rb_next(n)) {
 		struct ion_buffer *buffer = rb_entry(n, struct ion_buffer,
 						     node);
-		if (buffer->heap->type == heap->type)
-			total_size += buffer->size;
+		if (buffer->heap->type != heap->type)
+			continue;
+		total_size += buffer->size;
 		if (!buffer->handle_count) {
-			seq_printf(s, "%16.s %16u %16u\n", buffer->task_comm,
-				   buffer->pid, buffer->size);
+			seq_printf(s, "%16.s %16u %16u %d %d\n", buffer->task_comm,
+				   buffer->pid, buffer->size, buffer->kmap_cnt, buffer->ref);
 			total_orphaned_size += buffer->size;
 		}
 	}
@@ -1232,6 +1238,10 @@ static int ion_debug_heap_show(struct seq_file *s, void *unused)
 	seq_printf(s, "%16.s %16u\n", "total orphaned",
 		   total_orphaned_size);
 	seq_printf(s, "%16.s %16u\n", "total ", total_size);
+	seq_printf(s, "----------------------------------------------------\n");
+
+	if (heap->debug_show)
+		heap->debug_show(heap, s, unused);
 
 	return 0;
 }
diff --git a/drivers/staging/android/ion/ion_priv.h b/drivers/staging/android/ion/ion_priv.h
index 0707733..9f32634 100644
--- a/drivers/staging/android/ion/ion_priv.h
+++ b/drivers/staging/android/ion/ion_priv.h
@@ -118,6 +118,8 @@ struct ion_heap_ops {
  *			allocating.  These are specified by platform data and
  *			MUST be unique
  * @name:		used for debugging
+ * @debug_show:		called when heap debug file is read to add any
+ *			heap specific debug info to output
  *
  * Represents a pool of memory from which buffers can be made.  In some
  * systems the only heap is regular system memory allocated via vmalloc.
@@ -131,9 +133,18 @@ struct ion_heap {
 	struct ion_heap_ops *ops;
 	int id;
 	const char *name;
+	int (*debug_show)(struct ion_heap *heap, struct seq_file *, void *);
 };
 
 /**
+ * ion_buffer_cached - this ion buffer is cached
+ * @buffer:		buffer
+ *
+ * indicates whether this ion buffer is cached
+ */
+bool ion_buffer_cached(struct ion_buffer *buffer);
+
+/**
  * ion_buffer_fault_user_mappings - fault in user mappings of this buffer
  * @buffer:		buffer
  *
diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index fcfbb66..35fbfff 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -20,39 +20,112 @@
 #include <linux/highmem.h>
 #include <linux/mm.h>
 #include <linux/scatterlist.h>
+#include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include "ion.h"
 #include "ion_priv.h"
 
+static const unsigned int orders[] = {8, 4, 0};
+static const int num_orders = ARRAY_SIZE(orders);
+static int order_to_index(unsigned int order)
+{
+	int i;
+	for (i = 0; i < num_orders; i++)
+		if (order == orders[i])
+			return i;
+	BUG();
+	return -1;
+}
+
+static unsigned int order_to_size(int order)
+{
+	return PAGE_SIZE << order;
+}
+
+struct ion_system_heap {
+	struct ion_heap heap;
+	struct ion_page_pool **pools;
+};
+
 struct page_info {
 	struct page *page;
-	unsigned long order;
+	unsigned int order;
 	struct list_head list;
 };
 
-static unsigned int orders[] = {8, 4, 0};
+static struct page *alloc_buffer_page(struct ion_system_heap *heap,
+				      struct ion_buffer *buffer,
+				      unsigned long order)
+{
+	bool cached = ion_buffer_cached(buffer);
+	bool split_pages = ion_buffer_fault_user_mappings(buffer);
+	struct ion_page_pool *pool = heap->pools[order_to_index(order)];
+	struct page *page;
 
-static struct page_info *alloc_largest_available(unsigned long size,
-						 bool split_pages,
+	if (!cached)
+		page = ion_page_pool_alloc(pool);
+	else
+		page = alloc_pages(GFP_HIGHUSER | __GFP_ZERO |
+				   __GFP_NOWARN | __GFP_NORETRY, order);
+	if (!page)
+		return 0;
+	if (split_pages)
+		split_page(page, order);
+	return page;
+}
+
+static void free_buffer_page(struct ion_system_heap *heap,
+			     struct ion_buffer *buffer, struct page *page,
+			     unsigned int order)
+{
+	bool cached = ion_buffer_cached(buffer);
+	bool split_pages = ion_buffer_fault_user_mappings(buffer);
+	int i;
+
+	if (!cached) {
+		struct ion_page_pool *pool = heap->pools[order_to_index(order)];
+		/* zero the pages before returning them to the pool for
+		   security.  This uses vmap as we want to set the pgprot so
+		   the writes to occur to noncached mappings, as the pool's
+		   purpose is to keep the pages out of the cache */
+		for (i = 0; i < order / PAGE_SIZE; i++) {
+			struct page *sub_page = page + i;
+			void *addr = vmap(&sub_page, 1, VM_MAP,
+					  pgprot_writecombine(PAGE_KERNEL));
+			memset(addr, 0, PAGE_SIZE);
+			vunmap(addr);
+		}
+		ion_page_pool_free(pool, page);
+	} else if (split_pages) {
+		for (i = 0; i < (1 << order); i++)
+			__free_page(page + i);
+	} else {
+		__free_pages(page, order);
+	}
+}
+
+
+static struct page_info *alloc_largest_available(struct ion_system_heap *heap,
+						 struct ion_buffer *buffer,
+						 unsigned long size,
 						 unsigned int max_order)
 {
 	struct page *page;
 	struct page_info *info;
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(orders); i++) {
-		if (size < (1 << orders[i]) * PAGE_SIZE)
+	for (i = 0; i < num_orders; i++) {
+		if (size < order_to_size(orders[i]))
 			continue;
 		if (max_order < orders[i])
 			continue;
-		page = alloc_pages(GFP_HIGHUSER | __GFP_ZERO |
-				   __GFP_NOWARN | __GFP_NORETRY, orders[i]);
+
+		page = alloc_buffer_page(heap, buffer, orders[i]);
 		if (!page)
 			continue;
-		if (split_pages)
-			split_page(page, orders[i]);
-		info = kmalloc(sizeof(struct page_info *), GFP_KERNEL);
+
+		info = kmalloc(sizeof(struct page_info), GFP_KERNEL);
 		info->page = page;
 		info->order = orders[i];
 		return info;
@@ -65,6 +138,9 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 				     unsigned long size, unsigned long align,
 				     unsigned long flags)
 {
+	struct ion_system_heap *sys_heap = container_of(heap,
+							struct ion_system_heap,
+							heap);
 	struct sg_table *table;
 	struct scatterlist *sg;
 	int ret;
@@ -72,15 +148,12 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 	struct page_info *info, *tmp_info;
 	int i = 0;
 	long size_remaining = PAGE_ALIGN(size);
-	bool split_pages = ion_buffer_fault_user_mappings(buffer);
-
-
 	unsigned int max_order = orders[0];
+	bool split_pages = ion_buffer_fault_user_mappings(buffer);
 
 	INIT_LIST_HEAD(&pages);
 	while (size_remaining > 0) {
-		info = alloc_largest_available(size_remaining, split_pages,
-					       max_order);
+		info = alloc_largest_available(sys_heap, buffer, size_remaining, max_order);
 		if (!info)
 			goto err;
 		list_add_tail(&info->list, &pages);
@@ -105,7 +178,6 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 	sg = table->sgl;
 	list_for_each_entry_safe(info, tmp_info, &pages, list) {
 		struct page *page = info->page;
-
 		if (split_pages) {
 			for (i = 0; i < (1 << info->order); i++) {
 				sg_set_page(sg, page + i, PAGE_SIZE, 0);
@@ -129,12 +201,7 @@ err1:
 	kfree(table);
 err:
 	list_for_each_entry(info, &pages, list) {
-		if (split_pages)
-			for (i = 0; i < (1 << info->order); i++)
-				__free_page(info->page + i);
-		else
-			__free_pages(info->page, info->order);
-
+		free_buffer_page(sys_heap, buffer, info->page, info->order);
 		kfree(info);
 	}
 	return -ENOMEM;
@@ -142,15 +209,19 @@ err:
 
 void ion_system_heap_free(struct ion_buffer *buffer)
 {
-	int i;
-	struct scatterlist *sg;
+	struct ion_heap *heap = buffer->heap;
+	struct ion_system_heap *sys_heap = container_of(heap,
+							struct ion_system_heap,
+							heap);
 	struct sg_table *table = buffer->priv_virt;
+	struct scatterlist *sg;
+	LIST_HEAD(pages);
+	int i;
 
 	for_each_sg(table->sgl, sg, table->nents, i)
-		__free_pages(sg_page(sg), get_order(sg_dma_len(sg)));
-	if (buffer->sg_table)
-		sg_free_table(buffer->sg_table);
-	kfree(buffer->sg_table);
+		free_buffer_page(sys_heap, buffer, sg_page(sg), get_order(sg_dma_len(sg)));
+	sg_free_table(table);
+	kfree(table);
 }
 
 struct sg_table *ion_system_heap_map_dma(struct ion_heap *heap,
@@ -228,7 +299,7 @@ int ion_system_heap_map_user(struct ion_heap *heap, struct ion_buffer *buffer,
 	return 0;
 }
 
-static struct ion_heap_ops vmalloc_ops = {
+static struct ion_heap_ops system_heap_ops = {
 	.allocate = ion_system_heap_allocate,
 	.free = ion_system_heap_free,
 	.map_dma = ion_system_heap_map_dma,
@@ -238,21 +309,69 @@ static struct ion_heap_ops vmalloc_ops = {
 	.map_user = ion_system_heap_map_user,
 };
 
+static int ion_system_heap_debug_show(struct ion_heap *heap, struct seq_file *s,
+				      void *unused)
+{
+
+	struct ion_system_heap *sys_heap = container_of(heap,
+							struct ion_system_heap,
+							heap);
+	int i;
+	for (i = 0; i < num_orders; i++) {
+		struct ion_page_pool *pool = sys_heap->pools[i];
+		seq_printf(s, "%d order %u pages in pool = %lu total\n",
+			   pool->count, pool->order,
+			   (1 << pool->order) * PAGE_SIZE * pool->count);
+	}
+	return 0;
+}
+
 struct ion_heap *ion_system_heap_create(struct ion_platform_heap *unused)
 {
-	struct ion_heap *heap;
+	struct ion_system_heap *heap;
+	int i;
 
-	heap = kzalloc(sizeof(struct ion_heap), GFP_KERNEL);
+	heap = kzalloc(sizeof(struct ion_system_heap), GFP_KERNEL);
 	if (!heap)
 		return ERR_PTR(-ENOMEM);
-	heap->ops = &vmalloc_ops;
-	heap->type = ION_HEAP_TYPE_SYSTEM;
-	return heap;
+	heap->heap.ops = &system_heap_ops;
+	heap->heap.type = ION_HEAP_TYPE_SYSTEM;
+	heap->pools = kzalloc(sizeof(struct ion_page_pool *) * num_orders,
+			      GFP_KERNEL);
+	if (!heap->pools)
+		goto err_alloc_pools;
+	for (i = 0; i < num_orders; i++) {
+		struct ion_page_pool *pool;
+		pool = ion_page_pool_create(GFP_HIGHUSER | __GFP_ZERO |
+					   __GFP_NOWARN | __GFP_NORETRY,
+					   orders[i]);
+		if (!pool)
+			goto err_create_pool;
+		heap->pools[i] = pool;
+	}
+	heap->heap.debug_show = ion_system_heap_debug_show;
+	return &heap->heap;
+err_create_pool:
+	for (i = 0; i < num_orders; i++)
+		if (heap->pools[i])
+			ion_page_pool_destroy(heap->pools[i]);
+	kfree(heap->pools);
+err_alloc_pools:
+	kfree(heap);
+	return ERR_PTR(-ENOMEM);
 }
 
 void ion_system_heap_destroy(struct ion_heap *heap)
 {
-	kfree(heap);
+	struct ion_system_heap *sys_heap = container_of(heap,
+							struct ion_system_heap,
+							heap);
+	int i;
+
+	for (i = 0; i < num_orders; i++)
+		ion_page_pool_destroy(sys_heap->pools[i]);
+	kfree(sys_heap->pools);
+	kfree(sys_heap);
 }
 
 static int ion_system_contig_heap_allocate(struct ion_heap *heap,
-- 
1.8.3.2

