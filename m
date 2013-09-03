Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760138Ab3ICNcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 09:32:18 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:4394 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759959Ab3ICNcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 09:32:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 03 Sep 2013 06:32:15 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-tegra@vger.kernel.org>, Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Joseph Lo <josephl@nvidia.com>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] clk: tegra: simplify periph clock data
Date: Tue, 3 Sep 2013 16:31:31 +0300
Message-ID: <1378215105-12145-2-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1378215105-12145-1-git-send-email-pdeschrijver@nvidia.com>
References: <1378215105-12145-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch determines the register bank for clock enable/disable and reset
based on the clock ID instead of hardcoding it in the tables describing the
clocks. This results in less data to be maintained in the tables, making the
code easier to understand. The full benefit of the change will be realized once
also other clocktypes will be table based.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-tegra114.c |  403 ++++++++++++++++++++------------------
 1 files changed, 210 insertions(+), 193 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index a26e5ef..451d0e2 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -730,49 +730,49 @@ static struct tegra_clk_pll_params pll_re_vco_params = {
 
 /* Peripheral clock registers */
 
-static struct tegra_clk_periph_regs periph_l_regs = {
-	.enb_reg = CLK_OUT_ENB_L,
-	.enb_set_reg = CLK_OUT_ENB_SET_L,
-	.enb_clr_reg = CLK_OUT_ENB_CLR_L,
-	.rst_reg = RST_DEVICES_L,
-	.rst_set_reg = RST_DEVICES_SET_L,
-	.rst_clr_reg = RST_DEVICES_CLR_L,
-};
-
-static struct tegra_clk_periph_regs periph_h_regs = {
-	.enb_reg = CLK_OUT_ENB_H,
-	.enb_set_reg = CLK_OUT_ENB_SET_H,
-	.enb_clr_reg = CLK_OUT_ENB_CLR_H,
-	.rst_reg = RST_DEVICES_H,
-	.rst_set_reg = RST_DEVICES_SET_H,
-	.rst_clr_reg = RST_DEVICES_CLR_H,
-};
-
-static struct tegra_clk_periph_regs periph_u_regs = {
-	.enb_reg = CLK_OUT_ENB_U,
-	.enb_set_reg = CLK_OUT_ENB_SET_U,
-	.enb_clr_reg = CLK_OUT_ENB_CLR_U,
-	.rst_reg = RST_DEVICES_U,
-	.rst_set_reg = RST_DEVICES_SET_U,
-	.rst_clr_reg = RST_DEVICES_CLR_U,
-};
-
-static struct tegra_clk_periph_regs periph_v_regs = {
-	.enb_reg = CLK_OUT_ENB_V,
-	.enb_set_reg = CLK_OUT_ENB_SET_V,
-	.enb_clr_reg = CLK_OUT_ENB_CLR_V,
-	.rst_reg = RST_DEVICES_V,
-	.rst_set_reg = RST_DEVICES_SET_V,
-	.rst_clr_reg = RST_DEVICES_CLR_V,
-};
-
-static struct tegra_clk_periph_regs periph_w_regs = {
-	.enb_reg = CLK_OUT_ENB_W,
-	.enb_set_reg = CLK_OUT_ENB_SET_W,
-	.enb_clr_reg = CLK_OUT_ENB_CLR_W,
-	.rst_reg = RST_DEVICES_W,
-	.rst_set_reg = RST_DEVICES_SET_W,
-	.rst_clr_reg = RST_DEVICES_CLR_W,
+enum periph_reg_names { l = 0, h = 1, u = 2, v = 3, w = 4 };
+
+static struct tegra_clk_periph_regs periph_regs[] = {
+	[0] = {
+		.enb_reg = CLK_OUT_ENB_L,
+		.enb_set_reg = CLK_OUT_ENB_SET_L,
+		.enb_clr_reg = CLK_OUT_ENB_CLR_L,
+		.rst_reg = RST_DEVICES_L,
+		.rst_set_reg = RST_DEVICES_SET_L,
+		.rst_clr_reg = RST_DEVICES_CLR_L,
+	},
+	[1] = {
+		.enb_reg = CLK_OUT_ENB_H,
+		.enb_set_reg = CLK_OUT_ENB_SET_H,
+		.enb_clr_reg = CLK_OUT_ENB_CLR_H,
+		.rst_reg = RST_DEVICES_H,
+		.rst_set_reg = RST_DEVICES_SET_H,
+		.rst_clr_reg = RST_DEVICES_CLR_H,
+	},
+	[2] = {
+		.enb_reg = CLK_OUT_ENB_U,
+		.enb_set_reg = CLK_OUT_ENB_SET_U,
+		.enb_clr_reg = CLK_OUT_ENB_CLR_U,
+		.rst_reg = RST_DEVICES_U,
+		.rst_set_reg = RST_DEVICES_SET_U,
+		.rst_clr_reg = RST_DEVICES_CLR_U,
+	},
+	[3] = {
+		.enb_reg = CLK_OUT_ENB_V,
+		.enb_set_reg = CLK_OUT_ENB_SET_V,
+		.enb_clr_reg = CLK_OUT_ENB_CLR_V,
+		.rst_reg = RST_DEVICES_V,
+		.rst_set_reg = RST_DEVICES_SET_V,
+		.rst_clr_reg = RST_DEVICES_CLR_V,
+	},
+	[4] = {
+		.enb_reg = CLK_OUT_ENB_W,
+		.enb_set_reg = CLK_OUT_ENB_SET_W,
+		.enb_clr_reg = CLK_OUT_ENB_CLR_W,
+		.rst_reg = RST_DEVICES_W,
+		.rst_set_reg = RST_DEVICES_SET_W,
+		.rst_clr_reg = RST_DEVICES_CLR_W,
+	},
 };
 
 /* possible OSC frequencies in Hz */
@@ -789,79 +789,79 @@ static unsigned long tegra114_input_freq[] = {
 #define MASK(x) (BIT(x) - 1)
 
 #define TEGRA_INIT_DATA_MUX(_name, _con_id, _dev_id, _parents, _offset,	\
-			    _clk_num, _regs, _gate_flags, _clk_id)	\
+			    _clk_num, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
-			30, MASK(2), 0, 0, 8, 1, 0, _regs, _clk_num,	\
-			periph_clk_enb_refcnt, _gate_flags, _clk_id,	\
-			_parents##_idx, 0)
+			30, MASK(2), 0, 0, 8, 1, 0, 0,\
+			_clk_num, periph_clk_enb_refcnt, _gate_flags,\
+			 _clk_id, _parents##_idx, 0)
 
 #define TEGRA_INIT_DATA_MUX_FLAGS(_name, _con_id, _dev_id, _parents, _offset,\
-			    _clk_num, _regs, _gate_flags, _clk_id, flags)\
+			    _clk_num, _gate_flags, _clk_id, flags)\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
-			30, MASK(2), 0, 0, 8, 1, 0, _regs, _clk_num,	\
+			30, MASK(2), 0, 0, 8, 1, 0, 0, _clk_num,	\
 			periph_clk_enb_refcnt, _gate_flags, _clk_id,	\
 			_parents##_idx, flags)
 
 #define TEGRA_INIT_DATA_MUX8(_name, _con_id, _dev_id, _parents, _offset, \
