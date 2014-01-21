Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbaAUKMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 05:12:22 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:59911 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754117AbaAUKMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 05:12:20 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <george.cherian@ti.com>, <heikki.krogerus@linux.intel.com>,
        <rogerq@ti.com>, <balbi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>
CC: <kishon@ti.com>
Subject: [PATCH 1/2] usb: dwc3: core: continue probing if usb phy library returns -ENODEV/-ENXIO
Date: Tue, 21 Jan 2014 15:41:38 +0530
Message-ID: <1390299099-14764-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1385373690-12170-1-git-send-email-kishon@ti.com>
References: <1385373690-12170-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since PHYs for dwc3 is optional (not all SoCs that have DWC3 use PHYs),
do not return from probe if the USB PHY library returns -ENODEV as that
indicates the platform does not have PHY.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/dwc3/core.c |   34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index a49217a..e009d4e 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -411,32 +411,26 @@ static int dwc3_probe(struct platform_device *pdev)
 
 	if (IS_ERR(dwc->usb2_phy)) {
 		ret = PTR_ERR(dwc->usb2_phy);
-
-		/*
-		 * if -ENXIO is returned, it means PHY layer wasn't
-		 * enabled, so it makes no sense to return -EPROBE_DEFER
-		 * in that case, since no PHY driver will ever probe.
-		 */
-		if (ret == -ENXIO)
+		if (ret == -ENXIO || ret == -ENODEV) {
+			dwc->usb2_phy = NULL;
+		} else if (ret == -EPROBE_DEFER) {
 			return ret;
-
-		dev_err(dev, "no usb2 phy configured\n");
-		return -EPROBE_DEFER;
+		} else {
+			dev_err(dev, "no usb2 phy configured\n");
+			return ret;
+		}
 	}
 
 	if (IS_ERR(dwc->usb3_phy)) {
 		ret = PTR_ERR(dwc->usb3_phy);
-
-		/*
-		 * if -ENXIO is returned, it means PHY layer wasn't
-		 * enabled, so it makes no sense to return -EPROBE_DEFER
-		 * in that case, since no PHY driver will ever probe.
-		 */
-		if (ret == -ENXIO)
+		if (ret == -ENXIO || ret == -ENODEV) {
+			dwc->usb3_phy = NULL;
+		} else if (ret == -EPROBE_DEFER) {
 			return ret;
-
-		dev_err(dev, "no usb3 phy configured\n");
-		return -EPROBE_DEFER;
+		} else {
+			dev_err(dev, "no usb3 phy configured\n");
+			return ret;
+		}
 	}
 
 	dwc->xhci_resources[0].start = res->start;
-- 
1.7.10.4

