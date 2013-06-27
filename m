Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab3F0NIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 09:08:47 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:5610 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752609Ab3F0Mue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:50:34 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 02/51] Input: atmel_mxt_ts - Improve T19 GPIO keys handling
Date: Thu, 27 Jun 2013 13:48:37 +0100
Message-Id: <1372337366-9286-3-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 * The mapping of the GPIO numbers into the T19 status byte varies between
   different maXTouch chips. Some have up to 7 GPIOs. Allowing a keycode array
   of up to 8 items is simpler and more generic. So replace #define with
   configurable number of keys which also allows the removal of is_tp.
 * Rename platform data parameters to include "t19" to prevent confusion with
   T15 key array.
 * Probe aborts early on when pdata is NULL, so no need to check.
 * Move "int i" to beginning of function (mixed declarations and code)
 * Use API calls rather than __set_bit()
 * Remove unused dev variable.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   44 ++++++++++++------------------
 drivers/platform/x86/chromeos_laptop.c   |   17 ++++++++----
 include/linux/i2c/atmel_mxt_ts.h         |    7 ++---
 3 files changed, 30 insertions(+), 38 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index e01a9ed..6702175 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -181,12 +181,6 @@
 
 #define MXT_FWRESET_TIME	175	/* msec */
 
-/* MXT_SPT_GPIOPWM_T19 field */
-#define MXT_GPIO0_MASK		0x04
-#define MXT_GPIO1_MASK		0x08
-#define MXT_GPIO2_MASK		0x10
-#define MXT_GPIO3_MASK		0x20
-
 /* Command to unlock bootloader */
 #define MXT_UNLOCK_CMD_MSB	0xaa
 #define MXT_UNLOCK_CMD_LSB	0xdc
