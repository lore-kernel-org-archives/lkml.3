Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364AbaFOHL6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 03:11:58 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:51870 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbaFOHLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 03:11:55 -0400
From: Houcheng Lin <houcheng@gmail.com>
To: linus.walleij@linaro.org, gnurou@gmail.com, grant.likely@linaro.org,
        robh+dt@kernel.org, dbaryshkov@gmail.com, dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org, Houcheng Lin <houcheng@gmail.com>
Subject: [PATCH] [RFC PATCH v2] power:reset: Add defer reset object to send board specific reset
Date: Sun, 15 Jun 2014 15:11:29 +0800
Message-Id: <1402816289-7024-1-git-send-email-houcheng@gmail.com>
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
    usb-ehci-chip@1211000{
        usb-phy = <&usb2_phy>;
        defer_reset_vbus {
            compatible = "defer-reset";
            reset-gpios = <&gpx3 5 1>;
            reset-init = <0>;
            reset-end = <1>;
            delay = <5>;
        };
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
 .../devicetree/bindings/gpio/gpio-defer-reset.txt  |  22 +++
 drivers/power/reset/Kconfig                        |   8 +
 drivers/power/reset/Makefile                       |   1 +
 drivers/power/reset/gpio-defer-reset.c             | 192 +++++++++++++++++++++
 4 files changed, 223 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-defer-reset.txt
 create mode 100644 drivers/power/reset/gpio-defer-reset.c

diff --git a/Documentation/devicetree/bindings/gpio/gpio-defer-reset.txt b/Documentation/devicetree/bindings/gpio/gpio-defer-reset.txt
new file mode 100644
index 0000000..5d55830
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio-defer-reset.txt
@@ -0,0 +1,22 @@
+GPIO defer reset binding
+
+Put a defer-reset device in a device node and enable DEFER RESET OBJECT CONFIG.
+During driver init-calls, a defer-reset object will be created and issue reset
+signal after the enclosing device node's initialization complete.
+
+Required properties:
+- compatible:
+  - "defer-reset" for creating defer reset object
+- reset-gpio: specify gpio pin, can be an array.
+- reset-init: specify reset signal initial value, can be 0 or 1.
+- reset-end: specify reset signal end value, can be 0 or 1.
+- delay: specify reset duration in ms.
+
+Example:
+	defer_reset_vbus {
+		compatible = "defer-reset";
+		reset-gpios = <&gpx3 5 1>;
+		reset-init = <0>;
+		reset-end = <1>;
+		delay = <5>;
+	};
diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
index fa0e4e0..74b7eb0 100644
--- a/drivers/power/reset/Kconfig
+++ b/drivers/power/reset/Kconfig
@@ -57,3 +57,11 @@ config POWER_RESET_XGENE
 	depends on POWER_RESET
 	help
 	  Reboot support for the APM SoC X-Gene Eval boards.
+
+config GPIO_DEFER_RESET
+	bool "Defer reset driver via gpio"
+	depends on OF_GPIO && POWER_RESET
+	help
+	  Enable defer reset drvier
+	  The reset signal would be issued after a device on USB or PCI bus is initialied.
+	  The dependency of reset signal and device can be specified in board's dts file.
diff --git a/drivers/power/reset/Makefile b/drivers/power/reset/Makefile
index a5b4a77..166baf9 100644
--- a/drivers/power/reset/Makefile
+++ b/drivers/power/reset/Makefile
@@ -5,3 +5,4 @@ obj-$(CONFIG_POWER_RESET_QNAP) += qnap-poweroff.o
 obj-$(CONFIG_POWER_RESET_RESTART) += restart-poweroff.o
 obj-$(CONFIG_POWER_RESET_VEXPRESS) += vexpress-poweroff.o
 obj-$(CONFIG_POWER_RESET_XGENE) += xgene-reboot.o
+obj-$(CONFIG_GPIO_DEFER_RESET)	+= gpio-defer-reset.o
diff --git a/drivers/power/reset/gpio-defer-reset.c b/drivers/power/reset/gpio-defer-reset.c
new file mode 100644
index 0000000..6425519
--- /dev/null
+++ b/drivers/power/reset/gpio-defer-reset.c
@@ -0,0 +1,192 @@
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
+	struct list_head next;
+	struct device_node *node;  /* defer_reset device */
+};
+
+static void __exit gdr_cleanup(void);
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
+	u8 reset_init[GDR_MAX_DEV];
+	u8 reset_end[GDR_MAX_DEV];
+	u8 delay;
+
+	if (count != of_property_count_u32_elems(of_node, "reset-init")) {
+		dev_err(&pdev->dev, "should call std error here, number is wrong:%d\n",
+			of_property_count_u32_elems(of_node, "reset-init"));
+		return -EINVAL;
+	}
+	if (count != of_property_count_u32_elems(of_node, "reset-end")) {
+		dev_err(&pdev->dev, "should call std error here, number is wrong:%d\n",
+			of_property_count_u32_elems(of_node, "reset-end"));
+		return -EINVAL;
+	}
+	if (count > GDR_MAX_DEV) {
+		dev_err(&pdev->dev, "too large reset array!\n");
+		return -EINVAL;
+	}
+
+	/* setup parameters */
+	of_property_read_u8_array(of_node, "reset-init", reset_init, count);
+	of_property_read_u8_array(of_node, "reset-end", reset_end, count);
+	of_property_read_u8(of_node, "delay", &delay);
+
+	/* HC DEBUG CODE, WONT COMMIT
+	printk("gpio num:%d\n", of_get_named_gpio(of_node, "reset-gpios", i));
+	printk("gpiod to gpio num:%d\n", desc_to_gpio(gpiod)); */
+	/* reset init */
+	for (i = 0; i < count; i++) {
+		struct gpio_desc *gpiod = of_get_named_gpiod_flags(of_node,
+			"reset-gpios", i, NULL);
+		if (IS_ERR(gpiod)) {
+			dev_err(&pdev->dev, "error get gpiod:%ld\n",
+				PTR_ERR(gpiod));
+			continue;
+		}
+		dev_info(&pdev->dev, "issue reset to gpio for device [%s]\n",
+			of_node->parent->name);
+		gpiod_set_value(gpiod, reset_init[i]);
+		gpiod_put(gpiod);
+	}
+	if (delay == 0)
+		delay = 5;
+	mdelay(delay);
+	for (i = 0; i < count; i++) {
+		struct gpio_desc *gpiod = of_get_named_gpiod_flags(of_node,
+			"reset-gpios", i, NULL);
+		if (IS_ERR(gpiod)) {
+			dev_err(&pdev->dev, "error get gpiod:%ld\n",
+				PTR_ERR(gpiod));
+			continue;
+		}
+		gpiod_set_value(gpiod, reset_end[i]);
+		gpiod_put(gpiod);
+	}
+	return 0;
+}
+
+/**
+  * the pdev parameter is provided by register routine, platform_device_register_simple
+  **/
+static int gdr_probe(struct platform_device *pdev_gdr)
+{
+	struct list_head *pos, *n;
+
+	pr_debug("gpio defer reset probe\n");
+
+	mutex_lock(&deferred_reset_mutex);
+	list_for_each_safe(pos, n, &deferred_reset_list) {
+		struct platform_device *pdev;
+		struct defer_reset_private *pdata = list_entry(
+			pos, struct defer_reset_private, next);
+		pdev = of_find_device_by_node(pdata->node->parent);
+		if (pdev != NULL && pdev->dev.driver != NULL) {
+			gdr_issue_reset(pdev_gdr, pdata->node);
+			list_del(&pdata->next);
+			kfree(pdata);
+		}
+		/**
+		 * for some device no register platfrom deivce yet
+		 * druing probe will be dropped??
+		 */
+		if (pdev == NULL) {
+			list_del(&pdata->next);
+			kfree(pdata);
+		}
+
+	}
+	mutex_unlock(&deferred_reset_mutex);
+	list_for_each(pos, &deferred_reset_list) {
+		return -EPROBE_DEFER;
+	}
+	platform_device_unregister(pdev_gdr);
+	gdr_cleanup();
+	return 0;
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
+		list_add_tail(&pdata->next, &deferred_reset_list);
+	}
+	mutex_unlock(&deferred_reset_mutex);
+	return platform_driver_register(&gdr_driver);
+}
+
+module_init(gdr_init);
+
+static void __exit gdr_cleanup(void)
+{
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

