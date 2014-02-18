Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbaBRNjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 08:39:25 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:21979 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbaBRNjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 08:39:23 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-ef-530362899658
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-mm-sig@lists.linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
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
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>
Subject: [PATCH v3 1/6] base: dma-contiguous: add
 dma_contiguous_init_reserved_mem() function
Date: Tue, 18 Feb 2014 14:37:56 +0100
Message-id: <1392730681-14695-2-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392730681-14695-1-git-send-email-m.szyprowski@samsung.com>
References: <1392730681-14695-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAIsWRmVeSWpSXmKPExsVy+t9jAd3OJOZggxXNYhZ/Jx1jt/jQ1Mps
	Mf/IOVaL/jcLWS0O/NnBaPGmt4PFYue6d4wWZ5vesFts75zBbvHlykMmi02Pr7FaLGxbwmJx
	edccNou1R+6yW2x4eZDJYun1i0wWC463sFr8mS5ncer6ZzaLCdPXsli07j3CbvF3+yYWi1cH
	21gs1s94zWKxatcfRgdJjzXz1jB6/P41idHj9eQJjB6X+3qZPHbOusvu0fOmhdVj06pONo87
	1/aweWxeUu9x+99jZo8rJ5pYPdb9ecXk0f/XwKNvyypGj8+b5Dw2zg0NEIjisklJzcksSy3S
	t0vgyvg+9xlzwW21irP7P7E1MD6W72Lk5JAQMJF4PnkxG4QtJnHh3nogm4tDSGARo8TVv3eg
	nFYmiSvfprOAVLEJGEp0ve0C6xARWMgo8XkeC0gRs8B0NonFW9+DJYQF4iXer77BDmKzCKhK
	zNkyEczmFfCQaL0/B6iGA2idgsScSTYgJqeAp8SX6zogFUJAFVvvP2aewMi7gJFhFaNoakFy
	QXFSeq6hXnFibnFpXrpecn7uJkZwvD2T2sG4ssHiEKMAB6MSD+8HZaZgIdbEsuLK3EOMEhzM
	SiK8mlHMwUK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7RaBwoJpCeWpGanphakFsFkmTg4pRoY
	z/w93O5fdtipLEorWWOf0Pv9wS92z/0QfJQz8tNXj/daLfGcUvZZ384b+18/GCc01/jsPB8V
	VxfV9yvPeL7YzqqvP7XF33R5kYb1vFd9Qpm6jMcu7JmwN+WKXmZ3peg5N4sFhnx9pcoCqbtk
	VvX+e3Jyd83ZFRcSP/3T7gx8EWPoJDAz4MhTJZbijERDLeai4kQAKfMYibMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new dma_contiguous_init_reserved_mem() function, which creates CMA area
from previously reserved memory region.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/base/dma-contiguous.c  |   70 +++++++++++++++++++++++++++-------------
 include/linux/dma-contiguous.h |    7 ++++
 2 files changed, 55 insertions(+), 22 deletions(-)

diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
index 165c2c299e57..ece82e8f3a8b 100644
--- a/drivers/base/dma-contiguous.c
+++ b/drivers/base/dma-contiguous.c
@@ -182,6 +182,53 @@ static int __init cma_init_reserved_areas(void)
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
+int __init dma_contiguous_init_reserved_mem(phys_addr_t size, phys_addr_t base,
+				       struct cma **res_cma)
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
+	pr_info("CMA: reserved %ld MiB at %08lx\n", (unsigned long)size / SZ_1M,
+		(unsigned long)base);
+
+	/* Architecture specific contiguous memory fixup. */
+	dma_contiguous_early_fixup(base, size);
+	return 0;
+}
+
+
+/**
  * dma_contiguous_reserve_area() - reserve custom contiguous area
  * @size: Size of the reserved area (in bytes),
  * @base: Base address of the reserved area optional, use 0 for any
@@ -197,7 +244,6 @@ core_initcall(cma_init_reserved_areas);
 int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
 				       phys_addr_t limit, struct cma **res_cma)
 {
-	struct cma *cma = &cma_areas[cma_area_count];
 	phys_addr_t alignment;
 	int ret = 0;
 
@@ -205,12 +251,6 @@ int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
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
 
@@ -241,21 +281,7 @@ int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
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
+	return dma_contiguous_init_reserved_mem(size, base, res_cma);
 err:
 	pr_err("CMA: failed to reserve %ld MiB\n", (unsigned long)size / SZ_1M);
 	return ret;
diff --git a/include/linux/dma-contiguous.h b/include/linux/dma-contiguous.h
index 3b28f937d959..550497393ae7 100644
--- a/include/linux/dma-contiguous.h
+++ b/include/linux/dma-contiguous.h
@@ -90,6 +90,8 @@ void dma_contiguous_reserve(phys_addr_t addr_limit);
 int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
 				       phys_addr_t limit, struct cma **res_cma);
 
+int dma_contiguous_init_reserved_mem(phys_addr_t size, phys_addr_t base,
+				     struct cma **res_cma);
 /**
  * dma_declare_contiguous() - reserve area for contiguous memory handling
  *			      for particular device
@@ -140,6 +142,11 @@ static inline int dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base
 	return -ENOSYS;
 }
 
+static inline int dma_contiguous_init_reserved_mem(phys_addr_t size,
+				phys_addr_t base, struct cma **res_cma) {
+	return -ENOSYS;
+}
+
 static inline
 int dma_declare_contiguous(struct device *dev, phys_addr_t size,
 			   phys_addr_t base, phys_addr_t limit)
-- 
1.7.9.5

