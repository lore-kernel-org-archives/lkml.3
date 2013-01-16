Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530Ab3APOo5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 09:44:57 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:37792 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756441Ab3APOov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 09:44:51 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <sameo@linux.intel.com>, <tony@atomide.com>
CC: <kishon@ti.com>, <sshtylyov@mvista.com>, <bjorn@mork.no>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <rogerq@ti.com>
Subject: [PATCH v6 12/22] mfd: omap-usb-host: know about number of ports from revision register
Date: Wed, 16 Jan 2013 16:43:43 +0200
Message-ID: <1358347433-329-13-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358347433-329-1-git-send-email-rogerq@ti.com>
References: <1358347433-329-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The revision register should tell us how many ports are present.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/mfd/omap-usb-host.c |   33 ++++++++++++++++++++++++++++-----
 1 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 0f190b6..0ab6801 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -91,6 +91,8 @@
 
 
 struct usbhs_hcd_omap {
+	int				nports;
+
 	struct clk			*xclk60mhsp1_ck;
 	struct clk			*xclk60mhsp2_ck;
 	struct clk			*utmi_p1_fck;
@@ -347,8 +349,6 @@ static void omap_usbhs_init(struct device *dev)
 
 	pm_runtime_get_sync(dev);
 	spin_lock_irqsave(&omap->lock, flags);
-	omap->usbhs_rev = usbhs_read(omap->uhh_base, OMAP_UHH_REVISION);
-	dev_dbg(dev, "OMAP UHH_REVISION 0x%x\n", omap->usbhs_rev);
 
 	reg = usbhs_read(omap->uhh_base, OMAP_UHH_HOSTCONFIG);
 	/* setup ULPI bypass and burst configurations */
@@ -483,7 +483,32 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 
 	pm_runtime_enable(dev);
 
-	for (i = 0; i < OMAP3_HS_USB_PORTS; i++)
+	platform_set_drvdata(pdev, omap);
+	pm_runtime_get_sync(dev);
+
+	omap->usbhs_rev = usbhs_read(omap->uhh_base, OMAP_UHH_REVISION);
+
+	/* we need to call runtime suspend before we update omap->nports
+	 * to prevent unbalanced clk_disable()
+	 */
+	pm_runtime_put_sync(dev);
+
+	switch (omap->usbhs_rev) {
+	case OMAP_USBHS_REV1:
+		omap->nports = 3;
+		break;
+	case OMAP_USBHS_REV2:
+		omap->nports = 2;
+		break;
+	default:
+		omap->nports = OMAP3_HS_USB_PORTS;
+		dev_dbg(dev,
+		  "USB HOST Rev : 0x%d not recognized, assuming %d ports\n",
+		   omap->usbhs_rev, omap->nports);
+		break;
+	}
+
+	for (i = 0; i < omap->nports; i++)
 		if (is_ehci_phy_mode(i) || is_ehci_tll_mode(i) ||
 			is_ehci_hsic_mode(i)) {
 			omap->ehci_logic_fck = clk_get(dev, "ehci_logic_fck");
@@ -573,8 +598,6 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 				"failed error:%d\n", ret);
 	}
 
-	platform_set_drvdata(pdev, omap);
-
 	omap_usbhs_init(dev);
 	ret = omap_usbhs_alloc_children(pdev);
 	if (ret) {
-- 
1.7.4.1

