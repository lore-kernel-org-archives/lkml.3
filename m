Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab3LMWd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:33:57 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:38848 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab3LMW15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:27:57 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 070/115] gpu: ion: add CMA heap
Date: Fri, 13 Dec 2013 14:24:44 -0800
Message-Id: <1386973529-4884-71-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Gaignard <benjamin.gaignard@linaro.org>

New heap type ION_HEAP_TYPE_DMA where allocation is done with dma_alloc_coherent API.
device coherent_dma_mask must be set to DMA_BIT_MASK(32).
ion_platform_heap private field is used to retrieve the device linked to CMA,
if NULL the default CMA area is used.
ion_cma_get_sgtable is a copy of dma_common_get_sgtable function which should
be in kernel 3.5

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/Makefile       |   2 +-
 drivers/staging/android/ion/ion.h          |   7 +-
 drivers/staging/android/ion/ion_cma_heap.c | 233 +++++++++++++++++++++++++++++
 drivers/staging/android/ion/ion_heap.c     |   6 +
 drivers/staging/android/ion/ion_priv.h     |   3 +
 5 files changed, 249 insertions(+), 2 deletions(-)
 create mode 100644 drivers/staging/android/ion/ion_cma_heap.c

diff --git a/drivers/staging/android/ion/Makefile b/drivers/staging/android/ion/Makefile
index 306fff9..ce0f1ef 100644
--- a/drivers/staging/android/ion/Makefile
+++ b/drivers/staging/android/ion/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_ION) +=	ion.o ion_heap.o ion_page_pool.o ion_system_heap.o \
-			ion_carveout_heap.o ion_chunk_heap.o
+			ion_carveout_heap.o ion_chunk_heap.o ion_cma_heap.o
 obj-$(CONFIG_ION_TEGRA) += tegra/
diff --git a/drivers/staging/android/ion/ion.h b/drivers/staging/android/ion/ion.h
index 226bfd5..3942b3e 100644
--- a/drivers/staging/android/ion/ion.h
+++ b/drivers/staging/android/ion/ion.h
@@ -27,13 +27,17 @@ struct ion_handle;
  * @ION_HEAP_TYPE_CARVEOUT:	 memory allocated from a prereserved
  * 				 carveout heap, allocations are physically
  * 				 contiguous
