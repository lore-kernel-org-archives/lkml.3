Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbbATJVL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 04:21:11 -0500
Received: from mga11.intel.com ([192.55.52.93]:15591 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541AbbATJSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 04:18:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="442631533"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Baolu Lu <baolu.lu@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 2/3] usb: dwc3: add ULPI interface support
Date: Tue, 20 Jan 2015 11:18:21 +0200
Message-Id: <1421745502-169447-3-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421745502-169447-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1421745502-169447-1-git-send-email-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Registers ULPI interface with the ULPI bus if HSPHY type is
ULPI.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/dwc3/Kconfig  |   7 ++++
 drivers/usb/dwc3/Makefile |   4 ++
 drivers/usb/dwc3/core.c   |   9 +++-
 drivers/usb/dwc3/core.h   |  22 ++++++++++
 drivers/usb/dwc3/ulpi.c   | 102 ++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 143 insertions(+), 1 deletion(-)
 create mode 100644 drivers/usb/dwc3/ulpi.c

diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
index 58b5b2c..6d0c5e6 100644
--- a/drivers/usb/dwc3/Kconfig
+++ b/drivers/usb/dwc3/Kconfig
@@ -11,6 +11,13 @@ config USB_DWC3
 
 if USB_DWC3
 
+config USB_DWC3_ULPI
+	bool "Provide ULPI PHY Interface"
+	depends on ULPI_PHY=y || ULPI_PHY=USB_DWC3
+	help
+	  Select this if you have ULPI type PHY attached to your DWC3
+	  controller.
+
 choice
 	bool "DWC3 Mode Selection"
 	default USB_DWC3_DUAL_ROLE if (USB && USB_GADGET)
diff --git a/drivers/usb/dwc3/Makefile b/drivers/usb/dwc3/Makefile
index bb34fbc..2fc44e0 100644
--- a/drivers/usb/dwc3/Makefile
+++ b/drivers/usb/dwc3/Makefile
@@ -16,6 +16,10 @@ ifneq ($(filter y,$(CONFIG_USB_DWC3_GADGET) $(CONFIG_USB_DWC3_DUAL_ROLE)),)
 	dwc3-y				+= gadget.o ep0.o
 endif
 
+ifneq ($(CONFIG_USB_DWC3_ULPI),)
+	dwc3-y				+= ulpi.o
+endif
+
 ifneq ($(CONFIG_DEBUG_FS),)
 	dwc3-y				+= debugfs.o
 endif
diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 25ddc39..5219bc7 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -876,12 +876,17 @@ static int dwc3_probe(struct platform_device *pdev)
 	dwc->hird_threshold = hird_threshold
 		| (dwc->is_utmi_l1_suspend << 4);
 
+	platform_set_drvdata(pdev, dwc);
+
+	ret = dwc3_ulpi_init(dwc);
+	if (ret)
+		return ret;
+
 	ret = dwc3_core_get_phy(dwc);
 	if (ret)
 		return ret;
 
 	spin_lock_init(&dwc->lock);
-	platform_set_drvdata(pdev, dwc);
 
 	if (!dev->dma_mask) {
 		dev->dma_mask = dev->parent->dma_mask;
@@ -965,6 +970,7 @@ err1:
 
 err0:
 	dwc3_free_event_buffers(dwc);
+	dwc3_ulpi_exit(dwc);
 
 	return ret;
 }
@@ -984,6 +990,7 @@ static int dwc3_remove(struct platform_device *pdev)
 	phy_power_off(dwc->usb3_generic_phy);
 
 	dwc3_core_exit(dwc);
+	dwc3_ulpi_exit(dwc);
 
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 0842aa8..f6881a6 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -32,6 +32,7 @@
 #include <linux/usb/otg.h>
 
 #include <linux/phy/phy.h>
+#include <linux/phy/ulpi/interface.h>
 
 #define DWC3_MSG_MAX	500
 
@@ -174,6 +175,14 @@
 #define DWC3_GUSB2PHYCFG_PHYSOFTRST	(1 << 31)
 #define DWC3_GUSB2PHYCFG_SUSPHY		(1 << 6)
 
+/* Global USB2 PHY Vendor Control Register */
+#define DWC3_GUSB2PHYACC_NEWREGREQ	(1 << 25)
+#define DWC3_GUSB2PHYACC_BUSY		(1 << 23)
+#define DWC3_GUSB2PHYACC_WRITE		(1 << 22)
+#define DWC3_GUSB2PHYACC_ADDR(n)	(n << 16)
+#define DWC3_GUSB2PHYACC_EXTEND_ADDR(n)	(n << 8)
+#define DWC3_GUSB2PHYACC_DATA(n)	(n & 0xff)
+
 /* Global USB3 PIPE Control Register */
 #define DWC3_GUSB3PIPECTL_PHYSOFTRST	(1 << 31)
 #define DWC3_GUSB3PIPECTL_U2SSINP3OK	(1 << 29)
