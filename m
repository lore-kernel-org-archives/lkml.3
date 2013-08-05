Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab3HEUnP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:43:15 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:50985 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331Ab3HEUnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:43:12 -0400
Message-ID: <8fa873d7a80eb81943487802b8c8b7f48f56bce2.1375733180.git.cmetcalf@tilera.com>
In-Reply-To: <cover.1375733180.git.cmetcalf@tilera.com>
References: <cover.1375733180.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 5 Aug 2013 16:06:20 -0400
Subject: [PATCH 16/20] tile PCI RC: add dma_get_required_mask()
To: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The standard kernel function dma_get_required_mask() uses the
highest DRAM address to determine if 32-bit or 64-bit DMA addressing
is needed.  This only works on architectures that have direct mapping
between the PA and the PCI address space, i.e. those that don't have
I/O TLBs or have I/O TLB but choose to use direct mapping.  Neither
of these are true for tilegx.  Whether to use 64-bit DMA should depend
on the PCI device's capability only, not on the amount of DRAM
installeds, so we now advertise a 64-bit DMA mask unconditionally.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/dma-mapping.h |  4 ++++
 arch/tile/kernel/pci-dma.c          | 18 ++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/arch/tile/include/asm/dma-mapping.h b/arch/tile/include/asm/dma-mapping.h
index 6da0540..bd8387d 100644
--- a/arch/tile/include/asm/dma-mapping.h
+++ b/arch/tile/include/asm/dma-mapping.h
@@ -20,6 +20,10 @@
 #include <linux/cache.h>
 #include <linux/io.h>
 
+#ifdef __tilegx__
+#define ARCH_HAS_DMA_GET_REQUIRED_MASK
+#endif
+
 extern struct dma_map_ops *tile_dma_map_ops;
 extern struct dma_map_ops *gx_pci_dma_map_ops;
 extern struct dma_map_ops *gx_legacy_pci_dma_map_ops;
diff --git a/arch/tile/kernel/pci-dma.c b/arch/tile/kernel/pci-dma.c
index d16cfc1..3570ff7 100644
--- a/arch/tile/kernel/pci-dma.c
+++ b/arch/tile/kernel/pci-dma.c
@@ -590,3 +590,21 @@ int dma_set_coherent_mask(struct device *dev, u64 mask)
 }
 EXPORT_SYMBOL(dma_set_coherent_mask);
 #endif
+
+#ifdef ARCH_HAS_DMA_GET_REQUIRED_MASK
+/*
+ * The generic dma_get_required_mask() uses the highest physical address
+ * (max_pfn) to provide the hint to the PCI drivers regarding 32-bit or
+ * 64-bit DMA configuration. Since TILEGx has I/O TLB/MMU, allowing the
+ * DMAs to use the full 64-bit PCI address space and not limited by
+ * the physical memory space, we always let the PCI devices use
+ * 64-bit DMA if they have that capability, by returning the 64-bit
+ * DMA mask here. The device driver has the option to use 32-bit DMA if
+ * the device is not capable of 64-bit DMA.
+ */
+u64 dma_get_required_mask(struct device *dev)
+{
+	return DMA_BIT_MASK(64);
+}
+EXPORT_SYMBOL_GPL(dma_get_required_mask);
+#endif
-- 
1.8.3.1

