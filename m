Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbaK0G1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 01:27:00 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:41723 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175AbaK0G05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 01:26:57 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 25/25] phy: add support for USB cluster on the Armada 375 SoC
Date: Thu, 27 Nov 2014 11:56:17 +0530
Message-ID: <1417069577-1169-26-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417069577-1169-1-git-send-email-kishon@ti.com>
References: <1417069577-1169-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gregory CLEMENT <gregory.clement@free-electrons.com>

The Armada 375 SoC comes with an USB2 host and device controller and
an USB3 controller. The USB cluster control register allows to manage
common features of both USB controllers.

This commit adds a driver integrated in the generic PHY framework to
control this USB cluster feature.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
[ kishon@ti.com : Made it to use the updated devm_phy_create API and
		  soem cosmentic changes in Kconfig file.]
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Acked-by: Jason Cooper <jason@lakedaemon.net>
---
 drivers/phy/Kconfig              |    6 ++
 drivers/phy/Makefile             |    1 +
 drivers/phy/phy-armada375-usb2.c |  158 ++++++++++++++++++++++++++++++++++++++
 include/dt-bindings/phy/phy.h    |    1 +
 4 files changed, 166 insertions(+)
 create mode 100644 drivers/phy/phy-armada375-usb2.c

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 96d43d5..ccad880 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -29,6 +29,12 @@ config PHY_BERLIN_SATA
 	help
 	  Enable this to support the SATA PHY on Marvell Berlin SoCs.
 
+config ARMADA375_USBCLUSTER_PHY
+	def_bool y
+	depends on MACH_ARMADA_375 || COMPILE_TEST
+	depends on OF
+	select GENERIC_PHY
+
 config PHY_EXYNOS_MIPI_VIDEO
 	tristate "S5P/EXYNOS SoC series MIPI CSI-2/DSI PHY driver"
 	depends on HAS_IOMEM
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index 68022f6..aa74f96 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -5,6 +5,7 @@
 obj-$(CONFIG_GENERIC_PHY)		+= phy-core.o
 obj-$(CONFIG_PHY_BERLIN_USB)		+= phy-berlin-usb.o
 obj-$(CONFIG_PHY_BERLIN_SATA)		+= phy-berlin-sata.o
+obj-$(CONFIG_ARMADA375_USBCLUSTER_PHY)	+= phy-armada375-usb2.o
 obj-$(CONFIG_BCM_KONA_USB2_PHY)		+= phy-bcm-kona-usb2.o
 obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)	+= phy-exynos-dp-video.o
 obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
