Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab3JUN45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 09:56:57 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:5905 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab3JUN4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 09:56:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 21 Oct 2013 06:56:54 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Mark Zhang <markz@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 09/15] clk: tegra: add clkdev registration infra
Date: Mon, 21 Oct 2013 16:53:48 +0300
Message-ID: <1382363634-10870-10-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1382363634-10870-1-git-send-email-pdeschrijver@nvidia.com>
References: <1382363634-10870-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a common infra for registering clkdev. This allows decoupling clk
registration from clkdev registration.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-tegra114.c |  322 +++++++++++++++++++-------------------
 drivers/clk/tegra/clk.c          |    9 +
 drivers/clk/tegra/clk.h          |    7 +
 3 files changed, 179 insertions(+), 159 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index 123e8eb..9082132 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -732,71 +732,71 @@ static unsigned long tegra114_input_freq[] = {
 
 #define MASK(x) (BIT(x) - 1)
 
-#define TEGRA_INIT_DATA_MUX(_name, _con_id, _dev_id, _parents, _offset,	\
+#define TEGRA_INIT_DATA_MUX(_name, _parents, _offset,	\
 			    _clk_num, _gate_flags, _clk_id)	\
-	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
+	TEGRA_INIT_DATA_TABLE(_name, NULL, NULL, _parents, _offset,\
 			30, MASK(2), 0, 0, 8, 1, 0, _clk_num, _gate_flags,\
 			_clk_id, _parents##_idx, 0)
 
-#define TEGRA_INIT_DATA_MUX_FLAGS(_name, _con_id, _dev_id, _parents, _offset,\
+#define TEGRA_INIT_DATA_MUX_FLAGS(_name, _parents, _offset,\
 			    _clk_num, _gate_flags, _clk_id, flags)\
-	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
+	TEGRA_INIT_DATA_TABLE(_name, NULL, NULL, _parents, _offset,\
 			30, MASK(2), 0, 0, 8, 1, 0, _clk_num,	\
 			_gate_flags, _clk_id,	\
 			_parents##_idx, flags)
 
-#define TEGRA_INIT_DATA_MUX8(_name, _con_id, _dev_id, _parents, _offset, \
+#define TEGRA_INIT_DATA_MUX8(_name, _parents, _offset, \
 			     _clk_num, _gate_flags, _clk_id)	\
-	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
+	TEGRA_INIT_DATA_TABLE(_name, NULL, NULL, _parents, _offset,\
 			29, MASK(3), 0, 0, 8, 1, 0, _clk_num,	\
 			_gate_flags, _clk_id,	\
 			_parents##_idx, 0)
 
-#define TEGRA_INIT_DATA_INT_FLAGS(_name, _con_id, _dev_id, _parents, _offset,\
+#define TEGRA_INIT_DATA_INT_FLAGS(_name, _parents, _offset,\
 			    _clk_num, _gate_flags, _clk_id, flags)\
-	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
+	TEGRA_INIT_DATA_TABLE(_name, NULL, NULL, _parents, _offset,\
 			30, MASK(2), 0, 0, 8, 1, TEGRA_DIVIDER_INT, \
 			_clk_num, _gate_flags,	\
 			_clk_id, _parents##_idx, flags)
 
-#define TEGRA_INIT_DATA_INT8(_name, _con_id, _dev_id, _parents, _offset,\
+#define TEGRA_INIT_DATA_INT8(_name, _parents, _offset,\
 			    _clk_num, _gate_flags, _clk_id)	\
-	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
+	TEGRA_INIT_DATA_TABLE(_name, NULL, NULL, _parents, _offset,\
 			29, MASK(3), 0, 0, 8, 1, TEGRA_DIVIDER_INT, \
 			_clk_num, _gate_flags,	\
 			_clk_id, _parents##_idx, 0)
 
-#define TEGRA_INIT_DATA_UART(_name, _con_id, _dev_id, _parents, _offset,\
+#define TEGRA_INIT_DATA_UART(_name, _parents, _offset,\
 			     _clk_num, _clk_id)			\
-	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
+	TEGRA_INIT_DATA_TABLE(_name, NULL, NULL, _parents, _offset,\
 			30, MASK(2), 0, 0, 16, 1, TEGRA_DIVIDER_UART, \
 			_clk_num, 0, _clk_id,	\
 			_parents##_idx, 0)
 
-#define TEGRA_INIT_DATA_I2C(_name, _con_id, _dev_id, _parents, _offset,\
+#define TEGRA_INIT_DATA_I2C(_name, _parents, _offset,\
 			     _clk_num, _clk_id)			\
-	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
+	TEGRA_INIT_DATA_TABLE(_name, NULL, NULL, _parents, _offset,\
 			30, MASK(2), 0, 0, 16, 0, 0, _clk_num,	\
 			0, _clk_id, _parents##_idx, 0)
 
-#define TEGRA_INIT_DATA_NODIV(_name, _con_id, _dev_id, _parents, _offset, \
+#define TEGRA_INIT_DATA_NODIV(_name, _parents, _offset, \
 			      _mux_shift, _mux_mask, _clk_num, \
 			      _gate_flags, _clk_id)			\
-	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
+	TEGRA_INIT_DATA_TABLE(_name, NULL, NULL, _parents, _offset,\
 			_mux_shift, _mux_mask, 0, 0, 0, 0, 0,\
 			_clk_num, _gate_flags,	\
 			_clk_id, _parents##_idx, 0)
 
-#define TEGRA_INIT_DATA_XUSB(_name, _con_id, _dev_id, _parents, _offset, \
+#define TEGRA_INIT_DATA_XUSB(_name, _parents, _offset, \
 			     _clk_num, _gate_flags, _clk_id)	 \
-	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset, \
+	TEGRA_INIT_DATA_TABLE(_name, NULL, NULL, _parents, _offset, \
 			29, MASK(3), 0, 0, 8, 1, TEGRA_DIVIDER_INT, \
 			_clk_num, _gate_flags,	 \
 			_clk_id, _parents##_idx, 0)
 
-#define TEGRA_INIT_DATA_AUDIO(_name, _con_id, _dev_id, _offset,  _clk_num,\
+#define TEGRA_INIT_DATA_AUDIO(_name, _offset,  _clk_num,\
 				 _gate_flags, _clk_id)		\
-	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, mux_d_audio_clk,	\
+	TEGRA_INIT_DATA_TABLE(_name, NULL, NULL, mux_d_audio_clk,	\
 			_offset, 16, 0xE01F, 0, 0, 8, 1, 0, _clk_num, \
 			_gate_flags , _clk_id,	\
 			mux_d_audio_clk_idx, 0)
@@ -964,6 +964,71 @@ static const struct clk_div_table pll_re_div_table[] = {
 	{ .val = 0, .div = 0 },
 };
 
