Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab3A3DDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 22:03:32 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13606 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab3A3DCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 22:02:51 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 29 Jan 2013 19:02:21 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Stephen Warren <swarren@wwwdotorg.org>, Mark Zhang <markz@nvidia.com>
CC: <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [RFC 1/4] video: panel: add CLAA101WA01A panel support
Date: Wed, 30 Jan 2013 12:02:16 +0900
Message-ID: <1359514939-15653-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359514939-15653-1-git-send-email-acourbot@nvidia.com>
References: <1359514939-15653-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the Chunghwa CLAA101WA01A display panel.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 .../video/display/chunghwa,claa101wa01a.txt        |   8 +
 drivers/video/display/Kconfig                      |   8 +
 drivers/video/display/Makefile                     |   1 +
 drivers/video/display/panel-claa101wa01a.c         | 209 +++++++++++++++++++++
 4 files changed, 226 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/video/display/chunghwa,claa101wa01a.txt
 create mode 100644 drivers/video/display/panel-claa101wa01a.c

diff --git a/Documentation/devicetree/bindings/video/display/chunghwa,claa101wa01a.txt b/Documentation/devicetree/bindings/video/display/chunghwa,claa101wa01a.txt
new file mode 100644
index 0000000..cfdc7fd
--- /dev/null
+++ b/Documentation/devicetree/bindings/video/display/chunghwa,claa101wa01a.txt
@@ -0,0 +1,8 @@
+Chunghwa CLAA101WA01A Display Panel
+
+Required properties:
+- compatible: "chunghwa,claa101wa01a"
+- pnl-supply: regulator controlling power supply to the panel
+- bl-supply: regulator controlling power supply to the backlight
+- pnl-enable-gpios: GPIO that enables the panel
+- bl-enable-gpios: GPIO that enables the backlight
diff --git a/drivers/video/display/Kconfig b/drivers/video/display/Kconfig
index 9ca2e60..6902abb 100644
--- a/drivers/video/display/Kconfig
+++ b/drivers/video/display/Kconfig
@@ -32,4 +32,12 @@ config DISPLAY_PANEL_R61517
 
 	  If you are in doubt, say N.
 
+config DISPLAY_PANEL_CLAA101WA01A
+	tristate "Chunghwa CLAA101WA01A Display Panel"
+	select BACKLIGHT_PWM
+	---help---
+	  Support for the Chunghwa CLAA101WA01A Display Panel.
+
+	  If you are in doubt, say N.
+
 endif # DISPLAY_CORE
diff --git a/drivers/video/display/Makefile b/drivers/video/display/Makefile
index ec557a1..19084a2 100644
--- a/drivers/video/display/Makefile
+++ b/drivers/video/display/Makefile
@@ -2,3 +2,4 @@ obj-$(CONFIG_DISPLAY_CORE) += display-core.o
 obj-$(CONFIG_DISPLAY_PANEL_DPI) += panel-dpi.o
 obj-$(CONFIG_DISPLAY_PANEL_R61505) += panel-r61505.o
 obj-$(CONFIG_DISPLAY_PANEL_R61517) += panel-r61517.o