diff --git a/drivers/phy/phy-armada375-usb2.c b/drivers/phy/phy-armada375-usb2.c
new file mode 100644
index 0000000..ac7d99d
--- /dev/null
+++ b/drivers/phy/phy-armada375-usb2.c
@@ -0,0 +1,158 @@
+/*
+ * USB cluster support for Armada 375 platform.
+ *
+ * Copyright (C) 2014 Marvell
+ *
+ * Gregory CLEMENT <gregory.clement@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2 or later. This program is licensed "as is"
+ * without any warranty of any kind, whether express or implied.
+ *
+ * Armada 375 comes with an USB2 host and device controller and an
+ * USB3 controller. The USB cluster control register allows to manage
+ * common features of both USB controllers.
+ */
+
+#include <dt-bindings/phy/phy.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of_address.h>
+#include <linux/phy/phy.h>
+#include <linux/platform_device.h>
+
+#define USB2_PHY_CONFIG_DISABLE BIT(0)
+
+struct armada375_cluster_phy {
+	struct phy *phy;
+	void __iomem *reg;
+	bool use_usb3;
+	int phy_provided;
+};
+
+static int armada375_usb_phy_init(struct phy *phy)
+{
+	struct armada375_cluster_phy *cluster_phy;
+	u32 reg;
+
+	cluster_phy = dev_get_drvdata(phy->dev.parent);
+	if (!cluster_phy)
+		return -ENODEV;
+
+	reg = readl(cluster_phy->reg);
+	if (cluster_phy->use_usb3)
+		reg |= USB2_PHY_CONFIG_DISABLE;
+	else
+		reg &= ~USB2_PHY_CONFIG_DISABLE;
+	writel(reg, cluster_phy->reg);
+
+	return 0;
+}
+
+static struct phy_ops armada375_usb_phy_ops = {
+	.init = armada375_usb_phy_init,
+	.owner = THIS_MODULE,
+};
+
+/*
+ * Only one controller can use this PHY. We shouldn't have the case
+ * when two controllers want to use this PHY. But if this case occurs
+ * then we provide a phy to the first one and return an error for the
+ * next one. This error has also to be an error returned by
+ * devm_phy_optional_get() so different from ENODEV for USB2. In the
+ * USB3 case it still optional and we use ENODEV.
+ */
+static struct phy *armada375_usb_phy_xlate(struct device *dev,
+					struct of_phandle_args *args)
+{
+	struct armada375_cluster_phy *cluster_phy = dev_get_drvdata(dev);
+
+	if (!cluster_phy)
+		return  ERR_PTR(-ENODEV);
+
+	/*
+	 * Either the phy had never been requested and then the first
+	 * usb claiming it can get it, or it had already been
+	 * requested in this case, we only allow to use it with the
+	 * same configuration.
+	 */
+	if (WARN_ON((cluster_phy->phy_provided != PHY_NONE) &&
+			(cluster_phy->phy_provided != args->args[0]))) {
+		dev_err(dev, "This PHY has already been provided!\n");
+		dev_err(dev, "Check your device tree, only one controller can use it\n.");
+		if (args->args[0] == PHY_TYPE_USB2)
+			return ERR_PTR(-EBUSY);
+		else
+			return ERR_PTR(-ENODEV);
+	}
+
+	if (args->args[0] == PHY_TYPE_USB2)
+		cluster_phy->use_usb3 = false;
+	else if (args->args[0] == PHY_TYPE_USB3)
+		cluster_phy->use_usb3 = true;
+	else {
+		dev_err(dev, "Invalid PHY mode\n");
+		return ERR_PTR(-ENODEV);
+	}
+
+	/* Store which phy mode is used for next test */
+	cluster_phy->phy_provided = args->args[0];
+
+	return cluster_phy->phy;
+}
+
+static int armada375_usb_phy_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct phy *phy;
+	struct phy_provider *phy_provider;
+	void __iomem *usb_cluster_base;
+	struct resource *res;
+	struct armada375_cluster_phy *cluster_phy;
+
+	cluster_phy = devm_kzalloc(dev, sizeof(*cluster_phy), GFP_KERNEL);
+	if (!cluster_phy)
+		return  -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	usb_cluster_base = devm_ioremap_resource(&pdev->dev, res);
+	if (!usb_cluster_base)
+		return -ENOMEM;
+
+	phy = devm_phy_create(dev, NULL, &armada375_usb_phy_ops);
+	if (IS_ERR(phy)) {
+		dev_err(dev, "failed to create PHY\n");
+		return PTR_ERR(phy);
+	}
+
+	cluster_phy->phy = phy;
+	cluster_phy->reg = usb_cluster_base;
+
+	dev_set_drvdata(dev, cluster_phy);
+
+	phy_provider = devm_of_phy_provider_register(&pdev->dev,
+						     armada375_usb_phy_xlate);
+	return PTR_ERR_OR_ZERO(phy_provider);
+}
+
+static const struct of_device_id of_usb_cluster_table[] = {
+	{ .compatible = "marvell,armada-375-usb-cluster", },
+	{ /* end of list */ },
+};
+MODULE_DEVICE_TABLE(of, of_usb_cluster_table);
+
+static struct platform_driver armada375_usb_phy_driver = {
+	.probe	= armada375_usb_phy_probe,
+	.driver = {
+		.of_match_table	= of_usb_cluster_table,
+		.name  = "armada-375-usb-cluster",
+		.owner = THIS_MODULE,
+	}
+};
+module_platform_driver(armada375_usb_phy_driver);
+
+MODULE_DESCRIPTION("Armada 375 USB cluster driver");
+MODULE_AUTHOR("Gregory CLEMENT <gregory.clement@free-electrons.com>");
+MODULE_LICENSE("GPL");
diff --git a/include/dt-bindings/phy/phy.h b/include/dt-bindings/phy/phy.h
index e8c6a3f..6c90193 100644
--- a/include/dt-bindings/phy/phy.h
+++ b/include/dt-bindings/phy/phy.h
@@ -10,6 +10,7 @@
 #ifndef _DT_BINDINGS_PHY
 #define _DT_BINDINGS_PHY
 
+#define PHY_NONE		0
 #define PHY_TYPE_SATA		1
 #define PHY_TYPE_PCIE		2
 #define PHY_TYPE_USB2		3
-- 
1.7.9.5