+static struct tegra_devclk devclks[] __initdata = {
+	{ .con_id = "clk_m", .dt_id = TEGRA114_CLK_CLK_M },
+	{ .con_id = "pll_ref", .dt_id = TEGRA114_CLK_PLL_REF },
+	{ .con_id = "clk_32k", .dt_id = TEGRA114_CLK_CLK_32K },
+	{ .con_id = "clk_m_div2", .dt_id = TEGRA114_CLK_CLK_M_DIV2 },
+	{ .con_id = "clk_m_div4", .dt_id = TEGRA114_CLK_CLK_M_DIV4 },
+	{ .con_id = "pll_c", .dt_id = TEGRA114_CLK_PLL_C },
+	{ .con_id = "pll_c_out1", .dt_id = TEGRA114_CLK_PLL_C_OUT1 },
+	{ .con_id = "pll_c2", .dt_id = TEGRA114_CLK_PLL_C2 },
+	{ .con_id = "pll_c3", .dt_id = TEGRA114_CLK_PLL_C3 },
+	{ .con_id = "pll_p", .dt_id = TEGRA114_CLK_PLL_P },
+	{ .con_id = "pll_p_out1", .dt_id = TEGRA114_CLK_PLL_P_OUT1 },
+	{ .con_id = "pll_p_out2", .dt_id = TEGRA114_CLK_PLL_P_OUT2 },
+	{ .con_id = "pll_p_out3", .dt_id = TEGRA114_CLK_PLL_P_OUT3 },
+	{ .con_id = "pll_p_out4", .dt_id = TEGRA114_CLK_PLL_P_OUT4 },
+	{ .con_id = "pll_m", .dt_id = TEGRA114_CLK_PLL_M },
+	{ .con_id = "pll_m_out1", .dt_id = TEGRA114_CLK_PLL_M_OUT1 },
+	{ .con_id = "pll_x", .dt_id = TEGRA114_CLK_PLL_X },
+	{ .con_id = "pll_x_out0", .dt_id = TEGRA114_CLK_PLL_X_OUT0 },
+	{ .con_id = "pll_u", .dt_id = TEGRA114_CLK_PLL_U },
+	{ .con_id = "pll_u_480M", .dt_id = TEGRA114_CLK_PLL_U_480M },
+	{ .con_id = "pll_u_60M", .dt_id = TEGRA114_CLK_PLL_U_60M },
+	{ .con_id = "pll_u_48M", .dt_id = TEGRA114_CLK_PLL_U_48M },
+	{ .con_id = "pll_u_12M", .dt_id = TEGRA114_CLK_PLL_U_12M },
+	{ .con_id = "pll_d", .dt_id = TEGRA114_CLK_PLL_D },
+	{ .con_id = "pll_d_out0", .dt_id = TEGRA114_CLK_PLL_D_OUT0 },
+	{ .con_id = "pll_d2", .dt_id = TEGRA114_CLK_PLL_D2 },
+	{ .con_id = "pll_d2_out0", .dt_id = TEGRA114_CLK_PLL_D2_OUT0 },
+	{ .con_id = "pll_a", .dt_id = TEGRA114_CLK_PLL_A },
+	{ .con_id = "pll_a_out0", .dt_id = TEGRA114_CLK_PLL_A_OUT0 },
+	{ .con_id = "pll_re_vco", .dt_id = TEGRA114_CLK_PLL_RE_VCO },
+	{ .con_id = "pll_re_out", .dt_id = TEGRA114_CLK_PLL_RE_OUT },
+	{ .con_id = "pll_e_out0", .dt_id = TEGRA114_CLK_PLL_E_OUT0 },
+	{ .con_id = "spdif_in_sync", .dt_id = TEGRA114_CLK_SPDIF_IN_SYNC },
+	{ .con_id = "i2s0_sync", .dt_id = TEGRA114_CLK_I2S0_SYNC },
+	{ .con_id = "i2s1_sync", .dt_id = TEGRA114_CLK_I2S1_SYNC },
+	{ .con_id = "i2s2_sync", .dt_id = TEGRA114_CLK_I2S2_SYNC },
+	{ .con_id = "i2s3_sync", .dt_id = TEGRA114_CLK_I2S3_SYNC },
+	{ .con_id = "i2s4_sync", .dt_id = TEGRA114_CLK_I2S4_SYNC },
+	{ .con_id = "vimclk_sync", .dt_id = TEGRA114_CLK_VIMCLK_SYNC },
+	{ .con_id = "audio0", .dt_id = TEGRA114_CLK_AUDIO0 },
+	{ .con_id = "audio1", .dt_id = TEGRA114_CLK_AUDIO1 },
+	{ .con_id = "audio2", .dt_id = TEGRA114_CLK_AUDIO2 },
+	{ .con_id = "audio3", .dt_id = TEGRA114_CLK_AUDIO3 },
+	{ .con_id = "audio4", .dt_id = TEGRA114_CLK_AUDIO4 },
+	{ .con_id = "spdif", .dt_id = TEGRA114_CLK_SPDIF },
+	{ .con_id = "audio0_2x", .dt_id = TEGRA114_CLK_AUDIO0_2X },
+	{ .con_id = "audio1_2x", .dt_id = TEGRA114_CLK_AUDIO1_2X },
+	{ .con_id = "audio2_2x", .dt_id = TEGRA114_CLK_AUDIO2_2X },
+	{ .con_id = "audio3_2x", .dt_id = TEGRA114_CLK_AUDIO3_2X },
+	{ .con_id = "audio4_2x", .dt_id = TEGRA114_CLK_AUDIO4_2X },
+	{ .con_id = "spdif_2x", .dt_id = TEGRA114_CLK_SPDIF_2X },
+	{ .con_id = "extern1", .dev_id = "clk_out_1", .dt_id = TEGRA114_CLK_EXTERN1 },
+	{ .con_id = "extern2", .dev_id = "clk_out_2", .dt_id = TEGRA114_CLK_EXTERN2 },
+	{ .con_id = "extern3", .dev_id = "clk_out_3", .dt_id = TEGRA114_CLK_EXTERN3 },
+	{ .con_id = "blink", .dt_id = TEGRA114_CLK_BLINK },
+	{ .con_id = "cclk_g", .dt_id = TEGRA114_CLK_CCLK_G },
+	{ .con_id = "cclk_lp", .dt_id = TEGRA114_CLK_CCLK_LP },
+	{ .con_id = "sclk", .dt_id = TEGRA114_CLK_SCLK },
+	{ .con_id = "hclk", .dt_id = TEGRA114_CLK_HCLK },
+	{ .con_id = "pclk", .dt_id = TEGRA114_CLK_PCLK },
+	{ .dev_id = "rtc-tegra", .dt_id = TEGRA114_CLK_RTC },
+	{ .dev_id = "timer", .dt_id = TEGRA114_CLK_TIMER },
+};
+
 static struct clk **clks;
 
 static unsigned long osc_freq;
@@ -985,7 +1050,6 @@ static int __init tegra114_osc_clk_init(void __iomem *clk_base)
 	/* clk_m */
 	clk = clk_register_fixed_rate(NULL, "clk_m", NULL, CLK_IS_ROOT,
 				      osc_freq);
-	clk_register_clkdev(clk, "clk_m", NULL);
 	clks[TEGRA114_CLK_CLK_M] = clk;
 
 	/* pll_ref */
@@ -993,7 +1057,6 @@ static int __init tegra114_osc_clk_init(void __iomem *clk_base)
 	pll_ref_div = 1 << val;
 	clk = clk_register_fixed_factor(NULL, "pll_ref", "clk_m",
 					CLK_SET_RATE_PARENT, 1, pll_ref_div);
-	clk_register_clkdev(clk, "pll_ref", NULL);
 	clks[TEGRA114_CLK_PLL_REF] = clk;
 
 	pll_ref_freq = osc_freq / pll_ref_div;
@@ -1008,19 +1071,16 @@ static void __init tegra114_fixed_clk_init(void __iomem *clk_base)
 	/* clk_32k */
 	clk = clk_register_fixed_rate(NULL, "clk_32k", NULL, CLK_IS_ROOT,
 				      32768);
-	clk_register_clkdev(clk, "clk_32k", NULL);
 	clks[TEGRA114_CLK_CLK_32K] = clk;
 
 	/* clk_m_div2 */
 	clk = clk_register_fixed_factor(NULL, "clk_m_div2", "clk_m",
 					CLK_SET_RATE_PARENT, 1, 2);
-	clk_register_clkdev(clk, "clk_m_div2", NULL);
 	clks[TEGRA114_CLK_CLK_M_DIV2] = clk;
 
 	/* clk_m_div4 */
 	clk = clk_register_fixed_factor(NULL, "clk_m_div4", "clk_m",
 					CLK_SET_RATE_PARENT, 1, 4);
-	clk_register_clkdev(clk, "clk_m_div4", NULL);
 	clks[TEGRA114_CLK_CLK_M_DIV4] = clk;
 
 }
@@ -1116,7 +1176,6 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 	/* PLLC */
 	clk = tegra_clk_register_pllxc("pll_c", "pll_ref", clk_base,
 			pmc, 0, &pll_c_params, NULL);
-	clk_register_clkdev(clk, "pll_c", NULL);
 	clks[TEGRA114_CLK_PLL_C] = clk;
 
 	/* PLLC_OUT1 */
@@ -1126,25 +1185,21 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 	clk = tegra_clk_register_pll_out("pll_c_out1", "pll_c_out1_div",
 				clk_base + PLLC_OUT, 1, 0,
 				CLK_SET_RATE_PARENT, 0, NULL);
-	clk_register_clkdev(clk, "pll_c_out1", NULL);
 	clks[TEGRA114_CLK_PLL_C_OUT1] = clk;
 
 	/* PLLC2 */
 	clk = tegra_clk_register_pllc("pll_c2", "pll_ref", clk_base, pmc, 0,
 			     &pll_c2_params, NULL);
-	clk_register_clkdev(clk, "pll_c2", NULL);
 	clks[TEGRA114_CLK_PLL_C2] = clk;
 
 	/* PLLC3 */
 	clk = tegra_clk_register_pllc("pll_c3", "pll_ref", clk_base, pmc, 0,
 			     &pll_c3_params, NULL);
