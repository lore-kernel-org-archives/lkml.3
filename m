Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab3CON3H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:29:07 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60971 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab3CON3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:29:04 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <notasas@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH 4/4] usb: otg: twl4030: fix cold plug on OMAP3
Date: Fri, 15 Mar 2013 18:58:52 +0530
Message-ID: <1363354132-27523-4-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363354132-27523-1-git-send-email-kishon@ti.com>
References: <1363354132-27523-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having twl4030_usb_phy_init() (detects if a cable is connected before
twl4030 is probed) in twl4030 probe makes cable connect events to be
missed by musb glue, since it gets loaded after twl4030. Having
twl4030_usb_phy_init as a usb_phy ops lets twl4030_usb_phy_init to be
called when glue is ready.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Tested-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/usb/phy/phy-twl4030-usb.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/phy/phy-twl4030-usb.c b/drivers/usb/phy/phy-twl4030-usb.c
index e14b03e..1986c78 100644
--- a/drivers/usb/phy/phy-twl4030-usb.c
+++ b/drivers/usb/phy/phy-twl4030-usb.c
@@ -510,8 +510,9 @@ static irqreturn_t twl4030_usb_irq(int irq, void *_twl)
 	return IRQ_HANDLED;
 }
 
-static void twl4030_usb_phy_init(struct twl4030_usb *twl)
+static int twl4030_usb_phy_init(struct usb_phy *phy)
 {
+	struct twl4030_usb *twl = phy_to_twl(phy);
 	enum omap_musb_vbus_id_status status;
 
 	status = twl4030_usb_linkstat(twl);
@@ -528,6 +529,7 @@ static void twl4030_usb_phy_init(struct twl4030_usb *twl)
 		omap_musb_mailbox(twl->linkstat);
 	}
 	sysfs_notify(&twl->dev->kobj, NULL, "vbus");
+	return 0;
 }
 
 static int twl4030_set_suspend(struct usb_phy *x, int suspend)
@@ -604,6 +606,7 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 	twl->phy.otg		= otg;
 	twl->phy.type		= USB_PHY_TYPE_USB2;
 	twl->phy.set_suspend	= twl4030_set_suspend;
+	twl->phy.init		= twl4030_usb_phy_init;
 
 	otg->phy		= &twl->phy;
 	otg->set_host		= twl4030_set_host;
@@ -641,11 +644,6 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 		return status;
 	}
 
-	/* Power down phy or make it work according to
-	 * current link state.
-	 */
-	twl4030_usb_phy_init(twl);
-
 	dev_info(&pdev->dev, "Initialized TWL4030 USB module\n");
 	return 0;
 }
-- 
1.7.10.4

