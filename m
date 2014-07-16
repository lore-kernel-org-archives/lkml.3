Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933169AbaGPKZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 06:25:58 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53087 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbaGPKXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 06:23:04 -0400
X-AuditID: cbfee61a-f79e46d00000134f-72-53c6527f4fd7
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Kamil Debski <k.debski@samsung.com>,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2 03/12] usb: dwc2/gadget: move phy bus legth initialization
Date: Wed, 16 Jul 2014 12:22:21 +0200
Message-id: <1405506150-16185-4-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1405506150-16185-1-git-send-email-r.baldyga@samsung.com>
References: <1405506150-16185-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHLMWRmVeSWpSXmKPExsVy+t9jQd36oGPBBq8XyFrMetnOYnHwfr1F
	8+L1bBY/Xl9gs7i8aw6bxaJlrcwWa4/cZbfYPmU6k8WDwzvZHTg99s9dw+7Rt2UVo8eW/Z8Z
	PY7f2M7k8XmTXABrFJdNSmpOZllqkb5dAlfGnN1L2AoO81VMPX2UsYFxP3cXIyeHhICJxL1z
	k5khbDGJC/fWs3UxcnEICUxnlNjxeiojhNPOJHHrSzs7SBWbgI7Elu8TGEFsEQEBifUvLrGD
	FDELvGWUmHbuGwtIQljAV6Jjx1I2EJtFQFViwZIjYDavgKvEi9evGCHWyUmcPDaZFcTmFHCT
	WPO6GWyBEFDN8XXLmCYw8i5gZFjFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERxqz6R2MK5s
	sDjEKMDBqMTDuyHkaLAQa2JZcWXuIUYJDmYlEV4H/2PBQrwpiZVVqUX58UWlOanFhxilOViU
	xHkPtFoHCgmkJ5akZqemFqQWwWSZODilGhjP57dc8vi1/YfFcndWlkvfJHTeBrqlLmGOUpUw
	/n/mcm9hcPFBLsfoGHd93tBV9Y2+wdvjjdccLVVcw3zRZ9XErRpR9w81L5m0Yofs09WplY+W
	LN5/+8XHrQd2XxK6YH5dr6kmXvtb6mH5pMXL1jDGf1mw4IeD33m+/ayMNUcnKlcqzE8Mal2r
	xFKckWioxVxUnAgAyG8PFTECAAA=
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
index 70eab95..fc27b4c 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -3395,6 +3395,9 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	/* Set default UTMI width */
+	hsotg->phyif = GUSBCFG_PHYIF16;
+
 	/*
 	 * Attempt to find a generic PHY, then look for an old style
 	 * USB PHY, finally fall back to pdata
@@ -3413,8 +3416,15 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
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
 
@@ -3481,16 +3491,6 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
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

