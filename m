Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab3LMWij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:38:39 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:63214 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab3LMW1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:27:31 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 053/115] gpu: ion: Add chunk heap
Date: Fri, 13 Dec 2013 14:24:27 -0800
Message-Id: <1386973529-4884-54-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

This patch adds support for a chunk heap that allows for buffers that are
made up of a list of fixed size chunks taken from a carveout.  Chunk sizes
are configured when the heaps are created by passing the chunk size in the
priv field of the heap platform data.

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/Makefile         |   2 +-
 drivers/staging/android/ion/ion.h            |   5 +
 drivers/staging/android/ion/ion_chunk_heap.c | 174 +++++++++++++++++++++++++++
 drivers/staging/android/ion/ion_heap.c       |   6 +
 drivers/staging/android/ion/ion_priv.h       |   4 +-
 5 files changed, 189 insertions(+), 2 deletions(-)
 create mode 100644 drivers/staging/android/ion/ion_chunk_heap.c

diff --git a/drivers/staging/android/ion/Makefile b/drivers/staging/android/ion/Makefile
index d1ddebb..306fff9 100644
--- a/drivers/staging/android/ion/Makefile
+++ b/drivers/staging/android/ion/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_ION) +=	ion.o ion_heap.o ion_page_pool.o ion_system_heap.o \
-			ion_carveout_heap.o
+			ion_carveout_heap.o ion_chunk_heap.o
 obj-$(CONFIG_ION_TEGRA) += tegra/
