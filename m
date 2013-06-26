Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab3FZLsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 07:48:53 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39485 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200Ab3FZLsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:48:51 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@linaro.org>, <tony@atomide.com>, <balbi@ti.com>,
        <kishon@ti.com>, <arnd@arndb.de>, <swarren@nvidia.com>,
        <sylvester.nawrocki@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <akpm@linux-foundation.org>
CC: <rob.herring@calxeda.com>, <rob@landley.net>, <linux@arm.linux.org.uk>,
        <benoit.cousson@linaro.org>, <mchehab@redhat.com>, <cesarb@cesarb.net>,
        <davem@davemloft.net>, <rnayak@ti.com>, <shawn.guo@linaro.org>,
        <santosh.shilimkar@ti.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <nsekhar@ti.com>, <balajitk@ti.com>,
        <george.cherian@ti.com>
Subject: [PATCH v9 3/8] usb: phy: twl4030: use the new generic PHY framework
Date: Wed, 26 Jun 2013 17:17:31 +0530
Message-ID: <1372247257-30186-4-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372247257-30186-1-git-send-email-kishon@ti.com>
References: <1372247257-30186-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used the generic PHY framework API to create the PHY. For powering on
and powering off the PHY, power_on and power_off ops are used. Once the
MUSB OMAP glue is adapted to the new framework, the suspend and resume
ops of usb phy library will be removed.

However using the old usb phy library cannot be completely removed
because otg is intertwined with phy and moving to the new
framework completely will break otg. Once we have a separate otg state machine,
we can get rid of the usb phy library.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/usb/phy/phy-twl4030-usb.c |   50 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/phy/phy-twl4030-usb.c b/drivers/usb/phy/phy-twl4030-usb.c
index 8fbe2d9..437ba30 100644
--- a/drivers/usb/phy/phy-twl4030-usb.c
+++ b/drivers/usb/phy/phy-twl4030-usb.c
@@ -33,6 +33,7 @@
 #include <linux/io.h>
 #include <linux/delay.h>
 #include <linux/usb/otg.h>
+#include <linux/phy/phy.h>
 #include <linux/usb/musb-omap.h>
 #include <linux/usb/ulpi.h>
 #include <linux/i2c/twl.h>
@@ -431,6 +432,14 @@ static void twl4030_phy_suspend(struct twl4030_usb *twl, int controller_off)
 	dev_dbg(twl->dev, "%s\n", __func__);
 }
 
+static int twl4030_phy_power_off(struct phy *phy)
+{
+	struct twl4030_usb *twl = phy_get_drvdata(phy);
+
+	twl4030_phy_suspend(twl, 0);
+	return 0;
+}
+
 static void __twl4030_phy_resume(struct twl4030_usb *twl)
 {
 	twl4030_phy_power(twl, 1);
@@ -459,6 +468,14 @@ static void twl4030_phy_resume(struct twl4030_usb *twl)
 	}
 }
 
+static int twl4030_phy_power_on(struct phy *phy)
+{
+	struct twl4030_usb *twl = phy_get_drvdata(phy);
+
+	twl4030_phy_resume(twl);
+	return 0;
+}
+
 static int twl4030_usb_ldo_init(struct twl4030_usb *twl)
 {
 	/* Enable writing to power configuration registers */
@@ -602,13 +619,22 @@ static int twl4030_usb_phy_init(struct usb_phy *phy)
 	status = twl4030_usb_linkstat(twl);
 	twl->linkstat = status;
 
-	if (status == OMAP_MUSB_ID_GROUND || status == OMAP_MUSB_VBUS_VALID)
+	if (status == OMAP_MUSB_ID_GROUND || status == OMAP_MUSB_VBUS_VALID) {
 		omap_musb_mailbox(twl->linkstat);
+		twl4030_phy_resume(twl);
+	}
 
 	sysfs_notify(&twl->dev->kobj, NULL, "vbus");
 	return 0;
 }
 
+static int twl4030_phy_init(struct phy *phy)
+{
+	struct twl4030_usb *twl = phy_get_drvdata(phy);
+
+	return twl4030_usb_phy_init(&twl->phy);
+}
+
 static int twl4030_set_suspend(struct usb_phy *x, int suspend)
 {
 	struct twl4030_usb *twl = phy_to_twl(x);
@@ -646,13 +672,22 @@ static int twl4030_set_host(struct usb_otg *otg, struct usb_bus *host)
 	return 0;
 }
 
+static const struct phy_ops ops = {
+	.init		= twl4030_phy_init,
+	.power_on	= twl4030_phy_power_on,
+	.power_off	= twl4030_phy_power_off,
+	.owner		= THIS_MODULE,
+};
+
 static int twl4030_usb_probe(struct platform_device *pdev)
 {
 	struct twl4030_usb_data *pdata = pdev->dev.platform_data;
 	struct twl4030_usb	*twl;
+	struct phy		*phy;
 	int			status, err;
 	struct usb_otg		*otg;
 	struct device_node	*np = pdev->dev.of_node;
+	struct phy_provider	*phy_provider;
 
 	twl = devm_kzalloc(&pdev->dev, sizeof *twl, GFP_KERNEL);
 	if (!twl)
@@ -689,6 +724,19 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 	otg->set_host		= twl4030_set_host;
 	otg->set_peripheral	= twl4030_set_peripheral;
 
+	phy_provider = devm_of_phy_provider_register(twl->dev,
+		of_phy_simple_xlate);
+	if (IS_ERR(phy_provider))
+		return PTR_ERR(phy_provider);
+
+	phy = devm_phy_create(twl->dev, 0, &ops, "twl4030");
+	if (IS_ERR(phy)) {
+		dev_dbg(&pdev->dev, "Failed to create PHY\n");
+		return PTR_ERR(phy);
+	}
+
+	phy_set_drvdata(phy, twl);
+
 	/* init spinlock for workqueue */
 	spin_lock_init(&twl->lock);
 
-- 
1.7.10.4

