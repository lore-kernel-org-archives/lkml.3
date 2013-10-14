Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324Ab3JNMnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 08:43:46 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52884 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008Ab3JNMno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 08:43:44 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC: <tony@atomide.com>, <balbi@ti.com>, <kishon@ti.com>, <rob@landley.net>,
        <ijc+devicetree@hellion.org.uk>, <swarren@wwwdotorg.org>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>,
        <rob.herring@calxeda.com>, George Cherian <george.cherian@ti.com>
Subject: [PATCH] phy: omap: Adapt phy-omap-usb2 for AM437x
Date: Mon, 14 Oct 2013 18:13:23 +0530
Message-ID: <1381754603-11581-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a compatible for AM437x "ti,am43xx-usb2" to
reuse the same phy-omap-usb2 driver.

Also updated the documentation to add the new compatible.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 Documentation/devicetree/bindings/usb/usb-phy.txt |  2 +-
 drivers/phy/phy-omap-usb2.c                       | 13 ++++++++++---
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/usb-phy.txt b/Documentation/devicetree/bindings/usb/usb-phy.txt
index c0245c8..d5a7f21 100644
--- a/Documentation/devicetree/bindings/usb/usb-phy.txt
+++ b/Documentation/devicetree/bindings/usb/usb-phy.txt
@@ -3,7 +3,7 @@ USB PHY
 OMAP USB2 PHY
 
 Required properties:
- - compatible: Should be "ti,omap-usb2"
+ - compatible: Should be "ti,omap-usb2" or "ti,am437x-usb2"
  - reg : Address and length of the register set for the device.
  - #phy-cells: determine the number of cells that should be given in the
    phandle while referencing this phy.
diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
index bfc5c33..0529c83 100644
--- a/drivers/phy/phy-omap-usb2.c
+++ b/drivers/phy/phy-omap-usb2.c
@@ -29,6 +29,7 @@
 #include <linux/delay.h>
 #include <linux/usb/omap_control_usb.h>
 #include <linux/phy/phy.h>
+#include <linux/of.h>
 #include <linux/of_platform.h>
 
 /**
@@ -172,7 +173,10 @@ static int omap_usb2_probe(struct platform_device *pdev)
 	phy->dev		= &pdev->dev;
 
 	phy->phy.dev		= phy->dev;
-	phy->phy.label		= "omap-usb2";
+	if (of_device_is_compatible(node, "ti,am437x-usb2"))
+		phy->phy.label		= "am437x-usb2";
+	else
+		phy->phy.label		= "omap-usb2";
 	phy->phy.set_suspend	= omap_usb2_suspend;
 	phy->phy.otg		= otg;
 	phy->phy.type		= USB_PHY_TYPE_USB2;
@@ -201,8 +205,10 @@ static int omap_usb2_probe(struct platform_device *pdev)
 
 	otg->set_host		= omap_usb_set_host;
 	otg->set_peripheral	= omap_usb_set_peripheral;
-	otg->set_vbus		= omap_usb_set_vbus;
-	otg->start_srp		= omap_usb_start_srp;
+	if (of_device_is_compatible(node, "ti,omap-usb2")) {
+		otg->set_vbus		= omap_usb_set_vbus;
+		otg->start_srp		= omap_usb_start_srp;
+	}
 	otg->phy		= &phy->phy;
 
 	platform_set_drvdata(pdev, phy);
@@ -300,6 +306,7 @@ static const struct dev_pm_ops omap_usb2_pm_ops = {
 #ifdef CONFIG_OF
 static const struct of_device_id omap_usb2_id_table[] = {
 	{ .compatible = "ti,omap-usb2" },
+	{ .compatible = "ti,am437x-usb2" },
 	{}
 };
 MODULE_DEVICE_TABLE(of, omap_usb2_id_table);
-- 
1.8.1

