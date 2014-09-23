Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435AbaIWQNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:13:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932236AbaIWQIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:08:22 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>, Ping Cheng <pinglinux@gmail.com>,
        killertofu@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] HID: wacom: implement the finger part of the HID generic handling
Date: Tue, 23 Sep 2014 12:08:09 -0400
Message-Id: <1411488489-10625-6-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1411488489-10625-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1411488489-10625-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/wacom_sys.c |  39 ++++++++++++++--
 drivers/hid/wacom_wac.c | 120 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/hid/wacom_wac.h |   8 ++++
 3 files changed, 164 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
index dd288b2..8593047 100644
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -109,6 +109,7 @@ static void wacom_feature_mapping(struct hid_device *hdev,
 {
 	struct wacom *wacom = hid_get_drvdata(hdev);
 	struct wacom_features *features = &wacom->wacom_wac.features;
+	struct hid_data *hid_data = &wacom->wacom_wac.hid_data;
 	u8 *data;
 	int ret;
 
@@ -128,6 +129,16 @@ static void wacom_feature_mapping(struct hid_device *hdev,
 			kfree(data);
 		}
 		break;
+	case HID_DG_INPUTMODE:
+		/* Ignore if value index is out of bounds. */
+		if (usage->usage_index >= field->report_count) {
+			dev_err(&hdev->dev, "HID_DG_INPUTMODE out of range\n");
+			break;
+		}
+
+		hid_data->inputmode = field->report->id;
+		hid_data->inputmode_index = usage->usage_index;
+		break;
 	}
 }
 
@@ -255,6 +266,25 @@ static void wacom_parse_hid(struct hid_device *hdev,
 	}
 }
 
