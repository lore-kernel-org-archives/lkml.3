Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030222AbaGRLnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 07:43:13 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:42896 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400AbaGRLj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 07:39:59 -0400
X-AuditID: cbfee61b-f79f86d00000144c-07-53c9078ecd2f
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Kamil Debski <k.debski@samsung.com>,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v3 03/12] usb: dwc2/gadget: move phy bus legth initialization
Date: Fri, 18 Jul 2014 13:39:28 +0200
Message-id: <1405683577-11226-4-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1405683577-11226-1-git-send-email-r.baldyga@samsung.com>
References: <1405683577-11226-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t9jAd0+9pPBBisfSFvMetnOYnHwfr1F
	8+L1bBY/Xl9gs7i8aw6bxaJlrcwWa4/cZbfYPmU6k8WDwzvZHTg99s9dw+7Rt2UVo8eW/Z8Z
	PY7f2M7k8XmTXABrFJdNSmpOZllqkb5dAlfGnN1L2AoO81VMPX2UsYFxP3cXIyeHhICJxKkd
	8xghbDGJC/fWs3UxcnEICSxilGiY/JoVwmlnkji4/QorSBWbgI7Elu8TwDpEBAQk1r+4xA5S
	xCzwllFi2rlvLCAJYQFfiU+XvjCB2CwCqhKPPjWDNfMKuEq0fXjMDrFOTuLksclgcU4BN4m2
	R/+BejmAtrlKTPvKP4GRdwEjwypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4EB7Jr2DcVWD
	xSFGAQ5GJR5ei5vHg4VYE8uKK3MPMUpwMCuJ8GbfBwrxpiRWVqUW5ccXleakFh9ilOZgURLn
	PdhqHSgkkJ5YkpqdmlqQWgSTZeLglGpgVN50ruJtyu+l26+eDlTujtaexieZdEuJ6eaPVuvT
	H6esULymsvP7hZBri3k0z67jqW2a6C+413q+4NbrYlc82fjvn7lwRlmrkueigHmo8apPdky6
	xhd+v/8nVr15G2vRuqmPE0LY2f+JZM7fmtO+e19aZarhuslsE7i3/WwX+vPWteR7rLWrnRJL
	cUaioRZzUXEiALEYuygwAgAA
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

