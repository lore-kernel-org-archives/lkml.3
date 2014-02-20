Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbaBTKxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:53:08 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:9712 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbaBTKxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:53:00 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-4e-5305de8935c1
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-mm-sig@lists.linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mackerras <paulus@samba.org>
Subject: [PATCH v4 3/7] drivers: dma-contiguous: add initialization from device
 tree
Date: Thu, 20 Feb 2014 11:52:43 +0100
Message-id: <1392893567-31623-4-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392893567-31623-1-git-send-email-m.szyprowski@samsung.com>
References: <1392893567-31623-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAyXRa0iTYRjG8Z7tPTkavC6NNwmTlXRC0wh7MokIiSciCSYhgeScSyU3ZWvS
	gkh0mpvnhTjE1obahzG1ZngYRW4utaSYeVimTsvRUJenSVlOyeG338X9/3ZTbF4dFkHlSu+L
	ZVJhHp/gYMM7g2MxajcuiJusPw+3tQMkXC0uZcOVF5UAPnd8xmGNz4jDvkAPgL6qcgz2ti8D
	+KnYR8JutY6EG2PfWdAyP4FDY1kLBketTQRsc8yQ8OWCjQVbXSMsaBhU4TDQEAk/uvwENDua
	SVjb0IbB0rcOEm53WzC4aCvDYIduCYMmawDAhbUh7PJhZNabAdr6pwVo6WktQKPVVSzU2zhD
	okqfCkcWk5pA0xNvCNTZ8hhN7cyz0dhQMY7aA4ssVLMdh55ZqwGqfm0CyG+JvBl6m5OUJc7L
	LRTLzlzK4OS0fp0jC3QxD0o+GEARUEVrQAjF0OeYLz+6sD0fZJzuDkIDOBSPbgWMba4C3xsV
	LMZZ5yGDFUHHM5pfGiLoMNoIGL8eC0ZsepZgykcqWcHDAfoWszLu3TVFYXQ0s2yVBsmlEfN+
	LS1Iho5imrRJwTiEvsaUuGfwoHm7hbVxFK8FXAPYZwLhYoWoQJ6ZLYmPlQslcoU0O1aUL7GA
	vTdu9IDmgUQ7oCnA389Nc2ECHi4slCsldsBQbH4Yt2sSF/C4WULlQ7Es/45MkSeW2wGLCoko
	AsfOKqwXRSZPYjK9eiHVcCJrqdXu1FccCeOZQzfv1aScDK9r8xolx3sUdj0pULrT/mRrlTa2
	c0rc59MVqW78XuV3P/EPpwYcjZ3J6un+aM/fn5lXEqI207lJ7fId5aPT7zIO3TV883r7jVvL
	40dF7Ospr9br1696ZksD6QkuPibPEcafYsvkwv+Hdgt3pAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor internal dma_contiguous_init_reserved_mem() function, which
creates CMA area from previously reserved memory region and add support
for handling 'shared-dma-pool' reserved-memory device tree nodes.

Based on previous code provided by Josh Cartwright <joshc@codeaurora.org>

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/base/dma-contiguous.c |  130 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 108 insertions(+), 22 deletions(-)

diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
index 165c2c299e57..5dfcc3743d9b 100644
--- a/drivers/base/dma-contiguous.c
+++ b/drivers/base/dma-contiguous.c
@@ -182,6 +182,49 @@ static int __init cma_init_reserved_areas(void)
 core_initcall(cma_init_reserved_areas);
 
 /**
+ * dma_contiguous_init_reserved_mem() - reserve custom contiguous area
+ * @size: Size of the reserved area (in bytes),
+ * @base: Base address of the reserved area optional, use 0 for any
+ * @limit: End address of the reserved memory (optional, 0 for any).
+ * @res_cma: Pointer to store the created cma region.
+ *
+ * This function reserves memory from early allocator. It should be
+ * called by arch specific code once the early allocator (memblock or bootmem)
+ * has been activated and all other subsystems have already allocated/reserved
+ * memory. This function allows to create custom reserved areas for specific
+ * devices.
+ */
+static int __init dma_contiguous_init_reserved_mem(phys_addr_t size,
+					phys_addr_t base, struct cma **res_cma)
+{
+	struct cma *cma = &cma_areas[cma_area_count];
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
+	/* Sanitise input arguments */
+	alignment = PAGE_SIZE << max(MAX_ORDER - 1, pageblock_order);
+	if (ALIGN(base, alignment) != base || ALIGN(size, alignment) != size)
+		return -EINVAL;
+
+	cma->base_pfn = PFN_DOWN(base);
+	cma->count = size >> PAGE_SHIFT;
+	*res_cma = cma;
+	cma_area_count++;
+
+	/* Architecture specific contiguous memory fixup. */
+	dma_contiguous_early_fixup(base, size);
+	return 0;
+}
+
+/**
  * dma_contiguous_reserve_area() - reserve custom contiguous area
  * @size: Size of the reserved area (in bytes),
  * @base: Base address of the reserved area optional, use 0 for any
@@ -197,7 +240,6 @@ core_initcall(cma_init_reserved_areas);
 int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
 				       phys_addr_t limit, struct cma **res_cma)
 {
-	struct cma *cma = &cma_areas[cma_area_count];
 	phys_addr_t alignment;
 	int ret = 0;
 
@@ -205,12 +247,6 @@ int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
 		 (unsigned long)size, (unsigned long)base,
 		 (unsigned long)limit);
 
-	/* Sanity checks */
-	if (cma_area_count == ARRAY_SIZE(cma_areas)) {
-		pr_err("Not enough slots for CMA reserved regions!\n");
-		return -ENOSPC;
-	}
-
 	if (!size)
 		return -EINVAL;
 
@@ -241,21 +277,12 @@ int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
 		}
 	}
 
-	/*
-	 * Each reserved area must be initialised later, when more kernel
-	 * subsystems (like slab allocator) are available.
-	 */
-	cma->base_pfn = PFN_DOWN(base);
-	cma->count = size >> PAGE_SHIFT;
-	*res_cma = cma;
-	cma_area_count++;
-
-	pr_info("CMA: reserved %ld MiB at %08lx\n", (unsigned long)size / SZ_1M,
-		(unsigned long)base);
-
-	/* Architecture specific contiguous memory fixup. */
-	dma_contiguous_early_fixup(base, size);
-	return 0;
+	ret = dma_contiguous_init_reserved_mem(size, base, res_cma);
+	if (ret == 0) {
+		pr_info("CMA: reserved %ld MiB at %08lx\n",
+			(unsigned long)size / SZ_1M, (unsigned long)base);
+		return 0;
+	}
 err:
 	pr_err("CMA: failed to reserve %ld MiB\n", (unsigned long)size / SZ_1M);
 	return ret;
@@ -357,3 +384,62 @@ bool dma_release_from_contiguous(struct device *dev, struct page *pages,
 
 	return true;
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
+static void rmem_cma_device_init(struct reserved_mem *rmem,
+			 struct device *dev, struct of_phandle_args *args)
+{
+	struct cma *cma = rmem->priv;
+	dev_set_cma_area(dev, cma);
+}
+
+static const struct reserved_mem_ops rmem_cma_ops = {
+	.device_init	= rmem_cma_device_init,
+};
+
+static int __init rmem_cma_setup(struct reserved_mem *rmem,
+				 unsigned long node,
+				 const char *uname)
+{
+	phys_addr_t align = PAGE_SIZE << max(MAX_ORDER - 1, pageblock_order);
+	phys_addr_t mask = align - 1;
+	struct cma *cma;
+	int err;
+
+	if (!of_get_flat_dt_prop(node, "reusable", NULL))
+		return -EINVAL;
+
+	if ((rmem->base & mask) || (rmem->size & mask)) {
+		pr_err("Reserved memory: incorrect alignment of CMA region\n");
+		return -EINVAL;
+	}
+
+	err = dma_contiguous_init_reserved_mem(rmem->size, rmem->base, &cma);
+	if (err) {
+		pr_err("Reserved memory: unable to setup CMA region\n");
+		return err;
+	}
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
-- 
1.7.9.5

