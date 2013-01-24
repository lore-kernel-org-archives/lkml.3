Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab3AXKVI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:21:08 -0500
Received: from mail-da0-f54.google.com ([209.85.210.54]:56154 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab3AXKUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:20:14 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: w.sang@pengutronix.de, kgene.kim@samsung.com, patches@linaro.org
Subject: [PATCH V3 2/4] i2c: s3c2410: Convert to use devm_* APIs
Date: Thu, 24 Jan 2013 15:41:07 +0530
Message-Id: <1359022269-12593-3-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359022269-12593-1-git-send-email-tushar.behera@linaro.org>
References: <1359022269-12593-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i2c-s3c2410 driver is modified to use devm_clk_get()
and devm_request_irq(). This also simplifies the
return path in driver's probe.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
Changes since V2:
  * Rebased on v3.8-rc4. devm_request_and_ioremap implementaion
has already been merged.
Changes since V1:
  * devm_request_mem_region and devm_ioremap calls were replaced by
devm_request_and_ioremap() call.
  * All devm_* related modifications (earlier patches 2-5) were merged
to a single patch.

 drivers/i2c/busses/i2c-s3c2410.c |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index b7ca1f4..4b6cc13 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -1022,7 +1022,7 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 	/* find the clock and enable it */
 
 	i2c->dev = &pdev->dev;
-	i2c->clk = clk_get(&pdev->dev, "i2c");
+	i2c->clk = devm_clk_get(&pdev->dev, "i2c");
 	if (IS_ERR(i2c->clk)) {
 		dev_err(&pdev->dev, "cannot get clock\n");
 		return -ENOENT;
@@ -1044,7 +1044,7 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 	i2c->regs = devm_request_and_ioremap(&pdev->dev, res);
 
 	if (i2c->regs == NULL) {
-		dev_err(&pdev->dev, "cannot map IO\n");
+		dev_err(&pdev->dev, "cannot request and map IO\n");
 		ret = -ENXIO;
 		goto err_clk;
 	}
@@ -1084,8 +1084,8 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 		goto err_clk;
 	}
 
-	ret = request_irq(i2c->irq, s3c24xx_i2c_irq, 0,
-			  dev_name(&pdev->dev), i2c);
+	ret = devm_request_irq(&pdev->dev, i2c->irq, s3c24xx_i2c_irq, 0,
+			       dev_name(&pdev->dev), i2c);
 
 	if (ret != 0) {
 		dev_err(&pdev->dev, "cannot claim IRQ %d\n", i2c->irq);
@@ -1095,7 +1095,7 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 	ret = s3c24xx_i2c_register_cpufreq(i2c);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to register cpufreq notifier\n");
-		goto err_irq;
+		goto err_clk;
 	}
 
 	/* Note, previous versions of the driver used i2c_add_adapter()
@@ -1126,12 +1126,8 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
  err_cpufreq:
 	s3c24xx_i2c_deregister_cpufreq(i2c);
 
- err_irq:
-	free_irq(i2c->irq, i2c);
-
  err_clk:
 	clk_disable_unprepare(i2c->clk);
-	clk_put(i2c->clk);
 	return ret;
 }
 
@@ -1150,10 +1146,8 @@ static int s3c24xx_i2c_remove(struct platform_device *pdev)
 	s3c24xx_i2c_deregister_cpufreq(i2c);
 
 	i2c_del_adapter(&i2c->adap);
-	free_irq(i2c->irq, i2c);
 
 	clk_disable_unprepare(i2c->clk);
-	clk_put(i2c->clk);
 
 	if (pdev->dev.of_node && IS_ERR(i2c->pctrl))
 		s3c24xx_i2c_dt_gpio_free(i2c);
-- 
1.7.4.1

