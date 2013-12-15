Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab3LOJy2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 04:54:28 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:50428 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab3LOJy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 04:54:26 -0500
From: dt.tangr@gmail.com
To: linux-leds@vger.kernel.org
Cc: Daniel Tang <dt.tangr@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] leds: add support for LSI Zevio LED controller
Date: Sun, 15 Dec 2013 20:54:11 +1100
Message-Id: <1387101253-30804-1-git-send-email-dt.tangr@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Tang <dt.tangr@gmail.com>

This adds initial support for the LED controller found on the LSI Zevio SoC.

Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
---
 drivers/leds/Kconfig      |    7 ++
 drivers/leds/Makefile     |    1 +
 drivers/leds/leds-zevio.c |  168 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 176 insertions(+)
 create mode 100644 drivers/leds/leds-zevio.c

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 72156c1..ec8b565 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -487,6 +487,13 @@ config LEDS_BLINKM
 	  This option enables support for the BlinkM RGB LED connected
 	  through I2C. Say Y to enable support for the BlinkM LED.
 
+config LEDS_ZEVIO
+	tristate "LED support for LSI Zevio LED controller"
+	depends on LEDS_CLASS
+	help
+	  This option enables support for the LSI Zevio LED controller.
+	  Say Y to enable support for the LSI Zevio LED controller.
+
 comment "LED Triggers"
 source "drivers/leds/trigger/Kconfig"
 
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 3cd76db..85c4b54 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -54,6 +54,7 @@ obj-$(CONFIG_LEDS_ASIC3)		+= leds-asic3.o
 obj-$(CONFIG_LEDS_MAX8997)		+= leds-max8997.o
 obj-$(CONFIG_LEDS_LM355x)		+= leds-lm355x.o
 obj-$(CONFIG_LEDS_BLINKM)		+= leds-blinkm.o
+obj-$(CONFIG_LEDS_ZEVIO)		+= leds-zevio.o
 
 # LED SPI Drivers
 obj-$(CONFIG_LEDS_DAC124S085)		+= leds-dac124s085.o
diff --git a/drivers/leds/leds-zevio.c b/drivers/leds/leds-zevio.c
new file mode 100644
index 0000000..017ebf0
--- /dev/null
+++ b/drivers/leds/leds-zevio.c
@@ -0,0 +1,168 @@
+/*
+ *	Copyright (C) 2013 Daniel Tang <tangrs@tangrs.id.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/device.h>
+#include <linux/of_address.h>
+#include <linux/io.h>
+#include <linux/leds.h>
+
+#define LED_CONTROL		0x00
+
+#define LED_GREEN		(1 << 4)
+#define LED_RED			(1 << 5)
+
+struct zevio_led {
+	void __iomem *base;
+
+	struct led_classdev zevio_red_led;
+	struct led_classdev zevio_green_led;
+
+	spinlock_t lock;
+};
+
+static void zevio_led_set(struct zevio_led *priv, unsigned long mask)
+{
+	u32 reg;
+
+	spin_lock(&priv->lock);
+
+	reg = readl(priv->base + LED_CONTROL);
+	writel(reg | mask, priv->base + LED_CONTROL);
+
+	spin_unlock(&priv->lock);
+}
+
+static void zevio_led_clr(struct zevio_led *priv, unsigned long mask)
+{
+	u32 reg;
+
+	spin_lock(&priv->lock);
+
+	reg = readl(priv->base + LED_CONTROL);
+	writel(reg & ~mask, priv->base + LED_CONTROL);
+
+	spin_unlock(&priv->lock);
+}
+
+static void zevio_red_set(struct led_classdev *led_cdev,
+			   enum led_brightness brightness)
+{
+	struct zevio_led *priv = container_of(led_cdev, struct zevio_led,
+					       zevio_red_led);
+
+	if (brightness == 0)
+		zevio_led_clr(priv, LED_RED);
+	else
+		zevio_led_set(priv, LED_RED);
+}
+
+static void zevio_green_set(struct led_classdev *led_cdev,
+			     enum led_brightness brightness)
+{
+	struct zevio_led *priv = container_of(led_cdev, struct zevio_led,
+					       zevio_green_led);
+
+	if (brightness == 0)
+		zevio_led_clr(priv, LED_GREEN);
+	else
+		zevio_led_set(priv, LED_GREEN);
+}
+
+static int zevio_led_probe(struct platform_device *pdev)
+{
+	struct device_node *of_node = pdev->dev.of_node;
+	struct zevio_led *priv;
+	int ret;
+	u32 reg;
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->base = of_iomap(of_node, 0);
+	if (!priv->base)
+		return -EINVAL;
+
+	spin_lock_init(&priv->lock);
+
+	reg = readl(priv->base + LED_CONTROL);
+	writel(~reg, priv->base + LED_CONTROL);
+	if (readl(priv->base + LED_CONTROL) == reg) {
+		dev_warn(&pdev->dev, "led registers appear to be read-only");
+	}
+
+	writel(0, priv->base + LED_CONTROL);
+
+	priv->zevio_red_led.name		= "zevio::red_led";
+	priv->zevio_red_led.default_trigger	= "default-on",
+	priv->zevio_red_led.max_brightness	= 1;
+	priv->zevio_red_led.brightness_set	= zevio_red_set;
+	priv->zevio_red_led.flags		= LED_CORE_SUSPENDRESUME;
+
+	priv->zevio_green_led.name		= "zevio::green_led";
+	priv->zevio_green_led.default_trigger	= "default-on",
+	priv->zevio_green_led.max_brightness	= 1;
+	priv->zevio_green_led.brightness_set	= zevio_green_set;
+	priv->zevio_green_led.flags		= LED_CORE_SUSPENDRESUME;
+
+	ret = led_classdev_register(&pdev->dev, &priv->zevio_red_led);
+	if (ret)
+		goto err_unmap;
+
+	ret = led_classdev_register(&pdev->dev, &priv->zevio_green_led);
+	if (ret)
+		goto err;
+
+	platform_set_drvdata(pdev, priv);
+
+	return 0;
+
+err:
+	led_classdev_unregister(&priv->zevio_red_led);
+
+err_unmap:
+	iounmap(priv->base);
+
+	return ret;
+}
+
+static int zevio_led_remove(struct platform_device *pdev)
+{
+	struct zevio_led *priv = platform_get_drvdata(pdev);
+
+	led_classdev_unregister(&priv->zevio_red_led);
+	led_classdev_unregister(&priv->zevio_green_led);
+
+	iounmap(priv->base);
+
+	return 0;
+}
+
+static const struct of_device_id zevio_led_dt_match[] = {
+	{ .compatible = "lsi,zevio-led" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, zevio_led_dt_match);
+
+static struct platform_driver zevio_led_driver = {
+	.driver = {
+		.name = "zevio-led",
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(zevio_led_dt_match),
+	},
+	.probe = zevio_led_probe,
+	.remove = zevio_led_remove,
+};
+
+module_platform_driver(zevio_led_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("LSI Zevio LED Driver");
-- 
1.7.10.4

