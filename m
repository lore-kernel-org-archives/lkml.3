Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbaK1Qyt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:54:49 -0500
Received: from mail-bl2on0111.outbound.protection.outlook.com ([65.55.169.111]:35614
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751166AbaK1Qyr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:54:47 -0500
X-Greylist: delayed 839 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Nov 2014 11:54:46 EST
From: Muthu Mani <muth@cypress.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, <johan@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-gpio@vger.kernel.org>, Muthu Mani <muth@cypress.com>,
        "Rajaram Regupathy" <rera@cypress.com>
Subject: [PATCH v4 1/3] mfd: add support for Cypress CYUSBS234 USB Serial Bridge controller
Date: Fri, 28 Nov 2014 22:11:03 +0530
Message-ID: <1417192863-16639-1-git-send-email-muth@cypress.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Originating-IP: [121.243.89.10]
X-ClientProxiedBy: BY2PR03CA061.namprd03.prod.outlook.com (10.141.249.34) To
 BY2PR06MB073.namprd06.prod.outlook.com (10.242.42.140)
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR06MB073;
Content-Transfer-Encoding: 7BIT
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR06MB073;
X-Forefront-PRVS: 04097B7F7F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(51164003)(50986999)(93916002)(15975445006)(87286001)(87976001)(19580405001)(19580395003)(42186005)(122386002)(62966003)(31966008)(77096003)(77156002)(15202345003)(92566001)(99396003)(40100003)(120916001)(21056001)(4396001)(50466002)(92726001)(575784001)(86362001)(50226001)(48376002)(66066001)(105586002)(36756003)(104166001)(46102003)(64706001)(107046002)(47776003)(33646002)(20776003)(229853001)(106356001)(89996001)(88136002)(101416001)(102836001)(97736003)(95666004)(2004002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR06MB073;H:prji-Latitude-E6420.india.cypress.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR06MB073;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR06MB456;
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
Changes since v3:
* Added devm_* allocation function
* Added vendor commands to read configuration info

Changes since v2:
* Used auto mfd id to support multiple devices
* Cleaned up the code

Changes since v1:
* Identified different serial interface and loaded correct cell driver
* Formed a mfd id to support multiple devices
* Removed unused platform device

 drivers/mfd/Kconfig           |  12 +++
 drivers/mfd/Makefile          |   1 +
 drivers/mfd/cyusbs23x.c       | 167 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/cyusbs23x.h |  56 ++++++++++++++
 4 files changed, 236 insertions(+)
 create mode 100644 drivers/mfd/cyusbs23x.c
 create mode 100644 include/linux/mfd/cyusbs23x.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 1456ea7..504d125 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -116,6 +116,18 @@ config MFD_ASIC3
          This driver supports the ASIC3 multifunction chip found on many
          PDAs (mainly iPAQ and HTC based ones)

+config MFD_CYUSBS23X
+       tristate "Cypress CYUSBS23x USB Serial Bridge controller"
+       select MFD_CORE
+       depends on USB
+       default n
+       help
+         Say yes here if you want support for Cypress Semiconductor
+         CYUSBS23x USB-Serial Bridge controller.
+
+         This driver can also be built as a module. If so, the module will be
+         called cyusbs23x.
+
 config PMIC_DA903X
        bool "Dialog Semiconductor DA9030/DA9034 PMIC Support"
        depends on I2C=y
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 8bd54b1..81c0f87 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -151,6 +151,7 @@ si476x-core-y := si476x-cmd.o si476x-prop.o si476x-i2c.o
 obj-$(CONFIG_MFD_SI476X_CORE)  += si476x-core.o

 obj-$(CONFIG_MFD_CS5535)       += cs5535-mfd.o
+obj-$(CONFIG_MFD_CYUSBS23X)     += cyusbs23x.o
 obj-$(CONFIG_MFD_OMAP_USB_HOST)        += omap-usb-host.o omap-usb-tll.o
 obj-$(CONFIG_MFD_PM8921_CORE)  += pm8921-core.o ssbi.o
 obj-$(CONFIG_MFD_SPMI_PMIC)    += qcom-spmi-pmic.o
diff --git a/drivers/mfd/cyusbs23x.c b/drivers/mfd/cyusbs23x.c
new file mode 100644
index 0000000..bdde42f
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
+#include <linux/mfd/core.h>
+#include <linux/mfd/cyusbs23x.h>
+
+#include <linux/usb.h>
+
+/* Serial interfaces (I2C, SPI, UART) differ in interface subclass */
+enum cy_scb_modes {
+       CY_USBS_SCB_DISABLED = 0,
+       CY_USBS_SCB_UART = 1,
+       CY_USBS_SCB_SPI = 2,
+       CY_USBS_SCB_I2C = 3
+};
+
+static const struct usb_device_id cyusbs23x_usb_table[] = {
+       { USB_DEVICE(0x04b4, 0x0004) },   /* Cypress Semiconductor CYUSBS234 */
+       { }
+};
+
+MODULE_DEVICE_TABLE(usb, cyusbs23x_usb_table);
+
+static const struct mfd_cell cyusbs23x_i2c_gpio_devs[] = {
+       {
+               .name = "cyusbs23x-i2c",
+       },
+       {
+               .name = "cyusbs23x-gpio",
+       },
+};
+
+static int update_ep_details(struct usb_interface *interface,
+                               struct cyusbs23x *cyusbs)
+{
+       struct usb_host_interface *iface_desc;
+       struct usb_endpoint_descriptor *ep;
+       int i;
+
+       iface_desc = interface->cur_altsetting;
+
+       for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
+
+               ep = &iface_desc->endpoint[i].desc;
+
+               if (!cyusbs->bulk_in_ep_num && usb_endpoint_is_bulk_in(ep))
+                       cyusbs->bulk_in_ep_num = ep->bEndpointAddress;
+               if (!cyusbs->bulk_out_ep_num && usb_endpoint_is_bulk_out(ep))
+                       cyusbs->bulk_out_ep_num = ep->bEndpointAddress;
+               if (!cyusbs->intr_in_ep_num && usb_endpoint_is_int_in(ep))
+                       cyusbs->intr_in_ep_num = ep->bEndpointAddress;
+       }
+
+       dev_dbg(&interface->dev, "%s intr_in=%d, bulk_in=%d, bulk_out=%d\n",
+               __func__, cyusbs->intr_in_ep_num ,
+               cyusbs->bulk_in_ep_num, cyusbs->bulk_out_ep_num);
+
+       if (!cyusbs->bulk_in_ep_num || !cyusbs->bulk_out_ep_num ||
+               !cyusbs->intr_in_ep_num) {
+               dev_err(&interface->dev, "%s invalid endpoints\n", __func__);
+               return -ENODEV;
+       }
+
+       return 0;
+}
+
+static int cyusbs23x_probe(struct usb_interface *interface,
+                          const struct usb_device_id *id)
+{
+       struct cyusbs23x *cyusbs;
+       const struct mfd_cell *cyusbs23x_devs;
+       int ret, ndevs = 0;
+
+       cyusbs = devm_kzalloc(&interface->dev, sizeof(*cyusbs), GFP_KERNEL);
+       if (!cyusbs)
+               return -ENOMEM;
+
+       ret = update_ep_details(interface, cyusbs);
+       if (ret)
+               return -ENODEV;
+
+       /* Serial interfaces (I2C, SPI, UART) differ in interface subclass */
+       switch (interface->cur_altsetting->desc.bInterfaceSubClass) {
+       case CY_USBS_SCB_I2C:
+               dev_info(&interface->dev, "using I2C interface\n");
+               cyusbs23x_devs = cyusbs23x_i2c_gpio_devs;
+               ndevs = ARRAY_SIZE(cyusbs23x_i2c_gpio_devs);
+               break;
+       default:
+               dev_err(&interface->dev, "unsupported subclass\n");
+               return -ENODEV;
+       }
+
+       cyusbs->usb_dev = usb_get_dev(interface_to_usbdev(interface));
+       cyusbs->usb_intf = interface;
+       cyusbs->intf_num = interface->cur_altsetting->desc.bInterfaceNumber;
+       usb_set_intfdata(interface, cyusbs);
+
+       ret = mfd_add_devices(&interface->dev, PLATFORM_DEVID_AUTO,
+                               cyusbs23x_devs, ndevs, NULL, 0, NULL);
+       if (ret) {
+               dev_err(&interface->dev, "Failed to register devices\n");
+               goto error;
+       }
+
+       dev_info(&interface->dev, "registered MFD device\n");
+       return 0;
+
+error:
+       usb_put_dev(cyusbs->usb_dev);
+
+       return ret;
+}
+
+static void cyusbs23x_disconnect(struct usb_interface *interface)
+{
+       struct cyusbs23x *cyusbs = usb_get_intfdata(interface);
+
+       mfd_remove_devices(&interface->dev);
+       usb_put_dev(cyusbs->usb_dev);
+}
+
+static struct usb_driver cyusbs23x_usb_driver = {
+       .name           = "cyusbs23x",
+       .probe          = cyusbs23x_probe,
+       .disconnect     = cyusbs23x_disconnect,
+       .id_table       = cyusbs23x_usb_table,
+};
+
+module_usb_driver(cyusbs23x_usb_driver);
+
+MODULE_AUTHOR("Rajaram Regupathy <rera@cypress.com>");
+MODULE_AUTHOR("Muthu Mani <muth@cypress.com>");
+MODULE_DESCRIPTION("Cypress CYUSBS23x MFD core driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/mfd/cyusbs23x.h b/include/linux/mfd/cyusbs23x.h
new file mode 100644
index 0000000..534fcf7
--- /dev/null
+++ b/include/linux/mfd/cyusbs23x.h
@@ -0,0 +1,56 @@
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
+       struct usb_device *usb_dev;
+       struct usb_interface *usb_intf;
+
+       u8 intf_num;
+       u8 bulk_in_ep_num;
+       u8 bulk_out_ep_num;
+       u8 intr_in_ep_num;
+};
+
+enum cy_usbs_vendor_cmds {
+       CY_DEV_CMD_READ_CONFIG         = 0xB5,
+       CY_I2C_GET_CONFIG_CMD          = 0xC4,
+       CY_I2C_SET_CONFIG_CMD          = 0xC5,
+       CY_I2C_WRITE_CMD               = 0xC6,
+       CY_I2C_READ_CMD                = 0xC7,
+       CY_I2C_GET_STATUS_CMD          = 0xC8,
+       CY_I2C_RESET_CMD               = 0xC9,
+       CY_GPIO_GET_CONFIG_CMD         = 0xD8,
+       CY_GPIO_SET_CONFIG_CMD         = 0xD9,
+       CY_GPIO_GET_VALUE_CMD          = 0xDA,
+       CY_GPIO_SET_VALUE_CMD          = 0xDB,
+       CY_DEV_ENABLE_CONFIG_READ_CMD  = 0xE2
+};
+
+/* SCB index shift */
+#define CY_SCB_INDEX_SHIFT      15
+
+#define CY_USBS_CTRL_XFER_TIMEOUT      2000
+#define CY_USBS_BULK_XFER_TIMEOUT      5000
+#define CY_USBS_INTR_XFER_TIMEOUT      5000
+
+#endif /* __MFD_CYUSBS23X_H__ */
--
1.8.3.2


This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
