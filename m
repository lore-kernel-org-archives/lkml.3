Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab3GAWyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 18:54:08 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.204]:27942 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755100Ab3GAWyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 18:54:05 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-131.messagelabs.com!1372719243!22535440!3
X-Originating-IP: [216.166.12.72]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 4/4] usb: ohci-ep93xx: tidy up driver (*probe) and (*remove)
Date: Mon, 1 Jul 2013 15:53:02 -0700
User-Agent: KMail/1.9.9
CC: <stern@rowland.harvard.edu>, <kernel@wantstofly.org>,
        <gregkh@linuxfoundation.org>, <hsweeten@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201307011553.02910.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merge the usb_hcd_ep93xx_probe() into ohci_hcd_ep93xx_drv_probe() and
the usb_hcd_ep93xx_remove() into ohci_hcd_ep93xx_drv_remove(). As Alan
Stern pointed out, there is no reason for them to be separate.

Also, as Alan Stern suggested, eliminate the ep93xx_start_hc() and
ep93xx_stop_hc() routines and simply call clk_enable() and clk_disable()
directly. The extra level of redirection does not add any clarity.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Lennert Buytenhek <kernel@wantstofly.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ohci-ep93xx.c | 128 +++++++++++++++++------------------------
 1 file changed, 52 insertions(+), 76 deletions(-)

diff --git a/drivers/usb/host/ohci-ep93xx.c b/drivers/usb/host/ohci-ep93xx.c
index 28fa6b8..84a20d5 100644
--- a/drivers/usb/host/ohci-ep93xx.c
+++ b/drivers/usb/host/ohci-ep93xx.c
@@ -30,74 +30,6 @@
 
 static struct clk *usb_host_clock;
 
-static void ep93xx_start_hc(struct device *dev)
-{
-	clk_enable(usb_host_clock);
-}
-
-static void ep93xx_stop_hc(struct device *dev)
-{
-	clk_disable(usb_host_clock);
-}
-
-static int usb_hcd_ep93xx_probe(const struct hc_driver *driver,
-			 struct platform_device *pdev)
-{
-	struct usb_hcd *hcd;
-	struct resource *res;
-	int irq;
-	int retval;
-
-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0)
-		return irq;
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENXIO;
-
-	hcd = usb_create_hcd(driver, &pdev->dev, "ep93xx");
-	if (hcd == NULL)
-		return -ENOMEM;
-
-	hcd->rsrc_start = res->start;
-	hcd->rsrc_len = resource_size(res);
-
-	hcd->regs = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(hcd->regs)) {
-		retval = PTR_ERR(hcd->regs);
-		goto err_put_hcd;
-	}
-
-	usb_host_clock = devm_clk_get(&pdev->dev, NULL);
-	if (IS_ERR(usb_host_clock)) {
-		retval = PTR_ERR(usb_host_clock);
-		goto err_put_hcd;
-	}
-
-	ep93xx_start_hc(&pdev->dev);
-
-	ohci_hcd_init(hcd_to_ohci(hcd));
-
-	retval = usb_add_hcd(hcd, irq, 0);
-	if (retval == 0)
-		return retval;
-
-	ep93xx_stop_hc(&pdev->dev);
-err_put_hcd:
-	usb_put_hcd(hcd);
-
-	return retval;
-}
-
-static void usb_hcd_ep93xx_remove(struct usb_hcd *hcd,
-			struct platform_device *pdev)
-{
-	usb_remove_hcd(hcd);
-	ep93xx_stop_hc(&pdev->dev);
-	usb_put_hcd(hcd);
-}
-
 static int ohci_ep93xx_start(struct usb_hcd *hcd)
 {
 	struct ohci_hcd *ohci = hcd_to_ohci(hcd);
@@ -138,15 +70,57 @@ static struct hc_driver ohci_ep93xx_hc_driver = {
 	.start_port_reset	= ohci_start_port_reset,
 };
 
-extern int usb_disabled(void);
-
 static int ohci_hcd_ep93xx_drv_probe(struct platform_device *pdev)
 {
+	struct usb_hcd *hcd;
+	struct resource *res;
+	int irq;
 	int ret;
 
-	ret = -ENODEV;
-	if (!usb_disabled())
-		ret = usb_hcd_ep93xx_probe(&ohci_ep93xx_hc_driver, pdev);
+	if (usb_disabled())
+		return -ENODEV;
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENXIO;
+
+	hcd = usb_create_hcd(&ohci_ep93xx_hc_driver, &pdev->dev, "ep93xx");
+	if (!hcd)
+		return -ENOMEM;
+
+	hcd->rsrc_start = res->start;
+	hcd->rsrc_len = resource_size(res);
+
+	hcd->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(hcd->regs)) {
+		ret = PTR_ERR(hcd->regs);
+		goto err_put_hcd;
+	}
+
+	usb_host_clock = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(usb_host_clock)) {
+		ret = PTR_ERR(usb_host_clock);
+		goto err_put_hcd;
+	}
+
+	clk_enable(usb_host_clock);
+
+	ohci_hcd_init(hcd_to_ohci(hcd));
+
+	ret = usb_add_hcd(hcd, irq, 0);
+	if (ret)
+		goto err_clk_disable;
+
+	return 0;
+
+err_clk_disable:
+	clk_disable(usb_host_clock);
+err_put_hcd:
+	usb_put_hcd(hcd);
 
 	return ret;
 }
@@ -155,7 +129,9 @@ static int ohci_hcd_ep93xx_drv_remove(struct platform_device *pdev)
 {
 	struct usb_hcd *hcd = platform_get_drvdata(pdev);
 
-	usb_hcd_ep93xx_remove(hcd, pdev);
+	usb_remove_hcd(hcd);
+	clk_disable(usb_host_clock);
+	usb_put_hcd(hcd);
 
 	return 0;
 }
@@ -170,7 +146,7 @@ static int ohci_hcd_ep93xx_drv_suspend(struct platform_device *pdev, pm_message_
 		msleep(5);
 	ohci->next_statechange = jiffies;
 
-	ep93xx_stop_hc(&pdev->dev);
+	clk_disable(usb_host_clock);
 	return 0;
 }
 
@@ -183,7 +159,7 @@ static int ohci_hcd_ep93xx_drv_resume(struct platform_device *pdev)
 		msleep(5);
 	ohci->next_statechange = jiffies;
 
-	ep93xx_start_hc(&pdev->dev);
+	clk_enable(usb_host_clock);
 
 	ohci_resume(hcd, false);
 	return 0;
-- 
1.8.1.4