-			     _clk_num, _regs, _gate_flags, _clk_id)	\
+			     _clk_num, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
-			29, MASK(3), 0, 0, 8, 1, 0, _regs, _clk_num,	\
+			29, MASK(3), 0, 0, 8, 1, 0, 0, _clk_num,	\
 			periph_clk_enb_refcnt, _gate_flags, _clk_id,	\
 			_parents##_idx, 0)
 
 #define TEGRA_INIT_DATA_INT(_name, _con_id, _dev_id, _parents, _offset,	\
-			    _clk_num, _regs, _gate_flags, _clk_id)	\
+			    _clk_num, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
-			30, MASK(2), 0, 0, 8, 1, TEGRA_DIVIDER_INT, _regs,\
+			30, MASK(2), 0, 0, 8, 1, TEGRA_DIVIDER_INT, 0,\
 			_clk_num, periph_clk_enb_refcnt, _gate_flags,	\
 			_clk_id, _parents##_idx, 0)
 
 #define TEGRA_INIT_DATA_INT_FLAGS(_name, _con_id, _dev_id, _parents, _offset,\
-			    _clk_num, _regs, _gate_flags, _clk_id, flags)\
+			    _clk_num, _gate_flags, _clk_id, flags)\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
-			30, MASK(2), 0, 0, 8, 1, TEGRA_DIVIDER_INT, _regs,\
+			30, MASK(2), 0, 0, 8, 1, TEGRA_DIVIDER_INT, 0,\
 			_clk_num, periph_clk_enb_refcnt, _gate_flags,	\
 			_clk_id, _parents##_idx, flags)
 
 #define TEGRA_INIT_DATA_INT8(_name, _con_id, _dev_id, _parents, _offset,\
-			    _clk_num, _regs, _gate_flags, _clk_id)	\
+			    _clk_num, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
-			29, MASK(3), 0, 0, 8, 1, TEGRA_DIVIDER_INT, _regs,\
+			29, MASK(3), 0, 0, 8, 1, TEGRA_DIVIDER_INT, 0,\
 			_clk_num, periph_clk_enb_refcnt, _gate_flags,	\
 			_clk_id, _parents##_idx, 0)
 
 #define TEGRA_INIT_DATA_UART(_name, _con_id, _dev_id, _parents, _offset,\
-			     _clk_num, _regs, _clk_id)			\
+			     _clk_num, _clk_id)			\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
-			30, MASK(2), 0, 0, 16, 1, TEGRA_DIVIDER_UART, _regs,\
+			30, MASK(2), 0, 0, 16, 1, TEGRA_DIVIDER_UART, 0,\
 			_clk_num, periph_clk_enb_refcnt, 0, _clk_id,	\
 			_parents##_idx, 0)
 
 #define TEGRA_INIT_DATA_I2C(_name, _con_id, _dev_id, _parents, _offset,\
-			     _clk_num, _regs, _clk_id)			\
+			     _clk_num, _clk_id)			\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
-			30, MASK(2), 0, 0, 16, 0, 0, _regs, _clk_num,	\
+			30, MASK(2), 0, 0, 16, 0, 0, 0, _clk_num,	\
 			periph_clk_enb_refcnt, 0, _clk_id, _parents##_idx, 0)
 
 #define TEGRA_INIT_DATA_NODIV(_name, _con_id, _dev_id, _parents, _offset, \
-			      _mux_shift, _mux_mask, _clk_num, _regs,	\
+			      _mux_shift, _mux_mask, _clk_num, \
 			      _gate_flags, _clk_id)			\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
-			_mux_shift, _mux_mask, 0, 0, 0, 0, 0, _regs,	\
+			_mux_shift, _mux_mask, 0, 0, 0, 0, 0, 0,	\
 			_clk_num, periph_clk_enb_refcnt, _gate_flags,	\
 			_clk_id, _parents##_idx, 0)
 
 #define TEGRA_INIT_DATA_XUSB(_name, _con_id, _dev_id, _parents, _offset, \
-			     _clk_num, _regs, _gate_flags, _clk_id)	 \
+			     _clk_num, _gate_flags, _clk_id)	 \
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset, \
-			29, MASK(3), 0, 0, 8, 1, TEGRA_DIVIDER_INT, _regs, \
+			29, MASK(3), 0, 0, 8, 1, TEGRA_DIVIDER_INT, 0, \
 			_clk_num, periph_clk_enb_refcnt, _gate_flags,	 \
 			_clk_id, _parents##_idx, 0)
 
 #define TEGRA_INIT_DATA_AUDIO(_name, _con_id, _dev_id, _offset,  _clk_num,\
-				 _regs, _gate_flags, _clk_id)		\
+				 _gate_flags, _clk_id)		\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, mux_d_audio_clk,	\
-			_offset, 16, 0xE01F, 0, 0, 8, 1, 0, _regs, _clk_num, \
+			_offset, 16, 0xE01F, 0, 0, 8, 1, 0, 0, _clk_num, \
 			periph_clk_enb_refcnt, _gate_flags , _clk_id,	\
 			mux_d_audio_clk_idx, 0)
 
@@ -1034,6 +1034,18 @@ static struct clk_onecell_data clk_data;
 static unsigned long osc_freq;
 static unsigned long pll_ref_freq;
 
+static __init int get_reg_bank(int clkid)
+{
+	int reg_bank = clkid / 32;
+
+	if (reg_bank < ARRAY_SIZE(periph_regs))
+		return reg_bank;
+	else {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+}
+
 static int __init tegra114_osc_clk_init(void __iomem *clk_base)
 {
 	struct clk *clk;
@@ -1608,7 +1620,7 @@ static void __init tegra114_audio_clk_init(void __iomem *clk_base)
 				0, &clk_doubler_lock);
 	clk = tegra_clk_register_periph_gate("audio0_2x", "audio0_div",
 				  TEGRA_PERIPH_NO_RESET, clk_base,
-				  CLK_SET_RATE_PARENT, 113, &periph_v_regs,
+				  CLK_SET_RATE_PARENT, 113, &periph_regs[113 / 32],
 				  periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "audio0_2x", NULL);
 	clks[TEGRA114_CLK_AUDIO0_2X] = clk;
@@ -1621,7 +1633,7 @@ static void __init tegra114_audio_clk_init(void __iomem *clk_base)
 				0, &clk_doubler_lock);
 	clk = tegra_clk_register_periph_gate("audio1_2x", "audio1_div",
 				  TEGRA_PERIPH_NO_RESET, clk_base,
-				  CLK_SET_RATE_PARENT, 114, &periph_v_regs,
+				  CLK_SET_RATE_PARENT, 114, &periph_regs[114 / 32],
 				  periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "audio1_2x", NULL);
 	clks[TEGRA114_CLK_AUDIO1_2X] = clk;
@@ -1634,7 +1646,7 @@ static void __init tegra114_audio_clk_init(void __iomem *clk_base)
 				0, &clk_doubler_lock);
 	clk = tegra_clk_register_periph_gate("audio2_2x", "audio2_div",
 				  TEGRA_PERIPH_NO_RESET, clk_base,
-				  CLK_SET_RATE_PARENT, 115, &periph_v_regs,
+				  CLK_SET_RATE_PARENT, 115, &periph_regs[115 / 32],
 				  periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "audio2_2x", NULL);
 	clks[TEGRA114_CLK_AUDIO2_2X] = clk;
