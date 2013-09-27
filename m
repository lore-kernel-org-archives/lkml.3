Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab3I0QL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 12:11:57 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:29435 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab3I0QKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 12:10:54 -0400
X-IronPort-AV: E=Sophos;i="4.90,994,1371081600"; 
   d="scan'208";a="55582483"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v6 07/19] swiotlb-xen: introduce xen_swiotlb_set_dma_mask
Date: Fri, 27 Sep 2013 17:09:55 +0100
Message-ID: <1380298207-29151-7-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1309271653420.5498@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1309271653420.5498@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement xen_swiotlb_set_dma_mask, use it for set_dma_mask on arm.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/xen/mm.c         |    1 +
 drivers/xen/swiotlb-xen.c |   12 ++++++++++++
 include/xen/swiotlb-xen.h |    2 ++
 3 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/arm/xen/mm.c b/arch/arm/xen/mm.c
index b065c98..4330b15 100644
--- a/arch/arm/xen/mm.c
+++ b/arch/arm/xen/mm.c
@@ -110,6 +110,7 @@ static struct dma_map_ops xen_swiotlb_dma_ops = {
 	.map_page = xen_swiotlb_map_page,
 	.unmap_page = xen_swiotlb_unmap_page,
 	.dma_supported = xen_swiotlb_dma_supported,
+	.set_dma_mask = xen_swiotlb_set_dma_mask,
 };
 
 int __init xen_mm_init(void)
diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index a1cb0f4..deb9131 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -754,3 +754,15 @@ xen_swiotlb_dma_supported(struct device *hwdev, u64 mask)
 	return xen_virt_to_bus(xen_io_tlb_end - 1) <= mask;
 }
 EXPORT_SYMBOL_GPL(xen_swiotlb_dma_supported);
+
+int
+xen_swiotlb_set_dma_mask(struct device *dev, u64 dma_mask)
+{
+	if (!dev->dma_mask || !xen_swiotlb_dma_supported(dev, dma_mask))
+		return -EIO;
+
+	*dev->dma_mask = dma_mask;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xen_swiotlb_set_dma_mask);
diff --git a/include/xen/swiotlb-xen.h b/include/xen/swiotlb-xen.h
index de8bcc6..7b64465 100644
--- a/include/xen/swiotlb-xen.h
+++ b/include/xen/swiotlb-xen.h
@@ -55,4 +55,6 @@ xen_swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr);
 extern int
 xen_swiotlb_dma_supported(struct device *hwdev, u64 mask);
 
+extern int
+xen_swiotlb_set_dma_mask(struct device *dev, u64 dma_mask);
 #endif /* __LINUX_SWIOTLB_XEN_H */
-- 
1.7.2.5

