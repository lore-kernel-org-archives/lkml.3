Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956AbaGCPJm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:09:42 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:28608 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758569AbaGCPIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:08:14 -0400
From: nick.dyer@itdev.co.uk
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Sekhar Nori <nsekhar@ti.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 02/15] Input: atmel_mxt_ts - move input device init into separate function
Date: Thu,  3 Jul 2014 16:01:24 +0100
Message-Id: <1404399697-26484-3-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404399697-26484-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1404399697-26484-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Dyer <nick.dyer@itdev.co.uk>

It is useful to initialise the input device later:
- Screen parameters may not be not known yet, for instance if waiting for
  firmware loader to return.
- Device may be in bootloader mode on probe (but could still be recovered by
  firmware download).

In addition, later devices have a different touchscreen object (T100) which
requires handling differently.

This also reduces the complexity of the probe function.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Yufeng Shen <miletus@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 191 +++++++++++++++++--------------
 1 file changed, 107 insertions(+), 84 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 02c374d..a248414 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -1047,6 +1047,9 @@ static int mxt_get_object_table(struct mxt_data *data)
 
 static void mxt_free_object_table(struct mxt_data *data)
 {
+	input_unregister_device(data->input_dev);
+	data->input_dev = NULL;
+
 	kfree(data->object_table);
 	data->object_table = NULL;
 	data->T6_reportid = 0;
@@ -1103,6 +1106,102 @@ static int mxt_read_t9_resolution(struct mxt_data *data)
 	return 0;
 }
 
