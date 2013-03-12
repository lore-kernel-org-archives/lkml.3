Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755Ab3CLKqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:46:32 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51577 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932519Ab3CLKpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:45:32 -0400
From: Roger Quadros <rogerq@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <stern@rowland.harvard.edu>, <balbi@ti.com>, <b-cousson@ti.com>,
        <mark.rutland@arm.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <rogerq@ti.com>
Subject: [PATCH 11/12] USB: ehci-omap: Try to get PHY even if not in PHY mode
Date: Tue, 12 Mar 2013 12:44:49 +0200
Message-ID: <1363085090-24676-12-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363085090-24676-1-git-send-email-rogerq@ti.com>
References: <1363085090-24676-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even when not in PHY mode, the USB device on the port (e.g. HUB)
might need resources like RESET which can be modelled as a PHY
device. So try to get the PHY device in any case.

Signed-off-by: Roger Quadros <rogerq@ti.com>
CC: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/host/ehci-omap.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index 45cd01e..1ba1df8 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -202,15 +202,16 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 	for (i = 0 ; i < omap->nports ; i++) {
 		struct usb_phy *phy;
 
-		if (pdata->port_mode[i] != OMAP_EHCI_PORT_MODE_PHY)
-			continue;
-
 		/* get the PHY device */
 		if (dev->of_node)
 			phy = devm_usb_get_phy_by_phandle(dev, "phys", i);
 		else
 			phy = devm_usb_get_phy_dev(dev, i);
 		if (IS_ERR(phy) || !phy) {
+			/* Don't bail out if PHY is not absolutely necessary */
+			if (pdata->port_mode[i] != OMAP_EHCI_PORT_MODE_PHY)
+				continue;
+
 			ret = IS_ERR(phy) ? PTR_ERR(phy) : -ENODEV;
 			dev_err(dev, "Can't get PHY device for port %d: %d\n",
 					i, ret);
-- 
1.7.4.1

