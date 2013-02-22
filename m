Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477Ab3BVSMF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:12:05 -0500
Received: from [89.21.227.133] ([89.21.227.133]:61778 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759074Ab3BVSIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:08:36 -0500
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 22/40] Input: atmel_mxt_ts - Output status from T48 Noise Supression
Date: Fri, 22 Feb 2013 17:58:09 +0000
Message-Id: <1361555907-19840-23-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 238c11c..94e54bd 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -75,6 +75,7 @@
 #define MXT_SPT_DIGITIZER_T43		43
 #define MXT_SPT_MESSAGECOUNT_T44	44
 #define MXT_SPT_CTECONFIG_T46		46
+#define MXT_SPT_NOISESUPPRESSION_T48	48
 
 /* MXT_GEN_MESSAGE_T5 object */
 #define MXT_RPTID_NOMSG		0xff
@@ -265,6 +266,7 @@ struct mxt_data {
 	u8 T9_reportid_min;
 	u8 T9_reportid_max;
 	u16 T44_address;
+	u8 T48_reportid;
 };
 
 /* I2C slave address pairs */
@@ -671,6 +673,26 @@ static void mxt_proc_t9_message(struct mxt_data *data, u8 *message)
 	data->update_input = true;
 }
 
+static int mxt_proc_t48_messages(struct mxt_data *data, u8 *msg)
+{
+	struct device *dev = &data->client->dev;
+	u8 status, state;
+
+	status = msg[1];
+	state  = msg[4];
+
+	dev_dbg(dev, "T48 state %d status %02X %s%s%s%s%s\n",
+			state,
+			status,
+			(status & 0x01) ? "FREQCHG " : "",
+			(status & 0x02) ? "APXCHG " : "",
+			(status & 0x04) ? "ALGOERR " : "",
+			(status & 0x10) ? "STATCHG " : "",
+			(status & 0x20) ? "NLVLCHG " : "");
+
+	return 0;
+}
+
 static int mxt_proc_message(struct mxt_data *data, u8 *message)
 {
 	u8 report_id = message[0];
@@ -686,6 +708,9 @@ static int mxt_proc_message(struct mxt_data *data, u8 *message)
 	    && report_id <= data->T9_reportid_max) {
 		mxt_proc_t9_message(data, message);
 		handled = true;
+	} else if (report_id == data->T48_reportid) {
+		mxt_proc_t48_messages(data, message);
+		handled = true;
 	}
 
 	if (!handled || data->debug_enabled)
@@ -1343,6 +1368,9 @@ static int mxt_get_object_table(struct mxt_data *data)
 		case MXT_SPT_MESSAGECOUNT_T44:
 			data->T44_address = object->start_address;
 			break;
+		case MXT_SPT_NOISESUPPRESSION_T48:
+			data->T48_reportid = min_id;
+			break;
 		}
 
 		end_address = object->start_address
-- 
1.7.10.4

