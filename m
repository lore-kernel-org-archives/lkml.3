Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab3LMWhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:37:48 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:53100 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab3LMW1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:27:39 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 058/115] gpu: ion: Refactor the code to zero buffers
Date: Fri, 13 Dec 2013 14:24:32 -0800
Message-Id: <1386973529-4884-59-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

Refactor the code in the system heap used to map and zero the buffers
into a seperate utility so it can be called from other heaps.  Use it from
the chunk heap.

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_chunk_heap.c  |  2 ++
 drivers/staging/android/ion/ion_heap.c        | 37 +++++++++++++++++++++++++++
 drivers/staging/android/ion/ion_priv.h        |  1 +
 drivers/staging/android/ion/ion_system_heap.c | 34 ++++++------------------
 4 files changed, 48 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/android/ion/ion_chunk_heap.c b/drivers/staging/android/ion/ion_chunk_heap.c
index 1d47409..5582909 100644
--- a/drivers/staging/android/ion/ion_chunk_heap.c
+++ b/drivers/staging/android/ion/ion_chunk_heap.c
@@ -101,6 +101,8 @@ static void ion_chunk_heap_free(struct ion_buffer *buffer)
 	struct scatterlist *sg;
 	int i;
 
+	ion_heap_buffer_zero(buffer);
+
 	for_each_sg(table->sgl, sg, table->nents, i) {
 		__dma_page_cpu_to_dev(sg_page(sg), 0, sg_dma_len(sg),
 				      DMA_BIDIRECTIONAL);
diff --git a/drivers/staging/android/ion/ion_heap.c b/drivers/staging/android/ion/ion_heap.c
index a9bf52e..11066a2 100644
--- a/drivers/staging/android/ion/ion_heap.c
+++ b/drivers/staging/android/ion/ion_heap.c
@@ -93,6 +93,43 @@ int ion_heap_map_user(struct ion_heap *heap, struct ion_buffer *buffer,
 	return 0;
 }
 
+int ion_heap_buffer_zero(struct ion_buffer *buffer)
+{
+	struct sg_table *table = buffer->sg_table;
+	pgprot_t pgprot;
+	struct scatterlist *sg;
+	struct vm_struct *vm_struct;
+	int i, j, ret = 0;
+
+	if (buffer->flags & ION_FLAG_CACHED)
+		pgprot = PAGE_KERNEL;
+	else
+		pgprot = pgprot_writecombine(PAGE_KERNEL);
+
+	vm_struct = get_vm_area(PAGE_SIZE, VM_ALLOC);
+	if (!vm_struct)
+		return -ENOMEM;
+
+	for_each_sg(table->sgl, sg, table->nents, i) {
+		struct page *page = sg_page(sg);
+		unsigned long len = sg_dma_len(sg);
+
+		for (j = 0; j < len / PAGE_SIZE; j++) {
+			struct page *sub_page = page + j;
+			struct page **pages = &sub_page;
+			ret = map_vm_area(vm_struct, pgprot, &pages);
+			if (ret)
+				goto end;
+			memset(vm_struct->addr, 0, PAGE_SIZE);
+			unmap_kernel_range((unsigned long)vm_struct->addr,
+					   PAGE_SIZE);
+		}
+	}
+end:
+	free_vm_area(vm_struct);
+	return ret;
+}
+
 struct ion_heap *ion_heap_create(struct ion_platform_heap *heap_data)
 {
 	struct ion_heap *heap = NULL;
diff --git a/drivers/staging/android/ion/ion_priv.h b/drivers/staging/android/ion/ion_priv.h
index eef4de8..cfb4264 100644
--- a/drivers/staging/android/ion/ion_priv.h
+++ b/drivers/staging/android/ion/ion_priv.h
@@ -185,6 +185,7 @@ void *ion_heap_map_kernel(struct ion_heap *, struct ion_buffer *);
 void ion_heap_unmap_kernel(struct ion_heap *, struct ion_buffer *);
 int ion_heap_map_user(struct ion_heap *, struct ion_buffer *,
 			struct vm_area_struct *);
+int ion_heap_buffer_zero(struct ion_buffer *buffer);
 
 
 /**
diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index e54307f..3ca704e 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -91,7 +91,7 @@ static struct page *alloc_buffer_page(struct ion_system_heap *heap,
 
 static void free_buffer_page(struct ion_system_heap *heap,
 			     struct ion_buffer *buffer, struct page *page,
-			     unsigned int order, struct vm_struct *vm_struct)
+			     unsigned int order)
 {
 	bool cached = ion_buffer_cached(buffer);
 	bool split_pages = ion_buffer_fault_user_mappings(buffer);
@@ -99,20 +99,6 @@ static void free_buffer_page(struct ion_system_heap *heap,
 
 	if (!cached) {
 		struct ion_page_pool *pool = heap->pools[order_to_index(order)];
-		/* zero the pages before returning them to the pool for
-		   security.  This uses vmap as we want to set the pgprot so
-		   the writes to occur to noncached mappings, as the pool's
-		   purpose is to keep the pages out of the cache */
-		for (i = 0; i < (1 << order); i++) {
-			struct page *sub_page = page + i;
-			struct page **pages = &sub_page;
-			map_vm_area(vm_struct,
-					 pgprot_writecombine(PAGE_KERNEL),
-					 &pages);
-			memset(vm_struct->addr, 0, PAGE_SIZE);
-			unmap_kernel_range((unsigned long)vm_struct->addr,
-					PAGE_SIZE);
-		}
 		ion_page_pool_free(pool, page);
 	} else if (split_pages) {
 		for (i = 0; i < (1 << order); i++)
@@ -167,8 +153,6 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 	long size_remaining = PAGE_ALIGN(size);
 	unsigned int max_order = orders[0];
 	bool split_pages = ion_buffer_fault_user_mappings(buffer);
-	struct vm_struct *vm_struct;
-	pte_t *ptes;
 
 	INIT_LIST_HEAD(&pages);
 	while (size_remaining > 0) {
@@ -216,13 +200,10 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 err1:
 	kfree(table);
 err:
-	vm_struct = get_vm_area(PAGE_SIZE, &ptes);
 	list_for_each_entry(info, &pages, list) {
-		free_buffer_page(sys_heap, buffer, info->page, info->order,
-				vm_struct);
+		free_buffer_page(sys_heap, buffer, info->page, info->order);
 		kfree(info);
 	}
-	free_vm_area(vm_struct);
 	return -ENOMEM;
 }
 
@@ -233,18 +214,19 @@ void ion_system_heap_free(struct ion_buffer *buffer)
 							struct ion_system_heap,
 							heap);
 	struct sg_table *table = buffer->sg_table;
+	bool cached = ion_buffer_cached(buffer);
 	struct scatterlist *sg;
 	LIST_HEAD(pages);
-	struct vm_struct *vm_struct;
-	pte_t *ptes;
 	int i;
 
-	vm_struct = get_vm_area(PAGE_SIZE, &ptes);
+	/* uncached pages come from the page pools, zero them before returning
+	   for security purposes (other allocations are zerod at alloc time */
+	if (!cached)
+		ion_heap_buffer_zero(buffer);
 
 	for_each_sg(table->sgl, sg, table->nents, i)
 		free_buffer_page(sys_heap, buffer, sg_page(sg),
-				get_order(sg_dma_len(sg)), vm_struct);
-	free_vm_area(vm_struct);
+				get_order(sg_dma_len(sg)));
 	sg_free_table(table);
 	kfree(table);
 }
-- 
1.8.3.2

