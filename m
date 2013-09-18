Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab3IROwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 10:52:35 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:5968 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab3IROwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 10:52:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 18 Sep 2013 07:52:33 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Joseph Lo <josephl@nvidia.com>, Paul Walmsley <pwalmsley@nvidia.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH 07/12] clk: tegra: move audio clk to common file
Date: Wed, 18 Sep 2013 17:40:59 +0300
Message-ID: <1379515331-19427-8-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1379515331-19427-1-git-send-email-pdeschrijver@nvidia.com>
References: <1379515331-19427-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move audio clocks and PLLA initialization to a common file so it can be used by
multiple Tegra SoCs.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/Makefile          |    1 +
 drivers/clk/tegra/clk-tegra-audio.c |  260 +++++++++++++++++++++++++++++++++++
 drivers/clk/tegra/clk-tegra114.c    |  254 +----------------------------------
 drivers/clk/tegra/clk.h             |    4 +
 4 files changed, 266 insertions(+), 253 deletions(-)
 create mode 100644 drivers/clk/tegra/clk-tegra-audio.c

diff --git a/drivers/clk/tegra/Makefile b/drivers/clk/tegra/Makefile
index f49fac2..796ff9a 100644
--- a/drivers/clk/tegra/Makefile
+++ b/drivers/clk/tegra/Makefile
@@ -6,6 +6,7 @@ obj-y					+= clk-periph-gate.o
 obj-y					+= clk-pll.o
 obj-y					+= clk-pll-out.o
 obj-y					+= clk-super.o
+obj-y					+= clk-tegra-audio.o
 
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += clk-tegra20.o
 obj-$(CONFIG_ARCH_TEGRA_3x_SOC)         += clk-tegra30.o
