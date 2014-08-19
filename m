Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaHSI40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 04:56:26 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:54887 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaHSI4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 04:56:23 -0400
X-AuditID: cbfee61b-f79f86d00000144c-b0-53f31135464b
From: Robert Baldyga <r.baldyga@samsung.com>
To: Paul.Zimmerman@synopsys.com
Cc: gregkh@linuxfoundation.org, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Kamil Debski <k.debski@samsung.com>,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH RESEND v3 02/12] usb: dwc2/gadget: fix phy initialization
 sequence
Date: Tue, 19 Aug 2014 10:54:08 +0200
Message-id: <1408438458-3317-3-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1408438458-3317-1-git-send-email-r.baldyga@samsung.com>
References: <1408438458-3317-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t9jQV1Twc/BBpdmS1rMetnOYnHwfr1F
	8+L1bBY/Xl9gs7i8aw6bxaJlrcwWa4/cZbd49HArq8WDwzvZHTg99s9dw+7Rt2UVo8eW/Z8Z
	PY7f2M7k8XmTXABrFJdNSmpOZllqkb5dAlfGks1bGAvmCFf0XX/N3MD4m7+LkZNDQsBEYuXW
	k6wQtpjEhXvr2boYuTiEBKYzSnTs+8sM4bQzSdy5coINpIpNQEdiy/cJjCC2iIC8xPWNN1lA
	ipgFnjNKnFk/EWyUsECIxPSzu4ASHBwsAqoShzbFgIR5BVwkPkzZygyxTU7i5LHJYOWcAq4S
	b/fNYgexhYBqNreeYZvAyLuAkWEVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnCgPZPewbiq
	weIQowAHoxIPr8KXj8FCrIllxZW5hxglOJiVRHgdX3wKFuJNSaysSi3Kjy8qzUktPsQozcGi
	JM57sNU6UEggPbEkNTs1tSC1CCbLxMEp1cCYEXvlR+uMrTfWHikM2PhtV+q9ZamrRbdwetq8
	77l1wuvSDxffxxpLZbNkzK4GPZ8VkrOZ/3J+ns7f0J9/jGut+XNnK+446fZh39s37up3p0x9
	8nkL69xpxj/+z7r7/2n57a1Kjx5e+Ji2TVbraMAzhW+7by0LS1qVsZzl09G5Mk+d/nO+9H86
	/a8SS3FGoqEWc1FxIgCV7iE/MAIAAA==
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
index d27417e..f0135a5 100644
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

