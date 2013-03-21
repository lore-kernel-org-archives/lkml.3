Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095Ab3CUMIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 08:08:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:54055 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757792Ab3CUMIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 08:08:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,884,1355126400"; 
   d="scan'208";a="305573501"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        ben-linux@fluff.org, Jean Delvare <khali@linux-fr.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 3/7] i2c-designware-pci: use managed functions pcim_* and devm_*
Date: Thu, 21 Mar 2013 14:09:56 +0200
Message-Id: <1363867800-23861-3-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363867800-23861-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1363867800-23861-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

This makes the error handling much more simpler than open-coding everything
and in addition makes the probe function smaller an tidier.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/i2c/busses/i2c-designware-pcidrv.c |   68 +++++++---------------------
 1 file changed, 17 insertions(+), 51 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/busses/i2c-designware-pcidrv.c
index eed149d..aacb64e 100644
--- a/drivers/i2c/busses/i2c-designware-pcidrv.c
+++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
@@ -212,8 +212,6 @@ static int i2c_dw_pci_probe(struct pci_dev *pdev,
 {
 	struct dw_i2c_dev *dev;
 	struct i2c_adapter *adap;
-	unsigned long start, len;
-	void __iomem *base;
 	int r;
 	struct  dw_pci_controller *controller;
 
@@ -225,51 +223,30 @@ static int i2c_dw_pci_probe(struct pci_dev *pdev,
 
 	controller = &dw_pci_controllers[id->driver_data];
 
-	r = pci_enable_device(pdev);
+	r = pcim_enable_device(pdev);
 	if (r) {
 		dev_err(&pdev->dev, "Failed to enable I2C PCI device (%d)\n",
 			r);
-		goto exit;
+		return r;
 	}
 
-	/* Determine the address of the I2C area */
-	start = pci_resource_start(pdev, 0);
-	len = pci_resource_len(pdev, 0);
-	if (!start || len == 0) {
-		dev_err(&pdev->dev, "base address not set\n");
-		r = -ENODEV;
-		goto exit;
-	}
-
-	r = pci_request_region(pdev, 0, DRIVER_NAME);
+	r = pcim_iomap_regions(pdev, 1 << 0, pci_name(pdev));
 	if (r) {
-		dev_err(&pdev->dev, "failed to request I2C region "
-			"0x%lx-0x%lx\n", start,
-			(unsigned long)pci_resource_end(pdev, 0));
-		goto exit;
-	}
-
-	base = ioremap_nocache(start, len);
-	if (!base) {
 		dev_err(&pdev->dev, "I/O memory remapping failed\n");
-		r = -ENOMEM;
-		goto err_release_region;
+		return r;
 	}
 
-
-	dev = kzalloc(sizeof(struct dw_i2c_dev), GFP_KERNEL);
-	if (!dev) {
-		r = -ENOMEM;
-		goto err_release_region;
-	}
+	dev = devm_kzalloc(&pdev->dev, sizeof(struct dw_i2c_dev), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
 
 	init_completion(&dev->cmd_complete);
 	mutex_init(&dev->lock);
 	dev->clk = NULL;
 	dev->controller = controller;
 	dev->get_clk_rate_khz = i2c_dw_get_clk_rate_khz;
-	dev->base = base;
-	dev->dev = get_device(&pdev->dev);
+	dev->base = pcim_iomap_table(pdev)[0];
+	dev->dev = &pdev->dev;
 	dev->functionality =
 		I2C_FUNC_I2C |
 		I2C_FUNC_SMBUS_BYTE |
@@ -284,7 +261,7 @@ static int i2c_dw_pci_probe(struct pci_dev *pdev,
 	dev->rx_fifo_depth = controller->rx_fifo_depth;
 	r = i2c_dw_init(dev);
 	if (r)
-		goto err_iounmap;
+		return r;
 
 	adap = &dev->adapter;
 	i2c_set_adapdata(adap, dev);
@@ -296,10 +273,11 @@ static int i2c_dw_pci_probe(struct pci_dev *pdev,
 	snprintf(adap->name, sizeof(adap->name), "i2c-designware-pci-%d",
 		adap->nr);
 
-	r = request_irq(pdev->irq, i2c_dw_isr, IRQF_SHARED, adap->name, dev);
+	r = devm_request_irq(&pdev->dev, pdev->irq, i2c_dw_isr, IRQF_SHARED,
+			adap->name, dev);
 	if (r) {
 		dev_err(&pdev->dev, "failure requesting irq %i\n", dev->irq);
-		goto err_iounmap;
+		return r;
 	}
 
 	i2c_dw_disable_int(dev);
@@ -307,24 +285,16 @@ static int i2c_dw_pci_probe(struct pci_dev *pdev,
 	r = i2c_add_numbered_adapter(adap);
 	if (r) {
 		dev_err(&pdev->dev, "failure adding adapter\n");
-		goto err_free_irq;
+		return r;
 	}
 
+	/* Increase reference counter */
+	get_device(&pdev->dev);
+
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_allow(&pdev->dev);
 
 	return 0;
-
-err_free_irq:
-	free_irq(pdev->irq, dev);
-err_iounmap:
-	iounmap(dev->base);
-	put_device(&pdev->dev);
-	kfree(dev);
-err_release_region:
-	pci_release_region(pdev, 0);
-exit:
-	return r;
 }
 
 static void i2c_dw_pci_remove(struct pci_dev *pdev)
@@ -337,10 +307,6 @@ static void i2c_dw_pci_remove(struct pci_dev *pdev)
 
 	i2c_del_adapter(&dev->adapter);
 	put_device(&pdev->dev);
-
-	free_irq(dev->irq, dev);
-	kfree(dev);
-	pci_release_region(pdev, 0);
 }
 
 /* work with hotplug and coldplug */
-- 
1.7.10.4

