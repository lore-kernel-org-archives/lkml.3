Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbaIKLWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 07:22:54 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:46643 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472AbaIKLWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 07:22:52 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-5d-541186097666
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
Subject: [PATCH v2 3/3] drivers: dma-contiguous: add initialization from device
 tree
Date: Thu, 11 Sep 2014 13:22:41 +0200
Message-id: <1410434561-9294-4-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1410434561-9294-1-git-send-email-m.szyprowski@samsung.com>
References: <1410434561-9294-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsVy+t/xq7qcbYIhBk//mVjMWb+GzeLvpGPs
	Fgf+7GC0WNndzGaxc907RouzTW/YLbZ3zmC3+HLlIZPFpsfXWC0u75rDZrH2yF12iwXHW1gd
	eDx+/5rE6HG5r5fJo+vtFSaPO9f2sHmcmPGbxWPzknqP2/8eM3us+/OKyaNvyypGj8+b5AK4
	orhsUlJzMstSi/TtErgyTm8OKVhrWLFx7jbWBsYdGl2MnBwSAiYS3/ctZYewxSQu3FvP1sXI
	xSEksJRRYsnBuUwQTh+TxP7Jj8Cq2AQMJbredrGB2CICbhL/1h0C62AWmMwscW3hHiaQhLBA
	mERLz1SwBhYBVYmnT1eBNfAKuEtMeHiVFWKdnMT/lyvA6jkFPCQmf5sEVi8EVHNx9wa2CYy8
	CxgZVjGKppYmFxQnpeca6RUn5haX5qXrJefnbmKEBO7XHYxLj1kdYhTgYFTi4f2QKxgixJpY
	VlyZe4hRgoNZSYS3tBAoxJuSWFmVWpQfX1Sak1p8iJGJg1OqgVHphbvEk9Xnn7P2bNd7L8jQ
	f0Jic3zbzsNu/o5lVbOOM7X/VebZbr6q9q2CZOPyTG27skNpmhVTimJv8t9jbI+Of7Bf6Vj2
	/zBG86lO78Vu/Gk16yw8kV70cP4tk+mHjpXGH1yb83yiOpfT91WxB/RvzpiRdyszvN6dpTqL
	Y126pa7Y6g26Z5VYijMSDbWYi4oTAQz66u46AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function to create CMA region from previously reserved memory
and add support for handling 'shared-dma-pool' reserved-memory device
tree nodes.

Based on previous code provided by Josh Cartwright <joshc@codeaurora.org>

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/base/dma-contiguous.c | 71 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/cma.h           |  3 ++
 mm/cma.c                      | 62 ++++++++++++++++++++++++++++++-------
 3 files changed, 125 insertions(+), 11 deletions(-)

diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
index 6606abd..eefb81b8 100644
--- a/drivers/base/dma-contiguous.c
+++ b/drivers/base/dma-contiguous.c
@@ -211,3 +211,74 @@ bool dma_release_from_contiguous(struct device *dev, struct page *pages,
 {
 	return cma_release(dev_get_cma_area(dev), pages, count);
 }
+
+/*
+ * Support for reserved memory regions defined in device tree
+ */
+#ifdef CONFIG_OF_RESERVED_MEM
+#include <linux/of.h>
+#include <linux/of_fdt.h>
+#include <linux/of_reserved_mem.h>
+
+#undef pr_fmt
+#define pr_fmt(fmt) fmt
+
+static int rmem_cma_device_init(struct reserved_mem *rmem, struct device *dev)
+{
+	struct cma *cma = rmem->priv;
+	if (!cma)
+		return -ENODEV;
+
+	dev_set_cma_area(dev, cma);
+	return 0;
+}
+
+static void rmem_cma_device_release(struct reserved_mem *rmem,
+				    struct device *dev)
+{
+	dev_set_cma_area(dev, NULL);
+}
+
+static const struct reserved_mem_ops rmem_cma_ops = {
+	.device_init	= rmem_cma_device_init,
+	.device_release = rmem_cma_device_release,
+};
+
+static int __init rmem_cma_setup(struct reserved_mem *rmem)
+{
+	phys_addr_t align = PAGE_SIZE << max(MAX_ORDER - 1, pageblock_order);
+	phys_addr_t mask = align - 1;
+	unsigned long node = rmem->fdt_node;
+	struct cma *cma;
+	int err;
+
+	if (!of_get_flat_dt_prop(node, "reusable", NULL) ||
+	    of_get_flat_dt_prop(node, "no-map", NULL))
+		return -EINVAL;
+
+	if ((rmem->base & mask) || (rmem->size & mask)) {
+		pr_err("Reserved memory: incorrect alignment of CMA region\n");
+		return -EINVAL;
+	}
+
+	err = cma_init_reserved_mem(rmem->base, rmem->size, 0, &cma);
+	if (err) {
+		pr_err("Reserved memory: unable to setup CMA region\n");
+		return err;
+	}
+	/* Architecture specific contiguous memory fixup. */
+	dma_contiguous_early_fixup(rmem->base, rmem->size);
+
+	if (of_get_flat_dt_prop(node, "linux,cma-default", NULL))
+		dma_contiguous_set_default(cma);
+
+	rmem->ops = &rmem_cma_ops;
+	rmem->priv = cma;
+
+	pr_info("Reserved memory: created CMA memory pool at %pa, size %ld MiB\n",
+		&rmem->base, (unsigned long)rmem->size / SZ_1M);
+
+	return 0;
+}
+RESERVEDMEM_OF_DECLARE(cma, "shared-dma-pool", rmem_cma_setup);
+#endif
diff --git a/include/linux/cma.h b/include/linux/cma.h
index 371b930..0430ed0 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -22,6 +22,9 @@ extern int __init cma_declare_contiguous(phys_addr_t size,
 			phys_addr_t base, phys_addr_t limit,
 			phys_addr_t alignment, unsigned int order_per_bit,
 			bool fixed, struct cma **res_cma);
+extern int cma_init_reserved_mem(phys_addr_t size,
+					phys_addr_t base, int order_per_bit,
+					struct cma **res_cma);
 extern struct page *cma_alloc(struct cma *cma, int count, unsigned int align);
 extern bool cma_release(struct cma *cma, struct page *pages, int count);
 #endif
diff --git a/mm/cma.c b/mm/cma.c
index 474c644..014e145 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -141,6 +141,54 @@ static int __init cma_init_reserved_areas(void)
 core_initcall(cma_init_reserved_areas);
 
 /**
+ * cma_init_reserved_mem() - create custom contiguous area from reserved memory
+ * @base: Base address of the reserved area
+ * @size: Size of the reserved area (in bytes),
+ * @order_per_bit: Order of pages represented by one bit on bitmap.
+ * @res_cma: Pointer to store the created cma region.
+ *
+ * This function creates custom contiguous area from already reserved memory.
+ */
+int __init cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
+				 int order_per_bit, struct cma **res_cma)
+{
+	struct cma *cma;
+	phys_addr_t alignment;
+
+	/* Sanity checks */
+	if (cma_area_count == ARRAY_SIZE(cma_areas)) {
+		pr_err("Not enough slots for CMA reserved regions!\n");
+		return -ENOSPC;
+	}
+
+	if (!size || !memblock_is_region_reserved(base, size))
+		return -EINVAL;
+
+	/* ensure minimal alignment requied by mm core */
+	alignment = PAGE_SIZE << max(MAX_ORDER - 1, pageblock_order);
+
+	/* alignment should be aligned with order_per_bit */
+	if (!IS_ALIGNED(alignment >> PAGE_SHIFT, 1 << order_per_bit))
+		return -EINVAL;
+
+	if (ALIGN(base, alignment) != base || ALIGN(size, alignment) != size)
+		return -EINVAL;
+
+	/*
+	 * Each reserved area must be initialised later, when more kernel
+	 * subsystems (like slab allocator) are available.
+	 */
+	cma = &cma_areas[cma_area_count];
+	cma->base_pfn = PFN_DOWN(base);
+	cma->count = size >> PAGE_SHIFT;
+	cma->order_per_bit = order_per_bit;
+	*res_cma = cma;
+	cma_area_count++;
+
+	return 0;
+}
+
+/**
  * cma_declare_contiguous() - reserve custom contiguous area
  * @base: Base address of the reserved area optional, use 0 for any
  * @size: Size of the reserved area (in bytes),
@@ -163,7 +211,6 @@ int __init cma_declare_contiguous(phys_addr_t base,
 			phys_addr_t alignment, unsigned int order_per_bit,
 			bool fixed, struct cma **res_cma)
 {
-	struct cma *cma;
 	phys_addr_t memblock_end = memblock_end_of_DRAM();
 	phys_addr_t highmem_start = __pa(high_memory);
 	int ret = 0;
@@ -235,16 +282,9 @@ int __init cma_declare_contiguous(phys_addr_t base,
 		}
 	}
 
-	/*
-	 * Each reserved area must be initialised later, when more kernel
-	 * subsystems (like slab allocator) are available.
-	 */
-	cma = &cma_areas[cma_area_count];
-	cma->base_pfn = PFN_DOWN(base);
-	cma->count = size >> PAGE_SHIFT;
-	cma->order_per_bit = order_per_bit;
-	*res_cma = cma;
-	cma_area_count++;
+	ret = cma_init_reserved_mem(base, size, order_per_bit, res_cma);
+	if (ret)
+		goto err;
 
 	pr_info("Reserved %ld MiB at %08lx\n", (unsigned long)size / SZ_1M,
 		(unsigned long)base);
-- 
1.9.2

