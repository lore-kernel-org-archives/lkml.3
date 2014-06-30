Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbaF3VuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:50:21 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51908 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbaF3VuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:50:18 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <linux-pci@vger.kernel.org>, Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: [PATCH - v3] phy: Add serdes phy driver for keystone
Date: Mon, 30 Jun 2014 17:50:10 -0400
Message-ID: <1404165010-11202-1-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This phy driver added to support keystone PCI driver. This is
a generic phy driver and currently it supports only SerDes
for PCI Controller. The hw vendor that provides the phy
hw published only registers and their values. So this driver
uses these hard coded values to initialize the phy.

Changelog:-
 -  Added comments to indicate what the register functionality
    each register blob is doing.
 -  Previous versions were part of the PCI Keystone driver series.
    This is now send as a separate patch so that this can be
    reviewed indepedently and merged.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
CC: Rob Herring <robh+dt@kernel.org>
CC: Pawel Moll <pawel.moll@arm.com>
CC: Mark Rutland <mark.rutland@arm.com>
CC: Ian Campbell <ijc+devicetree@hellion.org.uk>
CC: Kumar Gala <galak@codeaurora.org>
CC: Kishon Vijay Abraham I <kishon@ti.com>
CC: Grant Likely <grant.likely@linaro.org>
---
 .../bindings/phy/phy-serdes-keystone.txt           |   25 +++
 drivers/phy/Kconfig                                |    6 +
 drivers/phy/Makefile                               |    1 +
 drivers/phy/phy-serdes-keystone.c                  |  200 ++++++++++++++++++++
 4 files changed, 232 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/phy-serdes-keystone.txt
 create mode 100644 drivers/phy/phy-serdes-keystone.c

diff --git a/Documentation/devicetree/bindings/phy/phy-serdes-keystone.txt b/Documentation/devicetree/bindings/phy/phy-serdes-keystone.txt
new file mode 100644
index 0000000..612c7b5
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/phy-serdes-keystone.txt
@@ -0,0 +1,25 @@
+TI Keystone SerDes Phy: DT documentation
+=======================================
+
+Required properties:
+ - compatible: should be "ti,keystone-serdes-phy";
+ - reg: base address and length of the SerDes register set
+ - reg-names: should be "reg_serdes", name of the reg SerDes register set
+ - #phy-cells: from the generic phy bindings, must be 0;
+
+Exampel for Keystone PCIE,
+
+		pcie0_phy: serdes_phy@2320000 {
+			#phy-cells = <0>;
+			compatible = "ti,keystone-serdes-phy";
+			reg = <0x02320000 0x4000>;
+			reg-names = "reg_serdes";
+		};
+
+
+Then the PHY can be used in PCIe controller node as
+
+pcie@21800000 {
+	phys = <&pcie0_phy>;
+	phy-names = "pcie-phy";
+};
diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 16a2f06..54a8471 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -178,4 +178,10 @@ config PHY_XGENE
 	help
 	  This option enables support for APM X-Gene SoC multi-purpose PHY.
 
+config PHY_TI_KEYSTONE_SERDES
+	bool "TI Keystone SerDes PHY support"
+	depends on ARCH_KEYSTONE
+	select GENERIC_PHY
+	help
+	  This option enables support for TI Keystone SerDes PHY.
 endmenu
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index b4f1d57..a02faaa 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -20,3 +20,4 @@ phy-exynos-usb2-$(CONFIG_PHY_EXYNOS4X12_USB2)	+= phy-exynos4x12-usb2.o
 phy-exynos-usb2-$(CONFIG_PHY_EXYNOS5250_USB2)	+= phy-exynos5250-usb2.o
 obj-$(CONFIG_PHY_EXYNOS5_USBDRD)	+= phy-exynos5-usbdrd.o
 obj-$(CONFIG_PHY_XGENE)			+= phy-xgene.o
