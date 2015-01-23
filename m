Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbbAWWeJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 17:34:09 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:48430 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbbAWWdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 17:33:47 -0500
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
Subject: [PATCH v4 2/6] of: move of_dma_configure() to device.c to help re-use
Date: Fri, 23 Jan 2015 17:32:35 -0500
Message-ID: <1422052359-12384-3-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422052359-12384-1-git-send-email-m-karicheri2@ti.com>
References: <1422052359-12384-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move of_dma_configure() to device.c so that same function can be re-used
for PCI devices to obtain DMA configuration from DT. Also add a second
argument so that for PCI, DT node of root bus host bridge can be used to
obtain the DMA configuration for the slave PCI device.

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
 drivers/of/device.c       |   59 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/of/platform.c     |   58 ++------------------------------------------
 include/linux/of_device.h |    2 ++
 3 files changed, 63 insertions(+), 56 deletions(-)

diff --git a/drivers/of/device.c b/drivers/of/device.c
index 46d6c75c..2de320d 100644
--- a/drivers/of/device.c
+++ b/drivers/of/device.c
@@ -2,6 +2,9 @@
 #include <linux/kernel.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/of_address.h>
+#include <linux/of_iommu.h>
+#include <linux/dma-mapping.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
@@ -66,6 +69,62 @@ int of_device_add(struct platform_device *ofdev)
 	return device_add(&ofdev->dev);
 }
 
