Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab3AYDDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 22:03:23 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:35392 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755909Ab3AYDBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 22:01:11 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <rob.herring@calxeda.com>, <rob@landley.net>, <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
CC: <grant.likely@secretlab.ca>, <gregkh@linuxfoundation.org>, <kishon@ti.com>
Subject: [PATCH v3 08/11] usb: dwc3-omap: stop using nop-usb-xceiv
Date: Fri, 25 Jan 2013 08:30:52 +0530
Message-ID: <1359082855-7404-9-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359082855-7404-1-git-send-email-kishon@ti.com>
References: <1359082855-7404-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have drivers for omap-usb2 phy and omap-usb3 phy, stop
using nop-usb-xceiv.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/dwc3/dwc3-omap.c |   67 ------------------------------------------
 1 file changed, 67 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index 4e96fbe..0c62e28 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -52,7 +52,6 @@
 #include <linux/of_platform.h>
 
 #include <linux/usb/otg.h>
-#include <linux/usb/nop-usb-xceiv.h>
 
 #include "core.h"
 
@@ -119,8 +118,6 @@ struct dwc3_omap {
 	/* device lock */
 	spinlock_t		lock;
 
-	struct platform_device	*usb2_phy;
-	struct platform_device	*usb3_phy;
 	struct device		*dev;
 
 	int			irq;
@@ -195,60 +192,6 @@ void dwc3_omap_mailbox(enum omap_dwc3_vbus_id_status status)
 }
 EXPORT_SYMBOL_GPL(dwc3_omap_mailbox);
 
-static int dwc3_omap_register_phys(struct dwc3_omap *omap)
-{
-	struct nop_usb_xceiv_platform_data pdata;
-	struct platform_device	*pdev;
-	int			ret;
-
-	memset(&pdata, 0x00, sizeof(pdata));
-
-	pdev = platform_device_alloc("nop_usb_xceiv", 0);
-	if (!pdev)
-		return -ENOMEM;
-
-	omap->usb2_phy = pdev;
-	pdata.type = USB_PHY_TYPE_USB2;
-
-	ret = platform_device_add_data(omap->usb2_phy, &pdata, sizeof(pdata));
-	if (ret)
-		goto err1;
-
-	pdev = platform_device_alloc("nop_usb_xceiv", 1);
-	if (!pdev) {
-		ret = -ENOMEM;
-		goto err1;
-	}
-
-	omap->usb3_phy = pdev;
-	pdata.type = USB_PHY_TYPE_USB3;
-
-	ret = platform_device_add_data(omap->usb3_phy, &pdata, sizeof(pdata));
-	if (ret)
-		goto err2;
-
-	ret = platform_device_add(omap->usb2_phy);
-	if (ret)
-		goto err2;
-
-	ret = platform_device_add(omap->usb3_phy);
-	if (ret)
-		goto err3;
-
-	return 0;
-
-err3:
-	platform_device_del(omap->usb2_phy);
-
-err2:
-	platform_device_put(omap->usb3_phy);
-
-err1:
-	platform_device_put(omap->usb2_phy);
-
-	return ret;
-}
-
 static irqreturn_t dwc3_omap_interrupt(int irq, void *_omap)
 {
 	struct dwc3_omap	*omap = _omap;
@@ -358,12 +301,6 @@ static int dwc3_omap_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	ret = dwc3_omap_register_phys(omap);
-	if (ret) {
-		dev_err(dev, "couldn't register PHYs\n");
-		return ret;
-	}
-
 	context = devm_kzalloc(dev, resource_size(res), GFP_KERNEL);
 	if (!context) {
 		dev_err(dev, "couldn't allocate dwc3 context memory\n");
@@ -447,10 +384,6 @@ static int dwc3_omap_probe(struct platform_device *pdev)
 
 static int dwc3_omap_remove(struct platform_device *pdev)
 {
-	struct dwc3_omap	*omap = platform_get_drvdata(pdev);
-
-	platform_device_unregister(omap->usb2_phy);
-	platform_device_unregister(omap->usb3_phy);
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	device_for_each_child(&pdev->dev, NULL, dwc3_omap_remove_core);
-- 
1.7.9.5

