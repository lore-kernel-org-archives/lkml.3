Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbaHHHTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 03:19:51 -0400
Received: from smtp89.ord1c.emailsrvr.com ([108.166.43.89]:45718 "EHLO
	smtp89.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752575AbaHHHTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 03:19:47 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: support.opensource@diasemi.com, dmitry.torokhov@gmail.com
Cc: anthony.olech.opensource@diasemi.com, david.chen@diasemi.com,
        kiran.padwal21@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kiran Padwal <kiran.padwal@smartplayin.com>
Subject: [PATCH 2/2] Input: da9055_onkey: convert to use devm_*
Date: Fri,  8 Aug 2014 12:46:52 +0530
Message-Id: <1407482212-17669-1-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Converting to devm functions can make the code smaller and cleaner.

Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
---
 drivers/input/misc/da9055_onkey.c |   22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/input/misc/da9055_onkey.c b/drivers/input/misc/da9055_onkey.c
index ed6eaa9..1a1e760 100644
--- a/drivers/input/misc/da9055_onkey.c
+++ b/drivers/input/misc/da9055_onkey.c
@@ -90,9 +90,9 @@ static int da9055_onkey_probe(struct platform_device *pdev)
 	if (!onkey)
 		return -ENOMEM;
 
-	input_dev = input_allocate_device();
+	input_dev = devm_input_allocate_device(&pdev->dev);
 	if (!input_dev) {
-		dev_err(&pdev->dev, "Failed to allocate memory\n");
+		dev_err(&pdev->dev, "Failed to allocate input device\n");
 		return -ENOMEM;
 	}
 
@@ -107,43 +107,33 @@ static int da9055_onkey_probe(struct platform_device *pdev)
 
 	INIT_DELAYED_WORK(&onkey->work, da9055_onkey_work);
 
-	err = request_threaded_irq(irq, NULL, da9055_onkey_irq,
+	err = devm_request_threaded_irq(&pdev->dev, irq, NULL, da9055_onkey_irq,
 				   IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
 				   "ONKEY", onkey);
 	if (err < 0) {
 		dev_err(&pdev->dev,
 			"Failed to register ONKEY IRQ %d, error = %d\n",
 			irq, err);
-		goto err_free_input;
+		return err;
 	}
 
 	err = input_register_device(input_dev);
 	if (err) {
 		dev_err(&pdev->dev, "Unable to register input device, %d\n",
 			err);
-		goto err_free_irq;
+		cancel_delayed_work_sync(&onkey->work);
+		return err;
 	}
 
 	platform_set_drvdata(pdev, onkey);
 
 	return 0;
-
-err_free_irq:
-	free_irq(irq, onkey);
-	cancel_delayed_work_sync(&onkey->work);
-err_free_input:
-	input_free_device(input_dev);
-
-	return err;
 }
 
 static int da9055_onkey_remove(struct platform_device *pdev)
 {
 	struct da9055_onkey *onkey = platform_get_drvdata(pdev);
-	int irq = platform_get_irq_byname(pdev, "ONKEY");
 
-	irq = regmap_irq_get_virq(onkey->da9055->irq_data, irq);
-	free_irq(irq, onkey);
 	cancel_delayed_work_sync(&onkey->work);
 	input_unregister_device(onkey->input);
 
-- 
1.7.9.5