+/**
+ * of_dma_configure - Setup DMA configuration
+ * @dev:	Device to apply DMA configuration
+ * @np:		ptr to of node having dma configuration
+ *
+ * Try to get devices's DMA configuration from DT and update it
+ * accordingly.
+ *
+ * In case if platform code need to use own special DMA configuration,it
+ * can use Platform bus notifier and handle BUS_NOTIFY_ADD_DEVICE event
+ * to fix up DMA configuration.
+ */
+void of_dma_configure(struct device *dev, struct device_node *np)
+{
+	u64 dma_addr, paddr, size;
+	int ret;
+	bool coherent;
+	unsigned long offset;
+	struct iommu_ops *iommu;
+
+	/*
+	 * Set default dma-mask to 32 bit. Drivers are expected to setup
+	 * the correct supported dma_mask.
+	 */
+	dev->coherent_dma_mask = DMA_BIT_MASK(32);
+
+	/*
+	 * Set it to coherent_dma_mask by default if the architecture
+	 * code has not set it.
+	 */
+	if (!dev->dma_mask)
+		dev->dma_mask = &dev->coherent_dma_mask;
+
+	ret = of_dma_get_range(np, &dma_addr, &paddr, &size);
+	if (ret < 0) {
+		dma_addr = offset = 0;
+		size = dev->coherent_dma_mask;
+	} else {
+		offset = PFN_DOWN(paddr - dma_addr);
+		dev_dbg(dev, "dma_pfn_offset(%#08lx)\n", offset);
+	}
+
+	dev->dma_pfn_offset = offset;
+
+	coherent = of_dma_is_coherent(np);
+	dev_dbg(dev, "device is%sdma coherent\n",
+		coherent ? " " : " not ");
+
+	iommu = of_iommu_configure(dev, np);
+	dev_dbg(dev, "device is%sbehind an iommu\n",
+		iommu ? " " : " not ");
+
+	arch_setup_dma_ops(dev, dma_addr, size, iommu, coherent);
+}
+EXPORT_SYMBOL_GPL(of_dma_configure);
+
 int of_device_register(struct platform_device *pdev)
 {
 	device_initialize(&pdev->dev);
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 7675b79..6403501 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -19,7 +19,6 @@
 #include <linux/slab.h>
 #include <linux/of_address.h>
 #include <linux/of_device.h>
-#include <linux/of_iommu.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
@@ -150,59 +149,6 @@ struct platform_device *of_device_alloc(struct device_node *np,
 }
 EXPORT_SYMBOL(of_device_alloc);
 
-/**
- * of_dma_configure - Setup DMA configuration
- * @dev:	Device to apply DMA configuration
- *
- * Try to get devices's DMA configuration from DT and update it
- * accordingly.
- *
- * In case if platform code need to use own special DMA configuration,it
- * can use Platform bus notifier and handle BUS_NOTIFY_ADD_DEVICE event
- * to fix up DMA configuration.
- */
-static void of_dma_configure(struct device *dev)
-{
-	u64 dma_addr, paddr, size;
-	int ret;
-	bool coherent;
-	unsigned long offset;
-	struct iommu_ops *iommu;
-
-	/*
-	 * Set default dma-mask to 32 bit. Drivers are expected to setup
-	 * the correct supported dma_mask.
-	 */
-	dev->coherent_dma_mask = DMA_BIT_MASK(32);
-
-	/*
-	 * Set it to coherent_dma_mask by default if the architecture
-	 * code has not set it.
-	 */
-	if (!dev->dma_mask)
-		dev->dma_mask = &dev->coherent_dma_mask;
-
-	ret = of_dma_get_range(dev->of_node, &dma_addr, &paddr, &size);
-	if (ret < 0) {
-		dma_addr = offset = 0;
-		size = dev->coherent_dma_mask;
-	} else {
-		offset = PFN_DOWN(paddr - dma_addr);
-		dev_dbg(dev, "dma_pfn_offset(%#08lx)\n", offset);
-	}
-	dev->dma_pfn_offset = offset;
-
-	coherent = of_dma_is_coherent(dev->of_node);
-	dev_dbg(dev, "device is%sdma coherent\n",
-		coherent ? " " : " not ");
-
-	iommu = of_iommu_configure(dev, dev->of_node);
-	dev_dbg(dev, "device is%sbehind an iommu\n",
-		iommu ? " " : " not ");
-
-	arch_setup_dma_ops(dev, dma_addr, size, iommu, coherent);
-}
-
 static void of_dma_deconfigure(struct device *dev)
 {
 	arch_teardown_dma_ops(dev);
@@ -236,7 +182,7 @@ static struct platform_device *of_platform_device_create_pdata(
 
 	dev->dev.bus = &platform_bus_type;
 	dev->dev.platform_data = platform_data;
-	of_dma_configure(&dev->dev);
+	of_dma_configure(&dev->dev, dev->dev.of_node);
 
 	if (of_device_add(dev) != 0) {
 		of_dma_deconfigure(&dev->dev);
@@ -299,7 +245,7 @@ static struct amba_device *of_amba_device_create(struct device_node *node,
 		dev_set_name(&dev->dev, "%s", bus_id);
 	else
 		of_device_make_bus_id(&dev->dev);
-	of_dma_configure(&dev->dev);
+	of_dma_configure(&dev->dev, dev->dev.of_node);
 
 	/* Allow the HW Peripheral ID to be overridden */
 	prop = of_get_property(node, "arm,primecell-periphid", NULL);
diff --git a/include/linux/of_device.h b/include/linux/of_device.h
index ef37021..c661496 100644
--- a/include/linux/of_device.h
+++ b/include/linux/of_device.h
@@ -53,6 +53,7 @@ static inline struct device_node *of_cpu_device_node_get(int cpu)
 	return of_node_get(cpu_dev->of_node);
 }
 
+void of_dma_configure(struct device *dev, struct device_node *np);
 #else /* CONFIG_OF */
 
 static inline int of_driver_match_device(struct device *dev,
@@ -90,6 +91,7 @@ static inline struct device_node *of_cpu_device_node_get(int cpu)
 {
 	return NULL;
 }
+void of_dma_configure(struct device *dev, struct device_node *np) { }
 #endif /* CONFIG_OF */
 
 #endif /* _LINUX_OF_DEVICE_H */
-- 
1.7.9.5

