Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354Ab3BVSQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:16:13 -0500
Received: from [89.21.227.133] ([89.21.227.133]:40598 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759020Ab3BVSId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:08:33 -0500
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 20/40] Input: atmel_mxt_ts - Split interrupt handler into separate functions
Date: Fri, 22 Feb 2013 17:58:07 +0000
Message-Id: <1361555907-19840-21-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is in preparation for support of the T44 message count object.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |  112 ++++++++++++++++--------------
 1 file changed, 58 insertions(+), 54 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index bdf7555..51901b7 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -251,8 +251,10 @@ struct mxt_data {
 	u8 bootloader_addr;
 	struct t7_config t7_cfg;
 	u8 *msg_buf;
+	bool update_input;
 
 	/* Cached parameters from object table */
+	u16 T5_address;
 	u8 T5_msg_size;
 	u8 T6_reportid;
 	u16 T6_address;
@@ -592,27 +594,13 @@ static void mxt_proc_t6_messages(struct mxt_data *data, u8 *msg)
 				(status & MXT_T6_STATUS_COMSERR) ? " COMSERR" : "");
 }
 
-static int mxt_read_message(struct mxt_data *data, u8 *message)
-{
-	struct mxt_object *object;
-	u16 reg;
-
-	object = mxt_get_object(data, MXT_GEN_MESSAGE_T5);
-	if (!object)
-		return -EINVAL;
-
-	reg = object->start_address;
-	return __mxt_read_reg(data->client, reg,
-			data->T5_msg_size, message);
-}
-
 static void mxt_input_sync(struct input_dev *input_dev)
 {
 	input_mt_report_pointer_emulation(input_dev, false);
 	input_sync(input_dev);
 }
 
-static void mxt_input_touchevent(struct mxt_data *data, u8 *message)
+static void mxt_proc_t9_message(struct mxt_data *data, u8 *message)
 {
 	struct device *dev = &data->client->dev;
 	struct input_dev *input_dev = data->input_dev;
@@ -675,46 +663,62 @@ static void mxt_input_touchevent(struct mxt_data *data, u8 *message)
 		/* Touch no longer active, close out slot */
 		input_mt_report_slot_state(input_dev, MT_TOOL_FINGER, 0);
 	}
+
+	data->update_input = true;
 }
 
-static bool mxt_is_T9_message(struct mxt_data *data, u8 *msg)
+static int mxt_proc_message(struct mxt_data *data, u8 *message)
 {
-	u8 id = msg[0];
-	return (id >= data->T9_reportid_min && id <= data->T9_reportid_max);
+	u8 report_id = message[0];
+	bool handled = false;
+
+	if (report_id == MXT_RPTID_NOMSG)
+		return 0;
+
+	if (report_id == data->T6_reportid) {
+		mxt_proc_t6_messages(data, message);
+		handled = true;
+	} else if (report_id >= data->T9_reportid_min
+	    && report_id <= data->T9_reportid_max) {
+		mxt_proc_t9_message(data, message);
+		handled = true;
+	}
+
+	if (!handled || data->debug_enabled)
+		mxt_dump_message(data, message);
+
+	return 1;
 }
 
-static irqreturn_t mxt_process_messages_until_invalid(struct mxt_data *data)
+static int mxt_read_and_process_message(struct mxt_data *data)
 {
-	u8 *message = &data->msg_buf[0];
 	struct device *dev = &data->client->dev;
-	u8 reportid;
-	bool update_input = false;
-	bool handled;
+	int ret;
 
-	do {
-		if (mxt_read_message(data, message)) {
-			dev_err(dev, "Failed to read message\n");
-			return IRQ_NONE;
-		}
+	ret = __mxt_read_reg(data->client, data->T5_address,
+				data->T5_msg_size, data->msg_buf);
+	if (ret) {
+		dev_err(dev, "Error %d reading message\n", ret);
+		return ret;
+	}
 
-		reportid = message[0];
-		handled = false;
+	return mxt_proc_message(data, data->msg_buf);
+}
 
-		if (reportid == data->T6_reportid) {
-			mxt_proc_t6_messages(data, message);
-			handled = true;
-		} else if (mxt_is_T9_message(data, message)) {
-			mxt_input_touchevent(data, message);
-			update_input = true;
-			handled = true;
-		}
+static irqreturn_t mxt_process_messages_until_invalid(struct mxt_data *data)
+{
+	int ret;
 
-		if (!handled || data->debug_enabled)
-			mxt_dump_message(data, message);
-	} while (reportid != MXT_RPTID_NOMSG);
+	do {
+		ret = mxt_read_and_process_message(data);
+		if (ret < 0)
+			return IRQ_NONE;
+	} while (ret > 0);
 
-	if (update_input)
+	if (data->update_input) {
 		mxt_input_sync(data->input_dev);
+		data->update_input = false;
+	}
 
 	return IRQ_HANDLED;
 }
@@ -1129,21 +1133,19 @@ static int mxt_make_highchg(struct mxt_data *data)
 {
 	struct device *dev = &data->client->dev;
 	int count = 10;
-	int error;
+	int ret;
 
-	/* Read dummy message to make high CHG pin */
+	/* Read messages until we force an invalid */
 	do {
-		error = mxt_read_message(data, data->msg_buf);
-		if (error)
-			return error;
-	} while (data->msg_buf[0] != MXT_RPTID_NOMSG && --count);
-
-	if (!count) {
-		dev_err(dev, "CHG pin isn't cleared\n");
-		return -EBUSY;
-	}
+		ret = mxt_read_and_process_message(data);
+		if (ret == 0)
+			return 0;
+		else if (ret < 0)
+			return ret;
+	} while (--count);
 
-	return 0;
+	dev_err(dev, "CHG pin isn't cleared\n");
+	return -EBUSY;
 }
 
 static int mxt_get_info(struct mxt_data *data)
@@ -1166,6 +1168,7 @@ static void mxt_free_object_table(struct mxt_data *data)
 	data->object_table = NULL;
 	kfree(data->msg_buf);
 	data->msg_buf = NULL;
+	data->T5_address = 0;
 	data->T5_msg_size = 0;
 	data->T6_reportid = 0;
 	data->T7_address = 0;
@@ -1216,6 +1219,7 @@ static int mxt_get_object_table(struct mxt_data *data)
 		case MXT_GEN_MESSAGE_T5:
 			/* CRC not enabled, therefore don't read last byte */
 			data->T5_msg_size = OBP_SIZE(object) - 1;
+			data->T5_address = object->start_address;
 		case MXT_GEN_COMMAND_T6:
 			data->T6_reportid = min_id;
 			data->T6_address = object->start_address;
-- 
1.7.10.4