diff --git a/drivers/staging/android/ion/ion.h b/drivers/staging/android/ion/ion.h
index 072d64d..e5f679f 100644
--- a/drivers/staging/android/ion/ion.h
+++ b/drivers/staging/android/ion/ion.h
@@ -33,6 +33,7 @@ enum ion_heap_type {
 	ION_HEAP_TYPE_SYSTEM,
 	ION_HEAP_TYPE_SYSTEM_CONTIG,
 	ION_HEAP_TYPE_CARVEOUT,
+	ION_HEAP_TYPE_CHUNK,
 	ION_HEAP_TYPE_CUSTOM, /* must be last so device specific heaps always
 				 are at the end of this enum */
 	ION_NUM_HEAPS,
@@ -75,6 +76,8 @@ struct ion_buffer;
  * @name:	used for debug purposes
  * @base:	base address of heap in physical memory if applicable
  * @size:	size of the heap in bytes if applicable
+ * @align:	required alignment in physical memory if applicable
+ * @priv:	private info passed from the board file
  *
  * Provided by the board file.
  */
@@ -84,6 +87,8 @@ struct ion_platform_heap {
 	const char *name;
 	ion_phys_addr_t base;
 	size_t size;
+	ion_phys_addr_t align;
+	void *priv;
 };
 
 /**
diff --git a/drivers/staging/android/ion/ion_chunk_heap.c b/drivers/staging/android/ion/ion_chunk_heap.c
new file mode 100644
index 0000000..1d47409
--- /dev/null
+++ b/drivers/staging/android/ion/ion_chunk_heap.c
@@ -0,0 +1,174 @@
+/*
+ * drivers/staging/android/ion/ion_chunk_heap.c
+ *
+ * Copyright (C) 2012 Google, Inc.
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
+//#include <linux/spinlock.h>
+#include <linux/dma-mapping.h>
+#include <linux/err.h>
+#include <linux/genalloc.h>
+#include <linux/io.h>
+#include <linux/mm.h>
+#include <linux/scatterlist.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include "ion.h"
+#include "ion_priv.h"
+
+#include <asm/mach/map.h>
+
+struct ion_chunk_heap {
+	struct ion_heap heap;
+	struct gen_pool *pool;
+	ion_phys_addr_t base;
+	unsigned long chunk_size;
+	unsigned long size;
+	unsigned long allocated;
+};
+
+static int ion_chunk_heap_allocate(struct ion_heap *heap,
+				      struct ion_buffer *buffer,
+				      unsigned long size, unsigned long align,
+				      unsigned long flags)
+{
+	struct ion_chunk_heap *chunk_heap =
+		container_of(heap, struct ion_chunk_heap, heap);
+	struct sg_table *table;
+	struct scatterlist *sg;
+	int ret, i;
+	unsigned long num_chunks;
+
+	if (ion_buffer_fault_user_mappings(buffer))
+		return -ENOMEM;
+
+	num_chunks = ALIGN(size, chunk_heap->chunk_size) /
+		chunk_heap->chunk_size;
+	buffer->size = num_chunks * chunk_heap->chunk_size;
+
+	if (buffer->size > chunk_heap->size - chunk_heap->allocated)
+		return -ENOMEM;
+
+	table = kzalloc(sizeof(struct sg_table), GFP_KERNEL);
+	if (!table)
+		return -ENOMEM;
+	ret = sg_alloc_table(table, num_chunks, GFP_KERNEL);
+	if (ret) {
+		kfree(table);
+		return ret;
+	}
+
+	sg = table->sgl;
+	for (i = 0; i < num_chunks; i++) {
+		unsigned long paddr = gen_pool_alloc(chunk_heap->pool,
+						     chunk_heap->chunk_size);
+		if (!paddr)
+			goto err;
+		sg_set_page(sg, phys_to_page(paddr), chunk_heap->chunk_size, 0);
+		sg = sg_next(sg);
+	}
+
+	buffer->priv_virt = table;
+	chunk_heap->allocated += buffer->size;
+	return 0;
+err:
+	sg = table->sgl;
+	for (i -= 1; i >= 0; i--) {
+		gen_pool_free(chunk_heap->pool, page_to_phys(sg_page(sg)),
+			      sg_dma_len(sg));
+		sg = sg_next(sg);
+	}
+	sg_free_table(table);
+	kfree(table);
+	return -ENOMEM;
+}
+
+static void ion_chunk_heap_free(struct ion_buffer *buffer)
+{
+	struct ion_heap *heap = buffer->heap;
+	struct ion_chunk_heap *chunk_heap =
+		container_of(heap, struct ion_chunk_heap, heap);
+	struct sg_table *table = buffer->priv_virt;
+	struct scatterlist *sg;
+	int i;
+
+	for_each_sg(table->sgl, sg, table->nents, i) {
+		__dma_page_cpu_to_dev(sg_page(sg), 0, sg_dma_len(sg),
+				      DMA_BIDIRECTIONAL);
+		gen_pool_free(chunk_heap->pool, page_to_phys(sg_page(sg)),
+			      sg_dma_len(sg));
+	}
+	chunk_heap->allocated -= buffer->size;
+	sg_free_table(table);
+	kfree(table);
+}
+
+struct sg_table *ion_chunk_heap_map_dma(struct ion_heap *heap,
+					 struct ion_buffer *buffer)
+{
+	return buffer->priv_virt;
+}
+
+void ion_chunk_heap_unmap_dma(struct ion_heap *heap,
+			       struct ion_buffer *buffer)
+{
+	return;
+}
+
+static struct ion_heap_ops chunk_heap_ops = {
+	.allocate = ion_chunk_heap_allocate,
+	.free = ion_chunk_heap_free,
+	.map_dma = ion_chunk_heap_map_dma,
+	.unmap_dma = ion_chunk_heap_unmap_dma,
+	.map_user = ion_heap_map_user,
+	.map_kernel = ion_heap_map_kernel,
+	.unmap_kernel = ion_heap_unmap_kernel,
+};
+
+struct ion_heap *ion_chunk_heap_create(struct ion_platform_heap *heap_data)
+{
+	struct ion_chunk_heap *chunk_heap;
+
+	chunk_heap = kzalloc(sizeof(struct ion_chunk_heap), GFP_KERNEL);
+	if (!chunk_heap)
+		return ERR_PTR(-ENOMEM);
+
+	chunk_heap->chunk_size = (unsigned long)heap_data->priv;
+	chunk_heap->pool = gen_pool_create(get_order(chunk_heap->chunk_size) +
+					   PAGE_SHIFT, -1);
+	if (!chunk_heap->pool) {
+		kfree(chunk_heap);
+		return ERR_PTR(-ENOMEM);
+	}
+	chunk_heap->base = heap_data->base;
+	chunk_heap->size = heap_data->size;
+	chunk_heap->allocated = 0;
+	__dma_page_cpu_to_dev(phys_to_page(heap_data->base), 0, heap_data->size,
+			      DMA_BIDIRECTIONAL);
+	gen_pool_add(chunk_heap->pool, chunk_heap->base, heap_data->size, -1);
+	chunk_heap->heap.ops = &chunk_heap_ops;
+	chunk_heap->heap.type = ION_HEAP_TYPE_CHUNK;
+	pr_info("%s: base %lu size %ld align %ld\n", __func__, chunk_heap->base,
+		heap_data->size, heap_data->align);
+
+	return &chunk_heap->heap;
+}
+
+void ion_chunk_heap_destroy(struct ion_heap *heap)
+{
+	struct ion_chunk_heap *chunk_heap =
+	     container_of(heap, struct  ion_chunk_heap, heap);
+
+	gen_pool_destroy(chunk_heap->pool);
+	kfree(chunk_heap);
+	chunk_heap = NULL;
+}
diff --git a/drivers/staging/android/ion/ion_heap.c b/drivers/staging/android/ion/ion_heap.c
index 441e9ef..a9bf52e 100644
--- a/drivers/staging/android/ion/ion_heap.c
+++ b/drivers/staging/android/ion/ion_heap.c
@@ -107,6 +107,9 @@ struct ion_heap *ion_heap_create(struct ion_platform_heap *heap_data)
 	case ION_HEAP_TYPE_CARVEOUT:
 		heap = ion_carveout_heap_create(heap_data);
 		break;
+	case ION_HEAP_TYPE_CHUNK:
+		heap = ion_chunk_heap_create(heap_data);
+		break;
 	default:
 		pr_err("%s: Invalid heap type %d\n", __func__,
 		       heap_data->type);
@@ -140,6 +143,9 @@ void ion_heap_destroy(struct ion_heap *heap)
 	case ION_HEAP_TYPE_CARVEOUT:
 		ion_carveout_heap_destroy(heap);
 		break;
+	case ION_HEAP_TYPE_CHUNK:
+		ion_chunk_heap_destroy(heap);
+		break;
 	default:
 		pr_err("%s: Invalid heap type %d\n", __func__,
 		       heap->type);
diff --git a/drivers/staging/android/ion/ion_priv.h b/drivers/staging/android/ion/ion_priv.h
index 6b3616e..eef4de8 100644
--- a/drivers/staging/android/ion/ion_priv.h
+++ b/drivers/staging/android/ion/ion_priv.h
@@ -195,7 +195,6 @@ int ion_heap_map_user(struct ion_heap *, struct ion_buffer *,
 
 struct ion_heap *ion_heap_create(struct ion_platform_heap *);
 void ion_heap_destroy(struct ion_heap *);
-
 struct ion_heap *ion_system_heap_create(struct ion_platform_heap *);
 void ion_system_heap_destroy(struct ion_heap *);
 
@@ -204,6 +203,9 @@ void ion_system_contig_heap_destroy(struct ion_heap *);
 
 struct ion_heap *ion_carveout_heap_create(struct ion_platform_heap *);
 void ion_carveout_heap_destroy(struct ion_heap *);
+
+struct ion_heap *ion_chunk_heap_create(struct ion_platform_heap *);
+void ion_chunk_heap_destroy(struct ion_heap *);
 /**
  * kernel api to allocate/free from carveout -- used when carveout is
  * used to back an architecture specific custom heap
-- 
1.8.3.2

