Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab3LMQv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 11:51:56 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:45378 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab3LMQvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 11:51:52 -0500
From: Matt Porter <mporter@linaro.org>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>
Cc: Tomasz Figa <t.figa@samsung.com>, Kamil Debski <k.debski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dinh Nguyen <dinh.linux@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: [PATCH v6 8/9] phy: add Broadcom Kona USB2 PHY driver
Date: Fri, 13 Dec 2013 11:51:22 -0500
Message-Id: <1386953483-21631-9-git-send-email-mporter@linaro.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386953483-21631-1-git-send-email-mporter@linaro.org>
References: <1386953483-21631-1-git-send-email-mporter@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a driver for the internal Broadcom Kona USB 2.0 PHY found
on the BCM281xx family of SoCs.

Signed-off-by: Matt Porter <mporter@linaro.org>
---
 drivers/phy/Kconfig             |   6 ++
 drivers/phy/Makefile            |   1 +
 drivers/phy/phy-bcm-kona-usb2.c | 158 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 165 insertions(+)
 create mode 100644 drivers/phy/phy-bcm-kona-usb2.c

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index a344f3d..2e87fa8 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -51,4 +51,10 @@ config PHY_EXYNOS_DP_VIDEO
 	help
 	  Support for Display Port PHY found on Samsung EXYNOS SoCs.
 
+config BCM_KONA_USB2_PHY
+	tristate "Broadcom Kona USB2 PHY Driver"
+	depends on GENERIC_PHY
+	help
+	  Enable this to support the Broadcom Kona USB 2.0 PHY.
+
 endmenu
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index d0caae9..c447f1a 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -3,6 +3,7 @@
 #
 
 obj-$(CONFIG_GENERIC_PHY)		+= phy-core.o
+obj-$(CONFIG_BCM_KONA_USB2_PHY)		+= phy-bcm-kona-usb2.o
 obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)	+= phy-exynos-dp-video.o
 obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
 obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
diff --git a/drivers/phy/phy-bcm-kona-usb2.c b/drivers/phy/phy-bcm-kona-usb2.c
new file mode 100644
index 0000000..0046781
--- /dev/null
+++ b/drivers/phy/phy-bcm-kona-usb2.c
@@ -0,0 +1,158 @@
+/*
+ * phy-bcm-kona-usb2.c - Broadcom Kona USB2 Phy Driver
+ *
+ * Copyright (C) 2013 Linaro Limited
+ * Matt Porter <mporter@linaro.org>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/phy/phy.h>
+#include <linux/platform_device.h>
+
+#define OTGCTL			(0)
+#define OTGCTL_OTGSTAT2		BIT(31)
+#define OTGCTL_OTGSTAT1		BIT(30)
+#define OTGCTL_PRST_N_SW	BIT(11)
+#define OTGCTL_HRESET_N		BIT(10)
+#define OTGCTL_UTMI_LINE_STATE1	BIT(9)
+#define OTGCTL_UTMI_LINE_STATE0	BIT(8)
+
+#define P1CTL			(8)
+#define P1CTL_SOFT_RESET	BIT(1)
+#define P1CTL_NON_DRIVING	BIT(0)
+
+struct bcm_kona_usb {
+	void __iomem *regs;
+};
+
+static void bcm_kona_usb_phy_power(struct bcm_kona_usb *phy, int on)
+{
+	u32 val;
+
+	val = readl(phy->regs + OTGCTL);
+	if (on) {
+		/* Configure and power PHY */
+		val &= ~(OTGCTL_OTGSTAT2 | OTGCTL_OTGSTAT1 |
+			 OTGCTL_UTMI_LINE_STATE1 | OTGCTL_UTMI_LINE_STATE0);
+		val |= OTGCTL_PRST_N_SW | OTGCTL_HRESET_N;
+	} else {
+		val &= ~(OTGCTL_PRST_N_SW | OTGCTL_HRESET_N);
+	}
+	writel(val, phy->regs + OTGCTL);
+}
+
+static int bcm_kona_usb_phy_init(struct phy *gphy)
+{
+	struct bcm_kona_usb *phy = phy_get_drvdata(gphy);
+	u32 val;
+
+	/* Soft reset PHY */
+	val = readl(phy->regs + P1CTL);
+	val &= ~P1CTL_NON_DRIVING;
+	val |= P1CTL_SOFT_RESET;
+	writel(val, phy->regs + P1CTL);
+	writel(val & ~P1CTL_SOFT_RESET, phy->regs + P1CTL);
+	/* Reset needs to be asserted for 2ms */
+	mdelay(2);
+	writel(val | P1CTL_SOFT_RESET, phy->regs + P1CTL);
+
+	return 0;
+}
+
+static int bcm_kona_usb_phy_power_on(struct phy *gphy)
+{
+	struct bcm_kona_usb *phy = phy_get_drvdata(gphy);
+
+	bcm_kona_usb_phy_power(phy, 1);
+
+	return 0;
+}
+
+static int bcm_kona_usb_phy_power_off(struct phy *gphy)
+{
+	struct bcm_kona_usb *phy = phy_get_drvdata(gphy);
+
+	bcm_kona_usb_phy_power(phy, 0);
+
+	return 0;
+}
+
+static struct phy_ops ops = {
+	.init		= bcm_kona_usb_phy_init,
+	.power_on	= bcm_kona_usb_phy_power_on,
+	.power_off	= bcm_kona_usb_phy_power_off,
+	.owner		= THIS_MODULE,
+};
+
+static int bcm_kona_usb2_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct bcm_kona_usb *phy;
+	struct resource *res;
+	struct phy *gphy;
+	struct phy_provider *phy_provider;
+
+	phy = devm_kzalloc(dev, sizeof(*phy), GFP_KERNEL);
+	if (!phy)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	phy->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(phy->regs))
+		return PTR_ERR(phy->regs);
+
+	platform_set_drvdata(pdev, phy);
+
+	phy_provider = devm_of_phy_provider_register(dev,
+			of_phy_simple_xlate);
+	if (IS_ERR(phy_provider))
+		return PTR_ERR(phy_provider);
+
+	gphy = devm_phy_create(dev, &ops, NULL);
+	if (IS_ERR(gphy))
+		return PTR_ERR(gphy);
+
+	/* The Kona PHY supports an 8-bit wide UTMI interface */
+	phy_set_bus_width(gphy, 8);
+
+	phy_set_drvdata(gphy, phy);
+
+	return 0;
+}
+
+static const struct of_device_id bcm_kona_usb2_dt_ids[] = {
+	{ .compatible = "brcm,kona-usb2-phy" },
+	{ /* sentinel */ }
+};
+
+MODULE_DEVICE_TABLE(of, bcm_kona_usb2_dt_ids);
+
+static struct platform_driver bcm_kona_usb2_driver = {
+	.probe		= bcm_kona_usb2_probe,
+	.driver		= {
+		.name	= "bcm-kona-usb2",
+		.owner	= THIS_MODULE,
+		.of_match_table = bcm_kona_usb2_dt_ids,
+	},
+};
+
+module_platform_driver(bcm_kona_usb2_driver);
+
+MODULE_ALIAS("platform:bcm-kona-usb2");
+MODULE_AUTHOR("Matt Porter <mporter@linaro.org>");
+MODULE_DESCRIPTION("BCM Kona USB 2.0 PHY driver");
+MODULE_LICENSE("GPL v2");
-- 
1.8.4

