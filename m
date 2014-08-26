Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925AbaHZMOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 08:14:05 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:17890 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757771AbaHZMNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 08:13:55 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-82-53fc7a001500
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
Subject: [PATCH 4/7] drivers: dma-contiguous: add initialization from device
 tree
Date: Tue, 26 Aug 2014 14:09:45 +0200
Message-id: <1409054988-32758-5-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1409054988-32758-1-git-send-email-m.szyprowski@samsung.com>
References: <1409054988-32758-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNLMWRmVeSWpSXmKPExsVy+t/xa7oMVX+CDb7tkbf4O+kYu8WBPzsY
	LVZ2N7NZ7Fz3jtHibNMbdovtnTPYLb5cechksenxNVaLy7vmsFn0bNjKajHj/D4mi7VH7rJb
	LDjewmqxfsZrFgc+j9+/JjF6XO7rZfLoenuFyePOtT1sHpuX1Hvc/veY2WPdn1dMHn1bVjF6
	fN4kF8AZxWWTkpqTWZZapG+XwJXx8/IxxoJThhWn969gbmC8qtHFyMkhIWAisevUd1YIW0zi
	wr31bF2MXBxCAksZJdYt/MwE4fQxSfxdsZAdpIpNwFCi620XG4gtIpAt8ePbZBYQm1lgKbPE
	vFlSILawQLBE87SfTCA2i4CqxMLJF8F6eQU8JM5OfM4EsU1O4v/LFUA2BwengKfEuSnVIGEh
	oJKN09+zTGDkXcDIsIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjJIC/7GBcfMzqEKMAB6MS
	D++Hkt/BQqyJZcWVuYcYJTiYlUR4fyT9CRbiTUmsrEotyo8vKs1JLT7EyMTBKdXAWCL/OMxM
	+UzF599Zd3UCb4n7Pfhh+/VC1+0YP1GWA9NuitQdf107i8fda0/vL7u9D8TjmKpeP3Yo4PJ8
	uWuX++0+e/aj8VzLq0PzLi85Z/PUuPqjxI8/WsGKS9+ELRNwaK28sEGoR9nrYeYa+1Nn17V+
	unb5+bNrV/j9H5vvntdjG2itN3fSayWW4oxEQy3mouJEANnA7yw+AgAA
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
index 6606abdf880c..eefb81b85b42 100644
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
index 371b93042520..0430ed05d3b9 100644
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
index 4acc6aa4a086..d0065af4f000 100644
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

