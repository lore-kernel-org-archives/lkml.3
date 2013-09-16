Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668Ab3IPOuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 10:50:16 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:56265 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab3IPOuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 10:50:14 -0400
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: josh.wu@atmel.com, dmitry.torokhov@gmail.com, badarkhe.manish@gmail.com
Subject: [PATCH] Input: atmel_mxt_ts - update to devm_* API
Date: Mon, 16 Sep 2013 20:20:16 +0530
Message-Id: <1379343016-6354-1-git-send-email-badarkhe.manish@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the code to use devm_* API so that driver core will manage
resources.

Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>
---
This is just clean up of code to manage resources using "devm_" 
funtions. Not tested on hardware.

:100644 100644 59aa240... 73c5ad0... M	drivers/input/touchscreen/atmel_mxt_ts.c
 drivers/input/touchscreen/atmel_mxt_ts.c |   27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 59aa240..73c5ad0 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -1139,12 +1139,12 @@ static int mxt_probe(struct i2c_client *client,
 	if (!pdata)
 		return -EINVAL;
 
-	data = kzalloc(sizeof(struct mxt_data), GFP_KERNEL);
-	input_dev = input_allocate_device();
+	data = devm_kzalloc(&client->dev, sizeof(struct mxt_data), GFP_KERNEL);
+	input_dev = devm_input_allocate_device(&client->dev);
 	if (!data || !input_dev) {
 		dev_err(&client->dev, "Failed to allocate memory\n");
 		error = -ENOMEM;
-		goto err_free_mem;
+		goto err_out;
 	}
 
 	data->is_tp = pdata && pdata->is_tp;
@@ -1170,7 +1170,7 @@ static int mxt_probe(struct i2c_client *client,
 
 	error = mxt_initialize(data);
 	if (error)
-		goto err_free_mem;
+		goto err_out;
 
 	__set_bit(EV_ABS, input_dev->evbit);
 	__set_bit(EV_KEY, input_dev->evbit);
@@ -1224,9 +1224,10 @@ static int mxt_probe(struct i2c_client *client,
 	input_set_drvdata(input_dev, data);
 	i2c_set_clientdata(client, data);
 
-	error = request_threaded_irq(client->irq, NULL, mxt_interrupt,
-				     pdata->irqflags | IRQF_ONESHOT,
-				     client->name, data);
+	error = devm_request_threaded_irq(&client->dev,
+				client->irq, NULL, mxt_interrupt,
+				pdata->irqflags | IRQF_ONESHOT,
+				client->name, data);
 	if (error) {
 		dev_err(&client->dev, "Failed to register interrupt\n");
 		goto err_free_object;
@@ -1234,11 +1235,11 @@ static int mxt_probe(struct i2c_client *client,
 
 	error = mxt_make_highchg(data);
 	if (error)
-		goto err_free_irq;
+		goto err_free_object;
 
 	error = input_register_device(input_dev);
 	if (error)
-		goto err_free_irq;
+		goto err_free_object;
 
 	error = sysfs_create_group(&client->dev.kobj, &mxt_attr_group);
 	if (error)
@@ -1249,13 +1250,9 @@ static int mxt_probe(struct i2c_client *client,
 err_unregister_device:
 	input_unregister_device(input_dev);
 	input_dev = NULL;
-err_free_irq:
-	free_irq(client->irq, data);
 err_free_object:
 	kfree(data->object_table);
-err_free_mem:
-	input_free_device(input_dev);
-	kfree(data);
+err_out:
 	return error;
 }
 
@@ -1264,10 +1261,8 @@ static int mxt_remove(struct i2c_client *client)
 	struct mxt_data *data = i2c_get_clientdata(client);
 
 	sysfs_remove_group(&client->dev.kobj, &mxt_attr_group);
-	free_irq(data->irq, data);
 	input_unregister_device(data->input_dev);
 	kfree(data->object_table);
-	kfree(data);
 
 	return 0;
 }
-- 
1.7.10.4

