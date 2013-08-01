Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971Ab3HAWUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 18:20:43 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39843 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab3HAWUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 18:20:42 -0400
In-Reply-To: <20130801213420.GL23006@n2100.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH RFC 46/51] ARM: DMA-API: better handing of DMA masks for
 coherent allocations
Message-Id: <E1V51EE-0006uO-C2@rmk-PC.arm.linux.org.uk>
Date: Thu, 01 Aug 2013 23:20:14 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to start treating DMA masks as something which is specific to
the bus that the device resides on, otherwise we're going to hit all
sorts of nasty issues with LPAE and 32-bit DMA controllers in >32-bit
systems, where memory is offset from PFN 0.

In order to start doing this, we convert the DMA mask to a PFN using
the device specific dma_to_pfn() macro.  This is the reverse of the
pfn_to_dma() macro which is used to get the DMA address for the device.

This gives us a PFN mask, which we can then check against the PFN
limit of the DMA zone.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/mm/dma-mapping.c |   49 ++++++++++++++++++++++++++++++++++++++++----
 arch/arm/mm/init.c        |    2 +
 arch/arm/mm/mm.h          |    2 +
 3 files changed, 48 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 7f9b179..ef0efab 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -173,10 +173,30 @@ static u64 get_coherent_dma_mask(struct device *dev)
 			return 0;
 		}
 
-		if ((~mask) & (u64)arm_dma_limit) {
-			dev_warn(dev, "coherent DMA mask %#llx is smaller "
-				 "than system GFP_DMA mask %#llx\n",
-				 mask, (u64)arm_dma_limit);
+		/*
+		 * If the mask allows for more memory than we can address,
+		 * and we actually have that much memory, then fail the
+		 * allocation.
+		 */
+		if (sizeof(mask) != sizeof(dma_addr_t) &&
+		    mask > (dma_addr_t)~0 &&
+		    dma_to_pfn(dev, ~0) > arm_dma_pfn_limit) {
+			dev_warn(dev, "Coherent DMA mask %#llx is larger than dma_addr_t allows\n",
+				 mask);
+			dev_warn(dev, "Driver did not use or check the return value from dma_set_coherent_mask()?\n");
+			return 0;
+		}
+
+		/*
+		 * Now check that the mask, when translated to a PFN,
+		 * fits within the allowable addresses which we can
+		 * allocate.
+		 */
+		if (dma_to_pfn(dev, mask) < arm_dma_pfn_limit) {
+			dev_warn(dev, "Coherent DMA mask %#llx (pfn %#lx-%#lx) covers a smaller range of system memory than the DMA zone pfn 0x0-%#lx\n",
+				 mask,
+				 dma_to_pfn(dev, 0), dma_to_pfn(dev, mask) + 1,
+				 arm_dma_pfn_limit + 1);
 			return 0;
 		}
 	}
@@ -1008,8 +1028,27 @@ void arm_dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
  */
 int dma_supported(struct device *dev, u64 mask)
 {
-	if (mask < (u64)arm_dma_limit)
+	unsigned long limit;
+
+	/*
+	 * If the mask allows for more memory than we can address,
+	 * and we actually have that much memory, then we must
+	 * indicate that DMA to this device is not supported.
+	 */
+	if (sizeof(mask) != sizeof(dma_addr_t) &&
+	    mask > (dma_addr_t)~0 &&
+	    dma_to_pfn(dev, ~0) > arm_dma_pfn_limit)
+		return 0;
+
+	/*
+	 * Translate the device's DMA mask to a PFN limit.  This
+	 * PFN number includes the page which we can DMA to.
+	 */
+	limit = dma_to_pfn(dev, mask);
+
+	if (limit < arm_dma_pfn_limit)
 		return 0;
+
 	return 1;
 }
 EXPORT_SYMBOL(dma_supported);
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 15225d8..b5b5836 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -217,6 +217,7 @@ EXPORT_SYMBOL(arm_dma_zone_size);
  * so a successful GFP_DMA allocation will always satisfy this.
  */
 phys_addr_t arm_dma_limit;
+unsigned long arm_dma_pfn_limit;
 
 static void __init arm_adjust_dma_zone(unsigned long *size, unsigned long *hole,
 	unsigned long dma_size)
@@ -239,6 +240,7 @@ void __init setup_dma_zone(struct machine_desc *mdesc)
 		arm_dma_limit = PHYS_OFFSET + arm_dma_zone_size - 1;
 	} else
 		arm_dma_limit = 0xffffffff;
+	arm_dma_pfn_limit = arm_dma_limit >> PAGE_SHIFT;
 #endif
 }
 
diff --git a/arch/arm/mm/mm.h b/arch/arm/mm/mm.h
index d5a4e9a..d5a982d 100644
--- a/arch/arm/mm/mm.h
+++ b/arch/arm/mm/mm.h
@@ -81,8 +81,10 @@ extern __init void add_static_vm_early(struct static_vm *svm);
 
 #ifdef CONFIG_ZONE_DMA
 extern phys_addr_t arm_dma_limit;
+extern unsigned long arm_dma_pfn_limit;
 #else
 #define arm_dma_limit ((phys_addr_t)~0)
+#define arm_dma_pfn_limit (~0ul >> PAGE_SHIFT)
 #endif
 
 extern phys_addr_t arm_lowmem_limit;
-- 
1.7.4.4

