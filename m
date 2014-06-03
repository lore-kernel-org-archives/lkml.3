Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934134AbaFCVUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 17:20:04 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:47284 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934038AbaFCVUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 17:20:02 -0400
Date: Wed, 4 Jun 2014 02:49:53 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] usb: phy: phy-gpio-vbus-usb: use devm_ functions
Message-ID: <20140603211953.GA17838@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The various devm_ functions allocate memory that is released when a
driver detaches.  This patch uses devm_kzalloc, devm_request_irq,
devm_gpio_request, devm_regulator_get etc. for data that is
allocated in the probe function of a platform device and is only
freed in the remove function. The corresponding free functions are
removed and the labels are done away with.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/usb/phy/phy-gpio-vbus-usb.c | 45 +++++++++++--------------------------
 1 file changed, 13 insertions(+), 32 deletions(-)

diff --git a/drivers/usb/phy/phy-gpio-vbus-usb.c b/drivers/usb/phy/phy-gpio-vbus-usb.c
index 69462e0..ea9e705 100644
--- a/drivers/usb/phy/phy-gpio-vbus-usb.c
+++ b/drivers/usb/phy/phy-gpio-vbus-usb.c
@@ -253,11 +253,13 @@ static int gpio_vbus_probe(struct platform_device *pdev)
 		return -EINVAL;
 	gpio = pdata->gpio_vbus;
 
-	gpio_vbus = kzalloc(sizeof(struct gpio_vbus_data), GFP_KERNEL);
+	gpio_vbus = devm_kzalloc(&pdev->dev, sizeof(struct gpio_vbus_data),
+				 GFP_KERNEL);
 	if (!gpio_vbus)
 		return -ENOMEM;
 
-	gpio_vbus->phy.otg = kzalloc(sizeof(struct usb_otg), GFP_KERNEL);
+	gpio_vbus->phy.otg = devm_kzalloc(&pdev->dev, sizeof(struct usb_otg),
+					  GFP_KERNEL);
 	if (!gpio_vbus->phy.otg) {
 		kfree(gpio_vbus);
 		return -ENOMEM;
@@ -274,11 +276,11 @@ static int gpio_vbus_probe(struct platform_device *pdev)
 	gpio_vbus->phy.otg->phy = &gpio_vbus->phy;
 	gpio_vbus->phy.otg->set_peripheral = gpio_vbus_set_peripheral;
 
-	err = gpio_request(gpio, "vbus_detect");
+	err = devm_gpio_request(&pdev->dev, gpio, "vbus_detect");
 	if (err) {
 		dev_err(&pdev->dev, "can't request vbus gpio %d, err: %d\n",
 			gpio, err);
-		goto err_gpio;
+		return err;
 	}
 	gpio_direction_input(gpio);
 
@@ -296,27 +298,27 @@ static int gpio_vbus_probe(struct platform_device *pdev)
 	/* if data line pullup is in use, initialize it to "not pulling up" */
 	gpio = pdata->gpio_pullup;
 	if (gpio_is_valid(gpio)) {
-		err = gpio_request(gpio, "udc_pullup");
+		err = devm_gpio_request(&pdev->dev, gpio, "udc_pullup");
 		if (err) {
 			dev_err(&pdev->dev,
 				"can't request pullup gpio %d, err: %d\n",
 				gpio, err);
-			gpio_free(pdata->gpio_vbus);
-			goto err_gpio;
+			return err;
 		}
 		gpio_direction_output(gpio, pdata->gpio_pullup_inverted);
 	}
 
-	err = request_irq(irq, gpio_vbus_irq, irqflags, "vbus_detect", pdev);
+	err = devm_request_irq(&pdev->dev, irq, gpio_vbus_irq, irqflags,
+			       "vbus_detect", pdev);
 	if (err) {
 		dev_err(&pdev->dev, "can't request irq %i, err: %d\n",
 			irq, err);
-		goto err_irq;
+		return err;
 	}
 
 	INIT_DELAYED_WORK(&gpio_vbus->work, gpio_vbus_work);
 
-	gpio_vbus->vbus_draw = regulator_get(&pdev->dev, "vbus_draw");
+	gpio_vbus->vbus_draw = devm_regulator_get(&pdev->dev, "vbus_draw");
 	if (IS_ERR(gpio_vbus->vbus_draw)) {
 		dev_dbg(&pdev->dev, "can't get vbus_draw regulator, err: %ld\n",
 			PTR_ERR(gpio_vbus->vbus_draw));
@@ -328,44 +330,23 @@ static int gpio_vbus_probe(struct platform_device *pdev)
 	if (err) {
 		dev_err(&pdev->dev, "can't register transceiver, err: %d\n",
 			err);
-		goto err_otg;
+		return err;
 	}
 
 	device_init_wakeup(&pdev->dev, pdata->wakeup);
 
 	return 0;
-err_otg:
-	regulator_put(gpio_vbus->vbus_draw);
-	free_irq(irq, pdev);
-err_irq:
-	if (gpio_is_valid(pdata->gpio_pullup))
-		gpio_free(pdata->gpio_pullup);
-	gpio_free(pdata->gpio_vbus);
-err_gpio:
-	kfree(gpio_vbus->phy.otg);
-	kfree(gpio_vbus);
-	return err;
 }
 
 static int gpio_vbus_remove(struct platform_device *pdev)
 {
 	struct gpio_vbus_data *gpio_vbus = platform_get_drvdata(pdev);
-	struct gpio_vbus_mach_info *pdata = dev_get_platdata(&pdev->dev);
-	int gpio = pdata->gpio_vbus;
 
 	device_init_wakeup(&pdev->dev, 0);
 	cancel_delayed_work_sync(&gpio_vbus->work);
-	regulator_put(gpio_vbus->vbus_draw);
 
 	usb_remove_phy(&gpio_vbus->phy);
 
-	free_irq(gpio_vbus->irq, pdev);
-	if (gpio_is_valid(pdata->gpio_pullup))
-		gpio_free(pdata->gpio_pullup);
-	gpio_free(gpio);
-	kfree(gpio_vbus->phy.otg);
-	kfree(gpio_vbus);
-
 	return 0;
 }
 
-- 
1.9.1

