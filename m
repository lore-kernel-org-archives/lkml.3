Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbaKDC2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 21:28:24 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:34227 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbaKDCZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 21:25:20 -0500
From: varkabhadram@gmail.com
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org
Cc: balbi@ti.com, stern@rowland.harvard.edu,
        sergei.shtylyov@cogentembedded.com, linux-kernel@vger.kernel.org,
        Varka Bhadram <varkabhadram@gmail.com>, Varka Bhadram <varkab@cdac.in>
Subject: [PATCH usb v4 18/27] host: ehci-platform: remove duplicate check on resource
Date: Tue,  4 Nov 2014 07:51:25 +0530
Message-Id: <1415067694-9473-19-git-send-email-varkabhadram@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415067694-9473-1-git-send-email-varkabhadram@gmail.com>
References: <1415067694-9473-1-git-send-email-varkabhadram@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Varka Bhadram <varkabhadram@gmail.com>

Sanity check on resource happening with devm_ioremap_resource().

Signed-off-by: Varka Bhadram <varkab@cdac.in>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/host/ehci-platform.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/host/ehci-platform.c b/drivers/usb/host/ehci-platform.c
index da056fe..35a9aed 100644
--- a/drivers/usb/host/ehci-platform.c
+++ b/drivers/usb/host/ehci-platform.c
@@ -164,11 +164,6 @@ static int ehci_platform_probe(struct platform_device *dev)
 		dev_err(&dev->dev, "no irq provided");
 		return irq;
 	}
-	res_mem = platform_get_resource(dev, IORESOURCE_MEM, 0);
-	if (!res_mem) {
-		dev_err(&dev->dev, "no memory resource provided");
-		return -ENXIO;
-	}
 
 	hcd = usb_create_hcd(&ehci_platform_hc_driver, &dev->dev,
 			     dev_name(&dev->dev));
@@ -250,14 +245,15 @@ static int ehci_platform_probe(struct platform_device *dev)
 			goto err_reset;
 	}
 
-	hcd->rsrc_start = res_mem->start;
-	hcd->rsrc_len = resource_size(res_mem);
-
+	res_mem = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	hcd->regs = devm_ioremap_resource(&dev->dev, res_mem);
 	if (IS_ERR(hcd->regs)) {
 		err = PTR_ERR(hcd->regs);
 		goto err_power;
 	}
+	hcd->rsrc_start = res_mem->start;
+	hcd->rsrc_len = resource_size(res_mem);
+
 	err = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (err)
 		goto err_power;
-- 
1.7.9.5

