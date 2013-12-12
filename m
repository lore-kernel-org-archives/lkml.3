Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab3LLH6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 02:58:17 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:1528 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab3LLH6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:58:11 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 12 Dec 2013 00:00:50 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>, <swarren@nvidia.com>,
        <will.deacon@arm.com>, <grant.likely@linaro.org>,
        <thierry.reding@gmail.com>, <robherring2@gmail.com>, <joro@8bytes.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, <lorenzo.pieralisi@arm.com>,
        <linux-kernel@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
        <galak@codeaurora.org>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCHv7 02/12] iommu/of: introduce a global iommu device list
Date: Thu, 12 Dec 2013 09:57:03 +0200
Message-ID: <1386835033-4701-3-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1386835033-4701-1-git-send-email-hdoyu@nvidia.com>
References: <1386835033-4701-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables to find an populated IOMMU device via a device node. This
can be used to see if an dependee IOMMU is populated or not to keep
correct device population order. Client devices need to wait an IOMMU
to be populated.

Suggested by Thierry Reding and copied his example code.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Thierry Reding <thierry.reding@gmail.com>
---
v6:
New for v6.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 drivers/iommu/of_iommu.c | 37 +++++++++++++++++++++++++++++++++++++
 include/linux/of_iommu.h | 16 ++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/drivers/iommu/of_iommu.c b/drivers/iommu/of_iommu.c
index ee249bc..5d1aeb9 100644
--- a/drivers/iommu/of_iommu.c
+++ b/drivers/iommu/of_iommu.c
@@ -20,6 +20,43 @@
 #include <linux/export.h>
 #include <linux/limits.h>
 #include <linux/of.h>
+#include <linux/of_iommu.h>
+#include <linux/device.h>
+
+static DEFINE_MUTEX(iommus_lock);
+static LIST_HEAD(iommus_list);
+
+void iommu_add(struct iommu *iommu)
+{
+	INIT_LIST_HEAD(&iommu->list);
+	mutex_lock(&iommus_lock);
+	list_add_tail(&iommu->list, &iommus_list);
+	mutex_unlock(&iommus_lock);
+}
+
+void iommu_del(struct iommu *iommu)
+{
+	INIT_LIST_HEAD(&iommu->list);
+	mutex_lock(&iommus_lock);
+	list_del(&iommu->list);
+	mutex_unlock(&iommus_lock);
+}
+
+static struct iommu *of_find_iommu_by_node(struct device_node *np)
+{
+	struct iommu *iommu;
+
+	mutex_lock(&iommus_lock);
+	list_for_each_entry(iommu, &iommus_list, list) {
+		if (iommu->dev->of_node == np) {
+			mutex_unlock(&iommus_lock);
+			return iommu;
+		}
+	}
+	mutex_unlock(&iommus_lock);
+
+	return NULL;
+}
 
 /**
  * of_get_dma_window - Parse *dma-window property and returns 0 if found.
diff --git a/include/linux/of_iommu.h b/include/linux/of_iommu.h
index 51a560f..a0aa9d4 100644
--- a/include/linux/of_iommu.h
+++ b/include/linux/of_iommu.h
@@ -3,10 +3,18 @@
 
 #ifdef CONFIG_OF_IOMMU
 
+struct iommu {
+	struct list_head list;
+	struct device *dev;
+};
+
 extern int of_get_dma_window(struct device_node *dn, const char *prefix,
 			     int index, unsigned long *busno, dma_addr_t *addr,
 			     size_t *size);
 
+extern void iommu_add(struct iommu *iommu);
+extern void iommu_del(struct iommu *iommu);
+
 #else
 
 static inline int of_get_dma_window(struct device_node *dn, const char *prefix,
@@ -16,6 +24,14 @@ static inline int of_get_dma_window(struct device_node *dn, const char *prefix,
 	return -EINVAL;
 }
 
+static inline void iommu_add(struct iommu *iommu)
+{
+}
+
+static inline void iommu_del(struct iommu *iommu)
+{
+}
+
 #endif	/* CONFIG_OF_IOMMU */
 
 #endif /* __OF_IOMMU_H */
-- 
1.8.1.5

