Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138AbaEJJ53 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 05:57:29 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:58336 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756846AbaEJJ5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 05:57:25 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        swarren@wwwdotorg.org, kgene.kim@samsung.com, thierry.reding@gmail.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH 3/6] usb: host: ehci-mv: Use devm_ioremap_resource instead of devm_ioremap
Date: Sat, 10 May 2014 15:27:00 +0530
Message-Id: <1399715823-19839-4-git-send-email-gautam.vivek@samsung.com>
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
 drivers/usb/host/ehci-mv.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/host/ehci-mv.c b/drivers/usb/host/ehci-mv.c
index bd61612..5d03787 100644
--- a/drivers/usb/host/ehci-mv.c
+++ b/drivers/usb/host/ehci-mv.c
@@ -176,10 +176,8 @@ static int mv_ehci_probe(struct platform_device *pdev)
 		goto err_put_hcd;
 	}
 
-	ehci_mv->phy_regs = devm_ioremap(&pdev->dev, r->start,
-					 resource_size(r));
+	ehci_mv->phy_regs = devm_ioremap_resource(&pdev->dev, r);
 	if (!ehci_mv->phy_regs) {
-		dev_err(&pdev->dev, "failed to map phy I/O memory\n");
 		retval = -EFAULT;
 		goto err_put_hcd;
 	}
@@ -191,10 +189,8 @@ static int mv_ehci_probe(struct platform_device *pdev)
 		goto err_put_hcd;
 	}
 
-	ehci_mv->cap_regs = devm_ioremap(&pdev->dev, r->start,
-					 resource_size(r));
+	ehci_mv->cap_regs = devm_ioremap_resource(&pdev->dev, r);
 	if (ehci_mv->cap_regs == NULL) {
-		dev_err(&pdev->dev, "failed to map I/O memory\n");
 		retval = -EFAULT;
 		goto err_put_hcd;
 	}
-- 
1.7.10.4

