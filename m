Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264Ab3BVSNl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:13:41 -0500
Received: from [89.21.227.133] ([89.21.227.133]:32129 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759059Ab3BVSIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:08:35 -0500
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 23/40] Input: atmel_mxt_ts - Output status from T42 Touch Suppression
Date: Fri, 22 Feb 2013 17:58:10 +0000
Message-Id: <1361555907-19840-24-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 94e54bd..b1fdc36 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -185,6 +185,9 @@ struct t9_range {
 #define MXT_RESET_VALUE		0x01
 #define MXT_BACKUP_VALUE	0x55
 
+/* Define for MXT_PROCI_TOUCHSUPPRESSION_T42 */
+#define MXT_T42_MSG_TCHSUP	(1 << 0)
+
 /* Delay times */
 #define MXT_BACKUP_TIME		25	/* msec */
 #define MXT_RESET_TIME		200	/* msec */
@@ -265,6 +268,8 @@ struct mxt_data {
 	u16 T7_address;
 	u8 T9_reportid_min;
 	u8 T9_reportid_max;
+	u8 T42_reportid_min;
+	u8 T42_reportid_max;
 	u16 T44_address;
 	u8 T48_reportid;
 };
@@ -673,6 +678,17 @@ static void mxt_proc_t9_message(struct mxt_data *data, u8 *message)
 	data->update_input = true;
 }
 
+static void mxt_proc_t42_messages(struct mxt_data *data, u8 *msg)
+{
+	struct device *dev = &data->client->dev;
+	u8 status = msg[1];
+
+	if (status & MXT_T42_MSG_TCHSUP)
+		dev_info(dev, "T42 suppress\n");
+	else
+		dev_info(dev, "T42 normal\n");
+}
+
 static int mxt_proc_t48_messages(struct mxt_data *data, u8 *msg)
 {
 	struct device *dev = &data->client->dev;
@@ -708,6 +724,10 @@ static int mxt_proc_message(struct mxt_data *data, u8 *message)
 	    && report_id <= data->T9_reportid_max) {
 		mxt_proc_t9_message(data, message);
 		handled = true;
+	} else if (report_id >= data->T42_reportid_min
+		   && report_id <= data->T42_reportid_max) {
+		mxt_proc_t42_messages(data, message);
+		handled = true;
 	} else if (report_id == data->T48_reportid) {
 		mxt_proc_t48_messages(data, message);
 		handled = true;
@@ -1365,6 +1385,10 @@ static int mxt_get_object_table(struct mxt_data *data)
 			data->num_touchids =
 				object->num_report_ids * OBP_INSTANCES(object);
 			break;
+		case MXT_PROCI_TOUCHSUPPRESSION_T42:
+			data->T42_reportid_min = min_id;
+			data->T42_reportid_max = max_id;
+			break;
 		case MXT_SPT_MESSAGECOUNT_T44:
 			data->T44_address = object->start_address;
 			break;
-- 
1.7.10.4

