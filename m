Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbaIVKG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 06:06:27 -0400
Received: from mail-by2on0129.outbound.protection.outlook.com ([207.46.100.129]:47298
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752372AbaIVKGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 06:06:25 -0400
X-Greylist: delayed 1034 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Sep 2014 06:06:24 EDT
From: Muthu Mani <muth@cypress.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, <linux-i2c@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, <linux-gpio@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Muthu Mani <muth@cypress.com>,
        "Rajaram Regupathy" <rera@cypress.com>
Subject: [PATCH 3/3] gpio: add support for Cypress CYUSBS234 USB-GPIO adapter
Date: Mon, 22 Sep 2014 15:04:18 +0530
Message-ID: <1411378458-18424-1-git-send-email-muth@cypress.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [121.243.89.10]
X-ClientProxiedBy: BY1PR00CA0041.namprd00.prod.outlook.com (25.160.102.51) To
 BLUPR06MB066.namprd06.prod.outlook.com (10.242.187.145)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR06MB066;
X-Forefront-PRVS: 034215E98F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(15202345003)(36756003)(62966002)(85852003)(101416001)(42186005)(104166001)(21056001)(83072002)(77156001)(50986999)(83322001)(87286001)(229853001)(107046002)(19580395003)(102836001)(89996001)(92566001)(93916002)(92726001)(120916001)(97736003)(88136002)(15975445006)(85306004)(87976001)(99396002)(2201001)(19580405001)(81342003)(4396001)(86362001)(77982003)(46102003)(79102003)(74662003)(77096002)(50226001)(50466002)(47776003)(20776003)(64706001)(90102001)(80022003)(105586002)(106356001)(81542003)(74502003)(76482002)(33646002)(31966008)(66066001)(95666004)(48376002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR06MB066;H:prji-Latitude-E6420.india.cypress.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: cypress.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support for USB-GPIO interface of Cypress Semiconductor
CYUSBS234 USB-Serial Bridge controller.

The GPIO get/set can be done through vendor command
on control endpoint.

Details about the device can be found at:
http://www.cypress.com/?rID=84126

Signed-off-by: Muthu Mani <muth@cypress.com>
Signed-off-by: Rajaram Regupathy <rera@cypress.com>
---
 drivers/gpio/Kconfig          |  13 +++
 drivers/gpio/Makefile         |   1 +
 drivers/gpio/gpio-cyusbs23x.c | 190 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 204 insertions(+)
 create mode 100644 drivers/gpio/gpio-cyusbs23x.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 9de1515..932e07c 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -886,6 +886,19 @@ config GPIO_BCM_KONA
 
 comment "USB GPIO expanders:"
 
+config GPIO_CYUSBS23X
+	tristate "CYUSBS23x GPIO support"
+	depends on MFD_CYUSBS23X && USB
+	help
+	  Say yes here to access the GPIO signals of Cypress
+	  Semiconductor CYUSBS23x USB Serial Bridge Controller.
+
+	  This driver enables the GPIO interface of CYUSBS23x USB Serial
+	  Bridge controller.
+
+	  This driver can also be built as a module. If so, the module will be
+	  called gpio-cyusbs23x.
+
 config GPIO_VIPERBOARD
 	tristate "Viperboard GPIO a & b support"
 	depends on MFD_VIPERBOARD && USB
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 5d024e3..3ad89f1 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_GPIO_BT8XX)	+= gpio-bt8xx.o
 obj-$(CONFIG_GPIO_CLPS711X)	+= gpio-clps711x.o
 obj-$(CONFIG_GPIO_CS5535)	+= gpio-cs5535.o
 obj-$(CONFIG_GPIO_CRYSTAL_COVE)	+= gpio-crystalcove.o
+obj-$(CONFIG_GPIO_CYUSBS23X)	+= gpio-cyusbs23x.o
 obj-$(CONFIG_GPIO_DA9052)	+= gpio-da9052.o
 obj-$(CONFIG_GPIO_DA9055)	+= gpio-da9055.o
 obj-$(CONFIG_GPIO_DAVINCI)	+= gpio-davinci.o
diff --git a/drivers/gpio/gpio-cyusbs23x.c b/drivers/gpio/gpio-cyusbs23x.c
new file mode 100644
index 0000000..8aa3ab6
--- /dev/null
+++ b/drivers/gpio/gpio-cyusbs23x.c
@@ -0,0 +1,190 @@
+/*
+ * Cypress USB-Serial Bridge Controller GPIO driver
+ *
+ * Copyright (c) 2014 Cypress Semiconductor Corporation.
+ *
+ * Author:
+ *   Muthu Mani <muth@cypress.com>
+ *
+ * Additional contributors include:
+ *   Rajaram Regupathy <rera@cypress.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+
+#include <linux/usb.h>
+#include <linux/gpio.h>
+
+#include <linux/mfd/cyusbs23x.h>
+
+#define CY_GPIO_GET_LEN		(2)
+
+struct cyusbs_gpio {
+	struct gpio_chip gpio;
+	struct cyusbs23x *cyusbs;
+};
+
+static int cy_gpio_get(struct gpio_chip *chip,
+			unsigned offset)
+{
+	int ret;
+	char buf[CY_GPIO_GET_LEN];
+	__u16 wIndex, wValue;
+	struct cyusbs_gpio *gpio =
+				container_of(chip, struct cyusbs_gpio, gpio);
+	struct cyusbs23x *cyusbs = gpio->cyusbs;
+
+	dev_dbg(&cyusbs->usb_intf->dev, "%s: %d\n", __func__,
+		offset);
+	wValue = offset;
+	wIndex = 0;
+
+	mutex_lock(&cyusbs->lock);
+	ret = usb_control_msg(cyusbs->usb_dev,
+			usb_rcvctrlpipe(cyusbs->usb_dev, 0),
+			CY_GPIO_GET_VALUE_CMD,
+			USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
+			wValue, wIndex, buf, CY_GPIO_GET_LEN, 2000);
+	mutex_unlock(&cyusbs->lock);
+
+	dev_dbg(&cyusbs->usb_intf->dev, "%s: %d %02x %02x\n", __func__,
+		ret, buf[0], buf[1]);
+
+	if (ret == CY_GPIO_GET_LEN) {
+		if (buf[0] == 0)
+			ret = buf[1];
+		else
+			ret = -EINVAL;
+	} else {
+		ret = -EREMOTEIO;
+	}
+
+	return ret;
+}
+
+static void cy_gpio_set(struct gpio_chip *chip,
+			unsigned offset, int value)
+{
+	int ret;
+	__u16 wIndex, wValue;
+	struct cyusbs_gpio *gpio =
+			container_of(chip, struct cyusbs_gpio, gpio);
+	struct cyusbs23x *cyusbs = gpio->cyusbs;
+
+	dev_dbg(&cyusbs->usb_intf->dev, "%s: %d\n", __func__,
+		offset);
+	wValue = offset;
+	wIndex = value;
+
+	mutex_lock(&cyusbs->lock);
+	ret = usb_control_msg(cyusbs->usb_dev,
+			usb_sndctrlpipe(cyusbs->usb_dev, 0),
+			CY_GPIO_SET_VALUE_CMD,
+			USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
+			wValue, wIndex, NULL, 0, 2000);
+	mutex_unlock(&cyusbs->lock);
+
+	if (ret < 0)
+		dev_err(&cyusbs->usb_intf->dev, "error setting gpio:%d\n", ret);
+}
+
+static int cy_gpio_direction_input(struct gpio_chip *chip,
+					unsigned offset)
+{
+	return 0;
+}
+
+static int cy_gpio_direction_output(struct gpio_chip *chip,
+					unsigned offset, int value)
+{
+	return 0;
+}
+
+static int cyusbs23x_gpio_probe(struct platform_device *pdev)
+{
+	struct cyusbs23x *cyusbs;
+	struct cyusbs_gpio *cy_gpio;
+	int ret = 0;
+
+	dev_dbg(&pdev->dev, "%s\n", __func__);
+
+	cyusbs = dev_get_drvdata(pdev->dev.parent);
+
+	cy_gpio = devm_kzalloc(&pdev->dev, sizeof(*cy_gpio), GFP_KERNEL);
+	if (cy_gpio == NULL)
+		return -ENOMEM;
+
+	cy_gpio->cyusbs = cyusbs;
+	/* registering gpio */
+	cy_gpio->gpio.label = "cyusbs23x gpio";
+	cy_gpio->gpio.dev = &pdev->dev;
+	cy_gpio->gpio.owner = THIS_MODULE;
+	cy_gpio->gpio.base = -1;
+	cy_gpio->gpio.ngpio = 12; /* total GPIOs */
+	cy_gpio->gpio.can_sleep = true;
+	cy_gpio->gpio.set = cy_gpio_set;
+	cy_gpio->gpio.get = cy_gpio_get;
+	cy_gpio->gpio.direction_input = cy_gpio_direction_input;
+	cy_gpio->gpio.direction_output = cy_gpio_direction_output;
+	ret = gpiochip_add(&cy_gpio->gpio);
+	if (ret < 0) {
+		dev_err(cy_gpio->gpio.dev, "could not add gpio");
+		goto error;
+	}
+
+	platform_set_drvdata(pdev, cy_gpio);
+
+	dev_dbg(&pdev->dev, "added GPIO\n");
+	return ret;
+
+error:
+	dev_dbg(&pdev->dev, "error occured %d\n", ret);
+	return ret;
+}
+
+static int cyusbs23x_gpio_remove(struct platform_device *pdev)
+{
+	struct cyusbs_gpio *cy_gpio = platform_get_drvdata(pdev);
+
+	dev_dbg(&pdev->dev, "%s\n", __func__);
+
+	gpiochip_remove(&cy_gpio->gpio);
+
+	return 0;
+}
+
+static struct platform_driver cyusbs23x_gpio_driver = {
+	.driver.name    = "cyusbs23x-gpio",
+	.driver.owner   = THIS_MODULE,
+	.probe          = cyusbs23x_gpio_probe,
+	.remove         = cyusbs23x_gpio_remove,
+};
+
+static int __init cyusbs23x_gpio_init(void)
+{
+	return platform_driver_register(&cyusbs23x_gpio_driver);
+}
+subsys_initcall(cyusbs23x_gpio_init);
+
+static void __exit cyusbs23x_gpio_exit(void)
+{
+	platform_driver_unregister(&cyusbs23x_gpio_driver);
+}
+module_exit(cyusbs23x_gpio_exit);
+
+MODULE_AUTHOR("Rajaram Regupathy <rera@cypress.com>");
+MODULE_AUTHOR("Muthu Mani <muth@cypress.com>");
+MODULE_DESCRIPTION("gpio-cyusbs23x driver v0.1");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:cyusbs23x-gpio");
+
-- 
1.8.3.2

