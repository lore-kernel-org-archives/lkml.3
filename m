Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbaKJQQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 11:16:44 -0500
Received: from smtp.citrix.com ([66.165.176.89]:36052 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306AbaKJQPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 11:15:10 -0500
X-IronPort-AV: E=Sophos;i="5.07,353,1413244800"; 
   d="scan'208";a="189798980"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>,
        <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        <Stefano.Stabellini@eu.citrix.com>,
        <linux-arm-kernel@lists.infradead.org>, <catalin.marinas@arm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v8 07/13] xen: add a dma_addr_t dev_addr argument to xen_dma_map_page
Date: Mon, 10 Nov 2014 16:13:59 +0000
Message-ID: <1415636045-24669-7-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1411101607130.22875@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1411101607130.22875@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: david.vrabel@citrix.com
CC: konrad.wilk@oracle.com
---
 arch/arm/include/asm/xen/page-coherent.h   |    4 ++--
 arch/arm64/include/asm/xen/page-coherent.h |    4 ++--
 arch/x86/include/asm/xen/page-coherent.h   |    4 ++--
 drivers/xen/swiotlb-xen.c                  |    6 ++++--
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/arm/include/asm/xen/page-coherent.h b/arch/arm/include/asm/xen/page-coherent.h
index d97b0b4..25d450c 100644
--- a/arch/arm/include/asm/xen/page-coherent.h
+++ b/arch/arm/include/asm/xen/page-coherent.h
@@ -29,8 +29,8 @@ static inline void xen_free_coherent_pages(struct device *hwdev, size_t size,
 }
 
 static inline void xen_dma_map_page(struct device *hwdev, struct page *page,
-	     unsigned long offset, size_t size, enum dma_data_direction dir,
-	     struct dma_attrs *attrs)
+	     dma_addr_t dev_addr, unsigned long offset, size_t size,
+	     enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 	__generic_dma_ops(hwdev)->map_page(hwdev, page, offset, size, dir, attrs);
 }
diff --git a/arch/arm64/include/asm/xen/page-coherent.h b/arch/arm64/include/asm/xen/page-coherent.h
index dde3fc9..d7cd4c2 100644
--- a/arch/arm64/include/asm/xen/page-coherent.h
+++ b/arch/arm64/include/asm/xen/page-coherent.h
@@ -20,8 +20,8 @@ static inline void xen_free_coherent_pages(struct device *hwdev, size_t size,
 }
 
 static inline void xen_dma_map_page(struct device *hwdev, struct page *page,
-	     unsigned long offset, size_t size, enum dma_data_direction dir,
-	     struct dma_attrs *attrs)
+	     dma_addr_t dev_addr, unsigned long offset, size_t size,
+	     enum dma_data_direction dir, struct dma_attrs *attrs)
 {
 }
 
diff --git a/arch/x86/include/asm/xen/page-coherent.h b/arch/x86/include/asm/xen/page-coherent.h
index 7f02fe4..acd844c 100644
--- a/arch/x86/include/asm/xen/page-coherent.h
+++ b/arch/x86/include/asm/xen/page-coherent.h
@@ -22,8 +22,8 @@ static inline void xen_free_coherent_pages(struct device *hwdev, size_t size,
 }
 
 static inline void xen_dma_map_page(struct device *hwdev, struct page *page,
-	     unsigned long offset, size_t size, enum dma_data_direction dir,
-	     struct dma_attrs *attrs) { }
+	     dma_addr_t dev_addr, unsigned long offset, size_t size,
+	     enum dma_data_direction dir, struct dma_attrs *attrs) { }
 
 static inline void xen_dma_unmap_page(struct device *hwdev, dma_addr_t handle,
 		size_t size, enum dma_data_direction dir,
diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index ebd8f21..ad2c5eb 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -403,7 +403,7 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
 		/* we are not interested in the dma_addr returned by
 		 * xen_dma_map_page, only in the potential cache flushes executed
 		 * by the function. */
-		xen_dma_map_page(dev, page, offset, size, dir, attrs);
+		xen_dma_map_page(dev, page, dev_addr, offset, size, dir, attrs);
 		return dev_addr;
 	}
 
@@ -417,7 +417,7 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
 		return DMA_ERROR_CODE;
 
 	xen_dma_map_page(dev, pfn_to_page(map >> PAGE_SHIFT),
-					map & ~PAGE_MASK, size, dir, attrs);
+					dev_addr, map & ~PAGE_MASK, size, dir, attrs);
 	dev_addr = xen_phys_to_bus(map);
 
 	/*
@@ -574,6 +574,7 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 				return 0;
 			}
 			xen_dma_map_page(hwdev, pfn_to_page(map >> PAGE_SHIFT),
+						dev_addr,
 						map & ~PAGE_MASK,
 						sg->length,
 						dir,
@@ -584,6 +585,7 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 			 * xen_dma_map_page, only in the potential cache flushes executed
 			 * by the function. */
 			xen_dma_map_page(hwdev, pfn_to_page(paddr >> PAGE_SHIFT),
+						dev_addr,
 						paddr & ~PAGE_MASK,
 						sg->length,
 						dir,
-- 
1.7.10.4

