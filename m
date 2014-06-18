Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934151AbaFRGSt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 02:18:49 -0400
Received: from mail-vc0-f201.google.com ([209.85.220.201]:35973 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756728AbaFRGQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 02:16:38 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kishon Vijay Abraham I <kishon@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH v1 4/9] pinctrl: tegra-xusb: Add USB PHY support
Date: Tue, 17 Jun 2014 23:16:15 -0700
Message-Id: <1403072180-4944-5-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1403072180-4944-1-git-send-email-abrestic@chromium.org>
References: <1403072180-4944-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In addition to the PCIe and SATA PHYs, the XUSB pad controller also
supports 3 UTMI, 2 HSIC, and 2 USB3 PHYs.  Each USB3 PHY uses a single
PCIe or SATA lane and is mapped to one of the three UTMI ports.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/pinctrl/pinctrl-tegra-xusb.c | 1106 +++++++++++++++++++++++++++++++++-
 1 file changed, 1089 insertions(+), 17 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-tegra-xusb.c b/drivers/pinctrl/pinctrl-tegra-xusb.c
index 2405646..67056ab 100644
--- a/drivers/pinctrl/pinctrl-tegra-xusb.c
+++ b/drivers/pinctrl/pinctrl-tegra-xusb.c
@@ -14,22 +14,55 @@
 #include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/module.h>
+#include <linux/notifier.h>
 #include <linux/of.h>
 #include <linux/phy/phy.h>
 #include <linux/pinctrl/pinctrl.h>
 #include <linux/pinctrl/pinmux.h>
 #include <linux/platform_device.h>
+#include <linux/regulator/consumer.h>
 #include <linux/reset.h>
+#include <linux/tegra-soc.h>
+#include <linux/tegra-xusb-mbox.h>
 
 #include <dt-bindings/pinctrl/pinctrl-tegra-xusb.h>
 
 #include "core.h"
 #include "pinctrl-utils.h"
 
+#define TEGRA_XUSB_PADCTL_USB3_PORTS 2
+#define TEGRA_XUSB_PADCTL_UTMI_PORTS 3
+#define TEGRA_XUSB_PADCTL_HSIC_PORTS 2
+
+#define FUSE_SKU_CALIB_HS_CURR_LEVEL_PADX_SHIFT(x) ((x) ? 15 : 0)
+#define FUSE_SKU_CALIB_HS_CURR_LEVEL_PAD_MASK 0x3f
+#define FUSE_SKU_CALIB_HS_IREF_CAP_SHIFT 13
+#define FUSE_SKU_CALIB_HS_IREF_CAP_MASK 0x3
+#define FUSE_SKU_CALIB_HS_SQUELCH_LEVEL_SHIFT 11
+#define FUSE_SKU_CALIB_HS_SQUELCH_LEVEL_MASK 0x3
+#define FUSE_SKU_CALIB_HS_TERM_RANGE_ADJ_SHIFT 7
+#define FUSE_SKU_CALIB_HS_TERM_RANGE_ADJ_MASK 0xf
+
+#define XUSB_PADCTL_USB2_PORT_CAP 0x008
+#define XUSB_PADCTL_USB2_PORT_CAP_PORTX_CAP_SHIFT(x) ((x) * 4)
+#define XUSB_PADCTL_USB2_PORT_CAP_PORT_CAP_MASK 0x3
+#define XUSB_PADCTL_USB2_PORT_CAP_DISABLED 0x0
+#define XUSB_PADCTL_USB2_PORT_CAP_HOST 0x1
+#define XUSB_PADCTL_USB2_PORT_CAP_DEVICE 0x2
+#define XUSB_PADCTL_USB2_PORT_CAP_OTG 0x3
+
+#define XUSB_PADCTL_SS_PORT_MAP 0x014
+#define XUSB_PADCTL_SS_PORT_MAP_PORTX_SHIFT(x) ((x) * 4)
+#define XUSB_PADCTL_SS_PORT_MAP_PORT_MASK 0x7
+
 #define XUSB_PADCTL_ELPG_PROGRAM 0x01c
 #define XUSB_PADCTL_ELPG_PROGRAM_AUX_MUX_LP0_VCORE_DOWN (1 << 26)
 #define XUSB_PADCTL_ELPG_PROGRAM_AUX_MUX_LP0_CLAMP_EN_EARLY (1 << 25)
 #define XUSB_PADCTL_ELPG_PROGRAM_AUX_MUX_LP0_CLAMP_EN (1 << 24)
+#define XUSB_PADCTL_ELPG_PROGRAM_SSPX_ELPG_VCORE_DOWN(x) (1 << (18 + (x) * 4))
+#define XUSB_PADCTL_ELPG_PROGRAM_SSPX_ELPG_CLAMP_EN_EARLY(x) \
+							(1 << (17 + (x) * 4))
+#define XUSB_PADCTL_ELPG_PROGRAM_SSPX_ELPG_CLAMP_EN(x) (1 << (16 + (x) * 4))
 
 #define XUSB_PADCTL_IOPHY_PLL_P0_CTL1 0x040
 #define XUSB_PADCTL_IOPHY_PLL_P0_CTL1_PLL0_LOCKDET (1 << 19)
@@ -41,6 +74,104 @@
 #define XUSB_PADCTL_IOPHY_PLL_P0_CTL2_TXCLKREF_EN (1 << 5)
 #define XUSB_PADCTL_IOPHY_PLL_P0_CTL2_TXCLKREF_SEL (1 << 4)
 
