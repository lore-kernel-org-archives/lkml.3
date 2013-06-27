Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab3F0M5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 08:57:35 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:40495 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753198Ab3F0Mur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:50:47 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 31/51] Input: atmel_mxt_ts - Add support for dynamic message size
Date: Thu, 27 Jun 2013 13:49:06 +0100
Message-Id: <1372337366-9286-32-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The T5 object may have various sizes depending on the objects used on the
particular maXTouch chip and firmware version, therefore it can't be hardcoded
in the driver. Allocate a buffer on probe instead.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |  114 +++++++++++++++++-------------
 1 file changed, 65 insertions(+), 49 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index b8e2b04..688eab3 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -79,6 +79,9 @@
 #define MXT_SPT_MESSAGECOUNT_T44	44
 #define MXT_SPT_CTECONFIG_T46		46
 
+/* MXT_GEN_MESSAGE_T5 object */
+#define MXT_RPTID_NOMSG		0xff
+
 /* MXT_GEN_COMMAND_T6 field */
 #define MXT_COMMAND_RESET	0
 #define MXT_COMMAND_BACKUPNV	1
@@ -225,11 +228,6 @@ struct mxt_object {
 	u8 num_report_ids;
 } __packed;
 
-struct mxt_message {
-	u8 reportid;
-	u8 message[7];
-};
-
 /* Each client has this additional data */
 struct mxt_data {
 	struct i2c_client *client;
@@ -247,8 +245,10 @@ struct mxt_data {
 	u32 info_crc;
 	u8 bootloader_addr;
 	struct t7_config t7_cfg;
+	u8 *msg_buf;
 
 	/* Cached parameters from object table */
+	u8 T5_msg_size;
 	u8 T6_reportid;
 	u16 T6_address;
 	u16 T7_address;
@@ -312,11 +312,10 @@ static bool mxt_object_readable(unsigned int type)
 	}
 }
 
-static void mxt_dump_message(struct device *dev,
-			     struct mxt_message *message)
+static void mxt_dump_message(struct mxt_data *data, u8 *message)
 {
-	dev_dbg(dev, "reportid: %u\tmessage: %*ph\n",
-		message->reportid, 7, message->message);
+	dev_dbg(&data->client->dev, "message: %*ph\n",
+		data->T5_msg_size, message);
 }
 
 static int mxt_wait_for_completion(struct mxt_data *data,
@@ -630,8 +629,7 @@ mxt_get_object(struct mxt_data *data, u8 type)
 	return NULL;
 }
 
-static int mxt_read_message(struct mxt_data *data,
-				 struct mxt_message *message)
+static int mxt_read_message(struct mxt_data *data, u8 *message)
 {
 	struct mxt_object *object;
 	u16 reg;
@@ -642,10 +640,10 @@ static int mxt_read_message(struct mxt_data *data,
 
 	reg = object->start_address;
 	return __mxt_read_reg(data->client, reg,
-			sizeof(struct mxt_message), message);
+			data->T5_msg_size, message);
 }
 
-static void mxt_input_button(struct mxt_data *data, struct mxt_message *message)
+static void mxt_input_button(struct mxt_data *data, u8 *message)
 {
 	struct input_dev *input = data->input_dev;
 	const struct mxt_platform_data *pdata = data->pdata;
@@ -660,7 +658,7 @@ static void mxt_input_button(struct mxt_data *data, struct mxt_message *message)
 	for (i = 0; i < pdata->t19_num_keys; i++) {
 		if (pdata->t19_keymap[i] == KEY_RESERVED)
 			continue;
-		button = !(message->message[0] & (1 << i));
+		button = !(message[1] & (1 << i));
 		input_report_key(input, pdata->t19_keymap[i], button);
 	}
 }
