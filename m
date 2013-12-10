Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686Ab3LJXoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 18:44:16 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:38985 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab3LJXnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 18:43:20 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org
Subject: [PATCH 6/7] Input: pmic8xxx-keypad - Migrate to devm_* APIs
Date: Tue, 10 Dec 2013 15:43:15 -0800
Message-Id: <1386718996-3733-7-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.1.109.g3d252a9
In-Reply-To: <1386718996-3733-1-git-send-email-sboyd@codeaurora.org>
References: <1386718996-3733-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify the error paths and reduce the lines of code in this
driver by using the devm_* APIs.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/input/keyboard/pmic8xxx-keypad.c | 62 +++++++++-----------------------
 1 file changed, 17 insertions(+), 45 deletions(-)

diff --git a/drivers/input/keyboard/pmic8xxx-keypad.c b/drivers/input/keyboard/pmic8xxx-keypad.c
index 2c9f19a..4e6bfbf 100644
--- a/drivers/input/keyboard/pmic8xxx-keypad.c
+++ b/drivers/input/keyboard/pmic8xxx-keypad.c
@@ -586,7 +586,7 @@ static int pmic8xxx_kp_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	kp = kzalloc(sizeof(*kp), GFP_KERNEL);
+	kp = devm_kzalloc(&pdev->dev, sizeof(*kp), GFP_KERNEL);
 	if (!kp)
 		return -ENOMEM;
 
@@ -595,32 +595,27 @@ static int pmic8xxx_kp_probe(struct platform_device *pdev)
 	kp->pdata	= pdata;
 	kp->dev		= &pdev->dev;
 
-	kp->input = input_allocate_device();
+	kp->input = devm_input_allocate_device(&pdev->dev);
 	if (!kp->input) {
 		dev_err(&pdev->dev, "unable to allocate input device\n");
-		rc = -ENOMEM;
-		goto err_alloc_device;
+		return -ENOMEM;
 	}
 
 	kp->key_sense_irq = platform_get_irq(pdev, 0);
 	if (kp->key_sense_irq < 0) {
 		dev_err(&pdev->dev, "unable to get keypad sense irq\n");
-		rc = -ENXIO;
-		goto err_get_irq;
+		return kp->key_sense_irq;
 	}
 
 	kp->key_stuck_irq = platform_get_irq(pdev, 1);
 	if (kp->key_stuck_irq < 0) {
 		dev_err(&pdev->dev, "unable to get keypad stuck irq\n");
-		rc = -ENXIO;
-		goto err_get_irq;
+		return kp->key_stuck_irq;
 	}
 
 	kp->input->name = pdata->input_name ? : "PMIC8XXX keypad";
 	kp->input->phys = pdata->input_phys_device ? : "pmic8xxx_keypad/input0";
 
-	kp->input->dev.parent	= &pdev->dev;
-
 	kp->input->id.bustype	= BUS_I2C;
 	kp->input->id.version	= 0x0001;
 	kp->input->id.product	= 0x0001;
@@ -634,7 +629,7 @@ static int pmic8xxx_kp_probe(struct platform_device *pdev)
 					kp->keycodes, kp->input);
 	if (rc) {
 		dev_err(&pdev->dev, "failed to build keymap\n");
-		goto err_get_irq;
+		return rc;
 	}
 
 	if (pdata->rep)
@@ -650,7 +645,7 @@ static int pmic8xxx_kp_probe(struct platform_device *pdev)
 	rc = pmic8xxx_kpd_init(kp);
 	if (rc < 0) {
 		dev_err(&pdev->dev, "unable to initialize keypad controller\n");
-		goto err_get_irq;
+		return rc;
 	}
 
 	rc = pmic8xxx_kp_config_gpio(pdata->cols_gpio_start,
@@ -667,24 +662,26 @@ static int pmic8xxx_kp_probe(struct platform_device *pdev)
 		goto err_gpio_config;
 	}
 
-	rc = request_any_context_irq(kp->key_sense_irq, pmic8xxx_kp_irq,
-				 IRQF_TRIGGER_RISING, "pmic-keypad", kp);
+	rc = devm_request_any_context_irq(&pdev->dev, kp->key_sense_irq,
+			pmic8xxx_kp_irq, IRQF_TRIGGER_RISING, "pmic-keypad",
+			kp);
 	if (rc < 0) {
 		dev_err(&pdev->dev, "failed to request keypad sense irq\n");
-		goto err_get_irq;
+		return rc;
 	}
 
-	rc = request_any_context_irq(kp->key_stuck_irq, pmic8xxx_kp_stuck_irq,
-				 IRQF_TRIGGER_RISING, "pmic-keypad-stuck", kp);
+	rc = devm_request_any_context_irq(&pdev->dev, kp->key_stuck_irq,
+			pmic8xxx_kp_stuck_irq, IRQF_TRIGGER_RISING,
+			"pmic-keypad-stuck", kp);
 	if (rc < 0) {
 		dev_err(&pdev->dev, "failed to request keypad stuck irq\n");
-		goto err_req_stuck_irq;
+		return rc;
 	}
 
 	rc = pmic8xxx_kp_read_u8(kp, &ctrl_val, KEYP_CTRL);
 	if (rc < 0) {
 		dev_err(&pdev->dev, "failed to read KEYP_CTRL register\n");
-		goto err_pmic_reg_read;
+		return rc;
 	}
 
 	kp->ctrl_reg = ctrl_val;
@@ -692,36 +689,12 @@ static int pmic8xxx_kp_probe(struct platform_device *pdev)
 	rc = input_register_device(kp->input);
 	if (rc < 0) {
 		dev_err(&pdev->dev, "unable to register keypad input device\n");
-		goto err_pmic_reg_read;
+		return rc;
 	}
 
 	device_init_wakeup(&pdev->dev, pdata->wakeup);
 
 	return 0;
-
-err_pmic_reg_read:
-	free_irq(kp->key_stuck_irq, kp);
-err_req_stuck_irq:
-	free_irq(kp->key_sense_irq, kp);
-err_gpio_config:
-err_get_irq:
-	input_free_device(kp->input);
-err_alloc_device:
-	kfree(kp);
-	return rc;
-}
-
-static int pmic8xxx_kp_remove(struct platform_device *pdev)
-{
-	struct pmic8xxx_kp *kp = platform_get_drvdata(pdev);
-
-	device_init_wakeup(&pdev->dev, 0);
-	free_irq(kp->key_stuck_irq, kp);
-	free_irq(kp->key_sense_irq, kp);
-	input_unregister_device(kp->input);
-	kfree(kp);
-
-	return 0;
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -771,7 +744,6 @@ static SIMPLE_DEV_PM_OPS(pm8xxx_kp_pm_ops,
 
 static struct platform_driver pmic8xxx_kp_driver = {
 	.probe		= pmic8xxx_kp_probe,
-	.remove		= pmic8xxx_kp_remove,
 	.driver		= {
 		.name = PM8XXX_KEYPAD_DEV_NAME,
 		.owner = THIS_MODULE,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

