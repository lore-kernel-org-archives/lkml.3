Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934920AbaFTQtG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 12:49:06 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:36304 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756992AbaFTQtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:49:02 -0400
Date: Fri, 20 Jun 2014 22:18:53 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] usb: host: xhci-plat: use devm_functions
Message-ID: <20140620164853.GA5798@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the use of managed interface devm_ioremap_resource
for ioremap_nocache and request_mem_region and removes the corresponding
free functions in the probe and remove functions.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
---
 drivers/usb/host/xhci-plat.c | 25 +++++--------------------
 1 file changed, 5 insertions(+), 20 deletions(-)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 29d8adb..31d14a5 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -140,18 +140,11 @@ static int xhci_plat_probe(struct platform_device *pdev)
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
 
-	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len,
-				driver->description)) {
-		dev_dbg(&pdev->dev, "controller already in use\n");
-		ret = -EBUSY;
-		goto put_hcd;
-	}
-
-	hcd->regs = ioremap_nocache(hcd->rsrc_start, hcd->rsrc_len);
-	if (!hcd->regs) {
+	hcd->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(hcd->regs)) {
 		dev_dbg(&pdev->dev, "error mapping memory\n");
-		ret = -EFAULT;
-		goto release_mem_region;
+		ret = PTR_ERR(hcd->regs);
+		goto put_hcd;
 	}
 
 	/*
@@ -162,7 +155,7 @@ static int xhci_plat_probe(struct platform_device *pdev)
 	if (!IS_ERR(clk)) {
 		ret = clk_prepare_enable(clk);
 		if (ret)
-			goto unmap_registers;
+			goto put_hcd;
 	}
 
 	ret = usb_add_hcd(hcd, irq, IRQF_SHARED);
@@ -207,12 +200,6 @@ disable_clk:
 	if (!IS_ERR(clk))
 		clk_disable_unprepare(clk);
 
-unmap_registers:
-	iounmap(hcd->regs);
-
-release_mem_region:
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
-
 put_hcd:
 	usb_put_hcd(hcd);
 
@@ -231,8 +218,6 @@ static int xhci_plat_remove(struct platform_device *dev)
 	usb_remove_hcd(hcd);
 	if (!IS_ERR(clk))
 		clk_disable_unprepare(clk);
-	iounmap(hcd->regs);
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 	usb_put_hcd(hcd);
 	kfree(xhci);
 
-- 
1.9.1

