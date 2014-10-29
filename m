Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933887AbaJ2OJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:09:28 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:43360 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933835AbaJ2OJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:09:20 -0400
From: Kever Yang <kever.yang@rock-chips.com>
To: Paul Zimmerman <paulz@synopsys.com>
Cc: Dinh Nguyen <dinguyen@opensource.altera.com>, Felipe Balbi <balbi@ti.com>,
        linux-usb@vger.kernel.org, cf@rock-chips.com, lyz@rock-chips.com,
        wulf@rock-chips.com, jwerner@chromium.org,
        Kever Yang <kever.yang@rock-chips.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 2/2] usb: dwc2: move the clock management from gadget to platform
Date: Wed, 29 Oct 2014 22:08:47 +0800
Message-Id: <1414591728-10106-3-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414591728-10106-1-git-send-email-kever.yang@rock-chips.com>
References: <1414591728-10106-1-git-send-email-kever.yang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch move clock management out of gadget into platform,
make both hcd and gadget can use the clock.

Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
---

Changes in v2:
- move all the clock operation into platform

 drivers/usb/dwc2/gadget.c   | 24 ++----------------------
 drivers/usb/dwc2/platform.c | 32 ++++++++++++++++++++------------
 2 files changed, 22 insertions(+), 34 deletions(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 6ffbfc2..0b108ee 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2852,8 +2852,6 @@ static int s3c_hsotg_udc_start(struct usb_gadget *gadget,
 	hsotg->gadget.dev.of_node = hsotg->dev->of_node;
 	hsotg->gadget.speed = USB_SPEED_UNKNOWN;
 
-	clk_enable(hsotg->clk);
-
 	ret = regulator_bulk_enable(ARRAY_SIZE(hsotg->supplies),
 				    hsotg->supplies);
 	if (ret) {
@@ -2903,8 +2901,6 @@ static int s3c_hsotg_udc_stop(struct usb_gadget *gadget,
 	regulator_bulk_disable(ARRAY_SIZE(hsotg->supplies),
 				hsotg->supplies);
 
-	clk_disable(hsotg->clk);
-
 	return 0;
 }
 
@@ -2936,10 +2932,8 @@ static int s3c_hsotg_pullup(struct usb_gadget *gadget, int is_on)
 	spin_lock_irqsave(&hsotg->lock, flags);
 	if (is_on) {
 		s3c_hsotg_phy_enable(hsotg);
-		clk_enable(hsotg->clk);
 		s3c_hsotg_core_init(hsotg);
 	} else {
-		clk_disable(hsotg->clk);
 		s3c_hsotg_phy_disable(hsotg);
 	}
 
@@ -3408,20 +3402,12 @@ int dwc2_gadget_init(struct dwc2_hsotg *hsotg, int irq)
 			hsotg->phyif = GUSBCFG_PHYIF8;
 	}
 
-	hsotg->clk = devm_clk_get(dev, "otg");
-	if (IS_ERR(hsotg->clk)) {
-		dev_err(dev, "cannot get otg clock\n");
-		return PTR_ERR(hsotg->clk);
-	}
-
 	hsotg->gadget.max_speed = USB_SPEED_HIGH;
 	hsotg->gadget.ops = &s3c_hsotg_gadget_ops;
 	hsotg->gadget.name = dev_name(dev);
 
 	/* reset the system */
 
-	clk_prepare_enable(hsotg->clk);
-
 	/* regulators */
 
 	for (i = 0; i < ARRAY_SIZE(hsotg->supplies); i++)
@@ -3431,7 +3417,7 @@ int dwc2_gadget_init(struct dwc2_hsotg *hsotg, int irq)
 				 hsotg->supplies);
 	if (ret) {
 		dev_err(dev, "failed to request supplies: %d\n", ret);
-		goto err_clk;
+		goto out;
 	}
 
 	ret = regulator_bulk_enable(ARRAY_SIZE(hsotg->supplies),
@@ -3510,9 +3496,7 @@ err_ep_mem:
 	kfree(eps);
 err_supplies:
 	s3c_hsotg_phy_disable(hsotg);
-err_clk:
-	clk_disable_unprepare(hsotg->clk);
-
+out:
 	return ret;
 }
 EXPORT_SYMBOL_GPL(dwc2_gadget_init);
@@ -3532,8 +3516,6 @@ int s3c_hsotg_remove(struct dwc2_hsotg *hsotg)
 		usb_gadget_unregister_driver(hsotg->driver);
 	}
 
