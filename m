Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581Ab3HLNH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:07:57 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:2390 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756482Ab3HLNHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:07:17 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 12 Aug 2013 06:05:22 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <balbi@ti.com>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <swarren@wwwdotorg.org>,
        <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH v3 5/6] usb: phy: tegra: Program new PHY parameters
Date: Mon, 12 Aug 2013 16:06:53 +0300
Message-ID: <1376312814-18992-6-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1376312814-18992-1-git-send-email-ttynkkynen@nvidia.com>
References: <1376312814-18992-1-git-send-email-ttynkkynen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Tegra30 TRM recommends configuration of certain PHY parameters for
optimal quality. Program the following registers based on device tree
parameters:

- UTMIP_XCVR_HSSLEW: HS slew rate control.
- UTMIP_HSSQUELCH_LEVEL: HS squelch detector level
- UTMIP_HSDISCON_LEVEL: HS disconnect detector level.

These registers exist in Tegra20, but programming them hasn't been
necessary, so these parameters won't be set on Tegra20 to keep the
device trees backward compatible.

Additionally, the UTMIP_XCVR_SETUP parameter can be set from fuses
instead of a software-programmed value, as the optimal value can
vary between invidual boards. The boolean property
nvidia,xcvr-setup-use-fuses can be used to enable this behaviour.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Tested-by: Stephen Warren <swarren@nvidia.com>
Reviewed-by: Stephen Warren <swarren@nvidia.com>
---
v2: Don't touch new PHY params under T20
v2: Change register bitmasks to not contain shifted-out bits
 drivers/usb/phy/phy-tegra-usb.c   | 81 ++++++++++++++++++++++++++++++---------
 include/linux/usb/tegra_usb_phy.h |  4 ++
 2 files changed, 67 insertions(+), 18 deletions(-)

diff --git a/drivers/usb/phy/phy-tegra-usb.c b/drivers/usb/phy/phy-tegra-usb.c
index 1ad184a..3bfb3d1 100644
--- a/drivers/usb/phy/phy-tegra-usb.c
+++ b/drivers/usb/phy/phy-tegra-usb.c
@@ -99,11 +99,15 @@
 #define   UTMIP_FORCE_PD2_POWERDOWN		(1 << 16)
 #define   UTMIP_FORCE_PDZI_POWERDOWN		(1 << 18)
 #define   UTMIP_XCVR_LSBIAS_SEL			(1 << 21)
-#define   UTMIP_XCVR_HSSLEW_MSB(x)		(((x) & 0x7f) << 25)
+#define   UTMIP_XCVR_HSSLEW(x)			(((x) & 0x3) << 4)
+#define   UTMIP_XCVR_HSSLEW_MSB(x)		((((x) & 0x1fc) >> 2) << 25)
 
 #define UTMIP_BIAS_CFG0		0x80c
 #define   UTMIP_OTGPD			(1 << 11)
 #define   UTMIP_BIASPD			(1 << 10)
+#define   UTMIP_HSSQUELCH_LEVEL(x)	(((x) & 0x3) << 0)
+#define   UTMIP_HSDISCON_LEVEL(x)	(((x) & 0x3) << 2)
+#define   UTMIP_HSDISCON_LEVEL_MSB(x)	((((x) & 0x4) >> 2) << 24)
 
 #define UTMIP_HSRX_CFG0		0x810
 #define   UTMIP_ELASTIC_LIMIT(x)	(((x) & 0x1f) << 10)
@@ -255,6 +259,7 @@ static void utmip_pad_power_on(struct tegra_usb_phy *phy)
 {
 	unsigned long val, flags;
 	void __iomem *base = phy->pad_regs;
+	struct tegra_utmip_config *config = phy->config;
 
 	clk_prepare_enable(phy->pad_clk);
 
@@ -263,6 +268,16 @@ static void utmip_pad_power_on(struct tegra_usb_phy *phy)
 	if (utmip_pad_count++ == 0) {
 		val = readl(base + UTMIP_BIAS_CFG0);
 		val &= ~(UTMIP_OTGPD | UTMIP_BIASPD);
+
+		if (phy->soc_config->requires_extra_tuning_parameters) {
+			val &= ~(UTMIP_HSSQUELCH_LEVEL(~0) |
+				UTMIP_HSDISCON_LEVEL(~0) |
+				UTMIP_HSDISCON_LEVEL_MSB(~0));
+
+			val |= UTMIP_HSSQUELCH_LEVEL(config->hssquelch_level);
+			val |= UTMIP_HSDISCON_LEVEL(config->hsdiscon_level);
+			val |= UTMIP_HSDISCON_LEVEL_MSB(config->hsdiscon_level);
+		}
 		writel(val, base + UTMIP_BIAS_CFG0);
 	}
 
@@ -431,12 +446,20 @@ static int utmi_phy_power_on(struct tegra_usb_phy *phy)
 	val &= ~(UTMIP_FORCE_PD_POWERDOWN | UTMIP_FORCE_PD2_POWERDOWN |
 		 UTMIP_FORCE_PDZI_POWERDOWN | UTMIP_XCVR_LSBIAS_SEL |
 		 UTMIP_XCVR_SETUP(~0) | UTMIP_XCVR_SETUP_MSB(~0) |
-		 UTMIP_XCVR_LSFSLEW(~0) | UTMIP_XCVR_LSRSLEW(~0) |
-		 UTMIP_XCVR_HSSLEW_MSB(~0));
-	val |= UTMIP_XCVR_SETUP(config->xcvr_setup);
-	val |= UTMIP_XCVR_SETUP_MSB(config->xcvr_setup);
+		 UTMIP_XCVR_LSFSLEW(~0) | UTMIP_XCVR_LSRSLEW(~0));
+
+	if (!config->xcvr_setup_use_fuses) {
+		val |= UTMIP_XCVR_SETUP(config->xcvr_setup);
+		val |= UTMIP_XCVR_SETUP_MSB(config->xcvr_setup);
+	}
 	val |= UTMIP_XCVR_LSFSLEW(config->xcvr_lsfslew);
 	val |= UTMIP_XCVR_LSRSLEW(config->xcvr_lsrslew);