@@ -1647,7 +1659,7 @@ static void __init tegra114_audio_clk_init(void __iomem *clk_base)
 				0, &clk_doubler_lock);
 	clk = tegra_clk_register_periph_gate("audio3_2x", "audio3_div",
 				  TEGRA_PERIPH_NO_RESET, clk_base,
-				  CLK_SET_RATE_PARENT, 116, &periph_v_regs,
+				  CLK_SET_RATE_PARENT, 116, &periph_regs[116 / 32],
 				  periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "audio3_2x", NULL);
 	clks[TEGRA114_CLK_AUDIO3_2X] = clk;
@@ -1660,7 +1672,7 @@ static void __init tegra114_audio_clk_init(void __iomem *clk_base)
 				0, &clk_doubler_lock);
 	clk = tegra_clk_register_periph_gate("audio4_2x", "audio4_div",
 				  TEGRA_PERIPH_NO_RESET, clk_base,
-				  CLK_SET_RATE_PARENT, 117, &periph_v_regs,
+				  CLK_SET_RATE_PARENT, 117, &periph_regs[117 / 32],
 				  periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "audio4_2x", NULL);
 	clks[TEGRA114_CLK_AUDIO4_2X] = clk;
@@ -1674,7 +1686,7 @@ static void __init tegra114_audio_clk_init(void __iomem *clk_base)
 	clk = tegra_clk_register_periph_gate("spdif_2x", "spdif_div",
 				  TEGRA_PERIPH_NO_RESET, clk_base,
 				  CLK_SET_RATE_PARENT, 118,
-				  &periph_v_regs, periph_clk_enb_refcnt);
+				  &periph_regs[118 / 32], periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "spdif_2x", NULL);
 	clks[TEGRA114_CLK_SPDIF_2X] = clk;
 }
