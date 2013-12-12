Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab3LLH6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 02:58:19 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:10169 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab3LLH6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:58:14 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 12 Dec 2013 00:00:54 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>, <swarren@nvidia.com>,
        <will.deacon@arm.com>, <grant.likely@linaro.org>,
        <thierry.reding@gmail.com>, <robherring2@gmail.com>, <joro@8bytes.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, <lorenzo.pieralisi@arm.com>,
        <linux-kernel@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
        <galak@codeaurora.org>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCHv7 03/12] iommu/of: check if dependee iommu is ready or not
Date: Thu, 12 Dec 2013 09:57:04 +0200
Message-ID: <1386835033-4701-4-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1386835033-4701-1-git-send-email-hdoyu@nvidia.com>
References: <1386835033-4701-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IOMMU devices on the bus need to be poplulated first, then iommu
master devices are done later.

With CONFIG_OF_IOMMU, "iommus=" DT binding would be used to identify
whether a device can be an iommu msater or not. If a device can, we'll
defer to populate that device till an depending iommu device is
populated.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
v6:
Spinned off only of_iommu part from:
  [PATCHv5 2/9] driver/core: populate devices in order for IOMMUs

v5:
Use "iommus=" binding instread of arm,smmu's "#stream-id-cells".

v4:
This is newly added, and the successor of the following RFC:
  [RFC][PATCHv3+ 1/2] driver/core: Add of_iommu_attach()
  http://lists.linuxfoundation.org/pipermail/iommu/2013-November/006914.html

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 drivers/iommu/of_iommu.c | 14 ++++++++++++++
 include/linux/of_iommu.h |  6 ++++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/iommu/of_iommu.c b/drivers/iommu/of_iommu.c
index 5d1aeb9..557c0c8 100644
--- a/drivers/iommu/of_iommu.c
+++ b/drivers/iommu/of_iommu.c
@@ -125,3 +125,17 @@ int of_get_dma_window(struct device_node *dn, const char *prefix, int index,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(of_get_dma_window);
+
+int of_iommu_attach(struct device *dev)
+{
+	const __be32 *cur, *end;
+	struct of_phandle_args args;
+
+	of_property_for_each_phandle_with_args(dev->of_node, "iommus",
+				       "#iommu-cells", 0, args, cur, end) {
+		if (!of_find_iommu_by_node(args.np))
+			return -EPROBE_DEFER;
+	}
+
+	return 0;
+}
diff --git a/include/linux/of_iommu.h b/include/linux/of_iommu.h
index a0aa9d4..14c9a5c 100644
--- a/include/linux/of_iommu.h
+++ b/include/linux/of_iommu.h
@@ -14,6 +14,7 @@ extern int of_get_dma_window(struct device_node *dn, const char *prefix,
 
 extern void iommu_add(struct iommu *iommu);
 extern void iommu_del(struct iommu *iommu);
+extern int of_iommu_attach(struct device *dev);
 
 #else
 
@@ -32,6 +33,11 @@ static inline void iommu_del(struct iommu *iommu)
 {
 }
 
+static inline int of_iommu_attach(struct device *dev)
+{
+	return 0;
+}
+
 #endif	/* CONFIG_OF_IOMMU */
 
 #endif /* __OF_IOMMU_H */
-- 
1.8.1.5

