Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbaHSI5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 04:57:08 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:39004 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaHSI5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 04:57:05 -0400
X-AuditID: cbfee61b-f79f86d00000144c-93-53f3115f7fb7
From: Robert Baldyga <r.baldyga@samsung.com>
To: Paul.Zimmerman@synopsys.com
Cc: gregkh@linuxfoundation.org, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Kamil Debski <k.debski@samsung.com>,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH RESEND v3 03/12] usb: dwc2/gadget: move phy bus legth
 initialization
Date: Tue, 19 Aug 2014 10:54:09 +0200
Message-id: <1408438458-3317-4-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1408438458-3317-1-git-send-email-r.baldyga@samsung.com>
References: <1408438458-3317-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t9jQd14wc/BBuvvmljMetnOYnHwfr1F
	8+L1bBY/Xl9gs7i8aw6bxaJlrcwWa4/cZbd49HArq8WDwzvZHTg99s9dw+7Rt2UVo8eW/Z8Z
	PY7f2M7k8XmTXABrFJdNSmpOZllqkb5dAlfGmp5VzAVn+Sru3//H0sB4gruLkZNDQsBEouHS
	ZiYIW0ziwr31bF2MXBxCAtMZJeZOmMAGkhASaGeSeLYyAcRmE9CR2PJ9AiOILSIgL3F9400W
	kAZmgeeMEmfWT2QFSQgLhEkse32aGcRmEVCVePj+HVgDr4CLxP6vJ9kgtslJnDw2GayeU8BV
	4u2+WewQy1wkNreeYZvAyLuAkWEVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnCgPZPewbiq
	weIQowAHoxIPr8KXj8FCrIllxZW5hxglOJiVRHgdX3wKFuJNSaysSi3Kjy8qzUktPsQozcGi
	JM57sNU6UEggPbEkNTs1tSC1CCbLxMEp1cCoLFzxp/PXKrGdS1RWLA9w74/PNfV8a/jjqW95
	2aGtRyer/WFmYmxa3X/gzTlZuz1PPnH/XxwdsuAua6t/1MHoJXf+Mp3R+WO0RVP5pfFxFo/r
	Cl1HdzyaKC9kmrvJ9AUT/6WfTxdpChyfEf+tuYhJd/ljx8QZl05r1V1T48ivnJksbf/WsCxd
	iaU4I9FQi7moOBEAw7Sz4TACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kamil Debski <k.debski@samsung.com>

This patch moves the part of code that initializes the PHY bus width.
This results in simpler code and removes the need to check whether
the Generic PHY Framework is used.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/dwc2/gadget.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index f0135a5..2d09ed1 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -3392,6 +3392,9 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
 	if (!hsotg)
 		return -ENOMEM;
 
+	/* Set default UTMI width */
+	hsotg->phyif = GUSBCFG_PHYIF16;
+
 	/*
 	 * Attempt to find a generic PHY, then look for an old style
 	 * USB PHY, finally fall back to pdata
@@ -3410,8 +3413,15 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
 			hsotg->plat = plat;
 		} else
 			hsotg->uphy = uphy;
-	} else
+	} else {
 		hsotg->phy = phy;
+		/*
+		 * If using the generic PHY framework, check if the PHY bus
+		 * width is 8-bit and set the phyif appropriately.
+		 */
+		if (phy_get_bus_width(phy) == 8)
+			hsotg->phyif = GUSBCFG_PHYIF8;
+	}
 
 	hsotg->dev = dev;
 
@@ -3478,16 +3488,6 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
 		goto err_supplies;
 	}
 
-	/* Set default UTMI width */
-	hsotg->phyif = GUSBCFG_PHYIF16;
-
-	/*
-	 * If using the generic PHY framework, check if the PHY bus
-	 * width is 8-bit and set the phyif appropriately.
-	 */
-	if (hsotg->phy && (phy_get_bus_width(phy) == 8))
-		hsotg->phyif = GUSBCFG_PHYIF8;
-
 	/* usb phy enable */
 	s3c_hsotg_phy_enable(hsotg);
 
-- 
1.9.1

