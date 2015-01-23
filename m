Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbbAWWdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 17:33:18 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:59662 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbbAWWdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 17:33:15 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>
CC: Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH v4 6/6] arm: dma-mapping: updates to limit dma_mask and iommu mapping size
Date: Fri, 23 Jan 2015 17:32:39 -0500
Message-ID: <1422052359-12384-7-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422052359-12384-1-git-send-email-m-karicheri2@ti.com>
References: <1422052359-12384-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Limit the dma_mask to minimum of dma_mask and dma_base + size - 1.

Also arm_iommu_create_mapping() has size parameter of size_t and
arm_setup_iommu_dma_ops() can take a value higher than that. So
limit the size to SIZE_MAX.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 arch/arm/mm/dma-mapping.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 7864797..a1f9030 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -2004,6 +2004,13 @@ static bool arm_setup_iommu_dma_ops(struct device *dev, u64 dma_base, u64 size,
 	if (!iommu)
 		return false;
 
+	/*
+	 * currently arm_iommu_create_mapping() takes a max of size_t
+	 * for size param. So check this limit for now.
+	 */
+	if (size > SIZE_MAX)
+		return false;
+
 	mapping = arm_iommu_create_mapping(dev->bus, dma_base, size);
 	if (IS_ERR(mapping)) {
 		pr_warn("Failed to create %llu-byte IOMMU mapping for device %s\n",
@@ -2053,6 +2060,9 @@ void arch_setup_dma_ops(struct device *dev, u64 dma_base, u64 size,
 {
 	struct dma_map_ops *dma_ops;
 
+	/* limit dma_mask to the lower of the two values */
+	*dev->dma_mask = min((*dev->dma_mask), (dma_base + size - 1));
+
 	dev->archdata.dma_coherent = coherent;
 	if (arm_setup_iommu_dma_ops(dev, dma_base, size, iommu))
 		dma_ops = arm_get_iommu_dma_map_ops(coherent);
-- 
1.7.9.5

