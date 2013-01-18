Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751156Ab3ARGPX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 01:15:23 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15419 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab3ARGPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 01:15:22 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 17 Jan 2013 22:14:26 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>, <balbi@ti.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <swarren@wwwdotorg.org>, <linux-tegra@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH v3 4/4] usb: Add APIs to access host registers from Tegra PHY
Date: Fri, 18 Jan 2013 11:45:37 +0530
Message-ID: <1358489737-32273-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Tegra PHY driver needs to access one of the Host registers,
added few APIs.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
delta from v2:
Renamed USB_PORTSC1 to TEGRA_USB_PORTSC1.
Removed tegra_ehci_set_wakeon_events() and its references.
Used standard defines for accessing PORTSC fields defined in ehci_def.h
Included OCC bit of PORTSC as part of TEGRA_PORTSC1_RWC_BITS.

delta from v1:
Taken care of RWC bits, while accessing PORTSC register.


 drivers/usb/host/ehci-tegra.c     |   51 ++++++++++++++++++++++++++++++++++-
 drivers/usb/phy/tegra_usb_phy.c   |   52 ++++++++-----------------------------
 include/linux/usb/tegra_usb_phy.h |    4 +++
 3 files changed, 64 insertions(+), 43 deletions(-)

diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index 55a9cde..1f596fb 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -2,7 +2,7 @@
  * EHCI-compliant USB host controller driver for NVIDIA Tegra SoCs
  *
  * Copyright (C) 2010 Google, Inc.
- * Copyright (C) 2009 NVIDIA Corporation
+ * Copyright (C) 2009 - 2013 NVIDIA Corporation
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
@@ -26,13 +26,18 @@
 #include <linux/of.h>
 #include <linux/of_gpio.h>
 #include <linux/pm_runtime.h>
-
+#include <linux/usb/ehci_def.h>
 #include <linux/usb/tegra_usb_phy.h>
 
 #define TEGRA_USB_BASE			0xC5000000
 #define TEGRA_USB2_BASE			0xC5004000
 #define TEGRA_USB3_BASE			0xC5008000
 
+/* PORTSC registers */
+#define TEGRA_USB_PORTSC1			0x184
+#define TEGRA_USB_PORTSC1_PTS(x)	(((x) & 0x3) << 30)
+#define TEGRA_USB_PORTSC1_PHCD	(1 << 23)
+
 #define TEGRA_USB_DMA_ALIGN 32
 
 struct tegra_ehci_hcd {
@@ -605,6 +610,37 @@ static const struct dev_pm_ops tegra_ehci_pm_ops = {
 
 #endif
 
+/* Bits of PORTSC1, which will get cleared by writing 1 into them */
+#define TEGRA_PORTSC1_RWC_BITS (PORT_CSC | PORT_PEC | PORT_OCC)
+
+void tegra_ehci_set_pts(struct usb_phy *x, u8 pts_val)
+{
+	unsigned long val;
+	struct usb_hcd *hcd = bus_to_hcd(x->otg->host);
+	void __iomem *base = hcd->regs;
+
+	val = readl(base + TEGRA_USB_PORTSC1) & ~TEGRA_PORTSC1_RWC_BITS;
+	val &= ~TEGRA_USB_PORTSC1_PTS(3);
+	val |= TEGRA_USB_PORTSC1_PTS(pts_val & 3);
+	writel(val, base + TEGRA_USB_PORTSC1);
+}
+EXPORT_SYMBOL_GPL(tegra_ehci_set_pts);
+
+void tegra_ehci_set_phcd(struct usb_phy *x, bool enable)
+{
+	unsigned long val;
+	struct usb_hcd *hcd = bus_to_hcd(x->otg->host);
+	void __iomem *base = hcd->regs;
+
+	val = readl(base + TEGRA_USB_PORTSC1) & ~TEGRA_PORTSC1_RWC_BITS;
+	if (enable)
+		val |= TEGRA_USB_PORTSC1_PHCD;
+	else
+		val &= ~TEGRA_USB_PORTSC1_PHCD;
+	writel(val, base + TEGRA_USB_PORTSC1);
+}
+EXPORT_SYMBOL_GPL(tegra_ehci_set_phcd);
+
 static u64 tegra_ehci_dma_mask = DMA_BIT_MASK(32);
 
 static int tegra_ehci_probe(struct platform_device *pdev)
@@ -616,6 +652,7 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 	int err = 0;
 	int irq;
 	int instance = pdev->id;
+	struct usb_phy *u_phy;
 
 	pdata = pdev->dev.platform_data;
 	if (!pdata) {
@@ -718,6 +755,16 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 
 	usb_phy_init(&tegra->phy->u_phy);
 
+	hcd->phy = u_phy = &tegra->phy->u_phy;
+	u_phy->otg = devm_kzalloc(&pdev->dev, sizeof(struct usb_otg),
+			     GFP_KERNEL);
+	if (!u_phy->otg) {
+		dev_err(&pdev->dev, "Failed to alloc memory for otg\n");
+		err = -ENOMEM;
+		goto fail_io;
+	}
+	u_phy->otg->host = hcd_to_bus(hcd);
+
 	err = usb_phy_set_suspend(&tegra->phy->u_phy, 0);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to power on the phy\n");
diff --git a/drivers/usb/phy/tegra_usb_phy.c b/drivers/usb/phy/tegra_usb_phy.c
index ce1ff2a..d465704 100644
--- a/drivers/usb/phy/tegra_usb_phy.c
+++ b/drivers/usb/phy/tegra_usb_phy.c
@@ -36,19 +36,6 @@
 
 #define ULPI_VIEWPORT		0x170
 
-#define USB_PORTSC1		0x184
-#define   USB_PORTSC1_PTS(x)	(((x) & 0x3) << 30)
-#define   USB_PORTSC1_PSPD(x)	(((x) & 0x3) << 26)
-#define   USB_PORTSC1_PHCD	(1 << 23)
-#define   USB_PORTSC1_WKOC	(1 << 22)
-#define   USB_PORTSC1_WKDS	(1 << 21)
-#define   USB_PORTSC1_WKCN	(1 << 20)
-#define   USB_PORTSC1_PTC(x)	(((x) & 0xf) << 16)
-#define   USB_PORTSC1_PP	(1 << 12)
-#define   USB_PORTSC1_SUSP	(1 << 7)
-#define   USB_PORTSC1_PE	(1 << 2)
-#define   USB_PORTSC1_CCS	(1 << 0)
-
 #define USB_SUSP_CTRL		0x400
 #define   USB_WAKE_ON_CNNT_EN_DEV	(1 << 3)
 #define   USB_WAKE_ON_DISCON_EN_DEV	(1 << 4)
@@ -311,11 +298,8 @@ static void utmi_phy_clk_disable(struct tegra_usb_phy *phy)
 		val = readl(base + USB_SUSP_CTRL);
 		val &= ~USB_SUSP_SET;
 		writel(val, base + USB_SUSP_CTRL);
-	} else {
-		val = readl(base + USB_PORTSC1);
-		val |= USB_PORTSC1_PHCD;
-		writel(val, base + USB_PORTSC1);
-	}
+	} else
+		tegra_ehci_set_phcd(&phy->u_phy, true);
 
 	if (utmi_wait_register(base + USB_SUSP_CTRL, USB_PHY_CLK_VALID, 0) < 0)
 		pr_err("%s: timeout waiting for phy to stabilize\n", __func__);
@@ -336,11 +320,8 @@ static void utmi_phy_clk_enable(struct tegra_usb_phy *phy)
 		val = readl(base + USB_SUSP_CTRL);
 		val &= ~USB_SUSP_CLR;
 		writel(val, base + USB_SUSP_CTRL);
-	} else {
-		val = readl(base + USB_PORTSC1);
-		val &= ~USB_PORTSC1_PHCD;
-		writel(val, base + USB_PORTSC1);
-	}
+	} else
+		tegra_ehci_set_phcd(&phy->u_phy, false);
 
 	if (utmi_wait_register(base + USB_SUSP_CTRL, USB_PHY_CLK_VALID,
 						     USB_PHY_CLK_VALID))
