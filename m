Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab3ETXbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 19:31:19 -0400
Received: from mout.gmx.net ([212.227.15.15]:64355 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932095Ab3ETXbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 19:31:16 -0400
X-Authenticated: #885997
X-Provags-ID: V01U2FsdGVkX1+GOqUjiaiG/oElD3p/29W2dLCuHEZhDs8eE9Jnra
	kdrHpLSExmuYXm
From: Christian Ohm <chr.ohm@gmx.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] HID: Add driver for Holtek gaming mouse 04d9:a067
Date: Tue, 21 May 2013 01:31:08 +0200
Message-Id: <39428ed7f69bd06e3d93f730ba8f7b7b0a3f6c26.1369083628.git.chr.ohm@gmx.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1369083628.git.chr.ohm@gmx.net>
References: <cover.1369083628.git.chr.ohm@gmx.net>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This mouse is sold as Sharkoon Drakonia and Perixx MX-2000 and reports a
too high usage maximum and logical maximum. This driver fixes the report
descriptor so those values don't exceed HID_MAX_USAGES.

Signed-off-by: Christian Ohm <chr.ohm@gmx.net>
---
 drivers/hid/Kconfig            |    1 +
 drivers/hid/Makefile           |    1 +
 drivers/hid/hid-holtek-mouse.c |   72 ++++++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-ids.h          |    1 +
 4 files changed, 75 insertions(+)
 create mode 100644 drivers/hid/hid-holtek-mouse.c

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index e7d6a13..d661a41 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -220,6 +220,7 @@ config HID_HOLTEK
 	Support for Holtek based devices:
 	  - Holtek On Line Grip based game controller
 	  - Trust GXT 18 Gaming Keyboard
+	  - Sharkoon Drakonia / Perixx MX-2000 gaming mice
 
 config HOLTEK_FF
 	bool "Holtek On Line Grip force feedback support"
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index b622157..c39bfc4 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -50,6 +50,7 @@ obj-$(CONFIG_HID_ELECOM)	+= hid-elecom.o
 obj-$(CONFIG_HID_EZKEY)		+= hid-ezkey.o
 obj-$(CONFIG_HID_GYRATION)	+= hid-gyration.o
 obj-$(CONFIG_HID_HOLTEK)	+= hid-holtek-kbd.o
+obj-$(CONFIG_HID_HOLTEK)	+= hid-holtek-mouse.o
 obj-$(CONFIG_HID_HOLTEK)	+= hid-holtekff.o
 obj-$(CONFIG_HID_HYPERV_MOUSE)	+= hid-hyperv.o
 obj-$(CONFIG_HID_ICADE)		+= hid-icade.o
diff --git a/drivers/hid/hid-holtek-mouse.c b/drivers/hid/hid-holtek-mouse.c
new file mode 100644
index 0000000..f32e29a
--- /dev/null
+++ b/drivers/hid/hid-holtek-mouse.c
@@ -0,0 +1,72 @@
+/*
+ * HID driver for Holtek gaming mice
+ * Copyright (c) 2013 Christian Ohm
+ * Heavily inspired by various other HID drivers that adjust the report
+ * descriptor.
+*/
+
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <linux/hid.h>
+#include <linux/module.h>
+#include <linux/usb.h>
+
+#include "hid-ids.h"
+
+/*
+ * The report descriptor of some Holtek based gaming mice specifies an
+ * excessively large number of consumer usages (2^15), which is more than
+ * HID_MAX_USAGES. This prevents proper parsing of the report descriptor.
+ *
+ * This driver fixes the report descriptor for USB ID 04d9:a067, sold as
+ * Sharkoon Drakonia and Perixx MX-2000.
+ */
+
+static __u8 *holtek_mouse_report_fixup(struct hid_device *hdev, __u8 *rdesc,
+		unsigned int *rsize)
+{
+	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
+
+	if (intf->cur_altsetting->desc.bInterfaceNumber == 1) {
+		/* Change usage maximum and logical maximum from 0x7fff to
+		 * 0x2fff, so they don't exceed HID_MAX_USAGES */
+		if (*rsize >= 122 && rdesc[115] == 0xff && rdesc[116] == 0x7f
+				&& rdesc[120] == 0xff && rdesc[121] == 0x7f) {
+			hid_info(hdev, "Fixing up report descriptor\n");
+			rdesc[116] = rdesc[121] = 0x2f;
+		}
+	}
+	return rdesc;
+}
+
+static const struct hid_device_id holtek_mouse_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT,
+			USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A067) },
+	{ }
+};
+MODULE_DEVICE_TABLE(hid, holtek_mouse_devices);
+
+static struct hid_driver holtek_mouse_driver = {
+	.name = "holtek_mouse",
+	.id_table = holtek_mouse_devices,
+	.report_fixup = holtek_mouse_report_fixup,
+};
+
+static int __init holtek_mouse_init(void)
+{
+	return hid_register_driver(&holtek_mouse_driver);
+}
+
+static void __exit holtek_mouse_exit(void)
+{
+	hid_unregister_driver(&holtek_mouse_driver);
+}
+
+module_exit(holtek_mouse_exit);
+module_init(holtek_mouse_init);
+MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 160a309..00f7ba9 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -435,6 +435,7 @@
 
 #define USB_VENDOR_ID_HOLTEK_ALT		0x04d9
 #define USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD	0xa055
+#define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A067	0xa067
 
 #define USB_VENDOR_ID_IMATION		0x0718
 #define USB_DEVICE_ID_DISC_STAKKA	0xd000
-- 
1.7.10.4

