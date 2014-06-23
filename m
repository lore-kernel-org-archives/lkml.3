Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbaFWHwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 03:52:43 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:60229 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbaFWHwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 03:52:39 -0400
X-AuditID: cbfee61a-f79e46d00000134f-16-53a7dcc57e42
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Kamil Debski <k.debski@samsung.com>,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 03/11] usb: dwc2/gadget: move phy bus legth initialization
Date: Mon, 23 Jun 2014 09:51:22 +0200
Message-id: <1403509890-14103-4-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1403509890-14103-1-git-send-email-r.baldyga@samsung.com>
References: <1403509890-14103-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t9jQd1jd5YHG0zpZ7OY9bKdxeLg/XqL
	5sXr2Sx+vL7AZnF51xw2i0XLWpkt1h65y26xfcp0JosHh3eyO3B67J+7ht2jb8sqRo8t+z8z
	ehy/sZ3J4/MmuQDWKC6blNSczLLUIn27BK6MObuXsBUc5quYevooYwPjfu4uRk4OCQETiRXb
	VzNB2GISF+6tZ+ti5OIQEpjOKPHk7GpGCKedSaL9/Fk2kCo2AR2JLd8nMILYIgICEutfXGIH
	KWIWeMsoMe3cN5YuRg4OYQEviasTq0BqWARUJWZN3gq2gVfAVWLvoo/sENvkJE4em8wKYnMK
	uEmsv7kQLC4EVLPo9DT2CYy8CxgZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEB9ozqR2M
	KxssDjEKcDAq8fBquC0PFmJNLCuuzD3EKMHBrCTC29gAFOJNSaysSi3Kjy8qzUktPsQozcGi
	JM57oNU6UEggPbEkNTs1tSC1CCbLxMEp1cCoVsb2ceaEW9O2O348WvfE3LdI3XJHy4EOMR6j
	JwyS34++6ODeffwSC4/rxWuslXZ3mNXPma6TurH22KUXJgwczhd3TjXaorchpK3ITOOKybFa
	rRlcynNeO1QeuVYivnnrXwVG43PLiloLL2SltGhJnBQ/EzT5WVlszc2dr/fe/xrz83k+75MW
	JZbijERDLeai4kQA6XKL6jACAAA=
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

