Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbbAWPNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 10:13:18 -0500
Received: from mga14.intel.com ([192.55.52.115]:30550 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755473AbbAWPNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 10:13:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,454,1418112000"; 
   d="scan'208";a="666508965"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Baolu Lu <baolu.lu@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] usb: dwc3: add ULPI interface support
Date: Fri, 23 Jan 2015 17:12:56 +0200
Message-Id: <1422025978-178336-7-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422025978-178336-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1422025978-178336-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Registers DWC3's ULPI interface with the ULPI bus when it's
available.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/usb/dwc3/Kconfig  |   7 +++
 drivers/usb/dwc3/Makefile |   4 ++
 drivers/usb/dwc3/core.c   |   6 +++
 drivers/usb/dwc3/core.h   |  13 ++++++
 drivers/usb/dwc3/ulpi.c   | 112 ++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 142 insertions(+)
 create mode 100644 drivers/usb/dwc3/ulpi.c

diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
index 58b5b2c..cda82ad 100644
--- a/drivers/usb/dwc3/Kconfig
+++ b/drivers/usb/dwc3/Kconfig
@@ -11,6 +11,13 @@ config USB_DWC3
 
 if USB_DWC3
 
+config USB_DWC3_ULPI
+	bool "Register ULPI PHY Interface"
+	depends on USB_ULPI_BUS=y
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
index a8c9062..66cbf38 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -879,6 +879,10 @@ static int dwc3_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, dwc);
 	dwc3_cache_hwparams(dwc);
 
+	ret = dwc3_ulpi_init(dwc);
+	if (ret)
+		return ret;
+
 	ret = dwc3_core_get_phy(dwc);
 	if (ret)
 		return ret;
@@ -965,6 +969,7 @@ err1:
 
 err0:
 	dwc3_free_event_buffers(dwc);
+	dwc3_ulpi_exit(dwc);
 
 	return ret;
 }
@@ -984,6 +989,7 @@ static int dwc3_remove(struct platform_device *pdev)
 	phy_power_off(dwc->usb3_generic_phy);
 
 	dwc3_core_exit(dwc);
+	dwc3_ulpi_exit(dwc);
 
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 9b6f4c7..ad6b371 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -30,6 +30,7 @@
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
 #include <linux/usb/otg.h>
+#include <linux/ulpi/interface.h>
 
 #include <linux/phy/phy.h>
 
@@ -748,6 +749,8 @@ struct dwc3 {
 	struct phy		*usb2_generic_phy;
 	struct phy		*usb3_generic_phy;
 
+	struct ulpi		*ulpi;
+
 	void __iomem		*regs;
 	size_t			regs_size;
 
@@ -1044,4 +1047,14 @@ static inline int dwc3_gadget_resume(struct dwc3 *dwc)
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
index 0000000..8806981
--- /dev/null
+++ b/drivers/usb/dwc3/ulpi.c
@@ -0,0 +1,112 @@
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
+#include <linux/ulpi/regs.h>
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
+		cpu_relax();
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
+	u32 reg;
+
+	/* First check USB2 PHY interface type */
+	switch (DWC3_GHWPARAMS3_HSPHY_IFC(dwc->hwparams.hwparams3)) {
+	case DWC3_GHWPARAMS3_HSPHY_IFC_UTMI_ULPI:
+		/* Select ULPI Interface */
+		reg = dwc3_readl(dwc->regs, DWC3_GUSB2PHYCFG(0));
+		reg |= DWC3_GUSB2PHYCFG_ULPI_UTMI;
+		dwc3_writel(dwc->regs, DWC3_GUSB2PHYCFG(0), reg);
+		/* FALLTHROUGH */
+	case DWC3_GHWPARAMS3_HSPHY_IFC_ULPI:
+		break;
+	default:
+		return 0;
+	}
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

