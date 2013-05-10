Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab3EJODu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:03:50 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11818 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab3EJODr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:03:47 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 10 May 2013 07:00:20 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <gregkh@linuxfoundation.org>, <swarren@wwwdotorg.org>, <balbi@ti.com>,
        <stern@rowland.harvard.edu>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH v3 10/10] Usb: Move PORTSC access to PHY
Date: Fri, 10 May 2013 19:24:11 +0530
Message-ID: <1368194051-4925-11-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1368194051-4925-1-git-send-email-vbyravarasu@nvidia.com>
References: <1368194051-4925-1-git-send-email-vbyravarasu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes with this patch:
1. As PHY is being registered as separate platform driver & EHCI Tegra
is no more calling PHY open, moved tegra_ehci_set_pts & tegra_ehci_set_phcd
functions to PHY driver,

2. Removed unused defines for multiple USB port base addresses

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
This is a new patch being added into the series, to address the revert done
with patch#4 of the series.

 drivers/usb/host/ehci-tegra.c     |   49 -------------------------------------
 drivers/usb/phy/phy-tegra-usb.c   |   37 +++++++++++++++++++++++++--
 include/linux/usb/tegra_usb_phy.h |    4 ---
 3 files changed, 34 insertions(+), 56 deletions(-)

diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index 406abd9..2340d7a 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -30,15 +30,6 @@
 #include <linux/usb/tegra_usb_phy.h>
 #include <linux/clk/tegra.h>
 
-#define TEGRA_USB_BASE			0xC5000000
-#define TEGRA_USB2_BASE			0xC5004000
-#define TEGRA_USB3_BASE			0xC5008000
-
-/* PORTSC registers */
-#define TEGRA_USB_PORTSC1			0x184
-#define TEGRA_USB_PORTSC1_PTS(x)	(((x) & 0x3) << 30)
-#define TEGRA_USB_PORTSC1_PHCD	(1 << 23)
-
 #define TEGRA_USB_DMA_ALIGN 32
 
 struct tegra_ehci_hcd {
@@ -608,37 +599,6 @@ static const struct dev_pm_ops tegra_ehci_pm_ops = {
 
 #endif
 
-/* Bits of PORTSC1, which will get cleared by writing 1 into them */
-#define TEGRA_PORTSC1_RWC_BITS (PORT_CSC | PORT_PEC | PORT_OCC)
-
-void tegra_ehci_set_pts(struct usb_phy *x, u8 pts_val)
-{
-	unsigned long val;
-	struct usb_hcd *hcd = bus_to_hcd(x->otg->host);
-	void __iomem *base = hcd->regs;
-
-	val = readl(base + TEGRA_USB_PORTSC1) & ~TEGRA_PORTSC1_RWC_BITS;
-	val &= ~TEGRA_USB_PORTSC1_PTS(3);
-	val |= TEGRA_USB_PORTSC1_PTS(pts_val & 3);
-	writel(val, base + TEGRA_USB_PORTSC1);
-}
-EXPORT_SYMBOL_GPL(tegra_ehci_set_pts);
-
-void tegra_ehci_set_phcd(struct usb_phy *x, bool enable)
-{
-	unsigned long val;
-	struct usb_hcd *hcd = bus_to_hcd(x->otg->host);
-	void __iomem *base = hcd->regs;
-
-	val = readl(base + TEGRA_USB_PORTSC1) & ~TEGRA_PORTSC1_RWC_BITS;
-	if (enable)
-		val |= TEGRA_USB_PORTSC1_PHCD;
-	else
-		val &= ~TEGRA_USB_PORTSC1_PHCD;
-	writel(val, base + TEGRA_USB_PORTSC1);
-}
-EXPORT_SYMBOL_GPL(tegra_ehci_set_phcd);
-
 static u64 tegra_ehci_dma_mask = DMA_BIT_MASK(32);
 
 static int tegra_ehci_probe(struct platform_device *pdev)
@@ -731,15 +691,6 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 		goto cleanup_hcd_create;
 	}
 
-	u_phy->otg = devm_kzalloc(&pdev->dev, sizeof(struct usb_otg),
-			     GFP_KERNEL);
-	if (!u_phy->otg) {
-		dev_err(&pdev->dev, "Failed to alloc memory for otg\n");
-		err = -ENOMEM;
-		goto cleanup_phy;
-	}
-	u_phy->otg->host = hcd_to_bus(hcd);
-
 	err = usb_phy_set_suspend(hcd->phy, 0);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to power on the phy\n");
diff --git a/drivers/usb/phy/phy-tegra-usb.c b/drivers/usb/phy/phy-tegra-usb.c
index 4d81b19..b2a909f 100644
--- a/drivers/usb/phy/phy-tegra-usb.c
+++ b/drivers/usb/phy/phy-tegra-usb.c
@@ -33,6 +33,7 @@
 #include <asm/mach-types.h>
 #include <linux/usb/tegra_usb_phy.h>
 #include <linux/module.h>
+#include <linux/usb/ehci_def.h>
 
 #define ULPI_VIEWPORT		0x170
 
@@ -196,6 +197,36 @@ static struct tegra_utmip_config utmip_default[] = {
 	},
 };
 