diff --git a/drivers/clk/tegra/clk-tegra-audio.c b/drivers/clk/tegra/clk-tegra-audio.c
new file mode 100644
index 0000000..b34e385
--- /dev/null
+++ b/drivers/clk/tegra/clk-tegra-audio.c
@@ -0,0 +1,260 @@
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
+
+#include "clk.h"
+#include "clk-id.h"
+
+#define AUDIO_SYNC_CLK_I2S0 0x4a0
+#define AUDIO_SYNC_CLK_I2S1 0x4a4
+#define AUDIO_SYNC_CLK_I2S2 0x4a8
+#define AUDIO_SYNC_CLK_I2S3 0x4ac
+#define AUDIO_SYNC_CLK_I2S4 0x4b0
+#define AUDIO_SYNC_CLK_SPDIF 0x4b4
+
+#define AUDIO_SYNC_DOUBLER 0x49c
+
+#define PLLA_BASE 0xb0
+#define PLLA_MISC 0xbc
+#define PLLA_OUT 0xb4
+
+#define PLL_BASE_LOCK BIT(27)
+#define PLL_MISC_LOCK_ENABLE 18
+
+struct tegra_sync_source_initdata {
+	char		*name;
+	unsigned long	rate;
+	unsigned long	max_rate;
+	int		clk_id;
+};
+
+struct tegra_audio_clk_initdata {
+	char		*gate_name;
+	char		*mux_name;
+	u32		offset;
+	int		gate_clk_id;
+	int		mux_clk_id;
+};
+
+#define AUDIO(_name, _offset) \
+	{\
+		.gate_name	= #_name,\
+		.mux_name	= #_name"_mux",\
+		.offset		= _offset,\
+		.gate_clk_id	= tegra_clk_ ## _name,\
+		.mux_clk_id	= tegra_clk_ ## _name ## _mux,\
+	}
+
+struct tegra_audio2x_clk_initdata {
+	char		*parent;
+	char		*gate_name;
+	char		*name_2x;
+	char		*div_name;
+	int		clk_id;
+	int		clk_num;
+	u8		div_offset;
+};
+
+#define AUDIO2X(_name, _num, _offset) \
+	{\
+		.parent		= #_name,\
+		.gate_name	= #_name"_2x",\
+		.name_2x	= #_name"_doubler",\
+		.div_name	= #_name"_div",\
+		.clk_id		= tegra_clk_ ## _name ## _2x,\
+		.clk_num	= _num,\
+	}
+
+static DEFINE_SPINLOCK(clk_doubler_lock);
+
+static const char *mux_audio_sync_clk[] = { "spdif_in_sync", "i2s0_sync",
+	"i2s1_sync", "i2s2_sync", "i2s3_sync", "i2s4_sync", "vimclk_sync",
+};
+
+static struct tegra_sync_source_initdata __initdata sync_source_clks[] = {
+	{ .name = "spdif_in_sync", .rate = 24000000, .max_rate = 24000000, .clk_id = tegra_clk_spdif_in_sync},
+	{ .name = "i2s0_sync", .rate = 24000000, .max_rate = 24000000, .clk_id = tegra_clk_i2s0_sync},
+	{ .name = "i2s1_sync", .rate = 24000000, .max_rate = 24000000, .clk_id = tegra_clk_i2s1_sync},
+	{ .name = "i2s2_sync", .rate = 24000000, .max_rate = 24000000, .clk_id = tegra_clk_i2s2_sync},
+	{ .name = "i2s3_sync", .rate = 24000000, .max_rate = 24000000, .clk_id = tegra_clk_i2s3_sync},
+	{ .name = "i2s4_sync", .rate = 24000000, .max_rate = 24000000, .clk_id = tegra_clk_i2s4_sync},
+	{ .name = "vimclk_sync", .rate = 24000000, .max_rate = 24000000, .clk_id = tegra_clk_vimclk_sync},
+};
+
+static struct tegra_audio_clk_initdata audio_clks[] = {
+	AUDIO(audio0, AUDIO_SYNC_CLK_I2S0),
+	AUDIO(audio1, AUDIO_SYNC_CLK_I2S1),
+	AUDIO(audio2, AUDIO_SYNC_CLK_I2S2),
+	AUDIO(audio3, AUDIO_SYNC_CLK_I2S3),
+	AUDIO(audio4, AUDIO_SYNC_CLK_I2S4),
+	AUDIO(spdif, AUDIO_SYNC_CLK_SPDIF),
+};
+
+static struct tegra_audio2x_clk_initdata audio2x_clks[] = {
+	AUDIO2X(audio0, 113, 24),
+	AUDIO2X(audio1, 114, 25),
+	AUDIO2X(audio2, 115, 26),
+	AUDIO2X(audio3, 116, 27),
+	AUDIO2X(audio4, 117, 28),
+	AUDIO2X(spdif, 118, 29),
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
+static struct tegra_clk_pll_freq_table pll_a_freq_table[] = {
+	{9600000, 282240000, 147, 5, 0, 4},
+	{9600000, 368640000, 192, 5, 0, 4},
+	{9600000, 240000000, 200, 8, 0, 8},
+
+	{28800000, 282240000, 245, 25, 0, 8},
+	{28800000, 368640000, 320, 25, 0, 8},
+	{28800000, 240000000, 200, 24, 0, 8},
+	{0, 0, 0, 0, 0, 0},
+};
+
+static struct tegra_clk_pll_params pll_a_params = {
+	.input_min = 2000000,
+	.input_max = 31000000,
+	.cf_min = 1000000,
+	.cf_max = 6000000,
+	.vco_min = 200000000,
+	.vco_max = 700000000,
+	.base_reg = PLLA_BASE,
+	.misc_reg = PLLA_MISC,
+	.lock_mask = PLL_BASE_LOCK,
+	.lock_enable_bit_idx = PLL_MISC_LOCK_ENABLE,
+	.lock_delay = 300,
+	.div_nmp = &pllp_nmp,
+};
+
+void __init tegra_audio_clk_init(void __iomem *clk_base,
+			void __iomem *pmc_base, struct tegra_clk *tegra_clks,
+			struct tegra_clk_pll_freq_table *freq_table)
+{
+	struct clk *clk;
+	struct clk **dt_clk;
+	int i;
+
+	if (!freq_table)
+		freq_table = pll_a_freq_table;
+
+	/* PLLA */
+	dt_clk = tegra_lookup_dt_id(tegra_clk_pll_a, tegra_clks);
+	if (dt_clk) {
+		clk = tegra_clk_register_pll("pll_a", "pll_p_out1", clk_base,
+				pmc_base, 0, 0, &pll_a_params,
+				TEGRA_PLL_HAS_CPCON | TEGRA_PLL_USE_LOCK,
+				freq_table, NULL);
+		clk_register_clkdev(clk, "pll_a", NULL);
+		*dt_clk = clk;
+	}
+
+	/* PLLA_OUT0 */
+	dt_clk = tegra_lookup_dt_id(tegra_clk_pll_a_out0, tegra_clks);
+	if (dt_clk) {
+		clk = tegra_clk_register_divider("pll_a_out0_div", "pll_a",
+				clk_base + PLLA_OUT, 0, TEGRA_DIVIDER_ROUND_UP,
+				8, 8, 1, NULL);
+		clk = tegra_clk_register_pll_out("pll_a_out0", "pll_a_out0_div",
+				clk_base + PLLA_OUT, 1, 0, CLK_IGNORE_UNUSED |
+				CLK_SET_RATE_PARENT, 0, NULL);
+		clk_register_clkdev(clk, "pll_a_out0", NULL);
+		*dt_clk = clk;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(sync_source_clks); i++) {
+		struct tegra_sync_source_initdata *data;
+
+		data = &sync_source_clks[i];
+
+		dt_clk = tegra_lookup_dt_id(data->clk_id, tegra_clks);
+		if (!dt_clk)
+			continue;
+
+		clk = tegra_clk_register_sync_source(data->name,
+					data->rate, data->max_rate);
+		*dt_clk = clk;
+		clk_register_clkdev(clk, data->name, NULL);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(audio_clks); i++) {
+		struct tegra_audio_clk_initdata *data;
+
+		data = &audio_clks[i];
+		dt_clk = tegra_lookup_dt_id(data->mux_clk_id, tegra_clks);
+
+		if (!dt_clk)
+			continue;
+		clk = clk_register_mux(NULL, data->mux_name, mux_audio_sync_clk,
+					ARRAY_SIZE(mux_audio_sync_clk), 0,
+					clk_base + data->offset, 0, 3, 0,
+					NULL);
+		*dt_clk = clk;
+
+		dt_clk = tegra_lookup_dt_id(data->gate_clk_id, tegra_clks);
+		if (!dt_clk)
+			continue;
+
+		clk = clk_register_gate(NULL, data->gate_name, data->mux_name,
+					0, clk_base + data->offset, 4,
+					CLK_GATE_SET_TO_DISABLE, NULL);
+		clk_register_clkdev(clk, data->gate_name, NULL);
+		*dt_clk = clk;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(audio2x_clks); i++) {
+		struct tegra_audio2x_clk_initdata *data;
+		struct tegra_clk_periph_regs *bank;
+
+		data = &audio2x_clks[i];
+		dt_clk = tegra_lookup_dt_id(data->clk_id, tegra_clks);
+		if (!dt_clk)
+			continue;
+
+		bank = get_reg_bank(data->clk_num);
+		if (!bank)
+			continue;
+
+		clk = clk_register_fixed_factor(NULL, data->name_2x,
+				data->parent, CLK_SET_RATE_PARENT, 2, 1);
+		clk = tegra_clk_register_divider(data->div_name,
+				data->name_2x, clk_base + AUDIO_SYNC_DOUBLER,
+				0, 0, data->div_offset, 1, 0,
+				&clk_doubler_lock);
+		clk = tegra_clk_register_periph_gate(data->gate_name,
+				data->div_name, TEGRA_PERIPH_NO_RESET,
+				clk_base, CLK_SET_RATE_PARENT, data->clk_num,
+				bank, periph_clk_enb_refcnt);
+		*dt_clk = clk;
+	}
+}
+
diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index 90ae909..02bfd4f 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -79,8 +79,6 @@
 #define PLLD2_MISC 0x4bc
 #define PLLE_BASE 0xe8
 #define PLLE_MISC 0xec
-#define PLLA_BASE 0xb0
-#define PLLA_MISC 0xbc
 #define PLLU_BASE 0xc0
 #define PLLU_MISC 0xcc
 #define PLLRE_BASE 0x4c4
@@ -106,16 +104,6 @@
 #define PLLM_OUT 0x94
 #define PLLP_OUTA 0xa4
 #define PLLP_OUTB 0xa8
-#define PLLA_OUT 0xb4
-
-#define AUDIO_SYNC_CLK_I2S0 0x4a0
-#define AUDIO_SYNC_CLK_I2S1 0x4a4
-#define AUDIO_SYNC_CLK_I2S2 0x4a8
-#define AUDIO_SYNC_CLK_I2S3 0x4ac
-#define AUDIO_SYNC_CLK_I2S4 0x4b0
-#define AUDIO_SYNC_CLK_SPDIF 0x4b4
-
-#define AUDIO_SYNC_DOUBLER 0x49c
 
 #define PMC_CLK_OUT_CNTRL 0x1a8
 #define PMC_DPD_PADS_ORIDE 0x1c
@@ -271,7 +259,6 @@ static DEFINE_SPINLOCK(pll_d2_lock);
 static DEFINE_SPINLOCK(pll_u_lock);
 static DEFINE_SPINLOCK(pll_div_lock);
 static DEFINE_SPINLOCK(pll_re_lock);
-static DEFINE_SPINLOCK(clk_doubler_lock);
 static DEFINE_SPINLOCK(clk_out_lock);
 static DEFINE_SPINLOCK(sysrate_lock);
 
@@ -481,33 +468,6 @@ static struct tegra_clk_pll_params pll_p_params = {
 	.div_nmp = &pllp_nmp,
 };
 
-static struct tegra_clk_pll_freq_table pll_a_freq_table[] = {
-	{9600000, 282240000, 147, 5, 0, 4},
-	{9600000, 368640000, 192, 5, 0, 4},
-	{9600000, 240000000, 200, 8, 0, 8},
-
-	{28800000, 282240000, 245, 25, 0, 8},
-	{28800000, 368640000, 320, 25, 0, 8},
-	{28800000, 240000000, 200, 24, 0, 8},
-	{0, 0, 0, 0, 0, 0},
-};
-
-
-static struct tegra_clk_pll_params pll_a_params = {
-	.input_min = 2000000,
-	.input_max = 31000000,
-	.cf_min = 1000000,
-	.cf_max = 6000000,
-	.vco_min = 200000000,
-	.vco_max = 700000000,
-	.base_reg = PLLA_BASE,
-	.misc_reg = PLLA_MISC,
-	.lock_mask = PLL_BASE_LOCK,
-	.lock_enable_bit_idx = PLL_MISC_LOCK_ENABLE,
-	.lock_delay = 300,
-	.div_nmp = &pllp_nmp,
-};
-
 static struct tegra_clk_pll_freq_table pll_d_freq_table[] = {
 	{12000000, 216000000, 864, 12, 2, 12},
 	{13000000, 216000000, 864, 13, 2, 12},
@@ -1449,23 +1409,6 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 	clk_register_clkdev(clk, "pll_d2_out0", NULL);
 	clks[TEGRA114_CLK_PLL_D2_OUT0] = clk;
 
-	/* PLLA */
-	clk = tegra_clk_register_pll("pll_a", "pll_p_out1", clk_base, pmc, 0,
-			    0, &pll_a_params, TEGRA_PLL_HAS_CPCON |
-			    TEGRA_PLL_USE_LOCK, pll_a_freq_table, NULL);
-	clk_register_clkdev(clk, "pll_a", NULL);
-	clks[TEGRA114_CLK_PLL_A] = clk;
-
-	/* PLLA_OUT0 */
-	clk = tegra_clk_register_divider("pll_a_out0_div", "pll_a",
-				clk_base + PLLA_OUT, 0, TEGRA_DIVIDER_ROUND_UP,
-				8, 8, 1, NULL);
-	clk = tegra_clk_register_pll_out("pll_a_out0", "pll_a_out0_div",
-				clk_base + PLLA_OUT, 1, 0, CLK_IGNORE_UNUSED |
-				CLK_SET_RATE_PARENT, 0, NULL);
-	clk_register_clkdev(clk, "pll_a_out0", NULL);
-	clks[TEGRA114_CLK_PLL_A_OUT0] = clk;
-
 	/* PLLRE */
 	clk = tegra_clk_register_pllre("pll_re_vco", "pll_ref", clk_base, pmc,
 			     0, 0, &pll_re_vco_params, TEGRA_PLL_USE_LOCK,
@@ -1487,10 +1430,6 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 	clks[TEGRA114_CLK_PLL_E_OUT0] = clk;
 }
 
-static const char *mux_audio_sync_clk[] = { "spdif_in_sync", "i2s0_sync",
-	"i2s1_sync", "i2s2_sync", "i2s3_sync", "i2s4_sync", "vimclk_sync",
-};
-
 static const char *clk_out1_parents[] = { "clk_m", "clk_m_div2",
 	"clk_m_div4", "extern1",
 };
@@ -1517,197 +1456,6 @@ static struct clk * __init tegra114_periph_gate_helper(const char *name,
 			clk_base, flags, clk_num, bank, enable_refcnt);
 }
 
-static void __init tegra114_audio_clk_init(void __iomem *clk_base)
-{
-	struct clk *clk;
-
-	/* spdif_in_sync */
-	clk = tegra_clk_register_sync_source("spdif_in_sync", 24000000,
-					     24000000);
-	clk_register_clkdev(clk, "spdif_in_sync", NULL);
-	clks[TEGRA114_CLK_SPDIF_IN_SYNC] = clk;
-
-	/* i2s0_sync */
-	clk = tegra_clk_register_sync_source("i2s0_sync", 24000000, 24000000);
-	clk_register_clkdev(clk, "i2s0_sync", NULL);
-	clks[TEGRA114_CLK_I2S0_SYNC] = clk;
-
-	/* i2s1_sync */
-	clk = tegra_clk_register_sync_source("i2s1_sync", 24000000, 24000000);
-	clk_register_clkdev(clk, "i2s1_sync", NULL);
-	clks[TEGRA114_CLK_I2S1_SYNC] = clk;
-
-	/* i2s2_sync */
-	clk = tegra_clk_register_sync_source("i2s2_sync", 24000000, 24000000);
-	clk_register_clkdev(clk, "i2s2_sync", NULL);
-	clks[TEGRA114_CLK_I2S2_SYNC] = clk;
-
-	/* i2s3_sync */
-	clk = tegra_clk_register_sync_source("i2s3_sync", 24000000, 24000000);
-	clk_register_clkdev(clk, "i2s3_sync", NULL);
-	clks[TEGRA114_CLK_I2S3_SYNC] = clk;
-
-	/* i2s4_sync */
-	clk = tegra_clk_register_sync_source("i2s4_sync", 24000000, 24000000);
-	clk_register_clkdev(clk, "i2s4_sync", NULL);
-	clks[TEGRA114_CLK_I2S4_SYNC] = clk;
-
-	/* vimclk_sync */
-	clk = tegra_clk_register_sync_source("vimclk_sync", 24000000, 24000000);
-	clk_register_clkdev(clk, "vimclk_sync", NULL);
-	clks[TEGRA114_CLK_VIMCLK_SYNC] = clk;
-
-	/* audio0 */
-	clk = clk_register_mux(NULL, "audio0_mux", mux_audio_sync_clk,
-			       ARRAY_SIZE(mux_audio_sync_clk), 0,
-			       clk_base + AUDIO_SYNC_CLK_I2S0, 0, 3, 0,
-			       NULL);
-	clks[TEGRA114_CLK_AUDIO0_MUX] = clk;
-	clk = clk_register_gate(NULL, "audio0", "audio0_mux", 0,
-				clk_base + AUDIO_SYNC_CLK_I2S0, 4,
-				CLK_GATE_SET_TO_DISABLE, NULL);
-	clk_register_clkdev(clk, "audio0", NULL);
-	clks[TEGRA114_CLK_AUDIO0] = clk;
-
-	/* audio1 */
-	clk = clk_register_mux(NULL, "audio1_mux", mux_audio_sync_clk,
-			       ARRAY_SIZE(mux_audio_sync_clk), 0,
-			       clk_base + AUDIO_SYNC_CLK_I2S1, 0, 3, 0,
-			       NULL);
-	clks[TEGRA114_CLK_AUDIO1_MUX] = clk;
-	clk = clk_register_gate(NULL, "audio1", "audio1_mux", 0,
-				clk_base + AUDIO_SYNC_CLK_I2S1, 4,
-				CLK_GATE_SET_TO_DISABLE, NULL);
-	clk_register_clkdev(clk, "audio1", NULL);
-	clks[TEGRA114_CLK_AUDIO1] = clk;
-
-	/* audio2 */
-	clk = clk_register_mux(NULL, "audio2_mux", mux_audio_sync_clk,
-			       ARRAY_SIZE(mux_audio_sync_clk), 0,
-			       clk_base + AUDIO_SYNC_CLK_I2S2, 0, 3, 0,
-			       NULL);
-	clks[TEGRA114_CLK_AUDIO2_MUX] = clk;
-	clk = clk_register_gate(NULL, "audio2", "audio2_mux", 0,
-				clk_base + AUDIO_SYNC_CLK_I2S2, 4,
-				CLK_GATE_SET_TO_DISABLE, NULL);
-	clk_register_clkdev(clk, "audio2", NULL);
-	clks[TEGRA114_CLK_AUDIO2] = clk;
-
-	/* audio3 */
-	clk = clk_register_mux(NULL, "audio3_mux", mux_audio_sync_clk,
-			       ARRAY_SIZE(mux_audio_sync_clk), 0,
-			       clk_base + AUDIO_SYNC_CLK_I2S3, 0, 3, 0,
-			       NULL);
-	clks[TEGRA114_CLK_AUDIO3_MUX] = clk;
-	clk = clk_register_gate(NULL, "audio3", "audio3_mux", 0,
-				clk_base + AUDIO_SYNC_CLK_I2S3, 4,
-				CLK_GATE_SET_TO_DISABLE, NULL);
-	clk_register_clkdev(clk, "audio3", NULL);
-	clks[TEGRA114_CLK_AUDIO3] = clk;
-
-	/* audio4 */
-	clk = clk_register_mux(NULL, "audio4_mux", mux_audio_sync_clk,
-			       ARRAY_SIZE(mux_audio_sync_clk), 0,
-			       clk_base + AUDIO_SYNC_CLK_I2S4, 0, 3, 0,
-			       NULL);
-	clks[TEGRA114_CLK_AUDIO4_MUX] = clk;
-	clk = clk_register_gate(NULL, "audio4", "audio4_mux", 0,
-				clk_base + AUDIO_SYNC_CLK_I2S4, 4,
-				CLK_GATE_SET_TO_DISABLE, NULL);
-	clk_register_clkdev(clk, "audio4", NULL);
-	clks[TEGRA114_CLK_AUDIO4] = clk;
-
-	/* spdif */
-	clk = clk_register_mux(NULL, "spdif_mux", mux_audio_sync_clk,
-			       ARRAY_SIZE(mux_audio_sync_clk), 0,
-			       clk_base + AUDIO_SYNC_CLK_SPDIF, 0, 3, 0,
-			       NULL);
-	clks[TEGRA114_CLK_SPDIF_MUX] = clk;
-	clk = clk_register_gate(NULL, "spdif", "spdif_mux", 0,
-				clk_base + AUDIO_SYNC_CLK_SPDIF, 4,
-				CLK_GATE_SET_TO_DISABLE, NULL);
-	clk_register_clkdev(clk, "spdif", NULL);
-	clks[TEGRA114_CLK_SPDIF] = clk;
-
-	/* audio0_2x */
-	clk = clk_register_fixed_factor(NULL, "audio0_doubler", "audio0",
-					CLK_SET_RATE_PARENT, 2, 1);
-	clk = tegra_clk_register_divider("audio0_div", "audio0_doubler",
-				clk_base + AUDIO_SYNC_DOUBLER, 0, 0, 24, 1,
-				0, &clk_doubler_lock);
-	clk = tegra114_periph_gate_helper("audio0_2x", "audio0_div",
-				  TEGRA_PERIPH_NO_RESET, clk_base,
-				  CLK_SET_RATE_PARENT, 113,
-				  periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "audio0_2x", NULL);
-	clks[TEGRA114_CLK_AUDIO0_2X] = clk;
-
-	/* audio1_2x */
-	clk = clk_register_fixed_factor(NULL, "audio1_doubler", "audio1",
-					CLK_SET_RATE_PARENT, 2, 1);
-	clk = tegra_clk_register_divider("audio1_div", "audio1_doubler",
-				clk_base + AUDIO_SYNC_DOUBLER, 0, 0, 25, 1,
-				0, &clk_doubler_lock);
-	clk = tegra114_periph_gate_helper("audio1_2x", "audio1_div",
-				  TEGRA_PERIPH_NO_RESET, clk_base,
-				  CLK_SET_RATE_PARENT, 114,
-				  periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "audio1_2x", NULL);
-	clks[TEGRA114_CLK_AUDIO1_2X] = clk;
-
-	/* audio2_2x */
-	clk = clk_register_fixed_factor(NULL, "audio2_doubler", "audio2",
-					CLK_SET_RATE_PARENT, 2, 1);
-	clk = tegra_clk_register_divider("audio2_div", "audio2_doubler",
-				clk_base + AUDIO_SYNC_DOUBLER, 0, 0, 26, 1,
-				0, &clk_doubler_lock);
-	clk = tegra114_periph_gate_helper("audio2_2x", "audio2_div",
-				  TEGRA_PERIPH_NO_RESET, clk_base,
-				  CLK_SET_RATE_PARENT, 115,
-				  periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "audio2_2x", NULL);
-	clks[TEGRA114_CLK_AUDIO2_2X] = clk;
-
-	/* audio3_2x */
-	clk = clk_register_fixed_factor(NULL, "audio3_doubler", "audio3",
-					CLK_SET_RATE_PARENT, 2, 1);
-	clk = tegra_clk_register_divider("audio3_div", "audio3_doubler",
-				clk_base + AUDIO_SYNC_DOUBLER, 0, 0, 27, 1,
-				0, &clk_doubler_lock);
-	clk = tegra114_periph_gate_helper("audio3_2x", "audio3_div",
-				  TEGRA_PERIPH_NO_RESET, clk_base,
-				  CLK_SET_RATE_PARENT, 116,
-				  periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "audio3_2x", NULL);
-	clks[TEGRA114_CLK_AUDIO3_2X] = clk;
-
-	/* audio4_2x */
-	clk = clk_register_fixed_factor(NULL, "audio4_doubler", "audio4",
-					CLK_SET_RATE_PARENT, 2, 1);
-	clk = tegra_clk_register_divider("audio4_div", "audio4_doubler",
-				clk_base + AUDIO_SYNC_DOUBLER, 0, 0, 28, 1,
-				0, &clk_doubler_lock);
-	clk = tegra114_periph_gate_helper("audio4_2x", "audio4_div",
-				  TEGRA_PERIPH_NO_RESET, clk_base,
-				  CLK_SET_RATE_PARENT, 117,
-				  periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "audio4_2x", NULL);
-	clks[TEGRA114_CLK_AUDIO4_2X] = clk;
-
-	/* spdif_2x */
-	clk = clk_register_fixed_factor(NULL, "spdif_doubler", "spdif",
-					CLK_SET_RATE_PARENT, 2, 1);
-	clk = tegra_clk_register_divider("spdif_div", "spdif_doubler",
-				clk_base + AUDIO_SYNC_DOUBLER, 0, 0, 29, 1,
-				0, &clk_doubler_lock);
-	clk = tegra114_periph_gate_helper("spdif_2x", "spdif_div",
-				  TEGRA_PERIPH_NO_RESET, clk_base,
-				  CLK_SET_RATE_PARENT, 118,
-				  periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "spdif_2x", NULL);
-	clks[TEGRA114_CLK_SPDIF_2X] = clk;
-}
-
 static void __init tegra114_pmc_clk_init(void __iomem *pmc_base)
 {
 	struct clk *clk;
@@ -2360,7 +2108,7 @@ static void __init tegra114_clock_init(struct device_node *np)
 	tegra114_fixed_clk_init(clk_base);
 	tegra114_pll_init(clk_base, pmc_base);
 	tegra114_periph_clk_init(clk_base);
-	tegra114_audio_clk_init(clk_base);
+	tegra_audio_clk_init(clk_base, pmc_base, tegra114_clks, NULL);
 	tegra114_pmc_clk_init(pmc_base);
 	tegra114_super_clk_init(clk_base);
 
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index 1244010..9ed9bd6 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -600,6 +600,10 @@ struct clk **tegra_lookup_dt_id(int clk_id, struct tegra_clk *tegra_clk);
 
 void tegra_add_of_provider(struct device_node *np);
 
+void tegra_audio_clk_init(void __iomem *clk_base,
+			void __iomem *pmc_base, struct tegra_clk *tegra_clks,
+			struct tegra_clk_pll_freq_table *freq_table);
+
 void tegra114_clock_tune_cpu_trimmers_high(void);
 void tegra114_clock_tune_cpu_trimmers_low(void);
 void tegra114_clock_tune_cpu_trimmers_init(void);
-- 
1.7.7.rc0.72.g4b5ea.dirty

