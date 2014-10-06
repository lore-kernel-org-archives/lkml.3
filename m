Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbaJFMwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 08:52:19 -0400
Received: from mail-bn1bon0119.outbound.protection.outlook.com ([157.56.111.119]:31551
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752503AbaJFMwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 08:52:15 -0400
From: Muthu Mani <muth@cypress.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, <linux-i2c@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, <linux-gpio@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Muthu Mani <muth@cypress.com>,
        Rajaram Regupathy <rera@cypress.com>
Subject: [PATCH v3 1/3] mfd: add support for Cypress CYUSBS234 USB Serial Bridge controller
Date: Mon, 6 Oct 2014 18:22:29 +0530
Message-ID: <1412599949-3818-1-git-send-email-muth@cypress.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [121.243.89.10]
X-ClientProxiedBy: CO2PR06CA014.namprd06.prod.outlook.com (10.141.242.14) To
 BLUPR06MB067.namprd06.prod.outlook.com (10.242.187.146)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR06MB067;
X-Forefront-PRVS: 03569407CC
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(93916002)(97736003)(4396001)(86362001)(101416001)(229853001)(20776003)(47776003)(21056001)(107046002)(64706001)(50226001)(42186005)(85306004)(80022003)(48376002)(46102003)(66066001)(2201001)(50986999)(105586002)(87286001)(36756003)(87976001)(102836001)(19580395003)(19580405001)(15202345003)(104166001)(62966002)(76482002)(122386002)(77096002)(77156001)(120916001)(40100001)(99396003)(50466002)(10300001)(95666004)(92726001)(92566001)(106356001)(33646002)(15975445006)(85852003)(31966008)(89996001)(2004002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR06MB067;H:prji-Latitude-E6420.india.cypress.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: cypress.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support for USB-I2C/GPIO interfaces of Cypress Semiconductor
CYUSBS234 USB-Serial Bridge controller.

Details about the device can be found at:
http://www.cypress.com/?rID=84126

Signed-off-by: Muthu Mani <muth@cypress.com>
Signed-off-by: Rajaram Regupathy <rera@cypress.com>
---
 drivers/mfd/Kconfig           |  12 +++
 drivers/mfd/Makefile          |   1 +
 drivers/mfd/cyusbs23x.c       | 167 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/cyusbs23x.h |  62 ++++++++++++++++
 4 files changed, 242 insertions(+)
 create mode 100644 drivers/mfd/cyusbs23x.c
 create mode 100644 include/linux/mfd/cyusbs23x.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index de5abf2..a31e9e3 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -116,6 +116,18 @@ config MFD_ASIC3
 	  This driver supports the ASIC3 multifunction chip found on many
 	  PDAs (mainly iPAQ and HTC based ones)
 
+config MFD_CYUSBS23X
+        tristate "Cypress CYUSBS23x USB Serial Bridge controller"
+	select MFD_CORE
+	depends on USB
+	default n
+	help
+	  Say yes here if you want support for Cypress Semiconductor
+	  CYUSBS23x USB-Serial Bridge controller.
+
+	  This driver can also be built as a module. If so, the module will be
+	  called cyusbs23x.
+
 config PMIC_DA903X
 	bool "Dialog Semiconductor DA9030/DA9034 PMIC Support"
 	depends on I2C=y
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index f001487..fc5bcd1 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -151,6 +151,7 @@ si476x-core-y := si476x-cmd.o si476x-prop.o si476x-i2c.o
 obj-$(CONFIG_MFD_SI476X_CORE)	+= si476x-core.o
 
 obj-$(CONFIG_MFD_CS5535)	+= cs5535-mfd.o
+obj-$(CONFIG_MFD_CYUSBS23X)     += cyusbs23x.o
 obj-$(CONFIG_MFD_OMAP_USB_HOST)	+= omap-usb-host.o omap-usb-tll.o
 obj-$(CONFIG_MFD_PM8921_CORE) 	+= pm8921-core.o ssbi.o
 obj-$(CONFIG_TPS65911_COMPARATOR)	+= tps65911-comparator.o
diff --git a/drivers/mfd/cyusbs23x.c b/drivers/mfd/cyusbs23x.c
new file mode 100644
index 0000000..c70ea40
--- /dev/null
+++ b/drivers/mfd/cyusbs23x.c
@@ -0,0 +1,167 @@
+/*
+ * Cypress USB-Serial Bridge Controller USB adapter driver
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
+ * This is core MFD driver for Cypress Semiconductor CYUSBS234 USB-Serial
+ * Bridge controller. CYUSBS234 offers a single channel serial interface
+ * (I2C/SPI/UART). It can be configured to enable either of I2C, SPI, UART
+ * interfaces. The GPIOs are also available to access.
+ * Details about the device can be found at:
+ *    http://www.cypress.com/?rID=84126
+ *
+ * Separate cell drivers are available for I2C and GPIO. SPI and UART are not
+ * supported yet. All GPIOs are exposed for get operation. However, only
+ * unused GPIOs can be set.
+ */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/mutex.h>
+
+#include <linux/mfd/core.h>
+#include <linux/mfd/cyusbs23x.h>
+
+#include <linux/usb.h>
+
+static const struct usb_device_id cyusbs23x_usb_table[] = {
+	{ USB_DEVICE(0x04b4, 0x0004) },   /* Cypress Semiconductor */
+	{ }                               /* Terminating entry */
+};
+
+MODULE_DEVICE_TABLE(usb, cyusbs23x_usb_table);
+
+static const struct mfd_cell cyusbs23x_i2c_devs[] = {
+	{
+		.name = "cyusbs23x-i2c",
+	},
+	{
+		.name = "cyusbs23x-gpio",
+	},
+};
+
+static int update_ep_details(struct usb_interface *interface,
+				struct cyusbs23x *cyusbs)
+{
+	struct usb_host_interface *iface_desc;
+	struct usb_endpoint_descriptor *ep;
+	int i;
+
+	iface_desc = interface->cur_altsetting;
+
+	for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
+
+		ep = &iface_desc->endpoint[i].desc;
+
+		if (!cyusbs->bulk_in_ep_num && usb_endpoint_is_bulk_in(ep))
+			cyusbs->bulk_in_ep_num = ep->bEndpointAddress;
+		if (!cyusbs->bulk_out_ep_num && usb_endpoint_is_bulk_out(ep))
+			cyusbs->bulk_out_ep_num = ep->bEndpointAddress;
+		if (!cyusbs->intr_in_ep_num && usb_endpoint_is_int_in(ep))
+			cyusbs->intr_in_ep_num = ep->bEndpointAddress;
+	}
+
+	dev_dbg(&interface->dev, "%s intr_in=%d, bulk_in=%d, bulk_out=%d\n",
+		__func__, cyusbs->intr_in_ep_num ,
+		cyusbs->bulk_in_ep_num, cyusbs->bulk_out_ep_num);
+
+	if (!cyusbs->bulk_in_ep_num || !cyusbs->bulk_out_ep_num ||
+		!cyusbs->intr_in_ep_num)
+		return -ENODEV;
+
+	return 0;
+}
+
+static int cyusbs23x_probe(struct usb_interface *interface,
+			   const struct usb_device_id *id)
+{
+	struct cyusbs23x *cyusbs;
+	const struct mfd_cell *cyusbs23x_devs;
+	int ret, ndevs = 0;
+	u8 sub_class;
+
+	cyusbs = kzalloc(sizeof(*cyusbs), GFP_KERNEL);
+	if (cyusbs == NULL)
+		return -ENOMEM;
+
+	cyusbs->usb_dev = usb_get_dev(interface_to_usbdev(interface));
+	cyusbs->usb_intf = interface;
+	cyusbs->intf_num = interface->cur_altsetting->desc.bInterfaceNumber;
+
+	ret = update_ep_details(interface, cyusbs);
+	if (ret < 0) {
+		dev_err(&interface->dev, "invalid interface\n");
+		goto error;
+	}
+
+	usb_set_intfdata(interface, cyusbs);
+
+	/* Serial interfaces (I2C, SPI, UART) differ in interface subclass */
+	sub_class = interface->cur_altsetting->desc.bInterfaceSubClass;
+	switch (sub_class) {
+	case CY_USBS_SCB_I2C:
+		dev_info(&interface->dev, "I2C interface found\n");
+		cyusbs23x_devs = cyusbs23x_i2c_devs;
+		ndevs = ARRAY_SIZE(cyusbs23x_i2c_devs);
+		break;
+	default:
+		dev_err(&interface->dev, "unsupported subclass\n");
+		ret = -ENODEV;
+		goto error;
+	}
+
+	ret = mfd_add_devices(&interface->dev, PLATFORM_DEVID_AUTO,
+				cyusbs23x_devs, ndevs, NULL, 0, NULL);
+	if (ret != 0) {
+		dev_err(&interface->dev, "Failed to add mfd devices to core\n");
+		goto error;
+	}
+
+	return 0;
+
+error:
+	usb_put_dev(cyusbs->usb_dev);
+	kfree(cyusbs);
+
+	return ret;
+}
+
+static void cyusbs23x_disconnect(struct usb_interface *interface)
+{
+	struct cyusbs23x *cyusbs = usb_get_intfdata(interface);
+
+	mfd_remove_devices(&interface->dev);
+	usb_put_dev(cyusbs->usb_dev);
+	kfree(cyusbs);
+
+	dev_dbg(&interface->dev, "disconnected\n");
+}
+
+static struct usb_driver cyusbs23x_usb_driver = {
+	.name           = "cyusbs23x",
+	.probe          = cyusbs23x_probe,
+	.disconnect     = cyusbs23x_disconnect,
+	.id_table       = cyusbs23x_usb_table,
+};
+
+module_usb_driver(cyusbs23x_usb_driver);
+
+MODULE_AUTHOR("Rajaram Regupathy <rera@cypress.com>");
+MODULE_AUTHOR("Muthu Mani <muth@cypress.com>");
+MODULE_DESCRIPTION("Cypress CYUSBS23x mfd core driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/mfd/cyusbs23x.h b/include/linux/mfd/cyusbs23x.h
new file mode 100644
index 0000000..1580d98
--- /dev/null
+++ b/include/linux/mfd/cyusbs23x.h
@@ -0,0 +1,62 @@
+/*
+ * Cypress USB-Serial Bridge Controller definitions
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
+#ifndef __MFD_CYUSBS23X_H__
+#define __MFD_CYUSBS23X_H__
+
+#include <linux/types.h>
+#include <linux/usb.h>
+
+/* Structure to hold all device specific stuff */
+struct cyusbs23x {
+	struct usb_device *usb_dev;
+	struct usb_interface *usb_intf;
+
+	u8 intf_num;
+	u8 bulk_in_ep_num;
+	u8 bulk_out_ep_num;
+	u8 intr_in_ep_num;
+};
+
+enum cy_usbs_vendor_cmds {
+	CY_I2C_GET_CONFIG_CMD  = 0xC4,
+	CY_I2C_SET_CONFIG_CMD  = 0xC5,
+	CY_I2C_WRITE_CMD       = 0xC6,
+	CY_I2C_READ_CMD        = 0xC7,
+	CY_I2C_GET_STATUS_CMD  = 0xC8,
+	CY_I2C_RESET_CMD       = 0xC9,
+	CY_GPIO_GET_CONFIG_CMD = 0xD8,
+	CY_GPIO_SET_CONFIG_CMD = 0xD9,
+	CY_GPIO_GET_VALUE_CMD  = 0xDA,
+	CY_GPIO_SET_VALUE_CMD  = 0xDB,
+};
+
+/* Serial interfaces (I2C, SPI, UART) differ in interface subclass */
+enum cy_scb_modes {
+	CY_USBS_SCB_DISABLED = 0,
+	CY_USBS_SCB_UART = 1,
+	CY_USBS_SCB_SPI = 2,
+	CY_USBS_SCB_I2C = 3
+};
+
+/* SCB index shift */
+#define CY_SCB_INDEX_SHIFT      15
+
+#define CY_USBS_CTRL_XFER_TIMEOUT	2000
+#define CY_USBS_BULK_XFER_TIMEOUT	5000
+#define CY_USBS_INTR_XFER_TIMEOUT	5000
+
+#endif /* __MFD_CYUSBS23X_H__ */
-- 
1.8.3.2

