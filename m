Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab3BVSIq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:08:46 -0500
Received: from [89.21.227.133] ([89.21.227.133]:10930 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759004Ab3BVSIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:08:32 -0500
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 40/40] Input: atmel_mxt_ts - Implement support for T100 touch object
Date: Fri, 22 Feb 2013 17:58:27 +0000
Message-Id: <1361555907-19840-41-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The T100 object replaces the old T9 multitouch touchscreen object in new
chips.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |  307 ++++++++++++++++++++++++++++--
 1 file changed, 296 insertions(+), 11 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 24c262c..13e2028 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -65,6 +65,7 @@
 #define MXT_SPT_CTECONFIG_T46		46
 #define MXT_SPT_NOISESUPPRESSION_T48	48
 #define MXT_PROCI_ACTIVE_STYLUS_T63	63
+#define MXT_TOUCH_MULTITOUCHSCREEN_T100 100
 
 /* MXT_GEN_MESSAGE_T5 object */
 #define MXT_RPTID_NOMSG		0xff
@@ -148,6 +149,23 @@ static unsigned long mxt_t15_keystatus;
 
 #define MXT_STYLUS_PRESSURE_MASK	0x3F
 
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
 #define MXT_BACKUP_TIME		25	/* msec */
 #define MXT_RESET_TIME		200	/* msec */
@@ -212,6 +230,9 @@ struct mxt_data {
 	unsigned int irq;
 	unsigned int max_x;
 	unsigned int max_y;
+	u8 aux_ampl;
+	u8 aux_area;
+	u8 aux_vect;
 	struct bin_attribute mem_access_attr;
 	bool debug_enabled;
 	u8 max_reportid;
@@ -246,6 +267,8 @@ struct mxt_data {
 	u8 T48_reportid;
 	u8 T63_reportid_min;
 	u8 T63_reportid_max;
+	u8 T100_reportid_min;
+	u8 T100_reportid_max;
 };
 
 /* I2C slave address pairs */
@@ -706,6 +729,79 @@ static void mxt_proc_t9_message(struct mxt_data *data, u8 *message)
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
+	if (!input_dev)
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
+		"[%u] status:%02X x:%u y:%u aux:%02X%02X%02X\n",
+		id,
+		status,
+		x, y,
+		message[6],
+		message[7],
+		message[8]);
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
+		if (data->aux_ampl)
+			input_report_abs(input_dev, ABS_MT_PRESSURE,
+					 message[data->aux_ampl]);
+
+		if (data->aux_area) {
+			if (tool == MT_TOOL_PEN)
+				input_report_abs(input_dev, ABS_MT_TOUCH_MAJOR,
+						 MXT_TOUCH_MAJOR_T47_STYLUS);
+			else
+				input_report_abs(input_dev, ABS_MT_TOUCH_MAJOR,
+						 message[data->aux_area]);
+		}
+
+		if (data->aux_vect)
+			input_report_abs(input_dev, ABS_MT_ORIENTATION,
+					 message[data->aux_vect]);
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
@@ -839,6 +935,10 @@ static int mxt_proc_message(struct mxt_data *data, u8 *message)
 	    && report_id <= data->T9_reportid_max) {
 		mxt_proc_t9_message(data, message);
 		handled = true;
+	} else if (report_id >= data->T100_reportid_min
+	    && report_id <= data->T100_reportid_max) {
+		mxt_proc_t100_message(data, message);
+		handled = true;
 	} else if (report_id >= data->T63_reportid_min
 		   && report_id <= data->T63_reportid_max) {
 		mxt_proc_t63_messages(data, message);
@@ -1487,6 +1587,12 @@ static int mxt_parse_object_table(struct mxt_data *data)
 			data->num_stylusids =
 				object->num_report_ids * OBP_INSTANCES(object);
 			break;
+		case MXT_TOUCH_MULTITOUCHSCREEN_T100:
+			data->T100_reportid_min = min_id;
+			data->T100_reportid_max = max_id;
+			/* first two report IDs reserved */
+			data->num_touchids = object->num_report_ids - 2;
+			break;
 		}
 
 		end_address = object->start_address
@@ -1529,6 +1635,8 @@ static void mxt_free_object_table(struct mxt_data *data)
 	data->T7_address = 0;
 	data->T9_reportid_min = 0;
 	data->T9_reportid_max = 0;
+	data->T100_reportid_min = 0;
+	data->T100_reportid_max = 0;
 }
 
 static int mxt_read_info_block(struct mxt_data *data)
