Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbaLSWr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 17:47:27 -0500
Received: from us-mx2.synaptics.com ([192.147.44.131]:64859 "EHLO
	us-mx1.synaptics.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752182AbaLSWrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 17:47:25 -0500
X-PGP-Universal: processed;
	by securemail.synaptics.com on Fri, 19 Dec 2014 15:12:42 -0800
From: Andrew Duggan <aduggan@synaptics.com>
To: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Andrew Duggan <aduggan@synaptics.com>, Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 1/3] HID: rmi: Support non rmi devices by passing events to hid-input
Date: Fri, 19 Dec 2014 14:45:41 -0800
Message-ID: <1419029143-20484-1-git-send-email-aduggan@synaptics.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.4.10.98]
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allowing hid-rmi to bind to non rmi devices allows us to support composite USB
devices which contain several HID devices one of which is a HID touchpad.
Since all of the devices have the same VID and PID we can add the device
to the hid_have_special_driver list and have hid-rmi handle all of the devices.
Then hid-rmi's probe can look for the rmi specific HID report IDs and decide if
it should handle the device as a rmi device or simply report that the events
needs additional processing.

Signed-off-by: Andrew Duggan <aduggan@synaptics.com>
---
This patch series is my second attempt at getting the hid-rmi driver working on
the Razer Blade 14 based on Benjamin's comments. I decided to break it up into
three separate patches. This one allows hid-rmi to bind to all of the devices.
Instead of adding a quirk I just look at the report IDs to see if it should
do rmi or not.

 drivers/hid/hid-rmi.c | 93 +++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 76 insertions(+), 17 deletions(-)

diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
index b51200f..018f80f 100644
--- a/drivers/hid/hid-rmi.c
+++ b/drivers/hid/hid-rmi.c
@@ -33,6 +33,9 @@
 #define RMI_READ_DATA_PENDING		BIT(1)
 #define RMI_STARTED			BIT(2)
 
+/* device flags */
+#define RMI_DEVICE			BIT(0)
+
 enum rmi_mode_type {
 	RMI_MODE_OFF			= 0,
 	RMI_MODE_ATTN_REPORTS		= 1,
@@ -118,6 +121,8 @@ struct rmi_data {
 
 	struct work_struct reset_work;
 	struct hid_device *hdev;
+
+	unsigned long device_flags;
 };
 
 #define RMI_PAGE(addr) (((addr) >> 8) & 0xff)
@@ -452,9 +457,23 @@ static int rmi_raw_event(struct hid_device *hdev,
 		return rmi_read_data_event(hdev, data, size);
 	case RMI_ATTN_REPORT_ID:
 		return rmi_input_event(hdev, data, size);
-	case RMI_MOUSE_REPORT_ID:
+	default:
+		return 1;
+	}
+
+	return 0;
+}
+
+static int rmi_event(struct hid_device *hdev, struct hid_field *field,
+			struct hid_usage *usage, __s32 value)
+{
+	struct rmi_data *data = hid_get_drvdata(hdev);
+
+	if ((data->device_flags & RMI_DEVICE) &&
+	    (field->application == HID_GD_POINTER ||
+	    field->application == HID_GD_MOUSE)) {
 		rmi_schedule_reset(hdev);
-		break;
+		return 1;
 	}
 
 	return 0;
@@ -856,6 +875,9 @@ static void rmi_input_configured(struct hid_device *hdev, struct hid_input *hi)
 	if (ret)
 		return;
 
+	if (!(data->device_flags & RMI_DEVICE))
+		return;
+
 	/* Allow incoming hid reports */
 	hid_device_io_start(hdev);
 
@@ -914,8 +936,33 @@ static int rmi_input_mapping(struct hid_device *hdev,
 		struct hid_input *hi, struct hid_field *field,
 		struct hid_usage *usage, unsigned long **bit, int *max)
 {
-	/* we want to make HID ignore the advertised HID collection */
-	return -1;
+	struct rmi_data *data = hid_get_drvdata(hdev);
+
+	/*
+	 * we want to make HID ignore the advertised HID collection
+	 * for RMI deivces
+	 */
+	if (data->device_flags & RMI_DEVICE)
+		return -1;
+
+	return 0;
+}
+
+static int rmi_check_valid_report_id(struct hid_device *hdev, unsigned type,
+		unsigned id, struct hid_report **report)
+{
+	int i;
+
+	*report = hdev->report_enum[type].report_id_hash[id];
+	if (*report) {
+		for (i = 0; i < (*report)->maxfield; i++) {
+			unsigned app = (*report)->field[i]->application;
+			if ((app & HID_USAGE_PAGE) >= HID_UP_MSVENDOR)
+				return 1;
+		}
+	}
+
+	return 0;
 }
 
 static int rmi_probe(struct hid_device *hdev, const struct hid_device_id *id)
@@ -925,6 +972,7 @@ static int rmi_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	size_t alloc_size;
 	struct hid_report *input_report;
 	struct hid_report *output_report;
+	struct hid_report *feature_report;
 
 	data = devm_kzalloc(&hdev->dev, sizeof(struct rmi_data), GFP_KERNEL);
 	if (!data)
@@ -943,27 +991,35 @@ static int rmi_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		return ret;
 	}
 
