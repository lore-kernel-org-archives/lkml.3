Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab3F2A3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 20:29:13 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.107]:12462 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752779Ab3F2A3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 20:29:12 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-160.messagelabs.com!1372465749!6883358!4
X-Originating-IP: [216.166.12.98]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] usb: ohci-ep93xx: use devm_ioremap_resource()
Date: Fri, 28 Jun 2013 17:27:59 -0700
User-Agent: KMail/1.9.9
CC: <stern@rowland.harvard.edu>, <kernel@wantstofly.org>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201306281727.59280.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_ioremap_resource() to make the code a bit cleaner and
simpler.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Lennert Buytenhek <kernel@wantstofly.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ohci-ep93xx.c | 35 ++++++++++++++---------------------
 1 file changed, 14 insertions(+), 21 deletions(-)

diff --git a/drivers/usb/host/ohci-ep93xx.c b/drivers/usb/host/ohci-ep93xx.c
index 8704e9f..4e12f67 100644
--- a/drivers/usb/host/ohci-ep93xx.c
+++ b/drivers/usb/host/ohci-ep93xx.c
@@ -43,38 +43,37 @@ static void ep93xx_stop_hc(struct device *dev)
 static int usb_hcd_ep93xx_probe(const struct hc_driver *driver,
 			 struct platform_device *pdev)
 {
-	int retval;
 	struct usb_hcd *hcd;
+	struct resource *res;
+	int retval;
 
 	if (pdev->resource[1].flags != IORESOURCE_IRQ) {
 		dev_dbg(&pdev->dev, "resource[1] is not IORESOURCE_IRQ\n");
 		return -ENOMEM;
 	}
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENXIO;
+
 	hcd = usb_create_hcd(driver, &pdev->dev, "ep93xx");
 	if (hcd == NULL)
 		return -ENOMEM;
 
-	hcd->rsrc_start = pdev->resource[0].start;
-	hcd->rsrc_len = pdev->resource[0].end - pdev->resource[0].start + 1;
-	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
-		usb_put_hcd(hcd);
-		retval = -EBUSY;
-		goto err1;
-	}
+	hcd->rsrc_start = res->start;
+	hcd->rsrc_len = resource_size(res);
 
-	hcd->regs = ioremap(hcd->rsrc_start, hcd->rsrc_len);
-	if (hcd->regs == NULL) {
-		dev_dbg(&pdev->dev, "ioremap failed\n");
-		retval = -ENOMEM;
-		goto err2;
+	hcd->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(hcd->regs)) {
+		retval = PTR_ERR(hcd->regs);
+		goto err_put_hcd;
 	}
 
 	usb_host_clock = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(usb_host_clock)) {
 		dev_dbg(&pdev->dev, "clk_get failed\n");
 		retval = PTR_ERR(usb_host_clock);
-		goto err3;
+		goto err_put_hcd;
 	}
 
 	ep93xx_start_hc(&pdev->dev);
@@ -86,11 +85,7 @@ static int usb_hcd_ep93xx_probe(const struct hc_driver *driver,
 		return retval;
 
 	ep93xx_stop_hc(&pdev->dev);
-err3:
-	iounmap(hcd->regs);
-err2:
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
-err1:
+err_put_hcd:
 	usb_put_hcd(hcd);
 
 	return retval;
@@ -102,8 +97,6 @@ static void usb_hcd_ep93xx_remove(struct usb_hcd *hcd,
 	usb_remove_hcd(hcd);
 	ep93xx_stop_hc(&pdev->dev);
 	clk_put(usb_host_clock);
-	iounmap(hcd->regs);
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 	usb_put_hcd(hcd);
 }
 
-- 
1.8.1.4

