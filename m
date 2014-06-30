Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbaF3V2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:28:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754964AbaF3V05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:26:57 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxwacom-devel@lists.sourceforge.net
Subject: [PATCH 12/15] Input - wacom: use in-kernel HID parser
Date: Mon, 30 Jun 2014 17:26:23 -0400
Message-Id: <1404163586-29582-13-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1404163586-29582-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1404163586-29582-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HID already parses the report descriptor, so use it instead of implementing
our own.
The special case for Bamboo PT 3rd gen is also removed and handled in the
same way Intuos 5 is treated, by hardcoding it in the driver.
Last, the unit_exponent stored into the hid field already is signed, so
there is no need to handle a two's complement anymore.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/input/tablet/wacom_sys.c | 344 +++++++++++++--------------------------
 drivers/input/tablet/wacom_wac.h |   4 +-
 2 files changed, 112 insertions(+), 236 deletions(-)

diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index 065c6d5..eab299c 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -15,13 +15,6 @@
 #include "wacom.h"
 #include <linux/hid.h>
 
-#define HID_HDESC_USAGE_UNDEFINED	0x00
-#define HID_HDESC_USAGE_PAGE		0x05
-#define HID_HDESC_USAGE			0x09
-#define HID_HDESC_COLLECTION		0xa1
-#define HID_HDESC_COLLECTION_LOGICAL	0x02
-#define HID_HDESC_COLLECTION_END	0xc0
-
 #define WAC_MSG_RETRIES		5
 
 #define WAC_CMD_LED_CONTROL	0x20
