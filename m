Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab3LRJWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 04:22:32 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:51618 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301Ab3LRJW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 04:22:26 -0500
From: Roger Quadros <rogerq@ti.com>
To: <dmitry.torokhov@gmail.com>
CC: <rydberg@euromail.se>, <jcbian@pixcir.com.cn>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 4/9] Input: pixcir_i2c_ts: Use devres managed resource allocations
Date: Wed, 18 Dec 2013 14:51:15 +0530
Message-ID: <1387358480-8313-5-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387358480-8313-1-git-send-email-rogerq@ti.com>
References: <1387358480-8313-1-git-send-email-rogerq@ti.com>
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
 drivers/input/touchscreen/pixcir_i2c_ts.c | 35 ++++++++++++-------------------
 1 file changed, 13 insertions(+), 22 deletions(-)

diff --git a/drivers/input/touchscreen/pixcir_i2c_ts.c b/drivers/input/touchscreen/pixcir_i2c_ts.c
index ce8abcd..3370fd9 100644
--- a/drivers/input/touchscreen/pixcir_i2c_ts.c
+++ b/drivers/input/touchscreen/pixcir_i2c_ts.c
@@ -346,12 +346,14 @@ static int pixcir_i2c_ts_probe(struct i2c_client *client,
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
@@ -378,12 +380,12 @@ static int pixcir_i2c_ts_probe(struct i2c_client *client,
 
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
 
 	/* Always be in IDLE mode to save power, device supports auto wake */
@@ -396,23 +398,16 @@ static int pixcir_i2c_ts_probe(struct i2c_client *client,
 	/* Stop device till opened */
 	error = pixcir_stop(tsdata);
 	if (error)
-		goto err_free_irq;
+		return error;
 
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
@@ -423,10 +418,6 @@ static int pixcir_i2c_ts_remove(struct i2c_client *client)
 
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

