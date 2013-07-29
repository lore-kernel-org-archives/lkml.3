Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab3G2H14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 03:27:56 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:34895 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885Ab3G2H1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 03:27:55 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: [PATCH v2] usb: dwc3: core: modify IO memory resource after deferred probe completes
Date: Mon, 29 Jul 2013 10:27:02 +0300
Message-Id: <1375082822-3516-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

When deferred probe happens driver will try to ioremap multiple times
and will fail. Memory resource.start variable is a global variable,
modifications in this field will be accumulated on every probe.
Fix this by moving the above operations after driver hold all
required PHY's.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---

Felipe, Paul if you get better solution please go ahead and ignore
this patch.

v2 - inline comments

 drivers/usb/dwc3/core.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 607bef8..c257117 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -384,21 +384,6 @@ static int dwc3_probe(struct platform_device *pdev)
 		dev_err(dev, "missing memory resource\n");
 		return -ENODEV;
 	}
-	dwc->xhci_resources[0].start = res->start;
-	dwc->xhci_resources[0].end = dwc->xhci_resources[0].start +
-					DWC3_XHCI_REGS_END;
-	dwc->xhci_resources[0].flags = res->flags;
-	dwc->xhci_resources[0].name = res->name;
-
-	res->start += DWC3_GLOBALS_REGS_START;
-
-	 /*
-	  * Request memory region but exclude xHCI regs,
-	  * since it will be requested by the xhci-plat driver.
-	  */
-	regs = devm_ioremap_resource(dev, res);
-	if (IS_ERR(regs))
-		return PTR_ERR(regs);
 
 	if (node) {
 		dwc->maximum_speed = of_usb_get_maximum_speed(node);
@@ -452,6 +437,22 @@ static int dwc3_probe(struct platform_device *pdev)
 		return -EPROBE_DEFER;
 	}
 
+	dwc->xhci_resources[0].start = res->start;
+	dwc->xhci_resources[0].end = dwc->xhci_resources[0].start +
+					DWC3_XHCI_REGS_END;
+	dwc->xhci_resources[0].flags = res->flags;
+	dwc->xhci_resources[0].name = res->name;
+
+	res->start += DWC3_GLOBALS_REGS_START;
+
+	/*
+	 * Request memory region but exclude xHCI regs,
+	 * since it will be requested by the xhci-plat driver.
+	 */
+	regs = devm_ioremap_resource(dev, res);
+	if (IS_ERR(regs))
+		return PTR_ERR(regs);
+
 	usb_phy_set_suspend(dwc->usb2_phy, 0);
 	usb_phy_set_suspend(dwc->usb3_phy, 0);
 
-- 
1.7.9.5

