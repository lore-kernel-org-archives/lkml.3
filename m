Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbaLVWme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 17:42:34 -0500
Received: from mga11.intel.com ([192.55.52.93]:57422 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbaLVWmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 17:42:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,627,1413270000"; 
   d="scan'208";a="627920901"
From: David Cohen <david.a.cohen@linux.intel.com>
To: myungjoo.ham@samsung.com, cw00.choi@samsung.com
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        baolu.lu@linux.intel.com, David Cohen <david.a.cohen@linux.intel.com>
Subject: [RFC/PATCH] extcon: otg_gpio: add driver for USB OTG port controlled by GPIO(s)
Date: Mon, 22 Dec 2014 14:43:37 -0800
Message-Id: <1419288217-19262-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platforms have an USB OTG port fully (or partially) controlled by
GPIOs:

(1) USB ID is connected directly to GPIO

Optionally:
(2) VBUS is enabled by a GPIO (when ID is grounded)
(3) Platform has 2 USB controllers connected to same port: one for
    device and one for host role. D+/- are switched between phys
    by GPIO.

As per initial version, this driver has the duty to control whether
USB-Host cable is plugged in or not:
 - If yes, OTG port is configured for host role
 - If no, by standard, the OTG port is configured for device role

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---

Hi,

Some Intel Bay Trail boards have an unusual way to handle the USB OTG port:
 - The USB ID pin is connected directly to GPIO on SoC
 - When in host role, VBUS is provided by enabling a GPIO
 - Device and host roles are supported by 2 independent controllers with D+/-
   pins from port switched between different phys according a GPIO level.

The ACPI table describes this USB port as a (virtual) device with all the
necessary GPIOs. This driver implements support to this virtual device as an
extcon class driver. All drivers that depend on the USB OTG port state (USB phy,
PMIC, charge detection) will listen to extcon events.

Comments are welcome.

Br, David
---

 drivers/extcon/Kconfig           |   8 ++
 drivers/extcon/Makefile          |   1 +
 drivers/extcon/extcon-otg_gpio.c | 200 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 209 insertions(+)
 create mode 100644 drivers/extcon/extcon-otg_gpio.c

diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
index 6a1f7de6fa54..e8010cda4642 100644
--- a/drivers/extcon/Kconfig
+++ b/drivers/extcon/Kconfig
@@ -93,4 +93,12 @@ config EXTCON_SM5502
 	  Silicon Mitus SM5502. The SM5502 is a USB port accessory
 	  detector and switch.
 
+config EXTCON_OTG_GPIO
+	tristate "VIRTUAL USB OTG PORT support"
+	depends on GPIOLIB
+	help
+	  Say Y here to enable support for virtual USB OTG port device
+	  controlled by GPIOs. This driver can be used when at least USB ID pin
+	  is connected directly to GPIO.
+
 endif # MULTISTATE_SWITCH
diff --git a/drivers/extcon/Makefile b/drivers/extcon/Makefile
index 0370b42e5a27..9e81088c6584 100644
--- a/drivers/extcon/Makefile
+++ b/drivers/extcon/Makefile
@@ -12,3 +12,4 @@ obj-$(CONFIG_EXTCON_MAX8997)	+= extcon-max8997.o
 obj-$(CONFIG_EXTCON_PALMAS)	+= extcon-palmas.o
 obj-$(CONFIG_EXTCON_RT8973A)	+= extcon-rt8973a.o
 obj-$(CONFIG_EXTCON_SM5502)	+= extcon-sm5502.o
+obj-$(CONFIG_EXTCON_OTG_GPIO) += extcon-otg_gpio.o
diff --git a/drivers/extcon/extcon-otg_gpio.c b/drivers/extcon/extcon-otg_gpio.c
new file mode 100644
index 000000000000..c5ee765a5f4f
--- /dev/null
+++ b/drivers/extcon/extcon-otg_gpio.c
@@ -0,0 +1,200 @@
+/*
+ * Virtual USB OTG Port driver controlled by gpios
+ *
+ * Copyright (c) 2014, Intel Corporation.
+ * Author: David Cohen <david.a.cohen@linux.intel.com>
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
+#include <linux/acpi.h>
+#include <linux/extcon.h>
+#include <linux/gpio.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+
+#define DRV_NAME	"usb_otg_port"
+
+struct vuport {
+	struct device *dev;
+	struct gpio_desc *gpio_vbus_en;
+	struct gpio_desc *gpio_usb_id;
+	struct gpio_desc *gpio_usb_mux;
+
+	struct extcon_dev edev;
+};
+
+static const char *const vuport_extcon_cable[] = {
+	[0] = "USB-Host",
+	NULL,
+};
+
+/*
+ * If id == 1, USB port should be set to peripheral
+ * if id == 0, USB port should be set to host
+ *
+ * Peripheral: set USB mux to peripheral and disable VBUS
+ * Host: set USB mux to host and enable VBUS
+ */
+static void vuport_set_port(struct vuport *vup, int id)
+{
+	int mux_val = id;
+	int vbus_val = !id;
+
+	if (!IS_ERR(vup->gpio_usb_mux))
+		gpiod_direction_output(vup->gpio_usb_mux, mux_val);
+
+	if (!IS_ERR(vup->gpio_vbus_en))
+		gpiod_direction_output(vup->gpio_vbus_en, vbus_val);
+}
+
+static void vuport_do_usb_id(struct vuport *vup)
+{
+	int id = gpiod_get_value(vup->gpio_usb_id);
+
+	dev_info(vup->dev, "USB PORT ID: %s\n", id ? "PERIPHERAL" : "HOST");
+
+	/*
+	 * id == 1: PERIPHERAL
+	 * id == 0: HOST
+	 */
+	vuport_set_port(vup, id);
+
+	/*
+	 * id == 0: HOST connected
+	 * id == 1: Host disconnected
+	 */
+	extcon_set_cable_state(&vup->edev, "USB-Host", !id);
+}
+
+static irqreturn_t vuport_thread_isr(int irq, void *priv)
+{
+	struct vuport *vup = priv;
+
+	vuport_do_usb_id(vup);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t vuport_isr(int irq, void *priv)
+{
+	return IRQ_WAKE_THREAD;
+}
+
+#define VUPORT_GPIO_USB_ID	0
+#define VUPORT_GPIO_VBUS_EN	1
+#define VUPORT_GPIO_USB_MUX	2
+static int vuport_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct vuport *vup;
+	int ret;
+
+	vup = devm_kzalloc(dev, sizeof(*vup), GFP_KERNEL);
+	if (!vup) {
+		dev_err(dev, "cannot allocate private data\n");
+		return -ENOMEM;
+	}
+	vup->dev = dev;
+
+	vup->gpio_usb_id = devm_gpiod_get_index(dev, "id", VUPORT_GPIO_USB_ID);
+	if (IS_ERR(vup->gpio_usb_id)) {
+		dev_err(dev, "cannot request USB ID GPIO: ret = %ld\n",
+			PTR_ERR(vup->gpio_usb_id));
+		return PTR_ERR(vup->gpio_usb_id);
+	}
+
+	ret = gpiod_direction_input(vup->gpio_usb_id);
+	if (ret < 0) {
+		dev_err(dev, "cannot set input direction to USB ID GPIO: ret = %d\n",
+			ret);
+		return ret;
+	}
+
+	vup->gpio_vbus_en = devm_gpiod_get_index(dev, "vbus en",
+						 VUPORT_GPIO_VBUS_EN);
+	if (IS_ERR(vup->gpio_vbus_en))
+		dev_info(dev, "cannot request VBUS EN GPIO, skipping it.\n");
+
+	vup->gpio_usb_mux = devm_gpiod_get_index(dev, "usb mux",
+						 VUPORT_GPIO_USB_MUX);
+	if (IS_ERR(vup->gpio_usb_mux))
+		dev_info(dev, "cannot request USB USB MUX, skipping it.\n");
+
+	/* register extcon device */
+	vup->edev.dev.parent = dev;
+	vup->edev.supported_cable = vuport_extcon_cable;
+	ret = extcon_dev_register(&vup->edev);
+	if (ret < 0) {
+		dev_err(dev, "failed to register extcon device: ret = %d\n",
+			ret);
+		return ret;
+	}
+
+	ret = devm_request_threaded_irq(dev, gpiod_to_irq(vup->gpio_usb_id),
+					vuport_isr, vuport_thread_isr,
+					IRQF_SHARED | IRQF_TRIGGER_RISING |
+					IRQF_TRIGGER_FALLING,
+					dev_name(dev), vup);
+	if (ret < 0) {
+		dev_err(dev, "cannot request IRQ for USB ID GPIO: ret = %d\n",
+			ret);
+		goto irq_err;
+	}
+	vuport_do_usb_id(vup);
+
+	platform_set_drvdata(pdev, vup);
+
+	dev_info(dev, "driver successfully probed\n");
+
+	return 0;
+
+irq_err:
+	extcon_dev_unregister(&vup->edev);
+
+	return ret;
+}
+
+static int vuport_remove(struct platform_device *pdev)
+{
+	struct vuport *vup = platform_get_drvdata(pdev);
+
+	extcon_dev_unregister(&vup->edev);
+	return 0;
+}
+
+static struct acpi_device_id vuport_acpi_match[] = {
+	{ "INT3496" },
+	{ }
+};
+MODULE_DEVICE_TABLE(acpi, vuport_acpi_match);
+
+static struct platform_driver vuport_driver = {
+	.driver = {
+		.name = DRV_NAME,
+		.acpi_match_table = ACPI_PTR(vuport_acpi_match),
+	},
+	.probe = vuport_probe,
+	.remove = vuport_remove,
+};
+
+static int __init vuport_init(void)
+{
+	return platform_driver_register(&vuport_driver);
+}
+subsys_initcall(vuport_init);
+
+static void __exit vuport_exit(void)
+{
+	platform_driver_unregister(&vuport_driver);
+}
+module_exit(vuport_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("David Cohen <david.a.cohen@linux.intel.com>");
-- 
2.1.1

