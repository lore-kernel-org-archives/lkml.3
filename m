Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab3LND1z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 22:27:55 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:36642 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab3LND1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 22:27:10 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 108/115] ion: fix sparse warnings
Date: Fri, 13 Dec 2013 19:26:28 -0800
Message-Id: <1386991595-6251-16-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
 <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

Fix sparse warnings in ion.

Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c               |  8 +++----
 drivers/staging/android/ion/ion_carveout_heap.c |  8 +++----
 drivers/staging/android/ion/ion_chunk_heap.c    |  8 +++----
 drivers/staging/android/ion/ion_cma_heap.c      | 15 +++++++------
 drivers/staging/android/ion/ion_heap.c          |  4 ++--
 drivers/staging/android/ion/ion_page_pool.c     |  2 +-
 drivers/staging/android/ion/ion_system_heap.c   | 30 ++++++++++++-------------
 7 files changed, 37 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 45127f5..559e4ee 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -669,7 +669,7 @@ static int ion_debug_client_show(struct seq_file *s, void *unused)
 	struct ion_client *client = s->private;
 	struct rb_node *n;
 	size_t sizes[ION_NUM_HEAP_IDS] = {0};
-	const char *names[ION_NUM_HEAP_IDS] = {0};
+	const char *names[ION_NUM_HEAP_IDS] = {NULL};
 	int i;
 
 	mutex_lock(&client->lock);
@@ -887,7 +887,7 @@ static void ion_buffer_sync_for_device(struct ion_buffer *buffer,
 	mutex_unlock(&buffer->lock);
 }
 
-int ion_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int ion_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct ion_buffer *buffer = vma->vm_private_data;
 	unsigned long pfn;
@@ -939,7 +939,7 @@ static void ion_vm_close(struct vm_area_struct *vma)
 	mutex_unlock(&buffer->lock);
 }
 
