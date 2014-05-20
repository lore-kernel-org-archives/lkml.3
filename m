Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbaETSv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 14:51:57 -0400
Received: from static.59.56.47.78.clients.your-server.de ([78.47.56.59]:44841
	"EHLO www.braincalibration.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751244AbaETSvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 14:51:55 -0400
X-Greylist: delayed 1427 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 May 2014 14:51:55 EDT
Message-ID: <537B9EB0.60603@braincalibration.de>
Date: Tue, 20 May 2014 20:28:00 +0200
From: Harald Brinkmann <hbrinkmann@braincalibration.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] HID: quirk for Saitek RAT7 and MMO7 mices' mode button
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

- added RAT7 abd MMO7 VID/PIDs to hid_have_special_driver[]

Some saitek mice implement a tristate button (for switching button
mappings in the original driver) by keeping one of three (non-physical)
buttons constantly pressed.
This breaks X and probably other userspace software.
This patch implements a quirk for the R.A.T.7 and M.M.O.7, tracking
the mode and generating presses of a single button if it changes.
Also the missing release event is generated instantly.

Signed-off-by: Harald Brinkmann <hbrinkmann@braincalibration.de>
---
 drivers/hid/Kconfig      |    5 -
 drivers/hid/hid-core.c   |    4 
 drivers/hid/hid-ids.h    |    2 
 drivers/hid/hid-saitek.c |  154 +++++++++++++++++++++++++++++++++++--
 4 files changed, 157 insertions(+), 8 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 7af9d0b..00e0138 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -608,7 +608,10 @@ config HID_SAITEK
 	Support for Saitek devices that are not fully compliant with the
 	HID standard.
 
-	Currently only supports the PS1000 controller.
+	Supported devices:
+	- PS1000 Dual Analog Pad
+	- R.A.T.7 Gaming Mouse
+	- M.M.O.7 Gaming Mouse
 
 config HID_SAMSUNG
 	tristate "Samsung InfraRed remote control or keyboards"
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index da52279..d078f85 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1868,7 +1868,11 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_RYOS_MK_PRO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ROCCAT, USB_DEVICE_ID_ROCCAT_SAVU) },
 #endif
+#if IS_ENABLED(CONFIG_HID_SAITEK)
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_PS1000) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_RAT7) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_MMO7) },
+#endif
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_IR_REMOTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_WIRELESS_KBD_MOUSE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SKYCABLE, USB_DEVICE_ID_SKYCABLE_WIRELESS_PRESENTER) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 34bb220..adb0187 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -764,6 +764,8 @@
 #define USB_VENDOR_ID_SAITEK		0x06a3
 #define USB_DEVICE_ID_SAITEK_RUMBLEPAD	0xff17
 #define USB_DEVICE_ID_SAITEK_PS1000	0x0621
+#define USB_DEVICE_ID_SAITEK_RAT7	0x0cd7
+#define USB_DEVICE_ID_SAITEK_MMO7	0x0cd0
 
 #define USB_VENDOR_ID_SAMSUNG		0x0419
 #define USB_DEVICE_ID_SAMSUNG_IR_REMOTE	0x0001
