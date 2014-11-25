Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaKYNUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:20:52 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44794 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284AbaKYNPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:15:55 -0500
From: George Cherian <george.cherian@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
CC: <peter.chen@freescale.com>, <sojka@merica.cz>, <mathias.nyman@intel.com>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>, <kgene.kim@samsung.com>,
        <ben-linux@fluff.org>, <linux@arm.linux.org.uk>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH 07/19] usb: host: xhci: Adapt xhci to use usb drd library
Date: Tue, 25 Nov 2014 18:41:43 +0530
Message-ID: <1416921115-10467-8-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1416921115-10467-1-git-send-email-george.cherian@ti.com>
References: <1416921115-10467-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adapt the xhci-plat driver  to use drd library functions.
In prepration to support DRD on dwc3.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/host/xhci-plat.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index d8d024d..fbbbd59 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -17,6 +17,8 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/usb/otg.h>
+#include <linux/usb/drd.h>
 #include <linux/usb/xhci_pdriver.h>
 
 #include "xhci.h"
@@ -78,6 +80,7 @@ static int xhci_plat_probe(struct platform_device *pdev)
 	struct resource         *res;
 	struct usb_hcd		*hcd;
 	struct clk              *clk;
+	struct usb_drd_host	*drd_host;
 	int			ret;
 	int			irq;
 
@@ -169,6 +172,17 @@ static int xhci_plat_probe(struct platform_device *pdev)
 	if (ret)
 		goto put_usb3_hcd;
 
+	drd_host = kzalloc(sizeof(*drd_host), GFP_KERNEL);
+	if (!drd_host)
+		return -ENOMEM;
+
+	drd_host->main_hcd = xhci->main_hcd;
+	drd_host->shared_hcd = xhci->shared_hcd;
+	drd_host->hcd_irq = irq;
+	drd_host->host_setup = NULL;
+
+	usb_drd_register_hcd(pdev->dev.parent, drd_host);
+
 	return 0;
 
 put_usb3_hcd:
@@ -200,6 +214,7 @@ static int xhci_plat_remove(struct platform_device *dev)
 	if (!IS_ERR(clk))
 		clk_disable_unprepare(clk);
 	usb_put_hcd(hcd);
+	usb_drd_unregister_hcd(dev->dev.parent);
 	kfree(xhci);
 
 	return 0;
-- 
1.8.3.1

