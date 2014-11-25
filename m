Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbaKYNQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:16:49 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:37230 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045AbaKYNQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:16:45 -0500
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
Subject: [PATCH 14/19] usb: dwc3: otg: Add the initial otg driver for dwc3.
Date: Tue, 25 Nov 2014 18:41:50 +0530
Message-ID: <1416921115-10467-15-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1416921115-10467-1-git-send-email-george.cherian@ti.com>
References: <1416921115-10467-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the Initial OTG driver for dwc3.
Currently support only
	* ID based Role switching.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/dwc3/Makefile |   4 ++
 drivers/usb/dwc3/core.c   |  10 +---
 drivers/usb/dwc3/core.h   |  10 ++++
 drivers/usb/dwc3/otg.c    | 126 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 142 insertions(+), 8 deletions(-)
 create mode 100644 drivers/usb/dwc3/otg.c

diff --git a/drivers/usb/dwc3/Makefile b/drivers/usb/dwc3/Makefile
index bb34fbc..fe7af97 100644
--- a/drivers/usb/dwc3/Makefile
+++ b/drivers/usb/dwc3/Makefile
@@ -12,6 +12,10 @@ ifneq ($(filter y,$(CONFIG_USB_DWC3_HOST) $(CONFIG_USB_DWC3_DUAL_ROLE)),)
 	dwc3-y				+= host.o
 endif
 
+ifneq ($(CONFIG_USB_DWC3_DUAL_ROLE),)
+	dwc3-y				+= otg.o
+endif
+
 ifneq ($(filter y,$(CONFIG_USB_DWC3_GADGET) $(CONFIG_USB_DWC3_DUAL_ROLE)),)
 	dwc3-y				+= gadget.o ep0.o
 endif
diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index dbd5589..dd4af3f 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -685,15 +685,9 @@ static int dwc3_core_init_mode(struct dwc3 *dwc)
 		break;
 	case USB_DR_MODE_OTG:
 		dwc3_set_mode(dwc, DWC3_GCTL_PRTCAP_OTG);
