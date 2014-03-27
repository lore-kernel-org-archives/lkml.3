Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbaC0PRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 11:17:16 -0400
Received: from vsp-authed02.binero.net ([195.74.38.226]:55132 "EHLO
	vsp-authed-01-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755244AbaC0PRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 11:17:09 -0400
From: Andreas Larsson <andreas@gaisler.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        software@gaisler.com
Subject: [PATCH v2 1/7] usb: gadget: gr_udc: Make struct platform_device variable name clearer and use platform_set/get_drvdata
Date: Thu, 27 Mar 2014 16:15:53 +0100
Message-Id: <1395933359-7109-2-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1395933359-7109-1-git-send-email-andreas@gaisler.com>
References: <1395933359-7109-1-git-send-email-andreas@gaisler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename struct platform_device pointers from ofdev to pdev for clarity.
Suggested by Mark Rutland.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---
Differences since v1: use platform_set/get_drvdata

 drivers/usb/gadget/gr_udc.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/gadget/gr_udc.c b/drivers/usb/gadget/gr_udc.c
index f984ee7..ae5bebe 100644
--- a/drivers/usb/gadget/gr_udc.c
+++ b/drivers/usb/gadget/gr_udc.c
@@ -2065,9 +2065,9 @@ static int gr_udc_init(struct gr_udc *dev)
 	return 0;
 }
 
-static int gr_remove(struct platform_device *ofdev)
+static int gr_remove(struct platform_device *pdev)
 {
-	struct gr_udc *dev = dev_get_drvdata(&ofdev->dev);
+	struct gr_udc *dev = platform_get_drvdata(pdev);
 
 	if (dev->added)
 		usb_del_gadget_udc(&dev->gadget); /* Shuts everything down */
@@ -2077,7 +2077,7 @@ static int gr_remove(struct platform_device *ofdev)
 	gr_dfs_delete(dev);
 	if (dev->desc_pool)
 		dma_pool_destroy(dev->desc_pool);
-	dev_set_drvdata(&ofdev->dev, NULL);
+	platform_set_drvdata(pdev, NULL);
 
 	gr_free_request(&dev->epi[0].ep, &dev->ep0reqi->req);
 	gr_free_request(&dev->epo[0].ep, &dev->ep0reqo->req);
@@ -2090,7 +2090,7 @@ static int gr_request_irq(struct gr_udc *dev, int irq)
 					 IRQF_SHARED, driver_name, dev);
 }
 
-static int gr_probe(struct platform_device *ofdev)
+static int gr_probe(struct platform_device *pdev)
 {
 	struct gr_udc *dev;
 	struct resource *res;
@@ -2098,12 +2098,12 @@ static int gr_probe(struct platform_device *ofdev)
 	int retval;
 	u32 status;
 
-	dev = devm_kzalloc(&ofdev->dev, sizeof(*dev), GFP_KERNEL);
+	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
 	if (!dev)
 		return -ENOMEM;
-	dev->dev = &ofdev->dev;
+	dev->dev = &pdev->dev;
 
-	res = platform_get_resource(ofdev, IORESOURCE_MEM, 0);
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	regs = devm_ioremap_resource(dev->dev, res);
 	if (IS_ERR(regs))
 		return PTR_ERR(regs);
@@ -2132,7 +2132,7 @@ static int gr_probe(struct platform_device *ofdev)
 	spin_lock_init(&dev->lock);
 	dev->regs = regs;
 
-	dev_set_drvdata(&ofdev->dev, dev);
+	platform_set_drvdata(pdev, dev);
 
 	/* Determine number of endpoints and data interface mode */
 	status = gr_read32(&dev->regs->status);
@@ -2204,7 +2204,7 @@ out:
 	spin_unlock(&dev->lock);
 
 	if (retval)
-		gr_remove(ofdev);
+		gr_remove(pdev);
 
 	return retval;
 }
-- 
1.7.10.4

