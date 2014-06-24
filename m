Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbaFXKhu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:37:50 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54304 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752534AbaFXKf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:35:28 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, balbi@ti.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 05/12] usb: phy: add the Berlin USB PHY driver
Date: Tue, 24 Jun 2014 12:35:14 +0200
Message-Id: <1403606121-6368-6-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403606121-6368-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1403606121-6368-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the driver driving the Marvell Berlin USB PHY. This allows to
initialize the PHY and to use it from the USB driver later.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 drivers/usb/phy/Kconfig          |   9 ++
 drivers/usb/phy/Makefile         |   1 +
 drivers/usb/phy/phy-berlin-usb.c | 211 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 221 insertions(+)
 create mode 100644 drivers/usb/phy/phy-berlin-usb.c

diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
index e253fa05be68..9a47cc1c73fe 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -18,6 +18,15 @@ config AB8500_USB
 	  This transceiver supports high and full speed devices plus,
 	  in host mode, low speed.
 
+config BERLIN_USBPHY
+	tristate "Marvell Berlin USB Transceiver Driver"
+	depends on ARCH_BERLIN
+	select USB_PHY
+	help
+	  Enable this to support the USB tranceiver on Marvell Berlin
+	  SoCs.
+
+
 config FSL_USB2_OTG
 	bool "Freescale USB OTG Transceiver Driver"
 	depends on USB_EHCI_FSL && USB_FSL_USB2 && USB_OTG_FSM && PM_RUNTIME
diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
index 24a91332d4ad..450ac91c5e20 100644
--- a/drivers/usb/phy/Makefile
+++ b/drivers/usb/phy/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_OF)			+= of.o
 # transceiver drivers, keep the list sorted
 
 obj-$(CONFIG_AB8500_USB)		+= phy-ab8500-usb.o
+obj-$(CONFIG_BERLIN_USBPHY)		+= phy-berlin-usb.o
 obj-$(CONFIG_FSL_USB2_OTG)		+= phy-fsl-usb.o
 obj-$(CONFIG_ISP1301_OMAP)		+= phy-isp1301-omap.o
 obj-$(CONFIG_NOP_USB_XCEIV)		+= phy-generic.o
diff --git a/drivers/usb/phy/phy-berlin-usb.c b/drivers/usb/phy/phy-berlin-usb.c
new file mode 100644
index 000000000000..276d28f5cb83
--- /dev/null
+++ b/drivers/usb/phy/phy-berlin-usb.c
@@ -0,0 +1,211 @@
+/*
+ * Copyright (C) 2014 Marvell Technology Group Ltd.
+ *
+ * Antoine Ténart <antoine.tenart@free-electrons.com>
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
+#include <linux/platform_device.h>
+#include <linux/reset.h>
+#include <linux/usb/phy.h>
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
+#define to_berlin_phy_priv(p)	container_of((p), struct berlin_phy_priv, phy)
+
+static const u32 phy_berlin_pll_dividers[] = {
+	/* Berlin 2 */
+	CLK_REF_DIV(0xc) | FEEDBACK_CLK_DIV(0x54),
+	/* Berlin 2CD */
+	CLK_REF_DIV(0x6) | FEEDBACK_CLK_DIV(0x55),
+};
+
+struct berlin_phy_priv {
+	void __iomem		*base;
+	struct usb_phy		phy;
+	struct reset_control	*rst_ctrl;
+	u32			pll_divider;
+};
+
+static int berlin_phy_init(struct usb_phy *phy)
+{
+	struct berlin_phy_priv *priv = to_berlin_phy_priv(phy);
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
+static int berlin_phy_probe(struct platform_device *pdev)
+{
+	const struct of_device_id *match =
+		of_match_device(phy_berlin_sata_of_match, &pdev->dev);
+	struct berlin_phy_priv *priv;
+	struct resource *res;
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
+	priv->phy.io_priv = priv->base;
+	priv->phy.dev = &pdev->dev;
+	priv->phy.label = "phy-berlin-usb";
+	priv->phy.init = berlin_phy_init;
+	priv->phy.type = USB_PHY_TYPE_USB2;
+
+	platform_set_drvdata(pdev, priv);
+
+	return usb_add_phy_dev(&priv->phy);
+}
+
+static struct platform_driver phy_berlin_usb_driver = {
+	.probe	= berlin_phy_probe,
+	.driver	= {
+		.name		= "phy-berlin-usb",
+		.owner		= THIS_MODULE,
+		.of_match_table	= phy_berlin_sata_of_match,
+	 },
+};
+module_platform_driver(phy_berlin_usb_driver);
+
+MODULE_AUTHOR("Antoine Ténart <antoine.tenart@free-electrons.com>");
+MODULE_DESCRIPTION("Marvell Berlin USB PHY driver");
+MODULE_LICENSE("GPL");
-- 
1.9.1

