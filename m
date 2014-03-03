Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbaCCFXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 00:23:50 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:42469 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaCCFXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 00:23:46 -0500
From: Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>
To: kishon@ti.com, kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: grant.likely@linaro.org, t.figa@samsung.com, b.zolnierkie@samsung.com,
        jg1.han@samsung.com, christoffer.dall@linaro.com, sander@humilis.net,
        swarren@wwwdotorg.org, mark.rutland@arm.com, joshi@samsung.com,
        ks.giri@samsung.com, Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>,
        Vasanth Ananthan <vasanth.a@samsung.com>
Subject: [PATCH V9 1/2] PHY: Exynos: Add Exynos5250 SATA PHY driver
Date: Mon,  3 Mar 2014 10:52:39 +0530
Message-Id: <1393824160-27040-2-git-send-email-yuvaraj.cd@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1393824160-27040-1-git-send-email-yuvaraj.cd@samsung.com>
References: <1393824160-27040-1-git-send-email-yuvaraj.cd@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the SATA PHY driver for Exynos5250.This driver uses the
generic PHY framework to deal with SATA PHY.Exynos5250 SATA PHY comprises
of CMU and TRSV blocks which are of I2C register Map.So this driver
configures the CMU and TRSV block of exynos5250 SATA PHY using i2c.

Signed-off-by: Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
Signed-off-by: Girish K S <ks.giri@samsung.com>
Signed-off-by: Vasanth Ananthan <vasanth.a@samsung.com>
---
Changes from V8:
	1. Updated commit message.

Changes from V7:
	1.Used BIT macro and made CONFIG_PHY_EXYNOS5250_SATA
	  depends on HAS_IOMEM and OF.

Changes from V6:
	1.Removed phy-exynos5250-sata-i2c.c,as it is not required
	  after moving to of_find_i2c_device_by_node().
	2.Changed struct __iomem *pmureg to struct regmap *pmureg.
	3.Changed the wait_for_reg_status() to return 0 or -EFAULT.

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
 drivers/phy/Kconfig               |   15 +++
 drivers/phy/Makefile              |    1 +
 drivers/phy/phy-exynos5250-sata.c |  251 +++++++++++++++++++++++++++++++++++++
 3 files changed, 267 insertions(+)
 create mode 100644 drivers/phy/phy-exynos5250-sata.c

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 5bf9ed3..0431284 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -70,4 +70,19 @@ config BCM_KONA_USB2_PHY
 	help
 	  Enable this to support the Broadcom Kona USB 2.0 PHY.
 
+config PHY_EXYNOS5250_SATA
+	tristate "Exynos5250 Sata SerDes/PHY driver"
+	depends on SOC_EXYNOS5250
+	depends on HAS_IOMEM
+	depends on OF
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
index b57c253..0d03822 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
 obj-$(CONFIG_PHY_MVEBU_SATA)		+= phy-mvebu-sata.o
 obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
 obj-$(CONFIG_TWL4030_USB)		+= phy-twl4030-usb.o
