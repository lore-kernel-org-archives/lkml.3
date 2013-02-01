Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab3BAIMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 03:12:23 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:48538 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902Ab3BAIMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 03:12:09 -0500
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, olofj@chromium.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 02/10] Input: atmel_mxt_ts - register input device before request_irq
Date: Fri,  1 Feb 2013 16:11:44 +0800
Message-Id: <1359706312-24642-3-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359706312-24642-1-git-send-email-djkurtz@chromium.org>
References: <1359706312-24642-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As soon as the irq is request, input event interrupts could occur that
the isr should handle.  Similarly, if there are input events queued up
in the device output buffer, it will send them immediately when we
drain the message buffer with mxt_handle_messages.

Therefore, register the input device before enabling the irq (or handling
messages).

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index a222bd8..84f0408 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -1124,8 +1124,13 @@ static int mxt_probe(struct i2c_client *client,
 		return -EINVAL;
 
 	data = kzalloc(sizeof(struct mxt_data), GFP_KERNEL);
+	if (!data) {
+		dev_err(&client->dev, "Failed to allocate memory\n");
+		return -ENOMEM;
+	}
+
 	input_dev = input_allocate_device();
-	if (!data || !input_dev) {
+	if (!input_dev) {
 		dev_err(&client->dev, "Failed to allocate memory\n");
 		error = -ENOMEM;
 		goto err_free_mem;
@@ -1167,8 +1172,11 @@ static int mxt_probe(struct i2c_client *client,
 	/* For multi touch */
 	num_mt_slots = data->T9_reportid_max - data->T9_reportid_min + 1;
 	error = input_mt_init_slots(input_dev, num_mt_slots, 0);
-	if (error)
+	if (error) {
+		input_free_device(input_dev);
 		goto err_free_object;
+	}
+
 	input_set_abs_params(input_dev, ABS_MT_TOUCH_MAJOR,
 			     0, MXT_MAX_AREA, 0, 0);
 	input_set_abs_params(input_dev, ABS_MT_POSITION_X,
@@ -1181,37 +1189,37 @@ static int mxt_probe(struct i2c_client *client,
 	input_set_drvdata(input_dev, data);
 	i2c_set_clientdata(client, data);
 
+	error = input_register_device(input_dev);
+	if (error) {
+		input_free_device(input_dev);
+		goto err_free_object;
+	}
+
 	error = request_threaded_irq(client->irq, NULL, mxt_interrupt,
 				     pdata->irqflags | IRQF_ONESHOT,
 				     client->name, data);
 	if (error) {
 		dev_err(&client->dev, "Failed to register interrupt\n");
-		goto err_free_object;
+		goto err_unregister_device;
 	}
 
 	error = mxt_make_highchg(data);
 	if (error)
 		goto err_free_irq;
 
-	error = input_register_device(input_dev);
-	if (error)
-		goto err_free_irq;
-
 	error = sysfs_create_group(&client->dev.kobj, &mxt_attr_group);
 	if (error)
-		goto err_unregister_device;
+		goto err_free_irq;
 
 	return 0;
 
-err_unregister_device:
-	input_unregister_device(input_dev);
-	input_dev = NULL;
 err_free_irq:
 	free_irq(client->irq, data);
+err_unregister_device:
+	input_unregister_device(data->input_dev);
 err_free_object:
 	kfree(data->object_table);
 err_free_mem:
-	input_free_device(input_dev);
 	kfree(data);
 	return error;
 }
-- 
1.8.1