@@ -1798,86 +1810,86 @@ static void __init tegra114_super_clk_init(void __iomem *clk_base)
 }
 
 static struct tegra_periph_init_data tegra_periph_clk_list[] = {
-	TEGRA_INIT_DATA_MUX("i2s0", NULL, "tegra30-i2s.0", mux_pllaout0_audio0_2x_pllp_clkm, CLK_SOURCE_I2S0, 30, &periph_l_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_I2S0),
-	TEGRA_INIT_DATA_MUX("i2s1", NULL, "tegra30-i2s.1", mux_pllaout0_audio1_2x_pllp_clkm, CLK_SOURCE_I2S1, 11, &periph_l_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_I2S1),
-	TEGRA_INIT_DATA_MUX("i2s2", NULL, "tegra30-i2s.2", mux_pllaout0_audio2_2x_pllp_clkm, CLK_SOURCE_I2S2, 18, &periph_l_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_I2S2),
-	TEGRA_INIT_DATA_MUX("i2s3", NULL, "tegra30-i2s.3", mux_pllaout0_audio3_2x_pllp_clkm, CLK_SOURCE_I2S3, 101, &periph_v_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_I2S3),
-	TEGRA_INIT_DATA_MUX("i2s4", NULL, "tegra30-i2s.4", mux_pllaout0_audio4_2x_pllp_clkm, CLK_SOURCE_I2S4, 102, &periph_v_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_I2S4),
-	TEGRA_INIT_DATA_MUX("spdif_out", "spdif_out", "tegra30-spdif", mux_pllaout0_audio_2x_pllp_clkm, CLK_SOURCE_SPDIF_OUT, 10, &periph_l_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SPDIF_OUT),
-	TEGRA_INIT_DATA_MUX("spdif_in", "spdif_in", "tegra30-spdif", mux_pllp_pllc_pllm, CLK_SOURCE_SPDIF_IN, 10, &periph_l_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SPDIF_IN),
-	TEGRA_INIT_DATA_MUX("pwm", NULL, "pwm", mux_pllp_pllc_clk32_clkm, CLK_SOURCE_PWM, 17, &periph_l_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_PWM),
-	TEGRA_INIT_DATA_MUX("adx", NULL, "adx", mux_plla_pllc_pllp_clkm, CLK_SOURCE_ADX, 154, &periph_w_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_ADX),
-	TEGRA_INIT_DATA_MUX("amx", NULL, "amx", mux_plla_pllc_pllp_clkm, CLK_SOURCE_AMX, 153, &periph_w_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_AMX),
-	TEGRA_INIT_DATA_MUX("hda", "hda", "tegra30-hda", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_HDA, 125, &periph_v_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_HDA),
-	TEGRA_INIT_DATA_MUX("hda2codec_2x", "hda2codec", "tegra30-hda", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_HDA2CODEC_2X, 111, &periph_v_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_HDA2CODEC_2X),
-	TEGRA_INIT_DATA_MUX("sbc1", NULL, "tegra11-spi.0", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SBC1, 41, &periph_h_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC1),
-	TEGRA_INIT_DATA_MUX("sbc2", NULL, "tegra11-spi.1", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SBC2, 44, &periph_h_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC2),
-	TEGRA_INIT_DATA_MUX("sbc3", NULL, "tegra11-spi.2", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SBC3, 46, &periph_h_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC3),
-	TEGRA_INIT_DATA_MUX("sbc4", NULL, "tegra11-spi.3", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SBC4, 68, &periph_u_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC4),
-	TEGRA_INIT_DATA_MUX("sbc5", NULL, "tegra11-spi.4", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SBC5, 104, &periph_v_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC5),
-	TEGRA_INIT_DATA_MUX("sbc6", NULL, "tegra11-spi.5", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SBC6, 105, &periph_v_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC6),
-	TEGRA_INIT_DATA_MUX8("ndflash", NULL, "tegra_nand", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_NDFLASH, 13, &periph_u_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_NDSPEED),
-	TEGRA_INIT_DATA_MUX8("ndspeed", NULL, "tegra_nand_speed", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_NDSPEED, 80, &periph_u_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_NDSPEED),
-	TEGRA_INIT_DATA_MUX("vfir", NULL, "vfir", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_VFIR, 7, &periph_l_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_VFIR),
-	TEGRA_INIT_DATA_MUX("sdmmc1", NULL, "sdhci-tegra.0", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC1, 14, &periph_l_regs, 0, TEGRA114_CLK_SDMMC1),
-	TEGRA_INIT_DATA_MUX("sdmmc2", NULL, "sdhci-tegra.1", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC2, 9, &periph_l_regs, 0, TEGRA114_CLK_SDMMC2),
-	TEGRA_INIT_DATA_MUX("sdmmc3", NULL, "sdhci-tegra.2", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC3, 69, &periph_u_regs, 0, TEGRA114_CLK_SDMMC3),
-	TEGRA_INIT_DATA_MUX("sdmmc4", NULL, "sdhci-tegra.3", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC4, 15, &periph_l_regs, 0, TEGRA114_CLK_SDMMC4),
-	TEGRA_INIT_DATA_INT("vde", NULL, "vde", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_VDE, 61, &periph_h_regs, 0, TEGRA114_CLK_VDE),
-	TEGRA_INIT_DATA_MUX_FLAGS("csite", NULL, "csite", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_CSITE, 73, &periph_u_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_CSITE, CLK_IGNORE_UNUSED),
-	TEGRA_INIT_DATA_MUX("la", NULL, "la", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_LA, 76, &periph_u_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_LA),
-	TEGRA_INIT_DATA_MUX("trace", NULL, "trace", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_TRACE, 77, &periph_u_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_TRACE),
-	TEGRA_INIT_DATA_MUX("owr", NULL, "tegra_w1", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_OWR, 71, &periph_u_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_OWR),
-	TEGRA_INIT_DATA_MUX("nor", NULL, "tegra-nor", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_NOR, 42, &periph_h_regs, 0, TEGRA114_CLK_NOR),
-	TEGRA_INIT_DATA_MUX("mipi", NULL, "mipi", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_MIPI, 50, &periph_h_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_MIPI),
-	TEGRA_INIT_DATA_I2C("i2c1", "div-clk", "tegra11-i2c.0", mux_pllp_clkm, CLK_SOURCE_I2C1, 12, &periph_l_regs, TEGRA114_CLK_I2C1),
-	TEGRA_INIT_DATA_I2C("i2c2", "div-clk", "tegra11-i2c.1", mux_pllp_clkm, CLK_SOURCE_I2C2, 54, &periph_h_regs, TEGRA114_CLK_I2C2),
-	TEGRA_INIT_DATA_I2C("i2c3", "div-clk", "tegra11-i2c.2", mux_pllp_clkm, CLK_SOURCE_I2C3, 67, &periph_u_regs, TEGRA114_CLK_I2C3),
-	TEGRA_INIT_DATA_I2C("i2c4", "div-clk", "tegra11-i2c.3", mux_pllp_clkm, CLK_SOURCE_I2C4, 103, &periph_v_regs, TEGRA114_CLK_I2C4),
-	TEGRA_INIT_DATA_I2C("i2c5", "div-clk", "tegra11-i2c.4", mux_pllp_clkm, CLK_SOURCE_I2C5, 47, &periph_h_regs, TEGRA114_CLK_I2C5),
-	TEGRA_INIT_DATA_UART("uarta", NULL, "tegra_uart.0", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_UARTA, 6, &periph_l_regs, TEGRA114_CLK_UARTA),
-	TEGRA_INIT_DATA_UART("uartb", NULL, "tegra_uart.1", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_UARTB, 7, &periph_l_regs, TEGRA114_CLK_UARTB),
-	TEGRA_INIT_DATA_UART("uartc", NULL, "tegra_uart.2", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_UARTC, 55, &periph_h_regs, TEGRA114_CLK_UARTC),
-	TEGRA_INIT_DATA_UART("uartd", NULL, "tegra_uart.3", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_UARTD, 65, &periph_u_regs, TEGRA114_CLK_UARTD),
-	TEGRA_INIT_DATA_INT("3d", NULL, "3d", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_3D, 24, &periph_l_regs, 0, TEGRA114_CLK_GR_3D),
-	TEGRA_INIT_DATA_INT("2d", NULL, "2d", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_2D, 21, &periph_l_regs, 0, TEGRA114_CLK_GR_2D),
-	TEGRA_INIT_DATA_MUX("vi_sensor", "vi_sensor", "tegra_camera", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_VI_SENSOR, 20, &periph_l_regs, TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_VI_SENSOR),
-	TEGRA_INIT_DATA_INT8("vi", "vi", "tegra_camera", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_VI, 20, &periph_l_regs, 0, TEGRA114_CLK_VI),
-	TEGRA_INIT_DATA_INT8("epp", NULL, "epp", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_EPP, 19, &periph_l_regs, 0, TEGRA114_CLK_EPP),
-	TEGRA_INIT_DATA_INT8("msenc", NULL, "msenc", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_MSENC, 91, &periph_u_regs, TEGRA_PERIPH_WAR_1005168, TEGRA114_CLK_MSENC),
-	TEGRA_INIT_DATA_INT8("tsec", NULL, "tsec", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_TSEC, 83, &periph_u_regs, 0, TEGRA114_CLK_TSEC),
-	TEGRA_INIT_DATA_INT8("host1x", NULL, "host1x", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_HOST1X, 28, &periph_l_regs, 0, TEGRA114_CLK_HOST1X),
-	TEGRA_INIT_DATA_MUX8("hdmi", NULL, "hdmi", mux_pllp_pllm_plld_plla_pllc_plld2_clkm, CLK_SOURCE_HDMI, 51, &periph_h_regs, 0, TEGRA114_CLK_HDMI),
-	TEGRA_INIT_DATA_MUX("cilab", "cilab", "tegra_camera", mux_pllp_pllc_clkm, CLK_SOURCE_CILAB, 144, &periph_w_regs, 0, TEGRA114_CLK_CILAB),
-	TEGRA_INIT_DATA_MUX("cilcd", "cilcd", "tegra_camera", mux_pllp_pllc_clkm, CLK_SOURCE_CILCD, 145, &periph_w_regs, 0, TEGRA114_CLK_CILCD),
-	TEGRA_INIT_DATA_MUX("cile", "cile", "tegra_camera", mux_pllp_pllc_clkm, CLK_SOURCE_CILE, 146, &periph_w_regs, 0, TEGRA114_CLK_CILE),
-	TEGRA_INIT_DATA_MUX("dsialp", "dsialp", "tegradc.0", mux_pllp_pllc_clkm, CLK_SOURCE_DSIALP, 147, &periph_w_regs, 0, TEGRA114_CLK_DSIALP),
-	TEGRA_INIT_DATA_MUX("dsiblp", "dsiblp", "tegradc.1", mux_pllp_pllc_clkm, CLK_SOURCE_DSIBLP, 148, &periph_w_regs, 0, TEGRA114_CLK_DSIBLP),
-	TEGRA_INIT_DATA_MUX("tsensor", NULL, "tegra-tsensor", mux_pllp_pllc_clkm_clk32, CLK_SOURCE_TSENSOR, 100, &periph_v_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_TSENSOR),
-	TEGRA_INIT_DATA_MUX("actmon", NULL, "actmon", mux_pllp_pllc_clk32_clkm, CLK_SOURCE_ACTMON, 119, &periph_v_regs, 0, TEGRA114_CLK_ACTMON),
-	TEGRA_INIT_DATA_MUX8("extern1", NULL, "extern1", mux_plla_clk32_pllp_clkm_plle, CLK_SOURCE_EXTERN1, 120, &periph_v_regs, 0, TEGRA114_CLK_EXTERN1),
-	TEGRA_INIT_DATA_MUX8("extern2", NULL, "extern2", mux_plla_clk32_pllp_clkm_plle, CLK_SOURCE_EXTERN2, 121, &periph_v_regs, 0, TEGRA114_CLK_EXTERN2),
-	TEGRA_INIT_DATA_MUX8("extern3", NULL, "extern3", mux_plla_clk32_pllp_clkm_plle, CLK_SOURCE_EXTERN3, 122, &periph_v_regs, 0, TEGRA114_CLK_EXTERN3),
-	TEGRA_INIT_DATA_MUX("i2cslow", NULL, "i2cslow", mux_pllp_pllc_clk32_clkm, CLK_SOURCE_I2CSLOW, 81, &periph_u_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_I2CSLOW),
-	TEGRA_INIT_DATA_INT8("se", NULL, "se", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SE, 127, &periph_v_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SE),
-	TEGRA_INIT_DATA_INT_FLAGS("mselect", NULL, "mselect", mux_pllp_clkm, CLK_SOURCE_MSELECT, 99, &periph_v_regs, 0, TEGRA114_CLK_MSELECT, CLK_IGNORE_UNUSED),
-	TEGRA_INIT_DATA_MUX("dfll_ref", "ref", "t114_dfll", mux_pllp_clkm, CLK_SOURCE_DFLL_REF, 155, &periph_w_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_DFLL_REF),
-	TEGRA_INIT_DATA_MUX("dfll_soc", "soc", "t114_dfll", mux_pllp_clkm, CLK_SOURCE_DFLL_SOC, 155, &periph_w_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_DFLL_SOC),
-	TEGRA_INIT_DATA_MUX8("soc_therm", NULL, "soc_therm", mux_pllm_pllc_pllp_plla, CLK_SOURCE_SOC_THERM, 78, &periph_u_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SOC_THERM),
-	TEGRA_INIT_DATA_XUSB("xusb_host_src", "host_src", "tegra_xhci", mux_clkm_pllp_pllc_pllre, CLK_SOURCE_XUSB_HOST_SRC, 143, &periph_w_regs, TEGRA_PERIPH_ON_APB | TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_XUSB_HOST_SRC),
-	TEGRA_INIT_DATA_XUSB("xusb_falcon_src", "falcon_src", "tegra_xhci", mux_clkm_pllp_pllc_pllre, CLK_SOURCE_XUSB_FALCON_SRC, 143, &periph_w_regs, TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_XUSB_FALCON_SRC),
-	TEGRA_INIT_DATA_XUSB("xusb_fs_src", "fs_src", "tegra_xhci", mux_clkm_48M_pllp_480M, CLK_SOURCE_XUSB_FS_SRC, 143, &periph_w_regs, TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_XUSB_FS_SRC),
-	TEGRA_INIT_DATA_XUSB("xusb_ss_src", "ss_src", "tegra_xhci", mux_clkm_pllre_clk32_480M_pllc_ref, CLK_SOURCE_XUSB_SS_SRC, 143, &periph_w_regs, TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_XUSB_SS_SRC),
-	TEGRA_INIT_DATA_XUSB("xusb_dev_src", "dev_src", "tegra_xhci", mux_clkm_pllp_pllc_pllre, CLK_SOURCE_XUSB_DEV_SRC, 95, &periph_u_regs, TEGRA_PERIPH_ON_APB | TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_XUSB_DEV_SRC),
-	TEGRA_INIT_DATA_AUDIO("d_audio", "d_audio", "tegra30-ahub", CLK_SOURCE_D_AUDIO, 106, &periph_v_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_D_AUDIO),
-	TEGRA_INIT_DATA_AUDIO("dam0", NULL, "tegra30-dam.0", CLK_SOURCE_DAM0, 108, &periph_v_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_DAM0),
-	TEGRA_INIT_DATA_AUDIO("dam1", NULL, "tegra30-dam.1", CLK_SOURCE_DAM1, 109, &periph_v_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_DAM1),
-	TEGRA_INIT_DATA_AUDIO("dam2", NULL, "tegra30-dam.2", CLK_SOURCE_DAM2, 110, &periph_v_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_DAM2),
+	TEGRA_INIT_DATA_MUX("i2s0", NULL, "tegra30-i2s.0", mux_pllaout0_audio0_2x_pllp_clkm, CLK_SOURCE_I2S0, 30, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_I2S0),
+	TEGRA_INIT_DATA_MUX("i2s1", NULL, "tegra30-i2s.1", mux_pllaout0_audio1_2x_pllp_clkm, CLK_SOURCE_I2S1, 11, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_I2S1),
+	TEGRA_INIT_DATA_MUX("i2s2", NULL, "tegra30-i2s.2", mux_pllaout0_audio2_2x_pllp_clkm, CLK_SOURCE_I2S2, 18, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_I2S2),
+	TEGRA_INIT_DATA_MUX("i2s3", NULL, "tegra30-i2s.3", mux_pllaout0_audio3_2x_pllp_clkm, CLK_SOURCE_I2S3, 101, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_I2S3),
+	TEGRA_INIT_DATA_MUX("i2s4", NULL, "tegra30-i2s.4", mux_pllaout0_audio4_2x_pllp_clkm, CLK_SOURCE_I2S4, 102, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_I2S4),
+	TEGRA_INIT_DATA_MUX("spdif_out", "spdif_out", "tegra30-spdif", mux_pllaout0_audio_2x_pllp_clkm, CLK_SOURCE_SPDIF_OUT, 10, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SPDIF_OUT),
+	TEGRA_INIT_DATA_MUX("spdif_in", "spdif_in", "tegra30-spdif", mux_pllp_pllc_pllm, CLK_SOURCE_SPDIF_IN, 10, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SPDIF_IN),
+	TEGRA_INIT_DATA_MUX("pwm", NULL, "pwm", mux_pllp_pllc_clk32_clkm, CLK_SOURCE_PWM, 17, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_PWM),
+	TEGRA_INIT_DATA_MUX("adx", NULL, "adx", mux_plla_pllc_pllp_clkm, CLK_SOURCE_ADX, 154, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_ADX),
+	TEGRA_INIT_DATA_MUX("amx", NULL, "amx", mux_plla_pllc_pllp_clkm, CLK_SOURCE_AMX, 153, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_AMX),
+	TEGRA_INIT_DATA_MUX("hda", "hda", "tegra30-hda", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_HDA, 125, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_HDA),
+	TEGRA_INIT_DATA_MUX("hda2codec_2x", "hda2codec", "tegra30-hda", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_HDA2CODEC_2X, 111, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_HDA2CODEC_2X),
+	TEGRA_INIT_DATA_MUX("sbc1", NULL, "tegra11-spi.0", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SBC1, 41, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC1),
+	TEGRA_INIT_DATA_MUX("sbc2", NULL, "tegra11-spi.1", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SBC2, 44, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC2),
+	TEGRA_INIT_DATA_MUX("sbc3", NULL, "tegra11-spi.2", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SBC3, 46, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC3),
+	TEGRA_INIT_DATA_MUX("sbc4", NULL, "tegra11-spi.3", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SBC4, 68, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC4),
+	TEGRA_INIT_DATA_MUX("sbc5", NULL, "tegra11-spi.4", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SBC5, 104, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC5),
+	TEGRA_INIT_DATA_MUX("sbc6", NULL, "tegra11-spi.5", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SBC6, 105, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC6),
+	TEGRA_INIT_DATA_MUX8("ndflash", NULL, "tegra_nand", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_NDFLASH, 13, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_NDSPEED),
+	TEGRA_INIT_DATA_MUX8("ndspeed", NULL, "tegra_nand_speed", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_NDSPEED, 80, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_NDSPEED),
+	TEGRA_INIT_DATA_MUX("vfir", NULL, "vfir", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_VFIR, 7, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_VFIR),
+	TEGRA_INIT_DATA_MUX("sdmmc1", NULL, "sdhci-tegra.0", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC1, 14, 0, TEGRA114_CLK_SDMMC1),
+	TEGRA_INIT_DATA_MUX("sdmmc2", NULL, "sdhci-tegra.1", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC2, 9, 0, TEGRA114_CLK_SDMMC2),
+	TEGRA_INIT_DATA_MUX("sdmmc3", NULL, "sdhci-tegra.2", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC3, 69, 0, TEGRA114_CLK_SDMMC3),
+	TEGRA_INIT_DATA_MUX("sdmmc4", NULL, "sdhci-tegra.3", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC4, 15, 0, TEGRA114_CLK_SDMMC4),
+	TEGRA_INIT_DATA_INT("vde", NULL, "vde", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_VDE, 61, 0, TEGRA114_CLK_VDE),
+	TEGRA_INIT_DATA_MUX_FLAGS("csite", NULL, "csite", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_CSITE, 73, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_CSITE, CLK_IGNORE_UNUSED),
+	TEGRA_INIT_DATA_MUX("la", NULL, "la", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_LA, 76, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_LA),
+	TEGRA_INIT_DATA_MUX("trace", NULL, "trace", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_TRACE, 77, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_TRACE),
+	TEGRA_INIT_DATA_MUX("owr", NULL, "tegra_w1", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_OWR, 71, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_OWR),
+	TEGRA_INIT_DATA_MUX("nor", NULL, "tegra-nor", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_NOR, 42, 0, TEGRA114_CLK_NOR),
+	TEGRA_INIT_DATA_MUX("mipi", NULL, "mipi", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_MIPI, 50, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_MIPI),
+	TEGRA_INIT_DATA_I2C("i2c1", "div-clk", "tegra11-i2c.0", mux_pllp_clkm, CLK_SOURCE_I2C1, 12, TEGRA114_CLK_I2C1),
+	TEGRA_INIT_DATA_I2C("i2c2", "div-clk", "tegra11-i2c.1", mux_pllp_clkm, CLK_SOURCE_I2C2, 54, TEGRA114_CLK_I2C2),
+	TEGRA_INIT_DATA_I2C("i2c3", "div-clk", "tegra11-i2c.2", mux_pllp_clkm, CLK_SOURCE_I2C3, 67, TEGRA114_CLK_I2C3),
+	TEGRA_INIT_DATA_I2C("i2c4", "div-clk", "tegra11-i2c.3", mux_pllp_clkm, CLK_SOURCE_I2C4, 103, TEGRA114_CLK_I2C4),
+	TEGRA_INIT_DATA_I2C("i2c5", "div-clk", "tegra11-i2c.4", mux_pllp_clkm, CLK_SOURCE_I2C5, 47, TEGRA114_CLK_I2C5),
+	TEGRA_INIT_DATA_UART("uarta", NULL, "tegra_uart.0", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_UARTA, 6, TEGRA114_CLK_UARTA),
+	TEGRA_INIT_DATA_UART("uartb", NULL, "tegra_uart.1", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_UARTB, 7, TEGRA114_CLK_UARTB),
+	TEGRA_INIT_DATA_UART("uartc", NULL, "tegra_uart.2", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_UARTC, 55, TEGRA114_CLK_UARTC),
+	TEGRA_INIT_DATA_UART("uartd", NULL, "tegra_uart.3", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_UARTD, 65, TEGRA114_CLK_UARTD),
+	TEGRA_INIT_DATA_INT("3d", NULL, "3d", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_3D, 24, 0, TEGRA114_CLK_GR_3D),
+	TEGRA_INIT_DATA_INT("2d", NULL, "2d", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_2D, 21, 0, TEGRA114_CLK_GR_2D),
+	TEGRA_INIT_DATA_MUX("vi_sensor", "vi_sensor", "tegra_camera", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_VI_SENSOR, 20, TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_VI_SENSOR),
+	TEGRA_INIT_DATA_INT8("vi", "vi", "tegra_camera", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_VI, 20, 0, TEGRA114_CLK_VI),
+	TEGRA_INIT_DATA_INT8("epp", NULL, "epp", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_EPP, 19, 0, TEGRA114_CLK_EPP),
+	TEGRA_INIT_DATA_INT8("msenc", NULL, "msenc", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_MSENC, 91, TEGRA_PERIPH_WAR_1005168, TEGRA114_CLK_MSENC),
+	TEGRA_INIT_DATA_INT8("tsec", NULL, "tsec", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_TSEC, 83, 0, TEGRA114_CLK_TSEC),
+	TEGRA_INIT_DATA_INT8("host1x", NULL, "host1x", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_HOST1X, 28, 0, TEGRA114_CLK_HOST1X),
+	TEGRA_INIT_DATA_MUX8("hdmi", NULL, "hdmi", mux_pllp_pllm_plld_plla_pllc_plld2_clkm, CLK_SOURCE_HDMI, 51, 0, TEGRA114_CLK_HDMI),
+	TEGRA_INIT_DATA_MUX("cilab", "cilab", "tegra_camera", mux_pllp_pllc_clkm, CLK_SOURCE_CILAB, 144, 0, TEGRA114_CLK_CILAB),
+	TEGRA_INIT_DATA_MUX("cilcd", "cilcd", "tegra_camera", mux_pllp_pllc_clkm, CLK_SOURCE_CILCD, 145, 0, TEGRA114_CLK_CILCD),
+	TEGRA_INIT_DATA_MUX("cile", "cile", "tegra_camera", mux_pllp_pllc_clkm, CLK_SOURCE_CILE, 146, 0, TEGRA114_CLK_CILE),
+	TEGRA_INIT_DATA_MUX("dsialp", "dsialp", "tegradc.0", mux_pllp_pllc_clkm, CLK_SOURCE_DSIALP, 147, 0, TEGRA114_CLK_DSIALP),
+	TEGRA_INIT_DATA_MUX("dsiblp", "dsiblp", "tegradc.1", mux_pllp_pllc_clkm, CLK_SOURCE_DSIBLP, 148, 0, TEGRA114_CLK_DSIBLP),
+	TEGRA_INIT_DATA_MUX("tsensor", NULL, "tegra-tsensor", mux_pllp_pllc_clkm_clk32, CLK_SOURCE_TSENSOR, 100, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_TSENSOR),
+	TEGRA_INIT_DATA_MUX("actmon", NULL, "actmon", mux_pllp_pllc_clk32_clkm, CLK_SOURCE_ACTMON, 119, 0, TEGRA114_CLK_ACTMON),
+	TEGRA_INIT_DATA_MUX8("extern1", NULL, "extern1", mux_plla_clk32_pllp_clkm_plle, CLK_SOURCE_EXTERN1, 120, 0, TEGRA114_CLK_EXTERN1),
+	TEGRA_INIT_DATA_MUX8("extern2", NULL, "extern2", mux_plla_clk32_pllp_clkm_plle, CLK_SOURCE_EXTERN2, 121, 0, TEGRA114_CLK_EXTERN2),
+	TEGRA_INIT_DATA_MUX8("extern3", NULL, "extern3", mux_plla_clk32_pllp_clkm_plle, CLK_SOURCE_EXTERN3, 122, 0, TEGRA114_CLK_EXTERN3),
+	TEGRA_INIT_DATA_MUX("i2cslow", NULL, "i2cslow", mux_pllp_pllc_clk32_clkm, CLK_SOURCE_I2CSLOW, 81, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_I2CSLOW),
+	TEGRA_INIT_DATA_INT8("se", NULL, "se", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SE, 127, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SE),
+	TEGRA_INIT_DATA_INT_FLAGS("mselect", NULL, "mselect", mux_pllp_clkm, CLK_SOURCE_MSELECT, 99, 0, TEGRA114_CLK_MSELECT, CLK_IGNORE_UNUSED),
+	TEGRA_INIT_DATA_MUX("dfll_ref", "ref", "t114_dfll", mux_pllp_clkm, CLK_SOURCE_DFLL_REF, 155, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_DFLL_REF),
+	TEGRA_INIT_DATA_MUX("dfll_soc", "soc", "t114_dfll", mux_pllp_clkm, CLK_SOURCE_DFLL_SOC, 155, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_DFLL_SOC),
+	TEGRA_INIT_DATA_MUX8("soc_therm", NULL, "soc_therm", mux_pllm_pllc_pllp_plla, CLK_SOURCE_SOC_THERM, 78, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SOC_THERM),
+	TEGRA_INIT_DATA_XUSB("xusb_host_src", "host_src", "tegra_xhci", mux_clkm_pllp_pllc_pllre, CLK_SOURCE_XUSB_HOST_SRC, 143, TEGRA_PERIPH_ON_APB | TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_XUSB_HOST_SRC),
+	TEGRA_INIT_DATA_XUSB("xusb_falcon_src", "falcon_src", "tegra_xhci", mux_clkm_pllp_pllc_pllre, CLK_SOURCE_XUSB_FALCON_SRC, 143, TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_XUSB_FALCON_SRC),
+	TEGRA_INIT_DATA_XUSB("xusb_fs_src", "fs_src", "tegra_xhci", mux_clkm_48M_pllp_480M, CLK_SOURCE_XUSB_FS_SRC, 143, TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_XUSB_FS_SRC),
+	TEGRA_INIT_DATA_XUSB("xusb_ss_src", "ss_src", "tegra_xhci", mux_clkm_pllre_clk32_480M_pllc_ref, CLK_SOURCE_XUSB_SS_SRC, 143, TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_XUSB_SS_SRC),
+	TEGRA_INIT_DATA_XUSB("xusb_dev_src", "dev_src", "tegra_xhci", mux_clkm_pllp_pllc_pllre, CLK_SOURCE_XUSB_DEV_SRC, 95, TEGRA_PERIPH_ON_APB | TEGRA_PERIPH_NO_RESET, TEGRA114_CLK_XUSB_DEV_SRC),
+	TEGRA_INIT_DATA_AUDIO("d_audio", "d_audio", "tegra30-ahub", CLK_SOURCE_D_AUDIO, 106, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_D_AUDIO),
+	TEGRA_INIT_DATA_AUDIO("dam0", NULL, "tegra30-dam.0", CLK_SOURCE_DAM0, 108, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_DAM0),
+	TEGRA_INIT_DATA_AUDIO("dam1", NULL, "tegra30-dam.1", CLK_SOURCE_DAM1, 109, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_DAM1),
+	TEGRA_INIT_DATA_AUDIO("dam2", NULL, "tegra30-dam.2", CLK_SOURCE_DAM2, 110, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_DAM2),
 };
 
 static struct tegra_periph_init_data tegra_periph_nodiv_clk_list[] = {
-	TEGRA_INIT_DATA_NODIV("disp1", NULL, "tegradc.0", mux_pllp_pllm_plld_plla_pllc_plld2_clkm, CLK_SOURCE_DISP1, 29, 7, 27, &periph_l_regs, 0, TEGRA114_CLK_DISP1),
-	TEGRA_INIT_DATA_NODIV("disp2", NULL, "tegradc.1", mux_pllp_pllm_plld_plla_pllc_plld2_clkm, CLK_SOURCE_DISP2, 29, 7, 26, &periph_l_regs, 0, TEGRA114_CLK_DISP2),
+	TEGRA_INIT_DATA_NODIV("disp1", NULL, "tegradc.0", mux_pllp_pllm_plld_plla_pllc_plld2_clkm, CLK_SOURCE_DISP1, 29, 7, 27, 0, TEGRA114_CLK_DISP1),
+	TEGRA_INIT_DATA_NODIV("disp2", NULL, "tegradc.1", mux_pllp_pllm_plld_plla_pllc_plld2_clkm, CLK_SOURCE_DISP2, 29, 7, 26, 0, TEGRA114_CLK_DISP2),
 };
 
 static __init void tegra114_periph_clk_init(void __iomem *clk_base)
