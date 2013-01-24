Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab3AXNSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 08:18:31 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12782 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab3AXNSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 08:18:23 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 24 Jan 2013 05:16:05 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, Russell King <linux@arm.linux.org.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] ARM: dma-mapping: Add arm_iommu_detach_device()
Date: Thu, 24 Jan 2013 15:16:57 +0200
Message-ID: <1359033425-6674-2-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359033425-6674-1-git-send-email-hdoyu@nvidia.com>
References: <1359033425-6674-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A counter part of arm_iommu_attach_device().

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 arch/arm/include/asm/dma-iommu.h |    1 +
 arch/arm/mm/dma-mapping.c        |   25 +++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/arch/arm/include/asm/dma-iommu.h b/arch/arm/include/asm/dma-iommu.h
index 799b094..af1ac4ed 100644
--- a/arch/arm/include/asm/dma-iommu.h
+++ b/arch/arm/include/asm/dma-iommu.h
@@ -29,6 +29,7 @@ void arm_iommu_release_mapping(struct dma_iommu_mapping *mapping);
 
 int arm_iommu_attach_device(struct device *dev,
 					struct dma_iommu_mapping *mapping);
+void arm_iommu_detach_device(struct device *dev);
 
 #endif /* __KERNEL__ */
 #endif
diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 6b2fb87..b075a1f 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -1842,4 +1842,29 @@ int arm_iommu_attach_device(struct device *dev,
 	return 0;
 }
 
+/**
+ * arm_iommu_detach_device
+ * @dev: valid struct device pointer
+ *
+ * Detaches the provided device from a previously attached map.
+ * This voids the dma operations (dma_map_ops pointer)
+ */
+void arm_iommu_detach_device(struct device *dev)
+{
+	struct dma_iommu_mapping *mapping;
+
+	mapping = to_dma_iommu_mapping(dev);
+	if (!mapping) {
+		dev_warn(dev, "Not attached\n");
+		return;
+	}
+
+	iommu_detach_device(mapping->domain, dev);
+	kref_put(&mapping->kref, release_iommu_mapping);
+	mapping = NULL;
+	set_dma_ops(dev, NULL);
+
+	pr_debug("Detached IOMMU controller from %s device.\n", dev_name(dev));
+}
+
 #endif
-- 
1.7.9.5

