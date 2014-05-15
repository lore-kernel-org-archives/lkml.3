Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbaEOAdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 20:33:49 -0400
Received: from mail-oa0-f74.google.com ([209.85.219.74]:63873 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbaEOAdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 20:33:18 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: linux-tegra@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [RFC PATCH 07/10] phy: Add Tegra XUSB PHY driver
Date: Wed, 14 May 2014 17:33:03 -0700
Message-Id: <1400113986-339-8-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <1400113986-339-1-git-send-email-abrestic@chromium.org>
References: <1400113986-339-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the Tegra XUSB PHY present on Tegra114 and Tegra124 SoCs.
This provides all PHY functionality for the Tegra XHCI host-controller
driver and supports UTMI, HSIC, and SuperSpeed interfaces.

While this PHY driver currently only handles USB, the SATA and PCIe
PHYs are programmed in a similar way using the same register set.
The driver could be extended in the future to support these PHY
types as well.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 .../bindings/phy/nvidia,tegra-xusb-phy.txt         |   76 ++
 drivers/phy/Kconfig                                |   11 +
 drivers/phy/Makefile                               |    1 +
 drivers/phy/phy-tegra-xusb.c                       | 1171 ++++++++++++++++++++
 drivers/phy/phy-tegra-xusb.h                       |  270 +++++
 5 files changed, 1529 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/nvidia,tegra-xusb-phy.txt
 create mode 100644 drivers/phy/phy-tegra-xusb.c
 create mode 100644 drivers/phy/phy-tegra-xusb.h

diff --git a/Documentation/devicetree/bindings/phy/nvidia,tegra-xusb-phy.txt b/Documentation/devicetree/bindings/phy/nvidia,tegra-xusb-phy.txt
new file mode 100644
index 0000000..6d819f9
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/nvidia,tegra-xusb-phy.txt
@@ -0,0 +1,76 @@
+NVIDIA Tegra XUSB PHY
+
+The device node for the Tegra XUSB PHY present on Tegra114 and later SoCs.
+
+Required properties:
+ - compatible: Should be "nvidia,tegra114-xusb-phy" or
+   "nvidia,tegra124-xusb-phy".
+ - reg: Address and length of the XUSB_PADCTL register set.
+ - clocks: Handles to XUSB SS, SS source, HS source, FS source, PLL_U_480M,
+   CLK_M, and PLLE.  Note that PLL_U_480M and CLK_M are only necessary
+   on Tegra124.
+ - clock-names: Should be "xusb_ss", "xusb_ss_src", "xusb_hs_src",
+   "xusb_fs_src", "pll_u_480M", "clk_m",and "pll_e" respectively.
+ - resets: Handle to the XUSB SS reset.
+ - reset-names: Should be "xusb_ss".
+ - nvidia,clkrst: Handle to the clock-reset module syscon node.
+ - nvidia,ss-pads: Bitmap of enabled SuperSpeed pads:
+     bit 0 - SuperSpeed port 0
+     bit 1 - SuperSpeed port 1
+ - nvidia,utmi-pads: Bitmap of enabled USB2.0 UTMI pads:
+     bit 0 - UTMI port 0
+     bit 1 - UTMI port 1
+     bit 2 - UTMI port 2 (Tegra124 only)
+ - nvidia,hsic-pads: Bitmap of enabled USB2.0 HSIC pads:
+     bit 0 - HSIC port 0
+     bit 1 - HSIC port 1
+ - nvidia,hsic{0,1}-config: byte array with 9 elements specifiying the
+   configuration for the corresponding HISC port:
+     byte 0 - rx_strobe_trim
+     byte 1 - rx_data_trim
+     byte 2 - tx_rtune_n
+     byte 3 - tx_rtune_p
+     byte 4 - tx_slew_n
+     byte 5 - tx_slew_p
+     byte 6 - auto_term_en
+     byte 7 - strb_trim_val
+     byte 8 - pretend_connect
+   Only required for enabled HISC ports.
+ - nvidia,ss-port{0,1}-map: Mapping from SS port to its corresponding USB2.0
+   port.  Both fields have valid values from 0 to 2 (USB2.0 ports 0, 1, 2).
+   Only required for enabled SS pads.
+ - vbus{1,2,3}-supply: VBUS regulator for the corresponding UTMI pad.
+   Only required when the respective UTMI pad is enabled.
+ - vddio-hsic-supply: HSIC supply regulator.  Only required when HSIC ports
+   are enabled.
+Optional properties:
+ - nvidia,use-sata-lane: Should be set if SS port 1 is mapped to the SATA
+   lane.  Only applicable on Tegra124.
+
+Example:
+	phy@0,7009f000 {
+		compatible = "nvidia,tegra124-xusb-phy";
+		reg = <0x0 0x7009f000 0x0 0x1000>;
+		#phy-cells = <0>;
+		clocks = <&tegra_car TEGRA124_CLK_XUSB_SS>,
+			 <&tegra_car TEGRA124_CLK_XUSB_SS_SRC>,
+			 <&tegra_car TEGRA124_CLK_XUSB_HS_SRC>,
+			 <&tegra_car TEGRA124_CLK_XUSB_FS_SRC>,
+			 <&tegra_car TEGRA124_CLK_PLL_U_480M>,
+			 <&tegra_car TEGRA124_CLK_CLK_M>,
+			 <&tegra_car TEGRA124_CLK_PLL_E>;
+		clock-names = "xusb_ss", "xusb_ss_src", "xusb_hs_src",
+			      "xusb_fs_src", "pll_u_480M", "clk_m",
+			      "pll_e";
+		resets = <&tegra_car 156>;
+		reset-names = "xusb_ss";
+		nvidia,clkrst = <&tegra_car>;
+		nvidia,ss-pads = <0x3>;
+		nvidia,hsic-pads = <0x0>;
+		nvidia,utmi-pads = <0x7>;
+		nvidia,ss-port0-map = <0>;
+		nvidia,ss-port1-map = <2>;
+		vbus1-supply = <&vdd_usb1_vbus>;
+		vbus2-supply = <&vdd_run_cam>;
+		vbus3-supply = <&vdd_usb3_vbus>;
+	};
diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 3bb05f1..8eb65ae 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -159,6 +159,17 @@ config PHY_EXYNOS5250_USB2
 	  particular SoC is compiled in the driver. In case of Exynos 5250 four
 	  phys are available - device, host, HSIC0 and HSIC.
 
+config PHY_TEGRA_XUSB
+	tristate "Support for NVIDIA Tegra XUSB PHY"
+	depends on USB_XHCI_TEGRA
+	select GENERIC_PHY
+	select MFD_SYSCON
+	help
+	  Enable this to support the XUSB PHY present on NVIDIA Tegra114
+	  and later SoCs.  This driver supports UTMI, HSIC, and SuperSpeed
+	  interfaces and handles all host PHY functionality for the Tegra
+	  XHCI host-controller driver.
+
 config PHY_XGENE
 	tristate "APM X-Gene 15Gbps PHY support"
 	depends on HAS_IOMEM && OF && (ARM64 || COMPILE_TEST)
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index 2faf78e..f682a8e 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -17,4 +17,5 @@ obj-$(CONFIG_PHY_SAMSUNG_USB2)		+= phy-samsung-usb2.o
 obj-$(CONFIG_PHY_EXYNOS4210_USB2)	+= phy-exynos4210-usb2.o
 obj-$(CONFIG_PHY_EXYNOS4X12_USB2)	+= phy-exynos4x12-usb2.o
 obj-$(CONFIG_PHY_EXYNOS5250_USB2)	+= phy-exynos5250-usb2.o
+obj-$(CONFIG_PHY_TEGRA_XUSB)		+= phy-tegra-xusb.o
 obj-$(CONFIG_PHY_XGENE)			+= phy-xgene.o
diff --git a/drivers/phy/phy-tegra-xusb.c b/drivers/phy/phy-tegra-xusb.c
new file mode 100644
index 0000000..78d2398
--- /dev/null
+++ b/drivers/phy/phy-tegra-xusb.c
@@ -0,0 +1,1171 @@
+/*
+ * NVIDIA Tegra XUSB PHY driver
+ *
+ * Copyright (C) 2014 NVIDIA Corporation
+ * Copyright (C) 2014 Google, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/export.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/mfd/syscon.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/tegra-soc.h>
+#include <linux/regmap.h>
+#include <linux/regulator/consumer.h>
+#include <linux/reset.h>
+#include <linux/resource.h>
+#include <linux/phy/phy.h>
+#include <linux/usb/tegra_xusb.h>
+
+#include "phy-tegra-xusb.h"
+
+struct tegra_xusb_hsic_config {
+	u8 rx_strobe_trim;
+	u8 rx_data_trim;
+	u8 tx_rtune_n;
+	u8 tx_rtune_p;
+	u8 tx_slew_n;
+	u8 tx_slew_p;
+	u8 auto_term_en;
+	u8 strb_trim_val;
+	u8 pretend_connect;
+};
+
+struct tegra_xusb_phy_calib_data {
+	u32 hs_curr_level_pad[TEGRA_XUSB_UTMI_COUNT];
+	u32 hs_iref_cap;
+	u32 hs_term_range_adj;
+	u32 hs_squelch_level;
+};
+
+struct tegra_xusb_phy_board_data {
+	unsigned long utmi_pads;
+	unsigned long hsic_pads;
+	unsigned long ss_pads;
+	bool use_sata_lane;
+	int ss_portmap[TEGRA_XUSB_SS_COUNT];
+	struct tegra_xusb_hsic_config hsic[TEGRA_XUSB_HSIC_COUNT];
+};
+
+struct tegra_xusb_phy_soc_config {
+	bool ss_idle_mode_ovrd;
+	bool has_ctle;
+	bool scale_ss_clk;
+	int num_utmi_pads;
+	u32 rx_wander;
+	u32 rx_eq;
+	u32 cdr_cntl;
+	u32 dfe_cntl;
+	u32 hs_slew;
+	u32 ls_rslew_pad[TEGRA_XUSB_UTMI_COUNT];
+	u32 hs_disc_lvl;
+	u32 spare_in;
+	int hsic_port_offset;
+	const struct tegra_xusb_padctl_regs *padctl_offsets;
+};
+
+struct tegra_xusb_phy {
+	struct device *dev;
+
+	void __iomem *padctl_regs;
+	struct regmap *clkrst_regs;
+
+	struct notifier_block mbox_nb;
+
+	struct clk *ss_src_clk;
+	struct clk *hs_src_clk;
+	struct clk *fs_src_clk;
+	struct clk *ss_clk;
+	struct clk *pll_u_480M;
+	struct clk *clk_m;
+	struct clk *plle;
+	struct reset_control *ss_rst;
+
+	struct regulator *utmi_vbus[TEGRA_XUSB_UTMI_COUNT];
+	struct regulator *vddio_hsic;
+
+	/* DFE and CTLE context */
+	bool ss_ctx_saved[TEGRA_XUSB_SS_COUNT];
+	u8 tap1_val[TEGRA_XUSB_SS_COUNT];
+	u8 amp_val[TEGRA_XUSB_SS_COUNT];
+	u8 ctle_z_val[TEGRA_XUSB_SS_COUNT];
+	u8 ctle_g_val[TEGRA_XUSB_SS_COUNT];
+
+	struct tegra_xusb_phy_board_data board_data;
+	struct tegra_xusb_phy_calib_data calib_data;
+	const struct tegra_xusb_phy_soc_config *soc_config;
+};
+
+static inline u32 padctl_readl(struct tegra_xusb_phy *tegra, u32 reg)
+{
+	BUG_ON(reg == PADCTL_REG_NONE);
+	return readl(tegra->padctl_regs + reg);
+}
+
+static inline void padctl_writel(struct tegra_xusb_phy *tegra, u32 val, u32 reg)
+{
+	BUG_ON(reg == PADCTL_REG_NONE);
+	writel(val, tegra->padctl_regs + reg);
+}
+
+static inline u32 clkrst_readl(struct tegra_xusb_phy *tegra, u32 reg)
+{
+	u32 val;
+
+	regmap_read(tegra->clkrst_regs, reg, &val);
+	return val;
+}
+
+static inline void clkrst_writel(struct tegra_xusb_phy *tegra, u32 val, u32 reg)
+{
+	regmap_write(tegra->clkrst_regs, reg, val);
+}
+
+static void hsic_pad_init(struct tegra_xusb_phy *tegra, int pad)
+{
+	const struct tegra_xusb_padctl_regs *padregs;
+	struct tegra_xusb_hsic_config *hsic = &tegra->board_data.hsic[pad];
+	u32 reg;
+
+	padregs = tegra->soc_config->padctl_offsets;
+	reg = padctl_readl(tegra, padregs->usb2_hsic_padX_ctlY_0[pad][2]);
+	reg &= ~(USB2_HSIC_RX_STROBE_TRIM(~0) | USB2_HSIC_RX_DATA_TRIM(~0));
+	reg |= USB2_HSIC_RX_STROBE_TRIM(hsic->rx_strobe_trim) |
+		USB2_HSIC_RX_DATA_TRIM(hsic->rx_data_trim);
+	padctl_writel(tegra, reg, padregs->usb2_hsic_padX_ctlY_0[pad][2]);
+
+	reg = padctl_readl(tegra, padregs->usb2_hsic_padX_ctlY_0[pad][0]);
+	reg &= ~(USB2_HSIC_TX_RTUNEP(~0) | USB2_HSIC_TX_RTUNEN(~0) |
+		 USB2_HSIC_TX_SLEWP(~0) | USB2_HSIC_TX_SLEWN(~0));
+	reg |= USB2_HSIC_TX_RTUNEP(hsic->tx_rtune_p) |
+		USB2_HSIC_TX_RTUNEN(hsic->tx_rtune_n) |
+		USB2_HSIC_TX_SLEWP(hsic->tx_slew_p) |
+		USB2_HSIC_TX_SLEWN(hsic->tx_slew_n);
+	padctl_writel(tegra, reg, padregs->usb2_hsic_padX_ctlY_0[pad][0]);
+
+	reg = padctl_readl(tegra, padregs->usb2_hsic_padX_ctlY_0[pad][1]);
+	if (hsic->auto_term_en)
+		reg |= USB2_HSIC_AUTO_TERM_EN;
+	else
+		reg &= ~USB2_HSIC_AUTO_TERM_EN;
+	padctl_writel(tegra, reg, padregs->usb2_hsic_padX_ctlY_0[pad][1]);
+
+	reg = padctl_readl(tegra, padregs->hsic_strb_trim_ctl0);
+	reg &= ~HSIC_STRB_TRIM(~0);
+	reg |= HSIC_STRB_TRIM(hsic->strb_trim_val);
+	padctl_writel(tegra, reg, padregs->hsic_strb_trim_ctl0);
+
+	reg = padctl_readl(tegra, padregs->usb2_pad_mux_0);
+	reg |= USB2_HSIC_PAD_PORT(pad);
+	padctl_writel(tegra, reg, padregs->usb2_pad_mux_0);
+}
+
+static void hsic_pad_enable(struct tegra_xusb_phy *tegra, int pad)
+{
+	const struct tegra_xusb_padctl_regs *padregs;
+	u32 reg;
+
+	padregs = tegra->soc_config->padctl_offsets;
+
+	reg = padctl_readl(tegra, padregs->usb2_hsic_padX_ctlY_0[pad][1]);
+	reg &= ~(USB2_HSIC_RPD_DATA | USB2_HSIC_RPD_STROBE |
+		 USB2_HSIC_RPU_DATA | USB2_HSIC_RPU_STROBE |
+		 USB2_HSIC_PD_RX | USB2_HSIC_PD_ZI |
+		 USB2_HSIC_PD_TRX | USB2_HSIC_PD_TX);
+	/* Keep HSIC in IDLE */
+	reg |= USB2_HSIC_RPD_DATA | USB2_HSIC_RPU_STROBE;
+	padctl_writel(tegra, reg, padregs->usb2_hsic_padX_ctlY_0[pad][1]);
+}
+
+static void hsic_pad_disable(struct tegra_xusb_phy *tegra, int pad)
+{
+	const struct tegra_xusb_padctl_regs *padregs;
+	u32 reg;
+
+	padregs = tegra->soc_config->padctl_offsets;
+
+	reg = padctl_readl(tegra, padregs->usb2_hsic_padX_ctlY_0[pad][1]);
+	reg |= (USB2_HSIC_PD_RX | USB2_HSIC_PD_ZI | USB2_HSIC_PD_TRX |
+		USB2_HSIC_PD_TX);
+	padctl_writel(tegra, reg, padregs->usb2_hsic_padX_ctlY_0[pad][1]);
+}
+
+static void hsic_pad_set_idle(struct tegra_xusb_phy *tegra, int pad, bool set)
+{
+	const struct tegra_xusb_padctl_regs *padregs;
+	u32 reg;
+
+	padregs = tegra->soc_config->padctl_offsets;
+
+	reg = padctl_readl(tegra, padregs->usb2_hsic_padX_ctlY_0[pad][1]);
+	reg &= ~(USB2_HSIC_RPD_DATA | USB2_HSIC_RPD_STROBE |
+		 USB2_HSIC_RPU_DATA | USB2_HSIC_RPU_STROBE);
+	if (set)
+		reg |= USB2_HSIC_RPD_DATA | USB2_HSIC_RPU_STROBE;
+	padctl_writel(tegra, reg, padregs->usb2_hsic_padX_ctlY_0[pad][1]);
+}
+
+static void utmi_pad_init(struct tegra_xusb_phy *tegra, int pad)
+{
+	const struct tegra_xusb_padctl_regs *padregs;
+	u32 reg;
+
+	padregs = tegra->soc_config->padctl_offsets;
+
+	reg = padctl_readl(tegra, padregs->usb2_bias_pad_ctlY_0[0]);
+	reg &= ~(USB2_BIAS_HS_SQUELCH_LEVEL(~0) |
+		 USB2_BIAS_HS_DISCON_LEVEL(~0));
+	reg |= USB2_BIAS_HS_SQUELCH_LEVEL(tegra->calib_data.hs_squelch_level) |
+		USB2_BIAS_HS_DISCON_LEVEL(tegra->soc_config->hs_disc_lvl);
+	padctl_writel(tegra, reg, padregs->usb2_bias_pad_ctlY_0[0]);
+
+	reg = padctl_readl(tegra, padregs->usb2_pad_mux_0);
+	reg &= ~USB2_OTG_PAD_PORT_MASK(pad);
+	reg |= USB2_OTG_PAD_PORT_OWNER_XUSB(pad);
+	padctl_writel(tegra, reg, padregs->usb2_pad_mux_0);
+
+	reg = padctl_readl(tegra, padregs->usb2_port_cap_0);
+	reg &= ~USB2_PORT_CAP_MASK(pad);
+	reg |= USB2_PORT_CAP_HOST(pad);
+	padctl_writel(tegra, reg, padregs->usb2_port_cap_0);
+
+	reg = padctl_readl(tegra, padregs->usb2_otg_padX_ctlY_0[pad][0]);
+	reg &= ~(USB2_OTG_HS_CURR_LVL(~0) | USB2_OTG_HS_SLEW(~0) |
+		 USB2_OTG_FS_SLEW(~0) | USB2_OTG_LS_RSLEW(~0) |
+		 USB2_OTG_PD | USB2_OTG_PD2 | USB2_OTG_PD_ZI);
+	reg |= USB2_OTG_HS_SLEW(tegra->soc_config->hs_slew) |
+		USB2_OTG_LS_RSLEW(tegra->soc_config->ls_rslew_pad[pad]) |
+		USB2_OTG_HS_CURR_LVL(tegra->calib_data.hs_curr_level_pad[pad]);
+	padctl_writel(tegra, reg, padregs->usb2_otg_padX_ctlY_0[pad][0]);
+
+	reg = padctl_readl(tegra, padregs->usb2_otg_padX_ctlY_0[pad][1]);
+	reg &= ~(USB2_OTG_TERM_RANGE_AD(~0) | USB2_OTG_HS_IREF_CAP(~0) |
+		 USB2_OTG_PD_DR | USB2_OTG_PD_CHRP_FORCE_POWERUP |
+		 USB2_OTG_PD_DISC_FORCE_POWERUP);
+	reg |= USB2_OTG_HS_IREF_CAP(tegra->calib_data.hs_iref_cap) |
+		USB2_OTG_TERM_RANGE_AD(tegra->calib_data.hs_term_range_adj);
+	padctl_writel(tegra, reg, padregs->usb2_otg_padX_ctlY_0[pad][1]);
+}
+
+static void utmi_pads_enable(struct tegra_xusb_phy *tegra)
+{
+	const struct tegra_xusb_padctl_regs *padregs;
+	u32 val;
+
+	padregs = tegra->soc_config->padctl_offsets;
+
+	val = padctl_readl(tegra, padregs->usb2_bias_pad_ctlY_0[0]);
+	val &= ~USB2_BIAS_PD;
+	padctl_writel(tegra, val, padregs->usb2_bias_pad_ctlY_0[0]);
+}
+
+static void utmi_pads_disable(struct tegra_xusb_phy *tegra)
+{
+	const struct tegra_xusb_padctl_regs *padregs;
+	u32 val;
+
+	padregs = tegra->soc_config->padctl_offsets;
+
+	val = padctl_readl(tegra, padregs->usb2_bias_pad_ctlY_0[0]);
+	val |= USB2_BIAS_PD;
+	padctl_writel(tegra, val, padregs->usb2_bias_pad_ctlY_0[0]);
+}
+
+static void ss_save_context(struct tegra_xusb_phy *tegra, int pad)
+{
+	const struct tegra_xusb_padctl_regs *padregs;
+	u32 offset;
+	u32 reg;
+
+	padregs = tegra->soc_config->padctl_offsets;
+	tegra->ss_ctx_saved[pad] = true;
+
+	if (pad == 1 && tegra->board_data.use_sata_lane)
+		offset = padregs->iophy_misc_pad_s0_ctlY_0[5];
+	else
+		offset = padregs->iophy_misc_pad_pX_ctlY_0[pad][5];
+
+	reg = padctl_readl(tegra, offset);
+	reg &= ~IOPHY_MISC_OUT_SEL(~0);
+	reg |= IOPHY_MISC_OUT_SEL(IOPHY_MISC_OUT_SEL_TAP);
+	padctl_writel(tegra, reg, offset);
+
+	reg = padctl_readl(tegra, offset);
+	tegra->tap1_val[pad] = IOPHY_MISC_OUT_TAP_VAL(reg);
+
+	reg = padctl_readl(tegra, offset);
+	reg &= ~IOPHY_MISC_OUT_SEL(~0);
+	reg |= IOPHY_MISC_OUT_SEL(IOPHY_MISC_OUT_SEL_AMP);
+	padctl_writel(tegra, reg, offset);
+
+	reg = padctl_readl(tegra, offset);
+	tegra->amp_val[pad] = IOPHY_MISC_OUT_AMP_VAL(reg);
+
+	reg = padctl_readl(tegra, padregs->iophy_usb3_padX_ctlY_0[pad][3]);
+	reg &= ~IOPHY_USB3_DFE_CNTL_TAP(~0);
+	reg |= IOPHY_USB3_DFE_CNTL_TAP(tegra->tap1_val[pad]);
+	padctl_writel(tegra, reg, padregs->iophy_usb3_padX_ctlY_0[pad][3]);
+
+	reg = padctl_readl(tegra, padregs->iophy_usb3_padX_ctlY_0[pad][3]);
+	reg &= ~IOPHY_USB3_DFE_CNTL_AMP(~0);
+	reg |= IOPHY_USB3_DFE_CNTL_AMP(tegra->amp_val[pad]);
+	padctl_writel(tegra, reg, padregs->iophy_usb3_padX_ctlY_0[pad][3]);
+
+	if (!tegra->soc_config->has_ctle)
+		return;
+
+	reg = padctl_readl(tegra, offset);
+	reg &= ~IOPHY_MISC_OUT_SEL(~0);
+	reg |= IOPHY_MISC_OUT_SEL(IOPHY_MISC_OUT_SEL_LATCH_G_Z);
+	padctl_writel(tegra, reg, offset);
+
+	reg = padctl_readl(tegra, offset);
+	reg &= ~IOPHY_MISC_OUT_SEL(~0);
+	reg |= IOPHY_MISC_OUT_SEL(IOPHY_MISC_OUT_SEL_G_Z);
+	padctl_writel(tegra, reg, offset);
+
+	reg = padctl_readl(tegra, offset);
+	tegra->ctle_g_val[pad] = IOPHY_MISC_OUT_G_Z_VAL(reg);
+
+	reg = padctl_readl(tegra, offset);
+	reg &= ~IOPHY_MISC_OUT_SEL(~0);
+	reg |= IOPHY_MISC_OUT_SEL(IOPHY_MISC_OUT_SEL_CTLE_Z);
+	padctl_writel(tegra, reg, offset);
+
+	reg = padctl_readl(tegra, offset);
+	tegra->ctle_z_val[pad] = IOPHY_MISC_OUT_G_Z_VAL(reg);
+
+	reg = padctl_readl(tegra, padregs->iophy_usb3_padX_ctlY_0[pad][1]);
+	reg &= ~IOPHY_USB3_RX_EQ_Z(~0);
+	reg |= IOPHY_USB3_RX_EQ_Z(tegra->ctle_z_val[pad]);
+	padctl_writel(tegra, reg, padregs->iophy_usb3_padX_ctlY_0[pad][1]);
+
+	reg = padctl_readl(tegra, padregs->iophy_usb3_padX_ctlY_0[pad][1]);
+	reg &= ~IOPHY_USB3_RX_EQ_G(~0);
+	reg |= IOPHY_USB3_RX_EQ_G(tegra->ctle_g_val[pad]);
+	padctl_writel(tegra, reg, padregs->iophy_usb3_padX_ctlY_0[pad][1]);
+}
+
+static void ss_restore_context(struct tegra_xusb_phy *tegra, int pad)
+{
+	const struct tegra_xusb_padctl_regs *padregs;
+	u32 reg;
+
+	if (!tegra->ss_ctx_saved[pad])
+		return;
+
+	padregs = tegra->soc_config->padctl_offsets;
+
+	reg = padctl_readl(tegra, padregs->iophy_usb3_padX_ctlY_0[pad][3]);
+	reg &= ~(IOPHY_USB3_DFE_CNTL_AMP(~0) |
+		 IOPHY_USB3_DFE_CNTL_TAP(~0));
+	reg |= IOPHY_USB3_DFE_CNTL_AMP(tegra->amp_val[pad]) |
+		IOPHY_USB3_DFE_CNTL_TAP(tegra->tap1_val[pad]);
+	padctl_writel(tegra, reg, padregs->iophy_usb3_padX_ctlY_0[pad][3]);
+
+	if (!tegra->soc_config->has_ctle)
+		return;
+
+	reg = padctl_readl(tegra, padregs->iophy_usb3_padX_ctlY_0[pad][1]);
+	reg &= ~(IOPHY_USB3_RX_EQ_Z(~0) | IOPHY_USB3_RX_EQ_G(~0));
+	reg |= (IOPHY_USB3_RX_EQ_Z(tegra->ctle_z_val[pad]) |
+		IOPHY_USB3_RX_EQ_G(tegra->ctle_g_val[pad]));
+	padctl_writel(tegra, reg, padregs->iophy_usb3_padX_ctlY_0[pad][1]);
+}
+
+/* Disable/enable SS wake logic */
+static void ss_set_wake(struct tegra_xusb_phy *tegra, bool on)
+{
+	const struct tegra_xusb_padctl_regs *padregs;
+	u32 val;
+	int i;
+
+	padregs = tegra->soc_config->padctl_offsets;
+	val = padctl_readl(tegra, padregs->elpg_program_0);
+	for_each_set_bit(i, &tegra->board_data.ss_pads, TEGRA_XUSB_SS_COUNT) {
+		if (on)
+			val |= SSP_ELPG_CLAMP_EN_EARLY(i);
+		else
+			val &= ~SSP_ELPG_CLAMP_EN_EARLY(i);
+	}
+	padctl_writel(tegra, val, padregs->elpg_program_0);
+
+	/*
+	 * There needs to be a delay between writes to CLAMP_EN_EARLY and
+	 * CLAMP_EN
+	 */
+	udelay(100);
+
+	val = padctl_readl(tegra, padregs->elpg_program_0);
+	for_each_set_bit(i, &tegra->board_data.ss_pads, TEGRA_XUSB_SS_COUNT) {
+		if (on)
+			val |= SSP_ELPG_CLAMP_EN(i);
+		else
+			val &= ~SSP_ELPG_CLAMP_EN(i);
+	}
+	padctl_writel(tegra, val, padregs->elpg_program_0);
+
+	/* Wait for 250us for CLAMP_EN to propagate */
+	if (on)
+		udelay(250);
+
+	val = padctl_readl(tegra, padregs->elpg_program_0);
+	for_each_set_bit(i, &tegra->board_data.ss_pads, TEGRA_XUSB_SS_COUNT) {
+		if (on)
+			val |= SSP_ELPG_VCORE_DOWN(i);
+		else
+			val &= ~SSP_ELPG_VCORE_DOWN(i);
+	}
+	padctl_writel(tegra, val, padregs->elpg_program_0);
+}
+
+static int ss_set_clock_rate(struct tegra_xusb_phy *tegra, unsigned int rate)
+{
+	unsigned int new_parent_rate, old_parent_rate, div;
+	int ret;
+	struct clk *ss_clk = tegra->ss_src_clk;
+
+	if (clk_get_rate(ss_clk) == rate)
+		return 0;
+
+	switch (rate) {
+	case SS_CLK_HIGH_SPEED:
+		/* Reparent to PLLU_480M. Set div first to avoid overclocking */
+		old_parent_rate = clk_get_rate(clk_get_parent(ss_clk));
+		new_parent_rate = clk_get_rate(tegra->pll_u_480M);
+		div = new_parent_rate / rate;
+		ret = clk_set_rate(ss_clk, old_parent_rate / div);
+		if (ret) {
+			dev_err(tegra->dev, "Failed to set SS rate: %d\n",
+				ret);
+			return ret;
+		}
+		ret = clk_set_parent(ss_clk, tegra->pll_u_480M);
+		if (ret) {
+			dev_err(tegra->dev, "Failed to set SS parent: %d\n",
+				ret);
+			return ret;
+		}
+		break;
+	case SS_CLK_LOW_SPEED:
+		/* Reparent to CLK_M */
+		ret = clk_set_parent(ss_clk, tegra->clk_m);
+		if (ret) {
+			dev_err(tegra->dev, "Failed to set SS parent: %d\n",
+				ret);
+			return ret;
+		}
+		ret = clk_set_rate(ss_clk, rate);
+		if (ret) {
+			dev_err(tegra->dev, "Failed to set SS rate: %d\n",
+				ret);
+			return ret;
+		}
+		break;
+	default:
+		dev_err(tegra->dev, "Invalid SS rate: %u\n", rate);
+		return -EINVAL;
+	}
+
+	if (clk_get_rate(ss_clk) != rate) {
+		dev_err(tegra->dev, "SS clock doesn't match requested rate\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void ss_pad_init(struct tegra_xusb_phy *tegra, int pad)
+{
+	const struct tegra_xusb_padctl_regs *padregs;
+	u32 reg;
+
+	padregs = tegra->soc_config->padctl_offsets;
+	reg = padctl_readl(tegra, padregs->iophy_usb3_padX_ctlY_0[pad][1]);
+	reg &= ~(IOPHY_USB3_RX_WANDER(~0) | IOPHY_USB3_RX_EQ(~0) |
+		 IOPHY_USB3_CDR_CNTL(~0));
+	reg |= IOPHY_USB3_RX_WANDER(tegra->soc_config->rx_wander) |
+		IOPHY_USB3_RX_EQ(tegra->soc_config->rx_eq) |
+		IOPHY_USB3_CDR_CNTL(tegra->soc_config->cdr_cntl);
+	padctl_writel(tegra, reg, padregs->iophy_usb3_padX_ctlY_0[pad][1]);
+
+	padctl_writel(tegra, tegra->soc_config->dfe_cntl,
+		      padregs->iophy_usb3_padX_ctlY_0[pad][3]);
+
+	if (pad == 1 && tegra->board_data.use_sata_lane) {
+		reg = padctl_readl(tegra, padregs->iophy_misc_pad_s0_ctlY_0[4]);
+		reg |= IOPHY_RX_QEYE_EN;
+		padctl_writel(tegra, reg, padregs->iophy_misc_pad_s0_ctlY_0[4]);
+
+		reg = padctl_readl(tegra, padregs->iophy_misc_pad_s0_ctlY_0[1]);
+		reg &= ~IOPHY_SPARE_IN(~0);
+		reg |= IOPHY_SPARE_IN(tegra->soc_config->spare_in);
+		padctl_writel(tegra, reg, padregs->iophy_misc_pad_s0_ctlY_0[1]);
+	} else {
+		reg = padctl_readl(tegra,
+			padregs->iophy_misc_pad_pX_ctlY_0[pad][4]);
+		reg |= IOPHY_RX_QEYE_EN;
+		padctl_writel(tegra, reg,
+			padregs->iophy_misc_pad_pX_ctlY_0[pad][4]);
+
+		reg = padctl_readl(tegra,
+			padregs->iophy_misc_pad_pX_ctlY_0[pad][1]);
+		reg &= ~IOPHY_SPARE_IN(~0);
+		reg |= IOPHY_SPARE_IN(tegra->soc_config->spare_in);
+		padctl_writel(tegra, reg,
+			padregs->iophy_misc_pad_pX_ctlY_0[pad][1]);
+	}
+
+	reg = padctl_readl(tegra, padregs->ss_port_map_0);
+	reg &= ~SS_PORT_MAP_MASK(pad);
+	reg |= (tegra->board_data.ss_portmap[pad] << SS_PORT_MAP_SHIFT(pad)) &
+		SS_PORT_MAP_MASK(pad);
+	padctl_writel(tegra, reg, padregs->ss_port_map_0);
+
+	ss_restore_context(tegra, pad);
+}
+
+static void ss_pad_rx_idle_mode_override(struct tegra_xusb_phy *tegra, int pad)
+{
+	const struct tegra_xusb_padctl_regs *padregs;
+	u32 reg, offset;
+
+	/* Set RX_IDLE_MODE_OVRD to save power on unused pads */
+	padregs = tegra->soc_config->padctl_offsets;
+	if (pad == 1 && tegra->board_data.use_sata_lane)
+		offset = padregs->iophy_misc_pad_s0_ctlY_0[2];
+	else
+		offset = padregs->iophy_misc_pad_pX_ctlY_0[pad][2];
+	reg = padctl_readl(tegra, offset);
+	reg &= ~IOPHY_RX_IDLE_MODE;
+	reg |= IOPHY_RX_IDLE_MODE_OVRD;
+	padctl_writel(tegra, reg, offset);
+}
+
+static void ss_lanes_init(struct tegra_xusb_phy *tegra)
+{
+	const struct tegra_xusb_padctl_regs *padregs;
+	u32 val;
+
+	padregs = tegra->soc_config->padctl_offsets;
+	if ((tegra->board_data.ss_pads & BIT(1)) &&
+	    tegra->board_data.use_sata_lane) {
+		/* Program SATA pad phy */
+		val = padctl_readl(tegra, padregs->iophy_pll_s0_ctlY_0[0]);
+		val &= ~IOPHY_PLL_PLL0_REFCLK_NDIV(~0);
+		val |= IOPHY_PLL_PLL0_REFCLK_NDIV(0x2);
+		padctl_writel(tegra, val, padregs->iophy_pll_s0_ctlY_0[0]);
+
+		val = padctl_readl(tegra, padregs->iophy_pll_s0_ctlY_0[1]);
+		val &= ~(IOPHY_PLL_XDIGCLK_SEL(~0) | IOPHY_PLL_TXCLKREF_SEL |
+			 IOPHY_PLL_TCLKOUT_EN | IOPHY_PLL_PLL0_CP_CNTL(~0) |
+			 IOPHY_PLL_PLL1_CP_CNTL(~0));
+		val |= IOPHY_PLL_XDIGCLK_SEL(0x7) | IOPHY_PLL_TXCLKREF_SEL |
+			IOPHY_PLL_PLL0_CP_CNTL(0x8) |
+			IOPHY_PLL_PLL1_CP_CNTL(0x8);
+		padctl_writel(tegra, val, padregs->iophy_pll_s0_ctlY_0[1]);
+
+		val = padctl_readl(tegra, padregs->iophy_pll_s0_ctlY_0[2]);
+		val &= ~IOPHY_PLL_RCAL_BYPASS;
+		padctl_writel(tegra, val, padregs->iophy_pll_s0_ctlY_0[2]);
+
+		/* Enable SATA PADPLL clocks */
+		val = clkrst_readl(tegra, SATA_PLL_CFG0_0);
+		val &= ~SATA_PADPLL_RESET_SWCTL;
+		val |= SATA_PADPLL_USE_LOCKDET | SATA_SEQ_START_STATE;
+		clkrst_writel(tegra, val, SATA_PLL_CFG0_0);
+
+		udelay(1);
+
+		val = clkrst_readl(tegra, SATA_PLL_CFG0_0);
+		val |= SATA_SEQ_ENABLE;
+		clkrst_writel(tegra, val, SATA_PLL_CFG0_0);
+	}
+
+	/* Program ownerhsip of lanes */
+	val = padctl_readl(tegra, padregs->usb3_pad_mux_0);
+	if (tegra->board_data.ss_pads & BIT(0)) {
+		/* Port 0 is always mapped to PCIe lane0 */
+		val &= ~USB3_PCIE_PAD_LANE_OWNER(0, ~0);
+		val |= USB3_PCIE_PAD_LANE_OWNER(0, USB3_LANE_OWNER_USB3_SS);
+	}
+	if (tegra->board_data.ss_pads & BIT(1)) {
+		/* Port 1 can either be mapped to SATA lane or PCIe lane1 */
+		if (tegra->board_data.use_sata_lane) {
+			val &= ~USB3_SATA_PAD_LANE_OWNER(~0);
+			val |= USB3_SATA_PAD_LANE_OWNER(USB3_LANE_OWNER_USB3_SS);
+		} else {
+			val &= ~USB3_PCIE_PAD_LANE_OWNER(1, ~0);
+			val |= USB3_PCIE_PAD_LANE_OWNER(1, USB3_LANE_OWNER_USB3_SS);
+		}
+	}
+	padctl_writel(tegra, val, padregs->usb3_pad_mux_0);
+
+	/* Bring enabled lane out of IDDQ */
+	val = padctl_readl(tegra, padregs->usb3_pad_mux_0);
+	if (tegra->board_data.ss_pads & BIT(0))
+		val |= USB3_FORCE_PCIE_PAD_IDDQ_DISABLE_MASK(0);
+	if (tegra->board_data.ss_pads & BIT(1)) {
+		if (tegra->board_data.use_sata_lane)
+			val |= USB3_FORCE_SATA_PAD_IDDQ_DISABLE_MASK;
+		else
+			val |= USB3_FORCE_PCIE_PAD_IDDQ_DISABLE_MASK(1);
+	}
+	padctl_writel(tegra, val, padregs->usb3_pad_mux_0);
+
+	udelay(1);
+
+	/* Release pad muxing logic state latching */
+	val = padctl_readl(tegra, padregs->elpg_program_0);
+	val &= ~AUX_MUX_LP0_CLAMP_EN;
+	padctl_writel(tegra, val, padregs->elpg_program_0);
+
+	udelay(100);
+
+	val &= ~AUX_MUX_LP0_CLAMP_EN_EARLY;
+	padctl_writel(tegra, val, padregs->elpg_program_0);
+
+	udelay(100);
+
+	val &= ~AUX_MUX_LP0_VCORE_DOWN;
+	padctl_writel(tegra, val, padregs->elpg_program_0);
+}
+
+static int tegra_xusb_phy_mbox_notifier(struct notifier_block *nb,
+					unsigned long event, void *p)
+{
+	struct tegra_xusb_phy *tegra = container_of(nb, struct tegra_xusb_phy,
+						    mbox_nb);
+	struct mbox_notifier_data *data = (struct mbox_notifier_data *)p;
+	unsigned long ports;
+	int i, pad, ret = 0;
+
+	switch (event) {
+	case MBOX_CMD_INC_SSPI_CLOCK:
+	case MBOX_CMD_DEC_SSPI_CLOCK:
+		if (!tegra->soc_config->scale_ss_clk) {
+			data->resp_cmd = MBOX_CMD_ACK;
+			data->resp_data = data->msg_data;
+			return NOTIFY_STOP;
+		}
+		ret = ss_set_clock_rate(tegra, data->msg_data * 1000);
+		data->resp_data = clk_get_rate(tegra->ss_src_clk) / 1000;
+		if (ret)
+			data->resp_cmd = MBOX_CMD_NAK;
+		else
+			data->resp_cmd = MBOX_CMD_ACK;
+		return NOTIFY_STOP;
+	case MBOX_CMD_SAVE_DFE_CTLE_CTX:
+		data->resp_data = data->msg_data;
+		if (data->msg_data > TEGRA_XUSB_SS_COUNT) {
+			data->resp_cmd = MBOX_CMD_NAK;
+		} else {
+			ss_save_context(tegra, data->msg_data);
+			data->resp_cmd = MBOX_CMD_ACK;
+		}
+		return NOTIFY_STOP;
+	case MBOX_CMD_START_HSIC_IDLE:
+	case MBOX_CMD_STOP_HSIC_IDLE:
+		ports = data->msg_data;
+		data->resp_data = ports;
+		for_each_set_bit(i, &ports, BITS_PER_LONG) {
+			pad = i - 1 - tegra->soc_config->hsic_port_offset;
+			if (pad > TEGRA_XUSB_HSIC_COUNT) {
+				ret = -EINVAL;
+				break;
+			}
+			if (event == MBOX_CMD_START_HSIC_IDLE)
+				hsic_pad_set_idle(tegra, pad, true);
+			else
+				hsic_pad_set_idle(tegra, pad, false);
+		}
+		if (ret)
+			data->resp_cmd = MBOX_CMD_NAK;
+		else
+			data->resp_cmd = MBOX_CMD_ACK;
+		return NOTIFY_STOP;
+	default:
+		return NOTIFY_DONE;
+	}
+}
+
+static int tegra_xusb_phy_init(struct phy *phy)
+{
+	struct tegra_xusb_phy *tegra = phy_get_drvdata(phy);
+	int ret, i;
+
+	tegra->mbox_nb.notifier_call = tegra_xusb_phy_mbox_notifier;
+	ret = tegra_xhci_register_mbox_notifier(&tegra->mbox_nb);
+	if (ret) {
+		dev_err(tegra->dev, "Failed to register handler\n");
+		return ret;
+	}
+
+	for_each_set_bit(i, &tegra->board_data.utmi_pads, TEGRA_XUSB_UTMI_COUNT)
+		utmi_pad_init(tegra, i);
+
+	for_each_set_bit(i, &tegra->board_data.hsic_pads, TEGRA_XUSB_HSIC_COUNT)
+		hsic_pad_init(tegra, i);
+
+	for (i = 0; i < TEGRA_XUSB_SS_COUNT; i++) {
+		if (tegra->board_data.ss_pads & BIT(i))
+			ss_pad_init(tegra, i);
+		else
+			ss_pad_rx_idle_mode_override(tegra, i);
+	}
+
+	ss_lanes_init(tegra);
+
+	return 0;
+}
+
+static int tegra_xusb_phy_exit(struct phy *phy)
+{
+	struct tegra_xusb_phy *tegra = phy_get_drvdata(phy);
+
+	tegra_xhci_unregister_mbox_notifier(&tegra->mbox_nb);
+
+	return 0;
+}
+
+static int tegra_xusb_phy_power_on(struct phy *phy)
+{
+	struct tegra_xusb_phy *tegra = phy_get_drvdata(phy);
+	int i, ret;
+
+	for_each_set_bit(i, &tegra->board_data.utmi_pads,
+			 TEGRA_XUSB_UTMI_COUNT) {
+		ret = regulator_enable(tegra->utmi_vbus[i]);
+		if (ret) {
+			dev_err(tegra->dev, "Failed to enable vbus%d\n", i);
+			return ret;
+		}
+	}
+	if (tegra->board_data.hsic_pads) {
+		ret = regulator_enable(tegra->vddio_hsic);
+		if (ret) {
+			dev_err(tegra->dev, "Failed to enable vddio-hsic\n");
+			return ret;
+		}
+	}
+
+	clk_prepare_enable(tegra->plle);
+	clk_prepare_enable(tegra->ss_clk);
+	clk_prepare_enable(tegra->hs_src_clk);
+	clk_prepare_enable(tegra->fs_src_clk);
+	if (tegra->soc_config->scale_ss_clk) {
+		ret = ss_set_clock_rate(tegra, SS_CLK_HIGH_SPEED);
+		if (ret) {
+			dev_err(tegra->dev, "Failed to set xusb_ss rate\n");
+			return ret;
+		}
+	}
+
+	ss_set_wake(tegra, false);
+
+	utmi_pads_enable(tegra);
+
+	for_each_set_bit(i, &tegra->board_data.hsic_pads, TEGRA_XUSB_HSIC_COUNT)
+		hsic_pad_enable(tegra, i);
+
+	return 0;
+}
+
+static int tegra_xusb_phy_power_off(struct phy *phy)
+{
+	struct tegra_xusb_phy *tegra = phy_get_drvdata(phy);
+	int i;
+
+	for_each_set_bit(i, &tegra->board_data.hsic_pads, TEGRA_XUSB_HSIC_COUNT)
+		hsic_pad_disable(tegra, i);
+	utmi_pads_disable(tegra);
+
+	clk_disable_unprepare(tegra->plle);
+	clk_disable_unprepare(tegra->ss_clk);
+	clk_disable_unprepare(tegra->hs_src_clk);
+	clk_disable_unprepare(tegra->fs_src_clk);
+
+	for_each_set_bit(i, &tegra->board_data.utmi_pads, TEGRA_XUSB_UTMI_COUNT)
+		regulator_disable(tegra->utmi_vbus[i]);
+	if (tegra->board_data.hsic_pads)
+		regulator_disable(tegra->vddio_hsic);
+
+	return 0;
+}
+
+static const struct tegra_xusb_padctl_regs tegra114_padctl_offsets = {
+	.boot_media_0			= 0x0,
+	.usb2_pad_mux_0			= 0x4,
+	.usb2_port_cap_0		= 0x8,
+	.snps_oc_map_0			= 0xc,
+	.usb2_oc_map_0			= 0x10,
+	.ss_port_map_0			= 0x14,
+	.oc_det_0			= 0x18,
+	.elpg_program_0			= 0x1c,
+	.usb2_bchrg_otgpadX_ctlY_0	= {
+		{0x20, PADCTL_REG_NONE},
+		{0x24, PADCTL_REG_NONE},
+		{PADCTL_REG_NONE, PADCTL_REG_NONE}
+	},
+	.usb2_bchrg_bias_pad_0		= 0x28,
+	.usb2_bchrg_tdcd_dbnc_timer_0	= 0x2c,
+	.iophy_pll_p0_ctlY_0		= {0x30, 0x34, 0x38, 0x3c},
+	.iophy_usb3_padX_ctlY_0		= {
+		{0x40, 0x48, 0x50, 0x58},
+		{0x44, 0x4c, 0x54, 0x5c}
+	},
+	.iophy_misc_pad_pX_ctlY_0	= {
+		{0x60, 0x68, 0x70, 0x78, 0x80, 0x88},
+		{0x64, 0x6c, 0x74, 0x7c, 0x84, 0x8c},
+		{PADCTL_REG_NONE, PADCTL_REG_NONE, PADCTL_REG_NONE,
+		 PADCTL_REG_NONE, PADCTL_REG_NONE},
+		{PADCTL_REG_NONE, PADCTL_REG_NONE, PADCTL_REG_NONE,
+		 PADCTL_REG_NONE, PADCTL_REG_NONE},
+		{PADCTL_REG_NONE, PADCTL_REG_NONE, PADCTL_REG_NONE,
+		 PADCTL_REG_NONE, PADCTL_REG_NONE}
+	},
+	.usb2_otg_padX_ctlY_0		= {
+		{0x90, 0x98},
+		{0x94, 0x9c},
+		{PADCTL_REG_NONE, PADCTL_REG_NONE}
+	},
+	.usb2_bias_pad_ctlY_0		= {0xa0, 0xa4},
+	.usb2_hsic_padX_ctlY_0		= {
+		{0xa8, 0xb0, 0xb8},
+		{0xac, 0xb4, 0xbc}
+	},
+	.ulpi_link_trim_ctl0		= 0xc0,
+	.ulpi_null_clk_trim_ctl0	= 0xc4,
+	.hsic_strb_trim_ctl0		= 0xc8,
+	.wake_ctl0			= 0xcc,
+	.pm_spare0			= 0xd0,
+	.usb3_pad_mux_0			= PADCTL_REG_NONE,
+	.iophy_pll_s0_ctlY_0		= {PADCTL_REG_NONE, PADCTL_REG_NONE,
+					   PADCTL_REG_NONE, PADCTL_REG_NONE},
+	.iophy_misc_pad_s0_ctlY_0	= {PADCTL_REG_NONE, PADCTL_REG_NONE,
+					   PADCTL_REG_NONE, PADCTL_REG_NONE,
+					   PADCTL_REG_NONE, PADCTL_REG_NONE},
+};
+
+static const struct tegra_xusb_padctl_regs tegra124_padctl_offsets = {
+	.boot_media_0			= 0x0,
+	.usb2_pad_mux_0			= 0x4,
+	.usb2_port_cap_0		= 0x8,
+	.snps_oc_map_0			= 0xc,
+	.usb2_oc_map_0			= 0x10,
+	.ss_port_map_0			= 0x14,
+	.oc_det_0			= 0x18,
+	.elpg_program_0			= 0x1c,
+	.usb2_bchrg_otgpadX_ctlY_0	= {
+		{0x20, 0x24},
+		{0x28, 0x2c},
+		{0x30, 0x34}
+	},
+	.usb2_bchrg_bias_pad_0		= 0x38,
+	.usb2_bchrg_tdcd_dbnc_timer_0	= 0x3c,
+	.iophy_pll_p0_ctlY_0		= {0x40, 0x44, 0x48, 0x4c},
+	.iophy_usb3_padX_ctlY_0		= {
+		{0x50, 0x58, 0x60, 0x68},
+		{0x54, 0x5c, 0x64, 0x6c}
+	},
+	.iophy_misc_pad_pX_ctlY_0	= {
+		{0x70, 0x78, 0x80, 0x88, 0x90, 0x98},
+		{0x74, 0x7c, 0x84, 0x8c, 0x94, 0x9c},
+		{0xec, 0xf8, 0x104, 0x110, 0x11c, 0x128},
+		{0xf0, 0xfc, 0x108, 0x114, 0x120, 0x12c},
+		{0xf4, 0x100, 0x10c, 0x118, 0x124, 0x130}
+	},
+	.usb2_otg_padX_ctlY_0		= {
+		{0xa0, 0xac},
+		{0xa4, 0xb0},
+		{0xa8, 0xb4}
+	},
+	.usb2_bias_pad_ctlY_0		= {0xb8, 0xbc},
+	.usb2_hsic_padX_ctlY_0		= {
+		{0xc0, 0xc8, 0xd0},
+		{0xc4, 0xcc, 0xd4}
+	},
+	.ulpi_link_trim_ctl0		= 0xd8,
+	.ulpi_null_clk_trim_ctl0	= 0xdc,
+	.hsic_strb_trim_ctl0		= 0xe0,
+	.wake_ctl0			= 0xe4,
+	.pm_spare0			= 0xe8,
+	.usb3_pad_mux_0			= 0x134,
+	.iophy_pll_s0_ctlY_0		= {0x138, 0x13c, 0x140, 0x144},
+	.iophy_misc_pad_s0_ctlY_0	= {0x148, 0x14c, 0x150, 0x154,
+					   0x158, 0x15c},
+};
+
+static const struct tegra_xusb_phy_soc_config tegra114_soc_config = {
+	.has_ctle = false,
+	.scale_ss_clk = false,
+	.num_utmi_pads = 2,
+	.rx_wander = 0x3,
+	.rx_eq = 0x3928,
+	.cdr_cntl = 0x26,
+	.dfe_cntl = 0x002008ee,
+	.hs_slew = 0xe,
+	.ls_rslew_pad = {0x3, 0x0, 0x0},
+	.hs_disc_lvl = 0x5,
+	.spare_in = 0x0,
+	.hsic_port_offset = 5,
+	.padctl_offsets = &tegra114_padctl_offsets,
+};
+
+static const struct tegra_xusb_phy_soc_config tegra124_soc_config = {
+	.has_ctle = true,
+	.scale_ss_clk = true,
+	.num_utmi_pads = 3,
+	.rx_wander = 0xf,
+	.rx_eq = 0xf070,
+	.cdr_cntl = 0x24,
+	.dfe_cntl = 0x002008ee,
+	.hs_slew = 0xe,
+	.ls_rslew_pad = {0x3, 0x0, 0x0},
+	.hs_disc_lvl = 0x5,
+	.spare_in = 0x1,
+	.hsic_port_offset = 6,
+	.padctl_offsets = &tegra124_padctl_offsets,
+};
+
+static struct phy_ops tegra_xusb_phy_ops = {
+	.init = tegra_xusb_phy_init,
+	.exit = tegra_xusb_phy_exit,
+	.power_on = tegra_xusb_phy_power_on,
+	.power_off = tegra_xusb_phy_power_off,
+	.owner = THIS_MODULE,
+};
+
+static struct of_device_id tegra_xusb_phy_id_table[] = {
+	{
+		.compatible = "nvidia,tegra114-xusb-phy",
+		.data = &tegra114_soc_config,
+	},
+	{
+		.compatible = "nvidia,tegra124-xusb-phy",
+		.data = &tegra124_soc_config,
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, tegra_xusb_phy_id_table);
+
+static int tegra_xusb_phy_parse_dt(struct tegra_xusb_phy *tegra)
+{
+	struct tegra_xusb_phy_board_data *bdata = &tegra->board_data;
+	struct device_node *np = tegra->dev->of_node;
+	u32 val;
+	int ret, i;
+
+	if (of_property_read_u32(np, "nvidia,ss-pads", &val)) {
+		dev_err(tegra->dev, "Missing SS pad map\n");
+		return -EINVAL;
+	}
+	bdata->ss_pads = val;
+	for_each_set_bit(i, &bdata->ss_pads, TEGRA_XUSB_SS_COUNT) {
+		char prop[sizeof("nvidia,ss-portN-map")];
+
+		sprintf(prop, "nvidia,ss-port%d-map", i);
+		ret = of_property_read_u32(np, prop, &val);
+		if (ret) {
+			dev_err(tegra->dev, "Missing SS port %d mapping\n", i);
+			return -EINVAL;
+		}
+		bdata->ss_portmap[i] = val;
+	}
+	bdata->use_sata_lane = of_property_read_bool(np,
+						     "nvidia,use-sata-lane");
+	if (of_property_read_u32(np, "nvidia,hsic-pads", &val)) {
+		dev_err(tegra->dev, "Missing HSIC pad map\n");
+		return -EINVAL;
+	}
+	bdata->hsic_pads = val;
+	for_each_set_bit(i, &bdata->hsic_pads, TEGRA_XUSB_HSIC_COUNT) {
+		char prop[sizeof("nvidia,hsicN-config")];
+
+		sprintf(prop, "nvidia,hsic%d-config", i);
+		ret = of_property_read_u8_array(np, prop,
+						(u8 *)&bdata->hsic[i],
+						sizeof(bdata->hsic[i]));
+		if (ret) {
+			dev_err(tegra->dev, "Missing hsic %d config\n", i);
+			return -EINVAL;
+		}
+	}
+	if (of_property_read_u32(np, "nvidia,utmi-pads", &val)) {
+		dev_err(tegra->dev, "Missing UTMI pad map\n");
+		return -EINVAL;
+	}
+	bdata->utmi_pads = val;
+
+	return 0;
+}
+
+static void tegra_xusb_phy_read_calib_data(struct tegra_xusb_phy *tegra)
+{
+	int i;
+	u32 val;
+
+	val = tegra_read_usb_calibration_data();
+	for (i = 0; i < tegra->soc_config->num_utmi_pads; i++) {
+		tegra->calib_data.hs_curr_level_pad[i] =
+			USB_CALIB_HS_CURR_LVL_PAD(val, i);
+	}
+	tegra->calib_data.hs_term_range_adj = USB_CALIB_HS_TERM_RANGE_ADJ(val);
+	tegra->calib_data.hs_squelch_level = USB_CALIB_HS_SQUELCH_LVL(val);
+	tegra->calib_data.hs_iref_cap = USB_CALIB_HS_IREF_CAP(val);
+}
+
+static int tegra_xusb_phy_probe(struct platform_device *pdev)
+{
+	const struct of_device_id *match;
+	struct resource *res;
+	struct tegra_xusb_phy *tegra;
+	struct phy *phy;
+	struct phy_provider *phy_provider;
+	int err, i;
+
+	tegra = devm_kzalloc(&pdev->dev, sizeof(*tegra), GFP_KERNEL);
+	if (!tegra)
+		return -ENOMEM;
+	tegra->dev = &pdev->dev;
+
+	match = of_match_device(tegra_xusb_phy_id_table, &pdev->dev);
+	if (!match) {
+		dev_err(&pdev->dev, "No matching device found\n");
+		return -ENODEV;
+	}
+	tegra->soc_config = match->data;
+
+	tegra_xusb_phy_read_calib_data(tegra);
+	err = tegra_xusb_phy_parse_dt(tegra);
+	if (err)
+		return err;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	tegra->padctl_regs = devm_ioremap_resource(&pdev->dev, res);
+	if (!tegra->padctl_regs) {
+		dev_err(&pdev->dev, "Failed to map padctl regs\n");
+		return -ENOMEM;
+	}
+
+	tegra->clkrst_regs = syscon_regmap_lookup_by_phandle(pdev->dev.of_node,
+							     "nvidia,clkrst");
+	if (IS_ERR(tegra->clkrst_regs)) {
+		dev_err(&pdev->dev, "Failed to get clkrst regs\n");
+		return PTR_ERR(tegra->clkrst_regs);
+	}
+
+	if (tegra->board_data.hsic_pads) {
+		tegra->vddio_hsic = devm_regulator_get(&pdev->dev,
+						       "vddio-hsic");
+		if (IS_ERR(tegra->vddio_hsic)) {
+			dev_err(&pdev->dev,
+				"Failed to get vddio-hsic regulator\n");
+			return PTR_ERR(tegra->vddio_hsic);
+		}
+	}
+
+	for_each_set_bit(i, &tegra->board_data.utmi_pads,
+			 TEGRA_XUSB_UTMI_COUNT) {
+		char reg_name[sizeof("vbusN")];
+
+		sprintf(reg_name, "vbus%d", i + 1);
+		tegra->utmi_vbus[i] = devm_regulator_get(&pdev->dev, reg_name);
+		if (IS_ERR(tegra->utmi_vbus[i])) {
+			dev_err(&pdev->dev, "Failed to get %s regulator\n",
+				reg_name);
+			return PTR_ERR(tegra->utmi_vbus[i]);
+		}
+	}
+
+	tegra->ss_rst = devm_reset_control_get(&pdev->dev, "xusb_ss");
+	if (IS_ERR(tegra->ss_rst)) {
+		dev_err(&pdev->dev, "Failed to get SS reset\n");
+		return PTR_ERR(tegra->ss_rst);
+	}
+
+	tegra->ss_src_clk = devm_clk_get(&pdev->dev, "xusb_ss_src");
+	if (IS_ERR(tegra->ss_src_clk)) {
+		dev_err(&pdev->dev, "Failed to get SS source clock\n");
+		return PTR_ERR(tegra->ss_src_clk);
+	}
+	tegra->hs_src_clk = devm_clk_get(&pdev->dev, "xusb_hs_src");
+	if (IS_ERR(tegra->hs_src_clk)) {
+		dev_err(&pdev->dev, "Failed to get HS source clock\n");
+		return PTR_ERR(tegra->hs_src_clk);
+	}
+	tegra->fs_src_clk = devm_clk_get(&pdev->dev, "xusb_fs_src");
+	if (IS_ERR(tegra->fs_src_clk)) {
+		dev_err(&pdev->dev, "Failed to get FS source clock\n");
+		return PTR_ERR(tegra->fs_src_clk);
+	}
+	tegra->ss_clk = devm_clk_get(&pdev->dev, "xusb_ss");
+	if (IS_ERR(tegra->ss_clk)) {
+		dev_err(&pdev->dev, "Failed to get SS clock\n");
+		return PTR_ERR(tegra->ss_clk);
+	}
+	if (tegra->soc_config->scale_ss_clk) {
+		tegra->pll_u_480M = devm_clk_get(&pdev->dev, "pll_u_480M");
+		if (IS_ERR(tegra->pll_u_480M)) {
+			dev_err(&pdev->dev, "Failed to get PLL_U_480M\n");
+			return PTR_ERR(tegra->pll_u_480M);
+		}
+		tegra->clk_m = devm_clk_get(&pdev->dev, "clk_m");
+		if (IS_ERR(tegra->clk_m)) {
+			dev_err(&pdev->dev, "Failed to get clk_m\n");
+			return PTR_ERR(tegra->clk_m);
+		}
+	}
+	tegra->plle = devm_clk_get(&pdev->dev, "pll_e");
+	if (IS_ERR(tegra->plle)) {
+		dev_err(&pdev->dev, "Failed to get PLLE\n");
+		return PTR_ERR(tegra->plle);
+	}
+
+	phy = devm_phy_create(&pdev->dev, &tegra_xusb_phy_ops, NULL);
+	if (IS_ERR(phy)) {
+		dev_err(&pdev->dev, "Failed to create PHY\n");
+		return PTR_ERR(phy);
+	}
+	phy_set_drvdata(phy, tegra);
+	phy_provider = devm_of_phy_provider_register(&pdev->dev,
+						     of_phy_simple_xlate);
+	if (IS_ERR(phy_provider)) {
+		dev_err(&pdev->dev, "Failed to register PHY provider\n");
+		return PTR_ERR(phy_provider);
+	}
+
+	return 0;
+}
+
+static struct platform_driver tegra_xusb_phy_driver = {
+	.probe		= tegra_xusb_phy_probe,
+	.driver		= {
+		.name	= "tegra-xusb-phy",
+		.of_match_table = of_match_ptr(tegra_xusb_phy_id_table),
+	},
+};
+module_platform_driver(tegra_xusb_phy_driver);
+
+MODULE_DESCRIPTION("Tegra XUSB PHY driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:tegra-xusb-phy");
diff --git a/drivers/phy/phy-tegra-xusb.h b/drivers/phy/phy-tegra-xusb.h
new file mode 100644
index 0000000..4cfc98b
--- /dev/null
+++ b/drivers/phy/phy-tegra-xusb.h
@@ -0,0 +1,270 @@
+/*
+ * NVIDIA Tegra XUSB PHY driver
+ *
+ * Copyright (C) 2014 NVIDIA Corporation
+ * Copyright (C) 2014 Google, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __PHY_TEGRA_XUSB_H
+#define __PHY_TEGRA_XUSB_H
+
+/* SS pads */
+#define TEGRA_XUSB_SS_P0	BIT(0)
+#define TEGRA_XUSB_SS_P1	BIT(1)
+#define TEGRA_XUSB_SS_COUNT	2
+
+/* UTMI pads */
+#define TEGRA_XUSB_UTMI_P0	BIT(0)
+#define TEGRA_XUSB_UTMI_P1	BIT(1)
+#define TEGRA_XUSB_UTMI_P2	BIT(2)
+#define TEGRA_XUSB_UTMI_COUNT	3
+
+/* HSIC pads */
+#define TEGRA_XUSB_HSIC_P0	BIT(0)
+#define TEGRA_XUSB_HSIC_P1	BIT(1)
+#define TEGRA_XUSB_HSIC_COUNT	2
+
+#define SS_CLK_HIGH_SPEED	120000000
+#define SS_CLK_LOW_SPEED	12000000
+
+/* FUSE_SKU_USB_CALIB_0 bits */
+#define USB_CALIB_HS_CURR_LVL_PAD(reg, p)				\
+	(((p) ? (reg) >> 15 : (reg)) & 0x3f)
+#define USB_CALIB_HS_TERM_RANGE_ADJ(reg)	(((reg) >> 7) & 0xf)
+#define USB_CALIB_HS_SQUELCH_LVL(reg)		(((reg) >> 11) & 0x3)
+#define USB_CALIB_HS_IREF_CAP(reg)		(((reg) >> 13) & 0x3)
+
+/* CLKRST bits */
+#define SATA_PLL_CFG0_0		0x490
+#define SATA_PADPLL_USE_LOCKDET	BIT(2)
+#define SATA_PADPLL_RESET_SWCTL	BIT(0)
+#define SATA_SEQ_ENABLE		BIT(24)
+#define SATA_SEQ_START_STATE	BIT(25)
+
+/* XUSB_PADCTL bits */
+/* USB2_PAD_MUX_0 */
+#define USB2_OTG_PAD_PORT_MASK(p)	(0x3 << (2 * (p)))
+#define USB2_OTG_PAD_PORT_OWNER_SNPS(p) (0x0 << (2 * (p)))
+#define USB2_OTG_PAD_PORT_OWNER_XUSB(p)	(0x1 << (2 * (p)))
+#define USB2_OTG_PAD_PORT_OWNER_UART(p)	(0x2 << (2 * (p)))
+#define USB2_ULPI_PAD_PORT		(0x1 << 12)
+#define USB2_ULPI_PAD_PORT_OWNER_SNPS	(0x0 << 12)
+#define USB2_ULPI_PAD_PORT_OWNER_XUSB	(0x1 << 12)
+#define USB2_HSIC_PAD_PORT(p)		(0x1 << (14 + (p)))
+#define USB2_HSIC_PAD_PORT_OWNER_SNPS(p)	(0x0 << (14 + (p)))
+#define USB2_HSIC_PAD_PORT_OWNER_XUSB(p)	(0x1 << (14 + (p)))
+/* USB2_PORT_CAP_0 */
+#define USB2_PORT_CAP_MASK(p)		(0x3 << (4 * (p)))
+#define USB2_PORT_CAP_HOST(p)		(0x1 << (4 * (p)))
+#define USB2_ULPI_PORT_CAP		(0x1 << 24)
+/* USB2_OC_MAP_0 */
+#define SNPS_OC_MAP_CTRL1		(0x7 << 0)
+#define SNPS_OC_MAP_CTRL2		(0x7 << 3)
+#define SNPS_OC_MAP_CTRL3		(0x7 << 6)
+#define USB2_OC_MAP_PORT0		(0x7 << 0)
+#define USB2_OC_MAP_PORT1		(0x7 << 3)
+#define USB2_OC_MAP_PORT2		(0x7 << 6)
+#define USB2_OC_MAP_PORT(p)		(0x7 << ((p) * 3))
+#define USB2_OC_MAP_PORT0_OC_DETECTED_VBUS_PAD0 (0x4 << 0)
+#define USB2_OC_MAP_PORT1_OC_DETECTED_VBUS_PAD1 (0x5 << 3)
+/* OC_DET_0 */
+#define OC_DET_VBUS_ENABLE0_OC_MAP (0x7 << 10)
+#define OC_DET_VBUS_ENABLE1_OC_MAP (0x7 << 13)
+#define OC_DET_VBUS_ENABLE2_OC_MAP (0x7 << 5)
+#define OC_DET_VBUS_ENABLE_OC_MAP(p)					\
+	((p) == 2 ? OC_DET_VBUS_ENABLE2_OC_MAP :			\
+		(p) ? OC_DET_VBUS_ENABLE1_OC_MAP :			\
+			OC_DET_VBUS_ENABLE0_OC_MAP)
+#define OC_DET_VBUS_EN0_OC_DETECTED_VBUS_PAD0 (0x4 << 10)
+#define OC_DET_VBUS_EN1_OC_DETECTED_VBUS_PAD1 (0x5 << 13)
+#define OC_DET_VBUS_EN2_OC_DETECTED_VBUS_PAD2 (0x6 << 5)
+#define OC_DET_VBUS_EN_OC_DETECTED_VBUS_PAD(p)				\
+	((p) == 2 ? OC_DET_VBUS_EN2_OC_DETECTED_VBUS_PAD2 :		\
+		(p) ? OC_DET_VBUS_EN1_OC_DETECTED_VBUS_PAD1 :		\
+			OC_DET_VBUS_EN0_OC_DETECTED_VBUS_PAD0)
+#define OC_DET_OC_DETECTED_VBUS_PAD0	BIT(20)
+#define OC_DET_OC_DETECTED_VBUS_PAD1	BIT(21)
+#define OC_DET_OC_DETECTED_VBUS_PAD2	BIT(22)
+#define OC_DET_OC_DETECTED_VBUS_PAD(p)	BIT(20 + (p))
+/* SS_PORT_MAP_0 */
+#define SS_PORT_MAP_SHIFT(p)		(4 * (p))
+#define SS_PORT_MAP_MASK(p)		(0xf << SS_PORT_MAP_SHIFT(p))
+#define SS_PORT_MAP_USB2_PORT0		0x0
+#define SS_PORT_MAP_USB2_PORT1		0x1
+#define SS_PORT_MAP_USB2_PORT2		0x2
+/* USB2_OTG_PAD_CTL0_0 */
+#define USB2_OTG_HS_CURR_LVL(x)		((x) & 0x3f)
+#define USB2_OTG_HS_SLEW(x)		(((x) & 0x3f) << 6)
+#define USB2_OTG_FS_SLEW(x)		(((x) & 0x3) << 12)
+#define USB2_OTG_LS_RSLEW(x)		(((x) & 0x3) << 14)
+#define USB2_OTG_LS_FSLEW(x)		(((x) & 0x3) << 16)
+#define USB2_OTG_PD			BIT(19)
+#define USB2_OTG_PD2			BIT(20)
+#define USB2_OTG_PD_ZI			BIT(21)
+/* USB2_OTG_PAD_CTL1_0 */
+#define USB2_OTG_PD_CHRP_FORCE_POWERUP	BIT(0)
+#define USB2_OTG_PD_DISC_FORCE_POWERUP	BIT(1)
+#define USB2_OTG_PD_DR			BIT(2)
+#define USB2_OTG_TERM_RANGE_AD(x)	(((x) & 0xf) << 3)
+#define USB2_OTG_HS_IREF_CAP(x)		(((x) & 0x3) << 9)
+/* USB2_BIAS_PAD_CTL0_0 */
+#define USB2_BIAS_HS_SQUELCH_LEVEL(x)	((x) & 0x3)
+#define USB2_BIAS_HS_DISCON_LEVEL(x)	(((x) & 0x7) << 2)
+#define USB2_BIAS_PD			BIT(12)
+#define USB2_BIAS_PD_TRK		BIT(13)
+/* USB2_BIAS_PAD_CTL1_0 */
+#define USB2_BIAS_RCTRL_VAL(reg)	((reg) & 0xffff)
+#define USB2_BIAS_TCTRL_VAL(reg)	(((reg) >> 16) & 0xffff)
+/* USB2_HSIC_PAD_CTL0_0 */
+#define USB2_HSIC_TX_RTUNEP(x)		(((x) & 0xf) << 0)
+#define USB2_HSIC_TX_RTUNEN(x)		(((x) & 0xf) << 4)
+#define USB2_HSIC_TX_SLEWP(x)		(((x) & 0xf) << 8)
+#define USB2_HSIC_TX_SLEWN(x)		(((x) & 0xf) << 12)
+#define USB2_HSIC_OPT(x)		(((x) & 0xf) << 16)
+/* USB2_HSIC_PAD_CTL1_0 */
+#define USB2_HSIC_AUTO_TERM_EN		BIT(0)
+#define USB2_HSIC_IDDQ			BIT(1)
+#define USB2_HSIC_PD_TX			BIT(2)
+#define USB2_HSIC_PD_TRX		BIT(3)
+#define USB2_HSIC_PD_RX			BIT(4)
+#define USB2_HSIC_PD_ZI			BIT(5)
+#define USB2_HISC_LPBK			BIT(6)
+#define USB2_HSIC_RPD_DATA		BIT(7)
+#define USB2_HSIC_RPD_STROBE		BIT(8)
+#define USB2_HSIC_RPU_DATA		BIT(9)
+#define USB2_HSIC_RPU_STROBE		BIT(10)
+/* USB2_HSIC_PAD_CTL2_0 */
+#define USB2_HSIC_RX_DATA_TRIM(x)	(((x) & 0xf) << 0)
+#define USB2_HSIC_RX_STROBE_TRIM(x)	(((x) & 0xf) << 4)
+#define USB2_HSIC_CALIOUT(x)		(((x) & 0xffff) << 16)
+/* HSIC_STRB_TRIM_CONTROL_0 */
+#define HSIC_STRB_TRIM(x)		((x) & 0x3f)
+/* IOPHY_MISC_PAD_CTL2_0 */
+#define IOPHY_SPARE_IN(x)		(((x) & 0x3) << 28)
+/* IOPHY_MISC_PAD_CTL3_0 */
+#define IOPHY_MISC_CNTL(x)		(((x) & 0xf) << 0)
+#define IOPHY_TX_SEL_LOAD(x)		(((x) & 0xf) << 8)
+#define IOPHY_TX_RDET_T(x)		(((x) & 0x3) << 12)
+#define IOPHY_RX_IDLE_T(x)		(((x) & 0x3) << 14)
+#define IOPHY_TX_RDET_BYP		BIT(16)
+#define IOPHY_RX_IDLE_BYP		BIT(17)
+#define IOPHY_RX_IDLE_MODE		BIT(18)
+#define IOPHY_RX_IDLE_MODE_OVRD		BIT(19)
+#define IOPHY_CDR_TEST(x)		(((x) & 0xfff) << 20)
+/* IOPHY_MISC_PAD_CTL5_0 */
+#define IOPHY_RX_QEYE_EN		BIT(8)
+/* IOPHY_MISC_PAD_CTL6_0 */
+#define IOPHY_MISC_OUT_SEL(x)		(((x) & 0xff) << 16)
+#define IOPHY_MISC_OUT_SEL_TAP		0x32
+#define IOPHY_MISC_OUT_SEL_AMP		0x33
+#define IOPHY_MISC_OUT_SEL_LATCH_G_Z	0xa1
+#define IOPHY_MISC_OUT_SEL_G_Z		0x21
+#define IOPHY_MISC_OUT_SEL_CTLE_Z	0x48
+#define IOPHY_MISC_OUT_TAP_VAL(reg)	(((reg) >> 24) & 0x1f)
+#define IOPHY_MISC_OUT_AMP_VAL(reg)	(((reg) >> 24) & 0x7f)
+#define IOPHY_MISC_OUT_G_Z_VAL(reg)	(((reg) >> 24) & 0x3f)
+/* IOPHY_USB3_PAD_CTL2_0 */
+#define IOPHY_USB3_RX_WANDER(x)		(((x) & 0xf) << 4)
+#define IOPHY_USB3_RX_EQ_G(x)		(((x) & 0x3f) << 8)
+#define IOPHY_USB3_RX_EQ_Z(x)		(((x) & 0x3f) << 16)
+#define IOPHY_USB3_RX_EQ(x)		(((x) & 0xffff) << 8)
+#define IOPHY_USB3_CDR_CNTL(x)		(((x) & 0xff) << 24)
+/* IOPHY_USB3_PAD_CTL4_0 */
+#define IOPHY_USB3_DFE_CNTL_TAP(x)	(((x) & 0x1f) << 24)
+#define IOPHY_USB3_DFE_CNTL_AMP(x)	(((x) & 0x7f) << 16)
+/* IOPHY_PLL_CTL1_0 */
+#define IOPHY_PLL_PLL0_REFCLK_NDIV(x)	(((x) & 0x3) << 20)
+/* IOPHY_PLL_CTL2_0 */
+#define IOPHY_PLL_XDIGCLK_SEL(x)	((x) & 0x7)
+#define IOPHY_PLL_TXCLKREF_SEL		BIT(4)
+#define IOPHY_PLL_TCLKOUT_EN		BIT(12)
+#define IOPHY_PLL_PLL0_CP_CNTL(x)	(((x) & 0xf) << 16)
+#define IOPHY_PLL_PLL1_CP_CNTL(x)	(((x) & 0xf) << 20)
+/* IOPHY_PLL_CTL3_0 */
+#define IOPHY_PLL_RCAL_BYPASS		BIT(7)
+/* USB3_PAD_MUX_0 */
+#define USB3_FORCE_PCIE_PAD_IDDQ_DISABLE_MASK(l)	BIT(1 + (l))
+#define USB3_FORCE_SATA_PAD_IDDQ_DISABLE_MASK		BIT(6)
+#define USB3_PCIE_PAD_LANE_OWNER(l, p)		(((p) & 0x3) << (16 + 2 * (l)))
+#define USB3_SATA_PAD_LANE_OWNER(p)		(((p) & 0x3) << 26)
+#define USB3_LANE_OWNER_PCIE			0x0
+#define USB3_LANE_OWNER_USB3_SS			0x1
+#define USB3_LANE_OWNER_SATA			0x2
+/* ELPG_PROGRAM_0 */
+#define USB2_PORT0_WAKE_INTERRUPT_ENABLE	BIT(0)
+#define USB2_PORT1_WAKE_INTERRUPT_ENABLE	BIT(1)
+#define USB2_PORT2_WAKE_INTERRUPT_ENABLE	BIT(2)
+#define USB2_PORT_WAKE_INTERRUPT_ENABLE(p)	BIT(p)
+#define USB2_HSIC_PORT0_WAKE_INTERRUPT_ENABLE	BIT(3)
+#define USB2_HSIC_PORT1_WAKE_INTERRUPT_ENABLE	BIT(4)
+#define USB2_HSIC_PORT_WAKE_INTERRUPT_ENABLE(p)	BIT(3 + (p))
+#define SS_PORT0_WAKE_INTERRUPT_ENABLE		BIT(6)
+#define SS_PORT1_WAKE_INTERRUPT_ENABLE		BIT(7)
+#define SS_PORT_WAKE_INTERRUPT_ENABLE(p)	BIT(6 + (p))
+#define USB2_PORT0_WAKEUP_EVENT		BIT(8)
+#define USB2_PORT1_WAKEUP_EVENT		BIT(9)
+#define USB2_PORT2_WAKEUP_EVENT		BIT(10)
+#define USB2_PORT_WAKEUP_EVENT(p)	BIT(8 + (p))
+#define USB2_HSIC_PORT0_WAKEUP_EVENT	BIT(11)
+#define USB2_HSIC_PORT1_WAKEUP_EVENT	BIT(12)
+#define USB2_HSIC_PORT_WAKEUP_EVENT(p)	BIT(11 + (p))
+#define SS_PORT0_WAKEUP_EVENT		BIT(14)
+#define SS_PORT1_WAKEUP_EVENT		BIT(15)
+#define SS_PORT_WAKEUP_EVENT(p)		BIT(14 + (p))
+#define WAKEUP_EVENT_MASK		(0xdf << 8)
+#define SSP0_ELPG_CLAMP_EN		BIT(16)
+#define SSP0_ELPG_CLAMP_EN_EARLY	BIT(17)
+#define SSP0_ELPG_VCORE_DOWN		BIT(18)
+#define SSP1_ELPG_CLAMP_EN		BIT(20)
+#define SSP1_ELPG_CLAMP_EN_EARLY	BIT(21)
+#define SSP1_ELPG_VCORE_DOWN		BIT(22)
+#define SSP_ELPG_CLAMP_EN(p)		BIT(16 + 4 * (p))
+#define SSP_ELPG_CLAMP_EN_EARLY(p)	BIT(17 + 4 * (p))
+#define SSP_ELPG_VCORE_DOWN(p)		BIT(18 + 4 * (p))
+#define AUX_MUX_LP0_CLAMP_EN		BIT(24)
+#define AUX_MUX_LP0_CLAMP_EN_EARLY	BIT(25)
+#define AUX_MUX_LP0_VCORE_DOWN		BIT(26)
+
+#define PADCTL_REG_NONE			((u32)-1)
+
+struct tegra_xusb_padctl_regs {
+	u32 boot_media_0;
+	u32 usb2_pad_mux_0;
+	u32 usb2_port_cap_0;
+	u32 snps_oc_map_0;
+	u32 usb2_oc_map_0;
+	u32 ss_port_map_0;
+	u32 oc_det_0;
+	u32 elpg_program_0;
+	u32 usb2_bchrg_otgpadX_ctlY_0[3][2];
+	u32 usb2_bchrg_bias_pad_0;
+	u32 usb2_bchrg_tdcd_dbnc_timer_0;
+	u32 iophy_pll_p0_ctlY_0[4];
+	u32 iophy_usb3_padX_ctlY_0[2][4];
+	u32 iophy_misc_pad_pX_ctlY_0[5][6];
+	u32 usb2_otg_padX_ctlY_0[3][2];
+	u32 usb2_bias_pad_ctlY_0[2];
+	u32 usb2_hsic_padX_ctlY_0[2][3];
+	u32 ulpi_link_trim_ctl0;
+	u32 ulpi_null_clk_trim_ctl0;
+	u32 hsic_strb_trim_ctl0;
+	u32 wake_ctl0;
+	u32 pm_spare0;
+	u32 usb3_pad_mux_0;
+	u32 iophy_pll_s0_ctlY_0[4];
+	u32 iophy_misc_pad_s0_ctlY_0[6];
+};
+
+#endif /* __PHY_TEGRA_XUSB_H */
-- 
1.9.1.423.g4596e3a

