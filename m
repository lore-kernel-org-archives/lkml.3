Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab3JQNfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 09:35:41 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:62700 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488Ab3JQNfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 09:35:38 -0400
From: Majunath Goudar <csmanjuvijay@gmail.com>
To: csmanjuvijay@gmail.com
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH V3 3/6]  USB: OHCI: Properly handle ohci-s3c2410 suspend
Date: Thu, 17 Oct 2013 19:05:10 +0530
Message-Id: <1382016913-10872-4-git-send-email-csmanjuvijay@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382016913-10872-1-git-send-email-csmanjuvijay@gmail.com>
References: <1380708947-15966-1-git-send-email-csmanjuvijay@gmail.com>
 <1382016913-10872-1-git-send-email-csmanjuvijay@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suspend scenario in case of ohci-s3c2410 glue was not
properly handled as it was not suspending generic part
of ohci controller. Alan Stern suggested, properly handle
ohci-s3c2410 suspend scenario.

Calling explicitly the ohci_suspend()
routine in ohci_hcd_s3c2410_drv_suspend() will ensure
proper handling of suspend scenario.

V1->V2:
      -No changes.
       Due to the build failure on ep93xx reverted this patch.
       This patch is needed as Alan Stern suggestion.

V2->V3:
      -No changes.
      As a build failure on "ep93xx proper suspend patch" and Linaro 
      id bounced. Rewrote this patch on top of latest Greg usb-next 
      branch. This patch not gives any build error. Patch is required 
      for ohci-s3c2410 proper suspending as Alan mentioned.

      Initially when I wrote this patch I was working in Linaro, now 
      I am not part of Linaro that is why Linaro id is bouncing. Sending 
      this patch from personal mail id.

Signed-off-by: Manjunath Goudar <csmanjuvijay@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/host/ohci-s3c2410.c |   21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/host/ohci-s3c2410.c b/drivers/usb/host/ohci-s3c2410.c
index be3429e..b5bf9b7 100644
--- a/drivers/usb/host/ohci-s3c2410.c
+++ b/drivers/usb/host/ohci-s3c2410.c
@@ -426,28 +426,15 @@ static int ohci_hcd_s3c2410_drv_remove(struct platform_device *pdev)
 static int ohci_hcd_s3c2410_drv_suspend(struct device *dev)
 {
 	struct usb_hcd *hcd = dev_get_drvdata(dev);
-	struct ohci_hcd *ohci = hcd_to_ohci(hcd);
 	struct platform_device *pdev = to_platform_device(dev);
-	unsigned long flags;
+	bool do_wakeup = device_may_wakeup(dev);
 	int rc = 0;
 
-	/*
-	 * Root hub was already suspended. Disable irq emission and
-	 * mark HW unaccessible, bail out if RH has been resumed. Use
-	 * the spinlock to properly synchronize with possible pending
-	 * RH suspend or resume activity.
-	 */
-	spin_lock_irqsave(&ohci->lock, flags);
-	if (ohci->rh_state != OHCI_RH_SUSPENDED) {
-		rc = -EINVAL;
-		goto bail;
-	}
-
-	clear_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
+	rc = ohci_suspend(hcd, do_wakeup);
+	if (rc)
+		return rc;
 
 	s3c2410_stop_hc(pdev);
-bail:
-	spin_unlock_irqrestore(&ohci->lock, flags);
 
 	return rc;
 }
-- 
1.7.9.5

