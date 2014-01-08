Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbaAHLLX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 06:11:23 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50041 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339AbaAHLLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 06:11:20 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kernel@pengutronix.de, Roger Quadros <rogerq@ti.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Arnd Bergmann <arnd@arndb.de>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v3 2/2] reset: Add GPIO support to reset controller framework
Date: Wed,  8 Jan 2014 12:11:04 +0100
Message-Id: <1389179464-11963-2-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389179464-11963-1-git-send-email-p.zabel@pengutronix.de>
References: <1389179464-11963-1-git-send-email-p.zabel@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for GPIO controlled reset pins on peripheral ICs to the reset
controller framework. Currently there is no support for specifying a delay
between assertion and de-assertion of the reset signal, so this has to be
handled by the drivers.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v2:
 - fix assert_prop initial value
---
 drivers/reset/Kconfig      |  17 ++++++
 drivers/reset/Makefile     |   9 ++-
 drivers/reset/core.c       |  29 +++++-----
 drivers/reset/gpio-reset.c | 137 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/reset/reset-core.h |  47 ++++++++++++++++
 5 files changed, 224 insertions(+), 15 deletions(-)
 create mode 100644 drivers/reset/gpio-reset.c
 create mode 100644 drivers/reset/reset-core.h

diff --git a/drivers/reset/Kconfig b/drivers/reset/Kconfig
index c9d04f7..a6b12a9 100644
--- a/drivers/reset/Kconfig
+++ b/drivers/reset/Kconfig
@@ -10,4 +10,21 @@ menuconfig RESET_CONTROLLER
 	  This framework is designed to abstract reset handling of devices
 	  via GPIOs or SoC-internal reset controller modules.
 
+	  If the device tree contains any resets or reset-gpio properties,
+	  this probably should be enabled.
+
 	  If unsure, say no.
+
+if RESET_CONTROLLER
+
+menuconfig RESET_GPIO
+	bool "GPIO Reset Support"
+	depends on GPIOLIB
+	default y if GPIOLIB
+	help
+	  GPIO Reset Controller support.
+
+	  This option lets the reset controller framework handle reset lines
+	  connected to GPIOs.
+
+endif
diff --git a/drivers/reset/Makefile b/drivers/reset/Makefile
index cc29832..764bb74 100644
--- a/drivers/reset/Makefile
+++ b/drivers/reset/Makefile
@@ -1,2 +1,9 @@
-obj-$(CONFIG_RESET_CONTROLLER) += core.o
+reset-core-objs := core.o
+
+obj-$(CONFIG_RESET_CONTROLLER) += reset-core.o
+
+ifeq ($(CONFIG_RESET_GPIO),y)
+  reset-core-objs += gpio-reset.o
+endif
+
 obj-$(CONFIG_ARCH_SUNXI) += reset-sunxi.o
diff --git a/drivers/reset/core.c b/drivers/reset/core.c
index baeaf82..6bfd2d2 100644
--- a/drivers/reset/core.c
+++ b/drivers/reset/core.c
@@ -18,23 +18,12 @@
 #include <linux/reset-controller.h>
 #include <linux/slab.h>
 
+#include "reset-core.h"
+
 static DEFINE_MUTEX(reset_controller_list_mutex);
 static LIST_HEAD(reset_controller_list);
 
 /**
- * struct reset_control - a reset control
- * @rcdev: a pointer to the reset controller device
- *         this reset control belongs to
- * @id: ID of the reset controller in the reset
- *      controller device
- */
-struct reset_control {
-	struct reset_controller_dev *rcdev;
-	struct device *dev;
-	unsigned int id;
-};
-
-/**
  * of_reset_simple_xlate - translate reset_spec to the reset line number
  * @rcdev: a pointer to the reset controller device
  * @reset_spec: reset line specifier as found in the device tree
@@ -149,6 +138,8 @@ struct reset_control *of_reset_control_get(struct device_node *node,
 						 "reset-names", id);
 	ret = of_parse_phandle_with_args(node, "resets", "#reset-cells",
 					 index, &args);
+	if (index == -EINVAL)
+		return ERR_PTR(-ENOENT);
 	if (ret)
 		return ERR_PTR(ret);
 
@@ -209,6 +200,13 @@ struct reset_control *reset_control_get(struct device *dev, const char *id)
 	if (!IS_ERR(rstc))
 		rstc->dev = dev;
 
+	/*
+	 * If there is no dedicated reset controller device, check if we have
+	 * a reset line controlled by a GPIO instead.
+	 */
+	if (PTR_ERR(rstc) == -ENOENT)
+		return gpio_reset_control_get(dev, id);
+
 	return rstc;
 }
 EXPORT_SYMBOL_GPL(reset_control_get);
@@ -223,7 +221,10 @@ void reset_control_put(struct reset_control *rstc)
 	if (IS_ERR(rstc))
 		return;
 
-	module_put(rstc->rcdev->owner);
+	if (reset_control_is_gpio(rstc))
+		gpio_reset_control_put(rstc);
+	else
+		module_put(rstc->rcdev->owner);
 	kfree(rstc);
 }
 EXPORT_SYMBOL_GPL(reset_control_put);
