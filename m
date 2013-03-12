Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665Ab3CLKsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:48:41 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50380 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332Ab3CLKpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:45:11 -0400
From: Roger Quadros <rogerq@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <stern@rowland.harvard.edu>, <balbi@ti.com>, <b-cousson@ti.com>,
        <mark.rutland@arm.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <rogerq@ti.com>
Subject: [PATCH 03/12] USB: ehci-omap: Use PHY APIs to get the PHY device and put it out of suspend
Date: Tue, 12 Mar 2013 12:44:41 +0200
Message-ID: <1363085090-24676-4-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363085090-24676-1-git-send-email-rogerq@ti.com>
References: <1363085090-24676-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For each port that is in PHY mode we obtain a PHY device using the USB PHY
library and put it out of suspend.

It is up to platform code to associate the PHY to the controller's
port and it is up to the PHY driver to manage the PHY's resources.

Also remove weird spacing around declarations we come across.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/host/ehci-omap.c |   76 ++++++++++++++++++++++++++++++++++--------
 1 files changed, 62 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index 70e8e6f..6b8b7e5 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -4,10 +4,11 @@
  * Bus Glue for the EHCI controllers in OMAP3/4
  * Tested on several OMAP3 boards, and OMAP4 Pandaboard
  *
- * Copyright (C) 2007-2011 Texas Instruments, Inc.
+ * Copyright (C) 2007-2013 Texas Instruments, Inc.
  *	Author: Vikram Pandita <vikram.pandita@ti.com>
  *	Author: Anand Gadiyar <gadiyar@ti.com>
  *	Author: Keshava Munegowda <keshava_mgowda@ti.com>
+ *	Author: Roger Quadros <rogerq@ti.com>
  *
  * Copyright (C) 2009 Nokia Corporation
  *	Contact: Felipe Balbi <felipe.balbi@nokia.com>
@@ -70,6 +71,10 @@ static const char hcd_name[] = "ehci-omap";
 
 /*-------------------------------------------------------------------------*/
 
+struct omap_hcd {
+	struct usb_phy *phy[OMAP3_HS_USB_PORTS]; /* one PHY for each port */
+	int nports;
+};
 
 static inline void ehci_write(void __iomem *base, u32 reg, u32 val)
 {
@@ -178,7 +183,8 @@ static void disable_put_regulator(
 static struct hc_driver __read_mostly ehci_omap_hc_driver;
 
 static const struct ehci_driver_overrides ehci_omap_overrides __initdata = {
-	.reset =		omap_ehci_init,
+	.reset = omap_ehci_init,
+	.extra_priv_size = sizeof(struct omap_hcd),
 };
 
 /**
@@ -190,15 +196,16 @@ static const struct ehci_driver_overrides ehci_omap_overrides __initdata = {
  */
 static int ehci_hcd_omap_probe(struct platform_device *pdev)
 {
-	struct device				*dev = &pdev->dev;
-	struct usbhs_omap_platform_data		*pdata = dev->platform_data;
-	struct resource				*res;
-	struct usb_hcd				*hcd;
-	void __iomem				*regs;
-	int					ret = -ENODEV;
-	int					irq;
-	int					i;
-	char					supply[7];
+	struct device *dev = &pdev->dev;
+	struct usbhs_omap_platform_data *pdata = dev->platform_data;
+	struct resource	*res;
+	struct usb_hcd	*hcd;
+	void __iomem *regs;
+	int ret = -ENODEV;
+	int irq;
+	int i;
+	char supply[7];
+	struct omap_hcd	*omap;
 
 	if (usb_disabled())
 		return -ENODEV;
@@ -231,6 +238,33 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 	hcd->rsrc_len = resource_size(res);
 	hcd->regs = regs;
 
+	omap = (struct omap_hcd *)hcd_to_ehci(hcd)->priv;
+	omap->nports = pdata->nports;
+
+	platform_set_drvdata(pdev, hcd);
+
+	/* get the PHY devices if needed */
+	for (i = 0 ; i < omap->nports ; i++) {
+		struct usb_phy *phy;
+
+		if (pdata->port_mode[i] != OMAP_EHCI_PORT_MODE_PHY)
+			continue;
+
+		/* get the PHY device */
+		phy = devm_usb_get_phy_dev(dev, i);
+		if (IS_ERR(phy) || !phy) {
+			ret = IS_ERR(phy) ? PTR_ERR(phy) : -ENODEV;
+			dev_err(dev, "Can't get PHY device for port %d: %d\n",
+					i, ret);
+			goto err_phy;
+		}
+
+		omap->phy[i] = phy;
+		usb_phy_init(omap->phy[i]);
+		/* bring PHY out of suspend */
+		usb_phy_set_suspend(omap->phy[i], 0);
+	}
+
 	/* get ehci regulator and enable */
 	for (i = 0 ; i < OMAP3_HS_USB_PORTS ; i++) {
 		if (pdata->port_mode[i] != OMAP_EHCI_PORT_MODE_PHY) {
@@ -275,6 +309,13 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 err_pm_runtime:
 	disable_put_regulator(pdata);
 	pm_runtime_put_sync(dev);
+
+err_phy:
+	for (i = 0; i < omap->nports; i++) {
+		if (omap->phy[i])
+			usb_phy_shutdown(omap->phy[i]);
+	}
+
 	usb_put_hcd(hcd);
 
 	return ret;
@@ -291,13 +332,20 @@ err_pm_runtime:
  */
 static int ehci_hcd_omap_remove(struct platform_device *pdev)
 {
-	struct device *dev				= &pdev->dev;
-	struct usb_hcd *hcd				= dev_get_drvdata(dev);
+	struct device *dev = &pdev->dev;
+	struct usb_hcd *hcd = dev_get_drvdata(dev);
+	struct omap_hcd *omap = (struct omap_hcd *)hcd_to_ehci(hcd)->priv;
+	int i;
 
 	usb_remove_hcd(hcd);
 	disable_put_regulator(dev->platform_data);
-	usb_put_hcd(hcd);
 
+	for (i = 0; i < omap->nports; i++) {
+		if (omap->phy[i])
+			usb_phy_shutdown(omap->phy[i]);
+	}
+
+	usb_put_hcd(hcd);
 	pm_runtime_put_sync(dev);
 	pm_runtime_disable(dev);
 
-- 
1.7.4.1

