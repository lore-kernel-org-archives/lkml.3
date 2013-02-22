Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250Ab3BVSJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:09:49 -0500
Received: from [89.21.227.133] ([89.21.227.133]:8821 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759076Ab3BVSIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:08:37 -0500
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 16/40] Input: atmel_mxt_ts - Move input device configuration into separate function
Date: Fri, 22 Feb 2013 17:58:03 +0000
Message-Id: <1361555907-19840-17-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   83 +++++++++++++++++++-----------
 1 file changed, 53 insertions(+), 30 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 335fa1b..b7e5646 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -1681,28 +1681,19 @@ static void mxt_input_close(struct input_dev *dev)
 	mxt_stop(data);
 }
 
-static int mxt_probe(struct i2c_client *client,
-		const struct i2c_device_id *id)
+static int mxt_initialize_t9_input_device(struct mxt_data *data)
 {
-	const struct mxt_platform_data *pdata = client->dev.platform_data;
-	struct mxt_data *data;
+	struct i2c_client *client = data->client;
 	struct input_dev *input_dev;
 	int error;
 	unsigned int num_mt_slots;
 
-	if (!pdata)
-		return -EINVAL;
-
-	data = kzalloc(sizeof(struct mxt_data), GFP_KERNEL);
 	input_dev = input_allocate_device();
-	if (!data || !input_dev) {
+	if (!input_dev) {
 		dev_err(&client->dev, "Failed to allocate memory\n");
-		error = -ENOMEM;
-		goto err_free_mem;
+		return -ENOMEM;
 	}
 
-	data->state = INIT;
-
 	input_dev->name = "Atmel maXTouch Touchscreen";
 	snprintf(data->phys, sizeof(data->phys), "i2c-%u-%04x/input0",
 		 client->adapter->nr, client->addr);
@@ -1713,18 +1704,8 @@ static int mxt_probe(struct i2c_client *client,
 	input_dev->open = mxt_input_open;
 	input_dev->close = mxt_input_close;
 
-	data->client = client;
-	data->input_dev = input_dev;
-	data->pdata = pdata;
-	data->irq = client->irq;
-
-	error = mxt_initialize(data);
-	if (error)
-		goto err_free_mem;
-
-	__set_bit(EV_ABS, input_dev->evbit);
-	__set_bit(EV_KEY, input_dev->evbit);
-	__set_bit(BTN_TOUCH, input_dev->keybit);
+	set_bit(EV_ABS, input_dev->evbit);
+	input_set_capability(input_dev, EV_KEY, BTN_TOUCH);
 
 	/* For single touch */
 	input_set_abs_params(input_dev, ABS_X,
@@ -1738,7 +1719,8 @@ static int mxt_probe(struct i2c_client *client,
 	num_mt_slots = data->T9_reportid_max - data->T9_reportid_min + 1;
 	error = input_mt_init_slots(input_dev, num_mt_slots, 0);
 	if (error)
-		goto err_free_object;
+		goto err_free_mem;
+
 	input_set_abs_params(input_dev, ABS_MT_TOUCH_MAJOR,
 			     0, MXT_MAX_AREA, 0, 0);
 	input_set_abs_params(input_dev, ABS_MT_POSITION_X,
@@ -1749,8 +1731,50 @@ static int mxt_probe(struct i2c_client *client,
 			     0, 255, 0, 0);
 
 	input_set_drvdata(input_dev, data);
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
+static int mxt_probe(struct i2c_client *client,
+		const struct i2c_device_id *id)
+{
+	const struct mxt_platform_data *pdata = client->dev.platform_data;
+	struct mxt_data *data;
+	int error;
+
+	if (!pdata)
+		return -EINVAL;
+
+	data = kzalloc(sizeof(struct mxt_data), GFP_KERNEL);
+	if (!data) {
+		dev_err(&client->dev, "Failed to allocate memory\n");
+		return -ENOMEM;
+	}
+
+	data->state = INIT;
+
+	data->client = client;
+	data->pdata = pdata;
+	data->irq = client->irq;
 	i2c_set_clientdata(client, data);
 
+	error = mxt_initialize(data);
+	if (error)
+		goto err_free_mem;
+
 	error = request_threaded_irq(client->irq, NULL, mxt_interrupt,
 				     pdata->irqflags | IRQF_ONESHOT,
 				     client->name, data);
@@ -1765,7 +1789,7 @@ static int mxt_probe(struct i2c_client *client,
 			goto err_free_irq;
 	}
 
-	error = input_register_device(input_dev);
+	error = mxt_initialize_t9_input_device(data);
 	if (error) {
 		dev_err(&client->dev, "Error %d registering input device\n",
 			error);
@@ -1797,14 +1821,13 @@ static int mxt_probe(struct i2c_client *client,
 err_remove_sysfs_group:
 	sysfs_remove_group(&client->dev.kobj, &mxt_attr_group);
 err_unregister_device:
-	input_unregister_device(input_dev);
-	input_dev = NULL;
+	input_unregister_device(data->input_dev);
+	data->input_dev = NULL;
 err_free_irq:
 	free_irq(client->irq, data);
 err_free_object:
 	kfree(data->object_table);
 err_free_mem:
-	input_free_device(input_dev);
 	kfree(data);
 	return error;
 }
-- 
1.7.10.4

