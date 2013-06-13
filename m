Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450Ab3FMIp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 04:45:29 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52107 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932720Ab3FMIpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 04:45:14 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@linaro.org>, <tony@atomide.com>, <balbi@ti.com>,
        <kishon@ti.com>, <arnd@arndb.de>, <swarren@nvidia.com>,
        <sylvester.nawrocki@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <akpm@linux-foundation.org>
CC: <rob.herring@calxeda.com>, <rob@landley.net>, <b-cousson@ti.com>,
        <linux@arm.linux.org.uk>, <benoit.cousson@linaro.org>,
        <mchehab@redhat.com>, <cesarb@cesarb.net>, <davem@davemloft.net>,
        <rnayak@ti.com>, <shawn.guo@linaro.org>, <santosh.shilimkar@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <nsekhar@ti.com>
Subject: [PATCH v7 9/9] usb: phy: twl4030-usb: remove *set_suspend* and *phy_init* ops
Date: Thu, 13 Jun 2013 14:13:59 +0530
Message-ID: <1371113039-5784-10-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1371113039-5784-1-git-send-email-kishon@ti.com>
References: <1371113039-5784-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that twl4030-usb is adapted to the new generic PHY framework,
*set_suspend* and *phy_init* ops can be removed from twl4030-usb driver.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/phy/phy-twl4030-usb.c |   55 ++++++++-----------------------------
 1 file changed, 12 insertions(+), 43 deletions(-)

diff --git a/drivers/usb/phy/phy-twl4030-usb.c b/drivers/usb/phy/phy-twl4030-usb.c
index fba9697..5245b86 100644
--- a/drivers/usb/phy/phy-twl4030-usb.c
+++ b/drivers/usb/phy/phy-twl4030-usb.c
@@ -422,25 +422,20 @@ static void twl4030_phy_power(struct twl4030_usb *twl, int on)
 	}
 }
 
-static void twl4030_phy_suspend(struct twl4030_usb *twl, int controller_off)
+static int twl4030_phy_power_off(struct phy *phy)
 {
+	struct twl4030_usb *twl = dev_get_drvdata(&phy->dev);
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
-	struct twl4030_usb *twl = dev_get_drvdata(&phy->dev);
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
+	struct twl4030_usb *twl = dev_get_drvdata(&phy->dev);
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
-	struct twl4030_usb *twl = dev_get_drvdata(&phy->dev);
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
+	struct twl4030_usb *twl = dev_get_drvdata(&phy->dev);
 	enum omap_musb_vbus_id_status status;
 
 	/*
@@ -628,25 +618,6 @@ static int twl4030_usb_phy_init(struct usb_phy *phy)
 	return 0;
 }
 
-static int twl4030_phy_init(struct phy *phy)
-{
-	struct twl4030_usb *twl = dev_get_drvdata(&phy->dev);
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
@@ -717,8 +688,6 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 	twl->phy.label		= "twl4030";
 	twl->phy.otg		= otg;
 	twl->phy.type		= USB_PHY_TYPE_USB2;
-	twl->phy.set_suspend	= twl4030_set_suspend;
-	twl->phy.init		= twl4030_usb_phy_init;
 
 	otg->phy		= &twl->phy;
 	otg->set_host		= twl4030_set_host;
-- 
1.7.10.4

