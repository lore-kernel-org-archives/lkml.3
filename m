Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab3FQXPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:15:30 -0400
Received: from us-mx2.synaptics.com ([12.239.216.76]:54412 "EHLO
	us-mx2.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab3FQXP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:15:28 -0400
X-PGP-Universal: processed;
	by securemail.synaptics.com on Mon, 17 Jun 2013 16:15:27 -0700
From: Andrew Duggan <aduggan@synaptics.com>
To: <jkosina@suse.cz>, <benjamin.tissoires@redhat.com>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Andrew Duggan <aduggan@synaptics.com>
Subject: [PATCH v2] HID: i2c-hid: support sending HID output reports using the output register
Date: Mon, 17 Jun 2013 16:15:06 -0700
Message-ID: <1371510906-16859-1-git-send-email-aduggan@synaptics.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current i2c hid driver does not support sending HID output reports using
the output register for devices which support receiving reports through this
method. This patch determines which method to use to send output reports based
 on the value of wMaxOutputLength in the device's HID descriptor.

Signed-off-by: Andrew Duggan <aduggan@synaptics.com>
---
This is the second version of the patch which includes Benjamin's suggestions. The comment
now follows the multi line guidelines and in the i2c_hid_set_report function, hidcmd is now
a pointer.
 drivers/hid/i2c-hid/i2c-hid.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
index 2b1799a..879b0ed 100644
--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -108,6 +108,7 @@ static const struct i2c_hid_cmd hid_reset_cmd =		{ I2C_HID_CMD(0x01),
 static const struct i2c_hid_cmd hid_get_report_cmd =	{ I2C_HID_CMD(0x02) };
 static const struct i2c_hid_cmd hid_set_report_cmd =	{ I2C_HID_CMD(0x03) };
 static const struct i2c_hid_cmd hid_set_power_cmd =	{ I2C_HID_CMD(0x08) };
+static const struct i2c_hid_cmd hid_no_cmd =		{ .length = 0 };
 
 /*
  * These definitions are not used here, but are defined by the spec.
@@ -259,8 +260,11 @@ static int i2c_hid_set_report(struct i2c_client *client, u8 reportType,
 {
 	struct i2c_hid *ihid = i2c_get_clientdata(client);
 	u8 *args = ihid->argsbuf;
+	const struct i2c_hid_cmd * hidcmd = &hid_set_report_cmd;
 	int ret;
 	u16 dataRegister = le16_to_cpu(ihid->hdesc.wDataRegister);
+	u16 outputRegister = le16_to_cpu(ihid->hdesc.wOutputRegister);
+	u16 maxOutputLength = le16_to_cpu(ihid->hdesc.wMaxOutputLength);
 
 	/* hidraw already checked that data_len < HID_MAX_BUFFER_SIZE */
 	u16 size =	2			/* size */ +
@@ -278,8 +282,18 @@ static int i2c_hid_set_report(struct i2c_client *client, u8 reportType,
 		reportID = 0x0F;
 	}
 
-	args[index++] = dataRegister & 0xFF;
-	args[index++] = dataRegister >> 8;
+	/*
+	 * use the data register for feature reports or if the device does not
+	 * support the output register
+	 */
+	if (reportType == 0x03 || maxOutputLength == 0) {
+		args[index++] = dataRegister & 0xFF;
+		args[index++] = dataRegister >> 8;
+	} else {
+		args[index++] = outputRegister & 0xFF;
+		args[index++] = outputRegister >> 8;
+		hidcmd = &hid_no_cmd;
+	}
 
 	args[index++] = size & 0xFF;
 	args[index++] = size >> 8;
@@ -289,7 +303,7 @@ static int i2c_hid_set_report(struct i2c_client *client, u8 reportType,
 
 	memcpy(&args[index], buf, data_len);
 
-	ret = __i2c_hid_command(client, &hid_set_report_cmd, reportID,
+	ret = __i2c_hid_command(client, hidcmd, reportID,
 		reportType, args, args_len, NULL, 0);
 	if (ret) {
 		dev_err(&client->dev, "failed to set a report to device.\n");
-- 
1.7.10.4

