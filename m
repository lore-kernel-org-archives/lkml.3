Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbaAJHBM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 02:01:12 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:39640 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbaAJHAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 02:00:33 -0500
From: Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>
To: kishon@ti.com, kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: mark.rutland@arm.com, jg1.han@samsung.com, b.zolnierkie@samsung.com,
        joshi@samsung.com, t.figa@samsung.com, swarren@wwwdotorg.org,
        grant.likely@linaro.org, christoffer.dall@linaro.org,
        linux-ide@vger.kernel.org, Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>,
        Girish K S <ks.giri@samsung.com>,
        Vasanth Ananthan <vasanth.a@samsung.com>
Subject: [PATCH V6 1/2] PHY: Exynos: Add Exynos5250 SATA PHY driver
Date: Fri, 10 Jan 2014 12:30:06 +0530
Message-Id: <1389337208-11325-2-git-send-email-yuvaraj.cd@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389337208-11325-1-git-send-email-yuvaraj.cd@samsung.com>
References: <1389337208-11325-1-git-send-email-yuvaraj.cd@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the SATA PHY driver for Exynos5250.Exynos5250 SATA
PHY comprises of CMU and TRSV blocks which are of I2C register Map.
So this patch also adds a i2c client driver, which is used configure
the CMU and TRSV block of exynos5250 SATA PHY.

This patch incorporates the generic PHY framework to deal with SATA
PHY.

This patch depends on the below patches
	[1].drivers: phy: add generic PHY framework
		by Kishon Vijay Abraham I<kishon@ti.com>
	[2].ata: ahci_platform: Manage SATA PHY
		by Roger Quadros <rogerq@ti.com>

Signed-off-by: Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
Signed-off-by: Girish K S <ks.giri@samsung.com>
Signed-off-by: Vasanth Ananthan <vasanth.a@samsung.com>
---
Changes from V5:
	1.Rebased on latest generic PHY framework for-next tree.
	2.Minor nits such as indentations.

Changes from V4:
	1.Made Exynos5250 SATA PHY driver by default selects
	CONFIG_I2C and CONFIG_I2C_S3C2410, as SATA PHY driver
	depends on I2C.
	2.struct i2c_driver sataphy_i2c_driver made static which
	was earlier global type.
	3.Renamed the files to phy-exynos5250-sata.c and 
	phy-exynos5250-sata-i2c.c and CONFIG_EXYNOS5250_SATA_PHY
	to CONFIG_PHY_EXYNOS5250_SATA. 

Changes from V3:
	1.Moved devm_phy_create before to devm_phy_provider_register.

Changes from V2:
	1.Removed of_match_table
	2.Moved to syscon interface for PMU handling.

Changes from V1:
	1.Adapted to latest version of Generic PHY framework
	2.Removed exynos_sata_i2c_remove function.
 drivers/phy/Kconfig                   |   13 ++
 drivers/phy/Makefile                  |    1 +
 drivers/phy/phy-exynos5250-sata-i2c.c |   40 ++++++
 drivers/phy/phy-exynos5250-sata.c     |  238 +++++++++++++++++++++++++++++++++
 4 files changed, 292 insertions(+)
 create mode 100644 drivers/phy/phy-exynos5250-sata-i2c.c
 create mode 100644 drivers/phy/phy-exynos5250-sata.c

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index d0611b8..df79150 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -57,4 +57,17 @@ config PHY_EXYNOS_DP_VIDEO
 	help
 	  Support for Display Port PHY found on Samsung EXYNOS SoCs.
 
