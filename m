Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab3AXLNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 06:13:47 -0500
Received: from kiruna.synopsys.com ([198.182.44.80]:51434 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab3AXLN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 06:13:27 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v3 66/71] ARC: [Review] Multi-platform image #6: cpu-to-dma-addr optional
Date: Thu, 24 Jan 2013 16:36:26 +0530
Message-ID: <1359025589-22277-43-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359025589-22277-1-git-send-email-vgupta@synopsys.com>
References: <1359025589-22277-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the current platforms can work with 0x8000_0000 based dma_addr_t
since the Bus Bridges typically ignore the top bit (the only excpetion
was Angel4 PCI-AHM bridge which we no longer care for).
That way we don't need plat-specific cpu-addr to bus-addr conversion.

Hooks still provided - just in case a platform has an obscure device
which say needs 0 based bus address.

That way <asm/dma_mapping.h> no longer needs to unconditinally include
<plat/dma_addr.h>

Also verfied that on Angel4 board, other peripherals (IDE-disk / EMAC)
work fine with 0x8000_0000 based dma addresses.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arc/Kconfig                              |    4 ++
 arch/arc/include/asm/dma-mapping.h            |   16 +++++++++
 arch/arc/plat-arcfpga/include/plat/dma_addr.h |   45 -------------------------
 3 files changed, 20 insertions(+), 45 deletions(-)
 delete mode 100644 arch/arc/plat-arcfpga/include/plat/dma_addr.h

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index ac17368..be85ceb 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -119,6 +119,10 @@ config CPU_BIG_ENDIAN
 	help
 	  Build kernel for Big Endian Mode of ARC CPU
 
+# If a platform can't work with 0x8000_0000 based dma_addr_t
+config ARC_PLAT_NEEDS_CPU_TO_DMA
+	bool
+
 config SMP
 	bool "Symmetric Multi-Processing (Incomplete)"
 	default n
diff --git a/arch/arc/include/asm/dma-mapping.h b/arch/arc/include/asm/dma-mapping.h
index 7fd150e..31f77ae 100644
--- a/arch/arc/include/asm/dma-mapping.h
+++ b/arch/arc/include/asm/dma-mapping.h
@@ -13,7 +13,23 @@
 
 #include <asm-generic/dma-coherent.h>
 #include <asm/cacheflush.h>
+
+#ifndef CONFIG_ARC_PLAT_NEEDS_CPU_TO_DMA
+/*
+ * dma_map_* API take cpu addresses, which is kernel logical address in the
+ * untranslated address space (0x8000_0000) based. The dma address (bus addr)
+ * ideally needs to be 0x0000_0000 based hence these glue routines.
+ * However given that intermediate bus bridges can ignore the high bit, we can
+ * do with these routines being no-ops.
+ * If a platform/device comes up which sriclty requires 0 based bus addr
+ * (e.g. AHB-PCI bridge on Angel4 board), then it can provide it's own versions
+ */
+#define plat_dma_addr_to_kernel(dev, addr) ((unsigned long)(addr))
+#define plat_kernel_addr_to_dma(dev, ptr) ((dma_addr_t)(ptr))
+
+#else
 #include <plat/dma_addr.h>
+#endif
 
 void *dma_alloc_noncoherent(struct device *dev, size_t size,
 			    dma_addr_t *dma_handle, gfp_t gfp);
diff --git a/arch/arc/plat-arcfpga/include/plat/dma_addr.h b/arch/arc/plat-arcfpga/include/plat/dma_addr.h
deleted file mode 100644
index 0e96343..0000000
--- a/arch/arc/plat-arcfpga/include/plat/dma_addr.h
+++ /dev/null
@@ -1,45 +0,0 @@
-/*
- * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * vineetg: Feb 2009
- *  -For AA4 board, kernel to DMA address APIs
- */
-
-/*
- * kernel addresses are 0x800_000 based, while Bus addr are 0 based
- */
-
-#ifndef __PLAT_DMA_ADDR_H
-#define __PLAT_DMA_ADDR_H
-
-#include <linux/device.h>
-
-static inline unsigned long plat_dma_addr_to_kernel(struct device *dev,
-						    dma_addr_t dma_addr)
-{
-	return dma_addr + PAGE_OFFSET;
-}
-
-static inline dma_addr_t plat_kernel_addr_to_dma(struct device *dev, void *ptr)
-{
-	unsigned long addr = (unsigned long)ptr;
-	/*
-	 * To Catch buggy drivers which can call DMA map API with kernel vaddr
-	 * i.e. for buffers alloc via vmalloc or ioremap which are not
-	 * gaurnateed to be PHY contiguous and hence unfit for DMA anyways.
-	 * On ARC kernel virtual address is 0x7000_0000 to 0x7FFF_FFFF, so
-	 * ideally we want to check this range here, but our implementation is
-	 * better as it checks for even worse user virtual address as well.
-	 */
-	if (likely(addr >= PAGE_OFFSET))
-		return addr - PAGE_OFFSET;
-
-	BUG();
-	return addr;
-}
-
-#endif
-- 
1.7.4.1

