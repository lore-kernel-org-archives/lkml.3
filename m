Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168AbaEJJ5d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 05:57:33 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:51145 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756846AbaEJJ53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 05:57:29 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        swarren@wwwdotorg.org, kgene.kim@samsung.com, thierry.reding@gmail.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH 4/6] usb: host: ehci-spear: Use devm_ioremap_resource instead of devm_ioremap
Date: Sat, 10 May 2014 15:27:01 +0530
Message-Id: <1399715823-19839-5-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399715823-19839-1-git-send-email-gautam.vivek@samsung.com>
References: <1399715823-19839-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using devm_ioremap_resource() API should actually be preferred over
devm_ioremap(), since the former request the mem region first and then
gives back the ioremap'ed memory pointer.
devm_ioremap_resource() calls request_mem_region(), therby preventing
other drivers to make any overlapping call to the same region.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/host/ehci-spear.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/usb/host/ehci-spear.c b/drivers/usb/host/ehci-spear.c
index 8bd915b..6d84cf2 100644
--- a/drivers/usb/host/ehci-spear.c
+++ b/drivers/usb/host/ehci-spear.c
@@ -106,15 +106,8 @@ static int spear_ehci_hcd_drv_probe(struct platform_device *pdev)
 
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
-	if (!devm_request_mem_region(&pdev->dev, hcd->rsrc_start, hcd->rsrc_len,
-				driver->description)) {
-		retval = -EBUSY;
-		goto err_put_hcd;
-	}
-
-	hcd->regs = devm_ioremap(&pdev->dev, hcd->rsrc_start, hcd->rsrc_len);
+	hcd->regs = devm_ioremap_resource(&pdev->dev, res);
 	if (hcd->regs == NULL) {
-		dev_dbg(&pdev->dev, "error mapping memory\n");
 		retval = -ENOMEM;
 		goto err_put_hcd;
 	}
-- 
1.7.10.4

