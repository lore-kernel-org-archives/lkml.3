Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbaG3NpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 09:45:05 -0400
Received: from smtp105.ord1c.emailsrvr.com ([108.166.43.105]:44024 "EHLO
	smtp105.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752713AbaG3NpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 09:45:04 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 1/2] Input: jornada720_ts: Switch to using Managed resources
Date: Wed, 30 Jul 2014 19:18:26 +0530
Message-Id: <1406728107-26969-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This switches the driver to using managed resources to simplify
error handling and to do away with remove function.

CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>

Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/input/touchscreen/jornada720_ts.c |   38 ++++++-----------------------
 1 file changed, 8 insertions(+), 30 deletions(-)

diff --git a/drivers/input/touchscreen/jornada720_ts.c b/drivers/input/touchscreen/jornada720_ts.c
index 7324c5c..7422480 100644
--- a/drivers/input/touchscreen/jornada720_ts.c
+++ b/drivers/input/touchscreen/jornada720_ts.c
@@ -104,13 +104,10 @@ static int jornada720_ts_probe(struct platform_device *pdev)
 	struct input_dev *input_dev;
 	int error;
 
-	jornada_ts = kzalloc(sizeof(struct jornada_ts), GFP_KERNEL);
-	input_dev = input_allocate_device();
-
-	if (!jornada_ts || !input_dev) {
-		error = -ENOMEM;
-		goto fail1;
-	}
+	jornada_ts = devm_kzalloc(&pdev->dev, sizeof(*jornada_ts), GFP_KERNEL);
+	input_dev = devm_input_allocate_device(&pdev->dev);
+	if (!jornada_ts || !input_dev)
+		return -ENOMEM;
 
 	platform_set_drvdata(pdev, jornada_ts);
 
@@ -126,36 +123,18 @@ static int jornada720_ts_probe(struct platform_device *pdev)
 	input_set_abs_params(input_dev, ABS_X, 270, 3900, 0, 0);
 	input_set_abs_params(input_dev, ABS_Y, 180, 3700, 0, 0);
 
-	error = request_irq(IRQ_GPIO9,
+	error = devm_request_irq(&pdev->dev, IRQ_GPIO9,
 			jornada720_ts_interrupt,
 			IRQF_TRIGGER_RISING,
 			"HP7XX Touchscreen driver", pdev);
 	if (error) {
-		printk(KERN_INFO "HP7XX TS : Unable to acquire irq!\n");
-		goto fail1;
+		dev_err(&pdev->dev, "HP7XX TS : Unable to acquire irq!\n");
+		return error;
 	}
 
 	error = input_register_device(jornada_ts->dev);
 	if (error)
-		goto fail2;
-
-	return 0;
-
- fail2:
-	free_irq(IRQ_GPIO9, pdev);
- fail1:
-	input_free_device(input_dev);
-	kfree(jornada_ts);
-	return error;
-}
-
-static int jornada720_ts_remove(struct platform_device *pdev)
-{
-	struct jornada_ts *jornada_ts = platform_get_drvdata(pdev);
-
-	free_irq(IRQ_GPIO9, pdev);
-	input_unregister_device(jornada_ts->dev);
-	kfree(jornada_ts);
+		return error;
 
 	return 0;
 }
@@ -165,7 +144,6 @@ MODULE_ALIAS("platform:jornada_ts");
 
 static struct platform_driver jornada720_ts_driver = {
 	.probe		= jornada720_ts_probe,
-	.remove		= jornada720_ts_remove,
 	.driver		= {
 		.name	= "jornada_ts",
 		.owner	= THIS_MODULE,
-- 
1.7.9.5

