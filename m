Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750AbaGQXWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 19:22:36 -0400
Received: from us-mx2.synaptics.com ([192.147.44.131]:32990 "EHLO
	us-mx2.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758071AbaGQXWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 19:22:34 -0400
X-PGP-Universal: processed;
	by securemail.synaptics.com on Thu, 17 Jul 2014 16:31:02 -0700
From: Andrew Duggan <aduggan@synaptics.com>
To: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Andrew Duggan <aduggan@synaptics.com>, Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH v2] HID: rmi: check that report ids exist in the report_id_hash before accessing their size
Date: Thu, 17 Jul 2014 16:14:44 -0700
Message-ID: <1405638885-8014-1-git-send-email-aduggan@synaptics.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.2.20.38]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible that the hid-rmi driver could get loaded onto a device which does not have the
expected report ids. This should not happen because it would indicate that the hid-rmi driver is
not compatible with that device. However, if it does happen it should return an error from probe
instead of dereferencing a null pointer.

related bug:
https://bugzilla.kernel.org/show_bug.cgi?id=80091

Signed-off-by: Andrew Duggan <aduggan@synaptics.com>
---
Added hid_err messages as suggested by Benjamin. This fixes the null pointer dereference from
bug 80091 while the next patch addresses the binding issue in hid-core.

 drivers/hid/hid-rmi.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
index 3221a95..260be7a 100644
--- a/drivers/hid/hid-rmi.c
+++ b/drivers/hid/hid-rmi.c
@@ -848,6 +848,8 @@ static int rmi_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	struct rmi_data *data = NULL;
 	int ret;
 	size_t alloc_size;
+	struct hid_report *input_report;
+	struct hid_report *output_report;
 
 	data = devm_kzalloc(&hdev->dev, sizeof(struct rmi_data), GFP_KERNEL);
 	if (!data)
@@ -866,12 +868,26 @@ static int rmi_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		return ret;
 	}
 
-	data->input_report_size = (hdev->report_enum[HID_INPUT_REPORT]
-		.report_id_hash[RMI_ATTN_REPORT_ID]->size >> 3)
-		+ 1 /* report id */;
-	data->output_report_size = (hdev->report_enum[HID_OUTPUT_REPORT]
-		.report_id_hash[RMI_WRITE_REPORT_ID]->size >> 3)
-		+ 1 /* report id */;
+	input_report = hdev->report_enum[HID_INPUT_REPORT]
+			.report_id_hash[RMI_ATTN_REPORT_ID];
+	if (!input_report) {
+		hid_err(hdev, "device does not have expected input report\n");
+		ret = -ENODEV;
+		return ret;
+	}
+
+	data->input_report_size = (input_report->size >> 3) + 1 /* report id */;
+
+	output_report = hdev->report_enum[HID_OUTPUT_REPORT]
+			.report_id_hash[RMI_WRITE_REPORT_ID];
+	if (!output_report) {
+		hid_err(hdev, "device does not have expected output report\n");
+		ret = -ENODEV;
+		return ret;
+	}
+
+	data->output_report_size = (output_report->size >> 3)
+					+ 1 /* report id */;
 
 	alloc_size = data->output_report_size + data->input_report_size;
 
-- 
1.9.1

