Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbaGWJES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 05:04:18 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:42129 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757374AbaGWJEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 05:04:14 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v2] fb: backlight: add driver for iPAQ micro backlight
Date: Wed, 23 Jul 2014 11:04:03 +0200
Message-Id: <1406106243-20498-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a driver for the backlight controlled by the microcontroller
on the Compaq iPAQ series of handheld computers: h3100, h3600
and h3700.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Add a comment to clarify message format
- Coding format and style fixes
- Drop driver announce boilerplate
- Drop empty remove() function
---
 drivers/video/backlight/Kconfig         |  9 ++++
 drivers/video/backlight/Makefile        |  1 +
 drivers/video/backlight/ipaq_micro_bl.c | 83 +++++++++++++++++++++++++++++++++
 3 files changed, 93 insertions(+)
 create mode 100644 drivers/video/backlight/ipaq_micro_bl.c

diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index 5d449059a556..cc153f55d9f9 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -207,6 +207,15 @@ config BACKLIGHT_GENERIC
 	  known as the Corgi backlight driver. If you have a Sharp Zaurus
 	  SL-C7xx, SL-Cxx00 or SL-6000x say y.
 
+config BACKLIGHT_IPAQ_MICRO
+	tristate "iPAQ microcontroller backlight driver"
+	depends on MFD_IPAQ_MICRO
+	default y
+	help
+	  Say y to enable the backlight driver for Compaq iPAQ handheld
+	  computers. Say yes if you have one of the h3100/h3600/h3700
+	  machines.
+
 config BACKLIGHT_LM3533
 	tristate "Backlight Driver for LM3533"
 	depends on BACKLIGHT_CLASS_DEVICE
diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
index bb820024f346..a9ea34a39cad 100644
--- a/drivers/video/backlight/Makefile
+++ b/drivers/video/backlight/Makefile
@@ -36,6 +36,7 @@ obj-$(CONFIG_BACKLIGHT_GENERIC)		+= generic_bl.o
 obj-$(CONFIG_BACKLIGHT_GPIO)		+= gpio_backlight.o
 obj-$(CONFIG_BACKLIGHT_HP680)		+= hp680_bl.o
 obj-$(CONFIG_BACKLIGHT_HP700)		+= jornada720_bl.o
+obj-$(CONFIG_BACKLIGHT_IPAQ_MICRO)	+= ipaq_micro_bl.o
 obj-$(CONFIG_BACKLIGHT_LM3533)		+= lm3533_bl.o
 obj-$(CONFIG_BACKLIGHT_LM3630A)		+= lm3630a_bl.o
 obj-$(CONFIG_BACKLIGHT_LM3639)		+= lm3639_bl.o
diff --git a/drivers/video/backlight/ipaq_micro_bl.c b/drivers/video/backlight/ipaq_micro_bl.c
new file mode 100644
index 000000000000..88a3816da31e
--- /dev/null
+++ b/drivers/video/backlight/ipaq_micro_bl.c
@@ -0,0 +1,83 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * iPAQ microcontroller backlight support
+ * Author : Linus Walleij <linus.walleij@linaro.org>
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/backlight.h>
+#include <linux/mfd/ipaq-micro.h>
+#include <linux/fb.h>
+#include <linux/err.h>
+
+static int micro_bl_update_status(struct backlight_device *bd)
+{
+	struct ipaq_micro *micro = dev_get_drvdata(&bd->dev);
+	int intensity = bd->props.brightness;
+	struct ipaq_micro_msg msg = {
+		.id = MSG_BACKLIGHT,
+		.tx_len = 3,
+	};
+
+	if (bd->props.power != FB_BLANK_UNBLANK)
+		intensity = 0;
+	if (bd->props.state & (BL_CORE_FBBLANK | BL_CORE_SUSPENDED))
+		intensity = 0;
+
+	/*
+	 * Message format:
+	 * Byte 0: backlight instance (usually 1)
+	 * Byte 1: on/off
+	 * Byte 2: intensity, 0-255
+	 */
+	msg.tx_data[0] = 0x01;
+	msg.tx_data[1] = intensity > 0 ? 1 : 0;
+	msg.tx_data[2] = intensity;
+	return ipaq_micro_tx_msg_sync(micro, &msg);
+}
+
+static const struct backlight_ops micro_bl_ops = {
+	.options = BL_CORE_SUSPENDRESUME,
+	.update_status  = micro_bl_update_status,
+};
+
+static struct backlight_properties micro_bl_props = {
+	.type = BACKLIGHT_RAW,
+	.max_brightness = 255,
+	.power = FB_BLANK_UNBLANK,
+	.brightness = 64,
+};
+
+static int micro_backlight_probe(struct platform_device *pdev)
+{
+	struct backlight_device *bd;
+	struct ipaq_micro *micro = dev_get_drvdata(pdev->dev.parent);
+
+	bd = devm_backlight_device_register(&pdev->dev, "ipaq-micro-backlight",
+					    &pdev->dev, micro, &micro_bl_ops,
+					    &micro_bl_props);
+	if (IS_ERR(bd))
+		return PTR_ERR(bd);
+
+	platform_set_drvdata(pdev, bd);
+	backlight_update_status(bd);
+
+	return 0;
+}
+
+struct platform_driver micro_backlight_device_driver = {
+	.driver = {
+		.name    = "ipaq-micro-backlight",
+	},
+	.probe   = micro_backlight_probe,
+};
+module_platform_driver(micro_backlight_device_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("driver for iPAQ Atmel micro backlight");
+MODULE_ALIAS("platform:ipaq-micro-backlight");
-- 
1.9.3