-	input_report = hdev->report_enum[HID_INPUT_REPORT]
-			.report_id_hash[RMI_ATTN_REPORT_ID];
-	if (!input_report) {
-		hid_err(hdev, "device does not have expected input report\n");
-		ret = -ENODEV;
-		return ret;
+	/*
+	 * Check for the RMI specific report ids. If they are misisng
+	 * simply return and let the events be processed by hid-input
+	 */
+	if (!rmi_check_valid_report_id(hdev, HID_FEATURE_REPORT,
+	    RMI_SET_RMI_MODE_REPORT_ID, &feature_report)) {
+		hid_dbg(hdev, "device does not have set mode feature report\n");
+		goto start;
+	}
+
+	if (!rmi_check_valid_report_id(hdev, HID_INPUT_REPORT,
+	    RMI_ATTN_REPORT_ID, &input_report)) {
+		hid_dbg(hdev, "device does not have attention input report\n");
+		goto start;
 	}
 
 	data->input_report_size = (input_report->size >> 3) + 1 /* report id */;
 
-	output_report = hdev->report_enum[HID_OUTPUT_REPORT]
-			.report_id_hash[RMI_WRITE_REPORT_ID];
-	if (!output_report) {
-		hid_err(hdev, "device does not have expected output report\n");
-		ret = -ENODEV;
-		return ret;
+	if (!rmi_check_valid_report_id(hdev, HID_OUTPUT_REPORT,
+	    RMI_WRITE_REPORT_ID, &output_report)) {
+		hid_dbg(hdev,
+			"device does not have rmi write output report\n");
+		goto start;
 	}
 
 	data->output_report_size = (output_report->size >> 3)
 					+ 1 /* report id */;
 
+	data->device_flags |= RMI_DEVICE;
 	alloc_size = data->output_report_size + data->input_report_size;
 
 	data->writeReport = devm_kzalloc(&hdev->dev, alloc_size, GFP_KERNEL);
@@ -978,13 +1034,15 @@ static int rmi_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	mutex_init(&data->page_mutex);
 
+start:
 	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
 	if (ret) {
 		hid_err(hdev, "hw start failed\n");
 		return ret;
 	}
 
-	if (!test_bit(RMI_STARTED, &data->flags))
+	if ((data->device_flags & RMI_DEVICE) &&
+	    !test_bit(RMI_STARTED, &data->flags))
 		/*
 		 * The device maybe in the bootloader if rmi_input_configured
 		 * failed to find F11 in the PDT. Print an error, but don't
@@ -1017,6 +1075,7 @@ static struct hid_driver rmi_driver = {
 	.id_table		= rmi_id,
 	.probe			= rmi_probe,
 	.remove			= rmi_remove,
+	.event			= rmi_event,
 	.raw_event		= rmi_raw_event,
 	.input_mapping		= rmi_input_mapping,
 	.input_configured	= rmi_input_configured,
-- 
2.1.0