+obj-$(CONFIG_DISPLAY_PANEL_CLAA101WA01A) += panel-claa101wa01a.o
diff --git a/drivers/video/display/panel-claa101wa01a.c b/drivers/video/display/panel-claa101wa01a.c
new file mode 100644
index 0000000..93ae86b
--- /dev/null
+++ b/drivers/video/display/panel-claa101wa01a.c
@@ -0,0 +1,209 @@
+/*
+ * CLAA101WA01A Display Panel
+ *
+ * Copyright (C) 2013 NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/regulator/consumer.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
+
+#include <video/display.h>
+
+#define CLAA101WA01A_WIDTH	223
+#define CLAA101WA01A_HEIGHT	125
+
+struct panel_claa101 {
+	struct display_entity entity;
+	struct regulator *vdd_pnl;
+	struct regulator *vdd_bl;
+	/* Enable GPIOs */
+	int pnl_enable;
+	int bl_enable;
+};
+
+#define to_panel_claa101(p)	container_of(p, struct panel_claa101, entity)
+
+static int panel_claa101_set_state(struct display_entity *entity,
+				   enum display_entity_state state)
+{
+	struct panel_claa101 *panel = to_panel_claa101(entity);
+
+	/* OFF and STANDBY are equivalent to us */
+	if (state == DISPLAY_ENTITY_STATE_STANDBY)
+		state = DISPLAY_ENTITY_STATE_OFF;
+
+	switch (state) {
+	case DISPLAY_ENTITY_STATE_OFF:
+	case DISPLAY_ENTITY_STATE_STANDBY:
+		if (entity->source)
+			display_entity_set_stream(entity->source,
+						 DISPLAY_ENTITY_STREAM_STOPPED);
+
+		/* TODO error checking? */
+		gpio_set_value_cansleep(panel->bl_enable, 0);
+		usleep_range(10000, 10000);
+		regulator_disable(panel->vdd_bl);
+		usleep_range(200000, 200000);
+		gpio_set_value_cansleep(panel->pnl_enable, 0);
+		regulator_disable(panel->vdd_pnl);
+		break;
+
+	case DISPLAY_ENTITY_STATE_ON:
+		regulator_enable(panel->vdd_pnl);
+		gpio_set_value_cansleep(panel->pnl_enable, 1);
+		usleep_range(200000, 200000);
+		regulator_enable(panel->vdd_bl);
+		usleep_range(10000, 10000);
+		gpio_set_value_cansleep(panel->bl_enable, 1);
+
+		if (entity->source)
+			display_entity_set_stream(entity->source,
+					      DISPLAY_ENTITY_STREAM_CONTINUOUS);
+		break;
+	}
+
+	return 0;
+}
+
+static int panel_claa101_get_modes(struct display_entity *entity,
+				   const struct videomode **modes)
+{
+	/* TODO get modes from EDID? */
+	return 0;
+}
+
+static int panel_claa101_get_size(struct display_entity *entity,
+				  unsigned int *width, unsigned int *height)
+{
+	*width = CLAA101WA01A_WIDTH;
+	*height = CLAA101WA01A_HEIGHT;
+
+	return 0;
+}
+
+static int panel_claa101_get_params(struct display_entity *entity,
+				 struct display_entity_interface_params *params)
+{
+	return 0;
+}
+
+static const struct display_entity_control_ops panel_claa101_control_ops = {
+	.set_state = panel_claa101_set_state,
+	.get_modes = panel_claa101_get_modes,
+	.get_size = panel_claa101_get_size,
+	.get_params = panel_claa101_get_params,
+};
+
+static int __init panel_claa101_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct panel_claa101 *panel;
+	int err;
+
+	panel = devm_kzalloc(dev, sizeof(*panel), GFP_KERNEL);
+	if (!panel)
+		return -ENOMEM;
+
+	panel->vdd_pnl = devm_regulator_get(dev, "pnl");
+	if (IS_ERR(panel->vdd_pnl)) {
+		dev_err(dev, "cannot get vdd regulator\n");
+		return PTR_ERR(panel->vdd_pnl);
+	}
+
+	panel->vdd_bl = devm_regulator_get(dev, "bl");
+	if (IS_ERR(panel->vdd_bl)) {
+		dev_err(dev, "cannot get bl regulator\n");
+		return PTR_ERR(panel->vdd_bl);
+	}
+
+	err = of_get_named_gpio(dev->of_node, "pnl-enable-gpios", 0);
+	if (err < 0) {
+		dev_err(dev, "cannot find panel enable GPIO!\n");
+		return err;
+	}
+	panel->pnl_enable = err;
+	err = devm_gpio_request_one(dev, panel->pnl_enable,
+				    GPIOF_DIR_OUT | GPIOF_INIT_LOW, "panel");
+	if (err < 0) {
+		dev_err(dev, "cannot acquire panel enable GPIO!\n");
+		return err;
+	}
+
+	err = of_get_named_gpio(dev->of_node, "bl-enable-gpios", 0);
+	if (err < 0) {
+		dev_err(dev, "cannot find backlight enable GPIO!\n");
+		return err;
+	}
+	panel->bl_enable = err;
+	err = devm_gpio_request_one(dev, panel->bl_enable,
+				   GPIOF_DIR_OUT | GPIOF_INIT_LOW, "backlight");
+	if (err < 0) {
+		dev_err(dev, "cannot acquire backlight enable GPIO!\n");
+		return err;
+	}
+
+	panel->entity.dev = dev;
+	panel->entity.ops.ctrl = &panel_claa101_control_ops;
+	err = display_entity_register(&panel->entity);
+	if (err < 0)
+		return err;
+
+	platform_set_drvdata(pdev, panel);
+
+	dev_info(dev, "%s successful\n", __func__);
+
+	return 0;
+}
+
+static int __exit panel_claa101_remove(struct platform_device *pdev)
+{
+	struct panel_claa101 *panel = platform_get_drvdata(pdev);
+
+	display_entity_unregister(&panel->entity);
+
+	return 0;
+}
+
+#ifdef CONFIG_OF
+static struct of_device_id panel_claa101_of_match[] = {
+	{ .compatible = "chunghwa,claa101wa01a", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, pwm_backlight_of_match);
+#else
+#endif
+
+static const struct dev_pm_ops panel_claa101_dev_pm_ops = {
+};
+
+static struct platform_driver panel_claa101_driver = {
+	.probe = panel_claa101_probe,
+	.remove = panel_claa101_remove,
+	.driver = {
+		.name = "panel_claa101wa01a",
+		.owner = THIS_MODULE,
+#ifdef CONFIG_PM
+		.pm = &panel_claa101_dev_pm_ops,
+#endif
+#ifdef CONFIG_OF
+		.of_match_table	= of_match_ptr(panel_claa101_of_match),
+#endif
+	},
+};
+
+module_platform_driver(panel_claa101_driver);
+
+MODULE_AUTHOR("Alexandre Courbot <acourbot@nvidia.com>");
+MODULE_DESCRIPTION("Chunghwa CLAA101WA01A Display Panel");
+MODULE_LICENSE("GPL");
-- 
1.8.1.1

