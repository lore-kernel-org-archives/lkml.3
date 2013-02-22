Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759173Ab3BVSSK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:18:10 -0500
Received: from [89.21.227.133] ([89.21.227.133]:2612 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758667Ab3BVSIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:08:30 -0500
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 18/40] Input: atmel_mxt_ts - Add support for dynamic message size
Date: Fri, 22 Feb 2013 17:58:05 +0000
Message-Id: <1361555907-19840-19-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

maXTouch chips and firmware versions have different sizes of message buffer
depending on the objects used, therefore it can't be hardcoded in the driver.
Allocate a buffer on probe instead.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   97 +++++++++++++++++-------------
 1 file changed, 55 insertions(+), 42 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 60231bf..c879778 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -221,11 +221,6 @@ struct mxt_object {
 	u8 num_report_ids;
 } __packed;
 
-struct mxt_message {
-	u8 reportid;
-	u8 message[7];
-};
-
 enum mxt_device_state { INIT, APPMODE, BOOTLOADER, FAILED, SHUTDOWN };
 
 /* Each client has this additional data */
@@ -247,8 +242,10 @@ struct mxt_data {
 	u32 info_crc;
 	u8 bootloader_addr;
 	struct t7_config t7_cfg;
+	u8 *msg_buf;
 
 	/* Cached parameters from object table */
+	u8 T5_msg_size;
 	u8 T6_reportid;
 	u16 T6_address;
 	u16 T7_address;
@@ -309,10 +306,10 @@ static bool mxt_object_readable(unsigned int type)
 	}
 }
 
-static void mxt_dump_message(struct device *dev, struct mxt_message *message)
+static void mxt_dump_message(struct mxt_data *data, u8 *message)
 {
-	dev_dbg(dev, "MXT MSG: %*ph\n",
-		       sizeof(struct mxt_message), message);
+	dev_dbg(&data->client->dev, "MXT MSG: %*ph\n",
+		       data->T5_msg_size, message);
 }
 
 static int mxt_bootloader_read(struct mxt_data *data, u8 *val, unsigned int count)
@@ -565,8 +562,7 @@ mxt_get_object(struct mxt_data *data, u8 type)
 	return NULL;
 }
 
-static int mxt_read_message(struct mxt_data *data,
-				 struct mxt_message *message)
+static int mxt_read_message(struct mxt_data *data, u8 *message)
 {
 	struct mxt_object *object;
 	u16 reg;
@@ -577,7 +573,7 @@ static int mxt_read_message(struct mxt_data *data,
 
 	reg = object->start_address;
 	return __mxt_read_reg(data->client, reg,
-			sizeof(struct mxt_message), message);
+			data->T5_msg_size, message);
 }
 
 static void mxt_input_sync(struct input_dev *input_dev)
@@ -586,12 +582,12 @@ static void mxt_input_sync(struct input_dev *input_dev)
 	input_sync(input_dev);
 }
 