@@ -96,19 +89,15 @@ static void wacom_close(struct input_dev *dev)
  * This function is little more than hidinput_calc_abs_res stripped down.
  */
 static int wacom_calc_hid_res(int logical_extents, int physical_extents,
-                              unsigned char unit, unsigned char exponent)
+			       unsigned unit, int exponent)
 {
-	int prev, unit_exponent;
+	int prev;
+	int unit_exponent = exponent;
 
 	/* Check if the extents are sane */
 	if (logical_extents <= 0 || physical_extents <= 0)
 		return 0;
 
-	/* Get signed value of nybble-sized twos-compliment exponent */
-	unit_exponent = exponent;
-	if (unit_exponent > 7)
-		unit_exponent -= 16;
-
 	/* Convert physical_extents to millimeters */
 	if (unit == 0x11) {		/* If centimeters */
 		unit_exponent += 1;
@@ -141,42 +130,18 @@ static int wacom_calc_hid_res(int logical_extents, int physical_extents,
 	return logical_extents / physical_extents;
 }
 
-static int wacom_parse_logical_collection(unsigned char *report,
-					  struct wacom_features *features)
-{
-	int length = 0;
-
-	if (features->type == BAMBOO_PT) {
-
-		/* Logical collection is only used by 3rd gen Bamboo Touch */
-		features->device_type = BTN_TOOL_FINGER;
-
-		features->x_max = features->y_max =
-			get_unaligned_le16(&report[10]);
-
-		length = 11;
-	}
-	return length;
-}
-
-static void wacom_retrieve_report_data(struct hid_device *hdev,
-				       struct wacom_features *features)
+static void wacom_feature_mapping(struct hid_device *hdev,
+		struct hid_field *field, struct hid_usage *usage)
 {
-	int result = 0;
-	unsigned char *rep_data;
-
-	rep_data = kmalloc(2, GFP_KERNEL);
-	if (rep_data) {
-
-		rep_data[0] = 12;
-		result = wacom_get_report(hdev, HID_FEATURE_REPORT,
-					  rep_data[0], rep_data, 2,
-					  WAC_MSG_RETRIES);
-
-		if (result >= 0 && rep_data[1] > 2)
-			features->touch_max = rep_data[1];
+	struct wacom *wacom = hid_get_drvdata(hdev);
+	struct wacom_features *features = &wacom->wacom_wac.features;
 
-		kfree(rep_data);
+	switch (usage->hid) {
+	case HID_DG_CONTACTMAX:
+		/* leave touch_max as is if predefined */
+		if (!features->touch_max)
+			features->touch_max = field->value[0];
+		break;
 	}
 }
 
@@ -209,190 +174,96 @@ static void wacom_retrieve_report_data(struct hid_device *hdev,
  * interfaces haven't supported pressure or distance, this is enough
  * information to override invalid values in the wacom_features table.
  *
- * 3rd gen Bamboo Touch no longer define a Digitizer-Finger Pysical
- * Collection. Instead they define a Logical Collection with a single
- * Logical Maximum for both X and Y.
- *
- * Intuos5 touch interface does not contain useful data. We deal with
- * this after returning from this function.
+ * Intuos5 touch interface and 3rd gen Bamboo Touch do not contain useful
+ * data. We deal with them after returning from this function.
  */
-static int wacom_parse_hid(struct hid_device *hdev,
-			   struct wacom_features *features)
+static void wacom_usage_mapping(struct hid_device *hdev,
+		struct hid_field *field, struct hid_usage *usage)
 {
-	/* result has to be defined as int for some devices */
-	int result = 0, touch_max = 0;
-	int i = 0, page = 0, finger = 0, pen = 0;
-	unsigned char *report = hdev->rdesc;
-
-	for (i = 0; i < hdev->rsize; i++) {
-
-		switch (report[i]) {
-		case HID_HDESC_USAGE_PAGE:
-			page = report[i + 1];
-			i++;
-			break;
-
-		case HID_HDESC_USAGE:
-			switch (page << 16 | report[i + 1]) {
-			case HID_GD_X:
-				if (finger) {
-					features->device_type = BTN_TOOL_FINGER;
-					/* touch device at least supports one touch point */
-					touch_max = 1;
-
-					switch (features->type) {
-					case BAMBOO_PT:
-						features->x_phy =
-							get_unaligned_le16(&report[i + 5]);
-						features->x_max =
-							get_unaligned_le16(&report[i + 8]);
-						i += 15;
-						break;
-
-					case WACOM_24HDT:
-						features->x_max =
-							get_unaligned_le16(&report[i + 3]);
-						features->x_phy =
-							get_unaligned_le16(&report[i + 8]);
-						features->unit = report[i - 1];
-						features->unitExpo = report[i - 3];
-						i += 12;
-						break;
-
-					case MTTPC_B:
-						features->x_max =
-							get_unaligned_le16(&report[i + 3]);
-						features->x_phy =
-							get_unaligned_le16(&report[i + 6]);
-						features->unit = report[i - 5];
-						features->unitExpo = report[i - 3];
-						i += 9;
-						break;
-
-					default:
-						features->x_max =
-							get_unaligned_le16(&report[i + 3]);
-						features->x_phy =
-							get_unaligned_le16(&report[i + 6]);
-						features->unit = report[i + 9];
-						features->unitExpo = report[i + 11];
-						i += 12;
-						break;
-					}
-				} else if (pen) {
-					/* penabled only accepts exact bytes of data */
-					features->device_type = BTN_TOOL_PEN;
-					features->x_max =
-						get_unaligned_le16(&report[i + 3]);
-					i += 4;
-				}
-				break;
-
-			case HID_GD_Y:
-				if (finger) {
-					switch (features->type) {
-					case TABLETPC2FG:
-					case MTSCREEN:
-					case MTTPC:
-						features->y_max =
-							get_unaligned_le16(&report[i + 3]);
-						features->y_phy =
-							get_unaligned_le16(&report[i + 6]);
-						i += 7;
-						break;
-
-					case WACOM_24HDT:
-						features->y_max =
-							get_unaligned_le16(&report[i + 3]);
-						features->y_phy =
-							get_unaligned_le16(&report[i - 2]);
-						i += 7;
-						break;
-
-					case BAMBOO_PT:
-						features->y_phy =
-							get_unaligned_le16(&report[i + 3]);
-						features->y_max =
-							get_unaligned_le16(&report[i + 6]);
-						i += 12;
-						break;
-
-					case MTTPC_B:
-						features->y_max =
-							get_unaligned_le16(&report[i + 3]);
-						features->y_phy =
-							get_unaligned_le16(&report[i + 6]);
-						i += 9;
-						break;
-
-					default:
-						features->y_max =
-							features->x_max;
-						features->y_phy =
-							get_unaligned_le16(&report[i + 3]);
-						i += 4;
-						break;
-					}
-				} else if (pen) {
-					features->y_max =
-						get_unaligned_le16(&report[i + 3]);
-					i += 4;
-				}
-				break;
-
-			case HID_DG_FINGER:
-				finger = 1;
-				i++;
-				break;
+	struct wacom *wacom = hid_get_drvdata(hdev);
+	struct wacom_features *features = &wacom->wacom_wac.features;
+	bool finger = (field->logical == HID_DG_FINGER) ||
+		      (field->physical == HID_DG_FINGER);
+	bool pen = (field->logical == HID_DG_STYLUS) ||
+		   (field->physical == HID_DG_STYLUS);
 
-			/*
-			 * Requiring Stylus Usage will ignore boot mouse
-			 * X/Y values and some cases of invalid Digitizer X/Y
-			 * values commonly reported.
-			 */
-			case HID_DG_STYLUS:
-				pen = 1;
-				i++;
-				break;
+	/*
+	* Requiring Stylus Usage will ignore boot mouse
+	* X/Y values and some cases of invalid Digitizer X/Y
+	* values commonly reported.
+	*/
+	if (!pen && !finger)
+		return;
 
-			case HID_DG_CONTACTMAX:
-				/* leave touch_max as is if predefined */
-				if (!features->touch_max)
-					wacom_retrieve_report_data(hdev, features);
-				i++;
-				break;
+	if (finger && !features->touch_max)
+		/* touch device at least supports one touch point */
+		features->touch_max = 1;
 
-			case HID_DG_TIPPRESSURE:
-				if (pen) {
-					features->pressure_max =
-						get_unaligned_le16(&report[i + 3]);
-					i += 4;
-				}
-				break;
+	switch (usage->hid) {
+	case HID_GD_X:
+		features->x_max = field->logical_maximum;
+		if (finger) {
+			features->device_type = BTN_TOOL_FINGER;
+			features->x_phy = field->physical_maximum;
+			if (features->type != BAMBOO_PT) {
+				features->unit = field->unit;
+				features->unitExpo = field->unit_exponent;
 			}
-			break;
-
-		case HID_HDESC_COLLECTION_END:
-			/* reset UsagePage and Finger */
-			finger = page = 0;
-			break;
+		} else {
+			features->device_type = BTN_TOOL_PEN;
+		}
+		break;
+	case HID_GD_Y:
+		features->y_max = field->logical_maximum;
+		if (finger) {
+			features->y_phy = field->physical_maximum;
+			if (features->type != BAMBOO_PT) {
+				features->unit = field->unit;
+				features->unitExpo = field->unit_exponent;
+			}
+		}
+		break;
+	case HID_DG_TIPPRESSURE:
+		if (pen)
+			features->pressure_max = field->logical_maximum;
+		break;
+	}
+}
 
-		case HID_HDESC_COLLECTION:
-			i++;
-			switch (report[i]) {
-			case HID_HDESC_COLLECTION_LOGICAL:
-				i += wacom_parse_logical_collection(&report[i],
-								    features);
-				break;
+static void wacom_parse_hid(struct hid_device *hdev,
+			   struct wacom_features *features)
+{
+	struct hid_report_enum *rep_enum;
+	struct hid_report *hreport;
+	int i, j;
+
+	/* check features first */
+	rep_enum = &hdev->report_enum[HID_FEATURE_REPORT];
+	list_for_each_entry(hreport, &rep_enum->report_list, list) {
+		for (i = 0; i < hreport->maxfield; i++) {
+			/* Ignore if report count is out of bounds. */
+			if (hreport->field[i]->report_count < 1)
+				continue;
+
+			for (j = 0; j < hreport->field[i]->maxusage; j++) {
+				wacom_feature_mapping(hdev, hreport->field[i],
+						hreport->field[i]->usage + j);
 			}
-			break;
 		}
 	}
 
-	if (!features->touch_max && touch_max)
-		features->touch_max = touch_max;
-	result = 0;
-	return result;
+	/* now check the input usages */
+	rep_enum = &hdev->report_enum[HID_INPUT_REPORT];
+	list_for_each_entry(hreport, &rep_enum->report_list, list) {
+
+		if (!hreport->maxfield)
+			continue;
+
+		for (i = 0; i < hreport->maxfield; i++)
+			for (j = 0; j < hreport->field[i]->maxusage; j++)
+				wacom_usage_mapping(hdev, hreport->field[i],
+						hreport->field[i]->usage + j);
+	}
 }
 
 static int wacom_set_device_mode(struct hid_device *hdev, int report_id,
@@ -448,10 +319,9 @@ static int wacom_query_tablet_data(struct hid_device *hdev,
 	return 0;
 }
 
-static int wacom_retrieve_hid_descriptor(struct hid_device *hdev,
+static void wacom_retrieve_hid_descriptor(struct hid_device *hdev,
 					 struct wacom_features *features)
 {
-	int error = 0;
 	struct wacom *wacom = hid_get_drvdata(hdev);
 	struct usb_interface *intf = wacom->intf;
 
@@ -478,14 +348,10 @@ static int wacom_retrieve_hid_descriptor(struct hid_device *hdev,
 	}
 
 	/* only devices that support touch need to retrieve the info */
-	if (features->type < BAMBOO_PT) {
-		goto out;
-	}
-
-	error = wacom_parse_hid(hdev, features);
+	if (features->type < BAMBOO_PT)
+		return;
 
- out:
-	return error;
+	wacom_parse_hid(hdev, features);
 }
 
 struct wacom_hdev_data {
@@ -1276,9 +1142,7 @@ static int wacom_probe(struct hid_device *hdev,
 	wacom_set_default_phy(features);
 
 	/* Retrieve the physical and logical size for touch devices */
-	error = wacom_retrieve_hid_descriptor(hdev, features);
-	if (error)
-		goto fail1;
+	wacom_retrieve_hid_descriptor(hdev, features);
 
 	/*
 	 * Intuos5 has no useful data about its touch interface in its
@@ -1296,12 +1160,24 @@ static int wacom_probe(struct hid_device *hdev,
 		}
 	}
 
+	/*
+	 * Same thing for Bamboo 3rd gen.
+	 */
+	if ((features->type == BAMBOO_PT) &&
+	    (features->pktlen == WACOM_PKGLEN_BBTOUCH3) &&
+	    (features->device_type == BTN_TOOL_PEN)) {
+		features->device_type = BTN_TOOL_FINGER;
+
+		features->x_max = 4096;
+		features->y_max = 4096;
+	}
+
 	wacom_setup_device_quirks(features);
 
 	/* set unit to "100th of a mm" for devices not reported by HID */
 	if (!features->unit) {
 		features->unit = 0x11;
-		features->unitExpo = 16 - 3;
+		features->unitExpo = -3;
 	}
 	wacom_calculate_res(features);
 
diff --git a/drivers/input/tablet/wacom_wac.h b/drivers/input/tablet/wacom_wac.h
index 8821a51..2a7612a 100644
--- a/drivers/input/tablet/wacom_wac.h
+++ b/drivers/input/tablet/wacom_wac.h
@@ -127,8 +127,8 @@ struct wacom_features {
 	int device_type;
 	int x_phy;
 	int y_phy;
-	unsigned char unit;
-	unsigned char unitExpo;
+	unsigned unit;
+	int unitExpo;
 	int x_fuzz;
 	int y_fuzz;
 	int pressure_fuzz;
-- 
2.0.0