@@ -1889,7 +1901,7 @@ static __init void tegra114_periph_clk_init(void __iomem *clk_base)
 
 	/* apbdma */
 	clk = tegra_clk_register_periph_gate("apbdma", "clk_m", 0, clk_base,
-				  0, 34, &periph_h_regs,
+				  0, 34, &periph_regs[h],
 				  periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_APBDMA] = clk;
 
@@ -1897,7 +1909,7 @@ static __init void tegra114_periph_clk_init(void __iomem *clk_base)
 	clk = tegra_clk_register_periph_gate("rtc", "clk_32k",
 				    TEGRA_PERIPH_ON_APB |
 				    TEGRA_PERIPH_NO_RESET, clk_base,
-				    0, 4, &periph_l_regs,
+				    0, 4, &periph_regs[l],
 				    periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "rtc-tegra");
 	clks[TEGRA114_CLK_RTC] = clk;
@@ -1906,13 +1918,13 @@ static __init void tegra114_periph_clk_init(void __iomem *clk_base)
 	clk = tegra_clk_register_periph_gate("kbc", "clk_32k",
 				    TEGRA_PERIPH_ON_APB |
 				    TEGRA_PERIPH_NO_RESET, clk_base,
-				    0, 36, &periph_h_regs,
+				    0, 36, &periph_regs[h],
 				    periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_KBC] = clk;
 
 	/* timer */
 	clk = tegra_clk_register_periph_gate("timer", "clk_m", 0, clk_base,
-				  0, 5, &periph_l_regs,
+				  0, 5, &periph_regs[l],
 				  periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "timer");
 	clks[TEGRA114_CLK_TIMER] = clk;