-		ret = dwc3_host_init(dwc);
-		if (ret) {
-			dev_err(dev, "failed to initialize host\n");
-			return ret;
-		}
-
-		ret = dwc3_gadget_init(dwc);
+		ret = dwc3_otg_init(dwc);
 		if (ret) {
-			dev_err(dev, "failed to initialize gadget\n");
+			dev_err(dev, "failed to initialize otg\n");
 			return ret;
 		}
 		break;
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index eb2e970..001d77d 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -1103,6 +1103,16 @@ static inline int dwc3_send_gadget_generic_command(struct dwc3 *dwc,
 { return 0; }
 #endif
 
+#if IS_ENABLED(CONFIG_USB_DWC3_DUAL_ROLE)
+int dwc3_otg_init(struct dwc3 *dwc);
+void dwc3_otg_exit(struct dwc3 *dwc);
+#else
+static inline int dwc3_otg_init(struct dwc3 *dwc)
+{ return 0; }
+static inline void dwc3_otg_exit(struct dwc3 *dwc)
+{ }
+#endif
+
 /* power management interface */
 #if !IS_ENABLED(CONFIG_USB_DWC3_HOST)
 int dwc3_gadget_suspend(struct dwc3 *dwc);
diff --git a/drivers/usb/dwc3/otg.c b/drivers/usb/dwc3/otg.c
new file mode 100644
index 0000000..b5c31c0
--- /dev/null
+++ b/drivers/usb/dwc3/otg.c
@@ -0,0 +1,126 @@
+/**
+ * otg.c - DesignWare USB3 DRD Controller OTG
+ *
+ * Copyright (C) 2014 Texas Instruments Incorporated - http://www.ti.com
+ *
+ * Authors: George Cherian <george.cherian@ti.com>
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2  of
+ * the License as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/usb.h>
+#include <linux/usb/hcd.h>
+
+#include <linux/usb/drd.h>
+#include "core.h"
+#include "io.h"
+
+#define DWC3_GSTS_OTG_IP (1 << 10)
+
+static irqreturn_t dwc3_otg_interrupt(int irq , void *_dwc)
+{
+	struct dwc3 *dwc = _dwc;
+	u32 reg;
+
+	spin_lock(&dwc->lock);
+	reg = dwc3_readl(dwc->regs, DWC3_GSTS);
+	if (reg & DWC3_GSTS_OTG_IP) {
+		reg = dwc3_readl(dwc->regs, DWC3_OEVT);
+		dev_vdbg(dwc->dev, "OTG Interrupt %x\n", reg);
+		dwc3_writel(dwc->regs, DWC3_OEVT, reg);
+		spin_unlock(&dwc->lock);
+		return IRQ_WAKE_THREAD;
+	}
+
+	spin_unlock(&dwc->lock);
+	return IRQ_NONE;
+}
+
+static irqreturn_t dwc3_otg_thread_interrupt(int irq, void *_dwc)
+{
+	struct dwc3 *dwc = _dwc;
+	u32 reg = dwc3_readl(dwc->regs, DWC3_OSTS);
+
+	dev_vdbg(dwc->dev, "OTG thread interrupt\n");
+	if ((reg & DWC3_OSTS_CONIDSTS)) {
+		usb_drd_stop_hcd(dwc->dev);
+		dwc3_writel(dwc->regs, DWC3_OCFG, DWC3_OCFG_SFTRSTMASK);
+		dwc3_writel(dwc->regs, DWC3_OCTL,
+			    DWC3_OCTL_SESREQ | DWC3_OCTL_PERIMODE);
+		if (usb_drd_get_state(dwc->dev) & DRD_DEVICE_REGISTERED) {
+			usb_drd_start_udc(dwc->dev);
+		} else {
+			dwc3_core_gadget_helper(dwc);
+			dwc3_gadget_init(dwc);
+		}
+		dwc3_writel(dwc->regs, DWC3_OEVTEN,
+			    DWC3_OEVTEN_CONIDSTSCHNGEN);
+	} else if (!(reg & DWC3_OSTS_CONIDSTS)) {
+		usb_drd_stop_udc(dwc->dev);
+		dwc3_writel(dwc->regs, DWC3_OCFG,
+			    DWC3_OCFG_DISPWRCUTTOFF | DWC3_OCFG_SFTRSTMASK);
+		dwc3_writel(dwc->regs, DWC3_OCTL, DWC3_OCTL_PRTPWRCTL);
+		if (usb_drd_get_state(dwc->dev) & DRD_HOST_REGISTERED)
+			usb_drd_start_hcd(dwc->dev);
+		else
+			dwc3_host_init(dwc);
+
+		dwc3_writel(dwc->regs, DWC3_OEVTEN,
+			    DWC3_OEVTEN_CONIDSTSCHNGEN);
+	}
+
+	return IRQ_HANDLED;
+}
+
+int dwc3_otg_init(struct dwc3 *dwc)
+{
+	u32 reg, ret;
+
+	usb_drd_add(dwc->dev);
+	dwc3_writel(dwc->regs, DWC3_OEVT, 0xFFFF);
+	if (dwc->otg_irq > 0) {
+		ret = devm_request_threaded_irq(dwc->dev, dwc->otg_irq,
+						dwc3_otg_interrupt,
+						dwc3_otg_thread_interrupt,
+						IRQF_SHARED, "dwc3-otg", dwc);
+	} else {
+		WARN(1, "Trying to request invalid otg_irq");
+		return -ENODEV;
+	}
+
+	dwc3_writel(dwc->regs, DWC3_OEVTEN, DWC3_OEVTEN_CONIDSTSCHNGEN);
+	dwc3_writel(dwc->regs, DWC3_OCTL, DWC3_OCTL_PERIMODE);
+
+	reg = dwc3_readl(dwc->regs, DWC3_OSTS);
+	if ((reg & DWC3_OSTS_CONIDSTS)) {
+		dev_vdbg(dwc->dev, "Gadget  init\n");
+		dwc3_writel(dwc->regs, DWC3_OCFG, DWC3_OCFG_SFTRSTMASK);
+		dwc3_writel(dwc->regs, DWC3_OCTL,
+			    DWC3_OCTL_SESREQ | DWC3_OCTL_PERIMODE);
+		dwc3_gadget_init(dwc);
+		dwc3_writel(dwc->regs, DWC3_OEVTEN,
+			    DWC3_OEVTEN_CONIDSTSCHNGEN);
+
+	} else if (!(reg & DWC3_OSTS_CONIDSTS)) {
+		dev_vdbg(dwc->dev, "Host  init\n");
+		dwc3_writel(dwc->regs, DWC3_OCFG,
+			    DWC3_OCFG_DISPWRCUTTOFF | DWC3_OCFG_SFTRSTMASK);
+		dwc3_writel(dwc->regs, DWC3_OCTL, DWC3_OCTL_PRTPWRCTL);
+		dwc3_host_init(dwc);
+		dwc3_writel(dwc->regs, DWC3_OEVTEN,
+			    DWC3_OEVTEN_CONIDSTSCHNGEN);
+	}
+
+	return 0;
+}
-- 
1.8.3.1

