Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358Ab3HUFsG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 01:48:06 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53429 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332Ab3HUFsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 01:48:01 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <kyungmin.park@samsung.com>, <balbi@ti.com>,
        <kishon@ti.com>, <jg1.han@samsung.com>, <s.nawrocki@samsung.com>,
        <kgene.kim@samsung.com>, <stern@rowland.harvard.edu>,
        <broonie@kernel.org>, <tomasz.figa@gmail.com>, <arnd@arndb.de>
CC: <grant.likely@linaro.org>, <tony@atomide.com>, <swarren@nvidia.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <akpm@linux-foundation.org>,
        <balajitk@ti.com>, <george.cherian@ti.com>, <nsekhar@ti.com>,
        <linux@arm.linux.org.uk>
Subject: [PATCH v11 8/8] usb: phy: twl4030-usb: remove *set_suspend* and *phy_init* ops
Date: Wed, 21 Aug 2013 11:16:13 +0530
Message-ID: <1377063973-22044-9-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1377063973-22044-1-git-send-email-kishon@ti.com>
References: <1377063973-22044-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that twl4030-usb is adapted to the new generic PHY framework,
*set_suspend* and *phy_init* ops can be removed from twl4030-usb driver.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/phy/phy-twl4030-usb.c |   57 ++++++++++-------------------------------
 1 file changed, 13 insertions(+), 44 deletions(-)

diff --git a/drivers/phy/phy-twl4030-usb.c b/drivers/phy/phy-twl4030-usb.c
index 494f107..c437211 100644
--- a/drivers/phy/phy-twl4030-usb.c
+++ b/drivers/phy/phy-twl4030-usb.c
@@ -422,25 +422,20 @@ static void twl4030_phy_power(struct twl4030_usb *twl, int on)
 	}
 }
 
-static void twl4030_phy_suspend(struct twl4030_usb *twl, int controller_off)
+static int twl4030_phy_power_off(struct phy *phy)
 {
+	struct twl4030_usb *twl = phy_get_drvdata(phy);
+
 	if (twl->asleep)
-		return;
+		return 0;
 
 	twl4030_phy_power(twl, 0);
 	twl->asleep = 1;
 	dev_dbg(twl->dev, "%s\n", __func__);
-}
-
-static int twl4030_phy_power_off(struct phy *phy)
-{
-	struct twl4030_usb *twl = phy_get_drvdata(phy);
-
-	twl4030_phy_suspend(twl, 0);
 	return 0;
 }
 
-static void __twl4030_phy_resume(struct twl4030_usb *twl)
+static void __twl4030_phy_power_on(struct twl4030_usb *twl)
 {
 	twl4030_phy_power(twl, 1);
 	twl4030_i2c_access(twl, 1);
@@ -449,11 +444,13 @@ static void __twl4030_phy_resume(struct twl4030_usb *twl)
 		twl4030_i2c_access(twl, 0);
 }
 
-static void twl4030_phy_resume(struct twl4030_usb *twl)
+static int twl4030_phy_power_on(struct phy *phy)
 {
+	struct twl4030_usb *twl = phy_get_drvdata(phy);
+
 	if (!twl->asleep)
-		return;
-	__twl4030_phy_resume(twl);
+		return 0;
+	__twl4030_phy_power_on(twl);
 	twl->asleep = 0;
 	dev_dbg(twl->dev, "%s\n", __func__);
 
@@ -466,13 +463,6 @@ static void twl4030_phy_resume(struct twl4030_usb *twl)
 		cancel_delayed_work(&twl->id_workaround_work);
 		schedule_delayed_work(&twl->id_workaround_work, HZ);
 	}
-}
-
-static int twl4030_phy_power_on(struct phy *phy)
-{
-	struct twl4030_usb *twl = phy_get_drvdata(phy);
-
-	twl4030_phy_resume(twl);
 	return 0;
 }
 
@@ -604,9 +594,9 @@ static void twl4030_id_workaround_work(struct work_struct *work)
 	}
 }
 
-static int twl4030_usb_phy_init(struct usb_phy *phy)
+static int twl4030_phy_init(struct phy *phy)
 {
-	struct twl4030_usb *twl = phy_to_twl(phy);
+	struct twl4030_usb *twl = phy_get_drvdata(phy);
 	enum omap_musb_vbus_id_status status;
 
 	/*
@@ -621,32 +611,13 @@ static int twl4030_usb_phy_init(struct usb_phy *phy)
 
 	if (status == OMAP_MUSB_ID_GROUND || status == OMAP_MUSB_VBUS_VALID) {
 		omap_musb_mailbox(twl->linkstat);
-		twl4030_phy_resume(twl);
+		twl4030_phy_power_on(phy);
 	}
 
 	sysfs_notify(&twl->dev->kobj, NULL, "vbus");
 	return 0;
 }
 
-static int twl4030_phy_init(struct phy *phy)
-{
-	struct twl4030_usb *twl = phy_get_drvdata(phy);
-
-	return twl4030_usb_phy_init(&twl->phy);
-}
-
-static int twl4030_set_suspend(struct usb_phy *x, int suspend)
-{
-	struct twl4030_usb *twl = phy_to_twl(x);
-
-	if (suspend)
-		twl4030_phy_suspend(twl, 1);
-	else
-		twl4030_phy_resume(twl);
-
-	return 0;
-}
-
 static int twl4030_set_peripheral(struct usb_otg *otg,
 					struct usb_gadget *gadget)
 {
@@ -719,8 +690,6 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 	twl->phy.label		= "twl4030";
 	twl->phy.otg		= otg;
 	twl->phy.type		= USB_PHY_TYPE_USB2;
-	twl->phy.set_suspend	= twl4030_set_suspend;
-	twl->phy.init		= twl4030_usb_phy_init;
 
 	otg->phy		= &twl->phy;
 	otg->set_host		= twl4030_set_host;
-- 
1.7.10.4

