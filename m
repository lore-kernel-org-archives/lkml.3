Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619Ab3EWPZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:25:52 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:43821 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759600Ab3EWPZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:25:49 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 12/16] mfd: htc-i2cpld: Convert to managed resources for allocating memory
Date: Thu, 23 May 2013 16:25:13 +0100
Message-Id: <1369322717-30429-12-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369322717-30429-1-git-send-email-lee.jones@linaro.org>
References: <1369322717-30429-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/htc-i2cpld.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/mfd/htc-i2cpld.c b/drivers/mfd/htc-i2cpld.c
index 324187c..c9dfce6 100644
--- a/drivers/mfd/htc-i2cpld.c
+++ b/drivers/mfd/htc-i2cpld.c
@@ -514,8 +514,8 @@ static int htcpld_setup_chips(struct platform_device *pdev)
 
 	/* Setup each chip's output GPIOs */
 	htcpld->nchips = pdata->num_chip;
-	htcpld->chip = kzalloc(sizeof(struct htcpld_chip) * htcpld->nchips,
-			       GFP_KERNEL);
+	htcpld->chip = devm_kzalloc(dev, sizeof(struct htcpld_chip) * htcpld->nchips,
+				    GFP_KERNEL);
 	if (!htcpld->chip) {
 		dev_warn(dev, "Unable to allocate memory for chips\n");
 		return -ENOMEM;
@@ -580,12 +580,11 @@ static int htcpld_core_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
-	htcpld = kzalloc(sizeof(struct htcpld_data), GFP_KERNEL);
+	htcpld = devm_kzalloc(dev, sizeof(struct htcpld_data), GFP_KERNEL);
 	if (!htcpld)
 		return -ENOMEM;
 
 	/* Find chained irq */
-	ret = -EINVAL;
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (res) {
 		int flags;
@@ -598,7 +597,7 @@ static int htcpld_core_probe(struct platform_device *pdev)
 					   flags, pdev->name, htcpld);
 		if (ret) {
 			dev_warn(dev, "Unable to setup chained irq handler: %d\n", ret);
-			goto fail;
+			return ret;
 		} else
 			device_init_wakeup(dev, 0);
 	}
@@ -609,7 +608,7 @@ static int htcpld_core_probe(struct platform_device *pdev)
 	/* Setup the htcpld chips */
 	ret = htcpld_setup_chips(pdev);
 	if (ret)
-		goto fail;
+		return ret;
 
 	/* Request the GPIO(s) for the int reset and set them up */
 	if (pdata->int_reset_gpio_hi) {
@@ -644,10 +643,6 @@ static int htcpld_core_probe(struct platform_device *pdev)
 
 	dev_info(dev, "Initialized successfully\n");
 	return 0;
-
-fail:
-	kfree(htcpld);
-	return ret;
 }
 
 /* The I2C Driver -- used internally */
-- 
1.7.10.4