@@ -1920,109 +1932,109 @@ static __init void tegra114_periph_clk_init(void __iomem *clk_base)
 	/* kfuse */
 	clk = tegra_clk_register_periph_gate("kfuse", "clk_m",
 				  TEGRA_PERIPH_ON_APB, clk_base,  0, 40,
-				  &periph_h_regs, periph_clk_enb_refcnt);
+				  &periph_regs[h], periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_KFUSE] = clk;
 
 	/* fuse */
 	clk = tegra_clk_register_periph_gate("fuse", "clk_m",
 				  TEGRA_PERIPH_ON_APB, clk_base,  0, 39,
-				  &periph_h_regs, periph_clk_enb_refcnt);
+				  &periph_regs[h], periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_FUSE] = clk;
 
 	/* fuse_burn */
 	clk = tegra_clk_register_periph_gate("fuse_burn", "clk_m",
 				  TEGRA_PERIPH_ON_APB, clk_base,  0, 39,
-				  &periph_h_regs, periph_clk_enb_refcnt);
+				  &periph_regs[h], periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_FUSE_BURN] = clk;
 
 	/* apbif */
 	clk = tegra_clk_register_periph_gate("apbif", "clk_m",
 				  TEGRA_PERIPH_ON_APB, clk_base,  0, 107,
-				  &periph_v_regs, periph_clk_enb_refcnt);
+				  &periph_regs[v], periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_APBIF] = clk;
 
 	/* hda2hdmi */
 	clk = tegra_clk_register_periph_gate("hda2hdmi", "clk_m",
 				    TEGRA_PERIPH_ON_APB, clk_base,  0, 128,
-				    &periph_w_regs, periph_clk_enb_refcnt);
+				    &periph_regs[w], periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_HDA2HDMI] = clk;
 
 	/* vcp */
 	clk = tegra_clk_register_periph_gate("vcp", "clk_m", 0, clk_base,  0,
-				  29, &periph_l_regs,
+				  29, &periph_regs[l],
 				  periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_VCP] = clk;
 
 	/* bsea */
 	clk = tegra_clk_register_periph_gate("bsea", "clk_m", 0, clk_base,
-				  0, 62, &periph_h_regs,
+				  0, 62, &periph_regs[h],
 				  periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_BSEA] = clk;
 
 	/* bsev */
 	clk = tegra_clk_register_periph_gate("bsev", "clk_m", 0, clk_base,
-				  0, 63, &periph_h_regs,
+				  0, 63, &periph_regs[h],
 				  periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_BSEV] = clk;
 
 	/* mipi-cal */
 	clk = tegra_clk_register_periph_gate("mipi-cal", "clk_m", 0, clk_base,
-				   0, 56, &periph_h_regs,
+				   0, 56, &periph_regs[h],
 				  periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_MIPI_CAL] = clk;
 
 	/* usbd */
 	clk = tegra_clk_register_periph_gate("usbd", "clk_m", 0, clk_base,
-				  0, 22, &periph_l_regs,
+				  0, 22, &periph_regs[l],
 				  periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_USBD] = clk;
 
 	/* usb2 */
 	clk = tegra_clk_register_periph_gate("usb2", "clk_m", 0, clk_base,
-				  0, 58, &periph_h_regs,
+				  0, 58, &periph_regs[h],
 				  periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_USB2] = clk;
 
 	/* usb3 */
 	clk = tegra_clk_register_periph_gate("usb3", "clk_m", 0, clk_base,
-				  0, 59, &periph_h_regs,
+				  0, 59, &periph_regs[h],
 				  periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_USB3] = clk;
 
 	/* csi */
 	clk = tegra_clk_register_periph_gate("csi", "pll_p_out3", 0, clk_base,
-				   0, 52, &periph_h_regs,
+				   0, 52, &periph_regs[h],
 				  periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_CSI] = clk;
 
 	/* isp */
 	clk = tegra_clk_register_periph_gate("isp", "clk_m", 0, clk_base, 0,
-				  23, &periph_l_regs,
+				  23, &periph_regs[l],
 				  periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_ISP] = clk;
 
 	/* csus */
 	clk = tegra_clk_register_periph_gate("csus", "clk_m",
 				  TEGRA_PERIPH_NO_RESET, clk_base, 0, 92,
-				  &periph_u_regs, periph_clk_enb_refcnt);
+				  &periph_regs[u], periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_CSUS] = clk;
 
 	/* dds */
 	clk = tegra_clk_register_periph_gate("dds", "clk_m",
 				  TEGRA_PERIPH_ON_APB, clk_base, 0, 150,
-				  &periph_w_regs, periph_clk_enb_refcnt);
+				  &periph_regs[w], periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_DDS] = clk;
 
 	/* dp2 */
 	clk = tegra_clk_register_periph_gate("dp2", "clk_m",
 				  TEGRA_PERIPH_ON_APB, clk_base, 0, 152,
-				  &periph_w_regs, periph_clk_enb_refcnt);
+				  &periph_regs[w], periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_DP2] = clk;
 
 	/* dtv */
 	clk = tegra_clk_register_periph_gate("dtv", "clk_m",
 				    TEGRA_PERIPH_ON_APB, clk_base, 0, 79,
-				    &periph_u_regs, periph_clk_enb_refcnt);
+				    &periph_regs[u], periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_DTV] = clk;
 
 	/* dsia */
