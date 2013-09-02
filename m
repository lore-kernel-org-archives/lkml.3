Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675Ab3IBOTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 10:19:25 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52376 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756509Ab3IBOTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 10:19:23 -0400
From: Afzal Mohammed <afzal@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
        Benoit Cousson <bcousson@baylibre.com>,
        Russell King <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <rob.herring@calxeda.com>, Pavel Machek <pavel@ucw.cz>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH RFC 3/6] reset: am43x/am335x support
Date: Mon, 2 Sep 2013 19:48:31 +0530
Message-ID: <9c3c10544e365a2d0d70d1ad107f242b17b2392f.1378129416.git.afzal@ti.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <cover.1378129416.git.afzal@ti.com>
References: <cover.1378129416.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver to handle reset block in prcm of AM43x, AM335x SoC's. There are
three reset's that can be handled by this reset driver - gfx, m3 and
pruss. Of this only gfx has been handled here, adding support for the
remaining only require adding array entries with details of pruss and
m3.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 drivers/reset/Kconfig      |  14 ++++
 drivers/reset/Makefile     |   1 +
 drivers/reset/amx3_reset.c | 157 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 172 insertions(+)
 create mode 100644 drivers/reset/amx3_reset.c

diff --git a/drivers/reset/Kconfig b/drivers/reset/Kconfig
index c9d04f7..2af81b9 100644
--- a/drivers/reset/Kconfig
+++ b/drivers/reset/Kconfig
@@ -11,3 +11,17 @@ menuconfig RESET_CONTROLLER
 	  via GPIOs or SoC-internal reset controller modules.
 
 	  If unsure, say no.
+
+if	RESET_CONTROLLER
+
+config	RESET_AMX3
+	bool "AMx3 reset controller"
+	help
+	  Reset controller support for AM43x/AM335x SoC's
+
+	  Reset controller found in TI's AM series of SoC's like
+	  AM335x and AM43x
+
+	  If unsure, say no.
+
+endif
diff --git a/drivers/reset/Makefile b/drivers/reset/Makefile
index 1e2d83f..b8c1afe 100644
--- a/drivers/reset/Makefile
+++ b/drivers/reset/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_RESET_CONTROLLER) += core.o
+obj-$(CONFIG_RESET_AMX3) += amx3_reset.o
diff --git a/drivers/reset/amx3_reset.c b/drivers/reset/amx3_reset.c
new file mode 100644
index 0000000..4e476a5
--- /dev/null
+++ b/drivers/reset/amx3_reset.c
@@ -0,0 +1,157 @@
+/*
+ * PRCM reset driver for AM335x & AM43x SoC's
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/reset.h>
+#include <linux/reset-controller.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+
+#define DRIVER_NAME "amx3_reset"
+
+struct amx3_reset_reg_data {
+	u32	rstctrl_offs;
+	u32	rstst_offs;
+	u8	rstctrl_bit;
+	u8	rstst_bit;
+};
+
+struct amx3_reset_data {
+	struct	amx3_reset_reg_data *reg_data;
+	u8	nr_resets;
+};
+
+static void __iomem *reg_base;
+static const struct amx3_reset_data *amx3_reset_data;
+
+static struct amx3_reset_reg_data am335x_reset_reg_data[] = {
+	{
+		.rstctrl_offs	= 0x1104,
+		.rstst_offs	= 0x1114,
+		.rstctrl_bit	= 0,
+		.rstst_bit	= 0,
+	},
+};
+
+static struct amx3_reset_data am335x_reset_data = {
+	.reg_data	= am335x_reset_reg_data,
+	.nr_resets	= ARRAY_SIZE(am335x_reset_reg_data),
+};
+
+static struct amx3_reset_reg_data am43x_reset_reg_data[] = {
+	{
+		.rstctrl_offs	= 0x410,
+		.rstst_offs	= 0x414,
+		.rstctrl_bit	= 0,
+		.rstst_bit	= 0,
+	},
+};
+
+static struct amx3_reset_data am43x_reset_data = {
+	.reg_data	= am43x_reset_reg_data,
+	.nr_resets	= ARRAY_SIZE(am43x_reset_reg_data),
+};
+
+static int amx3_reset_clear_reset(struct reset_controller_dev *rcdev,
+				  unsigned long id)
+{
+	void __iomem *reg = amx3_reset_data->reg_data[id].rstst_offs + reg_base;
+	u8 bit = amx3_reset_data->reg_data[id].rstst_bit;
+	u32 val = readl(reg);
+
+	val &= ~(1 << bit);
+	val |= 1 << bit;
+	writel(val, reg);
+	return 0;
+}
+
+static int amx3_reset_is_reset(struct reset_controller_dev *rcdev,
+			       unsigned long id)
+{
+	void __iomem *reg = amx3_reset_data->reg_data[id].rstst_offs + reg_base;
+	u8 bit = amx3_reset_data->reg_data[id].rstst_bit;
+	u32 val = readl(reg);
+
+	val &= (1 << bit);
+	return !!val;
+}
+
+static int amx3_reset_deassert(struct reset_controller_dev *rcdev,
+			       unsigned long id)
+{
+	void __iomem *reg = amx3_reset_data->reg_data[id].rstctrl_offs +
+				reg_base;
+	u8 bit = amx3_reset_data->reg_data[id].rstctrl_bit;
+	u32 val = readl(reg);
+
+	val &= ~(1 << bit);
+	writel(val, reg);
+	return 0;
+}
+
+static struct reset_control_ops amx3_reset_ops = {
+	.deassert = amx3_reset_deassert,
+	.is_reset = amx3_reset_is_reset,
+	.clear_reset = amx3_reset_clear_reset,
+};
+
+static struct reset_controller_dev amx3_reset_controller = {
+	.ops = &amx3_reset_ops,
+};
+
+static const struct of_device_id amx3_reset_of_match[] = {
+	{ .compatible = "ti,am3352-prcm", .data = &am335x_reset_data,},
+	{ .compatible = "ti,am4372-prcm", .data = &am43x_reset_data,},
+	{},
+};
+
+static int amx3_reset_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	const struct of_device_id *id;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	reg_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(reg_base))
+		return PTR_ERR(reg_base);
+
+	amx3_reset_controller.of_node = pdev->dev.of_node;
+	id = of_match_device(amx3_reset_of_match, &pdev->dev);
+	amx3_reset_data = id->data;
+	amx3_reset_controller.nr_resets = amx3_reset_data->nr_resets;
+
+	reset_controller_register(&amx3_reset_controller);
+
+	return 0;
+}
+
+static int amx3_reset_remove(struct platform_device *pdev)
+{
+	reset_controller_unregister(&amx3_reset_controller);
+
+	return 0;
+}
+
+static struct platform_driver amx3_reset_driver = {
+	.probe	= amx3_reset_probe,
+	.remove	= amx3_reset_remove,
+	.driver	= {
+		.name		= DRIVER_NAME,
+		.owner		= THIS_MODULE,
+		.of_match_table	= of_match_ptr(amx3_reset_of_match),
+	},
+};
+module_platform_driver(amx3_reset_driver);
+
+MODULE_DESCRIPTION("PRCM reset driver for TI AM43x/AM335x SoC's");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DRIVER_NAME);
-- 
1.8.3.4

