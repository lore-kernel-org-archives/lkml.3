Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab3JUOVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 10:21:39 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:51268 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab3JUOTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 10:19:37 -0400
From: Majunath Goudar <csmanjuvijay@gmail.com>
To: csmanjuvijay@gmail.com
Cc: Arnd Bergmann <arnd@arndb.de>, Greg KH <greg@kroah.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH V4 5/6] USB: OHCI: Properly handle ohci-exynos suspend
Date: Mon, 21 Oct 2013 19:48:55 +0530
Message-Id: <1382365136-24472-6-git-send-email-csmanjuvijay@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382365136-24472-1-git-send-email-csmanjuvijay@gmail.com>
References: <1380708947-15966-1-git-send-email-csmanjuvijay@gmail.com>
 <1382365136-24472-1-git-send-email-csmanjuvijay@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suspend scenario in case of ohci-exynos glue was not
properly handled as it was not suspending generic part
of ohci controller. Alan Stern suggested, properly handle
ohci-exynos suspend scenario.

Calling explicitly the ohci_suspend() routine in
exynos_ohci_suspend() will ensure proper handling of suspend
scenario.

Signed-off-by: Manjunath Goudar <csmanjuvijay@gmail.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <greg@kroah.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org
---
V3->V4:
      -No changes, only added Alan Acked-by.

V2->V3:
      -No changes.
      As a build failure on "ep93xx proper suspend patch"
      and Linaro id bounced. Rewrote this patch on top of latest
      Greg usb-next branch. This patch not gives any build error.
      Patch is required for ohci-exynos proper suspending as Alan
      mentioned.

      Initially when I wrote this patch I was working in Linaro,
      now I am not part of Linaro that is why Linaro id is bouncing.
      Sending this patch from personal mail id.

V1->V2:
      -No changes.
       Due to the build failure on ep93xx reverted this patch.
       This patch is needed as Alan Stern suggestion.

 drivers/usb/host/ohci-exynos.c |   22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
index a87baed..4b5c8bd 100644
--- a/drivers/usb/host/ohci-exynos.c
+++ b/drivers/usb/host/ohci-exynos.c
@@ -192,23 +192,14 @@ static int exynos_ohci_suspend(struct device *dev)
 	struct exynos_ohci_hcd *exynos_ohci = to_exynos_ohci(hcd);
 	struct ohci_hcd *ohci = hcd_to_ohci(hcd);
 	struct platform_device *pdev = to_platform_device(dev);
+	bool do_wakeup = device_may_wakeup(dev);
 	unsigned long flags;
-	int rc = 0;
+	int rc = ohci_suspend(hcd, do_wakeup);
 
-	/*
-	 * Root hub was already suspended. Disable irq emission and
-	 * mark HW unaccessible, bail out if RH has been resumed. Use
-	 * the spinlock to properly synchronize with possible pending
-	 * RH suspend or resume activity.
-	 */
-	spin_lock_irqsave(&ohci->lock, flags);
-	if (ohci->rh_state != OHCI_RH_SUSPENDED &&
-			ohci->rh_state != OHCI_RH_HALTED) {
-		rc = -EINVAL;
-		goto fail;
-	}
+	if (rc)
+		return rc;
 
-	clear_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
+	spin_lock_irqsave(&ohci->lock, flags);
 
 	if (exynos_ohci->otg)
 		exynos_ohci->otg->set_host(exynos_ohci->otg, &hcd->self);
@@ -217,10 +208,9 @@ static int exynos_ohci_suspend(struct device *dev)
 
 	clk_disable_unprepare(exynos_ohci->clk);
 
-fail:
 	spin_unlock_irqrestore(&ohci->lock, flags);
 
-	return rc;
+	return 0;
 }
 
 static int exynos_ohci_resume(struct device *dev)
-- 
1.7.9.5

