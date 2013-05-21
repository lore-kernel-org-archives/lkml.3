Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab3EUKdQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 06:33:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:36419 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753886Ab3EUKdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 06:33:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,713,1363158000"; 
   d="scan'208";a="317074467"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        David Cohen <david.a.cohen@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 4/4] gpio-langwell: use managed functions pcim_* and devm_*
Date: Tue, 21 May 2013 13:33:06 +0300
Message-Id: <1369132386-11725-5-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1369132386-11725-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1369132386-11725-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the error handling much more simpler than open-coding everything and
in addition makes the probe function smaller an tidier.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/gpio/gpio-langwell.c | 78 ++++++++++++--------------------------------
 1 file changed, 20 insertions(+), 58 deletions(-)

diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
index 652c1c7..bdb24ef 100644
--- a/drivers/gpio/gpio-langwell.c
+++ b/drivers/gpio/gpio-langwell.c
@@ -320,56 +320,35 @@ static const struct dev_pm_ops lnw_gpio_pm_ops = {
 static int lnw_gpio_probe(struct pci_dev *pdev,
 			  const struct pci_device_id *id)
 {
-	void __iomem *base;
-	resource_size_t start, len;
 	struct lnw_gpio *lnw;
 	u32 gpio_base;
 	u32 irq_base;
 	int retval;
 	int ngpio = id->driver_data;
 
-	retval = pci_enable_device(pdev);
+	retval = pcim_enable_device(pdev);
 	if (retval)
 		return retval;
 
-	retval = pci_request_regions(pdev, "langwell_gpio");
+	retval = pcim_iomap_regions(pdev, 1 << 0 | 1 << 1, pci_name(pdev));
 	if (retval) {
-		dev_err(&pdev->dev, "error requesting resources\n");
-		goto err_pci_req_region;
-	}
-	/* get the gpio_base from bar1 */
-	start = pci_resource_start(pdev, 1);
-	len = pci_resource_len(pdev, 1);
-	base = ioremap_nocache(start, len);
-	if (!base) {
-		dev_err(&pdev->dev, "error mapping bar1\n");
-		retval = -EFAULT;
-		goto err_ioremap;
+		dev_err(&pdev->dev, "I/O memory mapping error\n");
+		return retval;
 	}
 
-	irq_base = readl(base);
-	gpio_base = readl(sizeof(u32) + base);
+	irq_base = readl(pcim_iomap_table(pdev)[1]);
+	gpio_base = readl(sizeof(u32) + pcim_iomap_table(pdev)[1]);
 
 	/* release the IO mapping, since we already get the info from bar1 */
-	iounmap(base);
-	/* get the register base from bar0 */
-	start = pci_resource_start(pdev, 0);
-	len = pci_resource_len(pdev, 0);
-	base = devm_ioremap_nocache(&pdev->dev, start, len);
-	if (!base) {
-		dev_err(&pdev->dev, "error mapping bar0\n");
-		retval = -EFAULT;
-		goto err_ioremap;
-	}
+	pcim_iounmap_regions(pdev, 1 << 1);
 
 	lnw = devm_kzalloc(&pdev->dev, sizeof(*lnw), GFP_KERNEL);
 	if (!lnw) {
 		dev_err(&pdev->dev, "can't allocate langwell_gpio chip data\n");
-		retval = -ENOMEM;
-		goto err_ioremap;
+		return -ENOMEM;
 	}
 
-	lnw->reg_base = base;
+	lnw->reg_base = pcim_iomap_table(pdev)[0];
 	lnw->chip.label = dev_name(&pdev->dev);
 	lnw->chip.request = lnw_gpio_request;
 	lnw->chip.direction_input = lnw_gpio_direction_input;
@@ -388,14 +367,14 @@ static int lnw_gpio_probe(struct pci_dev *pdev,
 					    &lnw_gpio_irq_ops, lnw);
 	if (!lnw->domain) {
 		retval = -ENOMEM;
-		goto err_ioremap;
+		return retval;
 	}
 
 	pci_set_drvdata(pdev, lnw);
 	retval = gpiochip_add(&lnw->chip);
 	if (retval) {
 		dev_err(&pdev->dev, "%s error %d\n", __func__, retval);
-		goto err_ioremap;
+		return retval;
 	}
 
 	lnw_irq_init_hw(lnw);
@@ -407,12 +386,6 @@ static int lnw_gpio_probe(struct pci_dev *pdev,
 	pm_runtime_allow(&pdev->dev);
 
 	return 0;
-
-err_ioremap:
-	pci_release_regions(pdev);
-err_pci_req_region:
-	pci_disable_device(pdev);
-	return retval;
 }
 
 static struct pci_driver lnw_gpio_driver = {
@@ -430,23 +403,20 @@ static int wp_gpio_probe(struct platform_device *pdev)
 	struct lnw_gpio *lnw;
 	struct gpio_chip *gc;
 	struct resource *rc;
-	int retval = 0;
-
-	rc = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!rc)
-		return -EINVAL;
+	int retval;
 
-	lnw = kzalloc(sizeof(struct lnw_gpio), GFP_KERNEL);
+	lnw = devm_kzalloc(&pdev->dev, sizeof(struct lnw_gpio), GFP_KERNEL);
 	if (!lnw) {
 		dev_err(&pdev->dev,
 			"can't allocate whitneypoint_gpio chip data\n");
 		return -ENOMEM;
 	}
-	lnw->reg_base = ioremap_nocache(rc->start, resource_size(rc));
-	if (lnw->reg_base == NULL) {
-		retval = -EINVAL;
-		goto err_kmalloc;
-	}
+
+	rc = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	lnw->reg_base = devm_ioremap_resource(&pdev->dev, rc);
+	if (IS_ERR(lnw->reg_base))
+		return PTR_ERR(lnw->reg_base);
+
 	spin_lock_init(&lnw->lock);
 	gc = &lnw->chip;
 	gc->label = dev_name(&pdev->dev);
@@ -462,15 +432,10 @@ static int wp_gpio_probe(struct platform_device *pdev)
 	retval = gpiochip_add(gc);
 	if (retval) {
 		dev_err(&pdev->dev, "%s error %d\n", __func__, retval);
-		goto err_ioremap;
+		return retval;
 	}
 	platform_set_drvdata(pdev, lnw);
 	return 0;
-err_ioremap:
-	iounmap(lnw->reg_base);
-err_kmalloc:
-	kfree(lnw);
-	return retval;
 }
 
 static int wp_gpio_remove(struct platform_device *pdev)
@@ -480,9 +445,6 @@ static int wp_gpio_remove(struct platform_device *pdev)
 	err = gpiochip_remove(&lnw->chip);
 	if (err)
 		dev_err(&pdev->dev, "failed to remove gpio_chip.\n");
-	iounmap(lnw->reg_base);
-	kfree(lnw);
-	platform_set_drvdata(pdev, NULL);
 	return 0;
 }
 
-- 
1.8.2.rc0.22.gb3600c3

