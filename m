Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbaJYSZp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 14:25:45 -0400
Received: from smtp.citrix.com ([66.165.176.89]:3077 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbaJYSZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 14:25:43 -0400
X-IronPort-AV: E=Sophos;i="5.04,786,1406592000"; 
   d="scan'208";a="184886133"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>,
        <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        <Stefano.Stabellini@eu.citrix.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v6 5/7] xen/arm/arm64: merge xen/mm32.c into xen/mm.c
Date: Sat, 25 Oct 2014 14:57:20 +0100
Message-ID: <1414245442-4306-5-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1410251450180.22875@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1410251450180.22875@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merge xen/mm32.c into xen/mm.c.
As a consequence the code gets compiled on arm64 too: introduce a few
compat functions to actually be able to compile it.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
---
 arch/arm/xen/Makefile                      |    2 +-
 arch/arm/xen/mm.c                          |  128 ++++++++++++++++++++++++++++
 arch/arm/xen/mm32.c                        |  116 -------------------------
 arch/arm64/include/asm/xen/page-coherent.h |   44 +---------
 4 files changed, 130 insertions(+), 160 deletions(-)
 delete mode 100644 arch/arm/xen/mm32.c

diff --git a/arch/arm/xen/Makefile b/arch/arm/xen/Makefile
index 1f85bfe..1296952 100644
--- a/arch/arm/xen/Makefile
+++ b/arch/arm/xen/Makefile
@@ -1 +1 @@
-obj-y		:= enlighten.o hypercall.o grant-table.o p2m.o mm.o mm32.o
+obj-y		:= enlighten.o hypercall.o grant-table.o p2m.o mm.o
diff --git a/arch/arm/xen/mm.c b/arch/arm/xen/mm.c
index b0e77de..8a23a10 100644
--- a/arch/arm/xen/mm.c
+++ b/arch/arm/xen/mm.c
@@ -1,6 +1,10 @@
+#include <linux/cpu.h>
+#include <linux/dma-mapping.h>
 #include <linux/bootmem.h>
 #include <linux/gfp.h>
+#include <linux/highmem.h>
 #include <linux/export.h>
+#include <linux/of_address.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/dma-mapping.h>
@@ -16,6 +20,130 @@
 #include <asm/xen/hypercall.h>
 #include <asm/xen/interface.h>
 
