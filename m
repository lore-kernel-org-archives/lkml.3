Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbaIXNrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:47:45 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38815 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbaIXNrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:47:43 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 13/22] usb: phy: twl4030-usb: Remove asleep and rely on runtime PM
Date: Wed, 24 Sep 2014 19:17:11 +0530
Message-ID: <1411566440-19169-14-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411566440-19169-1-git-send-email-kishon@ti.com>
References: <1411566440-19169-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

There's no longer need for tracking the phy state in the driver
with asleep, we can now rely on runtime PM.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-twl4030-usb.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/phy/phy-twl4030-usb.c b/drivers/phy/phy-twl4030-usb.c
index 519cc90..24ff3c6 100644
--- a/drivers/phy/phy-twl4030-usb.c
+++ b/drivers/phy/phy-twl4030-usb.c
@@ -163,7 +163,6 @@ struct twl4030_usb {
 	int			irq;
 	enum omap_musb_vbus_id_status linkstat;
 	bool			vbus_supplied;
-	u8			asleep;
 
 	struct delayed_work	id_workaround_work;
 };
@@ -388,14 +387,13 @@ static int twl4030_usb_runtime_suspend(struct device *dev)
 	struct twl4030_usb *twl = dev_get_drvdata(dev);
 
 	dev_dbg(twl->dev, "%s\n", __func__);
-	if (twl->asleep)
+	if (pm_runtime_suspended(dev))
 		return 0;
 
 	__twl4030_phy_power(twl, 0);
 	regulator_disable(twl->usb1v5);
 	regulator_disable(twl->usb1v8);
 	regulator_disable(twl->usb3v1);
-	twl->asleep = 1;
 
 	return 0;
 }
@@ -406,7 +404,7 @@ static int twl4030_usb_runtime_resume(struct device *dev)
 	int res;
 
 	dev_dbg(twl->dev, "%s\n", __func__);
-	if (!twl->asleep)
+	if (pm_runtime_active(dev))
 		return 0;
 
 	res = regulator_enable(twl->usb3v1);
@@ -435,7 +433,6 @@ static int twl4030_usb_runtime_resume(struct device *dev)
 			  twl4030_usb_read(twl, PHY_CLK_CTRL) |
 			  (PHY_CLK_CTRL_CLOCKGATING_EN |
 			   PHY_CLK_CTRL_CLK32K_EN));
-	twl->asleep = 0;
 
 	return 0;
 }
@@ -560,10 +557,10 @@ static irqreturn_t twl4030_usb_irq(int irq, void *_twl)
 		 */
 		if ((status == OMAP_MUSB_VBUS_VALID) ||
 		    (status == OMAP_MUSB_ID_GROUND)) {
-			if (twl->asleep)
+			if (pm_runtime_suspended(twl->dev))
 				pm_runtime_get_sync(twl->dev);
 		} else {
-			if (!twl->asleep) {
+			if (pm_runtime_active(twl->dev)) {
 				pm_runtime_mark_last_busy(twl->dev);
 				pm_runtime_put_autosuspend(twl->dev);
 			}
@@ -572,7 +569,7 @@ static irqreturn_t twl4030_usb_irq(int irq, void *_twl)
 	}
 
 	/* don't schedule during sleep - irq works right then */
-	if (status == OMAP_MUSB_ID_GROUND && !twl->asleep) {
+	if (status == OMAP_MUSB_ID_GROUND && pm_runtime_active(twl->dev)) {
 		cancel_delayed_work(&twl->id_workaround_work);
 		schedule_delayed_work(&twl->id_workaround_work, HZ);
 	}
@@ -674,7 +671,6 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 	twl->irq		= platform_get_irq(pdev, 0);
 	twl->vbus_supplied	= false;
 	twl->linkstat		= -EINVAL;
-	twl->asleep		= 1;
 	twl->linkstat		= OMAP_MUSB_UNKNOWN;
 
 	twl->phy.dev		= twl->dev;
-- 
1.7.9.5

