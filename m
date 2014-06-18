Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966789AbaFRNpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 09:45:44 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:44901 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbaFRNpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 09:45:42 -0400
From: Houcheng Lin <houcheng@gmail.com>
To: linus.walleij@linaro.org, gnurou@gmail.com, grant.likely@linaro.org,
        robh+dt@kernel.org, dbaryshkov@gmail.com, dwmw2@infradead.org,
        p.zabel@pengutronix.de, stephen.gallimore@st.com,
        srinivas.kandagatla@st.com, maxime.ripard@free-electrons.com,
        ulf.hansson@linaro.org, sre@kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, Houcheng Lin <houcheng@gmail.com>
Subject: [RFC PATCH v3] reset: Add a defer reset object to send board specific reset
Date: Wed, 18 Jun 2014 21:37:53 +0800
Message-Id: <1403098673-3058-1-git-send-email-houcheng@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Problem
-----------
The reset signal on a hardware board is send either:
    - during machine initialization
    - during bus master's initialization

In some hardware design, devices on bus need a non-standard and extra reset
signal after bus is initialied. Most reason is to wake up device from hanging
state.

The board spefic reset code can not be put into machine init code, as it is
too early. This code can not also be put onto chip's driver, as it is board
specific and not suitable for a common chip driver.

Defer Reset Object
------------------
The defer reset object is to resolve this issue, developer can put a defer-
reset device on the board's dts file and enable DEFER RESET OBJECT CONFIG.
During driver init-calls, a defer-reset object is created and issue reset signal
after the enclosing device is initialized.

This eliminate the need to rewrite a driver module with only one purpose: sending
a board specific reset. This also allow mainstream kernel to support many boards
that modify the common drivers to send board specific reset. Configuring defer-reset
device in dts leave the board specific reset rules on board level and simple to
maintain.

Example dts File
----------------
Example 1:
    defer_reset_vbus {
        compatible = "defer-reset";
        reset-gpios = <&gpx3 5 GPIO_ACTIVE_LOW>;
        duration = <5>;
    };

Example 2:
    defer_reset_vbus {
        compatible = "defer-reset";
        reset-gpios = <&gpx3 5 GPIO_ACTIVE_HIGH>;
        duration = <0>;
    };

Block Diagram of dts File
-------------------------
    +-------------------------------------+
    | usb-ehci-chip@1211000               |
    |   +-------------------------+       |
    |   | defer-reset(gpx3)       |       |
    |   +-------------------------+       |
    +-------------------------------------+

Signed-off-by: Houcheng Lin <houcheng@gmail.com>
---
 .../devicetree/bindings/reset/gpio-defer-reset.txt |  30 ++++
 drivers/reset/Kconfig                              |   8 +
 drivers/reset/Makefile                             |   1 +
 drivers/reset/gpio-defer-reset.c                   | 180 +++++++++++++++++++++
 4 files changed, 219 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/reset/gpio-defer-reset.txt
 create mode 100644 drivers/reset/gpio-defer-reset.c

