Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405Ab3BVSJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:09:36 -0500
Received: from [89.21.227.133] ([89.21.227.133]:47683 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759085Ab3BVSIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:08:37 -0500
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 21/40] Input: atmel_mxt_ts - Implement T44 message handling
Date: Fri, 22 Feb 2013 17:58:08 +0000
Message-Id: <1361555907-19840-22-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

maXTouch chips allow the reading of multiple messages in a single I2C
transaction. The number of messages available to be read is given by the value
in the T44 object which is located directly before the T5 object.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |  188 ++++++++++++++++++++++++------
 1 file changed, 155 insertions(+), 33 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 51901b7..238c11c 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -246,12 +246,15 @@ struct mxt_data {
 	unsigned int max_y;
 	struct bin_attribute mem_access_attr;
 	bool debug_enabled;
+	u8 max_reportid;
 	u32 config_crc;
 	u32 info_crc;
 	u8 bootloader_addr;
 	struct t7_config t7_cfg;
 	u8 *msg_buf;
 	bool update_input;
+	u8 last_message_count;
+	u8 num_touchids;
 
 	/* Cached parameters from object table */
 	u16 T5_address;
@@ -261,6 +264,7 @@ struct mxt_data {
 	u16 T7_address;
 	u8 T9_reportid_min;
 	u8 T9_reportid_max;
+	u16 T44_address;
 };
 
 /* I2C slave address pairs */
@@ -690,30 +694,143 @@ static int mxt_proc_message(struct mxt_data *data, u8 *message)
 	return 1;
 }
 
-static int mxt_read_and_process_message(struct mxt_data *data)
+static int mxt_read_and_process_messages(struct mxt_data *data, u8 count)
 {
 	struct device *dev = &data->client->dev;
 	int ret;
+	int i;
+	u8 num_valid = 0;
+
+	/* Safety check for msg_buf */
+	if (count > data->max_reportid)
+		return -EINVAL;
 
+	/* Process remaining messages if necessary */
 	ret = __mxt_read_reg(data->client, data->T5_address,
-				data->T5_msg_size, data->msg_buf);
+				data->T5_msg_size * count, data->msg_buf);
 	if (ret) {
-		dev_err(dev, "Error %d reading message\n", ret);
+		dev_err(dev, "Failed to read %u messages (%d)\n", count, ret);
 		return ret;
 	}
 
-	return mxt_proc_message(data, data->msg_buf);
+	for (i = 0;  i < count; i++) {
+		ret = mxt_proc_message(data,
+			data->msg_buf + data->T5_msg_size * i);
+
+		if (ret == 1)
+			num_valid++;
+	}
+
+	/* return number of messages read */
+	return num_valid;
 }
 
