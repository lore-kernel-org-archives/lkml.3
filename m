Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab3JDJXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 05:23:40 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:14427 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab3JDJXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 05:23:37 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 04 Oct 2013 02:15:38 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Paul Walmsley <pwalmsley@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: [PATCH 5/5] clk: tegra124: Add support for Tegra124 clocks
Date: Fri, 4 Oct 2013 12:12:44 +0300
Message-ID: <1380878014-22088-6-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1380878014-22088-1-git-send-email-pdeschrijver@nvidia.com>
References: <1380878014-22088-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement clock support for Tegra124.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/Makefile               |    1 +
 drivers/clk/tegra/clk-tegra124.c         | 1206 ++++++++++++++++++++++++++++++
 include/dt-bindings/clock/tegra124-car.h |  342 +++++++++
 3 files changed, 1549 insertions(+), 0 deletions(-)
 create mode 100644 drivers/clk/tegra/clk-tegra124.c
 create mode 100644 include/dt-bindings/clock/tegra124-car.h

diff --git a/drivers/clk/tegra/Makefile b/drivers/clk/tegra/Makefile
index a4e5b5a..fe34882 100644
--- a/drivers/clk/tegra/Makefile
+++ b/drivers/clk/tegra/Makefile
@@ -15,3 +15,4 @@ obj-y					+= clk-tegra-super-gen4.o
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += clk-tegra20.o
 obj-$(CONFIG_ARCH_TEGRA_3x_SOC)         += clk-tegra30.o
 obj-$(CONFIG_ARCH_TEGRA_114_SOC)	+= clk-tegra114.o
