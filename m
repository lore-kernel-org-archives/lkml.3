Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759089Ab3FCQO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 12:14:29 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36452 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759294Ab3FCQOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 12:14:20 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>, <balbi@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
CC: <kishon@ti.com>, <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <gregkh@linuxfoundation.org>,
        <benoit.cousson@linaro.org>, <anish198519851985@gmail.com>,
        <pmeerw@pmeerw.net>
Subject: [PATCH 4/5] usb: dwc3: omap: improve error handling of dwc3_omap_probe
Date: Mon, 3 Jun 2013 21:43:39 +0530
Message-ID: <1370276020-17446-5-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370276020-17446-1-git-send-email-kishon@ti.com>
References: <1370276020-17446-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improved the error handling of dwc3_omap_probe so that on error
conditions dwc3_omap is left in the original state.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/dwc3/dwc3-omap.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index 34638b9..f8f76e6 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -347,7 +347,7 @@ static int dwc3_omap_probe(struct platform_device *pdev)
 	ret = pm_runtime_get_sync(dev);
 	if (ret < 0) {
 		dev_err(dev, "get_sync failed with err %d\n", ret);
-		return ret;
+		goto err0;
 	}
 
 	reg = dwc3_omap_readl(omap->base, USBOTGSS_UTMI_OTG_STATUS);
@@ -376,7 +376,7 @@ static int dwc3_omap_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_err(dev, "failed to request IRQ #%d --> %d\n",
 				omap->irq, ret);
-		return ret;
+		goto err1;
 	}
 
 	dwc3_omap_enable_irqs(omap);
@@ -384,10 +384,21 @@ static int dwc3_omap_probe(struct platform_device *pdev)
 	ret = of_platform_populate(node, NULL, NULL, dev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to create dwc3 core\n");
-		return ret;
+		goto err2;
 	}
 
 	return 0;
+
+err2:
+	dwc3_omap_disable_irqs(omap);
+
+err1:
+	pm_runtime_put_sync(dev);
+
+err0:
+	pm_runtime_disable(dev);
+
+	return ret;
 }
 
 static int dwc3_omap_remove(struct platform_device *pdev)
-- 
1.7.10.4

