Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab3IQDUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 23:20:49 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:54695 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab3IQDUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 23:20:47 -0400
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: nick.dyer@itdev.co.uk, dmitry.torokhov@gmail.com, josh.wu@atmel.com
Subject: [PATCH V2] Input: atmel_mxt_ts - update to devm_* API
Date: Tue, 17 Sep 2013 08:50:49 +0530
Message-Id: <1379388049-4641-1-git-send-email-badarkhe.manish@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the code to use devm_* API so that driver core will manage
resources.

Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>
---
Changes since V1:
As per Dmitry's comment, avoid "devm_" operation on irq as it may cause
kernel crash while device is getting unbound and CCing Nick dryer.

:100644 100644 59aa240... d04dbed... M	drivers/input/touchscreen/atmel_mxt_ts.c
 drivers/input/touchscreen/atmel_mxt_ts.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 59aa240..d04dbed 100644
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
@@ -1253,9 +1253,7 @@ err_free_irq:
 	free_irq(client->irq, data);
 err_free_object:
 	kfree(data->object_table);
-err_free_mem:
-	input_free_device(input_dev);
-	kfree(data);
+err_out:
 	return error;
 }
 
@@ -1267,7 +1265,6 @@ static int mxt_remove(struct i2c_client *client)
 	free_irq(data->irq, data);
 	input_unregister_device(data->input_dev);
 	kfree(data->object_table);
-	kfree(data);
 
 	return 0;
 }
-- 
1.7.10.4

