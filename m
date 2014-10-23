Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbaJWRgL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 13:36:11 -0400
Received: from smtp.citrix.com ([66.165.176.89]:59249 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393AbaJWRfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 13:35:03 -0400
X-IronPort-AV: E=Sophos;i="5.04,776,1406592000"; 
   d="scan'208";a="184362056"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>,
        <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        <Stefano.Stabellini@eu.citrix.com>,
        <linux-arm-kernel@lists.infradead.org>, <will.deacon@arm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v5 4/6] xen/arm/arm64: merge xen/mm32.c into xen/mm.c
Date: Thu, 23 Oct 2014 18:27:24 +0100
Message-ID: <1414085246-16160-4-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1410231821520.876@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1410231821520.876@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merge xen/mm32.c into xen/mm.c.
As a consequence the code gets compiled on arm64 too: introduce a few
compat functions to actually be able to compile it.
Introduce xen_is_dma_coherent on arm64 and call into the dma_ops
functions from the xen_dma wrappers in page-coherent.h to handle
non-coherent devices.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

---

Changes in v5:
- introduce xen_is_dma_coherent to
arch/arm64/include/asm/xen/page-coherent.h;
- do not remove arch/arm64/include/asm/xen/page-coherent.h, add
the missing dma_ops calls from it.
---
 arch/arm/xen/Makefile                      |    2 +-
 arch/arm/xen/mm.c                          |  124 ++++++++++++++++++++++++++++
 arch/arm/xen/mm32.c                        |  110 ------------------------
 arch/arm64/include/asm/xen/page-coherent.h |   25 +++---
 4 files changed, 138 insertions(+), 123 deletions(-)
 delete mode 100644 arch/arm/xen/mm32.c

diff --git a/arch/arm/xen/Makefile b/arch/arm/xen/Makefile
index 1f85bfe..1296952 100644
--- a/arch/arm/xen/Makefile
+++ b/arch/arm/xen/Makefile
@@ -1 +1 @@
-obj-y		:= enlighten.o hypercall.o grant-table.o p2m.o mm.o mm32.o
+obj-y		:= enlighten.o hypercall.o grant-table.o p2m.o mm.o
diff --git a/arch/arm/xen/mm.c b/arch/arm/xen/mm.c
index b0e77de..659e1c3 100644
--- a/arch/arm/xen/mm.c
+++ b/arch/arm/xen/mm.c
@@ -1,5 +1,8 @@
+#include <linux/cpu.h>
+#include <linux/dma-mapping.h>
 #include <linux/bootmem.h>
 #include <linux/gfp.h>
+#include <linux/highmem.h>
 #include <linux/export.h>
 #include <linux/slab.h>
 #include <linux/types.h>
@@ -13,9 +16,130 @@
 
 #include <asm/cacheflush.h>
 #include <asm/xen/page.h>
+#include <asm/xen/page-coherent.h>
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
+	if (xen_is_dma_coherent(hwdev))
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
+	if (xen_is_dma_coherent(hwdev))
+		return;
+	__xen_dma_page_dev_to_cpu(hwdev, handle, size, dir);
+}
+
+void xen_dma_sync_single_for_device(struct device *hwdev,
+		dma_addr_t handle, size_t size, enum dma_data_direction dir)
+{
+	if (xen_is_dma_coherent(hwdev))
+		return;
+	__xen_dma_page_cpu_to_dev(hwdev, handle, size, dir);
+}
+
 int xen_create_contiguous_region(phys_addr_t pstart, unsigned int order,
 				 unsigned int address_bits,
 				 dma_addr_t *dma_handle)
diff --git a/arch/arm/xen/mm32.c b/arch/arm/xen/mm32.c
deleted file mode 100644
index 6c0224e..0000000
--- a/arch/arm/xen/mm32.c
+++ /dev/null
@@ -1,110 +0,0 @@
-#include <linux/cpu.h>
-#include <linux/dma-mapping.h>
-#include <linux/gfp.h>
-#include <linux/highmem.h>
-
-#include <xen/features.h>
-
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
-	if (xen_is_dma_coherent(hwdev))
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
-	if (xen_is_dma_coherent(hwdev))
-		return;
-	__xen_dma_page_dev_to_cpu(hwdev, handle, size, dir);
-}
-
-void xen_dma_sync_single_for_device(struct device *hwdev,
-		dma_addr_t handle, size_t size, enum dma_data_direction dir)
-{
-	if (xen_is_dma_coherent(hwdev))
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
index dde3fc9..c34132b 100644
--- a/arch/arm64/include/asm/xen/page-coherent.h
+++ b/arch/arm64/include/asm/xen/page-coherent.h
@@ -5,6 +5,11 @@
 #include <linux/dma-attrs.h>
 #include <linux/dma-mapping.h>
 
+static inline bool xen_is_dma_coherent(struct device *dev)
+{
+    return (__generic_dma_ops(dev) == &coherent_swiotlb_dma_ops);
+}
+
 static inline void *xen_alloc_coherent_pages(struct device *hwdev, size_t size,
 		dma_addr_t *dma_handle, gfp_t flags,
 		struct dma_attrs *attrs)
@@ -23,21 +28,17 @@ static inline void xen_dma_map_page(struct device *hwdev, struct page *page,
 	     unsigned long offset, size_t size, enum dma_data_direction dir,
 	     struct dma_attrs *attrs)
 {
+	__generic_dma_ops(hwdev)->map_page(hwdev, page, offset, size, dir, attrs);
 }
 
-static inline void xen_dma_unmap_page(struct device *hwdev, dma_addr_t handle,
+void xen_dma_unmap_page(struct device *hwdev, dma_addr_t handle,
 		size_t size, enum dma_data_direction dir,
-		struct dma_attrs *attrs)
-{
-}
+		struct dma_attrs *attrs);
 
-static inline void xen_dma_sync_single_for_cpu(struct device *hwdev,
-		dma_addr_t handle, size_t size, enum dma_data_direction dir)
-{
-}
+void xen_dma_sync_single_for_cpu(struct device *hwdev,
+		dma_addr_t handle, size_t size, enum dma_data_direction dir);
+
+void xen_dma_sync_single_for_device(struct device *hwdev,
+		dma_addr_t handle, size_t size, enum dma_data_direction dir);
 
-static inline void xen_dma_sync_single_for_device(struct device *hwdev,
-		dma_addr_t handle, size_t size, enum dma_data_direction dir)
-{
-}
 #endif /* _ASM_ARM64_XEN_PAGE_COHERENT_H */
-- 
1.7.10.4

