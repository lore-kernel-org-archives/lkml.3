Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570AbaGAUey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 16:34:54 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:54663 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932372AbaGAUew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 16:34:52 -0400
Date: Wed, 2 Jul 2014 02:04:44 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] fotg210: Use managed interfaces for allocation of resources
Message-ID: <20140701203444.GA19021@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch intoduces the use of devm_ioremap_resource instead of
request_mem_region and ioremap_nocache and removes the calls to free the
allocated memory. Some labels are removes and a new label failed
introduced to make it less specific to the context. The call to a
platform get resource with IORESOURCE_IO is removed as it allocates
memory that is not needed.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/usb/host/fotg210-hcd.c | 48 ++++++++----------------------------------
 1 file changed, 9 insertions(+), 39 deletions(-)

diff --git a/drivers/usb/host/fotg210-hcd.c b/drivers/usb/host/fotg210-hcd.c
index 98a89d1..adcd205 100644
--- a/drivers/usb/host/fotg210-hcd.c
+++ b/drivers/usb/host/fotg210-hcd.c
@@ -5838,41 +5838,17 @@ static int fotg210_hcd_probe(struct platform_device *pdev)
 		goto fail_create_hcd;
 	}
 
+	hcd->has_tt = 1;
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(dev,
-			"Found HC with no register addr. Check %s setup!\n",
-			dev_name(dev));
-		retval = -ENODEV;
-		goto fail_request_resource;
+	hcd->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(hcd->regs)) {
+		retval = PTR_ERR(hcd->regs);
+		goto failed;
 	}
 
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
-	hcd->has_tt = 1;
-
-	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len,
-				fotg210_fotg210_hc_driver.description)) {
-		dev_dbg(dev, "controller already in use\n");
-		retval = -EBUSY;
-		goto fail_request_resource;
-	}
-
-	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
-	if (!res) {
-		dev_err(dev,
-			"Found HC with no register addr. Check %s setup!\n",
-			dev_name(dev));
-		retval = -ENODEV;
-		goto fail_request_resource;
-	}
-
-	hcd->regs = ioremap_nocache(res->start, resource_size(res));
-	if (hcd->regs == NULL) {
-		dev_dbg(dev, "error mapping memory\n");
-		retval = -EFAULT;
-		goto fail_ioremap;
-	}
 
 	fotg210 = hcd_to_fotg210(hcd);
 
@@ -5880,24 +5856,20 @@ static int fotg210_hcd_probe(struct platform_device *pdev)
 
 	retval = fotg210_setup(hcd);
 	if (retval)
-		goto fail_add_hcd;
+		goto failed;
 
 	fotg210_init(fotg210);
 
 	retval = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (retval) {
 		dev_err(dev, "failed to add hcd with err %d\n", retval);
-		goto fail_add_hcd;
+		goto failed;
 	}
 	device_wakeup_enable(hcd->self.controller);
 
 	return retval;
 
-fail_add_hcd:
-	iounmap(hcd->regs);
-fail_ioremap:
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
-fail_request_resource:
+failed:
 	usb_put_hcd(hcd);
 fail_create_hcd:
 	dev_err(dev, "init %s fail, %d\n", dev_name(dev), retval);
@@ -5918,8 +5890,6 @@ static int fotg210_hcd_remove(struct platform_device *pdev)
 		return 0;
 
 	usb_remove_hcd(hcd);
-	iounmap(hcd->regs);
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 	usb_put_hcd(hcd);
 
 	return 0;
-- 
1.9.1

