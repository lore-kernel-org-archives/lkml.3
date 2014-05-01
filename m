Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbaEAWF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 18:05:29 -0400
Received: from us-mx2.synaptics.com ([192.147.44.131]:53421 "EHLO
	us-mx2.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaEAWF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 18:05:27 -0400
X-Greylist: delayed 595 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 May 2014 18:05:27 EDT
X-PGP-Universal: processed;
	by securemail.synaptics.com on Thu, 01 May 2014 14:55:38 -0700
From: Andrew Duggan <aduggan@synaptics.com>
To: <benjamin.tissoires@redhat.com>, <cheiny@synaptics.com>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Andrew Duggan <aduggan@synaptics.com>
Subject: [PATCH] HID: rmi: check for the existence of some optional queries before reading query 12
Date: Thu, 1 May 2014 14:49:17 -0700
Message-ID: <1398980957-10385-1-git-send-email-aduggan@synaptics.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.2.20.38]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rmi4 spec defines some optional query registers in F11 which appear before
query 12. This patch checks for the existence of some of the lesser used queries to
 compute the location of query12 and all subsequent query registers.

Signed-off-by: Andrew Duggan <aduggan@synaptics.com>
---
 drivers/hid/hid-rmi.c | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
index 90ae5eb..912e008 100644
--- a/drivers/hid/hid-rmi.c
+++ b/drivers/hid/hid-rmi.c
@@ -546,9 +546,12 @@ static int rmi_populate_f11(struct hid_device *hdev)
 	struct rmi_data *data = hid_get_drvdata(hdev);
 	u8 buf[20];
 	int ret;
+	bool has_query9;
+	bool has_query11;
 	bool has_query12;
 	bool has_physical_props;
 	unsigned x_size, y_size;
+	u16 query12_offset;
 
 	if (!data->f11.query_base_addr) {
 		hid_err(hdev, "No 2D sensor found, giving up.\n");
@@ -561,6 +564,8 @@ static int rmi_populate_f11(struct hid_device *hdev)
 		hid_err(hdev, "can not get query 0: %d.\n", ret);
 		return ret;
 	}
+	has_query9 = !!(buf[0] & BIT(3));
+	has_query11 = !!(buf[0] & BIT(4));
 	has_query12 = !!(buf[0] & BIT(5));
 
 	/* query 1 to get the max number of fingers */
@@ -582,11 +587,30 @@ static int rmi_populate_f11(struct hid_device *hdev)
 	}
 
 	/*
-	 * query 12 to know if the physical properties are reported
-	 * (query 12 is at offset 10 for HID devices)
+	 * At least 8 queries are guaranteed to be present in F11
+	 * +1 for query12.
 	 */
+	query12_offset = 9;
+
+	if (has_query9)
+		++query12_offset;
+
+	/* query 8 to find out if query 10 exists */
+	ret = rmi_read(hdev, data->f11.query_base_addr + 8, buf);
+	if (ret) {
+		hid_err(hdev, "can not read gesture information: %d.\n", ret);
+		return ret;
+	}
+	if (!!(buf[0] & BIT(2)))
+		++query12_offset;
+
+	if (has_query11)
+		++query12_offset;
+
+	/* query 12 to know if the physical properties are reported */
 	if (has_query12) {
-		ret = rmi_read(hdev, data->f11.query_base_addr + 10, buf);
+		ret = rmi_read(hdev, data->f11.query_base_addr
+				+ query12_offset, buf);
 		if (ret) {
 			hid_err(hdev, "can not get query 12: %d.\n", ret);
 			return ret;
@@ -595,7 +619,8 @@ static int rmi_populate_f11(struct hid_device *hdev)
 
 		if (has_physical_props) {
 			ret = rmi_read_block(hdev,
-					data->f11.query_base_addr + 11, buf, 4);
+					data->f11.query_base_addr
+						+ query12_offset + 1, buf, 4);
 			if (ret) {
 				hid_err(hdev, "can not read query 15-18: %d.\n",
 					ret);
-- 
1.9.1

