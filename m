Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349AbaIIIpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 04:45:21 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:51211 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290AbaIIIpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 04:45:13 -0400
X-AuditID: cbfee61b-f79f86d00000144c-5c-540ebe187967
From: Robert Baldyga <r.baldyga@samsung.com>
To: Paul.Zimmerman@synopsys.com
Cc: gregkh@linuxfoundation.org, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kamil Debski <k.debski@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 1/6] usb: dwc2/gadget: move phy bus legth initialization
Date: Tue, 09 Sep 2014 10:44:52 +0200
Message-id: <1410252297-13738-2-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410252297-13738-1-git-send-email-r.baldyga@samsung.com>
References: <1410252297-13738-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jQV2JfXwhBm/7eCwO3q+3aF68ns3i
	x+sLbBaXd81hs1i0rJXZYu2Ru+wWjx5uZbV4cHgnuwOHx/65a9g9+rasYvTYsv8zo8fxG9uZ
	PD5vkgtgjeKySUnNySxLLdK3S+DK2Pm5n73gLF/FhfvfmBsYT3B3MXJySAiYSCxq2cUKYYtJ
	XLi3nq2LkYtDSGA6o8T2FU2MEE47k8T20weZQarYBHQktnyfwAhiiwjIS1zfeJMFpIhZ4Cmj
	xJL919hBEsICHhJvV3wCG8sioCrx4+ksoGYODl4BV4mPL8UhtslJnDw2GayEU8BN4s+xL2Ct
	QkAl/+ZMY5nAyLuAkWEVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnB4PZPewbiqweIQowAH
	oxIPb0YwX4gQa2JZcWXuIUYJDmYlEd4ru4FCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeQ+2WgcK
	CaQnlqRmp6YWpBbBZJk4OKUaGC1urw3Zoj69OU3X8yzrc62UxmMX5VcGpr1f/nv/jdNiTwNc
	jrtJB3AHz/by6Ph5aZae1cF52z4GrO3Oudkf+X5DrPeZt3sj+3MZ6qYpJM7b3cQg6JDWxL7M
	cCNfqzOz1sxMtu37uAQCT1mXWpYdmPTG9KCiZvJxQdlpnfF9jz5vKJAxPPrBQomlOCPRUIu5
	qDgRAJyFIJkrAgAA
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
index ce6071d..9cbe136 100644
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
 
@@ -3471,16 +3481,6 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
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