+
+#ifdef CONFIG_ARM64
+static inline void dmac_map_area(const void *start, size_t size, int dir)
+{
+	return __dma_map_area(start, size, dir);
+}
+
+static inline void dmac_unmap_area(const void *start, size_t size, int dir)
+{
+	return __dma_unmap_area(start, size, dir);
+}
+
+static inline bool cache_is_vipt_nonaliasing(void)
+{
+	return true;
+}
+
+static inline void *kmap_high_get(struct page *page)
+{
+	return NULL;
+}
+
+static inline void kunmap_high(struct page *page) {}
+#endif
+
+static inline bool is_dma_coherent(struct device *dev)
+{
+	return of_dma_is_coherent(dev->of_node);
+}
+
+/* functions called by SWIOTLB */
+
+static void dma_cache_maint(dma_addr_t handle, unsigned long offset,
+	size_t size, enum dma_data_direction dir,
+	void (*op)(const void *, size_t, int))
+{
+	unsigned long pfn;
+	size_t left = size;
+
+	pfn = (handle >> PAGE_SHIFT) + offset / PAGE_SIZE;
+	offset %= PAGE_SIZE;
+
+	do {
+		size_t len = left;
+		void *vaddr;
+	
+		if (!pfn_valid(pfn))
+		{
+			/* TODO: cache flush */
+		} else {
+			struct page *page = pfn_to_page(pfn);
+
+			if (PageHighMem(page)) {
+				if (len + offset > PAGE_SIZE)
+					len = PAGE_SIZE - offset;
+
+				if (cache_is_vipt_nonaliasing()) {
+					vaddr = kmap_atomic(page);
+					op(vaddr + offset, len, dir);
+					kunmap_atomic(vaddr);
+				} else {
+					vaddr = kmap_high_get(page);
+					if (vaddr) {
+						op(vaddr + offset, len, dir);
+						kunmap_high(page);
+					}
+				}
+			} else {
+				vaddr = page_address(page) + offset;
+				op(vaddr, len, dir);
+			}
+		}
+
+		offset = 0;
+		pfn++;
+		left -= len;
+	} while (left);
+}
+
+static void __xen_dma_page_dev_to_cpu(struct device *hwdev, dma_addr_t handle,
+		size_t size, enum dma_data_direction dir)
+{
+	/* Cannot use __dma_page_dev_to_cpu because we don't have a
+	 * struct page for handle */
+
+	dma_cache_maint(handle & PAGE_MASK, handle & ~PAGE_MASK, size, dir, dmac_unmap_area);
+}
+
+static void __xen_dma_page_cpu_to_dev(struct device *hwdev, dma_addr_t handle,
+		size_t size, enum dma_data_direction dir)
+{
+
+	dma_cache_maint(handle & PAGE_MASK, handle & ~PAGE_MASK, size, dir, dmac_map_area);
+}
+
+void xen_dma_unmap_page(struct device *hwdev, dma_addr_t handle,
+		size_t size, enum dma_data_direction dir,
+		struct dma_attrs *attrs)
+
+{
+	if (is_dma_coherent(hwdev))
+		return;
+	if (dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
+		return;
+
+	__xen_dma_page_dev_to_cpu(hwdev, handle, size, dir);
+}
+
+void xen_dma_sync_single_for_cpu(struct device *hwdev,
+		dma_addr_t handle, size_t size, enum dma_data_direction dir)
+{
+	if (is_dma_coherent(hwdev))
+		return;
+	__xen_dma_page_dev_to_cpu(hwdev, handle, size, dir);
+}
+
+void xen_dma_sync_single_for_device(struct device *hwdev,
+		dma_addr_t handle, size_t size, enum dma_data_direction dir)
+{
+	if (is_dma_coherent(hwdev))
+		return;
+	__xen_dma_page_cpu_to_dev(hwdev, handle, size, dir);
+}
+
 int xen_create_contiguous_region(phys_addr_t pstart, unsigned int order,
 				 unsigned int address_bits,
 				 dma_addr_t *dma_handle)
diff --git a/arch/arm/xen/mm32.c b/arch/arm/xen/mm32.c
deleted file mode 100644
index 4daf931..0000000
--- a/arch/arm/xen/mm32.c
+++ /dev/null
@@ -1,116 +0,0 @@
-#include <linux/cpu.h>
-#include <linux/dma-mapping.h>
-#include <linux/gfp.h>
-#include <linux/highmem.h>
-#include <linux/of_address.h>
-
-#include <xen/features.h>
-
-
-static inline bool is_dma_coherent(struct device *dev)
-{
-	return of_dma_is_coherent(dev->of_node);
-}
-
-/* functions called by SWIOTLB */
-
-static void dma_cache_maint(dma_addr_t handle, unsigned long offset,
-	size_t size, enum dma_data_direction dir,
-	void (*op)(const void *, size_t, int))
-{
-	unsigned long pfn;
-	size_t left = size;
-
-	pfn = (handle >> PAGE_SHIFT) + offset / PAGE_SIZE;
-	offset %= PAGE_SIZE;
-
-	do {
-		size_t len = left;
-		void *vaddr;
-	
-		if (!pfn_valid(pfn))
-		{
-			/* TODO: cache flush */
-		} else {
-			struct page *page = pfn_to_page(pfn);
-
-			if (PageHighMem(page)) {
-				if (len + offset > PAGE_SIZE)
-					len = PAGE_SIZE - offset;
-
-				if (cache_is_vipt_nonaliasing()) {
-					vaddr = kmap_atomic(page);
-					op(vaddr + offset, len, dir);
-					kunmap_atomic(vaddr);
-				} else {
-					vaddr = kmap_high_get(page);
-					if (vaddr) {
-						op(vaddr + offset, len, dir);
-						kunmap_high(page);
-					}
-				}
-			} else {
-				vaddr = page_address(page) + offset;
-				op(vaddr, len, dir);
-			}
-		}
-
-		offset = 0;
-		pfn++;
-		left -= len;
-	} while (left);
-}
-
-static void __xen_dma_page_dev_to_cpu(struct device *hwdev, dma_addr_t handle,
-		size_t size, enum dma_data_direction dir)
-{
-	/* Cannot use __dma_page_dev_to_cpu because we don't have a
-	 * struct page for handle */
-
-	dma_cache_maint(handle & PAGE_MASK, handle & ~PAGE_MASK, size, dir, dmac_unmap_area);
-}
-
-static void __xen_dma_page_cpu_to_dev(struct device *hwdev, dma_addr_t handle,
-		size_t size, enum dma_data_direction dir)
-{
-
-	dma_cache_maint(handle & PAGE_MASK, handle & ~PAGE_MASK, size, dir, dmac_map_area);
-}
-
-void xen_dma_unmap_page(struct device *hwdev, dma_addr_t handle,
-		size_t size, enum dma_data_direction dir,
-		struct dma_attrs *attrs)
-
-{
-	if (is_dma_coherent(hwdev))
-		return;
-	if (dma_get_attr(DMA_ATTR_SKIP_CPU_SYNC, attrs))
-		return;
-
-	__xen_dma_page_dev_to_cpu(hwdev, handle, size, dir);
-}
-
-void xen_dma_sync_single_for_cpu(struct device *hwdev,
-		dma_addr_t handle, size_t size, enum dma_data_direction dir)
-{
-	if (is_dma_coherent(hwdev))
-		return;
-	__xen_dma_page_dev_to_cpu(hwdev, handle, size, dir);
-}
-
-void xen_dma_sync_single_for_device(struct device *hwdev,
-		dma_addr_t handle, size_t size, enum dma_data_direction dir)
-{
-	if (is_dma_coherent(hwdev))
-		return;
-	__xen_dma_page_cpu_to_dev(hwdev, handle, size, dir);
-}
-
-int __init xen_mm32_init(void)
-{
-	if (!xen_initial_domain())
-		return 0;
-
-	return 0;
-}
-arch_initcall(xen_mm32_init);
diff --git a/arch/arm64/include/asm/xen/page-coherent.h b/arch/arm64/include/asm/xen/page-coherent.h
index dde3fc9..2052102 100644
--- a/arch/arm64/include/asm/xen/page-coherent.h
+++ b/arch/arm64/include/asm/xen/page-coherent.h
@@ -1,43 +1 @@
-#ifndef _ASM_ARM64_XEN_PAGE_COHERENT_H
-#define _ASM_ARM64_XEN_PAGE_COHERENT_H
-
-#include <asm/page.h>
-#include <linux/dma-attrs.h>
-#include <linux/dma-mapping.h>
-
-static inline void *xen_alloc_coherent_pages(struct device *hwdev, size_t size,
-		dma_addr_t *dma_handle, gfp_t flags,
-		struct dma_attrs *attrs)
-{
-	return __generic_dma_ops(hwdev)->alloc(hwdev, size, dma_handle, flags, attrs);
-}
-
-static inline void xen_free_coherent_pages(struct device *hwdev, size_t size,
-		void *cpu_addr, dma_addr_t dma_handle,
-		struct dma_attrs *attrs)
-{
-	__generic_dma_ops(hwdev)->free(hwdev, size, cpu_addr, dma_handle, attrs);
-}
-
-static inline void xen_dma_map_page(struct device *hwdev, struct page *page,
-	     unsigned long offset, size_t size, enum dma_data_direction dir,
-	     struct dma_attrs *attrs)
-{
-}
-
-static inline void xen_dma_unmap_page(struct device *hwdev, dma_addr_t handle,
-		size_t size, enum dma_data_direction dir,
-		struct dma_attrs *attrs)
-{
-}
-
-static inline void xen_dma_sync_single_for_cpu(struct device *hwdev,
-		dma_addr_t handle, size_t size, enum dma_data_direction dir)
-{
-}
-
-static inline void xen_dma_sync_single_for_device(struct device *hwdev,
-		dma_addr_t handle, size_t size, enum dma_data_direction dir)
-{
-}
-#endif /* _ASM_ARM64_XEN_PAGE_COHERENT_H */
+#include <../../arm/include/asm/xen/page-coherent.h>
-- 
1.7.10.4