diff --git a/drivers/reset/gpio-reset.c b/drivers/reset/gpio-reset.c
new file mode 100644
index 0000000..77d4bd7
--- /dev/null
+++ b/drivers/reset/gpio-reset.c
@@ -0,0 +1,137 @@
+/*
+ * GPIO Reset Controller
+ *
+ * Copyright 2013 Philipp Zabel, Pengutronix
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
+#include <linux/reset-controller.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+
+#include "reset-core.h"
+
+/*
+ * Global GPIO reset controller
+ */
+static struct reset_controller_dev *gpio_rcdev;
+
+static int gpio_reset_set(struct reset_controller_dev *rcdev,
+			  unsigned int gpio, int asserted)
+{
+	struct gpio_desc *gpiod = gpio_to_desc(gpio);
+
+	if (!gpiod)
+		return -EINVAL;
+
+	gpiod_set_value_cansleep(gpiod, asserted);
+
+	return 0;
+}
+
+static int gpio_reset_assert(struct reset_controller_dev *rcdev,
+		unsigned long id)
+{
+	return gpio_reset_set(rcdev, id, 1);
+}
+
+static int gpio_reset_deassert(struct reset_controller_dev *rcdev,
+		unsigned long id)
+{
+	return gpio_reset_set(rcdev, id, 0);
+}
+
+static struct reset_control_ops gpio_reset_ops = {
+	.assert = gpio_reset_assert,
+	.deassert = gpio_reset_deassert,
+};
+
+struct reset_controller_dev *reset_get_gpio_rcdev(void)
+{
+	if (gpio_rcdev)
+		return gpio_rcdev;
+
+	gpio_rcdev = kzalloc(sizeof(*gpio_rcdev), GFP_KERNEL);
+	if (!gpio_rcdev)
+		return NULL;
+
+	gpio_rcdev->owner = THIS_MODULE;
+	gpio_rcdev->ops = &gpio_reset_ops;
+
+	reset_controller_register(gpio_rcdev);
+
+	return gpio_rcdev;
+}
+
+struct reset_control *gpio_reset_control_get(struct device *dev, const char *id)
+{
+	const char *assert_prop = "reset-boot-asserted";
+	const char *gpio_con_id = "reset";
+	struct reset_controller_dev *rcdev;
+	struct reset_control *rstc;
+	struct gpio_desc *gpiod;
+	char scratch[48];
+	bool asserted;
+	int ret;
+
+	if (id) {
+		snprintf(scratch, 48, "%s-reset-boot-asserted", id);
+		assert_prop = scratch;
+	}
+
+	asserted = of_property_read_bool(dev->of_node, assert_prop);
+
+	if (id) {
+		snprintf(scratch, 48, "%s-reset", id);
+		gpio_con_id = scratch;
+	}
+
+	gpiod = gpiod_get(dev, gpio_con_id);
+	if (IS_ERR(gpiod)) {
+		dev_err(dev, "Failed to get GPIO reset: %ld\n", PTR_ERR(gpiod));
+		return ERR_CAST(gpiod);
+	}
+
+	ret = gpiod_direction_output(gpiod, asserted);
+	if (ret < 0)
+		goto err_put;
+
+	ret = -ENOMEM;
+	rcdev = reset_get_gpio_rcdev();
+	if (!rcdev)
+		goto err_put;
+
+	rstc = kzalloc(sizeof(*rstc), GFP_KERNEL);
+	if (!rstc)
+		goto err_put;
+
+	rstc->dev = dev;
+	rstc->rcdev = rcdev;
+	rstc->id = desc_to_gpio(gpiod);
+
+	return rstc;
+
+err_put:
+	gpiod_put(gpiod);
+	return ERR_PTR(ret);
+}
+
+bool reset_control_is_gpio(struct reset_control *rstc)
+{
+	return rstc->rcdev == gpio_rcdev;
+}
+
+void gpio_reset_control_put(struct reset_control *rstc)
+{
+	struct gpio_desc *gpiod = gpio_to_desc(rstc->id);
+
+	if (gpiod)
+		gpiod_put(gpiod);
+}
diff --git a/drivers/reset/reset-core.h b/drivers/reset/reset-core.h
new file mode 100644
index 0000000..55bd297
--- /dev/null
+++ b/drivers/reset/reset-core.h
@@ -0,0 +1,47 @@
+/*
+ * Reset Controller framework
+ *
+ * Copyright 2013 Philipp Zabel, Pengutronix
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __RESET_CORE_H__
+#define __RESET_CORE_H__
+
+/**
+ * struct reset_control - a reset control
+ * @rcdev: a pointer to the reset controller device
+ *         this reset control belongs to
+ * @id: ID of the reset controller in the reset
+ *      controller device
+ */
+struct reset_control {
+	struct reset_controller_dev *rcdev;
+	struct device *dev;
+	unsigned int id;
+};
+
+#if IS_ENABLED(CONFIG_RESET_GPIO)
+struct reset_control *gpio_reset_control_get(struct device *dev, const char *id);
+bool reset_control_is_gpio(struct reset_control *rstc);
+void gpio_reset_control_put(struct reset_control *rstc);
+#else
+static inline struct reset_control *gpio_reset_control_get(struct device *dev,
+						    const char *id)
+{
+	return -ENOSYS;
+}
+
+static inline bool reset_control_is_gpio(struct reset_control *rstc)
+{
+	return false;
+}
+
+static inline void gpio_reset_control_put(struct reset_control *rstc) { }
+#endif
+
+#endif
-- 
1.8.5.2