-	clk_register_clkdev(clk, "pll_c3", NULL);
 	clks[TEGRA114_CLK_PLL_C3] = clk;
 
 	/* PLLP */
 	clk = tegra_clk_register_pll("pll_p", "pll_ref", clk_base, pmc, 0,
 			    &pll_p_params, NULL);
-	clk_register_clkdev(clk, "pll_p", NULL);
 	clks[TEGRA114_CLK_PLL_P] = clk;
 
 	/* PLLP_OUT1 */
@@ -1155,7 +1210,6 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 				clk_base + PLLP_OUTA, 1, 0,
 				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
 				&pll_div_lock);
-	clk_register_clkdev(clk, "pll_p_out1", NULL);
 	clks[TEGRA114_CLK_PLL_P_OUT1] = clk;
 
 	/* PLLP_OUT2 */
@@ -1167,7 +1221,6 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 				clk_base + PLLP_OUTA, 17, 16,
 				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
 				&pll_div_lock);
-	clk_register_clkdev(clk, "pll_p_out2", NULL);
 	clks[TEGRA114_CLK_PLL_P_OUT2] = clk;
 
 	/* PLLP_OUT3 */
@@ -1178,7 +1231,6 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 				clk_base + PLLP_OUTB, 1, 0,
 				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
 				&pll_div_lock);
-	clk_register_clkdev(clk, "pll_p_out3", NULL);
 	clks[TEGRA114_CLK_PLL_P_OUT3] = clk;
 
 	/* PLLP_OUT4 */
@@ -1190,14 +1242,12 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 				clk_base + PLLP_OUTB, 17, 16,
 				CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT, 0,
 				&pll_div_lock);
-	clk_register_clkdev(clk, "pll_p_out4", NULL);
 	clks[TEGRA114_CLK_PLL_P_OUT4] = clk;
 
 	/* PLLM */
 	clk = tegra_clk_register_pllm("pll_m", "pll_ref", clk_base, pmc,
 			     CLK_IGNORE_UNUSED | CLK_SET_RATE_GATE,
 			     &pll_m_params, NULL);
-	clk_register_clkdev(clk, "pll_m", NULL);
 	clks[TEGRA114_CLK_PLL_M] = clk;
 
 	/* PLLM_OUT1 */
@@ -1207,7 +1257,6 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 	clk = tegra_clk_register_pll_out("pll_m_out1", "pll_m_out1_div",
 				clk_base + PLLM_OUT, 1, 0, CLK_IGNORE_UNUSED |
 				CLK_SET_RATE_PARENT, 0, NULL);
-	clk_register_clkdev(clk, "pll_m_out1", NULL);
 	clks[TEGRA114_CLK_PLL_M_OUT1] = clk;
 
 	/* PLLM_UD */
@@ -1217,13 +1266,11 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 	/* PLLX */
 	clk = tegra_clk_register_pllxc("pll_x", "pll_ref", clk_base,
 			pmc, CLK_IGNORE_UNUSED, &pll_x_params, NULL);
-	clk_register_clkdev(clk, "pll_x", NULL);
 	clks[TEGRA114_CLK_PLL_X] = clk;
 
 	/* PLLX_OUT0 */
 	clk = clk_register_fixed_factor(NULL, "pll_x_out0", "pll_x",
 					CLK_SET_RATE_PARENT, 1, 2);
-	clk_register_clkdev(clk, "pll_x_out0", NULL);
 	clks[TEGRA114_CLK_PLL_X_OUT0] = clk;
 
 	/* PLLU */
@@ -1233,7 +1280,6 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 
 	clk = tegra_clk_register_pll("pll_u", "pll_ref", clk_base, pmc, 0,
 			    &pll_u_params, &pll_u_lock);
-	clk_register_clkdev(clk, "pll_u", NULL);
 	clks[TEGRA114_CLK_PLL_U] = clk;
 
 	tegra114_utmi_param_configure(clk_base);
@@ -1242,55 +1288,46 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 	clk = clk_register_gate(NULL, "pll_u_480M", "pll_u",
 				CLK_SET_RATE_PARENT, clk_base + PLLU_BASE,
 				22, 0, &pll_u_lock);
-	clk_register_clkdev(clk, "pll_u_480M", NULL);
 	clks[TEGRA114_CLK_PLL_U_480M] = clk;
 
 	/* PLLU_60M */
 	clk = clk_register_fixed_factor(NULL, "pll_u_60M", "pll_u",
 					CLK_SET_RATE_PARENT, 1, 8);
-	clk_register_clkdev(clk, "pll_u_60M", NULL);
 	clks[TEGRA114_CLK_PLL_U_60M] = clk;
 
 	/* PLLU_48M */
 	clk = clk_register_fixed_factor(NULL, "pll_u_48M", "pll_u",
 					CLK_SET_RATE_PARENT, 1, 10);
-	clk_register_clkdev(clk, "pll_u_48M", NULL);
 	clks[TEGRA114_CLK_PLL_U_48M] = clk;
 
 	/* PLLU_12M */
 	clk = clk_register_fixed_factor(NULL, "pll_u_12M", "pll_u",
 					CLK_SET_RATE_PARENT, 1, 40);
-	clk_register_clkdev(clk, "pll_u_12M", NULL);
 	clks[TEGRA114_CLK_PLL_U_12M] = clk;
 
 	/* PLLD */
 	clk = tegra_clk_register_pll("pll_d", "pll_ref", clk_base, pmc, 0,
 			    &pll_d_params, &pll_d_lock);
-	clk_register_clkdev(clk, "pll_d", NULL);
 	clks[TEGRA114_CLK_PLL_D] = clk;
 
 	/* PLLD_OUT0 */
 	clk = clk_register_fixed_factor(NULL, "pll_d_out0", "pll_d",
 					CLK_SET_RATE_PARENT, 1, 2);
-	clk_register_clkdev(clk, "pll_d_out0", NULL);
 	clks[TEGRA114_CLK_PLL_D_OUT0] = clk;
 
 	/* PLLD2 */
 	clk = tegra_clk_register_pll("pll_d2", "pll_ref", clk_base, pmc, 0,
 			    &pll_d2_params, &pll_d2_lock);
-	clk_register_clkdev(clk, "pll_d2", NULL);
 	clks[TEGRA114_CLK_PLL_D2] = clk;
 
 	/* PLLD2_OUT0 */
 	clk = clk_register_fixed_factor(NULL, "pll_d2_out0", "pll_d2",
 					CLK_SET_RATE_PARENT, 1, 2);
-	clk_register_clkdev(clk, "pll_d2_out0", NULL);
 	clks[TEGRA114_CLK_PLL_D2_OUT0] = clk;
 
 	/* PLLA */
 	clk = tegra_clk_register_pll("pll_a", "pll_p_out1", clk_base, pmc, 0,
 			    &pll_a_params, NULL);
-	clk_register_clkdev(clk, "pll_a", NULL);
 	clks[TEGRA114_CLK_PLL_A] = clk;
 
 	/* PLLA_OUT0 */
@@ -1300,25 +1337,21 @@ static void __init tegra114_pll_init(void __iomem *clk_base,
 	clk = tegra_clk_register_pll_out("pll_a_out0", "pll_a_out0_div",
 				clk_base + PLLA_OUT, 1, 0, CLK_IGNORE_UNUSED |
 				CLK_SET_RATE_PARENT, 0, NULL);
-	clk_register_clkdev(clk, "pll_a_out0", NULL);
 	clks[TEGRA114_CLK_PLL_A_OUT0] = clk;
 
 	/* PLLRE */
 	clk = tegra_clk_register_pllre("pll_re_vco", "pll_ref", clk_base, pmc,
 			     0, &pll_re_vco_params, &pll_re_lock, pll_ref_freq);
-	clk_register_clkdev(clk, "pll_re_vco", NULL);
 	clks[TEGRA114_CLK_PLL_RE_VCO] = clk;
 
 	clk = clk_register_divider_table(NULL, "pll_re_out", "pll_re_vco", 0,
 					 clk_base + PLLRE_BASE, 16, 4, 0,
 					 pll_re_div_table, &pll_re_lock);
-	clk_register_clkdev(clk, "pll_re_out", NULL);
 	clks[TEGRA114_CLK_PLL_RE_OUT] = clk;
 
 	/* PLLE */
 	clk = tegra_clk_register_plle_tegra114("pll_e_out0", "pll_re_vco",
 				      clk_base, 0, &pll_e_params, NULL);
-	clk_register_clkdev(clk, "pll_e_out0", NULL);
 	clks[TEGRA114_CLK_PLL_E_OUT0] = clk;
 }
 
