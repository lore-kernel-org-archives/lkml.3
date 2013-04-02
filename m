Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933195Ab3DBSt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:49:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:53580 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933109Ab3DBStx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:49:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,394,1363158000"; 
   d="scan'208";a="311319347"
From: Huzefa Kankroliwala <huzefa.nomanx.kankroliwala@intel.com>
To: jkosina@suse.cz
Cc: benjamin.tissoires@gmail.com, mika.westerberg@intel.com,
        linux-kernel@vger.kernel.org,
        Huzefa Kankroliwala <huzefa.nomanx.kankroliwala@intel.com>
Subject: [PATCH] i2c-hid: fix length for set/get report in i2c hid
Date: Tue,  2 Apr 2013 03:52:47 -0700
Message-Id: <1364899967-18118-1-git-send-email-huzefa.nomanx.kankroliwala@intel.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the current i2c hid driver set/get report does not work
as expected, for e.g sensor hub properties like power state,
frequency etc is not set properly on the device as a result
we do not get events.
The problem is that i2c hid driver in function i2c_hid_request
sets length equal to default buffer size for which the sensor
hub does not respond on get/set commands. Use report length
and calculate it based on report size and id.

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Huzefa Kankroliwala <huzefa.nomanx.kankroliwala@intel.com>
---
 drivers/hid/i2c-hid/i2c-hid.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
index 935f387..c8cd0c0 100644
--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -567,18 +567,18 @@ static void i2c_hid_request(struct hid_device *hid, struct hid_report *rep,
 		int reqtype)
 {
 	struct i2c_client *client = hid->driver_data;
-	struct i2c_hid *ihid = i2c_get_clientdata(client);
 	char *buf;
 	int ret;
+	int len = i2c_hid_get_report_length(rep) - 2;
 
-	buf = kzalloc(ihid->bufsize, GFP_KERNEL);
+	buf = kzalloc(len, GFP_KERNEL);
 	if (!buf)
 		return;
 
 	switch (reqtype) {
 	case HID_REQ_GET_REPORT:
-		ret = i2c_hid_get_raw_report(hid, rep->id, buf, ihid->bufsize,
-					     rep->type);
+		ret = i2c_hid_get_raw_report(hid, rep->id, buf, len,
+							rep->type);
 		if (ret < 0)
 			dev_err(&client->dev, "%s: unable to get report: %d\n",
 				__func__, ret);
@@ -587,7 +587,7 @@ static void i2c_hid_request(struct hid_device *hid, struct hid_report *rep,
 		break;
 	case HID_REQ_SET_REPORT:
 		hid_output_report(rep, buf);
-		i2c_hid_output_raw_report(hid, buf, ihid->bufsize, rep->type);
+		i2c_hid_output_raw_report(hid, buf, len, rep->type);
 		break;
 	}
 
-- 
1.7.4.1

