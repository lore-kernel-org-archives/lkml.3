Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866Ab3HAWZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 18:25:46 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39864 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab3HAWZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 18:25:44 -0400
In-Reply-To: <20130801213420.GL23006@n2100.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk>
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: [PATCH RFC 51/51] ARM: 7805/1: mm: change max*pfn to include the
 physical offset of memory
Message-Id: <E1V51J5-0006uq-1h@rmk-PC.arm.linux.org.uk>
Date: Thu, 01 Aug 2013 23:25:15 +0100
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

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/include/asm/dma-mapping.h |    8 ++++++++
 arch/arm/mm/init.c                 |   10 ++++------
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
index 5b579b9..863cd84 100644
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@ -64,6 +64,7 @@ static inline dma_addr_t virt_to_dma(struct device *dev, void *addr)
 {
 	return (dma_addr_t)__virt_to_bus((unsigned long)(addr));
 }
+
 #else
 static inline dma_addr_t pfn_to_dma(struct device *dev, unsigned long pfn)
 {
@@ -86,6 +87,13 @@ static inline dma_addr_t virt_to_dma(struct device *dev, void *addr)
 }
 #endif
 
+/* The ARM override for dma_max_pfn() */
+static inline unsigned long dma_max_pfn(struct device *dev)
+{
+	return PHYS_PFN_OFFSET + dma_to_pfn(dev, *dev->dma_mask);
+}
+#define dma_max_pfn(dev) dma_max_pfn(dev)
+
 /*
  * DMA errors are defined by all-bits-set in the DMA address.
  */
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index b5b5836..2731dcf 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -422,12 +422,10 @@ void __init bootmem_init(void)
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
@@ -533,7 +531,7 @@ static inline void free_area_high(unsigned long pfn, unsigned long end)
 static void __init free_highpages(void)
 {
 #ifdef CONFIG_HIGHMEM
-	unsigned long max_low = max_low_pfn + PHYS_PFN_OFFSET;
+	unsigned long max_low = max_low_pfn;
 	struct memblock_region *mem, *res;
 
 	/* set highmem page free */
-- 
1.7.4.4

