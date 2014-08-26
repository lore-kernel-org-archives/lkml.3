Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870AbaHZMN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 08:13:59 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:30501 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757777AbaHZMNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 08:13:55 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-81-53fc79ff5e0a
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Laura Abbott <lauraa@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 3/7] drivers: dma-coherent: add initialization from device tree
Date: Tue, 26 Aug 2014 14:09:44 +0200
Message-id: <1409054988-32758-4-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1409054988-32758-1-git-send-email-m.szyprowski@samsung.com>
References: <1409054988-32758-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsVy+t/xa7r/K/8EGxzrMLP4O+kYu8WBPzsY
	LVZ2N7NZ7Fz3jtHibNMbdovtnTPYLb5cechksenxNVaLy7vmsFn0bNjKajHj/D4mi7VH7rJb
	LDjewmqxfsZrFgc+j9+/JjF6XO7rZfLoenuFyePOtT1sHpuX1Hvc/veY2WPdn1dMHn1bVjF6
	fN4kF8AZxWWTkpqTWZZapG+XwJWxbtpatoJjthV9j46wNDCuN+pi5OCQEDCRmPPFu4uRE8gU
	k7hwbz1bFyMXh5DAUkaJaW9eMUI4fUwSyzffYQepYhMwlOh628UGYosIZEv8+DaZBcRmFljK
	LDFvlhSILSzgL/Fk6mKwGhYBVYn+3ptgNbwCHhIHXq9igdgmJ/H/5QomkCM4BTwlzk2pBgkL
	AZVsnP6eZQIj7wJGhlWMoqmlyQXFSem5hnrFibnFpXnpesn5uZsYIeH7ZQfj4mNWhxgFOBiV
	eHg/lPwOFmJNLCuuzD3EKMHBrCTC+yPpT7AQb0piZVVqUX58UWlOavEhRiYOTqkGxiX/HFY2
	nHrULSv0YpfR+c4eVWGmU725Byvvu10JL1xcdGXdDN72i5cNNyZXa+omJM7ruPqvyO5S/67K
	tymeiySXLdoQdfhrl/Xz/Re8vY+YXP/7WPPoK448O9UDX3S2LZoY/OHIroW6On4r1B+mP+Ra
	2/AhS6KzwsNKN9P+28uXE57eN9CtYlFiKc5INNRiLipOBAApUcuUPQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialization procedure of dma coherent pool has been split into two
parts, so memory pool can now be initialized without assigning to
particular struct device. Then initialized region can be assigned to
more than one struct device. To protect from concurent allocations from
different devices, a spinlock has been added to dma_coherent_mem
structure. The last part of this patch adds support for handling
'shared-dma-pool' reserved-memory device tree nodes.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/base/dma-coherent.c | 138 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 119 insertions(+), 19 deletions(-)

diff --git a/drivers/base/dma-coherent.c b/drivers/base/dma-coherent.c
index 7d6e84a51424..4e2dfcc16b70 100644
--- a/drivers/base/dma-coherent.c
+++ b/drivers/base/dma-coherent.c
@@ -14,11 +14,14 @@ struct dma_coherent_mem {
 	int		size;
 	int		flags;
 	unsigned long	*bitmap;
+	spinlock_t	spinlock;
 };
 
