Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664AbaFFMMq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 08:12:46 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:47206 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaFFMMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 08:12:43 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        gregkh@linuxfoundation.org, kishon@ti.com, mathias.nyman@intel.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kgene.kim@samsung.com, jwerner@chromium.org,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH 2/4] usb: host: xhci-plat: Add support to get PHYs
Date: Fri,  6 Jun 2014 17:42:13 +0530
Message-Id: <1402056736-12674-3-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402056736-12674-1-git-send-email-gautam.vivek@samsung.com>
References: <1402056736-12674-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The host controller by itself may sometimes need to handle PHY
and/or calibrate some of the PHY settings to get full support out
of the PHY controller.
The PHY core provides a calibration funtionality now to do so.
Therefore, facilitate getting the two possible PHY types for
xhci controller, viz. USB 2.0 type (UTMI+) and USB 3.0 type (PIPE3)
from its parent.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/host/xhci-plat.c |   24 ++++++++++++++++++++++++
 drivers/usb/host/xhci.h      |    3 +++
 2 files changed, 27 insertions(+)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 29d8adb..e7145b5 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -17,6 +17,7 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/phy/phy.h>
 
 #include "xhci.h"
 #include "xhci-mvebu.h"
@@ -183,6 +184,29 @@ static int xhci_plat_probe(struct platform_device *pdev)
 	}
 
 	/*
+	 * Get possile USB 2.0 type PHY (UTMI+), as well as
+	 * USB 3.0 type PHY (PIPE3).
+	 * The host controller may need to handle PHYs by itself too
+	 * sometimes, so as to calibrate it based on the need.
+	 */
+	xhci->phy2_gen = devm_phy_get(&pdev->dev, "usb2-phy");
+	if (IS_ERR(xhci->phy2_gen)) {
+		ret = PTR_ERR(xhci->phy2_gen);
+		if (ret != -ENOSYS && ret != -ENODEV) {
+			dev_err(&pdev->dev, "no usb2 phy configured\n");
+			return ret;
+		}
+	}
+	xhci->phy3_gen = devm_phy_get(&pdev->dev, "usb3-phy");
+	if (IS_ERR(xhci->phy3_gen)) {
+		ret = PTR_ERR(xhci->phy3_gen);
+		if (ret != -ENOSYS && ret != -ENODEV) {
+			dev_err(&pdev->dev, "no usb3 phy configured\n");
+			return ret;
+		}
+	}
+
+	/*
 	 * Set the xHCI pointer before xhci_plat_setup() (aka hcd_driver.reset)
 	 * is called by usb_add_hcd().
 	 */
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 9ffecd5..453d89e 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1582,6 +1582,9 @@ struct xhci_hcd {
 	u32			port_status_u0;
 /* Compliance Mode Timer Triggered every 2 seconds */
 #define COMP_MODE_RCVRY_MSECS 2000
+	/* phys for the controller */
+	struct phy		*phy2_gen;
+	struct phy		*phy3_gen;
 };
 
 /* convert between an HCD pointer and the corresponding EHCI_HCD */
-- 
1.7.10.4