diff --git a/drivers/hid/hid-saitek.c b/drivers/hid/hid-saitek.c
index 37961c7..69cca14 100644
--- a/drivers/hid/hid-saitek.c
+++ b/drivers/hid/hid-saitek.c
@@ -1,10 +1,17 @@
 /*
- *  HID driver for Saitek devices, currently only the PS1000 (USB gamepad).
+ *  HID driver for Saitek devices.
+ *
+ *  PS1000 (USB gamepad):
  *  Fixes the HID report descriptor by removing a non-existent axis and
  *  clearing the constant bit on the input reports for buttons and d-pad.
  *  (This module is based on "hid-ortek".)
- *
  *  Copyright (c) 2012 Andreas Hübner
+ *
+ *  R.A.T.7, M.M.O.7 (USB gaming mice):
+ *  Fixes the mode button which cycles through three constantly pressed
+ *  buttons. All three press events are mapped to one button and the
+ *  missing release event is generated immediately.
+ *
  */
 
 /*
@@ -21,12 +28,57 @@
 
 #include "hid-ids.h"
 
+#define SAITEK_FIX_PS1000	0x0001
+#define SAITEK_RELEASE_MODE_RAT7	0x0002
+#define SAITEK_RELEASE_MODE_MMO7	0x0004
+
+struct saitek_sc {
+	unsigned long quirks;
+	int mode;
+};
+
+static int saitek_probe(struct hid_device *hdev,
+		const struct hid_device_id *id)
+{
+	unsigned long quirks = id->driver_data;
+	struct saitek_sc *ssc;
+	int ret;
+
+	ssc = devm_kzalloc(&hdev->dev, sizeof(*ssc), GFP_KERNEL);
+	if (ssc == NULL) {
+		hid_err(hdev, "can't alloc saitek descriptor\n");
+		return -ENOMEM;
+	}
+
+	ssc->quirks = quirks;
+	ssc->mode = -1;
+
+	hid_set_drvdata(hdev, ssc);
+
+	ret = hid_parse(hdev);
+	if (ret) {
+		hid_err(hdev, "parse failed\n");
+		return ret;
+	}
+
+	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
+	if (ret) {
+		hid_err(hdev, "hw start failed\n");
+		return ret;
+	}
+
+	return 0;
+}
+
 static __u8 *saitek_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
-	if (*rsize == 137 && rdesc[20] == 0x09 && rdesc[21] == 0x33
-			&& rdesc[94] == 0x81 && rdesc[95] == 0x03
-			&& rdesc[110] == 0x81 && rdesc[111] == 0x03) {
+	struct saitek_sc *ssc = hid_get_drvdata(hdev);
+
+	if ((ssc->quirks & SAITEK_FIX_PS1000) && *rsize == 137 &&
+			rdesc[20] == 0x09 && rdesc[21] == 0x33 &&
+			rdesc[94] == 0x81 && rdesc[95] == 0x03 &&
+			rdesc[110] == 0x81 && rdesc[111] == 0x03) {
 
 		hid_info(hdev, "Fixing up Saitek PS1000 report descriptor\n");
 
@@ -42,8 +94,93 @@ static __u8 *saitek_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 	return rdesc;
 }
 
+static int saitek_raw_event(struct hid_device *hdev,
+		struct hid_report *report, u8 *raw_data, int size)
+{
+	struct saitek_sc *ssc = hid_get_drvdata(hdev);
+
+	if (ssc->quirks & SAITEK_RELEASE_MODE_RAT7 && size == 7) {
+		/* R.A.T.7 uses bits 13, 14, 15 for the mode */
+		int mode = -1;
+		if (raw_data[1] & 0x01)
+			mode = 0;
+		else if (raw_data[1] & 0x02)
+			mode = 1;
+		else if (raw_data[1] & 0x04)
+			mode = 2;
+
+		/* clear mode bits */
+		raw_data[1] &= ~0x07;
+
+		if (mode != ssc->mode) {
+			hid_dbg(hdev, "entered mode %d\n", mode);
+			if (ssc->mode != -1) {
+				/* use bit 13 as the mode button */
+				raw_data[1] |= 0x04;
+			}
+			ssc->mode = mode;
+		}
+	} else if (ssc->quirks & SAITEK_RELEASE_MODE_MMO7 && size == 8) {
+
+		/* M.M.O.7 uses bits 8, 22, 23 for the mode */
+		int mode = -1;
+		if (raw_data[1] & 0x80)
+			mode = 0;
+		else if (raw_data[2] & 0x01)
+			mode = 1;
+		else if (raw_data[2] & 0x02)
+			mode = 2;
+
+		/* clear mode bits */
+		raw_data[1] &= ~0x80;
+		raw_data[2] &= ~0x03;
+
+		if (mode != ssc->mode) {
+			hid_dbg(hdev, "entered mode %d\n", mode);
+			if (ssc->mode != -1) {
+				/* use bit 8 as the mode button, bits 22
+				 * and 23 do not represent buttons
+				 * according to the HID report descriptor
+				 */
+				raw_data[1] |= 0x80;
+			}
+			ssc->mode = mode;
+		}
+	}
+
+	return 0;
+}
+
+static int saitek_event(struct hid_device *hdev, struct hid_field *field,
+		struct hid_usage *usage, __s32 value)
+{
+	struct saitek_sc *ssc = hid_get_drvdata(hdev);
+	struct input_dev *input = field->hidinput->input;
+
+	if (usage->type == EV_KEY && value &&
+			(((ssc->quirks & SAITEK_RELEASE_MODE_RAT7) &&
+			  usage->code - BTN_MOUSE == 10) ||
+			((ssc->quirks & SAITEK_RELEASE_MODE_MMO7) &&
+			 usage->code - BTN_MOUSE == 15))) {
+
+		input_report_key(input, usage->code, 1);
+
+		/* report missing release event */
+		input_report_key(input, usage->code, 0);
+
+		return 1;
+	}
+
+	return 0;
+}
+
 static const struct hid_device_id saitek_devices[] = {
-	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_PS1000)},
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_PS1000),
+		.driver_data = SAITEK_FIX_PS1000 },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_RAT7),
+		.driver_data = SAITEK_RELEASE_MODE_RAT7 },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_MMO7),
+		.driver_data = SAITEK_RELEASE_MODE_MMO7 },
 	{ }
 };
 
@@ -52,7 +189,10 @@ MODULE_DEVICE_TABLE(hid, saitek_devices);
 static struct hid_driver saitek_driver = {
 	.name = "saitek",
 	.id_table = saitek_devices,
-	.report_fixup = saitek_report_fixup
+	.probe = saitek_probe,
+	.report_fixup = saitek_report_fixup,
+	.raw_event = saitek_raw_event,
+	.event = saitek_event,
 };
 module_hid_driver(saitek_driver);
 
