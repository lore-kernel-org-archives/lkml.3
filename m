Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab3LND16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 22:27:58 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:50385 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab3LND1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 22:27:13 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 110/115] ion: add helper to zero contiguous region of pages
Date: Fri, 13 Dec 2013 19:26:30 -0800
Message-Id: <1386991595-6251-18-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
 <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

Add ion_heap_pages_zero for ion heaps to use to zero pages
during initialization or allocation, when a struct ion_buffer
may not be available.  Use it from the chunk heap and carveout
heaps.

Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_carveout_heap.c | 13 ++++++
 drivers/staging/android/ion/ion_chunk_heap.c    | 39 ++++++------------
 drivers/staging/android/ion/ion_heap.c          | 53 +++++++++++++++----------
 drivers/staging/android/ion/ion_priv.h          |  1 +
 4 files changed, 58 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/android/ion/ion_carveout_heap.c b/drivers/staging/android/ion/ion_carveout_heap.c
index 66dec4c..3cb05b9 100644
--- a/drivers/staging/android/ion/ion_carveout_heap.c
+++ b/drivers/staging/android/ion/ion_carveout_heap.c
@@ -150,6 +150,19 @@ static struct ion_heap_ops carveout_heap_ops = {
 struct ion_heap *ion_carveout_heap_create(struct ion_platform_heap *heap_data)
 {
 	struct ion_carveout_heap *carveout_heap;
+	int ret;
+
+	struct page *page;
+	size_t size;
+
+	page = pfn_to_page(PFN_DOWN(heap_data->base));
+	size = heap_data->size;
+
+	ion_pages_sync_for_device(NULL, page, size, DMA_BIDIRECTIONAL);
+
+	ret = ion_heap_pages_zero(page, size, pgprot_writecombine(PAGE_KERNEL));
+	if (ret)
+		return ERR_PTR(ret);
 
 	carveout_heap = kzalloc(sizeof(struct ion_carveout_heap), GFP_KERNEL);
 	if (!carveout_heap)
diff --git a/drivers/staging/android/ion/ion_chunk_heap.c b/drivers/staging/android/ion/ion_chunk_heap.c
index 46e8a3b..f21530f 100644
--- a/drivers/staging/android/ion/ion_chunk_heap.c
+++ b/drivers/staging/android/ion/ion_chunk_heap.c
@@ -140,9 +140,18 @@ static struct ion_heap_ops chunk_heap_ops = {
 struct ion_heap *ion_chunk_heap_create(struct ion_platform_heap *heap_data)
 {
 	struct ion_chunk_heap *chunk_heap;
-	struct vm_struct *vm_struct;
-	pgprot_t pgprot = pgprot_writecombine(PAGE_KERNEL);
-	int i, ret;
+	int ret;
+	struct page *page;
+	size_t size;
+
+	page = pfn_to_page(PFN_DOWN(heap_data->base));
+	size = heap_data->size;
+
+	ion_pages_sync_for_device(NULL, page, size, DMA_BIDIRECTIONAL);
+
+	ret = ion_heap_pages_zero(page, size, pgprot_writecombine(PAGE_KERNEL));
+	if (ret)
+		return ERR_PTR(ret);
 
 	chunk_heap = kzalloc(sizeof(struct ion_chunk_heap), GFP_KERNEL);
 	if (!chunk_heap)
@@ -159,26 +168,6 @@ struct ion_heap *ion_chunk_heap_create(struct ion_platform_heap *heap_data)
 	chunk_heap->size = heap_data->size;
 	chunk_heap->allocated = 0;
 
-	vm_struct = get_vm_area(PAGE_SIZE, VM_ALLOC);
-	if (!vm_struct) {
-		ret = -ENOMEM;
-		goto error;
-	}
-	for (i = 0; i < chunk_heap->size; i += PAGE_SIZE) {
-		struct page *page = pfn_to_page(PFN_DOWN(chunk_heap->base + i));
-		struct page **pages = &page;
-
-		ret = map_vm_area(vm_struct, pgprot, &pages);
-		if (ret)
-			goto error_map_vm_area;
-		memset(vm_struct->addr, 0, PAGE_SIZE);
-		unmap_kernel_range((unsigned long)vm_struct->addr, PAGE_SIZE);
-	}
-	free_vm_area(vm_struct);
-
-	ion_pages_sync_for_device(NULL, pfn_to_page(PFN_DOWN(heap_data->base)),
-			heap_data->size, DMA_BIDIRECTIONAL);
-
 	gen_pool_add(chunk_heap->pool, chunk_heap->base, heap_data->size, -1);
 	chunk_heap->heap.ops = &chunk_heap_ops;
 	chunk_heap->heap.type = ION_HEAP_TYPE_CHUNK;
@@ -188,10 +177,6 @@ struct ion_heap *ion_chunk_heap_create(struct ion_platform_heap *heap_data)
 
 	return &chunk_heap->heap;
 
-error_map_vm_area:
-	free_vm_area(vm_struct);
-error:
-	gen_pool_destroy(chunk_heap->pool);
 error_gen_pool_create:
 	kfree(chunk_heap);
 	return ERR_PTR(ret);
diff --git a/drivers/staging/android/ion/ion_heap.c b/drivers/staging/android/ion/ion_heap.c
index c3a213b..2d1d555 100644
--- a/drivers/staging/android/ion/ion_heap.c
+++ b/drivers/staging/android/ion/ion_heap.c
@@ -114,38 +114,49 @@ static int ion_heap_clear_pages(struct page **pages, int num, pgprot_t pgprot)
 	return 0;
 }
 
+static int ion_heap_sglist_zero(struct scatterlist *sgl, unsigned int nents,
+						pgprot_t pgprot)
+{
+	int p = 0;
+	int ret = 0;
+	struct sg_page_iter piter;
+	struct page *pages[32];
+
+	for_each_sg_page(sgl, &piter, nents, 0) {
+		pages[p++] = sg_page_iter_page(&piter);
+		if (p == ARRAY_SIZE(pages)) {
+			ret = ion_heap_clear_pages(pages, p, pgprot);
+			if (ret)
+				return ret;
+			p = 0;
+		}
+	}
+	if (p)
+		ret = ion_heap_clear_pages(pages, p, pgprot);
+
+	return ret;
+}
+
 int ion_heap_buffer_zero(struct ion_buffer *buffer)
 {
 	struct sg_table *table = buffer->sg_table;
 	pgprot_t pgprot;
-	struct scatterlist *sg;
-	int i, j, ret = 0;
-	struct page *pages[32];
-	int k = 0;
 
 	if (buffer->flags & ION_FLAG_CACHED)
 		pgprot = PAGE_KERNEL;
 	else
 		pgprot = pgprot_writecombine(PAGE_KERNEL);
 
-	for_each_sg(table->sgl, sg, table->nents, i) {
-		struct page *page = sg_page(sg);
-		unsigned long len = sg->length;
+	return ion_heap_sglist_zero(table->sgl, table->nents, pgprot);
+}
 
-		for (j = 0; j < len / PAGE_SIZE; j++) {
-			pages[k++] = page + j;
-			if (k == ARRAY_SIZE(pages)) {
-				ret = ion_heap_clear_pages(pages, k, pgprot);
-				if (ret)
-					goto end;
-				k = 0;
-			}
-		}
-		if (k)
-			ret = ion_heap_clear_pages(pages, k, pgprot);
-	}
-end:
-	return ret;
+int ion_heap_pages_zero(struct page *page, size_t size, pgprot_t pgprot)
+{
+	struct scatterlist sg;
+
+	sg_init_table(&sg, 1);
+	sg_set_page(&sg, page, size, 0);
+	return ion_heap_sglist_zero(&sg, 1, pgprot);
 }
 
 void ion_heap_freelist_add(struct ion_heap *heap, struct ion_buffer * buffer)
diff --git a/drivers/staging/android/ion/ion_priv.h b/drivers/staging/android/ion/ion_priv.h
index c9b507d..fa96175 100644
--- a/drivers/staging/android/ion/ion_priv.h
+++ b/drivers/staging/android/ion/ion_priv.h
@@ -215,6 +215,7 @@ void ion_heap_unmap_kernel(struct ion_heap *, struct ion_buffer *);
 int ion_heap_map_user(struct ion_heap *, struct ion_buffer *,
 			struct vm_area_struct *);
 int ion_heap_buffer_zero(struct ion_buffer *buffer);
+int ion_heap_pages_zero(struct page *page, size_t size, pgprot_t pgprot);
 
 /**
  * ion_heap_init_deferred_free -- initialize deferred free functionality
-- 
1.8.3.2