+config PHY_EXYNOS5250_SATA
+	tristate "Exynos5250 Sata SerDes/PHY driver"
+	depends on SOC_EXYNOS5250
+	select GENERIC_PHY
+	select I2C
+	select I2C_S3C2410
+	select MFD_SYSCON
+	help
+	  Enable this to support SATA SerDes/Phy found on Samsung's
+	  Exynos5250 based SoCs.This SerDes/Phy supports SATA 1.5 Gb/s,
+	  SATA 3.0 Gb/s, SATA 6.0 Gb/s speeds. It supports one SATA host
+	  port to accept one SATA device.
+
 endmenu
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index 4e4adc9..8ccf8c3 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -8,3 +8,4 @@ obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
 obj-$(CONFIG_PHY_MVEBU_SATA)		+= phy-mvebu-sata.o
 obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
 obj-$(CONFIG_TWL4030_USB)		+= phy-twl4030-usb.o
+obj-$(CONFIG_PHY_EXYNOS5250_SATA)	+= phy-exynos5250-sata.o phy-exynos5250-sata-i2c.o
diff --git a/drivers/phy/phy-exynos5250-sata-i2c.c b/drivers/phy/phy-exynos5250-sata-i2c.c
new file mode 100644
index 0000000..206e337
--- /dev/null
+++ b/drivers/phy/phy-exynos5250-sata-i2c.c
@@ -0,0 +1,40 @@
+/*
+ * Copyright (C) 2013 Samsung Electronics Co.Ltd
+ * Author:
+ *	Yuvaraj C D <yuvaraj.cd@samsung.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ */
+
+#include <linux/i2c.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+static int exynos_sata_i2c_probe(struct i2c_client *client,
+		const struct i2c_device_id *i2c_id)
+{
+	return 0;
+}
+
+static const struct i2c_device_id sataphy_i2c_device_match[] = {
+	{ "exynos-sataphy-i2c", 0 },
+};
+
+static struct i2c_driver sataphy_i2c_driver = {
+	.probe		= exynos_sata_i2c_probe,
+	.id_table	= sataphy_i2c_device_match,
+	.driver   = {
+		.name = "exynos-sataphy-i2c",
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init exynos5250_phy_i2c_init(void)
+{
+	return i2c_add_driver(&sataphy_i2c_driver);
+}
+module_init(exynos5250_phy_i2c_init);
diff --git a/drivers/phy/phy-exynos5250-sata.c b/drivers/phy/phy-exynos5250-sata.c
new file mode 100644
index 0000000..6e5ff8d
--- /dev/null
+++ b/drivers/phy/phy-exynos5250-sata.c
@@ -0,0 +1,238 @@
+/*
+ * Samsung SATA SerDes(PHY) driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ * Authors: Girish K S <ks.giri@samsung.com>
+ *         Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/i2c.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/phy/phy.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/spinlock.h>
+#include <linux/mfd/syscon.h>
+
+#define EXYNOS5_SATA_RESET		0x4
+#define RESET_CMN_RST_N			(1 << 1)
+#define LINK_RESET			0xF0000
+#define EXYNOS5_SATA_MODE0		0x10
+#define EXYNOS5_SATAPHY_PMU_ENABLE	(1 << 0)
+#define SATA_SPD_GEN3			(2 << 0)
+#define EXYNOS5_SATA_CTRL0		0x14
+#define CTRL0_P0_PHY_CALIBRATED_SEL	(1 << 9)
+#define CTRL0_P0_PHY_CALIBRATED		(1 << 8)
+#define EXYNOS5_SATA_PHSATA_CTRLM	0xE0
+#define PHCTRLM_REF_RATE		(1 << 1)
+#define PHCTRLM_HIGH_SPEED		(1 << 0)
+#define EXYNOS5_SATA_PHSATA_STATM	0xF0
+#define PHSTATM_PLL_LOCKED		(1 << 0)
+#define EXYNOS_SATA_PHY_EN		(1 << 0)
+#define SATAPHY_CONTROL_OFFSET		0x0724
+
+struct exynos_sata_phy {
+	struct phy *phy;
+	struct clk *phyclk;
+	void __iomem *regs;
+	void __iomem *pmureg;
+	struct i2c_client *client;
+};
+
+static bool wait_for_reg_status(void __iomem *base, u32 reg, u32 checkbit,
+				u32 status)
+{
+	unsigned long timeout = jiffies + usecs_to_jiffies(1000);
+
+	while (time_before(jiffies, timeout)) {
+		if ((readl(base + reg) & checkbit) == status)
+			return true;
+	}
+
+	return false;
+}
+
+static int exynos_sata_phy_power_on(struct phy *phy)
+{
+	struct exynos_sata_phy *sata_phy = phy_get_drvdata(phy);
+
+	regmap_update_bits(sata_phy->pmureg, SATAPHY_CONTROL_OFFSET,
+			EXYNOS5_SATAPHY_PMU_ENABLE, EXYNOS_SATA_PHY_EN);
+
+	return 0;
+}
+
+static int exynos_sata_phy_power_off(struct phy *phy)
+{
+	struct exynos_sata_phy *sata_phy = phy_get_drvdata(phy);
+
+	regmap_update_bits(sata_phy->pmureg, SATAPHY_CONTROL_OFFSET,
+			EXYNOS5_SATAPHY_PMU_ENABLE, ~EXYNOS_SATA_PHY_EN);
+
+	return 0;
+}
+
+static int exynos_sata_phy_init(struct phy *phy)
+{
+	u32 val = 0;
+	int ret = 0;
+	u8 buf[] = { 0x3A, 0x0B };
+	struct exynos_sata_phy *sata_phy = phy_get_drvdata(phy);
+
+	regmap_update_bits(sata_phy->pmureg, SATAPHY_CONTROL_OFFSET,
+			EXYNOS5_SATAPHY_PMU_ENABLE, EXYNOS_SATA_PHY_EN);
+
+	writel(val, sata_phy->regs + EXYNOS5_SATA_RESET);
+
+	val = readl(sata_phy->regs + EXYNOS5_SATA_RESET);
+	val |= 0xFF;
+	writel(val, sata_phy->regs + EXYNOS5_SATA_RESET);
+
+	val = readl(sata_phy->regs + EXYNOS5_SATA_RESET);
+	val |= LINK_RESET;
+	writel(val, sata_phy->regs + EXYNOS5_SATA_RESET);
+
+	val = readl(sata_phy->regs + EXYNOS5_SATA_RESET);
+	val |= RESET_CMN_RST_N;
+	writel(val, sata_phy->regs + EXYNOS5_SATA_RESET);
+
+	val = readl(sata_phy->regs + EXYNOS5_SATA_PHSATA_CTRLM);
+	val &= ~PHCTRLM_REF_RATE;
+	writel(val, sata_phy->regs + EXYNOS5_SATA_PHSATA_CTRLM);
+
+	/* High speed enable for Gen3 */
+	val = readl(sata_phy->regs + EXYNOS5_SATA_PHSATA_CTRLM);
+	val |= PHCTRLM_HIGH_SPEED;
+	writel(val, sata_phy->regs + EXYNOS5_SATA_PHSATA_CTRLM);
+
+	val = readl(sata_phy->regs + EXYNOS5_SATA_CTRL0);
+	val |= CTRL0_P0_PHY_CALIBRATED_SEL | CTRL0_P0_PHY_CALIBRATED;
+	writel(val, sata_phy->regs + EXYNOS5_SATA_CTRL0);
+
+	val = readl(sata_phy->regs + EXYNOS5_SATA_MODE0);
+	val |= SATA_SPD_GEN3;
+	writel(val, sata_phy->regs + EXYNOS5_SATA_MODE0);
+
+	ret = i2c_master_send(sata_phy->client, buf, sizeof(buf));
+	if (ret < 0)
+		return -ENXIO;
+
+	/* release cmu reset */
+	val = readl(sata_phy->regs + EXYNOS5_SATA_RESET);
+	val &= ~RESET_CMN_RST_N;
+	writel(val, sata_phy->regs + EXYNOS5_SATA_RESET);
+
+	val = readl(sata_phy->regs + EXYNOS5_SATA_RESET);
+	val |= RESET_CMN_RST_N;
+	writel(val, sata_phy->regs + EXYNOS5_SATA_RESET);
+
+	return (wait_for_reg_status(sata_phy->regs, EXYNOS5_SATA_PHSATA_STATM,
+		PHSTATM_PLL_LOCKED, 1)) ? 0 : -EINVAL;
+
+}
+
+static struct phy_ops exynos_sata_phy_ops = {
+	.init		= exynos_sata_phy_init,
+	.power_on	= exynos_sata_phy_power_on,
+	.power_off	= exynos_sata_phy_power_off,
+	.owner		= THIS_MODULE,
+};
+
+static int exynos_sata_phy_probe(struct platform_device *pdev)
+{
+	struct exynos_sata_phy *sata_phy;
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+	struct phy_provider *phy_provider;
+	struct device_node *node;
+	int ret = 0;
+
+	sata_phy = devm_kzalloc(dev, sizeof(*sata_phy), GFP_KERNEL);
+	if (!sata_phy)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	sata_phy->regs = devm_ioremap_resource(dev, res);
+	if (IS_ERR(sata_phy->regs))
+		return PTR_ERR(sata_phy->regs);
+
+	sata_phy->pmureg = syscon_regmap_lookup_by_phandle(dev->of_node,
+					"samsung,syscon-phandle");
+	if (!sata_phy->pmureg) {
+		dev_err(dev, "syscon regmap lookup failed.\n");
+		return PTR_ERR(sata_phy->pmureg);
+	}
+
+	node = of_parse_phandle(dev->of_node,
+			"samsung,exynos-sataphy-i2c-phandle", 0);
+	if (!node)
+		return -ENODEV;
+
+	sata_phy->client = of_find_i2c_device_by_node(node);
+	if (!sata_phy->client)
+		return -EPROBE_DEFER;
+
+	dev_set_drvdata(dev, sata_phy);
+
+	sata_phy->phyclk = devm_clk_get(dev, "sata_phyctrl");
+	if (IS_ERR(sata_phy->phyclk)) {
+		dev_err(dev, "failed to get clk for PHY\n");
+		return PTR_ERR(sata_phy->phyclk);
+	}
+
+	ret = clk_prepare_enable(sata_phy->phyclk);
+	if (ret < 0) {
+		dev_err(dev, "failed to enable source clk\n");
+		return ret;
+	}
+
+	sata_phy->phy = devm_phy_create(dev, &exynos_sata_phy_ops, NULL);
+	if (IS_ERR(sata_phy->phy)) {
+		clk_disable_unprepare(sata_phy->phyclk);
+		dev_err(dev, "failed to create PHY\n");
+		return PTR_ERR(sata_phy->phy);
+	}
+
+	phy_set_drvdata(sata_phy->phy, sata_phy);
+
+	phy_provider = devm_of_phy_provider_register(dev,
+					of_phy_simple_xlate);
+	if (IS_ERR(phy_provider)) {
+		clk_disable_unprepare(sata_phy->phyclk);
+		return PTR_ERR(phy_provider);
+	}
+
+	return 0;
+}
+
+static const struct of_device_id exynos_sata_phy_of_match[] = {
+	{ .compatible = "samsung,exynos5250-sata-phy" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, exynos_sata_phy_of_match);
+
+static struct platform_driver exynos_sata_phy_driver = {
+	.probe	= exynos_sata_phy_probe,
+	.driver = {
+		.of_match_table	= exynos_sata_phy_of_match,
+		.name  = "samsung,sata-phy",
+		.owner = THIS_MODULE,
+	}
+};
+module_platform_driver(exynos_sata_phy_driver);
+
+MODULE_DESCRIPTION("Samsung SerDes PHY driver");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Girish K S <ks.giri@samsung.com>");
+MODULE_AUTHOR("Yuvaraj C D <yuvaraj.cd@samsung.com>");
-- 
1.7.9.5

