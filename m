Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935790AbaH0TY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 15:24:26 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:53982 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935556AbaH0TYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 15:24:23 -0400
From: David Riley <davidriley@chromium.org>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        David Riley <davidriley@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        Anton Vorontsov <anton@enomsg.org>,
        Marc Carino <marc.ceeeee@gmail.com>, Anders Berg <anders.berg@lsi.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Jamie Lentin <jm@lentin.co.uk>, Doug Anderson <dianders@chromium.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH v2 1/1] power: Add simple gpio-restart driver
Date: Wed, 27 Aug 2014 12:23:51 -0700
Message-Id: <1409167431-21155-2-git-send-email-davidriley@chromium.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1409167431-21155-1-git-send-email-davidriley@chromium.org>
References: <1409167431-21155-1-git-send-email-davidriley@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver registers a restart handler to set a GPIO line high/low
to reset a board based on devicetree bindings.

Signed-off-by: David Riley <davidriley@chromium.org>
---
 .../devicetree/bindings/gpio/gpio-restart.txt      |  54 ++++++++
 drivers/power/reset/Kconfig                        |   8 ++
 drivers/power/reset/Makefile                       |   1 +
 drivers/power/reset/gpio-restart.c                 | 149 +++++++++++++++++++++
 4 files changed, 212 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-restart.txt
 create mode 100644 drivers/power/reset/gpio-restart.c

diff --git a/Documentation/devicetree/bindings/gpio/gpio-restart.txt b/Documentation/devicetree/bindings/gpio/gpio-restart.txt
new file mode 100644
index 0000000..af3701b
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio-restart.txt
@@ -0,0 +1,54 @@
+Drive a GPIO line that can be used to restart the system from a restart
+handler.
+
+This binding supports level and edge triggered reset.  At driver load
+time, the driver will request the given gpio line and install a restart
+handler. If the optional properties 'open-source' is not found, the GPIO line
+will be driven in the inactive state.  Otherwise its not driven until
+the restart is initiated.
+
+When the system is restarted, the restart handler will be invoked in
+priority order.  The gpio is configured as an output, and driven active,
+triggering a level triggered reset condition. This will also cause an
+inactive->active edge condition, triggering positive edge triggered
+reset. After a delay specified by active-delay, the GPIO is set to
+inactive, thus causing an active->inactive edge, triggering negative edge
+triggered reset. After a delay specified by inactive-delay, the GPIO
+is driven active again.  After a delay specified by wait-delay, the
+restart handler completes allowing other restart handlers to be attempted.
+
+Required properties:
+- compatible : should be "gpio-restart".
+- gpios : The GPIO to set high/low, see "gpios property" in
+  Documentation/devicetree/bindings/gpio/gpio.txt. If the pin should be
+  low to reset the board set it to "Active Low", otherwise set
+  gpio to "Active High".
+
+Optional properties:
+- open-source : Treat the GPIO as being open source and defer driving
+  it to when the restart is initiated.  If this optional property is not
+  specified, the GPIO is initialized as an output in its inactive state.
+- priority : A priority ranging from 0 to 255 (default 128) according to
+  the following guidelines:
+	0:	Restart handler of last resort, with limited restart
+		capabilities
+	128:	Default restart handler; use if no other restart handler is
+		expected to be available, and/or if restart functionality is
+		sufficient to restart the entire system
+	255:	Highest priority restart handler, will preempt all other
+		restart handlers
+- active-delay: Delay (default 100) to wait after driving gpio active [ms]
+- inactive-delay: Delay (default 100) to wait after driving gpio inactive [ms]
+- wait-delay: Delay (default 3000) to wait after completing restart
+  sequence [ms]
+
+Examples:
+
+gpio-restart {
+	compatible = "gpio-restart";
+	gpios = <&gpio 4 0>;
+	priority = <128>;
+	active-delay = <100>;
+	inactive-delay = <100>;
+	wait-delay = <3000>;
+};
diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
index ca41523..f07e26c 100644
--- a/drivers/power/reset/Kconfig
+++ b/drivers/power/reset/Kconfig
@@ -39,6 +39,14 @@ config POWER_RESET_GPIO
 	  If your board needs a GPIO high/low to power down, say Y and
 	  create a binding in your devicetree.
 
+config POWER_RESET_GPIO_RESTART
+	bool "GPIO restart driver"
+	depends on OF_GPIO && POWER_RESET
+	help
+	  This driver supports restarting your board via a GPIO line.
+	  If your board needs a GPIO high/low to restart, say Y and
+	  create a binding in your devicetree.
+
 config POWER_RESET_HISI
 	bool "Hisilicon power-off driver"
 	depends on POWER_RESET && ARCH_HISI
diff --git a/drivers/power/reset/Makefile b/drivers/power/reset/Makefile
index a42e70e..199cb6e 100644
--- a/drivers/power/reset/Makefile
+++ b/drivers/power/reset/Makefile
@@ -2,6 +2,7 @@ obj-$(CONFIG_POWER_RESET_AS3722) += as3722-poweroff.o
 obj-$(CONFIG_POWER_RESET_AXXIA) += axxia-reset.o
 obj-$(CONFIG_POWER_RESET_BRCMSTB) += brcmstb-reboot.o
 obj-$(CONFIG_POWER_RESET_GPIO) += gpio-poweroff.o
