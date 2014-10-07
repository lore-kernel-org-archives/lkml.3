Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbaJGJek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 05:34:40 -0400
Received: from smtp73.ord1c.emailsrvr.com ([108.166.43.73]:56343 "EHLO
	smtp73.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752825AbaJGJei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 05:34:38 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Subject: [PATCH] input: lm8323: Switch to using managed resources
Date: Tue,  7 Oct 2014 15:08:09 +0530
Message-Id: <1412674689-20132-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change switches to using devm_* APIs to allocate  resources.
This helps to simplify failure path in probe function as well as
remove function.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/input/keyboard/lm8323.c |   39 ++++++++++++++++-----------------------
 1 file changed, 16 insertions(+), 23 deletions(-)

diff --git a/drivers/input/keyboard/lm8323.c b/drivers/input/keyboard/lm8323.c
index cb32e2b..c4325a1 100644
--- a/drivers/input/keyboard/lm8323.c
+++ b/drivers/input/keyboard/lm8323.c
@@ -653,12 +653,10 @@ static int lm8323_probe(struct i2c_client *client,
 		return -EINVAL;
 	}
 
-	lm = kzalloc(sizeof *lm, GFP_KERNEL);
-	idev = input_allocate_device();
-	if (!lm || !idev) {
-		err = -ENOMEM;
-		goto fail1;
-	}
+	lm = devm_kzalloc(&client->dev, sizeof(*lm), GFP_KERNEL);
+	idev = devm_input_allocate_device(&client->dev);
+	if (!lm || !idev)
+		return -ENOMEM;
 
 	lm->client = client;
 	lm->idev = idev;
@@ -695,21 +693,20 @@ static int lm8323_probe(struct i2c_client *client,
 	/* If a true probe check the device */
 	if (lm8323_read_id(lm, data) != 0) {
 		dev_err(&client->dev, "device not found\n");
-		err = -ENODEV;
-		goto fail1;
+		return -ENODEV;
 	}
 
 	for (pwm = 0; pwm < LM8323_NUM_PWMS; pwm++) {
 		err = init_pwm(lm, pwm + 1, &client->dev,
 			       pdata->pwm_names[pwm]);
 		if (err < 0)
-			goto fail2;
+			goto fail1;
 	}
 
 	lm->kp_enabled = true;
 	err = device_create_file(&client->dev, &dev_attr_disable_kp);
 	if (err < 0)
-		goto fail2;
+		goto fail1;
 
 	idev->name = pdata->name ? : "LM8323 keypad";
 	snprintf(lm->phys, sizeof(lm->phys),
@@ -730,14 +727,16 @@ static int lm8323_probe(struct i2c_client *client,
 	err = input_register_device(idev);
 	if (err) {
 		dev_dbg(&client->dev, "error registering input device\n");
-		goto fail3;
+		goto fail2;
 	}
 
-	err = request_threaded_irq(client->irq, NULL, lm8323_irq,
-			  IRQF_TRIGGER_LOW|IRQF_ONESHOT, "lm8323", lm);
+	err = devm_request_threaded_irq(&client->dev, client->irq, NULL,
+					lm8323_irq,
+					IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+					"lm8323", lm);
 	if (err) {
 		dev_err(&client->dev, "could not get IRQ %d\n", client->irq);
-		goto fail4;
+		goto fail3;
 	}
 
 	i2c_set_clientdata(client, lm);
@@ -747,18 +746,15 @@ static int lm8323_probe(struct i2c_client *client,
 
 	return 0;
 
-fail4:
+fail3:
 	input_unregister_device(idev);
 	idev = NULL;
-fail3:
-	device_remove_file(&client->dev, &dev_attr_disable_kp);
 fail2:
+	device_remove_file(&client->dev, &dev_attr_disable_kp);
+fail1:
 	while (--pwm >= 0)
 		if (lm->pwm[pwm].enabled)
 			led_classdev_unregister(&lm->pwm[pwm].cdev);
-fail1:
-	input_free_device(idev);
-	kfree(lm);
 	return err;
 }
 
@@ -768,7 +764,6 @@ static int lm8323_remove(struct i2c_client *client)
 	int i;
 
 	disable_irq_wake(client->irq);
-	free_irq(client->irq, lm);
 
 	input_unregister_device(lm->idev);
 
@@ -778,8 +773,6 @@ static int lm8323_remove(struct i2c_client *client)
 		if (lm->pwm[i].enabled)
 			led_classdev_unregister(&lm->pwm[i].cdev);
 
-	kfree(lm);
-
 	return 0;
 }
 
-- 
1.7.9.5

