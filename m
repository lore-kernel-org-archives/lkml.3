Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763AbaGCPIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:08:16 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:57279 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756408AbaGCPIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:08:13 -0400
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jul 2014 11:08:13 EDT
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
Subject: [PATCH 01/15] Input: atmel_mxt_ts - initialise IRQ before probing
Date: Thu,  3 Jul 2014 16:01:23 +0100
Message-Id: <1404399697-26484-2-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404399697-26484-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1404399697-26484-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Dyer <nick.dyer@itdev.co.uk>

The maXTouch chips use the CHG line to generate status events in bootloader
mode, and during configuration download, before there is enough information to
configure the input device. Therefore set up the interrupt handler earlier.

However, this introduces states where parts of the interrupt processing must
not run. Use data->object_table as a way to tell whether the chip information
is valid, and data->input_dev as a way to tell whether it is valid to generate
input report.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
Acked-by: Yufeng Shen <miletus@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 101 +++++++++++++++++++------------
 1 file changed, 62 insertions(+), 39 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 6e0b4a2..02c374d 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -764,6 +764,12 @@ static irqreturn_t mxt_process_messages_until_invalid(struct mxt_data *data)
 
 			if (status & MXT_T6_STATUS_RESET)
 				complete(&data->reset_completion);
+		} else if (!data->input_dev) {
+			/*
+			 * do not report events if input device
+			 * is not yet registered
+			 */
+			mxt_dump_message(dev, &message);
 		} else if (mxt_is_T9_message(data, &message)) {
 			int id = reportid - data->T9_reportid_min;
 			mxt_input_touchevent(data, &message, id);
@@ -792,6 +798,9 @@ static irqreturn_t mxt_interrupt(int irq, void *dev_id)
 		return IRQ_HANDLED;
 	}
 
+	if (!data->object_table)
+		return IRQ_HANDLED;
+
 	return mxt_process_messages_until_invalid(data);
 }
 
@@ -942,6 +951,19 @@ static int mxt_make_highchg(struct mxt_data *data)
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
@@ -960,20 +982,29 @@ static int mxt_get_object_table(struct mxt_data *data)
 {
 	struct i2c_client *client = data->client;
 	size_t table_size;
+	struct mxt_object *object_table;
 	int error;
 	int i;
 	u8 reportid;
 
 	table_size = data->info.object_num * sizeof(struct mxt_object);
+	object_table = kzalloc(table_size, GFP_KERNEL);
+	if (!object_table) {
+		dev_err(&data->client->dev, "Failed to allocate memory\n");
+		return -ENOMEM;
+	}
+
 	error = __mxt_read_reg(client, MXT_OBJECT_START, table_size,
-			data->object_table);
-	if (error)
+			object_table);
+	if (error) {
+		kfree(object_table);
 		return error;
+	}
 
 	/* Valid Report IDs start counting from 1 */
 	reportid = 1;
 	for (i = 0; i < data->info.object_num; i++) {
-		struct mxt_object *object = data->object_table + i;
+		struct mxt_object *object = object_table + i;
 		u8 min_id, max_id;
 
 		le16_to_cpus(&object->start_address);
@@ -1009,6 +1040,8 @@ static int mxt_get_object_table(struct mxt_data *data)
 		}
 	}
 
+	data->object_table = object_table;
+
 	return 0;
 }
 
@@ -1080,21 +1113,17 @@ static int mxt_initialize(struct mxt_data *data)
 	if (error)
 		return error;
 
-	data->object_table = kcalloc(info->object_num,
-				     sizeof(struct mxt_object),
-				     GFP_KERNEL);
-	if (!data->object_table) {
-		dev_err(&client->dev, "Failed to allocate memory\n");
-		return -ENOMEM;
-	}
-
 	/* Get object table information */
 	error = mxt_get_object_table(data);
 	if (error) {
 		dev_err(&client->dev, "Error %d reading object table\n", error);
-		goto err_free_object_table;
+		return error;
 	}
 
+	mxt_acquire_irq(data);
+	if (error)
+		goto err_free_object_table;
+
 	/* Check register init values */
 	error = mxt_check_reg_init(data);
 	if (error) {
@@ -1345,11 +1374,7 @@ static ssize_t mxt_update_fw_store(struct device *dev,
 
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
@@ -1446,9 +1471,26 @@ static int mxt_probe(struct i2c_client *client,
 	init_completion(&data->reset_completion);
 	init_completion(&data->crc_completion);
 
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
+	error = input_register_device(input_dev);
+	if (error) {
+		dev_err(&client->dev, "Error %d registering input device\n",
+			error);
+		goto err_free_irq;
+	}
+
 	error = mxt_initialize(data);
 	if (error)
-		goto err_free_mem;
+		goto err_unregister_device;
 
 	__set_bit(EV_ABS, input_dev->evbit);
 	__set_bit(EV_KEY, input_dev->evbit);
@@ -1499,25 +1541,6 @@ static int mxt_probe(struct i2c_client *client,
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
-	error = input_register_device(input_dev);
-	if (error) {
-		dev_err(&client->dev, "Error %d registering input device\n",
-			error);
-		goto err_free_irq;
-	}
-
 	error = sysfs_create_group(&client->dev.kobj, &mxt_attr_group);
 	if (error) {
 		dev_err(&client->dev, "Failure %d creating sysfs group\n",
@@ -1530,10 +1553,10 @@ static int mxt_probe(struct i2c_client *client,
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
2.0.1

