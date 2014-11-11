Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbaKKHFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 02:05:41 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:43672 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbaKKHFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 02:05:39 -0500
From: Lauri Niskanen <ape@ape3000.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Cc: Lauri Niskanen <ape@ape3000.com>
Subject: [PATCH] usb: misc: Add driver for ALVA Nanoface
Date: Tue, 11 Nov 2014 09:05:06 +0200
Message-Id: <1415689506-1755-1-git-send-email-ape@ape3000.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ALVA Nanoface is a USB audio interface device that only works after
receiving an initialization command. This driver does not handle any
actual audio features, but only initializes the device enabling its
audio I/O and physical controls. There are some additional USB audio
features on the device that are currently not supported. The support
for these features may be added later.

Signed-off-by: Lauri Niskanen <ape@ape3000.com>
---
 drivers/usb/misc/Kconfig    |  9 +++++
 drivers/usb/misc/Makefile   |  1 +
 drivers/usb/misc/nanoface.c | 95 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 105 insertions(+)
 create mode 100644 drivers/usb/misc/nanoface.c

diff --git a/drivers/usb/misc/Kconfig b/drivers/usb/misc/Kconfig
index 76d7720..d01d5c0 100644
--- a/drivers/usb/misc/Kconfig
+++ b/drivers/usb/misc/Kconfig
@@ -249,6 +249,15 @@ config USB_HSIC_USB3503
        help
          This option enables support for SMSC USB3503 HSIC to USB 2.0 Driver.
 
+config USB_NANOFACE
+	tristate "ALVA Nanoface USB driver"
+	help
+	  Say Y here if you need ALVA Nanoface device support. ALVA
+	  Nanoface is a USB audio interface device. See
+	  <http://www.alva-audio.de/nanoface/> for further information.
+	  This driver does not support USB audio features, but enables basic
+	  audio I/O connections and physical controls.
+
 config USB_LINK_LAYER_TEST
 	tristate "USB Link Layer Test driver"
 	help
diff --git a/drivers/usb/misc/Makefile b/drivers/usb/misc/Makefile
index 65b0402..2ee5b73 100644
--- a/drivers/usb/misc/Makefile
+++ b/drivers/usb/misc/Makefile
@@ -25,6 +25,7 @@ obj-$(CONFIG_USB_USS720)		+= uss720.o
 obj-$(CONFIG_USB_SEVSEG)		+= usbsevseg.o
 obj-$(CONFIG_USB_YUREX)			+= yurex.o
 obj-$(CONFIG_USB_HSIC_USB3503)		+= usb3503.o
+obj-$(CONFIG_USB_NANOFACE)		+= nanoface.o
 
 obj-$(CONFIG_USB_SISUSBVGA)		+= sisusbvga/
 obj-$(CONFIG_USB_LINK_LAYER_TEST)	+= lvstest.o
diff --git a/drivers/usb/misc/nanoface.c b/drivers/usb/misc/nanoface.c
new file mode 100644
index 0000000..1201240
--- /dev/null
+++ b/drivers/usb/misc/nanoface.c
@@ -0,0 +1,95 @@
+/*
+ * Minimal driver for ALVA Nanoface USB audio interface. This driver does not
+ * support USB audio, but enables other audio I/O connections on the device.
+ *
+ * Copyright (C) 2014 Lauri Niskanen (ape@ape3000.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/usb.h>
+
+static unsigned char init_setup[] = {0x01, 0x0b, 0x00, 0x00,
+				     0x01, 0x00, 0x00, 0x00};
+static unsigned char init_data[] = {};
+
+static void init_complete_callback(struct urb *request)
+{
+	dev_info(&request->dev->dev, "ALVA Nanoface initialized\n");
+	usb_free_urb(request);
+}
+
+static int nanoface_probe(struct usb_interface *interface,
+			  const struct usb_device_id *id)
+{
+	int status;
+	struct usb_device *dev;
+	struct urb *init_request;
+
+	dev = interface_to_usbdev(interface);
+
+	init_request = usb_alloc_urb(0, 0);
+	if (init_request == 0) {
+		dev_err(&dev->dev, "ALVA Nanoface initialization failed: Cannot allocate memory for URB request\n");
+		return -ENOMEM;
+	}
+
+	dev_info(&dev->dev, "ALVA Nanoface (%04X:%04X) connected\n",
+		 id->idVendor, id->idProduct);
+
+	usb_fill_control_urb(init_request, dev,
+			     usb_sndctrlpipe(dev, 0), init_setup,
+			     init_data, sizeof(init_data),
+			     init_complete_callback, 0);
+
+	status = usb_submit_urb(init_request, 0);
+	if (status != 0) {
+		dev_err(&dev->dev, "ALVA Nanoface initialization failed: Error %d when submitting URB\n",
+		       status);
+		return status;
+	}
+
+	/* do not manage the device */
+	return -ENODEV;
+}
+
+static void nanoface_disconnect(struct usb_interface *interface)
+{
+	dev_info(&interface->dev, "ALVA Nanoface disconnected\n");
+}
+
+static struct usb_device_id nanoface_table[] = {
+	{ USB_DEVICE(0x0a4a, 0xaffe) },
+	{ /* Terminating entry */ }
+};
+
+MODULE_DEVICE_TABLE(usb, nanoface_table);
+
+static struct usb_driver nanoface_driver = {
+	.name = "nanoface",
+	.id_table = nanoface_table,
+	.probe = nanoface_probe,
+	.disconnect = nanoface_disconnect,
+};
+
+static int __init nanoface_init(void)
+{
+	return usb_register(&nanoface_driver);
+}
+
+static void __exit nanoface_exit(void)
+{
+	usb_deregister(&nanoface_driver);
+}
+
+module_init(nanoface_init);
+module_exit(nanoface_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Lauri Niskanen <ape@ape3000.com>");
+MODULE_DESCRIPTION("ALVA Nanoface USB driver");
-- 
2.1.3