+static int mxt_input_open(struct input_dev *dev);
+static void mxt_input_close(struct input_dev *dev);
+
+static int mxt_initialize_t9_input_device(struct mxt_data *data)
+{
+	struct device *dev = &data->client->dev;
+	const struct mxt_platform_data *pdata = data->pdata;
+	struct input_dev *input_dev;
+	int error;
+	unsigned int num_mt_slots;
+	unsigned int mt_flags = 0;
+	int i;
+
+	error = mxt_read_t9_resolution(data);
+	if (error)
+		dev_warn(dev, "Failed to initialize T9 resolution\n");
+
+	input_dev = input_allocate_device();
+	if (!input_dev) {
+		dev_err(dev, "Failed to allocate memory\n");
+		return -ENOMEM;
+	}
+
+	input_dev->name = "Atmel maXTouch Touchscreen";
+	input_dev->phys = data->phys;
+	input_dev->id.bustype = BUS_I2C;
+	input_dev->dev.parent = dev;
+	input_dev->open = mxt_input_open;
+	input_dev->close = mxt_input_close;
+
+	__set_bit(EV_ABS, input_dev->evbit);
+	__set_bit(EV_KEY, input_dev->evbit);
+	__set_bit(BTN_TOUCH, input_dev->keybit);
+
+	if (pdata->t19_num_keys) {
+		__set_bit(INPUT_PROP_BUTTONPAD, input_dev->propbit);
+
+		for (i = 0; i < pdata->t19_num_keys; i++)
+			if (pdata->t19_keymap[i] != KEY_RESERVED)
+				input_set_capability(input_dev, EV_KEY,
+						     pdata->t19_keymap[i]);
+
+		mt_flags |= INPUT_MT_POINTER;
+
+		input_abs_set_res(input_dev, ABS_X, MXT_PIXELS_PER_MM);
+		input_abs_set_res(input_dev, ABS_Y, MXT_PIXELS_PER_MM);
+		input_abs_set_res(input_dev, ABS_MT_POSITION_X,
+				  MXT_PIXELS_PER_MM);
+		input_abs_set_res(input_dev, ABS_MT_POSITION_Y,
+				  MXT_PIXELS_PER_MM);
+
+		input_dev->name = "Atmel maXTouch Touchpad";
+	}
+
+	/* For single touch */
+	input_set_abs_params(input_dev, ABS_X,
+			     0, data->max_x, 0, 0);
+	input_set_abs_params(input_dev, ABS_Y,
+			     0, data->max_y, 0, 0);
+	input_set_abs_params(input_dev, ABS_PRESSURE,
+			     0, 255, 0, 0);
+
+	/* For multi touch */
+	num_mt_slots = data->T9_reportid_max - data->T9_reportid_min + 1;
+	error = input_mt_init_slots(input_dev, num_mt_slots, mt_flags);
+	if (error) {
+		dev_err(dev, "Error %d initialising slots\n", error);
+		goto err_free_mem;
+	}
+
+	input_set_abs_params(input_dev, ABS_MT_TOUCH_MAJOR,
+			     0, MXT_MAX_AREA, 0, 0);
+	input_set_abs_params(input_dev, ABS_MT_POSITION_X,
+			     0, data->max_x, 0, 0);
+	input_set_abs_params(input_dev, ABS_MT_POSITION_Y,
+			     0, data->max_y, 0, 0);
+	input_set_abs_params(input_dev, ABS_MT_PRESSURE,
+			     0, 255, 0, 0);
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
 static int mxt_initialize(struct mxt_data *data)
 {
 	struct i2c_client *client = data->client;
@@ -1132,11 +1231,9 @@ static int mxt_initialize(struct mxt_data *data)
 		goto err_free_object_table;
 	}
 
-	error = mxt_read_t9_resolution(data);
-	if (error) {
-		dev_err(&client->dev, "Failed to initialize T9 resolution\n");
+	error = mxt_initialize_t9_input_device(data);
+	if (error)
 		goto err_free_object_table;
-	}
 
 	dev_info(&client->dev,
 		 "Family: %u Variant: %u Firmware V%u.%u.%02X Objects: %u\n",
@@ -1432,40 +1529,26 @@ static void mxt_input_close(struct input_dev *dev)
 static int mxt_probe(struct i2c_client *client,
 		const struct i2c_device_id *id)
 {
-	const struct mxt_platform_data *pdata = dev_get_platdata(&client->dev);
 	struct mxt_data *data;
-	struct input_dev *input_dev;
+	const struct mxt_platform_data *pdata = dev_get_platdata(&client->dev);
 	int error;
-	unsigned int num_mt_slots;
-	unsigned int mt_flags = 0;
-	int i;
 
 	if (!pdata)
 		return -EINVAL;
 
 	data = kzalloc(sizeof(struct mxt_data), GFP_KERNEL);
-	input_dev = input_allocate_device();
-	if (!data || !input_dev) {
+	if (!data) {
 		dev_err(&client->dev, "Failed to allocate memory\n");
-		error = -ENOMEM;
-		goto err_free_mem;
+		return -ENOMEM;
 	}
 
-	input_dev->name = "Atmel maXTouch Touchscreen";
 	snprintf(data->phys, sizeof(data->phys), "i2c-%u-%04x/input0",
 		 client->adapter->nr, client->addr);
 
-	input_dev->phys = data->phys;
-
-	input_dev->id.bustype = BUS_I2C;
-	input_dev->dev.parent = &client->dev;
-	input_dev->open = mxt_input_open;
-	input_dev->close = mxt_input_close;
-
 	data->client = client;
-	data->input_dev = input_dev;
 	data->pdata = pdata;
 	data->irq = client->irq;
+	i2c_set_clientdata(client, data);
 
 	init_completion(&data->bl_completion);
 	init_completion(&data->reset_completion);
@@ -1481,84 +1564,24 @@ static int mxt_probe(struct i2c_client *client,
 
 	disable_irq(client->irq);
 
-	error = input_register_device(input_dev);
-	if (error) {
-		dev_err(&client->dev, "Error %d registering input device\n",
-			error);
-		goto err_free_irq;
-	}
-
 	error = mxt_initialize(data);
 	if (error)
-		goto err_unregister_device;
-
-	__set_bit(EV_ABS, input_dev->evbit);
-	__set_bit(EV_KEY, input_dev->evbit);
-	__set_bit(BTN_TOUCH, input_dev->keybit);
-
-	if (pdata->t19_num_keys) {
-		__set_bit(INPUT_PROP_BUTTONPAD, input_dev->propbit);
-
-		for (i = 0; i < pdata->t19_num_keys; i++)
-			if (pdata->t19_keymap[i] != KEY_RESERVED)
-				input_set_capability(input_dev, EV_KEY,
-						     pdata->t19_keymap[i]);
-
-		mt_flags |= INPUT_MT_POINTER;
-
-		input_abs_set_res(input_dev, ABS_X, MXT_PIXELS_PER_MM);
-		input_abs_set_res(input_dev, ABS_Y, MXT_PIXELS_PER_MM);
-		input_abs_set_res(input_dev, ABS_MT_POSITION_X,
-				  MXT_PIXELS_PER_MM);
-		input_abs_set_res(input_dev, ABS_MT_POSITION_Y,
-				  MXT_PIXELS_PER_MM);
-
-		input_dev->name = "Atmel maXTouch Touchpad";
-	}
-
-	/* For single touch */
-	input_set_abs_params(input_dev, ABS_X,
-			     0, data->max_x, 0, 0);
-	input_set_abs_params(input_dev, ABS_Y,
-			     0, data->max_y, 0, 0);
-	input_set_abs_params(input_dev, ABS_PRESSURE,
-			     0, 255, 0, 0);
-
-	/* For multi touch */
-	num_mt_slots = data->T9_reportid_max - data->T9_reportid_min + 1;
-	error = input_mt_init_slots(input_dev, num_mt_slots, mt_flags);
-	if (error)
-		goto err_free_object;
-	input_set_abs_params(input_dev, ABS_MT_TOUCH_MAJOR,
-			     0, MXT_MAX_AREA, 0, 0);
-	input_set_abs_params(input_dev, ABS_MT_POSITION_X,
-			     0, data->max_x, 0, 0);
-	input_set_abs_params(input_dev, ABS_MT_POSITION_Y,
-			     0, data->max_y, 0, 0);
-	input_set_abs_params(input_dev, ABS_MT_PRESSURE,
-			     0, 255, 0, 0);
-
-	input_set_drvdata(input_dev, data);
-	i2c_set_clientdata(client, data);
+		goto err_free_irq;
 
 	error = sysfs_create_group(&client->dev.kobj, &mxt_attr_group);
 	if (error) {
 		dev_err(&client->dev, "Failure %d creating sysfs group\n",
 			error);
-		goto err_unregister_device;
+		goto err_free_object;
 	}
 
 	return 0;
 
-err_unregister_device:
-	input_unregister_device(input_dev);
-	input_dev = NULL;
 err_free_object:
 	kfree(data->object_table);
 err_free_irq:
 	free_irq(client->irq, data);
 err_free_mem:
-	input_free_device(input_dev);
 	kfree(data);
 	return error;
 }
-- 
2.0.1

