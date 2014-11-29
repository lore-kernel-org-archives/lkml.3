Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbaK2GfR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 01:35:17 -0500
Received: from mail-by2on0141.outbound.protection.outlook.com ([207.46.100.141]:45856
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750995AbaK2GfP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 01:35:15 -0500
From: Muthu Mani <muth@cypress.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, <gregkh@linuxfoundation.org>,
        Johan Hovold <johan@kernel.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        Muthu Mani <muth@cypress.com>, Rajaram Regupathy <rera@cypress.com>
Subject: [PATCH v4 3/3] gpio: add support for Cypress CYUSBS234 USB-GPIO adapter
Date: Sat, 29 Nov 2014 11:51:28 +0530
Message-ID: <1417242088-17945-1-git-send-email-muth@cypress.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Originating-IP: [121.243.89.10]
X-ClientProxiedBy: BY2PR03CA077.namprd03.prod.outlook.com (10.141.249.50) To
 CO1PR06MB079.namprd06.prod.outlook.com (10.242.164.22)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR06MB079;
Content-Transfer-Encoding: 7BIT
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CO1PR06MB079;
X-Forefront-PRVS: 041032FF37
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(51164003)(189002)(199003)(107046002)(86362001)(93916002)(99396003)(95666004)(40100003)(122386002)(229853001)(106356001)(92566001)(87286001)(92726001)(120916001)(42186005)(33646002)(87976001)(88136002)(105586002)(89996001)(77096004)(4396001)(36756003)(50226001)(50986999)(97736003)(21056001)(77156002)(62966003)(15202345003)(101416001)(46102003)(19580395003)(104166001)(64706001)(50466002)(15975445006)(102836001)(47776003)(20776003)(19580405001)(66066001)(48376002)(31966008)(21314002)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR06MB079;H:prji-Latitude-E6420.india.cypress.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CO1PR06MB079;
X-OriginatorOrg: cypress.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support for USB-GPIO interface of Cypress Semiconductor
CYUSBS234 USB-Serial Bridge controller.

The GPIO get/set can be done through vendor command on control endpoint
for the configured gpios.

Details about the device can be found at:
http://www.cypress.com/?rID=84126

Signed-off-by: Muthu Mani <muth@cypress.com>
Signed-off-by: Rajaram Regupathy <rera@cypress.com>
---
Changes since v3:
* added reading gpio configuration from device
* exposed only the gpios available
* exposed correct direction of gpios
* removed the direction input/output handler as
  setting gpio direction is not supported by the device

Changes since v2:
* added helper macros
* removed lock
* given gpio chip device for dev_xxx
* cleaned up the code

Changes since v1:
* allocated memory on heap for usb transfer data
* changed gpio label as platform device name to identify multiple devices

 drivers/gpio/Kconfig          |  13 ++
 drivers/gpio/Makefile         |   1 +
 drivers/gpio/gpio-cyusbs23x.c | 284 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 298 insertions(+)
 create mode 100644 drivers/gpio/gpio-cyusbs23x.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 0959ca9..66f460f5 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -894,6 +894,19 @@ config GPIO_BCM_KONA

 comment "USB GPIO expanders:"

+config GPIO_CYUSBS23X
+       tristate "CYUSBS23x GPIO support"
+       depends on MFD_CYUSBS23X && USB
+       help
+         Say yes here to access the GPIO signals of Cypress
+         Semiconductor CYUSBS23x USB Serial Bridge Controller.
+
+         This driver enables the GPIO interface of CYUSBS23x USB Serial
+         Bridge controller.
+
+         This driver can also be built as a module. If so, the module will be
+         called gpio-cyusbs23x.
+
 config GPIO_VIPERBOARD
        tristate "Viperboard GPIO a & b support"
        depends on MFD_VIPERBOARD && USB
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index e5d346c..da30751 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_GPIO_BT8XX)      += gpio-bt8xx.o
 obj-$(CONFIG_GPIO_CLPS711X)    += gpio-clps711x.o
 obj-$(CONFIG_GPIO_CS5535)      += gpio-cs5535.o
 obj-$(CONFIG_GPIO_CRYSTAL_COVE)        += gpio-crystalcove.o
+obj-$(CONFIG_GPIO_CYUSBS23X)   += gpio-cyusbs23x.o
 obj-$(CONFIG_GPIO_DA9052)      += gpio-da9052.o
 obj-$(CONFIG_GPIO_DA9055)      += gpio-da9055.o
 obj-$(CONFIG_GPIO_DAVINCI)     += gpio-davinci.o