+obj-$(CONFIG_PHY_EXYNOS5250_SATA)	+= phy-exynos5250-sata.o
diff --git a/drivers/phy/phy-exynos5250-sata.c b/drivers/phy/phy-exynos5250-sata.c
new file mode 100644
index 0000000..8ccd305
--- /dev/null
+++ b/drivers/phy/phy-exynos5250-sata.c
@@ -0,0 +1,251 @@
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
+#define SATAPHY_CONTROL_OFFSET		0x0724
+#define EXYNOS5_SATAPHY_PMU_ENABLE	BIT(0)
+#define EXYNOS5_SATA_RESET		0x4
+#define RESET_GLOBAL_RST_N		BIT(0)
+#define RESET_CMN_RST_N			BIT(1)
+#define RESET_CMN_BLOCK_RST_N		BIT(2)
+#define RESET_CMN_I2C_RST_N		BIT(3)
+#define RESET_TX_RX_PIPE_RST_N		BIT(4)
+#define RESET_TX_RX_BLOCK_RST_N		BIT(5)
+#define RESET_TX_RX_I2C_RST_N		(BIT(6) | BIT(7))
+#define LINK_RESET			0xf0000
+#define EXYNOS5_SATA_MODE0		0x10
+#define SATA_SPD_GEN3			BIT(1)
+#define EXYNOS5_SATA_CTRL0		0x14
+#define CTRL0_P0_PHY_CALIBRATED_SEL	BIT(9)
+#define CTRL0_P0_PHY_CALIBRATED		BIT(8)
+#define EXYNOS5_SATA_PHSATA_CTRLM	0xe0
+#define PHCTRLM_REF_RATE		BIT(1)
+#define PHCTRLM_HIGH_SPEED		BIT(0)
+#define EXYNOS5_SATA_PHSATA_STATM	0xf0
+#define PHSTATM_PLL_LOCKED		BIT(0)
+
+#define PHY_PLL_TIMEOUT (usecs_to_jiffies(1000))
+
+struct exynos_sata_phy {
+	struct phy *phy;
+	struct clk *phyclk;
+	void __iomem *regs;
+	struct regmap *pmureg;
+	struct i2c_client *client;
+};
+
+static int wait_for_reg_status(void __iomem *base, u32 reg, u32 checkbit,
+				u32 status)
+{
+	unsigned long timeout = jiffies + PHY_PLL_TIMEOUT;
+
+	while (time_before(jiffies, timeout)) {
+		if ((readl(base + reg) & checkbit) == status)
+			return 0;
+	}
+
+	return -EFAULT;
+}
+
+static int exynos_sata_phy_power_on(struct phy *phy)
+{
+	struct exynos_sata_phy *sata_phy = phy_get_drvdata(phy);
+
+	return regmap_update_bits(sata_phy->pmureg, SATAPHY_CONTROL_OFFSET,
+			EXYNOS5_SATAPHY_PMU_ENABLE, true);
+
+}
+
+static int exynos_sata_phy_power_off(struct phy *phy)
+{
+	struct exynos_sata_phy *sata_phy = phy_get_drvdata(phy);
+
+	return regmap_update_bits(sata_phy->pmureg, SATAPHY_CONTROL_OFFSET,
+			EXYNOS5_SATAPHY_PMU_ENABLE, false);
+
+}
+
+static int exynos_sata_phy_init(struct phy *phy)
+{
+	u32 val = 0;
+	int ret = 0;
+	u8 buf[] = { 0x3a, 0x0b };
+	struct exynos_sata_phy *sata_phy = phy_get_drvdata(phy);
+
+	ret = regmap_update_bits(sata_phy->pmureg, SATAPHY_CONTROL_OFFSET,
+			EXYNOS5_SATAPHY_PMU_ENABLE, true);
+	if (ret != 0)
+		dev_err(&sata_phy->phy->dev, "phy init failed\n");
+
+	writel(val, sata_phy->regs + EXYNOS5_SATA_RESET);
+
+	val = readl(sata_phy->regs + EXYNOS5_SATA_RESET);
+	val |= RESET_GLOBAL_RST_N | RESET_CMN_RST_N | RESET_CMN_BLOCK_RST_N
+		| RESET_CMN_I2C_RST_N | RESET_TX_RX_PIPE_RST_N
+		| RESET_TX_RX_BLOCK_RST_N | RESET_TX_RX_I2C_RST_N;
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
+		return ret;
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
+	ret = wait_for_reg_status(sata_phy->regs,
+				EXYNOS5_SATA_PHSATA_STATM,
+				PHSTATM_PLL_LOCKED, 1);
+	if (ret < 0)
+		dev_err(&sata_phy->phy->dev,
+			"PHY PLL locking failed\n");
+	return ret;
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
+	if (IS_ERR(sata_phy->pmureg)) {
+			dev_err(dev, "syscon regmap lookup failed.\n");
+			return PTR_ERR(sata_phy->pmureg);
+		}
+
+	node = of_parse_phandle(dev->of_node,
+			"samsung,exynos-sataphy-i2c-phandle", 0);
+	if (!node)
+		return -EINVAL;
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
+MODULE_LICENSE("GPL V2");
+MODULE_AUTHOR("Girish K S <ks.giri@samsung.com>");
+MODULE_AUTHOR("Yuvaraj C D <yuvaraj.cd@samsung.com>");
-- 
1.7.10.4