@@ -2031,20 +2043,10 @@ static __init void tegra114_periph_clk_init(void __iomem *clk_base)
 			       clk_base + PLLD_BASE, 25, 1, 0, &pll_d_lock);
 	clks[TEGRA114_CLK_DSIA_MUX] = clk;
 	clk = tegra_clk_register_periph_gate("dsia", "dsia_mux", 0, clk_base,
-				    0, 48, &periph_h_regs,
+				    0, 48, &periph_regs[h],
 				    periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_DSIA] = clk;
 
-	/* dsib */
-	clk = clk_register_mux(NULL, "dsib_mux", mux_plld_out0_plld2_out0,
-			       ARRAY_SIZE(mux_plld_out0_plld2_out0), 0,
-			       clk_base + PLLD2_BASE, 25, 1, 0, &pll_d2_lock);
-	clks[TEGRA114_CLK_DSIB_MUX] = clk;
-	clk = tegra_clk_register_periph_gate("dsib", "dsib_mux", 0, clk_base,
-				    0, 82, &periph_u_regs,
-				    periph_clk_enb_refcnt);
-	clks[TEGRA114_CLK_DSIB] = clk;
-
 	/* xusb_hs_src */
 	val = readl(clk_base + CLK_SOURCE_XUSB_SS_SRC);
 	val |= BIT(25); /* always select PLLU_60M */
