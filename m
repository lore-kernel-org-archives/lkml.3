Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab3DWQcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:32:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64943 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757425Ab3DWQcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:32:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Venu Byravarasu <vbyravarasu@nvidia.com>,
        Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@nvidia.com>, linux-usb@vger.kernel.org
Subject: [PATCH 18/21] usb: phy: tegra: don't call into tegra-ehci directly
Date: Tue, 23 Apr 2013 18:30:50 +0200
Message-Id: <1366734653-488286-19-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366734653-488286-1-git-send-email-arnd@arndb.de>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:HsDOiLVfv9kN0cQqpDtGACkD747w0cQCZB9D9C7IQaM
 IJ7fLr63yX+BAPQwC7ZZwEAHkEo0JlxdyzCK0dNCMvzFLADdI/
 /alFdQazpY60Hfl02IHuEo56t/RP/X9lu9WJPxJENgyDWKSDBU
 7bR2IHeVJ152dfqqRmZzC8Ij6RqvauF9j9nJSYxYISfqCn926b
 0Kun7/odYNjO9sGU/ZKiBjAiqKk+frDci3xcTJlc8vDv1jAx17
 yBXHfVHiCDSpkdpYXs1ynnOnPT+eQKIxjfmH2A/D907YB476XI
 gCnGNGgDiPpjOUV6yZwpoRUA4V/st5a0lEv8zFXtwWmonIo+r3
 Ug2zCYvVeoYLCyxWxUSvIcDZzx4gx87rcBGILBpxw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both phy-tegra-usb.c and ehci-tegra.c export symbols used by the other one,
which does not work if one of them or both are loadable modules, resulting
in an error like:

drivers/built-in.o: In function `utmi_phy_clk_disable':
drivers/usb/phy/phy-tegra-usb.c:302: undefined reference to `tegra_ehci_set_phcd'
drivers/built-in.o: In function `utmi_phy_clk_enable':
drivers/usb/phy/phy-tegra-usb.c:324: undefined reference to `tegra_ehci_set_phcd'
drivers/built-in.o: In function `utmi_phy_power_on':
drivers/usb/phy/phy-tegra-usb.c:447: undefined reference to `tegra_ehci_set_pts'

This turns the interface into a one-way dependency by letting the tegra ehci
driver pass two function pointers for callbacks that need to be called by
the phy driver.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/host/ehci-tegra.c     | 10 +++++-----
 drivers/usb/phy/tegra_usb_phy.c   | 13 +++++++++----
 include/linux/usb/tegra_usb_phy.h | 10 +++++-----
 3 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index 568aecc..07419e4 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -610,7 +610,7 @@ static const struct dev_pm_ops tegra_ehci_pm_ops = {
 /* Bits of PORTSC1, which will get cleared by writing 1 into them */
 #define TEGRA_PORTSC1_RWC_BITS (PORT_CSC | PORT_PEC | PORT_OCC)
 
-void tegra_ehci_set_pts(struct usb_phy *x, u8 pts_val)
+static void tegra_ehci_set_pts(struct usb_phy *x, u8 pts_val)
 {
 	unsigned long val;
 	struct usb_hcd *hcd = bus_to_hcd(x->otg->host);
@@ -621,9 +621,8 @@ void tegra_ehci_set_pts(struct usb_phy *x, u8 pts_val)
 	val |= TEGRA_USB_PORTSC1_PTS(pts_val & 3);
 	writel(val, base + TEGRA_USB_PORTSC1);
 }
-EXPORT_SYMBOL_GPL(tegra_ehci_set_pts);
 
-void tegra_ehci_set_phcd(struct usb_phy *x, bool enable)
+static void tegra_ehci_set_phcd(struct usb_phy *x, bool enable)
 {
 	unsigned long val;
 	struct usb_hcd *hcd = bus_to_hcd(x->otg->host);
@@ -636,7 +635,6 @@ void tegra_ehci_set_phcd(struct usb_phy *x, bool enable)
 		val &= ~TEGRA_USB_PORTSC1_PHCD;
 	writel(val, base + TEGRA_USB_PORTSC1);
 }
-EXPORT_SYMBOL_GPL(tegra_ehci_set_phcd);
 
 static u64 tegra_ehci_dma_mask = DMA_BIT_MASK(32);
 
@@ -733,7 +731,9 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 
 	tegra->phy = tegra_usb_phy_open(&pdev->dev, instance, hcd->regs,
 					pdata->phy_config,
-					TEGRA_USB_PHY_MODE_HOST);
+					TEGRA_USB_PHY_MODE_HOST,
+					&tegra_ehci_set_pts,
+					tegra_ehci_set_phcd);
 	if (IS_ERR(tegra->phy)) {
 		dev_err(&pdev->dev, "Failed to open USB phy\n");
 		err = -ENXIO;
diff --git a/drivers/usb/phy/tegra_usb_phy.c b/drivers/usb/phy/tegra_usb_phy.c
index 5487d38..17d8112 100644
--- a/drivers/usb/phy/tegra_usb_phy.c
+++ b/drivers/usb/phy/tegra_usb_phy.c
@@ -299,7 +299,7 @@ static void utmi_phy_clk_disable(struct tegra_usb_phy *phy)
 		val &= ~USB_SUSP_SET;
 		writel(val, base + USB_SUSP_CTRL);
 	} else
