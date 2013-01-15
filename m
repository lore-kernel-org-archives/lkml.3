Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150Ab3AORzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 12:55:52 -0500
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:35862 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751396Ab3AORzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 12:55:51 -0500
From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
To: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: =?UTF-8?q?=5BPATCH=5D=20Support=20Jess/Saitek=20Color=20Rumble=20Pad?=
Date: Tue, 15 Jan 2013 18:57:47 +0100
Message-Id: <1358272668-5124-1-git-send-email-kernel@mkarcher.dialup.fu-berlin.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <alpine.LNX.2.00.1301031042530.27348@pobox.suse.cz>
References: <alpine.LNX.2.00.1301031042530.27348@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="------------1.7.10.4"
In-Reply-To: <alpine.LNX.2.00.1301031042530.27348@pobox.suse.cz>
X-Originating-IP: 92.204.106.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------1.7.10.4
Content-Type: text/plain; charset=UTF-8; format=fixed
Content-Transfer-Encoding: 8bit


Add support for another gamepad to the hid-pl driver.
The "color rumble pad P580" marketed using the "Saitek" brand in
Germany, and using a USB Vendor ID attributed to "Jess" seems to be
electronically identical to the 4-field variant of the "Green Asia"
gamepad.

The pad has been tested to support rumble strengths up to 255, not
just 127.

Signed-off-by: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
---
 drivers/hid/hid-core.c |    1 +
 drivers/hid/hid-ids.h  |    3 +++
 drivers/hid/hid-pl.c   |   13 +++++++++++--
 3 files changed, 15 insertions(+), 2 deletions(-)


--------------1.7.10.4
Content-Type: text/x-patch; name="0001-Support-Jess-Saitek-Color-Rumble-Pad.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline; filename="0001-Support-Jess-Saitek-Color-Rumble-Pad.patch"

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index eb2ee11..aad2627 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1599,6 +1599,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GYRATION, USB_DEVICE_ID_GYRATION_REMOTE_3) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK, USB_DEVICE_ID_HOLTEK_ON_LINE_GRIP) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_JESS2, USB_DEVICE_ID_JESS2_COLOR_RUMBLE_PAD) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ION, USB_DEVICE_ID_ICADE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KENSINGTON, USB_DEVICE_ID_KS_SLIMBLADE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KEYTOUCH, USB_DEVICE_ID_KEYTOUCH_IEC) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 4dfa605..3a49334 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -442,6 +442,9 @@
 #define USB_VENDOR_ID_JESS		0x0c45
 #define USB_DEVICE_ID_JESS_YUREX	0x1010
 
+#define USB_VENDOR_ID_JESS2		0x0f30
+#define USB_DEVICE_ID_JESS2_COLOR_RUMBLE_PAD 0x0111
+
 #define USB_VENDOR_ID_KBGEAR		0x084e
 #define USB_DEVICE_ID_KBGEAR_JAMSTUDIO	0x1001
 
diff --git a/drivers/hid/hid-pl.c b/drivers/hid/hid-pl.c
index 47ed74c..1768414 100644
--- a/drivers/hid/hid-pl.c
+++ b/drivers/hid/hid-pl.c
@@ -14,6 +14,8 @@
  *  0e8f:0003 "GASIA USB Gamepad"
  *   - another version of the König gamepad
  *
+ *  0f30:0111 "Saitek Color Rumble Pad"
+ *
  *  Copyright (c) 2007, 2009 Anssi Hannula <anssi.hannula@gmail.com>
  */
 
@@ -51,6 +53,7 @@
 
 struct plff_device {
 	struct hid_report *report;
+	s32 maxval;
 	s32 *strong;
 	s32 *weak;
 };
@@ -66,8 +69,8 @@ static int hid_plff_play(struct input_dev *dev, void *data,
 	right = effect->u.rumble.weak_magnitude;
 	debug("called with 0x%04x 0x%04x", left, right);
 
-	left = left * 0x7f / 0xffff;
-	right = right * 0x7f / 0xffff;
+	left = left * plff->maxval / 0xffff;
+	right = right * plff->maxval / 0xffff;
 
 	*plff->strong = left;
 	*plff->weak = right;
@@ -87,6 +90,7 @@ static int plff_init(struct hid_device *hid)
 	struct list_head *report_ptr = report_list;
 	struct input_dev *dev;
 	int error;
+	s32 maxval;
 	s32 *strong;
 	s32 *weak;
 
@@ -123,6 +127,7 @@ static int plff_init(struct hid_device *hid)
 			return -ENODEV;
 		}
 
+		maxval = 0x7f;
 		if (report->field[0]->report_count >= 4) {
 			report->field[0]->value[0] = 0x00;
 			report->field[0]->value[1] = 0x00;
@@ -135,6 +140,8 @@ static int plff_init(struct hid_device *hid)
 			report->field[1]->value[0] = 0x00;
 			strong = &report->field[2]->value[0];
 			weak = &report->field[3]->value[0];
+			if (hid->vendor == USB_VENDOR_ID_JESS2)
+				maxval = 0xff;
 			debug("detected 4-field device");
 		} else {
 			hid_err(hid, "not enough fields or values\n");
@@ -158,6 +165,7 @@ static int plff_init(struct hid_device *hid)
 		plff->report = report;
 		plff->strong = strong;
 		plff->weak = weak;
+		plff->maxval = maxval;
 
 		*strong = 0x00;
 		*weak = 0x00;
@@ -207,6 +215,7 @@ static const struct hid_device_id pl_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GAMERON, USB_DEVICE_ID_GAMERON_DUAL_PCS_ADAPTOR),
 		.driver_data = 1 }, /* Twin USB Joystick */
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GREENASIA, 0x0003), },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_JESS2, USB_DEVICE_ID_JESS2_COLOR_RUMBLE_PAD), },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, pl_devices);

--------------1.7.10.4--


