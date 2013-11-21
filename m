Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab3KUFOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 00:14:55 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:36006 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab3KUFOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 00:14:54 -0500
Date: Wed, 20 Nov 2013 21:14:43 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@vger.kernel.org
Cc: Bill Pemberton <wfp5p@virginia.edu>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Denis Carikli <denis@eukrea.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] Input: tsc2007 - convert to use devres-managed resources
Message-ID: <20131121051438.GA6180@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simplifies error handling path and allows us get rid of
tsc2007_remove().

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/touchscreen/tsc2007.c | 79 +++++++++++++++++++------------------
 1 file changed, 40 insertions(+), 39 deletions(-)

diff --git a/drivers/input/touchscreen/tsc2007.c b/drivers/input/touchscreen/tsc2007.c
index 48a165a..bd51eee 100644
--- a/drivers/input/touchscreen/tsc2007.c
+++ b/drivers/input/touchscreen/tsc2007.c
@@ -366,6 +366,14 @@ static int tsc2007_probe_pdev(struct i2c_client *client, struct tsc2007 *ts,
 	return 0;
 }
 
+static void tsc2007_call_exit_platform_hw(void *data)
+{
+	struct device *dev = data;
+	const struct tsc2007_platform_data *pdata = dev_get_platdata(dev);
+
+	pdata->exit_platform_hw();
+}
+
 static int tsc2007_probe(struct i2c_client *client,
 			 const struct i2c_device_id *id)
 {
@@ -389,11 +397,9 @@ static int tsc2007_probe(struct i2c_client *client,
 	if (err)
 		return err;
 
-	input_dev = input_allocate_device();
-	if (!input_dev) {
-		err = -ENOMEM;
-		goto err_free_input;
-	};
+	input_dev = devm_input_allocate_device(&client->dev);
+	if (!input_dev)
+		return -ENOMEM;
 
 	i2c_set_clientdata(client, ts);
 
@@ -422,45 +428,41 @@ static int tsc2007_probe(struct i2c_client *client,
 	input_set_abs_params(input_dev, ABS_PRESSURE, 0, MAX_12BIT,
 			     ts->fuzzz, 0);
 
-	if (pdata && pdata->init_platform_hw)
-		pdata->init_platform_hw();
+	if (pdata) {
+		if (pdata->exit_platform_hw) {
+			err = devm_add_action(&client->dev,
+					      tsc2007_call_exit_platform_hw,
+					      &client->dev);
+			if (err) {
+				dev_err(&client->dev,
+					"Failed to register exit_platform_hw action, %d\n",
+					err);
+				return err;
+			}
+		}
+
+		if (pdata->init_platform_hw)
+			pdata->init_platform_hw();
+	}
 
-	err = request_threaded_irq(ts->irq, tsc2007_hard_irq, tsc2007_soft_irq,
-				   IRQF_ONESHOT, client->dev.driver->name, ts);
-	if (err < 0) {
-		dev_err(&client->dev, "irq %d busy?\n", ts->irq);
-		goto err_free_input;
+	err = devm_request_threaded_irq(&client->dev, ts->irq,
+					tsc2007_hard_irq, tsc2007_soft_irq,
+					IRQF_ONESHOT,
+					client->dev.driver->name, ts);
+	if (err) {
+		dev_err(&client->dev, "Failed to request irq %d: %d\n",
+			ts->irq, err);
+		return err;
 	}
 
 	tsc2007_stop(ts);
 
 	err = input_register_device(input_dev);
-	if (err)
-		goto err_free_irq;
-
-	return 0;
-
- err_free_irq:
-	free_irq(ts->irq, ts);
-	if (pdata && pdata->exit_platform_hw)
-		pdata->exit_platform_hw();
- err_free_input:
-	input_free_device(input_dev);
-	return err;
-}
-
-static int tsc2007_remove(struct i2c_client *client)
-{
-	const struct tsc2007_platform_data *pdata = dev_get_platdata(&client->dev);
-	struct tsc2007 *ts = i2c_get_clientdata(client);
-
-	free_irq(ts->irq, ts);
-
-	if (pdata && pdata->exit_platform_hw)
-		pdata->exit_platform_hw();
-
-	input_unregister_device(ts->input);
-	kfree(ts);
+	if (err) {
+		dev_err(&client->dev,
+			"Failed to register input device: %d\n", err);
+		return err;
+	}
 
 	return 0;
 }
@@ -488,7 +490,6 @@ static struct i2c_driver tsc2007_driver = {
 	},
 	.id_table	= tsc2007_idtable,
 	.probe		= tsc2007_probe,
-	.remove		= tsc2007_remove,
 };
 
 module_i2c_driver(tsc2007_driver);
-- 
1.8.3.1


-- 
Dmitry
