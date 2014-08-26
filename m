Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344AbaHZXpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 19:45:33 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:54987 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756315AbaHZXp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 19:45:29 -0400
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
Subject: [PATCH v1 1/1] power: Add simple gpio-restart driver
Date: Tue, 26 Aug 2014 16:45:05 -0700
Message-Id: <1409096705-24290-2-git-send-email-davidriley@chromium.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1409096705-24290-1-git-send-email-davidriley@chromium.org>
References: <1409096705-24290-1-git-send-email-davidriley@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver registers a restart handler to set a GPIO line high/low
to reset a board based on devicetree bindings.

Signed-off-by: David Riley <davidriley@chromium.org>
---
 .../devicetree/bindings/gpio/gpio-restart.txt      |  48 +++++++
 drivers/power/reset/Kconfig                        |   8 ++
 drivers/power/reset/Makefile                       |   1 +
 drivers/power/reset/gpio-restart.c                 | 142 +++++++++++++++++++++
 4 files changed, 199 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-restart.txt
 create mode 100644 drivers/power/reset/gpio-restart.c

diff --git a/Documentation/devicetree/bindings/gpio/gpio-restart.txt b/Documentation/devicetree/bindings/gpio/gpio-restart.txt
new file mode 100644
index 0000000..7cd58788
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio-restart.txt
@@ -0,0 +1,48 @@
+Driver a GPIO line that can be used to restart the system as a
+restart handler.
+
+The driver supports both level triggered and edge triggered power off.
+At driver load time, the driver will request the given gpio line and
+install a restart handler. If the optional properties 'input' is
+not found, the GPIO line will be driven in the inactive state.
+Otherwise its configured as an input.
+
+When do_kernel_restart is called the various restart handlers will be tried
+in order.  The gpio is configured as an output, and drive active, so
+triggering a level triggered power off condition. This will also cause an
+inactive->active edge condition, so triggering positive edge triggered
+power off. After a delay of 100ms, the GPIO is set to inactive, thus
+causing an active->inactive edge, triggering negative edge triggered power
+off. After another 100ms delay the GPIO is driver active again. If the
+power is still on and the CPU still running after a 3000ms delay, a
+WARN_ON(1) is emitted.
+
+Required properties:
+- compatible : should be "gpio-restart".
+- gpios : The GPIO to set high/low, see "gpios property" in
+  Documentation/devicetree/bindings/gpio/gpio.txt. If the pin should be
+  low to power down the board set it to "Active Low", otherwise set
+  gpio to "Active High".
+
+Optional properties:
+- input : Initially configure the GPIO line as an input. Only reconfigure
+  it to an output when the machine_restart function is called. If this optional
+  property is not specified, the GPIO is initialized as an output in its
+  inactive state.
+- priority : A priority ranging from 0 to 255 (default 128) according to
+  the following guidelines:
+	0:	Restart handler of last resort, with limited restart
+		capabilities
+	128:	Default restart handler; use if no other restart handler is
+		expected to be available, and/or if restart functionality is
+		sufficient to restart the entire system
+	255:	Highest priority restart handler, will preempt all other
+		restart handlers
+
+Examples:
+
+gpio-restart {
+	compatible = "gpio-restart";
+	gpios = <&gpio 4 0>;
+	priority = /bits/ 8 <200>;
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
index 0000000..2cbff64
--- /dev/null
+++ b/drivers/power/reset/gpio-restart.c
@@ -0,0 +1,142 @@
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
+};
+
+static int gpio_restart_notify(struct notifier_block *this,
+				unsigned long mode, void *cmd)
+{
+	struct gpio_restart *gpio_restart =
+		container_of(this, struct gpio_restart, restart_handler);
+
+	BUG_ON(!gpio_restart->reset_gpio);
+
+	/* drive it active, also inactive->active edge */
+	gpiod_direction_output(gpio_restart->reset_gpio, 1);
+	mdelay(100);
+
+	/* drive inactive, also active->inactive edge */
+	gpiod_set_value(gpio_restart->reset_gpio, 0);
+	mdelay(100);
+
+	/* drive it active, also inactive->active edge */
+	gpiod_set_value(gpio_restart->reset_gpio, 1);
+
+	/* give it some time */
+	mdelay(3000);
+
+	WARN_ON(1);
+
+	return NOTIFY_DONE;
+}
+
+static int gpio_restart_probe(struct platform_device *pdev)
+{
+	struct gpio_restart *gpio_restart;
+	bool input = false;
+	u8 priority;
+	int ret;
+
+	gpio_restart = devm_kzalloc(&pdev->dev, sizeof(*gpio_restart),
+			GFP_KERNEL);
+	if (!gpio_restart)
+		return -ENOMEM;
+
+	gpio_restart->reset_gpio = devm_gpiod_get(&pdev->dev, NULL);
+	if (IS_ERR(gpio_restart->reset_gpio))
+		return PTR_ERR(gpio_restart->reset_gpio);
+
+	gpio_restart->restart_handler.notifier_call = gpio_restart_notify;
+	gpio_restart->restart_handler.priority = 128;
+
+	platform_set_drvdata(pdev, gpio_restart);
+
+	input = of_property_read_bool(pdev->dev.of_node, "input");
+	if (input) {
+		if (gpiod_direction_input(gpio_restart->reset_gpio)) {
+			dev_err(&pdev->dev,
+				"Could not set direction of reset GPIO to input\n");
+			return -ENODEV;
+		}
+	} else {
+		if (gpiod_direction_output(gpio_restart->reset_gpio, 0)) {
+			dev_err(&pdev->dev,
+				"Could not set direction of reset GPIO\n");
+			return -ENODEV;
+		}
+	}
+
+	if (!of_property_read_u8(pdev->dev.of_node, "priority", &priority))
+		gpio_restart->restart_handler.priority = priority;
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

