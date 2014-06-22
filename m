Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240AbaFVHS0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 03:18:26 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:65340 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaFVHSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 03:18:24 -0400
Date: Sun, 22 Jun 2014 12:47:51 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] usb: gadget: pxa25x_udc: use devm_ functions
Message-ID: <20140622071751.GA5904@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the use of devm_request_irq, devm_gpio_request,
devm_clk_get etc. instead of the corresponding unmanaged interfaces. The
calls to the functions like free_irq to free the allocated resources are
removed as they are no longer required. Some labels in the probe function
are also done away with and the name of the label err_gpio_pullup is
changed to make it less specific to the context.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/usb/gadget/pxa25x_udc.c | 73 +++++++++++++----------------------------
 1 file changed, 22 insertions(+), 51 deletions(-)

diff --git a/drivers/usb/gadget/pxa25x_udc.c b/drivers/usb/gadget/pxa25x_udc.c
index 9984437..f1a5cdc 100644
--- a/drivers/usb/gadget/pxa25x_udc.c
+++ b/drivers/usb/gadget/pxa25x_udc.c
@@ -2105,11 +2105,9 @@ static int pxa25x_udc_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return -ENODEV;
 
-	dev->clk = clk_get(&pdev->dev, NULL);
-	if (IS_ERR(dev->clk)) {
-		retval = PTR_ERR(dev->clk);
-		goto err_clk;
-	}
+	dev->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(dev->clk))
+		return PTR_ERR(dev->clk);
 
 	pr_debug("%s: IRQ %d%s%s\n", driver_name, irq,
 		dev->has_cfr ? "" : " (!cfr)",
@@ -2120,15 +2118,16 @@ static int pxa25x_udc_probe(struct platform_device *pdev)
 	dev->dev = &pdev->dev;
 	dev->mach = dev_get_platdata(&pdev->dev);
 
-	dev->transceiver = usb_get_phy(USB_PHY_TYPE_USB2);
+	dev->transceiver = devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
 
 	if (gpio_is_valid(dev->mach->gpio_pullup)) {
-		if ((retval = gpio_request(dev->mach->gpio_pullup,
-				"pca25x_udc GPIO PULLUP"))) {
+		retval = devm_gpio_request(&pdev->dev, dev->mach->gpio_pullup,
+					   "pca25x_udc GPIO PULLUP");
+		if (retval) {
 			dev_dbg(&pdev->dev,
 				"can't get pullup gpio %d, err: %d\n",
 				dev->mach->gpio_pullup, retval);
-			goto err_gpio_pullup;
+			goto err;
 		}
 		gpio_direction_output(dev->mach->gpio_pullup, 0);
 	}
@@ -2146,30 +2145,32 @@ static int pxa25x_udc_probe(struct platform_device *pdev)
 	dev->vbus = 0;
 
 	/* irq setup after old hardware state is cleaned up */
-	retval = request_irq(irq, pxa25x_udc_irq,
-			0, driver_name, dev);
+	retval = devm_request_irq(&pdev->dev, irq, pxa25x_udc_irq, 0,
+				  driver_name, dev);
 	if (retval != 0) {
 		pr_err("%s: can't get irq %d, err %d\n",
 			driver_name, irq, retval);
-		goto err_irq1;
+		goto err;
 	}
 	dev->got_irq = 1;
 
 #ifdef CONFIG_ARCH_LUBBOCK
 	if (machine_is_lubbock()) {
-		retval = request_irq(LUBBOCK_USB_DISC_IRQ, lubbock_vbus_irq,
-				     0, driver_name, dev);
+		retval = devm_request_irq(&pdev->dev, LUBBOCK_USB_DISC_IRQ,
+					  lubbock_vbus_irq, 0, driver_name,
+					  dev);
 		if (retval != 0) {
 			pr_err("%s: can't get irq %i, err %d\n",
 				driver_name, LUBBOCK_USB_DISC_IRQ, retval);
-			goto err_irq_lub;
+			goto err;
 		}
-		retval = request_irq(LUBBOCK_USB_IRQ, lubbock_vbus_irq,
-				     0, driver_name, dev);
+		retval = devm_request_irq(&pdev->dev, LUBBOCK_USB_IRQ,
+					  lubbock_vbus_irq, 0, driver_name,
+					  dev);
 		if (retval != 0) {
 			pr_err("%s: can't get irq %i, err %d\n",
 				driver_name, LUBBOCK_USB_IRQ, retval);
-			goto lubbock_fail0;
+			goto err;
 		}
 	} else
 #endif
@@ -2180,22 +2181,9 @@ static int pxa25x_udc_probe(struct platform_device *pdev)
 		return retval;
 
 	remove_debug_files(dev);
-#ifdef	CONFIG_ARCH_LUBBOCK
-lubbock_fail0:
-	free_irq(LUBBOCK_USB_DISC_IRQ, dev);
- err_irq_lub:
-	free_irq(irq, dev);
-#endif
- err_irq1:
-	if (gpio_is_valid(dev->mach->gpio_pullup))
-		gpio_free(dev->mach->gpio_pullup);
- err_gpio_pullup:
-	if (!IS_ERR_OR_NULL(dev->transceiver)) {
-		usb_put_phy(dev->transceiver);
+ err:
+	if (!IS_ERR_OR_NULL(dev->transceiver))
 		dev->transceiver = NULL;
-	}
-	clk_put(dev->clk);
- err_clk:
 	return retval;
 }
 
@@ -2217,25 +2205,8 @@ static int pxa25x_udc_remove(struct platform_device *pdev)
 
 	remove_debug_files(dev);
 
-	if (dev->got_irq) {
-		free_irq(platform_get_irq(pdev, 0), dev);
-		dev->got_irq = 0;
-	}
-#ifdef CONFIG_ARCH_LUBBOCK
-	if (machine_is_lubbock()) {
-		free_irq(LUBBOCK_USB_DISC_IRQ, dev);
-		free_irq(LUBBOCK_USB_IRQ, dev);
-	}
-#endif
-	if (gpio_is_valid(dev->mach->gpio_pullup))
-		gpio_free(dev->mach->gpio_pullup);
-
-	clk_put(dev->clk);
-
-	if (!IS_ERR_OR_NULL(dev->transceiver)) {
-		usb_put_phy(dev->transceiver);
+	if (!IS_ERR_OR_NULL(dev->transceiver))
 		dev->transceiver = NULL;
-	}
 
 	the_controller = NULL;
 	return 0;
-- 
1.9.1

