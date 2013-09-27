Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab3I0QKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 12:10:54 -0400
Received: from smtp.citrix.com ([66.165.176.89]:22036 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402Ab3I0QKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 12:10:53 -0400
X-IronPort-AV: E=Sophos;i="4.90,994,1371081600"; 
   d="scan'208";a="58122164"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <will.deacon@arm.com>, <linux@arm.linux.org.uk>
Subject: [PATCH v6 01/19] arm: make SWIOTLB available
Date: Fri, 27 Sep 2013 17:09:49 +0100
Message-ID: <1380298207-29151-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1309271653420.5498@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1309271653420.5498@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IOMMU_HELPER is needed because SWIOTLB calls iommu_is_span_boundary,
provided by lib/iommu_helper.c.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: will.deacon@arm.com
CC: linux@arm.linux.org.uk


Changes in v6:
- check for dev->dma_mask being NULL in dma_capable.

Changes in v5:
- implement dma_mark_clean using dmac_flush_range.

Changes in v3:
- dma_capable: do not treat dma_mask as a limit;
- remove SWIOTLB dependency on NEED_SG_DMA_LENGTH.
---
 arch/arm/Kconfig                   |    6 +++++
 arch/arm/include/asm/dma-mapping.h |   37 ++++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index ba412e0..c0bfb33 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1832,6 +1832,12 @@ config CC_STACKPROTECTOR
 	  neutralized via a kernel panic.
 	  This feature requires gcc version 4.2 or above.
 
+config SWIOTLB
+	def_bool y
+
+config IOMMU_HELPER
+	def_bool SWIOTLB
+
 config XEN_DOM0
 	def_bool y
 	depends on XEN
diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
index 5b579b9..8807124 100644
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@ -10,6 +10,7 @@
 
 #include <asm-generic/dma-coherent.h>
 #include <asm/memory.h>
+#include <asm/cacheflush.h>
 
 #define DMA_ERROR_CODE	(~0)
 extern struct dma_map_ops arm_dma_ops;
@@ -86,6 +87,42 @@ static inline dma_addr_t virt_to_dma(struct device *dev, void *addr)
 }
 #endif
 
+static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
+{
+	unsigned int offset = paddr & ~PAGE_MASK;
+	return pfn_to_dma(dev, paddr >> PAGE_SHIFT) + offset;
+}
+
+static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t dev_addr)
+{
+	unsigned int offset = dev_addr & ~PAGE_MASK;
+	return (dma_to_pfn(dev, dev_addr) << PAGE_SHIFT) + offset;
+}
+
+static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
+{
+	u64 limit, mask;
+	
+	if (!dev->dma_mask)
+		return 0;
+
+	mask = *dev->dma_mask;
+
+	limit = (mask + 1) & ~mask;
+	if (limit && size > limit)
+		return 0;
+
+	if ((addr | (addr + size - 1)) & ~mask)
+		return 0;
+
+	return 1;
+}
+
+static inline void dma_mark_clean(void *addr, size_t size)
+{
+	dmac_flush_range(addr, addr + size);
+}
+
 /*
  * DMA errors are defined by all-bits-set in the DMA address.
  */
-- 
1.7.2.5

