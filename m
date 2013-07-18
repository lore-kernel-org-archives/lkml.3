Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964878Ab3GRGtu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 02:49:50 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34738 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758662Ab3GRGsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 02:48:38 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <kyungmin.park@samsung.com>, <balbi@ti.com>,
        <kishon@ti.com>, <jg1.han@samsung.com>, <s.nawrocki@samsung.com>,
        <kgene.kim@samsung.com>
CC: <grant.likely@linaro.org>, <tony@atomide.com>, <arnd@arndb.de>,
        <swarren@nvidia.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <akpm@linux-foundation.org>,
        <balajitk@ti.com>, <george.cherian@ti.com>, <nsekhar@ti.com>
Subject: [PATCH 13/15] phy: Add driver for Exynos DP PHY
Date: Thu, 18 Jul 2013 12:16:22 +0530
Message-ID: <1374129984-765-14-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1374129984-765-1-git-send-email-kishon@ti.com>
References: <1374129984-765-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jingoo Han <jg1.han@samsung.com>

Add a PHY provider driver for the Samsung Exynos SoC Display Port PHY.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 .../devicetree/bindings/phy/samsung-phy.txt        |    8 ++
 drivers/phy/Kconfig                                |    6 ++
 drivers/phy/Makefile                               |    1 +
 drivers/phy/phy-exynos-dp-video.c                  |  111 ++++++++++++++++++++
 4 files changed, 126 insertions(+)
 create mode 100644 drivers/phy/phy-exynos-dp-video.c

diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt b/Documentation/devicetree/bindings/phy/samsung-phy.txt
index 5ff208c..c0fccaa 100644
--- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
+++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
@@ -12,3 +12,11 @@ the PHY specifier identifies the PHY and its meaning is as follows:
   1 - MIPI DSIM 0,
   2 - MIPI CSIS 1,
   3 - MIPI DSIM 1.
+
+Samsung EXYNOS SoC series Display Port PHY
+-------------------------------------------------
+
+Required properties:
+- compatible : should be "samsung,exynos5250-dp-video-phy";
+- reg : offset and length of the Display Port PHY register set;
+- #phy-cells : from the generic PHY bindings, must be 0;
diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 6f446d0..ed0b1b8 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -19,4 +19,10 @@ config PHY_EXYNOS_MIPI_VIDEO
 	help
 	  Support for MIPI CSI-2 and MIPI DSI DPHY found on Samsung
 	  S5P and EXYNOS SoCs.
+
+config PHY_EXYNOS_DP_VIDEO
+	tristate "EXYNOS SoC series Display Port PHY driver"
+	depends on OF
+	help
+	  Support for Display Port PHY found on Samsung EXYNOS SoCs.
 endif
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index 71d8841..0fd1340 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -4,3 +4,4 @@
 
 obj-$(CONFIG_GENERIC_PHY)		+= phy-core.o
 obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
+obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)	+= phy-exynos-dp-video.o
diff --git a/drivers/phy/phy-exynos-dp-video.c b/drivers/phy/phy-exynos-dp-video.c
new file mode 100644
index 0000000..3c8e247
--- /dev/null
+++ b/drivers/phy/phy-exynos-dp-video.c
@@ -0,0 +1,111 @@
+/*
+ * Samsung EXYNOS SoC series Display Port PHY driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ * Author: Jingoo Han <jg1.han@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/phy/phy.h>
+#include <linux/platform_device.h>
+
+/* DPTX_PHY_CONTROL register */
+#define EXYNOS_DPTX_PHY_ENABLE		(1 << 0)
+
+struct exynos_dp_video_phy {
+	void __iomem *regs;
+};
+
+static int __set_phy_state(struct exynos_dp_video_phy *state, unsigned int on)
+{
+	u32 reg;
+
+	reg = readl(state->regs);
+	if (on)
+		reg |= EXYNOS_DPTX_PHY_ENABLE;
+	else
+		reg &= ~EXYNOS_DPTX_PHY_ENABLE;
+	writel(reg, state->regs);
+
+	return 0;
+}
+
+static int exynos_dp_video_phy_power_on(struct phy *phy)
+{
+	struct exynos_dp_video_phy *state = phy_get_drvdata(phy);
+
+	return __set_phy_state(state, 1);
+}
+
+static int exynos_dp_video_phy_power_off(struct phy *phy)
+{
+	struct exynos_dp_video_phy *state = phy_get_drvdata(phy);
+
+	return __set_phy_state(state, 0);
+}
+
+static struct phy_ops exynos_dp_video_phy_ops = {
+	.power_on	= exynos_dp_video_phy_power_on,
+	.power_off	= exynos_dp_video_phy_power_off,
+	.owner		= THIS_MODULE,
+};
+
+static int exynos_dp_video_phy_probe(struct platform_device *pdev)
+{
+	struct exynos_dp_video_phy *state;
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+	struct phy_provider *phy_provider;
+	struct phy *phy;
+
+	state = devm_kzalloc(dev, sizeof(*state), GFP_KERNEL);
+	if (!state)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	state->regs = devm_ioremap_resource(dev, res);
+	if (IS_ERR(state->regs))
+		return PTR_ERR(state->regs);
+
+	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
+	if (IS_ERR(phy_provider))
+		return PTR_ERR(phy_provider);
+
+	phy = devm_phy_create(dev, 0, &exynos_dp_video_phy_ops, NULL);
+	if (IS_ERR(phy)) {
+		dev_err(dev, "failed to create Display Port PHY\n");
+		return PTR_ERR(phy);
+	}
+	phy_set_drvdata(phy, state);
+
+	return 0;
+}
+
+static const struct of_device_id exynos_dp_video_phy_of_match[] = {
+	{ .compatible = "samsung,exynos5250-dp-video-phy" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, exynos_dp_video_phy_of_match);
+
+static struct platform_driver exynos_dp_video_phy_driver = {
+	.probe	= exynos_dp_video_phy_probe,
+	.driver = {
+		.name	= "exynos-dp-video-phy",
+		.owner	= THIS_MODULE,
+		.of_match_table	= exynos_dp_video_phy_of_match,
+	}
+};
+module_platform_driver(exynos_dp_video_phy_driver);
+
+MODULE_AUTHOR("Jingoo Han <jg1.han@samsung.com>");
+MODULE_DESCRIPTION("Samsung EXYNOS SoC DP PHY driver");
+MODULE_LICENSE("GPL v2");
-- 
1.7.10.4