@@ -1345,37 +1378,30 @@ static void __init tegra114_audio_clk_init(void __iomem *clk_base)
 	/* spdif_in_sync */
 	clk = tegra_clk_register_sync_source("spdif_in_sync", 24000000,
 					     24000000);
-	clk_register_clkdev(clk, "spdif_in_sync", NULL);
 	clks[TEGRA114_CLK_SPDIF_IN_SYNC] = clk;
 
 	/* i2s0_sync */
 	clk = tegra_clk_register_sync_source("i2s0_sync", 24000000, 24000000);
-	clk_register_clkdev(clk, "i2s0_sync", NULL);
 	clks[TEGRA114_CLK_I2S0_SYNC] = clk;
 
 	/* i2s1_sync */
 	clk = tegra_clk_register_sync_source("i2s1_sync", 24000000, 24000000);
-	clk_register_clkdev(clk, "i2s1_sync", NULL);
 	clks[TEGRA114_CLK_I2S1_SYNC] = clk;
 
 	/* i2s2_sync */
 	clk = tegra_clk_register_sync_source("i2s2_sync", 24000000, 24000000);
-	clk_register_clkdev(clk, "i2s2_sync", NULL);
 	clks[TEGRA114_CLK_I2S2_SYNC] = clk;
 
 	/* i2s3_sync */
 	clk = tegra_clk_register_sync_source("i2s3_sync", 24000000, 24000000);
-	clk_register_clkdev(clk, "i2s3_sync", NULL);
 	clks[TEGRA114_CLK_I2S3_SYNC] = clk;
 
 	/* i2s4_sync */
 	clk = tegra_clk_register_sync_source("i2s4_sync", 24000000, 24000000);
-	clk_register_clkdev(clk, "i2s4_sync", NULL);
 	clks[TEGRA114_CLK_I2S4_SYNC] = clk;
 
 	/* vimclk_sync */
 	clk = tegra_clk_register_sync_source("vimclk_sync", 24000000, 24000000);
-	clk_register_clkdev(clk, "vimclk_sync", NULL);
 	clks[TEGRA114_CLK_VIMCLK_SYNC] = clk;
 
 	/* audio0 */
@@ -1388,7 +1414,6 @@ static void __init tegra114_audio_clk_init(void __iomem *clk_base)
 	clk = clk_register_gate(NULL, "audio0", "audio0_mux", 0,
 				clk_base + AUDIO_SYNC_CLK_I2S0, 4,
 				CLK_GATE_SET_TO_DISABLE, NULL);
-	clk_register_clkdev(clk, "audio0", NULL);
 	clks[TEGRA114_CLK_AUDIO0] = clk;
 
 	/* audio1 */
@@ -1401,7 +1426,6 @@ static void __init tegra114_audio_clk_init(void __iomem *clk_base)
 	clk = clk_register_gate(NULL, "audio1", "audio1_mux", 0,
 				clk_base + AUDIO_SYNC_CLK_I2S1, 4,
 				CLK_GATE_SET_TO_DISABLE, NULL);
-	clk_register_clkdev(clk, "audio1", NULL);
 	clks[TEGRA114_CLK_AUDIO1] = clk;
 
 	/* audio2 */
@@ -1414,7 +1438,6 @@ static void __init tegra114_audio_clk_init(void __iomem *clk_base)
 	clk = clk_register_gate(NULL, "audio2", "audio2_mux", 0,
 				clk_base + AUDIO_SYNC_CLK_I2S2, 4,
 				CLK_GATE_SET_TO_DISABLE, NULL);
-	clk_register_clkdev(clk, "audio2", NULL);
 	clks[TEGRA114_CLK_AUDIO2] = clk;
 
 	/* audio3 */
@@ -1427,7 +1450,6 @@ static void __init tegra114_audio_clk_init(void __iomem *clk_base)
 	clk = clk_register_gate(NULL, "audio3", "audio3_mux", 0,
 				clk_base + AUDIO_SYNC_CLK_I2S3, 4,
 				CLK_GATE_SET_TO_DISABLE, NULL);
-	clk_register_clkdev(clk, "audio3", NULL);
 	clks[TEGRA114_CLK_AUDIO3] = clk;
 
 	/* audio4 */
@@ -1440,7 +1462,6 @@ static void __init tegra114_audio_clk_init(void __iomem *clk_base)
 	clk = clk_register_gate(NULL, "audio4", "audio4_mux", 0,
 				clk_base + AUDIO_SYNC_CLK_I2S4, 4,
 				CLK_GATE_SET_TO_DISABLE, NULL);
-	clk_register_clkdev(clk, "audio4", NULL);
 	clks[TEGRA114_CLK_AUDIO4] = clk;
 
 	/* spdif */
@@ -1453,7 +1474,6 @@ static void __init tegra114_audio_clk_init(void __iomem *clk_base)
 	clk = clk_register_gate(NULL, "spdif", "spdif_mux", 0,
 				clk_base + AUDIO_SYNC_CLK_SPDIF, 4,
 				CLK_GATE_SET_TO_DISABLE, NULL);
-	clk_register_clkdev(clk, "spdif", NULL);
 	clks[TEGRA114_CLK_SPDIF] = clk;
 
 	/* audio0_2x */
@@ -1466,7 +1486,6 @@ static void __init tegra114_audio_clk_init(void __iomem *clk_base)
 				  TEGRA_PERIPH_NO_RESET, clk_base,
 				  CLK_SET_RATE_PARENT, 113,
 				  periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "audio0_2x", NULL);
 	clks[TEGRA114_CLK_AUDIO0_2X] = clk;
 
 	/* audio1_2x */
@@ -1479,7 +1498,6 @@ static void __init tegra114_audio_clk_init(void __iomem *clk_base)
 				  TEGRA_PERIPH_NO_RESET, clk_base,
 				  CLK_SET_RATE_PARENT, 114,
 				  periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "audio1_2x", NULL);
 	clks[TEGRA114_CLK_AUDIO1_2X] = clk;
 
 	/* audio2_2x */
@@ -1492,7 +1510,6 @@ static void __init tegra114_audio_clk_init(void __iomem *clk_base)
 				  TEGRA_PERIPH_NO_RESET, clk_base,
 				  CLK_SET_RATE_PARENT, 115,
 				  periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "audio2_2x", NULL);
 	clks[TEGRA114_CLK_AUDIO2_2X] = clk;
 
 	/* audio3_2x */
@@ -1505,7 +1522,6 @@ static void __init tegra114_audio_clk_init(void __iomem *clk_base)
 				  TEGRA_PERIPH_NO_RESET, clk_base,
 				  CLK_SET_RATE_PARENT, 116,
 				  periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "audio3_2x", NULL);
 	clks[TEGRA114_CLK_AUDIO3_2X] = clk;
 
 	/* audio4_2x */
@@ -1518,7 +1534,6 @@ static void __init tegra114_audio_clk_init(void __iomem *clk_base)
 				  TEGRA_PERIPH_NO_RESET, clk_base,
 				  CLK_SET_RATE_PARENT, 117,
 				  periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "audio4_2x", NULL);
 	clks[TEGRA114_CLK_AUDIO4_2X] = clk;
 
 	/* spdif_2x */
@@ -1531,7 +1546,6 @@ static void __init tegra114_audio_clk_init(void __iomem *clk_base)
 				  TEGRA_PERIPH_NO_RESET, clk_base,
 				  CLK_SET_RATE_PARENT, 118,
 				  periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, "spdif_2x", NULL);
 	clks[TEGRA114_CLK_SPDIF_2X] = clk;
 }
 
@@ -1549,7 +1563,6 @@ static void __init tegra114_pmc_clk_init(void __iomem *pmc_base)
 	clk = clk_register_gate(NULL, "clk_out_1", "clk_out_1_mux", 0,
 				pmc_base + PMC_CLK_OUT_CNTRL, 2, 0,
 				&clk_out_lock);
-	clk_register_clkdev(clk, "extern1", "clk_out_1");
 	clks[TEGRA114_CLK_CLK_OUT_1] = clk;
 
 	/* clk_out_2 */
@@ -1562,7 +1575,6 @@ static void __init tegra114_pmc_clk_init(void __iomem *pmc_base)
 	clk = clk_register_gate(NULL, "clk_out_2", "clk_out_2_mux", 0,
 				pmc_base + PMC_CLK_OUT_CNTRL, 10, 0,
 				&clk_out_lock);