-static irqreturn_t mxt_process_messages_until_invalid(struct mxt_data *data)
+static irqreturn_t mxt_process_messages_t44(struct mxt_data *data)
 {
+	struct device *dev = &data->client->dev;
 	int ret;
+	u8 count, num_left;
 
-	do {
-		ret = mxt_read_and_process_message(data);
+	/* Read T44 and T5 together */
+	ret = __mxt_read_reg(data->client, data->T44_address,
+		data->T5_msg_size + 1, data->msg_buf);
+	if (ret) {
+		dev_err(dev, "Failed to read T44 and T5 (%d)\n", ret);
+		return IRQ_NONE;
+	}
+
+	count = data->msg_buf[0];
+
+	if (count == 0) {
+		dev_warn(dev, "Interrupt triggered but zero messages\n");
+		return IRQ_NONE;
+	} else if (count > data->max_reportid) {
+		dev_err(dev, "T44 count exceeded max report id\n");
+		count = data->max_reportid;
+	}
+
+	/* Process first message */
+	ret = mxt_proc_message(data, data->msg_buf + 1);
+	if (ret < 0) {
+		dev_warn(dev, "Unexpected invalid message\n");
+		return IRQ_NONE;
+	}
+
+	num_left = count - 1;
+
+	/* Process remaining messages if necessary */
+	if (num_left) {
+		ret = mxt_read_and_process_messages(data, num_left);
 		if (ret < 0)
+			goto end;
+		else if (ret != num_left)
+			dev_warn(dev, "Unexpected invalid message\n");
+	}
+
+end:
+	if (data->update_input) {
+		mxt_input_sync(data->input_dev);
+		data->update_input = false;
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int mxt_process_messages_until_invalid(struct mxt_data *data)
+{
+	struct device *dev = &data->client->dev;
+	int count, read;
+	u8 tries = 2;
+
+	count = data->max_reportid;
+
+	/* Read messages until we force an invalid */
+	do {
+		read = mxt_read_and_process_messages(data, count);
+		if (read < count)
+			return 0;
+	} while (--tries);
+
+	if (data->update_input) {
+		mxt_input_sync(data->input_dev);
+		data->update_input = false;
+	}
+
+	dev_err(dev, "CHG pin isn't cleared\n");
+	return -EBUSY;
+}
+
+static irqreturn_t mxt_process_messages(struct mxt_data *data)
+{
+	int total_handled, num_handled;
+	u8 count = data->last_message_count;
+
+	if (count < 1 || count > data->max_reportid)
+		count = 1;
+
+	/* include final invalid message */
+	total_handled = mxt_read_and_process_messages(data, count + 1);
+	if (total_handled < 0)
+		return IRQ_NONE;
+	/* if there were invalid messages, then we are done */
+	else if (total_handled <= count)
+		goto update_count;
+
+	/* read two at a time until an invalid message or else we reach
+	 * reportid limit */
+	do {
+		num_handled = mxt_read_and_process_messages(data, 2);
+		if (num_handled < 0)
 			return IRQ_NONE;
-	} while (ret > 0);
+
+		total_handled += num_handled;
+
+		if (num_handled < 2)
+			break;
+	} while (total_handled < data->num_touchids);
+
+update_count:
+	data->last_message_count = total_handled;
 
 	if (data->update_input) {
 		mxt_input_sync(data->input_dev);
@@ -727,7 +844,10 @@ static irqreturn_t mxt_interrupt(int irq, void *dev_id)
 {
 	struct mxt_data *data = dev_id;
 
-	return mxt_process_messages_until_invalid(data);
+	if (data->T44_address)
+		return mxt_process_messages_t44(data);
+	else
+		return mxt_process_messages(data);
 }
 
 static int mxt_t6_command(struct mxt_data *data, u16 cmd_offset, u8 value, bool wait)
@@ -1129,25 +1249,6 @@ recheck:
 	}
 }
 
-static int mxt_make_highchg(struct mxt_data *data)
-{
-	struct device *dev = &data->client->dev;
-	int count = 10;
-	int ret;
-
-	/* Read messages until we force an invalid */
-	do {
-		ret = mxt_read_and_process_message(data);
-		if (ret == 0)
-			return 0;
-		else if (ret < 0)
-			return ret;
-	} while (--count);
-
-	dev_err(dev, "CHG pin isn't cleared\n");
-	return -EBUSY;
-}
-
 static int mxt_get_info(struct mxt_data *data)
 {
 	struct i2c_client *client = data->client;
@@ -1217,8 +1318,14 @@ static int mxt_get_object_table(struct mxt_data *data)
 
 		switch (object->type) {
 		case MXT_GEN_MESSAGE_T5:
-			/* CRC not enabled, therefore don't read last byte */
-			data->T5_msg_size = OBP_SIZE(object) - 1;
+			if (data->info.family_id == 0x80) {
+				/* On mXT224 read and discard unused CRC byte
+				 * otherwise DMA reads are misaligned */
+				data->T5_msg_size = OBP_SIZE(object);
+			} else {
+				/* CRC not enabled, therefore don't read last byte */
+				data->T5_msg_size = OBP_SIZE(object) - 1;
+			}
 			data->T5_address = object->start_address;
 		case MXT_GEN_COMMAND_T6:
 			data->T6_reportid = min_id;
@@ -1230,6 +1337,11 @@ static int mxt_get_object_table(struct mxt_data *data)
 		case MXT_TOUCH_MULTI_T9:
 			data->T9_reportid_min = min_id;
 			data->T9_reportid_max = max_id;
+			data->num_touchids =
+				object->num_report_ids * OBP_INSTANCES(object);
+			break;
+		case MXT_SPT_MESSAGECOUNT_T44:
+			data->T44_address = object->start_address;
 			break;
 		}
 
@@ -1240,7 +1352,17 @@ static int mxt_get_object_table(struct mxt_data *data)
 			data->mem_size = end_address + 1;
 	}
 
-	data->msg_buf = kzalloc(data->T5_msg_size, GFP_KERNEL);
+	/* Store maximum reportid */
+	data->max_reportid = reportid;
+
+	/* If T44 exists, T5 position has to be directly after */
+	if (data->T44_address && (data->T5_address != data->T44_address + 1)) {
+		dev_err(&client->dev, "Invalid T44 position\n");
+		error = -EINVAL;
+		goto free_object_table;
+	}
+
+	data->msg_buf = kcalloc(data->max_reportid, data->T5_msg_size, GFP_KERNEL);
 	if (!data->msg_buf) {
 		dev_err(&client->dev, "Failed to allocate message buffer\n");
 		error = -ENOMEM;
@@ -1577,7 +1699,7 @@ static ssize_t mxt_update_fw_store(struct device *dev,
 	if (data->state == APPMODE) {
 		enable_irq(data->irq);
 
-		error = mxt_make_highchg(data);
+		error = mxt_process_messages_until_invalid(data);
 		if (error)
 			return error;
 	}
@@ -1826,7 +1948,7 @@ static int mxt_probe(struct i2c_client *client,
 	}
 
 	if (data->state == APPMODE) {
-		error = mxt_make_highchg(data);
+		error = mxt_process_messages_until_invalid(data);
 		if (error)
 			goto err_free_irq;
 	}
-- 
1.7.10.4

