Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab3F0Mux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 08:50:53 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:40495 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753595Ab3F0Muv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:50:51 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 39/51] Input: atmel_mxt_ts - Implement T63 Active Stylus support
Date: Thu, 27 Jun 2013 13:49:14 +0100
Message-Id: <1372337366-9286-40-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   95 +++++++++++++++++++++++++++++-
 1 file changed, 94 insertions(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index b63f227..2e6118a 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -78,6 +78,7 @@
 #define MXT_SPT_DIGITIZER_T43		43
 #define MXT_SPT_MESSAGECOUNT_T44	44
 #define MXT_SPT_CTECONFIG_T46		46
+#define MXT_PROCI_ACTIVE_STYLUS_T63	63
 
 /* MXT_GEN_MESSAGE_T5 object */
 #define MXT_RPTID_NOMSG		0xff
@@ -190,6 +191,19 @@ struct t9_range {
 /* Define for MXT_PROCI_TOUCHSUPPRESSION_T42 */
 #define MXT_T42_MSG_TCHSUP	(1 << 0)
 
+/* T63 Stylus */
+#define MXT_T63_STYLUS_PRESS	(1 << 0)
+#define MXT_T63_STYLUS_RELEASE	(1 << 1)
+#define MXT_T63_STYLUS_MOVE		(1 << 2)
+#define MXT_T63_STYLUS_SUPPRESS	(1 << 3)
+
+#define MXT_T63_STYLUS_DETECT	(1 << 4)
+#define MXT_T63_STYLUS_TIP		(1 << 5)
+#define MXT_T63_STYLUS_ERASER	(1 << 6)
+#define MXT_T63_STYLUS_BARREL	(1 << 7)
+
+#define MXT_T63_STYLUS_PRESSURE_MASK	0x3F
+
 /* Delay times */
 #define MXT_BACKUP_TIME		50	/* msec */
 #define MXT_RESET_TIME		200	/* msec */
@@ -260,6 +274,7 @@ struct mxt_data {
 	bool update_input;
 	u8 last_message_count;
 	u8 num_touchids;
+	u8 num_stylusids;
 
 	/* Cached parameters from object table */
 	u16 T5_address;
@@ -274,6 +289,8 @@ struct mxt_data {
 	u8 T42_reportid_max;
 	u16 T44_address;
 	u8 T48_reportid;
+	u8 T63_reportid_min;
+	u8 T63_reportid_max;
 
 	/* for fw update in bootloader */
 	struct completion bl_completion;
@@ -823,6 +840,63 @@ static int mxt_proc_t48_messages(struct mxt_data *data, u8 *msg)
 	return 0;
 }
 
+static void mxt_proc_t63_messages(struct mxt_data *data, u8 *msg)
+{
+	struct device *dev = &data->client->dev;
+	struct input_dev *input_dev = data->input_dev;
+	u8 id;
+	u16 x, y;
+	u8 pressure;
+
+	/* do not report events if input device not yet registered */
+	if (!data->enable_reporting)
+		return;
+
+	/* stylus slots come after touch slots */
+	id = data->num_touchids + (msg[0] - data->T63_reportid_min);
+
+	if (id < 0 || id > (data->num_touchids + data->num_stylusids)) {
+		dev_err(dev, "invalid stylus id %d, max slot is %d\n",
+			id, data->num_stylusids);
+		return;
+	}
+
+	x = msg[3] | (msg[4] << 8);
+	y = msg[5] | (msg[6] << 8);
+	pressure = msg[7] & MXT_T63_STYLUS_PRESSURE_MASK;
+
+	dev_dbg(dev,
+		"[%d] %c%c%c%c x: %d y: %d pressure: %d stylus:%c%c%c%c\n",
+		id,
+		(msg[1] & MXT_T63_STYLUS_SUPPRESS) ? 'S' : '.',
+		(msg[1] & MXT_T63_STYLUS_MOVE)     ? 'M' : '.',
+		(msg[1] & MXT_T63_STYLUS_RELEASE)  ? 'R' : '.',
+		(msg[1] & MXT_T63_STYLUS_PRESS)    ? 'P' : '.',
+		x, y, pressure,
+		(msg[2] & MXT_T63_STYLUS_BARREL) ? 'B' : '.',
+		(msg[2] & MXT_T63_STYLUS_ERASER) ? 'E' : '.',
+		(msg[2] & MXT_T63_STYLUS_TIP)    ? 'T' : '.',
+		(msg[2] & MXT_T63_STYLUS_DETECT) ? 'D' : '.');
+
+	input_mt_slot(input_dev, id);
+
+	if (msg[2] & MXT_T63_STYLUS_DETECT) {
+		input_mt_report_slot_state(input_dev, MT_TOOL_PEN, 1);
+		input_report_abs(input_dev, ABS_MT_POSITION_X, x);
+		input_report_abs(input_dev, ABS_MT_POSITION_Y, y);
+		input_report_abs(input_dev, ABS_MT_PRESSURE, pressure);
+	} else {
+		input_mt_report_slot_state(input_dev, MT_TOOL_PEN, 0);
+	}
+
+	input_report_key(input_dev, BTN_STYLUS,
+			 (msg[2] & MXT_T63_STYLUS_ERASER));
+	input_report_key(input_dev, BTN_STYLUS2,
+			 (msg[2] & MXT_T63_STYLUS_BARREL));
+
+	mxt_input_sync(input_dev);
+}
+
 static int mxt_proc_message(struct mxt_data *data, u8 *message)
 {
 	u8 report_id = message[0];
@@ -838,6 +912,9 @@ static int mxt_proc_message(struct mxt_data *data, u8 *message)
 	} else if (report_id == data->T19_reportid) {
 		mxt_input_button(data, message);
 		data->update_input = true;
+	} else if (report_id >= data->T63_reportid_min
+		   && report_id <= data->T63_reportid_max) {
+		mxt_proc_t63_messages(data, message);
 	} else if (report_id >= data->T42_reportid_min
 		   && report_id <= data->T42_reportid_max) {
 		mxt_proc_t42_messages(data, message);
@@ -1483,6 +1560,8 @@ static void mxt_free_object_table(struct mxt_data *data)
 	data->T42_reportid_max = 0;
 	data->T44_address = 0;
 	data->T48_reportid = 0;
+	data->T63_reportid_min = 0;
+	data->T63_reportid_max = 0;
 	data->max_reportid = 0;
 }
 
@@ -1563,6 +1642,12 @@ static int mxt_get_object_table(struct mxt_data *data)
 		case MXT_PROCG_NOISESUPPRESSION_T48:
 			data->T48_reportid = min_id;
 			break;
+		case MXT_PROCI_ACTIVE_STYLUS_T63:
+			data->T63_reportid_min = min_id;
+			data->T63_reportid_max = max_id;
+			data->num_stylusids = object->num_report_ids
+						* mxt_obj_instances(object);
+			break;
 		}
 
 		end_address = object->start_address
@@ -2103,7 +2188,7 @@ static int mxt_initialize_t9_input_device(struct mxt_data *data)
 			     0, 255, 0, 0);
 
 	/* For multi touch */
-	num_mt_slots = data->T9_reportid_max - data->T9_reportid_min + 1;
+	num_mt_slots = data->num_touchids + data->num_stylusids;
 	error = input_mt_init_slots(input_dev, num_mt_slots, mt_flags);
 	if (error) {
 		dev_err(dev, "Error %d initialising slots\n", error);
@@ -2121,6 +2206,14 @@ static int mxt_initialize_t9_input_device(struct mxt_data *data)
 	input_set_abs_params(input_dev, ABS_MT_ORIENTATION,
 			     0, 255, 0, 0);
 
+	/* For T63 active stylus */
+	if (data->T63_reportid_min) {
+		input_set_capability(input_dev, EV_KEY, BTN_STYLUS);
+		input_set_capability(input_dev, EV_KEY, BTN_STYLUS2);
+		input_set_abs_params(input_dev, ABS_MT_TOOL_TYPE,
+			0, MT_TOOL_MAX, 0, 0);
+	}
+
 	input_set_drvdata(input_dev, data);
 
 	error = input_register_device(input_dev);
-- 
1.7.10.4

