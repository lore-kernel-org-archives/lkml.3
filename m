Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbaBZUD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 15:03:27 -0500
Received: from ring0.de ([5.45.105.125]:53265 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbaBZUDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 15:03:25 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, Marek Belisko <marek@goldelico.com>,
        Jonathan Cameron <jic23@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-iio@vger.kernel.org,
        Sebastian Reichel <sre@debian.org>
Subject: [RFCv4 1/7] mfd: twl4030-madc: Use managed resources
Date: Wed, 26 Feb 2014 21:03:04 +0100
Message-Id: <1393444990-28140-2-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393444990-28140-1-git-send-email-sre@debian.org>
References: <1393374270-20079-1-git-send-email-sre@debian.org>
 <1393444990-28140-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update twl4030-madc driver to use managed resources.

Signed-off-by: Sebastian Reichel <sre@debian.org>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/twl4030-madc.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/twl4030-madc.c b/drivers/mfd/twl4030-madc.c
index 4c583e4..5458561 100644
--- a/drivers/mfd/twl4030-madc.c
+++ b/drivers/mfd/twl4030-madc.c
@@ -702,14 +702,14 @@ static int twl4030_madc_probe(struct platform_device *pdev)
 {
 	struct twl4030_madc_data *madc;
 	struct twl4030_madc_platform_data *pdata = dev_get_platdata(&pdev->dev);
-	int ret;
+	int irq, ret;
 	u8 regval;
 
 	if (!pdata) {
 		dev_err(&pdev->dev, "platform_data not available\n");
 		return -EINVAL;
 	}
-	madc = kzalloc(sizeof(*madc), GFP_KERNEL);
+	madc = devm_kzalloc(&pdev->dev, sizeof(*madc), GFP_KERNEL);
 	if (!madc)
 		return -ENOMEM;
 
@@ -726,7 +726,7 @@ static int twl4030_madc_probe(struct platform_device *pdev)
 	    TWL4030_MADC_ISR1 : TWL4030_MADC_ISR2;
 	ret = twl4030_madc_set_power(madc, 1);
 	if (ret < 0)
-		goto err_power;
+		return ret;
 	ret = twl4030_madc_set_current_generator(madc, 0, 1);
 	if (ret < 0)
 		goto err_current_generator;
@@ -770,7 +770,9 @@ static int twl4030_madc_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, madc);
 	mutex_init(&madc->lock);
-	ret = request_threaded_irq(platform_get_irq(pdev, 0), NULL,
+
+	irq = platform_get_irq(pdev, 0);
+	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
 				   twl4030_madc_threaded_irq_handler,
 				   IRQF_TRIGGER_RISING, "twl4030_madc", madc);
 	if (ret) {
@@ -783,9 +785,6 @@ err_i2c:
 	twl4030_madc_set_current_generator(madc, 0, 0);
 err_current_generator:
 	twl4030_madc_set_power(madc, 0);
-err_power:
-	kfree(madc);
-
 	return ret;
 }
 
@@ -793,10 +792,8 @@ static int twl4030_madc_remove(struct platform_device *pdev)
 {
 	struct twl4030_madc_data *madc = platform_get_drvdata(pdev);
 
-	free_irq(platform_get_irq(pdev, 0), madc);
 	twl4030_madc_set_current_generator(madc, 0, 0);
 	twl4030_madc_set_power(madc, 0);
-	kfree(madc);
 
 	return 0;
 }
-- 
1.8.5.3

