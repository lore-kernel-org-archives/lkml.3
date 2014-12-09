Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbaLIUYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 15:24:46 -0500
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:6042 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752697AbaLIUYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 15:24:43 -0500
X-Greylist: delayed 501 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Dec 2014 15:24:42 EST
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Sekhar Nori <nsekhar@ti.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH] Input: atmel_mxt_ts - implement T100 touch object support
Date: Tue,  9 Dec 2014 20:16:07 +0000
Message-Id: <1418156167-11724-1-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the new T100 object which replaces the previous T9 multitouch
touchscreen object in recent maXTouch devices. T100 provides improved
reporting with selectable auxiliary information, and a type field for
hover/stylus/glove reporting.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Yufeng Shen <miletus@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 326 ++++++++++++++++++++++++++++++-
 1 file changed, 323 insertions(+), 3 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index bb07020..569346e 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -79,6 +79,7 @@
 #define MXT_SPT_DIGITIZER_T43		43
 #define MXT_SPT_MESSAGECOUNT_T44	44
 #define MXT_SPT_CTECONFIG_T46		46
+#define MXT_TOUCH_MULTITOUCHSCREEN_T100 100
 
 /* MXT_GEN_MESSAGE_T5 object */
 #define MXT_RPTID_NOMSG		0xff
@@ -188,6 +189,33 @@ struct t9_range {
 #define MXT_RESET_VALUE		0x01
 #define MXT_BACKUP_VALUE	0x55
 
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
+
+enum t100_type {
+	MXT_T100_TYPE_FINGER		= 1,
+	MXT_T100_TYPE_PASSIVE_STYLUS	= 2,
+	MXT_T100_TYPE_HOVERING_FINGER	= 4,
+	MXT_T100_TYPE_GLOVE		= 5,
+	MXT_T100_TYPE_LARGE_TOUCH	= 6,
+};
+
+#define MXT_TOUCH_MAJOR_DEFAULT	1
+#define MXT_PRESSURE_DEFAULT	1
+
 /* Delay times */
 #define MXT_BACKUP_TIME		50	/* msec */
 #define MXT_RESET_TIME		200	/* msec */
@@ -247,6 +275,9 @@ struct mxt_data {
 	unsigned int max_y;
 	bool in_bootloader;
 	u16 mem_size;
+	u8 t100_aux_ampl;
+	u8 t100_aux_area;
+	u8 t100_aux_vect;
 	u8 max_reportid;
 	u32 config_crc;
 	u32 info_crc;
@@ -268,6 +299,8 @@ struct mxt_data {
 	u8 T9_reportid_max;
 	u8 T19_reportid;
 	u16 T44_address;
+	u8 T100_reportid_min;
+	u8 T100_reportid_max;
 
 	/* for fw update in bootloader */
 	struct completion bl_completion;
@@ -761,6 +794,113 @@ static void mxt_proc_t9_message(struct mxt_data *data, u8 *message)
 	data->update_input = true;
 }
 
+static void mxt_proc_t100_message(struct mxt_data *data, u8 *message)
+{
+	struct device *dev = &data->client->dev;
+	struct input_dev *input_dev = data->input_dev;
+	int id;
+	u8 status;
+	u8 type;
+	int x;
+	int y;
+	int tool;
+	u8 major = 0;
+	u8 pressure = 0;
+	u8 orientation = 0;
+	bool active = false;
+	bool hover = false;
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
+	if (status & MXT_T100_DETECT) {
+		type = (status & MXT_T100_TYPE_MASK) >> 4;
+
+		switch (type) {
+		case MXT_T100_TYPE_HOVERING_FINGER:
+			hover = true;
+			/* fall through */
+		case MXT_T100_TYPE_FINGER:
+		case MXT_T100_TYPE_GLOVE:
+			active = true;
+			tool = MT_TOOL_FINGER;
+
+			if (data->t100_aux_area)
+				major = message[data->t100_aux_area];
+			if (data->t100_aux_ampl)
+				pressure = message[data->t100_aux_ampl];
+			if (data->t100_aux_vect)
+				orientation = message[data->t100_aux_vect];
+
+			break;
+
+		case MXT_T100_TYPE_PASSIVE_STYLUS:
+			active = true;
+			tool = MT_TOOL_PEN;
+
+			/* Passive stylus is reported with size zero so
+			 * hardcode */
+			major = MXT_TOUCH_MAJOR_DEFAULT;
+
+			if (data->t100_aux_ampl)
+				pressure = message[data->t100_aux_ampl];
+
+			break;
+
+		case MXT_T100_TYPE_LARGE_TOUCH:
+			/* Ignore suppressed touch */
+			break;
+
+		default:
+			dev_dbg(dev, "Unexpected T100 type\n");
+			return;
+		}
+	}
+
+	if (hover) {
+		pressure = 0;
+		major = 0;
+	} else if (active) {
+		/*
+		 * Values reported should be non-zero if tool is touching the
+		 * device
+		 */
+		if (pressure == 0)
+			pressure = MXT_PRESSURE_DEFAULT;
+
+		if (major == 0)
+			major = MXT_TOUCH_MAJOR_DEFAULT;
+	}
+
+	input_mt_slot(input_dev, id);
+
+	if (active) {
+		dev_dbg(dev, "[%u] type:%u x:%u y:%u a:%02X p:%02X v:%02X\n",
+			id, type, x, y, major, pressure, orientation);
+
+		input_mt_report_slot_state(input_dev, tool, 1);
+		input_report_abs(input_dev, ABS_MT_POSITION_X, x);
+		input_report_abs(input_dev, ABS_MT_POSITION_Y, y);
+		input_report_abs(input_dev, ABS_MT_TOUCH_MAJOR, major);
+		input_report_abs(input_dev, ABS_MT_PRESSURE, pressure);
+		input_report_abs(input_dev, ABS_MT_ORIENTATION, orientation);
+	} else {
+		dev_dbg(dev, "[%u] release\n", id);
+
+		/* close out slot */
+		input_mt_report_slot_state(input_dev, 0, 0);
+	}
+
+	data->update_input = true;
+}
+
 static int mxt_proc_message(struct mxt_data *data, u8 *message)
 {
 	u8 report_id = message[0];
@@ -779,6 +919,9 @@ static int mxt_proc_message(struct mxt_data *data, u8 *message)
 	} else if (report_id >= data->T9_reportid_min
 	    && report_id <= data->T9_reportid_max) {
 		mxt_proc_t9_message(data, message);
+	} else if (report_id >= data->T100_reportid_min
+	    && report_id <= data->T100_reportid_max) {
+		mxt_proc_t100_message(data, message);
 	} else if (report_id == data->T19_reportid) {
 		mxt_input_button(data, message);
 		data->update_input = true;
@@ -1401,6 +1544,8 @@ static void mxt_free_object_table(struct mxt_data *data)
 	data->T9_reportid_max = 0;
 	data->T19_reportid = 0;
 	data->T44_address = 0;
+	data->T100_reportid_min = 0;
+	data->T100_reportid_max = 0;
 	data->max_reportid = 0;
 }
 
@@ -1488,6 +1633,12 @@ static int mxt_get_object_table(struct mxt_data *data)
 		case MXT_SPT_GPIOPWM_T19:
 			data->T19_reportid = min_id;
 			break;
+		case MXT_TOUCH_MULTITOUCHSCREEN_T100:
+			data->T100_reportid_min = min_id;
+			data->T100_reportid_max = max_id;
+			/* first two report IDs reserved */
+			data->num_touchids = object->num_report_ids - 2;
+			break;
 		}
 
 		end_address = object->start_address
@@ -1668,6 +1819,167 @@ err_free_mem:
 	return error;
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
+	le16_to_cpus(&range_x);
+
+	error = __mxt_read_reg(client,
+			       object->start_address + MXT_T100_YRANGE,
+			       sizeof(range_y), &range_y);
+	if (error)
+		return error;
+
+	le16_to_cpus(&range_y);
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
+	dev_dbg(&client->dev,
+		"T100 aux mappings vect:%u ampl:%u area:%u\n",
+		data->t100_aux_vect, data->t100_aux_ampl, data->t100_aux_area);
+
+	dev_info(&client->dev,
+		 "T100 Touchscreen size X%uY%u\n", data->max_x, data->max_y);
+
+	return 0;
+}
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
 static int mxt_configure_objects(struct mxt_data *data,
 				 const struct firmware *cfg);
 
@@ -1815,9 +2127,17 @@ static int mxt_configure_objects(struct mxt_data *data,
 		return error;
 	}
 
-	error = mxt_initialize_t9_input_device(data);
-	if (error)
-		return error;
+	if (data->T9_reportid_min) {
+		error = mxt_initialize_t9_input_device(data);
+		if (error)
+			return error;
+	} else if (data->T100_reportid_min) {
+		error = mxt_initialize_t100_input_device(data);
+		if (error)
+			return error;
+	} else {
+		dev_warn(dev, "No touch object detected\n");
+	}
 
 	dev_info(dev,
 		 "Family: %u Variant: %u Firmware V%u.%u.%02X Objects: %u\n",
-- 
1.9.1

