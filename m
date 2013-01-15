Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203Ab3AOM6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 07:58:48 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39247 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756972Ab3AOM5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:57:04 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, sameo@linux.intel.com,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 22/26] mfd: ab8500-gpadc: Add runtime pm support
Date: Tue, 15 Jan 2013 12:56:02 +0000
Message-Id: <1358254566-12419-23-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

Add runtime pm support to speed up multiple ADC reads in a row.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Reviewed-by: Ulf HANSSON <ulf.hansson@stericsson.com>
---
 drivers/mfd/ab8500-gpadc.c |   70 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 64 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/ab8500-gpadc.c b/drivers/mfd/ab8500-gpadc.c
index 6f97c599..1fd8f78 100644
--- a/drivers/mfd/ab8500-gpadc.c
+++ b/drivers/mfd/ab8500-gpadc.c
@@ -12,6 +12,7 @@
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
 #include <linux/delay.h>
+#include <linux/pm_runtime.h>
 #include <linux/platform_device.h>
 #include <linux/completion.h>
 #include <linux/regulator/consumer.h>
@@ -82,6 +83,9 @@
 /* This is used to not lose precision when dividing to get gain and offset */
 #define CALIB_SCALE			1000
 
+/* Time in ms before disabling regulator */
+#define GPADC_AUDOSUSPEND_DELAY		1
+
 enum cal_channels {
 	ADC_INPUT_VMAIN = 0,
 	ADC_INPUT_BTEMP,
@@ -282,8 +286,9 @@ int ab8500_gpadc_read_raw(struct ab8500_gpadc *gpadc, u8 channel)
 		return -ENODEV;
 
 	mutex_lock(&gpadc->ab8500_gpadc_lock);
+
 	/* Enable VTVout LDO this is required for GPADC */
-	regulator_enable(gpadc->regu);
+	pm_runtime_get_sync(gpadc->dev);
 
 	/* Check if ADC is not busy, lock and proceed */
 	do {
@@ -397,8 +402,10 @@ int ab8500_gpadc_read_raw(struct ab8500_gpadc *gpadc, u8 channel)
 		dev_err(gpadc->dev, "gpadc_conversion: disable gpadc failed\n");
 		goto out;
 	}
-	/* Disable VTVout LDO this is required for GPADC */
-	regulator_disable(gpadc->regu);
+
+	pm_runtime_mark_last_busy(gpadc->dev);
+	pm_runtime_put_autosuspend(gpadc->dev);
+
 	mutex_unlock(&gpadc->ab8500_gpadc_lock);
 
 	return (high_data << 8) | low_data;
@@ -412,7 +419,9 @@ out:
 	 */
 	(void) abx500_set_register_interruptible(gpadc->dev, AB8500_GPADC,
 		AB8500_GPADC_CTRL1_REG, DIS_GPADC);
-	regulator_disable(gpadc->regu);
+
+	pm_runtime_put(gpadc->dev);
+
 	mutex_unlock(&gpadc->ab8500_gpadc_lock);
 	dev_err(gpadc->dev,
 		"gpadc_conversion: Failed to AD convert channel %d\n", channel);
@@ -571,6 +580,30 @@ static void ab8500_gpadc_read_calibration_data(struct ab8500_gpadc *gpadc)
 		gpadc->cal_data[ADC_INPUT_VBAT].offset);
 }
 
+static int ab8500_gpadc_runtime_suspend(struct device *dev)
+{
+	struct ab8500_gpadc *gpadc = dev_get_drvdata(dev);
+
+	regulator_disable(gpadc->regu);
+	return 0;
+}
+
+static int ab8500_gpadc_runtime_resume(struct device *dev)
+{
+	struct ab8500_gpadc *gpadc = dev_get_drvdata(dev);
+
+	regulator_enable(gpadc->regu);
+	return 0;
+}
+
+static int ab8500_gpadc_runtime_idle(struct device *dev)
+{
+	struct ab8500_gpadc *gpadc = dev_get_drvdata(dev);
+
+	pm_runtime_suspend(dev);
+	return 0;
+}
+
 static int __devinit ab8500_gpadc_probe(struct platform_device *pdev)
 {
 	int ret = 0;
@@ -615,6 +648,16 @@ static int __devinit ab8500_gpadc_probe(struct platform_device *pdev)
 		dev_err(gpadc->dev, "failed to get vtvout LDO\n");
 		goto fail_irq;
 	}
+
+	platform_set_drvdata(pdev, gpadc);
+
+	regulator_enable(gpadc->regu);
+
+	pm_runtime_set_autosuspend_delay(gpadc->dev, GPADC_AUDOSUSPEND_DELAY);
+	pm_runtime_use_autosuspend(gpadc->dev);
+	pm_runtime_set_active(gpadc->dev);
+	pm_runtime_enable(gpadc->dev);
+
 	ab8500_gpadc_read_calibration_data(gpadc);
 	list_add_tail(&gpadc->node, &ab8500_gpadc_list);
 	dev_dbg(gpadc->dev, "probe success\n");
@@ -635,19 +678,34 @@ static int __devexit ab8500_gpadc_remove(struct platform_device *pdev)
 	list_del(&gpadc->node);
 	/* remove interrupt  - completion of Sw ADC conversion */
 	free_irq(gpadc->irq, gpadc);
-	/* disable VTVout LDO that is being used by GPADC */
-	regulator_put(gpadc->regu);
+
+	pm_runtime_get_sync(gpadc->dev);
+	pm_runtime_disable(gpadc->dev);
+
+	regulator_disable(gpadc->regu);
+
+	pm_runtime_set_suspended(gpadc->dev);
+
+	pm_runtime_put_noidle(gpadc->dev);
+
 	kfree(gpadc);
 	gpadc = NULL;
 	return 0;
 }
 
+static const struct dev_pm_ops ab8500_gpadc_pm_ops = {
+	SET_RUNTIME_PM_OPS(ab8500_gpadc_runtime_suspend,
+			   ab8500_gpadc_runtime_resume,
+			   ab8500_gpadc_runtime_idle)
+};
+
 static struct platform_driver ab8500_gpadc_driver = {
 	.probe = ab8500_gpadc_probe,
 	.remove = __devexit_p(ab8500_gpadc_remove),
 	.driver = {
 		.name = "ab8500-gpadc",
 		.owner = THIS_MODULE,
+		.pm = &ab8500_gpadc_pm_ops,
 	},
 };
 
-- 
1.7.9.5

