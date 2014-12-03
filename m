Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbaLCJbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:31:34 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:51127 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbaLCJbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:31:31 -0500
From: Dudley Du <dudley.dulixin@gmail.com>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se
Cc: Dudley Du <dudley.dulixin@gmail.com>, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v12 02/19] input: cyapa: add device resource management infrastructure support
Date: Wed,  3 Dec 2014 17:30:08 +0800
Message-Id: <1417599025-21681-3-git-send-email-dudley.dulixin@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417599025-21681-1-git-send-email-dudley.dulixin@gmail.com>
References: <1417599025-21681-1-git-send-email-dudley.dulixin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove cyapa_remove() method, add cyapa_open() and cyapa_close() methods for
input interface, also modified together with driver's memory and IRQ resource
allocations to support device resource management infrastructure to reduce
the mistakes of resource management.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudley.dulixin@gmail.com>
---
 drivers/input/mouse/cyapa.c | 77 ++++++++++++++++++++++++++-------------------
 1 file changed, 44 insertions(+), 33 deletions(-)

diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index c9fdf6d..d8f1dfe 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -753,6 +753,22 @@ static u8 cyapa_check_adapter_functionality(struct i2c_client *client)
 	return ret;
 }
 
+static int cyapa_open(struct input_dev *input)
+{
+	struct cyapa *cyapa = input_get_drvdata(input);
+	struct i2c_client *client = cyapa->client;
+
+	enable_irq(client->irq);
+	return 0;
+}
+
+static void cyapa_close(struct input_dev *input)
+{
+	struct cyapa *cyapa = input_get_drvdata(input);
+
+	disable_irq(cyapa->client->irq);
+}
+
 static int cyapa_create_input_dev(struct cyapa *cyapa)
 {
 	struct device *dev = &cyapa->client->dev;
@@ -762,7 +778,7 @@ static int cyapa_create_input_dev(struct cyapa *cyapa)
 	if (!cyapa->physical_size_x || !cyapa->physical_size_y)
 		return -EINVAL;
 
-	input = cyapa->input = input_allocate_device();
+	input = devm_input_allocate_device(dev);
 	if (!input) {
 		dev_err(dev, "failed to allocate memory for input device.\n");
 		return -ENOMEM;
@@ -775,6 +791,9 @@ static int cyapa_create_input_dev(struct cyapa *cyapa)
 	input->id.product = 0;  /* Means any product in eventcomm. */
 	input->dev.parent = &cyapa->client->dev;
 
+	input->open = cyapa_open;
+	input->close = cyapa_close;
+
 	input_set_drvdata(input, cyapa);
 
 	__set_bit(EV_ABS, input->evbit);
@@ -806,21 +825,18 @@ static int cyapa_create_input_dev(struct cyapa *cyapa)
 			INPUT_MT_POINTER | INPUT_MT_DROP_UNUSED);
 	if (error) {
 		dev_err(dev, "failed to initialize MT slots, %d\n", error);
-		goto err_free_device;
+		return error;
 	}
 
 	/* Register the device in input subsystem */
 	error = input_register_device(input);
 	if (error) {
 		dev_err(dev, "failed to register input device, %d\n", error);
-		goto err_free_device;
+		return error;
 	}
-	return 0;
 
-err_free_device:
-	input_free_device(input);
-	cyapa->input = NULL;
-	return error;
+	cyapa->input = input;
+	return 0;
 }
 
 static int cyapa_probe(struct i2c_client *client,
@@ -837,7 +853,7 @@ static int cyapa_probe(struct i2c_client *client,
 		return -EIO;
 	}
 
-	cyapa = kzalloc(sizeof(struct cyapa), GFP_KERNEL);
+	cyapa = devm_kzalloc(dev, sizeof(struct cyapa), GFP_KERNEL);
 	if (!cyapa)
 		return -ENOMEM;
 
@@ -854,51 +870,46 @@ static int cyapa_probe(struct i2c_client *client,
 	error = cyapa_check_is_operational(cyapa);
 	if (error) {
 		dev_err(dev, "device not operational, %d\n", error);
-		goto err_mem_free;
-	}
-
-	error = cyapa_create_input_dev(cyapa);
-	if (error) {
-		dev_err(dev, "create input_dev instance failed, %d\n", error);
-		goto err_mem_free;
+		return error;
 	}
 
 	error = cyapa_set_power_mode(cyapa, PWR_MODE_FULL_ACTIVE);
 	if (error) {
 		dev_err(dev, "set active power failed, %d\n", error);
-		goto err_unregister_device;
+		return error;
 	}
 
 	cyapa->irq = client->irq;
-	error = request_threaded_irq(cyapa->irq,
-				   NULL,
-				   cyapa_irq,
-				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-				   "cyapa",
-				   cyapa);
+	error = devm_request_threaded_irq(dev,
+					cyapa->irq,
+					NULL,
+					cyapa_irq,
+					IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+					"cyapa",
+					cyapa);
 	if (error) {
 		dev_err(dev, "failed to request threaded irq: %d\n", error);
-		goto err_unregister_device;
+		return error;
 	}
 
-	return 0;
+	/* Disable IRQ until the device is opened. */
+	disable_irq(client->irq);
 
-err_unregister_device:
-	input_unregister_device(cyapa->input);
-err_mem_free:
-	kfree(cyapa);
+	error = cyapa_create_input_dev(cyapa);
+	if (error) {
+		dev_err(dev, "create input_dev instance failed, %d\n", error);
+		return error;
+	}
 
-	return error;
+	return 0;
 }
 
 static int cyapa_remove(struct i2c_client *client)
 {
 	struct cyapa *cyapa = i2c_get_clientdata(client);
 
-	free_irq(cyapa->irq, cyapa);
-	input_unregister_device(cyapa->input);
+	disable_irq(cyapa->irq);
 	cyapa_set_power_mode(cyapa, PWR_MODE_OFF);
-	kfree(cyapa);
 
 	return 0;
 }
-- 
1.9.1