@@ -462,11 +443,8 @@ static int utmi_phy_power_on(struct tegra_usb_phy *phy)
 
 	utmi_phy_clk_enable(phy);
 
-	if (!phy->is_legacy_phy) {
-		val = readl(base + USB_PORTSC1);
-		val &= ~USB_PORTSC1_PTS(~0);
-		writel(val, base + USB_PORTSC1);
-	}
+	if (!phy->is_legacy_phy)
+		tegra_ehci_set_pts(&phy->u_phy, 0);
 
 	return 0;
 }
@@ -611,10 +589,6 @@ static int ulpi_phy_power_on(struct tegra_usb_phy *phy)
 		return ret;
 	}
 
-	val = readl(base + USB_PORTSC1);
-	val |= USB_PORTSC1_WKOC | USB_PORTSC1_WKDS | USB_PORTSC1_WKCN;
-	writel(val, base + USB_PORTSC1);
-
 	val = readl(base + USB_SUSP_CTRL);
 	val |= USB_SUSP_CLR;
 	writel(val, base + USB_SUSP_CTRL);
@@ -629,17 +603,8 @@ static int ulpi_phy_power_on(struct tegra_usb_phy *phy)
 
 static int ulpi_phy_power_off(struct tegra_usb_phy *phy)
 {
-	unsigned long val;
-	void __iomem *base = phy->regs;
 	struct tegra_ulpi_config *config = phy->config;
 
-	/* Clear WKCN/WKDS/WKOC wake-on events that can cause the USB
-	 * Controller to immediately bring the ULPI PHY out of low power
-	 */
-	val = readl(base + USB_PORTSC1);
-	val &= ~(USB_PORTSC1_WKOC | USB_PORTSC1_WKDS | USB_PORTSC1_WKCN);
-	writel(val, base + USB_PORTSC1);
-
 	clk_disable(phy->clk);
 	return gpio_direction_output(config->reset_gpio, 0);
 }
@@ -742,6 +707,11 @@ struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instance,
 	phy->dev = dev;
 	phy->is_legacy_phy =
 		of_property_read_bool(np, "nvidia,has-legacy-mode");
+	err = of_property_match_string(np, "phy_type", "ulpi");
+	if (err < 0)
+		phy->is_ulpi_phy = false;
+	else
+		phy->is_ulpi_phy = true;
 
 	if (!phy->config) {
 		if (phy->is_ulpi_phy) {
diff --git a/include/linux/usb/tegra_usb_phy.h b/include/linux/usb/tegra_usb_phy.h
index a6a89d4..9259d46 100644
--- a/include/linux/usb/tegra_usb_phy.h
+++ b/include/linux/usb/tegra_usb_phy.h
@@ -75,4 +75,8 @@ void tegra_ehci_phy_restore_start(struct tegra_usb_phy *phy,
 
 void tegra_ehci_phy_restore_end(struct tegra_usb_phy *phy);
 
+void tegra_ehci_set_pts(struct usb_phy *x, u8 pts_val);
+
+void tegra_ehci_set_phcd(struct usb_phy *x, bool enable);
+
 #endif /* __TEGRA_USB_PHY_H */
-- 
1.7.0.4

