Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbaEOKWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 06:22:18 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54537 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754853AbaEOKS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 06:18:59 -0400
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
Subject: [PATCH v6 07/17] usb: host: xhci-plat: add clock support
Date: Thu, 15 May 2014 12:17:32 +0200
Message-Id: <1400149062-32661-8-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1400149062-32661-1-git-send-email-gregory.clement@free-electrons.com>
References: <1400149062-32661-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platforms (such as the Armada 38x ones) can gate the clock of
their USB controller. This patch adds the support for one clock in
xhci-plat, by enabling it during probe and disabling it on remove.

To achieve this, it adds a 'struct clk *' member in xhci_hcd. While
only used for now in xhci-plat, it might be used by other drivers in
the future. Moreover, the xhci_hcd structure already holds other
members such as msix_count and msix_entries, which are MSI-X specific,
and therefore only used by xhci-pci.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Acked-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-plat.c | 24 +++++++++++++++++++++++-
 drivers/usb/host/xhci.h      |  2 ++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index f5351af4b2c5..8108e58c9e02 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -11,6 +11,7 @@
  * version 2 as published by the Free Software Foundation.
  */
 
+#include <linux/clk.h>
 #include <linux/dma-mapping.h>
 #include <linux/module.h>
 #include <linux/of.h>
@@ -91,6 +92,7 @@ static int xhci_plat_probe(struct platform_device *pdev)
 	struct xhci_hcd		*xhci;
 	struct resource         *res;
 	struct usb_hcd		*hcd;
+	struct clk              *clk;
 	int			ret;
 	int			irq;
 
@@ -137,14 +139,27 @@ static int xhci_plat_probe(struct platform_device *pdev)
 		goto release_mem_region;
 	}
 
+	/*
+	 * Not all platforms have a clk so it is not an error if the
+	 * clock does not exists.
+	 */
+	clk = devm_clk_get(&pdev->dev, NULL);
+	if (!IS_ERR(clk)) {
+		ret = clk_prepare_enable(clk);
+		if (ret)
+			goto unmap_registers;
+	}
+
 	ret = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (ret)
-		goto unmap_registers;
+		goto disable_clk;
+
 	device_wakeup_enable(hcd->self.controller);
 
 	/* USB 2.0 roothub is stored in the platform_device now. */
 	hcd = platform_get_drvdata(pdev);
 	xhci = hcd_to_xhci(hcd);
+	xhci->clk = clk;
 	xhci->shared_hcd = usb_create_shared_hcd(driver, &pdev->dev,
 			dev_name(&pdev->dev), hcd);
 	if (!xhci->shared_hcd) {
@@ -173,6 +188,10 @@ put_usb3_hcd:
 dealloc_usb2_hcd:
 	usb_remove_hcd(hcd);
 
+disable_clk:
+	if (!IS_ERR(clk))
+		clk_disable_unprepare(clk);
+
 unmap_registers:
 	iounmap(hcd->regs);
 
@@ -189,11 +208,14 @@ static int xhci_plat_remove(struct platform_device *dev)
 {
 	struct usb_hcd	*hcd = platform_get_drvdata(dev);
 	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
+	struct clk *clk = xhci->clk;
 
 	usb_remove_hcd(xhci->shared_hcd);
 	usb_put_hcd(xhci->shared_hcd);
 
 	usb_remove_hcd(hcd);
+	if (!IS_ERR(clk))
+		clk_disable_unprepare(clk);
 	iounmap(hcd->regs);
 	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 	usb_put_hcd(hcd);
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index d280e9213d08..003dc094ca37 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1478,6 +1478,8 @@ struct xhci_hcd {
 	/* msi-x vectors */
 	int		msix_count;
 	struct msix_entry	*msix_entries;
+	/* optional clock */
+	struct clk		*clk;
 	/* data structures */
 	struct xhci_device_context_array *dcbaa;
 	struct xhci_ring	*cmd_ring;
-- 
1.8.1.2

