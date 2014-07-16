Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756AbaGPKXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 06:23:00 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:17982 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758621AbaGPKWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 06:22:53 -0400
X-AuditID: cbfee61a-f79e46d00000134f-69-53c6527b0bfd
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Kamil Debski <k.debski@samsung.com>,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2 02/12] usb: dwc2/gadget: fix phy initialization sequence
Date: Wed, 16 Jul 2014 12:22:20 +0200
Message-id: <1405506150-16185-3-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1405506150-16185-1-git-send-email-r.baldyga@samsung.com>
References: <1405506150-16185-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t9jQd3qoGPBBg82qVnMetnOYnHwfr1F
	8+L1bBY/Xl9gs7i8aw6bxaJlrcwWa4/cZbfYPmU6k8WDwzvZHTg99s9dw+7Rt2UVo8eW/Z8Z
	PY7f2M7k8XmTXABrFJdNSmpOZllqkb5dAlfGnS7egjnCFQfnrmFtYPzN38XIySEhYCLR8KWF
	EcIWk7hwbz1bFyMXh5DAdEaJ7nOHoZx2JomL8y4xgVSxCehIbPk+AaxDREBAYv2LS+wgRcwC
	bxklpp37xgKSEBbwlliy8iiYzSKgKnHq+Q9mEJtXwFXi/ckz7BDr5CROHpvMCmJzCrhJrHnd
	DBYXAqo5vm4Z0wRG3gWMDKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxggPtmdQOxpUNFocY
	BTgYlXh4N4QcDRZiTSwrrsw9xCjBwawkwuvgfyxYiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+B
	VutAIYH0xJLU7NTUgtQimCwTB6dUA+N6r74OiVj5Yzvdp+/+lXHVKuDZPiE9pShGBtH218tZ
	ApR9nN94/NJkPJga7tpvmbNoZYjeNbegT757xY55s/62in50wsQ084Goply6g/gn3tbyqa3f
	OuLt2naueuQbvfT8m36+7+k8yRPVT/QGW8svWu479Vzz4heFTmlrnm27eKD2SXfjDyWW4oxE
	Qy3mouJEAMmLbZowAgAA
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

