Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab3AaPHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 10:07:23 -0500
Received: from host171.canaca.com ([67.55.55.225]:33524 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab3AaPHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 10:07:20 -0500
From: Simon Wood <simon@mungewell.org>
To: linux-input@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        simon@mungewell.org, rosegardener@freeode.co.uk
Subject: [PATCH 1/5] USB: HID: SRW-S1 Gaming Wheel Driver
Date: Thu, 31 Jan 2013 08:07:07 -0700
Message-Id: <1359644830-3274-1-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <alpine.LNX.2.00.1301291057170.23853@pobox.suse.cz>
References: <alpine.LNX.2.00.1301291057170.23853@pobox.suse.cz>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support the SRW-S1 by patching HID descriptor to read axis
as Generic Desktop X, Y and Z (rather than Usage page being
'Simulation').

Signed-off-by: Simon Wood <simon@mungewell.org>
Tested-by: John Murphy <rosegardener@freeode.co.uk>
---
 drivers/hid/Kconfig                 |    6 ++++
 drivers/hid/Makefile                |    1 +
 drivers/hid/hid-core.c              |    1 +
 drivers/hid/hid-ids.h               |    3 ++
 drivers/hid/hid-steelseries-srws1.c |   58 +++++++++++++++++++++++++++++++++++
 5 files changed, 69 insertions(+)
 create mode 100644 drivers/hid/hid-steelseries-srws1.c

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index e7d6a13..37df92f 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -596,6 +596,12 @@ config HID_SPEEDLINK
 	---help---
 	Support for Speedlink Vicious and Divine Cezanne mouse.
 
+config HID_STEELSERIES_SRWS1
+	tristate "Steelseries SRW-S1 steering wheel support"
+	depends on USB_HID
+	---help---
+	Support for Steelseries SRW-S1 steering wheel
+
 config HID_SUNPLUS
 	tristate "Sunplus wireless desktop"
 	depends on USB_HID
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index b622157..bbebe0a 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -101,6 +101,7 @@ obj-$(CONFIG_HID_SAMSUNG)	+= hid-samsung.o
 obj-$(CONFIG_HID_SMARTJOYPLUS)	+= hid-sjoy.o
 obj-$(CONFIG_HID_SONY)		+= hid-sony.o
 obj-$(CONFIG_HID_SPEEDLINK)	+= hid-speedlink.o
+obj-$(CONFIG_HID_STEELSERIES_SRWS1)    	+= hid-steelseries-srws1.o
 obj-$(CONFIG_HID_SUNPLUS)	+= hid-sunplus.o
 obj-$(CONFIG_HID_GREENASIA)	+= hid-gaff.o
 obj-$(CONFIG_HID_THRUSTMASTER)	+= hid-tmff.o
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index eb2ee11..65cda7f 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1697,6 +1697,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_NAVIGATION_CONTROLLER) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS3_CONTROLLER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_VAIO_VGX_MOUSE) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_STEELSERIES, USB_DEVICE_ID_STEELSERIES_SRWS1) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SUNPLUS, USB_DEVICE_ID_SUNPLUS_WDESKTOP) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb300) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb304) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 4dfa605..f5976f3 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -723,6 +723,9 @@
 #define USB_VENDOR_ID_STANTUM_SITRONIX		0x1403
 #define USB_DEVICE_ID_MTP_SITRONIX		0x5001
 
+#define USB_VENDOR_ID_STEELSERIES	0x1038
+#define USB_DEVICE_ID_STEELSERIES_SRWS1	0x1410
+
 #define USB_VENDOR_ID_SUN		0x0430
 #define USB_DEVICE_ID_RARITAN_KVM_DONGLE	0xcdab
 
diff --git a/drivers/hid/hid-steelseries-srws1.c b/drivers/hid/hid-steelseries-srws1.c
new file mode 100644
index 0000000..4a5386b
--- /dev/null
+++ b/drivers/hid/hid-steelseries-srws1.c
@@ -0,0 +1,58 @@
+/*
+ *  HID driver for Steelseries SRW-S1
+ *
+ *  Copyright (c) 2013 Simon Wood
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
+static __u8 *steelseries_srws1_report_fixup(struct hid_device *hdev, __u8 *rdesc,
+		unsigned int *rsize)
+{
+	if (*rsize >= 115 && rdesc[11] == 0x02 && rdesc[13] == 0xc8
+			&& rdesc[29] == 0xbb && rdesc[40] == 0xc5) {
+		hid_info(hdev, "Fixing up Steelseries SRW-S1 report descriptor\n");
+		rdesc[11] = 0x01;
+		rdesc[13] = 0x30;
+		rdesc[29] = 0x31;
+		rdesc[40] = 0x32;
+	}
+	return rdesc;
+}
+
+static const struct hid_device_id steelseries_srws1_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_STEELSERIES, USB_DEVICE_ID_STEELSERIES_SRWS1) },
+	{ }
+};
+MODULE_DEVICE_TABLE(hid, steelseries_srws1_devices);
+
+static struct hid_driver steelseries_srws1_driver = {
+	.name = "steelseries_srws1",
+	.id_table = steelseries_srws1_devices,
+	.report_fixup = steelseries_srws1_report_fixup
+};
+
+static int __init steelseries_srws1_init(void)
+{
+	return hid_register_driver(&steelseries_srws1_driver);
+}
+
+static void __exit steelseries_srws1_exit(void)
+{
+	hid_unregister_driver(&steelseries_srws1_driver);
+}
+
+module_init(steelseries_srws1_init);
+module_exit(steelseries_srws1_exit);
+MODULE_LICENSE("GPL");
-- 
1.7.10.4

