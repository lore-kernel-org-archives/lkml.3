Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab3F0M4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 08:56:55 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:12379 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752817Ab3F0Mus (ORCPT
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
Subject: [PATCH 34/51] Input: atmel_mxt_ts - Implement T44 message handling
Date: Thu, 27 Jun 2013 13:49:09 +0100
Message-Id: <1372337366-9286-35-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

maXTouch chips allow the reading of multiple messages in a single I2C
transaction. The number of messages available to be read is given by the value
in the T44 object which is located directly before the T5 object.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |  190 +++++++++++++++++++++++++-----
 1 file changed, 158 insertions(+), 32 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index ef68bf1..5d51133 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -246,6 +246,7 @@ struct mxt_data {
 	unsigned int max_y;
 	bool in_bootloader;
 	u16 mem_size;
+	u8 max_reportid;
 	u32 config_crc;
 	u32 info_crc;
 	u8 bootloader_addr;
@@ -253,6 +254,8 @@ struct mxt_data {
 	u8 *msg_buf;
 	u8 t6_status;
 	bool update_input;
+	u8 last_message_count;
+	u8 num_touchids;
 
 	/* Cached parameters from object table */
 	u16 T5_address;
@@ -263,6 +266,7 @@ struct mxt_data {
 	u8 T9_reportid_min;
 	u8 T9_reportid_max;
 	u8 T19_reportid;
+	u16 T44_address;
 
 	/* for fw update in bootloader */
 	struct completion bl_completion;
@@ -786,30 +790,143 @@ static int mxt_proc_message(struct mxt_data *data, u8 *message)
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
+		dev_err(dev, "T44 count %d exceeded max report id\n", count);
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
 
 	if (data->enable_reporting && data->update_input) {
 		mxt_input_sync(data->input_dev);
@@ -832,7 +949,11 @@ static irqreturn_t mxt_interrupt(int irq, void *dev_id)
 	if (!data->object_table)
 		return IRQ_NONE;
 
-	return mxt_process_messages_until_invalid(data);
+	if (data->T44_address) {
+		return mxt_process_messages_t44(data);
+	} else {
+		return mxt_process_messages(data);
+	}
 }
 
 static int mxt_t6_command(struct mxt_data *data, u16 cmd_offset,
@@ -1257,32 +1378,13 @@ recheck:
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
 static int mxt_acquire_irq(struct mxt_data *data)
 {
 	int error;
 
 	enable_irq(data->irq);
 
-	error = mxt_make_highchg(data);
+	error = mxt_process_messages_until_invalid(data);
 	if (error)
 		return error;
 
@@ -1317,6 +1419,8 @@ static void mxt_free_object_table(struct mxt_data *data)
 	data->T9_reportid_min = 0;
 	data->T9_reportid_max = 0;
 	data->T19_reportid = 0;
+	data->T44_address = 0;
+	data->max_reportid = 0;
 }
 
 static int mxt_get_object_table(struct mxt_data *data)
@@ -1361,8 +1465,14 @@ static int mxt_get_object_table(struct mxt_data *data)
 
 		switch (object->type) {
 		case MXT_GEN_MESSAGE_T5:
-			/* CRC not enabled, therefore don't read last byte */
-			data->T5_msg_size = mxt_obj_size(object) - 1;
+			if (data->info.family_id == 0x80) {
+				/* On mXT224 read and discard unused CRC byte
+				 * otherwise DMA reads are misaligned */
+				data->T5_msg_size = mxt_obj_size(object);
+			} else {
+				/* CRC not enabled, so skip last byte */
+				data->T5_msg_size = mxt_obj_size(object) - 1;
+			}
 			data->T5_address = object->start_address;
 		case MXT_GEN_COMMAND_T6:
 			data->T6_reportid = min_id;
@@ -1374,6 +1484,11 @@ static int mxt_get_object_table(struct mxt_data *data)
 		case MXT_TOUCH_MULTI_T9:
 			data->T9_reportid_min = min_id;
 			data->T9_reportid_max = max_id;
+			data->num_touchids = object->num_report_ids
+						* mxt_obj_instances(object);
+			break;
+		case MXT_SPT_MESSAGECOUNT_T44:
+			data->T44_address = object->start_address;
 			break;
 		case MXT_SPT_GPIOPWM_T19:
 			data->T19_reportid = min_id;
@@ -1387,7 +1502,18 @@ static int mxt_get_object_table(struct mxt_data *data)
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
+	data->msg_buf = kcalloc(data->max_reportid,
+				data->T5_msg_size, GFP_KERNEL);
 	if (!data->msg_buf) {
 		dev_err(&client->dev, "Failed to allocate message buffer\n");
 		error = -ENOMEM;
-- 
1.7.10.4

