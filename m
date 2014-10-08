Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbaJHGpA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 02:45:00 -0400
Received: from smtp97.ord1c.emailsrvr.com ([108.166.43.97]:36212 "EHLO
	smtp97.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752281AbaJHGo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 02:44:58 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Subject: [PATCH] Input: mpr121: Switch to using managed resources
Date: Wed,  8 Oct 2014 12:18:31 +0530
Message-Id: <1412750911-16759-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change switches to using devm_* managed resources APIs to
request the resources in probe to simplify probe error path and
module unloading and does away with remove function.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/input/keyboard/mpr121_touchkey.c |   35 +++++++-----------------------
 1 file changed, 8 insertions(+), 27 deletions(-)

diff --git a/drivers/input/keyboard/mpr121_touchkey.c b/drivers/input/keyboard/mpr121_touchkey.c
index 009c822..49c578e 100644
--- a/drivers/input/keyboard/mpr121_touchkey.c
+++ b/drivers/input/keyboard/mpr121_touchkey.c
@@ -214,12 +214,12 @@ static int mpr_touchkey_probe(struct i2c_client *client,
 		return -EINVAL;
 	}
 
-	mpr121 = kzalloc(sizeof(struct mpr121_touchkey), GFP_KERNEL);
-	input_dev = input_allocate_device();
+	mpr121 = devm_kzalloc(&client->dev, sizeof(*mpr121),
+			      GFP_KERNEL);
+	input_dev = devm_input_allocate_device(&client->dev);
 	if (!mpr121 || !input_dev) {
 		dev_err(&client->dev, "Failed to allocate memory\n");
-		error = -ENOMEM;
-		goto err_free_mem;
+		return -ENOMEM;
 	}
 
 	mpr121->client = client;
@@ -243,44 +243,26 @@ static int mpr_touchkey_probe(struct i2c_client *client,
 	error = mpr121_phys_init(pdata, mpr121, client);
 	if (error) {
 		dev_err(&client->dev, "Failed to init register\n");
-		goto err_free_mem;
+		return error;
 	}
 
-	error = request_threaded_irq(client->irq, NULL,
+	error = devm_request_threaded_irq(&client->dev, client->irq, NULL,
 				     mpr_touchkey_interrupt,
 				     IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 				     client->dev.driver->name, mpr121);
 	if (error) {
 		dev_err(&client->dev, "Failed to register interrupt\n");
-		goto err_free_mem;
+		return error;
 	}
 
 	error = input_register_device(input_dev);
 	if (error)
-		goto err_free_irq;
+		return error;
 
 	i2c_set_clientdata(client, mpr121);
 	device_init_wakeup(&client->dev, pdata->wakeup);
 
 	return 0;
-
-err_free_irq:
-	free_irq(client->irq, mpr121);
-err_free_mem:
-	input_free_device(input_dev);
-	kfree(mpr121);
-	return error;
-}
-
-static int mpr_touchkey_remove(struct i2c_client *client)
-{
-	struct mpr121_touchkey *mpr121 = i2c_get_clientdata(client);
-
-	free_irq(client->irq, mpr121);
-	input_unregister_device(mpr121->input_dev);
-	kfree(mpr121);
-
-	return 0;
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -327,7 +309,6 @@ static struct i2c_driver mpr_touchkey_driver = {
 	},
 	.id_table	= mpr121_id,
 	.probe		= mpr_touchkey_probe,
-	.remove		= mpr_touchkey_remove,
 };
 
 module_i2c_driver(mpr_touchkey_driver);
-- 
1.7.9.5