-struct vm_operations_struct ion_vma_ops = {
+static struct vm_operations_struct ion_vma_ops = {
 	.open = ion_vm_open,
 	.close = ion_vm_close,
 	.fault = ion_vm_fault,
@@ -1030,7 +1030,7 @@ static void ion_dma_buf_end_cpu_access(struct dma_buf *dmabuf, size_t start,
 	mutex_unlock(&buffer->lock);
 }
 
-struct dma_buf_ops dma_buf_ops = {
+static struct dma_buf_ops dma_buf_ops = {
 	.map_dma_buf = ion_map_dma_buf,
 	.unmap_dma_buf = ion_unmap_dma_buf,
 	.mmap = ion_mmap,
diff --git a/drivers/staging/android/ion/ion_carveout_heap.c b/drivers/staging/android/ion/ion_carveout_heap.c
index b0b08c3..9bf20a3 100644
--- a/drivers/staging/android/ion/ion_carveout_heap.c
+++ b/drivers/staging/android/ion/ion_carveout_heap.c
@@ -85,8 +85,8 @@ static void ion_carveout_heap_free(struct ion_buffer *buffer)
 	buffer->priv_phys = ION_CARVEOUT_ALLOCATE_FAIL;
 }
 
-struct sg_table *ion_carveout_heap_map_dma(struct ion_heap *heap,
-					      struct ion_buffer *buffer)
+static struct sg_table *ion_carveout_heap_map_dma(struct ion_heap *heap,
+						  struct ion_buffer *buffer)
 {
 	struct sg_table *table;
 	int ret;
@@ -104,8 +104,8 @@ struct sg_table *ion_carveout_heap_map_dma(struct ion_heap *heap,
 	return table;
 }
 
-void ion_carveout_heap_unmap_dma(struct ion_heap *heap,
-				 struct ion_buffer *buffer)
+static void ion_carveout_heap_unmap_dma(struct ion_heap *heap,
+					struct ion_buffer *buffer)
 {
 	sg_free_table(buffer->sg_table);
 }
diff --git a/drivers/staging/android/ion/ion_chunk_heap.c b/drivers/staging/android/ion/ion_chunk_heap.c
index 34d1d18..46e8a3b 100644
--- a/drivers/staging/android/ion/ion_chunk_heap.c
+++ b/drivers/staging/android/ion/ion_chunk_heap.c
@@ -115,14 +115,14 @@ static void ion_chunk_heap_free(struct ion_buffer *buffer)
 	kfree(table);
 }
 
-struct sg_table *ion_chunk_heap_map_dma(struct ion_heap *heap,
-					 struct ion_buffer *buffer)
+static struct sg_table *ion_chunk_heap_map_dma(struct ion_heap *heap,
+					       struct ion_buffer *buffer)
 {
 	return buffer->priv_virt;
 }
 
-void ion_chunk_heap_unmap_dma(struct ion_heap *heap,
-			       struct ion_buffer *buffer)
+static void ion_chunk_heap_unmap_dma(struct ion_heap *heap,
+				     struct ion_buffer *buffer)
 {
 	return;
 }
diff --git a/drivers/staging/android/ion/ion_cma_heap.c b/drivers/staging/android/ion/ion_cma_heap.c
index 1e308a0..3dcf9b4 100644
--- a/drivers/staging/android/ion/ion_cma_heap.c
+++ b/drivers/staging/android/ion/ion_cma_heap.c
@@ -44,8 +44,8 @@ struct ion_cma_buffer_info {
  * This function could be replaced by dma_common_get_sgtable
  * as soon as it will avalaible.
  */
-int ion_cma_get_sgtable(struct device *dev, struct sg_table *sgt,
-			void *cpu_addr, dma_addr_t handle, size_t size)
+static int ion_cma_get_sgtable(struct device *dev, struct sg_table *sgt,
+			       void *cpu_addr, dma_addr_t handle, size_t size)
 {
 	struct page *page = virt_to_page(cpu_addr);
 	int ret;
@@ -137,16 +137,16 @@ static int ion_cma_phys(struct ion_heap *heap, struct ion_buffer *buffer,
 	return 0;
 }
 
-struct sg_table *ion_cma_heap_map_dma(struct ion_heap *heap,
-					 struct ion_buffer *buffer)
+static struct sg_table *ion_cma_heap_map_dma(struct ion_heap *heap,
+					     struct ion_buffer *buffer)
 {
 	struct ion_cma_buffer_info *info = buffer->priv_virt;
 
 	return info->table;
 }
 
-void ion_cma_heap_unmap_dma(struct ion_heap *heap,
-			       struct ion_buffer *buffer)
+static void ion_cma_heap_unmap_dma(struct ion_heap *heap,
+				   struct ion_buffer *buffer)
 {
 	return;
 }
@@ -162,7 +162,8 @@ static int ion_cma_mmap(struct ion_heap *mapper, struct ion_buffer *buffer,
 				 buffer->size);
 }
 
-void *ion_cma_map_kernel(struct ion_heap *heap, struct ion_buffer *buffer)
+static void *ion_cma_map_kernel(struct ion_heap *heap,
+				struct ion_buffer *buffer)
 {
 	struct ion_cma_buffer_info *info = buffer->priv_virt;
 	/* kernel memory mapping has been done at allocation time */
diff --git a/drivers/staging/android/ion/ion_heap.c b/drivers/staging/android/ion/ion_heap.c
index 8054611..c3a213b 100644
--- a/drivers/staging/android/ion/ion_heap.c
+++ b/drivers/staging/android/ion/ion_heap.c
@@ -38,7 +38,7 @@ void *ion_heap_map_kernel(struct ion_heap *heap,
 	struct page **tmp = pages;
 
 	if (!pages)
-		return 0;
+		return NULL;
 
 	if (buffer->flags & ION_FLAG_CACHED)
 		pgprot = PAGE_KERNEL;
@@ -193,7 +193,7 @@ size_t ion_heap_freelist_drain(struct ion_heap *heap, size_t size)
 	return total_drained;
 }
 
-int ion_heap_deferred_free(void *data)
+static int ion_heap_deferred_free(void *data)
 {
 	struct ion_heap *heap = data;
 
diff --git a/drivers/staging/android/ion/ion_page_pool.c b/drivers/staging/android/ion/ion_page_pool.c
index 0ad0263..a1c51a8 100644
--- a/drivers/staging/android/ion/ion_page_pool.c
+++ b/drivers/staging/android/ion/ion_page_pool.c
@@ -134,7 +134,7 @@ int ion_page_pool_shrink(struct ion_page_pool *pool, gfp_t gfp_mask,
 	int i;
 	bool high;
 
-	high = gfp_mask & __GFP_HIGHMEM;
+	high = !!(gfp_mask & __GFP_HIGHMEM);
 
 	if (nr_to_scan == 0)
 		return ion_page_pool_total(pool, high);
diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 841511d..301d019 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -26,11 +26,9 @@
 #include "ion.h"
 #include "ion_priv.h"
 
-static unsigned int high_order_gfp_flags = (GFP_HIGHUSER | __GFP_ZERO |
-					    __GFP_NOWARN | __GFP_NORETRY) &
-					   ~__GFP_WAIT;
-static unsigned int low_order_gfp_flags  = (GFP_HIGHUSER | __GFP_ZERO |
-					 __GFP_NOWARN);
+static gfp_t high_order_gfp_flags = (GFP_HIGHUSER | __GFP_ZERO | __GFP_NOWARN |
+				     __GFP_NORETRY) & ~__GFP_WAIT;
+static gfp_t low_order_gfp_flags  = (GFP_HIGHUSER | __GFP_ZERO | __GFP_NOWARN);
 static const unsigned int orders[] = {8, 4, 0};
 static const int num_orders = ARRAY_SIZE(orders);
 static int order_to_index(unsigned int order)
@@ -76,12 +74,12 @@ static struct page *alloc_buffer_page(struct ion_system_heap *heap,
 			gfp_flags = high_order_gfp_flags;
 		page = alloc_pages(gfp_flags, order);
 		if (!page)
-			return 0;
+			return NULL;
 		ion_pages_sync_for_device(NULL, page, PAGE_SIZE << order,
 						DMA_BIDIRECTIONAL);
 	}
 	if (!page)
-		return 0;
+		return NULL;
 
 	return page;
 }
@@ -187,7 +185,7 @@ err:
 	return -ENOMEM;
 }
 
-void ion_system_heap_free(struct ion_buffer *buffer)
+static void ion_system_heap_free(struct ion_buffer *buffer)
 {
 	struct ion_heap *heap = buffer->heap;
 	struct ion_system_heap *sys_heap = container_of(heap,
@@ -211,14 +209,14 @@ void ion_system_heap_free(struct ion_buffer *buffer)
 	kfree(table);
 }
 
-struct sg_table *ion_system_heap_map_dma(struct ion_heap *heap,
-					 struct ion_buffer *buffer)
+static struct sg_table *ion_system_heap_map_dma(struct ion_heap *heap,
+						struct ion_buffer *buffer)
 {
 	return buffer->priv_virt;
 }
 
-void ion_system_heap_unmap_dma(struct ion_heap *heap,
-			       struct ion_buffer *buffer)
+static void ion_system_heap_unmap_dma(struct ion_heap *heap,
+				      struct ion_buffer *buffer)
 {
 	return;
 }
@@ -403,7 +401,7 @@ out:
 	return ret;
 }
 
-void ion_system_contig_heap_free(struct ion_buffer *buffer)
+static void ion_system_contig_heap_free(struct ion_buffer *buffer)
 {
 	struct sg_table *table = buffer->priv_virt;
 	struct page *page = sg_page(table->sgl);
@@ -427,14 +425,14 @@ static int ion_system_contig_heap_phys(struct ion_heap *heap,
 	return 0;
 }
 
-struct sg_table *ion_system_contig_heap_map_dma(struct ion_heap *heap,
+static struct sg_table *ion_system_contig_heap_map_dma(struct ion_heap *heap,
 						struct ion_buffer *buffer)
 {
 	return buffer->priv_virt;
 }
 
-void ion_system_contig_heap_unmap_dma(struct ion_heap *heap,
-				      struct ion_buffer *buffer)
+static void ion_system_contig_heap_unmap_dma(struct ion_heap *heap,
+					     struct ion_buffer *buffer)
 {
 }
 
-- 
1.8.3.2

