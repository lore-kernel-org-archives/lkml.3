Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558Ab3APNaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 08:30:35 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8183 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104Ab3APNab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 08:30:31 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 16 Jan 2013 05:29:19 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <gregkh@linuxfoundation.org>, <balbi@ti.com>, <stern@rowland.harvard.edu>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <swarren@wwwdotorg.org>, <linux-doc@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH 2/4] USB: PHY: Get rid of instance number to differentiate legacy controller
Date: Wed, 16 Jan 2013 19:00:20 +0530
Message-ID: <1358343022-28919-3-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1358343022-28919-1-git-send-email-vbyravarasu@nvidia.com>
References: <1358343022-28919-1-git-send-email-vbyravarasu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra20 USB has 3 PHY instances. Instance 0 is based on
legacy PHY interface and other two are standard interfaces.

As instance number was used to differentiate legacy from
standard interfaces, used DT param to get this info and
processed accordingly.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 drivers/usb/phy/tegra_usb_phy.c   |   32 +++++++++++++++-----------------
 include/linux/usb/tegra_usb_phy.h |    1 +
 2 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/phy/tegra_usb_phy.c b/drivers/usb/phy/tegra_usb_phy.c
index 3059384..79280fe 100644
--- a/drivers/usb/phy/tegra_usb_phy.c
+++ b/drivers/usb/phy/tegra_usb_phy.c
@@ -24,6 +24,7 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/gpio.h>
+#include <linux/of.h>
 #include <linux/of_gpio.h>
 #include <linux/usb/otg.h>
 #include <linux/usb/ulpi.h>
@@ -221,7 +222,7 @@ static int utmip_pad_open(struct tegra_usb_phy *phy)
 		return PTR_ERR(phy->pad_clk);
 	}
 
