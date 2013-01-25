Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab3AYCeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 21:34:21 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:38592 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567Ab3AYCdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 21:33:51 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <tony@atomide.com>, <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <linux@arm.linux.org.uk>, <eballetbo@gmail.com>, <javier@dowhile0.org>,
        <gregkh@linuxfoundation.org>, <kishon@ti.com>
Subject: [PATCH v2 4/6] drivers: usb: musb: omap: make use of the new PHY lib APIs
Date: Fri, 25 Jan 2013 08:03:24 +0530
Message-ID: <1359081206-5602-5-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359081206-5602-1-git-send-email-kishon@ti.com>
References: <1359081206-5602-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New PHY lib APIs like usb_add_phy_dev() and devm_usb_get_phy_dev() are
used in MUSB (OMAP), in order to make use of the binding information
provided in the board file (of OMAP platforms).
All the platforms should be modified similar to this to add and get the
PHY.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/musb/omap2430.c   |    2 +-
 drivers/usb/otg/twl4030-usb.c |    3 ++-
 drivers/usb/phy/omap-usb2.c   |    3 ++-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 88a601b..be6d259 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -345,7 +345,7 @@ static int omap2430_musb_init(struct musb *musb)
 	 * up through ULPI.  TWL4030-family PMICs include one,
 	 * which needs a driver, drivers aren't always needed.
 	 */
-	musb->xceiv = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
+	musb->xceiv = devm_usb_get_phy_dev(dev, 0);
 	if (IS_ERR_OR_NULL(musb->xceiv)) {
 		pr_err("HS USB OTG: no transceiver configured\n");
 		return -ENODEV;
diff --git a/drivers/usb/otg/twl4030-usb.c b/drivers/usb/otg/twl4030-usb.c
index 0a70193..a994715 100644
--- a/drivers/usb/otg/twl4030-usb.c
+++ b/drivers/usb/otg/twl4030-usb.c
@@ -610,6 +610,7 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 	twl->phy.dev		= twl->dev;
 	twl->phy.label		= "twl4030";
 	twl->phy.otg		= otg;
+	twl->phy.type		= USB_PHY_TYPE_USB2;
 	twl->phy.set_suspend	= twl4030_set_suspend;
 
 	otg->phy		= &twl->phy;
@@ -624,7 +625,7 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "ldo init failed\n");
 		return err;
 	}
-	usb_add_phy(&twl->phy, USB_PHY_TYPE_USB2);
+	usb_add_phy_dev(&twl->phy);
 
 	platform_set_drvdata(pdev, twl);
 	if (device_create_file(&pdev->dev, &dev_attr_vbus))
diff --git a/drivers/usb/phy/omap-usb2.c b/drivers/usb/phy/omap-usb2.c
index c2b4c8e..0cd88ac 100644
--- a/drivers/usb/phy/omap-usb2.c
+++ b/drivers/usb/phy/omap-usb2.c
@@ -142,6 +142,7 @@ static int omap_usb2_probe(struct platform_device *pdev)
 	phy->phy.label		= "omap-usb2";
 	phy->phy.set_suspend	= omap_usb2_suspend;
 	phy->phy.otg		= otg;
+	phy->phy.type		= USB_PHY_TYPE_USB2;
 
 	phy->control_dev = omap_get_control_dev();
 	if (IS_ERR(phy->control_dev)) {
@@ -165,7 +166,7 @@ static int omap_usb2_probe(struct platform_device *pdev)
 	}
 	clk_prepare(phy->wkupclk);
 
-	usb_add_phy(&phy->phy, USB_PHY_TYPE_USB2);
+	usb_add_phy_dev(&phy->phy);
 
 	platform_set_drvdata(pdev, phy);
 
-- 
1.7.9.5

