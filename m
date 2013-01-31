Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab3AaQub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 11:50:31 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:47655 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab3AaQu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 11:50:29 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Andrew Duggan <aduggan@synaptics.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] HID: i2c-hid: fix i2c_hid_output_raw_report
Date: Thu, 31 Jan 2013 17:50:02 +0100
Message-Id: <1359651002-16562-1-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i2c_hid_output_raw_report is used by hidraw to forward set_report requests.
The current implementation of i2c_hid_set_report needs to take the
report_id as an argument. The report_id is stored in the first byte
of the buffer in argument of i2c_hid_output_raw_report.

Not removing the report_id from the given buffer adds this byte 2 times
in the command, leading to a non working command.

Reported-by: Andrew Duggan <aduggan@synaptics.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/i2c-hid/i2c-hid.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
index 9e46e42..2b57e60 100644
--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -543,13 +543,24 @@ static int i2c_hid_output_raw_report(struct hid_device *hid, __u8 *buf,
 {
 	struct i2c_client *client = hid->driver_data;
 	int report_id = buf[0];
+	int ret;
 
 	if (report_type == HID_INPUT_REPORT)
 		return -EINVAL;
 
-	return i2c_hid_set_report(client,
+	if (report_id) {
+		buf++;
+		count--;
+	}
+
+	ret = i2c_hid_set_report(client,
 				report_type == HID_FEATURE_REPORT ? 0x03 : 0x02,
 				report_id, buf, count);
+
+	if (report_id && ret >= 0)
+		ret++; /* add report_id to the number of transfered bytes */
+
+	return ret;
 }
 
 static int i2c_hid_parse(struct hid_device *hid)
-- 
1.8.1

