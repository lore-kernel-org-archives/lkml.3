Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966014Ab3GSFqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:46:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39662 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965561Ab3GSF00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:26:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, Roger Quadros <rogerq@ti.com>
Subject: [ 14/72] USB: ehci-omap: Tweak PHY initialization sequence
Date: Thu, 18 Jul 2013 22:25:31 -0700
Message-Id: <20130719052600.831901685@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052559.852627424@linuxfoundation.org>
References: <20130719052559.852627424@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Quadros <rogerq@ti.com>

commit 4e5c9e6fa2d232a0686d5fe45cd1508484048936 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/ehci-omap.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -187,6 +187,12 @@ static int ehci_hcd_omap_probe(struct pl
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
@@ -211,13 +217,14 @@ static int ehci_hcd_omap_probe(struct pl
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


