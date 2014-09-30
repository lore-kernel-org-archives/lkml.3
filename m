Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbaI3RTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:19:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbaI3RSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:18:52 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Andrew de los Reyes <andrew-vger@gizmolabs.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH 12/13] HID: logitech-hidpp: add support of the first Logitech Wireless Touchpad
Date: Tue, 30 Sep 2014 13:18:34 -0400
Message-Id: <1412097515-17241-13-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1412097515-17241-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1412097515-17241-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This touchpad differs from the T650 in several ways:
- the resolution is not correctly returned by the device
- it presents physical buttons, so the button flag in the raw touch report
  is not filled.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-logitech-hidpp.c | 32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index f9a4ec0..17e27e9 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -38,6 +38,7 @@ MODULE_AUTHOR("Nestor Lopez Casado <nlopezcasad@logitech.com>");
 
 /* bits 1..20 are reserved for classes */
 #define HIDPP_QUIRK_DELAYED_INIT		BIT(21)
+#define HIDPP_QUIRK_WTP_PHYSICAL_BUTTONS	BIT(22)
 
 /*
  * There are two hidpp protocols in use, the first version hidpp10 is known
@@ -596,6 +597,8 @@ static void hidpp_touchpad_raw_xy_event(struct hidpp_device *hidpp_dev,
 /* Touchpad HID++ devices                                                     */
 /* -------------------------------------------------------------------------- */
 
+#define WTP_MANUAL_RESOLUTION				39
+
 struct wtp_data {
 	struct input_dev *input;
 	u16 x_size, y_size;
@@ -634,7 +637,10 @@ static void wtp_populate_input(struct hidpp_device *hidpp,
 
 	input_set_capability(input_dev, EV_KEY, BTN_LEFT);
 
-	__set_bit(INPUT_PROP_BUTTONPAD, input_dev->propbit);
+	if (hidpp->quirks & HIDPP_QUIRK_WTP_PHYSICAL_BUTTONS)
+		input_set_capability(input_dev, EV_KEY, BTN_RIGHT);
+	else
+		__set_bit(INPUT_PROP_BUTTONPAD, input_dev->propbit);
 
 	input_mt_init_slots(input_dev, wd->maxcontacts, INPUT_MT_POINTER |
 		INPUT_MT_DROP_UNUSED);
@@ -676,7 +682,8 @@ static void wtp_send_raw_xy_event(struct hidpp_device *hidpp,
 	for (i = 0; i < 2; i++)
 		wtp_touch_event(wd, &(raw->fingers[i]));
 
-	if (raw->end_of_frame)
+	if (raw->end_of_frame &&
+	    !(hidpp->quirks & HIDPP_QUIRK_WTP_PHYSICAL_BUTTONS))
 		input_event(wd->input, EV_KEY, BTN_LEFT, raw->button);
 
 	if (raw->end_of_frame || raw->finger_count <= 2) {
@@ -736,9 +743,17 @@ static int wtp_raw_event(struct hid_device *hdev, u8 *data, int size)
 
 	switch (data[0]) {
 	case 0x02:
-		if (size < 21)
-			return 1;
-		return wtp_mouse_raw_xy_event(hidpp, &data[7]);
+		if (hidpp->quirks & HIDPP_QUIRK_WTP_PHYSICAL_BUTTONS) {
+			input_event(wd->input, EV_KEY, BTN_LEFT,
+					!!(data[1] & 0x01));
+			input_event(wd->input, EV_KEY, BTN_RIGHT,
+					!!(data[1] & 0x02));
+			input_sync(wd->input);
+		} else {
+			if (size < 21)
+				return 1;
+			return wtp_mouse_raw_xy_event(hidpp, &data[7]);
+		}
 	case REPORT_ID_HIDPP_LONG:
 		if ((report->fap.feature_index != wd->mt_feature_index) ||
 		    (report->fap.funcindex_clientid != EVENT_TOUCHPAD_RAW_XY))
@@ -775,6 +790,8 @@ static int wtp_get_config(struct hidpp_device *hidpp)
 	wd->maxcontacts = raw_info.maxcontacts;
 	wd->flip_y = raw_info.origin == TOUCHPAD_RAW_XY_ORIGIN_LOWER_LEFT;
 	wd->resolution = raw_info.res;
+	if (!wd->resolution)
+		wd->resolution = WTP_MANUAL_RESOLUTION;
 
 	return 0;
 }
@@ -1130,6 +1147,11 @@ static void hidpp_remove(struct hid_device *hdev)
 }
 
 static const struct hid_device_id hidpp_devices[] = {
+	{ /* wireless touchpad */
+	  HID_DEVICE(BUS_USB, HID_GROUP_LOGITECH_DJ_DEVICE,
+		USB_VENDOR_ID_LOGITECH, 0x4011),
+	  .driver_data = HIDPP_QUIRK_CLASS_WTP | HIDPP_QUIRK_DELAYED_INIT |
+			 HIDPP_QUIRK_WTP_PHYSICAL_BUTTONS },
 	{ /* wireless touchpad T650 */
 	  HID_DEVICE(BUS_USB, HID_GROUP_LOGITECH_DJ_DEVICE,
 		USB_VENDOR_ID_LOGITECH, 0x4101),
-- 
2.1.0

