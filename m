Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab3AWKkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:40:36 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:41982 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521Ab3AWKjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:39:17 -0500
From: Roger Quadros <rogerq@ti.com>
To: <sameo@linux.intel.com>
CC: <balbi@ti.com>, <tony@atomide.com>, <kishon@ti.com>,
        <sshtylyov@mvista.com>, <bjorn@mork.no>, <linux@arm.linux.org.uk>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <rogerq@ti.com>
Subject: [PATCH v9 17/20] mfd: omap-usb-host: Get rid of unnecessary spinlock
Date: Wed, 23 Jan 2013 12:38:09 +0200
Message-ID: <1358937492-8129-18-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358937492-8129-1-git-send-email-rogerq@ti.com>
References: <1358937492-8129-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver does not have an interrupt handler and
we don't really need a spinlock, so get rid of it.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/omap-usb-host.c |   16 ----------------
 1 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index bdfc8b7..0740c68 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -23,7 +23,6 @@
 #include <linux/delay.h>
 #include <linux/clk.h>
 #include <linux/dma-mapping.h>
-#include <linux/spinlock.h>
 #include <linux/gpio.h>
 #include <linux/platform_device.h>
 #include <linux/platform_data/usb-omap.h>
@@ -108,7 +107,6 @@ struct usbhs_hcd_omap {
 	struct usbhs_omap_platform_data	*pdata;
 
 	u32				usbhs_rev;
-	spinlock_t			lock;
 };
 /*-------------------------------------------------------------------------*/
 
@@ -276,13 +274,11 @@ static int usbhs_runtime_resume(struct device *dev)
 {
 	struct usbhs_hcd_omap		*omap = dev_get_drvdata(dev);
 	struct usbhs_omap_platform_data	*pdata = omap->pdata;
-	unsigned long			flags;
 	int i, r;
 
 	dev_dbg(dev, "usbhs_runtime_resume\n");
 
 	omap_tll_enable();
-	spin_lock_irqsave(&omap->lock, flags);
 
 	if (!IS_ERR(omap->ehci_logic_fck))
 		clk_enable(omap->ehci_logic_fck);
@@ -324,8 +320,6 @@ static int usbhs_runtime_resume(struct device *dev)
 		}
 	}
 
-	spin_unlock_irqrestore(&omap->lock, flags);
-
 	return 0;
 }
 
@@ -333,13 +327,10 @@ static int usbhs_runtime_suspend(struct device *dev)
 {
 	struct usbhs_hcd_omap		*omap = dev_get_drvdata(dev);
 	struct usbhs_omap_platform_data	*pdata = omap->pdata;
-	unsigned long			flags;
 	int i;
 
 	dev_dbg(dev, "usbhs_runtime_suspend\n");
 
-	spin_lock_irqsave(&omap->lock, flags);
-
 	for (i = 0; i < omap->nports; i++) {
 		switch (pdata->port_mode[i]) {
 		case OMAP_EHCI_PORT_MODE_HSIC:
@@ -362,7 +353,6 @@ static int usbhs_runtime_suspend(struct device *dev)
 	if (!IS_ERR(omap->ehci_logic_fck))
 		clk_disable(omap->ehci_logic_fck);
 
-	spin_unlock_irqrestore(&omap->lock, flags);
 	omap_tll_disable();
 
 	return 0;
@@ -372,7 +362,6 @@ static void omap_usbhs_init(struct device *dev)
 {
 	struct usbhs_hcd_omap		*omap = dev_get_drvdata(dev);
 	struct usbhs_omap_platform_data	*pdata = omap->pdata;
-	unsigned long			flags;
 	unsigned			reg;
 
 	dev_dbg(dev, "starting TI HSUSB Controller\n");
@@ -391,7 +380,6 @@ static void omap_usbhs_init(struct device *dev)
 	}
 
 	pm_runtime_get_sync(dev);
-	spin_lock_irqsave(&omap->lock, flags);
 
 	reg = usbhs_read(omap->uhh_base, OMAP_UHH_HOSTCONFIG);
 	/* setup ULPI bypass and burst configurations */
@@ -454,8 +442,6 @@ static void omap_usbhs_init(struct device *dev)
 	usbhs_write(omap->uhh_base, OMAP_UHH_HOSTCONFIG, reg);
 	dev_dbg(dev, "UHH setup done, uhh_hostconfig=%x\n", reg);
 
-	spin_unlock_irqrestore(&omap->lock, flags);
-
 	pm_runtime_put_sync(dev);
 	if (pdata->phy_reset) {
 		/* Hold the PHY in RESET for enough time till
@@ -521,8 +507,6 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 		return -EADDRNOTAVAIL;
 	}
 
-	spin_lock_init(&omap->lock);
-
 	omap->pdata = pdata;
 
 	pm_runtime_enable(dev);
-- 
1.7.4.1

