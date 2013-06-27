Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab3F0NGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 09:06:05 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:62414 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752902Ab3F0Mug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:50:36 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 08/51] Input: atmel_mxt_ts - Initialise IRQ before probing
Date: Thu, 27 Jun 2013 13:48:43 +0100
Message-Id: <1372337366-9286-9-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows the interrupt handler to be used to detect CHG line during config
download. We need to make sure we do not report events if input device not yet
registered.

data->enable_reporting is checked in each of the possible message handling
function paths rather than higher up (such as at mxt_proc_message) because
some objects may be used for completions (T6).

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   73 +++++++++++++++++++++---------
 1 file changed, 51 insertions(+), 22 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 55d7667..1e24e54 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -2,6 +2,7 @@
  * Atmel maXTouch Touchscreen driver
  *
  * Copyright (C) 2010 Samsung Electronics Co.Ltd
+ * Copyright (C) 2011-2012 Atmel Corporation
  * Copyright (C) 2012 Google, Inc.
  *
  * Author: Joonyoung Shim <jy0922.shim@samsung.com>
@@ -261,6 +262,9 @@ struct mxt_data {
 
 	/* for fw update in bootloader */
 	struct completion bl_completion;
+
+	/* Enable reporting of input events */
+	bool enable_reporting;
 };
 
 static inline size_t mxt_obj_size(const struct mxt_object *obj)
@@ -568,6 +572,10 @@ static void mxt_input_button(struct mxt_data *data, struct mxt_message *message)
 	bool button;
 	int i;
 
+	/* do not report events if input device not yet registered */
+	if (!data->enable_reporting)
+		return;
+
 	/* Active-low switch */
 	for (i = 0; i < pdata->t19_num_keys; i++) {
 		if (pdata->t19_keymap[i] == KEY_RESERVED)
@@ -588,6 +596,10 @@ static void mxt_input_touchevent(struct mxt_data *data,
 	int area;
 	int pressure;
 
+	/* do not report events if input device not yet registered */
+	if (!data->enable_reporting)
+		return;
+
 	x = (message->message[1] << 4) | ((message->message[3] >> 4) & 0xf);
 	y = (message->message[2] << 4) | ((message->message[3] & 0xf));
 	if (data->max_x < 1024)
@@ -667,7 +679,7 @@ static irqreturn_t mxt_process_messages_until_invalid(struct mxt_data *data)
 		}
 	} while (reportid != 0xff);
 
-	if (update_input) {
+	if (data->enable_reporting && update_input) {
 		input_mt_report_pointer_emulation(data->input_dev, false);
 		input_sync(data->input_dev);
 	}
@@ -685,6 +697,9 @@ static irqreturn_t mxt_interrupt(int irq, void *dev_id)
 		return IRQ_HANDLED;
 	}
 
+	if (!data->object_table)
+		return IRQ_NONE;
+
 	return mxt_process_messages_until_invalid(data);
 }
 
@@ -746,6 +761,19 @@ static int mxt_make_highchg(struct mxt_data *data)
 	return 0;
 }
 
+static int mxt_acquire_irq(struct mxt_data *data)
+{
+	int error;
+
+	enable_irq(data->irq);
+
+	error = mxt_make_highchg(data);
+	if (error)
+		return error;
+
+	return 0;
+}
+
 static int mxt_get_info(struct mxt_data *data)
 {
 	struct i2c_client *client = data->client;
@@ -819,6 +847,7 @@ static void mxt_free_object_table(struct mxt_data *data)
 {
 	kfree(data->object_table);
 	data->object_table = NULL;
+	data->enable_reporting = false;
 	data->T6_reportid = 0;
 	data->T9_reportid_min = 0;
 	data->T9_reportid_max = 0;
@@ -849,6 +878,10 @@ static int mxt_initialize(struct mxt_data *data)
 	if (error)
 		goto err_free_object_table;
 
+	error = mxt_acquire_irq(data);
+	if (error)
+		goto err_free_object_table;
+
 	/* Check register init values */
 	error = mxt_check_reg_init(data);
 	if (error)
@@ -886,6 +919,8 @@ static int mxt_initialize(struct mxt_data *data)
 			info->matrix_xsize, info->matrix_ysize,
 			info->object_num);
 
+	data->enable_reporting = true;
+
 	return 0;
 
 err_free_object_table:
@@ -1087,11 +1122,7 @@ static ssize_t mxt_update_fw_store(struct device *dev,
 		dev_dbg(dev, "The firmware update succeeded\n");
 		mxt_free_object_table(data);
 
-		mxt_initialize(data);
-
-		enable_irq(data->irq);
-
-		error = mxt_make_highchg(data);
+		error = mxt_initialize(data);
 		if (error)
 			return error;
 	}
@@ -1188,9 +1219,19 @@ static int mxt_probe(struct i2c_client *client,
 
 	mxt_calc_resolution(data);
 
+	error = request_threaded_irq(client->irq, NULL, mxt_interrupt,
+				     pdata->irqflags | IRQF_ONESHOT,
+				     client->name, data);
+	if (error) {
+		dev_err(&client->dev, "Failed to register interrupt\n");
+		goto err_free_mem;
+	}
+
+	disable_irq(client->irq);
+
 	error = mxt_initialize(data);
 	if (error)
-		goto err_free_mem;
+		goto err_free_irq;
 
 	__set_bit(EV_ABS, input_dev->evbit);
 	__set_bit(EV_KEY, input_dev->evbit);
@@ -1241,21 +1282,9 @@ static int mxt_probe(struct i2c_client *client,
 	input_set_drvdata(input_dev, data);
 	i2c_set_clientdata(client, data);
 
-	error = request_threaded_irq(client->irq, NULL, mxt_interrupt,
-				     pdata->irqflags | IRQF_ONESHOT,
-				     client->name, data);
-	if (error) {
-		dev_err(&client->dev, "Failed to register interrupt\n");
-		goto err_free_object;
-	}
-
-	error = mxt_make_highchg(data);
-	if (error)
-		goto err_free_irq;
-
 	error = input_register_device(input_dev);
 	if (error)
-		goto err_free_irq;
+		goto err_free_object;
 
 	error = sysfs_create_group(&client->dev.kobj, &mxt_attr_group);
 	if (error)
@@ -1266,10 +1295,10 @@ static int mxt_probe(struct i2c_client *client,
 err_unregister_device:
 	input_unregister_device(input_dev);
 	input_dev = NULL;
-err_free_irq:
-	free_irq(client->irq, data);
 err_free_object:
 	kfree(data->object_table);
+err_free_irq:
+	free_irq(client->irq, data);
 err_free_mem:
 	input_free_device(input_dev);
 	kfree(data);
-- 
1.7.10.4