+/* PORTSC registers */
+#define TEGRA_USB_PORTSC1			0x184
+#define TEGRA_USB_PORTSC1_PTS(x)	(((x) & 0x3) << 30)
+#define TEGRA_USB_PORTSC1_PHCD	(1 << 23)
+
+/* Bits of PORTSC1, which will get cleared by writing 1 into them */
+#define TEGRA_PORTSC1_RWC_BITS (PORT_CSC | PORT_PEC | PORT_OCC)
+
+static void tegra_ehci_set_pts(void __iomem *base, u8 pts_val)
+{
+	unsigned long val;
+
+	val = readl(base + TEGRA_USB_PORTSC1) & ~TEGRA_PORTSC1_RWC_BITS;
+	val &= ~TEGRA_USB_PORTSC1_PTS(3);
+	val |= TEGRA_USB_PORTSC1_PTS(pts_val & 3);
+	writel(val, base + TEGRA_USB_PORTSC1);
+}
+
+static void tegra_ehci_set_phcd(void __iomem *base, bool enable)
+{
+	unsigned long val;
+
+	val = readl(base + TEGRA_USB_PORTSC1) & ~TEGRA_PORTSC1_RWC_BITS;
+	if (enable)
+		val |= TEGRA_USB_PORTSC1_PHCD;
+	else
+		val &= ~TEGRA_USB_PORTSC1_PHCD;
+	writel(val, base + TEGRA_USB_PORTSC1);
+}
+
 static int utmip_pad_open(struct tegra_usb_phy *phy)
 {
 	phy->pad_clk = devm_clk_get(phy->dev, "utmi-pads");
@@ -282,7 +313,7 @@ static void utmi_phy_clk_disable(struct tegra_usb_phy *phy)
 		val &= ~USB_SUSP_SET;
 		writel(val, base + USB_SUSP_CTRL);
 	} else
-		tegra_ehci_set_phcd(&phy->u_phy, true);
+		tegra_ehci_set_phcd(base, true);
 
 	if (utmi_wait_register(base + USB_SUSP_CTRL, USB_PHY_CLK_VALID, 0) < 0)
 		pr_err("%s: timeout waiting for phy to stabilize\n", __func__);
@@ -304,7 +335,7 @@ static void utmi_phy_clk_enable(struct tegra_usb_phy *phy)
 		val &= ~USB_SUSP_CLR;
 		writel(val, base + USB_SUSP_CTRL);
 	} else
-		tegra_ehci_set_phcd(&phy->u_phy, false);
+		tegra_ehci_set_phcd(base, false);
 
 	if (utmi_wait_register(base + USB_SUSP_CTRL, USB_PHY_CLK_VALID,
 						     USB_PHY_CLK_VALID))
@@ -427,7 +458,7 @@ static int utmi_phy_power_on(struct tegra_usb_phy *phy)
 	utmi_phy_clk_enable(phy);
 
 	if (!phy->is_legacy_phy)
-		tegra_ehci_set_pts(&phy->u_phy, 0);
+		tegra_ehci_set_pts(base, 0);
 
 	return 0;
 }
diff --git a/include/linux/usb/tegra_usb_phy.h b/include/linux/usb/tegra_usb_phy.h
index 0cd15d2..d2ca919 100644
--- a/include/linux/usb/tegra_usb_phy.h
+++ b/include/linux/usb/tegra_usb_phy.h
@@ -76,8 +76,4 @@ void tegra_ehci_phy_restore_start(struct usb_phy *phy,
 
 void tegra_ehci_phy_restore_end(struct usb_phy *phy);
 
-void tegra_ehci_set_pts(struct usb_phy *x, u8 pts_val);
-
-void tegra_ehci_set_phcd(struct usb_phy *x, bool enable);
-
 #endif /* __TEGRA_USB_PHY_H */
-- 
1.7.0.4

