Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbaDYOHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 10:07:38 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47214 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753864AbaDYOHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 10:07:34 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH v2 02/18] usb: host: xhci-plat: Add clocks support
Date: Fri, 25 Apr 2014 16:07:00 +0200
Message-Id: <1398434836-18908-3-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1398434836-18908-1-git-send-email-gregory.clement@free-electrons.com>
References: <1398434836-18908-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platform (such as the Armada 38x ones) can gate the clock of
their USB controller. This patch add the support for the clock, by
enabling them during probe and disabling them on remove.

As not all platforms have clock support then enabling and disabling
the clocks have been placed in separate functions. Then if the clocks
are not supported we still can use the same calls, and there is no

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 drivers/usb/host/xhci-plat.c | 52 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 50 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index f5351af4b2c5..bb5d563f729c 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -11,6 +11,7 @@
  * version 2 as published by the Free Software Foundation.
  */
 
+#include <linux/clk.h>
 #include <linux/dma-mapping.h>
 #include <linux/module.h>
 #include <linux/of.h>
@@ -85,6 +86,42 @@ static const struct hc_driver xhci_plat_xhci_driver = {
 	.bus_resume =		xhci_bus_resume,
 };
 
+#if defined(CONFIG_HAVE_CLK)
+static int try_enable_clk(struct platform_device *pdev)
+{
+	struct clk *clk = devm_clk_get(&pdev->dev, NULL);
+
+	/* Not all platforms have a clk so it is not an error if the clock
+	   does not exists. */
+	if (!IS_ERR(clk))
+		if (clk_prepare_enable(clk))
+			return  -ENODEV;
+	return 0;
+}
+
+static int try_disable_clk(struct platform_device *pdev)
+{
+	struct clk *clk = devm_clk_get(&pdev->dev, NULL);
+
+	/* Not all platforms have a clk so it is not an error if the clock
+	   does not exists. */
+	if (!IS_ERR(clk))
+		clk_disable_unprepare(clk);
+
+	return 0;
+}
+#else
+static inline int try_enable_clk(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static inline int try_disable_clk(struct platform_device *pdev)
+{
+	return 0;
+}
+#endif
+
 static int xhci_plat_probe(struct platform_device *pdev)
 {
 	const struct hc_driver	*driver;
@@ -107,6 +144,10 @@ static int xhci_plat_probe(struct platform_device *pdev)
 	if (!res)
 		return -ENODEV;
 
+	ret = try_enable_clk(pdev);
+	if (ret)
+		return ret;
+
 	/* Initialize dma_mask and coherent_dma_mask to 32-bits */
 	ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
 	if (ret)
@@ -117,8 +158,10 @@ static int xhci_plat_probe(struct platform_device *pdev)
 		dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
 
 	hcd = usb_create_hcd(driver, &pdev->dev, dev_name(&pdev->dev));
-	if (!hcd)
-		return -ENOMEM;
+	if (!hcd) {
+		ret = -ENOMEM;
+		goto disable_clk;
+	}
 
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
@@ -182,6 +225,9 @@ release_mem_region:
 put_hcd:
 	usb_put_hcd(hcd);
 
+disable_clk:
+	try_disable_clk(pdev);
+
 	return ret;
 }
 
@@ -199,6 +245,8 @@ static int xhci_plat_remove(struct platform_device *dev)
 	usb_put_hcd(hcd);
 	kfree(xhci);
 
+	try_disable_clk(dev);
+
 	return 0;
 }
 
-- 
1.8.1.2

