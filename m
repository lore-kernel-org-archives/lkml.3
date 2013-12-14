Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab3LND15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 22:27:57 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:58235 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab3LND1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 22:27:12 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 109/115] ion: carveout heap: zero buffers on free, fix memory leak
Date: Fri, 13 Dec 2013 19:26:29 -0800
Message-Id: <1386991595-6251-17-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
 <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

The carveout heap wasn't zeroing its buffers after use.
Create the sg_table during allocate instead of map_dma, to allow
using the sg_table during free, and call ion_heap_buffer_zero
during free.  Also fixes a missing kfree when destroying the
table.

Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_carveout_heap.c | 69 +++++++++++++++++--------
 1 file changed, 48 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/android/ion/ion_carveout_heap.c b/drivers/staging/android/ion/ion_carveout_heap.c
index 9bf20a3..66dec4c 100644
--- a/drivers/staging/android/ion/ion_carveout_heap.c
+++ b/drivers/staging/android/ion/ion_carveout_heap.c
@@ -14,7 +14,7 @@
  *
  */
 #include <linux/spinlock.h>
-
+#include <linux/dma-mapping.h>
 #include <linux/err.h>
 #include <linux/genalloc.h>
 #include <linux/io.h>
@@ -60,7 +60,11 @@ static int ion_carveout_heap_phys(struct ion_heap *heap,
 				  struct ion_buffer *buffer,
 				  ion_phys_addr_t *addr, size_t *len)
 {
-	*addr = buffer->priv_phys;
+	struct sg_table *table = buffer->priv_virt;
+	struct page *page = sg_page(table->sgl);
+	ion_phys_addr_t paddr = PFN_PHYS(page_to_pfn(page));
+
+	*addr = paddr;
 	*len = buffer->size;
 	return 0;
 }
@@ -70,44 +74,66 @@ static int ion_carveout_heap_allocate(struct ion_heap *heap,
 				      unsigned long size, unsigned long align,
 				      unsigned long flags)
 {
+	struct sg_table *table;
+	ion_phys_addr_t paddr;
+	int ret;
+
 	if (align > PAGE_SIZE)
 		return -EINVAL;
 
-	buffer->priv_phys = ion_carveout_allocate(heap, size, align);
-	return buffer->priv_phys == ION_CARVEOUT_ALLOCATE_FAIL ? -ENOMEM : 0;
+	table = kzalloc(sizeof(struct sg_table), GFP_KERNEL);
+	if (!table)
+		return -ENOMEM;
+	ret = sg_alloc_table(table, 1, GFP_KERNEL);
+	if (ret)
+		goto err_free;
+
+	paddr = ion_carveout_allocate(heap, size, align);
+	if (paddr == ION_CARVEOUT_ALLOCATE_FAIL) {
+		ret = -ENOMEM;
+		goto err_free_table;
+	}
+
+	sg_set_page(table->sgl, pfn_to_page(PFN_DOWN(paddr)), size, 0);
+	buffer->priv_virt = table;
+
+	return 0;
+
+err_free_table:
+	sg_free_table(table);
+err_free:
+	kfree(table);
+	return ret;
 }
 
 static void ion_carveout_heap_free(struct ion_buffer *buffer)
 {
 	struct ion_heap *heap = buffer->heap;
+	struct sg_table *table = buffer->priv_virt;
+	struct page *page = sg_page(table->sgl);
+	ion_phys_addr_t paddr = PFN_PHYS(page_to_pfn(page));
+
+	ion_heap_buffer_zero(buffer);
 
-	ion_carveout_free(heap, buffer->priv_phys, buffer->size);
-	buffer->priv_phys = ION_CARVEOUT_ALLOCATE_FAIL;
+	if (ion_buffer_cached(buffer))
+		dma_sync_sg_for_device(NULL, table->sgl, table->nents,
+							DMA_BIDIRECTIONAL);
+
+	ion_carveout_free(heap, paddr, buffer->size);
+	sg_free_table(table);
+	kfree(table);
 }
 
 static struct sg_table *ion_carveout_heap_map_dma(struct ion_heap *heap,
 						  struct ion_buffer *buffer)
 {
-	struct sg_table *table;
-	int ret;
-
-	table = kzalloc(sizeof(struct sg_table), GFP_KERNEL);
-	if (!table)
-		return ERR_PTR(-ENOMEM);
-	ret = sg_alloc_table(table, 1, GFP_KERNEL);
-	if (ret) {
-		kfree(table);
-		return ERR_PTR(ret);
-	}
-	sg_set_page(table->sgl, pfn_to_page(PFN_DOWN(buffer->priv_phys)),
-			buffer->size, 0);
-	return table;
+	return buffer->priv_virt;
 }
 
 static void ion_carveout_heap_unmap_dma(struct ion_heap *heap,
 					struct ion_buffer *buffer)
 {
-	sg_free_table(buffer->sg_table);
+	return;
 }
 
 static struct ion_heap_ops carveout_heap_ops = {
@@ -139,6 +165,7 @@ struct ion_heap *ion_carveout_heap_create(struct ion_platform_heap *heap_data)
 		     -1);
 	carveout_heap->heap.ops = &carveout_heap_ops;
 	carveout_heap->heap.type = ION_HEAP_TYPE_CARVEOUT;
+	carveout_heap->heap.flags = ION_HEAP_FLAG_DEFER_FREE;
 
 	return &carveout_heap->heap;
 }
-- 
1.8.3.2

