Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbaFHIFX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 04:05:23 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:44343 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbaFHIFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 04:05:18 -0400
Date: Sun, 8 Jun 2014 13:35:09 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Tony Prisk <linux@prisktech.co.nz>, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] uhci-platform: use devm_ioremap resource
Message-ID: <20140608080509.GA3748@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the memory allocation using request_mem_region and
the ioremap by a single call to managed interface devm_ioremap_reource.
The corresponding calls to release_mem_region and iounmap in the probe
and release functions are now unnecessary and are removed. Also a label
is done away with and linux/device.h is added to make sure the devm_*()
outine declarations are unambiguously available.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
Not compile tested due to incompatible architecture.

 drivers/usb/host/uhci-platform.c | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/host/uhci-platform.c b/drivers/usb/host/uhci-platform.c
index 01833ab..34248a6 100644
--- a/drivers/usb/host/uhci-platform.c
+++ b/drivers/usb/host/uhci-platform.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/of.h>
+#include <linux/device.h>
 #include <linux/platform_device.h>
 
 static int uhci_platform_init(struct usb_hcd *hcd)
@@ -88,33 +89,23 @@ static int uhci_hcd_platform_probe(struct platform_device *pdev)
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
 
-	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
-		pr_err("%s: request_mem_region failed\n", __func__);
-		ret = -EBUSY;
+	hcd->regs = devm_ioremap_resource(&pdev->dev, hcd->rsrc_start,
+					  hcd->rsrc_len);
+	if (IS_ERR(hcd->regs)) {
+		ret = PTR_ERR(hcd->regs);
 		goto err_rmr;
 	}
-
-	hcd->regs = ioremap(hcd->rsrc_start, hcd->rsrc_len);
-	if (!hcd->regs) {
-		pr_err("%s: ioremap failed\n", __func__);
-		ret = -ENOMEM;
-		goto err_irq;
-	}
 	uhci = hcd_to_uhci(hcd);
 
 	uhci->regs = hcd->regs;
 
 	ret = usb_add_hcd(hcd, pdev->resource[1].start, IRQF_SHARED);
 	if (ret)
-		goto err_uhci;
+		goto err_rmr;
 
 	device_wakeup_enable(hcd->self.controller);
 	return 0;
 
-err_uhci:
-	iounmap(hcd->regs);
-err_irq:
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 err_rmr:
 	usb_put_hcd(hcd);
 
@@ -126,8 +117,6 @@ static int uhci_hcd_platform_remove(struct platform_device *pdev)
 	struct usb_hcd *hcd = platform_get_drvdata(pdev);
 
 	usb_remove_hcd(hcd);
-	iounmap(hcd->regs);
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 	usb_put_hcd(hcd);
 
 	return 0;
-- 
1.9.1

