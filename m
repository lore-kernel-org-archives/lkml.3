Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab3HAOHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 10:07:55 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57472 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756278Ab3HAOF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 10:05:26 -0400
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>
CC: <tony@atomide.com>, <kishon@ti.com>, <george.cherian@ti.com>,
        <dmurphy@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 2/7] usb: phy: omap-usb2: Don't use omap_get_control_dev()
Date: Thu, 1 Aug 2013 17:05:10 +0300
Message-ID: <1375365915-21380-3-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1375365915-21380-1-git-send-email-rogerq@ti.com>
References: <1375365915-21380-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

omap_get_control_dev() is being deprecated as it doesn't support
multiple instances. As control device is present only from OMAP4
onwards which supports DT only, we use phandles to get the
reference to the control device.

As we don't support non-DT boot, we just bail out on probe
if device node is not present.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/usb/phy/phy-omap-usb2.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/phy/phy-omap-usb2.c b/drivers/usb/phy/phy-omap-usb2.c
index 376b367..77e0cf4 100644
--- a/drivers/usb/phy/phy-omap-usb2.c
+++ b/drivers/usb/phy/phy-omap-usb2.c
@@ -28,6 +28,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/delay.h>
 #include <linux/usb/omap_control_usb.h>
+#include <linux/of_platform.h>
 
 /**
  * omap_usb2_set_comparator - links the comparator present in the sytem with
@@ -124,6 +125,8 @@ static int omap_usb2_probe(struct platform_device *pdev)
 	struct omap_usb			*phy;
 	struct usb_otg			*otg;
 	struct device_node *node = pdev->dev.of_node;
+	struct device_node *control_node;
+	struct platform_device *control_pdev;
 
 	if (!node)
 		return -ENODEV;
@@ -148,11 +151,18 @@ static int omap_usb2_probe(struct platform_device *pdev)
 	phy->phy.otg		= otg;
 	phy->phy.type		= USB_PHY_TYPE_USB2;
 
-	phy->control_dev = omap_get_control_dev();
-	if (IS_ERR(phy->control_dev)) {
-		dev_dbg(&pdev->dev, "Failed to get control device\n");
+	control_node = of_parse_phandle(node, "ctrl-module", 0);
+	if (!control_node) {
+		dev_err(&pdev->dev, "Failed to get control device phandle\n");
 		return -ENODEV;
 	}
+	control_pdev = of_find_device_by_node(control_node);
+	if (!control_pdev) {
+		dev_err(&pdev->dev, "Failed to get control device\n");
+		return -ENODEV;
+	}
+
+	phy->control_dev = &control_pdev->dev;
 
 	phy->is_suspended	= 1;
 	omap_control_usb_phy_power(phy->control_dev, 0);
-- 
1.7.4.1

