Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbbAZMPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:15:53 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33782 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925AbbAZMPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:15:46 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <tony@atomide.com>, <myungjoo.ham@samsung.com>,
        <cw00.choi@samsung.com>
CC: <george.cherian@ti.com>, <nsekhar@ti.com>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH v2 1/7] extcon: usb-gpio: Introduce gpio usb extcon driver
Date: Mon, 26 Jan 2015 14:15:26 +0200
Message-ID: <1422274532-9488-2-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422274532-9488-1-git-send-email-rogerq@ti.com>
References: <1422274532-9488-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver observes the USB ID pin connected over a GPIO and
updates the USB cable extcon states accordingly.

The existing GPIO extcon driver is not suitable for this purpose
as it needs to be taught to understand USB cable states and it
can't handle more than one cable per instance.

For the USB case we need to handle 2 cable states.
1) USB (attach/detach)
2) USB-Host (attach/detach)

This driver can be easily updated in the future to handle VBUS
events in case it happens to be available on GPIO for any platform.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 .../devicetree/bindings/extcon/extcon-usb-gpio.txt |  20 ++
 drivers/extcon/Kconfig                             |   7 +
 drivers/extcon/Makefile                            |   1 +
 drivers/extcon/extcon-usb-gpio.c                   | 214 +++++++++++++++++++++
 4 files changed, 242 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/extcon/extcon-usb-gpio.txt
 create mode 100644 drivers/extcon/extcon-usb-gpio.c

diff --git a/Documentation/devicetree/bindings/extcon/extcon-usb-gpio.txt b/Documentation/devicetree/bindings/extcon/extcon-usb-gpio.txt
new file mode 100644
index 0000000..ab52a85
--- /dev/null
+++ b/Documentation/devicetree/bindings/extcon/extcon-usb-gpio.txt
@@ -0,0 +1,20 @@
+USB GPIO Extcon device
+
+This is a virtual device used to generate USB cable states from the USB ID pin
+connected to a GPIO pin.
+
+Required properties:
+- compatible: Should be "linux,extcon-usb-gpio"
+- id-gpio: gpio for USB ID pin. See gpio binding.
+
+Example:
+	extcon_usb1 {
+		compatible = "linux,extcon-usb-gpio";
+		id-gpio = <&gpio6 1 GPIO_ACTIVE_HIGH>;
+	}
+
+	usb@1 {
+		...
+		extcon = <&extcon_usb1>;
+		...
+	};
diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
index 6a1f7de..e4c01ab 100644
--- a/drivers/extcon/Kconfig
+++ b/drivers/extcon/Kconfig
@@ -93,4 +93,11 @@ config EXTCON_SM5502
 	  Silicon Mitus SM5502. The SM5502 is a USB port accessory
 	  detector and switch.
 
+config EXTCON_USB_GPIO
+	tristate "USB GPIO extcon support"
+	depends on GPIOLIB
+	help
+	  Say Y here to enable GPIO based USB cable detection extcon support.
+	  Used typically if GPIO is used for USB ID pin detection.
+
 endif # MULTISTATE_SWITCH
diff --git a/drivers/extcon/Makefile b/drivers/extcon/Makefile
index 0370b42..6a08a98 100644
--- a/drivers/extcon/Makefile
+++ b/drivers/extcon/Makefile
@@ -12,3 +12,4 @@ obj-$(CONFIG_EXTCON_MAX8997)	+= extcon-max8997.o
 obj-$(CONFIG_EXTCON_PALMAS)	+= extcon-palmas.o
 obj-$(CONFIG_EXTCON_RT8973A)	+= extcon-rt8973a.o
 obj-$(CONFIG_EXTCON_SM5502)	+= extcon-sm5502.o
