Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981AbaEOKTC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 06:19:02 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54526 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754848AbaEOKS7 (ORCPT
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
Subject: [PATCH v6 08/17] usb: host: xhci-plat: add support for the Armada 375/38x XHCI controllers
Date: Thu, 15 May 2014 12:17:33 +0200
Message-Id: <1400149062-32661-9-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1400149062-32661-1-git-send-email-gregory.clement@free-electrons.com>
References: <1400149062-32661-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Armada 375 and 38x SoCs come with an XHCI controller that requires
some specific initialization related to the MBus windows
configuration. This patch adds the support for this special
configuration as an XHCI quirk executed during probe.

Two new compatible strings are added to identify the Armada 375 and
Armada 38x XHCI controllers, and therefore enable the relevant quirk.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Acked-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/Kconfig      |  8 +++++
 drivers/usb/host/Makefile     |  3 ++
 drivers/usb/host/xhci-mvebu.c | 72 +++++++++++++++++++++++++++++++++++++++++++
 drivers/usb/host/xhci-mvebu.h | 21 +++++++++++++
 drivers/usb/host/xhci-plat.c  | 12 ++++++++
 5 files changed, 116 insertions(+)
 create mode 100644 drivers/usb/host/xhci-mvebu.c
 create mode 100644 drivers/usb/host/xhci-mvebu.h

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 3d9e54062d62..9247ad26db9a 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -29,6 +29,14 @@ if USB_XHCI_HCD
 config USB_XHCI_PLATFORM
 	tristate
 
+config USB_XHCI_MVEBU
+	tristate "xHCI support for Marvell Armada 375/38x"
+	select USB_XHCI_PLATFORM
+	depends on ARCH_MVEBU || COMPILE_TEST
+	---help---
+	  Say 'Y' to enable the support for the xHCI host controller
+	  found in Marvell Armada 375/38x ARM SOCs.
+
 endif # USB_XHCI_HCD
 
 config USB_EHCI_HCD
diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
index 7530468c9a4f..7c0886a35182 100644
--- a/drivers/usb/host/Makefile
+++ b/drivers/usb/host/Makefile
@@ -19,6 +19,9 @@ xhci-hcd-$(CONFIG_PCI)	+= xhci-pci.o
 
 ifneq ($(CONFIG_USB_XHCI_PLATFORM), )
 	xhci-hcd-y		+= xhci-plat.o
+ifneq ($(CONFIG_USB_XHCI_MVEBU), )
+	xhci-hcd-y		+= xhci-mvebu.o
+endif
 endif
 
 obj-$(CONFIG_USB_WHCI_HCD)	+= whci/
diff --git a/drivers/usb/host/xhci-mvebu.c b/drivers/usb/host/xhci-mvebu.c
new file mode 100644
index 000000000000..1eefc988192d
--- /dev/null
+++ b/drivers/usb/host/xhci-mvebu.c
@@ -0,0 +1,72 @@
+/*
+ * Copyright (C) 2014 Marvell
+ * Author: Gregory CLEMENT <gregory.clement@free-electrons.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ */
+
+#include <linux/io.h>
+#include <linux/mbus.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+
+#include "xhci-mvebu.h"
+
+#define USB3_MAX_WINDOWS	4
+#define USB3_WIN_CTRL(w)	(0x0 + ((w) * 8))
+#define USB3_WIN_BASE(w)	(0x4 + ((w) * 8))
+
+static void xhci_mvebu_mbus_config(void __iomem *base,
+			const struct mbus_dram_target_info *dram)
+{
+	int win;
+
+	/* Clear all existing windows */
+	for (win = 0; win < USB3_MAX_WINDOWS; win++) {
+		writel(0, base + USB3_WIN_CTRL(win));
+		writel(0, base + USB3_WIN_BASE(win));
+	}
+
+	/* Program each DRAM CS in a seperate window */
+	for (win = 0; win < dram->num_cs; win++) {
+		const struct mbus_dram_window *cs = dram->cs + win;
+
+		writel(((cs->size - 1) & 0xffff0000) | (cs->mbus_attr << 8) |
+		       (dram->mbus_dram_target_id << 4) | 1,
+		       base + USB3_WIN_CTRL(win));
+
+		writel((cs->base & 0xffff0000), base + USB3_WIN_BASE(win));
+	}
+}
+
+int xhci_mvebu_mbus_init_quirk(struct platform_device *pdev)
+{
+	struct resource	*res;
+	void __iomem *base;
+	const struct mbus_dram_target_info *dram;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	if (!res)
+		return -ENODEV;
+
+	/*
+	 * We don't use devm_ioremap() because this mapping should
+	 * only exists for the duration of this probe function.
+	 */
+	base = ioremap(res->start, resource_size(res));
+	if (!base)
+		return -ENODEV;
+
+	dram = mv_mbus_dram_info();
+	xhci_mvebu_mbus_config(base, dram);
+
+	/*
+	 * This memory area was only needed to configure the MBus
+	 * windows, and is therefore no longer useful.
+	 */
+	iounmap(base);
+
+	return 0;
+}
diff --git a/drivers/usb/host/xhci-mvebu.h b/drivers/usb/host/xhci-mvebu.h
new file mode 100644
index 000000000000..7ede92aa41f6
--- /dev/null
+++ b/drivers/usb/host/xhci-mvebu.h
@@ -0,0 +1,21 @@
+/*
+ * Copyright (C) 2014 Marvell
+ *
+ * Gregory Clement <gregory.clement@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef __LINUX_XHCI_MVEBU_H
+#define __LINUX_XHCI_MVEBU_H
+#if IS_ENABLED(CONFIG_USB_XHCI_MVEBU)
+int xhci_mvebu_mbus_init_quirk(struct platform_device *pdev);
+#else
+static inline int xhci_mvebu_mbus_init_quirk(struct platform_device *pdev)
+{
+	return 0;
+}
+#endif
+#endif /* __LINUX_XHCI_MVEBU_H */
diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 8108e58c9e02..0f5f4c8f5bf6 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -19,6 +19,7 @@
 #include <linux/slab.h>
 
 #include "xhci.h"
+#include "xhci-mvebu.h"
 
 static void xhci_plat_quirks(struct device *dev, struct xhci_hcd *xhci)
 {
@@ -109,6 +110,15 @@ static int xhci_plat_probe(struct platform_device *pdev)
 	if (!res)
 		return -ENODEV;
 
+	if (of_device_is_compatible(pdev->dev.of_node,
+				    "marvell,armada-375-xhci") ||
+	    of_device_is_compatible(pdev->dev.of_node,
+				    "marvell,armada-380-xhci")) {
+		ret = xhci_mvebu_mbus_init_quirk(pdev);
+		if (ret)
+			return ret;
+	}
+
 	/* Initialize dma_mask and coherent_dma_mask to 32-bits */
 	ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
 	if (ret)
@@ -253,6 +263,8 @@ static const struct dev_pm_ops xhci_plat_pm_ops = {
 static const struct of_device_id usb_xhci_of_match[] = {
 	{ .compatible = "generic-xhci" },
 	{ .compatible = "xhci-platform" },
+	{ .compatible = "marvell,armada-375-xhci"},
+	{ .compatible = "marvell,armada-380-xhci"},
 	{ },
 };
 MODULE_DEVICE_TABLE(of, usb_xhci_of_match);
-- 
1.8.1.2