diff --git a/Documentation/devicetree/bindings/reset/gpio-defer-reset.txt b/Documentation/devicetree/bindings/reset/gpio-defer-reset.txt
new file mode 100644
index 0000000..2ef416e
--- /dev/null
+++ b/Documentation/devicetree/bindings/reset/gpio-defer-reset.txt
@@ -0,0 +1,30 @@
+GPIO defer reset binding
+
+Put a defer-reset device in a device node and enable DEFER RESET OBJECT CONFIG.
+During driver init-calls, a defer-reset object will be created and issue reset
+signal after the enclosing device node's initialization complete.
+
+Required properties:
+- compatible:
+  - "defer-reset" for creating defer reset object
+- reset-gpio: specify gpio pin to send reset signal, GPIO_ACTIVE_LOW indicates
+              the reset signal is low and would revert line back to high.
+              It can be an array.
+- duration: specify reset signal duration in ms, 0 indicates hold the reset
+            signal forever.
+            It can be an array.
+
+Example 1:
+	defer_reset_vbus {
+		compatible = "defer-reset";
+		reset-gpios = <&gpx3 5 GPIO_ACTIVE_LOW>;
+		duration = <5>;
+	};
+
+Example 2:
+	defer_reset_vbus {
+		compatible = "defer-reset";
+		reset-gpios = <&gpx3 5 GPIO_ACTIVE_HIGH>;
+		duration = <0>;
+	};
+
diff --git a/drivers/reset/Kconfig b/drivers/reset/Kconfig
index 0615f50..d53eb26 100644
--- a/drivers/reset/Kconfig
+++ b/drivers/reset/Kconfig
@@ -12,4 +12,12 @@ menuconfig RESET_CONTROLLER
 
 	  If unsure, say no.
 
+config GPIO_DEFER_RESET
+	bool "Defer reset driver via gpio"
+	depends on OF_GPIO
+	help
+	  Enable defer reset drvier
+	  The reset signal would be issued after a device on USB or PCI bus is initialied.
+	  The dependency of reset signal and device can be specified in board's dts file.
+
 source "drivers/reset/sti/Kconfig"
diff --git a/drivers/reset/Makefile b/drivers/reset/Makefile
index 4f60caf..a3fdfef 100644
--- a/drivers/reset/Makefile
+++ b/drivers/reset/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_RESET_CONTROLLER) += core.o
 obj-$(CONFIG_ARCH_SUNXI) += reset-sunxi.o
 obj-$(CONFIG_ARCH_STI) += sti/
