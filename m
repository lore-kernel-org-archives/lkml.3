Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447Ab3GBWne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 18:43:34 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:16211 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755582Ab3GBWn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 18:43:28 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsALAJpW01Fbti7d/2dsb2JhbABagwnAbwQBgQcXdIJRLwYdJlwCFjeHfAEDE6sBhyYKGScNWId6jHyBHDCBHYN0A4tsiXaBaIwghSWDEzo
From: Peter De Wachter <pdewacht@gmail.com>
To: linux-input@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        Peter De Wachter <pdewacht@gmail.com>
Subject: [PATCH] hid: add driver for IBM/Lenovo ScrollPoint mice
Date: Wed,  3 Jul 2013 00:42:31 +0200
Message-Id: <1372804951-7135-1-git-send-email-pdewacht@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IBM Scrollpoint have a trackpoint-like gizmo instead of a scroll wheel,
which allows for two-dimensional scrolling. This driver provides an
input mapping to make that work.

The scrollpoint is also much more sensitive than a typical mouse wheel.
X can use this to provide smooth scrolling, but the kernel doesn't seem
to have a way to communicate this fact. As a result this mouse simply
scrolls way too fast. For now I've created an xorg patch to provide a
manual setting (fdo #48118).

Signed-off-by: Peter De Wachter <pdewacht@gmail.com>
---
 drivers/hid/Kconfig           |  8 ++++++
 drivers/hid/Makefile          |  1 +
 drivers/hid/hid-core.c        |  7 +++++
 drivers/hid/hid-ids.h         |  7 +++++
 drivers/hid/hid-scrollpoint.c | 67 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 90 insertions(+)
 create mode 100644 drivers/hid/hid-scrollpoint.c

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index fb52f3f..fdc49ca 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -593,6 +593,14 @@ config HID_SAMSUNG
 	---help---
 	Support for Samsung InfraRed remote control or keyboards.
 
+config HID_SCROLLPOINT
+	tristate "IBM/Lenovo ScrollPoint mice"
+	depends on HID
+	---help---
+	Support for IBM/Lenovo ScrollPoint mice.
+	Say Y here if you have a ScrollPoint mouse and want horizontal
+	scrolling to work.
+
 config HID_SONY
 	tristate "Sony PS3 controller"
 	depends on USB_HID
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index 2065694..4a4c279 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -99,6 +99,7 @@ obj-$(CONFIG_HID_ROCCAT)	+= hid-roccat.o hid-roccat-common.o \
 	hid-roccat-lua.o hid-roccat-pyra.o hid-roccat-savu.o
 obj-$(CONFIG_HID_SAITEK)	+= hid-saitek.o
 obj-$(CONFIG_HID_SAMSUNG)	+= hid-samsung.o
+obj-$(CONFIG_HID_SCROLLPOINT)	+= hid-scrollpoint.o
 obj-$(CONFIG_HID_SMARTJOYPLUS)	+= hid-sjoy.o
 obj-$(CONFIG_HID_SONY)		+= hid-sony.o
 obj-$(CONFIG_HID_SPEEDLINK)	+= hid-speedlink.o
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 264f550..003f419 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1584,6 +1584,13 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GYRATION, USB_DEVICE_ID_GYRATION_REMOTE_3) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK, USB_DEVICE_ID_HOLTEK_ON_LINE_GRIP) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD) },
+#if IS_ENABLED(CONFIG_HID_SCROLLPOINT)
+	{ HID_USB_DEVICE(USB_VENDOR_ID_IBM, USB_DEVICE_ID_IBM_SCROLLPOINT_III) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_IBM, USB_DEVICE_ID_IBM_SCROLLPOINT_PRO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_IBM, USB_DEVICE_ID_IBM_SCROLLPOINT_OPTICAL) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_IBM, USB_DEVICE_ID_IBM_SCROLLPOINT_800DPI_OPTICAL) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_IBM, USB_DEVICE_ID_IBM_SCROLLPOINT_800DPI_OPTICAL_PRO) },
+#endif
 	{ HID_USB_DEVICE(USB_VENDOR_ID_JESS2, USB_DEVICE_ID_JESS2_COLOR_RUMBLE_PAD) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ION, USB_DEVICE_ID_ICADE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KENSINGTON, USB_DEVICE_ID_KS_SLIMBLADE) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 38535c9..f813fab 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -441,6 +441,13 @@
 #define USB_VENDOR_ID_HOLTEK_ALT		0x04d9
 #define USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD	0xa055
 
+#define USB_VENDOR_ID_IBM					0x04b3
+#define USB_DEVICE_ID_IBM_SCROLLPOINT_III			0x3100
+#define USB_DEVICE_ID_IBM_SCROLLPOINT_PRO			0x3103
+#define USB_DEVICE_ID_IBM_SCROLLPOINT_OPTICAL			0x3105
+#define USB_DEVICE_ID_IBM_SCROLLPOINT_800DPI_OPTICAL		0x3108
+#define USB_DEVICE_ID_IBM_SCROLLPOINT_800DPI_OPTICAL_PRO	0x3109
+
 #define USB_VENDOR_ID_IMATION		0x0718
 #define USB_DEVICE_ID_DISC_STAKKA	0xd000
 
diff --git a/drivers/hid/hid-scrollpoint.c b/drivers/hid/hid-scrollpoint.c
new file mode 100644
index 0000000..48e7696
--- /dev/null
+++ b/drivers/hid/hid-scrollpoint.c
@@ -0,0 +1,67 @@
+/*
+ * HID driver for IBM/Lenovo ScrollPoint mice
+ *
+ * Copyright (c) 2012 Peter De Wachter <pdewacht@gmail.com>
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <linux/device.h>
+#include <linux/hid.h>
+#include <linux/module.h>
+
+#include "hid-ids.h"
+
+static int scrollpoint_input_mapping(struct hid_device *hdev,
+		struct hid_input *hi, struct hid_field *field,
+		struct hid_usage *usage, unsigned long **bit, int *max)
+{
+	if (usage->hid == HID_GD_Z) {
+		hid_map_usage(hi, usage, bit, max, EV_REL, REL_HWHEEL);
+		return 1;
+	}
+	return 0;
+}
+
+static const struct hid_device_id scrollpoint_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_IBM,
+		USB_DEVICE_ID_IBM_SCROLLPOINT_III) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_IBM,
+		USB_DEVICE_ID_IBM_SCROLLPOINT_PRO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_IBM,
+		USB_DEVICE_ID_IBM_SCROLLPOINT_OPTICAL) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_IBM,
+		USB_DEVICE_ID_IBM_SCROLLPOINT_800DPI_OPTICAL) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_IBM,
+		USB_DEVICE_ID_IBM_SCROLLPOINT_800DPI_OPTICAL_PRO) },
+	{ }
+};
+MODULE_DEVICE_TABLE(hid, scrollpoint_devices);
+
+static struct hid_driver scrollpoint_driver = {
+	.name = "scrollpoint",
+	.id_table = scrollpoint_devices,
+	.input_mapping = scrollpoint_input_mapping
+};
+
+static int __init scrollpoint_init(void)
+{
+	return hid_register_driver(&scrollpoint_driver);
+}
+
+static void __exit scrollpoint_exit(void)
+{
+	hid_unregister_driver(&scrollpoint_driver);
+}
+
+module_init(scrollpoint_init);
+module_exit(scrollpoint_exit);
+
+MODULE_AUTHOR("Peter De Wachter");
+MODULE_DESCRIPTION("IBM/Lenovo ScrollPoint mouse driver");
+MODULE_LICENSE("GPL");
-- 
1.8.3.2

