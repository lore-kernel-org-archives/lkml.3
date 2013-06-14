Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab3FNNwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 09:52:17 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49243 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116Ab3FNNwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 09:52:14 -0400
From: Roger Quadros <rogerq@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <balbi@ti.com>, <stern@rowland.harvard.edu>, <tomi.valkeinen@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH] USB: ehci-omap: Tweak PHY initialization sequence
Date: Fri, 14 Jun 2013 16:52:07 +0300
Message-ID: <1371217927-5719-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For PHY mode, the PHYs must be brought out of reset
before the EHCI controller is started.

This patch fixes the issue where USB devices are not found
on Beagleboard/Beagle-xm if USB has been started previously
by the bootloader. (e.g. by "usb start" command in u-boot)

Tested on Beagleboard, Beagleboard-xm and Pandaboard.

Issue present on 3.10 onwards.

Reported-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Tested-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/usb/host/ehci-omap.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index 16d7150..dda408f 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -187,6 +187,12 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 		}
 
 		omap->phy[i] = phy;
+
+		if (pdata->port_mode[i] == OMAP_EHCI_PORT_MODE_PHY) {
+			usb_phy_init(omap->phy[i]);
+			/* bring PHY out of suspend */
+			usb_phy_set_suspend(omap->phy[i], 0);
+		}
 	}
 
 	pm_runtime_enable(dev);
@@ -211,13 +217,14 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 	}
 
 	/*
-	 * Bring PHYs out of reset.
+	 * Bring PHYs out of reset for non PHY modes.
 	 * Even though HSIC mode is a PHY-less mode, the reset
 	 * line exists between the chips and can be modelled
 	 * as a PHY device for reset control.
 	 */
 	for (i = 0; i < omap->nports; i++) {
-		if (!omap->phy[i])
+		if (!omap->phy[i] ||
+		     pdata->port_mode[i] == OMAP_EHCI_PORT_MODE_PHY)
 			continue;
 
 		usb_phy_init(omap->phy[i]);
-- 
1.7.4.1

