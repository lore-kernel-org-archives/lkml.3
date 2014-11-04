Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258AbaKDCWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 21:22:37 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:33589 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbaKDCWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 21:22:31 -0500
From: varkabhadram@gmail.com
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org
Cc: balbi@ti.com, stern@rowland.harvard.edu,
        sergei.shtylyov@cogentembedded.com, linux-kernel@vger.kernel.org,
        Varka Bhadram <varkabhadram@gmail.com>, Varka Bhadram <varkab@cdac.in>
Subject: [PATCH usb v4 08/27] host: ohci-octeon: remove duplicate check on resource
Date: Tue,  4 Nov 2014 07:51:15 +0530
Message-Id: <1415067694-9473-9-git-send-email-varkabhadram@gmail.com>
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
 drivers/usb/host/ohci-octeon.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/host/ohci-octeon.c b/drivers/usb/host/ohci-octeon.c
index 15af895..20d861b 100644
--- a/drivers/usb/host/ohci-octeon.c
+++ b/drivers/usb/host/ohci-octeon.c
@@ -120,12 +120,6 @@ static int ohci_octeon_drv_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	res_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res_mem == NULL) {
-		dev_err(&pdev->dev, "No register space assigned\n");
-		return -ENODEV;
-	}
-
 	/* Ohci is a 32-bit device. */
 	ret = dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 	if (ret)
@@ -135,14 +129,14 @@ static int ohci_octeon_drv_probe(struct platform_device *pdev)
 	if (!hcd)
 		return -ENOMEM;
 
-	hcd->rsrc_start = res_mem->start;
-	hcd->rsrc_len = resource_size(res_mem);
-
+	res_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	reg_base = devm_ioremap_resource(&pdev->dev, res_mem);
 	if (IS_ERR(reg_base)) {
 		ret = PTR_ERR(reg_base);
 		goto err1;
 	}
+	hcd->rsrc_start = res_mem->start;
+	hcd->rsrc_len = resource_size(res_mem);
 
 	ohci_octeon_hw_start();
 
-- 
1.7.9.5

