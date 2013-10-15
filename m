Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084Ab3JOI2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 04:28:42 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:2266 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233Ab3JOI2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 04:28:39 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 15 Oct 2013 01:28:39 -0700
From: Bibek Basu <bbasu@nvidia.com>
To: <benjamin.tissoires@gmail.com>, <jkosina@suse.cz>
CC: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Bibek Basu <bbasu@nvidia.com>
Subject: [PATCH] HID: i2c-hid: Stop querying for init reports
Date: Tue, 15 Oct 2013 13:58:29 +0530
Message-ID: <1381825709-5098-1-git-send-email-bbasu@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to specifications, HID over I2C devices
are not bound to respond to query for INPUT
REPORTS. Thus dropping the call during init
as many devices does not respond causing error
messages during boot.

Signed-off-by: Bibek Basu <bbasu@nvidia.com>
---
 drivers/hid/i2c-hid/i2c-hid.c | 59 -------------------------------------------
 1 file changed, 59 deletions(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
index fd7ce37..58a4f12 100644
--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -409,62 +409,6 @@ static int i2c_hid_get_report_length(struct hid_report *report)
 		report->device->report_enum[report->type].numbered + 2;
 }
 
-static void i2c_hid_init_report(struct hid_report *report, u8 *buffer,
-	size_t bufsize)
-{
-	struct hid_device *hid = report->device;
-	struct i2c_client *client = hid->driver_data;
-	struct i2c_hid *ihid = i2c_get_clientdata(client);
-	unsigned int size, ret_size;
-
-	size = i2c_hid_get_report_length(report);
-	if (i2c_hid_get_report(client,
-			report->type == HID_FEATURE_REPORT ? 0x03 : 0x01,
-			report->id, buffer, size))
-		return;
-
-	i2c_hid_dbg(ihid, "report (len=%d): %*ph\n", size, size, ihid->inbuf);
-
-	ret_size = buffer[0] | (buffer[1] << 8);
-
-	if (ret_size != size) {
-		dev_err(&client->dev, "error in %s size:%d / ret_size:%d\n",
-			__func__, size, ret_size);
-		return;
-	}
-
-	/* hid->driver_lock is held as we are in probe function,
-	 * we just need to setup the input fields, so using
-	 * hid_report_raw_event is safe. */
-	hid_report_raw_event(hid, report->type, buffer + 2, size - 2, 1);
-}
-
-/*
- * Initialize all reports
- */
-static void i2c_hid_init_reports(struct hid_device *hid)
-{
-	struct hid_report *report;
-	struct i2c_client *client = hid->driver_data;
-	struct i2c_hid *ihid = i2c_get_clientdata(client);
-	u8 *inbuf = kzalloc(ihid->bufsize, GFP_KERNEL);
-
-	if (!inbuf) {
-		dev_err(&client->dev, "can not retrieve initial reports\n");
-		return;
-	}
-
-	list_for_each_entry(report,
-		&hid->report_enum[HID_INPUT_REPORT].report_list, list)
-		i2c_hid_init_report(report, inbuf, ihid->bufsize);
-
-	list_for_each_entry(report,
-		&hid->report_enum[HID_FEATURE_REPORT].report_list, list)
-		i2c_hid_init_report(report, inbuf, ihid->bufsize);
-
-	kfree(inbuf);
-}
-
 /*
  * Traverse the supplied list of reports and find the longest
  */
@@ -683,9 +627,6 @@ static int i2c_hid_start(struct hid_device *hid)
 			return ret;
 	}
 
-	if (!(hid->quirks & HID_QUIRK_NO_INIT_REPORTS))
-		i2c_hid_init_reports(hid);
-
 	return 0;
 }
 
-- 
1.8.1.5