+
+	if (phy->soc_config->requires_extra_tuning_parameters) {
+		val &= ~(UTMIP_XCVR_HSSLEW(~0) | UTMIP_XCVR_HSSLEW_MSB(~0));
+		val |= UTMIP_XCVR_HSSLEW(config->xcvr_hsslew);
+		val |= UTMIP_XCVR_HSSLEW_MSB(config->xcvr_hsslew);
+	}
 	writel(val, base + UTMIP_XCVR_CFG0);
 
 	val = readl(base + UTMIP_XCVR_CFG1);
@@ -450,14 +473,14 @@ static int utmi_phy_power_on(struct tegra_usb_phy *phy)
 	val |= UTMIP_BIAS_PDTRK_COUNT(0x5);
 	writel(val, base + UTMIP_BIAS_CFG1);
 
-	if (phy->is_legacy_phy) {
-		val = readl(base + UTMIP_SPARE_CFG0);
-		if (phy->mode == USB_DR_MODE_PERIPHERAL)
-			val &= ~FUSE_SETUP_SEL;
-		else
-			val |= FUSE_SETUP_SEL;
-		writel(val, base + UTMIP_SPARE_CFG0);
-	} else {
+	val = readl(base + UTMIP_SPARE_CFG0);
+	if (config->xcvr_setup_use_fuses)
+		val |= FUSE_SETUP_SEL;
+	else
+		val &= ~FUSE_SETUP_SEL;
+	writel(val, base + UTMIP_SPARE_CFG0);
+
+	if (!phy->is_legacy_phy) {
 		val = readl(base + USB_SUSP_CTRL);
 		val |= UTMIP_PHY_ENABLE;
 		writel(val, base + USB_SUSP_CTRL);
@@ -888,11 +911,6 @@ static int utmi_phy_probe(struct tegra_usb_phy *tegra_phy,
 	if (err < 0)
 		return err;
 
-	err = read_utmi_param(pdev, "nvidia,xcvr-setup",
-		&config->xcvr_setup);
-	if (err < 0)
-		return err;
-
 	err = read_utmi_param(pdev, "nvidia,xcvr-lsfslew",
 		&config->xcvr_lsfslew);
 	if (err < 0)
@@ -903,6 +921,33 @@ static int utmi_phy_probe(struct tegra_usb_phy *tegra_phy,
 	if (err < 0)
 		return err;
 
+	if (tegra_phy->soc_config->requires_extra_tuning_parameters) {
+		err = read_utmi_param(pdev, "nvidia,xcvr-hsslew",
+			&config->xcvr_hsslew);
+		if (err < 0)
+			return err;
+
+		err = read_utmi_param(pdev, "nvidia,hssquelch-level",
+			&config->hssquelch_level);
+		if (err < 0)
+			return err;
+
+		err = read_utmi_param(pdev, "nvidia,hsdiscon-level",
+			&config->hsdiscon_level);
+		if (err < 0)
+			return err;
+	}
+
+	config->xcvr_setup_use_fuses = of_property_read_bool(
+		pdev->dev.of_node, "nvidia,xcvr-setup-use-fuses");
+
+	if (!config->xcvr_setup_use_fuses) {
+		err = read_utmi_param(pdev, "nvidia,xcvr-setup",
+			&config->xcvr_setup);
+		if (err < 0)
+			return err;
+	}
+
 	return 0;
 }
 
diff --git a/include/linux/usb/tegra_usb_phy.h b/include/linux/usb/tegra_usb_phy.h
index d3a63c3..1de16c3 100644
--- a/include/linux/usb/tegra_usb_phy.h
+++ b/include/linux/usb/tegra_usb_phy.h
@@ -41,9 +41,13 @@ struct tegra_utmip_config {
 	u8 elastic_limit;
 	u8 idle_wait_delay;
 	u8 term_range_adj;
+	bool xcvr_setup_use_fuses;
 	u8 xcvr_setup;
 	u8 xcvr_lsfslew;
 	u8 xcvr_lsrslew;
+	u8 xcvr_hsslew;
+	u8 hssquelch_level;
+	u8 hsdiscon_level;
 };
 
 enum tegra_usb_phy_port_speed {
-- 
1.8.1.5

