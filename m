Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab3LMW21 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:28:27 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:38554 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231Ab3LMW2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:28:23 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 087/115] ion: fix dma APIs
Date: Fri, 13 Dec 2013 14:25:01 -0800
Message-Id: <1386973529-4884-88-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

__dma_page_cpu_to_dev is a private ARM api that is not available
on 3.10 and was never available on other architectures.  We can
get the same behavior by calling dma_sync_sg_for_device with a
scatterlist containing a single page.  It's still not quite a
kosher use of the dma apis, we still conflate physical addresses
with bus addresses, but it should at least compile on all
platforms, and work on any platform that doesn't have a physical
to bus address translation.

Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c             | 20 +++++++++++++++++++-
 drivers/staging/android/ion/ion_chunk_heap.c  | 15 +++++++--------
 drivers/staging/android/ion/ion_page_pool.c   |  9 ++-------
 drivers/staging/android/ion/ion_priv.h        | 12 ++++++++++++
 drivers/staging/android/ion/ion_system_heap.c |  5 ++---
 5 files changed, 42 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 2e7be70..4bdbdec 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -840,6 +840,22 @@ static void ion_unmap_dma_buf(struct dma_buf_attachment *attachment,
 {
 }
 
+void ion_pages_sync_for_device(struct device *dev, struct page *page,
+		size_t size, enum dma_data_direction dir)
+{
+	struct scatterlist sg;
+
+	sg_init_table(&sg, 1);
+	sg_set_page(&sg, page, size, 0);
+	/*
+	 * This is not correct - sg_dma_address needs a dma_addr_t that is valid
+	 * for the the targeted device, but this works on the currently targeted
+	 * hardware.
+	 */
+	sg_dma_address(&sg) = page_to_phys(page);
+	dma_sync_sg_for_device(dev, &sg, 1, dir);
+}
+
 struct ion_vma_list {
 	struct list_head list;
 	struct vm_area_struct *vma;
@@ -864,7 +880,9 @@ static void ion_buffer_sync_for_device(struct ion_buffer *buffer,
 		struct page *page = buffer->pages[i];
 
 		if (ion_buffer_page_is_dirty(page))
-			__dma_page_cpu_to_dev(page, 0, PAGE_SIZE, dir);
+			ion_pages_sync_for_device(dev, ion_buffer_page(page),
+							PAGE_SIZE, dir);
+
 		ion_buffer_page_clean(buffer->pages + i);
 	}
 	list_for_each_entry(vma_list, &buffer->vmas, list) {
diff --git a/drivers/staging/android/ion/ion_chunk_heap.c b/drivers/staging/android/ion/ion_chunk_heap.c
index 85fefe7..2fddc04 100644
--- a/drivers/staging/android/ion/ion_chunk_heap.c
+++ b/drivers/staging/android/ion/ion_chunk_heap.c
@@ -106,11 +106,11 @@ static void ion_chunk_heap_free(struct ion_buffer *buffer)
 
 	ion_heap_buffer_zero(buffer);
 
+	if (ion_buffer_cached(buffer))
+		dma_sync_sg_for_device(NULL, table->sgl, table->nents,
+								DMA_BIDIRECTIONAL);
+
 	for_each_sg(table->sgl, sg, table->nents, i) {
-		if (ion_buffer_cached(buffer))
-			arm_dma_ops.sync_single_for_device(NULL,
-				pfn_to_dma(NULL, page_to_pfn(sg_page(sg))),
-				sg_dma_len(sg), DMA_BIDIRECTIONAL);
 		gen_pool_free(chunk_heap->pool, page_to_phys(sg_page(sg)),
 			      sg_dma_len(sg));
 	}
@@ -148,7 +148,6 @@ struct ion_heap *ion_chunk_heap_create(struct ion_platform_heap *heap_data)
 	pgprot_t pgprot = pgprot_writecombine(PAGE_KERNEL);
 	int i, ret;
 
-
 	chunk_heap = kzalloc(sizeof(struct ion_chunk_heap), GFP_KERNEL);
 	if (!chunk_heap)
 		return ERR_PTR(-ENOMEM);
@@ -181,9 +180,9 @@ struct ion_heap *ion_chunk_heap_create(struct ion_platform_heap *heap_data)
 	}
 	free_vm_area(vm_struct);
 
-	arm_dma_ops.sync_single_for_device(NULL,
-		pfn_to_dma(NULL, page_to_pfn(phys_to_page(heap_data->base))),
-		heap_data->size, DMA_BIDIRECTIONAL);
+	ion_pages_sync_for_device(NULL, pfn_to_page(PFN_DOWN(heap_data->base)),
+			heap_data->size, DMA_BIDIRECTIONAL);
+
 	gen_pool_add(chunk_heap->pool, chunk_heap->base, heap_data->size, -1);
 	chunk_heap->heap.ops = &chunk_heap_ops;
 	chunk_heap->heap.type = ION_HEAP_TYPE_CHUNK;
diff --git a/drivers/staging/android/ion/ion_page_pool.c b/drivers/staging/android/ion/ion_page_pool.c
index 855f30c..979d2e4 100644
--- a/drivers/staging/android/ion/ion_page_pool.c
+++ b/drivers/staging/android/ion/ion_page_pool.c
@@ -34,13 +34,8 @@ static void *ion_page_pool_alloc_pages(struct ion_page_pool *pool)
 
 	if (!page)
 		return NULL;
-	/* this is only being used to flush the page for dma,
-	   this api is not really suitable for calling from a driver
-	   but no better way to flush a page for dma exist at this time */
-	arm_dma_ops.sync_single_for_device(NULL,
-					   pfn_to_dma(NULL, page_to_pfn(page)),
-					   PAGE_SIZE << pool->order,
-					   DMA_BIDIRECTIONAL);
+	ion_pages_sync_for_device(NULL, page, PAGE_SIZE << pool->order,
+						DMA_BIDIRECTIONAL);
 	return page;
 }
 
diff --git a/drivers/staging/android/ion/ion_priv.h b/drivers/staging/android/ion/ion_priv.h
index f263563..d1fa771 100644
--- a/drivers/staging/android/ion/ion_priv.h
+++ b/drivers/staging/android/ion/ion_priv.h
@@ -17,6 +17,7 @@
 #ifndef _ION_PRIV_H
 #define _ION_PRIV_H
 
+#include <linux/dma-direction.h>
 #include <linux/kref.h>
 #include <linux/mm_types.h>
 #include <linux/mutex.h>
@@ -357,4 +358,15 @@ void ion_page_pool_free(struct ion_page_pool *, struct page *);
 int ion_page_pool_shrink(struct ion_page_pool *pool, gfp_t gfp_mask,
 			  int nr_to_scan);
 
+/**
+ * ion_pages_sync_for_device - cache flush pages for use with the specified
+ *                             device
+ * @dev:		the device the pages will be used with
+ * @page:		the first page to be flushed
+ * @size:		size in bytes of region to be flushed
+ * @dir:		direction of dma transfer
+ */
+void ion_pages_sync_for_device(struct device *dev, struct page *page,
+		size_t size, enum dma_data_direction dir);
+
 #endif /* _ION_PRIV_H */
diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index b9b1036..792cade 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -77,9 +77,8 @@ static struct page *alloc_buffer_page(struct ion_system_heap *heap,
 		page = ion_heap_alloc_pages(buffer, gfp_flags, order);
 		if (!page)
 			return 0;
-		arm_dma_ops.sync_single_for_device(NULL,
-			pfn_to_dma(NULL, page_to_pfn(page)),
-			PAGE_SIZE << order, DMA_BIDIRECTIONAL);
+		ion_pages_sync_for_device(NULL, page, PAGE_SIZE << order,
+						DMA_BIDIRECTIONAL);
 	}
 	if (!page)
 		return 0;
-- 
1.8.3.2

