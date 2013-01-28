Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162Ab3A1LbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:31:14 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:42757 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932088Ab3A1LbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:31:11 -0500
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <linux@arm.linux.org.uk>, <sameo@linux.intel.com>, <balbi@ti.com>,
        <stern@rowland.harvard.edu>, <gregkh@linuxfoundation.org>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v2 10/30] USB: ehci-omap: Use PHY APIs to get the PHY device and put it out of suspend
Date: Mon, 28 Jan 2013 13:30:11 +0200
Message-ID: <1359372631-8180-11-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359372631-8180-1-git-send-email-rogerq@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For each port that is in PHY mode we obtain a PHY device using the USB PHY
library and put it out of suspend.

It is upto platform code to associate the PHY to the controller's
port and it is upto the PHY driver to manage the PHY's resources.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/usb/host/ehci-omap.c |   54 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index fd2f5450..a35e44e 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -70,6 +70,11 @@ static const char hcd_name[] = "ehci-omap";
 
 /*-------------------------------------------------------------------------*/
 
+struct omap_hcd {
+	struct usb_hcd *hcd;
+	struct usb_phy **phy;	/* one PHY for each port */
+	int nports;
+};
 
 static inline void ehci_write(void __iomem *base, u32 reg, u32 val)
 {
@@ -179,6 +184,7 @@ static struct hc_driver __read_mostly ehci_omap_hc_driver;
 
 static const struct ehci_driver_overrides ehci_omap_overrides __initdata = {
 	.reset =		omap_ehci_init,
+	.extra_priv_size =	sizeof(struct omap_hcd),
 };
 
 /**
@@ -194,6 +200,7 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 	struct usbhs_omap_platform_data		*pdata = dev->platform_data;
 	struct resource				*res;
 	struct usb_hcd				*hcd;
+	struct omap_hcd				*omap;
 	void __iomem				*regs;
 	int					ret = -ENODEV;
 	int					irq;
@@ -233,6 +240,39 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 	hcd->rsrc_len = resource_size(res);
 	hcd->regs = regs;
 
+	omap = (struct omap_hcd *)hcd_to_ehci(hcd)->priv;
+	omap->nports = pdata->nports;
+	i = sizeof(struct usb_phy *) * omap->nports;
+	omap->phy = devm_kzalloc(&pdev->dev, i, GFP_KERNEL);
+	if (!omap->phy) {
+		dev_err(dev, "Memory allocation failed\n");
+		return -ENOMEM;
+	}
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
@@ -277,6 +317,13 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
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
@@ -295,11 +342,18 @@ static int ehci_hcd_omap_remove(struct platform_device *pdev)
 {
 	struct device *dev				= &pdev->dev;
 	struct usb_hcd *hcd				= dev_get_drvdata(dev);
+	struct omap_hcd *omap = (struct omap_hcd *)hcd_to_ehci(hcd)->priv;
+	int i;
 
 	usb_remove_hcd(hcd);
 	disable_put_regulator(dev->platform_data);
 	usb_put_hcd(hcd);
 
+	for (i = 0; i < omap->nports; i++) {
+		if (omap->phy[i])
+			usb_phy_shutdown(omap->phy[i]);
+	}
+
 	pm_runtime_put_sync(dev);
 	pm_runtime_disable(dev);
 
-- 
1.7.4.1

