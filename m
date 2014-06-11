Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbaFKTSx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 15:18:53 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60953 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaFKTSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 15:18:52 -0400
Date: Thu, 12 Jun 2014 00:48:44 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Tony Prisk <linux@prisktech.co.nz>, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH v2] uhci-platform: use devm_ioremap resource
Message-ID: <20140611191844.GA13009@himangi-Dell>
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
v2: pass correct arguments to devm_ioremap_resource
Not compile tested due to incompatible architecture.

 drivers/usb/host/uhci-platform.c | 22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/host/uhci-platform.c b/drivers/usb/host/uhci-platform.c
index 01833ab..b987f1d 100644
--- a/drivers/usb/host/uhci-platform.c
+++ b/drivers/usb/host/uhci-platform.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/of.h>
+#include <linux/device.h>
 #include <linux/platform_device.h>
 
 static int uhci_platform_init(struct usb_hcd *hcd)
@@ -88,33 +89,22 @@ static int uhci_hcd_platform_probe(struct platform_device *pdev)
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
 
-	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
-		pr_err("%s: request_mem_region failed\n", __func__);
-		ret = -EBUSY;
+	hcd->regs = devm_ioremap_resource(&pdev->dev, res);
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
 
@@ -126,8 +116,6 @@ static int uhci_hcd_platform_remove(struct platform_device *pdev)
 	struct usb_hcd *hcd = platform_get_drvdata(pdev);
 
 	usb_remove_hcd(hcd);
-	iounmap(hcd->regs);
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 	usb_put_hcd(hcd);
 
 	return 0;
-- 
1.9.1

