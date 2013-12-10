Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab3LJXov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 18:44:51 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:38972 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab3LJXnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 18:43:19 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org
Subject: [PATCH 3/7] Input: pm8xxx-vibrator - Migrate to devm_* APIs
Date: Tue, 10 Dec 2013 15:43:12 -0800
Message-Id: <1386718996-3733-4-git-send-email-sboyd@codeaurora.org>
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
 drivers/input/misc/pm8xxx-vibrator.c | 44 +++++++++++-------------------------
 1 file changed, 13 insertions(+), 31 deletions(-)

diff --git a/drivers/input/misc/pm8xxx-vibrator.c b/drivers/input/misc/pm8xxx-vibrator.c
index ec086f6..2a92ab0 100644
--- a/drivers/input/misc/pm8xxx-vibrator.c
+++ b/drivers/input/misc/pm8xxx-vibrator.c
@@ -186,13 +186,13 @@ static int pm8xxx_vib_probe(struct platform_device *pdev)
 	int error;
 	u8 val;
 
-	vib = kzalloc(sizeof(*vib), GFP_KERNEL);
-	input_dev = input_allocate_device();
-	if (!vib || !input_dev) {
-		dev_err(&pdev->dev, "couldn't allocate memory\n");
-		error = -ENOMEM;
-		goto err_free_mem;
-	}
+	vib = devm_kzalloc(&pdev->dev, sizeof(*vib), GFP_KERNEL);
+	if (!vib)
+		return -ENOMEM;
+
+	input_dev = devm_input_allocate_device(&pdev->dev);
+	if (!input_dev)
+		return -ENOMEM;
 
 	INIT_WORK(&vib->work, pm8xxx_work_handler);
 	vib->dev = &pdev->dev;
@@ -201,17 +201,17 @@ static int pm8xxx_vib_probe(struct platform_device *pdev)
 	/* operate in manual mode */
 	error = pm8xxx_vib_read_u8(vib, &val, VIB_DRV);
 	if (error < 0)
-		goto err_free_mem;
+		return error;
+
 	val &= ~VIB_DRV_EN_MANUAL_MASK;
 	error = pm8xxx_vib_write_u8(vib, val, VIB_DRV);
 	if (error < 0)
-		goto err_free_mem;
+		return error;
 
 	vib->reg_vib_drv = val;
 
 	input_dev->name = "pm8xxx_vib_ffmemless";
 	input_dev->id.version = 1;
-	input_dev->dev.parent = &pdev->dev;
 	input_dev->close = pm8xxx_vib_close;
 	input_set_drvdata(input_dev, vib);
 	input_set_capability(vib->vib_input_dev, EV_FF, FF_RUMBLE);
@@ -221,35 +221,18 @@ static int pm8xxx_vib_probe(struct platform_device *pdev)
 	if (error) {
 		dev_err(&pdev->dev,
 			"couldn't register vibrator as FF device\n");
-		goto err_free_mem;
+		return error;
 	}
 
 	error = input_register_device(input_dev);
 	if (error) {
 		dev_err(&pdev->dev, "couldn't register input device\n");
-		goto err_destroy_memless;
+		input_ff_destroy(input_dev);
+		return error;
 	}
 
 	platform_set_drvdata(pdev, vib);
 	return 0;
-
-err_destroy_memless:
-	input_ff_destroy(input_dev);
-err_free_mem:
-	input_free_device(input_dev);
-	kfree(vib);
-
-	return error;
-}
-
-static int pm8xxx_vib_remove(struct platform_device *pdev)
-{
-	struct pm8xxx_vib *vib = platform_get_drvdata(pdev);
-
-	input_unregister_device(vib->vib_input_dev);
-	kfree(vib);
-
-	return 0;
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -268,7 +251,6 @@ static SIMPLE_DEV_PM_OPS(pm8xxx_vib_pm_ops, pm8xxx_vib_suspend, NULL);
 
 static struct platform_driver pm8xxx_vib_driver = {
 	.probe		= pm8xxx_vib_probe,
-	.remove		= pm8xxx_vib_remove,
 	.driver		= {
 		.name	= "pm8xxx-vib",
 		.owner	= THIS_MODULE,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