-	clk_register_clkdev(clk, "extern2", "clk_out_2");
 	clks[TEGRA114_CLK_CLK_OUT_2] = clk;
 
 	/* clk_out_3 */
@@ -1575,7 +1587,6 @@ static void __init tegra114_pmc_clk_init(void __iomem *pmc_base)
 	clk = clk_register_gate(NULL, "clk_out_3", "clk_out_3_mux", 0,
 				pmc_base + PMC_CLK_OUT_CNTRL, 18, 0,
 				&clk_out_lock);
-	clk_register_clkdev(clk, "extern3", "clk_out_3");
 	clks[TEGRA114_CLK_CLK_OUT_3] = clk;
 
 	/* blink */
@@ -1587,7 +1598,6 @@ static void __init tegra114_pmc_clk_init(void __iomem *pmc_base)
 	clk = clk_register_gate(NULL, "blink", "blink_override", 0,
 				pmc_base + PMC_CTRL,
 				PMC_CTRL_BLINK_ENB, 0, NULL);
-	clk_register_clkdev(clk, "blink", NULL);
 	clks[TEGRA114_CLK_BLINK] = clk;
 
 }
@@ -1614,7 +1624,6 @@ static void __init tegra114_super_clk_init(void __iomem *clk_base)
 					CLK_SET_RATE_PARENT,
 					clk_base + CCLKG_BURST_POLICY,
 					0, 4, 0, 0, NULL);
-	clk_register_clkdev(clk, "cclk_g", NULL);
 	clks[TEGRA114_CLK_CCLK_G] = clk;
 
 	/* CCLKLP */
@@ -1623,7 +1632,6 @@ static void __init tegra114_super_clk_init(void __iomem *clk_base)
 					CLK_SET_RATE_PARENT,
 					clk_base + CCLKLP_BURST_POLICY,
 					0, 4, 8, 9, NULL);
-	clk_register_clkdev(clk, "cclk_lp", NULL);
 	clks[TEGRA114_CLK_CCLK_LP] = clk;
 
 	/* SCLK */
@@ -1632,7 +1640,6 @@ static void __init tegra114_super_clk_init(void __iomem *clk_base)
 					CLK_SET_RATE_PARENT,
 					clk_base + SCLK_BURST_POLICY,
 					0, 4, 0, 0, NULL);
-	clk_register_clkdev(clk, "sclk", NULL);
 	clks[TEGRA114_CLK_SCLK] = clk;
 
 	/* HCLK */
@@ -1642,7 +1649,6 @@ static void __init tegra114_super_clk_init(void __iomem *clk_base)
 	clk = clk_register_gate(NULL, "hclk", "hclk_div", CLK_SET_RATE_PARENT |
 				CLK_IGNORE_UNUSED, clk_base + SYSTEM_CLK_RATE,
 				7, CLK_GATE_SET_TO_DISABLE, &sysrate_lock);
-	clk_register_clkdev(clk, "hclk", NULL);
 	clks[TEGRA114_CLK_HCLK] = clk;
 
 	/* PCLK */
@@ -1652,91 +1658,90 @@ static void __init tegra114_super_clk_init(void __iomem *clk_base)
 	clk = clk_register_gate(NULL, "pclk", "pclk_div", CLK_SET_RATE_PARENT |
 				CLK_IGNORE_UNUSED, clk_base + SYSTEM_CLK_RATE,
 				3, CLK_GATE_SET_TO_DISABLE, &sysrate_lock);
