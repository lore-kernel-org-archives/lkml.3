Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbaIXNya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:54:30 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50995 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528AbaIXNrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:47:40 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/22] usb: phy: twl4030-usb: Simplify phy init to use runtime PM
Date: Wed, 24 Sep 2014 19:17:09 +0530
Message-ID: <1411566440-19169-12-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411566440-19169-1-git-send-email-kishon@ti.com>
References: <1411566440-19169-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

We can now let the interrupt and delayed work do all that's
needed with runtime PM.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-twl4030-usb.c |   20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/phy/phy-twl4030-usb.c b/drivers/phy/phy-twl4030-usb.c
index bc28ecc..a292db0 100644
--- a/drivers/phy/phy-twl4030-usb.c
+++ b/drivers/phy/phy-twl4030-usb.c
@@ -471,16 +471,8 @@ static int twl4030_phy_power_on(struct phy *phy)
 	twl4030_usb_set_mode(twl, twl->usb_mode);
 	if (twl->usb_mode == T2_USB_MODE_ULPI)
 		twl4030_i2c_access(twl, 0);
+	schedule_delayed_work(&twl->id_workaround_work, 0);
 
-	/*
-	 * XXX When VBUS gets driven after musb goes to A mode,
-	 * ID_PRES related interrupts no longer arrive, why?
-	 * Register itself is updated fine though, so we must poll.
-	 */
-	if (twl->linkstat == OMAP_MUSB_ID_GROUND) {
-		cancel_delayed_work(&twl->id_workaround_work);
-		schedule_delayed_work(&twl->id_workaround_work, HZ);
-	}
 	return 0;
 }
 
@@ -612,16 +604,9 @@ static void twl4030_id_workaround_work(struct work_struct *work)
 static int twl4030_phy_init(struct phy *phy)
 {
 	struct twl4030_usb *twl = phy_get_drvdata(phy);
-	enum omap_musb_vbus_id_status status;
 
 	pm_runtime_get_sync(twl->dev);
-	status = twl4030_usb_linkstat(twl);
-	twl->linkstat = status;
-
-	if (status == OMAP_MUSB_ID_GROUND || status == OMAP_MUSB_VBUS_VALID)
-		omap_musb_mailbox(twl->linkstat);
-
-	sysfs_notify(&twl->dev->kobj, NULL, "vbus");
+	schedule_delayed_work(&twl->id_workaround_work, 0);
 	pm_runtime_mark_last_busy(twl->dev);
 	pm_runtime_put_autosuspend(twl->dev);
 
@@ -698,6 +683,7 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 	twl->dev		= &pdev->dev;
 	twl->irq		= platform_get_irq(pdev, 0);
 	twl->vbus_supplied	= false;
+	twl->linkstat		= -EINVAL;
 	twl->asleep		= 1;
 	twl->linkstat		= OMAP_MUSB_UNKNOWN;
 
-- 
1.7.9.5

