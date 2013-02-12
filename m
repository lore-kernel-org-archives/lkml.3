Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761352Ab3BLPRx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 10:17:53 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:42034 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761312Ab3BLPRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 10:17:51 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] HID: i2c-hid: implement request() callback
Date: Tue, 12 Feb 2013 16:16:49 +0100
Message-Id: <1360682209-31615-1-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows HID drivers to also get/set reports through hid_hw_request().

Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---

Hi guys,

this one also goes on top of the cleanup of usbhid from hid drivers.
The purpose is to make hid-sensor-hub independent from USB and usable
with I2C.

Cheers,
Benjamin

 drivers/hid/i2c-hid/i2c-hid.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
index ec79302..935f387 100644
--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -563,6 +563,37 @@ static int i2c_hid_output_raw_report(struct hid_device *hid, __u8 *buf,
 	return ret;
 }
 
+static void i2c_hid_request(struct hid_device *hid, struct hid_report *rep,
+		int reqtype)
+{
+	struct i2c_client *client = hid->driver_data;
+	struct i2c_hid *ihid = i2c_get_clientdata(client);
+	char *buf;
+	int ret;
+
+	buf = kzalloc(ihid->bufsize, GFP_KERNEL);
+	if (!buf)
+		return;
+
+	switch (reqtype) {
+	case HID_REQ_GET_REPORT:
+		ret = i2c_hid_get_raw_report(hid, rep->id, buf, ihid->bufsize,
+					     rep->type);
+		if (ret < 0)
+			dev_err(&client->dev, "%s: unable to get report: %d\n",
+				__func__, ret);
+		else
+			hid_input_report(hid, rep->type, buf, ret, 0);
+		break;
+	case HID_REQ_SET_REPORT:
+		hid_output_report(rep, buf);
+		i2c_hid_output_raw_report(hid, buf, ihid->bufsize, rep->type);
+		break;
+	}
+
+	kfree(buf);
+}
+
 static int i2c_hid_parse(struct hid_device *hid)
 {
 	struct i2c_client *client = hid->driver_data;
@@ -742,6 +773,7 @@ static struct hid_ll_driver i2c_hid_ll_driver = {
 	.open = i2c_hid_open,
 	.close = i2c_hid_close,
 	.power = i2c_hid_power,
+	.request = i2c_hid_request,
 	.hidinput_input_event = i2c_hid_hidinput_input_event,
 };
 
-- 
1.8.1.2

