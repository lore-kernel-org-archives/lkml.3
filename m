Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbaCCLlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 06:41:15 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:51467 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601AbaCCLjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 06:39:42 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <bcousson@baylibre.com>, <balbi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <george.cherian@ti.com>,
        <heikki.krogerus@linux.intel.com>, <rogerq@ti.com>
CC: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <rob@landley.net>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <kishon@ti.com>, <gregkh@linuxfoundation.org>,
        <grant.likely@linaro.org>, <s.nawrocki@samsung.com>,
        <galak@codeaurora.org>
Subject: [PATCH v5 4/6] usb: phy: omap-usb2: remove *set_suspend* callback from omap-usb2
Date: Mon, 3 Mar 2014 17:08:13 +0530
Message-ID: <1393846695-14644-5-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393846695-14644-1-git-send-email-kishon@ti.com>
References: <1393846695-14644-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that omap-usb2 is adapted to the new generic PHY framework,
*set_suspend* ops can be removed from omap-usb2 driver.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/phy/phy-omap-usb2.c |   25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
index 7699752..705af5a 100644
--- a/drivers/phy/phy-omap-usb2.c
+++ b/drivers/phy/phy-omap-usb2.c
@@ -98,28 +98,6 @@ static int omap_usb_set_peripheral(struct usb_otg *otg,
 	return 0;
 }
 
-static int omap_usb2_suspend(struct usb_phy *x, int suspend)
-{
-	struct omap_usb *phy = phy_to_omapusb(x);
-	int ret;
-
-	if (suspend && !phy->is_suspended) {
-		omap_control_usb_phy_power(phy->control_dev, 0);
-		pm_runtime_put_sync(phy->dev);
-		phy->is_suspended = 1;
-	} else if (!suspend && phy->is_suspended) {
-		ret = pm_runtime_get_sync(phy->dev);
-		if (ret < 0) {
-			dev_err(phy->dev, "get_sync failed with err %d\n", ret);
-			return ret;
-		}
-		omap_control_usb_phy_power(phy->control_dev, 1);
-		phy->is_suspended = 0;
-	}
-
-	return 0;
-}
-
 static int omap_usb_power_off(struct phy *x)
 {
 	struct omap_usb *phy = phy_get_drvdata(x);
@@ -173,7 +151,6 @@ static int omap_usb2_probe(struct platform_device *pdev)
 
 	phy->phy.dev		= phy->dev;
 	phy->phy.label		= "omap-usb2";
-	phy->phy.set_suspend	= omap_usb2_suspend;
 	phy->phy.otg		= otg;
 	phy->phy.type		= USB_PHY_TYPE_USB2;
 
@@ -190,8 +167,6 @@ static int omap_usb2_probe(struct platform_device *pdev)
 	}
 
 	phy->control_dev = &control_pdev->dev;
-
-	phy->is_suspended	= 1;
 	omap_control_usb_phy_power(phy->control_dev, 0);
 
 	otg->set_host		= omap_usb_set_host;
-- 
1.7.9.5

