Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbbAWWdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 17:33:51 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:48425 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128AbbAWWdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 17:33:42 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>
CC: Murali Karicheri <m-karicheri2@ti.com>, Joerg Roedel <joro@8bytes.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH v4 1/6] of: iommu: add ptr to OF node arg to of_iommu_configure()
Date: Fri, 23 Jan 2015 17:32:34 -0500
Message-ID: <1422052359-12384-2-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422052359-12384-1-git-send-email-m-karicheri2@ti.com>
References: <1422052359-12384-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function of_iommu_configure() is called from of_dma_configure() to
setup iommu ops using DT property. This API is currently used for
platform devices for which DMA configuration (including iommu ops)
may come from device's parent. To extend this functionality for PCI
devices, this API need to take a parent node ptr as an argument
instead of assuming device's parent. This is needed since for PCI, the
dma configuration may be defined in the DT node of the root bus bridge's
parent device. Currently only dma-range is used for PCI and iommu is not
supported. So return error if the device is PCI.

Cc: Joerg Roedel <joro@8bytes.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 drivers/iommu/of_iommu.c |   10 ++++++++--
 drivers/of/platform.c    |    2 +-
 include/linux/of_iommu.h |    6 ++++--
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/of_iommu.c b/drivers/iommu/of_iommu.c
index af1dc6a..439235b 100644
--- a/drivers/iommu/of_iommu.c
+++ b/drivers/iommu/of_iommu.c
@@ -133,19 +133,25 @@ struct iommu_ops *of_iommu_get_ops(struct device_node *np)
 	return ops;
 }
 
-struct iommu_ops *of_iommu_configure(struct device *dev)
+struct iommu_ops *of_iommu_configure(struct device *dev,
+				     struct device_node *iommu_np)
 {
 	struct of_phandle_args iommu_spec;
 	struct device_node *np;
 	struct iommu_ops *ops = NULL;
 	int idx = 0;
 
+	if (dev_is_pci(dev)) {
+		dev_err(dev, "iommu is currently not supported for PCI\n");
+		return NULL;
+	}
+
 	/*
 	 * We don't currently walk up the tree looking for a parent IOMMU.
 	 * See the `Notes:' section of
 	 * Documentation/devicetree/bindings/iommu/iommu.txt
 	 */
-	while (!of_parse_phandle_with_args(dev->of_node, "iommus",
+	while (!of_parse_phandle_with_args(iommu_np, "iommus",
 					   "#iommu-cells", idx,
 					   &iommu_spec)) {
 		np = iommu_spec.np;
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index a54ec10..7675b79 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -196,7 +196,7 @@ static void of_dma_configure(struct device *dev)
 	dev_dbg(dev, "device is%sdma coherent\n",
 		coherent ? " " : " not ");
 
-	iommu = of_iommu_configure(dev);
+	iommu = of_iommu_configure(dev, dev->of_node);
 	dev_dbg(dev, "device is%sbehind an iommu\n",
 		iommu ? " " : " not ");
 
diff --git a/include/linux/of_iommu.h b/include/linux/of_iommu.h
index 16c7554..a97e5bd 100644
--- a/include/linux/of_iommu.h
+++ b/include/linux/of_iommu.h
@@ -12,7 +12,8 @@ extern int of_get_dma_window(struct device_node *dn, const char *prefix,
 			     size_t *size);
 
 extern void of_iommu_init(void);
-extern struct iommu_ops *of_iommu_configure(struct device *dev);
+extern struct iommu_ops *of_iommu_configure(struct device *dev,
+					struct device_node *iommu_np);
 
 #else
 
@@ -24,7 +25,8 @@ static inline int of_get_dma_window(struct device_node *dn, const char *prefix,
 }
 
 static inline void of_iommu_init(void) { }
-static inline struct iommu_ops *of_iommu_configure(struct device *dev)
+static inline struct iommu_ops *of_iommu_configure(struct device *dev,
+					 struct device_node *iommu_np)
 {
 	return NULL;
 }
-- 
1.7.9.5

