Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab3F0Mvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 08:51:48 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:62414 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753722Ab3F0Muz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:50:55 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 48/51] Input: atmel_mxt_ts - Implement support for T100 touch object
Date: Thu, 27 Jun 2013 13:49:23 +0100
Message-Id: <1372337366-9286-49-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The T100 object replaces the old T9 multitouch touchscreen object in new
chips.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |  299 ++++++++++++++++++++++++++++--
 1 file changed, 288 insertions(+), 11 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index b75cf38..cb6fe8f 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -67,6 +67,7 @@
 #define MXT_SPT_MESSAGECOUNT_T44	44
 #define MXT_SPT_CTECONFIG_T46		46
 #define MXT_PROCI_ACTIVE_STYLUS_T63	63
+#define MXT_TOUCH_MULTITOUCHSCREEN_T100 100
 
 /* MXT_GEN_MESSAGE_T5 object */
 #define MXT_RPTID_NOMSG		0xff
@@ -146,6 +147,23 @@ struct t9_range {
 
 #define MXT_T63_STYLUS_PRESSURE_MASK	0x3F
 
+/* T100 Multiple Touch Touchscreen */
+#define MXT_T100_CTRL		0
+#define MXT_T100_CFG1		1
+#define MXT_T100_TCHAUX		3
+#define MXT_T100_XRANGE		13
+#define MXT_T100_YRANGE		24
+
+#define MXT_T100_CFG_SWITCHXY	(1 << 5)
+
+#define MXT_T100_TCHAUX_VECT	(1 << 0)
+#define MXT_T100_TCHAUX_AMPL	(1 << 1)
+#define MXT_T100_TCHAUX_AREA	(1 << 2)
+
+#define MXT_T100_DETECT		(1 << 7)
+#define MXT_T100_TYPE_MASK	0x70
+#define MXT_T100_TYPE_STYLUS	0x20
+
 /* Delay times */
 #define MXT_BACKUP_TIME		50	/* msec */
 #define MXT_RESET_TIME		200	/* msec */
@@ -209,6 +227,9 @@ struct mxt_data {
 	unsigned int max_y;
 	bool in_bootloader;
 	u16 mem_size;
+	u8 t100_aux_ampl;
+	u8 t100_aux_area;
+	u8 t100_aux_vect;
 	u8 max_reportid;
 	u32 config_crc;
 	u32 info_crc;
@@ -244,6 +265,8 @@ struct mxt_data {
 	u8 T48_reportid;
 	u8 T63_reportid_min;
 	u8 T63_reportid_max;
+	u8 T100_reportid_min;
+	u8 T100_reportid_max;
 
 	/* for fw update in bootloader */
 	struct completion bl_completion;
@@ -780,6 +803,79 @@ static void mxt_proc_t9_message(struct mxt_data *data, u8 *message)
 	data->update_input = true;
 }
 
+static void mxt_proc_t100_message(struct mxt_data *data, u8 *message)
+{
+	struct device *dev = &data->client->dev;
+	struct input_dev *input_dev = data->input_dev;
+	int id;
+	u8 status;
+	int x;
+	int y;
+	int tool;
+
+	/* do not report events if input device not yet registered */
+	if (!data->enable_reporting)
+		return;
+
+	id = message[0] - data->T100_reportid_min - 2;
+
+	/* ignore SCRSTATUS events */
+	if (id < 0)
+		return;
+
+	status = message[1];
+	x = (message[3] << 8) | message[2];
+	y = (message[5] << 8) | message[4];
+
+	dev_dbg(dev,
+		"[%u] status:%02X x:%u y:%u area:%02X amp:%02X vec:%02X\n",
+		id,
+		status,
+		x, y,
+		(data->t100_aux_area) ? message[data->t100_aux_area] : 0,
+		(data->t100_aux_ampl) ? message[data->t100_aux_ampl] : 0,
+		(data->t100_aux_vect) ? message[data->t100_aux_vect] : 0);
+
+	input_mt_slot(input_dev, id);
+
+	if (status & MXT_T100_DETECT) {
+		/* A reported size of zero indicates that the reported touch
+		 * is a stylus from a linked Stylus T47 object. */
+		if ((status & MXT_T100_TYPE_MASK) == MXT_T100_TYPE_STYLUS)
+			tool = MT_TOOL_PEN;
+		else
+			tool = MT_TOOL_FINGER;
+
+		/* Touch active */
+		input_mt_report_slot_state(input_dev, tool, 1);
+		input_report_abs(input_dev, ABS_MT_POSITION_X, x);
+		input_report_abs(input_dev, ABS_MT_POSITION_Y, y);
+
+		if (data->t100_aux_ampl)
+			input_report_abs(input_dev, ABS_MT_PRESSURE,
+					 message[data->t100_aux_ampl]);
+
+		if (data->t100_aux_area) {
+			if (tool == MT_TOOL_PEN)
+				input_report_abs(input_dev, ABS_MT_TOUCH_MAJOR,
+						 MXT_TOUCH_MAJOR_T47_STYLUS);
+			else
+				input_report_abs(input_dev, ABS_MT_TOUCH_MAJOR,
+						 message[data->t100_aux_area]);
+		}
+
+		if (data->t100_aux_vect)
+			input_report_abs(input_dev, ABS_MT_ORIENTATION,
+					 message[data->t100_aux_vect]);
+	} else {
+		/* Touch no longer active, close out slot */
+		input_mt_report_slot_state(input_dev, MT_TOOL_FINGER, 0);
+	}
+
+	data->update_input = true;
+}
+
+
 static void mxt_proc_t15_messages(struct mxt_data *data, u8 *msg)
 {
 	struct input_dev *input_dev = data->input_dev;
@@ -916,6 +1012,9 @@ static int mxt_proc_message(struct mxt_data *data, u8 *message)
 	} else if (report_id >= data->T9_reportid_min
 	    && report_id <= data->T9_reportid_max) {
 		mxt_proc_t9_message(data, message);
+	} else if (report_id >= data->T100_reportid_min
+	    && report_id <= data->T100_reportid_max) {
+		mxt_proc_t100_message(data, message);
 	} else if (report_id == data->T19_reportid) {
 		mxt_input_button(data, message);
 		data->update_input = true;
@@ -1582,6 +1681,12 @@ static void mxt_free_object_table(struct mxt_data *data)
 	data->raw_info_block = NULL;
 	kfree(data->msg_buf);
 	data->msg_buf = NULL;
+
+	if (data->input_dev) {
+		input_unregister_device(data->input_dev);
+		data->input_dev = NULL;
+	}
+
 	data->enable_reporting = false;
 	data->T5_address = 0;
 	data->T5_msg_size = 0;
@@ -1599,6 +1704,8 @@ static void mxt_free_object_table(struct mxt_data *data)
 	data->T48_reportid = 0;
 	data->T63_reportid_min = 0;
 	data->T63_reportid_max = 0;
+	data->T100_reportid_min = 0;
+	data->T100_reportid_max = 0;
 	data->max_reportid = 0;
 }
 
@@ -1684,6 +1791,12 @@ static int mxt_parse_object_table(struct mxt_data *data)
 			data->num_stylusids = object->num_report_ids
 						* mxt_obj_instances(object);
 			break;
+		case MXT_TOUCH_MULTITOUCHSCREEN_T100:
+			data->T100_reportid_min = min_id;
+			data->T100_reportid_max = max_id;
+			/* first two report IDs reserved */
+			data->num_touchids = object->num_report_ids - 2;
+			break;
 		}
 
 		end_address = object->start_address
@@ -1907,6 +2020,168 @@ fail:
 	data->use_regulator = false;
 }
 
