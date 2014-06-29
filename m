Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbaF2HHx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 03:07:53 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39607 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbaF2HHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 03:07:51 -0400
Date: Sun, 29 Jun 2014 12:37:44 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] USB: oxu210hp-hcd.c: use devm_ functions
Message-ID: <20140629070743.GA15703@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the use of devm_ioremap_resource instead of
request_mem_region and ioremap. The error handling on
platform_get_resource and the error message for ioremap are removed. The
function devm_kzalloc replaces memory allocation by unmanaged kzalloc. The
function calls to free the allocated memory in the probe and remove
functions are done away with. Some labels are removed and a label error
is added to make is less specific to the context. The debug message is
removed as devm_ioremap generates debug messages of its own.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/usb/host/oxu210hp-hcd.c | 48 ++++++++---------------------------------
 1 file changed, 9 insertions(+), 39 deletions(-)

diff --git a/drivers/usb/host/oxu210hp-hcd.c b/drivers/usb/host/oxu210hp-hcd.c
index e07248b..da5fb0e 100644
--- a/drivers/usb/host/oxu210hp-hcd.c
+++ b/drivers/usb/host/oxu210hp-hcd.c
@@ -3826,49 +3826,36 @@ static int oxu_drv_probe(struct platform_device *pdev)
 	dev_dbg(&pdev->dev, "IRQ resource %d\n", irq);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "no registers address! Check %s setup!\n",
-			dev_name(&pdev->dev));
-		return -ENODEV;
+	base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base)) {
+		ret = PTR_ERR(base);
+		goto error;
 	}
 	memstart = res->start;
 	memlen = resource_size(res);
-	dev_dbg(&pdev->dev, "MEM resource %lx-%lx\n", memstart, memlen);
-	if (!request_mem_region(memstart, memlen,
-				oxu_hc_driver.description)) {
-		dev_dbg(&pdev->dev, "memory area already in use\n");
-		return -EBUSY;
-	}
 
 	ret = irq_set_irq_type(irq, IRQF_TRIGGER_FALLING);
 	if (ret) {
 		dev_err(&pdev->dev, "error setting irq type\n");
 		ret = -EFAULT;
-		goto error_set_irq_type;
-	}
-
-	base = ioremap(memstart, memlen);
-	if (!base) {
-		dev_dbg(&pdev->dev, "error mapping memory\n");
-		ret = -EFAULT;
-		goto error_ioremap;
+		goto error;
 	}
 
 	/* Allocate a driver data struct to hold useful info for both
 	 * SPH & OTG devices
 	 */
-	info = kzalloc(sizeof(struct oxu_info), GFP_KERNEL);
+	info = devm_kzalloc(&pdev->dev, sizeof(struct oxu_info), GFP_KERNEL);
 	if (!info) {
 		dev_dbg(&pdev->dev, "error allocating memory\n");
 		ret = -EFAULT;
-		goto error_alloc;
+		goto error;
 	}
 	platform_set_drvdata(pdev, info);
 
 	ret = oxu_init(pdev, memstart, memlen, base, irq);
 	if (ret < 0) {
 		dev_dbg(&pdev->dev, "cannot init USB devices\n");
-		goto error_init;
+		goto error;
 	}
 
 	dev_info(&pdev->dev, "devices enabled and running\n");
@@ -3876,16 +3863,7 @@ static int oxu_drv_probe(struct platform_device *pdev)
 
 	return 0;
 
-error_init:
-	kfree(info);
-
-error_alloc:
-	iounmap(base);
-
-error_set_irq_type:
-error_ioremap:
-	release_mem_region(memstart, memlen);
-
+error:
 	dev_err(&pdev->dev, "init %s fail, %d\n", dev_name(&pdev->dev), ret);
 	return ret;
 }
@@ -3899,18 +3877,10 @@ static void oxu_remove(struct platform_device *pdev, struct usb_hcd *hcd)
 static int oxu_drv_remove(struct platform_device *pdev)
 {
 	struct oxu_info *info = platform_get_drvdata(pdev);
-	unsigned long memstart = info->hcd[0]->rsrc_start,
-			memlen = info->hcd[0]->rsrc_len;
-	void *base = info->hcd[0]->regs;
 
 	oxu_remove(pdev, info->hcd[0]);
 	oxu_remove(pdev, info->hcd[1]);
 
-	iounmap(base);
-	release_mem_region(memstart, memlen);
-
-	kfree(info);
-
 	return 0;
 }
 
-- 
1.9.1