-	clk_register_clkdev(clk, "pclk", NULL);
 	clks[TEGRA114_CLK_PCLK] = clk;
 }
 
 static struct tegra_periph_init_data tegra_periph_clk_list[] = {
-	TEGRA_INIT_DATA_MUX("i2s0", NULL, "tegra30-i2s.0", mux_pllaout0_audio0_2x_pllp_clkm, CLK_SOURCE_I2S0, 30, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_I2S0),
-	TEGRA_INIT_DATA_MUX("i2s1", NULL, "tegra30-i2s.1", mux_pllaout0_audio1_2x_pllp_clkm, CLK_SOURCE_I2S1, 11, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_I2S1),
-	TEGRA_INIT_DATA_MUX("i2s2", NULL, "tegra30-i2s.2", mux_pllaout0_audio2_2x_pllp_clkm, CLK_SOURCE_I2S2, 18, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_I2S2),
-	TEGRA_INIT_DATA_MUX("i2s3", NULL, "tegra30-i2s.3", mux_pllaout0_audio3_2x_pllp_clkm, CLK_SOURCE_I2S3, 101, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_I2S3),
-	TEGRA_INIT_DATA_MUX("i2s4", NULL, "tegra30-i2s.4", mux_pllaout0_audio4_2x_pllp_clkm, CLK_SOURCE_I2S4, 102, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_I2S4),
-	TEGRA_INIT_DATA_MUX("spdif_out", "spdif_out", "tegra30-spdif", mux_pllaout0_audio_2x_pllp_clkm, CLK_SOURCE_SPDIF_OUT, 10, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SPDIF_OUT),
-	TEGRA_INIT_DATA_MUX("spdif_in", "spdif_in", "tegra30-spdif", mux_pllp_pllc_pllm, CLK_SOURCE_SPDIF_IN, 10, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SPDIF_IN),
-	TEGRA_INIT_DATA_MUX("pwm", NULL, "pwm", mux_pllp_pllc_clk32_clkm, CLK_SOURCE_PWM, 17, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_PWM),
-	TEGRA_INIT_DATA_MUX("adx", NULL, "adx", mux_plla_pllc_pllp_clkm, CLK_SOURCE_ADX, 154, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_ADX),
-	TEGRA_INIT_DATA_MUX("amx", NULL, "amx", mux_plla_pllc_pllp_clkm, CLK_SOURCE_AMX, 153, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_AMX),
-	TEGRA_INIT_DATA_MUX("hda", "hda", "tegra30-hda", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_HDA, 125, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_HDA),
-	TEGRA_INIT_DATA_MUX("hda2codec_2x", "hda2codec", "tegra30-hda", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_HDA2CODEC_2X, 111, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_HDA2CODEC_2X),
-	TEGRA_INIT_DATA_MUX8("sbc1", NULL, "tegra11-spi.0", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SBC1, 41, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC1),
-	TEGRA_INIT_DATA_MUX8("sbc2", NULL, "tegra11-spi.1", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SBC2, 44, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC2),
-	TEGRA_INIT_DATA_MUX8("sbc3", NULL, "tegra11-spi.2", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SBC3, 46, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC3),
-	TEGRA_INIT_DATA_MUX8("sbc4", NULL, "tegra11-spi.3", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SBC4, 68, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC4),
-	TEGRA_INIT_DATA_MUX8("sbc5", NULL, "tegra11-spi.4", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SBC5, 104, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC5),
-	TEGRA_INIT_DATA_MUX8("sbc6", NULL, "tegra11-spi.5", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SBC6, 105, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC6),
-	TEGRA_INIT_DATA_MUX8("ndflash", NULL, "tegra_nand", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_NDFLASH, 13, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_NDSPEED),
-	TEGRA_INIT_DATA_MUX8("ndspeed", NULL, "tegra_nand_speed", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_NDSPEED, 80, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_NDSPEED),
-	TEGRA_INIT_DATA_MUX("vfir", NULL, "vfir", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_VFIR, 7, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_VFIR),
-	TEGRA_INIT_DATA_MUX("sdmmc1", NULL, "sdhci-tegra.0", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC1, 14, 0, TEGRA114_CLK_SDMMC1),
-	TEGRA_INIT_DATA_MUX("sdmmc2", NULL, "sdhci-tegra.1", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC2, 9, 0, TEGRA114_CLK_SDMMC2),
-	TEGRA_INIT_DATA_MUX("sdmmc3", NULL, "sdhci-tegra.2", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC3, 69, 0, TEGRA114_CLK_SDMMC3),
-	TEGRA_INIT_DATA_MUX("sdmmc4", NULL, "sdhci-tegra.3", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC4, 15, 0, TEGRA114_CLK_SDMMC4),
-	TEGRA_INIT_DATA_INT8("vde", NULL, "vde", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_VDE, 61, 0, TEGRA114_CLK_VDE),
-	TEGRA_INIT_DATA_MUX_FLAGS("csite", NULL, "csite", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_CSITE, 73, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_CSITE, CLK_IGNORE_UNUSED),
-	TEGRA_INIT_DATA_MUX("la", NULL, "la", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_LA, 76, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_LA),
-	TEGRA_INIT_DATA_MUX("trace", NULL, "trace", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_TRACE, 77, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_TRACE),
-	TEGRA_INIT_DATA_MUX("owr", NULL, "tegra_w1", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_OWR, 71, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_OWR),
-	TEGRA_INIT_DATA_MUX("nor", NULL, "tegra-nor", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_NOR, 42, 0, TEGRA114_CLK_NOR),
-	TEGRA_INIT_DATA_MUX("mipi", NULL, "mipi", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_MIPI, 50, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_MIPI),
-	TEGRA_INIT_DATA_I2C("i2c1", "div-clk", "tegra11-i2c.0", mux_pllp_clkm, CLK_SOURCE_I2C1, 12, TEGRA114_CLK_I2C1),
-	TEGRA_INIT_DATA_I2C("i2c2", "div-clk", "tegra11-i2c.1", mux_pllp_clkm, CLK_SOURCE_I2C2, 54, TEGRA114_CLK_I2C2),
-	TEGRA_INIT_DATA_I2C("i2c3", "div-clk", "tegra11-i2c.2", mux_pllp_clkm, CLK_SOURCE_I2C3, 67, TEGRA114_CLK_I2C3),
-	TEGRA_INIT_DATA_I2C("i2c4", "div-clk", "tegra11-i2c.3", mux_pllp_clkm, CLK_SOURCE_I2C4, 103, TEGRA114_CLK_I2C4),
-	TEGRA_INIT_DATA_I2C("i2c5", "div-clk", "tegra11-i2c.4", mux_pllp_clkm, CLK_SOURCE_I2C5, 47, TEGRA114_CLK_I2C5),
-	TEGRA_INIT_DATA_UART("uarta", NULL, "tegra_uart.0", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_UARTA, 6, TEGRA114_CLK_UARTA),
-	TEGRA_INIT_DATA_UART("uartb", NULL, "tegra_uart.1", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_UARTB, 7, TEGRA114_CLK_UARTB),
-	TEGRA_INIT_DATA_UART("uartc", NULL, "tegra_uart.2", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_UARTC, 55, TEGRA114_CLK_UARTC),
-	TEGRA_INIT_DATA_UART("uartd", NULL, "tegra_uart.3", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_UARTD, 65, TEGRA114_CLK_UARTD),
-	TEGRA_INIT_DATA_INT8("3d", NULL, "3d", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_3D, 24, 0, TEGRA114_CLK_GR3D),
-	TEGRA_INIT_DATA_INT8("2d", NULL, "2d", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_2D, 21, 0, TEGRA114_CLK_GR2D),
-	TEGRA_INIT_DATA_MUX("vi_sensor", "vi_sensor", "tegra_camera", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_VI_SENSOR, 20, TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_VI_SENSOR),
-	TEGRA_INIT_DATA_INT8("vi", "vi", "tegra_camera", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_VI, 20, 0, TEGRA114_CLK_VI),
-	TEGRA_INIT_DATA_INT8("epp", NULL, "epp", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_EPP, 19, 0, TEGRA114_CLK_EPP),
-	TEGRA_INIT_DATA_INT8("msenc", NULL, "msenc", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_MSENC, 91, TEGRA_PERIPH_WAR_1005168, TEGRA114_CLK_MSENC),
-	TEGRA_INIT_DATA_INT8("tsec", NULL, "tsec", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_TSEC, 83, 0, TEGRA114_CLK_TSEC),
-	TEGRA_INIT_DATA_INT8("host1x", NULL, "host1x", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_HOST1X, 28, 0, TEGRA114_CLK_HOST1X),
-	TEGRA_INIT_DATA_MUX8("hdmi", NULL, "hdmi", mux_pllp_pllm_plld_plla_pllc_plld2_clkm, CLK_SOURCE_HDMI, 51, 0, TEGRA114_CLK_HDMI),
-	TEGRA_INIT_DATA_MUX("cilab", "cilab", "tegra_camera", mux_pllp_pllc_clkm, CLK_SOURCE_CILAB, 144, 0, TEGRA114_CLK_CILAB),
-	TEGRA_INIT_DATA_MUX("cilcd", "cilcd", "tegra_camera", mux_pllp_pllc_clkm, CLK_SOURCE_CILCD, 145, 0, TEGRA114_CLK_CILCD),
-	TEGRA_INIT_DATA_MUX("cile", "cile", "tegra_camera", mux_pllp_pllc_clkm, CLK_SOURCE_CILE, 146, 0, TEGRA114_CLK_CILE),
-	TEGRA_INIT_DATA_MUX("dsialp", "dsialp", "tegradc.0", mux_pllp_pllc_clkm, CLK_SOURCE_DSIALP, 147, 0, TEGRA114_CLK_DSIALP),
-	TEGRA_INIT_DATA_MUX("dsiblp", "dsiblp", "tegradc.1", mux_pllp_pllc_clkm, CLK_SOURCE_DSIBLP, 148, 0, TEGRA114_CLK_DSIBLP),
-	TEGRA_INIT_DATA_MUX("tsensor", NULL, "tegra-tsensor", mux_pllp_pllc_clkm_clk32, CLK_SOURCE_TSENSOR, 100, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_TSENSOR),
-	TEGRA_INIT_DATA_MUX("actmon", NULL, "actmon", mux_pllp_pllc_clk32_clkm, CLK_SOURCE_ACTMON, 119, 0, TEGRA114_CLK_ACTMON),
-	TEGRA_INIT_DATA_MUX8("extern1", NULL, "extern1", mux_plla_clk32_pllp_clkm_plle, CLK_SOURCE_EXTERN1, 120, 0, TEGRA114_CLK_EXTERN1),
-	TEGRA_INIT_DATA_MUX8("extern2", NULL, "extern2", mux_plla_clk32_pllp_clkm_plle, CLK_SOURCE_EXTERN2, 121, 0, TEGRA114_CLK_EXTERN2),
-	TEGRA_INIT_DATA_MUX8("extern3", NULL, "extern3", mux_plla_clk32_pllp_clkm_plle, CLK_SOURCE_EXTERN3, 122, 0, TEGRA114_CLK_EXTERN3),
-	TEGRA_INIT_DATA_MUX("i2cslow", NULL, "i2cslow", mux_pllp_pllc_clk32_clkm, CLK_SOURCE_I2CSLOW, 81, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_I2CSLOW),
-	TEGRA_INIT_DATA_INT8("se", NULL, "se", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SE, 127, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SE),
-	TEGRA_INIT_DATA_INT_FLAGS("mselect", NULL, "mselect", mux_pllp_clkm, CLK_SOURCE_MSELECT, 99, 0, TEGRA114_CLK_MSELECT, CLK_IGNORE_UNUSED),
-	TEGRA_INIT_DATA_MUX("dfll_ref", "ref", "t114_dfll", mux_pllp_clkm, CLK_SOURCE_DFLL_REF, 155, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_DFLL_REF),
-	TEGRA_INIT_DATA_MUX("dfll_soc", "soc", "t114_dfll", mux_pllp_clkm, CLK_SOURCE_DFLL_SOC, 155, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_DFLL_SOC),
-	TEGRA_INIT_DATA_MUX8("soc_therm", NULL, "soc_therm", mux_pllm_pllc_pllp_plla, CLK_SOURCE_SOC_THERM, 78, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SOC_THERM),
-	TEGRA_INIT_DATA_XUSB("xusb_host_src", "host_src", "tegra_xhci", mux_clkm_pllp_pllc_pllre, CLK_SOURCE_XUSB_HOST_SRC, 143, TEGRA_PERIPH_ON_APB | TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_XUSB_HOST_SRC),
-	TEGRA_INIT_DATA_XUSB("xusb_falcon_src", "falcon_src", "tegra_xhci", mux_clkm_pllp_pllc_pllre, CLK_SOURCE_XUSB_FALCON_SRC, 143, TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_XUSB_FALCON_SRC),
-	TEGRA_INIT_DATA_XUSB("xusb_fs_src", "fs_src", "tegra_xhci", mux_clkm_48M_pllp_480M, CLK_SOURCE_XUSB_FS_SRC, 143, TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_XUSB_FS_SRC),
-	TEGRA_INIT_DATA_XUSB("xusb_ss_src", "ss_src", "tegra_xhci", mux_clkm_pllre_clk32_480M_pllc_ref, CLK_SOURCE_XUSB_SS_SRC, 143, TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_XUSB_SS_SRC),
-	TEGRA_INIT_DATA_XUSB("xusb_dev_src", "dev_src", "tegra_xhci", mux_clkm_pllp_pllc_pllre, CLK_SOURCE_XUSB_DEV_SRC, 95, TEGRA_PERIPH_ON_APB | TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_XUSB_DEV_SRC),
-	TEGRA_INIT_DATA_AUDIO("d_audio", "d_audio", "tegra30-ahub", CLK_SOURCE_D_AUDIO, 106, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_D_AUDIO),
-	TEGRA_INIT_DATA_AUDIO("dam0", NULL, "tegra30-dam.0", CLK_SOURCE_DAM0, 108, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_DAM0),
-	TEGRA_INIT_DATA_AUDIO("dam1", NULL, "tegra30-dam.1", CLK_SOURCE_DAM1, 109, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_DAM1),
-	TEGRA_INIT_DATA_AUDIO("dam2", NULL, "tegra30-dam.2", CLK_SOURCE_DAM2, 110, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_DAM2),
+	TEGRA_INIT_DATA_MUX("i2s0", mux_pllaout0_audio0_2x_pllp_clkm, CLK_SOURCE_I2S0, 30, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_I2S0),
+	TEGRA_INIT_DATA_MUX("i2s1", mux_pllaout0_audio1_2x_pllp_clkm, CLK_SOURCE_I2S1, 11, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_I2S1),
+	TEGRA_INIT_DATA_MUX("i2s2", mux_pllaout0_audio2_2x_pllp_clkm, CLK_SOURCE_I2S2, 18, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_I2S2),
+	TEGRA_INIT_DATA_MUX("i2s3", mux_pllaout0_audio3_2x_pllp_clkm, CLK_SOURCE_I2S3, 101, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_I2S3),
+	TEGRA_INIT_DATA_MUX("i2s4", mux_pllaout0_audio4_2x_pllp_clkm, CLK_SOURCE_I2S4, 102, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_I2S4),
+	TEGRA_INIT_DATA_MUX("spdif_out", mux_pllaout0_audio_2x_pllp_clkm, CLK_SOURCE_SPDIF_OUT, 10, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SPDIF_OUT),
+	TEGRA_INIT_DATA_MUX("spdif_in", mux_pllp_pllc_pllm, CLK_SOURCE_SPDIF_IN, 10, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SPDIF_IN),
+	TEGRA_INIT_DATA_MUX("pwm", mux_pllp_pllc_clk32_clkm, CLK_SOURCE_PWM, 17, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_PWM),
+	TEGRA_INIT_DATA_MUX("adx", mux_plla_pllc_pllp_clkm, CLK_SOURCE_ADX, 154, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_ADX),
+	TEGRA_INIT_DATA_MUX("amx", mux_plla_pllc_pllp_clkm, CLK_SOURCE_AMX, 153, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_AMX),
+	TEGRA_INIT_DATA_MUX("hda", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_HDA, 125, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_HDA),
+	TEGRA_INIT_DATA_MUX("hda2codec_2x", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_HDA2CODEC_2X, 111, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_HDA2CODEC_2X),
+	TEGRA_INIT_DATA_MUX8("sbc1", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SBC1, 41, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC1),
+	TEGRA_INIT_DATA_MUX8("sbc2", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SBC2, 44, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC2),
+	TEGRA_INIT_DATA_MUX8("sbc3", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SBC3, 46, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC3),
+	TEGRA_INIT_DATA_MUX8("sbc4", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SBC4, 68, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC4),
+	TEGRA_INIT_DATA_MUX8("sbc5", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SBC5, 104, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC5),
+	TEGRA_INIT_DATA_MUX8("sbc6", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SBC6, 105, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC6),
+	TEGRA_INIT_DATA_MUX8("ndflash", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_NDFLASH, 13, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_NDSPEED),
+	TEGRA_INIT_DATA_MUX8("ndspeed", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_NDSPEED, 80, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_NDSPEED),
+	TEGRA_INIT_DATA_MUX("vfir", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_VFIR, 7, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_VFIR),
+	TEGRA_INIT_DATA_MUX("sdmmc1", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC1, 14, 0, TEGRA114_CLK_SDMMC1),
+	TEGRA_INIT_DATA_MUX("sdmmc2", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC2, 9, 0, TEGRA114_CLK_SDMMC2),
+	TEGRA_INIT_DATA_MUX("sdmmc3", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC3, 69, 0, TEGRA114_CLK_SDMMC3),
+	TEGRA_INIT_DATA_MUX("sdmmc4", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC4, 15, 0, TEGRA114_CLK_SDMMC4),
+	TEGRA_INIT_DATA_INT8("vde", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_VDE, 61, 0, TEGRA114_CLK_VDE),
+	TEGRA_INIT_DATA_MUX_FLAGS("csite", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_CSITE, 73, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_CSITE, CLK_IGNORE_UNUSED),
+	TEGRA_INIT_DATA_MUX("la", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_LA, 76, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_LA),
+	TEGRA_INIT_DATA_MUX("trace", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_TRACE, 77, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_TRACE),
+	TEGRA_INIT_DATA_MUX("owr", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_OWR, 71, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_OWR),
+	TEGRA_INIT_DATA_MUX("nor", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_NOR, 42, 0, TEGRA114_CLK_NOR),
+	TEGRA_INIT_DATA_MUX("mipi", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_MIPI, 50, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_MIPI),
+	TEGRA_INIT_DATA_I2C("i2c1", mux_pllp_clkm, CLK_SOURCE_I2C1, 12, TEGRA114_CLK_I2C1),
+	TEGRA_INIT_DATA_I2C("i2c2", mux_pllp_clkm, CLK_SOURCE_I2C2, 54, TEGRA114_CLK_I2C2),
+	TEGRA_INIT_DATA_I2C("i2c3", mux_pllp_clkm, CLK_SOURCE_I2C3, 67, TEGRA114_CLK_I2C3),
+	TEGRA_INIT_DATA_I2C("i2c4", mux_pllp_clkm, CLK_SOURCE_I2C4, 103, TEGRA114_CLK_I2C4),
+	TEGRA_INIT_DATA_I2C("i2c5", mux_pllp_clkm, CLK_SOURCE_I2C5, 47, TEGRA114_CLK_I2C5),
+	TEGRA_INIT_DATA_UART("uarta", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_UARTA, 6, TEGRA114_CLK_UARTA),
+	TEGRA_INIT_DATA_UART("uartb", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_UARTB, 7, TEGRA114_CLK_UARTB),
+	TEGRA_INIT_DATA_UART("uartc", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_UARTC, 55, TEGRA114_CLK_UARTC),
+	TEGRA_INIT_DATA_UART("uartd", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_UARTD, 65, TEGRA114_CLK_UARTD),
+	TEGRA_INIT_DATA_INT8("3d", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_3D, 24, 0, TEGRA114_CLK_GR3D),
+	TEGRA_INIT_DATA_INT8("2d", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_2D, 21, 0, TEGRA114_CLK_GR2D),
+	TEGRA_INIT_DATA_MUX("vi_sensor", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_VI_SENSOR, 20, TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_VI_SENSOR),
+	TEGRA_INIT_DATA_INT8("vi", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_VI, 20, 0, TEGRA114_CLK_VI),
+	TEGRA_INIT_DATA_INT8("epp", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_EPP, 19, 0, TEGRA114_CLK_EPP),
+	TEGRA_INIT_DATA_INT8("msenc", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_MSENC, 91, TEGRA_PERIPH_WAR_1005168, TEGRA114_CLK_MSENC),
+	TEGRA_INIT_DATA_INT8("tsec", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_TSEC, 83, 0, TEGRA114_CLK_TSEC),
+	TEGRA_INIT_DATA_INT8("host1x", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_HOST1X, 28, 0, TEGRA114_CLK_HOST1X),
+	TEGRA_INIT_DATA_MUX8("hdmi", mux_pllp_pllm_plld_plla_pllc_plld2_clkm, CLK_SOURCE_HDMI, 51, 0, TEGRA114_CLK_HDMI),
+	TEGRA_INIT_DATA_MUX("cilab", mux_pllp_pllc_clkm, CLK_SOURCE_CILAB, 144, 0, TEGRA114_CLK_CILAB),
+	TEGRA_INIT_DATA_MUX("cilcd", mux_pllp_pllc_clkm, CLK_SOURCE_CILCD, 145, 0, TEGRA114_CLK_CILCD),
+	TEGRA_INIT_DATA_MUX("cile", mux_pllp_pllc_clkm, CLK_SOURCE_CILE, 146, 0, TEGRA114_CLK_CILE),
+	TEGRA_INIT_DATA_MUX("dsialp", mux_pllp_pllc_clkm, CLK_SOURCE_DSIALP, 147, 0, TEGRA114_CLK_DSIALP),
+	TEGRA_INIT_DATA_MUX("dsiblp", mux_pllp_pllc_clkm, CLK_SOURCE_DSIBLP, 148, 0, TEGRA114_CLK_DSIBLP),
+	TEGRA_INIT_DATA_MUX("tsensor", mux_pllp_pllc_clkm_clk32, CLK_SOURCE_TSENSOR, 100, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_TSENSOR),
+	TEGRA_INIT_DATA_MUX("actmon", mux_pllp_pllc_clk32_clkm, CLK_SOURCE_ACTMON, 119, 0, TEGRA114_CLK_ACTMON),
+	TEGRA_INIT_DATA_MUX8("extern1", mux_plla_clk32_pllp_clkm_plle, CLK_SOURCE_EXTERN1, 120, 0, TEGRA114_CLK_EXTERN1),
+	TEGRA_INIT_DATA_MUX8("extern2", mux_plla_clk32_pllp_clkm_plle, CLK_SOURCE_EXTERN2, 121, 0, TEGRA114_CLK_EXTERN2),
+	TEGRA_INIT_DATA_MUX8("extern3", mux_plla_clk32_pllp_clkm_plle, CLK_SOURCE_EXTERN3, 122, 0, TEGRA114_CLK_EXTERN3),
+	TEGRA_INIT_DATA_MUX("i2cslow", mux_pllp_pllc_clk32_clkm, CLK_SOURCE_I2CSLOW, 81, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_I2CSLOW),
+	TEGRA_INIT_DATA_INT8("se", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SE, 127, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SE),
+	TEGRA_INIT_DATA_INT_FLAGS("mselect", mux_pllp_clkm, CLK_SOURCE_MSELECT, 99, 0, TEGRA114_CLK_MSELECT, CLK_IGNORE_UNUSED),
+	TEGRA_INIT_DATA_MUX("dfll_ref", mux_pllp_clkm, CLK_SOURCE_DFLL_REF, 155, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_DFLL_REF),
+	TEGRA_INIT_DATA_MUX("dfll_soc", mux_pllp_clkm, CLK_SOURCE_DFLL_SOC, 155, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_DFLL_SOC),
+	TEGRA_INIT_DATA_MUX8("soc_therm", mux_pllm_pllc_pllp_plla, CLK_SOURCE_SOC_THERM, 78, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SOC_THERM),
+	TEGRA_INIT_DATA_XUSB("xusb_host_src", mux_clkm_pllp_pllc_pllre, CLK_SOURCE_XUSB_HOST_SRC, 143, TEGRA_PERIPH_ON_APB | TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_XUSB_HOST_SRC),
+	TEGRA_INIT_DATA_XUSB("xusb_falcon_src", mux_clkm_pllp_pllc_pllre, CLK_SOURCE_XUSB_FALCON_SRC, 143, TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_XUSB_FALCON_SRC),
+	TEGRA_INIT_DATA_XUSB("xusb_fs_src", mux_clkm_48M_pllp_480M, CLK_SOURCE_XUSB_FS_SRC, 143, TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_XUSB_FS_SRC),
+	TEGRA_INIT_DATA_XUSB("xusb_ss_src", mux_clkm_pllre_clk32_480M_pllc_ref, CLK_SOURCE_XUSB_SS_SRC, 143, TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_XUSB_SS_SRC),
+	TEGRA_INIT_DATA_XUSB("xusb_dev_src", mux_clkm_pllp_pllc_pllre, CLK_SOURCE_XUSB_DEV_SRC, 95, TEGRA_PERIPH_ON_APB | TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_XUSB_DEV_SRC),
+	TEGRA_INIT_DATA_AUDIO("d_audio", CLK_SOURCE_D_AUDIO, 106, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_D_AUDIO),
+	TEGRA_INIT_DATA_AUDIO("dam0", CLK_SOURCE_DAM0, 108, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_DAM0),
+	TEGRA_INIT_DATA_AUDIO("dam1", CLK_SOURCE_DAM1, 109, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_DAM1),
+	TEGRA_INIT_DATA_AUDIO("dam2", CLK_SOURCE_DAM2, 110, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_DAM2),
 };
 
 static struct tegra_periph_init_data tegra_periph_nodiv_clk_list[] = {
-	TEGRA_INIT_DATA_NODIV("disp1", NULL, "tegradc.0", mux_pllp_pllm_plld_plla_pllc_plld2_clkm, CLK_SOURCE_DISP1, 29, 7, 27, 0, TEGRA114_CLK_DISP1),
-	TEGRA_INIT_DATA_NODIV("disp2", NULL, "tegradc.1", mux_pllp_pllm_plld_plla_pllc_plld2_clkm, CLK_SOURCE_DISP2, 29, 7, 26, 0, TEGRA114_CLK_DISP2),
+	TEGRA_INIT_DATA_NODIV("disp1", mux_pllp_pllm_plld_plla_pllc_plld2_clkm, CLK_SOURCE_DISP1, 29, 7, 27, 0, TEGRA114_CLK_DISP1),
+	TEGRA_INIT_DATA_NODIV("disp2", mux_pllp_pllm_plld_plla_pllc_plld2_clkm, CLK_SOURCE_DISP2, 29, 7, 26, 0, TEGRA114_CLK_DISP2),
 };
 
 static __init void tegra114_periph_clk_init(void __iomem *clk_base)