+#define XUSB_PADCTL_IOPHY_USB3_PADX_CTL2(x) (0x058 + (x) * 4)
+#define XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_CDR_CNTL_SHIFT 24
+#define XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_CDR_CNTL_MASK 0xff
+#define XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_RX_EQ_Z_SHIFT 16
+#define XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_RX_EQ_Z_MASK 0x3f
+#define XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_RX_EQ_G_SHIFT 8
+#define XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_RX_EQ_G_MASK 0x3f
+#define XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_RX_EQ_SHIFT 8
+#define XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_RX_EQ_MASK 0xffff
+#define XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_RX_WANDER_SHIFT 4
+#define XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_RX_WANDER_MASK 0x7
+
+#define XUSB_PADCTL_IOPHY_USB3_PADX_CTL4(x) (0x068 + (x) * 4)
+#define XUSB_PADCTL_IOPHY_USB3_PAD_CTL4_DFE_CNTL_TAP_SHIFT 24
+#define XUSB_PADCTL_IOPHY_USB3_PAD_CTL4_DFE_CNTL_TAP_MASK 0x1f
+#define XUSB_PADCTL_IOPHY_USB3_PAD_CTL4_DFE_CNTL_AMP_SHIFT 16
+#define XUSB_PADCTL_IOPHY_USB3_PAD_CTL4_DFE_CNTL_AMP_MASK 0x7f
+
+#define XUSB_PADCTL_IOPHY_MISC_PAD_PX_CTL2(x) ((x) < 2 ? 0x078 + (x) * 4 : \
+					       0x0f8 + (x) * 4)
+#define XUSB_PADCTL_IOPHY_MISC_PAD_CTL2_SPARE_IN_SHIFT 28
+#define XUSB_PADCTL_IOPHY_MISC_PAD_CTL2_SPARE_IN_MASK 0x3
+
+#define XUSB_PADCTL_IOPHY_MISC_PAD_PX_CTL5(x) ((x) < 2 ? 0x090 + (x) * 4 : \
+					       0x11c + (x) * 4)
+#define XUSB_PADCTL_IOPHY_MISC_PAD_CTL5_RX_QEYE_EN (1 << 8)
+
+#define XUSB_PADCTL_IOPHY_MISC_PAD_PX_CTL6(x) ((x) < 2 ? 0x098 + (x) * 4 : \
+					       0x128 + (x) * 4)
+#define XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_SHIFT 24
+#define XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_G_Z_MASK 0x3f
+#define XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_TAP_MASK 0x1f
+#define XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_AMP_MASK 0x7f
+#define XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_SEL_SHIFT 16
+#define XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_SEL_MASK 0xff
+#define XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_SEL_G_Z 0x21
+#define XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_SEL_TAP 0x32
+#define XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_SEL_AMP 0x33
+#define XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_SEL_CTLE_Z 0x48
+#define XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_SEL_LATCH_G_Z 0xa1
+
+#define XUSB_PADCTL_USB2_OTG_PADX_CTL0(x) (0x0a0 + (x) * 4)
+#define XUSB_PADCTL_USB2_OTG_PAD_CTL0_PD_ZI (1 << 21)
+#define XUSB_PADCTL_USB2_OTG_PAD_CTL0_PD2 (1 << 20)
+#define XUSB_PADCTL_USB2_OTG_PAD_CTL0_PD (1 << 19)
+#define XUSB_PADCTL_USB2_OTG_PAD_CTL0_LS_RSLEW_SHIFT 14
+#define XUSB_PADCTL_USB2_OTG_PAD_CTL0_LS_RSLEW_MASK 0x3
+#define XUSB_PADCTL_USB2_OTG_PAD_CTL0_HS_SLEW_SHIFT 6
+#define XUSB_PADCTL_USB2_OTG_PAD_CTL0_HS_SLEW_MASK 0x3f
+#define XUSB_PADCTL_USB2_OTG_PAD_CTL0_HS_CURR_LEVEL_SHIFT 0
+#define XUSB_PADCTL_USB2_OTG_PAD_CTL0_HS_CURR_LEVEL_MASK 0x3f
+
+#define XUSB_PADCTL_USB2_OTG_PADX_CTL1(x) (0x0ac + (x) * 4)
+#define XUSB_PADCTL_USB2_OTG_PAD_CTL1_HS_IREF_CAP_SHIFT 9
+#define XUSB_PADCTL_USB2_OTG_PAD_CTL1_HS_IREF_CAP_MASK 0x3
+#define XUSB_PADCTL_USB2_OTG_PAD_CTL1_TERM_RANGE_ADJ_SHIFT 3
+#define XUSB_PADCTL_USB2_OTG_PAD_CTL1_TERM_RANGE_ADJ_MASK 0x7
+#define XUSB_PADCTL_USB2_OTG_PAD_CTL1_PD_DR (1 << 2)
+#define XUSB_PADCTL_USB2_OTG_PAD_CTL1_PD_DISC_FORCE_POWERUP (1 << 1)
+#define XUSB_PADCTL_USB2_OTG_PAD_CTL1_PD_CHRP_FORCE_POWERUP (1 << 0)
+
+#define XUSB_PADCTL_USB2_BIAS_PAD_CTL0 0x0b8
+#define XUSB_PADCTL_USB2_BIAS_PAD_CTL0_PD (1 << 12)
+#define XUSB_PADCTL_USB2_BIAS_PAD_CTL0_HS_DISCON_LEVEL_SHIFT 2
+#define XUSB_PADCTL_USB2_BIAS_PAD_CTL0_HS_DISCON_LEVEL_MASK 0x7
+#define XUSB_PADCTL_USB2_BIAS_PAD_CTL0_HS_SQUELCH_LEVEL_SHIFT 0
+#define XUSB_PADCTL_USB2_BIAS_PAD_CTL0_HS_SQUELCH_LEVEL_MASK 0x3
+
+#define XUSB_PADCTL_HSIC_PADX_CTL0(x) (0x0c0 + (x) * 4)
+#define XUSB_PADCTL_HSIC_PAD_CTL0_TX_RSLEWN_SHIFT 12
+#define XUSB_PADCTL_HSIC_PAD_CTL0_TX_RSLEWN_MASK 0x7
+#define XUSB_PADCTL_HSIC_PAD_CTL0_TX_RSLEWP_SHIFT 8
+#define XUSB_PADCTL_HSIC_PAD_CTL0_TX_RSLEWP_MASK 0x7
+#define XUSB_PADCTL_HSIC_PAD_CTL0_TX_RTUNEN_SHIFT 4
+#define XUSB_PADCTL_HSIC_PAD_CTL0_TX_RTUNEN_MASK 0x7
+#define XUSB_PADCTL_HSIC_PAD_CTL0_TX_RTUNEP_SHIFT 0
+#define XUSB_PADCTL_HSIC_PAD_CTL0_TX_RTUNEP_MASK 0x7
+
+#define XUSB_PADCTL_HSIC_PADX_CTL1(x) (0x0c8 + (x) * 4)
+#define XUSB_PADCTL_HSIC_PAD_CTL1_RPU_STROBE (1 << 10)
+#define XUSB_PADCTL_HSIC_PAD_CTL1_RPU_DATA (1 << 9)
+#define XUSB_PADCTL_HSIC_PAD_CTL1_RPD_STROBE (1 << 8)
+#define XUSB_PADCTL_HSIC_PAD_CTL1_RPD_DATA (1 << 7)
+#define XUSB_PADCTL_HSIC_PAD_CTL1_PD_ZI (1 << 5)
+#define XUSB_PADCTL_HSIC_PAD_CTL1_PD_RX (1 << 4)
+#define XUSB_PADCTL_HSIC_PAD_CTL1_PD_TRX (1 << 3)
+#define XUSB_PADCTL_HSIC_PAD_CTL1_PD_TX (1 << 2)
+#define XUSB_PADCTL_HSIC_PAD_CTL1_AUTO_TERM_EN (1 << 0)
+
+#define XUSB_PADCTL_HSIC_PADX_CTL2(x) (0x0d0 + (x) * 4)
+#define XUSB_PADCTL_HSIC_PAD_CTL2_RX_STROBE_TRIM_SHIFT 4
+#define XUSB_PADCTL_HSIC_PAD_CTL2_RX_STROBE_TRIM_MASK 0x7
+#define XUSB_PADCTL_HSIC_PAD_CTL2_RX_DATA_TRIM_SHIFT 0
+#define XUSB_PADCTL_HSIC_PAD_CTL2_RX_DATA_TRIM_MASK 0x7
+
+#define XUSB_PADCTL_HSIC_STRB_TRIM_CONTROL 0x0e0
+#define XUSB_PADCTL_HSIC_STRB_TRIM_CONTROL_STRB_TRIM_MASK 0x1f
+
 #define XUSB_PADCTL_IOPHY_PLL_S0_CTL1 0x138
 #define XUSB_PADCTL_IOPHY_PLL_S0_CTL1_PLL1_LOCKDET (1 << 27)
 #define XUSB_PADCTL_IOPHY_PLL_S0_CTL1_PLL1_MODE (1 << 24)
@@ -52,6 +183,12 @@
 #define XUSB_PADCTL_IOPHY_MISC_PAD_S0_CTL1_IDDQ_OVRD (1 << 1)
 #define XUSB_PADCTL_IOPHY_MISC_PAD_S0_CTL1_IDDQ (1 << 0)
 
