Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222AbaIIIom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 04:44:42 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:47050 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533AbaIIIoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 04:44:34 -0400
X-AuditID: cbfee61b-f79f86d00000144c-1d-540ebdf081fc
From: Robert Baldyga <r.baldyga@samsung.com>
To: Paul.Zimmerman@synopsys.com
Cc: gregkh@linuxfoundation.org, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kamil Debski <k.debski@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 2/6] usb: dwc2/gadget: fix phy initialization sequence
Date: Tue, 09 Sep 2014 10:44:09 +0200
Message-id: <1410252253-13687-3-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410252253-13687-1-git-send-email-r.baldyga@samsung.com>
References: <1410252253-13687-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jQd0Pe/lCDG7u17E4eL/eonnxejaL
	H68vsFlc3jWHzWLRslZmi7VH7rJbPHq4ldXiweGd7A4cHvvnrmH36NuyitFjy/7PjB7Hb2xn
	8vi8SS6ANYrLJiU1J7MstUjfLoEr4/pvz4I5whXbWz4wNzD+5u9i5OSQEDCROP75FhuELSZx
	4d56IJuLQ0hgOqPEhcVT2CGcdiaJb2/nsINUsQnoSGz5PoERxBYRkJe4vvEmC0gRs8BTRokl
	+6+BFQkLuElc62llBrFZBFQlXn17xApi8wq4Slw/cYkFYp2cxMljk8HinED183v7wc4QAqrp
	fLKWcQIj7wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYweH1THoH46oGi0OMAhyMSjy8
	GcF8IUKsiWXFlbmHGCU4mJVEeK/sBgrxpiRWVqUW5ccXleakFh9ilOZgURLnPdhqHSgkkJ5Y
	kpqdmlqQWgSTZeLglGpgtOk8fyl87yXuvHsZz+9+7/lZl7tGV6GI6d8BKR/FIJ7JF6M31TPf
	1q4577ngG9Nvljkzmyp/9GTv8GvM5HF79dxv5X6zF+5LcmbynpdbPd3VpvOB0K67vjV7kuM1
	TK5k3OrRYpOXPnbHVUvHqjZIfbMea/2jJrv25q+a/T7Oi9rlfGekTGdQYinOSDTUYi4qTgQA
	mifZ9SsCAAA=
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
index 505d56e..fd556e0 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2747,13 +2747,14 @@ static void s3c_hsotg_phy_enable(struct s3c_hsotg *hsotg)
 
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
@@ -2767,13 +2768,14 @@ static void s3c_hsotg_phy_disable(struct s3c_hsotg *hsotg)
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
@@ -3486,9 +3488,6 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
 	if (hsotg->phy && (phy_get_bus_width(phy) == 8))
 		hsotg->phyif = GUSBCFG_PHYIF8;
 
-	if (hsotg->phy)
-		phy_init(hsotg->phy);
-
 	/* usb phy enable */
 	s3c_hsotg_phy_enable(hsotg);
 
@@ -3580,8 +3579,6 @@ static int s3c_hsotg_remove(struct platform_device *pdev)
 		usb_gadget_unregister_driver(hsotg->driver);
 	}
 
-	if (hsotg->phy)
-		phy_exit(hsotg->phy);
 	clk_disable_unprepare(hsotg->clk);
 
 	return 0;
-- 
1.9.1

