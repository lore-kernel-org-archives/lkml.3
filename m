Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbaDDNzG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 09:55:06 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:61635 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbaDDNy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 09:54:59 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, kgene.kim@samsung.com,
        Manjunath Goudar <csmanjuvijay@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] usb: ohci-exynos: Remove locks for 'ohci' in suspend callback
Date: Fri,  4 Apr 2014 19:24:48 +0530
Message-Id: <1396619688-26857-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1396618417-9560-1-git-send-email-gautam.vivek@samsung.com>
References: <1396618417-9560-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch : 14982e3 USB: OHCI: Properly handle ohci-exynos suspend
has already removed 'ohci_hcd' settings from exynos glue layer
as a part of streamlining the ohci controller's suspend.
So we don't need the locks for 'ohci_hcd' anymore.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Cc: Manjunath Goudar <csmanjuvijay@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/host/ohci-exynos.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
index 68588d8..9cf80cb 100644
--- a/drivers/usb/host/ohci-exynos.c
+++ b/drivers/usb/host/ohci-exynos.c
@@ -190,17 +190,13 @@ static int exynos_ohci_suspend(struct device *dev)
 {
 	struct usb_hcd *hcd = dev_get_drvdata(dev);
 	struct exynos_ohci_hcd *exynos_ohci = to_exynos_ohci(hcd);
-	struct ohci_hcd *ohci = hcd_to_ohci(hcd);
 	struct platform_device *pdev = to_platform_device(dev);
 	bool do_wakeup = device_may_wakeup(dev);
-	unsigned long flags;
 	int rc = ohci_suspend(hcd, do_wakeup);
 
 	if (rc)
 		return rc;
 
-	spin_lock_irqsave(&ohci->lock, flags);
-
 	if (exynos_ohci->otg)
 		exynos_ohci->otg->set_host(exynos_ohci->otg, &hcd->self);
 
@@ -208,8 +204,6 @@ static int exynos_ohci_suspend(struct device *dev)
 
 	clk_disable_unprepare(exynos_ohci->clk);
 
-	spin_unlock_irqrestore(&ohci->lock, flags);
-
 	return 0;
 }
 
-- 
1.7.10.4