+#define XUSB_PADCTL_IOPHY_MISC_PAD_S0_CTL2 0x14c
+
+#define XUSB_PADCTL_IOPHY_MISC_PAD_S0_CTL5 0x158
+
+#define XUSB_PADCTL_IOPHY_MISC_PAD_S0_CTL6 0x15c
+
 struct tegra_xusb_padctl_function {
 	const char *name;
 	const char * const *groups;
@@ -72,6 +209,16 @@ struct tegra_xusb_padctl_soc {
 
 	const struct tegra_xusb_padctl_lane *lanes;
 	unsigned int num_lanes;
+
+	u32 rx_wander;
+	u32 rx_eq;
+	u32 cdr_cntl;
+	u32 dfe_cntl;
+	u32 hs_slew;
+	u32 ls_rslew[TEGRA_XUSB_PADCTL_UTMI_PORTS];
+	u32 hs_discon_level;
+	u32 spare_in;
+	int hsic_port_offset;
 };
 
 struct tegra_xusb_padctl_lane {
@@ -86,6 +233,22 @@ struct tegra_xusb_padctl_lane {
 	unsigned int num_funcs;
 };
 
+struct tegra_xusb_fuse_calibration {
+	u32 hs_curr_level[TEGRA_XUSB_PADCTL_UTMI_PORTS];
+	u32 hs_iref_cap;
+	u32 hs_term_range_adj;
+	u32 hs_squelch_level;
+};
+
+struct tegra_xusb_usb3_port {
+	unsigned int lane;
+	bool context_saved;
+	u32 tap1_val;
+	u32 amp_val;
+	u32 ctle_z_val;
+	u32 ctle_g_val;
+};
+
 struct tegra_xusb_padctl {
 	struct device *dev;
 	void __iomem *regs;
@@ -93,13 +256,22 @@ struct tegra_xusb_padctl {
 	struct reset_control *rst;
 
 	const struct tegra_xusb_padctl_soc *soc;
+	struct tegra_xusb_fuse_calibration calib;
 	struct pinctrl_dev *pinctrl;
 	struct pinctrl_desc desc;
 
 	struct phy_provider *provider;
-	struct phy *phys[2];
+	struct phy *phys[9];
 
 	unsigned int enable;
+
+	struct tegra_xusb_mbox *mbox;
+	struct notifier_block mbox_nb;
+
+	struct tegra_xusb_usb3_port usb3_ports[TEGRA_XUSB_PADCTL_USB3_PORTS];
+	unsigned int utmi_enable;
+	struct regulator *vbus[TEGRA_XUSB_PADCTL_UTMI_PORTS];
+	struct regulator *vddio_hsic;
 };
 
 static inline void padctl_writel(struct tegra_xusb_padctl *padctl, u32 value,
@@ -114,6 +286,42 @@ static inline u32 padctl_readl(struct tegra_xusb_padctl *padctl,
 	return readl(padctl->regs + offset);
 }
 
+#define PIN_OTG_0   0
+#define PIN_OTG_1   1
+#define PIN_OTG_2   2
+#define PIN_ULPI_0  3
+#define PIN_HSIC_0  4
+#define PIN_HSIC_1  5
+#define PIN_PCIE_0  6
+#define PIN_PCIE_1  7
+#define PIN_PCIE_2  8
+#define PIN_PCIE_3  9
+#define PIN_PCIE_4 10
+#define PIN_SATA_0 11
+
+static inline bool is_hsic_lane(unsigned int lane)
+{
+	return lane >= PIN_HSIC_0 && lane <= PIN_HSIC_1;
+}
+
+static inline bool is_pcie_sata_lane(unsigned int lane)
+{
+	return lane >= PIN_PCIE_0 && lane <= PIN_SATA_0;
+}
+
+static int lane_to_usb3_port(struct tegra_xusb_padctl *padctl,
+			     unsigned int lane)
+{
+	int i;
+
+	for (i = 0; i < TEGRA_XUSB_PADCTL_USB3_PORTS; i++) {
+		if (padctl->usb3_ports[i].lane == lane)
+			return i;
+	}
+
+	return -1;
+}
+
 static int tegra_xusb_padctl_get_groups_count(struct pinctrl_dev *pinctrl)
 {
 	struct tegra_xusb_padctl *padctl = pinctrl_dev_get_drvdata(pinctrl);
@@ -131,6 +339,16 @@ static const char *tegra_xusb_padctl_get_group_name(struct pinctrl_dev *pinctrl,
 
 enum tegra_xusb_padctl_param {
 	TEGRA_XUSB_PADCTL_IDDQ,
+	TEGRA_XUSB_PADCTL_USB3_PORT_NUM,
+	TEGRA_XUSB_PADCTL_USB2_PORT_NUM,
+	TEGRA_XUSB_PADCTL_HSIC_STROBE_TRIM,
+	TEGRA_XUSB_PADCTL_HSIC_RX_STROBE_TRIM,
+	TEGRA_XUSB_PADCTL_HSIC_RX_DATA_TRIM,
+	TEGRA_XUSB_PADCTL_HSIC_TX_RTUNEN,
+	TEGRA_XUSB_PADCTL_HSIC_TX_RTUNEP,
+	TEGRA_XUSB_PADCTL_HSIC_TX_RSLEWN,
+	TEGRA_XUSB_PADCTL_HSIC_TX_RSLEWP,
+	TEGRA_XUSB_PADCTL_HSIC_AUTO_TERM,
 };
 
 static const struct tegra_xusb_padctl_property {
@@ -138,6 +356,16 @@ static const struct tegra_xusb_padctl_property {
 	enum tegra_xusb_padctl_param param;
 } properties[] = {
 	{ "nvidia,iddq", TEGRA_XUSB_PADCTL_IDDQ },
+	{ "nvidia,usb3-port-num", TEGRA_XUSB_PADCTL_USB3_PORT_NUM },
+	{ "nvidia,usb2-port-num", TEGRA_XUSB_PADCTL_USB2_PORT_NUM },
+	{ "nvidia,hsic-strobe-trim", TEGRA_XUSB_PADCTL_HSIC_STROBE_TRIM },
+	{ "nvidia,hsic-rx-strobe-trim", TEGRA_XUSB_PADCTL_HSIC_RX_STROBE_TRIM },
+	{ "nvidia,hsic-rx-data-trim", TEGRA_XUSB_PADCTL_HSIC_RX_DATA_TRIM },
+	{ "nvidia,hsic-tx-rtune-n", TEGRA_XUSB_PADCTL_HSIC_TX_RTUNEN },
+	{ "nvidia,hsic-tx-rtune-p", TEGRA_XUSB_PADCTL_HSIC_TX_RTUNEP },
+	{ "nvidia,hsic-tx-rslew-n", TEGRA_XUSB_PADCTL_HSIC_TX_RSLEWN },
+	{ "nvidia,hsic-tx-rslew-p", TEGRA_XUSB_PADCTL_HSIC_TX_RSLEWP },
+	{ "nvidia,hsic-auto-term", TEGRA_XUSB_PADCTL_HSIC_AUTO_TERM },
 };
 
 #define TEGRA_XUSB_PADCTL_PACK(param, value) ((param) << 16 | (value))
@@ -321,6 +549,7 @@ static int tegra_xusb_padctl_pinconf_group_get(struct pinctrl_dev *pinctrl,
 	struct tegra_xusb_padctl *padctl = pinctrl_dev_get_drvdata(pinctrl);
 	const struct tegra_xusb_padctl_lane *lane;
 	enum tegra_xusb_padctl_param param;
+	int port;
 	u32 value;
 
 	param = TEGRA_XUSB_PADCTL_UNPACK_PARAM(*config);
@@ -330,7 +559,125 @@ static int tegra_xusb_padctl_pinconf_group_get(struct pinctrl_dev *pinctrl,
 	case TEGRA_XUSB_PADCTL_IDDQ:
 		value = padctl_readl(padctl, lane->offset);
 		value = (value >> lane->iddq) & 0x1;
-		*config = TEGRA_XUSB_PADCTL_PACK(param, value);
+		break;
+
+	case TEGRA_XUSB_PADCTL_USB3_PORT_NUM:
+		value = lane_to_usb3_port(padctl, group);
+		if (value < 0) {
+			dev_err(padctl->dev,
+				"Lane %d not mapped to USB3 port\n", group);
+			return -EINVAL;
+		}
+		break;
+
+	case TEGRA_XUSB_PADCTL_USB2_PORT_NUM:
+		port = lane_to_usb3_port(padctl, group);
+		if (port < 0) {
+			dev_err(padctl->dev,
+				"Lane %d not mapped to USB2 port\n", group);
+			return -EINVAL;
+		}
+
+		value = padctl_readl(padctl, XUSB_PADCTL_SS_PORT_MAP) >>
+			XUSB_PADCTL_SS_PORT_MAP_PORTX_SHIFT(port);
+		value &= XUSB_PADCTL_SS_PORT_MAP_PORT_MASK;
+		break;
+
+	case TEGRA_XUSB_PADCTL_HSIC_STROBE_TRIM:
+		if (!is_hsic_lane(group)) {
+			dev_err(padctl->dev, "Pin %d not an HSIC\n", group);
+			return -EINVAL;
+		}
+
+		value = padctl_readl(padctl,
+				     XUSB_PADCTL_HSIC_STRB_TRIM_CONTROL);
+		value &= XUSB_PADCTL_HSIC_STRB_TRIM_CONTROL_STRB_TRIM_MASK;
+		break;
+
+	case TEGRA_XUSB_PADCTL_HSIC_RX_STROBE_TRIM:
+		if (!is_hsic_lane(group)) {
+			dev_err(padctl->dev, "Pin %d not an HSIC\n", group);
+			return -EINVAL;
+		}
+
+		port = group - PIN_HSIC_0;
+		value = padctl_readl(padctl, XUSB_PADCTL_HSIC_PADX_CTL2(port)) >>
+			XUSB_PADCTL_HSIC_PAD_CTL2_RX_STROBE_TRIM_SHIFT;
+		value &= XUSB_PADCTL_HSIC_PAD_CTL2_RX_STROBE_TRIM_MASK;
+		break;
+
+	case TEGRA_XUSB_PADCTL_HSIC_RX_DATA_TRIM:
+		if (!is_hsic_lane(group)) {
+			dev_err(padctl->dev, "Pin %d not an HSIC\n", group);
+			return -EINVAL;
+		}
+
+		port = group - PIN_HSIC_0;
+		value = padctl_readl(padctl, XUSB_PADCTL_HSIC_PADX_CTL2(port)) >>
+			XUSB_PADCTL_HSIC_PAD_CTL2_RX_DATA_TRIM_SHIFT;
+		value &= XUSB_PADCTL_HSIC_PAD_CTL2_RX_DATA_TRIM_MASK;
+		break;
+
+	case TEGRA_XUSB_PADCTL_HSIC_TX_RTUNEN:
+		if (!is_hsic_lane(group)) {
+			dev_err(padctl->dev, "Pin %d not an HSIC\n", group);
+			return -EINVAL;
+		}
+
+		port = group - PIN_HSIC_0;
+		value = padctl_readl(padctl, XUSB_PADCTL_HSIC_PADX_CTL0(port)) >>
+			XUSB_PADCTL_HSIC_PAD_CTL0_TX_RTUNEN_SHIFT;
+		value &= XUSB_PADCTL_HSIC_PAD_CTL0_TX_RTUNEN_MASK;
+		break;
+
+	case TEGRA_XUSB_PADCTL_HSIC_TX_RTUNEP:
+		if (!is_hsic_lane(group)) {
+			dev_err(padctl->dev, "Pin %d not an HSIC\n", group);
+			return -EINVAL;
+		}
+
+		port = group - PIN_HSIC_0;
+		value = padctl_readl(padctl, XUSB_PADCTL_HSIC_PADX_CTL0(port)) >>
+			XUSB_PADCTL_HSIC_PAD_CTL0_TX_RTUNEP_SHIFT;
+		value &= XUSB_PADCTL_HSIC_PAD_CTL0_TX_RTUNEP_MASK;
+		break;
+
+	case TEGRA_XUSB_PADCTL_HSIC_TX_RSLEWN:
+		if (!is_hsic_lane(group)) {
+			dev_err(padctl->dev, "Pin %d not an HSIC\n", group);
+			return -EINVAL;
+		}
+
+		port = group - PIN_HSIC_0;
+		value = padctl_readl(padctl, XUSB_PADCTL_HSIC_PADX_CTL0(port)) >>
+			XUSB_PADCTL_HSIC_PAD_CTL0_TX_RSLEWN_SHIFT;
+		value &= XUSB_PADCTL_HSIC_PAD_CTL0_TX_RSLEWN_MASK;
+		break;
+
+	case TEGRA_XUSB_PADCTL_HSIC_TX_RSLEWP:
+		if (!is_hsic_lane(group)) {
+			dev_err(padctl->dev, "Pin %d not an HSIC\n", group);
+			return -EINVAL;
+		}
+
+		port = group - PIN_HSIC_0;
+		value = padctl_readl(padctl, XUSB_PADCTL_HSIC_PADX_CTL0(port)) >>
+			XUSB_PADCTL_HSIC_PAD_CTL0_TX_RSLEWP_SHIFT;
+		value &= XUSB_PADCTL_HSIC_PAD_CTL0_TX_RSLEWP_MASK;
+		break;
+
+	case TEGRA_XUSB_PADCTL_HSIC_AUTO_TERM:
+		if (!is_hsic_lane(group)) {
+			dev_err(padctl->dev, "Pin %d not an HSIC\n", group);
+			return -EINVAL;
+		}
+
+		port = group - PIN_HSIC_0;
+		value = padctl_readl(padctl, XUSB_PADCTL_HSIC_PADX_CTL1(port));
+		if (value & XUSB_PADCTL_HSIC_PAD_CTL1_AUTO_TERM_EN)
+			value = 1;
+		else
+			value = 0;
 		break;
 
 	default:
@@ -339,6 +686,7 @@ static int tegra_xusb_padctl_pinconf_group_get(struct pinctrl_dev *pinctrl,
 		return -ENOTSUPP;
 	}
 
+	*config = TEGRA_XUSB_PADCTL_PACK(param, value);
 	return 0;
 }
 
@@ -351,7 +699,7 @@ static int tegra_xusb_padctl_pinconf_group_set(struct pinctrl_dev *pinctrl,
 	const struct tegra_xusb_padctl_lane *lane;
 	enum tegra_xusb_padctl_param param;
 	unsigned long value;
-	unsigned int i;
+	unsigned int i, port;
 	u32 regval;
 
 	lane = &padctl->soc->lanes[group];
@@ -372,6 +720,193 @@ static int tegra_xusb_padctl_pinconf_group_set(struct pinctrl_dev *pinctrl,
 			padctl_writel(padctl, regval, lane->offset);
 			break;
 
+		case TEGRA_XUSB_PADCTL_USB3_PORT_NUM:
+			if (value >= TEGRA_XUSB_PADCTL_USB3_PORTS) {
+				dev_err(padctl->dev, "Invalid USB3 port: %lu\n",
+					value);
+				return -EINVAL;
+			}
+			if (!is_pcie_sata_lane(group)) {
+				dev_err(padctl->dev,
+					"USB3 port not applicable for pin %d\n",
+					group);
+				return -EINVAL;
+			}
+			padctl->usb3_ports[value].lane = group;
+			break;
+
+		case TEGRA_XUSB_PADCTL_USB2_PORT_NUM:
+			if (value >= TEGRA_XUSB_PADCTL_UTMI_PORTS) {
+				dev_err(padctl->dev, "Invalid USB2 port: %lu\n",
+					value);
+				return -EINVAL;
+			}
+			if (!is_pcie_sata_lane(group)) {
+				dev_err(padctl->dev,
+					"USB2 port not applicable for pin %d\n",
+					group);
+				return -EINVAL;
+			}
+			port = lane_to_usb3_port(padctl, group);
+			if (port < 0) {
+				dev_err(padctl->dev,
+					"Pin %d not mapped to USB3 port\n",
+					group);
+				break;
+			}
+
+			regval = padctl_readl(padctl, XUSB_PADCTL_SS_PORT_MAP);
+			regval &= ~(XUSB_PADCTL_SS_PORT_MAP_PORT_MASK <<
+				    XUSB_PADCTL_SS_PORT_MAP_PORTX_SHIFT(port));
+			regval |= value <<
+				XUSB_PADCTL_SS_PORT_MAP_PORTX_SHIFT(port);
+			padctl_writel(padctl, regval, XUSB_PADCTL_SS_PORT_MAP);
+			break;
+
+		case TEGRA_XUSB_PADCTL_HSIC_STROBE_TRIM:
+			if (!is_hsic_lane(group)) {
+				dev_err(padctl->dev, "Pin %d not an HSIC\n",
+					group);
+				return -EINVAL;
+			}
+
+			value &= XUSB_PADCTL_HSIC_STRB_TRIM_CONTROL_STRB_TRIM_MASK;
+			padctl_writel(padctl, value,
+				      XUSB_PADCTL_HSIC_STRB_TRIM_CONTROL);
+			break;
+
+		case TEGRA_XUSB_PADCTL_HSIC_RX_STROBE_TRIM:
+			if (!is_hsic_lane(group)) {
+				dev_err(padctl->dev, "Pin %d not an HSIC\n",
+					group);
+				return -EINVAL;
+			}
+
+			port = group - PIN_HSIC_0;
+			value &= XUSB_PADCTL_HSIC_PAD_CTL2_RX_STROBE_TRIM_MASK;
+			regval = padctl_readl(padctl,
+					      XUSB_PADCTL_HSIC_PADX_CTL2(port));
+			regval &= ~(XUSB_PADCTL_HSIC_PAD_CTL2_RX_STROBE_TRIM_MASK <<
+				    XUSB_PADCTL_HSIC_PAD_CTL2_RX_STROBE_TRIM_SHIFT);
+			regval |= value <<
+				XUSB_PADCTL_HSIC_PAD_CTL2_RX_STROBE_TRIM_SHIFT;
+			padctl_writel(padctl, regval,
+				      XUSB_PADCTL_HSIC_PADX_CTL2(port));
+			break;
+
+		case TEGRA_XUSB_PADCTL_HSIC_RX_DATA_TRIM:
+			if (!is_hsic_lane(group)) {
+				dev_err(padctl->dev, "Pin %d not an HSIC\n",
+					group);
+				return -EINVAL;
+			}
+
+			port = group - PIN_HSIC_0;
+			value &= XUSB_PADCTL_HSIC_PAD_CTL2_RX_DATA_TRIM_MASK;
+			regval = padctl_readl(padctl,
+					      XUSB_PADCTL_HSIC_PADX_CTL2(port));
+			regval &= ~(XUSB_PADCTL_HSIC_PAD_CTL2_RX_DATA_TRIM_MASK <<
+				    XUSB_PADCTL_HSIC_PAD_CTL2_RX_DATA_TRIM_SHIFT);
+			regval |= value <<
+				XUSB_PADCTL_HSIC_PAD_CTL2_RX_DATA_TRIM_SHIFT;
+			padctl_writel(padctl, regval,
+				      XUSB_PADCTL_HSIC_PADX_CTL2(port));
+			break;
+
+		case TEGRA_XUSB_PADCTL_HSIC_TX_RTUNEN:
+			if (!is_hsic_lane(group)) {
+				dev_err(padctl->dev, "Pin %d not an HSIC\n",
+					group);
+				return -EINVAL;
+			}
+
+			port = group - PIN_HSIC_0;
+			value &= XUSB_PADCTL_HSIC_PAD_CTL0_TX_RTUNEN_MASK;
+			regval = padctl_readl(padctl,
+					      XUSB_PADCTL_HSIC_PADX_CTL0(port));
+			regval &= ~(XUSB_PADCTL_HSIC_PAD_CTL0_TX_RTUNEN_MASK <<
+				    XUSB_PADCTL_HSIC_PAD_CTL0_TX_RTUNEN_SHIFT);
+			regval |= value <<
+				XUSB_PADCTL_HSIC_PAD_CTL0_TX_RTUNEN_SHIFT;
+			padctl_writel(padctl, regval,
+				      XUSB_PADCTL_HSIC_PADX_CTL0(port));
+			break;
+
+		case TEGRA_XUSB_PADCTL_HSIC_TX_RTUNEP:
+			if (!is_hsic_lane(group)) {
+				dev_err(padctl->dev, "Pin %d not an HSIC\n",
+					group);
+				return -EINVAL;
+			}
+
+			port = group - PIN_HSIC_0;
+			value &= XUSB_PADCTL_HSIC_PAD_CTL0_TX_RTUNEP_MASK;
+			regval = padctl_readl(padctl,
+					      XUSB_PADCTL_HSIC_PADX_CTL0(port));
+			regval &= ~(XUSB_PADCTL_HSIC_PAD_CTL0_TX_RTUNEP_MASK <<
+				    XUSB_PADCTL_HSIC_PAD_CTL0_TX_RTUNEP_SHIFT);
+			regval |= value <<
+				XUSB_PADCTL_HSIC_PAD_CTL0_TX_RTUNEP_SHIFT;
+			padctl_writel(padctl, regval,
+				      XUSB_PADCTL_HSIC_PADX_CTL0(port));
+			break;
+
+		case TEGRA_XUSB_PADCTL_HSIC_TX_RSLEWN:
+			if (!is_hsic_lane(group)) {
+				dev_err(padctl->dev, "Pin %d not an HSIC\n",
+					group);
+				return -EINVAL;
+			}
+
+			port = group - PIN_HSIC_0;
+			value &= XUSB_PADCTL_HSIC_PAD_CTL0_TX_RSLEWN_MASK;
+			regval = padctl_readl(padctl,
+					      XUSB_PADCTL_HSIC_PADX_CTL0(port));
+			regval &= ~(XUSB_PADCTL_HSIC_PAD_CTL0_TX_RSLEWN_MASK <<
+				    XUSB_PADCTL_HSIC_PAD_CTL0_TX_RSLEWN_SHIFT);
+			regval |= value <<
+				XUSB_PADCTL_HSIC_PAD_CTL0_TX_RSLEWN_SHIFT;
+			padctl_writel(padctl, regval,
+				      XUSB_PADCTL_HSIC_PADX_CTL0(port));
+			break;
+
+		case TEGRA_XUSB_PADCTL_HSIC_TX_RSLEWP:
+			if (!is_hsic_lane(group)) {
+				dev_err(padctl->dev, "Pin %d not an HSIC\n",
+					group);
+				return -EINVAL;
+			}
+
+			port = group - PIN_HSIC_0;
+			value &= XUSB_PADCTL_HSIC_PAD_CTL0_TX_RSLEWP_MASK;
+			regval = padctl_readl(padctl,
+					      XUSB_PADCTL_HSIC_PADX_CTL0(port));
+			regval &= ~(XUSB_PADCTL_HSIC_PAD_CTL0_TX_RSLEWP_MASK <<
+				    XUSB_PADCTL_HSIC_PAD_CTL0_TX_RSLEWP_SHIFT);
+			regval |= value <<
+				XUSB_PADCTL_HSIC_PAD_CTL0_TX_RSLEWP_SHIFT;
+			padctl_writel(padctl, regval,
+				      XUSB_PADCTL_HSIC_PADX_CTL0(port));
+			break;
+
+		case TEGRA_XUSB_PADCTL_HSIC_AUTO_TERM:
+			if (!is_hsic_lane(group)) {
+				dev_err(padctl->dev, "Pin %d not an HSIC\n",
+					group);
+				return -EINVAL;
+			}
+
+			port = group - PIN_HSIC_0;
+			regval = padctl_readl(padctl,
+					      XUSB_PADCTL_HSIC_PADX_CTL1(port));
+			if (!value)
+				regval &= ~XUSB_PADCTL_HSIC_PAD_CTL1_AUTO_TERM_EN;
+			else
+				regval |= XUSB_PADCTL_HSIC_PAD_CTL1_AUTO_TERM_EN;
+			padctl_writel(padctl, regval,
+				      XUSB_PADCTL_HSIC_PADX_CTL1(port));
+			break;
+
 		default:
 			dev_err(padctl->dev,
 				"invalid configuration parameter: %04x\n",
@@ -595,6 +1130,459 @@ static const struct phy_ops sata_phy_ops = {
 	.owner = THIS_MODULE,
 };
 
+static int usb3_phy_to_port(struct phy *phy)
+{
+	struct tegra_xusb_padctl *padctl = phy_get_drvdata(phy);
+	int i;
+
+	for (i = 0; i < TEGRA_XUSB_PADCTL_USB3_PORTS; i++) {
+		if (phy == padctl->phys[TEGRA_XUSB_PADCTL_USB3_P0 + i])
+			break;
+	}
+	BUG_ON(i == TEGRA_XUSB_PADCTL_USB3_PORTS);
+
+	return i;
+}
+
+static int usb3_phy_power_on(struct phy *phy)
+{
+	struct tegra_xusb_padctl *padctl = phy_get_drvdata(phy);
+	int port = usb3_phy_to_port(phy);
+	int lane = padctl->usb3_ports[port].lane;
+	u32 value, offset;
+
+	value = padctl_readl(padctl, XUSB_PADCTL_IOPHY_USB3_PADX_CTL2(port));
+	value &= ~((XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_RX_WANDER_MASK <<
+		    XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_RX_WANDER_SHIFT) |
+		   (XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_RX_EQ_MASK <<
+		    XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_RX_EQ_SHIFT) |
+		   (XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_CDR_CNTL_MASK <<
+		    XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_CDR_CNTL_SHIFT));
+	value |= (padctl->soc->rx_wander <<
+		  XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_RX_WANDER_SHIFT) |
+		 (padctl->soc->cdr_cntl <<
+		  XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_CDR_CNTL_SHIFT) |
+		 (padctl->soc->rx_eq <<
+		  XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_RX_EQ_SHIFT);
+	if (padctl->usb3_ports[port].context_saved) {
+		value &= ~((XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_RX_EQ_G_MASK <<
+			    XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_RX_EQ_G_SHIFT) |
+			   (XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_RX_EQ_Z_MASK <<
+			    XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_RX_EQ_Z_SHIFT));
+		value |= (padctl->usb3_ports[port].ctle_g_val <<
+			  XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_RX_EQ_G_SHIFT) |
+			 (padctl->usb3_ports[port].ctle_z_val <<
+			  XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_RX_EQ_Z_SHIFT);
+	}
+	padctl_writel(padctl, value, XUSB_PADCTL_IOPHY_USB3_PADX_CTL2(port));
+
+	value = padctl->soc->dfe_cntl;
+	if (padctl->usb3_ports[port].context_saved) {
+		value &= ~((XUSB_PADCTL_IOPHY_USB3_PAD_CTL4_DFE_CNTL_TAP_MASK <<
+			    XUSB_PADCTL_IOPHY_USB3_PAD_CTL4_DFE_CNTL_TAP_SHIFT) |
+			   (XUSB_PADCTL_IOPHY_USB3_PAD_CTL4_DFE_CNTL_AMP_MASK <<
+			    XUSB_PADCTL_IOPHY_USB3_PAD_CTL4_DFE_CNTL_AMP_SHIFT));
+		value |= (padctl->usb3_ports[port].tap1_val <<
+			  XUSB_PADCTL_IOPHY_USB3_PAD_CTL4_DFE_CNTL_TAP_SHIFT) |
+			 (padctl->usb3_ports[port].amp_val <<
+			  XUSB_PADCTL_IOPHY_USB3_PAD_CTL4_DFE_CNTL_AMP_SHIFT);
+	}
+	padctl_writel(padctl, value, XUSB_PADCTL_IOPHY_USB3_PADX_CTL4(port));
+
+	offset = (lane == PIN_SATA_0) ? XUSB_PADCTL_IOPHY_MISC_PAD_S0_CTL2 :
+		XUSB_PADCTL_IOPHY_MISC_PAD_PX_CTL2(lane - PIN_PCIE_0);
+	value = padctl_readl(padctl, offset);
+	value &= ~(XUSB_PADCTL_IOPHY_MISC_PAD_CTL2_SPARE_IN_MASK <<
+		   XUSB_PADCTL_IOPHY_MISC_PAD_CTL2_SPARE_IN_SHIFT);
+	value |= padctl->soc->spare_in <<
+		XUSB_PADCTL_IOPHY_MISC_PAD_CTL2_SPARE_IN_SHIFT;
+	padctl_writel(padctl, value, offset);
+
+	offset = (lane == PIN_SATA_0) ? XUSB_PADCTL_IOPHY_MISC_PAD_S0_CTL5 :
+		XUSB_PADCTL_IOPHY_MISC_PAD_PX_CTL5(lane - PIN_PCIE_0);
+	value = padctl_readl(padctl, offset);
+	value |= XUSB_PADCTL_IOPHY_MISC_PAD_CTL5_RX_QEYE_EN;
+	padctl_writel(padctl, value, offset);
+
+	value = padctl_readl(padctl, XUSB_PADCTL_ELPG_PROGRAM);
+	value &= ~XUSB_PADCTL_ELPG_PROGRAM_SSPX_ELPG_CLAMP_EN_EARLY(port);
+	padctl_writel(padctl, value, XUSB_PADCTL_ELPG_PROGRAM);
+
+	usleep_range(100, 200);
+
+	value = padctl_readl(padctl, XUSB_PADCTL_ELPG_PROGRAM);
+	value &= ~XUSB_PADCTL_ELPG_PROGRAM_SSPX_ELPG_CLAMP_EN_EARLY(port);
+	padctl_writel(padctl, value, XUSB_PADCTL_ELPG_PROGRAM);
+
+	value = padctl_readl(padctl, XUSB_PADCTL_ELPG_PROGRAM);
+	value &= ~XUSB_PADCTL_ELPG_PROGRAM_SSPX_ELPG_VCORE_DOWN(port);
+	padctl_writel(padctl, value, XUSB_PADCTL_ELPG_PROGRAM);
+
+	return 0;
+}
+
+static int usb3_phy_power_off(struct phy *phy)
+{
+	struct tegra_xusb_padctl *padctl = phy_get_drvdata(phy);
+	int port = usb3_phy_to_port(phy);
+	u32 value;
+
+	value = padctl_readl(padctl, XUSB_PADCTL_ELPG_PROGRAM);
+	value |= XUSB_PADCTL_ELPG_PROGRAM_SSPX_ELPG_CLAMP_EN_EARLY(port);
+	padctl_writel(padctl, value, XUSB_PADCTL_ELPG_PROGRAM);
+
+	usleep_range(100, 200);
+
+	value = padctl_readl(padctl, XUSB_PADCTL_ELPG_PROGRAM);
+	value |= XUSB_PADCTL_ELPG_PROGRAM_SSPX_ELPG_CLAMP_EN_EARLY(port);
+	padctl_writel(padctl, value, XUSB_PADCTL_ELPG_PROGRAM);
+
+	usleep_range(250, 350);
+
+	value = padctl_readl(padctl, XUSB_PADCTL_ELPG_PROGRAM);
+	value |= XUSB_PADCTL_ELPG_PROGRAM_SSPX_ELPG_VCORE_DOWN(port);
+	padctl_writel(padctl, value, XUSB_PADCTL_ELPG_PROGRAM);
+
+	return 0;
+}
+
+static void usb3_phy_save_context(struct tegra_xusb_padctl *padctl, int port)
+{
+	int lane = padctl->usb3_ports[port].lane;
+	u32 value, offset;
+
+	padctl->usb3_ports[port].context_saved = true;
+
+	offset = (lane == PIN_SATA_0) ? XUSB_PADCTL_IOPHY_MISC_PAD_S0_CTL6 :
+		XUSB_PADCTL_IOPHY_MISC_PAD_PX_CTL6(lane - PIN_PCIE_0);
+
+	value = padctl_readl(padctl, offset);
+	value &= ~(XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_SEL_MASK <<
+		   XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_SEL_SHIFT);
+	value |= XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_SEL_TAP <<
+		XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_SEL_SHIFT;
+	padctl_writel(padctl, value, offset);
+
+	value = padctl_readl(padctl, offset) >>
+		XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_SHIFT;
+	padctl->usb3_ports[port].tap1_val = value &
+		XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_TAP_MASK;
+
+	value = padctl_readl(padctl, offset);
+	value &= ~(XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_SEL_MASK <<
+		   XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_SEL_SHIFT);
+	value |= XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_SEL_AMP <<
+		XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_SEL_SHIFT;
+	padctl_writel(padctl, value, offset);
+
+	value = padctl_readl(padctl, offset) >>
+		XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_SHIFT;
+	padctl->usb3_ports[port].amp_val = value &
+		XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_AMP_MASK;
+
+	value = padctl_readl(padctl, XUSB_PADCTL_IOPHY_USB3_PADX_CTL4(port));
+	value &= ~((XUSB_PADCTL_IOPHY_USB3_PAD_CTL4_DFE_CNTL_TAP_MASK <<
+		    XUSB_PADCTL_IOPHY_USB3_PAD_CTL4_DFE_CNTL_TAP_SHIFT) |
+		   (XUSB_PADCTL_IOPHY_USB3_PAD_CTL4_DFE_CNTL_AMP_MASK <<
+		    XUSB_PADCTL_IOPHY_USB3_PAD_CTL4_DFE_CNTL_AMP_SHIFT));
+	value |= (padctl->usb3_ports[port].tap1_val <<
+		  XUSB_PADCTL_IOPHY_USB3_PAD_CTL4_DFE_CNTL_TAP_SHIFT) |
+		 (padctl->usb3_ports[port].amp_val <<
+		  XUSB_PADCTL_IOPHY_USB3_PAD_CTL4_DFE_CNTL_AMP_SHIFT);
+	padctl_writel(padctl, value, XUSB_PADCTL_IOPHY_USB3_PADX_CTL4(port));
+
+	value = padctl_readl(padctl, offset);
+	value &= ~(XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_SEL_MASK <<
+		   XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_SEL_SHIFT);
+	value |= XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_SEL_LATCH_G_Z <<
+		XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_SEL_SHIFT;
+	padctl_writel(padctl, value, offset);
+
+	value = padctl_readl(padctl, offset);
+	value &= ~(XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_SEL_MASK <<
+		   XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_SEL_SHIFT);
+	value |= XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_SEL_G_Z <<
+		XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_SEL_SHIFT;
+	padctl_writel(padctl, value, offset);
+
+	value = padctl_readl(padctl, offset) >>
+		XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_SHIFT;
+	padctl->usb3_ports[port].ctle_g_val = value &
+		XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_G_Z_MASK;
+
+	value = padctl_readl(padctl, offset);
+	value &= ~(XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_SEL_MASK <<
+		   XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_SEL_SHIFT);
+	value |= XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_SEL_CTLE_Z <<
+		XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_SEL_SHIFT;
+	padctl_writel(padctl, value, offset);
+
+	value = padctl_readl(padctl, offset) >>
+		XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_SHIFT;
+	padctl->usb3_ports[port].ctle_z_val = value &
+		XUSB_PADCTL_IOPHY_MISC_PAD_CTL6_MISC_OUT_G_Z_MASK;
+
+	value = padctl_readl(padctl, XUSB_PADCTL_IOPHY_USB3_PADX_CTL2(port));
+	value &= ~((XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_RX_EQ_G_MASK <<
+		    XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_RX_EQ_G_SHIFT) |
+		   (XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_RX_EQ_Z_MASK <<
+		    XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_RX_EQ_Z_SHIFT));
+	value |= (padctl->usb3_ports[port].ctle_g_val <<
+		  XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_RX_EQ_G_SHIFT) |
+		 (padctl->usb3_ports[port].ctle_z_val <<
+		  XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_RX_EQ_Z_SHIFT);
+	padctl_writel(padctl, value, XUSB_PADCTL_IOPHY_USB3_PADX_CTL2(port));
+}
+
+static const struct phy_ops usb3_phy_ops = {
+	.init = tegra_xusb_phy_init,
+	.exit = tegra_xusb_phy_exit,
+	.power_on = usb3_phy_power_on,
+	.power_off = usb3_phy_power_off,
+	.owner = THIS_MODULE,
+};
+
+static int utmi_phy_to_port(struct phy *phy)
+{
+	struct tegra_xusb_padctl *padctl = phy_get_drvdata(phy);
+	int i;
+
+	for (i = 0; i < TEGRA_XUSB_PADCTL_UTMI_PORTS; i++) {
+		if (phy == padctl->phys[TEGRA_XUSB_PADCTL_UTMI_P0 + i])
+			break;
+	}
+	BUG_ON(i == TEGRA_XUSB_PADCTL_UTMI_PORTS);
+
+	return i;
+}
+
+static int utmi_phy_power_on(struct phy *phy)
+{
+	struct tegra_xusb_padctl *padctl = phy_get_drvdata(phy);
+	int port = utmi_phy_to_port(phy);
+	int ret;
+	u32 value;
+
+	value = padctl_readl(padctl, XUSB_PADCTL_USB2_BIAS_PAD_CTL0);
+	value &= ~((XUSB_PADCTL_USB2_BIAS_PAD_CTL0_HS_SQUELCH_LEVEL_MASK <<
+		    XUSB_PADCTL_USB2_BIAS_PAD_CTL0_HS_SQUELCH_LEVEL_SHIFT) |
+		   (XUSB_PADCTL_USB2_BIAS_PAD_CTL0_HS_DISCON_LEVEL_MASK <<
+		    XUSB_PADCTL_USB2_BIAS_PAD_CTL0_HS_DISCON_LEVEL_SHIFT));
+	value |= (padctl->calib.hs_squelch_level <<
+		  XUSB_PADCTL_USB2_BIAS_PAD_CTL0_HS_SQUELCH_LEVEL_SHIFT) |
+		 (padctl->soc->hs_discon_level <<
+		  XUSB_PADCTL_USB2_BIAS_PAD_CTL0_HS_DISCON_LEVEL_SHIFT);
+	padctl_writel(padctl, value, XUSB_PADCTL_USB2_BIAS_PAD_CTL0);
+
+	value = padctl_readl(padctl, XUSB_PADCTL_USB2_PORT_CAP);
+	value &= ~(XUSB_PADCTL_USB2_PORT_CAP_PORT_CAP_MASK <<
+		   XUSB_PADCTL_USB2_PORT_CAP_PORTX_CAP_SHIFT(port));
+	value |= XUSB_PADCTL_USB2_PORT_CAP_HOST <<
+		XUSB_PADCTL_USB2_PORT_CAP_PORTX_CAP_SHIFT(port);
+	padctl_writel(padctl, value, XUSB_PADCTL_USB2_PORT_CAP);
+
+	value = padctl_readl(padctl, XUSB_PADCTL_USB2_OTG_PADX_CTL0(port));
+	value &= ~((XUSB_PADCTL_USB2_OTG_PAD_CTL0_HS_CURR_LEVEL_MASK <<
+		    XUSB_PADCTL_USB2_OTG_PAD_CTL0_HS_CURR_LEVEL_SHIFT) |
+		   (XUSB_PADCTL_USB2_OTG_PAD_CTL0_HS_SLEW_MASK <<
+		    XUSB_PADCTL_USB2_OTG_PAD_CTL0_HS_SLEW_SHIFT) |
+		   (XUSB_PADCTL_USB2_OTG_PAD_CTL0_LS_RSLEW_MASK <<
+		    XUSB_PADCTL_USB2_OTG_PAD_CTL0_LS_RSLEW_SHIFT) |
+		   XUSB_PADCTL_USB2_OTG_PAD_CTL0_PD |
+		   XUSB_PADCTL_USB2_OTG_PAD_CTL0_PD2 |
+		   XUSB_PADCTL_USB2_OTG_PAD_CTL0_PD_ZI);
+	value |= padctl->calib.hs_curr_level[port] <<
+		XUSB_PADCTL_USB2_OTG_PAD_CTL0_HS_CURR_LEVEL_SHIFT;
+	value |= padctl->soc->hs_slew <<
+		XUSB_PADCTL_USB2_OTG_PAD_CTL0_HS_SLEW_SHIFT;
+	value |= padctl->soc->ls_rslew[port] <<
+		XUSB_PADCTL_USB2_OTG_PAD_CTL0_LS_RSLEW_SHIFT;
+	padctl_writel(padctl, value, XUSB_PADCTL_USB2_OTG_PADX_CTL0(port));
+
+	value = padctl_readl(padctl, XUSB_PADCTL_USB2_OTG_PADX_CTL1(port));
+	value &= ~((XUSB_PADCTL_USB2_OTG_PAD_CTL1_TERM_RANGE_ADJ_MASK <<
+		    XUSB_PADCTL_USB2_OTG_PAD_CTL1_TERM_RANGE_ADJ_SHIFT) |
+		   (XUSB_PADCTL_USB2_OTG_PAD_CTL1_HS_IREF_CAP_MASK <<
+		    XUSB_PADCTL_USB2_OTG_PAD_CTL1_HS_IREF_CAP_SHIFT) |
+		   XUSB_PADCTL_USB2_OTG_PAD_CTL1_PD_DR |
+		   XUSB_PADCTL_USB2_OTG_PAD_CTL1_PD_CHRP_FORCE_POWERUP |
+		   XUSB_PADCTL_USB2_OTG_PAD_CTL1_PD_DISC_FORCE_POWERUP);
+	value |= (padctl->calib.hs_term_range_adj <<
+		  XUSB_PADCTL_USB2_OTG_PAD_CTL1_TERM_RANGE_ADJ_SHIFT) |
+		 (padctl->calib.hs_iref_cap <<
+		  XUSB_PADCTL_USB2_OTG_PAD_CTL1_HS_IREF_CAP_SHIFT);
+	padctl_writel(padctl, value, XUSB_PADCTL_USB2_OTG_PADX_CTL1(port));
+
+	ret = regulator_enable(padctl->vbus[port]);
+	if (ret)
+		return ret;
+
+	mutex_lock(&padctl->lock);
+
+	if (padctl->utmi_enable++ > 0)
+		goto out;
+
+	value = padctl_readl(padctl, XUSB_PADCTL_USB2_BIAS_PAD_CTL0);
+	value &= ~XUSB_PADCTL_USB2_BIAS_PAD_CTL0_PD;
+	padctl_writel(padctl, value, XUSB_PADCTL_USB2_BIAS_PAD_CTL0);
+
+out:
+	mutex_unlock(&padctl->lock);
+	return 0;
+}
+
+static int utmi_phy_power_off(struct phy *phy)
+{
+	struct tegra_xusb_padctl *padctl = phy_get_drvdata(phy);
+	int port = utmi_phy_to_port(phy);
+	u32 value;
+
+	regulator_disable(padctl->vbus[port]);
+
+	mutex_lock(&padctl->lock);
+
+	if (WARN_ON(padctl->utmi_enable == 0))
+		goto out;
+
+	if (--padctl->utmi_enable > 0)
+		goto out;
+
+	value = padctl_readl(padctl, XUSB_PADCTL_USB2_BIAS_PAD_CTL0);
+	value |= XUSB_PADCTL_USB2_BIAS_PAD_CTL0_PD;
+	padctl_writel(padctl, value, XUSB_PADCTL_USB2_BIAS_PAD_CTL0);
+
+out:
+	mutex_unlock(&padctl->lock);
+	return 0;
+}
+
+static const struct phy_ops utmi_phy_ops = {
+	.init = tegra_xusb_phy_init,
+	.exit = tegra_xusb_phy_exit,
+	.power_on = utmi_phy_power_on,
+	.power_off = utmi_phy_power_off,
+	.owner = THIS_MODULE,
+};
+
+static int hsic_phy_to_port(struct phy *phy)
+{
+	struct tegra_xusb_padctl *padctl = phy_get_drvdata(phy);
+	int i;
+
+	for (i = 0; i < TEGRA_XUSB_PADCTL_HSIC_PORTS; i++) {
+		if (phy == padctl->phys[TEGRA_XUSB_PADCTL_HSIC_P0 + i])
+			break;
+	}
+	BUG_ON(i == TEGRA_XUSB_PADCTL_HSIC_PORTS);
+
+	return i;
+}
+
+static int hsic_phy_power_on(struct phy *phy)
+{
+	struct tegra_xusb_padctl *padctl = phy_get_drvdata(phy);
+	int port = hsic_phy_to_port(phy);
+	int ret;
+	u32 value;
+
+	ret = regulator_enable(padctl->vddio_hsic);
+	if (ret)
+		return ret;
+
+	value = padctl_readl(padctl, XUSB_PADCTL_HSIC_PADX_CTL1(port));
+	value &= ~(XUSB_PADCTL_HSIC_PAD_CTL1_RPD_STROBE |
+		   XUSB_PADCTL_HSIC_PAD_CTL1_RPU_DATA |
+		   XUSB_PADCTL_HSIC_PAD_CTL1_PD_RX |
+		   XUSB_PADCTL_HSIC_PAD_CTL1_PD_ZI |
+		   XUSB_PADCTL_HSIC_PAD_CTL1_PD_TRX |
+		   XUSB_PADCTL_HSIC_PAD_CTL1_PD_TX);
+	value |= XUSB_PADCTL_HSIC_PAD_CTL1_RPD_DATA |
+		 XUSB_PADCTL_HSIC_PAD_CTL1_RPU_STROBE;
+	padctl_writel(padctl, value, XUSB_PADCTL_HSIC_PADX_CTL1(port));
+
+	return 0;
+}
+
+static int hsic_phy_power_off(struct phy *phy)
+{
+	struct tegra_xusb_padctl *padctl = phy_get_drvdata(phy);
+	int port = hsic_phy_to_port(phy);
+	u32 value;
+
+	regulator_disable(padctl->vddio_hsic);
+
+	value = padctl_readl(padctl, XUSB_PADCTL_HSIC_PADX_CTL1(port));
+	value |= XUSB_PADCTL_HSIC_PAD_CTL1_PD_RX |
+		 XUSB_PADCTL_HSIC_PAD_CTL1_PD_ZI |
+		 XUSB_PADCTL_HSIC_PAD_CTL1_PD_TRX |
+		 XUSB_PADCTL_HSIC_PAD_CTL1_PD_TX;
+	padctl_writel(padctl, value, XUSB_PADCTL_HSIC_PADX_CTL1(port));
+
+	return 0;
+}
+
+static void hsic_phy_set_idle(struct tegra_xusb_padctl *padctl, int port,
+			      bool set)
+{
+	u32 value;
+
+	value = padctl_readl(padctl, XUSB_PADCTL_HSIC_PADX_CTL1(port));
+	if (set)
+		value |= XUSB_PADCTL_HSIC_PAD_CTL1_RPD_DATA |
+			 XUSB_PADCTL_HSIC_PAD_CTL1_RPU_STROBE;
+	else
+		value &= ~(XUSB_PADCTL_HSIC_PAD_CTL1_RPD_DATA |
+			   XUSB_PADCTL_HSIC_PAD_CTL1_RPU_STROBE);
+	padctl_writel(padctl, value, XUSB_PADCTL_HSIC_PADX_CTL1(port));
+}
+
+static const struct phy_ops hsic_phy_ops = {
+	.init = tegra_xusb_phy_init,
+	.exit = tegra_xusb_phy_exit,
+	.power_on = hsic_phy_power_on,
+	.power_off = hsic_phy_power_off,
+	.owner = THIS_MODULE,
+};
+
+static int tegra_xusb_phy_mbox_notifier(struct notifier_block *nb,
+					unsigned long event, void *p)
+{
+	struct tegra_xusb_padctl *padctl = container_of(nb,
+						struct tegra_xusb_padctl,
+						mbox_nb);
+	struct tegra_xusb_mbox_msg *msg = (struct tegra_xusb_mbox_msg *)p;
+	u32 ports;
+	int i;
+
+	switch (event) {
+	case MBOX_CMD_SAVE_DFE_CTLE_CTX:
+		msg->data_out = msg->data_in;
+		if (msg->data_in > TEGRA_XUSB_PADCTL_USB3_PORTS) {
+			msg->cmd_out = MBOX_CMD_NAK;
+		} else {
+			usb3_phy_save_context(padctl, msg->data_in);
+			msg->cmd_out = MBOX_CMD_ACK;
+		}
+		return NOTIFY_STOP;
+	case MBOX_CMD_START_HSIC_IDLE:
+	case MBOX_CMD_STOP_HSIC_IDLE:
+		ports = msg->data_in >> (padctl->soc->hsic_port_offset + 1);
+		msg->data_out = msg->data_in;
+		for (i = 0; i < TEGRA_XUSB_PADCTL_HSIC_PORTS; i++) {
+			if (!(ports & BIT(i)))
+				continue;
+			if (event == MBOX_CMD_START_HSIC_IDLE)
+				hsic_phy_set_idle(padctl, i, true);
+			else
+				hsic_phy_set_idle(padctl, i, false);
+		}
+		msg->cmd_out = MBOX_CMD_ACK;
+		return NOTIFY_STOP;
+	default:
+		return NOTIFY_DONE;
+	}
+}
+
 static struct phy *tegra_xusb_padctl_xlate(struct device *dev,
 					   struct of_phandle_args *args)
 {
@@ -610,19 +1598,6 @@ static struct phy *tegra_xusb_padctl_xlate(struct device *dev,
 	return padctl->phys[index];
 }
 
-#define PIN_OTG_0   0
-#define PIN_OTG_1   1
-#define PIN_OTG_2   2
-#define PIN_ULPI_0  3
-#define PIN_HSIC_0  4
-#define PIN_HSIC_1  5
-#define PIN_PCIE_0  6
-#define PIN_PCIE_1  7
-#define PIN_PCIE_2  8
-#define PIN_PCIE_3  9
-#define PIN_PCIE_4 10
-#define PIN_SATA_0 11
-
 static const struct pinctrl_pin_desc tegra124_pins[] = {
 	PINCTRL_PIN(PIN_OTG_0,  "otg-0"),
 	PINCTRL_PIN(PIN_OTG_1,  "otg-1"),
@@ -780,6 +1755,15 @@ static const struct tegra_xusb_padctl_soc tegra124_soc = {
 	.functions = tegra124_functions,
 	.num_lanes = ARRAY_SIZE(tegra124_lanes),
 	.lanes = tegra124_lanes,
+	.rx_wander = 0xf,
+	.rx_eq = 0xf070,
+	.cdr_cntl = 0x24,
+	.dfe_cntl = 0x002008ee,
+	.hs_slew = 0xe,
+	.ls_rslew = {0x3, 0x0, 0x0},
+	.hs_discon_level = 0x5,
+	.spare_in = 0x1,
+	.hsic_port_offset = 6,
 };
 
 static const struct of_device_id tegra_xusb_padctl_of_match[] = {
@@ -788,13 +1772,40 @@ static const struct of_device_id tegra_xusb_padctl_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, tegra_xusb_padctl_of_match);
 
+static int tegra_xusb_read_fuse_calibration(struct tegra_xusb_padctl *padctl)
+{
+	int i, ret;
+	u32 value;
+
+	ret = tegra_fuse_readl(TEGRA_FUSE_SKU_CALIB_0, &value);
+	if (ret < 0)
+		return ret;
+
+	for (i = 0; i < TEGRA_XUSB_PADCTL_UTMI_PORTS; i++) {
+		padctl->calib.hs_curr_level[i] =
+			(value >> FUSE_SKU_CALIB_HS_CURR_LEVEL_PADX_SHIFT(i)) &
+			FUSE_SKU_CALIB_HS_CURR_LEVEL_PAD_MASK;
+	}
+	padctl->calib.hs_iref_cap =
+		(value >> FUSE_SKU_CALIB_HS_IREF_CAP_SHIFT) &
+		FUSE_SKU_CALIB_HS_IREF_CAP_MASK;
+	padctl->calib.hs_term_range_adj =
+		(value >> FUSE_SKU_CALIB_HS_TERM_RANGE_ADJ_SHIFT) &
+		FUSE_SKU_CALIB_HS_TERM_RANGE_ADJ_MASK;
+	padctl->calib.hs_squelch_level =
+		(value >> FUSE_SKU_CALIB_HS_SQUELCH_LEVEL_SHIFT) &
+		FUSE_SKU_CALIB_HS_SQUELCH_LEVEL_MASK;
+
+	return 0;
+}
+
 static int tegra_xusb_padctl_probe(struct platform_device *pdev)
 {
 	struct tegra_xusb_padctl *padctl;
 	const struct of_device_id *match;
 	struct resource *res;
 	struct phy *phy;
-	int err;
+	int err, i;
 
 	padctl = devm_kzalloc(&pdev->dev, sizeof(*padctl), GFP_KERNEL);
 	if (!padctl)
@@ -812,6 +1823,10 @@ static int tegra_xusb_padctl_probe(struct platform_device *pdev)
 	if (IS_ERR(padctl->regs))
 		return PTR_ERR(padctl->regs);
 
+	err = tegra_xusb_read_fuse_calibration(padctl);
+	if (err < 0)
+		return err;
+
 	padctl->rst = devm_reset_control_get(&pdev->dev, NULL);
 	if (IS_ERR(padctl->rst))
 		return PTR_ERR(padctl->rst);
@@ -852,6 +1867,54 @@ static int tegra_xusb_padctl_probe(struct platform_device *pdev)
 	padctl->phys[TEGRA_XUSB_PADCTL_SATA] = phy;
 	phy_set_drvdata(phy, padctl);
 
+	for (i = 0; i < TEGRA_XUSB_PADCTL_USB3_PORTS; i++) {
+		phy = devm_phy_create(&pdev->dev, &usb3_phy_ops, NULL);
+		if (IS_ERR(phy)) {
+			err = PTR_ERR(phy);
+			goto unregister;
+		}
+
+		padctl->phys[TEGRA_XUSB_PADCTL_USB3_P0 + i] = phy;
+		phy_set_drvdata(phy, padctl);
+	}
+
+	for (i = 0; i < TEGRA_XUSB_PADCTL_UTMI_PORTS; i++) {
+		char reg_name[sizeof("vbus-otg-N")];
+
+		sprintf(reg_name, "vbus-otg-%d", i);
+		padctl->vbus[i] = devm_regulator_get(&pdev->dev, reg_name);
+		if (IS_ERR(padctl->vbus[i])) {
+			err = PTR_ERR(padctl->vbus[i]);
+			goto unregister;
+		}
+
+		phy = devm_phy_create(&pdev->dev, &utmi_phy_ops, NULL);
+		if (IS_ERR(phy)) {
+			err = PTR_ERR(phy);
+			goto unregister;
+		}
+
+		padctl->phys[TEGRA_XUSB_PADCTL_UTMI_P0 + i] = phy;
+		phy_set_drvdata(phy, padctl);
+	}
+
+	padctl->vddio_hsic = devm_regulator_get(&pdev->dev, "vddio-hsic");
+	if (IS_ERR(padctl->vddio_hsic)) {
+		err = PTR_ERR(padctl->vddio_hsic);
+		goto unregister;
+	}
+
+	for (i = 0; i < TEGRA_XUSB_PADCTL_HSIC_PORTS; i++) {
+		phy = devm_phy_create(&pdev->dev, &hsic_phy_ops, NULL);
+		if (IS_ERR(phy)) {
+			err = PTR_ERR(phy);
+			goto unregister;
+		}
+
+		padctl->phys[TEGRA_XUSB_PADCTL_HSIC_P0 + i] = phy;
+		phy_set_drvdata(phy, padctl);
+	}
+
 	padctl->provider = devm_of_phy_provider_register(&pdev->dev,
 							 tegra_xusb_padctl_xlate);
 	if (err < 0) {
@@ -859,6 +1922,13 @@ static int tegra_xusb_padctl_probe(struct platform_device *pdev)
 		goto unregister;
 	}
 
+	padctl->mbox = tegra_xusb_mbox_lookup_by_phandle(pdev->dev.of_node,
+							 "nvidia,xusb-mbox");
+	if (IS_ERR(padctl->mbox))
+		return PTR_ERR(padctl->mbox);
+	padctl->mbox_nb.notifier_call = tegra_xusb_phy_mbox_notifier;
+	tegra_xusb_mbox_register_notifier(padctl->mbox, &padctl->mbox_nb);
+
 	return 0;
 
 unregister:
@@ -873,6 +1943,8 @@ static int tegra_xusb_padctl_remove(struct platform_device *pdev)
 	struct tegra_xusb_padctl *padctl = platform_get_drvdata(pdev);
 	int err;
 
+	tegra_xusb_mbox_unregister_notifier(padctl->mbox, &padctl->mbox_nb);
+
 	pinctrl_unregister(padctl->pinctrl);
 
 	err = reset_control_assert(padctl->rst);
-- 
2.0.0.526.g5318336