+obj-$(CONFIG_EXTCON_USB_GPIO)	+= extcon-usb-gpio.o
diff --git a/drivers/extcon/extcon-usb-gpio.c b/drivers/extcon/extcon-usb-gpio.c
new file mode 100644
index 0000000..a20aa39
--- /dev/null
+++ b/drivers/extcon/extcon-usb-gpio.c
@@ -0,0 +1,214 @@
+/**
+ * drivers/extcon/extcon_usb_gpio.c - USB GPIO extcon driver
+ *
+ * Copyright (C) 2015 Texas Instruments Incorporated - http://www.ti.com
+ * Author: Roger Quadros <rogerq@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/extcon.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of_gpio.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/workqueue.h>
+
+#define USB_GPIO_DEBOUNCE_MS	20	/* ms */
+
+struct usb_extcon_info {
+	struct device *dev;
+	struct extcon_dev *edev;
+
+	struct gpio_desc *id_gpiod;
+	int id_irq;
+
+	unsigned long debounce_jiffies;
+	struct delayed_work wq_detcable;
+};
+
+/* List of detectable cables */
+enum {
+	EXTCON_CABLE_USB = 0,
+	EXTCON_CABLE_USB_HOST,
+
+	EXTCON_CABLE_END,
+};
+
+static const char *usb_extcon_cable[] = {
+	[EXTCON_CABLE_USB] = "USB",
+	[EXTCON_CABLE_USB_HOST] = "USB-Host",
+	NULL,
+};
+
+static void usb_extcon_detect_cable(struct work_struct *work)
+{
+	int id;
+	struct usb_extcon_info *info;
+
+	info  = container_of(to_delayed_work(work), struct usb_extcon_info,
+			     wq_detcable);
+
+	/* check ID and update cable state */
+	id = gpiod_get_value_cansleep(info->id_gpiod);
+	if (id) {
+		/*
+		 * ID = 1 means USB HOST cable detached.
+		 * As we don't have event for USB peripheral cable attached,
+		 * we simulate USB peripheral attach here.
+		 */
+		extcon_set_cable_state(info->edev,
+				       usb_extcon_cable[EXTCON_CABLE_USB_HOST],
+				       false);
+		extcon_set_cable_state(info->edev,
+				       usb_extcon_cable[EXTCON_CABLE_USB],
+				       true);
+	} else {
+		/*
+		 * ID = 0 means USB HOST cable attached.
+		 * As we don't have event for USB peripheral cable detached,
+		 * we simulate USB peripheral detach here.
+		 */
+		extcon_set_cable_state(info->edev,
+				       usb_extcon_cable[EXTCON_CABLE_USB],
+				       false);
+		extcon_set_cable_state(info->edev,
+				       usb_extcon_cable[EXTCON_CABLE_USB_HOST],
+				       true);
+	}
+}
+
+static irqreturn_t usb_irq_handler(int irq, void *dev_id)
+{
+	struct usb_extcon_info *info = dev_id;
+
+	queue_delayed_work(system_power_efficient_wq, &info->wq_detcable,
+			   info->debounce_jiffies);
+	return IRQ_HANDLED;
+}
+
+static int usb_extcon_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+	struct usb_extcon_info *info;
+	int ret;
+
+	if (!np)
+		return -EINVAL;
+
+	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	info->dev = dev;
+	info->id_gpiod = devm_gpiod_get(&pdev->dev, "id");
+	if (IS_ERR(info->id_gpiod)) {
+		dev_err(dev, "failed to get ID GPIO\n");
+		return PTR_ERR(info->id_gpiod);
+	}
+
+	ret = gpiod_set_debounce(info->id_gpiod,
+				 USB_GPIO_DEBOUNCE_MS * 1000);
+	if (ret < 0)
+		info->debounce_jiffies = msecs_to_jiffies(USB_GPIO_DEBOUNCE_MS);
+
+	INIT_DELAYED_WORK(&info->wq_detcable, usb_extcon_detect_cable);
+
+	info->id_irq = gpiod_to_irq(info->id_gpiod);
+	if (info->id_irq < 0) {
+		dev_err(dev, "failed to get ID IRQ\n");
+		return info->id_irq;
+	}
+
+	ret = devm_request_threaded_irq(dev, info->id_irq, NULL,
+					usb_irq_handler,
+					IRQF_SHARED | IRQF_ONESHOT |
+					IRQF_NO_SUSPEND,
+					pdev->name, info);
+	if (ret < 0) {
+		dev_err(dev, "failed to request handler for ID IRQ\n");
+		return ret;
+	}
+
+	info->edev = devm_extcon_dev_allocate(dev, usb_extcon_cable);
+	if (IS_ERR(info->edev)) {
+		dev_err(dev, "failed to allocate extcon device\n");
+		return -ENOMEM;
+	}
+
+	ret = devm_extcon_dev_register(dev, info->edev);
+	if (ret < 0) {
+		dev_err(dev, "failed to register extcon device\n");
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, info);
+
+	/* Perform initial detection */
+	usb_extcon_detect_cable(&info->wq_detcable.work);
+
+	return 0;
+}
+
+static int usb_extcon_remove(struct platform_device *pdev)
+{
+	struct usb_extcon_info *info = platform_get_drvdata(pdev);
+
+	cancel_delayed_work_sync(&info->wq_detcable);
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int usb_extcon_suspend(struct device *dev)
+{
+	struct usb_extcon_info *info = dev_get_drvdata(dev);
+
+	enable_irq_wake(info->id_irq);
+	return 0;
+}
+
+static int usb_extcon_resume(struct device *dev)
+{
+	struct usb_extcon_info *info = dev_get_drvdata(dev);
+
+	disable_irq_wake(info->id_irq);
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(usb_extcon_pm_ops,
+			 usb_extcon_suspend, usb_extcon_resume);
+
+static struct of_device_id usb_extcon_dt_match[] = {
+	{ .compatible = "linux,extcon-usb-gpio", },
+	{ /* end */ }
+};
+MODULE_DEVICE_TABLE(of, usb_extcon_dt_match);
+
+static struct platform_driver usb_extcon_driver = {
+	.probe		= usb_extcon_probe,
+	.remove		= usb_extcon_remove,
+	.driver		= {
+		.name	= "extcon-usb-gpio",
+		.pm	= &usb_extcon_pm_ops,
+		.of_match_table = usb_extcon_dt_match,
+	},
+};
+
+module_platform_driver(usb_extcon_driver);
+
+MODULE_AUTHOR("Roger Quadros <rogerq@ti.com>");
+MODULE_DESCRIPTION("USB GPIO extcon driver");
+MODULE_LICENSE("GPL v2");
-- 
2.1.0

