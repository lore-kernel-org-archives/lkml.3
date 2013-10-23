Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab3JWRyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 13:54:31 -0400
Received: from ring0.de ([91.143.88.219]:42711 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752556Ab3JWRy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 13:54:28 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Sebastian Reichel <sre@debian.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCHv4 3/3] Input: twl4030-pwrbutton: simplify driver using devm_*
Date: Wed, 23 Oct 2013 19:54:12 +0200
Message-Id: <1382550852-11508-4-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1382550852-11508-1-git-send-email-sre@debian.org>
References: <1382550852-11508-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use managed irq resource to simplify the driver.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 drivers/input/misc/twl4030-pwrbutton.c | 26 ++++----------------------
 1 file changed, 4 insertions(+), 22 deletions(-)

diff --git a/drivers/input/misc/twl4030-pwrbutton.c b/drivers/input/misc/twl4030-pwrbutton.c
index 3efbb13..da30af0 100644
--- a/drivers/input/misc/twl4030-pwrbutton.c
+++ b/drivers/input/misc/twl4030-pwrbutton.c
@@ -58,7 +58,7 @@ static int twl4030_pwrbutton_probe(struct platform_device *pdev)
 	int irq = platform_get_irq(pdev, 0);
 	int err;
 
-	pwr = input_allocate_device();
+	pwr = devm_input_allocate_device(&pdev->dev);
 	if (!pwr) {
 		dev_err(&pdev->dev, "Can't allocate power button\n");
 		return -ENOMEM;
@@ -70,40 +70,23 @@ static int twl4030_pwrbutton_probe(struct platform_device *pdev)
 	pwr->phys = "twl4030_pwrbutton/input0";
 	pwr->dev.parent = &pdev->dev;
 
-	err = request_threaded_irq(irq, NULL, powerbutton_irq,
+	err = devm_request_threaded_irq(&pwr->dev, irq, NULL, powerbutton_irq,
 			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
 			"twl4030_pwrbutton", pwr);
 	if (err < 0) {
 		dev_err(&pdev->dev, "Can't get IRQ for pwrbutton: %d\n", err);
-		goto free_input_dev;
+		return err;
 	}
 
 	err = input_register_device(pwr);
 	if (err) {
 		dev_err(&pdev->dev, "Can't register power button: %d\n", err);
-		goto free_irq;
+		return err;
 	}
 
 	platform_set_drvdata(pdev, pwr);
 
 	return 0;
-
-free_irq:
-	free_irq(irq, pwr);
-free_input_dev:
-	input_free_device(pwr);
-	return err;
-}
-
-static int __exit twl4030_pwrbutton_remove(struct platform_device *pdev)
-{
-	struct input_dev *pwr = platform_get_drvdata(pdev);
-	int irq = platform_get_irq(pdev, 0);
-
-	free_irq(irq, pwr);
-	input_unregister_device(pwr);
-
-	return 0;
 }
 
 #if IS_ENABLED(CONFIG_OF)
@@ -116,7 +99,6 @@ MODULE_DEVICE_TABLE(of, twl4030_pwrbutton_dt_match_table);
 
 static struct platform_driver twl4030_pwrbutton_driver = {
 	.probe		= twl4030_pwrbutton_probe,
-	.remove		= __exit_p(twl4030_pwrbutton_remove),
 	.driver		= {
 		.name	= "twl4030_pwrbutton",
 		.owner	= THIS_MODULE,
-- 
1.8.4.rc3

