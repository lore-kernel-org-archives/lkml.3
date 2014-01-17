Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbaAQM3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 07:29:32 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:52740 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbaAQM3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 07:29:25 -0500
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Jonathan Cameron <jic23@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Silvio F <silvio.fricke@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Jingoo Han <jg1.han@samsung.com>, Fugang Duan <B38611@freescale.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Cc: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCHv3 2/4] Input: edt_ft5x06: use devm_* functions where appropriate
Date: Fri, 17 Jan 2014 13:28:36 +0100
Message-Id: <1389961718-8130-3-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1389961718-8130-1-git-send-email-LW@KARO-electronics.de>
References: <1389961718-8130-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify the error path and remove() function by using devm_*
functions for requesting gpios and irq and allocating memory.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/input/touchscreen/edt-ft5x06.c |   66 +++++++++++---------------------
 1 files changed, 23 insertions(+), 43 deletions(-)

diff --git a/drivers/input/touchscreen/edt-ft5x06.c b/drivers/input/touchscreen/edt-ft5x06.c
index af0d68b..583c053 100644
--- a/drivers/input/touchscreen/edt-ft5x06.c
+++ b/drivers/input/touchscreen/edt-ft5x06.c
@@ -366,7 +366,9 @@ static int edt_ft5x06_factory_mode(struct edt_ft5x06_ts_data *tsdata)
 	if (!tsdata->raw_buffer) {
 		tsdata->raw_bufsize = tsdata->num_x * tsdata->num_y *
 				      sizeof(u16);
-		tsdata->raw_buffer = kzalloc(tsdata->raw_bufsize, GFP_KERNEL);
+		tsdata->raw_buffer = devm_kzalloc(&client->dev,
+						tsdata->raw_bufsize,
+						GFP_KERNEL);
 		if (!tsdata->raw_buffer) {
 			error = -ENOMEM;
 			goto err_out;
@@ -623,8 +625,9 @@ static int edt_ft5x06_ts_reset(struct i2c_client *client,
 
 	if (gpio_is_valid(reset_pin)) {
 		/* this pulls reset down, enabling the low active reset */
-		error = gpio_request_one(reset_pin, GPIOF_OUT_INIT_LOW,
-					 "edt-ft5x06 reset");
+		error = devm_gpio_request_one(&client->dev, reset_pin,
+					GPIOF_OUT_INIT_LOW,
+					"edt-ft5x06 reset");
 		if (error) {
 			dev_err(&client->dev,
 				"Failed to request GPIO %d as reset pin, error %d\n",
@@ -723,7 +726,7 @@ static int edt_ft5x06_ts_probe(struct i2c_client *client,
 		return error;
 
 	if (gpio_is_valid(pdata->irq_pin)) {
-		error = gpio_request_one(pdata->irq_pin,
+		error = devm_gpio_request_one(&client->dev, pdata->irq_pin,
 					 GPIOF_IN, "edt-ft5x06 irq");
 		if (error) {
 			dev_err(&client->dev,
@@ -733,12 +736,11 @@ static int edt_ft5x06_ts_probe(struct i2c_client *client,
 		}
 	}
 
-	tsdata = kzalloc(sizeof(*tsdata), GFP_KERNEL);
-	input = input_allocate_device();
+	tsdata = devm_kzalloc(&client->dev, sizeof(*tsdata), GFP_KERNEL);
+	input = devm_input_allocate_device(&client->dev);
 	if (!tsdata || !input) {
-		dev_err(&client->dev, "failed to allocate driver data.\n");
-		error = -ENOMEM;
-		goto err_free_mem;
+		dev_err(&client->dev, "failed to allocate input device.\n");
+		return -ENOMEM;
 	}
 
 	mutex_init(&tsdata->mutex);
@@ -749,7 +751,7 @@ static int edt_ft5x06_ts_probe(struct i2c_client *client,
 	error = edt_ft5x06_ts_identify(client, tsdata->name, fw_version);
 	if (error) {
 		dev_err(&client->dev, "touchscreen probe failed\n");
-		goto err_free_mem;
+		return error;
 	}
 
 	edt_ft5x06_ts_get_defaults(tsdata, pdata);
@@ -776,27 +778,30 @@ static int edt_ft5x06_ts_probe(struct i2c_client *client,
 	error = input_mt_init_slots(input, MAX_SUPPORT_POINTS, 0);
 	if (error) {
 		dev_err(&client->dev, "Unable to init MT slots.\n");
-		goto err_free_mem;
+		return error;
 	}
 
 	input_set_drvdata(input, tsdata);
 	i2c_set_clientdata(client, tsdata);
 
-	error = request_threaded_irq(client->irq, NULL, edt_ft5x06_ts_isr,
-				     IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-				     client->name, tsdata);
+	error = devm_request_threaded_irq(&client->dev, client->irq, NULL,
+					edt_ft5x06_ts_isr,
+					IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+					client->name, tsdata);
 	if (error) {
 		dev_err(&client->dev, "Unable to request touchscreen IRQ.\n");
-		goto err_free_mem;
+		return error;
 	}
 
 	error = sysfs_create_group(&client->dev.kobj, &edt_ft5x06_attr_group);
 	if (error)
-		goto err_free_irq;
+		return error;
 
 	error = input_register_device(input);
-	if (error)
-		goto err_remove_attrs;
+	if (error) {
+		sysfs_remove_group(&client->dev.kobj, &edt_ft5x06_attr_group);
+		return error;
+	}
 
 	edt_ft5x06_ts_prepare_debugfs(tsdata, dev_driver_string(&client->dev));
 	device_init_wakeup(&client->dev, 1);
@@ -806,40 +811,15 @@ static int edt_ft5x06_ts_probe(struct i2c_client *client,
 		pdata->irq_pin, pdata->reset_pin);
 
 	return 0;
-
-err_remove_attrs:
-	sysfs_remove_group(&client->dev.kobj, &edt_ft5x06_attr_group);
-err_free_irq:
-	free_irq(client->irq, tsdata);
-err_free_mem:
-	input_free_device(input);
-	kfree(tsdata);
-
-	if (gpio_is_valid(pdata->irq_pin))
-		gpio_free(pdata->irq_pin);
-
-	return error;
 }
 
 static int edt_ft5x06_ts_remove(struct i2c_client *client)
 {
-	const struct edt_ft5x06_platform_data *pdata =
-						dev_get_platdata(&client->dev);
 	struct edt_ft5x06_ts_data *tsdata = i2c_get_clientdata(client);
 
 	edt_ft5x06_ts_teardown_debugfs(tsdata);
 	sysfs_remove_group(&client->dev.kobj, &edt_ft5x06_attr_group);
 
-	free_irq(client->irq, tsdata);
-	input_unregister_device(tsdata->input);
-
-	if (gpio_is_valid(pdata->irq_pin))
-		gpio_free(pdata->irq_pin);
-	if (gpio_is_valid(pdata->reset_pin))
-		gpio_free(pdata->reset_pin);
-
-	kfree(tsdata);
-
 	return 0;
 }
 
-- 
1.7.2.5

