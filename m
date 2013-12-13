Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab3LMWi5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:38:57 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:37381 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab3LMW13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:27:29 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 052/115] gpu: ion: Refactor common mapping functions out of system heap
Date: Fri, 13 Dec 2013 14:24:26 -0800
Message-Id: <1386973529-4884-53-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

The system heap contained several general purpose functions to map
buffers to the kernel and userspace.  This patch refactors those
into ion_heap.c so they can be used by other heaps.

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_heap.c        | 75 ++++++++++++++++++++++++
 drivers/staging/android/ion/ion_priv.h        | 10 ++++
 drivers/staging/android/ion/ion_system_heap.c | 84 ++-------------------------
 3 files changed, 91 insertions(+), 78 deletions(-)

diff --git a/drivers/staging/android/ion/ion_heap.c b/drivers/staging/android/ion/ion_heap.c
index 4f7caa8..441e9ef 100644
--- a/drivers/staging/android/ion/ion_heap.c
+++ b/drivers/staging/android/ion/ion_heap.c
@@ -15,9 +15,84 @@
  */
 
 #include <linux/err.h>
+#include <linux/mm.h>
+#include <linux/scatterlist.h>
+#include <linux/vmalloc.h>
 #include "ion.h"
 #include "ion_priv.h"
 
