Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbaBZP2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 10:28:25 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:54288 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbaBZP2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 10:28:23 -0500
From: Roger Quadros <rogerq@ti.com>
To: <dmitry.torokhov@gmail.com>
CC: <rydberg@euromail.se>, <jcbian@pixcir.com.cn>, <balbi@ti.com>,
        <dmurphy@ti.com>, <mugunthanvnm@ti.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH v2 1/8] Input: pixcir_i2c_ts: Use devres managed resource allocations
Date: Wed, 26 Feb 2014 17:27:59 +0200
Message-ID: <1393428486-15001-2-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393428486-15001-1-git-send-email-rogerq@ti.com>
References: <1393428486-15001-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_() and friends for allocating memory, input device
and IRQ.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Mugunthan V N <mugunthanvnm@ti.com>
---
 drivers/input/touchscreen/pixcir_i2c_ts.c | 34 ++++++++++++-------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff --git a/drivers/input/touchscreen/pixcir_i2c_ts.c b/drivers/input/touchscreen/pixcir_i2c_ts.c
index 02392d2..38e83a2 100644
--- a/drivers/input/touchscreen/pixcir_i2c_ts.c
+++ b/drivers/input/touchscreen/pixcir_i2c_ts.c
@@ -130,6 +130,7 @@ static int pixcir_i2c_ts_probe(struct i2c_client *client,
 {
 	const struct pixcir_ts_platform_data *pdata =
 			dev_get_platdata(&client->dev);
+	struct device *dev = &client->dev;
 	struct pixcir_i2c_ts_data *tsdata;
 	struct input_dev *input;
 	int error;
@@ -139,12 +140,14 @@ static int pixcir_i2c_ts_probe(struct i2c_client *client,
 		return -EINVAL;
 	}
 
-	tsdata = kzalloc(sizeof(*tsdata), GFP_KERNEL);
-	input = input_allocate_device();
-	if (!tsdata || !input) {
-		dev_err(&client->dev, "Failed to allocate driver data!\n");
-		error = -ENOMEM;
-		goto err_free_mem;
+	tsdata = devm_kzalloc(dev, sizeof(*tsdata), GFP_KERNEL);
+	if (!tsdata)
+		return -ENOMEM;
+
+	input = devm_input_allocate_device(dev);
+	if (!input) {
+		dev_err(&client->dev, "Failed to allocate input device\n");
+		return -ENOMEM;
 	}
 
 	tsdata->client = client;
@@ -165,29 +168,22 @@ static int pixcir_i2c_ts_probe(struct i2c_client *client,
 
 	input_set_drvdata(input, tsdata);
 
-	error = request_threaded_irq(client->irq, NULL, pixcir_ts_isr,
+	error = devm_request_threaded_irq(dev, client->irq, NULL, pixcir_ts_isr,
 				     IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 				     client->name, tsdata);
 	if (error) {
-		dev_err(&client->dev, "Unable to request touchscreen IRQ.\n");
-		goto err_free_mem;
+		dev_err(dev, "failed to request irq %d\n", client->irq);
+		return error;
 	}
 
 	error = input_register_device(input);
 	if (error)
-		goto err_free_irq;
+		return error;
 
 	i2c_set_clientdata(client, tsdata);
 	device_init_wakeup(&client->dev, 1);
 
 	return 0;
-
-err_free_irq:
-	free_irq(client->irq, tsdata);
-err_free_mem:
-	input_free_device(input);
-	kfree(tsdata);
-	return error;
 }
 
 static int pixcir_i2c_ts_remove(struct i2c_client *client)
@@ -198,10 +194,6 @@ static int pixcir_i2c_ts_remove(struct i2c_client *client)
 
 	tsdata->exiting = true;
 	mb();
-	free_irq(client->irq, tsdata);
-
-	input_unregister_device(tsdata->input);
-	kfree(tsdata);
 
 	return 0;
 }
-- 
1.8.3.2

