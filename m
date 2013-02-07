Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758324Ab3BGMvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 07:51:04 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:55518 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803Ab3BGMvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 07:51:01 -0500
From: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
To: <linux-i2c@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>
CC: <nsekhar@ti.com>, <khilman@deeprootsystems.com>, <ben-linux@fluff.org>,
        <w.sang@pengutronix.de>, <manishv.b@ti.com>
Subject: [PATCH V3] i2c: davinci: update to devm_* API
Date: Thu, 7 Feb 2013 18:22:00 +0530
Message-ID: <1360241520-11476-1-git-send-email-manishv.b@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the code to use devm_* API so that driver
core will manage resources.
Also, if "devm_request_and_ioremap" fails return -EADDRNOTAVAIL
instead of -EBUSY.

Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>
---
:100644 100644 6a0a553... 663ced8... M	drivers/i2c/busses/i2c-davinci.c
 drivers/i2c/busses/i2c-davinci.c |   47 +++++++++++--------------------------
 1 files changed, 14 insertions(+), 33 deletions(-)

Changes since V2:
  - if "devm_request_and_ioremap" fails return -EADDRNOTAVAIL
    instead of -EBUSY.
Changes since V1:
  - Rebase on top of v3.8-rc6 of linus tree.
  - Apply devm operation on clk_get.

diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index 6a0a553..663ced8 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -643,7 +643,7 @@ static int davinci_i2c_probe(struct platform_device *pdev)
 {
 	struct davinci_i2c_dev *dev;
 	struct i2c_adapter *adap;
-	struct resource *mem, *irq, *ioarea;
+	struct resource *mem, *irq;
 	int r;
 
 	/* NOTE: driver uses the static register mapping */
@@ -659,17 +659,11 @@ static int davinci_i2c_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	ioarea = request_mem_region(mem->start, resource_size(mem),
-				    pdev->name);
-	if (!ioarea) {
-		dev_err(&pdev->dev, "I2C region already claimed\n");
-		return -EBUSY;
-	}
-
-	dev = kzalloc(sizeof(struct davinci_i2c_dev), GFP_KERNEL);
+	dev = devm_kzalloc(&pdev->dev, sizeof(struct davinci_i2c_dev),
+			GFP_KERNEL);
 	if (!dev) {
-		r = -ENOMEM;
-		goto err_release_region;
+		dev_err(&pdev->dev, "Memory allocation failed\n");
+		return -ENOMEM;
 	}
 
 	init_completion(&dev->cmd_complete);
@@ -699,22 +693,24 @@ static int davinci_i2c_probe(struct platform_device *pdev)
 		dev->pdata = &davinci_i2c_platform_data_default;
 	}
 
-	dev->clk = clk_get(&pdev->dev, NULL);
+	dev->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(dev->clk)) {
 		r = -ENODEV;
 		goto err_free_mem;
 	}
 	clk_prepare_enable(dev->clk);
 
-	dev->base = ioremap(mem->start, resource_size(mem));
+	dev->base = devm_request_and_ioremap(&pdev->dev, mem);
 	if (!dev->base) {
-		r = -EBUSY;
-		goto err_mem_ioremap;
+		r = -EADDRNOTAVAIL;
+		dev_err(&pdev->dev, "I2C region already claimed\n");
+		goto err_unuse_clocks;
 	}
 
 	i2c_davinci_init(dev);
 
-	r = request_irq(dev->irq, i2c_davinci_isr, 0, pdev->name, dev);
+	r = devm_request_irq(&pdev->dev, dev->irq, i2c_davinci_isr, 0,
+			pdev->name, dev);
 	if (r) {
 		dev_err(&pdev->dev, "failure requesting irq %i\n", dev->irq);
 		goto err_unuse_clocks;
@@ -723,7 +719,7 @@ static int davinci_i2c_probe(struct platform_device *pdev)
 	r = i2c_davinci_cpufreq_register(dev);
 	if (r) {
 		dev_err(&pdev->dev, "failed to register cpufreq\n");
-		goto err_free_irq;
+		goto err_unuse_clocks;
 	}
 
 	adap = &dev->adapter;
@@ -740,26 +736,18 @@ static int davinci_i2c_probe(struct platform_device *pdev)
 	r = i2c_add_numbered_adapter(adap);
 	if (r) {
 		dev_err(&pdev->dev, "failure adding adapter\n");
-		goto err_free_irq;
+		goto err_unuse_clocks;
 	}
 	of_i2c_register_devices(adap);
 
 	return 0;
 
-err_free_irq:
-	free_irq(dev->irq, dev);
 err_unuse_clocks:
-	iounmap(dev->base);
-err_mem_ioremap:
 	clk_disable_unprepare(dev->clk);
-	clk_put(dev->clk);
 	dev->clk = NULL;
 err_free_mem:
 	platform_set_drvdata(pdev, NULL);
 	put_device(&pdev->dev);
-	kfree(dev);
-err_release_region:
-	release_mem_region(mem->start, resource_size(mem));
 
 	return r;
 }
@@ -767,7 +755,6 @@ err_release_region:
 static int davinci_i2c_remove(struct platform_device *pdev)
 {
 	struct davinci_i2c_dev *dev = platform_get_drvdata(pdev);
-	struct resource *mem;
 
 	i2c_davinci_cpufreq_deregister(dev);
 
@@ -776,16 +763,10 @@ static int davinci_i2c_remove(struct platform_device *pdev)
 	put_device(&pdev->dev);
 
 	clk_disable_unprepare(dev->clk);
-	clk_put(dev->clk);
 	dev->clk = NULL;
 
 	davinci_i2c_write_reg(dev, DAVINCI_I2C_MDR_REG, 0);
-	free_irq(dev->irq, dev);
-	iounmap(dev->base);
-	kfree(dev);
 
-	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(mem->start, resource_size(mem));
 	return 0;
 }
 
-- 
1.7.4.1

