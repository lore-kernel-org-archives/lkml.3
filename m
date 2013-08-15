Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab3HOLMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 07:12:44 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:19433 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464Ab3HOLLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 07:11:05 -0400
X-IronPort-AV: E=Sophos;i="4.89,885,1367971200"; 
   d="scan'208";a="42396944"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <will.deacon@arm.com>, <linux@arm.linux.org.uk>
Subject: [PATCH v4 03/10] arm: make SWIOTLB available
Date: Thu, 15 Aug 2013 12:10:47 +0100
Message-ID: <1376565054-24153-3-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1308151200580.4470@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1308151200580.4470@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IOMMU_HELPER is needed because SWIOTLB calls iommu_is_span_boundary,
provided by lib/iommu_helper.c.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: will.deacon@arm.com
CC: linux@arm.linux.org.uk


Changes in v3:
- dma_capable: do not treat dma_mask as a limit;
- remove SWIOTLB dependency on NEED_SG_DMA_LENGTH.
---
 arch/arm/Kconfig                   |    6 ++++++
 arch/arm/include/asm/dma-mapping.h |   30 ++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

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
index 5b579b9..5b8eef9 100644
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@ -86,6 +86,36 @@ static inline dma_addr_t virt_to_dma(struct device *dev, void *addr)
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
+	u64 limit, mask = *dev->dma_mask;
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
+}
+
 /*
  * DMA errors are defined by all-bits-set in the DMA address.
  */
-- 
1.7.2.5

