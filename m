Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab3J3BSZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 21:18:25 -0400
Received: from smtp.citrix.com ([66.165.176.89]:21414 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab3J3BSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 21:18:24 -0400
X-IronPort-AV: E=Sophos;i="4.93,597,1378857600"; 
   d="scan'208";a="68694906"
Date: Wed, 30 Oct 2013 01:17:14 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <Ian.Campbell@citrix.com>,
        <will.deacon@arm.com>
Subject: Re: [PATCH v9 01/18] arm: make SWIOTLB available
In-Reply-To: <20131029180105.GR16735@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.02.1310300112520.26077@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1310251144020.26077@kaball.uk.xensource.com> <1382698313-13161-1-git-send-email-stefano.stabellini@eu.citrix.com> <alpine.DEB.2.02.1310251206450.26077@kaball.uk.xensource.com> <alpine.DEB.2.02.1310290441260.26077@kaball.uk.xensource.com>
 <20131029142023.GE20487@phenom.dumpdata.com> <20131029142626.GQ16735@n2100.arm.linux.org.uk> <alpine.DEB.2.02.1310291716120.26077@kaball.uk.xensource.com> <20131029180105.GR16735@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Oct 2013, Russell King - ARM Linux wrote:
> So... what I'm saying is please fix xgmac to use the DMA API properly
> rather than working around such problems. :)
 
OK.
Would the appended patch fix your concerns?

---

arm: make SWIOTLB available

IOMMU_HELPER is needed because SWIOTLB calls iommu_is_span_boundary,
provided by lib/iommu_helper.c.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Changes in v9:
- remove uneeded include asm/cacheflush.h;
- just return 0 if !dev->dma_mask in dma_capable.

---
 arch/arm/Kconfig                   |    6 ++++++
 arch/arm/include/asm/dma-mapping.h |   33 +++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 1ad6fb6..b08374f 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1872,6 +1872,12 @@ config CC_STACKPROTECTOR
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
index 5b579b9..1ad2c17 100644
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@ -86,6 +86,39 @@ static inline dma_addr_t virt_to_dma(struct device *dev, void *addr)
 }
 #endif
 
+static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
+{
+	unsigned int offset = paddr & ~PAGE_MASK;
+	return pfn_to_dma(dev, __phys_to_pfn(paddr)) + offset;
+}
+
+static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t dev_addr)
+{
+	unsigned int offset = dev_addr & ~PAGE_MASK;
+	return __pfn_to_phys(dma_to_pfn(dev, dev_addr)) + offset;
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
+static inline void dma_mark_clean(void *addr, size_t size) { }
+
 /*
  * DMA errors are defined by all-bits-set in the DMA address.
  */
-- 
1.7.2.5

