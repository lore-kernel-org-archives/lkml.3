Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbaFWHwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 03:52:31 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50603 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbaFWHw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 03:52:28 -0400
X-AuditID: cbfee61a-f79e46d00000134f-f1-53a7dcba99eb
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Kamil Debski <k.debski@samsung.com>,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 02/11] usb: dwc2/gadget: fix phy initialization sequence
Date: Mon, 23 Jun 2014 09:51:21 +0200
Message-id: <1403509890-14103-3-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1403509890-14103-1-git-send-email-r.baldyga@samsung.com>
References: <1403509890-14103-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNLMWRmVeSWpSXmKPExsVy+t9jQd3dd5YHG8yIsJj1sp3F4uD9eovm
	xevZLH68vsBmcXnXHDaLRctamS3WHrnLbrF9ynQmiweHd7I7cHrsn7uG3aNvyypGjy37PzN6
	HL+xncnj8ya5ANYoLpuU1JzMstQifbsErow7XbwFc4QrDs5dw9rA+Ju/i5GTQ0LAROJe0yQm
	CFtM4sK99WxdjFwcQgLTGSX2N35khnDamSR+/PnCCFLFJqAjseX7BDBbREBAYv2LS+wgRcwC
	bxklpp37xtLFyMEhLOAhMW+fKkgNi4CqxLnzZ9hBbF4BV4kJCxqgtslJnDw2mRXE5hRwk1h/
	cyFYjRBQzaLT09gnMPIuYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREcZM+kdjCubLA4
	xCjAwajEw6vhtjxYiDWxrLgy9xCjBAezkghvYwNQiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+B
	VutAIYH0xJLU7NTUgtQimCwTB6dUAyOjXJR4euTmBdmrfh2Zdi40yvTrvozI+/tmHBG2kUo5
	WHONWy7jmC37nKeLXAJY57mnJrB7L3z5b0bpliyth/vE2ZbHmJfc3LHTqV07w4Ln0jPOoDNH
	PU6EOpzUSDfMk8xMXLJyaqlfZdeUqwqauofX36z7eOF64d8KpRIBwdnFHAdEnvXa+iixFGck
	GmoxFxUnAgDleT85LgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kamil Debski <k.debski@samsung.com>

In the Generic PHY Framework a NULL phy is considered to be a valid phy
thus the "if (hsotg->phy)" check does not give us the information whether
the Generic PHY Framework is used.

In addition to the above this patch also removes phy_init from probe and
phy_exit from remove. This is not necessary when init/exit is done in the
s3c_hsotg_phy_enable/disable functions.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/dwc2/gadget.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index ccef3a7..70eab95 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2748,13 +2748,14 @@ static void s3c_hsotg_phy_enable(struct s3c_hsotg *hsotg)
 
 	dev_dbg(hsotg->dev, "pdev 0x%p\n", pdev);
 
-	if (hsotg->phy) {
-		phy_init(hsotg->phy);
-		phy_power_on(hsotg->phy);
-	} else if (hsotg->uphy)
+	if (hsotg->uphy)
 		usb_phy_init(hsotg->uphy);
-	else if (hsotg->plat->phy_init)
+	else if (hsotg->plat && hsotg->plat->phy_init)
 		hsotg->plat->phy_init(pdev, hsotg->plat->phy_type);
+	else {
+		phy_init(hsotg->phy);
+		phy_power_on(hsotg->phy);
+	}
 }
 
 /**
@@ -2768,13 +2769,14 @@ static void s3c_hsotg_phy_disable(struct s3c_hsotg *hsotg)
 {
 	struct platform_device *pdev = to_platform_device(hsotg->dev);
 
-	if (hsotg->phy) {
-		phy_power_off(hsotg->phy);
-		phy_exit(hsotg->phy);
-	} else if (hsotg->uphy)
+	if (hsotg->uphy)
 		usb_phy_shutdown(hsotg->uphy);
-	else if (hsotg->plat->phy_exit)
+	else if (hsotg->plat && hsotg->plat->phy_exit)
 		hsotg->plat->phy_exit(pdev, hsotg->plat->phy_type);
+	else {
+		phy_power_off(hsotg->phy);
+		phy_exit(hsotg->phy);
+	}
 }
 
 /**
@@ -3489,9 +3491,6 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
 	if (hsotg->phy && (phy_get_bus_width(phy) == 8))
 		hsotg->phyif = GUSBCFG_PHYIF8;
 
-	if (hsotg->phy)
-		phy_init(hsotg->phy);
-
 	/* usb phy enable */
 	s3c_hsotg_phy_enable(hsotg);
 
@@ -3584,8 +3583,6 @@ static int s3c_hsotg_remove(struct platform_device *pdev)
 		usb_gadget_unregister_driver(hsotg->driver);
 	}
 
-	if (hsotg->phy)
-		phy_exit(hsotg->phy);
 	clk_disable_unprepare(hsotg->clk);
 
 	return 0;
-- 
1.9.1

