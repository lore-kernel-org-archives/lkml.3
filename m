Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab3F0Muu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 08:50:50 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:36964 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753595Ab3F0Mus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:50:48 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 33/51] Input: atmel_mxt_ts - Split message handler into separate functions
Date: Thu, 27 Jun 2013 13:49:08 +0100
Message-Id: <1372337366-9286-34-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is in preparation for support of the T44 message count object.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |  111 ++++++++++++++++--------------
 1 file changed, 58 insertions(+), 53 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 3890ed5..ef68bf1 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -252,8 +252,10 @@ struct mxt_data {
 	struct t7_config t7_cfg;
 	u8 *msg_buf;
 	u8 t6_status;
+	bool update_input;
 
 	/* Cached parameters from object table */
+	u16 T5_address;
 	u8 T5_msg_size;
 	u8 T6_reportid;
 	u16 T6_address;
@@ -668,20 +670,6 @@ static void mxt_proc_t6_messages(struct mxt_data *data, u8 *msg)
 	data->t6_status = status;
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
 static void mxt_input_button(struct mxt_data *data, u8 *message)
 {
 	struct input_dev *input = data->input_dev;
@@ -708,7 +696,7 @@ static void mxt_input_sync(struct input_dev *input_dev)
 	input_sync(input_dev);
 }
 
-static void mxt_input_touchevent(struct mxt_data *data, u8 *message)
+static void mxt_proc_t9_message(struct mxt_data *data, u8 *message)
 {
 	struct device *dev = &data->client->dev;
 	struct input_dev *input_dev = data->input_dev;
@@ -772,44 +760,61 @@ static void mxt_input_touchevent(struct mxt_data *data, u8 *message)
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
+
+	if (report_id == MXT_RPTID_NOMSG)
+		return 0;
+
+	if (report_id == data->T6_reportid) {
+		mxt_proc_t6_messages(data, message);
+	} else if (report_id >= data->T9_reportid_min
+	    && report_id <= data->T9_reportid_max) {
+		mxt_proc_t9_message(data, message);
+	} else if (report_id == data->T19_reportid) {
+		mxt_input_button(data, message);
+		data->update_input = true;
+	} else {
+		mxt_dump_message(data, message);
+	}
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
+	return mxt_proc_message(data, data->msg_buf);
+}
 
-		if (reportid == data->T6_reportid) {
-			mxt_proc_t6_messages(data, message);
-		} else if (mxt_is_T9_message(data, message)) {
-			mxt_input_touchevent(data, message);
-			update_input = true;
-		} else if (reportid == data->T19_reportid) {
-			mxt_input_button(data, message);
-			update_input = true;
-		} else {
-			mxt_dump_message(data, message);
-		}
-	} while (reportid != MXT_RPTID_NOMSG);
+static irqreturn_t mxt_process_messages_until_invalid(struct mxt_data *data)
+{
+	int ret;
+
+	do {
+		ret = mxt_read_and_process_message(data);
+		if (ret < 0)
+			return IRQ_NONE;
+	} while (ret > 0);
 
-	if (data->enable_reporting && update_input)
+	if (data->enable_reporting && data->update_input) {
 		mxt_input_sync(data->input_dev);
+		data->update_input = false;
+	}
 
 	return IRQ_HANDLED;
 }
@@ -1256,21 +1261,19 @@ static int mxt_make_highchg(struct mxt_data *data)
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
 
 static int mxt_acquire_irq(struct mxt_data *data)
@@ -1307,6 +1310,7 @@ static void mxt_free_object_table(struct mxt_data *data)
 	kfree(data->msg_buf);
 	data->msg_buf = NULL;
 	data->enable_reporting = false;
+	data->T5_address = 0;
 	data->T5_msg_size = 0;
 	data->T6_reportid = 0;
 	data->T7_address = 0;
@@ -1359,6 +1363,7 @@ static int mxt_get_object_table(struct mxt_data *data)
 		case MXT_GEN_MESSAGE_T5:
 			/* CRC not enabled, therefore don't read last byte */
 			data->T5_msg_size = mxt_obj_size(object) - 1;
+			data->T5_address = object->start_address;
 		case MXT_GEN_COMMAND_T6:
 			data->T6_reportid = min_id;
 			data->T6_address = object->start_address;
-- 
1.7.10.4