@@ -1722,6 +1830,172 @@ fail:
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
+		data->aux_vect = aux++;
+
+	if (tchaux & MXT_T100_TCHAUX_AMPL)
+		data->aux_ampl = aux++;
+
+	if (tchaux & MXT_T100_TCHAUX_AREA)
+		data->aux_area = aux++;
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
+	struct i2c_client *client = data->client;
+	struct input_dev *input_dev;
+	int error;
+
+	error = mxt_read_t100_config(data);
+	if (error)
+		dev_warn(&client->dev, "Failed to initialize T9 resolution\n");
+
+	input_dev = input_allocate_device();
+	if (!data || !input_dev) {
+		dev_err(&client->dev, "Failed to allocate memory\n");
+		return -ENOMEM;
+	}
+
+	if (data->pdata->input_name)
+		input_dev->name = data->pdata->input_name;
+	else
+		input_dev->name = "Atmel maXTouch Touchscreen";
+
+	snprintf(data->phys, sizeof(data->phys), "i2c-%u-%04x/input0",
+		 client->adapter->nr, client->addr);
+	input_dev->phys = data->phys;
+
+	input_dev->id.bustype = BUS_I2C;
+	input_dev->dev.parent = &client->dev;
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
+	if (data->aux_ampl)
+		input_set_abs_params(input_dev, ABS_PRESSURE,
+				     0, 255, 0, 0);
+
+	/* For multi touch */
+	error = input_mt_init_slots(input_dev, data->num_touchids, 0);
+	if (error)
+		goto err_free_mem;
+
+	input_set_abs_params(input_dev, ABS_MT_POSITION_X,
+			     0, data->max_x, 0, 0);
+	input_set_abs_params(input_dev, ABS_MT_POSITION_Y,
+			     0, data->max_y, 0, 0);
+
+	if (data->aux_area)
+		input_set_abs_params(input_dev, ABS_MT_TOUCH_MAJOR,
+				     0, MXT_MAX_AREA, 0, 0);
+
+	if (data->aux_ampl)
+		input_set_abs_params(input_dev, ABS_MT_PRESSURE,
+				     0, 255, 0, 0);
+
+	if (data->aux_vect)
+		input_set_abs_params(input_dev, ABS_MT_ORIENTATION,
+				     0, 255, 0, 0);
+
+	input_set_drvdata(input_dev, data);
+
+	error = input_register_device(input_dev);
+	if (error) {
+		dev_err(&client->dev, "Error %d registering input device\n",
+			error);
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
@@ -1771,6 +2045,26 @@ retry_probe:
 		return error;
 	}
 
+	if (data->T9_reportid_min) {
+		error = mxt_initialize_t9_input_device(data);
+		if (error) {
+			dev_err(&client->dev,
+				"error %d registering T9 input device\n",
+				error);
+			return error;
+		}
+	} else if (data->T100_reportid_min) {
+		error = mxt_initialize_t100_input_device(data);
+		if (error) {
+			dev_err(&client->dev,
+				"error %d registering T100 input device\n",
+				error);
+			return error;
+		}
+	} else {
+		dev_warn(&client->dev, "No touch object detected\n");
+	}
+
 	return 0;
 }
 
@@ -2305,13 +2599,6 @@ static int mxt_probe(struct i2c_client *client,
 	if (error)
 		goto err_free_mem;
 
-	error = mxt_initialize_t9_input_device(data);
-	if (error) {
-		dev_err(&client->dev, "Error %d registering input device\n",
-			error);
-		goto err_free_irq;
-	}
-
 	error = request_threaded_irq(client->irq, NULL, mxt_interrupt,
 				     pdata->irqflags | IRQF_ONESHOT,
 				     client->name, data);
@@ -2324,7 +2611,7 @@ static int mxt_probe(struct i2c_client *client,
 	if (error) {
 		dev_err(&client->dev, "Failure %d creating sysfs group\n",
 			error);
-		goto err_unregister_device;
+		goto err_free_irq;
 	}
 
 	sysfs_bin_attr_init(&data->mem_access_attr);
@@ -2344,9 +2631,6 @@ static int mxt_probe(struct i2c_client *client,
 
 err_remove_sysfs_group:
 	sysfs_remove_group(&client->dev.kobj, &mxt_attr_group);
-err_unregister_device:
-	input_unregister_device(data->input_dev);
-	data->input_dev = NULL;
 err_free_irq:
 	free_irq(client->irq, data);
 err_free_object:
@@ -2364,6 +2648,7 @@ static int mxt_remove(struct i2c_client *client)
 	sysfs_remove_group(&client->dev.kobj, &mxt_attr_group);
 	free_irq(data->irq, data);
 	input_unregister_device(data->input_dev);
+	data->input_dev = NULL;
 	regulator_put(data->reg_avdd);
 	regulator_put(data->reg_vdd);
 	mxt_free_object_table(data);
-- 
1.7.10.4

