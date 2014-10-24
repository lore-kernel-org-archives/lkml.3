Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbaJXP0D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:26:03 -0400
Received: from down.free-electrons.com ([37.187.137.238]:40680 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756782AbaJXPYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:24:31 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: "Kishon Vijay Abraham I" <kishon@ti.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/6] phy: add support for USB cluster on the Armada 375 SoC
Date: Fri, 24 Oct 2014 17:24:12 +0200
Message-Id: <1414164254-13053-5-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414164254-13053-1-git-send-email-gregory.clement@free-electrons.com>
References: <1414164254-13053-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Armada 375 SoC comes with an USB2 host and device controller and
an USB3 controller. The USB cluster control register allows to manage
common features of both USB controllers.

This commit adds a driver integrated in the generic PHY framework to
control this USB cluster feature.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 drivers/phy/Kconfig                              |   6 +
 drivers/phy/Makefile                             |   1 +
 drivers/phy/phy-armada375-usb2.c                 | 145 +++++++++++++++++++++++
 include/dt-bindings/phy/armada-375-usb-cluster.h |  19 +++
 4 files changed, 171 insertions(+)
 create mode 100644 drivers/phy/phy-armada375-usb2.c
 create mode 100644 include/dt-bindings/phy/armada-375-usb-cluster.h

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 2a436e607f99..625adb0abd43 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -21,6 +21,12 @@ config PHY_BERLIN_SATA
 	select GENERIC_PHY
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
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index c4590fce082f..26b5633f378a 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -4,6 +4,7 @@
 
 obj-$(CONFIG_GENERIC_PHY)		+= phy-core.o
 obj-$(CONFIG_PHY_BERLIN_SATA)		+= phy-berlin-sata.o
+obj-$(CONFIG_ARMADA375_USBCLUSTER_PHY)	+= phy-armada375-usb2.o
 obj-$(CONFIG_BCM_KONA_USB2_PHY)		+= phy-bcm-kona-usb2.o
 obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)	+= phy-exynos-dp-video.o
 obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
diff --git a/drivers/phy/phy-armada375-usb2.c b/drivers/phy/phy-armada375-usb2.c
new file mode 100644
index 000000000000..7c6daa9029b3
--- /dev/null
+++ b/drivers/phy/phy-armada375-usb2.c
@@ -0,0 +1,145 @@
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
+#include <dt-bindings/phy/armada-375-usb-cluster.h>
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
+static struct armada375_cluster_phy usb_cluster_phy;
+
+static int armada375_usb_phy_init(struct phy *phy)
+{
+	struct armada375_cluster_phy *cluster_phy = phy_get_drvdata(phy);
+	u32 reg;
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
+
+    /*
+     * Either the phy had never been requested and then the first usb
+     * claiming it can get it, or it had already been requested in
+     * this case, we only allow to use it with the same configuration.
+     */
+	if (WARN_ON((usb_cluster_phy.phy_provided != PHY_NONE) &&
+			(usb_cluster_phy.phy_provided != args->args[0]))) {
+		dev_err(dev, "This PHY has already been provided!\n");
+		dev_err(dev, "Check your device tree, only one controller can use it\n.");
+		if (args->args[0] == PHY_USB2)
+			return ERR_PTR(-EBUSY);
+		else
+			return ERR_PTR(-ENODEV);
+	}
+
+	if (args->args[0] == PHY_USB2)
+		usb_cluster_phy.use_usb3 = false;
+	else if (args->args[0] == PHY_USB3)
+		usb_cluster_phy.use_usb3 = true;
+	else {
+		dev_err(dev, "Invalid PHY mode\n");
+		return ERR_PTR(-ENODEV);
+	}
+
+	/* Store which phy mode is used for next test */
+	usb_cluster_phy.phy_provided = args->args[0];
+
+	return usb_cluster_phy.phy;
+}
+
+static int armada375_usb_phy_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct phy *phy;
+	struct phy_provider *phy_provider;
+	void __iomem *usb_cluster_base;
+	struct resource *res;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	usb_cluster_base = devm_ioremap_resource(&pdev->dev, res);
+	if (!usb_cluster_base)
+		return -ENOMEM;
+
+	phy = devm_phy_create(dev, NULL, &armada375_usb_phy_ops, NULL);
+	if (IS_ERR(phy)) {
+		dev_err(dev, "failed to create PHY\n");
+		return PTR_ERR(phy);
+	}
+
+	usb_cluster_phy.phy = phy;
+	usb_cluster_phy.reg = usb_cluster_base;
+	phy_set_drvdata(phy, &usb_cluster_phy);
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
diff --git a/include/dt-bindings/phy/armada-375-usb-cluster.h b/include/dt-bindings/phy/armada-375-usb-cluster.h
new file mode 100644
index 000000000000..cbd2d4e720bb
--- /dev/null
+++ b/include/dt-bindings/phy/armada-375-usb-cluster.h
@@ -0,0 +1,19 @@
+/*
+ * Copyright (C) 2014 Marvell
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version.
+ */
+
+#ifndef __ARMADA_375_USB_CLUSTER__
+#define __ARMADA_375_USB_CLUSTER__
+
+/* The supported mode passed through by the phandle are the following */
+
+#define PHY_NONE    0
+#define PHY_USB2    1
+#define PHY_USB3    2
+
+#endif /* __DT_BINDINGS_CLOCK_R8A7791_H__ */
-- 
1.9.1