+obj-$(CONFIG_GPIO_DEFER_RESET)	+= gpio-defer-reset.o
diff --git a/drivers/reset/gpio-defer-reset.c b/drivers/reset/gpio-defer-reset.c
new file mode 100644
index 0000000..e75ec14
--- /dev/null
+++ b/drivers/reset/gpio-defer-reset.c
@@ -0,0 +1,180 @@
+/*
+ * GPIO Defer Reset Driver
+ *
+ * Copyright (C) 2014 Houcheng Lin
+ * Author: Houcheng Lin <houcheng@gmail.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ */
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/gpio/consumer.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+
+#define DRIVER_NAME "defer-reset"
+#define DRIVER_DESC "GPIO defer reset driver"
+#define GDR_MAX_DEV 32
+
+
+static DEFINE_MUTEX(deferred_reset_mutex);
+static LIST_HEAD(deferred_reset_list);
+
+struct defer_reset_private {
+	struct list_head lnode;
+	struct device_node *node;  /* defer_reset device */
+};
+
+static void __exit gdr_cleanup(void);
+
+
+/*
+ * Try to force active_low if board DTS does not configure the
+ * GPIO_ACTIVE_LOW properties into gpio chip.
+ */
+static void gdr_issue_reset_gpio(struct gpio_desc *gpiod, int val,
+	enum of_gpio_flags  flags)
+{
+	if (flags == OF_GPIO_ACTIVE_LOW && !gpiod_is_active_low(gpiod))
+		gpiod_set_value(gpiod, !val);
+	else
+		gpiod_set_value(gpiod, val);
+}
+
+
+static int gdr_issue_reset_line(
+	struct device_node *of_node, int index, int val)
+{
+	enum of_gpio_flags flags = 0;
+	struct gpio_desc *gpiod;
+	gpiod = of_get_named_gpiod_flags(of_node, "reset-gpios", index, &flags);
+	if (IS_ERR(gpiod))
+		return -PTR_ERR(gpiod);
+	gdr_issue_reset_gpio(gpiod, val, flags);
+	return 0;
+}
+
+/**
+ *  @pdev: deferred reset object's pdev
+ *  @of_node: deferred reset object's OF node
+ */
+static int gdr_issue_reset(
+	struct platform_device *pdev, struct device_node *of_node)
+{
+	int i;
+	int count = of_gpio_named_count(of_node, "reset-gpios");
+	u32 duration = 5;
+
+	if (count > GDR_MAX_DEV) {
+		dev_err(&pdev->dev, "too large reset array!\n");
+		return -EINVAL;
+	}
+	dev_info(&pdev->dev, "send reset signal for device [%s]\n",
+		of_node->parent->name);
+	/* setup parameters */
+	of_property_read_u32(of_node, "duration", &duration);
+	for (i = 0; i < count; i++) {
+		int ret = gdr_issue_reset_line(of_node, i, 1);
+		if (ret < 0)
+			dev_err(&pdev->dev, "error get gpiod:%d\n", ret);
+	}
+	/** hold reset signal forever if duration 0 */
+	if (duration == 0)
+		return 0;
+	mdelay(duration);
+	for (i = 0; i < count; i++) {
+		int ret = gdr_issue_reset_line(of_node, i, 0);
+		if (ret < 0)
+			dev_err(&pdev->dev, "error get gpiod:%d\n", ret);
+	}
+	return 0;
+}
+
+/*
+ * The pdev parameter is provided by register routine,
+ * platform_device_register_simple()
+ */
+static int gdr_probe(struct platform_device *pdev_gdr)
+{
+	struct list_head *pos, *n;
+
+	pr_debug("gpio defer reset probe\n");
+
+	mutex_lock(&deferred_reset_mutex);
+	list_for_each_safe(pos, n, &deferred_reset_list) {
+		struct defer_reset_private *pdata;
+		struct platform_device *pdev;
+		pdata = list_entry(pos, struct defer_reset_private, lnode);
+		pdev = of_find_device_by_node(pdata->node->parent);
+		if (pdev != NULL && pdev->dev.driver != NULL) {
+			gdr_issue_reset(pdev_gdr, pdata->node);
+			list_del(pos);
+			kfree(pdata);
+		}
+	}
+	mutex_unlock(&deferred_reset_mutex);
+	list_for_each(pos, &deferred_reset_list) {
+		return -EPROBE_DEFER;
+	}
+	dev_err(&pdev_gdr->dev, "return %d to release resources\n", -EUCLEAN);
+	return -EUCLEAN;
+}
+
+
+
+#ifdef CONFIG_OF
+static const struct of_device_id gdr_match[] = {
+	{ .compatible = "defer-reset" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, gdr_match);
+#endif
+
+static struct platform_driver gdr_driver = {
+	.probe      = gdr_probe,
+	.driver = {
+		.name   = DRIVER_NAME,
+		.owner  = THIS_MODULE,
+		.of_match_table = of_match_ptr(gdr_match),
+	}
+};
+
+
+static int __init gdr_init(void)
+{
+	struct device_node *node;
+	pr_info("defer-reset object initialied.\n");
+	platform_device_register_simple("defer-reset", -1, NULL, 0);
+	mutex_lock(&deferred_reset_mutex);
+	for_each_compatible_node(node, NULL, "defer-reset") {
+		struct defer_reset_private *pdata = kmalloc(
+			sizeof(struct defer_reset_private), GFP_KERNEL);
+		pdata->node = node;
+		list_add_tail(&pdata->lnode, &deferred_reset_list);
+	}
+	mutex_unlock(&deferred_reset_mutex);
+	return platform_driver_register(&gdr_driver);
+}
+
+module_init(gdr_init);
+
+static void __exit gdr_cleanup(void)
+{
+	pr_info("defer-reset cleanup.\n");
+	platform_driver_unregister(&gdr_driver);
+}
+
+module_exit(gdr_cleanup);
+
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_ALIAS("platform:defer-reset");
+MODULE_AUTHOR("Houcheng Lin");
+MODULE_LICENSE("GPL v2");
-- 
1.9.1