+obj-$(CONFIG_ARCH_TEGRA_124_SOC)	+= clk-tegra124.o
diff --git a/drivers/clk/tegra/clk-tegra124.c b/drivers/clk/tegra/clk-tegra124.c
new file mode 100644
index 0000000..26ba059
--- /dev/null
+++ b/drivers/clk/tegra/clk-tegra124.c
@@ -0,0 +1,1206 @@
+/*
+ * Copyright (c) 2012, 2013, NVIDIA CORPORATION.  All rights reserved.
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
+#include <linux/io.h>
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
+#include <linux/clkdev.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/delay.h>
+#include <linux/export.h>
+#include <linux/clk/tegra.h>
+#include <dt-bindings/clock/tegra124-car.h>
+
+#include "clk.h"
+#include "clk-id.h"
+
+#define CLK_SOURCE_EMC 0x19c
+#define CLK_SOURCE_XUSB_SS_SRC 0x610
+
+#define PLLC_BASE 0x80
+#define PLLC_OUT 0x84
+#define PLLC_MISC2 0x88
+#define PLLC_MISC 0x8c
+#define PLLC2_BASE 0x4e8
+#define PLLC2_MISC 0x4ec
+#define PLLC3_BASE 0x4fc
+#define PLLC3_MISC 0x500
+#define PLLM_BASE 0x90
+#define PLLM_OUT 0x94
+#define PLLM_MISC 0x9c
+#define PLLD_BASE 0xd0
+#define PLLD_MISC 0xdc
+#define PLLU_BASE 0xc0
+#define PLLU_MISC 0xcc
+#define PLLE_BASE 0xe8
+#define PLLE_MISC 0xec
+#define PLLD2_BASE 0x4b8
+#define PLLD2_MISC 0x4bc
+#define PLLE_AUX 0x48c
+#define PLLRE_BASE 0x4c4
+#define PLLRE_MISC 0x4c8
+#define PLLDP_BASE 0x590
+#define PLLDP_MISC 0x594
+#define PLLC4_BASE 0x5a4
+#define PLLC4_MISC 0x5a8
+
+#define PLLC_IDDQ_BIT 26
+#define PLLRE_IDDQ_BIT 16
+#define PLLSS_IDDQ_BIT 19
+
+#define PLL_BASE_LOCK BIT(27)
+#define PLLE_MISC_LOCK BIT(11)
+#define PLLRE_MISC_LOCK BIT(24)
+
+#define PLL_MISC_LOCK_ENABLE 18
+#define PLLC_MISC_LOCK_ENABLE 24
+#define PLLDU_MISC_LOCK_ENABLE 22
+#define PLLE_MISC_LOCK_ENABLE 9
+#define PLLRE_MISC_LOCK_ENABLE 30
+#define PLLSS_MISC_LOCK_ENABLE 30
+
+#define PLLXC_SW_MAX_P 6
+
+#define PMC_BLINK_TIMER 0x40
+
+#define PMC_PLLM_WB0_OVERRIDE 0x1dc
+#define PMC_PLLM_WB0_OVERRIDE_2 0x2b0
+
+#define UTMIP_PLL_CFG2 0x488
+#define UTMIP_PLL_CFG2_STABLE_COUNT(x) (((x) & 0xffff) << 6)
+#define UTMIP_PLL_CFG2_ACTIVE_DLY_COUNT(x) (((x) & 0x3f) << 18)
+#define UTMIP_PLL_CFG2_FORCE_PD_SAMP_A_POWERDOWN BIT(0)
+#define UTMIP_PLL_CFG2_FORCE_PD_SAMP_B_POWERDOWN BIT(2)
+#define UTMIP_PLL_CFG2_FORCE_PD_SAMP_C_POWERDOWN BIT(4)
+
+#define UTMIP_PLL_CFG1 0x484
+#define UTMIP_PLL_CFG1_ENABLE_DLY_COUNT(x) (((x) & 0x1f) << 6)
+#define UTMIP_PLL_CFG1_XTAL_FREQ_COUNT(x) (((x) & 0xfff) << 0)
+#define UTMIP_PLL_CFG1_FORCE_PLLU_POWERUP BIT(17)
+#define UTMIP_PLL_CFG1_FORCE_PLLU_POWERDOWN BIT(16)
+#define UTMIP_PLL_CFG1_FORCE_PLL_ENABLE_POWERUP BIT(15)
+#define UTMIP_PLL_CFG1_FORCE_PLL_ENABLE_POWERDOWN BIT(14)
+#define UTMIP_PLL_CFG1_FORCE_PLL_ACTIVE_POWERDOWN BIT(12)
+
+#define UTMIPLL_HW_PWRDN_CFG0			0x52c
+#define UTMIPLL_HW_PWRDN_CFG0_SEQ_START_STATE	BIT(25)
+#define UTMIPLL_HW_PWRDN_CFG0_SEQ_ENABLE	BIT(24)
+#define UTMIPLL_HW_PWRDN_CFG0_USE_LOCKDET	BIT(6)
+#define UTMIPLL_HW_PWRDN_CFG0_SEQ_RESET_INPUT_VALUE	BIT(5)
+#define UTMIPLL_HW_PWRDN_CFG0_SEQ_IN_SWCTL	BIT(4)
+#define UTMIPLL_HW_PWRDN_CFG0_CLK_ENABLE_SWCTL	BIT(2)
+#define UTMIPLL_HW_PWRDN_CFG0_IDDQ_OVERRIDE	BIT(1)
+#define UTMIPLL_HW_PWRDN_CFG0_IDDQ_SWCTL	BIT(0)
+
+static void __iomem *clk_base;
+static void __iomem *pmc_base;
+
+static unsigned long osc_freq;
+static unsigned long pll_ref_freq;
+
+static DEFINE_SPINLOCK(pll_d_lock);
+static DEFINE_SPINLOCK(pll_d2_lock);
+static DEFINE_SPINLOCK(pll_e_lock);
+static DEFINE_SPINLOCK(pll_re_lock);
+static DEFINE_SPINLOCK(pll_u_lock);
+
+/* possible OSC frequencies in Hz */
+static unsigned long tegra124_input_freq[] = {
+	[0] = 13000000,
+	[1] = 16800000,
+	[4] = 19200000,
+	[5] = 38400000,
+	[8] = 12000000,
+	[9] = 48000000,
+	[12] = 260000000,
+};
+
+static const char *mux_plld_out0_plld2_out0[] = {
+	"pll_d_out0", "pll_d2_out0",
+};
+#define mux_plld_out0_plld2_out0_idx NULL
+
+static const char *mux_pllmcp_clkm[] = {
+	"pll_m", "pll_c", "pll_p", "clk_m", "pll_m_ud", "pll_c2", "pll_c3",
+};
+#define mux_pllmcp_clkm_idx NULL
+
+static struct div_nmp pllxc_nmp = {
+	.divm_shift = 0,
+	.divm_width = 8,
+	.divn_shift = 8,
+	.divn_width = 8,
+	.divp_shift = 20,
+	.divp_width = 4,
+};
+
+static struct pdiv_map pllxc_p[] = {
+	{ .pdiv = 1, .hw_val = 0 },
+	{ .pdiv = 2, .hw_val = 1 },
+	{ .pdiv = 3, .hw_val = 2 },
+	{ .pdiv = 4, .hw_val = 3 },
+	{ .pdiv = 5, .hw_val = 4 },
+	{ .pdiv = 6, .hw_val = 5 },
+	{ .pdiv = 8, .hw_val = 6 },
+	{ .pdiv = 10, .hw_val = 7 },
+	{ .pdiv = 12, .hw_val = 8 },
+	{ .pdiv = 16, .hw_val = 9 },
+	{ .pdiv = 12, .hw_val = 10 },
+	{ .pdiv = 16, .hw_val = 11 },
+	{ .pdiv = 20, .hw_val = 12 },
+	{ .pdiv = 24, .hw_val = 13 },
+	{ .pdiv = 32, .hw_val = 14 },
+	{ .pdiv = 0, .hw_val = 0 },
+};
+
+static struct tegra_clk_pll_freq_table pll_c_freq_table[] = {
+	{ 12000000, 624000000, 104, 1, 2},
+	{ 12000000, 600000000, 100, 1, 2},
+	{ 13000000, 600000000,  92, 1, 2},	/* actual: 598.0 MHz */
+	{ 16800000, 600000000,  71, 1, 2},	/* actual: 596.4 MHz */
+	{ 19200000, 600000000,  62, 1, 2},	/* actual: 595.2 MHz */
+	{ 26000000, 600000000,  92, 2, 2},	/* actual: 598.0 MHz */
+	{ 0, 0, 0, 0, 0, 0 },
+};
+
+static struct tegra_clk_pll_params pll_c_params = {
+	.input_min = 12000000,
+	.input_max = 800000000,
+	.cf_min = 12000000,
+	.cf_max = 19200000,	/* s/w policy, h/w capability 50 MHz */
+	.vco_min = 600000000,
+	.vco_max = 1400000000,
+	.base_reg = PLLC_BASE,
+	.misc_reg = PLLC_MISC,
+	.lock_mask = PLL_BASE_LOCK,
+	.lock_enable_bit_idx = PLLC_MISC_LOCK_ENABLE,
+	.lock_delay = 300,
+	.iddq_reg = PLLC_MISC,
+	.iddq_bit_idx = PLLC_IDDQ_BIT,
+	.max_p = PLLXC_SW_MAX_P,
+	.dyn_ramp_reg = PLLC_MISC2,
+	.stepa_shift = 17,
+	.stepb_shift = 9,
+	.pdiv_tohw = pllxc_p,
+	.div_nmp = &pllxc_nmp,
+};
+
+static struct div_nmp pllcx_nmp = {
+	.divm_shift = 0,
+	.divm_width = 2,
+	.divn_shift = 8,
+	.divn_width = 8,
+	.divp_shift = 20,
+	.divp_width = 3,
+};
+
+static struct pdiv_map pllc_p[] = {
+	{ .pdiv = 1, .hw_val = 0 },
+	{ .pdiv = 2, .hw_val = 1 },
+	{ .pdiv = 4, .hw_val = 3 },
+	{ .pdiv = 8, .hw_val = 5 },
+	{ .pdiv = 16, .hw_val = 7 },
+	{ .pdiv = 0, .hw_val = 0 },
+};
+
+static struct tegra_clk_pll_freq_table pll_cx_freq_table[] = {
+	{12000000, 600000000, 100, 1, 2},
+	{13000000, 600000000, 92, 1, 2},	/* actual: 598.0 MHz */
+	{16800000, 600000000, 71, 1, 2},	/* actual: 596.4 MHz */
+	{19200000, 600000000, 62, 1, 2},	/* actual: 595.2 MHz */
+	{26000000, 600000000, 92, 2, 2},	/* actual: 598.0 MHz */
+	{0, 0, 0, 0, 0, 0},
+};
+
+static struct tegra_clk_pll_params pll_c2_params = {
+	.input_min = 12000000,
+	.input_max = 48000000,
+	.cf_min = 12000000,
+	.cf_max = 19200000,
+	.vco_min = 600000000,
+	.vco_max = 1200000000,
+	.base_reg = PLLC2_BASE,
+	.misc_reg = PLLC2_MISC,
+	.lock_mask = PLL_BASE_LOCK,
+	.lock_enable_bit_idx = PLL_MISC_LOCK_ENABLE,
+	.lock_delay = 300,
+	.pdiv_tohw = pllc_p,
+	.div_nmp = &pllcx_nmp,
+	.max_p = 7,
+	.ext_misc_reg[0] = 0x4f0,
+	.ext_misc_reg[1] = 0x4f4,
+	.ext_misc_reg[2] = 0x4f8,
+};
+
+static struct tegra_clk_pll_params pll_c3_params = {
+	.input_min = 12000000,
+	.input_max = 48000000,
+	.cf_min = 12000000,
+	.cf_max = 19200000,
+	.vco_min = 600000000,
+	.vco_max = 1200000000,
+	.base_reg = PLLC3_BASE,
+	.misc_reg = PLLC3_MISC,
+	.lock_mask = PLL_BASE_LOCK,
+	.lock_enable_bit_idx = PLL_MISC_LOCK_ENABLE,
+	.lock_delay = 300,
+	.pdiv_tohw = pllc_p,
+	.div_nmp = &pllcx_nmp,
+	.max_p = 7,
+	.ext_misc_reg[0] = 0x504,
+	.ext_misc_reg[1] = 0x508,
+	.ext_misc_reg[2] = 0x50c,
+};
+
+static struct div_nmp pllss_nmp = {
+	.divm_shift = 0,
+	.divm_width = 8,
+	.divn_shift = 8,
+	.divn_width = 8,
+	.divp_shift = 20,
+	.divp_width = 4,
+};
+
+static struct pdiv_map pll12g_ssd_esd_p[] = {
+	{ .pdiv = 1, .hw_val = 0 },
+	{ .pdiv = 2, .hw_val = 1 },
+	{ .pdiv = 3, .hw_val = 2 },
+	{ .pdiv = 4, .hw_val = 3 },
+	{ .pdiv = 5, .hw_val = 4 },
+	{ .pdiv = 6, .hw_val = 5 },
+	{ .pdiv = 8, .hw_val = 6 },
+	{ .pdiv = 10, .hw_val = 7 },
+	{ .pdiv = 12, .hw_val = 8 },
+	{ .pdiv = 16, .hw_val = 9 },
+	{ .pdiv = 12, .hw_val = 10 },
+	{ .pdiv = 16, .hw_val = 11 },
+	{ .pdiv = 20, .hw_val = 12 },
+	{ .pdiv = 24, .hw_val = 13 },
+	{ .pdiv = 32, .hw_val = 14 },
+	{ .pdiv = 0, .hw_val = 15 },
+};
+
+static struct tegra_clk_pll_freq_table pll_c4_freq_table[] = {
+	{ 12000000, 600000000, 100, 1, 1},
+	{ 13000000, 600000000,  92, 1, 1},      /* actual: 598.0 MHz */
+	{ 16800000, 600000000,  71, 1, 1},      /* actual: 596.4 MHz */
+	{ 19200000, 600000000,  62, 1, 1},      /* actual: 595.2 MHz */
+	{ 26000000, 600000000,  92, 2, 1},      /* actual: 598.0 MHz */
+	{ 0, 0, 0, 0, 0, 0 },
+};
+
+static struct tegra_clk_pll_params pll_c4_params = {
+	.input_min = 12000000,
+	.input_max = 1000000000,
+	.cf_min = 12000000,
+	.cf_max = 19200000, /* s/w policy, h/w capability 38 MHz */
+	.vco_min = 600000000,
+	.vco_max = 1200000000,
+	.base_reg = PLLC4_BASE,
+	.misc_reg = PLLC4_MISC,
+	.lock_mask = PLL_BASE_LOCK,
+	.lock_enable_bit_idx = PLLSS_MISC_LOCK_ENABLE,
+	.lock_delay = 300,
+	.iddq_reg = PLLC4_BASE,
+	.iddq_bit_idx = PLLSS_IDDQ_BIT,
+	.pdiv_tohw = pll12g_ssd_esd_p,
+	.div_nmp = &pllss_nmp,
+	.ext_misc_reg[0] = 0x5ac,
+	.ext_misc_reg[1] = 0x5b0,
+	.ext_misc_reg[2] = 0x5b4,
+};
+
+static struct pdiv_map pllm_p[] = {
+	{ .pdiv = 1, .hw_val = 0 },
+	{ .pdiv = 2, .hw_val = 1 },
+	{ .pdiv = 0, .hw_val = 0 },
+};
+
+static struct tegra_clk_pll_freq_table pll_m_freq_table[] = {
+	{12000000, 800000000, 66, 1, 1},	/* actual: 792.0 MHz */
+	{13000000, 800000000, 61, 1, 1},	/* actual: 793.0 MHz */
+	{16800000, 800000000, 47, 1, 1},	/* actual: 789.6 MHz */
+	{19200000, 800000000, 41, 1, 1},	/* actual: 787.2 MHz */
+	{26000000, 800000000, 61, 2, 1},	/* actual: 793.0 MHz */
+	{0, 0, 0, 0, 0, 0},
+};
+
+static struct div_nmp pllm_nmp = {
+	.divm_shift = 0,
+	.divm_width = 8,
+	.override_divm_shift = 0,
+	.divn_shift = 8,
+	.divn_width = 8,
+	.override_divn_shift = 8,
+	.divp_shift = 20,
+	.divp_width = 1,
+	.override_divp_shift = 27,
+};
+
+static struct tegra_clk_pll_params pll_m_params = {
+	.input_min = 12000000,
+	.input_max = 500000000,
+	.cf_min = 12000000,
+	.cf_max = 19200000,	/* s/w policy, h/w capability 50 MHz */
+	.vco_min = 400000000,
+	.vco_max = 1066000000,
+	.base_reg = PLLM_BASE,
+	.misc_reg = PLLM_MISC,
+	.lock_mask = PLL_BASE_LOCK,
+	.lock_enable_bit_idx = PLL_MISC_LOCK_ENABLE,
+	.lock_delay = 300,
+	.max_p = 2,
+	.pdiv_tohw = pllm_p,
+	.div_nmp = &pllm_nmp,
+	.pmc_divnm_reg = PMC_PLLM_WB0_OVERRIDE,
+	.pmc_divp_reg = PMC_PLLM_WB0_OVERRIDE_2,
+};
+
+static struct tegra_clk_pll_freq_table pll_e_freq_table[] = {
+	/* PLLE special case: use cpcon field to store cml divider value */
+	{336000000, 100000000, 100, 21, 16, 11},
+	{312000000, 100000000, 200, 26, 24, 13},
+	{0, 0, 0, 0, 0, 0},
+};
+
+static struct div_nmp plle_nmp = {
+	.divm_shift = 0,
+	.divm_width = 8,
+	.divn_shift = 8,
+	.divn_width = 8,
+	.divp_shift = 24,
+	.divp_width = 4,
+};
+
+static struct tegra_clk_pll_params pll_e_params = {
+	.input_min = 12000000,
+	.input_max = 1000000000,
+	.cf_min = 12000000,
+	.cf_max = 75000000,
+	.vco_min = 1600000000,
+	.vco_max = 2400000000U,
+	.base_reg = PLLE_BASE,
+	.misc_reg = PLLE_MISC,
+	.aux_reg = PLLE_AUX,
+	.lock_mask = PLLE_MISC_LOCK,
+	.lock_enable_bit_idx = PLLE_MISC_LOCK_ENABLE,
+	.lock_delay = 300,
+	.div_nmp = &plle_nmp,
+};
+
+static const struct clk_div_table pll_re_div_table[] = {
+	{ .val = 0, .div = 1 },
+	{ .val = 1, .div = 2 },
+	{ .val = 2, .div = 3 },
+	{ .val = 3, .div = 4 },
+	{ .val = 4, .div = 5 },
+	{ .val = 5, .div = 6 },
+	{ .val = 0, .div = 0 },
+};
+
+static struct div_nmp pllre_nmp = {
+	.divm_shift = 0,
+	.divm_width = 8,
+	.divn_shift = 8,
+	.divn_width = 8,
+	.divp_shift = 16,
+	.divp_width = 4,
+};
+
+static struct tegra_clk_pll_params pll_re_vco_params = {
+	.input_min = 12000000,
+	.input_max = 1000000000,
+	.cf_min = 12000000,
+	.cf_max = 19200000, /* s/w policy, h/w capability 38 MHz */
+	.vco_min = 300000000,
+	.vco_max = 600000000,
+	.base_reg = PLLRE_BASE,
+	.misc_reg = PLLRE_MISC,
+	.lock_mask = PLLRE_MISC_LOCK,
+	.lock_enable_bit_idx = PLLRE_MISC_LOCK_ENABLE,
+	.lock_delay = 300,
+	.iddq_reg = PLLRE_MISC,
+	.iddq_bit_idx = PLLRE_IDDQ_BIT,
+	.div_nmp = &pllre_nmp,
+};
+
+static struct div_nmp pllp_nmp = {
+	.divm_shift = 0,
+	.divm_width = 5,
+	.divn_shift = 8,
+	.divn_width = 10,
+	.divp_shift = 20,
+	.divp_width = 3,
+};
+
+static struct tegra_clk_pll_freq_table pll_d_freq_table[] = {
+	{12000000, 216000000, 864, 12, 4, 12},
+	{13000000, 216000000, 864, 13, 4, 12},
+	{16800000, 216000000, 720, 14, 4, 12},
+	{19200000, 216000000, 720, 16, 4, 12},
+	{26000000, 216000000, 864, 26, 4, 12},
+
+	{12000000, 594000000, 594, 12, 1, 12},
+	{13000000, 594000000, 594, 13, 1, 12},
+	{16800000, 594000000, 495, 14, 1, 12},
+	{19200000, 594000000, 495, 16, 1, 12},
+	{26000000, 594000000, 594, 26, 1, 12},
+
+	{12000000, 1000000000, 1000, 12, 1, 12},
+	{13000000, 1000000000, 1000, 13, 1, 12},
+	{19200000, 1000000000, 625, 12, 1, 12},
+	{26000000, 1000000000, 1000, 26, 1, 12},
+
+	{0, 0, 0, 0, 0, 0},
+};
+
+static struct tegra_clk_pll_params pll_d_params = {
+	.input_min = 2000000,
+	.input_max = 40000000,
+	.cf_min = 1000000,
+	.cf_max = 6000000,
+	.vco_min = 500000000,
+	.vco_max = 1000000000,
+	.base_reg = PLLD_BASE,
+	.misc_reg = PLLD_MISC,
+	.lock_mask = PLL_BASE_LOCK,
+	.lock_enable_bit_idx = PLLDU_MISC_LOCK_ENABLE,
+	.lock_delay = 1000,
+	.div_nmp = &pllp_nmp,
+};
+
+static struct tegra_clk_pll_freq_table tegra124_pll_d2_freq_table[] = {
+	{ 12000000, 148500000,  99, 1, 8},
+	{ 12000000, 594000000,  99, 1, 1},
+	{ 13000000, 594000000,  91, 1, 1},      /* actual: 591.5 MHz */
+	{ 16800000, 594000000,  71, 1, 1},      /* actual: 596.4 MHz */
+	{ 19200000, 594000000,  62, 1, 1},      /* actual: 595.2 MHz */
+	{ 26000000, 594000000,  91, 2, 1},      /* actual: 591.5 MHz */
+	{ 0, 0, 0, 0, 0, 0 },
+};
+
+static struct tegra_clk_pll_params tegra124_pll_d2_params = {
+	.input_min = 12000000,
+	.input_max = 1000000000,
+	.cf_min = 12000000,
+	.cf_max = 19200000, /* s/w policy, h/w capability 38 MHz */
+	.vco_min = 600000000,
+	.vco_max = 1200000000,
+	.base_reg = PLLD2_BASE,
+	.misc_reg = PLLD2_MISC,
+	.lock_mask = PLL_BASE_LOCK,
+	.lock_enable_bit_idx = PLLSS_MISC_LOCK_ENABLE,
+	.lock_delay = 300,
+	.iddq_reg = PLLD2_BASE,
+	.iddq_bit_idx = PLLSS_IDDQ_BIT,
+	.pdiv_tohw = pll12g_ssd_esd_p,
+	.div_nmp = &pllss_nmp,
+	.ext_misc_reg[0] = 0x570,
+	.ext_misc_reg[1] = 0x574,
+	.ext_misc_reg[2] = 0x578,
+	.max_p = 15,
+};
+
+static struct tegra_clk_pll_freq_table pll_dp_freq_table[] = {
+	{ 12000000, 600000000, 100, 1, 1},
+	{ 13000000, 600000000,  92, 1, 1},      /* actual: 598.0 MHz */
+	{ 16800000, 600000000,  71, 1, 1},      /* actual: 596.4 MHz */
+	{ 19200000, 600000000,  62, 1, 1},      /* actual: 595.2 MHz */
+	{ 26000000, 600000000,  92, 2, 1},      /* actual: 598.0 MHz */
+	{ 0, 0, 0, 0, 0, 0 },
+};
+
+static struct tegra_clk_pll_params pll_dp_params = {
+	.input_min = 12000000,
+	.input_max = 1000000000,
+	.cf_min = 12000000,
+	.cf_max = 19200000, /* s/w policy, h/w capability 38 MHz */
+	.vco_min = 600000000,
+	.vco_max = 1200000000,
+	.base_reg = PLLDP_BASE,
+	.misc_reg = PLLDP_MISC,
+	.lock_mask = PLL_BASE_LOCK,
+	.lock_enable_bit_idx = PLLSS_MISC_LOCK_ENABLE,
+	.lock_delay = 300,
+	.iddq_reg = PLLDP_BASE,
+	.iddq_bit_idx = PLLSS_IDDQ_BIT,
+	.pdiv_tohw = pll12g_ssd_esd_p,
+	.div_nmp = &pllss_nmp,
+	.ext_misc_reg[0] = 0x598,
+	.ext_misc_reg[1] = 0x59c,
+	.ext_misc_reg[2] = 0x5a0,
+	.max_p = 5,
+};
+
+static struct pdiv_map pllu_p[] = {
+	{ .pdiv = 1, .hw_val = 1 },
+	{ .pdiv = 2, .hw_val = 0 },
+	{ .pdiv = 0, .hw_val = 0 },
+};
+
+static struct div_nmp pllu_nmp = {
+	.divm_shift = 0,
+	.divm_width = 5,
+	.divn_shift = 8,
+	.divn_width = 10,
+	.divp_shift = 20,
+	.divp_width = 1,
+};
+
+static struct tegra_clk_pll_freq_table pll_u_freq_table[] = {
+	{12000000, 480000000, 960, 12, 2, 12},
+	{13000000, 480000000, 960, 13, 2, 12},
+	{16800000, 480000000, 400, 7, 2, 5},
+	{19200000, 480000000, 200, 4, 2, 3},
+	{26000000, 480000000, 960, 26, 2, 12},
+	{0, 0, 0, 0, 0, 0},
+};
+
+static struct tegra_clk_pll_params pll_u_params = {
+	.input_min = 2000000,
+	.input_max = 40000000,
+	.cf_min = 1000000,
+	.cf_max = 6000000,
+	.vco_min = 480000000,
+	.vco_max = 960000000,
+	.base_reg = PLLU_BASE,
+	.misc_reg = PLLU_MISC,
+	.lock_mask = PLL_BASE_LOCK,
+	.lock_enable_bit_idx = PLLDU_MISC_LOCK_ENABLE,
+	.lock_delay = 1000,
+	.pdiv_tohw = pllu_p,
+	.div_nmp = &pllu_nmp,
+};
+
+struct utmi_clk_param {
+	/* Oscillator Frequency in KHz */
+	u32 osc_frequency;
+	/* UTMIP PLL Enable Delay Count  */
+	u8 enable_delay_count;
+	/* UTMIP PLL Stable count */
+	u8 stable_count;
+	/*  UTMIP PLL Active delay count */
+	u8 active_delay_count;
+	/* UTMIP PLL Xtal frequency count */
+	u8 xtal_freq_count;
+};
+
+static const struct utmi_clk_param utmi_parameters[] = {
+	{.osc_frequency = 13000000, .enable_delay_count = 0x02,
+	 .stable_count = 0x33, .active_delay_count = 0x05,
+	 .xtal_freq_count = 0x7F},
+	{.osc_frequency = 19200000, .enable_delay_count = 0x03,
+	 .stable_count = 0x4B, .active_delay_count = 0x06,
+	 .xtal_freq_count = 0xBB},
+	{.osc_frequency = 12000000, .enable_delay_count = 0x02,
+	 .stable_count = 0x2F, .active_delay_count = 0x04,
+	 .xtal_freq_count = 0x76},
+	{.osc_frequency = 26000000, .enable_delay_count = 0x04,
+	 .stable_count = 0x66, .active_delay_count = 0x09,
+	 .xtal_freq_count = 0xFE},
+	{.osc_frequency = 16800000, .enable_delay_count = 0x03,
+	 .stable_count = 0x41, .active_delay_count = 0x0A,
+	 .xtal_freq_count = 0xA4},
+};
+
+static struct tegra_clk __initdata tegra124_clks[tegra_clk_max] = {
+	[tegra_clk_ispb] = { .dt_id = TEGRA124_CLK_ISPB, .present = true },
+	[tegra_clk_rtc] = { .dt_id = TEGRA124_CLK_RTC, .present = true },
+	[tegra_clk_timer] = { .dt_id = TEGRA124_CLK_TIMER, .present = true },
+	[tegra_clk_uarta] = { .dt_id = TEGRA124_CLK_UARTA, .present = true },
+	[tegra_clk_sdmmc2] = { .dt_id = TEGRA124_CLK_SDMMC2, .present = true },
+	[tegra_clk_i2s1] = { .dt_id = TEGRA124_CLK_I2S1, .present = true },
+	[tegra_clk_i2c1] = { .dt_id = TEGRA124_CLK_I2C1, .present = true },
+	[tegra_clk_ndflash] = { .dt_id = TEGRA124_CLK_NDFLASH, .present = true },
+	[tegra_clk_sdmmc1] = { .dt_id = TEGRA124_CLK_SDMMC1, .present = true },
+	[tegra_clk_sdmmc4] = { .dt_id = TEGRA124_CLK_SDMMC4, .present = true },
+	[tegra_clk_pwm] = { .dt_id = TEGRA124_CLK_PWM, .present = true },
+	[tegra_clk_i2s2] = { .dt_id = TEGRA124_CLK_I2S2, .present = true },
+	[tegra_clk_epp] = { .dt_id = TEGRA124_CLK_EPP, .present = true },
+	[tegra_clk_gr_2d] = { .dt_id = TEGRA124_CLK_GR_2D, .present = true },
+	[tegra_clk_usbd] = { .dt_id = TEGRA124_CLK_USBD, .present = true },
+	[tegra124_clk_isp] = { .dt_id = TEGRA124_CLK_ISP, .present = true },
+	[tegra_clk_gr_3d] = { .dt_id = TEGRA124_CLK_GR_3D, .present = true },
+	[tegra_clk_disp2] = { .dt_id = TEGRA124_CLK_DISP2, .present = true },
+	[tegra_clk_disp1] = { .dt_id = TEGRA124_CLK_DISP1, .present = true },
+	[tegra_clk_host1x] = { .dt_id = TEGRA124_CLK_HOST1X, .present = true },
+	[tegra_clk_vcp] = { .dt_id = TEGRA124_CLK_VCP, .present = true },
+	[tegra_clk_i2s0] = { .dt_id = TEGRA124_CLK_I2S0, .present = true },
+	[tegra_clk_apbdma] = { .dt_id = TEGRA124_CLK_APBDMA, .present = true },
+	[tegra_clk_kbc] = { .dt_id = TEGRA124_CLK_KBC, .present = true },
+	[tegra_clk_kfuse] = { .dt_id = TEGRA124_CLK_KFUSE, .present = true },
+	[tegra_clk_sbc1] = { .dt_id = TEGRA124_CLK_SBC1, .present = true },
+	[tegra_clk_nor] = { .dt_id = TEGRA124_CLK_NOR, .present = true },
+	[tegra_clk_sbc2] = { .dt_id = TEGRA124_CLK_SBC2, .present = true },
+	[tegra_clk_sbc3] = { .dt_id = TEGRA124_CLK_SBC3, .present = true },
+	[tegra_clk_i2c5] = { .dt_id = TEGRA124_CLK_I2C5, .present = true },
+	[tegra_clk_dsia] = { .dt_id = TEGRA124_CLK_DSIA, .present = true },
+	[tegra_clk_mipi] = { .dt_id = TEGRA124_CLK_MIPI, .present = true },
+	[tegra_clk_hdmi] = { .dt_id = TEGRA124_CLK_HDMI, .present = true },
+	[tegra_clk_csi] = { .dt_id = TEGRA124_CLK_CSI, .present = true },
+	[tegra_clk_i2c2] = { .dt_id = TEGRA124_CLK_I2C2, .present = true },
+	[tegra_clk_uartc] = { .dt_id = TEGRA124_CLK_UARTC, .present = true },
+	[tegra_clk_mipi_cal] = { .dt_id = TEGRA124_CLK_MIPI_CAL, .present = true },
+	[tegra_clk_emc] = { .dt_id = TEGRA124_CLK_EMC, .present = true },
+	[tegra_clk_usb2] = { .dt_id = TEGRA124_CLK_USB2, .present = true },
+	[tegra_clk_usb3] = { .dt_id = TEGRA124_CLK_USB3, .present = true },
+	[tegra_clk_vde] = { .dt_id = TEGRA124_CLK_VDE, .present = true },
+	[tegra_clk_bsea] = { .dt_id = TEGRA124_CLK_BSEA, .present = true },
+	[tegra_clk_bsev] = { .dt_id = TEGRA124_CLK_BSEV, .present = true },
+	[tegra_clk_uartd] = { .dt_id = TEGRA124_CLK_UARTD, .present = true },
+	[tegra_clk_i2c3] = { .dt_id = TEGRA124_CLK_I2C3, .present = true },
+	[tegra_clk_sbc4] = { .dt_id = TEGRA124_CLK_SBC4, .present = true },
+	[tegra_clk_sdmmc3] = { .dt_id = TEGRA124_CLK_SDMMC3, .present = true },
+	[tegra_clk_pcie] = { .dt_id = TEGRA124_CLK_PCIE, .present = true },
+	[tegra_clk_owr] = { .dt_id = TEGRA124_CLK_OWR, .present = true },
+	[tegra_clk_afi] = { .dt_id = TEGRA124_CLK_AFI, .present = true },
+	[tegra_clk_csite] = { .dt_id = TEGRA124_CLK_CSITE, .present = true },
+	[tegra_clk_la] = { .dt_id = TEGRA124_CLK_LA, .present = true },
+	[tegra_clk_trace] = { .dt_id = TEGRA124_CLK_TRACE, .present = true },
+	[tegra_clk_soc_therm] = { .dt_id = TEGRA124_CLK_SOC_THERM, .present = true },
+	[tegra_clk_dtv] = { .dt_id = TEGRA124_CLK_DTV, .present = true },
+	[tegra_clk_ndspeed] = { .dt_id = TEGRA124_CLK_NDSPEED, .present = true },
+	[tegra_clk_i2cslow] = { .dt_id = TEGRA124_CLK_I2CSLOW, .present = true },
+	[tegra_clk_dsib] = { .dt_id = TEGRA124_CLK_DSIB, .present = true },
+	[tegra_clk_tsec] = { .dt_id = TEGRA124_CLK_TSEC, .present = true },
+	[tegra_clk_xusb_host] = { .dt_id = TEGRA124_CLK_XUSB_HOST, .present = true },
+	[tegra_clk_msenc] = { .dt_id = TEGRA124_CLK_MSENC, .present = true },
+	[tegra_clk_csus] = { .dt_id = TEGRA124_CLK_CSUS, .present = true },
+	[tegra_clk_mselect] = { .dt_id = TEGRA124_CLK_MSELECT, .present = true },
+	[tegra_clk_tsensor] = { .dt_id = TEGRA124_CLK_TSENSOR, .present = true },
+	[tegra_clk_i2s3] = { .dt_id = TEGRA124_CLK_I2S3, .present = true },
+	[tegra_clk_i2s4] = { .dt_id = TEGRA124_CLK_I2S4, .present = true },
+	[tegra_clk_i2c4] = { .dt_id = TEGRA124_CLK_I2C4, .present = true },
+	[tegra_clk_sbc5] = { .dt_id = TEGRA124_CLK_SBC5, .present = true },
+	[tegra_clk_sbc6] = { .dt_id = TEGRA124_CLK_SBC6, .present = true },
+	[tegra_clk_d_audio] = { .dt_id = TEGRA124_CLK_D_AUDIO, .present = true },
+	[tegra_clk_apbif] = { .dt_id = TEGRA124_CLK_APBIF, .present = true },
+	[tegra_clk_dam0] = { .dt_id = TEGRA124_CLK_DAM0, .present = true },
+	[tegra_clk_dam1] = { .dt_id = TEGRA124_CLK_DAM1, .present = true },
+	[tegra_clk_dam2] = { .dt_id = TEGRA124_CLK_DAM2, .present = true },
+	[tegra_clk_hda2codec_2x] = { .dt_id = TEGRA124_CLK_HDA2CODEC_2X, .present = true },
+	[tegra_clk_audio0_2x] = { .dt_id = TEGRA124_CLK_AUDIO0_2X, .present = true },
+	[tegra_clk_audio1_2x] = { .dt_id = TEGRA124_CLK_AUDIO1_2X, .present = true },
+	[tegra_clk_audio2_2x] = { .dt_id = TEGRA124_CLK_AUDIO2_2X, .present = true },
+	[tegra_clk_audio3_2x] = { .dt_id = TEGRA124_CLK_AUDIO3_2X, .present = true },
+	[tegra_clk_audio4_2x] = { .dt_id = TEGRA124_CLK_AUDIO4_2X, .present = true },
+	[tegra_clk_spdif_2x] = { .dt_id = TEGRA124_CLK_SPDIF_2X, .present = true },
+	[tegra_clk_actmon] = { .dt_id = TEGRA124_CLK_ACTMON, .present = true },
+	[tegra_clk_extern1] = { .dt_id = TEGRA124_CLK_EXTERN1, .present = true },
+	[tegra_clk_extern2] = { .dt_id = TEGRA124_CLK_EXTERN2, .present = true },
+	[tegra_clk_extern3] = { .dt_id = TEGRA124_CLK_EXTERN3, .present = true },
+	[tegra_clk_sata_oob] = { .dt_id = TEGRA124_CLK_SATA_OOB, .present = true },
+	[tegra_clk_sata] = { .dt_id = TEGRA124_CLK_SATA, .present = true },
+	[tegra_clk_hda] = { .dt_id = TEGRA124_CLK_HDA, .present = true },
+	[tegra_clk_se] = { .dt_id = TEGRA124_CLK_SE, .present = true },
+	[tegra_clk_hda2hdmi] = { .dt_id = TEGRA124_CLK_HDA2HDMI, .present = true },
+	[tegra_clk_sata_cold] = { .dt_id = TEGRA124_CLK_SATA_COLD, .present = true },
+	[tegra_clk_cilab] = { .dt_id = TEGRA124_CLK_CILAB, .present = true },
+	[tegra_clk_cilcd] = { .dt_id = TEGRA124_CLK_CILCD, .present = true },
+	[tegra_clk_cile] = { .dt_id = TEGRA124_CLK_CILE, .present = true },
+	[tegra_clk_dsialp] = { .dt_id = TEGRA124_CLK_DSIALP, .present = true },
+	[tegra_clk_dsiblp] = { .dt_id = TEGRA124_CLK_DSIBLP, .present = true },
+	[tegra_clk_entropy] = { .dt_id = TEGRA124_CLK_ENTROPY, .present = true },
+	[tegra_clk_dds] = { .dt_id = TEGRA124_CLK_DDS, .present = true },
+	[tegra_clk_dp2] = { .dt_id = TEGRA124_CLK_DP2, .present = true },
+	[tegra_clk_amx] = { .dt_id = TEGRA124_CLK_AMX, .present = true },
+	[tegra_clk_adx] = { .dt_id = TEGRA124_CLK_ADX, .present = true },
+	[tegra_clk_xusb_ss] = { .dt_id = TEGRA124_CLK_XUSB_SS, .present = true },
+	[tegra_clk_i2c6] = { .dt_id = TEGRA124_CLK_I2C6, .present = true },
+	[tegra_clk_vim2_clk] = { .dt_id = TEGRA124_CLK_VIM2_CLK, .present = true },
+	[tegra_clk_hdmi_audio] = { .dt_id = TEGRA124_CLK_HDMI_AUDIO, .present = true },
+	[tegra_clk_clk72Mhz] = { .dt_id = TEGRA124_CLK_CLK72MHZ, .present = true },
+	[tegra_clk_vic03] = { .dt_id = TEGRA124_CLK_VIC03, .present = true },
+	[tegra_clk_adx1] = { .dt_id = TEGRA124_CLK_ADX1, .present = true },
+	[tegra_clk_dpaux] = { .dt_id = TEGRA124_CLK_DPAUX, .present = true },
+	[tegra_clk_sor0] = { .dt_id = TEGRA124_CLK_SOR0, .present = true },
+	[tegra_clk_gpu] = { .dt_id = TEGRA124_CLK_GPU, .present = true },
+	[tegra_clk_amx1] = { .dt_id = TEGRA124_CLK_AMX1, .present = true },
+	[tegra_clk_uartb] = { .dt_id = TEGRA124_CLK_UARTB, .present = true },
+	[tegra_clk_vfir] = { .dt_id = TEGRA124_CLK_VFIR, .present = true },
+	[tegra_clk_spdif_in] = { .dt_id = TEGRA124_CLK_SPDIF_IN, .present = true },
+	[tegra_clk_spdif_out] = { .dt_id = TEGRA124_CLK_SPDIF_OUT, .present = true },
+	[tegra_clk_vi] = { .dt_id = TEGRA124_CLK_VI, .present = true },
+	[tegra_clk_vi_sensor] = { .dt_id = TEGRA124_CLK_VI_SENSOR, .present = true },
+	[tegra_clk_fuse] = { .dt_id = TEGRA124_CLK_FUSE, .present = true },
+	[tegra_clk_fuse_burn] = { .dt_id = TEGRA124_CLK_FUSE_BURN, .present = true },
+	[tegra_clk_clk_32k] = { .dt_id = TEGRA124_CLK_CLK_32K, .present = true },
+	[tegra_clk_clk_m] = { .dt_id = TEGRA124_CLK_CLK_M, .present = true },
+	[tegra_clk_clk_m_div2] = { .dt_id = TEGRA124_CLK_CLK_M_DIV2, .present = true },
+	[tegra_clk_clk_m_div4] = { .dt_id = TEGRA124_CLK_CLK_M_DIV4, .present = true },
+	[tegra_clk_pll_ref] = { .dt_id = TEGRA124_CLK_PLL_REF, .present = true },
+	[tegra_clk_pll_c] = { .dt_id = TEGRA124_CLK_PLL_C, .present = true },
+	[tegra_clk_pll_c_out1] = { .dt_id = TEGRA124_CLK_PLL_C_OUT1, .present = true },
+	[tegra_clk_pll_c2] = { .dt_id = TEGRA124_CLK_PLL_C2, .present = true },
+	[tegra_clk_pll_c3] = { .dt_id = TEGRA124_CLK_PLL_C3, .present = true },
+	[tegra_clk_pll_m] = { .dt_id = TEGRA124_CLK_PLL_M, .present = true },
+	[tegra_clk_pll_m_out1] = { .dt_id = TEGRA124_CLK_PLL_M_OUT1, .present = true },
+	[tegra_clk_pll_p] = { .dt_id = TEGRA124_CLK_PLL_P, .present = true },
+	[tegra_clk_pll_p_out1] = { .dt_id = TEGRA124_CLK_PLL_P_OUT1, .present = true },
+	[tegra_clk_pll_p_out2] = { .dt_id = TEGRA124_CLK_PLL_P_OUT2, .present = true },
+	[tegra_clk_pll_p_out3] = { .dt_id = TEGRA124_CLK_PLL_P_OUT3, .present = true },
+	[tegra_clk_pll_p_out4] = { .dt_id = TEGRA124_CLK_PLL_P_OUT4, .present = true },
+	[tegra_clk_pll_a] = { .dt_id = TEGRA124_CLK_PLL_A, .present = true },
+	[tegra_clk_pll_a_out0] = { .dt_id = TEGRA124_CLK_PLL_A_OUT0, .present = true },
+	[tegra_clk_pll_d] = { .dt_id = TEGRA124_CLK_PLL_D, .present = true },
+	[tegra_clk_pll_d_out0] = { .dt_id = TEGRA124_CLK_PLL_D_OUT0, .present = true },
+	[tegra_clk_pll_d2] = { .dt_id = TEGRA124_CLK_PLL_D2, .present = true },
+	[tegra_clk_pll_d2_out0] = { .dt_id = TEGRA124_CLK_PLL_D2_OUT0, .present = true },
+	[tegra_clk_pll_u] = { .dt_id = TEGRA124_CLK_PLL_U, .present = true },
+	[tegra_clk_pll_u_480m] = { .dt_id = TEGRA124_CLK_PLL_U_480M, .present = true },
+	[tegra_clk_pll_u_60m] = { .dt_id = TEGRA124_CLK_PLL_U_60M, .present = true },
+	[tegra_clk_pll_u_48m] = { .dt_id = TEGRA124_CLK_PLL_U_48M, .present = true },
+	[tegra_clk_pll_u_12m] = { .dt_id = TEGRA124_CLK_PLL_U_12M, .present = true },
+	[tegra_clk_pll_x] = { .dt_id = TEGRA124_CLK_PLL_X, .present = true },
+	[tegra_clk_pll_x_out0] = { .dt_id = TEGRA124_CLK_PLL_X_OUT0, .present = true },
+	[tegra_clk_pll_re_vco] = { .dt_id = TEGRA124_CLK_PLL_RE_VCO, .present = true },
+	[tegra_clk_pll_re_out] = { .dt_id = TEGRA124_CLK_PLL_RE_OUT, .present = true },
+	[tegra_clk_spdif_in_sync] = { .dt_id = TEGRA124_CLK_SPDIF_IN_SYNC, .present = true },
+	[tegra_clk_i2s0_sync] = { .dt_id = TEGRA124_CLK_I2S0_SYNC, .present = true },
+	[tegra_clk_i2s1_sync] = { .dt_id = TEGRA124_CLK_I2S1_SYNC, .present = true },
+	[tegra_clk_i2s2_sync] = { .dt_id = TEGRA124_CLK_I2S2_SYNC, .present = true },
+	[tegra_clk_i2s3_sync] = { .dt_id = TEGRA124_CLK_I2S3_SYNC, .present = true },
+	[tegra_clk_i2s4_sync] = { .dt_id = TEGRA124_CLK_I2S4_SYNC, .present = true },
+	[tegra_clk_vimclk_sync] = { .dt_id = TEGRA124_CLK_VIMCLK_SYNC, .present = true },
+	[tegra_clk_audio0] = { .dt_id = TEGRA124_CLK_AUDIO0, .present = true },
+	[tegra_clk_audio1] = { .dt_id = TEGRA124_CLK_AUDIO1, .present = true },
+	[tegra_clk_audio2] = { .dt_id = TEGRA124_CLK_AUDIO2, .present = true },
+	[tegra_clk_audio3] = { .dt_id = TEGRA124_CLK_AUDIO3, .present = true },
+	[tegra_clk_audio4] = { .dt_id = TEGRA124_CLK_AUDIO4, .present = true },
+	[tegra_clk_spdif] = { .dt_id = TEGRA124_CLK_SPDIF, .present = true },
+	[tegra_clk_clk_out_1] = { .dt_id = TEGRA124_CLK_CLK_OUT_1, .present = true },
+	[tegra_clk_clk_out_2] = { .dt_id = TEGRA124_CLK_CLK_OUT_2, .present = true },
+	[tegra_clk_clk_out_3] = { .dt_id = TEGRA124_CLK_CLK_OUT_3, .present = true },
+	[tegra_clk_blink] = { .dt_id = TEGRA124_CLK_BLINK, .present = true },
+	[tegra_clk_xusb_host_src] = { .dt_id = TEGRA124_CLK_XUSB_HOST_SRC, .present = true },
+	[tegra_clk_xusb_falcon_src] = { .dt_id = TEGRA124_CLK_XUSB_FALCON_SRC, .present = true },
+	[tegra_clk_xusb_fs_src] = { .dt_id = TEGRA124_CLK_XUSB_FS_SRC, .present = true },
+	[tegra_clk_xusb_ss_src] = { .dt_id = TEGRA124_CLK_XUSB_SS_SRC, .present = true },
+	[tegra_clk_xusb_dev_src] = { .dt_id = TEGRA124_CLK_XUSB_DEV_SRC, .present = true },
+	[tegra_clk_xusb_dev] = { .dt_id = TEGRA124_CLK_XUSB_DEV, .present = true },
+	[tegra_clk_xusb_hs_src] = { .dt_id = TEGRA124_CLK_XUSB_HS_SRC, .present = true },
+	[tegra_clk_sclk] = { .dt_id = TEGRA124_CLK_SCLK, .present = true },
+	[tegra_clk_hclk] = { .dt_id = TEGRA124_CLK_HCLK, .present = true },
+	[tegra_clk_pclk] = { .dt_id = TEGRA124_CLK_PCLK, .present = true },
+	[tegra_clk_cclk_g] = { .dt_id = TEGRA124_CLK_CCLK_G, .present = true },
+	[tegra_clk_cclk_lp] = { .dt_id = TEGRA124_CLK_CCLK_LP, .present = true },
+	[tegra_clk_dfll_ref] = { .dt_id = TEGRA124_CLK_DFLL_REF, .present = true },
+	[tegra_clk_dfll_soc] = { .dt_id = TEGRA124_CLK_DFLL_SOC, .present = true },
+	[tegra_clk_vi_sensor2] = { .dt_id = TEGRA124_CLK_VI_SENSOR2, .present = true },
+	[tegra_clk_pll_p_out5] = { .dt_id = TEGRA124_CLK_PLL_P_OUT5, .present = true },
+	[tegra_clk_cml0] = { .dt_id = TEGRA124_CLK_CML0, .present = true },
+	[tegra_clk_cml1] = { .dt_id = TEGRA124_CLK_CML1, .present = true },
+	[tegra_clk_pll_c4] = { .dt_id = TEGRA124_CLK_PLL_C4, .present = true },
+	[tegra_clk_pll_dp] = { .dt_id = TEGRA124_CLK_PLL_DP, .present = true },
+	[tegra_clk_audio0_mux] = { .dt_id = TEGRA124_CLK_AUDIO0_MUX, .present = true },
+	[tegra_clk_audio1_mux] = { .dt_id = TEGRA124_CLK_AUDIO1_MUX, .present = true },
+	[tegra_clk_audio2_mux] = { .dt_id = TEGRA124_CLK_AUDIO2_MUX, .present = true },
+	[tegra_clk_audio3_mux] = { .dt_id = TEGRA124_CLK_AUDIO3_MUX, .present = true },
+	[tegra_clk_audio4_mux] = { .dt_id = TEGRA124_CLK_AUDIO4_MUX, .present = true },
+	[tegra_clk_spdif_mux] = { .dt_id = TEGRA124_CLK_SPDIF_MUX, .present = true },
+	[tegra_clk_clk_out_1_mux] = { .dt_id = TEGRA124_CLK_CLK_OUT_1_MUX, .present = true },
+	[tegra_clk_clk_out_2_mux] = { .dt_id = TEGRA124_CLK_CLK_OUT_2_MUX, .present = true },
+	[tegra_clk_clk_out_3_mux] = { .dt_id = TEGRA124_CLK_CLK_OUT_3_MUX, .present = true },
+	[tegra_clk_dsia_mux] = { .dt_id = TEGRA124_CLK_DSIA_MUX, .present = true },
+	[tegra_clk_dsib_mux] = { .dt_id = TEGRA124_CLK_DSIB_MUX, .present = true },
+	[tegra_clk_uarte] = { .dt_id = TEGRA124_CLK_UARTE, .present = true },
+};
+
+static struct clk **clks;
+
+static void tegra124_utmi_param_configure(void __iomem *clk_base)
+{
+	u32 reg;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(utmi_parameters); i++) {
+		if (osc_freq == utmi_parameters[i].osc_frequency)
+			break;
+	}
+
+	if (i >= ARRAY_SIZE(utmi_parameters)) {
+		pr_err("%s: Unexpected oscillator freq %lu\n", __func__,
+		       osc_freq);
+		return;
+	}
+
+	reg = readl_relaxed(clk_base + UTMIP_PLL_CFG2);
+
+	/* Program UTMIP PLL stable and active counts */
+	/* [FIXME] arclk_rst.h says WRONG! This should be 1ms -> 0x50 Check! */
+	reg &= ~UTMIP_PLL_CFG2_STABLE_COUNT(~0);
+	reg |= UTMIP_PLL_CFG2_STABLE_COUNT(utmi_parameters[i].stable_count);
+
+	reg &= ~UTMIP_PLL_CFG2_ACTIVE_DLY_COUNT(~0);
+
+	reg |= UTMIP_PLL_CFG2_ACTIVE_DLY_COUNT(utmi_parameters[i].
+					    active_delay_count);
+
+	/* Remove power downs from UTMIP PLL control bits */
+	reg &= ~UTMIP_PLL_CFG2_FORCE_PD_SAMP_A_POWERDOWN;
+	reg &= ~UTMIP_PLL_CFG2_FORCE_PD_SAMP_B_POWERDOWN;
+	reg &= ~UTMIP_PLL_CFG2_FORCE_PD_SAMP_C_POWERDOWN;
+
+	writel_relaxed(reg, clk_base + UTMIP_PLL_CFG2);
+
+	/* Program UTMIP PLL delay and oscillator frequency counts */
+	reg = readl_relaxed(clk_base + UTMIP_PLL_CFG1);
+	reg &= ~UTMIP_PLL_CFG1_ENABLE_DLY_COUNT(~0);
+
+	reg |= UTMIP_PLL_CFG1_ENABLE_DLY_COUNT(utmi_parameters[i].
+					    enable_delay_count);
+
+	reg &= ~UTMIP_PLL_CFG1_XTAL_FREQ_COUNT(~0);
+	reg |= UTMIP_PLL_CFG1_XTAL_FREQ_COUNT(utmi_parameters[i].
+					   xtal_freq_count);
+
+	/* Remove power downs from UTMIP PLL control bits */
+	reg &= ~UTMIP_PLL_CFG1_FORCE_PLL_ENABLE_POWERDOWN;
+	reg &= ~UTMIP_PLL_CFG1_FORCE_PLL_ACTIVE_POWERDOWN;
+	reg &= ~UTMIP_PLL_CFG1_FORCE_PLLU_POWERUP;
+	reg &= ~UTMIP_PLL_CFG1_FORCE_PLLU_POWERDOWN;
+	writel_relaxed(reg, clk_base + UTMIP_PLL_CFG1);
+
+	/* Setup HW control of UTMIPLL */
+	reg = readl_relaxed(clk_base + UTMIPLL_HW_PWRDN_CFG0);
+	reg |= UTMIPLL_HW_PWRDN_CFG0_USE_LOCKDET;
+	reg &= ~UTMIPLL_HW_PWRDN_CFG0_CLK_ENABLE_SWCTL;
+	reg |= UTMIPLL_HW_PWRDN_CFG0_SEQ_START_STATE;
+	writel_relaxed(reg, clk_base + UTMIPLL_HW_PWRDN_CFG0);
+
+	reg = readl_relaxed(clk_base + UTMIP_PLL_CFG1);
+	reg &= ~UTMIP_PLL_CFG1_FORCE_PLL_ENABLE_POWERUP;
+	reg &= ~UTMIP_PLL_CFG1_FORCE_PLL_ENABLE_POWERDOWN;
+	writel_relaxed(reg, clk_base + UTMIP_PLL_CFG1);
+
+	udelay(1);
+
+	/* Setup SW override of UTMIPLL assuming USB2.0
+	   ports are assigned to USB2 */
+	reg = readl_relaxed(clk_base + UTMIPLL_HW_PWRDN_CFG0);
+	reg |= UTMIPLL_HW_PWRDN_CFG0_IDDQ_SWCTL;
+	reg &= ~UTMIPLL_HW_PWRDN_CFG0_IDDQ_OVERRIDE;
+	writel_relaxed(reg, clk_base + UTMIPLL_HW_PWRDN_CFG0);
+
+	udelay(1);
+
+	/* Enable HW control UTMIPLL */
+	reg = readl_relaxed(clk_base + UTMIPLL_HW_PWRDN_CFG0);
+	reg |= UTMIPLL_HW_PWRDN_CFG0_SEQ_ENABLE;
+	writel_relaxed(reg, clk_base + UTMIPLL_HW_PWRDN_CFG0);
+}
+
+static __init void tegra124_periph_clk_init(void __iomem *clk_base,
+					    void __iomem *pmc_base)
+{
+	struct clk *clk;
+	u32 val;
+
+	/* xusb_hs_src */
+	val = readl(clk_base + CLK_SOURCE_XUSB_SS_SRC);
+	val |= BIT(25); /* always select PLLU_60M */
+	writel(val, clk_base + CLK_SOURCE_XUSB_SS_SRC);
+
+	clk = clk_register_fixed_factor(NULL, "xusb_hs_src", "pll_u_60M", 0,
+					1, 1);
+	clks[TEGRA124_CLK_XUSB_HS_SRC] = clk;
+
+	/* dsia mux */
+	clk = clk_register_mux(NULL, "dsia_mux", mux_plld_out0_plld2_out0,
+			       ARRAY_SIZE(mux_plld_out0_plld2_out0), 0,
+			       clk_base + PLLD_BASE, 25, 1, 0, &pll_d_lock);
+	clks[TEGRA124_CLK_DSIA_MUX] = clk;
+
+	/* dsib mux */
+	clk = clk_register_mux(NULL, "dsib_mux", mux_plld_out0_plld2_out0,
+			       ARRAY_SIZE(mux_plld_out0_plld2_out0), 0,
+			       clk_base + PLLD2_BASE, 25, 1, 0, &pll_d2_lock);
+	clks[TEGRA124_CLK_DSIB_MUX] = clk;
+
+	/* emc mux */
+	clk = clk_register_mux(NULL, "emc_mux", mux_pllmcp_clkm,
+			       ARRAY_SIZE(mux_pllmcp_clkm), 0,
+			       clk_base + CLK_SOURCE_EMC,
+			       29, 3, 0, NULL);
+
+	/* cml0 */
+	clk = clk_register_gate(NULL, "cml0", "pll_e", 0, clk_base + PLLE_AUX,
+				0, 0, &pll_e_lock);
+	clk_register_clkdev(clk, "cml0", NULL);
+	clks[TEGRA124_CLK_CML0] = clk;
+
+	/* cml1 */
+	clk = clk_register_gate(NULL, "cml1", "pll_e", 0, clk_base + PLLE_AUX,
+				1, 0, &pll_e_lock);
+	clk_register_clkdev(clk, "cml1", NULL);
+	clks[TEGRA124_CLK_CML1] = clk;
+
+	tegra_periph_clk_init(clk_base, pmc_base, tegra124_clks);
+}
+
+static const char *mux_pll_e[] = { "pll_ref", "pll_p", "pllre_vco" };
+static u32 mux_pll_e_idx[] = { [0] = 0, [1] = BIT(2), [2] = BIT(28) };
+
+static void __init tegra124_pll_init(void __iomem *clk_base,
+				     void __iomem *pmc)
+{
+	u32 val;
+	struct clk *clk;
+
+	/* PLLC */
+	clk = tegra_clk_register_pllxc("pll_c", "pll_ref", clk_base,
+			pmc, 0, 0, &pll_c_params, TEGRA_PLL_USE_LOCK,
+			pll_c_freq_table, NULL);
+	clk_register_clkdev(clk, "pll_c", NULL);
+	clks[TEGRA124_CLK_PLL_C] = clk;
+
+	/* PLLC_OUT1 */
+	clk = tegra_clk_register_divider("pll_c_out1_div", "pll_c",
+			clk_base + PLLC_OUT, 0, TEGRA_DIVIDER_ROUND_UP,
+			8, 8, 1, NULL);
+	clk = tegra_clk_register_pll_out("pll_c_out1", "pll_c_out1_div",
+				clk_base + PLLC_OUT, 1, 0,
+				CLK_SET_RATE_PARENT, 0, NULL);
+	clk_register_clkdev(clk, "pll_c_out1", NULL);
+	clks[TEGRA124_CLK_PLL_C_OUT1] = clk;
+
+	/* PLLC2 */
+	clk = tegra_clk_register_pllc("pll_c2", "pll_ref", clk_base, pmc, 0, 0,
+			     &pll_c2_params, TEGRA_PLL_USE_LOCK,
+			     pll_cx_freq_table, NULL);
+	clk_register_clkdev(clk, "pll_c2", NULL);
+	clks[TEGRA124_CLK_PLL_C2] = clk;
+
+	/* PLLC3 */
+	clk = tegra_clk_register_pllc("pll_c3", "pll_ref", clk_base, pmc, 0, 0,
+			     &pll_c3_params, TEGRA_PLL_USE_LOCK,
+			     pll_cx_freq_table, NULL);
+	clk_register_clkdev(clk, "pll_c3", NULL);
+	clks[TEGRA124_CLK_PLL_C3] = clk;
+
+	/* PLLM */
+	clk = tegra_clk_register_pllm("pll_m", "pll_ref", clk_base, pmc,
+			     CLK_IGNORE_UNUSED | CLK_SET_RATE_GATE, 0,
+			     &pll_m_params, TEGRA_PLL_USE_LOCK,
+			     pll_m_freq_table, NULL);
+	clk_register_clkdev(clk, "pll_m", NULL);
+	clks[TEGRA124_CLK_PLL_M] = clk;
+
+	/* PLLM_OUT1 */
+	clk = tegra_clk_register_divider("pll_m_out1_div", "pll_m",
+				clk_base + PLLM_OUT, 0, TEGRA_DIVIDER_ROUND_UP,
+				8, 8, 1, NULL);
+	clk = tegra_clk_register_pll_out("pll_m_out1", "pll_m_out1_div",
+				clk_base + PLLM_OUT, 1, 0, CLK_IGNORE_UNUSED |
+				CLK_SET_RATE_PARENT, 0, NULL);
+	clk_register_clkdev(clk, "pll_m_out1", NULL);
+	clks[TEGRA124_CLK_PLL_M_OUT1] = clk;
+
+	/* PLLM_UD */
+	clk = clk_register_fixed_factor(NULL, "pll_m_ud", "pll_m",
+					CLK_SET_RATE_PARENT, 1, 1);
+
+	/* PLLU */
+	val = readl(clk_base + pll_u_params.base_reg);
+	val &= ~BIT(24); /* disable PLLU_OVERRIDE */
+	writel(val, clk_base + pll_u_params.base_reg);
+
+	clk = tegra_clk_register_pll("pll_u", "pll_ref", clk_base, pmc, 0,
+			    0, &pll_u_params, TEGRA_PLLU |
+			    TEGRA_PLL_HAS_CPCON | TEGRA_PLL_SET_LFCON |
+			    TEGRA_PLL_USE_LOCK, pll_u_freq_table, &pll_u_lock);
+	clk_register_clkdev(clk, "pll_u", NULL);
+	clks[TEGRA124_CLK_PLL_U] = clk;
+
+	tegra124_utmi_param_configure(clk_base);
+
+	/* PLLU_480M */
+	clk = clk_register_gate(NULL, "pll_u_480M", "pll_u",
+				CLK_SET_RATE_PARENT, clk_base + PLLU_BASE,
+				22, 0, &pll_u_lock);
+	clk_register_clkdev(clk, "pll_u_480M", NULL);
+	clks[TEGRA124_CLK_PLL_U_480M] = clk;
+
+	/* PLLU_60M */
+	clk = clk_register_fixed_factor(NULL, "pll_u_60M", "pll_u",
+					CLK_SET_RATE_PARENT, 1, 8);
+	clk_register_clkdev(clk, "pll_u_60M", NULL);
+	clks[TEGRA124_CLK_PLL_U_60M] = clk;
+
+	/* PLLU_48M */
+	clk = clk_register_fixed_factor(NULL, "pll_u_48M", "pll_u",
+					CLK_SET_RATE_PARENT, 1, 10);
+	clk_register_clkdev(clk, "pll_u_48M", NULL);
+	clks[TEGRA124_CLK_PLL_U_48M] = clk;
+
+	/* PLLU_12M */
+	clk = clk_register_fixed_factor(NULL, "pll_u_12M", "pll_u",
+					CLK_SET_RATE_PARENT, 1, 40);
+	clk_register_clkdev(clk, "pll_u_12M", NULL);
+	clks[TEGRA124_CLK_PLL_U_12M] = clk;
+
+	/* PLLD */
+	clk = tegra_clk_register_pll("pll_d", "pll_ref", clk_base, pmc, 0,
+			    0, &pll_d_params,
+			    TEGRA_PLL_HAS_CPCON | TEGRA_PLL_SET_LFCON |
+			    TEGRA_PLL_USE_LOCK, pll_d_freq_table, &pll_d_lock);
+	clk_register_clkdev(clk, "pll_d", NULL);
+	clks[TEGRA124_CLK_PLL_D] = clk;
+
+	/* PLLD_OUT0 */
+	clk = clk_register_fixed_factor(NULL, "pll_d_out0", "pll_d",
+					CLK_SET_RATE_PARENT, 1, 2);
+	clk_register_clkdev(clk, "pll_d_out0", NULL);
+	clks[TEGRA124_CLK_PLL_D_OUT0] = clk;
+
+	/* PLLRE */
+	clk = tegra_clk_register_pllre("pll_re_vco", "pll_ref", clk_base, pmc,
+			     0, 0, &pll_re_vco_params, TEGRA_PLL_USE_LOCK,
+			     NULL, &pll_re_lock, pll_ref_freq);
+	clk_register_clkdev(clk, "pll_re_vco", NULL);
+	clks[TEGRA124_CLK_PLL_RE_VCO] = clk;
+
+	clk = clk_register_divider_table(NULL, "pll_re_out", "pll_re_vco", 0,
+					 clk_base + PLLRE_BASE, 16, 4, 0,
+					 pll_re_div_table, &pll_re_lock);
+	clk_register_clkdev(clk, "pll_re_out", NULL);
+	clks[TEGRA124_CLK_PLL_RE_OUT] = clk;
+
+	/* PLLE */
+	clk = clk_register_mux_table(NULL, "pll_e_mux", mux_pll_e,
+				ARRAY_SIZE(mux_pll_e), CLK_SET_RATE_PARENT,
+				clk_base + PLLE_AUX, 0, BIT(28) | BIT(2),
+				0, mux_pll_e_idx, &pll_e_lock);
+	clks[TEGRA124_CLK_PLL_E_MUX] = clk;
+
+	clk = tegra_clk_register_plle_tegra114("pll_e", "pll_e_mux",
+				      clk_base, 0, 100000000, &pll_e_params,
+				      pll_e_freq_table, &pll_e_lock);
+	clk_register_clkdev(clk, "pll_e", NULL);
+	clks[TEGRA124_CLK_PLL_E] = clk;
+
+	/* PLLC4 */
+	clk = tegra_clk_register_pllss("pll_c4", "pll_ref", clk_base, 0, 0,
+					&pll_c4_params, pll_c4_freq_table, NULL);
+	clk_register_clkdev(clk, "pll_c4", NULL);
+	clks[TEGRA124_CLK_PLL_C4] = clk;
+
+	/* PLLDP */
+	clk = tegra_clk_register_pllss("pll_dp", "pll_ref", clk_base, 0, 0,
+					&pll_dp_params, pll_dp_freq_table, NULL);
+	clk_register_clkdev(clk, "pll_dp", NULL);
+	clks[TEGRA124_CLK_PLL_DP] = clk;
+
+	/* PLLD2 */
+	clk = tegra_clk_register_pllss("pll_d2", "pll_ref", clk_base, 0, 0,
+					&tegra124_pll_d2_params,
+					tegra124_pll_d2_freq_table, NULL);
+	clk_register_clkdev(clk, "pll_d2", NULL);
+	clks[TEGRA124_CLK_PLL_D2] = clk;
+
+	/* PLLD2_OUT0 ?? */
+	clk = clk_register_fixed_factor(NULL, "pll_d2_out0", "pll_d2",
+					CLK_SET_RATE_PARENT, 1, 2);
+	clk_register_clkdev(clk, "pll_d2_out0", NULL);
+	clks[TEGRA124_CLK_PLL_D2_OUT0] = clk;
+
+}
+
+static const struct of_device_id pmc_match[] __initconst = {
+	{ .compatible = "nvidia,tegra124-pmc" },
+	{},
+};
+
+static __initdata struct tegra_clk_init_table init_table[] = {
+	{TEGRA124_CLK_UARTA, TEGRA124_CLK_PLL_P, 408000000, 0},
+	{TEGRA124_CLK_UARTB, TEGRA124_CLK_PLL_P, 408000000, 0},
+	{TEGRA124_CLK_UARTC, TEGRA124_CLK_PLL_P, 408000000, 0},
+	{TEGRA124_CLK_UARTD, TEGRA124_CLK_PLL_P, 408000000, 0},
+	{TEGRA124_CLK_PLL_A, TEGRA124_CLK_CLK_MAX, 564480000, 1},
+	{TEGRA124_CLK_PLL_A_OUT0, TEGRA124_CLK_CLK_MAX, 11289600, 1},
+	{TEGRA124_CLK_EXTERN1, TEGRA124_CLK_PLL_A_OUT0, 0, 1},
+	{TEGRA124_CLK_CLK_OUT_1_MUX, TEGRA124_CLK_EXTERN1, 0, 1},
+	{TEGRA124_CLK_CLK_OUT_1, TEGRA124_CLK_CLK_MAX, 0, 1},
+	{TEGRA124_CLK_I2S0, TEGRA124_CLK_PLL_A_OUT0, 11289600, 0},
+	{TEGRA124_CLK_I2S1, TEGRA124_CLK_PLL_A_OUT0, 11289600, 0},
+	{TEGRA124_CLK_I2S2, TEGRA124_CLK_PLL_A_OUT0, 11289600, 0},
+	{TEGRA124_CLK_I2S3, TEGRA124_CLK_PLL_A_OUT0, 11289600, 0},
+	{TEGRA124_CLK_I2S4, TEGRA124_CLK_PLL_A_OUT0, 11289600, 0},
+	{TEGRA124_CLK_VDE, TEGRA124_CLK_PLL_P, 0, 0},
+	{TEGRA124_CLK_HOST1X, TEGRA124_CLK_PLL_P, 136000000, 1},
+	{TEGRA124_CLK_EPP, TEGRA124_CLK_PLL_C2, 300000000, 0},
+	{TEGRA124_CLK_SCLK, TEGRA124_CLK_PLL_P_OUT2, 102000000, 1},
+	{TEGRA124_CLK_DFLL_SOC, TEGRA124_CLK_PLL_P, 51000000, 1},
+	{TEGRA124_CLK_DFLL_REF, TEGRA124_CLK_PLL_P, 51000000, 1},
+	{TEGRA124_CLK_PLL_C, TEGRA124_CLK_CLK_MAX, 768000000, 0},
+	{TEGRA124_CLK_PLL_C_OUT1, TEGRA124_CLK_CLK_MAX, 100000000, 0},
+	{TEGRA124_CLK_SBC4, TEGRA124_CLK_PLL_P, 12000000, 1},
+	{TEGRA124_CLK_TSEC, TEGRA124_CLK_PLL_C3, 0, 0},
+	{TEGRA124_CLK_MSENC, TEGRA124_CLK_PLL_C3, 0, 0},
+	/* This MUST be the last entry. */
+	{TEGRA124_CLK_CLK_MAX, TEGRA124_CLK_CLK_MAX, 0, 0},
+};
+
+static void __init tegra124_clock_apply_init_table(void)
+{
+	tegra_init_from_table(init_table, clks, TEGRA124_CLK_CLK_MAX);
+}
+
+static void __init tegra124_clock_init(struct device_node *np)
+{
+	struct device_node *node;
+
+	clk_base = of_iomap(np, 0);
+	if (!clk_base) {
+		pr_err("ioremap tegra124 CAR failed\n");
+		return;
+	}
+
+	node = of_find_matching_node(NULL, pmc_match);
+	if (!node) {
+		pr_err("Failed to find pmc node\n");
+		WARN_ON(1);
+		return;
+	}
+
+	pmc_base = of_iomap(node, 0);
+	if (!pmc_base) {
+		pr_err("Can't map pmc registers\n");
+		WARN_ON(1);
+		return;
+	}
+
+	clks = tegra_clk_init(TEGRA124_CLK_CLK_MAX, 6);
+	if (!clks)
+		return;
+
+	if (tegra_osc_clk_init(clk_base, tegra124_clks, tegra124_input_freq,
+		ARRAY_SIZE(tegra124_input_freq), &osc_freq, &pll_ref_freq) < 0)
+		return;
+
+	tegra_fixed_clk_init(tegra124_clks);
+	tegra124_pll_init(clk_base, pmc_base);
+	tegra124_periph_clk_init(clk_base, pmc_base);
+	tegra_audio_clk_init(clk_base, pmc_base, tegra124_clks, NULL);
+	tegra_pmc_clk_init(pmc_base, tegra124_clks);
+
+	tegra_super_clk_gen4_init(clk_base, pmc_base, tegra124_clks);
+	tegra_add_of_provider(np);
+
+	tegra_clk_apply_init_table = tegra124_clock_apply_init_table;
+}
+CLK_OF_DECLARE(tegra124, "nvidia,tegra124-car", tegra124_clock_init);
diff --git a/include/dt-bindings/clock/tegra124-car.h b/include/dt-bindings/clock/tegra124-car.h
new file mode 100644
index 0000000..5917ff7
--- /dev/null
+++ b/include/dt-bindings/clock/tegra124-car.h
@@ -0,0 +1,342 @@
+/*
+ * This header provides constants for binding nvidia,tegra114-car.
+ *
+ * The first 160 clocks are numbered to match the bits in the CAR's CLK_OUT_ENB
+ * registers. These IDs often match those in the CAR's RST_DEVICES registers,
+ * but not in all cases. Some bits in CLK_OUT_ENB affect multiple clocks. In
+ * this case, those clocks are assigned IDs above 160 in order to highlight
+ * this issue. Implementations that interpret these clock IDs as bit values
+ * within the CLK_OUT_ENB or RST_DEVICES registers should be careful to
+ * explicitly handle these special cases.
+ *
+ * The balance of the clocks controlled by the CAR are assigned IDs of 160 and
+ * above.
+ */
+
+#ifndef _DT_BINDINGS_CLOCK_TEGRA124_CAR_H
+#define _DT_BINDINGS_CLOCK_TEGRA124_CAR_H
+
+/* 0 */
+/* 1 */
+/* 2 */
+#define TEGRA124_CLK_ISPB 3
+#define TEGRA124_CLK_RTC 4
+#define TEGRA124_CLK_TIMER 5
+#define TEGRA124_CLK_UARTA 6
+/* 7 (register bit affects uartb and vfir) */
+/* 8 */
+#define TEGRA124_CLK_SDMMC2 9
+/* 10 (register bit affects spdif_in and spdif_out) */
+#define TEGRA124_CLK_I2S1 11
+#define TEGRA124_CLK_I2C1 12
+#define TEGRA124_CLK_NDFLASH 13
+#define TEGRA124_CLK_SDMMC1 14
+#define TEGRA124_CLK_SDMMC4 15
+/* 16 */
+#define TEGRA124_CLK_PWM 17
+#define TEGRA124_CLK_I2S2 18
+#define TEGRA124_CLK_EPP 19
+/* 20 (register bit affects vi and vi_sensor) */
+#define TEGRA124_CLK_GR_2D 21
+#define TEGRA124_CLK_USBD 22
+#define TEGRA124_CLK_ISP 23
+#define TEGRA124_CLK_GR_3D 24
+/* 25 */
+#define TEGRA124_CLK_DISP2 26
+#define TEGRA124_CLK_DISP1 27
+#define TEGRA124_CLK_HOST1X 28
+#define TEGRA124_CLK_VCP 29
+#define TEGRA124_CLK_I2S0 30
+/* 31 */
+
+/* 32 */
+/* 33 */
+#define TEGRA124_CLK_APBDMA 34
+/* 35 */
+#define TEGRA124_CLK_KBC 36
+/* 37 */
+/* 38 */
+/* 39 (register bit affects fuse and fuse_burn) */
+#define TEGRA124_CLK_KFUSE 40
+#define TEGRA124_CLK_SBC1 41
+#define TEGRA124_CLK_NOR 42
+/* 43 */
+#define TEGRA124_CLK_SBC2 44
+/* 45 */
+#define TEGRA124_CLK_SBC3 46
+#define TEGRA124_CLK_I2C5 47
+#define TEGRA124_CLK_DSIA 48
+/* 49 */
+#define TEGRA124_CLK_MIPI 50
+#define TEGRA124_CLK_HDMI 51
+#define TEGRA124_CLK_CSI 52
+/* 53 */
+#define TEGRA124_CLK_I2C2 54
+#define TEGRA124_CLK_UARTC 55
+#define TEGRA124_CLK_MIPI_CAL 56
+#define TEGRA124_CLK_EMC 57
+#define TEGRA124_CLK_USB2 58
+#define TEGRA124_CLK_USB3 59
+/* 60 */
+#define TEGRA124_CLK_VDE 61
+#define TEGRA124_CLK_BSEA 62
+#define TEGRA124_CLK_BSEV 63
+
+/* 64 */
+#define TEGRA124_CLK_UARTD 65
+#define TEGRA124_CLK_UARTE 66
+#define TEGRA124_CLK_I2C3 67
+#define TEGRA124_CLK_SBC4 68
+#define TEGRA124_CLK_SDMMC3 69
+#define TEGRA124_CLK_PCIE 70
+#define TEGRA124_CLK_OWR 71
+#define TEGRA124_CLK_AFI 72
+#define TEGRA124_CLK_CSITE 73
+/* 74 */
+/* 75 */
+#define TEGRA124_CLK_LA 76
+#define TEGRA124_CLK_TRACE 77
+#define TEGRA124_CLK_SOC_THERM 78
+#define TEGRA124_CLK_DTV 79
+#define TEGRA124_CLK_NDSPEED 80
+#define TEGRA124_CLK_I2CSLOW 81
+#define TEGRA124_CLK_DSIB 82
+#define TEGRA124_CLK_TSEC 83
+/* 84 */
+/* 85 */
+/* 86 */
+/* 87 */
+/* 88 */
+#define TEGRA124_CLK_XUSB_HOST 89
+/* 90 */
+#define TEGRA124_CLK_MSENC 91
+#define TEGRA124_CLK_CSUS 92
+/* 93 */
+/* 94 */
+/* 95 (bit affects xusb_dev and xusb_dev_src) */
+
+/* 96 */
+/* 97 */
+/* 98 */
+#define TEGRA124_CLK_MSELECT 99
+#define TEGRA124_CLK_TSENSOR 100
+#define TEGRA124_CLK_I2S3 101
+#define TEGRA124_CLK_I2S4 102
+#define TEGRA124_CLK_I2C4 103
+#define TEGRA124_CLK_SBC5 104
+#define TEGRA124_CLK_SBC6 105
+#define TEGRA124_CLK_D_AUDIO 106
+#define TEGRA124_CLK_APBIF 107
+#define TEGRA124_CLK_DAM0 108
+#define TEGRA124_CLK_DAM1 109
+#define TEGRA124_CLK_DAM2 110
+#define TEGRA124_CLK_HDA2CODEC_2X 111
+/* 112 */
+#define TEGRA124_CLK_AUDIO0_2X 113
+#define TEGRA124_CLK_AUDIO1_2X 114
+#define TEGRA124_CLK_AUDIO2_2X 115
+#define TEGRA124_CLK_AUDIO3_2X 116
+#define TEGRA124_CLK_AUDIO4_2X 117
+#define TEGRA124_CLK_SPDIF_2X 118
+#define TEGRA124_CLK_ACTMON 119
+#define TEGRA124_CLK_EXTERN1 120
+#define TEGRA124_CLK_EXTERN2 121
+#define TEGRA124_CLK_EXTERN3 122
+#define TEGRA124_CLK_SATA_OOB 123
+#define TEGRA124_CLK_SATA 124
+#define TEGRA124_CLK_HDA 125
+/* 126 */
+#define TEGRA124_CLK_SE 127
+
+#define TEGRA124_CLK_HDA2HDMI 128
+#define TEGRA124_CLK_SATA_COLD 129
+/* 130 */
+/* 131 */
+/* 132 */
+/* 133 */
+/* 134 */
+/* 135 */
+/* 136 */
+/* 137 */
+/* 138 */
+/* 139 */
+/* 140 */
+/* 141 */
+/* 142 */
+/* 143 (bit affects xusb_falcon_src, xusb_fs_src, */
+/*      xusb_host_src and xusb_ss_src) */
+#define TEGRA124_CLK_CILAB 144
+#define TEGRA124_CLK_CILCD 145
+#define TEGRA124_CLK_CILE 146
+#define TEGRA124_CLK_DSIALP 147
+#define TEGRA124_CLK_DSIBLP 148
+#define TEGRA124_CLK_ENTROPY 149
+#define TEGRA124_CLK_DDS 150
+/* 151 */
+#define TEGRA124_CLK_DP2 152
+#define TEGRA124_CLK_AMX 153
+#define TEGRA124_CLK_ADX 154
+/* 155 (bit affects dfll_ref and dfll_soc) */
+#define TEGRA124_CLK_XUSB_SS 156
+/* 157 */
+/* 158 */
+/* 159 */
+
+/* 160 */
+/* 161 */
+/* 162 */
+/* 163 */
+/* 164 */
+/* 165 */
+#define TEGRA124_CLK_I2C6 166
+/* 167 */
+/* 168 */
+/* 169 */
+/* 170 */
+#define TEGRA124_CLK_VIM2_CLK 171
+/* 172 */
+/* 173 */
+/* 174 */
+/* 175 */
+#define TEGRA124_CLK_HDMI_AUDIO 176
+#define TEGRA124_CLK_CLK72MHZ 177
+#define TEGRA124_CLK_VIC03 178
+/* 179 */
+#define TEGRA124_CLK_ADX1 180
+#define TEGRA124_CLK_DPAUX 181
+#define TEGRA124_CLK_SOR0 182
+/* 183 */
+#define TEGRA124_CLK_GPU 184
+#define TEGRA124_CLK_AMX1 185
+/* 186 */
+/* 187 */
+/* 188 */
+/* 189 */
+/* 190 */
+/* 191 */
+
+#define TEGRA124_CLK_UARTB 192
+#define TEGRA124_CLK_VFIR 193
+#define TEGRA124_CLK_SPDIF_IN 194
+#define TEGRA124_CLK_SPDIF_OUT 195
+#define TEGRA124_CLK_VI 196
+#define TEGRA124_CLK_VI_SENSOR 197
+#define TEGRA124_CLK_FUSE 198
+#define TEGRA124_CLK_FUSE_BURN 199
+#define TEGRA124_CLK_CLK_32K 200
+#define TEGRA124_CLK_CLK_M 201
+#define TEGRA124_CLK_CLK_M_DIV2 202
+#define TEGRA124_CLK_CLK_M_DIV4 203
+#define TEGRA124_CLK_PLL_REF 204
+#define TEGRA124_CLK_PLL_C 205
+#define TEGRA124_CLK_PLL_C_OUT1 206
+#define TEGRA124_CLK_PLL_C2 207
+#define TEGRA124_CLK_PLL_C3 208
+#define TEGRA124_CLK_PLL_M 209
+#define TEGRA124_CLK_PLL_M_OUT1 210
+#define TEGRA124_CLK_PLL_P 211
+#define TEGRA124_CLK_PLL_P_OUT1 212
+#define TEGRA124_CLK_PLL_P_OUT2 213
+#define TEGRA124_CLK_PLL_P_OUT3 214
+#define TEGRA124_CLK_PLL_P_OUT4 215
+#define TEGRA124_CLK_PLL_A 216
+#define TEGRA124_CLK_PLL_A_OUT0 217
+#define TEGRA124_CLK_PLL_D 218
+#define TEGRA124_CLK_PLL_D_OUT0 219
+#define TEGRA124_CLK_PLL_D2 220
+#define TEGRA124_CLK_PLL_D2_OUT0 221
+#define TEGRA124_CLK_PLL_U 222
+#define TEGRA124_CLK_PLL_U_480M 223
+
+#define TEGRA124_CLK_PLL_U_60M 224
+#define TEGRA124_CLK_PLL_U_48M 225
+#define TEGRA124_CLK_PLL_U_12M 226
+#define TEGRA124_CLK_PLL_X 227
+#define TEGRA124_CLK_PLL_X_OUT0 228
+#define TEGRA124_CLK_PLL_RE_VCO 229
+#define TEGRA124_CLK_PLL_RE_OUT 230
+#define TEGRA124_CLK_PLL_E 231
+#define TEGRA124_CLK_SPDIF_IN_SYNC 232
+#define TEGRA124_CLK_I2S0_SYNC 233
+#define TEGRA124_CLK_I2S1_SYNC 234
+#define TEGRA124_CLK_I2S2_SYNC 235
+#define TEGRA124_CLK_I2S3_SYNC 236
+#define TEGRA124_CLK_I2S4_SYNC 237
+#define TEGRA124_CLK_VIMCLK_SYNC 238
+#define TEGRA124_CLK_AUDIO0 239
+#define TEGRA124_CLK_AUDIO1 240
+#define TEGRA124_CLK_AUDIO2 241
+#define TEGRA124_CLK_AUDIO3 242
+#define TEGRA124_CLK_AUDIO4 243
+#define TEGRA124_CLK_SPDIF 244
+#define TEGRA124_CLK_CLK_OUT_1 245
+#define TEGRA124_CLK_CLK_OUT_2 246
+#define TEGRA124_CLK_CLK_OUT_3 247
+#define TEGRA124_CLK_BLINK 248
+/* 249 */
+/* 250 */
+/* 251 */
+#define TEGRA124_CLK_XUSB_HOST_SRC 252
+#define TEGRA124_CLK_XUSB_FALCON_SRC 253
+#define TEGRA124_CLK_XUSB_FS_SRC 254
+#define TEGRA124_CLK_XUSB_SS_SRC 255
+
+#define TEGRA124_CLK_XUSB_DEV_SRC 256
+#define TEGRA124_CLK_XUSB_DEV 257
+#define TEGRA124_CLK_XUSB_HS_SRC 258
+#define TEGRA124_CLK_SCLK 259
+#define TEGRA124_CLK_HCLK 260
+#define TEGRA124_CLK_PCLK 261
+#define TEGRA124_CLK_CCLK_G 262
+#define TEGRA124_CLK_CCLK_LP 263
+#define TEGRA124_CLK_DFLL_REF 264
+#define TEGRA124_CLK_DFLL_SOC 265
+#define TEGRA124_CLK_VI_SENSOR2 266
+#define TEGRA124_CLK_PLL_P_OUT5 267
+#define TEGRA124_CLK_CML0 268
+#define TEGRA124_CLK_CML1 269
+#define TEGRA124_CLK_PLL_C4 270
+#define TEGRA124_CLK_PLL_DP 271
+#define TEGRA124_CLK_PLL_E_MUX 272
+/* 273 */
+/* 274 */
+/* 275 */
+/* 276 */
+/* 277 */
+/* 278 */
+/* 279 */
+/* 280 */
+/* 281 */
+/* 282 */
+/* 283 */
+/* 284 */
+/* 285 */
+/* 286 */
+/* 287 */
+
+/* 288 */
+/* 289 */
+/* 290 */
+/* 291 */
+/* 292 */
+/* 293 */
+/* 294 */
+/* 295 */
+/* 296 */
+/* 297 */
+/* 298 */
+/* 299 */
+#define TEGRA124_CLK_AUDIO0_MUX 300
+#define TEGRA124_CLK_AUDIO1_MUX 301
+#define TEGRA124_CLK_AUDIO2_MUX 302
+#define TEGRA124_CLK_AUDIO3_MUX 303
+#define TEGRA124_CLK_AUDIO4_MUX 304
+#define TEGRA124_CLK_SPDIF_MUX 305
+#define TEGRA124_CLK_CLK_OUT_1_MUX 306
+#define TEGRA124_CLK_CLK_OUT_2_MUX 307
+#define TEGRA124_CLK_CLK_OUT_3_MUX 308
+#define TEGRA124_CLK_DSIA_MUX 309
+#define TEGRA124_CLK_DSIB_MUX 310
+#define TEGRA124_CLK_CLK_MAX 311
+
+#endif	/* _DT_BINDINGS_CLOCK_TEGRA124_CAR_H */
-- 
1.7.7.rc0.72.g4b5ea.dirty