@@ -671,12 +669,12 @@ static void mxt_input_sync(struct input_dev *input_dev)
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
@@ -686,8 +684,10 @@ static void mxt_input_touchevent(struct mxt_data *data,
 	if (!data->enable_reporting)
 		return;
 
-	x = (message->message[1] << 4) | ((message->message[3] >> 4) & 0xf);
-	y = (message->message[2] << 4) | ((message->message[3] & 0xf));
+	id = message[0] - data->T9_reportid_min;
+	status = message[1];
+	x = (message[2] << 4) | ((message[4] >> 4) & 0xf);
+	y = (message[3] << 4) | ((message[4] & 0xf));
 
 	/* Handle 10/12 bit switching */
 	if (data->max_x < 1024)
@@ -695,8 +695,8 @@ static void mxt_input_touchevent(struct mxt_data *data,
 	if (data->max_y < 1024)
 		y >>= 2;
 
-	area = message->message[4];
-	amplitude = message->message[5];
+	area = message[5];
+	amplitude = message[6];
 
 	dev_dbg(dev,
 		"[%u] %c%c%c%c%c%c%c%c x: %5u y: %5u area: %3u amp: %3u\n",
@@ -740,28 +740,28 @@ static u16 mxt_extract_T6_csum(const u8 *csum)
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
 	u32 crc;
 
 	do {
-		if (mxt_read_message(data, &message)) {
+		if (mxt_read_message(data, message)) {
 			dev_err(dev, "Failed to read message\n");
 			return IRQ_NONE;
 		}
 
-		reportid = message.reportid;
+		reportid = message[0];
 
 		if (reportid == data->T6_reportid) {
 			u8 status = payload[0];
@@ -777,17 +777,16 @@ static irqreturn_t mxt_process_messages_until_invalid(struct mxt_data *data)
 
 			if (status & MXT_T6_STATUS_RESET)
 				complete(&data->reset_completion);
-		} else if (mxt_is_T9_message(data, &message)) {
-			int id = reportid - data->T9_reportid_min;
-			mxt_input_touchevent(data, &message, id);
+		} else if (mxt_is_T9_message(data, message)) {
+			mxt_input_touchevent(data, message);
 			update_input = true;
-		} else if (message.reportid == data->T19_reportid) {
-			mxt_input_button(data, &message);
+		} else if (reportid == data->T19_reportid) {
+			mxt_input_button(data, message);
 			update_input = true;
 		} else {
-			mxt_dump_message(dev, &message);
+			mxt_dump_message(data, message);
 		}
-	} while (reportid != 0xff);
+	} while (reportid != MXT_RPTID_NOMSG);
 
 	if (data->enable_reporting && update_input)
 		mxt_input_sync(data->input_dev);
@@ -1236,16 +1235,15 @@ recheck:
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
-	} while (message.reportid != 0xff && --count);
+	} while (data->msg_buf[0] != MXT_RPTID_NOMSG && --count);
 
 	if (!count) {
 		dev_err(dev, "CHG pin isn't cleared\n");
@@ -1282,6 +1280,21 @@ static int mxt_get_info(struct mxt_data *data)
 	return 0;
 }
 
+static void mxt_free_object_table(struct mxt_data *data)
+{
+	kfree(data->object_table);
+	data->object_table = NULL;
+	kfree(data->msg_buf);
+	data->msg_buf = NULL;
+	data->enable_reporting = false;
+	data->T5_msg_size = 0;
+	data->T6_reportid = 0;
+	data->T7_address = 0;
+	data->T9_reportid_min = 0;
+	data->T9_reportid_max = 0;
+	data->T19_reportid = 0;
+}
+
 static int mxt_get_object_table(struct mxt_data *data)
 {
 	struct i2c_client *client = data->client;
@@ -1323,6 +1336,9 @@ static int mxt_get_object_table(struct mxt_data *data)
 			min_id, max_id);
 
 		switch (object->type) {
+		case MXT_GEN_MESSAGE_T5:
+			/* CRC not enabled, therefore don't read last byte */
+			data->T5_msg_size = mxt_obj_size(object) - 1;
 		case MXT_GEN_COMMAND_T6:
 			data->T6_reportid = min_id;
 			data->T6_address = object->start_address;
@@ -1346,18 +1362,18 @@ static int mxt_get_object_table(struct mxt_data *data)
 			data->mem_size = end_address + 1;
 	}
 
+	data->msg_buf = kzalloc(data->T5_msg_size, GFP_KERNEL);
+	if (!data->msg_buf) {
+		dev_err(&client->dev, "Failed to allocate message buffer\n");
+		error = -ENOMEM;
+		goto free_object_table;
+	}
+
 	return 0;
-}
 
-static void mxt_free_object_table(struct mxt_data *data)
-{
-	kfree(data->object_table);
-	data->object_table = NULL;
-	data->enable_reporting = false;
-	data->T6_reportid = 0;
-	data->T9_reportid_min = 0;
-	data->T9_reportid_max = 0;
-	data->T19_reportid = 0;
+free_object_table:
+	mxt_free_object_table(data);
+	return error;
 }
 
 static int mxt_read_t9_resolution(struct mxt_data *data)
@@ -1959,7 +1975,7 @@ err_unregister_device:
 	input_unregister_device(data->input_dev);
 	data->input_dev = NULL;
 err_free_object:
-	kfree(data->object_table);
+	mxt_free_object_table(data);
 err_free_irq:
 	free_irq(data->irq, data);
 err_free_pdata:
@@ -1977,7 +1993,7 @@ static int mxt_remove(struct i2c_client *client)
 	sysfs_remove_group(&client->dev.kobj, &mxt_attr_group);
 	free_irq(data->irq, data);
 	input_unregister_device(data->input_dev);
-	kfree(data->object_table);
+	mxt_free_object_table(data);
 	if (!dev_get_platdata(&data->client->dev))
 		kfree(data->pdata);
 	kfree(data);
-- 
1.7.10.4

