Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965530Ab3GLVta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 17:49:30 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59153 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757641Ab3GLVtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 17:49:25 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: [RFC/RFT PATCH 4/5] ARM: mm: change max*pfn to include the physical offset of memory
Date: Fri, 12 Jul 2013 17:48:13 -0400
Message-ID: <1373665694-7580-5-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373665694-7580-1-git-send-email-santosh.shilimkar@ti.com>
References: <1373665694-7580-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the kernel code assumes that max*pfn is maximum pfns because
the physical start of memory is expected to be PFN0. Since this
assumption is not true on ARM architectures, the meaning of max*pfn
is number of memory pages. This is done to keep drivers happy which
are making use of of these variable to calculate the dma bounce limit
using dma_mask.

Now since we have a architecture override possibility for DMAable
maximum pfns, lets make meaning of max*pfns as maximum pnfs on ARM
as well.

In the patch, the dma_to_pfn/pfn_to_dma() pair is hacked to take care of
the physical memory offset. It is done this way just to enable testing
since its understood that it can come in way of single zImage.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 arch/arm/include/asm/dma-mapping.h |   16 ++++++++++++----
 arch/arm/mm/init.c                 |   10 ++++------
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
index 5b579b9..b2d5937 100644
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@ -47,12 +47,12 @@ static inline int dma_set_mask(struct device *dev, u64 mask)
 #ifndef __arch_pfn_to_dma
 static inline dma_addr_t pfn_to_dma(struct device *dev, unsigned long pfn)
 {
-	return (dma_addr_t)__pfn_to_bus(pfn);
+	return (dma_addr_t)__pfn_to_bus(pfn + PHYS_PFN_OFFSET);
 }
 
 static inline unsigned long dma_to_pfn(struct device *dev, dma_addr_t addr)
 {
-	return __bus_to_pfn(addr);
+	return __bus_to_pfn(addr) - PHYS_PFN_OFFSET;
 }
 
 static inline void *dma_to_virt(struct device *dev, dma_addr_t addr)
@@ -64,15 +64,16 @@ static inline dma_addr_t virt_to_dma(struct device *dev, void *addr)
 {
 	return (dma_addr_t)__virt_to_bus((unsigned long)(addr));
 }
+
 #else
 static inline dma_addr_t pfn_to_dma(struct device *dev, unsigned long pfn)
 {
-	return __arch_pfn_to_dma(dev, pfn);
+	return __arch_pfn_to_dma(dev, pfn + PHYS_PFN_OFFSET);
 }
 
 static inline unsigned long dma_to_pfn(struct device *dev, dma_addr_t addr)
 {
-	return __arch_dma_to_pfn(dev, addr);
+	return __arch_dma_to_pfn(dev, addr) - PHYS_PFN_OFFSET;
 }
 
 static inline void *dma_to_virt(struct device *dev, dma_addr_t addr)
@@ -86,6 +87,13 @@ static inline dma_addr_t virt_to_dma(struct device *dev, void *addr)
 }
 #endif
 
+/* The ARM override for dma_max_pfn() */
+static inline unsigned long dma_max_pfn(struct device *dev)
+{
+	return dma_to_pfn(dev, *dev->dma_mask);
+}
+#define dma_max_pfn(dev) dma_max_pfn(dev)
+
 /*
  * DMA errors are defined by all-bits-set in the DMA address.
  */
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 6833cbe..588a2c1 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -420,12 +420,10 @@ void __init bootmem_init(void)
 	 * This doesn't seem to be used by the Linux memory manager any
 	 * more, but is used by ll_rw_block.  If we can get rid of it, we
 	 * also get rid of some of the stuff above as well.
-	 *
-	 * Note: max_low_pfn and max_pfn reflect the number of _pages_ in
-	 * the system, not the maximum PFN.
 	 */
-	max_low_pfn = max_low - PHYS_PFN_OFFSET;
-	max_pfn = max_high - PHYS_PFN_OFFSET;
+	min_low_pfn = min;
+	max_low_pfn = max_low;
+	max_pfn = max_high;
 }
 
 /*
@@ -531,7 +529,7 @@ static inline void free_area_high(unsigned long pfn, unsigned long end)
 static void __init free_highpages(void)
 {
 #ifdef CONFIG_HIGHMEM
-	unsigned long max_low = max_low_pfn + PHYS_PFN_OFFSET;
+	unsigned long max_low = max_low_pfn;
 	struct memblock_region *mem, *res;
 
 	/* set highmem page free */
-- 
1.7.9.5