-		tegra_ehci_set_phcd(&phy->u_phy, true);
+		phy->set_phcd(&phy->u_phy, true);
 
 	if (utmi_wait_register(base + USB_SUSP_CTRL, USB_PHY_CLK_VALID, 0) < 0)
 		pr_err("%s: timeout waiting for phy to stabilize\n", __func__);
@@ -321,7 +321,7 @@ static void utmi_phy_clk_enable(struct tegra_usb_phy *phy)
 		val &= ~USB_SUSP_CLR;
 		writel(val, base + USB_SUSP_CTRL);
 	} else
-		tegra_ehci_set_phcd(&phy->u_phy, false);
+		phy->set_phcd(&phy->u_phy, false);
 
 	if (utmi_wait_register(base + USB_SUSP_CTRL, USB_PHY_CLK_VALID,
 						     USB_PHY_CLK_VALID))
@@ -444,7 +444,7 @@ static int utmi_phy_power_on(struct tegra_usb_phy *phy)
 	utmi_phy_clk_enable(phy);
 
 	if (!phy->is_legacy_phy)
-		tegra_ehci_set_pts(&phy->u_phy, 0);
+		phy->set_pts(&phy->u_phy, 0);
 
 	return 0;
 }
@@ -688,7 +688,10 @@ static int	tegra_usb_phy_suspend(struct usb_phy *x, int suspend)
 }
 
 struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instance,
-	void __iomem *regs, void *config, enum tegra_usb_phy_mode phy_mode)
+	void __iomem *regs, void *config, enum tegra_usb_phy_mode phy_mode,
+	void (*set_pts)(struct usb_phy *x, u8 pts_val),
+	void (*set_phcd)(struct usb_phy *x, bool enable))
+
 {
 	struct tegra_usb_phy *phy;
 	unsigned long parent_rate;
@@ -707,6 +710,8 @@ struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instance,
 	phy->dev = dev;
 	phy->is_legacy_phy =
 		of_property_read_bool(np, "nvidia,has-legacy-mode");
+	phy->set_pts = set_pts;
+	phy->set_phcd = set_phcd;
 	err = of_property_match_string(np, "phy_type", "ulpi");
 	if (err < 0)
 		phy->is_ulpi_phy = false;
diff --git a/include/linux/usb/tegra_usb_phy.h b/include/linux/usb/tegra_usb_phy.h
index 9ebebe9..1b7519a 100644
--- a/include/linux/usb/tegra_usb_phy.h
+++ b/include/linux/usb/tegra_usb_phy.h
@@ -61,10 +61,14 @@ struct tegra_usb_phy {
 	struct device *dev;
 	bool is_legacy_phy;
 	bool is_ulpi_phy;
+	void (*set_pts)(struct usb_phy *x, u8 pts_val);
+	void (*set_phcd)(struct usb_phy *x, bool enable);
 };
 
 struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instance,
-	void __iomem *regs, void *config, enum tegra_usb_phy_mode phy_mode);
+	void __iomem *regs, void *config, enum tegra_usb_phy_mode phy_mode,
+	void (*set_pts)(struct usb_phy *x, u8 pts_val),
+	void (*set_phcd)(struct usb_phy *x, bool enable));
 
 void tegra_usb_phy_preresume(struct usb_phy *phy);
 
@@ -75,8 +79,4 @@ void tegra_ehci_phy_restore_start(struct usb_phy *phy,
 
 void tegra_ehci_phy_restore_end(struct usb_phy *phy);
 
-void tegra_ehci_set_pts(struct usb_phy *x, u8 pts_val);
-
-void tegra_ehci_set_phcd(struct usb_phy *x, bool enable);
-
 #endif /* __TEGRA_USB_PHY_H */
-- 
1.8.1.2