diff --git a/drivers/gpio/gpio-cyusbs23x.c b/drivers/gpio/gpio-cyusbs23x.c
new file mode 100644
index 0000000..9f6beb1
--- /dev/null
+++ b/drivers/gpio/gpio-cyusbs23x.c
@@ -0,0 +1,284 @@
+/*
+ * GPIO subdriver for Cypress CYUSBS234 USB-Serial Bridge controller.
+ * Details about the device can be found at:
+ *    http://www.cypress.com/?rID=84126
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
+/*
+ * All GPIOs are exposed for get operation. Only the GPIOs which are configured
+ * by the user using the Configuration Utility can be set. Attempting to set
+ * value of unconfigured GPIOs would fail
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
+#define CY_GPIO_GET_LEN                2
+#define CY_DEVICE_CONFIG_SIZE  512
+
+/* total GPIOs present */
+#define CYUSBS234_GPIO_NUM     12
+
+struct cyusbs_gpio {
+       struct gpio_chip gpio;
+       struct cyusbs23x *cyusbs;
+       u32 out_gpio;
+       u32 out_value;
+       u32 in_gpio;
+};
+
+#define to_cyusbs_gpio(chip) container_of(chip, struct cyusbs_gpio, gpio)
+
+static int cy_gpio_get(struct gpio_chip *chip,
+                       unsigned offset)
+{
+       int ret;
+       char *buf;
+       u16 wIndex, wValue;
+       struct cyusbs_gpio *gpio = to_cyusbs_gpio(chip);
+       struct cyusbs23x *cyusbs = gpio->cyusbs;
+
+       if (gpio->out_gpio & (1 << offset))
+               return gpio->out_value & (1 << offset);
+
+       wValue = offset;
+       wIndex = 0;
+       buf = kmalloc(CY_GPIO_GET_LEN, GFP_KERNEL);
+       if (buf == NULL)
+               return -ENOMEM;
+
+       ret = usb_control_msg(cyusbs->usb_dev,
+                       usb_rcvctrlpipe(cyusbs->usb_dev, 0),
+                       CY_GPIO_GET_VALUE_CMD,
+                       USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
+                       wValue, wIndex, buf, CY_GPIO_GET_LEN,
+                       CY_USBS_CTRL_XFER_TIMEOUT);
+       if (ret == CY_GPIO_GET_LEN) {
+               dev_dbg(chip->dev, "%s: offset=%d %02X %02X\n",
+                       __func__, offset, buf[0], buf[1]);
+               if (buf[0] == 0)
+                       ret = buf[1];
+               else
+                       ret = -EIO;
+       } else {
+               dev_err(chip->dev, "%s: offset=%d %d\n", __func__, offset, ret);
+               ret = -EIO;
+       }
+
+       kfree(buf);
+       return ret;
+}
+
+static void cy_gpio_set(struct gpio_chip *chip,
+                       unsigned offset, int value)
+{
+       int ret;
+       u16 wIndex, wValue;
+       struct cyusbs_gpio *gpio = to_cyusbs_gpio(chip);
+       struct cyusbs23x *cyusbs = gpio->cyusbs;
+
+       wValue = offset;
+       wIndex = value;
+
+       ret = usb_control_msg(cyusbs->usb_dev,
+                       usb_sndctrlpipe(cyusbs->usb_dev, 0),
+                       CY_GPIO_SET_VALUE_CMD,
+                       USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
+                       wValue, wIndex, NULL, 0, CY_USBS_CTRL_XFER_TIMEOUT);
+       if (ret < 0)
+               dev_err(chip->dev, "error setting gpio %d: %d\n", offset, ret);
+       else {
+               if (value)
+                       gpio->out_value |= (1 << offset);
+               else
+                       gpio->out_value &= ~(1 << offset);
+       }
+}
+
+static int cy_gpio_request(struct gpio_chip *chip, unsigned offset)
+{
+       u32 gpios;
+       struct cyusbs_gpio *gpio = to_cyusbs_gpio(chip);
+
+       gpios = gpio->out_gpio | gpio->in_gpio;
+       if (gpios & (1 << offset))
+               return 0;
+
+       return -ENODEV;
+}
+
+static int cy_gpio_get_direction(struct gpio_chip *chip,
+                                       unsigned offset)
+{
+       struct cyusbs_gpio *gpio = to_cyusbs_gpio(chip);
+
+       if (gpio->out_gpio & (1 << offset))
+               return GPIOF_DIR_OUT;
+       else if (gpio->in_gpio & (1 << offset))
+               return GPIOF_DIR_IN;
+
+       return -EIO;
+}
+
+static int cy_get_device_config(struct cyusbs23x *cyusbs, u8 *buf)
+{
+       int ret;
+
+       ret = usb_control_msg(cyusbs->usb_dev,
+                       usb_sndctrlpipe(cyusbs->usb_dev, 0),
+                       CY_DEV_ENABLE_CONFIG_READ_CMD,
+                       USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
+                       0xA6BC, 0xB1B0, NULL, 0,
+                       CY_USBS_CTRL_XFER_TIMEOUT);
+       if (ret) {
+               dev_err(&cyusbs->usb_dev->dev,
+                       "%s: enable config read status%d\n", __func__, ret);
+               return -ENODEV;
+       }
+
+       ret = usb_control_msg(cyusbs->usb_dev,
+                       usb_rcvctrlpipe(cyusbs->usb_dev, 0),
+                       CY_DEV_CMD_READ_CONFIG,
+                       USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
+                       0, 0, buf, CY_DEVICE_CONFIG_SIZE,
+                       CY_USBS_CTRL_XFER_TIMEOUT);
+       if (ret != CY_DEVICE_CONFIG_SIZE) {
+               dev_err(&cyusbs->usb_dev->dev,
+                       "%s: read config status %d\n", __func__, ret);
+               return -ENODEV;
+       }
+
+       ret = usb_control_msg(cyusbs->usb_dev,
+                       usb_sndctrlpipe(cyusbs->usb_dev, 0),
+                       CY_DEV_ENABLE_CONFIG_READ_CMD,
+                       USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
+                       0xA6BC, 0xB9B0, NULL, 0,
+                       CY_USBS_CTRL_XFER_TIMEOUT);
+       if (ret) {
+               dev_err(&cyusbs->usb_dev->dev,
+                       "%s: disable config read status%d\n", __func__, ret);
+               return -ENODEV;
+       }
+
+       return 0;
+}
+
+static int cy_gpio_retrieve_gpio_details(struct cyusbs_gpio *gpio)
+{
+       int ret;
+       u32 drive0, drive1;
+       u8 *buf;
+       struct cyusbs23x *cyusbs = gpio->cyusbs;
+
+       buf = kzalloc(CY_DEVICE_CONFIG_SIZE, GFP_KERNEL);
+       if (buf == NULL)
+               return -ENOMEM;
+
+       ret = cy_get_device_config(cyusbs, buf);
+       if (ret) {
+               dev_err(&cyusbs->usb_dev->dev,
+                       "could not retrieve device configuration\n");
+               goto error;
+       }
+
+       /* Retrieve the GPIO configuration details */
+       drive0 = *((u32 *)&buf[436]);
+       drive1 = *((u32 *)&buf[440]);
+       gpio->out_gpio = drive0 | drive1;
+       gpio->out_value = drive1;
+       gpio->in_gpio = *((u32 *)&buf[444]);
+
+error:
+       kfree(buf);
+       return ret;
+}
+
+static int cyusbs23x_gpio_probe(struct platform_device *pdev)
+{
+       struct cyusbs23x *cyusbs;
+       struct cyusbs_gpio *cy_gpio;
+       int ret = 0;
+
+       dev_dbg(&pdev->dev, "%s\n", __func__);
+
+       cyusbs = dev_get_drvdata(pdev->dev.parent);
+
+       cy_gpio = devm_kzalloc(&pdev->dev, sizeof(*cy_gpio), GFP_KERNEL);
+       if (cy_gpio == NULL)
+               return -ENOMEM;
+
+       cy_gpio->cyusbs = cyusbs;
+       /* retrieve GPIO configuration info */
+       ret = cy_gpio_retrieve_gpio_details(cy_gpio);
+       if (ret) {
+               dev_err(&pdev->dev, "could not retrieve gpio details\n");
+               return -ENODEV;
+       }
+
+       /* registering gpio */
+       cy_gpio->gpio.label = dev_name(&pdev->dev);
+       cy_gpio->gpio.dev = &pdev->dev;
+       cy_gpio->gpio.owner = THIS_MODULE;
+       cy_gpio->gpio.base = -1;
+       cy_gpio->gpio.ngpio = CYUSBS234_GPIO_NUM;
+       cy_gpio->gpio.can_sleep = true;
+       cy_gpio->gpio.request = cy_gpio_request;
+       cy_gpio->gpio.set = cy_gpio_set;
+       cy_gpio->gpio.get = cy_gpio_get;
+       cy_gpio->gpio.get_direction = cy_gpio_get_direction;
+       ret = gpiochip_add(&cy_gpio->gpio);
+       if (ret < 0) {
+               dev_err(cy_gpio->gpio.dev, "could not add gpio\n");
+               return ret;
+       }
+
+       platform_set_drvdata(pdev, cy_gpio);
+
+       dev_dbg(&pdev->dev, "added GPIO\n");
+       return ret;
+}
+
+static int cyusbs23x_gpio_remove(struct platform_device *pdev)
+{
+       struct cyusbs_gpio *cy_gpio = platform_get_drvdata(pdev);
+
+       dev_dbg(&pdev->dev, "%s\n", __func__);
+       gpiochip_remove(&cy_gpio->gpio);
+       return 0;
+}
+
+static struct platform_driver cyusbs23x_gpio_driver = {
+       .driver.name    = "cyusbs23x-gpio",
+       .probe          = cyusbs23x_gpio_probe,
+       .remove         = cyusbs23x_gpio_remove,
+};
+
+module_platform_driver(cyusbs23x_gpio_driver);
+
+MODULE_AUTHOR("Rajaram Regupathy <rera@cypress.com>");
+MODULE_AUTHOR("Muthu Mani <muth@cypress.com>");
+MODULE_DESCRIPTION("GPIO driver for CYUSBS23x");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:cyusbs23x-gpio");
--
1.8.3.2


This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
