Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704AbaELJSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 05:18:45 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56963 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751442AbaELJRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 05:17:01 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, tj@kernel.org, kishon@ti.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/6] phy: add a driver for the Berlin SATA PHY
Date: Mon, 12 May 2014 11:16:52 +0200
Message-Id: <1399886217-20474-2-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399886217-20474-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1399886217-20474-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Berlin SoC has a two SATA ports. Add a PHY driver to handle them.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 drivers/phy/Kconfig           |   5 ++
 drivers/phy/Makefile          |   1 +
 drivers/phy/phy-berlin-sata.c | 179 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 185 insertions(+)
 create mode 100644 drivers/phy/phy-berlin-sata.c

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 4906c27fa3bd..b31b1986fda4 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -15,6 +15,11 @@ config GENERIC_PHY
 	  phy users can obtain reference to the PHY. All the users of this
 	  framework should select this config.
 
+config PHY_BERLIN_SATA
+	bool
+	depends on ARCH_BERLIN && OF
+	select GENERIC_PHY
+
 config PHY_EXYNOS_MIPI_VIDEO
 	tristate "S5P/EXYNOS SoC series MIPI CSI-2/DSI PHY driver"
 	depends on HAS_IOMEM
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index 7728518572a4..40278706ac1b 100644
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
index 000000000000..f20f5ece1a7f
--- /dev/null
+++ b/drivers/phy/phy-berlin-sata.c
@@ -0,0 +1,179 @@
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
+
+#define CONTROL_REGISTER	0x0
+#define MBUS_SIZE_CONTROL	0x4
+
+#define POWER_DOWN_SATA0		BIT(6)
+#define POWER_DOWN_SATA1		BIT(14)
+#define MBUS_WRITE_REQUEST_SIZE_128	(BIT(2) << 16)
+#define MBUS_READ_REQUEST_SIZE_128	(BIT(2) << 19)
+
+#define BERLIN_SATA_PHY_NB	2
+
+#define to_berlin_sata_phy_priv(desc)	\
+	container_of((desc), struct priv, phys[(desc)->index])
+
+struct phy_desc {
+	struct phy	*phy;
+	u32		val;
+	unsigned	index;
+};
+
+struct priv {
+	void __iomem	*base;
+	spinlock_t	lock;
+	struct phy_desc	phys[BERLIN_SATA_PHY_NB];
+};
+
+static int phy_berlin_sata_power_on(struct phy *phy)
+{
+	struct phy_desc *desc = phy_get_drvdata(phy);
+	struct priv *priv = to_berlin_sata_phy_priv(desc);
+	u32 regval;
+
+	spin_lock(&priv->lock);
+
+	/* Power up PHY */
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
+	spin_unlock(&priv->lock);
+
+	return 0;
+}
+
+static int phy_berlin_sata_power_off(struct phy *phy)
+{
+	struct phy_desc *desc = phy_get_drvdata(phy);
+	struct priv *priv = to_berlin_sata_phy_priv(desc);
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
+static struct phy *berlin_sata_phy_xlate(struct device *dev,
+					 struct of_phandle_args *args)
+{
+	struct priv *priv = dev_get_drvdata(dev);
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
+static struct phy_desc desc[] = {
+	{ .val = POWER_DOWN_SATA0 },
+	{ .val = POWER_DOWN_SATA1 },
+	{ },
+};
+
+static int phy_berlin_sata_probe(struct platform_device *pdev)
+{
+	struct phy *phy;
+	struct phy_provider *phy_provider;
+	struct priv *priv;
+	struct resource *res;
+	int i;
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	priv->base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
+	if (IS_ERR(priv->base))
+		return PTR_ERR(priv->base);
+
+	phy = devm_phy_create(&pdev->dev, &phy_berlin_sata_ops, NULL);
+	if (IS_ERR(phy))
+		return PTR_ERR(phy);
+
+	dev_set_drvdata(&pdev->dev, priv);
+	spin_lock_init(&priv->lock);
+
+	for (i = 0; i < BERLIN_SATA_PHY_NB; i++) {
+		struct phy *phy = devm_phy_create(&pdev->dev,
+						  &phy_berlin_sata_ops, NULL);
+		if (IS_ERR(phy)) {
+			dev_err(&pdev->dev, "failed to create PHY %d\n", i);
+			return PTR_ERR(phy);
+		}
+
+		priv->phys[i].phy = phy;
+		priv->phys[i].val = desc[i].val;
+		priv->phys[i].index = i;
+		phy_set_drvdata(phy, &priv->phys[i]);
+
+		/* Make sure the PHY is off */
+		phy_berlin_sata_power_off(phy);
+	}
+
+	phy_provider = devm_of_phy_provider_register(&pdev->dev,
+						     berlin_sata_phy_xlate);
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
+MODULE_LICENSE("GPL");
-- 
1.9.1

