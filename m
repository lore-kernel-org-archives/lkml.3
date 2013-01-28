Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab3A1LhQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:37:16 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:53254 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab3A1LbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:31:18 -0500
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>
CC: <linux@arm.linux.org.uk>, <sameo@linux.intel.com>, <balbi@ti.com>,
        <stern@rowland.harvard.edu>, <gregkh@linuxfoundation.org>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v2 12/30] usb: ehci-omap: Remove PHY regulator handling code
Date: Mon, 28 Jan 2013 13:30:13 +0200
Message-ID: <1359372631-8180-13-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359372631-8180-1-git-send-email-rogerq@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PHY regulator handling must be done in the PHY driver

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/usb/host/ehci-omap.c |   34 ----------------------------------
 1 files changed, 0 insertions(+), 34 deletions(-)

diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index 3c63619..da3e322 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -42,7 +42,6 @@
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
 
@@ -153,7 +139,6 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 	int					ret = -ENODEV;
 	int					irq;
 	int					i;
-	char					supply[7];
 
 	if (usb_disabled())
 		return -ENODEV;
@@ -221,23 +206,6 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
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
 
@@ -263,7 +231,6 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 	return 0;
 
 err_pm_runtime:
-	disable_put_regulator(pdata);
 	pm_runtime_put_sync(dev);
 
 err_phy:
@@ -294,7 +261,6 @@ static int ehci_hcd_omap_remove(struct platform_device *pdev)
 	int i;
 
 	usb_remove_hcd(hcd);
-	disable_put_regulator(dev->platform_data);
 	usb_put_hcd(hcd);
 
 	for (i = 0; i < omap->nports; i++) {
-- 
1.7.4.1

