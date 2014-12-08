Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbaLHXDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 18:03:32 -0500
Received: from us-mx2.synaptics.com ([192.147.44.131]:13375 "EHLO
	us-mx1.synaptics.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751103AbaLHXDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 18:03:30 -0500
X-PGP-Universal: processed;
	by securemail.synaptics.com on Mon, 08 Dec 2014 15:27:33 -0800
From: Andrew Duggan <aduggan@synaptics.com>
To: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Andrew Duggan <aduggan@synaptics.com>, Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Amordea Whiteoak <amordea@gmail.com>
Subject: [PATCH] HID: rmi: Check for additional ACM registers appended to F11 data report
Date: Mon, 8 Dec 2014 15:01:59 -0800
Message-ID: <1418079720-11766-1-git-send-email-aduggan@synaptics.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.4.10.98]
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a touchpad reports the F11 data40 register then this indicates that the touchpad reports
additional ACM (Accidental Contact Mitigation) data after the F11 data in the HID attention
report. These additional bytes shift the position of the F30 button data causing the driver
to incorrectly report button state when this functionality is present. This patch accounts
for the additional data in the report.

Fixes:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1398533

Signed-off-by: Andrew Duggan <aduggan@synaptics.com>
---
 drivers/hid/hid-rmi.c | 61 +++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 52 insertions(+), 9 deletions(-)

diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
index 1f131df..5065583 100644
--- a/drivers/hid/hid-rmi.c
+++ b/drivers/hid/hid-rmi.c
@@ -592,11 +592,15 @@ static int rmi_populate_f11(struct hid_device *hdev)
 	bool has_query10 = false;
 	bool has_query11;
 	bool has_query12;
+	bool has_query27;
+	bool has_query28;
+	bool has_query36 = false;
 	bool has_physical_props;
 	bool has_gestures;
 	bool has_rel;
+	bool has_data40 = false;
 	unsigned x_size, y_size;
-	u16 query12_offset;
+	u16 query_offset;
 
 	if (!data->f11.query_base_addr) {
 		hid_err(hdev, "No 2D sensor found, giving up.\n");
@@ -612,6 +616,8 @@ static int rmi_populate_f11(struct hid_device *hdev)
 	has_query9 = !!(buf[0] & BIT(3));
 	has_query11 = !!(buf[0] & BIT(4));
 	has_query12 = !!(buf[0] & BIT(5));
+	has_query27 = !!(buf[0] & BIT(6));
+	has_query28 = !!(buf[0] & BIT(7));
 
 	/* query 1 to get the max number of fingers */
 	ret = rmi_read(hdev, data->f11.query_base_addr + 1, buf);
@@ -650,27 +656,27 @@ static int rmi_populate_f11(struct hid_device *hdev)
 	 * +1 for query 5 which is present since absolute events are
 	 * reported and +1 for query 12.
 	 */
-	query12_offset = 6;
+	query_offset = 6;
 
 	if (has_rel)
-		++query12_offset; /* query 6 is present */
+		++query_offset; /* query 6 is present */
 
 	if (has_gestures)
-		query12_offset += 2; /* query 7 and 8 are present */
+		query_offset += 2; /* query 7 and 8 are present */
 
 	if (has_query9)
-		++query12_offset;
+		++query_offset;
 
 	if (has_query10)
-		++query12_offset;
+		++query_offset;
 
 	if (has_query11)
-		++query12_offset;
+		++query_offset;
 
 	/* query 12 to know if the physical properties are reported */
 	if (has_query12) {
 		ret = rmi_read(hdev, data->f11.query_base_addr
-				+ query12_offset, buf);
+				+ query_offset, buf);
 		if (ret) {
 			hid_err(hdev, "can not get query 12: %d.\n", ret);
 			return ret;
@@ -678,9 +684,10 @@ static int rmi_populate_f11(struct hid_device *hdev)
 		has_physical_props = !!(buf[0] & BIT(5));
 
 		if (has_physical_props) {
+			query_offset += 1;
 			ret = rmi_read_block(hdev,
 					data->f11.query_base_addr
-						+ query12_offset + 1, buf, 4);
+						+ query_offset, buf, 4);
 			if (ret) {
 				hid_err(hdev, "can not read query 15-18: %d.\n",
 					ret);
@@ -695,9 +702,45 @@ static int rmi_populate_f11(struct hid_device *hdev)
 
 			hid_info(hdev, "%s: size in mm: %d x %d\n",
 				 __func__, data->x_size_mm, data->y_size_mm);
+
+			/*
+			 * query 15 - 18 contain the size of the sensor
+			 * and query 19 - 26 contain bezel dimensions
+			 */
+			query_offset += 12;
+		}
+	}
+
+	if (has_query27)
+		++query_offset;
+
+	if (has_query28) {
+		ret = rmi_read(hdev, data->f11.query_base_addr
+				+ query_offset, buf);
+		if (ret) {
+			hid_err(hdev, "can not get query 28: %d.\n", ret);
+			return ret;
+		}
+
+		has_query36 = !!(buf[0] & BIT(6));
+	}
+
+	if (has_query36) {
+		query_offset += 2;
+		ret = rmi_read(hdev, data->f11.query_base_addr
+				+ query_offset, buf);
+		if (ret) {
+			hid_err(hdev, "can not get query 36: %d.\n", ret);
+			return ret;
 		}
+
+		has_data40 = !!(buf[0] & BIT(5));
 	}
 
+
+	if (has_data40)
+		data->f11.report_size += data->max_fingers * 2;
+
 	/*
 	 * retrieve the ctrl registers
 	 * the ctrl register has a size of 20 but a fw bug split it into 16 + 4,
-- 
2.1.0

