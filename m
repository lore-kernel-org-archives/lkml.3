Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab3CFHmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:42:11 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:51149 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab3CFHmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:42:04 -0500
From: Benson Leung <bleung@chromium.org>
To: olofj@chromium.org, miletus@chromium.org, dmitry.torokhov@gmail.com,
        matthew.garrett@nebula.com, rydberg@euromail.se, djkurtz@chromium.org,
        jy0922.shim@samsung.com, wfp5p@virginia.edu,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Cc: bleung@chromium.org, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH v2 1/2] Input: atmel_mxt_ts - add device id for touchpad variant
Date: Tue,  5 Mar 2013 23:41:46 -0800
Message-Id: <1362555707-24654-2-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1362555707-24654-1-git-send-email-bleung@chromium.org>
References: <1362187254-9227-1-git-send-email-bleung@chromium.org>
 <1362555707-24654-1-git-send-email-bleung@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Kurtz <djkurtz@chromium.org>

This same driver can be used by atmel based touchscreens and touchpads
(buttonpads) by instantiating the i2c device as a "atmel_mxt_tp".

This will cause the driver to perform some touchpad specific
initializations, such as:
  * register input device name "Atmel maXTouch Touchpad" instead of
  Touchscreen.
  * register BTN_LEFT & BTN_TOOL_* event types.
  * register axis resolution (as a fixed constant, for now)
  * register BUTTONPAD property
  * process GPIO buttons using reportid T19

For now, the left mouse button is mapped to GPIO3. Going forward,
platform data should specify the configuration of the buttons.
They can be configured via a future platform data change to
specify optional middle and right buttons, as well as other possible
uses for the GPIO object T19.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
Signed-off-by: Benson Leung <bleung@chromium.org>
Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Tested-by: Olof Johansson <olof@lixom.net>
---
v2: zero reportid in mxt_object_table_free(), Thanks nick.dyer@itdev.co.uk
v1: Initial
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 57 ++++++++++++++++++++++++++++++--
 1 file changed, 55 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index d04f810..3611a26 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -181,6 +181,12 @@
 
 #define MXT_FWRESET_TIME	175	/* msec */
 
+/* MXT_SPT_GPIOPWM_T19 field */
+#define MXT_GPIO0_MASK		0x04
+#define MXT_GPIO1_MASK		0x08
+#define MXT_GPIO2_MASK		0x10
+#define MXT_GPIO3_MASK		0x20
+
 /* Command to unlock bootloader */
 #define MXT_UNLOCK_CMD_MSB	0xaa
 #define MXT_UNLOCK_CMD_LSB	0xdc
@@ -212,6 +218,8 @@
 /* Touchscreen absolute values */
 #define MXT_MAX_AREA		0xff
 
+#define MXT_PIXELS_PER_MM	20
+
 struct mxt_info {
 	u8 family_id;
 	u8 variant_id;
@@ -243,6 +251,8 @@ struct mxt_data {
 	const struct mxt_platform_data *pdata;
 	struct mxt_object *object_table;
 	struct mxt_info info;
+	bool is_tp;
+
 	unsigned int irq;
 	unsigned int max_x;
 	unsigned int max_y;
@@ -251,6 +261,7 @@ struct mxt_data {
 	u8 T6_reportid;
 	u8 T9_reportid_min;
 	u8 T9_reportid_max;
+	u8 T19_reportid;
 };
 
 static bool mxt_object_readable(unsigned int type)
@@ -502,6 +513,18 @@ static int mxt_write_object(struct mxt_data *data,
 	return mxt_write_reg(data->client, reg + offset, val);
 }
 
+static void mxt_input_button(struct mxt_data *data, struct mxt_message *message)
+{
+	struct device *dev = &data->client->dev;
+	struct input_dev *input = data->input_dev;
+	bool button;
+
+	/* Active-low switch */
+	button = !(message->message[0] & MXT_GPIO3_MASK);
+	input_report_key(input, BTN_LEFT, button);
+	dev_dbg(dev, "Button state: %d\n", button);
+}
+
 static void mxt_input_touchevent(struct mxt_data *data,
 				      struct mxt_message *message, int id)
 {
@@ -585,6 +608,9 @@ static irqreturn_t mxt_interrupt(int irq, void *dev_id)
 			int id = reportid - data->T9_reportid_min;
 			mxt_input_touchevent(data, &message, id);
 			update_input = true;
+		} else if (message.reportid == data->T19_reportid) {
+			mxt_input_button(data, &message);
+			update_input = true;
 		} else {
 			mxt_dump_message(dev, &message);
 		}
@@ -764,6 +790,9 @@ static int mxt_get_object_table(struct mxt_data *data)
 			data->T9_reportid_min = min_id;
 			data->T9_reportid_max = max_id;
 			break;
+		case MXT_SPT_GPIOPWM_T19:
+			data->T19_reportid = min_id;
+			break;
 		}
 	}
 