+obj-$(CONFIG_POWER_RESET_GPIO_RESTART) += gpio-restart.o
 obj-$(CONFIG_POWER_RESET_HISI) += hisi-reboot.o
 obj-$(CONFIG_POWER_RESET_MSM) += msm-poweroff.o
 obj-$(CONFIG_POWER_RESET_QNAP) += qnap-poweroff.o
diff --git a/drivers/power/reset/gpio-restart.c b/drivers/power/reset/gpio-restart.c
new file mode 100644
index 0000000..a76829b
--- /dev/null
+++ b/drivers/power/reset/gpio-restart.c
@@ -0,0 +1,149 @@
+/*
+ * Toggles a GPIO pin to restart a device
+ *
+ * Copyright (C) 2014 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * Based on the gpio-poweroff driver.
+ */
+#include <linux/reboot.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/gpio/consumer.h>
+#include <linux/of_platform.h>
+#include <linux/module.h>
+
+struct gpio_restart {
+	struct gpio_desc *reset_gpio;
+	struct notifier_block restart_handler;
+	u32 active_delay_ms;
+	u32 inactive_delay_ms;
+	u32 wait_delay_ms;
+};
+
+static int gpio_restart_notify(struct notifier_block *this,
+				unsigned long mode, void *cmd)
+{
+	struct gpio_restart *gpio_restart =
+		container_of(this, struct gpio_restart, restart_handler);
+
+	/* drive it active, also inactive->active edge */
+	gpiod_direction_output(gpio_restart->reset_gpio, 1);
+	mdelay(gpio_restart->active_delay_ms);
+
+	/* drive inactive, also active->inactive edge */
+	gpiod_set_value(gpio_restart->reset_gpio, 0);
+	mdelay(gpio_restart->inactive_delay_ms);
+
+	/* drive it active, also inactive->active edge */
+	gpiod_set_value(gpio_restart->reset_gpio, 1);
+
+	/* give it some time */
+	mdelay(gpio_restart->wait_delay_ms);
+
+	WARN_ON(1);
+
+	return NOTIFY_DONE;
+}
+
+static int gpio_restart_probe(struct platform_device *pdev)
+{
+	struct gpio_restart *gpio_restart;
+	bool open_source = false;
+	u32 property;
+	int ret;
+
+	gpio_restart = devm_kzalloc(&pdev->dev, sizeof(*gpio_restart),
+			GFP_KERNEL);
+	if (!gpio_restart)
+		return -ENOMEM;
+
+	open_source = of_property_read_bool(pdev->dev.of_node, "open-source");
+
+	gpio_restart->reset_gpio = devm_gpiod_get(&pdev->dev, NULL,
+			open_source ? GPIOD_IN : GPIOD_OUT_LOW);
+	if (IS_ERR(gpio_restart->reset_gpio)) {
+		dev_err(&pdev->dev, "Could net get reset GPIO\n");
+		return PTR_ERR(gpio_restart->reset_gpio);
+	}
+
+	gpio_restart->restart_handler.notifier_call = gpio_restart_notify;
+	gpio_restart->restart_handler.priority = 128;
+	gpio_restart->active_delay_ms = 100;
+	gpio_restart->inactive_delay_ms = 100;
+	gpio_restart->wait_delay_ms = 3000;
+
+	ret = of_property_read_u32(pdev->dev.of_node, "priority", &property);
+	if (!ret) {
+		if (property > 255)
+			dev_err(&pdev->dev, "Invalid priority property: %u\n",
+					property);
+		else
+			gpio_restart->restart_handler.priority = property;
+	}
+
+	of_property_read_u32(pdev->dev.of_node, "active-delay",
+			&gpio_restart->active_delay_ms);
+	of_property_read_u32(pdev->dev.of_node, "inactive-delay",
+			&gpio_restart->inactive_delay_ms);
+	of_property_read_u32(pdev->dev.of_node, "wait-delay",
+			&gpio_restart->wait_delay_ms);
+
+	platform_set_drvdata(pdev, gpio_restart);
+
+	ret = register_restart_handler(&gpio_restart->restart_handler);
+	if (ret) {
+		dev_err(&pdev->dev, "%s: cannot register restart handler, %d\n",
+				__func__, ret);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int gpio_restart_remove(struct platform_device *pdev)
+{
+	struct gpio_restart *gpio_restart = platform_get_drvdata(pdev);
+	int ret;
+
+	ret = unregister_restart_handler(&gpio_restart->restart_handler);
+	if (ret) {
+		dev_err(&pdev->dev,
+				"%s: cannot unregister restart handler, %d\n",
+				__func__, ret);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static const struct of_device_id of_gpio_restart_match[] = {
+	{ .compatible = "gpio-restart", },
+	{},
+};
+
+static struct platform_driver gpio_restart_driver = {
+	.probe = gpio_restart_probe,
+	.remove = gpio_restart_remove,
+	.driver = {
+		.name = "restart-gpio",
+		.owner = THIS_MODULE,
+		.of_match_table = of_gpio_restart_match,
+	},
+};
+
+module_platform_driver(gpio_restart_driver);
+
+MODULE_AUTHOR("David Riley <davidriley@chromium.org>");
+MODULE_DESCRIPTION("GPIO restart driver");
+MODULE_LICENSE("GPL");
-- 
2.0.0

