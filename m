Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbaAaMZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 07:25:19 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:47915 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108AbaAaMZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 07:25:17 -0500
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: <santosh.shilimkar@ti.com>, Felipe Balbi <balbi@ti.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <ivan.khoronzhuk@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH] usb: dwc3: keystone: switch to use runtime pm
Date: Fri, 31 Jan 2014 15:20:26 +0200
Message-ID: <1391174426-13773-1-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Keystone PM management layer has been implemented using PM bus for
power management clocks. As result, most of Keystone drivers don't need
to manage clocks directly. They just need to enable runtime PM and use it
to handle their PM state and clocks.

Hence, remove clock management code and switch to use runtime PM.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/usb/dwc3/dwc3-keystone.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-keystone.c b/drivers/usb/dwc3/dwc3-keystone.c
index 1fad161..a810b41 100644
--- a/drivers/usb/dwc3/dwc3-keystone.c
+++ b/drivers/usb/dwc3/dwc3-keystone.c
@@ -23,6 +23,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/io.h>
 #include <linux/of_platform.h>
+#include <linux/pm_runtime.h>
 
 /* USBSS register offsets */
 #define USBSS_REVISION		0x0000
@@ -116,12 +117,10 @@ static int kdwc3_probe(struct platform_device *pdev)
 	kdwc3_dma_mask = dma_get_mask(dev);
 	dev->dma_mask = &kdwc3_dma_mask;
 
-	kdwc->clk = devm_clk_get(kdwc->dev, "usb");
-
-	error = clk_prepare_enable(kdwc->clk);
+	pm_runtime_enable(dev);
+	error = pm_runtime_get_sync(dev);
 	if (error < 0) {
-		dev_dbg(kdwc->dev, "unable to enable usb clock, err %d\n",
-			error);
+		dev_dbg(dev, "unable to enable usb dev, err %d\n", error);
 		return error;
 	}
 
@@ -152,7 +151,8 @@ static int kdwc3_probe(struct platform_device *pdev)
 err_core:
 	kdwc3_disable_irqs(kdwc);
 err_irq:
-	clk_disable_unprepare(kdwc->clk);
+	pm_runtime_put_sync(dev);
+	pm_runtime_disable(dev);
 
 	return error;
 }
@@ -172,7 +172,8 @@ static int kdwc3_remove(struct platform_device *pdev)
 
 	kdwc3_disable_irqs(kdwc);
 	device_for_each_child(&pdev->dev, NULL, kdwc3_remove_core);
-	clk_disable_unprepare(kdwc->clk);
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
-- 
1.7.9.5

