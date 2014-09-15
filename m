Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbaIOKgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 06:36:36 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36932 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753915AbaIOKgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 06:36:25 -0400
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com, balbi@ti.com,
        p.zabel@pengutronix.de
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 05/12] phy: add the Berlin USB PHY driver
Date: Mon, 15 Sep 2014 12:36:11 +0200
Message-Id: <1410777378-12726-6-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410777378-12726-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1410777378-12726-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the driver driving the Marvell Berlin USB PHY. This allows to
initialize the PHY and to use it from the USB driver later.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/phy/Kconfig          |   7 ++
 drivers/phy/Makefile         |   1 +
 drivers/phy/phy-berlin-usb.c | 224 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 232 insertions(+)
 create mode 100644 drivers/phy/phy-berlin-usb.c

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 0dd742719154..d1d73dd8c1fb 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -15,6 +15,13 @@ config GENERIC_PHY
 	  phy users can obtain reference to the PHY. All the users of this
 	  framework should select this config.
 
+config PHY_BERLIN_USB
+	tristate "Marvell Berlin USB PHY Driver"
+	depends on ARCH_BERLIN && HAS_IOMEM && OF
+	select GENERIC_PHY
+	help
+	  Enable this to support the USB PHY on Marvell Berlin SoCs.
+
 config PHY_BERLIN_SATA
 	tristate "Marvell Berlin SATA PHY driver"
 	depends on ARCH_BERLIN && HAS_IOMEM && OF
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index 95c69ed5ed45..b12e84b69c23 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -3,6 +3,7 @@
 #
 
 obj-$(CONFIG_GENERIC_PHY)		+= phy-core.o
+obj-$(CONFIG_PHY_BERLIN_USB)		+= phy-berlin-usb.o
 obj-$(CONFIG_PHY_BERLIN_SATA)		+= phy-berlin-sata.o
 obj-$(CONFIG_BCM_KONA_USB2_PHY)		+= phy-bcm-kona-usb2.o
 obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)	+= phy-exynos-dp-video.o
