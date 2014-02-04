Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216AbaBDP7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 10:59:54 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:35615 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185AbaBDP7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 10:59:48 -0500
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Cc: Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Chris Ball <chris@printf.net>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 11/17] i2c: nomadik: Convert to devm functions
Date: Tue,  4 Feb 2014 16:58:52 +0100
Message-Id: <1391529538-21685-12-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_* functions to simplify code and error handling.

Cc: Alessandro Rubini <rubini@unipv.it>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/i2c/busses/i2c-nomadik.c |   29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/i2c/busses/i2c-nomadik.c b/drivers/i2c/busses/i2c-nomadik.c
index 4443613..840bcf9 100644
--- a/drivers/i2c/busses/i2c-nomadik.c
+++ b/drivers/i2c/busses/i2c-nomadik.c
@@ -1015,7 +1015,7 @@ static int nmk_i2c_probe(struct amba_device *adev, const struct amba_id *id)
 		pdata->rft = max_fifo_threshold;
 	}
 
-	dev = kzalloc(sizeof(struct nmk_i2c_dev), GFP_KERNEL);
+	dev = devm_kzalloc(&adev->dev, sizeof(struct nmk_i2c_dev), GFP_KERNEL);
 	if (!dev) {
 		dev_err(&adev->dev, "cannot allocate memory\n");
 		ret = -ENOMEM;
@@ -1031,27 +1031,28 @@ static int nmk_i2c_probe(struct amba_device *adev, const struct amba_id *id)
 	/* If possible, let's go to idle until the first transfer */
 	pinctrl_pm_select_idle_state(&adev->dev);
 
-	dev->virtbase = ioremap(adev->res.start, resource_size(&adev->res));
+	dev->virtbase = devm_ioremap(&adev->dev, adev->res.start,
+				resource_size(&adev->res));
 	if (!dev->virtbase) {
 		ret = -ENOMEM;
-		goto err_no_ioremap;
+		goto err_no_mem;
 	}
 
 	dev->irq = adev->irq[0];
-	ret = request_irq(dev->irq, i2c_irq_handler, 0,
+	ret = devm_request_irq(&adev->dev, dev->irq, i2c_irq_handler, 0,
 				DRIVER_NAME, dev);
 	if (ret) {
 		dev_err(&adev->dev, "cannot claim the irq %d\n", dev->irq);
-		goto err_irq;
+		goto err_no_mem;
 	}
 
 	pm_suspend_ignore_children(&adev->dev, true);
 
-	dev->clk = clk_get(&adev->dev, NULL);
+	dev->clk = devm_clk_get(&adev->dev, NULL);
 	if (IS_ERR(dev->clk)) {
 		dev_err(&adev->dev, "could not get i2c clock\n");
 		ret = PTR_ERR(dev->clk);
-		goto err_no_clk;
+		goto err_no_mem;
 	}
 
 	adap = &dev->adap;
@@ -1079,21 +1080,13 @@ static int nmk_i2c_probe(struct amba_device *adev, const struct amba_id *id)
 	ret = i2c_add_adapter(adap);
 	if (ret) {
 		dev_err(&adev->dev, "failed to add adapter\n");
-		goto err_add_adap;
+		goto err_no_mem;
 	}
 
 	pm_runtime_put(&adev->dev);
 
 	return 0;
 
- err_add_adap:
-	clk_put(dev->clk);
- err_no_clk:
-	free_irq(dev->irq, dev);
- err_irq:
-	iounmap(dev->virtbase);
- err_no_ioremap:
-	kfree(dev);
  err_no_mem:
 
 	return ret;
@@ -1110,13 +1103,9 @@ static int nmk_i2c_remove(struct amba_device *adev)
 	clear_all_interrupts(dev);
 	/* disable the controller */
 	i2c_clr_bit(dev->virtbase + I2C_CR, I2C_CR_PE);
-	free_irq(dev->irq, dev);
-	iounmap(dev->virtbase);
 	if (res)
 		release_mem_region(res->start, resource_size(res));
-	clk_put(dev->clk);
 	pm_runtime_disable(&adev->dev);
-	kfree(dev);
 
 	return 0;
 }
-- 
1.7.9.5

