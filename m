Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab3EJODS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:03:18 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7071 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab3EJODO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:03:14 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 10 May 2013 07:03:07 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <gregkh@linuxfoundation.org>, <swarren@wwwdotorg.org>, <balbi@ti.com>,
        <stern@rowland.harvard.edu>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH v3 04/10] Revert "usb: phy: tegra: don't call into tegra-ehci directly"
Date: Fri, 10 May 2013 19:24:05 +0530
Message-ID: <1368194051-4925-5-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1368194051-4925-1-git-send-email-vbyravarasu@nvidia.com>
References: <1368194051-4925-1-git-send-email-vbyravarasu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit ee5d5499edb94cd03738a52a7e234b139da8fd72.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
As PHY is being registered as separate driver, solution proposed with
this patch cannot work anymore.
Hence pushed patch 10 of this series to address the issue.

 drivers/usb/host/ehci-tegra.c     |   10 +++++-----
 drivers/usb/phy/phy-tegra-usb.c   |   13 ++++---------
 include/linux/usb/tegra_usb_phy.h |   10 +++++-----
 3 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index e3eddc3..ed201ae 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -611,7 +611,7 @@ static const struct dev_pm_ops tegra_ehci_pm_ops = {
 /* Bits of PORTSC1, which will get cleared by writing 1 into them */
 #define TEGRA_PORTSC1_RWC_BITS (PORT_CSC | PORT_PEC | PORT_OCC)
 
-static void tegra_ehci_set_pts(struct usb_phy *x, u8 pts_val)
+void tegra_ehci_set_pts(struct usb_phy *x, u8 pts_val)
 {
 	unsigned long val;
 	struct usb_hcd *hcd = bus_to_hcd(x->otg->host);
@@ -622,8 +622,9 @@ static void tegra_ehci_set_pts(struct usb_phy *x, u8 pts_val)
 	val |= TEGRA_USB_PORTSC1_PTS(pts_val & 3);
 	writel(val, base + TEGRA_USB_PORTSC1);
 }
+EXPORT_SYMBOL_GPL(tegra_ehci_set_pts);
 
-static void tegra_ehci_set_phcd(struct usb_phy *x, bool enable)
+void tegra_ehci_set_phcd(struct usb_phy *x, bool enable)
 {
 	unsigned long val;
 	struct usb_hcd *hcd = bus_to_hcd(x->otg->host);
@@ -636,6 +637,7 @@ static void tegra_ehci_set_phcd(struct usb_phy *x, bool enable)
 		val &= ~TEGRA_USB_PORTSC1_PHCD;
 	writel(val, base + TEGRA_USB_PORTSC1);
 }
+EXPORT_SYMBOL_GPL(tegra_ehci_set_phcd);
 
 static u64 tegra_ehci_dma_mask = DMA_BIT_MASK(32);
 
@@ -736,9 +738,7 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 
 	tegra->phy = tegra_usb_phy_open(&pdev->dev, instance, hcd->regs,
 					pdata->phy_config,
-					TEGRA_USB_PHY_MODE_HOST,
-					tegra_ehci_set_pts,
-					tegra_ehci_set_phcd);
+					TEGRA_USB_PHY_MODE_HOST);
 	if (IS_ERR(tegra->phy)) {
 		dev_err(&pdev->dev, "Failed to open USB phy\n");
 		err = -ENXIO;
diff --git a/drivers/usb/phy/phy-tegra-usb.c b/drivers/usb/phy/phy-tegra-usb.c
index 17d8112..5487d38 100644
--- a/drivers/usb/phy/phy-tegra-usb.c
+++ b/drivers/usb/phy/phy-tegra-usb.c
@@ -299,7 +299,7 @@ static void utmi_phy_clk_disable(struct tegra_usb_phy *phy)
 		val &= ~USB_SUSP_SET;
 		writel(val, base + USB_SUSP_CTRL);
 	} else
-		phy->set_phcd(&phy->u_phy, true);
+		tegra_ehci_set_phcd(&phy->u_phy, true);
 
 	if (utmi_wait_register(base + USB_SUSP_CTRL, USB_PHY_CLK_VALID, 0) < 0)
 		pr_err("%s: timeout waiting for phy to stabilize\n", __func__);
@@ -321,7 +321,7 @@ static void utmi_phy_clk_enable(struct tegra_usb_phy *phy)
 		val &= ~USB_SUSP_CLR;
 		writel(val, base + USB_SUSP_CTRL);
 	} else
-		phy->set_phcd(&phy->u_phy, false);
+		tegra_ehci_set_phcd(&phy->u_phy, false);
 
 	if (utmi_wait_register(base + USB_SUSP_CTRL, USB_PHY_CLK_VALID,
 						     USB_PHY_CLK_VALID))
@@ -444,7 +444,7 @@ static int utmi_phy_power_on(struct tegra_usb_phy *phy)
 	utmi_phy_clk_enable(phy);
 
 	if (!phy->is_legacy_phy)
-		phy->set_pts(&phy->u_phy, 0);
+		tegra_ehci_set_pts(&phy->u_phy, 0);
 
 	return 0;
 }
@@ -688,10 +688,7 @@ static int	tegra_usb_phy_suspend(struct usb_phy *x, int suspend)
 }
 
 struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instance,
-	void __iomem *regs, void *config, enum tegra_usb_phy_mode phy_mode,
-	void (*set_pts)(struct usb_phy *x, u8 pts_val),
-	void (*set_phcd)(struct usb_phy *x, bool enable))
-
+	void __iomem *regs, void *config, enum tegra_usb_phy_mode phy_mode)
 {
 	struct tegra_usb_phy *phy;
 	unsigned long parent_rate;
@@ -710,8 +707,6 @@ struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instance,
 	phy->dev = dev;
 	phy->is_legacy_phy =
 		of_property_read_bool(np, "nvidia,has-legacy-mode");
-	phy->set_pts = set_pts;
-	phy->set_phcd = set_phcd;
 	err = of_property_match_string(np, "phy_type", "ulpi");
 	if (err < 0)
 		phy->is_ulpi_phy = false;
diff --git a/include/linux/usb/tegra_usb_phy.h b/include/linux/usb/tegra_usb_phy.h
index 1b7519a..9ebebe9 100644
--- a/include/linux/usb/tegra_usb_phy.h
+++ b/include/linux/usb/tegra_usb_phy.h
@@ -61,14 +61,10 @@ struct tegra_usb_phy {
 	struct device *dev;
 	bool is_legacy_phy;
 	bool is_ulpi_phy;
-	void (*set_pts)(struct usb_phy *x, u8 pts_val);
-	void (*set_phcd)(struct usb_phy *x, bool enable);
 };
 
 struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instance,
-	void __iomem *regs, void *config, enum tegra_usb_phy_mode phy_mode,
-	void (*set_pts)(struct usb_phy *x, u8 pts_val),
-	void (*set_phcd)(struct usb_phy *x, bool enable));
+	void __iomem *regs, void *config, enum tegra_usb_phy_mode phy_mode);
 
 void tegra_usb_phy_preresume(struct usb_phy *phy);
 
@@ -79,4 +75,8 @@ void tegra_ehci_phy_restore_start(struct usb_phy *phy,
 
 void tegra_ehci_phy_restore_end(struct usb_phy *phy);
 
+void tegra_ehci_set_pts(struct usb_phy *x, u8 pts_val);
+
+void tegra_ehci_set_phcd(struct usb_phy *x, bool enable);
+
 #endif /* __TEGRA_USB_PHY_H */
-- 
1.7.0.4