-static void mxt_input_touchevent(struct mxt_data *data,
-				      struct mxt_message *message, int id)
+static void mxt_input_touchevent(struct mxt_data *data, u8 *message)
 {
 	struct device *dev = &data->client->dev;
-	u8 status = message->message[0];
 	struct input_dev *input_dev = data->input_dev;
+	int id;
+	u8 status;
 	int x;
 	int y;
 	int area;
@@ -601,16 +597,18 @@ static void mxt_input_touchevent(struct mxt_data *data,
 	if (!input_dev)
 		return;
 
-	x = (message->message[1] << 4) | ((message->message[3] >> 4) & 0xf);
-	y = (message->message[2] << 4) | ((message->message[3] & 0xf));
+	id = message[0] - data->T9_reportid_min;
+	status = message[1];
+	x = (message[2] << 4) | ((message[4] >> 4) & 0xf);
+	y = (message[3] << 4) | ((message[4] & 0xf));
 
 	if (data->max_x < 1024)
 		x >>= 2;
 	if (data->max_y < 1024)
 		y >>= 2;
 
-	area = message->message[4];
-	amplitude = message->message[5];
+	area = message[5];
+	amplitude = message[6];
 
 	dev_dbg(dev,
 		"[%u] %c%c%c%c%c%c%c%c x: %5u y: %5u area: %3u amp: %3u\n",
@@ -654,28 +652,28 @@ static u16 mxt_extract_T6_csum(const u8 *csum)
 	return csum[0] | (csum[1] << 8) | (csum[2] << 16);
 }
 
-static bool mxt_is_T9_message(struct mxt_data *data, struct mxt_message *msg)
+static bool mxt_is_T9_message(struct mxt_data *data, u8 *msg)
 {
-	u8 id = msg->reportid;
+	u8 id = msg[0];
 	return (id >= data->T9_reportid_min && id <= data->T9_reportid_max);
 }
 
 static irqreturn_t mxt_process_messages_until_invalid(struct mxt_data *data)
 {
-	struct mxt_message message;
-	const u8 *payload = &message.message[0];
+	u8 *message = &data->msg_buf[0];
+	const u8 *payload = &data->msg_buf[1];
 	struct device *dev = &data->client->dev;
 	u8 reportid;
 	bool update_input = false;
 	bool handled;
 
 	do {
-		if (mxt_read_message(data, &message)) {
+		if (mxt_read_message(data, message)) {
 			dev_err(dev, "Failed to read message\n");
 			return IRQ_NONE;
 		}
 
-		reportid = message.reportid;
+		reportid = message[0];
 		handled = false;
 
 		if (reportid == data->T6_reportid) {
@@ -684,15 +682,14 @@ static irqreturn_t mxt_process_messages_until_invalid(struct mxt_data *data)
 			dev_dbg(dev, "Status: %02x Config Checksum: %06x\n",
 				status, data->config_crc);
 			handled = true;
-		} else if (mxt_is_T9_message(data, &message)) {
-			int id = reportid - data->T9_reportid_min;
-			mxt_input_touchevent(data, &message, id);
+		} else if (mxt_is_T9_message(data, message)) {
+			mxt_input_touchevent(data, message);
 			update_input = true;
 			handled = true;
 		}
 
 		if (!handled || data->debug_enabled)
-			mxt_dump_message(dev, &message);
+			mxt_dump_message(data, message);
 	} while (reportid != MXT_RPTID_NOMSG);
 
 	if (update_input)
@@ -1110,16 +1107,15 @@ recheck:
 static int mxt_make_highchg(struct mxt_data *data)
 {
 	struct device *dev = &data->client->dev;
-	struct mxt_message message;
 	int count = 10;
 	int error;
 
 	/* Read dummy message to make high CHG pin */
 	do {
-		error = mxt_read_message(data, &message);
+		error = mxt_read_message(data, data->msg_buf);
 		if (error)
 			return error;
-	} while (message.reportid != MXT_RPTID_NOMSG && --count);
+	} while (data->msg_buf[0] != MXT_RPTID_NOMSG && --count);
 
 	if (!count) {
 		dev_err(dev, "CHG pin isn't cleared\n");
@@ -1143,6 +1139,19 @@ static int mxt_get_info(struct mxt_data *data)
 	return 0;
 }
 
+static void mxt_free_object_table(struct mxt_data *data)
+{
+	kfree(data->object_table);
+	data->object_table = NULL;
+	kfree(data->msg_buf);
+	data->msg_buf = NULL;
+	data->T5_msg_size = 0;
+	data->T6_reportid = 0;
+	data->T7_address = 0;
+	data->T9_reportid_min = 0;
+	data->T9_reportid_max = 0;
+}
+
 static int mxt_get_object_table(struct mxt_data *data)
 {
 	struct i2c_client *client = data->client;
@@ -1183,6 +1192,9 @@ static int mxt_get_object_table(struct mxt_data *data)
 			OBP_INSTANCES(object), min_id, max_id);
 
 		switch (object->type) {
+		case MXT_GEN_MESSAGE_T5:
+			/* CRC not enabled, therefore don't read last byte */
+			data->T5_msg_size = OBP_SIZE(object) - 1;
 		case MXT_GEN_COMMAND_T6:
 			data->T6_reportid = min_id;
 			data->T6_address = object->start_address;
@@ -1203,17 +1215,18 @@ static int mxt_get_object_table(struct mxt_data *data)
 			data->mem_size = end_address + 1;
 	}
 
-	return 0;
-}
+	data->msg_buf = kzalloc(data->T5_msg_size, GFP_KERNEL);
+	if (!data->msg_buf) {
+		dev_err(&client->dev, "Failed to allocate message buffer\n");
+		error = -ENOMEM;
+		goto free_object_table;
+	}
 
-static void mxt_free_object_table(struct mxt_data *data)
-{
-	kfree(data->object_table);
-	data->object_table = NULL;
-	data->T6_reportid = 0;
-	data->T9_reportid_min = 0;
-	data->T9_reportid_max = 0;
+	return 0;
 
+free_object_table:
+	mxt_free_object_table(data);
+	return error;
 }
 
 static int mxt_read_t9_resolution(struct mxt_data *data)
@@ -1830,7 +1843,7 @@ err_unregister_device:
 err_free_irq:
 	free_irq(client->irq, data);
 err_free_object:
-	kfree(data->object_table);
+	mxt_free_object_table(data);
 err_free_mem:
 	kfree(data);
 	return error;
@@ -1844,7 +1857,7 @@ static int mxt_remove(struct i2c_client *client)
 	sysfs_remove_group(&client->dev.kobj, &mxt_attr_group);
 	free_irq(data->irq, data);
 	input_unregister_device(data->input_dev);
-	kfree(data->object_table);
+	mxt_free_object_table(data);
 	kfree(data);
 
 	return 0;
-- 
1.7.10.4

