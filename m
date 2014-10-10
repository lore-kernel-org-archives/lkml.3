Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbaJJUJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 16:09:08 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:52998 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196AbaJJUJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 16:09:04 -0400
From: Sumit Semwal <sumit.semwal@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linaro-kernel@lists.linaro.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [RFC 4/4] cenalloc: a sample allocator for contiguous page allocation
Date: Sat, 11 Oct 2014 01:37:58 +0530
Message-Id: <1412971678-4457-5-git-send-email-sumit.semwal@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412971678-4457-1-git-send-email-sumit.semwal@linaro.org>
References: <1412971678-4457-1-git-send-email-sumit.semwal@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Gaignard <benjamin.gaignard@linaro.org>

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org
---
 drivers/cenalloc/Makefile                 |   2 +-
 drivers/cenalloc/cenalloc_system_contig.c | 225 ++++++++++++++++++++++++++++++
 2 files changed, 226 insertions(+), 1 deletion(-)
 create mode 100644 drivers/cenalloc/cenalloc_system_contig.c

diff --git a/drivers/cenalloc/Makefile b/drivers/cenalloc/Makefile
index d36b531..2f69b61 100644
--- a/drivers/cenalloc/Makefile
+++ b/drivers/cenalloc/Makefile
@@ -1,3 +1,3 @@
 # Makefile for the cenalloc helper
 