+static int mxt_read_t100_config(struct mxt_data *data)
+{
+	struct i2c_client *client = data->client;
+	int error;
+	struct mxt_object *object;
+	u16 range_x, range_y;
+	u8 cfg, tchaux;
+	u8 aux;
+
+	object = mxt_get_object(data, MXT_TOUCH_MULTITOUCHSCREEN_T100);
+	if (!object)
+		return -EINVAL;
+
+	error = __mxt_read_reg(client,
+			       object->start_address + MXT_T100_XRANGE,
+			       sizeof(range_x), &range_x);
+	if (error)
+		return error;
+
+	le16_to_cpus(range_x);
+
+	error = __mxt_read_reg(client,
+			       object->start_address + MXT_T100_YRANGE,
+			       sizeof(range_y), &range_y);
+	if (error)
+		return error;
+
+	le16_to_cpus(range_y);
+
+	error =  __mxt_read_reg(client,
+				object->start_address + MXT_T100_CFG1,
+				1, &cfg);
+	if (error)
+		return error;
+
+	error =  __mxt_read_reg(client,
+				object->start_address + MXT_T100_TCHAUX,
+				1, &tchaux);
+	if (error)
+		return error;
+
+	/* Handle default values */
+	if (range_x == 0)
+		range_x = 1023;
+
+	/* Handle default values */
+	if (range_x == 0)
+		range_x = 1023;
+
+	if (range_y == 0)
+		range_y = 1023;
+
+	if (cfg & MXT_T100_CFG_SWITCHXY) {
+		data->max_x = range_y;
+		data->max_y = range_x;
+	} else {
+		data->max_x = range_x;
+		data->max_y = range_y;
+	}
+
+	/* allocate aux bytes */
+	aux = 6;
+
+	if (tchaux & MXT_T100_TCHAUX_VECT)
+		data->t100_aux_vect = aux++;
+
+	if (tchaux & MXT_T100_TCHAUX_AMPL)
+		data->t100_aux_ampl = aux++;
+
+	if (tchaux & MXT_T100_TCHAUX_AREA)
+		data->t100_aux_area = aux++;
+
+	dev_info(&client->dev,
+		 "T100 Touchscreen size X%uY%u\n", data->max_x, data->max_y);
+
+	return 0;
+}
+
+static int mxt_input_open(struct input_dev *dev);
+static void mxt_input_close(struct input_dev *dev);
+
+static int mxt_initialize_t100_input_device(struct mxt_data *data)
+{
+	struct device *dev = &data->client->dev;
+	struct input_dev *input_dev;
+	int error;
+
+	error = mxt_read_t100_config(data);
+	if (error)
+		dev_warn(dev, "Failed to initialize T9 resolution\n");
+
+	input_dev = input_allocate_device();
+	if (!data || !input_dev) {
+		dev_err(dev, "Failed to allocate memory\n");
+		return -ENOMEM;
+	}
+
+	input_dev->name = "atmel_mxt_ts T100 touchscreen";
+
+	input_dev->phys = data->phys;
+	input_dev->id.bustype = BUS_I2C;
+	input_dev->dev.parent = &data->client->dev;
+	input_dev->open = mxt_input_open;
+	input_dev->close = mxt_input_close;
+
+	set_bit(EV_ABS, input_dev->evbit);
+	input_set_capability(input_dev, EV_KEY, BTN_TOUCH);
+
+	/* For single touch */
+	input_set_abs_params(input_dev, ABS_X,
+			     0, data->max_x, 0, 0);
+	input_set_abs_params(input_dev, ABS_Y,
+			     0, data->max_y, 0, 0);
+
+	if (data->t100_aux_ampl)
+		input_set_abs_params(input_dev, ABS_PRESSURE,
+				     0, 255, 0, 0);
+
+	/* For multi touch */
+	error = input_mt_init_slots(input_dev, data->num_touchids, 0);
+	if (error) {
+		dev_err(dev, "Error %d initialising slots\n", error);
+		goto err_free_mem;
+	}
+
+	input_set_abs_params(input_dev, ABS_MT_TOOL_TYPE, 0, MT_TOOL_MAX, 0, 0);
+	input_set_abs_params(input_dev, ABS_MT_POSITION_X,
+			     0, data->max_x, 0, 0);
+	input_set_abs_params(input_dev, ABS_MT_POSITION_Y,
+			     0, data->max_y, 0, 0);
+
+	if (data->t100_aux_area)
+		input_set_abs_params(input_dev, ABS_MT_TOUCH_MAJOR,
+				     0, MXT_MAX_AREA, 0, 0);
+
+	if (data->t100_aux_ampl)
+		input_set_abs_params(input_dev, ABS_MT_PRESSURE,
+				     0, 255, 0, 0);
+
+	if (data->t100_aux_vect)
+		input_set_abs_params(input_dev, ABS_MT_ORIENTATION,
+				     0, 255, 0, 0);
+
+	input_set_drvdata(input_dev, data);
+
+	error = input_register_device(input_dev);
+	if (error) {
+		dev_err(dev, "Error %d registering input device\n", error);
+		goto err_free_mem;
+	}
+
+	data->input_dev = input_dev;
+
+	return 0;
+
+err_free_mem:
+	input_free_device(input_dev);
+	return error;
+}
+
+static int mxt_initialize_t9_input_device(struct mxt_data *data);
+
 static int mxt_initialize(struct mxt_data *data)
 {
 	struct i2c_client *client = data->client;
@@ -1969,6 +2244,18 @@ retry_bootloader:
 		goto err_free_object_table;
 	}
 