-	clk_disable_unprepare(hsotg->clk);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(s3c_hsotg_remove);
@@ -3560,7 +3542,6 @@ int s3c_hsotg_suspend(struct dwc2_hsotg *hsotg)
 
 		ret = regulator_bulk_disable(ARRAY_SIZE(hsotg->supplies),
 					     hsotg->supplies);
-		clk_disable(hsotg->clk);
 	}
 
 	return ret;
@@ -3576,7 +3557,6 @@ int s3c_hsotg_resume(struct dwc2_hsotg *hsotg)
 		dev_info(hsotg->dev, "resuming usb gadget %s\n",
 			 hsotg->driver->driver.name);
 
-		clk_enable(hsotg->clk);
 		ret = regulator_bulk_enable(ARRAY_SIZE(hsotg->supplies),
 				      hsotg->supplies);
 	}
diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
index 77c8417..356e378 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -37,6 +37,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/clk.h>
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
 #include <linux/of_device.h>
@@ -122,6 +123,7 @@ static int dwc2_driver_remove(struct platform_device *dev)
 
 	dwc2_hcd_remove(hsotg);
 	s3c_hsotg_remove(hsotg);
+	clk_disable_unprepare(hsotg->clk);
 
 	return 0;
 }
@@ -216,24 +218,28 @@ static int dwc2_driver_probe(struct platform_device *dev)
 	hsotg->dr_mode = of_usb_get_dr_mode(dev->dev.of_node);
 
 	spin_lock_init(&hsotg->lock);
-	retval = dwc2_gadget_init(hsotg, irq);
-	if (retval) {
-		/*
-		 * We will not fail the driver initialization for dual-role
-		 * if no clock node is supplied. However, all gadget
-		 * functionality will be disabled if a clock node is not
-		 * provided. Host functionality will continue.
-		 * TO-DO: make clock node a requirement for the HCD.
-		 */
-		if (!IS_ERR(hsotg->clk))
-			return retval;
+	hsotg->clk = devm_clk_get(hsotg->dev, "otg");
+	if (IS_ERR(hsotg->clk)) {
+		dev_err(dev, "cannot get otg clock\n");
+		return PTR_ERR(hsotg->clk);
 	}
+
+	clk_prepare_enable(hsotg->clk);
+
+	retval = dwc2_gadget_init(hsotg, irq);
+	if (retval)
+		goto out;
+
 	retval = dwc2_hcd_init(hsotg, irq, params);
 	if (retval)
-		return retval;
+		goto out;
 
 	platform_set_drvdata(dev, hsotg);
 
+out:
+	if (IS_ERR(retval))
+		clk_disable_unprepare(hsotg->clk);
+
 	return retval;
 }
 
@@ -245,6 +251,7 @@ static int dwc2_suspend(struct device *dev)
 	if (dwc2_is_device_mode(dwc2))
 		if (!IS_ERR(dwc2->clk))
 			ret = s3c_hsotg_suspend(dwc2);
+	clk_disable(dwc2->clk);
 	return ret;
 }
 
@@ -253,6 +260,7 @@ static int dwc2_resume(struct device *dev)
 	struct dwc2_hsotg *dwc2 = dev_get_drvdata(dev);
 	int ret = 0;
 
+	clk_enable(dwc2->clk);
 	if (dwc2_is_device_mode(dwc2))
 		if (!IS_ERR(dwc2->clk))
 			ret = s3c_hsotg_resume(dwc2);
-- 
1.9.1