@@ -1756,7 +1761,6 @@ static __init void tegra114_periph_clk_init(void __iomem *clk_base)
 				    TEGRA_PERIPH_ON_APB |
 				    TEGRA_PERIPH_NO_RESET, clk_base,
 				    0, 4, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, NULL, "rtc-tegra");
 	clks[TEGRA114_CLK_RTC] = clk;
 
 	/* kbc */
@@ -1769,7 +1773,6 @@ static __init void tegra114_periph_clk_init(void __iomem *clk_base)
 	/* timer */
 	clk = tegra_clk_register_periph_gate("timer", "clk_m", 0, clk_base,
 				  0, 5, periph_clk_enb_refcnt);
-	clk_register_clkdev(clk, NULL, "timer");
 	clks[TEGRA114_CLK_TIMER] = clk;
 
 	/* kfuse */
@@ -2197,6 +2200,7 @@ static void __init tegra114_clock_init(struct device_node *np)
 	tegra114_super_clk_init(clk_base);
 
 	tegra_add_of_provider(np);
+	tegra_register_devclks(devclks, ARRAY_SIZE(devclks));
 
 	tegra_clk_apply_init_table = tegra114_clock_apply_init_table;
 
diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c
index a0430cd..14d2532 100644
--- a/drivers/clk/tegra/clk.c
+++ b/drivers/clk/tegra/clk.c
@@ -212,6 +212,15 @@ void __init tegra_add_of_provider(struct device_node *np)
 	of_clk_add_provider(np, of_clk_src_onecell_get, &clk_data);
 }
 