- * @ION_HEAP_END:		 helper for iterating over heaps
+ * @ION_HEAP_TYPE_DMA:		 memory allocated via DMA API
+ * @ION_NUM_HEAPS:		 helper for iterating over heaps, a bit mask
+ * 				 is used to identify the heaps, so only 32
+ * 				 total heap types are supported
  */
 enum ion_heap_type {
 	ION_HEAP_TYPE_SYSTEM,
 	ION_HEAP_TYPE_SYSTEM_CONTIG,
 	ION_HEAP_TYPE_CARVEOUT,
 	ION_HEAP_TYPE_CHUNK,
+	ION_HEAP_TYPE_DMA,
 	ION_HEAP_TYPE_CUSTOM, /* must be last so device specific heaps always
 				 are at the end of this enum */
 	ION_NUM_HEAPS,
@@ -42,6 +46,7 @@ enum ion_heap_type {
 #define ION_HEAP_SYSTEM_MASK		(1 << ION_HEAP_TYPE_SYSTEM)
 #define ION_HEAP_SYSTEM_CONTIG_MASK	(1 << ION_HEAP_TYPE_SYSTEM_CONTIG)
 #define ION_HEAP_CARVEOUT_MASK		(1 << ION_HEAP_TYPE_CARVEOUT)
+#define ION_HEAP_TYPE_DMA_MASK		(1 << ION_HEAP_TYPE_DMA)
 
 #define ION_NUM_HEAP_IDS		sizeof(unsigned int) * 8
 
diff --git a/drivers/staging/android/ion/ion_cma_heap.c b/drivers/staging/android/ion/ion_cma_heap.c
new file mode 100644
index 0000000..74e3c77
--- /dev/null
+++ b/drivers/staging/android/ion/ion_cma_heap.c
@@ -0,0 +1,233 @@
+/*
+ * drivers/staging/android/ion/ion_cma_heap.c
+ *
+ * Copyright (C) Linaro 2012
+ * Author: <benjamin.gaignard@linaro.org> for ST-Ericsson.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/dma-mapping.h>
+
+#include "ion.h"
+#include "ion_priv.h"
+
+#define ION_CMA_ALLOCATE_FAILED -1
+
+struct ion_cma_heap {
+	struct ion_heap heap;
+	struct device *dev;
+};
+
+#define to_cma_heap(x) container_of(x, struct ion_cma_heap, heap)
+
+struct ion_cma_buffer_info {
+	void *cpu_addr;
+	dma_addr_t handle;
+	struct sg_table *table;
+};
+
+/*
+ * Create scatter-list for the already allocated DMA buffer.
+ * This function could be replaced by dma_common_get_sgtable
+ * as soon as it will avalaible.
+ */
+int ion_cma_get_sgtable(struct device *dev, struct sg_table *sgt,
+			void *cpu_addr, dma_addr_t handle, size_t size)
+{
+	struct page *page = virt_to_page(cpu_addr);
+	int ret;
+
+	ret = sg_alloc_table(sgt, 1, GFP_KERNEL);
+	if (unlikely(ret))
+		return ret;
+
+	sg_set_page(sgt->sgl, page, PAGE_ALIGN(size), 0);
+	return 0;
+}
+
+/*
+ * Create scatter-list for each page of the already allocated DMA buffer.
+ */
+int ion_cma_get_sgtable_per_page(struct device *dev, struct sg_table *sgt,
+			void *cpu_addr, dma_addr_t handle, size_t size)
+{
+	struct page *page = virt_to_page(cpu_addr);
+	int ret, i;
+	struct scatterlist *sg;
+
+	ret = sg_alloc_table(sgt, PAGE_ALIGN(size) / PAGE_SIZE, GFP_KERNEL);
+	if (unlikely(ret))
+		return ret;
+
+	sg = sgt->sgl;
+	for (i = 0; i < (PAGE_ALIGN(size) / PAGE_SIZE); i++) {
+		page = virt_to_page(cpu_addr + (i * PAGE_SIZE));
+		sg_set_page(sg, page, PAGE_SIZE, 0);
+		sg = sg_next(sg);
+	}
+	return 0;
+}
+
+/* ION CMA heap operations functions */
+static int ion_cma_allocate(struct ion_heap *heap, struct ion_buffer *buffer,
+			    unsigned long len, unsigned long align,
+			    unsigned long flags)
+{
+	struct ion_cma_heap *cma_heap = to_cma_heap(heap);
+	struct device *dev = cma_heap->dev;
+	struct ion_cma_buffer_info *info;
+
+	dev_dbg(dev, "Request buffer allocation len %ld\n", len);
+
+	info = kzalloc(sizeof(struct ion_cma_buffer_info), GFP_KERNEL);
+	if (!info) {
+		dev_err(dev, "Can't allocate buffer info\n");
+		return ION_CMA_ALLOCATE_FAILED;
+	}
+
+	info->cpu_addr = dma_alloc_coherent(dev, len, &(info->handle), 0);
+
+	if (!info->cpu_addr) {
+		dev_err(dev, "Fail to allocate buffer\n");
+		goto err;
+	}
+
+	info->table = kmalloc(sizeof(struct sg_table), GFP_KERNEL);
+	if (!info->table) {
+		dev_err(dev, "Fail to allocate sg table\n");
+		goto free_mem;
+	}
+
+	if (ion_buffer_fault_user_mappings(buffer)) {
+		if (ion_cma_get_sgtable_per_page
+			(dev, info->table, info->cpu_addr, info->handle, len))
+			goto free_table;
+	} else {
+		if (ion_cma_get_sgtable
+			(dev, info->table, info->cpu_addr, info->handle, len))
+			goto free_table;
+	}
+	/* keep this for memory release */
+	buffer->priv_virt = info;
+	dev_dbg(dev, "Allocate buffer %p\n", buffer);
+	return 0;
+
+free_table:
+	kfree(info->table);
+free_mem:
+	dma_free_coherent(dev, len, info->cpu_addr, info->handle);
+err:
+	kfree(info);
+	return ION_CMA_ALLOCATE_FAILED;
+}
+
+static void ion_cma_free(struct ion_buffer *buffer)
+{
+	struct ion_cma_heap *cma_heap = to_cma_heap(buffer->heap);
+	struct device *dev = cma_heap->dev;
+	struct ion_cma_buffer_info *info = buffer->priv_virt;
+
+	dev_dbg(dev, "Release buffer %p\n", buffer);
+	/* release memory */
+	dma_free_coherent(dev, buffer->size, info->cpu_addr, info->handle);
+	/* release sg table */
+	sg_free_table(info->table);
+	kfree(info->table);
+	kfree(info);
+}
+
+/* return physical address in addr */
+static int ion_cma_phys(struct ion_heap *heap, struct ion_buffer *buffer,
+			ion_phys_addr_t *addr, size_t *len)
+{
+	struct ion_cma_heap *cma_heap = to_cma_heap(buffer->heap);
+	struct device *dev = cma_heap->dev;
+	struct ion_cma_buffer_info *info = buffer->priv_virt;
+
+	dev_dbg(dev, "Return buffer %p physical address 0x%x\n", buffer,
+		info->handle);
+
+	*addr = info->handle;
+	*len = buffer->size;
+
+	return 0;
+}
+
+struct sg_table *ion_cma_heap_map_dma(struct ion_heap *heap,
+					 struct ion_buffer *buffer)
+{
+	struct ion_cma_buffer_info *info = buffer->priv_virt;
+
+	return info->table;
+}
+
+void ion_cma_heap_unmap_dma(struct ion_heap *heap,
+			       struct ion_buffer *buffer)
+{
+	return;
+}
+
+static int ion_cma_mmap(struct ion_heap *mapper, struct ion_buffer *buffer,
+			struct vm_area_struct *vma)
+{
+	struct ion_cma_heap *cma_heap = to_cma_heap(buffer->heap);
+	struct device *dev = cma_heap->dev;
+	struct ion_cma_buffer_info *info = buffer->priv_virt;
+
+	return dma_mmap_coherent(dev, vma, info->cpu_addr, info->handle,
+				 buffer->size);
+}
+
+void *ion_cma_map_kernel(struct ion_heap *heap, struct ion_buffer *buffer)
+{
+	struct ion_cma_buffer_info *info = buffer->priv_virt;
+	/* kernel memory mapping has been done at allocation time */
+	return info->cpu_addr;
+}
+
+static struct ion_heap_ops ion_cma_ops = {
+	.allocate = ion_cma_allocate,
+	.free = ion_cma_free,
+	.map_dma = ion_cma_heap_map_dma,
+	.unmap_dma = ion_cma_heap_unmap_dma,
+	.phys = ion_cma_phys,
+	.map_user = ion_cma_mmap,
+	.map_kernel = ion_cma_map_kernel,
+};
+
+struct ion_heap *ion_cma_heap_create(struct ion_platform_heap *data)
+{
+	struct ion_cma_heap *cma_heap;
+
+	cma_heap = kzalloc(sizeof(struct ion_cma_heap), GFP_KERNEL);
+
+	if (!cma_heap)
+		return ERR_PTR(-ENOMEM);
+
+	cma_heap->heap.ops = &ion_cma_ops;
+	/* get device from private heaps data, later it will be
+	 * used to make the link with reserved CMA memory */
+	cma_heap->dev = data->priv;
+	cma_heap->heap.type = ION_HEAP_TYPE_DMA;
+	return &cma_heap->heap;
+}
+
+void ion_cma_heap_destroy(struct ion_heap *heap)
+{
+	struct ion_cma_heap *cma_heap = to_cma_heap(heap);
+
+	kfree(cma_heap);
+}
diff --git a/drivers/staging/android/ion/ion_heap.c b/drivers/staging/android/ion/ion_heap.c
index f541bff..3fc1dcc 100644
--- a/drivers/staging/android/ion/ion_heap.c
+++ b/drivers/staging/android/ion/ion_heap.c
@@ -254,6 +254,9 @@ struct ion_heap *ion_heap_create(struct ion_platform_heap *heap_data)
 	case ION_HEAP_TYPE_CHUNK:
 		heap = ion_chunk_heap_create(heap_data);
 		break;
+	case ION_HEAP_TYPE_DMA:
+		heap = ion_cma_heap_create(heap_data);
+		break;
 	default:
 		pr_err("%s: Invalid heap type %d\n", __func__,
 		       heap_data->type);
@@ -290,6 +293,9 @@ void ion_heap_destroy(struct ion_heap *heap)
 	case ION_HEAP_TYPE_CHUNK:
 		ion_chunk_heap_destroy(heap);
 		break;
+	case ION_HEAP_TYPE_DMA:
+		ion_cma_heap_destroy(heap);
+		break;
 	default:
 		pr_err("%s: Invalid heap type %d\n", __func__,
 		       heap->type);
diff --git a/drivers/staging/android/ion/ion_priv.h b/drivers/staging/android/ion/ion_priv.h
index bdc1e34..f5a09b6 100644
--- a/drivers/staging/android/ion/ion_priv.h
+++ b/drivers/staging/android/ion/ion_priv.h
@@ -270,6 +270,9 @@ void ion_carveout_heap_destroy(struct ion_heap *);
 
 struct ion_heap *ion_chunk_heap_create(struct ion_platform_heap *);
 void ion_chunk_heap_destroy(struct ion_heap *);
+struct ion_heap *ion_cma_heap_create(struct ion_platform_heap *);
+void ion_cma_heap_destroy(struct ion_heap *);
+
 /**
  * kernel api to allocate/free from carveout -- used when carveout is
  * used to back an architecture specific custom heap
-- 
1.8.3.2

