Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab3F0NCc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 09:02:32 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:62414 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753408Ab3F0Mum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:50:42 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>,
        Yufeng Shen <miletus@chromium.org>, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 20/51] Input: atmel_mxt_ts - Set default irqflags when there is no pdata
Date: Thu, 27 Jun 2013 13:48:55 +0100
Message-Id: <1372337366-9286-21-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yufeng Shen <miletus@chromium.org>

This is the preparation for supporting the code path when there is
platform data provided and still boot the device into a sane state
with backup NVRAM config.

Make the irqflags default to be IRQF_TRIGGER_FALLING if no platform data is
provided.

Signed-off-by: Yufeng Shen <miletus@chromium.org>
Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   54 +++++++++++++++++++++---------
 1 file changed, 39 insertions(+), 15 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 1334e5b..2645d36 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -232,7 +232,7 @@ struct mxt_data {
 	struct i2c_client *client;
 	struct input_dev *input_dev;
 	char phys[64];		/* device physical location */
-	const struct mxt_platform_data *pdata;
+	struct mxt_platform_data *pdata;
 	struct mxt_object *object_table;
 	struct mxt_info info;
 	unsigned int irq;
@@ -1640,10 +1640,29 @@ static void mxt_input_close(struct input_dev *dev)
 	mxt_stop(data);
 }
 
+static int mxt_handle_pdata(struct mxt_data *data)
+{
+	data->pdata = dev_get_platdata(&data->client->dev);
+
+	/* Use provided platform data if present */
+	if (data->pdata)
+		return 0;
+
+	data->pdata = kzalloc(sizeof(*data->pdata), GFP_KERNEL);
+	if (!data->pdata) {
+		dev_err(&data->client->dev, "Failed to allocate pdata\n");
+		return -ENOMEM;
+	}
+
+	/* Set default parameters */
+	data->pdata->irqflags = IRQF_TRIGGER_FALLING;
+
+	return 0;
+}
+
 static int mxt_probe(struct i2c_client *client,
 		const struct i2c_device_id *id)
 {
-	const struct mxt_platform_data *pdata = client->dev.platform_data;
 	struct mxt_data *data;
 	struct input_dev *input_dev;
 	int error;
@@ -1651,9 +1670,6 @@ static int mxt_probe(struct i2c_client *client,
 	unsigned int mt_flags = 0;
 	int i;
 
-	if (!pdata)
-		return -EINVAL;
-
 	data = kzalloc(sizeof(struct mxt_data), GFP_KERNEL);
 	input_dev = input_allocate_device();
 	if (!data || !input_dev) {
@@ -1675,19 +1691,23 @@ static int mxt_probe(struct i2c_client *client,
 
 	data->client = client;
 	data->input_dev = input_dev;
-	data->pdata = pdata;
 	data->irq = client->irq;
+	i2c_set_clientdata(client, data);
+
+	error = mxt_handle_pdata(data);
+	if (error)
+		goto err_free_mem;
 
 	init_completion(&data->bl_completion);
 	init_completion(&data->reset_completion);
 	init_completion(&data->crc_completion);
 
-	error = request_threaded_irq(client->irq, NULL, mxt_interrupt,
-				     pdata->irqflags | IRQF_ONESHOT,
+	error = request_threaded_irq(data->irq, NULL, mxt_interrupt,
+				     data->pdata->irqflags | IRQF_ONESHOT,
 				     client->name, data);
 	if (error) {
 		dev_err(&client->dev, "Failed to register interrupt\n");
-		goto err_free_mem;
+		goto err_free_pdata;
 	}
 
 	disable_irq(client->irq);
@@ -1700,13 +1720,13 @@ static int mxt_probe(struct i2c_client *client,
 	__set_bit(EV_KEY, input_dev->evbit);
 	__set_bit(BTN_TOUCH, input_dev->keybit);
 
-	if (pdata->t19_num_keys) {
+	if (data->pdata->t19_num_keys) {
 		__set_bit(INPUT_PROP_BUTTONPAD, input_dev->propbit);
 
-		for (i = 0; i < pdata->t19_num_keys; i++)
-			if (pdata->t19_keymap[i] != KEY_RESERVED)
+		for (i = 0; i < data->pdata->t19_num_keys; i++)
+			if (data->pdata->t19_keymap[i] != KEY_RESERVED)
 				input_set_capability(input_dev, EV_KEY,
-						     pdata->t19_keymap[i]);
+						data->pdata->t19_keymap[i]);
 
 		mt_flags |= INPUT_MT_POINTER;
 
@@ -1743,7 +1763,6 @@ static int mxt_probe(struct i2c_client *client,
 			     0, 255, 0, 0);
 
 	input_set_drvdata(input_dev, data);
-	i2c_set_clientdata(client, data);
 
 	error = input_register_device(input_dev);
 	if (error) {
@@ -1767,7 +1786,10 @@ err_unregister_device:
 err_free_object:
 	kfree(data->object_table);
 err_free_irq:
-	free_irq(client->irq, data);
+	free_irq(data->irq, data);
+err_free_pdata:
+	if (!dev_get_platdata(&data->client->dev))
+		kfree(data->pdata);
 err_free_mem:
 	input_free_device(input_dev);
 	kfree(data);
@@ -1782,6 +1804,8 @@ static int mxt_remove(struct i2c_client *client)
 	free_irq(data->irq, data);
 	input_unregister_device(data->input_dev);
 	kfree(data->object_table);
+	if (!dev_get_platdata(&data->client->dev))
+		kfree(data->pdata);
 	kfree(data);
 
 	return 0;
-- 
1.7.10.4

