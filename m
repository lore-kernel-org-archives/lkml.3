Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab3F1Vik (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 17:38:40 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13555 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab3F1ViO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 17:38:14 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 28 Jun 2013 14:38:06 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <balbi@ti.com>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <swarren@wwwdotorg.org>,
        <gregkh@linuxfoundation.org>, Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH 9/9] usb: phy: tegra: Use DT helpers for dr_mode
Date: Sat, 29 Jun 2013 00:37:07 +0300
Message-ID: <1372455427-20898-10-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1372455427-20898-1-git-send-email-ttynkkynen@nvidia.com>
References: <1372455427-20898-1-git-send-email-ttynkkynen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new of_usb_get_dr_mode helper function for parsing dr_mode
from the device tree. Also replace the usage of the custom
tegra_usb_phy_mode enum with the standard enum.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
 drivers/usb/phy/phy-tegra-usb.c   | 20 ++++++++------------
 include/linux/usb/tegra_usb_phy.h |  8 +-------
 2 files changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/usb/phy/phy-tegra-usb.c b/drivers/usb/phy/phy-tegra-usb.c
index 13049ce..32d4394 100644
--- a/drivers/usb/phy/phy-tegra-usb.c
+++ b/drivers/usb/phy/phy-tegra-usb.c
@@ -377,7 +377,7 @@ static int utmi_phy_power_on(struct tegra_usb_phy *phy)
 		UTMIP_PLLU_ENABLE_DLY_COUNT(phy->freq->enable_delay);
 	writel(val, base + UTMIP_PLL_CFG1);
 
-	if (phy->mode == TEGRA_USB_PHY_MODE_DEVICE) {
+	if (phy->mode == USB_DR_MODE_PERIPHERAL) {
 		val = readl(base + USB_SUSP_CTRL);
 		val &= ~(USB_WAKE_ON_CNNT_EN_DEV | USB_WAKE_ON_DISCON_EN_DEV);
 		writel(val, base + USB_SUSP_CTRL);
@@ -412,7 +412,7 @@ static int utmi_phy_power_on(struct tegra_usb_phy *phy)
 
 	if (phy->is_legacy_phy) {
 		val = readl(base + UTMIP_SPARE_CFG0);
-		if (phy->mode == TEGRA_USB_PHY_MODE_DEVICE)
+		if (phy->mode == USB_DR_MODE_PERIPHERAL)
 			val &= ~FUSE_SETUP_SEL;
 		else
 			val |= FUSE_SETUP_SEL;
@@ -453,7 +453,7 @@ static int utmi_phy_power_off(struct tegra_usb_phy *phy)
 
 	utmi_phy_clk_disable(phy);
 
-	if (phy->mode == TEGRA_USB_PHY_MODE_DEVICE) {
+	if (phy->mode == USB_DR_MODE_PERIPHERAL) {
 		val = readl(base + USB_SUSP_CTRL);
 		val &= ~USB_WAKEUP_DEBOUNCE_COUNT(~0);
 		val |= USB_WAKE_ON_CNNT_EN_DEV | USB_WAKEUP_DEBOUNCE_COUNT(5);
@@ -906,15 +906,11 @@ static int tegra_usb_phy_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	err = of_property_match_string(np, "dr_mode", "otg");
-	if (err < 0) {
-		err = of_property_match_string(np, "dr_mode", "peripheral");
-		if (err < 0)
-			tegra_phy->mode = TEGRA_USB_PHY_MODE_HOST;
-		else
-			tegra_phy->mode = TEGRA_USB_PHY_MODE_DEVICE;
-	} else
-		tegra_phy->mode = TEGRA_USB_PHY_MODE_OTG;
+	tegra_phy->mode = of_usb_get_dr_mode(np);
+	if (tegra_phy->mode == USB_DR_MODE_UNKNOWN) {
+		dev_err(&pdev->dev, "dr_mode is invalid\n");
+		return -EINVAL;
+	}
 
 	/* On some boards, the VBUS regulator doesn't need to be controlled */
 	if (of_find_property(np, "vbus-supply", NULL)) {
diff --git a/include/linux/usb/tegra_usb_phy.h b/include/linux/usb/tegra_usb_phy.h
index a095c98..d3db274 100644
--- a/include/linux/usb/tegra_usb_phy.h
+++ b/include/linux/usb/tegra_usb_phy.h
@@ -34,12 +34,6 @@ enum tegra_usb_phy_port_speed {
 	TEGRA_USB_PHY_PORT_SPEED_HIGH,
 };
 
-enum tegra_usb_phy_mode {
-	TEGRA_USB_PHY_MODE_DEVICE,
-	TEGRA_USB_PHY_MODE_HOST,
-	TEGRA_USB_PHY_MODE_OTG,
-};
-
 struct tegra_xtal_freq;
 
 struct tegra_usb_phy {
@@ -51,7 +45,7 @@ struct tegra_usb_phy {
 	struct clk *pll_u;
 	struct clk *pad_clk;
 	struct regulator *vbus;
-	enum tegra_usb_phy_mode mode;
+	enum usb_dr_mode mode;
 	void *config;
 	struct usb_phy *ulpi;
 	struct usb_phy u_phy;
-- 
1.8.1.5