+static int wacom_hid_set_device_mode(struct hid_device *hdev)
+{
+	struct wacom *wacom = hid_get_drvdata(hdev);
+	struct hid_data *hid_data = &wacom->wacom_wac.hid_data;
+	struct hid_report *r;
+	struct hid_report_enum *re;
+
+	if (hid_data->inputmode < 0)
+		return 0;
+
+	re = &(hdev->report_enum[HID_FEATURE_REPORT]);
+	r = re->report_id_hash[hid_data->inputmode];
+	if (r) {
+		r->field[0]->value[hid_data->inputmode_index] = 2;
+		hid_hw_request(hdev, r, HID_REQ_SET_REPORT);
+	}
+	return 0;
+}
+
 static int wacom_set_device_mode(struct hid_device *hdev, int report_id,
 		int length, int mode)
 {
@@ -347,6 +377,9 @@ static int wacom_query_tablet_data(struct hid_device *hdev,
 	if (hdev->bus == BUS_BLUETOOTH)
 		return wacom_bt_query_tablet_data(hdev, 1, features);
 
+	if (features->type == HID_GENERIC)
+		return wacom_hid_set_device_mode(hdev);
+
 	if (features->device_type == BTN_TOOL_FINGER) {
 		if (features->type > TABLETPC) {
 			/* MT Tablet PC touch */
@@ -1451,9 +1484,6 @@ static int wacom_probe(struct hid_device *hdev,
 				 error);
 	}
 
-	/* Note that if query fails it is not a hard failure */
-	wacom_query_tablet_data(hdev, features);
-
 	if (features->type == HID_GENERIC)
 		connect_mask |= HID_CONNECT_DRIVER;
 
@@ -1464,6 +1494,9 @@ static int wacom_probe(struct hid_device *hdev,
 		goto fail_hw_start;
 	}
 
+	/* Note that if query fails it is not a hard failure */
+	wacom_query_tablet_data(hdev, features);
+
 	if (features->quirks & WACOM_QUIRK_MONITOR)
 		error = hid_hw_open(hdev);
 
diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index e77d46d..586b240 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1372,6 +1372,117 @@ static void wacom_wac_pen_report(struct hid_device *hdev,
 	}
 }
 
+static void wacom_wac_finger_usage_mapping(struct hid_device *hdev,
+		struct hid_field *field, struct hid_usage *usage)
+{
+	struct wacom *wacom = hid_get_drvdata(hdev);
+	struct wacom_wac *wacom_wac = &wacom->wacom_wac;
+	struct input_dev *input = wacom_wac->input;
+	unsigned touch_max = wacom_wac->features.touch_max;
+
+	switch (usage->hid) {
+	case HID_GD_X:
+		if (touch_max == 1)
+			wacom_map_usage(wacom, usage, field, EV_ABS, ABS_X, 4);
+		else
+			wacom_map_usage(wacom, usage, field, EV_ABS,
+					ABS_MT_POSITION_X, 4);
+		break;
+	case HID_GD_Y:
+		if (touch_max == 1)
+			wacom_map_usage(wacom, usage, field, EV_ABS, ABS_Y, 4);
+		else
+			wacom_map_usage(wacom, usage, field, EV_ABS,
+					ABS_MT_POSITION_Y, 4);
+		break;
+	case HID_DG_CONTACTID:
+		input_mt_init_slots(input, wacom_wac->features.touch_max,
+			INPUT_MT_DIRECT);
+		break;
+	case HID_DG_INRANGE:
+		break;
+	case HID_DG_INVERT:
+		break;
+	case HID_DG_TIPSWITCH:
+		wacom_map_usage(wacom, usage, field, EV_KEY, BTN_TOUCH, 0);
+		break;
+	}
+}
+
+static int wacom_wac_finger_event(struct hid_device *hdev,
+		struct hid_field *field, struct hid_usage *usage, __s32 value)
+{
+	struct wacom *wacom = hid_get_drvdata(hdev);
+	struct wacom_wac *wacom_wac = &wacom->wacom_wac;
+
+	switch (usage->hid) {
+	case HID_GD_X:
+		wacom_wac->hid_data.x = value;
+		break;
+	case HID_GD_Y:
+		wacom_wac->hid_data.y = value;
+		break;
+	case HID_DG_CONTACTID:
+		wacom_wac->hid_data.id = value;
+		break;
+	case HID_DG_TIPSWITCH:
+		wacom_wac->hid_data.tipswitch = value;
+		break;
+	}
+
+
+	return 0;
+}
+
+static void wacom_wac_finger_mt_report(struct wacom_wac *wacom_wac,
+		struct input_dev *input, bool touch)
+{
+	int slot;
+	struct hid_data *hid_data = &wacom_wac->hid_data;
+
+	slot = input_mt_get_slot_by_key(input, hid_data->id);
+
+	input_mt_slot(input, slot);
+	input_mt_report_slot_state(input, MT_TOOL_FINGER, touch);
+	if (touch) {
+		input_report_abs(input, ABS_MT_POSITION_X, hid_data->x);
+		input_report_abs(input, ABS_MT_POSITION_Y, hid_data->y);
+	}
+	input_mt_sync_frame(input);
+}
+
+static void wacom_wac_finger_single_touch_report(struct wacom_wac *wacom_wac,
+		struct input_dev *input, bool touch)
+{
+	struct hid_data *hid_data = &wacom_wac->hid_data;
+
+	if (touch) {
+		input_report_abs(input, ABS_X, hid_data->x);
+		input_report_abs(input, ABS_Y, hid_data->y);
+	}
+	input_report_key(input, BTN_TOUCH, touch);
+}
+
+static void wacom_wac_finger_report(struct hid_device *hdev,
+		struct hid_report *report)
+{
+	struct wacom *wacom = hid_get_drvdata(hdev);
+	struct wacom_wac *wacom_wac = &wacom->wacom_wac;
+	struct input_dev *input = wacom_wac->input;
+	bool touch = wacom_wac->hid_data.tipswitch &&
+		     !wacom_wac->shared->stylus_in_proximity;
+	unsigned touch_max = wacom_wac->features.touch_max;
+
+	if (touch_max > 1)
+		wacom_wac_finger_mt_report(wacom_wac, input, touch);
+	else
+		wacom_wac_finger_single_touch_report(wacom_wac, input, touch);
+	input_sync(input);
+
+	/* keep touch state for pen event */
+	wacom_wac->shared->touch_down = touch;
+}
+
 #define WACOM_PEN_FIELD(f)	(((f)->logical == HID_DG_STYLUS) || \
 				 ((f)->physical == HID_DG_STYLUS))
 #define WACOM_FINGER_FIELD(f)	(((f)->logical == HID_DG_FINGER) || \
@@ -1389,6 +1500,9 @@ void wacom_wac_usage_mapping(struct hid_device *hdev,
 
 	if (WACOM_PEN_FIELD(field))
 		return wacom_wac_pen_usage_mapping(hdev, field, usage);
+
+	if (WACOM_FINGER_FIELD(field))
+		return wacom_wac_finger_usage_mapping(hdev, field, usage);
 }
 
 int wacom_wac_event(struct hid_device *hdev, struct hid_field *field,
@@ -1402,6 +1516,9 @@ int wacom_wac_event(struct hid_device *hdev, struct hid_field *field,
 	if (WACOM_PEN_FIELD(field))
 		return wacom_wac_pen_event(hdev, field, usage, value);
 
+	if (WACOM_FINGER_FIELD(field))
+		return wacom_wac_finger_event(hdev, field, usage, value);
+
 	return 0;
 }
 
@@ -1416,6 +1533,9 @@ void wacom_wac_report(struct hid_device *hdev, struct hid_report *report)
 
 	if (WACOM_PEN_FIELD(field))
 		return wacom_wac_pen_report(hdev, report);
+
+	if (WACOM_FINGER_FIELD(field))
+		return wacom_wac_finger_report(hdev, report);
 }
 
 static int wacom_bpt_touch(struct wacom_wac *wacom)
diff --git a/drivers/hid/wacom_wac.h b/drivers/hid/wacom_wac.h
index f472eac..0f0b85e 100644
--- a/drivers/hid/wacom_wac.h
+++ b/drivers/hid/wacom_wac.h
@@ -156,9 +156,17 @@ struct wacom_shared {
 };
 
 struct hid_data {
+	__s16 inputmode;	/* InputMode HID feature, -1 if non-existent */
+	__s16 inputmode_index;	/* InputMode HID feature index in the report */
 	bool inrange_state;
 	bool invert_state;
 	bool tipswitch;
+	int x;
+	int y;
+	int pressure;
+	int width;
+	int height;
+	int id;
 };
 
 struct wacom_wac {
-- 
2.1.0