+	if (data->T9_reportid_min) {
+		error = mxt_initialize_t9_input_device(data);
+		if (error)
+			goto err_free_object_table;
+	} else if (data->T100_reportid_min) {
+		error = mxt_initialize_t100_input_device(data);
+		if (error)
+			goto err_free_object_table;
+	} else {
+		dev_warn(&client->dev, "No touch object detected\n");
+	}
+
 	data->enable_reporting = true;
 
 	return 0;
@@ -2493,24 +2780,15 @@ static int mxt_probe(struct i2c_client *client,
 	if (error)
 		goto err_free_irq;
 
-	if (!data->in_bootloader) {
-		error = mxt_initialize_t9_input_device(data);
-		if (error)
-			goto err_free_object;
-	}
-
 	error = sysfs_create_group(&client->dev.kobj, &mxt_attr_group);
 	if (error) {
 		dev_err(&client->dev, "Failure %d creating sysfs group\n",
 			error);
-		goto err_unregister_device;
+		goto err_free_object;
 	}
 
 	return 0;
 
-err_unregister_device:
-	input_unregister_device(data->input_dev);
-	data->input_dev = NULL;
 err_free_object:
 	mxt_free_object_table(data);
 err_free_irq:
@@ -2529,7 +2807,6 @@ static int mxt_remove(struct i2c_client *client)
 
 	sysfs_remove_group(&client->dev.kobj, &mxt_attr_group);
 	free_irq(data->irq, data);
-	input_unregister_device(data->input_dev);
 	regulator_put(data->reg_avdd);
 	regulator_put(data->reg_vdd);
 	mxt_free_object_table(data);
-- 
1.7.10.4