+void __init tegra_register_devclks(struct tegra_devclk *dev_clks, int num)
+{
+	int i;
+
+	for (i = 0; i < num; i++, dev_clks++)
+		clk_register_clkdev(clks[dev_clks->dt_id], dev_clks->con_id,
+				dev_clks->dev_id);
+}
+
 struct clk ** __init tegra_lookup_dt_id(int clk_id,
 					struct tegra_clk *tegra_clk)
 {
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index 489dad5..f742c7d 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -573,6 +573,12 @@ struct tegra_clk {
 	bool			present;
 };
 
+struct tegra_devclk {
+	int		dt_id;
+	char		*dev_id;
+	char		*con_id;
+};
+
 void tegra_init_from_table(struct tegra_clk_init_table *tbl,
 		struct clk *clks[], int clk_max);
 
@@ -585,6 +591,7 @@ struct clk **tegra_clk_init(int num, int periph_banks);
 struct clk **tegra_lookup_dt_id(int clk_id, struct tegra_clk *tegra_clk);
 
 void tegra_add_of_provider(struct device_node *np);
+void tegra_register_devclks(struct tegra_devclk *dev_clks, int num);
 
 void tegra114_clock_tune_cpu_trimmers_high(void);
 void tegra114_clock_tune_cpu_trimmers_low(void);
-- 
1.7.7.rc0.72.g4b5ea.dirty

