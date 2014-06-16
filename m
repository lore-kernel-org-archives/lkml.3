Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082AbaFPK0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 06:26:41 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54081 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755171AbaFPK0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 06:26:37 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, tj@kernel.org, kishon@ti.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 1/7] phy: add a driver for the Berlin SATA PHY
Date: Mon, 16 Jun 2014 12:26:26 +0200
Message-Id: <1402914392-6028-2-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402914392-6028-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1402914392-6028-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Berlin SoC has a two SATA ports. Add a PHY driver to handle them.

The mode selection can let us think this PHY can be configured to fit
other purposes. But there are reasons to think the SATA mode will be
the only one usable: the PHY registers are only accessible indirectly
through two registers in the SATA range, the PHY seems to be integrated
and no information tells us the contrary. For these reasons, make the
driver a SATA PHY driver.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 drivers/phy/Kconfig           |   7 ++
 drivers/phy/Makefile          |   1 +
 drivers/phy/phy-berlin-sata.c | 232 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 240 insertions(+)
 create mode 100644 drivers/phy/phy-berlin-sata.c

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 16a2f067c242..365ad3651e1c 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -15,6 +15,13 @@ config GENERIC_PHY
 	  phy users can obtain reference to the PHY. All the users of this
 	  framework should select this config.
 
+config PHY_BERLIN_SATA
+	tristate "Marvell Berlin SATA PHY driver"
+	depends on ARCH_BERLIN && OF
+	select GENERIC_PHY
+	help
+	  Enable this to support the SATA PHY on Marvell Berlin SoCs.
+
 config PHY_EXYNOS_MIPI_VIDEO
 	tristate "S5P/EXYNOS SoC series MIPI CSI-2/DSI PHY driver"
 	depends on HAS_IOMEM
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index b4f1d5770601..a137a2e23218 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -3,6 +3,7 @@
 #
 
 obj-$(CONFIG_GENERIC_PHY)		+= phy-core.o
+obj-$(CONFIG_PHY_BERLIN_SATA)		+= phy-berlin-sata.o
 obj-$(CONFIG_BCM_KONA_USB2_PHY)		+= phy-bcm-kona-usb2.o
 obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)	+= phy-exynos-dp-video.o
 obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