@@ -2056,19 +2058,19 @@ static __init void tegra114_periph_clk_init(void __iomem *clk_base)
 
 	/* xusb_host */
 	clk = tegra_clk_register_periph_gate("xusb_host", "xusb_host_src", 0,
-				    clk_base, 0, 89, &periph_u_regs,
+				    clk_base, 0, 89, &periph_regs[u],
 				    periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_XUSB_HOST] = clk;
 
 	/* xusb_ss */
 	clk = tegra_clk_register_periph_gate("xusb_ss", "xusb_ss_src", 0,
-				    clk_base, 0, 156, &periph_w_regs,
+				    clk_base, 0, 156, &periph_regs[w],
 				    periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_XUSB_HOST] = clk;
 
 	/* xusb_dev */
 	clk = tegra_clk_register_periph_gate("xusb_dev", "xusb_dev_src", 0,
-				    clk_base, 0, 95, &periph_u_regs,
+				    clk_base, 0, 95, &periph_regs[u],
 				    periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_XUSB_DEV] = clk;
 
@@ -2078,24 +2080,39 @@ static __init void tegra114_periph_clk_init(void __iomem *clk_base)
 			       clk_base + CLK_SOURCE_EMC,
 			       29, 3, 0, NULL);
 	clk = tegra_clk_register_periph_gate("emc", "emc_mux", 0, clk_base,
-				CLK_IGNORE_UNUSED, 57, &periph_h_regs,
+				CLK_IGNORE_UNUSED, 57, &periph_regs[h],
 				periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_EMC] = clk;
 
 	for (i = 0; i < ARRAY_SIZE(tegra_periph_clk_list); i++) {
+		int reg_bank;
+
 		data = &tegra_periph_clk_list[i];
-		clk = tegra_clk_register_periph(data->name, data->parent_names,
-				data->num_parents, &data->periph,
-				clk_base, data->offset, data->flags);
-		clks[data->clk_id] = clk;
+		reg_bank = get_reg_bank(data->periph.gate.clk_num);
+
+		if (reg_bank >= 0) {
+			data->periph.gate.regs = &periph_regs[reg_bank];
+			clk = tegra_clk_register_periph(data->name,
+				data->parent_names, data->num_parents,
+				&data->periph, clk_base, data->offset,
+				data->flags);
+			clks[data->clk_id] = clk;
+		}
 	}
 
 	for (i = 0; i < ARRAY_SIZE(tegra_periph_nodiv_clk_list); i++) {
+		int reg_bank;
+
 		data = &tegra_periph_nodiv_clk_list[i];
-		clk = tegra_clk_register_periph_nodiv(data->name,
+		reg_bank = get_reg_bank(data->periph.gate.clk_num);
+
+		if (reg_bank >= 0) {
+			data->periph.gate.regs = &periph_regs[reg_bank];
+			clk = tegra_clk_register_periph_nodiv(data->name,
 				data->parent_names, data->num_parents,
 				&data->periph, clk_base, data->offset);
-		clks[data->clk_id] = clk;
+			clks[data->clk_id] = clk;
+		}
 	}
 }
 
-- 
1.7.7.rc0.72.g4b5ea.dirty

