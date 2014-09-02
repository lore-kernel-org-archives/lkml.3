Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbaIBLMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 07:12:51 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:52680 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890AbaIBLMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 07:12:47 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        kishon@ti.com, balbi@ti.com, stern@rowland.harvard.edu,
        kgene.kim@samsung.com, heikki.krogerus@linux.intel.com,
        mathias.nyman@intel.com, sergei.shtylyov@cogentembedded.com,
        jg1.han@samsung.com, Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH v6 2/4] usb: host: xhci-plat: Get PHYs for xhci's hcds
Date: Tue,  2 Sep 2014 16:42:16 +0530
Message-Id: <1409656338-20337-3-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409656338-20337-1-git-send-email-gautam.vivek@samsung.com>
References: <1409656338-20337-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The host controller by itself may sometimes need to handle PHY
and/or calibrate some of the PHY settings to get full support out
of the PHY controller. The PHY core provides a calibration
funtionality now to do so.
Therefore, facilitate getting the two possible PHYs, viz.
USB 2.0 type (UTMI+) and USB 3.0 type (PIPE3).

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/host/xhci-plat.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 1a0cf9f..6afd508 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/phy/phy.h>
 #include <linux/slab.h>
 #include <linux/usb/xhci_pdriver.h>
 
@@ -180,6 +181,19 @@ static int xhci_plat_probe(struct platform_device *pdev)
 			goto put_hcd;
 	}
 
+	/* Get possile USB 2.0 type PHY (UTMI+) available with xhci */
+	hcd->gen_phy = devm_phy_get(&pdev->dev, "usb2-phy");
+	if (IS_ERR(hcd->gen_phy)) {
+		ret = PTR_ERR(hcd->gen_phy);
+		if (ret == -EPROBE_DEFER) {
+			return ret;
+		} else if (ret != -ENOSYS && ret != -ENODEV) {
+			hcd->gen_phy = NULL;
+			dev_warn(&pdev->dev,
+				 "Error retrieving usb2 phy: %d\n", ret);
+		}
+	}
+
 	ret = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (ret)
 		goto disable_clk;
@@ -209,6 +223,19 @@ static int xhci_plat_probe(struct platform_device *pdev)
 	if (HCC_MAX_PSA(xhci->hcc_params) >= 4)
 		xhci->shared_hcd->can_do_streams = 1;
 
+	/* Get possile USB 3.0 type PHY (PIPE3) available with xhci */
+	xhci->shared_hcd->gen_phy = devm_phy_get(&pdev->dev, "usb3-phy");
+	if (IS_ERR(xhci->shared_hcd->gen_phy)) {
+		ret = PTR_ERR(xhci->shared_hcd->gen_phy);
+		if (ret == -EPROBE_DEFER) {
+			return ret;
+		} else if (ret != -ENOSYS && ret != -ENODEV) {
+			xhci->shared_hcd->gen_phy = NULL;
+			dev_warn(&pdev->dev,
+				 "Error retrieving usb3 phy: %d\n", ret);
+		}
+	}
+
 	ret = usb_add_hcd(xhci->shared_hcd, irq, IRQF_SHARED);
 	if (ret)
 		goto put_usb3_hcd;
-- 
1.7.10.4