diff --git a/drivers/phy/phy-berlin-sata.c b/drivers/phy/phy-berlin-sata.c
new file mode 100644
index 000000000000..907897a02672
--- /dev/null
+++ b/drivers/phy/phy-berlin-sata.c
@@ -0,0 +1,232 @@
+/*
+ * Marvell Berlin SATA PHY driver
+ *
+ * Copyright (C) 2014 Marvell Technology Group Ltd.
+ *
+ * Antoine Ténart <antoine.tenart@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/module.h>
+#include <linux/phy/phy.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+
+#define HOST_VSA_ADDR		0x0
+#define HOST_VSA_DATA		0x4
+#define PORT_VSR_ADDR		0x78
+#define PORT_VSR_DATA		0x7c
+#define PORT_SCR_CTL		0x2c
+
+#define CONTROL_REGISTER	0x0
+#define MBUS_SIZE_CONTROL	0x4
+
+#define POWER_DOWN_PHY0			BIT(6)
+#define POWER_DOWN_PHY1			BIT(14)
+#define MBUS_WRITE_REQUEST_SIZE_128	(BIT(2) << 16)
+#define MBUS_READ_REQUEST_SIZE_128	(BIT(2) << 19)
+
+#define PHY_BASE		0x200
+
+/* register 0x01 */
+#define REF_FREF_SEL_25		BIT(0)
+#define PHY_MODE_SATA		(0x0 << 5)
+
+/* register 0x02 */
+#define USE_MAX_PLL_RATE	BIT(12)
+
+/* register 0x23 */
+#define DATA_BIT_WIDTH_10	(0x0 << 10)
+#define DATA_BIT_WIDTH_20	(0x1 << 10)
+#define DATA_BIT_WIDTH_40	(0x2 << 10)
+
+/* register 0x25 */
+#define PHY_GEN_MAX_1_5		(0x0 << 10)
+#define PHY_GEN_MAX_3_0		(0x1 << 10)
+#define PHY_GEN_MAX_6_0		(0x2 << 10)
+
+#define BERLIN_SATA_PHY_NB	2
+
+#define to_berlin_sata_phy_priv(desc)	\
+	container_of((desc), struct phy_berlin_priv, phys[(desc)->index])
+
+struct phy_berlin_desc {
+	struct phy	*phy;
+	u32		val;
+	unsigned	index;
+};
+
+struct phy_berlin_priv {
+	void __iomem		*base;
+	spinlock_t		lock;
+	struct phy_berlin_desc	phys[BERLIN_SATA_PHY_NB];
+};
+
+static inline void phy_berlin_sata_reg_setbits(void __iomem *ctrl_reg, u32 reg,
+					       u32 mask, u32 val)
+{
+	u32 regval;
+
+	/* select register */
+	writel(PHY_BASE + reg, ctrl_reg + PORT_VSR_ADDR);
+
+	/* set bits */
+	regval = readl(ctrl_reg + PORT_VSR_DATA);
+	regval &= ~mask;
+	regval |= val;
+	writel(regval, ctrl_reg + PORT_VSR_DATA);
+}
+
+static int phy_berlin_sata_power_on(struct phy *phy)
+{
+	struct phy_berlin_desc *desc = phy_get_drvdata(phy);
+	struct phy_berlin_priv *priv = to_berlin_sata_phy_priv(desc);
+	void __iomem *ctrl_reg = priv->base + 0x60 + (desc->index * 0x80);
+	int ret = 0;
+	u32 regval;
+
+	spin_lock(&priv->lock);
+
+	/* Power on PHY */
+	writel(CONTROL_REGISTER, priv->base + HOST_VSA_ADDR);
+	regval = readl(priv->base + HOST_VSA_DATA);
+	regval &= ~(desc->val);
+	writel(regval, priv->base + HOST_VSA_DATA);
+
+	/* Configure MBus */
+	writel(MBUS_SIZE_CONTROL, priv->base + HOST_VSA_ADDR);
+	regval = readl(priv->base + HOST_VSA_DATA);
+	regval |= MBUS_WRITE_REQUEST_SIZE_128 | MBUS_READ_REQUEST_SIZE_128;
+	writel(regval, priv->base + HOST_VSA_DATA);
+
+	/* set PHY mode and ref freq to 25 MHz */
+	phy_berlin_sata_reg_setbits(ctrl_reg, 0x1, 0xff,
+				    REF_FREF_SEL_25 | PHY_MODE_SATA);
+
+	/* set PHY up to 6 Gbps */
+	phy_berlin_sata_reg_setbits(ctrl_reg, 0x25, 0xc00, PHY_GEN_MAX_6_0);
+
+	/* set 40 bits width */
+	phy_berlin_sata_reg_setbits(ctrl_reg, 0x23,  0xc00, DATA_BIT_WIDTH_40);
+
+	/* use max pll rate */
+	phy_berlin_sata_reg_setbits(ctrl_reg, 0x2, 0x0, USE_MAX_PLL_RATE);
+
+	/* set the controller speed */
+	writel(0x31, ctrl_reg + PORT_SCR_CTL);
+
+	spin_unlock(&priv->lock);
+
+	return ret;
+}
+
+static int phy_berlin_sata_power_off(struct phy *phy)
+{
+	struct phy_berlin_desc *desc = phy_get_drvdata(phy);
+	struct phy_berlin_priv *priv = to_berlin_sata_phy_priv(desc);
+	u32 regval;
+
+	spin_lock(&priv->lock);
+
+	/* Power down PHY */
+	writel(CONTROL_REGISTER, priv->base + HOST_VSA_ADDR);
+	regval = readl(priv->base + HOST_VSA_DATA);
+	regval |= desc->val;
+	writel(regval, priv->base + HOST_VSA_DATA);
+
+	spin_unlock(&priv->lock);
+
+	return 0;
+}
+
+static struct phy *phy_berlin_sata_phy_xlate(struct device *dev,
+					     struct of_phandle_args *args)
+{
+	struct phy_berlin_priv *priv = dev_get_drvdata(dev);
+
+	if (WARN_ON(args->args[0] >= BERLIN_SATA_PHY_NB))
+		return ERR_PTR(-ENODEV);
+
+	return priv->phys[args->args[0]].phy;
+}
+
+static struct phy_ops phy_berlin_sata_ops = {
+	.power_on	= phy_berlin_sata_power_on,
+	.power_off	= phy_berlin_sata_power_off,
+	.owner		= THIS_MODULE,
+};
+
+static u32 phy_berlin_power_down_bits[] = {
+	POWER_DOWN_PHY0,
+	POWER_DOWN_PHY1,
+};
+
+static int phy_berlin_sata_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct phy *phy;
+	struct phy_provider *phy_provider;
+	struct phy_berlin_priv *priv;
+	struct resource *res;
+	int i;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -EINVAL;
+
+	priv->base = devm_ioremap(dev, res->start, resource_size(res));
+	if (!priv->base)
+		return -ENOMEM;
+
+	dev_set_drvdata(dev, priv);
+	spin_lock_init(&priv->lock);
+
+	for (i = 0; i < BERLIN_SATA_PHY_NB; i++) {
+		phy = devm_phy_create(dev, &phy_berlin_sata_ops, NULL);
+		if (IS_ERR(phy)) {
+			dev_err(dev, "failed to create PHY %d\n", i);
+			return PTR_ERR(phy);
+		}
+
+		priv->phys[i].phy = phy;
+		priv->phys[i].val = phy_berlin_power_down_bits[i];
+		priv->phys[i].index = i;
+		phy_set_drvdata(phy, &priv->phys[i]);
+
+		/* Make sure the PHY is off */
+		phy_berlin_sata_power_off(phy);
+	}
+
+	phy_provider =
+		devm_of_phy_provider_register(dev, phy_berlin_sata_phy_xlate);
+	if (IS_ERR(phy_provider))
+		return PTR_ERR(phy_provider);
+
+	return 0;
+}
+
+static const struct of_device_id phy_berlin_sata_of_match[] = {
+	{ .compatible = "marvell,berlin-sata-phy" },
+	{ },
+};
+
+static struct platform_driver phy_berlin_sata_driver = {
+	.probe	= phy_berlin_sata_probe,
+	.driver	= {
+		.name		= "phy-berlin-sata",
+		.owner		= THIS_MODULE,
+		.of_match_table	= phy_berlin_sata_of_match,
+	},
+};
+module_platform_driver(phy_berlin_sata_driver);
+
+MODULE_DESCRIPTION("Marvell Berlin SATA PHY driver");
+MODULE_AUTHOR("Antoine Ténart <antoine.tenart@free-electrons.com>");
+MODULE_LICENSE("GPL v2");
-- 
1.9.1

