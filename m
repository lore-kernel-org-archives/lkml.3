Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbaDRK1W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 06:27:22 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60685 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751293AbaDRKXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 06:23:23 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH 1/8] usb: host: xhci-plat: Allow to register glue code using the device tree
Date: Fri, 18 Apr 2014 12:22:36 +0200
Message-Id: <1397816563-9000-2-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1397816563-9000-1-git-send-email-gregory.clement@free-electrons.com>
References: <1397816563-9000-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allow to register specific glue code for xhci controller.
It creates a structure called xhci_plat_ops to register functions
specific to an SoC. Currently there are only probe() and remove() but
it can be extended later, it was the point to create such a structure.

Each compatible string can then be associated to an instance of this
structure. In the non device tree case a default structure is used.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 drivers/usb/host/xhci-plat.c | 72 +++++++++++++++++++++++++++++++++++++++++---
 drivers/usb/host/xhci.h      |  4 +++
 2 files changed, 72 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 151901ce1ba9..8029cc82edc4 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 #include <linux/of.h>
 #include <linux/dma-mapping.h>
+#include <linux/of_device.h>
 
 #include "xhci.h"
 
@@ -85,7 +86,7 @@ static const struct hc_driver xhci_plat_xhci_driver = {
 	.bus_resume =		xhci_bus_resume,
 };
 
-static int xhci_plat_probe(struct platform_device *pdev)
+int common_xhci_plat_probe(struct platform_device *pdev, void *priv)
 {
 	const struct hc_driver	*driver;
 	struct xhci_hcd		*xhci;
@@ -145,6 +146,7 @@ static int xhci_plat_probe(struct platform_device *pdev)
 	/* USB 2.0 roothub is stored in the platform_device now. */
 	hcd = platform_get_drvdata(pdev);
 	xhci = hcd_to_xhci(hcd);
+	xhci->priv = priv;
 	xhci->shared_hcd = usb_create_shared_hcd(driver, &pdev->dev,
 			dev_name(&pdev->dev), hcd);
 	if (!xhci->shared_hcd) {
@@ -185,7 +187,7 @@ put_hcd:
 	return ret;
 }
 
-static int xhci_plat_remove(struct platform_device *dev)
+int common_xhci_plat_remove(struct platform_device *dev)
 {
 	struct usb_hcd	*hcd = platform_get_drvdata(dev);
 	struct xhci_hcd	*xhci = hcd_to_xhci(hcd);
@@ -202,6 +204,26 @@ static int xhci_plat_remove(struct platform_device *dev)
 	return 0;
 }
 
+static int default_xhci_plat_probe(struct platform_device *pdev)
+{
+	return common_xhci_plat_probe(pdev, NULL);
+}
+
+static int default_xhci_plat_remove(struct platform_device *pdev)
+{
+	return common_xhci_plat_remove(pdev);
+}
+
+struct xhci_plat_ops {
+	int (*probe)(struct platform_device *);
+	int (*remove)(struct platform_device *);
+};
+
+static struct xhci_plat_ops xhci_plat_default = {
+	.probe = default_xhci_plat_probe,
+	.remove =  default_xhci_plat_remove,
+};
+
 #ifdef CONFIG_PM
 static int xhci_plat_suspend(struct device *dev)
 {
@@ -229,13 +251,55 @@ static const struct dev_pm_ops xhci_plat_pm_ops = {
 
 #ifdef CONFIG_OF
 static const struct of_device_id usb_xhci_of_match[] = {
-	{ .compatible = "generic-xhci" },
-	{ .compatible = "xhci-platform" },
+	{
+		.compatible = "generic-xhci",
+		.data = (void *) &xhci_plat_default,
+	},
+	{
+		.compatible = "xhci-platform",
+		.data = (void *) &xhci_plat_default,
+	},
 	{ },
 };
 MODULE_DEVICE_TABLE(of, usb_xhci_of_match);
 #endif
 
+static int xhci_plat_probe(struct platform_device *pdev)
+{
+	const struct xhci_plat_ops *plat_of = &xhci_plat_default;
+
+	if (pdev->dev.of_node) {
+		const struct of_device_id *match =
+			of_match_device(usb_xhci_of_match, &pdev->dev);
+		if (!match)
+			return -ENODEV;
+		plat_of = match->data;
+	}
+
+	if (!plat_of || !plat_of->probe)
+		return  -ENODEV;
+
+	return plat_of->probe(pdev);
+}
+
+static int xhci_plat_remove(struct platform_device *pdev)
+{
+	const struct xhci_plat_ops *plat_of = &xhci_plat_default;
+
+	if (pdev->dev.of_node) {
+		const struct of_device_id *match =
+			of_match_device(usb_xhci_of_match, &pdev->dev);
+		if (!match)
+			return -ENODEV;
+		plat_of = match->data;
+	}
+
+	if (!plat_of || !plat_of->remove)
+		return  -ENODEV;
+
+	return plat_of->remove(pdev);
+}
+
 static struct platform_driver usb_xhci_driver = {
 	.probe	= xhci_plat_probe,
 	.remove	= xhci_plat_remove,
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index d280e9213d08..96dd3df3dd8c 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1461,6 +1461,7 @@ struct xhci_hcd {
 	__u32		hcc_params;
 
 	spinlock_t	lock;
+	void           *priv;
 
 	/* packed release number */
 	u8		sbrn;
@@ -1597,6 +1598,9 @@ static inline struct usb_hcd *xhci_to_hcd(struct xhci_hcd *xhci)
 	return xhci->main_hcd;
 }
 
+int common_xhci_plat_probe(struct platform_device *pdev, void *priv);
+int common_xhci_plat_remove(struct platform_device *dev);
+
 #define xhci_dbg(xhci, fmt, args...) \
 	dev_dbg(xhci_to_hcd(xhci)->self.controller , fmt , ## args)
 #define xhci_err(xhci, fmt, args...) \
-- 
1.8.1.2

