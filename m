Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbaKNGEl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 01:04:41 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:51771 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbaKNGEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 01:04:39 -0500
From: Dudley Du <dudley.dulixin@gmail.com>
X-Google-Original-From: Dudley Du <dudl@cypress.com>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se
Cc: Dudley Du <dudl@cypress.com>, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v10 02/18] input: cyapa: add device resource management infrastructure support
Date: Fri, 14 Nov 2014 14:03:08 +0800
Message-Id: <1415945004-19868-3-git-send-email-dudl@cypress.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415945004-19868-1-git-send-email-dudl@cypress.com>
References: <1415945004-19868-1-git-send-email-dudl@cypress.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove cyapa_remove() method, add cyapa_open() and cyapa_close() methods for
input interface, also modified together with driver's memory and IRQ resource
allocations to support device resource management infrastructure to reduce
the mistakes of resource management.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudl@cypress.com>
---
 drivers/input/mouse/cyapa.c | 77 +++++++++++++++++++++++++--------------------
 1 file changed, 43 insertions(+), 34 deletions(-)

diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index c35f398..06c94a3 100644
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
+	input = cyapa->input = devm_input_allocate_device(dev);
 	if (!input) {
 		dev_err(dev, "allocate memory for input device failed\n");
 		return -ENOMEM;
@@ -775,6 +791,9 @@ static int cyapa_create_input_dev(struct cyapa *cyapa)
 	input->id.product = 0;  /* means any product in eventcomm. */
 	input->dev.parent = &cyapa->client->dev;
 
+	input->open = cyapa_open;
+	input->close = cyapa_close;
+
 	input_set_drvdata(input, cyapa);
 
 	__set_bit(EV_ABS, input->evbit);
@@ -807,21 +826,17 @@ static int cyapa_create_input_dev(struct cyapa *cyapa)
 	if (error) {
 		dev_err(dev, "allocate memory for MT slots failed, %d\n",
 				error);
-		goto err_free_device;
+		return error;
 	}
 
 	/* Register the device in input subsystem */
 	error = input_register_device(input);
 	if (error) {
 		dev_err(dev, "input device register failed, %d\n", error);
-		goto err_free_device;
+		return error;
 	}
-	return 0;
 
-err_free_device:
-	input_free_device(input);
-	cyapa->input = NULL;
-	return error;
+	return 0;
 }
 
 static int cyapa_probe(struct i2c_client *client,
@@ -838,7 +853,7 @@ static int cyapa_probe(struct i2c_client *client,
 		return -EIO;
 	}
 
-	cyapa = kzalloc(sizeof(struct cyapa), GFP_KERNEL);
+	cyapa = devm_kzalloc(dev, sizeof(struct cyapa), GFP_KERNEL);
 	if (!cyapa)
 		return -ENOMEM;
 
@@ -855,51 +870,45 @@ static int cyapa_probe(struct i2c_client *client,
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
 		dev_err(dev, "IRQ request failed: %d\n, ", error);
-		goto err_unregister_device;
+		return error;
 	}
+	/* Disable IRQ until the device is opened. */
+	disable_irq(client->irq);
 
-	return 0;
-
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

