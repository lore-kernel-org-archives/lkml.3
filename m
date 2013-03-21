Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678Ab3CUMJm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 08:09:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:55767 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757768Ab3CUMIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 08:08:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,884,1355126400"; 
   d="scan'208";a="305573500"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        ben-linux@fluff.org, Jean Delvare <khali@linux-fr.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 1/7] i2c-designware: move to managed functions (devm_*)
Date: Thu, 21 Mar 2013 14:09:54 +0200
Message-Id: <1363867800-23861-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

This makes the error handling much more simpler than open-coding everything
and in addition makes the probe function smaller and tidier.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/i2c/busses/i2c-designware-platdrv.c |   73 ++++++++-------------------
 1 file changed, 20 insertions(+), 53 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index 0ceb6e1..c19c4ce 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -92,7 +92,7 @@ static int dw_i2c_probe(struct platform_device *pdev)
 {
 	struct dw_i2c_dev *dev;
 	struct i2c_adapter *adap;
-	struct resource *mem, *ioarea;
+	struct resource *mem;
 	int irq, r;
 
 	/* NOTE: driver uses the static register mapping */
@@ -108,32 +108,27 @@ static int dw_i2c_probe(struct platform_device *pdev)
 		return irq; /* -ENXIO */
 	}
 
-	ioarea = request_mem_region(mem->start, resource_size(mem),
-			pdev->name);
-	if (!ioarea) {
-		dev_err(&pdev->dev, "I2C region already claimed\n");
-		return -EBUSY;
-	}
+	dev = devm_kzalloc(&pdev->dev, sizeof(struct dw_i2c_dev), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
 
-	dev = kzalloc(sizeof(struct dw_i2c_dev), GFP_KERNEL);
-	if (!dev) {
-		r = -ENOMEM;
-		goto err_release_region;
+	dev->base = devm_ioremap_resource(&pdev->dev, mem);
+	if (IS_ERR(dev->base)) {
+		dev_err(&pdev->dev, "I2C region already claimed\n");
+		return PTR_ERR(dev->base);
 	}
 
 	init_completion(&dev->cmd_complete);
 	mutex_init(&dev->lock);
-	dev->dev = get_device(&pdev->dev);
+	dev->dev = &pdev->dev;
 	dev->irq = irq;
 	platform_set_drvdata(pdev, dev);
 
-	dev->clk = clk_get(&pdev->dev, NULL);
+	dev->clk = devm_clk_get(&pdev->dev, NULL);
 	dev->get_clk_rate_khz = i2c_dw_get_clk_rate_khz;
 
-	if (IS_ERR(dev->clk)) {
-		r = -ENODEV;
-		goto err_free_mem;
-	}
+	if (IS_ERR(dev->clk))
+		return PTR_ERR(dev->clk);
 	clk_prepare_enable(dev->clk);
 
 	dev->functionality =
@@ -146,13 +141,6 @@ static int dw_i2c_probe(struct platform_device *pdev)
 	dev->master_cfg =  DW_IC_CON_MASTER | DW_IC_CON_SLAVE_DISABLE |
 		DW_IC_CON_RESTART_EN | DW_IC_CON_SPEED_FAST;
 
-	dev->base = ioremap(mem->start, resource_size(mem));
-	if (dev->base == NULL) {
-		dev_err(&pdev->dev, "failure mapping io resources\n");
-		r = -EBUSY;
-		goto err_unuse_clocks;
-	}
-
 	/* Try first if we can configure the device from ACPI */
 	r = dw_i2c_acpi_configure(pdev);
 	if (r) {
@@ -164,13 +152,14 @@ static int dw_i2c_probe(struct platform_device *pdev)
 	}
 	r = i2c_dw_init(dev);
 	if (r)
-		goto err_iounmap;
+		return r;
 
 	i2c_dw_disable_int(dev);
-	r = request_irq(dev->irq, i2c_dw_isr, IRQF_SHARED, pdev->name, dev);
+	r = devm_request_irq(&pdev->dev, dev->irq, i2c_dw_isr, IRQF_SHARED,
+			pdev->name, dev);
 	if (r) {
 		dev_err(&pdev->dev, "failure requesting irq %i\n", dev->irq);
-		goto err_iounmap;
+		return r;
 	}
 
 	adap = &dev->adapter;
@@ -187,57 +176,35 @@ static int dw_i2c_probe(struct platform_device *pdev)
 	r = i2c_add_numbered_adapter(adap);
 	if (r) {
 		dev_err(&pdev->dev, "failure adding adapter\n");
-		goto err_free_irq;
+		return r;
 	}
 	of_i2c_register_devices(adap);
 	acpi_i2c_register_devices(adap);
 
+	/* Increase reference counter */
+	get_device(&pdev->dev);
+
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_put(&pdev->dev);
 
 	return 0;
-
-err_free_irq:
-	free_irq(dev->irq, dev);
-err_iounmap:
-	iounmap(dev->base);
-err_unuse_clocks:
-	clk_disable_unprepare(dev->clk);
-	clk_put(dev->clk);
-	dev->clk = NULL;
-err_free_mem:
-	put_device(&pdev->dev);
-	kfree(dev);
-err_release_region:
-	release_mem_region(mem->start, resource_size(mem));
-
-	return r;
 }
 
 static int dw_i2c_remove(struct platform_device *pdev)
 {
 	struct dw_i2c_dev *dev = platform_get_drvdata(pdev);
-	struct resource *mem;
 
 	pm_runtime_get_sync(&pdev->dev);
 
 	i2c_del_adapter(&dev->adapter);
 	put_device(&pdev->dev);
 
-	clk_disable_unprepare(dev->clk);
-	clk_put(dev->clk);
-	dev->clk = NULL;
-
 	i2c_dw_disable(dev);
-	free_irq(dev->irq, dev);
-	kfree(dev);
 
 	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
-	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(mem->start, resource_size(mem));
 	return 0;
 }
 
-- 
1.7.10.4