@@ -590,6 +599,7 @@ struct dwc3_hwparams {
 #define DWC3_NUM_INT(n)		(((n) & (0x3f << 15)) >> 15)
 
 /* HWPARAMS3 */
+#define DWC3_ULPI_HSPHY		(1 << 3)
 #define DWC3_NUM_IN_EPS_MASK	(0x1f << 18)
 #define DWC3_NUM_EPS_MASK	(0x3f << 12)
 #define DWC3_NUM_EPS(p)		(((p)->hwparams3 &		\
@@ -739,6 +749,8 @@ struct dwc3 {
 	struct phy		*usb2_generic_phy;
 	struct phy		*usb3_generic_phy;
 
+	struct ulpi		*ulpi;
+
 	void __iomem		*regs;
 	size_t			regs_size;
 
@@ -1035,4 +1047,14 @@ static inline int dwc3_gadget_resume(struct dwc3 *dwc)
 }
 #endif /* !IS_ENABLED(CONFIG_USB_DWC3_HOST) */
 
+#if IS_ENABLED(CONFIG_USB_DWC3_ULPI)
+int dwc3_ulpi_init(struct dwc3 *dwc);
+void dwc3_ulpi_exit(struct dwc3 *dwc);
+#else
+static inline int dwc3_ulpi_init(struct dwc3 *dwc)
+{ return 0; }
+static inline void dwc3_ulpi_exit(struct dwc3 *dwc)
+{ }
+#endif
+
 #endif /* __DRIVERS_USB_DWC3_CORE_H */
diff --git a/drivers/usb/dwc3/ulpi.c b/drivers/usb/dwc3/ulpi.c
new file mode 100644
index 0000000..ee3ebbe
--- /dev/null
+++ b/drivers/usb/dwc3/ulpi.c
@@ -0,0 +1,102 @@
+/**
+ * ulpi.c - DesignWare USB3 Controller's ULPI PHY interface
+ *
+ * Copyright (C) 2015 Intel Corporation
+ *
+ * Author: Heikki Krogerus <heikki.krogerus@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/phy/ulpi/regs.h>
+
+#include "core.h"
+#include "io.h"
+
+#define DWC3_ULPI_ADDR(a) \
+		((a >= ULPI_EXT_VENDOR_SPECIFIC) ? \
+		DWC3_GUSB2PHYACC_ADDR(ULPI_ACCESS_EXTENDED) | \
+		DWC3_GUSB2PHYACC_EXTEND_ADDR(a) : DWC3_GUSB2PHYACC_ADDR(a))
+
+static int dwc3_ulpi_busyloop(struct dwc3 *dwc)
+{
+	unsigned count = 1000;
+	u32 reg;
+
+	while (count--) {
+		reg = dwc3_readl(dwc->regs, DWC3_GUSB2PHYACC(0));
+		if (!(reg & DWC3_GUSB2PHYACC_BUSY))
+			return 0;
+	}
+
+	return -ETIMEDOUT;
+}
+
+static int dwc3_ulpi_read(struct ulpi_ops *ops, u8 addr)
+{
+	struct dwc3 *dwc = dev_get_drvdata(ops->dev);
+	u32 reg;
+	int ret;
+
+	reg = DWC3_GUSB2PHYACC_NEWREGREQ | DWC3_ULPI_ADDR(addr);
+	dwc3_writel(dwc->regs, DWC3_GUSB2PHYACC(0), reg);
+
+	ret = dwc3_ulpi_busyloop(dwc);
+	if (ret)
+		return ret;
+
+	reg = dwc3_readl(dwc->regs, DWC3_GUSB2PHYACC(0));
+
+	return DWC3_GUSB2PHYACC_DATA(reg);
+}
+
+static int dwc3_ulpi_write(struct ulpi_ops *ops, u8 addr, u8 val)
+{
+	struct dwc3 *dwc = dev_get_drvdata(ops->dev);
+	u32 reg;
+	int ret;
+
+	reg = DWC3_GUSB2PHYACC_NEWREGREQ | DWC3_ULPI_ADDR(addr);
+	reg |= DWC3_GUSB2PHYACC_WRITE | val;
+	dwc3_writel(dwc->regs, DWC3_GUSB2PHYACC(0), reg);
+
+	ret = dwc3_ulpi_busyloop(dwc);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static struct ulpi_ops dwc3_ulpi = {
+	.read = dwc3_ulpi_read,
+	.write = dwc3_ulpi_write,
+};
+
+int dwc3_ulpi_init(struct dwc3 *dwc)
+{
+	int ret;
+
+	/* First check if there is ULPI PHY */
+	ret = dwc3_readl(dwc->regs, DWC3_GHWPARAMS3);
+	if (!(ret & DWC3_ULPI_HSPHY))
+		return 0;
+
+	/* Register the interface */
+	dwc->ulpi = ulpi_register_interface(dwc->dev, &dwc3_ulpi);
+	if (IS_ERR(dwc->ulpi)) {
+		dev_err(dwc->dev, "failed to register ULPI interface");
+		return PTR_ERR(dwc->ulpi);
+	}
+
+	return 0;
+}
+
+void dwc3_ulpi_exit(struct dwc3 *dwc)
+{
+	if (dwc->ulpi) {
+		ulpi_unregister_interface(dwc->ulpi);
+		dwc->ulpi = NULL;
+	}
+}
-- 
2.1.4