-obj-y				+= cenalloc.o
+obj-y				+= cenalloc.o cenalloc_system_contig.o
diff --git a/drivers/cenalloc/cenalloc_system_contig.c b/drivers/cenalloc/cenalloc_system_contig.c
new file mode 100644
index 0000000..ecf0c03
--- /dev/null
+++ b/drivers/cenalloc/cenalloc_system_contig.c
@@ -0,0 +1,225 @@
+/*
+ * central allocator using kmalloc
+ *
+ * Copyright(C) 2014 Linaro Limited. All rights reserved.
+ * Author: Benjamin Gaignard <benjamin.gaignard@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <asm/page.h>
+#include <linux/dma-mapping.h>
+#include <linux/err.h>
+#include <linux/highmem.h>
+#include <linux/mm.h>
+#include <linux/scatterlist.h>
+#include <linux/seq_file.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+
+#include "cenalloc_priv.h"
+
+static gfp_t low_order_gfp_flags  = (GFP_HIGHUSER | __GFP_ZERO | __GFP_NOWARN);
+
+void cenalloc_pages_sync_for_device(struct device *dev, struct page *page,
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
+static int cenalloc_system_contig_allocate(struct cenalloc_allocator *allocator,
+			struct cenalloc_buffer *buffer, unsigned long len,
+			unsigned long align, unsigned long flags)
+{
+	int order = get_order(len);
+		struct page *page;
+	struct sg_table *table;
+	unsigned long i;
+	int ret;
+
+	if (align > (PAGE_SIZE << order))
+		return -EINVAL;
+
+	page = alloc_pages(low_order_gfp_flags, order);
+	if (!page)
+		return -ENOMEM;
+
+	split_page(page, order);
+
+	len = PAGE_ALIGN(len);
+	for (i = len >> PAGE_SHIFT; i < (1 << order); i++)
+		__free_page(page + i);
+
+	table = kmalloc(sizeof(struct sg_table), GFP_KERNEL);
+	if (!table) {
+		ret = -ENOMEM;
+		goto free_pages;
+	}
+
+	ret = sg_alloc_table(table, 1, GFP_KERNEL);
+	if (ret)
+		goto free_table;
+
+	sg_set_page(table->sgl, page, len, 0);
+
+	buffer->sg_table = table;
+
+	cenalloc_pages_sync_for_device(NULL, page, len, DMA_BIDIRECTIONAL);
+
+	return 0;
+
+free_table:
+	kfree(table);
+free_pages:
+	for (i = 0; i < len >> PAGE_SHIFT; i++)
+		__free_page(page + i);
+
+	return ret;
+
+}
+
+static void cenalloc_system_contig_free(struct cenalloc_buffer *buffer)
+{
+	struct sg_table *table = buffer->sg_table;
+	struct page *page = sg_page(table->sgl);
+	unsigned long pages = PAGE_ALIGN(buffer->size) >> PAGE_SHIFT;
+	unsigned long i;
+
+	for (i = 0; i < pages; i++)
+		__free_page(page + i);
+	sg_free_table(table);
+	kfree(table);
+}
+
+static struct sg_table *cenalloc_system_contig_map_dma
+	(struct cenalloc_allocator *allocator, struct cenalloc_buffer *buffer)
+{
+	return buffer->sg_table;
+}
+
+static void cenalloc_system_contig_unmap_dma
+	(struct cenalloc_allocator *allocator, struct cenalloc_buffer *buffer)
+{
+
+}
+
+static void *cenalloc_system_contig_map_kernel
+	(struct cenalloc_allocator *allocator, struct cenalloc_buffer *buffer)
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
+		return NULL;
+
+	pgprot = pgprot_writecombine(PAGE_KERNEL);
+
+	for_each_sg(table->sgl, sg, table->nents, i) {
+		int npages_this_entry = PAGE_ALIGN(sg->length) / PAGE_SIZE;
+		struct page *page = sg_page(sg);
+
+		BUG_ON(i >= npages);
+		for (j = 0; j < npages_this_entry; j++)
+			*(tmp++) = page++;
+	}
+	vaddr = vmap(pages, npages, VM_MAP, pgprot);
+	vfree(pages);
+
+	if (vaddr == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	return vaddr;
+}
+
+static void cenalloc_system_contig_unmap_kernel
+	(struct cenalloc_allocator *allocator, struct cenalloc_buffer *buffer)
+{
+	vunmap(buffer->vaddr);
+}
+
+static int cenalloc_system_contig_map_user
+	(struct cenalloc_allocator *mapper, struct cenalloc_buffer *buffer,
+			struct vm_area_struct *vma)
+{
+	struct sg_table *table = buffer->sg_table;
+	unsigned long addr = vma->vm_start;
+	unsigned long offset = vma->vm_pgoff * PAGE_SIZE;
+	struct scatterlist *sg;
+	int i;
+	int ret;
+
+	for_each_sg(table->sgl, sg, table->nents, i) {
+		struct page *page = sg_page(sg);
+		unsigned long remainder = vma->vm_end - addr;
+		unsigned long len = sg->length;
+
+		if (offset >= sg->length) {
+			offset -= sg->length;
+			continue;
+		} else if (offset) {
+			page += offset / PAGE_SIZE;
+			len = sg->length - offset;
+			offset = 0;
+		}
+		len = min(len, remainder);
+		ret = remap_pfn_range(vma, addr, page_to_pfn(page), len,
+				vma->vm_page_prot);
+		if (ret)
+			return ret;
+		addr += len;
+		if (addr >= vma->vm_end)
+			return 0;
+	}
+	return 0;
+}
+
+static void cenalloc_system_contig_sync_for_device
+	(struct cenalloc_allocator *allocator, struct cenalloc_buffer *buffer,
+		struct device *dev, enum dma_data_direction dir)
+{
+	/* TODO */
+}
+
+static struct cenalloc_allocator_ops system_contig_ops = {
+	.allocate = cenalloc_system_contig_allocate,
+	.free = cenalloc_system_contig_free,
+	.map_dma = cenalloc_system_contig_map_dma,
+	.unmap_dma = cenalloc_system_contig_unmap_dma,
+	.map_kernel = cenalloc_system_contig_map_kernel,
+	.unmap_kernel = cenalloc_system_contig_unmap_kernel,
+	.map_user = cenalloc_system_contig_map_user,
+	.sync_for_device = cenalloc_system_contig_sync_for_device,
+};
+
+struct cenalloc_allocator system_contig = {
+	.ops = &system_contig_ops,
+	.type = CENALLOC_ALLOCATOR_SYSTEM,
+	.id = CENALLOC_ALLOCATOR_SYSTEM,
+	.name = "system contiguous memory allocator",
+};
-- 
1.9.1

