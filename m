Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760148Ab3B0PYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 10:24:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758160Ab3B0PYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 10:24:08 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] HID: multitouch: remove useless last_field_index field
Date: Wed, 27 Feb 2013 16:23:15 +0100
Message-Id: <1361978595-24225-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The aim of last_field_index was to detect the end of the report.
With the introduction of .report(), it is not required anymore to
detect it on the fly as we can put it in the right place during the
.report().

The resulting code path is simpler to read because the terminating
condition is not evaluated after each field.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-multitouch.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 3af9efdd..51d8938 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -97,7 +97,6 @@ struct mt_device {
 					   multitouch fields */
 	int cc_index;	/* contact count field index in the report */
 	int cc_value_index;	/* contact count value index in the field */
-	unsigned last_field_index;	/* last field index of the report */
 	unsigned last_slot_field;	/* the last field of a slot */
 	unsigned mt_report_id;	/* the report ID of the multitouch device */
 	__s8 inputmode;		/* InputMode HID feature, -1 if non-existent */
@@ -416,7 +415,6 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			}
 
 			mt_store_field(usage, td, hi);
-			td->last_field_index = field->index;
 			return 1;
 		case HID_GD_Y:
 			if (prev_usage && (prev_usage->hid == usage->hid)) {
@@ -432,7 +430,6 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			}
 
 			mt_store_field(usage, td, hi);
-			td->last_field_index = field->index;
 			return 1;
 		}
 		return 0;
@@ -447,21 +444,17 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 					ABS_MT_DISTANCE, 0, 1, 0, 0);
 			}
 			mt_store_field(usage, td, hi);
-			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_CONFIDENCE:
 			mt_store_field(usage, td, hi);
-			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_TIPSWITCH:
 			hid_map_usage(hi, usage, bit, max, EV_KEY, BTN_TOUCH);
 			input_set_capability(hi->input, EV_KEY, BTN_TOUCH);
 			mt_store_field(usage, td, hi);
-			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_CONTACTID:
 			mt_store_field(usage, td, hi);
-			td->last_field_index = field->index;
 			td->touches_by_report++;
 			td->mt_report_id = field->report->id;
 			return 1;
@@ -472,7 +465,6 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 				set_abs(hi->input, ABS_MT_TOUCH_MAJOR, field,
 					cls->sn_width);
 			mt_store_field(usage, td, hi);
-			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_HEIGHT:
 			hid_map_usage(hi, usage, bit, max,
@@ -484,7 +476,6 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 					ABS_MT_ORIENTATION, 0, 1, 0, 0);
 			}
 			mt_store_field(usage, td, hi);
-			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_TIPPRESSURE:
 			hid_map_usage(hi, usage, bit, max,
@@ -492,17 +483,14 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			set_abs(hi->input, ABS_MT_PRESSURE, field,
 				cls->sn_pressure);
 			mt_store_field(usage, td, hi);
-			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_CONTACTCOUNT:
 			td->cc_index = field->index;
 			td->cc_value_index = usage->usage_index;
-			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_CONTACTMAX:
 			/* we don't set td->last_slot_field as contactcount and
 			 * contact max are global to the report */
-			td->last_field_index = field->index;
 			return -1;
 		case HID_DG_TOUCH:
 			/* Legacy devices use TIPSWITCH and not TOUCH.
@@ -688,10 +676,6 @@ static void mt_process_mt_event(struct hid_device *hid, struct hid_field *field,
 			/* we only take into account the last report. */
 			if (usage->hid == td->last_slot_field)
 				mt_complete_slot(td, field->hidinput->input);
-
-			if (field->index == td->last_field_index
-				&& td->num_received >= td->num_expected)
-				mt_sync_frame(td, field->hidinput->input);
 		}
 
 	}
@@ -732,6 +716,9 @@ static void mt_report(struct hid_device *hid, struct hid_report *report)
 			mt_process_mt_event(hid, field, &field->usage[n],
 					field->value[n]);
 	}
+
+	if (td->num_received >= td->num_expected)
+		mt_sync_frame(td, report->field[0]->hidinput->input);
 }
 
 static void mt_set_input_mode(struct hid_device *hdev)
-- 
1.8.1.2