+obj-$(CONFIG_PHY_TI_KEYSTONE_SERDES)	+= phy-serdes-keystone.o
diff --git a/drivers/phy/phy-serdes-keystone.c b/drivers/phy/phy-serdes-keystone.c
new file mode 100644
index 0000000..f1a8888
--- /dev/null
+++ b/drivers/phy/phy-serdes-keystone.c
@@ -0,0 +1,200 @@
+/*
+ * Keystone SerDes Phy driver
+ *
+ * Copyright (C) 2013-2014 Texas Instruments, Inc.
+ *		http://www.ti.com
+ *
+ * Author: Murali Karicheri <m-karicheri2@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
+#include <linux/phy/phy.h>
+#include <linux/platform_device.h>
+
+#define reg_dump(addr, mask) \
+		pr_debug("reg %p has value %x\n", (void *)addr, \
+			(readl(addr) & ~mask))
+
+/* mask bits point to bits being modified */
+#define reg_rmw(addr, value, mask) \
+		writel(((readl(addr) & (~(mask))) | \
+			(value & (mask))), (addr))
+struct serdes_config {
+	u32 reg;
+	u32 val;
+	u32 mask;
+};
+
+struct phy_serdes_keystone {
+	struct device *dev;
+	void __iomem *base;
+};
+
+static struct serdes_config ks_100mhz_5gbps_serdes[] = {
+	/* SerDes Clock and common configuration */
+	{0x0000, 0x00000800, 0x0000ff00},
+	{0x0060, 0x00041c5c, 0x00ffffff},
+	{0x0064, 0x0343c700, 0xffffff00},
+	{0x006c, 0x00000012, 0x000000ff},
+	{0x0068, 0x00070000, 0x00ff0000},
+	{0x0078, 0x0000c000, 0x0000ff00},
+
+	/* Lane - A Phy configuration */
+	{0x0200, 0x00000000, 0x000000ff},
+	{0x0204, 0x5e000080, 0xff0000ff},
+	{0x0208, 0x00000006, 0x000000ff},
+	{0x0210, 0x00000023, 0x000000ff},
+	{0x0214, 0x2e003060, 0xff00ffff},
+	{0x0218, 0x76000000, 0xff000000},
+	{0x022c, 0x00200002, 0x00ff00ff},
+	{0x02a0, 0xffee0000, 0xffff0000},
+	{0x02a4, 0x0000000f, 0x000000ff},
+	{0x0204, 0x5e000000, 0xff000000},
+	{0x0208, 0x00000006, 0x000000ff},
+	{0x0278, 0x00002000, 0x0000ff00},
+	{0x0280, 0x00280028, 0x00ff00ff},
+	{0x0284, 0x2d0f0385, 0xffffffff},
+	{0x0250, 0xd0000000, 0xff000000},
+	{0x0284, 0x00000085, 0x000000ff},
+	{0x0294, 0x20000000, 0xff000000},
+
+	/* Lane - B Phy configuration */
+	{0x0400, 0x00000000, 0x000000ff},
+	{0x0404, 0x5e000080, 0xff0000ff},
+	{0x0408, 0x00000006, 0x000000ff},
+	{0x0410, 0x00000023, 0x000000ff},
+	{0x0414, 0x2e003060, 0xff00ffff},
+	{0x0418, 0x76000000, 0xff000000},
+	{0x042c, 0x00200002, 0x00ff00ff},
+	{0x04a0, 0xffee0000, 0xffff0000},
+	{0x04a4, 0x0000000f, 0x000000ff},
+	{0x0404, 0x5e000000, 0xff000000},
+	{0x0408, 0x00000006, 0x000000ff},
+	{0x0478, 0x00002000, 0x0000ff00},
+	{0x0480, 0x00280028, 0x00ff00ff},
+	{0x0484, 0x2d0f0385, 0xffffffff},
+	{0x0450, 0xd0000000, 0xff000000},
+	{0x0494, 0x20000000, 0xff000000},
+
+	/* Common Lane configurations */
+	{0x0a00, 0x00000100, 0x0000ff00},
+	{0x0a08, 0x00e12c08, 0x00ffffff},
+	{0x0a0c, 0x00000081, 0x000000ff},
+	{0x0a18, 0x00e80000, 0x00ff0000},
+	{0x0a30, 0x002f2f00, 0x00ffff00},
+	{0x0a4c, 0xac820000, 0xffff0000},
+	{0x0a54, 0xc0000000, 0xff000000},
+	{0x0a58, 0x00001441, 0x0000ffff},
+	{0x0a84, 0x00000301, 0x0000ffff},
+	{0x0a8c, 0x81030000, 0xffff0000},
+	{0x0a90, 0x00006001, 0x0000ffff},
+	{0x0a94, 0x01000000, 0xff000000},
+	{0x0aa0, 0x81000000, 0xff000000},
+	{0x0abc, 0xff000000, 0xff000000},
+	{0x0ac0, 0x0000008b, 0x000000ff},
+
+	/* common clock configuration */
+	{0x0000, 0x00000003, 0x000000ff},
+
+	/* Common Lane configurations */
+	{0x0a00, 0x0000009f, 0x000000ff},
+	{0x0a44, 0x5f733d00, 0xffffff00},
+	{0x0a48, 0x00fdca00, 0x00ffff00},
+	{0x0a5c, 0x00000000, 0xffff0000},
+	{0x0a60, 0x00008000, 0xffffffff},
+	{0x0a64, 0x0c581220, 0xffffffff},
+	{0x0a68, 0xe13b0602, 0xffffffff},
+	{0x0a6c, 0xb8074cc1, 0xffffffff},
+	{0x0a70, 0x3f02e989, 0xffffffff},
+	{0x0a74, 0x00000001, 0x000000ff},
+	{0x0b14, 0x00370000, 0x00ff0000},
+	{0x0b10, 0x37000000, 0xff000000},
+	{0x0b14, 0x0000005d, 0x000000ff},
+};
+
+static int ks_serdes_phy_init(struct phy *phy)
+{
+	struct serdes_config *p;
+	struct phy_serdes_keystone *ks_phy = phy_get_drvdata(phy);
+
+	int i;
+
+	for (i = 0, p = &ks_100mhz_5gbps_serdes[0];
+		i < ARRAY_SIZE(ks_100mhz_5gbps_serdes);
+		i++, p++) {
+		reg_rmw((ks_phy->base + p->reg), p->val, p->mask);
+		reg_dump((ks_phy->base + p->reg), p->mask);
+	}
+	msleep(20);
+
+	return 0;
+}
+
+static struct phy_ops ks_serdes_phy_ops = {
+	.init		= ks_serdes_phy_init,
+	.owner		= THIS_MODULE,
+};
+
+static int ks_serdes_phy_probe(struct platform_device *pdev)
+{
+	struct phy_provider *phy_provider;
+	struct device *dev = &pdev->dev;
+	struct phy_serdes_keystone *ks_phy;
+	struct phy *phy;
+	struct resource *res;
+
+	ks_phy = devm_kzalloc(dev, sizeof(*ks_phy), GFP_KERNEL);
+	if (!ks_phy)
+		return -ENOMEM;
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "reg_serdes");
+	ks_phy->base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(ks_phy->base))
+		return PTR_ERR(ks_phy->base);
+
+	ks_phy->dev = dev;
+	phy = devm_phy_create(dev, &ks_serdes_phy_ops, NULL);
+	if (IS_ERR(phy))
+		return PTR_ERR(phy);
+
+	phy_set_drvdata(phy, ks_phy);
+	phy_provider = devm_of_phy_provider_register(ks_phy->dev,
+				of_phy_simple_xlate);
+
+	if (IS_ERR(phy_provider))
+		return PTR_ERR(phy_provider);
+
+	dev_info(dev, "keystone SerDes Phy initialized\n");
+	return 0;
+}
+
+static const struct of_device_id ks_serdes_phy_of_match[] = {
+	{ .compatible = "ti,keystone-serdes-phy" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, ks_serdes_phy_of_match);
+
+static struct platform_driver ks_serdes_phy_driver = {
+	.probe	= ks_serdes_phy_probe,
+	.driver = {
+		.of_match_table	= ks_serdes_phy_of_match,
+		.name  = "ti,keystone-serdes-phy",
+		.owner = THIS_MODULE,
+	}
+};
+module_platform_driver(ks_serdes_phy_driver);
+
+MODULE_DESCRIPTION("TI Keystone SerDes PHY driver");
+MODULE_LICENSE("GPL V2");
+MODULE_AUTHOR("Murali Karicheri <m-karicheri2@ti.com>");
-- 
1.7.9.5