diff --git a/drivers/phy/phy-berlin-usb.c b/drivers/phy/phy-berlin-usb.c
new file mode 100644
index 000000000000..f9f13067f50f
--- /dev/null
+++ b/drivers/phy/phy-berlin-usb.c
@@ -0,0 +1,224 @@
+/*
+ * Copyright (C) 2014 Marvell Technology Group Ltd.
+ *
+ * Antoine Tenart <antoine.tenart@free-electrons.com>
+ * Jisheng Zhang <jszhang@marvell.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/gpio.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/of_gpio.h>
+#include <linux/phy/phy.h>
+#include <linux/platform_device.h>
+#include <linux/reset.h>
+
+#define USB_PHY_PLL		0x04
+#define USB_PHY_PLL_CONTROL	0x08
+#define USB_PHY_TX_CTRL0	0x10
+#define USB_PHY_TX_CTRL1	0x14
+#define USB_PHY_TX_CTRL2	0x18
+#define USB_PHY_RX_CTRL		0x20
+#define USB_PHY_ANALOG		0x34
+
+/* USB_PHY_PLL */
+#define CLK_REF_DIV(x)		((x) << 4)
+#define FEEDBACK_CLK_DIV(x)	((x) << 8)
+
+/* USB_PHY_PLL_CONTROL */
+#define CLK_STABLE		BIT(0)
+#define PLL_CTRL_PIN		BIT(1)
+#define PLL_CTRL_REG		BIT(2)
+#define PLL_ON			BIT(3)
+#define PHASE_OFF_TOL_125	(0x0 << 5)
+#define PHASE_OFF_TOL_250	BIT(5)
+#define KVC0_CALIB		(0x0 << 9)
+#define KVC0_REG_CTRL		BIT(9)
+#define KVC0_HIGH		(0x0 << 10)
+#define KVC0_LOW		(0x3 << 10)
+#define CLK_BLK_EN		BIT(13)
+
+/* USB_PHY_TX_CTRL0 */
+#define EXT_HS_RCAL_EN		BIT(3)
+#define EXT_FS_RCAL_EN		BIT(4)
+#define IMPCAL_VTH_DIV(x)	((x) << 5)
+#define EXT_RS_RCAL_DIV(x)	((x) << 8)
+#define EXT_FS_RCAL_DIV(x)	((x) << 12)
+
+/* USB_PHY_TX_CTRL1 */
+#define TX_VDD15_14		(0x0 << 4)
+#define TX_VDD15_15		BIT(4)
+#define TX_VDD15_16		(0x2 << 4)
+#define TX_VDD15_17		(0x3 << 4)
+#define TX_VDD12_VDD		(0x0 << 6)
+#define TX_VDD12_11		BIT(6)
+#define TX_VDD12_12		(0x2 << 6)
+#define TX_VDD12_13		(0x3 << 6)
+#define LOW_VDD_EN		BIT(8)
+#define TX_OUT_AMP(x)		((x) << 9)
+
+/* USB_PHY_TX_CTRL2 */
+#define TX_CHAN_CTRL_REG(x)	((x) << 0)
+#define DRV_SLEWRATE(x)		((x) << 4)
+#define IMP_CAL_FS_HS_DLY_0	(0x0 << 6)
+#define IMP_CAL_FS_HS_DLY_1	BIT(6)
+#define IMP_CAL_FS_HS_DLY_2	(0x2 << 6)
+#define IMP_CAL_FS_HS_DLY_3	(0x3 << 6)
+#define FS_DRV_EN_MASK(x)	((x) << 8)
+#define HS_DRV_EN_MASK(x)	((x) << 12)
+
+/* USB_PHY_RX_CTRL */
+#define PHASE_FREEZE_DLY_2_CL	(0x0 << 0)
+#define PHASE_FREEZE_DLY_4_CL	BIT(0)
+#define ACK_LENGTH_8_CL		(0x0 << 2)
+#define ACK_LENGTH_12_CL	BIT(2)
+#define ACK_LENGTH_16_CL	(0x2 << 2)
+#define ACK_LENGTH_20_CL	(0x3 << 2)
+#define SQ_LENGTH_3		(0x0 << 4)
+#define SQ_LENGTH_6		BIT(4)
+#define SQ_LENGTH_9		(0x2 << 4)
+#define SQ_LENGTH_12		(0x3 << 4)
+#define DISCON_THRESHOLD_260	(0x0 << 6)
+#define DISCON_THRESHOLD_270	BIT(6)
+#define DISCON_THRESHOLD_280	(0x2 << 6)
+#define DISCON_THRESHOLD_290	(0x3 << 6)
+#define SQ_THRESHOLD(x)		((x) << 8)
+#define LPF_COEF(x)		((x) << 12)
+#define INTPL_CUR_10		(0x0 << 14)
+#define INTPL_CUR_20		BIT(14)
+#define INTPL_CUR_30		(0x2 << 14)
+#define INTPL_CUR_40		(0x3 << 14)
+
+/* USB_PHY_ANALOG */
+#define ANA_PWR_UP		BIT(1)
+#define ANA_PWR_DOWN		BIT(2)
+#define V2I_VCO_RATIO(x)	((x) << 7)
+#define R_ROTATE_90		(0x0 << 10)
+#define R_ROTATE_0		BIT(10)
+#define MODE_TEST_EN		BIT(11)
+#define ANA_TEST_DC_CTRL(x)	((x) << 12)
+
+#define to_phy_berlin_usb_priv(p)	\
+	container_of((p), struct phy_berlin_usb_priv, phy)
+
+static const u32 phy_berlin_pll_dividers[] = {
+	/* Berlin 2 */
+	CLK_REF_DIV(0xc) | FEEDBACK_CLK_DIV(0x54),
+	/* Berlin 2CD */
+	CLK_REF_DIV(0x6) | FEEDBACK_CLK_DIV(0x55),
+};
+
+struct phy_berlin_usb_priv {
+	void __iomem		*base;
+	struct phy		*phy;
+	struct reset_control	*rst_ctrl;
+	u32			pll_divider;
+};
+
+static int phy_berlin_usb_power_on(struct phy *phy)
+{
+	struct phy_berlin_usb_priv *priv = dev_get_drvdata(phy->dev.parent);
+
+	reset_control_reset(priv->rst_ctrl);
+
+	writel(priv->pll_divider,
+	       priv->base + USB_PHY_PLL);
+	writel(CLK_STABLE | PLL_CTRL_REG | PHASE_OFF_TOL_250 | KVC0_REG_CTRL |
+	       CLK_BLK_EN, priv->base + USB_PHY_PLL_CONTROL);
+	writel(V2I_VCO_RATIO(0x5) | R_ROTATE_0 | ANA_TEST_DC_CTRL(0x5),
+	       priv->base + USB_PHY_ANALOG);
+	writel(PHASE_FREEZE_DLY_4_CL | ACK_LENGTH_16_CL | SQ_LENGTH_12 |
+	       DISCON_THRESHOLD_260 | SQ_THRESHOLD(0xa) | LPF_COEF(0x2) |
+	       INTPL_CUR_30, priv->base + USB_PHY_RX_CTRL);
+
+	writel(TX_VDD12_13 | TX_OUT_AMP(0x3), priv->base + USB_PHY_TX_CTRL1);
+	writel(EXT_HS_RCAL_EN | IMPCAL_VTH_DIV(0x3) | EXT_RS_RCAL_DIV(0x4),
+	       priv->base + USB_PHY_TX_CTRL0);
+
+	writel(EXT_HS_RCAL_EN | IMPCAL_VTH_DIV(0x3) | EXT_RS_RCAL_DIV(0x4) |
+	       EXT_FS_RCAL_DIV(0x2), priv->base + USB_PHY_TX_CTRL0);
+
+	writel(EXT_HS_RCAL_EN | IMPCAL_VTH_DIV(0x3) | EXT_RS_RCAL_DIV(0x4),
+	       priv->base + USB_PHY_TX_CTRL0);
+	writel(TX_CHAN_CTRL_REG(0xf) | DRV_SLEWRATE(0x3) | IMP_CAL_FS_HS_DLY_3 |
+	       FS_DRV_EN_MASK(0xd), priv->base + USB_PHY_TX_CTRL2);
+
+	return 0;
+}
+
+static struct phy_ops phy_berlin_usb_ops = {
+	.power_on	= phy_berlin_usb_power_on,
+	.owner		= THIS_MODULE,
+};
+
+static const struct of_device_id phy_berlin_sata_of_match[] = {
+	{
+		.compatible = "marvell,berlin2-usb-phy",
+		.data = &phy_berlin_pll_dividers[0],
+	},
+	{
+		.compatible = "marvell,berlin2cd-usb-phy",
+		.data = &phy_berlin_pll_dividers[1],
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, phy_berlin_sata_of_match);
+
+static int phy_berlin_usb_probe(struct platform_device *pdev)
+{
+	const struct of_device_id *match =
+		of_match_device(phy_berlin_sata_of_match, &pdev->dev);
+	struct phy_berlin_usb_priv *priv;
+	struct resource *res;
+	struct phy_provider *phy_provider;
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	priv->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(priv->base))
+		return PTR_ERR(priv->base);
+
+	priv->rst_ctrl = devm_reset_control_get(&pdev->dev, NULL);
+	if (IS_ERR(priv->rst_ctrl))
+		return PTR_ERR(priv->rst_ctrl);
+
+	priv->pll_divider = *((u32 *)match->data);
+
+	priv->phy = devm_phy_create(&pdev->dev, NULL, &phy_berlin_usb_ops,
+				    NULL);
+	if (IS_ERR(priv->phy)) {
+		dev_err(&pdev->dev, "failed to create PHY\n");
+		return PTR_ERR(priv->phy);
+	}
+
+	platform_set_drvdata(pdev, priv);
+
+	phy_provider =
+		devm_of_phy_provider_register(&pdev->dev, of_phy_simple_xlate);
+	if (IS_ERR(phy_provider))
+		return PTR_ERR(phy_provider);
+
+	return 0;
+}
+
+static struct platform_driver phy_berlin_usb_driver = {
+	.probe	= phy_berlin_usb_probe,
+	.driver	= {
+		.name		= "phy-berlin-usb",
+		.owner		= THIS_MODULE,
+		.of_match_table	= phy_berlin_sata_of_match,
+	 },
+};
+module_platform_driver(phy_berlin_usb_driver);
+
+MODULE_AUTHOR("Antoine Tenart <antoine.tenart@free-electrons.com>");
+MODULE_DESCRIPTION("Marvell Berlin PHY driver for USB");
+MODULE_LICENSE("GPL");
-- 
1.9.1

