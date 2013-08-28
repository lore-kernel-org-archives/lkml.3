Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab3H1OOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 10:14:22 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37130 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728Ab3H1OOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 10:14:19 -0400
From: George Cherian <george.cherian@ti.com>
To: <balbi@ti.com>, <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <grant.likely@linaro.org>,
        <rob@landley.net>, <ian.campbell@citrix.com>, <swarren@wwwdotorg.org>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>,
        <rob.herring@calxeda.com>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <bcousson@baylibre.com>,
        <davidb@codeaurora.org>, <arnd@arndb.de>, <swarren@nvidia.com>,
        <popcornmix@gmail.com>, George Cherian <george.cherian@ti.com>
Subject: [PATCH v2 1/3] extcon: extcon-gpio-usbvid: Generic USB VBUS/ID detection via GPIO
Date: Wed, 28 Aug 2013 19:29:10 +0530
Message-ID: <1377698352-27689-2-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1377698352-27689-1-git-send-email-george.cherian@ti.com>
References: <1377698352-27689-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a generic USB VBUS/ID detection EXTCON driver. This driver expects
the ID/VBUS pin are connected via GPIOs. This driver is tested on
DRA7x board were the ID pin is routed via GPIOs. The driver supports
both VBUS and ID pin configuration and ID pin only configuration.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 .../bindings/extcon/extcon-gpio-usbvid.txt         |  20 +++
 drivers/extcon/Kconfig                             |   7 +-
 drivers/extcon/Makefile                            |   2 +-
 drivers/extcon/extcon-gpio-usbvid.c                | 185 +++++++++++++++++----
 4 files changed, 174 insertions(+), 40 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/extcon/extcon-gpio-usbvid.txt

diff --git a/Documentation/devicetree/bindings/extcon/extcon-gpio-usbvid.txt b/Documentation/devicetree/bindings/extcon/extcon-gpio-usbvid.txt
new file mode 100644
index 0000000..eea0741
--- /dev/null
+++ b/Documentation/devicetree/bindings/extcon/extcon-gpio-usbvid.txt
@@ -0,0 +1,20 @@
+EXTCON FOR USB VIA GPIO
+
+Required Properties:
+ - compatible : Should be "ti,gpio-usb-vid" for USB VBUS-ID detector
+		using gpios or "ti,gpio-usb-id" for USB ID pin detector
+ - gpios : phandle and args ID pin gpio and VBUS gpio.
+	   The first gpio used  for ID pin detection
+	   and the second used for VBUS detection.
+	   ID pin gpio is mandatory and VBUS is optional
+	   depending on implementation.
+
+Please refer to ../gpio/gpio.txt for details of the common GPIO bindings
+
+Example:
+
+	gpio_usbvid_extcon1 {
+		compatible = "ti,gpio-usb-vid";
+		gpios = <&gpio1 1 0>,
+			<&gpio2 2 0>;
+	};
diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
index da21c5c..8097398 100644
--- a/drivers/extcon/Kconfig
+++ b/drivers/extcon/Kconfig
@@ -64,11 +64,10 @@ config EXTCON_PALMAS
 	  Say Y here to enable support for USB peripheral and USB host
 	  detection by palmas usb.
 
-config EXTCON_GPIO_USB_VID
-	tristate "USB VBUS and ID detection over GPIO EXTCON support"
+config EXTCON_GPIO_USBVID
+	tristate "Generic USB VBUS/ID detection using GPIO EXTCON support"
 	help
-	  Say Y here to enable support for USB peripheral and USB host
-	  detection by pcf8575 using DRA7XX extcon.
+	  Say Y here to enable support for USB VBUS/ID deetction by GPIO.
 
 
 endif # MULTISTATE_SWITCH
