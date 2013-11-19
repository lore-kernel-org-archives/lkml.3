Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab3KSJeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 04:34:13 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:5083 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab3KSJeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 04:34:07 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 19 Nov 2013 01:28:03 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <swarren@nvidia.com>, <will.deacon@arm.com>, <grant.likely@linaro.org>,
        <thierry.reding@gmail.com>, <swarren@wwwdotorg.org>,
        <galak@codeaurora.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <lorenzo.pieralisi@arm.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv5 2/9] driver/core: populate devices in order for IOMMUs
Date: Tue, 19 Nov 2013 11:33:06 +0200
Message-ID: <1384853593-32202-3-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384853593-32202-1-git-send-email-hdoyu@nvidia.com>
References: <1384853593-32202-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IOMMU devices on the bus need to be poplulated first, then iommu
master devices are done later.

With CONFIG_OF_IOMMU, "iommus=" DT binding would be used to identify
whether a device can be an iommu msater or not. If a device can, we'll
defer to populate that device till an iommu device is populated. Once
an iommu device is populated, "dev->bus->iommu_ops" is set in the
bus. Then, those defered iommu master devices are populated and
configured for IOMMU with help of the already populated iommu device
via iommu_ops->add_device(). Multiple IOMMUs can be listed on this
"iommus" binding so that a device can have multiple IOMMUs attached.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
v5:
Use "iommus=" binding instread of arm,smmu's "#stream-id-cells".

v4:
This is newly added, and the successor of the following RFC:
  [RFC][PATCHv3+ 1/2] driver/core: Add of_iommu_attach()
  http://lists.linuxfoundation.org/pipermail/iommu/2013-November/006914.html
---
 drivers/base/dd.c        |  5 +++++
 drivers/iommu/of_iommu.c | 22 ++++++++++++++++++++++
 include/linux/of_iommu.h |  7 +++++++
 3 files changed, 34 insertions(+)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 35fa368..6e892d4 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -25,6 +25,7 @@
 #include <linux/async.h>
 #include <linux/pm_runtime.h>
 #include <linux/pinctrl/devinfo.h>
+#include <linux/of_iommu.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -273,6 +274,10 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 
 	dev->driver = drv;
 
+	ret = of_iommu_attach(dev);
+	if (ret)
+		goto probe_failed;
+
 	/* If using pinctrl, bind pins now before probing */
 	ret = pinctrl_bind_pins(dev);
 	if (ret)
diff --git a/drivers/iommu/of_iommu.c b/drivers/iommu/of_iommu.c
index ee249bc..4aef2b2 100644
--- a/drivers/iommu/of_iommu.c
+++ b/drivers/iommu/of_iommu.c
@@ -20,6 +20,8 @@
 #include <linux/export.h>
 #include <linux/limits.h>
 #include <linux/of.h>
+#include <linux/device.h>
+#include <linux/iommu.h>
 
 /**
  * of_get_dma_window - Parse *dma-window property and returns 0 if found.
@@ -88,3 +90,23 @@ int of_get_dma_window(struct device_node *dn, const char *prefix, int index,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(of_get_dma_window);
+
+int of_iommu_attach(struct device *dev)
+{
+	int i;
+	struct of_phandle_args args;
+	struct iommu_ops *ops = dev->bus->iommu_ops;
+
+	of_property_for_each_phandle_with_args(dev->of_node, "iommus",
+					       "#iommu-cells", i, &args) {
+		pr_debug("%s(i=%d) ops=%p %s\n",
+			 __func__, i, ops, dev_name(dev));
+
+		if (!ops)
+			return -EPROBE_DEFER;
+	}
+
+	if (i && ops->add_device)
+		return ops->add_device(dev);
+	return 0;
+}
diff --git a/include/linux/of_iommu.h b/include/linux/of_iommu.h
index 51a560f..3457489 100644
--- a/include/linux/of_iommu.h
+++ b/include/linux/of_iommu.h
@@ -7,6 +7,8 @@ extern int of_get_dma_window(struct device_node *dn, const char *prefix,
 			     int index, unsigned long *busno, dma_addr_t *addr,
 			     size_t *size);
 
+extern int of_iommu_attach(struct device *dev);
+
 #else
 
 static inline int of_get_dma_window(struct device_node *dn, const char *prefix,
@@ -16,6 +18,11 @@ static inline int of_get_dma_window(struct device_node *dn, const char *prefix,
 	return -EINVAL;
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

