Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab3GJQXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 12:23:36 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33333 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754792Ab3GJQXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 12:23:34 -0400
From: Roger Quadros <rogerq@ti.com>
To: <stern@rowland.harvard.edu>
CC: <gregkh@linuxfoundation.org>, <balbi@ti.com>,
        <sergei.shtylyov@cogentembedded.com>, <khilman@linaro.org>,
        <tony@atomide.com>, <ruslan.bilovol@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Roger Quadros <rogerq@ti.com>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 4/6] mfd: omap-usb-host: Put pins in IDLE state on suspend
Date: Wed, 10 Jul 2013 19:23:00 +0300
Message-ID: <1373473380-27515-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1373473081-27181-1-git-send-email-rogerq@ti.com>
References: <1373473081-27181-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to support wake up from suspend use the pinctrl
framework to put the USB host pins in IDLE state during suspend.

CC: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/mfd/omap-usb-host.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index fb2b3d8..3734d16 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -31,6 +31,7 @@
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/err.h>
+#include <linux/pinctrl/consumer.h>
 
 #include "omap-usb.h"
 
@@ -111,6 +112,7 @@ struct usbhs_hcd_omap {
 	struct usbhs_omap_platform_data	*pdata;
 
 	u32				usbhs_rev;
+	bool				no_idle;
 };
 /*-------------------------------------------------------------------------*/
 
@@ -325,6 +327,7 @@ static int usbhs_runtime_resume(struct device *dev)
 
 	dev_dbg(dev, "usbhs_runtime_resume\n");
 
+	pinctrl_pm_select_default_state(dev);
 	omap_tll_enable(pdata);
 
 	if (!IS_ERR(omap->ehci_logic_fck))
@@ -378,6 +381,12 @@ static int usbhs_runtime_suspend(struct device *dev)
 
 	dev_dbg(dev, "usbhs_runtime_suspend\n");
 
+	if (omap->no_idle) {
+		dev_dbg(dev, "%s: Not suspending as IDLE pins not available\n",
+					__func__);
+		return -EBUSY;
+	}
+
 	for (i = 0; i < omap->nports; i++) {
 		switch (pdata->port_mode[i]) {
 		case OMAP_EHCI_PORT_MODE_HSIC:
@@ -401,6 +410,7 @@ static int usbhs_runtime_suspend(struct device *dev)
 		clk_disable(omap->ehci_logic_fck);
 
 	omap_tll_disable(pdata);
+	pinctrl_pm_select_idle_state(dev);
 
 	return 0;
 }
@@ -608,6 +618,14 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	if (!dev->pins || !dev->pins->idle_state) {
+		/* If IDLE pins are not available, we can't remote wakeup,
+		 * so prevent idling in that case.
+		 */
+		omap->no_idle = true;
+		dev_info(dev, "No IDLE pins so runtime idle disabled\n");
+	}
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	omap->uhh_base = devm_ioremap_resource(dev, res);
 	if (IS_ERR(omap->uhh_base))
@@ -796,6 +814,8 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 		}
 	}
 
+	pinctrl_pm_select_default_state(dev);
+
 	return 0;
 
 err_alloc:
@@ -872,6 +892,8 @@ static int usbhs_omap_remove(struct platform_device *pdev)
 
 	/* remove children */
 	device_for_each_child(&pdev->dev, NULL, usbhs_omap_remove_child);
+	pinctrl_pm_select_idle_state(&pdev->dev);
+
 	return 0;
 }
 
-- 
1.7.4.1

