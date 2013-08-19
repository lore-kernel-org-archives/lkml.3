Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327Ab3HSLKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 07:10:30 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:40475 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab3HSLK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 07:10:28 -0400
From: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
To: jic23@cam.ac.uk, gg@slimlogic.co.uk, balajitk@ti.com
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] iio: adc: twl6030-gpadc: Use devm_* API family
Date: Mon, 19 Aug 2013 14:09:40 +0300
Message-Id: <1376910580-7545-1-git-send-email-oleksandr.kozaruk@ti.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using devm_iio_device_alloc and devm_request_threaded_irq makes
code simpler.

Signed-off-by: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
---
 drivers/iio/adc/twl6030-gpadc.c | 36 ++++++++++--------------------------
 1 file changed, 10 insertions(+), 26 deletions(-)

diff --git a/drivers/iio/adc/twl6030-gpadc.c b/drivers/iio/adc/twl6030-gpadc.c
index a80a049..a558516 100644
--- a/drivers/iio/adc/twl6030-gpadc.c
+++ b/drivers/iio/adc/twl6030-gpadc.c
@@ -893,11 +893,9 @@ static int twl6030_gpadc_probe(struct platform_device *pdev)
 
 	pdata = match->data;
 
-	indio_dev = iio_device_alloc(sizeof(*gpadc));
-	if (!indio_dev) {
-		dev_err(dev, "failed allocating iio device\n");
-		ret = -ENOMEM;
-	}
+	indio_dev = devm_iio_device_alloc(dev, sizeof(*gpadc));
+	if (!indio_dev)
+		return -ENOMEM;
 
 	gpadc = iio_priv(indio_dev);
 
@@ -905,7 +903,7 @@ static int twl6030_gpadc_probe(struct platform_device *pdev)
 					sizeof(*gpadc->twl6030_cal_tbl) *
 					pdata->nchannels, GFP_KERNEL);
 	if (!gpadc->twl6030_cal_tbl)
-		goto err_free_device;
+		return -ENOMEM;
 
 	gpadc->dev = dev;
 	gpadc->pdata = pdata;
@@ -917,33 +915,30 @@ static int twl6030_gpadc_probe(struct platform_device *pdev)
 	ret = pdata->calibrate(gpadc);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to read calibration registers\n");
-		goto err_free_device;
+		return ret;
 	}
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
 		dev_err(&pdev->dev, "failed to get irq\n");
-		goto err_free_device;
+		return irq;
 	}
 
-	ret = request_threaded_irq(irq, NULL, twl6030_gpadc_irq_handler,
+	ret = devm_request_threaded_irq(dev, irq, NULL,
+				twl6030_gpadc_irq_handler,
 				IRQF_ONESHOT, "twl6030_gpadc", indio_dev);
-	if (ret) {
-		dev_dbg(&pdev->dev, "could not request irq\n");
-		goto err_free_device;
-	}
 
 	ret = twl6030_gpadc_enable_irq(TWL6030_GPADC_RT_SW1_EOC_MASK);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to enable GPADC interrupt\n");
-		goto err_free_irq;
+		return ret;
 	}
 
 	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, TWL6030_GPADCS,
 					TWL6030_REG_TOGGLE1);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to enable GPADC module\n");
-		goto err_free_irq;
+		return ret;
 	}
 
 	indio_dev->name = DRIVER_NAME;
@@ -954,15 +949,6 @@ static int twl6030_gpadc_probe(struct platform_device *pdev)
 	indio_dev->num_channels = pdata->nchannels;
 
 	ret = iio_device_register(indio_dev);
-	if (ret)
-		goto err_free_irq;
-
-	return ret;
-
-err_free_irq:
-	free_irq(irq, indio_dev);
-err_free_device:
-	iio_device_free(indio_dev);
 
 	return ret;
 }
@@ -972,9 +958,7 @@ static int twl6030_gpadc_remove(struct platform_device *pdev)
 	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
 
 	twl6030_gpadc_disable_irq(TWL6030_GPADC_RT_SW1_EOC_MASK);
-	free_irq(platform_get_irq(pdev, 0), indio_dev);
 	iio_device_unregister(indio_dev);
-	iio_device_free(indio_dev);
 
 	return 0;
 }
-- 
1.8.1.2

