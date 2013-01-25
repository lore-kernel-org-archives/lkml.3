Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416Ab3AYDBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 22:01:18 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:35388 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754179Ab3AYDBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 22:01:10 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <rob.herring@calxeda.com>, <rob@landley.net>, <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
CC: <grant.likely@secretlab.ca>, <gregkh@linuxfoundation.org>, <kishon@ti.com>
Subject: [PATCH v3 01/11] usb: dwc3-omap: use device_for_each_child to handle child removal
Date: Fri, 25 Jan 2013 08:30:45 +0530
Message-ID: <1359082855-7404-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359082855-7404-1-git-send-email-kishon@ti.com>
References: <1359082855-7404-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used device_for_each_child() to handle child device (dwc3 core) removal
during devexit of dwc3 omap. This is in preparation for creating the child
devices from subnode of dwc3 omap glue using of_platform_populate.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/dwc3/dwc3-omap.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index f31867f..1d03a8a 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -262,6 +262,15 @@ static irqreturn_t dwc3_omap_interrupt(int irq, void *_omap)
 	return IRQ_HANDLED;
 }
 
+static int dwc3_omap_remove_core(struct device *dev, void *c)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+
+	platform_device_unregister(pdev);
+
+	return 0;
+}
+
 static int dwc3_omap_probe(struct platform_device *pdev)
 {
 	struct dwc3_omap_data	*pdata = pdev->dev.platform_data;
@@ -425,9 +434,10 @@ static int dwc3_omap_remove(struct platform_device *pdev)
 {
 	struct dwc3_omap	*omap = platform_get_drvdata(pdev);
 
-	platform_device_unregister(omap->dwc3);
 	platform_device_unregister(omap->usb2_phy);
 	platform_device_unregister(omap->usb3_phy);
+	device_for_each_child(&pdev->dev, NULL, dwc3_omap_remove_core);
+
 	return 0;
 }
 
-- 
1.7.9.5

