Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab3FRGns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 02:43:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:21093 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020Ab3FRGnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 02:43:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,887,1363158000"; 
   d="scan'208";a="355188312"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        David Cohen <david.a.cohen@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] gpio-langwell: remove Withney point support
Date: Tue, 18 Jun 2013 09:43:38 +0300
Message-Id: <1371537818-19579-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems there is no user of the wp_gpio driver in the kernel. Let's remove it.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/gpio/gpio-langwell.c | 69 +-------------------------------------------
 1 file changed, 1 insertion(+), 68 deletions(-)

diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
index 2db6ef7..bfa1af1 100644
--- a/drivers/gpio/gpio-langwell.c
+++ b/drivers/gpio/gpio-langwell.c
@@ -20,7 +20,6 @@
 /* Supports:
  * Moorestown platform Langwell chip.
  * Medfield platform Penwell chip.
- * Whitney point.
  */
 
 #include <linux/module.h>
@@ -390,75 +389,9 @@ static struct pci_driver lnw_gpio_driver = {
 	},
 };
 
-
-static int wp_gpio_probe(struct platform_device *pdev)
-{
-	struct lnw_gpio *lnw;
-	struct gpio_chip *gc;
-	struct resource *rc;
-	int retval;
-
-	lnw = devm_kzalloc(&pdev->dev, sizeof(struct lnw_gpio), GFP_KERNEL);
-	if (!lnw) {
-		dev_err(&pdev->dev, "can't allocate chip data\n");
-		return -ENOMEM;
-	}
-
-	rc = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	lnw->reg_base = devm_ioremap_resource(&pdev->dev, rc);
-	if (IS_ERR(lnw->reg_base))
-		return PTR_ERR(lnw->reg_base);
-
-	spin_lock_init(&lnw->lock);
-	gc = &lnw->chip;
-	gc->label = dev_name(&pdev->dev);
-	gc->owner = THIS_MODULE;
-	gc->direction_input = lnw_gpio_direction_input;
-	gc->direction_output = lnw_gpio_direction_output;
-	gc->get = lnw_gpio_get;
-	gc->set = lnw_gpio_set;
-	gc->to_irq = NULL;
-	gc->base = 0;
-	gc->ngpio = 64;
-	gc->can_sleep = 0;
-	retval = gpiochip_add(gc);
-	if (retval) {
-		dev_err(&pdev->dev, "gpiochip_add error %d\n", retval);
-		return retval;
-	}
-	platform_set_drvdata(pdev, lnw);
-	return 0;
-}
-
-static int wp_gpio_remove(struct platform_device *pdev)
-{
-	struct lnw_gpio *lnw = platform_get_drvdata(pdev);
-	int err;
-	err = gpiochip_remove(&lnw->chip);
-	if (err)
-		dev_err(&pdev->dev, "failed to remove gpio_chip.\n");
-	return 0;
-}
-
-static struct platform_driver wp_gpio_driver = {
-	.probe		= wp_gpio_probe,
-	.remove		= wp_gpio_remove,
-	.driver		= {
-		.name	= "wp_gpio",
-		.owner	= THIS_MODULE,
-	},
-};
-
 static int __init lnw_gpio_init(void)
 {
-	int ret;
-	ret =  pci_register_driver(&lnw_gpio_driver);
-	if (ret < 0)
-		return ret;
-	ret = platform_driver_register(&wp_gpio_driver);
-	if (ret < 0)
-		pci_unregister_driver(&lnw_gpio_driver);
-	return ret;
+	return pci_register_driver(&lnw_gpio_driver);
 }
 
 device_initcall(lnw_gpio_init);
-- 
1.8.3.1

