Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761604AbaGRLkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 07:40:00 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:42882 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761571AbaGRLj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 07:39:56 -0400
X-AuditID: cbfee61b-f79f86d00000144c-00-53c9078afdb9
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Kamil Debski <k.debski@samsung.com>,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v3 02/12] usb: dwc2/gadget: fix phy initialization sequence
Date: Fri, 18 Jul 2014 13:39:27 +0200
Message-id: <1405683577-11226-3-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1405683577-11226-1-git-send-email-r.baldyga@samsung.com>
References: <1405683577-11226-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDLMWRmVeSWpSXmKPExsVy+t9jAd0u9pPBBpd/qljMetnOYnHwfr1F
	8+L1bBY/Xl9gs7i8aw6bxaJlrcwWa4/cZbfYPmU6k8WDwzvZHTg99s9dw+7Rt2UVo8eW/Z8Z
	PY7f2M7k8XmTXABrFJdNSmpOZllqkb5dAlfGnS7egjnCFQfnrmFtYPzN38XIySEhYCIx7fdn
	VghbTOLCvfVsXYxcHEICixgldt2fxgjhtDNJTHvxkB2kik1AR2LL9wmMILaIgIDE+heX2EGK
	mAXeMkpMO/eNBSQhLOAtsf1BG9hYFgFViQ3H94A18wq4Smw7+pkNYp2cxMljk8FqOAXcJNoe
	/Qfq5QDa5iox7Sv/BEbeBYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCw+yZ9A7GVQ0W
	hxgFOBiVeHgtbh4PFmJNLCuuzD3EKMHBrCTCm30fKMSbklhZlVqUH19UmpNafIhRmoNFSZz3
	YKt1oJBAemJJanZqakFqEUyWiYNTqoHRY9XiOk8Wj/ucoimdBZoRyzim/vh3fs7VXpF/Lczp
	oke+VpnryK0S3xhwVaZw4tLFFYxsPyYLz39j/DOizp/t4Pt1z5eeWyacJ/S88OW1Wr4lQhsC
	/yz20VugsXLjziq2udybf3v8u2Bfe9Nx1vZ67YrlJxlfrU47pFr13fXK2RWeuoJe8nYmSizF
	GYmGWsxFxYkA0OX04y8CAAA=
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