-	if (phy->instance == 0) {
+	if (phy->is_legacy_phy) {
 		phy->pad_regs = phy->regs;
 	} else {
 		phy->pad_regs = ioremap(TEGRA_USB_BASE, TEGRA_USB_SIZE);
@@ -236,7 +237,7 @@ static int utmip_pad_open(struct tegra_usb_phy *phy)
 
 static void utmip_pad_close(struct tegra_usb_phy *phy)
 {
-	if (phy->instance != 0)
+	if (!phy->is_legacy_phy)
 		iounmap(phy->pad_regs);
 	clk_put(phy->pad_clk);
 }
@@ -305,7 +306,7 @@ static void utmi_phy_clk_disable(struct tegra_usb_phy *phy)
 	unsigned long val;
 	void __iomem *base = phy->regs;
 
-	if (phy->instance == 0) {
+	if (phy->is_legacy_phy) {
 		val = readl(base + USB_SUSP_CTRL);
 		val |= USB_SUSP_SET;
 		writel(val, base + USB_SUSP_CTRL);
@@ -315,9 +316,7 @@ static void utmi_phy_clk_disable(struct tegra_usb_phy *phy)
 		val = readl(base + USB_SUSP_CTRL);
 		val &= ~USB_SUSP_SET;
 		writel(val, base + USB_SUSP_CTRL);
-	}
-
-	if (phy->instance == 2) {
+	} else {
 		val = readl(base + USB_PORTSC1);
 		val |= USB_PORTSC1_PHCD;
 		writel(val, base + USB_PORTSC1);
@@ -332,7 +331,7 @@ static void utmi_phy_clk_enable(struct tegra_usb_phy *phy)
 	unsigned long val;
 	void __iomem *base = phy->regs;
 
-	if (phy->instance == 0) {
+	if (phy->is_legacy_phy) {
 		val = readl(base + USB_SUSP_CTRL);
 		val |= USB_SUSP_CLR;
 		writel(val, base + USB_SUSP_CTRL);
@@ -342,9 +341,7 @@ static void utmi_phy_clk_enable(struct tegra_usb_phy *phy)
 		val = readl(base + USB_SUSP_CTRL);
 		val &= ~USB_SUSP_CLR;
 		writel(val, base + USB_SUSP_CTRL);
-	}
-
-	if (phy->instance == 2) {
+	} else {
 		val = readl(base + USB_PORTSC1);
 		val &= ~USB_PORTSC1_PHCD;
 		writel(val, base + USB_PORTSC1);
@@ -365,7 +362,7 @@ static int utmi_phy_power_on(struct tegra_usb_phy *phy)
 	val |= UTMIP_RESET;
 	writel(val, base + USB_SUSP_CTRL);
 
-	if (phy->instance == 0) {
+	if (phy->is_legacy_phy) {
 		val = readl(base + USB1_LEGACY_CTRL);
 		val |= USB1_NO_LEGACY_MODE;
 		writel(val, base + USB1_LEGACY_CTRL);
@@ -440,16 +437,14 @@ static int utmi_phy_power_on(struct tegra_usb_phy *phy)
 	val |= UTMIP_BIAS_PDTRK_COUNT(0x5);
 	writel(val, base + UTMIP_BIAS_CFG1);
 
-	if (phy->instance == 0) {
+	if (phy->is_legacy_phy) {
 		val = readl(base + UTMIP_SPARE_CFG0);
 		if (phy->mode == TEGRA_USB_PHY_MODE_DEVICE)
 			val &= ~FUSE_SETUP_SEL;
 		else
 			val |= FUSE_SETUP_SEL;
 		writel(val, base + UTMIP_SPARE_CFG0);
-	}
-
-	if (phy->instance == 2) {
+	} else {
 		val = readl(base + USB_SUSP_CTRL);
 		val |= UTMIP_PHY_ENABLE;
 		writel(val, base + USB_SUSP_CTRL);
@@ -459,7 +454,7 @@ static int utmi_phy_power_on(struct tegra_usb_phy *phy)
 	val &= ~UTMIP_RESET;
 	writel(val, base + USB_SUSP_CTRL);
 
-	if (phy->instance == 0) {
+	if (phy->is_legacy_phy) {
 		val = readl(base + USB1_LEGACY_CTRL);
 		val &= ~USB1_VBUS_SENSE_CTL_MASK;
 		val |= USB1_VBUS_SENSE_CTL_A_SESS_VLD;
@@ -472,7 +467,7 @@ static int utmi_phy_power_on(struct tegra_usb_phy *phy)
 
 	utmi_phy_clk_enable(phy);
 
-	if (phy->instance == 2) {
+	if (!phy->is_legacy_phy) {
 		val = readl(base + USB_PORTSC1);
 		val &= ~USB_PORTSC1_PTS(~0);
 		writel(val, base + USB_PORTSC1);
@@ -739,6 +734,7 @@ struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instance,
 	unsigned long parent_rate;
 	int i;
 	int err;
+	struct device_node *np = dev->of_node;
 
 	phy = kzalloc(sizeof(struct tegra_usb_phy), GFP_KERNEL);
 	if (!phy)
@@ -749,6 +745,8 @@ struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instance,
 	phy->config = config;
 	phy->mode = phy_mode;
 	phy->dev = dev;
+	phy->is_legacy_phy =
+		of_property_read_bool(np, "nvidia,has-legacy-mode");
 
 	if (!phy->config) {
 		if (phy_is_ulpi(phy)) {
diff --git a/include/linux/usb/tegra_usb_phy.h b/include/linux/usb/tegra_usb_phy.h
index 34e6355..f03e157 100644
--- a/include/linux/usb/tegra_usb_phy.h
+++ b/include/linux/usb/tegra_usb_phy.h
@@ -59,6 +59,7 @@ struct tegra_usb_phy {
 	struct usb_phy *ulpi;
 	struct usb_phy u_phy;
 	struct device *dev;
+	bool is_legacy_phy;
 };
 
 struct tegra_usb_phy *tegra_usb_phy_open(struct device *dev, int instance,
-- 
1.7.0.4