diff --git a/drivers/extcon/Makefile b/drivers/extcon/Makefile
index cbb0932..0451f698 100644
--- a/drivers/extcon/Makefile
+++ b/drivers/extcon/Makefile
@@ -10,4 +10,4 @@ obj-$(CONFIG_EXTCON_MAX77693)	+= extcon-max77693.o
 obj-$(CONFIG_EXTCON_MAX8997)	+= extcon-max8997.o
 obj-$(CONFIG_EXTCON_ARIZONA)	+= extcon-arizona.o
 obj-$(CONFIG_EXTCON_PALMAS)	+= extcon-palmas.o
-obj-$(CONFIG_EXTCON_GPIO_USB_VID)	+= extcon-gpio-usb-vid.o
+obj-$(CONFIG_EXTCON_GPIO_USBVID)	+= extcon-gpio-usbvid.o
diff --git a/drivers/extcon/extcon-gpio-usbvid.c b/drivers/extcon/extcon-gpio-usbvid.c
index 5a85c99..e9bc2a97 100644
--- a/drivers/extcon/extcon-gpio-usbvid.c
+++ b/drivers/extcon/extcon-gpio-usbvid.c
@@ -1,5 +1,5 @@
 /*
- * DRA7XX USB ID pin detection driver
+ * Generic  USB VBUS-ID pin detection driver
  *
  * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com
  * This program is free software; you can redistribute it and/or modify
@@ -38,9 +38,11 @@ struct gpio_usbvid {
 
 	/*GPIO pin */
 	int id_gpio;
+	int vbus_gpio;
 