@@ -777,7 +806,7 @@ static void mxt_free_object_table(struct mxt_data *data)
 	data->T6_reportid = 0;
 	data->T9_reportid_min = 0;
 	data->T9_reportid_max = 0;
-
+	data->T19_reportid = 0;
 }
 
 static int mxt_initialize(struct mxt_data *data)
@@ -1115,9 +1144,13 @@ static int mxt_probe(struct i2c_client *client,
 		goto err_free_mem;
 	}
 
-	input_dev->name = "Atmel maXTouch Touchscreen";
+	data->is_tp = !strcmp(id->name, "atmel_mxt_tp");
+
+	input_dev->name = (data->is_tp) ? "Atmel maXTouch Touchpad" :
+					  "Atmel maXTouch Touchscreen";
 	snprintf(data->phys, sizeof(data->phys), "i2c-%u-%04x/input0",
 		 client->adapter->nr, client->addr);
+
 	input_dev->phys = data->phys;
 
 	input_dev->id.bustype = BUS_I2C;
@@ -1140,6 +1173,25 @@ static int mxt_probe(struct i2c_client *client,
 	__set_bit(EV_KEY, input_dev->evbit);
 	__set_bit(BTN_TOUCH, input_dev->keybit);
 
+	if (data->is_tp) {
+		__set_bit(INPUT_PROP_POINTER, input_dev->propbit);
+		__set_bit(INPUT_PROP_BUTTONPAD, input_dev->propbit);
+
+		__set_bit(BTN_LEFT, input_dev->keybit);
+		__set_bit(BTN_TOOL_FINGER, input_dev->keybit);
+		__set_bit(BTN_TOOL_DOUBLETAP, input_dev->keybit);
+		__set_bit(BTN_TOOL_TRIPLETAP, input_dev->keybit);
+		__set_bit(BTN_TOOL_QUADTAP, input_dev->keybit);
+		__set_bit(BTN_TOOL_QUINTTAP, input_dev->keybit);
+
+		input_abs_set_res(input_dev, ABS_X, MXT_PIXELS_PER_MM);
+		input_abs_set_res(input_dev, ABS_Y, MXT_PIXELS_PER_MM);
+		input_abs_set_res(input_dev, ABS_MT_POSITION_X,
+				  MXT_PIXELS_PER_MM);
+		input_abs_set_res(input_dev, ABS_MT_POSITION_Y,
+				  MXT_PIXELS_PER_MM);
+	}
+
 	/* For single touch */
 	input_set_abs_params(input_dev, ABS_X,
 			     0, data->max_x, 0, 0);
@@ -1258,6 +1310,7 @@ static SIMPLE_DEV_PM_OPS(mxt_pm_ops, mxt_suspend, mxt_resume);
 static const struct i2c_device_id mxt_id[] = {
 	{ "qt602240_ts", 0 },
 	{ "atmel_mxt_ts", 0 },
+	{ "atmel_mxt_tp", 0 },
 	{ "mXT224", 0 },
 	{ }
 };
-- 
1.8.1.3

