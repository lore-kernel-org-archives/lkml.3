Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbaIKLXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 07:23:14 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:51125 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbaIKLWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 07:22:51 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-57-54118609f6a4
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Laura Abbott <lauraa@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 2/3] drivers: dma-coherent: add initialization from device
 tree
Date: Thu, 11 Sep 2014 13:22:40 +0200
Message-id: <1410434561-9294-3-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1410434561-9294-1-git-send-email-m.szyprowski@samsung.com>
References: <1410434561-9294-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsVy+t/xq7qcbYIhBg8es1vMWb+GzeLvpGPs
	Fgf+7GC0WNndzGaxc907RouzTW/YLbZ3zmC3+HLlIZPFpsfXWC0u75rDZrH2yF12iwXHW1gd
	eDx+/5rE6HG5r5fJo+vtFSaPO9f2sHmcmPGbxWPzknqP2/8eM3us+/OKyaNvyypGj8+b5AK4
	orhsUlJzMstSi/TtErgyJv8KK/hlV7H00RamBsaDxl2MnBwSAiYSL+f+ZYGwxSQu3FvP1sXI
	xSEksJRR4tHLmYwQTh+TxP7Jj9hBqtgEDCW63naxgdgiAm4S/9YdAutgFpjMLHFt4R4mkISw
	QIjEltmzwMayCKhKHOw8CNbAK+Au8fjCbqh1chL/X64Aq+cU8JCY/G0S2AIhoJqLuzewTWDk
	XcDIsIpRNLU0uaA4KT3XSK84Mbe4NC9dLzk/dxMjJHC/7mBceszqEKMAB6MSD++HXMEQIdbE
	suLK3EOMEhzMSiK8pYVAId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYxHLBf/t1y65VjXt8+Hl+2q
	eDlNf8KiNenzeqa63pr6dUZuPeefNVlH/f7fzYt9K3xfaFWnpn2wferZs1mTNW7lH/s9aSpj
	6J2ktC9rAnsKTxyZ/vLj7r8vpGe4ZD62XrlI7NvhmJpC3gyvmVx+hwWPLBb6V77t699Du/wn
	vXVfaMP1se7IZ6n2F0osxRmJhlrMRcWJALiaznA6AgAA
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
 drivers/base/dma-coherent.c | 145 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 126 insertions(+), 19 deletions(-)

diff --git a/drivers/base/dma-coherent.c b/drivers/base/dma-coherent.c
index 7d6e84a..8f88c91 100644
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
@@ -218,3 +268,60 @@ int dma_mmap_from_coherent(struct device *dev, struct vm_area_struct *vma,
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
+#ifdef CONFIG_ARM
+	if (!of_get_flat_dt_prop(node, "no-map", NULL)) {
+		pr_info("Reserved memory: regions without no-map are not yet supported\n");
+		return -EINVAL;
+	}
+#endif
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

