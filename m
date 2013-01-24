Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab3AXLAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 06:00:20 -0500
Received: from us01smtp3.synopsys.com ([198.182.44.81]:33828 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174Ab3AXKzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:55:04 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v3 29/71] ARC: I/O and DMA Mappings
Date: Thu, 24 Jan 2013 16:20:26 +0530
Message-ID: <1359024639-21915-13-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
References: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/dma-mapping.h            |  205 +++++++++++++++++++++++++
 arch/arc/include/asm/dma.h                    |   14 ++
 arch/arc/include/asm/io.h                     |  103 +++++++++++++
 arch/arc/mm/dma.c                             |   94 +++++++++++
 arch/arc/mm/ioremap.c                         |   67 ++++++++
 arch/arc/plat-arcfpga/include/plat/dma_addr.h |   45 ++++++
 6 files changed, 528 insertions(+), 0 deletions(-)
 create mode 100644 arch/arc/include/asm/dma-mapping.h
 create mode 100644 arch/arc/include/asm/dma.h
 create mode 100644 arch/arc/include/asm/io.h
 create mode 100644 arch/arc/mm/dma.c
 create mode 100644 arch/arc/mm/ioremap.c
 create mode 100644 arch/arc/plat-arcfpga/include/plat/dma_addr.h

diff --git a/arch/arc/include/asm/dma-mapping.h b/arch/arc/include/asm/dma-mapping.h
new file mode 100644
index 0000000..7fd150e
--- /dev/null
+++ b/arch/arc/include/asm/dma-mapping.h
@@ -0,0 +1,205 @@
+/*
+ * DMA Mapping glue for ARC
+ *
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef ASM_ARC_DMA_MAPPING_H
+#define ASM_ARC_DMA_MAPPING_H
+
+#include <asm-generic/dma-coherent.h>
+#include <asm/cacheflush.h>
+#include <plat/dma_addr.h>
+
+void *dma_alloc_noncoherent(struct device *dev, size_t size,
+			    dma_addr_t *dma_handle, gfp_t gfp);
+
+void dma_free_noncoherent(struct device *dev, size_t size, void *vaddr,
+			  dma_addr_t dma_handle);
+
+void *dma_alloc_coherent(struct device *dev, size_t size,
+			 dma_addr_t *dma_handle, gfp_t gfp);
+
+void dma_free_coherent(struct device *dev, size_t size, void *kvaddr,
+		       dma_addr_t dma_handle);
+
+/* drivers/base/dma-mapping.c */
+extern int dma_common_mmap(struct device *dev, struct vm_area_struct *vma,
+			   void *cpu_addr, dma_addr_t dma_addr, size_t size);
+extern int dma_common_get_sgtable(struct device *dev, struct sg_table *sgt,
+				  void *cpu_addr, dma_addr_t dma_addr,
+				  size_t size);
+
+#define dma_mmap_coherent(d, v, c, h, s) dma_common_mmap(d, v, c, h, s)
+#define dma_get_sgtable(d, t, v, h, s) dma_common_get_sgtable(d, t, v, h, s)
+
+/*
+ * streaming DMA Mapping API...
+ * CPU accesses page via normal paddr, thus needs to explicitly made
+ * consistent before each use
+ */
+
+static inline void __inline_dma_cache_sync(unsigned long paddr, size_t size,
+					   enum dma_data_direction dir)
+{
+	switch (dir) {
+	case DMA_FROM_DEVICE:
+		dma_cache_inv(paddr, size);
+		break;
+	case DMA_TO_DEVICE:
+		dma_cache_wback(paddr, size);
+		break;
+	case DMA_BIDIRECTIONAL:
+		dma_cache_wback_inv(paddr, size);
+		break;
+	default:
+		pr_err("Invalid DMA dir [%d] for OP @ %lx\n", dir, paddr);
+	}
+}
+
+void __arc_dma_cache_sync(unsigned long paddr, size_t size,
+			  enum dma_data_direction dir);
+
+#define _dma_cache_sync(addr, sz, dir)			\
+do {							\
+	if (__builtin_constant_p(dir))			\
+		__inline_dma_cache_sync(addr, sz, dir);	\
+	else						\
+		__arc_dma_cache_sync(addr, sz, dir);	\
+}							\
+while (0);
+
+static inline dma_addr_t
+dma_map_single(struct device *dev, void *cpu_addr, size_t size,
+	       enum dma_data_direction dir)
+{
+	_dma_cache_sync((unsigned long)cpu_addr, size, dir);
+	return plat_kernel_addr_to_dma(dev, cpu_addr);
+}
+
+static inline void
+dma_unmap_single(struct device *dev, dma_addr_t dma_addr,
+		 size_t size, enum dma_data_direction dir)
+{
+}
+
+static inline dma_addr_t
+dma_map_page(struct device *dev, struct page *page,
+	     unsigned long offset, size_t size,
+	     enum dma_data_direction dir)
+{
+	unsigned long paddr = page_to_phys(page) + offset;
+	return dma_map_single(dev, (void *)paddr, size, dir);
+}
+
+static inline void
+dma_unmap_page(struct device *dev, dma_addr_t dma_handle,
+	       size_t size, enum dma_data_direction dir)
+{
+}
+
+static inline int
+dma_map_sg(struct device *dev, struct scatterlist *sg,
+	   int nents, enum dma_data_direction dir)
+{
+	struct scatterlist *s;
+	int i;
+
+	for_each_sg(sg, s, nents, i)
+		sg->dma_address = dma_map_page(dev, sg_page(s), s->offset,
+					       s->length, dir);
+
+	return nents;
+}
+
+static inline void
+dma_unmap_sg(struct device *dev, struct scatterlist *sg,
+	     int nents, enum dma_data_direction dir)
+{
+	struct scatterlist *s;
+	int i;
+
+	for_each_sg(sg, s, nents, i)
+		dma_unmap_page(dev, sg_dma_address(s), sg_dma_len(s), dir);
+}
+
+static inline void
+dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
+			size_t size, enum dma_data_direction dir)
+{
+	_dma_cache_sync(plat_dma_addr_to_kernel(dev, dma_handle), size,
+			DMA_FROM_DEVICE);
+}
+
+static inline void
+dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
+			   size_t size, enum dma_data_direction dir)
+{
+	_dma_cache_sync(plat_dma_addr_to_kernel(dev, dma_handle), size,
+			DMA_TO_DEVICE);
+}
+
+static inline void
+dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
+			      unsigned long offset, size_t size,
+			      enum dma_data_direction direction)
+{
+	_dma_cache_sync(plat_dma_addr_to_kernel(dev, dma_handle) + offset,
+			size, DMA_FROM_DEVICE);
+}
+
+static inline void
+dma_sync_single_range_for_device(struct device *dev, dma_addr_t dma_handle,
+				 unsigned long offset, size_t size,
+				 enum dma_data_direction direction)
+{
+	_dma_cache_sync(plat_dma_addr_to_kernel(dev, dma_handle) + offset,
+			size, DMA_TO_DEVICE);
+}
+
+static inline void
+dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
+		    enum dma_data_direction dir)
+{
+	int i;
+
+	for (i = 0; i < nelems; i++, sg++)
+		_dma_cache_sync((unsigned int)sg_virt(sg), sg->length, dir);
+}
+
+static inline void
+dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nelems,
+		       enum dma_data_direction dir)
+{
+	int i;
+
+	for (i = 0; i < nelems; i++, sg++)
+		_dma_cache_sync((unsigned int)sg_virt(sg), sg->length, dir);
+}
+
+static inline int dma_supported(struct device *dev, u64 dma_mask)
+{
+	/* Support 32 bit DMA mask exclusively */
+	return dma_mask == DMA_BIT_MASK(32);
+}
+
+static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
+{
+	return 0;
+}
+
+static inline int dma_set_mask(struct device *dev, u64 dma_mask)
+{
+	if (!dev->dma_mask || !dma_supported(dev, dma_mask))
+		return -EIO;
+
+	*dev->dma_mask = dma_mask;
+
+	return 0;
+}
+
+#endif
diff --git a/arch/arc/include/asm/dma.h b/arch/arc/include/asm/dma.h
new file mode 100644
index 0000000..ca7c451
--- /dev/null
+++ b/arch/arc/include/asm/dma.h
@@ -0,0 +1,14 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef ASM_ARC_DMA_H
+#define ASM_ARC_DMA_H
+
+#define MAX_DMA_ADDRESS 0xC0000000
+
+#endif
diff --git a/arch/arc/include/asm/io.h b/arch/arc/include/asm/io.h
new file mode 100644
index 0000000..d20051b
--- /dev/null
+++ b/arch/arc/include/asm/io.h
@@ -0,0 +1,103 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_ARC_IO_H
+#define _ASM_ARC_IO_H
+
+#include <linux/types.h>
+#include <asm/byteorder.h>
+#include <asm/page.h>
+
+#define PCI_IOBASE ((void __iomem *)0)
+
+extern void __iomem *ioremap(unsigned long physaddr, unsigned long size);
+extern void iounmap(const void __iomem *addr);
+
+#define ioremap_nocache(phy, sz)	ioremap(phy, sz)
+#define ioremap_wc(phy, sz)		ioremap(phy, sz)
+
+/* Change struct page to physical address */
+#define page_to_phys(page)		(page_to_pfn(page) << PAGE_SHIFT)
+
+#define __raw_readb __raw_readb
+static inline u8 __raw_readb(const volatile void __iomem *addr)
+{
+	u8 b;
+
+	__asm__ __volatile__(
+	"	ldb%U1 %0, %1	\n"
+	: "=r" (b)
+	: "m" (*(volatile u8 __force *)addr)
+	: "memory");
+
+	return b;
+}
+
+#define __raw_readw __raw_readw
+static inline u16 __raw_readw(const volatile void __iomem *addr)
+{
+	u16 s;
+
+	__asm__ __volatile__(
+	"	ldw%U1 %0, %1	\n"
+	: "=r" (s)
+	: "m" (*(volatile u16 __force *)addr)
+	: "memory");
+
+	return s;
+}
+
+#define __raw_readl __raw_readl
+static inline u32 __raw_readl(const volatile void __iomem *addr)
+{
+	u32 w;
+
+	__asm__ __volatile__(
+	"	ld%U1 %0, %1	\n"
+	: "=r" (w)
+	: "m" (*(volatile u32 __force *)addr)
+	: "memory");
+
+	return w;
+}
+
+#define __raw_writeb __raw_writeb
+static inline void __raw_writeb(u8 b, volatile void __iomem *addr)
+{
+	__asm__ __volatile__(
+	"	stb%U1 %0, %1	\n"
+	:
+	: "r" (b), "m" (*(volatile u8 __force *)addr)
+	: "memory");
+}
+
+#define __raw_writew __raw_writew
+static inline void __raw_writew(u16 s, volatile void __iomem *addr)
+{
+	__asm__ __volatile__(
+	"	stw%U1 %0, %1	\n"
+	:
+	: "r" (s), "m" (*(volatile u16 __force *)addr)
+	: "memory");
+
+}
+
+#define __raw_writel __raw_writel
+static inline void __raw_writel(u32 w, volatile void __iomem *addr)
+{
+	__asm__ __volatile__(
+	"	st%U1 %0, %1	\n"
+	:
+	: "r" (w), "m" (*(volatile u32 __force *)addr)
+	: "memory");
+
+}
+
+#include <asm-generic/io.h>
+
+#endif /* _ASM_ARC_IO_H */
diff --git a/arch/arc/mm/dma.c b/arch/arc/mm/dma.c
new file mode 100644
index 0000000..12cc648
--- /dev/null
+++ b/arch/arc/mm/dma.c
@@ -0,0 +1,94 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/*
+ * DMA Coherent API Notes
+ *
+ * I/O is inherently non-coherent on ARC. So a coherent DMA buffer is
+ * implemented by accessintg it using a kernel virtual address, with
+ * Cache bit off in the TLB entry.
+ *
+ * The default DMA address == Phy address which is 0x8000_0000 based.
+ * A platform/device can make it zero based, by over-riding
+ * plat_{dma,kernel}_addr_to_{kernel,dma}
+ */
+
+#include <linux/dma-mapping.h>
+#include <linux/dma-debug.h>
+#include <linux/export.h>
+#include <asm/cacheflush.h>
+
+/*
+ * Helpers for Coherent DMA API.
+ */
+void *dma_alloc_noncoherent(struct device *dev, size_t size,
+			    dma_addr_t *dma_handle, gfp_t gfp)
+{
+	void *paddr;
+
+	/* This is linear addr (0x8000_0000 based) */
+	paddr = alloc_pages_exact(size, gfp);
+	if (!paddr)
+		return NULL;
+
+	/* This is bus address, platform dependent */
+	*dma_handle = plat_kernel_addr_to_dma(dev, paddr);
+
+	return paddr;
+}
+EXPORT_SYMBOL(dma_alloc_noncoherent);
+
+void dma_free_noncoherent(struct device *dev, size_t size, void *vaddr,
+			  dma_addr_t dma_handle)
+{
+	free_pages_exact((void *)plat_dma_addr_to_kernel(dev, dma_handle),
+			 size);
+}
+EXPORT_SYMBOL(dma_free_noncoherent);
+
+void *dma_alloc_coherent(struct device *dev, size_t size,
+			 dma_addr_t *dma_handle, gfp_t gfp)
+{
+	void *paddr, *kvaddr;
+
+	/* This is linear addr (0x8000_0000 based) */
+	paddr = alloc_pages_exact(size, gfp);
+	if (!paddr)
+		return NULL;
+
+	/* This is kernel Virtual address (0x7000_0000 based) */
+	kvaddr = ioremap_nocache((unsigned long)paddr, size);
+	if (kvaddr != NULL)
+		memset(kvaddr, 0, size);
+
+	/* This is bus address, platform dependent */
+	*dma_handle = plat_kernel_addr_to_dma(dev, paddr);
+
+	return kvaddr;
+}
+EXPORT_SYMBOL(dma_alloc_coherent);
+
+void dma_free_coherent(struct device *dev, size_t size, void *kvaddr,
+		       dma_addr_t dma_handle)
+{
+	iounmap((void __force __iomem *)kvaddr);
+
+	free_pages_exact((void *)plat_dma_addr_to_kernel(dev, dma_handle),
+			 size);
+}
+EXPORT_SYMBOL(dma_free_coherent);
+
+/*
+ * Helper for streaming DMA...
+ */
+void __arc_dma_cache_sync(unsigned long paddr, size_t size,
+			  enum dma_data_direction dir)
+{
+	__inline_dma_cache_sync(paddr, size, dir);
+}
+EXPORT_SYMBOL(__arc_dma_cache_sync);
diff --git a/arch/arc/mm/ioremap.c b/arch/arc/mm/ioremap.c
new file mode 100644
index 0000000..52518b6
--- /dev/null
+++ b/arch/arc/mm/ioremap.c
@@ -0,0 +1,67 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/vmalloc.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <asm/cache.h>
+
+void __iomem *ioremap(unsigned long paddr, unsigned long size)
+{
+	unsigned long vaddr;
+	struct vm_struct *area;
+	unsigned long off, end;
+	const pgprot_t prot = PAGE_KERNEL_NO_CACHE;
+
+	/* Don't allow wraparound or zero size */
+	end = paddr + size - 1;
+	if (!size || (end < paddr))
+		return NULL;
+
+	/* If the region is h/w uncached, nothing special needed */
+	if (paddr >= ARC_UNCACHED_ADDR_SPACE)
+		return (void __iomem *)paddr;
+
+	/* An early platform driver might end up here */
+	if (!slab_is_available())
+		return NULL;
+
+	/* Mappings have to be page-aligned, page-sized */
+	off = paddr & ~PAGE_MASK;
+	paddr &= PAGE_MASK;
+	size = PAGE_ALIGN(end + 1) - paddr;
+
+	/*
+	 * Ok, go for it..
+	 */
+	area = get_vm_area(size, VM_IOREMAP);
+	if (!area)
+		return NULL;
+
+	area->phys_addr = paddr;
+	vaddr = (unsigned long)area->addr;
+	if (ioremap_page_range(vaddr, vaddr + size, paddr, prot)) {
+		vfree(area->addr);
+		return NULL;
+	}
+
+	return (void __iomem *)(off + (char __iomem *)vaddr);
+}
+EXPORT_SYMBOL(ioremap);
+
+void iounmap(const void __iomem *addr)
+{
+	if (addr >= (void __force __iomem *)ARC_UNCACHED_ADDR_SPACE)
+		return;
+
+	vfree((void *)(PAGE_MASK & (unsigned long __force)addr));
+}
+EXPORT_SYMBOL(iounmap);
diff --git a/arch/arc/plat-arcfpga/include/plat/dma_addr.h b/arch/arc/plat-arcfpga/include/plat/dma_addr.h
new file mode 100644
index 0000000..0e96343
--- /dev/null
+++ b/arch/arc/plat-arcfpga/include/plat/dma_addr.h
@@ -0,0 +1,45 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * vineetg: Feb 2009
+ *  -For AA4 board, kernel to DMA address APIs
+ */
+
+/*
+ * kernel addresses are 0x800_000 based, while Bus addr are 0 based
+ */
+
+#ifndef __PLAT_DMA_ADDR_H
+#define __PLAT_DMA_ADDR_H
+
+#include <linux/device.h>
+
+static inline unsigned long plat_dma_addr_to_kernel(struct device *dev,
+						    dma_addr_t dma_addr)
+{
+	return dma_addr + PAGE_OFFSET;
+}
+
+static inline dma_addr_t plat_kernel_addr_to_dma(struct device *dev, void *ptr)
+{
+	unsigned long addr = (unsigned long)ptr;
+	/*
+	 * To Catch buggy drivers which can call DMA map API with kernel vaddr
+	 * i.e. for buffers alloc via vmalloc or ioremap which are not
+	 * gaurnateed to be PHY contiguous and hence unfit for DMA anyways.
+	 * On ARC kernel virtual address is 0x7000_0000 to 0x7FFF_FFFF, so
+	 * ideally we want to check this range here, but our implementation is
+	 * better as it checks for even worse user virtual address as well.
+	 */
+	if (likely(addr >= PAGE_OFFSET))
+		return addr - PAGE_OFFSET;
+
+	BUG();
+	return addr;
+}
+
+#endif
-- 
1.7.4.1