-int dma_declare_coherent_memory(struct device *dev, phys_addr_t phys_addr,
-				dma_addr_t device_addr, size_t size, int flags)
+static int dma_init_coherent_memory(phys_addr_t phys_addr, dma_addr_t device_addr,
+			     size_t size, int flags,
+			     struct dma_coherent_mem **mem)
 {
+	struct dma_coherent_mem *dma_mem = NULL;
 	void __iomem *mem_base = NULL;
 	int pages = size >> PAGE_SHIFT;
 	int bitmap_size = BITS_TO_LONGS(pages) * sizeof(long);
@@ -27,27 +30,26 @@ int dma_declare_coherent_memory(struct device *dev, phys_addr_t phys_addr,
 		goto out;
 	if (!size)
 		goto out;
-	if (dev->dma_mem)
-		goto out;
-
-	/* FIXME: this routine just ignores DMA_MEMORY_INCLUDES_CHILDREN */
 
 	mem_base = ioremap(phys_addr, size);
 	if (!mem_base)
 		goto out;
 
-	dev->dma_mem = kzalloc(sizeof(struct dma_coherent_mem), GFP_KERNEL);
-	if (!dev->dma_mem)
+	dma_mem = kzalloc(sizeof(struct dma_coherent_mem), GFP_KERNEL);
+	if (!dma_mem)
 		goto out;
-	dev->dma_mem->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
-	if (!dev->dma_mem->bitmap)
+	dma_mem->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
+	if (!dma_mem->bitmap)
 		goto free1_out;
 
-	dev->dma_mem->virt_base = mem_base;
-	dev->dma_mem->device_base = device_addr;
-	dev->dma_mem->pfn_base = PFN_DOWN(phys_addr);
-	dev->dma_mem->size = pages;
-	dev->dma_mem->flags = flags;
+	dma_mem->virt_base = mem_base;
+	dma_mem->device_base = device_addr;
+	dma_mem->pfn_base = PFN_DOWN(phys_addr);
+	dma_mem->size = pages;
+	dma_mem->flags = flags;
+	spin_lock_init(&dma_mem->spinlock);
+
+	*mem = dma_mem;
 
 	if (flags & DMA_MEMORY_MAP)
 		return DMA_MEMORY_MAP;
@@ -55,12 +57,51 @@ int dma_declare_coherent_memory(struct device *dev, phys_addr_t phys_addr,
 	return DMA_MEMORY_IO;
 
  free1_out:
-	kfree(dev->dma_mem);
+	kfree(dma_mem);
  out:
 	if (mem_base)
 		iounmap(mem_base);
 	return 0;
 }
+
+static void dma_release_coherent_memory(struct dma_coherent_mem *mem)
+{
+	if (!mem)
+		return;
+	iounmap(mem->virt_base);
+	kfree(mem->bitmap);
+	kfree(mem);
+}
+
+static int dma_assign_coherent_memory(struct device *dev,
+				      struct dma_coherent_mem *mem)
+{
+	if (dev->dma_mem)
+		return -EBUSY;
+
+	dev->dma_mem = mem;
+	/* FIXME: this routine just ignores DMA_MEMORY_INCLUDES_CHILDREN */
+
+	return 0;
+}
+
+int dma_declare_coherent_memory(struct device *dev, phys_addr_t phys_addr,
+				dma_addr_t device_addr, size_t size, int flags)
+{
+	struct dma_coherent_mem *mem;
+	int ret;
+
+	ret = dma_init_coherent_memory(phys_addr, device_addr, size, flags,
+				       &mem);
+	if (ret == 0)
+		return 0;
+
+	if (dma_assign_coherent_memory(dev, mem) == 0)
+		return ret;
+
+	dma_release_coherent_memory(mem);
+	return 0;
+}
 EXPORT_SYMBOL(dma_declare_coherent_memory);
 
 void dma_release_declared_memory(struct device *dev)
@@ -69,10 +110,8 @@ void dma_release_declared_memory(struct device *dev)
 
 	if (!mem)
 		return;
+	dma_release_coherent_memory(mem);
 	dev->dma_mem = NULL;
-	iounmap(mem->virt_base);
-	kfree(mem->bitmap);
-	kfree(mem);
 }
 EXPORT_SYMBOL(dma_release_declared_memory);
 
@@ -80,6 +119,7 @@ void *dma_mark_declared_memory_occupied(struct device *dev,
 					dma_addr_t device_addr, size_t size)
 {
 	struct dma_coherent_mem *mem = dev->dma_mem;
+	unsigned long flags;
 	int pos, err;
 
 	size += device_addr & ~PAGE_MASK;
@@ -87,8 +127,11 @@ void *dma_mark_declared_memory_occupied(struct device *dev,
 	if (!mem)
 		return ERR_PTR(-EINVAL);
 
+	spin_lock_irqsave(&mem->spinlock, flags);
 	pos = (device_addr - mem->device_base) >> PAGE_SHIFT;
 	err = bitmap_allocate_region(mem->bitmap, pos, get_order(size));
+	spin_unlock_irqrestore(&mem->spinlock, flags);
+
 	if (err != 0)
 		return ERR_PTR(err);
 	return mem->virt_base + (pos << PAGE_SHIFT);
@@ -115,6 +158,7 @@ int dma_alloc_from_coherent(struct device *dev, ssize_t size,
 {
 	struct dma_coherent_mem *mem;
 	int order = get_order(size);
+	unsigned long flags;
 	int pageno;
 
 	if (!dev)
@@ -124,6 +168,7 @@ int dma_alloc_from_coherent(struct device *dev, ssize_t size,
 		return 0;
 
 	*ret = NULL;
+	spin_lock_irqsave(&mem->spinlock, flags);
 
 	if (unlikely(size > (mem->size << PAGE_SHIFT)))
 		goto err;
@@ -138,10 +183,12 @@ int dma_alloc_from_coherent(struct device *dev, ssize_t size,
 	*dma_handle = mem->device_base + (pageno << PAGE_SHIFT);
 	*ret = mem->virt_base + (pageno << PAGE_SHIFT);
 	memset(*ret, 0, size);
+	spin_unlock_irqrestore(&mem->spinlock, flags);
 
 	return 1;
 
 err:
+	spin_unlock_irqrestore(&mem->spinlock, flags);
 	/*
 	 * In the case where the allocation can not be satisfied from the
 	 * per-device area, try to fall back to generic memory if the
@@ -171,8 +218,11 @@ int dma_release_from_coherent(struct device *dev, int order, void *vaddr)
 	if (mem && vaddr >= mem->virt_base && vaddr <
 		   (mem->virt_base + (mem->size << PAGE_SHIFT))) {
 		int page = (vaddr - mem->virt_base) >> PAGE_SHIFT;
+		unsigned long flags;
 
+		spin_lock_irqsave(&mem->spinlock, flags);
 		bitmap_release_region(mem->bitmap, page, order);
+		spin_unlock_irqrestore(&mem->spinlock, flags);
 		return 1;
 	}
 	return 0;
@@ -218,3 +268,53 @@ int dma_mmap_from_coherent(struct device *dev, struct vm_area_struct *vma,
 	return 0;
 }
 EXPORT_SYMBOL(dma_mmap_from_coherent);
+
+/*
+ * Support for reserved memory regions defined in device tree
+ */
+#ifdef CONFIG_OF_RESERVED_MEM
+#include <linux/of.h>
+#include <linux/of_fdt.h>
+#include <linux/of_reserved_mem.h>
+
+static int rmem_dma_device_init(struct reserved_mem *rmem, struct device *dev)
+{
+	struct dma_coherent_mem *mem = rmem->priv;
+	if (!mem &&
+	    dma_init_coherent_memory(rmem->base, rmem->base, rmem->size,
+				     DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE,
+				     &mem) != DMA_MEMORY_MAP) {
+		pr_info("Reserved memory: failed to init DMA memory pool at %pa, size %ld MiB\n",
+			&rmem->base, (unsigned long)rmem->size / SZ_1M);
+		return -ENODEV;
+	}
+	rmem->priv = mem;
+	dma_assign_coherent_memory(dev, mem);
+	return 0;
+}
+
+static void rmem_dma_device_release(struct reserved_mem *rmem,
+				    struct device *dev)
+{
+	dev->dma_mem = NULL;
+}
+
+static const struct reserved_mem_ops rmem_dma_ops = {
+	.device_init	= rmem_dma_device_init,
+	.device_release	= rmem_dma_device_release,
+};
+
+static int __init rmem_dma_setup(struct reserved_mem *rmem)
+{
+	unsigned long node = rmem->fdt_node;
+
+	if (of_get_flat_dt_prop(node, "reusable", NULL))
+		return -EINVAL;
+
+	rmem->ops = &rmem_dma_ops;
+	pr_info("Reserved memory: created DMA memory pool at %pa, size %ld MiB\n",
+		&rmem->base, (unsigned long)rmem->size / SZ_1M);
+	return 0;
+}
+RESERVEDMEM_OF_DECLARE(dma, "shared-dma-pool", rmem_dma_setup);
+#endif
-- 
1.9.2