-	int id_prev;
-	int id_current;
+	int id_irq;
+	int vbus_irq;
+	int type;
 };
 
 static const char *dra7xx_extcon_cable[] = {
@@ -51,36 +53,141 @@ static const char *dra7xx_extcon_cable[] = {
 
 static const int mutually_exclusive[] = {0x3, 0x0};
 
+/* Two types of support are provided.
+ * Systems which has
+ *	1) VBUS and ID pin connected via GPIO
+ *	2)  only ID pin connected via GPIO
+ *  For Case 1 both the gpios should be provided via DT
+ *  Always the first GPIO in dt is considered ID pin GPIO
+ */
+
+enum {
+	UNKNOWN = 0,
+	ID_DETECT,
+	VBUS_ID_DETECT,
+};
+
+#define ID_GND		0
+#define ID_FLOAT	1
+#define VBUS_OFF	0
+#define VBUS_ON		1
+
+
 static irqreturn_t id_irq_handler(int irq, void *data)
 {
 	struct gpio_usbvid *gpio_usbvid = (struct gpio_usbvid *) data;
+	int id_current;
 
-	gpio_usbvid->id_current = gpio_get_value_cansleep(gpio_usbvid->id_gpio);
-	printk ("***********id_irq_handler\n");
-	if (gpio_usbvid->id_current == gpio_usbvid->id_prev) {
-		return IRQ_HANDLED;
-	} else if (gpio_usbvid->id_current == 0) {
-		extcon_set_cable_state(&gpio_usbvid->edev, "USB", false);
+	id_current = gpio_get_value_cansleep(gpio_usbvid->id_gpio);
+	if (id_current == ID_GND) {
+		if (gpio_usbvid->type == ID_DETECT)
+			extcon_set_cable_state(&gpio_usbvid->edev,
+							"USB", false);
 		extcon_set_cable_state(&gpio_usbvid->edev, "USB-HOST", true);
 	} else {
 		extcon_set_cable_state(&gpio_usbvid->edev, "USB-HOST", false);
-		extcon_set_cable_state(&gpio_usbvid->edev, "USB", true);
+		if (gpio_usbvid->type == ID_DETECT)
+			extcon_set_cable_state(&gpio_usbvid->edev,
+							"USB", true);
 	}
+	return IRQ_HANDLED;
+}
 
-	gpio_usbvid->id_prev = gpio_usbvid->id_current;
+static irqreturn_t vbus_irq_handler(int irq, void *data)
+{
+	struct gpio_usbvid *gpio_usbvid = (struct gpio_usbvid *) data;
+	int vbus_current;
+
+	vbus_current = gpio_get_value_cansleep(gpio_usbvid->vbus_gpio);
+	if (vbus_current == VBUS_OFF)
+		extcon_set_cable_state(&gpio_usbvid->edev, "USB", false);
+	else
+		extcon_set_cable_state(&gpio_usbvid->edev, "USB", true);
 
 	return IRQ_HANDLED;
 }
 
+
+static void gpio_usbvid_set_initial_state(struct gpio_usbvid *gpio_usbvid)
+{
+	int id_current;
+	int vbus_current;
+
+	switch (gpio_usbvid->type) {
+	case ID_DETECT:
+		id_current = gpio_get_value_cansleep(gpio_usbvid->id_gpio);
+		if (!!id_current == ID_FLOAT) {
+			extcon_set_cable_state(&gpio_usbvid->edev,
+							"USB-HOST", false);
+			extcon_set_cable_state(&gpio_usbvid->edev,
+							"USB", true);
+		} else {
+			extcon_set_cable_state(&gpio_usbvid->edev,
+							"USB", false);
+			extcon_set_cable_state(&gpio_usbvid->edev,
+							"USB-HOST", true);
+		}
+		break;
+
+	case VBUS_ID_DETECT:
+		id_current = gpio_get_value_cansleep(gpio_usbvid->id_gpio);
+		if (!!id_current == ID_FLOAT)
+			extcon_set_cable_state(&gpio_usbvid->edev,
+							"USB-HOST", false);
+		else
+			extcon_set_cable_state(&gpio_usbvid->edev,
+							"USB-HOST", true);
+
+		vbus_current = gpio_get_value_cansleep(gpio_usbvid->vbus_gpio);
+		if (!!vbus_current == VBUS_ON)
+			extcon_set_cable_state(&gpio_usbvid->edev,
+							"USB", true);
+		else
+			extcon_set_cable_state(&gpio_usbvid->edev,
+							"USB", false);
+		break;
+
+	default:
+		dev_err(gpio_usbvid->dev, "Unknown VBUS-ID type\n");
+	}
+}
+
+static int gpio_usbvid_request_irq(struct gpio_usbvid *gpio_usbvid)
+{
+	int ret;
+	ret = devm_request_threaded_irq(gpio_usbvid->dev, gpio_usbvid->id_irq,
+					NULL, id_irq_handler,
+					IRQF_ONESHOT | IRQF_TRIGGER_FALLING,
+					dev_name(gpio_usbvid->dev),
+					(void *) gpio_usbvid);
+	if (ret) {
+		dev_err(gpio_usbvid->dev, "failed to request id irq #%d\n",
+					gpio_usbvid->id_irq);
+		return ret;
+	}
+	if (gpio_usbvid->type == VBUS_ID_DETECT) {
+		ret = devm_request_threaded_irq(gpio_usbvid->dev,
+					gpio_usbvid->vbus_irq, NULL,
+					vbus_irq_handler,
+					IRQF_ONESHOT | IRQF_TRIGGER_FALLING,
+					dev_name(gpio_usbvid->dev),
+					(void *) gpio_usbvid);
+		if (ret)
+			dev_err(gpio_usbvid->dev, "failed to request vbus irq #%d\n",
+						gpio_usbvid->vbus_irq);
+	}
+	return ret;
+}
+
 static int gpio_usbvid_probe(struct platform_device *pdev)
 {
 	struct device_node *node = pdev->dev.of_node;
 	struct gpio_usbvid *gpio_usbvid;
 	int ret;
-	int irq_num;
 	int gpio;
 
-	gpio_usbvid = devm_kzalloc(&pdev->dev, sizeof(*gpio_usbvid), GFP_KERNEL);
+	gpio_usbvid = devm_kzalloc(&pdev->dev, sizeof(*gpio_usbvid),
+								GFP_KERNEL);
 	if (!gpio_usbvid)
 		return -ENOMEM;
 
@@ -93,44 +200,51 @@ static int gpio_usbvid_probe(struct platform_device *pdev)
 	gpio_usbvid->edev.supported_cable = dra7xx_extcon_cable;
 	gpio_usbvid->edev.mutually_exclusive = mutually_exclusive;
 
+	if (of_device_is_compatible(node, "ti,gpio-usb-id"))
+		gpio_usbvid->type = ID_DETECT;
+
 	gpio = of_get_gpio(node, 0);
 	if (gpio_is_valid(gpio)) {
 		gpio_usbvid->id_gpio = gpio;
-		ret = devm_gpio_request(&pdev->dev, gpio_usbvid->id_gpio, "id_gpio");
+		ret = devm_gpio_request(&pdev->dev, gpio_usbvid->id_gpio,
+					"id_gpio");
 		if (ret)
 			return ret;
-		irq_num = gpio_to_irq(gpio_usbvid->id_gpio);
+		gpio_usbvid->id_irq = gpio_to_irq(gpio_usbvid->id_gpio);
 	} else {
 		dev_err(&pdev->dev, "failed to get id gpio\n");
 		return -ENODEV;
 	}
 
+	if (of_device_is_compatible(node, "ti,gpio-usb-vid")) {
+		gpio_usbvid->type = VBUS_ID_DETECT;
+		gpio = of_get_gpio(node, 1);
+		if (gpio_is_valid(gpio)) {
+			gpio_usbvid->vbus_gpio = gpio;
+			ret = devm_gpio_request(&pdev->dev,
+						gpio_usbvid->vbus_gpio,
+						"vbus_gpio");
+			if (ret)
+				return ret;
+			gpio_usbvid->vbus_irq =
+					gpio_to_irq(gpio_usbvid->vbus_gpio);
+		} else {
+			dev_err(&pdev->dev, "failed to get vbus gpio\n");
+			return -ENODEV;
+		}
+	}
+
 	ret = extcon_dev_register(&gpio_usbvid->edev, gpio_usbvid->dev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register extcon device\n");
 		return ret;
 	}
 
-	gpio_usbvid->id_prev = gpio_get_value_cansleep(gpio_usbvid->id_gpio);
-	if (gpio_usbvid->id_prev) {
-		extcon_set_cable_state(&gpio_usbvid->edev, "USB-HOST", false);
-		printk("***********extcon set USB DEV \n");
-		extcon_set_cable_state(&gpio_usbvid->edev, "USB", true);
-	} else {
-		extcon_set_cable_state(&gpio_usbvid->edev, "USB", false);
-		extcon_set_cable_state(&gpio_usbvid->edev, "USB-HOST", true);
-		printk("***********extcon set USB HOST \n");
-	}
-
-	ret = devm_request_threaded_irq(gpio_usbvid->dev, irq_num,
-			NULL, id_irq_handler, 
-			IRQF_ONESHOT | IRQF_TRIGGER_FALLING,
-		dev_name(&pdev->dev), (void *) gpio_usbvid);
-	if (ret) {
-		dev_err(gpio_usbvid->dev, "failed to request irq #%d\n",
-					irq_num);
+	gpio_usbvid_set_initial_state(gpio_usbvid);
+	ret = gpio_usbvid_request_irq(gpio_usbvid);
+	if (ret)
 		goto err0;
-	}
+
 	return 0;
 
 err0:
@@ -148,7 +262,8 @@ static int gpio_usbvid_remove(struct platform_device *pdev)
 }
 
 static struct of_device_id of_gpio_usbvid_match_tbl[] = {
-	{ .compatible = "ti,gpio-usbvid", },
+	{ .compatible = "ti,gpio-usb-vid", },
+	{ .compatible = "ti,gpio-usb-id", },
 	{ /* end */ }
 };
 
-- 
1.8.1.4