@@ -251,7 +245,6 @@ struct mxt_data {
 	const struct mxt_platform_data *pdata;
 	struct mxt_object *object_table;
 	struct mxt_info info;
-	bool is_tp;
 
 	unsigned int irq;
 	unsigned int max_x;
@@ -516,15 +509,16 @@ static int mxt_write_object(struct mxt_data *data,
 static void mxt_input_button(struct mxt_data *data, struct mxt_message *message)
 {
 	struct input_dev *input = data->input_dev;
+	const struct mxt_platform_data *pdata = data->pdata;
 	bool button;
 	int i;
 
 	/* Active-low switch */
-	for (i = 0; i < MXT_NUM_GPIO; i++) {
-		if (data->pdata->key_map[i] == KEY_RESERVED)
+	for (i = 0; i < pdata->t19_num_keys; i++) {
+		if (pdata->t19_keymap[i] == KEY_RESERVED)
 			continue;
-		button = !(message->message[0] & MXT_GPIO0_MASK << i);
-		input_report_key(input, data->pdata->key_map[i], button);
+		button = !(message->message[0] & (1 << i));
+		input_report_key(input, pdata->t19_keymap[i], button);
 	}
 }
 
@@ -1085,6 +1079,8 @@ static int mxt_probe(struct i2c_client *client,
 	struct input_dev *input_dev;
 	int error;
 	unsigned int num_mt_slots;
+	unsigned int mt_flags = 0;
+	int i;
 
 	if (!pdata)
 		return -EINVAL;
@@ -1097,10 +1093,7 @@ static int mxt_probe(struct i2c_client *client,
 		goto err_free_mem;
 	}
 
-	data->is_tp = pdata && pdata->is_tp;
-
-	input_dev->name = (data->is_tp) ? "Atmel maXTouch Touchpad" :
-					  "Atmel maXTouch Touchscreen";
+	input_dev->name = "Atmel maXTouch Touchscreen";
 	snprintf(data->phys, sizeof(data->phys), "i2c-%u-%04x/input0",
 		 client->adapter->nr, client->addr);
 
@@ -1126,20 +1119,15 @@ static int mxt_probe(struct i2c_client *client,
 	__set_bit(EV_KEY, input_dev->evbit);
 	__set_bit(BTN_TOUCH, input_dev->keybit);
 
-	if (data->is_tp) {
-		int i;
-		__set_bit(INPUT_PROP_POINTER, input_dev->propbit);
+	if (pdata->t19_num_keys) {
 		__set_bit(INPUT_PROP_BUTTONPAD, input_dev->propbit);
 
-		for (i = 0; i < MXT_NUM_GPIO; i++)
-			if (pdata->key_map[i] != KEY_RESERVED)
-				__set_bit(pdata->key_map[i], input_dev->keybit);
+		for (i = 0; i < pdata->t19_num_keys; i++)
+			if (pdata->t19_keymap[i] != KEY_RESERVED)
+				input_set_capability(input_dev, EV_KEY,
+						     pdata->t19_keymap[i]);
 
-		__set_bit(BTN_TOOL_FINGER, input_dev->keybit);
-		__set_bit(BTN_TOOL_DOUBLETAP, input_dev->keybit);
-		__set_bit(BTN_TOOL_TRIPLETAP, input_dev->keybit);
-		__set_bit(BTN_TOOL_QUADTAP, input_dev->keybit);
-		__set_bit(BTN_TOOL_QUINTTAP, input_dev->keybit);
+		mt_flags |= INPUT_MT_POINTER;
 
 		input_abs_set_res(input_dev, ABS_X, MXT_PIXELS_PER_MM);
 		input_abs_set_res(input_dev, ABS_Y, MXT_PIXELS_PER_MM);
@@ -1147,6 +1135,8 @@ static int mxt_probe(struct i2c_client *client,
 				  MXT_PIXELS_PER_MM);
 		input_abs_set_res(input_dev, ABS_MT_POSITION_Y,
 				  MXT_PIXELS_PER_MM);
+
+		input_dev->name = "Atmel maXTouch Touchpad";
 	}
 
 	/* For single touch */
@@ -1159,7 +1149,7 @@ static int mxt_probe(struct i2c_client *client,
 
 	/* For multi touch */
 	num_mt_slots = data->T9_reportid_max - data->T9_reportid_min + 1;
-	error = input_mt_init_slots(input_dev, num_mt_slots, 0);
+	error = input_mt_init_slots(input_dev, num_mt_slots, mt_flags);
 	if (error)
 		goto err_free_object;
 	input_set_abs_params(input_dev, ABS_MT_TOUCH_MAJOR,
diff --git a/drivers/platform/x86/chromeos_laptop.c b/drivers/platform/x86/chromeos_laptop.c
index 78ed277..8026554 100644
--- a/drivers/platform/x86/chromeos_laptop.c
+++ b/drivers/platform/x86/chromeos_laptop.c
@@ -70,16 +70,22 @@ static struct i2c_board_info __initdata tsl2563_als_device = {
 	I2C_BOARD_INFO("tsl2563", TAOS_ALS_I2C_ADDR),
 };
 
+static int mxt_t19_keys[] = {
+	KEY_RESERVED,
+	KEY_RESERVED,
+	KEY_RESERVED,
+	KEY_RESERVED,
+	KEY_RESERVED,
+	BTN_LEFT
+};
+
 static struct mxt_platform_data atmel_224s_tp_platform_data = {
 	.x_size			= 102*20,
 	.y_size			= 68*20,
 	.orient			= MXT_VERTICAL_FLIP,
 	.irqflags		= IRQF_TRIGGER_FALLING,
-	.is_tp			= true,
-	.key_map		= { KEY_RESERVED,
-				    KEY_RESERVED,
-				    KEY_RESERVED,
-				    BTN_LEFT },
+	.t19_num_keys		= ARRAY_SIZE(mxt_t19_keys),
+	.t19_keymap		= mxt_t19_keys,
 	.config			= NULL,
 	.config_length		= 0,
 };
@@ -95,7 +101,6 @@ static struct mxt_platform_data atmel_1664s_platform_data = {
 	.y_size			= 2560,
 	.orient			= MXT_ROTATED_90_COUNTER,
 	.irqflags		= IRQF_TRIGGER_FALLING,
-	.is_tp			= false,
 	.config			= NULL,
 	.config_length		= 0,
 };
diff --git a/include/linux/i2c/atmel_mxt_ts.h b/include/linux/i2c/atmel_mxt_ts.h
index eff0cdc..d26080d 100644
--- a/include/linux/i2c/atmel_mxt_ts.h
+++ b/include/linux/i2c/atmel_mxt_ts.h
@@ -15,9 +15,6 @@
 
 #include <linux/types.h>
 
-/* For key_map array */
-#define MXT_NUM_GPIO		4
-
 /* Orient */
 #define MXT_NORMAL		0x0
 #define MXT_DIAGONAL		0x1
@@ -38,8 +35,8 @@ struct mxt_platform_data {
 	unsigned char orient;
 
 	unsigned long irqflags;
-	bool is_tp;
-	const unsigned int key_map[MXT_NUM_GPIO];
+	u8 t19_num_keys;
+	const unsigned int *t19_keymap;
 };
 
 #endif /* __LINUX_ATMEL_MXT_TS_H */
-- 
1.7.10.4