+void *ion_heap_map_kernel(struct ion_heap *heap,
+			  struct ion_buffer *buffer)
+{
+	struct scatterlist *sg;
+	int i, j;
+	void *vaddr;
+	pgprot_t pgprot;
+	struct sg_table *table = buffer->sg_table;
+	int npages = PAGE_ALIGN(buffer->size) / PAGE_SIZE;
+	struct page **pages = vmalloc(sizeof(struct page *) * npages);
+	struct page **tmp = pages;
+
+	if (!pages)
+		return 0;
+
+	if (buffer->flags & ION_FLAG_CACHED)
+		pgprot = PAGE_KERNEL;
+	else
+		pgprot = pgprot_writecombine(PAGE_KERNEL);
+
+	for_each_sg(table->sgl, sg, table->nents, i) {
+		int npages_this_entry = PAGE_ALIGN(sg_dma_len(sg)) / PAGE_SIZE;
+		struct page *page = sg_page(sg);
+		BUG_ON(i >= npages);
+		for (j = 0; j < npages_this_entry; j++) {
+			*(tmp++) = page++;
+		}
+	}
+	vaddr = vmap(pages, npages, VM_MAP, pgprot);
+	vfree(pages);
+
+	return vaddr;
+}
+
+void ion_heap_unmap_kernel(struct ion_heap *heap,
+			   struct ion_buffer *buffer)
+{
+	vunmap(buffer->vaddr);
+}
+
+int ion_heap_map_user(struct ion_heap *heap, struct ion_buffer *buffer,
+		      struct vm_area_struct *vma)
+{
+	struct sg_table *table = buffer->sg_table;
+	unsigned long addr = vma->vm_start;
+	unsigned long offset = vma->vm_pgoff * PAGE_SIZE;
+	struct scatterlist *sg;
+	int i;
+
+	for_each_sg(table->sgl, sg, table->nents, i) {
+		struct page *page = sg_page(sg);
+		unsigned long remainder = vma->vm_end - addr;
+		unsigned long len = sg_dma_len(sg);
+
+		if (offset >= sg_dma_len(sg)) {
+			offset -= sg_dma_len(sg);
+			continue;
+		} else if (offset) {
+			page += offset / PAGE_SIZE;
+			len = sg_dma_len(sg) - offset;
+			offset = 0;
+		}
+		len = min(len, remainder);
+		remap_pfn_range(vma, addr, page_to_pfn(page), len,
+				vma->vm_page_prot);
+		addr += len;
+		if (addr >= vma->vm_end)
+			return 0;
+	}
+	return 0;
+}
+
 struct ion_heap *ion_heap_create(struct ion_platform_heap *heap_data)
 {
 	struct ion_heap *heap = NULL;
diff --git a/drivers/staging/android/ion/ion_priv.h b/drivers/staging/android/ion/ion_priv.h
index 57dbf6a..6b3616e 100644
--- a/drivers/staging/android/ion/ion_priv.h
+++ b/drivers/staging/android/ion/ion_priv.h
@@ -178,6 +178,16 @@ void ion_device_destroy(struct ion_device *dev);
 void ion_device_add_heap(struct ion_device *dev, struct ion_heap *heap);
 
 /**
+ * some helpers for common operations on buffers using the sg_table
+ * and vaddr fields
+ */
+void *ion_heap_map_kernel(struct ion_heap *, struct ion_buffer *);
+void ion_heap_unmap_kernel(struct ion_heap *, struct ion_buffer *);
+int ion_heap_map_user(struct ion_heap *, struct ion_buffer *,
+			struct vm_area_struct *);
+
+
+/**
  * functions for creating and destroying the built in ion heaps.
  * architectures can add their own custom architecture specific
  * heaps as appropriate.
diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 9327a32..89247cf 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -224,7 +224,7 @@ void ion_system_heap_free(struct ion_buffer *buffer)
 	struct ion_system_heap *sys_heap = container_of(heap,
 							struct ion_system_heap,
 							heap);
-	struct sg_table *table = buffer->priv_virt;
+	struct sg_table *table = buffer->sg_table;
 	struct scatterlist *sg;
 	LIST_HEAD(pages);
 	int i;
@@ -247,86 +247,14 @@ void ion_system_heap_unmap_dma(struct ion_heap *heap,
 	return;
 }
 
-void *ion_system_heap_map_kernel(struct ion_heap *heap,
-				 struct ion_buffer *buffer)
-{
-	struct scatterlist *sg;
-	int i, j;
-	void *vaddr;
-	pgprot_t pgprot;
-	struct sg_table *table = buffer->priv_virt;
-	int npages = PAGE_ALIGN(buffer->size) / PAGE_SIZE;
-	struct page **pages = vmalloc(sizeof(struct page *) * npages);
-	struct page **tmp = pages;
-
-	if (!pages)
-		return 0;
-
-	if (buffer->flags & ION_FLAG_CACHED)
-		pgprot = PAGE_KERNEL;
-	else
-		pgprot = pgprot_writecombine(PAGE_KERNEL);
-
-	for_each_sg(table->sgl, sg, table->nents, i) {
-		int npages_this_entry = PAGE_ALIGN(sg_dma_len(sg)) / PAGE_SIZE;
-		struct page *page = sg_page(sg);
-		BUG_ON(i >= npages);
-		for (j = 0; j < npages_this_entry; j++) {
-			*(tmp++) = page++;
-		}
-	}
-	vaddr = vmap(pages, npages, VM_MAP, pgprot);
-	vfree(pages);
-
-	return vaddr;
-}
-
-void ion_system_heap_unmap_kernel(struct ion_heap *heap,
-				  struct ion_buffer *buffer)
-{
-	vunmap(buffer->vaddr);
-}
-
-int ion_system_heap_map_user(struct ion_heap *heap, struct ion_buffer *buffer,
-			     struct vm_area_struct *vma)
-{
-	struct sg_table *table = buffer->priv_virt;
-	unsigned long addr = vma->vm_start;
-	unsigned long offset = vma->vm_pgoff * PAGE_SIZE;
-	struct scatterlist *sg;
-	int i;
-
-	for_each_sg(table->sgl, sg, table->nents, i) {
-		struct page *page = sg_page(sg);
-		unsigned long remainder = vma->vm_end - addr;
-		unsigned long len = sg_dma_len(sg);
-
-		if (offset >= sg_dma_len(sg)) {
-			offset -= sg_dma_len(sg);
-			continue;
-		} else if (offset) {
-			page += offset / PAGE_SIZE;
-			len = sg_dma_len(sg) - offset;
-			offset = 0;
-		}
-		len = min(len, remainder);
-		remap_pfn_range(vma, addr, page_to_pfn(page), len,
-				vma->vm_page_prot);
-		addr += len;
-		if (addr >= vma->vm_end)
-			return 0;
-	}
-	return 0;
-}
-
 static struct ion_heap_ops system_heap_ops = {
 	.allocate = ion_system_heap_allocate,
 	.free = ion_system_heap_free,
 	.map_dma = ion_system_heap_map_dma,
 	.unmap_dma = ion_system_heap_unmap_dma,
-	.map_kernel = ion_system_heap_map_kernel,
-	.unmap_kernel = ion_system_heap_unmap_kernel,
-	.map_user = ion_system_heap_map_user,
+	.map_kernel = ion_heap_map_kernel,
+	.unmap_kernel = ion_heap_unmap_kernel,
+	.map_user = ion_heap_map_user,
 };
 
 static int ion_system_heap_debug_show(struct ion_heap *heap, struct seq_file *s,
@@ -468,8 +396,8 @@ static struct ion_heap_ops kmalloc_ops = {
 	.phys = ion_system_contig_heap_phys,
 	.map_dma = ion_system_contig_heap_map_dma,
 	.unmap_dma = ion_system_contig_heap_unmap_dma,
-	.map_kernel = ion_system_heap_map_kernel,
-	.unmap_kernel = ion_system_heap_unmap_kernel,
+	.map_kernel = ion_heap_map_kernel,
+	.unmap_kernel = ion_heap_unmap_kernel,
 	.map_user = ion_system_contig_heap_map_user,
 };
 
-- 
1.8.3.2

