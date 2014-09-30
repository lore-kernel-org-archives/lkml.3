Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803AbaI3RTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:19:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbaI3RSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:18:51 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Andrew de los Reyes <andrew-vger@gizmolabs.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH 11/13] HID: logitech-hidpp: Add Wireless Touchpad T650 support
Date: Tue, 30 Sep 2014 13:18:33 -0400
Message-Id: <1412097515-17241-12-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1412097515-17241-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1412097515-17241-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the bits are now in place to add the support of the
Touchpad T650.
The creation/population of the input device is delayed until
the device is ready.

The T650 uses the special HID++ reporting protocol, so activate
this on connect.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-logitech-hidpp.c | 105 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 103 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 9561a1f..f9a4ec0 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -471,6 +471,9 @@ out_err:
 #define HIDPP_PAGE_TOUCHPAD_RAW_XY			0x6100
 
 #define CMD_TOUCHPAD_GET_RAW_INFO			0x01
+#define CMD_TOUCHPAD_SET_RAW_REPORT_STATE		0x21
+
+#define EVENT_TOUCHPAD_RAW_XY				0x00
 
 #define TOUCHPAD_RAW_XY_ORIGIN_LOWER_LEFT		0x01
 #define TOUCHPAD_RAW_XY_ORIGIN_UPPER_LEFT		0x03
@@ -530,6 +533,59 @@ static int hidpp_touchpad_get_raw_info(struct hidpp_device *hidpp,
 	return ret;
 }
 
+static int hidpp_touchpad_set_raw_report_state(struct hidpp_device *hidpp_dev,
+		u8 feature_index, bool send_raw_reports,
+		bool sensor_enhanced_settings)
+{
+	struct hidpp_report response;
+
+	/*
+	 * Params:
+	 *   bit 0 - enable raw
+	 *   bit 1 - 16bit Z, no area
+	 *   bit 2 - enhanced sensitivity
+	 *   bit 3 - width, height (4 bits each) instead of area
+	 *   bit 4 - send raw + gestures (degrades smoothness)
+	 *   remaining bits - reserved
+	 */
+	u8 params = send_raw_reports | (sensor_enhanced_settings << 2);
+
+	return hidpp_send_fap_command_sync(hidpp_dev, feature_index,
+		CMD_TOUCHPAD_SET_RAW_REPORT_STATE, &params, 1, &response);
+}
+
+static void hidpp_touchpad_touch_event(u8 *data,
+	struct hidpp_touchpad_raw_xy_finger *finger)
+{
+	u8 x_m = data[0] << 2;
+	u8 y_m = data[2] << 2;
+
+	finger->x = x_m << 6 | data[1];
+	finger->y = y_m << 6 | data[3];
+
+	finger->contact_type = data[0] >> 6;
+	finger->contact_status = data[2] >> 6;
+
+	finger->z = data[4];
+	finger->area = data[5];
+	finger->finger_id = data[6] >> 4;
+}
+
+static void hidpp_touchpad_raw_xy_event(struct hidpp_device *hidpp_dev,
+		u8 *data, struct hidpp_touchpad_raw_xy *raw_xy)
+{
+	memset(raw_xy, 0, sizeof(struct hidpp_touchpad_raw_xy));
+	raw_xy->end_of_frame = data[8] & 0x01;
+	raw_xy->spurious_flag = (data[8] >> 1) & 0x01;
+	raw_xy->finger_count = data[15] & 0x0f;
+	raw_xy->button = (data[8] >> 2) & 0x01;
+
+	if (raw_xy->finger_count) {
+		hidpp_touchpad_touch_event(&data[2], &raw_xy->fingers[0]);
+		hidpp_touchpad_touch_event(&data[9], &raw_xy->fingers[1]);
+	}
+}
+
 /* ************************************************************************** */
 /*                                                                            */
 /* Device Support                                                             */
@@ -672,11 +728,28 @@ static int wtp_raw_event(struct hid_device *hdev, u8 *data, int size)
 {
 	struct hidpp_device *hidpp = hid_get_drvdata(hdev);
 	struct wtp_data *wd = hidpp->private_data;
+	struct hidpp_report *report = (struct hidpp_report *)data;
+	struct hidpp_touchpad_raw_xy raw;
 
-	if (!wd || !wd->input || (data[0] != 0x02) || size < 21)
+	if (!wd || !wd->input)
 		return 1;
 
-	return wtp_mouse_raw_xy_event(hidpp, &data[7]);
+	switch (data[0]) {
+	case 0x02:
+		if (size < 21)
+			return 1;
+		return wtp_mouse_raw_xy_event(hidpp, &data[7]);
+	case REPORT_ID_HIDPP_LONG:
+		if ((report->fap.feature_index != wd->mt_feature_index) ||
+		    (report->fap.funcindex_clientid != EVENT_TOUCHPAD_RAW_XY))
+			return 1;
+		hidpp_touchpad_raw_xy_event(hidpp, data + 4, &raw);
+
+		wtp_send_raw_xy_event(hidpp, &raw);
+		return 0;
+	}
+
+	return 0;
 }
 
 static int wtp_get_config(struct hidpp_device *hidpp)
@@ -721,6 +794,27 @@ static int wtp_allocate(struct hid_device *hdev, const struct hid_device_id *id)
 	return 0;
 };
 
+static void wtp_connect(struct hid_device *hdev, bool connected)
+{
+	struct hidpp_device *hidpp = hid_get_drvdata(hdev);
+	struct wtp_data *wd = hidpp->private_data;
+	int ret;
+
+	if (!connected)
+		return;
+
+	if (!wd->x_size) {
+		ret = wtp_get_config(hidpp);
+		if (ret) {
+			hid_err(hdev, "Can not get wtp config: %d\n", ret);
+			return;
+		}
+	}
+
+	hidpp_touchpad_set_raw_report_state(hidpp, wd->mt_feature_index,
+			true, true);
+}
+
 /* -------------------------------------------------------------------------- */
 /* Generic HID++ devices                                                      */
 /* -------------------------------------------------------------------------- */
@@ -897,6 +991,9 @@ static void hidpp_connect_event(struct hidpp_device *hidpp)
 	char *name, *devm_name;
 	u8 name_length;
 
+	if (hidpp->quirks & HIDPP_QUIRK_CLASS_WTP)
+		wtp_connect(hdev, connected);
+
 	if (!connected || hidpp->delayed_input)
 		return;
 
@@ -1033,6 +1130,10 @@ static void hidpp_remove(struct hid_device *hdev)
 }
 
 static const struct hid_device_id hidpp_devices[] = {
+	{ /* wireless touchpad T650 */
+	  HID_DEVICE(BUS_USB, HID_GROUP_LOGITECH_DJ_DEVICE,
+		USB_VENDOR_ID_LOGITECH, 0x4101),
+	  .driver_data = HIDPP_QUIRK_CLASS_WTP | HIDPP_QUIRK_DELAYED_INIT },
 	{ /* wireless touchpad T651 */
 	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH,
 		USB_DEVICE_ID_LOGITECH_T651),
-- 
2.1.0

