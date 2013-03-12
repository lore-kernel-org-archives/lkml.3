Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab3CLKpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:45:21 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51549 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755278Ab3CLKpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:45:15 -0400
From: Roger Quadros <rogerq@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <stern@rowland.harvard.edu>, <balbi@ti.com>, <b-cousson@ti.com>,
        <mark.rutland@arm.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <rogerq@ti.com>
Subject: [PATCH 05/12] USB: ehci-omap: Remove PHY regulator handling code
Date: Tue, 12 Mar 2013 12:44:43 +0200
Message-ID: <1363085090-24676-6-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363085090-24676-1-git-send-email-rogerq@ti.com>
References: <1363085090-24676-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PHY regulator handling must be done in the PHY driver

Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/host/ehci-omap.c |   34 ----------------------------------
 1 files changed, 0 insertions(+), 34 deletions(-)

diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index 0bbfdc1..57fe985 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -43,7 +43,6 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/usb/ulpi.h>
-#include <linux/regulator/consumer.h>
 #include <linux/pm_runtime.h>
 #include <linux/gpio.h>
 #include <linux/clk.h>
@@ -112,19 +111,6 @@ static int omap_ehci_init(struct usb_hcd *hcd)
 	return rc;
 }
 
-static void disable_put_regulator(
-		struct usbhs_omap_platform_data *pdata)
-{
-	int i;
-
-	for (i = 0 ; i < OMAP3_HS_USB_PORTS ; i++) {
-		if (pdata->regulator[i]) {
-			regulator_disable(pdata->regulator[i]);
-			regulator_put(pdata->regulator[i]);
-		}
-	}
-}
-
 /* configure so an HC device and id are always provided */
 /* always called with process context; sleeping is OK */
 
@@ -152,7 +138,6 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 	int ret = -ENODEV;
 	int irq;
 	int i;
-	char supply[7];
 	struct omap_hcd	*omap;
 
 	if (usb_disabled())
@@ -213,23 +198,6 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 		usb_phy_set_suspend(omap->phy[i], 0);
 	}
 
-	/* get ehci regulator and enable */
-	for (i = 0 ; i < OMAP3_HS_USB_PORTS ; i++) {
-		if (pdata->port_mode[i] != OMAP_EHCI_PORT_MODE_PHY) {
-			pdata->regulator[i] = NULL;
-			continue;
-		}
-		snprintf(supply, sizeof(supply), "hsusb%d", i);
-		pdata->regulator[i] = regulator_get(dev, supply);
-		if (IS_ERR(pdata->regulator[i])) {
-			pdata->regulator[i] = NULL;
-			dev_dbg(dev,
-			"failed to get ehci port%d regulator\n", i);
-		} else {
-			regulator_enable(pdata->regulator[i]);
-		}
-	}
-
 	pm_runtime_enable(dev);
 	pm_runtime_get_sync(dev);
 
@@ -255,7 +223,6 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 	return 0;
 
 err_pm_runtime:
-	disable_put_regulator(pdata);
 	pm_runtime_put_sync(dev);
 
 err_phy:
@@ -286,7 +253,6 @@ static int ehci_hcd_omap_remove(struct platform_device *pdev)
 	int i;
 
 	usb_remove_hcd(hcd);
-	disable_put_regulator(dev->platform_data);
 
 	for (i = 0; i < omap->nports; i++) {
 		if (omap->phy[i])
-- 
1.7.4.1

