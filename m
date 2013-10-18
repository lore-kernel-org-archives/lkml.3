Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab3JRN3E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 09:29:04 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:1407 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695Ab3JRNZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 09:25:35 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 18 Oct 2013 06:21:04 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 02/15] clk: tegra: simplify periph clock data
Date: Fri, 18 Oct 2013 16:25:06 +0300
Message-ID: <1382102719-5531-3-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1382102719-5531-1-git-send-email-pdeschrijver@nvidia.com>
References: <1382102719-5531-1-git-send-email-pdeschrijver@nvidia.com>
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
 drivers/clk/tegra/clk-periph-gate.c |    8 +-
 drivers/clk/tegra/clk-periph.c      |    6 +
 drivers/clk/tegra/clk-tegra114.c    |  376 +++++++++++++----------------------
 drivers/clk/tegra/clk-tegra20.c     |  220 ++++++++-------------
 drivers/clk/tegra/clk-tegra30.c     |  317 +++++++++++-------------------
 drivers/clk/tegra/clk.c             |  104 ++++++++++
 drivers/clk/tegra/clk.h             |   17 +-
 7 files changed, 464 insertions(+), 584 deletions(-)

diff --git a/drivers/clk/tegra/clk-periph-gate.c b/drivers/clk/tegra/clk-periph-gate.c
index bafee98..f38f33e 100644
--- a/drivers/clk/tegra/clk-periph-gate.c
+++ b/drivers/clk/tegra/clk-periph-gate.c
@@ -151,12 +151,16 @@ const struct clk_ops tegra_clk_periph_gate_ops = {
 
 struct clk *tegra_clk_register_periph_gate(const char *name,
 		const char *parent_name, u8 gate_flags, void __iomem *clk_base,
-		unsigned long flags, int clk_num,
-		struct tegra_clk_periph_regs *pregs, int *enable_refcnt)
+		unsigned long flags, int clk_num, int *enable_refcnt)
 {
 	struct tegra_clk_periph_gate *gate;
 	struct clk *clk;
 	struct clk_init_data init;
+	struct tegra_clk_periph_regs *pregs;
+
+	pregs = get_reg_bank(clk_num);
+	if (!pregs)
+		return ERR_PTR(-EINVAL);
 
 	gate = kzalloc(sizeof(*gate), GFP_KERNEL);
 	if (!gate) {
diff --git a/drivers/clk/tegra/clk-periph.c b/drivers/clk/tegra/clk-periph.c
index b2309d3..735b024 100644
--- a/drivers/clk/tegra/clk-periph.c
+++ b/drivers/clk/tegra/clk-periph.c
@@ -178,6 +178,7 @@ static struct clk *_tegra_clk_register_periph(const char *name,
 {
 	struct clk *clk;
 	struct clk_init_data init;
+	struct tegra_clk_periph_regs *bank;
 
 	init.name = name;
 	init.ops = div ? &tegra_clk_periph_ops : &tegra_clk_periph_nodiv_ops;
@@ -185,12 +186,17 @@ static struct clk *_tegra_clk_register_periph(const char *name,
 	init.parent_names = parent_names;
 	init.num_parents = num_parents;
 
+	bank = get_reg_bank(periph->gate.clk_num);
+	if (!bank)
+		return ERR_PTR(-EINVAL);
+
 	/* Data in .init is copied by clk_register(), so stack variable OK */
 	periph->hw.init = &init;
 	periph->magic = TEGRA_CLK_PERIPH_MAGIC;
 	periph->mux.reg = clk_base + offset;
 	periph->divider.reg = div ? (clk_base + offset) : NULL;
 	periph->gate.clk_base = clk_base;
+	periph->gate.regs = bank;
 
 	clk = clk_register(NULL, &periph->hw);
 	if (IS_ERR(clk))
diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index d774ea3..e909d80 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -27,27 +27,10 @@
 
 #include "clk.h"
 
-#define RST_DEVICES_L			0x004
-#define RST_DEVICES_H			0x008
-#define RST_DEVICES_U			0x00C
 #define RST_DFLL_DVCO			0x2F4
-#define RST_DEVICES_V			0x358
-#define RST_DEVICES_W			0x35C
-#define RST_DEVICES_X			0x28C
-#define RST_DEVICES_SET_L		0x300
-#define RST_DEVICES_CLR_L		0x304
-#define RST_DEVICES_SET_H		0x308
-#define RST_DEVICES_CLR_H		0x30c
-#define RST_DEVICES_SET_U		0x310
-#define RST_DEVICES_CLR_U		0x314
-#define RST_DEVICES_SET_V		0x430
-#define RST_DEVICES_CLR_V		0x434
-#define RST_DEVICES_SET_W		0x438
-#define RST_DEVICES_CLR_W		0x43c
 #define CPU_FINETRIM_SELECT		0x4d4	/* override default prop dlys */
 #define CPU_FINETRIM_DR			0x4d8	/* rise->rise prop dly A */
 #define CPU_FINETRIM_R			0x4e4	/* rise->rise prop dly inc A */
-#define RST_DEVICES_NUM			5
 
 /* RST_DFLL_DVCO bitfields */
 #define DVFS_DFLL_RESET_SHIFT		0
@@ -74,26 +57,10 @@
 #define CPU_FINETRIM_R_FCPU_6_SHIFT	10		/* ftop */
 #define CPU_FINETRIM_R_FCPU_6_MASK	(0x3 << CPU_FINETRIM_R_FCPU_6_SHIFT)
 
-#define CLK_OUT_ENB_L			0x010
-#define CLK_OUT_ENB_H			0x014
-#define CLK_OUT_ENB_U			0x018
-#define CLK_OUT_ENB_V			0x360
-#define CLK_OUT_ENB_W			0x364
-#define CLK_OUT_ENB_X			0x280
-#define CLK_OUT_ENB_SET_L		0x320
-#define CLK_OUT_ENB_CLR_L		0x324
-#define CLK_OUT_ENB_SET_H		0x328
-#define CLK_OUT_ENB_CLR_H		0x32c
-#define CLK_OUT_ENB_SET_U		0x330
-#define CLK_OUT_ENB_CLR_U		0x334
-#define CLK_OUT_ENB_SET_V		0x440
-#define CLK_OUT_ENB_CLR_V		0x444
-#define CLK_OUT_ENB_SET_W		0x448
-#define CLK_OUT_ENB_CLR_W		0x44c
-#define CLK_OUT_ENB_SET_X		0x284
-#define CLK_OUT_ENB_CLR_X		0x288
 #define CLK_OUT_ENB_NUM			6
 
+#define TEGRA114_CLK_PERIPH_BANKS	5
+
 #define PLLC_BASE 0x80
 #define PLLC_MISC2 0x88
 #define PLLC_MISC 0x8c
@@ -728,53 +695,6 @@ static struct tegra_clk_pll_params pll_re_vco_params = {
 	.div_nmp = &pllre_nmp,
 };
 
-/* Peripheral clock registers */
-
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
-};
-
 /* possible OSC frequencies in Hz */
 static unsigned long tegra114_input_freq[] = {
 	[0] = 13000000,
@@ -789,72 +709,72 @@ static unsigned long tegra114_input_freq[] = {
 #define MASK(x) (BIT(x) - 1)
 
 #define TEGRA_INIT_DATA_MUX(_name, _con_id, _dev_id, _parents, _offset,	\
-			    _clk_num, _regs, _gate_flags, _clk_id)	\
+			    _clk_num, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
-			30, MASK(2), 0, 0, 8, 1, 0, _regs, _clk_num,	\
+			30, MASK(2), 0, 0, 8, 1, 0, _clk_num,		\
 			periph_clk_enb_refcnt, _gate_flags, _clk_id,	\
 			_parents##_idx, 0)
 
 #define TEGRA_INIT_DATA_MUX_FLAGS(_name, _con_id, _dev_id, _parents, _offset,\
-			    _clk_num, _regs, _gate_flags, _clk_id, flags)\
+			    _clk_num, _gate_flags, _clk_id, flags)\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
-			30, MASK(2), 0, 0, 8, 1, 0, _regs, _clk_num,	\
+			30, MASK(2), 0, 0, 8, 1, 0, _clk_num,	\
 			periph_clk_enb_refcnt, _gate_flags, _clk_id,	\
 			_parents##_idx, flags)
 
 #define TEGRA_INIT_DATA_MUX8(_name, _con_id, _dev_id, _parents, _offset, \
-			     _clk_num, _regs, _gate_flags, _clk_id)	\
+			     _clk_num, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
-			29, MASK(3), 0, 0, 8, 1, 0, _regs, _clk_num,	\
+			29, MASK(3), 0, 0, 8, 1, 0, _clk_num,	\
 			periph_clk_enb_refcnt, _gate_flags, _clk_id,	\
 			_parents##_idx, 0)
 
 #define TEGRA_INIT_DATA_INT_FLAGS(_name, _con_id, _dev_id, _parents, _offset,\
-			    _clk_num, _regs, _gate_flags, _clk_id, flags)\
+			    _clk_num, _gate_flags, _clk_id, flags)\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
-			30, MASK(2), 0, 0, 8, 1, TEGRA_DIVIDER_INT, _regs,\
+			30, MASK(2), 0, 0, 8, 1, TEGRA_DIVIDER_INT, \
 			_clk_num, periph_clk_enb_refcnt, _gate_flags,	\
 			_clk_id, _parents##_idx, flags)
 
 #define TEGRA_INIT_DATA_INT8(_name, _con_id, _dev_id, _parents, _offset,\
-			    _clk_num, _regs, _gate_flags, _clk_id)	\
+			    _clk_num, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
-			29, MASK(3), 0, 0, 8, 1, TEGRA_DIVIDER_INT, _regs,\
+			29, MASK(3), 0, 0, 8, 1, TEGRA_DIVIDER_INT, \
 			_clk_num, periph_clk_enb_refcnt, _gate_flags,	\
 			_clk_id, _parents##_idx, 0)
 
 #define TEGRA_INIT_DATA_UART(_name, _con_id, _dev_id, _parents, _offset,\
-			     _clk_num, _regs, _clk_id)			\
+			     _clk_num, _clk_id)			\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
-			30, MASK(2), 0, 0, 16, 1, TEGRA_DIVIDER_UART, _regs,\
+			30, MASK(2), 0, 0, 16, 1, TEGRA_DIVIDER_UART, \
 			_clk_num, periph_clk_enb_refcnt, 0, _clk_id,	\
 			_parents##_idx, 0)
 
 #define TEGRA_INIT_DATA_I2C(_name, _con_id, _dev_id, _parents, _offset,\
-			     _clk_num, _regs, _clk_id)			\
+			     _clk_num, _clk_id)			\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
-			30, MASK(2), 0, 0, 16, 0, 0, _regs, _clk_num,	\
+			30, MASK(2), 0, 0, 16, 0, 0, _clk_num,	\
 			periph_clk_enb_refcnt, 0, _clk_id, _parents##_idx, 0)
 
 #define TEGRA_INIT_DATA_NODIV(_name, _con_id, _dev_id, _parents, _offset, \
-			      _mux_shift, _mux_mask, _clk_num, _regs,	\
+			      _mux_shift, _mux_mask, _clk_num, \
 			      _gate_flags, _clk_id)			\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
-			_mux_shift, _mux_mask, 0, 0, 0, 0, 0, _regs,	\
+			_mux_shift, _mux_mask, 0, 0, 0, 0, 0,\
 			_clk_num, periph_clk_enb_refcnt, _gate_flags,	\
 			_clk_id, _parents##_idx, 0)
 
 #define TEGRA_INIT_DATA_XUSB(_name, _con_id, _dev_id, _parents, _offset, \
-			     _clk_num, _regs, _gate_flags, _clk_id)	 \
+			     _clk_num, _gate_flags, _clk_id)	 \
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset, \
-			29, MASK(3), 0, 0, 8, 1, TEGRA_DIVIDER_INT, _regs, \
+			29, MASK(3), 0, 0, 8, 1, TEGRA_DIVIDER_INT, \
 			_clk_num, periph_clk_enb_refcnt, _gate_flags,	 \
 			_clk_id, _parents##_idx, 0)
 
 #define TEGRA_INIT_DATA_AUDIO(_name, _con_id, _dev_id, _offset,  _clk_num,\
-				 _regs, _gate_flags, _clk_id)		\
+				 _gate_flags, _clk_id)		\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, mux_d_audio_clk,	\
-			_offset, 16, 0xE01F, 0, 0, 8, 1, 0, _regs, _clk_num, \
+			_offset, 16, 0xE01F, 0, 0, 8, 1, 0, _clk_num, \
 			periph_clk_enb_refcnt, _gate_flags , _clk_id,	\
 			mux_d_audio_clk_idx, 0)
 
@@ -1607,7 +1527,7 @@ static void __init tegra114_audio_clk_init(void __iomem *clk_base)
 				0, &clk_doubler_lock);
 	clk = tegra_clk_register_periph_gate("audio0_2x", "audio0_div",
 				  TEGRA_PERIPH_NO_RESET, clk_base,
-				  CLK_SET_RATE_PARENT, 113, &periph_v_regs,
+				  CLK_SET_RATE_PARENT, 113,
 				  periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "audio0_2x", NULL);
 	clks[TEGRA114_CLK_AUDIO0_2X] = clk;
@@ -1620,7 +1540,7 @@ static void __init tegra114_audio_clk_init(void __iomem *clk_base)
 				0, &clk_doubler_lock);
 	clk = tegra_clk_register_periph_gate("audio1_2x", "audio1_div",
 				  TEGRA_PERIPH_NO_RESET, clk_base,
-				  CLK_SET_RATE_PARENT, 114, &periph_v_regs,
+				  CLK_SET_RATE_PARENT, 114,
 				  periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "audio1_2x", NULL);
 	clks[TEGRA114_CLK_AUDIO1_2X] = clk;
@@ -1633,7 +1553,7 @@ static void __init tegra114_audio_clk_init(void __iomem *clk_base)
 				0, &clk_doubler_lock);
 	clk = tegra_clk_register_periph_gate("audio2_2x", "audio2_div",
 				  TEGRA_PERIPH_NO_RESET, clk_base,
-				  CLK_SET_RATE_PARENT, 115, &periph_v_regs,
+				  CLK_SET_RATE_PARENT, 115,
 				  periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "audio2_2x", NULL);
 	clks[TEGRA114_CLK_AUDIO2_2X] = clk;
@@ -1646,7 +1566,7 @@ static void __init tegra114_audio_clk_init(void __iomem *clk_base)
 				0, &clk_doubler_lock);
 	clk = tegra_clk_register_periph_gate("audio3_2x", "audio3_div",
 				  TEGRA_PERIPH_NO_RESET, clk_base,
-				  CLK_SET_RATE_PARENT, 116, &periph_v_regs,
+				  CLK_SET_RATE_PARENT, 116,
 				  periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "audio3_2x", NULL);
 	clks[TEGRA114_CLK_AUDIO3_2X] = clk;
@@ -1659,7 +1579,7 @@ static void __init tegra114_audio_clk_init(void __iomem *clk_base)
 				0, &clk_doubler_lock);
 	clk = tegra_clk_register_periph_gate("audio4_2x", "audio4_div",
 				  TEGRA_PERIPH_NO_RESET, clk_base,
-				  CLK_SET_RATE_PARENT, 117, &periph_v_regs,
+				  CLK_SET_RATE_PARENT, 117,
 				  periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "audio4_2x", NULL);
 	clks[TEGRA114_CLK_AUDIO4_2X] = clk;
@@ -1673,7 +1593,7 @@ static void __init tegra114_audio_clk_init(void __iomem *clk_base)
 	clk = tegra_clk_register_periph_gate("spdif_2x", "spdif_div",
 				  TEGRA_PERIPH_NO_RESET, clk_base,
 				  CLK_SET_RATE_PARENT, 118,
-				  &periph_v_regs, periph_clk_enb_refcnt);
+				  periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "spdif_2x", NULL);
 	clks[TEGRA114_CLK_SPDIF_2X] = clk;
 }
@@ -1800,86 +1720,86 @@ static void __init tegra114_super_clk_init(void __iomem *clk_base)
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
-	TEGRA_INIT_DATA_MUX8("sbc1", NULL, "tegra11-spi.0", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SBC1, 41, &periph_h_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC1),
-	TEGRA_INIT_DATA_MUX8("sbc2", NULL, "tegra11-spi.1", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SBC2, 44, &periph_h_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC2),
-	TEGRA_INIT_DATA_MUX8("sbc3", NULL, "tegra11-spi.2", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SBC3, 46, &periph_h_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC3),
-	TEGRA_INIT_DATA_MUX8("sbc4", NULL, "tegra11-spi.3", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SBC4, 68, &periph_u_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC4),
-	TEGRA_INIT_DATA_MUX8("sbc5", NULL, "tegra11-spi.4", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SBC5, 104, &periph_v_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC5),
-	TEGRA_INIT_DATA_MUX8("sbc6", NULL, "tegra11-spi.5", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SBC6, 105, &periph_v_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC6),
-	TEGRA_INIT_DATA_MUX8("ndflash", NULL, "tegra_nand", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_NDFLASH, 13, &periph_u_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_NDSPEED),
-	TEGRA_INIT_DATA_MUX8("ndspeed", NULL, "tegra_nand_speed", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_NDSPEED, 80, &periph_u_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_NDSPEED),
-	TEGRA_INIT_DATA_MUX("vfir", NULL, "vfir", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_VFIR, 7, &periph_l_regs, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_VFIR),
-	TEGRA_INIT_DATA_MUX("sdmmc1", NULL, "sdhci-tegra.0", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC1, 14, &periph_l_regs, 0, TEGRA114_CLK_SDMMC1),
-	TEGRA_INIT_DATA_MUX("sdmmc2", NULL, "sdhci-tegra.1", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC2, 9, &periph_l_regs, 0, TEGRA114_CLK_SDMMC2),
-	TEGRA_INIT_DATA_MUX("sdmmc3", NULL, "sdhci-tegra.2", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC3, 69, &periph_u_regs, 0, TEGRA114_CLK_SDMMC3),
-	TEGRA_INIT_DATA_MUX("sdmmc4", NULL, "sdhci-tegra.3", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC4, 15, &periph_l_regs, 0, TEGRA114_CLK_SDMMC4),
-	TEGRA_INIT_DATA_INT8("vde", NULL, "vde", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_VDE, 61, &periph_h_regs, 0, TEGRA114_CLK_VDE),
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
-	TEGRA_INIT_DATA_INT8("3d", NULL, "3d", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_3D, 24, &periph_l_regs, 0, TEGRA114_CLK_GR3D),
-	TEGRA_INIT_DATA_INT8("2d", NULL, "2d", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_2D, 21, &periph_l_regs, 0, TEGRA114_CLK_GR2D),
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
+	TEGRA_INIT_DATA_MUX8("sbc1", NULL, "tegra11-spi.0", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SBC1, 41, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC1),
+	TEGRA_INIT_DATA_MUX8("sbc2", NULL, "tegra11-spi.1", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SBC2, 44, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC2),
+	TEGRA_INIT_DATA_MUX8("sbc3", NULL, "tegra11-spi.2", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SBC3, 46, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC3),
+	TEGRA_INIT_DATA_MUX8("sbc4", NULL, "tegra11-spi.3", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SBC4, 68, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC4),
+	TEGRA_INIT_DATA_MUX8("sbc5", NULL, "tegra11-spi.4", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SBC5, 104, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC5),
+	TEGRA_INIT_DATA_MUX8("sbc6", NULL, "tegra11-spi.5", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_SBC6, 105, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_SBC6),
+	TEGRA_INIT_DATA_MUX8("ndflash", NULL, "tegra_nand", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_NDFLASH, 13, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_NDSPEED),
+	TEGRA_INIT_DATA_MUX8("ndspeed", NULL, "tegra_nand_speed", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_NDSPEED, 80, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_NDSPEED),
+	TEGRA_INIT_DATA_MUX("vfir", NULL, "vfir", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_VFIR, 7, TEGRA_PERIPH_ON_APB, TEGRA114_CLK_VFIR),
+	TEGRA_INIT_DATA_MUX("sdmmc1", NULL, "sdhci-tegra.0", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC1, 14, 0, TEGRA114_CLK_SDMMC1),
+	TEGRA_INIT_DATA_MUX("sdmmc2", NULL, "sdhci-tegra.1", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC2, 9, 0, TEGRA114_CLK_SDMMC2),
+	TEGRA_INIT_DATA_MUX("sdmmc3", NULL, "sdhci-tegra.2", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC3, 69, 0, TEGRA114_CLK_SDMMC3),
+	TEGRA_INIT_DATA_MUX("sdmmc4", NULL, "sdhci-tegra.3", mux_pllp_pllc_pllm_clkm, CLK_SOURCE_SDMMC4, 15, 0, TEGRA114_CLK_SDMMC4),
+	TEGRA_INIT_DATA_INT8("vde", NULL, "vde", mux_pllp_pllc2_c_c3_pllm_clkm, CLK_SOURCE_VDE, 61, 0, TEGRA114_CLK_VDE),
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
+	TEGRA_INIT_DATA_INT8("3d", NULL, "3d", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_3D, 24, 0, TEGRA114_CLK_GR3D),
+	TEGRA_INIT_DATA_INT8("2d", NULL, "2d", mux_pllm_pllc2_c_c3_pllp_plla, CLK_SOURCE_2D, 21, 0, TEGRA114_CLK_GR2D),
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
@@ -1891,16 +1811,14 @@ static __init void tegra114_periph_clk_init(void __iomem *clk_base)
 
 	/* apbdma */
 	clk = tegra_clk_register_periph_gate("apbdma", "clk_m", 0, clk_base,
-				  0, 34, &periph_h_regs,
-				  periph_clk_enb_refcnt);
+				  0, 34, periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_APBDMA] = clk;
 
 	/* rtc */
 	clk = tegra_clk_register_periph_gate("rtc", "clk_32k",
 				    TEGRA_PERIPH_ON_APB |
 				    TEGRA_PERIPH_NO_RESET, clk_base,
-				    0, 4, &periph_l_regs,
-				    periph_clk_enb_refcnt);
+				    0, 4, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "rtc-tegra");
 	clks[TEGRA114_CLK_RTC] = clk;
 
@@ -1908,123 +1826,112 @@ static __init void tegra114_periph_clk_init(void __iomem *clk_base)
 	clk = tegra_clk_register_periph_gate("kbc", "clk_32k",
 				    TEGRA_PERIPH_ON_APB |
 				    TEGRA_PERIPH_NO_RESET, clk_base,
-				    0, 36, &periph_h_regs,
-				    periph_clk_enb_refcnt);
+				    0, 36, periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_KBC] = clk;
 
 	/* timer */
 	clk = tegra_clk_register_periph_gate("timer", "clk_m", 0, clk_base,
-				  0, 5, &periph_l_regs,
-				  periph_clk_enb_refcnt);
+				  0, 5, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "timer");
 	clks[TEGRA114_CLK_TIMER] = clk;
 
 	/* kfuse */
 	clk = tegra_clk_register_periph_gate("kfuse", "clk_m",
 				  TEGRA_PERIPH_ON_APB, clk_base,  0, 40,
-				  &periph_h_regs, periph_clk_enb_refcnt);
+				  periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_KFUSE] = clk;
 
 	/* fuse */
 	clk = tegra_clk_register_periph_gate("fuse", "clk_m",
 				  TEGRA_PERIPH_ON_APB, clk_base,  0, 39,
-				  &periph_h_regs, periph_clk_enb_refcnt);
+				  periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_FUSE] = clk;
 
 	/* fuse_burn */
 	clk = tegra_clk_register_periph_gate("fuse_burn", "clk_m",
 				  TEGRA_PERIPH_ON_APB, clk_base,  0, 39,
-				  &periph_h_regs, periph_clk_enb_refcnt);
+				  periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_FUSE_BURN] = clk;
 
 	/* apbif */
 	clk = tegra_clk_register_periph_gate("apbif", "clk_m",
 				  TEGRA_PERIPH_ON_APB, clk_base,  0, 107,
-				  &periph_v_regs, periph_clk_enb_refcnt);
+				  periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_APBIF] = clk;
 
 	/* hda2hdmi */
 	clk = tegra_clk_register_periph_gate("hda2hdmi", "clk_m",
 				    TEGRA_PERIPH_ON_APB, clk_base,  0, 128,
-				    &periph_w_regs, periph_clk_enb_refcnt);
+				    periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_HDA2HDMI] = clk;
 
 	/* vcp */
 	clk = tegra_clk_register_periph_gate("vcp", "clk_m", 0, clk_base,  0,
-				  29, &periph_l_regs,
-				  periph_clk_enb_refcnt);
+				  29, periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_VCP] = clk;
 
 	/* bsea */
 	clk = tegra_clk_register_periph_gate("bsea", "clk_m", 0, clk_base,
-				  0, 62, &periph_h_regs,
-				  periph_clk_enb_refcnt);
+				  0, 62, periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_BSEA] = clk;
 
 	/* bsev */
 	clk = tegra_clk_register_periph_gate("bsev", "clk_m", 0, clk_base,
-				  0, 63, &periph_h_regs,
-				  periph_clk_enb_refcnt);
+				  0, 63, periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_BSEV] = clk;
 
 	/* mipi-cal */
 	clk = tegra_clk_register_periph_gate("mipi-cal", "clk_m", 0, clk_base,
-				   0, 56, &periph_h_regs,
-				  periph_clk_enb_refcnt);
+				   0, 56, periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_MIPI_CAL] = clk;
 
 	/* usbd */
 	clk = tegra_clk_register_periph_gate("usbd", "clk_m", 0, clk_base,
-				  0, 22, &periph_l_regs,
-				  periph_clk_enb_refcnt);
+				  0, 22, periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_USBD] = clk;
 
 	/* usb2 */
 	clk = tegra_clk_register_periph_gate("usb2", "clk_m", 0, clk_base,
-				  0, 58, &periph_h_regs,
-				  periph_clk_enb_refcnt);
+				  0, 58, periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_USB2] = clk;
 
 	/* usb3 */
 	clk = tegra_clk_register_periph_gate("usb3", "clk_m", 0, clk_base,
-				  0, 59, &periph_h_regs,
-				  periph_clk_enb_refcnt);
+				  0, 59, periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_USB3] = clk;
 
 	/* csi */
 	clk = tegra_clk_register_periph_gate("csi", "pll_p_out3", 0, clk_base,
-				   0, 52, &periph_h_regs,
-				  periph_clk_enb_refcnt);
+				   0, 52, periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_CSI] = clk;
 
 	/* isp */
 	clk = tegra_clk_register_periph_gate("isp", "clk_m", 0, clk_base, 0,
-				  23, &periph_l_regs,
-				  periph_clk_enb_refcnt);
+				  23, periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_ISP] = clk;
 
 	/* csus */
 	clk = tegra_clk_register_periph_gate("csus", "clk_m",
 				  TEGRA_PERIPH_NO_RESET, clk_base, 0, 92,
-				  &periph_u_regs, periph_clk_enb_refcnt);
+				  periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_CSUS] = clk;
 
 	/* dds */
 	clk = tegra_clk_register_periph_gate("dds", "clk_m",
 				  TEGRA_PERIPH_ON_APB, clk_base, 0, 150,
-				  &periph_w_regs, periph_clk_enb_refcnt);
+				  periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_DDS] = clk;
 
 	/* dp2 */
 	clk = tegra_clk_register_periph_gate("dp2", "clk_m",
 				  TEGRA_PERIPH_ON_APB, clk_base, 0, 152,
-				  &periph_w_regs, periph_clk_enb_refcnt);
+				  periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_DP2] = clk;
 
 	/* dtv */
 	clk = tegra_clk_register_periph_gate("dtv", "clk_m",
 				    TEGRA_PERIPH_ON_APB, clk_base, 0, 79,
-				    &periph_u_regs, periph_clk_enb_refcnt);
+				    periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_DTV] = clk;
 
 	/* dsia */
@@ -2034,8 +1941,7 @@ static __init void tegra114_periph_clk_init(void __iomem *clk_base)
 			       clk_base + PLLD_BASE, 25, 1, 0, &pll_d_lock);
 	clks[TEGRA114_CLK_DSIA_MUX] = clk;
 	clk = tegra_clk_register_periph_gate("dsia", "dsia_mux", 0, clk_base,
-				    0, 48, &periph_h_regs,
-				    periph_clk_enb_refcnt);
+				    0, 48, periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_DSIA] = clk;
 
 	/* dsib */
@@ -2045,8 +1951,7 @@ static __init void tegra114_periph_clk_init(void __iomem *clk_base)
 			       clk_base + PLLD2_BASE, 25, 1, 0, &pll_d2_lock);
 	clks[TEGRA114_CLK_DSIB_MUX] = clk;
 	clk = tegra_clk_register_periph_gate("dsib", "dsib_mux", 0, clk_base,
-				    0, 82, &periph_u_regs,
-				    periph_clk_enb_refcnt);
+				    0, 82, periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_DSIB] = clk;
 
 	/* xusb_hs_src */
@@ -2060,20 +1965,17 @@ static __init void tegra114_periph_clk_init(void __iomem *clk_base)
 
 	/* xusb_host */
 	clk = tegra_clk_register_periph_gate("xusb_host", "xusb_host_src", 0,
-				    clk_base, 0, 89, &periph_u_regs,
-				    periph_clk_enb_refcnt);
+				    clk_base, 0, 89, periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_XUSB_HOST] = clk;
 
 	/* xusb_ss */
 	clk = tegra_clk_register_periph_gate("xusb_ss", "xusb_ss_src", 0,
-				    clk_base, 0, 156, &periph_w_regs,
-				    periph_clk_enb_refcnt);
+				    clk_base, 0, 156, periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_XUSB_HOST] = clk;
 
 	/* xusb_dev */
 	clk = tegra_clk_register_periph_gate("xusb_dev", "xusb_dev_src", 0,
-				    clk_base, 0, 95, &periph_u_regs,
-				    periph_clk_enb_refcnt);
+				    clk_base, 0, 95, periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_XUSB_DEV] = clk;
 
 	/* emc */
@@ -2083,20 +1985,21 @@ static __init void tegra114_periph_clk_init(void __iomem *clk_base)
 			       clk_base + CLK_SOURCE_EMC,
 			       29, 3, 0, NULL);
 	clk = tegra_clk_register_periph_gate("emc", "emc_mux", 0, clk_base,
-				CLK_IGNORE_UNUSED, 57, &periph_h_regs,
-				periph_clk_enb_refcnt);
+				CLK_IGNORE_UNUSED, 57, periph_clk_enb_refcnt);
 	clks[TEGRA114_CLK_EMC] = clk;
 
 	for (i = 0; i < ARRAY_SIZE(tegra_periph_clk_list); i++) {
 		data = &tegra_periph_clk_list[i];
-		clk = tegra_clk_register_periph(data->name, data->parent_names,
-				data->num_parents, &data->periph,
-				clk_base, data->offset, data->flags);
+
+		clk = tegra_clk_register_periph(data->name,
+			data->parent_names, data->num_parents, &data->periph,
+			clk_base, data->offset, data->flags);
 		clks[data->clk_id] = clk;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(tegra_periph_nodiv_clk_list); i++) {
 		data = &tegra_periph_nodiv_clk_list[i];
+
 		clk = tegra_clk_register_periph_nodiv(data->name,
 				data->parent_names, data->num_parents,
 				&data->periph, clk_base, data->offset);
@@ -2346,6 +2249,9 @@ static void __init tegra114_clock_init(struct device_node *np)
 	if (tegra114_osc_clk_init(clk_base) < 0)
 		return;
 
+	if (tegra_clk_set_periph_banks(TEGRA114_CLK_PERIPH_BANKS) < 0)
+		return;
+
 	tegra114_fixed_clk_init(clk_base);
 	tegra114_pll_init(clk_base, pmc_base);
 	tegra114_periph_clk_init(clk_base);
diff --git a/drivers/clk/tegra/clk-tegra20.c b/drivers/clk/tegra/clk-tegra20.c
index 056f649..929a462 100644
--- a/drivers/clk/tegra/clk-tegra20.c
+++ b/drivers/clk/tegra/clk-tegra20.c
@@ -25,26 +25,6 @@
 
 #include "clk.h"
 
-#define RST_DEVICES_L 0x004
-#define RST_DEVICES_H 0x008
-#define RST_DEVICES_U 0x00c
-#define RST_DEVICES_SET_L 0x300
-#define RST_DEVICES_CLR_L 0x304
-#define RST_DEVICES_SET_H 0x308
-#define RST_DEVICES_CLR_H 0x30c
-#define RST_DEVICES_SET_U 0x310
-#define RST_DEVICES_CLR_U 0x314
-#define RST_DEVICES_NUM 3
-
-#define CLK_OUT_ENB_L 0x010
-#define CLK_OUT_ENB_H 0x014
-#define CLK_OUT_ENB_U 0x018
-#define CLK_OUT_ENB_SET_L 0x320
-#define CLK_OUT_ENB_CLR_L 0x324
-#define CLK_OUT_ENB_SET_H 0x328
-#define CLK_OUT_ENB_CLR_H 0x32c
-#define CLK_OUT_ENB_SET_U 0x330
-#define CLK_OUT_ENB_CLR_U 0x334
 #define CLK_OUT_ENB_NUM 3
 
 #define OSC_CTRL 0x50
@@ -67,6 +47,8 @@
 #define OSC_FREQ_DET_BUSY (1<<31)
 #define OSC_FREQ_DET_CNT_MASK 0xFFFF
 
+#define TEGRA20_CLK_PERIPH_BANKS	3
+
 #define PLLS_BASE 0xf0
 #define PLLS_MISC 0xf4
 #define PLLC_BASE 0x80
@@ -197,31 +179,31 @@ static DEFINE_SPINLOCK(pll_div_lock);
 static DEFINE_SPINLOCK(sysrate_lock);
 
 #define TEGRA_INIT_DATA_MUX(_name, _con_id, _dev_id, _parents, _offset,	\
-			    _clk_num, _regs, _gate_flags, _clk_id)	\
+			    _clk_num, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
 			30, 2, 0, 0, 8, 1, TEGRA_DIVIDER_ROUND_UP,	\
-			_regs, _clk_num, periph_clk_enb_refcnt,		\
+			_clk_num, periph_clk_enb_refcnt,		\
 			_gate_flags, _clk_id)
 
 #define TEGRA_INIT_DATA_INT(_name, _con_id, _dev_id, _parents, _offset,	\
-			    _clk_num, _regs, _gate_flags, _clk_id)	\
+			    _clk_num, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
-			30, 2, 0, 0, 8, 1, TEGRA_DIVIDER_INT, _regs,	\
+			30, 2, 0, 0, 8, 1, TEGRA_DIVIDER_INT, \
 			_clk_num, periph_clk_enb_refcnt, _gate_flags,	\
 			_clk_id)
 
 #define TEGRA_INIT_DATA_DIV16(_name, _con_id, _dev_id, _parents, _offset, \
-			      _clk_num, _regs, _gate_flags, _clk_id)	\
+			      _clk_num, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
-			30, 2, 0, 0, 16, 0, TEGRA_DIVIDER_ROUND_UP, _regs, \
+			30, 2, 0, 0, 16, 0, TEGRA_DIVIDER_ROUND_UP, \
 			_clk_num, periph_clk_enb_refcnt, _gate_flags,	\
 			_clk_id)
 
 #define TEGRA_INIT_DATA_NODIV(_name, _con_id, _dev_id, _parents, _offset, \
-			      _mux_shift, _mux_width, _clk_num, _regs,	\
+			      _mux_shift, _mux_width, _clk_num, \
 			      _gate_flags, _clk_id)			\
 	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
-			_mux_shift, _mux_width, 0, 0, 0, 0, 0, _regs,	\
+			_mux_shift, _mux_width, 0, 0, 0, 0, 0, \
 			_clk_num, periph_clk_enb_refcnt, _gate_flags,	\
 			_clk_id)
 
@@ -490,34 +472,6 @@ static struct tegra_clk_pll_params pll_e_params = {
 	.lock_delay = 0,
 };
 
-/* Peripheral clock registers */
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
 static unsigned long tegra20_clk_measure_input_freq(void)
 {
 	u32 osc_ctrl = readl_relaxed(clk_base + OSC_CTRL);
@@ -792,7 +746,7 @@ static void __init tegra20_audio_clk_init(void)
 					CLK_SET_RATE_PARENT, 2, 1);
 	clk = tegra_clk_register_periph_gate("audio_2x", "audio_doubler",
 				    TEGRA_PERIPH_NO_RESET, clk_base,
-				    CLK_SET_RATE_PARENT, 89, &periph_u_regs,
+				    CLK_SET_RATE_PARENT, 89,
 				    periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "audio_2x", NULL);
 	clks[audio_2x] = clk;
@@ -815,56 +769,56 @@ static const char *mux_pllpdc_clkm[] = {"pll_p", "pll_d_out0", "pll_c",
 static const char *mux_pllmcp_clkm[] = {"pll_m", "pll_c", "pll_p", "clk_m"};
 
 static struct tegra_periph_init_data tegra_periph_clk_list[] = {
-	TEGRA_INIT_DATA_MUX("i2s1",	NULL,		"tegra20-i2s.0", i2s1_parents,	    CLK_SOURCE_I2S1,	  11,	&periph_l_regs, TEGRA_PERIPH_ON_APB, i2s1),
-	TEGRA_INIT_DATA_MUX("i2s2",	NULL,		"tegra20-i2s.1", i2s2_parents,	    CLK_SOURCE_I2S2,	  18,	&periph_l_regs, TEGRA_PERIPH_ON_APB, i2s2),
-	TEGRA_INIT_DATA_MUX("spdif_out", "spdif_out",	"tegra20-spdif", spdif_out_parents, CLK_SOURCE_SPDIF_OUT, 10,	&periph_l_regs, TEGRA_PERIPH_ON_APB, spdif_out),
-	TEGRA_INIT_DATA_MUX("spdif_in",	"spdif_in",	"tegra20-spdif", spdif_in_parents,  CLK_SOURCE_SPDIF_IN,  10,	&periph_l_regs, TEGRA_PERIPH_ON_APB, spdif_in),
-	TEGRA_INIT_DATA_MUX("sbc1",	NULL,		"spi_tegra.0",	 mux_pllpcm_clkm,   CLK_SOURCE_SBC1,	  41,	&periph_h_regs, TEGRA_PERIPH_ON_APB, sbc1),
-	TEGRA_INIT_DATA_MUX("sbc2",	NULL,		"spi_tegra.1",	 mux_pllpcm_clkm,   CLK_SOURCE_SBC2,	  44,	&periph_h_regs, TEGRA_PERIPH_ON_APB, sbc2),
-	TEGRA_INIT_DATA_MUX("sbc3",	NULL,		"spi_tegra.2",	 mux_pllpcm_clkm,   CLK_SOURCE_SBC3,	  46,	&periph_h_regs, TEGRA_PERIPH_ON_APB, sbc3),
-	TEGRA_INIT_DATA_MUX("sbc4",	NULL,		"spi_tegra.3",	 mux_pllpcm_clkm,   CLK_SOURCE_SBC4,	  68,	&periph_u_regs, TEGRA_PERIPH_ON_APB, sbc4),
-	TEGRA_INIT_DATA_MUX("spi",	NULL,		"spi",		 mux_pllpcm_clkm,   CLK_SOURCE_SPI,	  43,	&periph_h_regs, TEGRA_PERIPH_ON_APB, spi),
-	TEGRA_INIT_DATA_MUX("xio",	NULL,		"xio",		 mux_pllpcm_clkm,   CLK_SOURCE_XIO,	  45,	&periph_h_regs, 0, xio),
-	TEGRA_INIT_DATA_MUX("twc",	NULL,		"twc",		 mux_pllpcm_clkm,   CLK_SOURCE_TWC,	  16,	&periph_l_regs, TEGRA_PERIPH_ON_APB, twc),
-	TEGRA_INIT_DATA_MUX("ide",	NULL,		"ide",		 mux_pllpcm_clkm,   CLK_SOURCE_XIO,	  25,	&periph_l_regs, 0, ide),
-	TEGRA_INIT_DATA_MUX("ndflash",	NULL,		"tegra_nand",	 mux_pllpcm_clkm,   CLK_SOURCE_NDFLASH,	  13,	&periph_l_regs, 0, ndflash),
-	TEGRA_INIT_DATA_MUX("vfir",	NULL,		"vfir",		 mux_pllpcm_clkm,   CLK_SOURCE_VFIR,	  7,	&periph_l_regs, TEGRA_PERIPH_ON_APB, vfir),
-	TEGRA_INIT_DATA_MUX("csite",	NULL,		"csite",	 mux_pllpcm_clkm,   CLK_SOURCE_CSITE,	  73,	&periph_u_regs, 0, csite),
-	TEGRA_INIT_DATA_MUX("la",	NULL,		"la",		 mux_pllpcm_clkm,   CLK_SOURCE_LA,	  76,	&periph_u_regs, 0, la),
-	TEGRA_INIT_DATA_MUX("owr",	NULL,		"tegra_w1",	 mux_pllpcm_clkm,   CLK_SOURCE_OWR,	  71,	&periph_u_regs, TEGRA_PERIPH_ON_APB, owr),
-	TEGRA_INIT_DATA_MUX("mipi",	NULL,		"mipi",		 mux_pllpcm_clkm,   CLK_SOURCE_MIPI,	  50,	&periph_h_regs, TEGRA_PERIPH_ON_APB, mipi),
-	TEGRA_INIT_DATA_MUX("vde",	NULL,		"vde",		 mux_pllpcm_clkm,   CLK_SOURCE_VDE,	  61,	&periph_h_regs, 0, vde),
-	TEGRA_INIT_DATA_MUX("vi",	"vi",		"tegra_camera",	 mux_pllmcpa,	    CLK_SOURCE_VI,	  20,	&periph_l_regs, 0, vi),
-	TEGRA_INIT_DATA_MUX("epp",	NULL,		"epp",		 mux_pllmcpa,	    CLK_SOURCE_EPP,	  19,	&periph_l_regs, 0, epp),
-	TEGRA_INIT_DATA_MUX("mpe",	NULL,		"mpe",		 mux_pllmcpa,	    CLK_SOURCE_MPE,	  60,	&periph_h_regs, 0, mpe),
-	TEGRA_INIT_DATA_MUX("host1x",	NULL,		"host1x",	 mux_pllmcpa,	    CLK_SOURCE_HOST1X,	  28,	&periph_l_regs, 0, host1x),
-	TEGRA_INIT_DATA_MUX("3d",	NULL,		"3d",		 mux_pllmcpa,	    CLK_SOURCE_3D,	  24,	&periph_l_regs, TEGRA_PERIPH_MANUAL_RESET, gr3d),
-	TEGRA_INIT_DATA_MUX("2d",	NULL,		"2d",		 mux_pllmcpa,	    CLK_SOURCE_2D,	  21,	&periph_l_regs, 0, gr2d),
-	TEGRA_INIT_DATA_MUX("nor",	NULL,		"tegra-nor",	 mux_pllpcm_clkm,   CLK_SOURCE_NOR,	  42,	&periph_h_regs, 0, nor),
-	TEGRA_INIT_DATA_MUX("sdmmc1",	NULL,		"sdhci-tegra.0", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC1,	  14,	&periph_l_regs, 0, sdmmc1),
-	TEGRA_INIT_DATA_MUX("sdmmc2",	NULL,		"sdhci-tegra.1", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC2,	  9,	&periph_l_regs, 0, sdmmc2),
-	TEGRA_INIT_DATA_MUX("sdmmc3",	NULL,		"sdhci-tegra.2", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC3,	  69,	&periph_u_regs, 0, sdmmc3),
-	TEGRA_INIT_DATA_MUX("sdmmc4",	NULL,		"sdhci-tegra.3", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC4,	  15,	&periph_l_regs, 0, sdmmc4),
-	TEGRA_INIT_DATA_MUX("cve",	NULL,		"cve",		 mux_pllpdc_clkm,   CLK_SOURCE_CVE,	  49,	&periph_h_regs, 0, cve),
-	TEGRA_INIT_DATA_MUX("tvo",	NULL,		"tvo",		 mux_pllpdc_clkm,   CLK_SOURCE_TVO,	  49,	&periph_h_regs, 0, tvo),
-	TEGRA_INIT_DATA_MUX("tvdac",	NULL,		"tvdac",	 mux_pllpdc_clkm,   CLK_SOURCE_TVDAC,	  53,	&periph_h_regs, 0, tvdac),
-	TEGRA_INIT_DATA_MUX("vi_sensor", "vi_sensor",	"tegra_camera",	 mux_pllmcpa,	    CLK_SOURCE_VI_SENSOR, 20,	&periph_l_regs, TEGRA_PERIPH_NO_RESET, vi_sensor),
-	TEGRA_INIT_DATA_DIV16("i2c1",	"div-clk",	"tegra-i2c.0",	 mux_pllpcm_clkm,   CLK_SOURCE_I2C1,	  12,	&periph_l_regs, TEGRA_PERIPH_ON_APB, i2c1),
-	TEGRA_INIT_DATA_DIV16("i2c2",	"div-clk",	"tegra-i2c.1",	 mux_pllpcm_clkm,   CLK_SOURCE_I2C2,	  54,	&periph_h_regs, TEGRA_PERIPH_ON_APB, i2c2),
-	TEGRA_INIT_DATA_DIV16("i2c3",	"div-clk",	"tegra-i2c.2",	 mux_pllpcm_clkm,   CLK_SOURCE_I2C3,	  67,	&periph_u_regs,	TEGRA_PERIPH_ON_APB, i2c3),
-	TEGRA_INIT_DATA_DIV16("dvc",	"div-clk",	"tegra-i2c.3",	 mux_pllpcm_clkm,   CLK_SOURCE_DVC,	  47,	&periph_h_regs,	TEGRA_PERIPH_ON_APB, dvc),
-	TEGRA_INIT_DATA_MUX("hdmi",	NULL,		"hdmi",		 mux_pllpdc_clkm,   CLK_SOURCE_HDMI,	  51,	&periph_h_regs,	0, hdmi),
-	TEGRA_INIT_DATA("pwm",		NULL,		"tegra-pwm",	 pwm_parents,	    CLK_SOURCE_PWM,	  28, 3, 0, 0, 8, 1, 0, &periph_l_regs, 17, periph_clk_enb_refcnt, TEGRA_PERIPH_ON_APB, pwm),
+	TEGRA_INIT_DATA_MUX("i2s1",	NULL,		"tegra20-i2s.0", i2s1_parents,	    CLK_SOURCE_I2S1,	  11,	TEGRA_PERIPH_ON_APB, i2s1),
+	TEGRA_INIT_DATA_MUX("i2s2",	NULL,		"tegra20-i2s.1", i2s2_parents,	    CLK_SOURCE_I2S2,	  18,	TEGRA_PERIPH_ON_APB, i2s2),
+	TEGRA_INIT_DATA_MUX("spdif_out", "spdif_out",	"tegra20-spdif", spdif_out_parents, CLK_SOURCE_SPDIF_OUT, 10,	TEGRA_PERIPH_ON_APB, spdif_out),
+	TEGRA_INIT_DATA_MUX("spdif_in",	"spdif_in",	"tegra20-spdif", spdif_in_parents,  CLK_SOURCE_SPDIF_IN,  10,	TEGRA_PERIPH_ON_APB, spdif_in),
+	TEGRA_INIT_DATA_MUX("sbc1",	NULL,		"spi_tegra.0",	 mux_pllpcm_clkm,   CLK_SOURCE_SBC1,	  41,	TEGRA_PERIPH_ON_APB, sbc1),
+	TEGRA_INIT_DATA_MUX("sbc2",	NULL,		"spi_tegra.1",	 mux_pllpcm_clkm,   CLK_SOURCE_SBC2,	  44,	TEGRA_PERIPH_ON_APB, sbc2),
+	TEGRA_INIT_DATA_MUX("sbc3",	NULL,		"spi_tegra.2",	 mux_pllpcm_clkm,   CLK_SOURCE_SBC3,	  46,	TEGRA_PERIPH_ON_APB, sbc3),
+	TEGRA_INIT_DATA_MUX("sbc4",	NULL,		"spi_tegra.3",	 mux_pllpcm_clkm,   CLK_SOURCE_SBC4,	  68,	TEGRA_PERIPH_ON_APB, sbc4),
+	TEGRA_INIT_DATA_MUX("spi",	NULL,		"spi",		 mux_pllpcm_clkm,   CLK_SOURCE_SPI,	  43,	TEGRA_PERIPH_ON_APB, spi),
+	TEGRA_INIT_DATA_MUX("xio",	NULL,		"xio",		 mux_pllpcm_clkm,   CLK_SOURCE_XIO,	  45,	0, xio),
+	TEGRA_INIT_DATA_MUX("twc",	NULL,		"twc",		 mux_pllpcm_clkm,   CLK_SOURCE_TWC,	  16,	TEGRA_PERIPH_ON_APB, twc),
+	TEGRA_INIT_DATA_MUX("ide",	NULL,		"ide",		 mux_pllpcm_clkm,   CLK_SOURCE_XIO,	  25,	0, ide),
+	TEGRA_INIT_DATA_MUX("ndflash",	NULL,		"tegra_nand",	 mux_pllpcm_clkm,   CLK_SOURCE_NDFLASH,	  13,	0, ndflash),
+	TEGRA_INIT_DATA_MUX("vfir",	NULL,		"vfir",		 mux_pllpcm_clkm,   CLK_SOURCE_VFIR,	  7,	TEGRA_PERIPH_ON_APB, vfir),
+	TEGRA_INIT_DATA_MUX("csite",	NULL,		"csite",	 mux_pllpcm_clkm,   CLK_SOURCE_CSITE,	  73,	0, csite),
+	TEGRA_INIT_DATA_MUX("la",	NULL,		"la",		 mux_pllpcm_clkm,   CLK_SOURCE_LA,	  76,	0, la),
+	TEGRA_INIT_DATA_MUX("owr",	NULL,		"tegra_w1",	 mux_pllpcm_clkm,   CLK_SOURCE_OWR,	  71,	TEGRA_PERIPH_ON_APB, owr),
+	TEGRA_INIT_DATA_MUX("mipi",	NULL,		"mipi",		 mux_pllpcm_clkm,   CLK_SOURCE_MIPI,	  50,	TEGRA_PERIPH_ON_APB, mipi),
+	TEGRA_INIT_DATA_MUX("vde",	NULL,		"vde",		 mux_pllpcm_clkm,   CLK_SOURCE_VDE,	  61,	0, vde),
+	TEGRA_INIT_DATA_MUX("vi",	"vi",		"tegra_camera",	 mux_pllmcpa,	    CLK_SOURCE_VI,	  20,	0, vi),
+	TEGRA_INIT_DATA_MUX("epp",	NULL,		"epp",		 mux_pllmcpa,	    CLK_SOURCE_EPP,	  19,	0, epp),
+	TEGRA_INIT_DATA_MUX("mpe",	NULL,		"mpe",		 mux_pllmcpa,	    CLK_SOURCE_MPE,	  60,	0, mpe),
+	TEGRA_INIT_DATA_MUX("host1x",	NULL,		"host1x",	 mux_pllmcpa,	    CLK_SOURCE_HOST1X,	  28,	0, host1x),
+	TEGRA_INIT_DATA_MUX("3d",	NULL,		"3d",		 mux_pllmcpa,	    CLK_SOURCE_3D,	  24,	TEGRA_PERIPH_MANUAL_RESET, gr3d),
+	TEGRA_INIT_DATA_MUX("2d",	NULL,		"2d",		 mux_pllmcpa,	    CLK_SOURCE_2D,	  21,	0, gr2d),
+	TEGRA_INIT_DATA_MUX("nor",	NULL,		"tegra-nor",	 mux_pllpcm_clkm,   CLK_SOURCE_NOR,	  42,	0, nor),
+	TEGRA_INIT_DATA_MUX("sdmmc1",	NULL,		"sdhci-tegra.0", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC1,	  14,	0, sdmmc1),
+	TEGRA_INIT_DATA_MUX("sdmmc2",	NULL,		"sdhci-tegra.1", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC2,	  9,	0, sdmmc2),
+	TEGRA_INIT_DATA_MUX("sdmmc3",	NULL,		"sdhci-tegra.2", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC3,	  69,	0, sdmmc3),
+	TEGRA_INIT_DATA_MUX("sdmmc4",	NULL,		"sdhci-tegra.3", mux_pllpcm_clkm,   CLK_SOURCE_SDMMC4,	  15,	0, sdmmc4),
+	TEGRA_INIT_DATA_MUX("cve",	NULL,		"cve",		 mux_pllpdc_clkm,   CLK_SOURCE_CVE,	  49,	0, cve),
+	TEGRA_INIT_DATA_MUX("tvo",	NULL,		"tvo",		 mux_pllpdc_clkm,   CLK_SOURCE_TVO,	  49,	0, tvo),
+	TEGRA_INIT_DATA_MUX("tvdac",	NULL,		"tvdac",	 mux_pllpdc_clkm,   CLK_SOURCE_TVDAC,	  53,	0, tvdac),
+	TEGRA_INIT_DATA_MUX("vi_sensor", "vi_sensor",	"tegra_camera",	 mux_pllmcpa,	    CLK_SOURCE_VI_SENSOR, 20,	TEGRA_PERIPH_NO_RESET, vi_sensor),
+	TEGRA_INIT_DATA_DIV16("i2c1",	"div-clk",	"tegra-i2c.0",	 mux_pllpcm_clkm,   CLK_SOURCE_I2C1,	  12,	TEGRA_PERIPH_ON_APB, i2c1),
+	TEGRA_INIT_DATA_DIV16("i2c2",	"div-clk",	"tegra-i2c.1",	 mux_pllpcm_clkm,   CLK_SOURCE_I2C2,	  54,	TEGRA_PERIPH_ON_APB, i2c2),
+	TEGRA_INIT_DATA_DIV16("i2c3",	"div-clk",	"tegra-i2c.2",	 mux_pllpcm_clkm,   CLK_SOURCE_I2C3,	  67,	TEGRA_PERIPH_ON_APB, i2c3),
+	TEGRA_INIT_DATA_DIV16("dvc",	"div-clk",	"tegra-i2c.3",	 mux_pllpcm_clkm,   CLK_SOURCE_DVC,	  47,	TEGRA_PERIPH_ON_APB, dvc),
+	TEGRA_INIT_DATA_MUX("hdmi",	NULL,		"hdmi",		 mux_pllpdc_clkm,   CLK_SOURCE_HDMI,	  51,	0, hdmi),
+	TEGRA_INIT_DATA("pwm",		NULL,		"tegra-pwm",	 pwm_parents,	    CLK_SOURCE_PWM,	  28, 3, 0, 0, 8, 1, 0, 17, periph_clk_enb_refcnt, TEGRA_PERIPH_ON_APB, pwm),
 };
 
 static struct tegra_periph_init_data tegra_periph_nodiv_clk_list[] = {
-	TEGRA_INIT_DATA_NODIV("uarta",	NULL, "tegra_uart.0", mux_pllpcm_clkm, CLK_SOURCE_UARTA, 30, 2, 6,  &periph_l_regs, TEGRA_PERIPH_ON_APB, uarta),
-	TEGRA_INIT_DATA_NODIV("uartb",	NULL, "tegra_uart.1", mux_pllpcm_clkm, CLK_SOURCE_UARTB, 30, 2, 7,  &periph_l_regs, TEGRA_PERIPH_ON_APB, uartb),
-	TEGRA_INIT_DATA_NODIV("uartc",	NULL, "tegra_uart.2", mux_pllpcm_clkm, CLK_SOURCE_UARTC, 30, 2, 55, &periph_h_regs, TEGRA_PERIPH_ON_APB, uartc),
-	TEGRA_INIT_DATA_NODIV("uartd",	NULL, "tegra_uart.3", mux_pllpcm_clkm, CLK_SOURCE_UARTD, 30, 2, 65, &periph_u_regs, TEGRA_PERIPH_ON_APB, uartd),
-	TEGRA_INIT_DATA_NODIV("uarte",	NULL, "tegra_uart.4", mux_pllpcm_clkm, CLK_SOURCE_UARTE, 30, 2, 66, &periph_u_regs, TEGRA_PERIPH_ON_APB, uarte),
-	TEGRA_INIT_DATA_NODIV("disp1",	NULL, "tegradc.0",    mux_pllpdc_clkm, CLK_SOURCE_DISP1, 30, 2, 27, &periph_l_regs, 0, disp1),
-	TEGRA_INIT_DATA_NODIV("disp2",	NULL, "tegradc.1",    mux_pllpdc_clkm, CLK_SOURCE_DISP2, 30, 2, 26, &periph_l_regs, 0, disp2),
+	TEGRA_INIT_DATA_NODIV("uarta",	NULL, "tegra_uart.0", mux_pllpcm_clkm, CLK_SOURCE_UARTA, 30, 2, 6,  TEGRA_PERIPH_ON_APB, uarta),
+	TEGRA_INIT_DATA_NODIV("uartb",	NULL, "tegra_uart.1", mux_pllpcm_clkm, CLK_SOURCE_UARTB, 30, 2, 7,  TEGRA_PERIPH_ON_APB, uartb),
+	TEGRA_INIT_DATA_NODIV("uartc",	NULL, "tegra_uart.2", mux_pllpcm_clkm, CLK_SOURCE_UARTC, 30, 2, 55, TEGRA_PERIPH_ON_APB, uartc),
+	TEGRA_INIT_DATA_NODIV("uartd",	NULL, "tegra_uart.3", mux_pllpcm_clkm, CLK_SOURCE_UARTD, 30, 2, 65, TEGRA_PERIPH_ON_APB, uartd),
+	TEGRA_INIT_DATA_NODIV("uarte",	NULL, "tegra_uart.4", mux_pllpcm_clkm, CLK_SOURCE_UARTE, 30, 2, 66, TEGRA_PERIPH_ON_APB, uarte),
+	TEGRA_INIT_DATA_NODIV("disp1",	NULL, "tegradc.0",    mux_pllpdc_clkm, CLK_SOURCE_DISP1, 30, 2, 27, 0, disp1),
+	TEGRA_INIT_DATA_NODIV("disp2",	NULL, "tegradc.1",    mux_pllpdc_clkm, CLK_SOURCE_DISP2, 30, 2, 26, 0, disp2),
 };
 
 static void __init tegra20_periph_clk_init(void)
@@ -876,67 +830,58 @@ static void __init tegra20_periph_clk_init(void)
 	/* ac97 */
 	clk = tegra_clk_register_periph_gate("ac97", "pll_a_out0",
 				    TEGRA_PERIPH_ON_APB,
-				    clk_base, 0, 3, &periph_l_regs,
-				    periph_clk_enb_refcnt);
+				    clk_base, 0, 3, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "tegra20-ac97");
 	clks[ac97] = clk;
 
 	/* apbdma */
 	clk = tegra_clk_register_periph_gate("apbdma", "pclk", 0, clk_base,
-				    0, 34, &periph_h_regs,
-				    periph_clk_enb_refcnt);
+				    0, 34, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "tegra-apbdma");
 	clks[apbdma] = clk;
 
 	/* rtc */
 	clk = tegra_clk_register_periph_gate("rtc", "clk_32k",
 				    TEGRA_PERIPH_NO_RESET,
-				    clk_base, 0, 4, &periph_l_regs,
-				    periph_clk_enb_refcnt);
+				    clk_base, 0, 4, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "rtc-tegra");
 	clks[rtc] = clk;
 
 	/* timer */
 	clk = tegra_clk_register_periph_gate("timer", "clk_m", 0, clk_base,
-				    0, 5, &periph_l_regs,
-				    periph_clk_enb_refcnt);
+				    0, 5, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "timer");
 	clks[timer] = clk;
 
 	/* kbc */
 	clk = tegra_clk_register_periph_gate("kbc", "clk_32k",
 				    TEGRA_PERIPH_NO_RESET | TEGRA_PERIPH_ON_APB,
-				    clk_base, 0, 36, &periph_h_regs,
-				    periph_clk_enb_refcnt);
+				    clk_base, 0, 36, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "tegra-kbc");
 	clks[kbc] = clk;
 
 	/* csus */
 	clk = tegra_clk_register_periph_gate("csus", "clk_m",
 				    TEGRA_PERIPH_NO_RESET,
-				    clk_base, 0, 92, &periph_u_regs,
-				    periph_clk_enb_refcnt);
+				    clk_base, 0, 92, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "csus", "tengra_camera");
 	clks[csus] = clk;
 
 	/* vcp */
 	clk = tegra_clk_register_periph_gate("vcp", "clk_m", 0,
-				    clk_base, 0, 29, &periph_l_regs,
-				    periph_clk_enb_refcnt);
+				    clk_base, 0, 29, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "vcp", "tegra-avp");
 	clks[vcp] = clk;
 
 	/* bsea */
 	clk = tegra_clk_register_periph_gate("bsea", "clk_m", 0,
-				    clk_base, 0, 62, &periph_h_regs,
-				    periph_clk_enb_refcnt);
+				    clk_base, 0, 62, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "bsea", "tegra-avp");
 	clks[bsea] = clk;
 
 	/* bsev */
 	clk = tegra_clk_register_periph_gate("bsev", "clk_m", 0,
-				    clk_base, 0, 63, &periph_h_regs,
-				    periph_clk_enb_refcnt);
+				    clk_base, 0, 63, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "bsev", "tegra-aes");
 	clks[bsev] = clk;
 
@@ -947,63 +892,61 @@ static void __init tegra20_periph_clk_init(void)
 			       clk_base + CLK_SOURCE_EMC,
 			       30, 2, 0, NULL);
 	clk = tegra_clk_register_periph_gate("emc", "emc_mux", 0, clk_base, 0,
-				    57, &periph_h_regs, periph_clk_enb_refcnt);
+				    57, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "emc", NULL);
 	clks[emc] = clk;
 
 	/* usbd */
 	clk = tegra_clk_register_periph_gate("usbd", "clk_m", 0, clk_base, 0,
-				    22, &periph_l_regs, periph_clk_enb_refcnt);
+				    22, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "fsl-tegra-udc");
 	clks[usbd] = clk;
 
 	/* usb2 */
 	clk = tegra_clk_register_periph_gate("usb2", "clk_m", 0, clk_base, 0,
-				    58, &periph_h_regs, periph_clk_enb_refcnt);
+				    58, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "tegra-ehci.1");
 	clks[usb2] = clk;
 
 	/* usb3 */
 	clk = tegra_clk_register_periph_gate("usb3", "clk_m", 0, clk_base, 0,
-				    59, &periph_h_regs, periph_clk_enb_refcnt);
+				    59, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "tegra-ehci.2");
 	clks[usb3] = clk;
 
 	/* dsi */
 	clk = tegra_clk_register_periph_gate("dsi", "pll_d", 0, clk_base, 0,
-				    48, &periph_h_regs, periph_clk_enb_refcnt);
+				    48, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "dsi");
 	clks[dsi] = clk;
 
 	/* csi */
 	clk = tegra_clk_register_periph_gate("csi", "pll_p_out3", 0, clk_base,
-				    0, 52, &periph_h_regs,
-				    periph_clk_enb_refcnt);
+				    0, 52, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "csi", "tegra_camera");
 	clks[csi] = clk;
 
 	/* isp */
 	clk = tegra_clk_register_periph_gate("isp", "clk_m", 0, clk_base, 0, 23,
-				    &periph_l_regs, periph_clk_enb_refcnt);
+				    periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "isp", "tegra_camera");
 	clks[isp] = clk;
 
 	/* pex */
 	clk = tegra_clk_register_periph_gate("pex", "clk_m", 0, clk_base, 0, 70,
-				    &periph_u_regs, periph_clk_enb_refcnt);
+				    periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "pex", NULL);
 	clks[pex] = clk;
 
 	/* afi */
 	clk = tegra_clk_register_periph_gate("afi", "clk_m", 0, clk_base, 0, 72,
-				    &periph_u_regs, periph_clk_enb_refcnt);
+				    periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "afi", NULL);
 	clks[afi] = clk;
 
 	/* pcie_xclk */
 	clk = tegra_clk_register_periph_gate("pcie_xclk", "clk_m", 0, clk_base,
-				    0, 74, &periph_u_regs,
-				    periph_clk_enb_refcnt);
+				    0, 74, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "pcie_xclk", NULL);
 	clks[pcie_xclk] = clk;
 
@@ -1011,8 +954,7 @@ static void __init tegra20_periph_clk_init(void)
 	clk = clk_register_fixed_rate(NULL, "cdev1_fixed", NULL, CLK_IS_ROOT,
 				      26000000);
 	clk = tegra_clk_register_periph_gate("cdev1", "cdev1_fixed", 0,
-				    clk_base, 0, 94, &periph_u_regs,
-				    periph_clk_enb_refcnt);
+				    clk_base, 0, 94, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "cdev1", NULL);
 	clks[cdev1] = clk;
 
@@ -1020,8 +962,7 @@ static void __init tegra20_periph_clk_init(void)
 	clk = clk_register_fixed_rate(NULL, "cdev2_fixed", NULL, CLK_IS_ROOT,
 				      26000000);
 	clk = tegra_clk_register_periph_gate("cdev2", "cdev2_fixed", 0,
-				    clk_base, 0, 93, &periph_u_regs,
-				    periph_clk_enb_refcnt);
+				    clk_base, 0, 93, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "cdev2", NULL);
 	clks[cdev2] = clk;
 
@@ -1312,6 +1253,9 @@ static void __init tegra20_clock_init(struct device_node *np)
 		BUG();
 	}
 
+	if (tegra_clk_set_periph_banks(TEGRA20_CLK_PERIPH_BANKS) < 0)
+		return;
+
 	tegra20_osc_clk_init();
 	tegra20_pmc_clk_init();
 	tegra20_fixed_clk_init();
diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
index dbe7c80..60e37c5 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -26,38 +26,6 @@
 
 #include "clk.h"
 
-#define RST_DEVICES_L 0x004
-#define RST_DEVICES_H 0x008
-#define RST_DEVICES_U 0x00c
-#define RST_DEVICES_V 0x358
-#define RST_DEVICES_W 0x35c
-#define RST_DEVICES_SET_L 0x300
-#define RST_DEVICES_CLR_L 0x304
-#define RST_DEVICES_SET_H 0x308
-#define RST_DEVICES_CLR_H 0x30c
-#define RST_DEVICES_SET_U 0x310
-#define RST_DEVICES_CLR_U 0x314
-#define RST_DEVICES_SET_V 0x430
-#define RST_DEVICES_CLR_V 0x434
-#define RST_DEVICES_SET_W 0x438
-#define RST_DEVICES_CLR_W 0x43c
-#define RST_DEVICES_NUM 5
-
-#define CLK_OUT_ENB_L 0x010
-#define CLK_OUT_ENB_H 0x014
-#define CLK_OUT_ENB_U 0x018
-#define CLK_OUT_ENB_V 0x360
-#define CLK_OUT_ENB_W 0x364
-#define CLK_OUT_ENB_SET_L 0x320
-#define CLK_OUT_ENB_CLR_L 0x324
-#define CLK_OUT_ENB_SET_H 0x328
-#define CLK_OUT_ENB_CLR_H 0x32c
-#define CLK_OUT_ENB_SET_U 0x330
-#define CLK_OUT_ENB_CLR_U 0x334
-#define CLK_OUT_ENB_SET_V 0x440
-#define CLK_OUT_ENB_CLR_V 0x444
-#define CLK_OUT_ENB_SET_W 0x448
-#define CLK_OUT_ENB_CLR_W 0x44c
 #define CLK_OUT_ENB_NUM 5
 
 #define OSC_CTRL			0x50
@@ -92,6 +60,8 @@
 
 #define SYSTEM_CLK_RATE 0x030
 
+#define TEGRA30_CLK_PERIPH_BANKS	5
+
 #define PLLC_BASE 0x80
 #define PLLC_MISC 0x8c
 #define PLLM_BASE 0x90
@@ -280,42 +250,42 @@ static DEFINE_SPINLOCK(pll_d_lock);
 static DEFINE_SPINLOCK(sysrate_lock);
 
 #define TEGRA_INIT_DATA_MUX(_name, _con_id, _dev_id, _parents, _offset,	\
-			    _clk_num, _regs, _gate_flags, _clk_id)	\
+			    _clk_num, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
-			30, 2, 0, 0, 8, 1, 0, _regs, _clk_num,		\
+			30, 2, 0, 0, 8, 1, 0, _clk_num,		\
 			periph_clk_enb_refcnt, _gate_flags, _clk_id)
 
 #define TEGRA_INIT_DATA_DIV16(_name, _con_id, _dev_id, _parents, _offset, \
-			    _clk_num, _regs, _gate_flags, _clk_id)	\
+			    _clk_num, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
 			30, 2, 0, 0, 16, 0, TEGRA_DIVIDER_ROUND_UP,	\
-			_regs, _clk_num, periph_clk_enb_refcnt,		\
+			_clk_num, periph_clk_enb_refcnt,		\
 			_gate_flags, _clk_id)
 
 #define TEGRA_INIT_DATA_MUX8(_name, _con_id, _dev_id, _parents, _offset, \
-			     _clk_num, _regs, _gate_flags, _clk_id)	\
+			     _clk_num, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
-			29, 3, 0, 0, 8, 1, 0, _regs, _clk_num,		\
+			29, 3, 0, 0, 8, 1, 0, _clk_num,		\
 			periph_clk_enb_refcnt, _gate_flags, _clk_id)
 
 #define TEGRA_INIT_DATA_INT(_name, _con_id, _dev_id, _parents, _offset,	\
-			    _clk_num, _regs, _gate_flags, _clk_id)	\
+			    _clk_num, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
-			30, 2, 0, 0, 8, 1, TEGRA_DIVIDER_INT, _regs,	\
+			30, 2, 0, 0, 8, 1, TEGRA_DIVIDER_INT,\
 			_clk_num, periph_clk_enb_refcnt, _gate_flags,	\
 			_clk_id)
 
 #define TEGRA_INIT_DATA_UART(_name, _con_id, _dev_id, _parents, _offset,\
-			     _clk_num, _regs, _clk_id)			\
+			     _clk_num, _clk_id)			\
 	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
-			30, 2, 0, 0, 16, 1, TEGRA_DIVIDER_UART, _regs,	\
+			30, 2, 0, 0, 16, 1, TEGRA_DIVIDER_UART,\
 			_clk_num, periph_clk_enb_refcnt, 0, _clk_id)
 
 #define TEGRA_INIT_DATA_NODIV(_name, _con_id, _dev_id, _parents, _offset, \
-			      _mux_shift, _mux_width, _clk_num, _regs,	\
+			      _mux_shift, _mux_width, _clk_num, \
 			      _gate_flags, _clk_id)			\
 	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
-			_mux_shift, _mux_width, 0, 0, 0, 0, 0, _regs,	\
+			_mux_shift, _mux_width, 0, 0, 0, 0, 0,\
 			_clk_num, periph_clk_enb_refcnt, _gate_flags,	\
 			_clk_id)
 
@@ -694,52 +664,6 @@ static struct tegra_clk_pll_params pll_e_params = {
 	.lock_delay = 300,
 };
 
-/* Peripheral clock registers */
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
-};
-
 static void tegra30_clk_measure_input_freq(void)
 {
 	u32 osc_ctrl = readl_relaxed(clk_base + OSC_CTRL);
@@ -1159,7 +1083,7 @@ static void __init tegra30_audio_clk_init(void)
 				&clk_doubler_lock);
 	clk = tegra_clk_register_periph_gate("audio0_2x", "audio0_div",
 				    TEGRA_PERIPH_NO_RESET, clk_base,
-				    CLK_SET_RATE_PARENT, 113, &periph_v_regs,
+				    CLK_SET_RATE_PARENT, 113,
 				    periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "audio0_2x", NULL);
 	clks[audio0_2x] = clk;
@@ -1172,7 +1096,7 @@ static void __init tegra30_audio_clk_init(void)
 				&clk_doubler_lock);
 	clk = tegra_clk_register_periph_gate("audio1_2x", "audio1_div",
 				    TEGRA_PERIPH_NO_RESET, clk_base,
-				    CLK_SET_RATE_PARENT, 114, &periph_v_regs,
+				    CLK_SET_RATE_PARENT, 114,
 				    periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "audio1_2x", NULL);
 	clks[audio1_2x] = clk;
@@ -1185,7 +1109,7 @@ static void __init tegra30_audio_clk_init(void)
 				&clk_doubler_lock);
 	clk = tegra_clk_register_periph_gate("audio2_2x", "audio2_div",
 				    TEGRA_PERIPH_NO_RESET, clk_base,
-				    CLK_SET_RATE_PARENT, 115, &periph_v_regs,
+				    CLK_SET_RATE_PARENT, 115,
 				    periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "audio2_2x", NULL);
 	clks[audio2_2x] = clk;
@@ -1198,7 +1122,7 @@ static void __init tegra30_audio_clk_init(void)
 				&clk_doubler_lock);
 	clk = tegra_clk_register_periph_gate("audio3_2x", "audio3_div",
 				    TEGRA_PERIPH_NO_RESET, clk_base,
-				    CLK_SET_RATE_PARENT, 116, &periph_v_regs,
+				    CLK_SET_RATE_PARENT, 116,
 				    periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "audio3_2x", NULL);
 	clks[audio3_2x] = clk;
@@ -1211,7 +1135,7 @@ static void __init tegra30_audio_clk_init(void)
 				&clk_doubler_lock);
 	clk = tegra_clk_register_periph_gate("audio4_2x", "audio4_div",
 				    TEGRA_PERIPH_NO_RESET, clk_base,
-				    CLK_SET_RATE_PARENT, 117, &periph_v_regs,
+				    CLK_SET_RATE_PARENT, 117,
 				    periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "audio4_2x", NULL);
 	clks[audio4_2x] = clk;
@@ -1224,7 +1148,7 @@ static void __init tegra30_audio_clk_init(void)
 				&clk_doubler_lock);
 	clk = tegra_clk_register_periph_gate("spdif_2x", "spdif_div",
 				    TEGRA_PERIPH_NO_RESET, clk_base,
-				    CLK_SET_RATE_PARENT, 118, &periph_v_regs,
+				    CLK_SET_RATE_PARENT, 118,
 				    periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "spdif_2x", NULL);
 	clks[spdif_2x] = clk;
@@ -1443,77 +1367,77 @@ static const char *mux_plld_out0_plld2_out0[] = { "pll_d_out0",
 						  "pll_d2_out0" };
 
 static struct tegra_periph_init_data tegra_periph_clk_list[] = {
-	TEGRA_INIT_DATA_MUX("i2s0",	NULL,		"tegra30-i2s.0",	i2s0_parents,		CLK_SOURCE_I2S0,	30,	&periph_l_regs, TEGRA_PERIPH_ON_APB, i2s0),
-	TEGRA_INIT_DATA_MUX("i2s1",	NULL,		"tegra30-i2s.1",	i2s1_parents,		CLK_SOURCE_I2S1,	11,	&periph_l_regs, TEGRA_PERIPH_ON_APB, i2s1),
-	TEGRA_INIT_DATA_MUX("i2s2",	NULL,		"tegra30-i2s.2",	i2s2_parents,		CLK_SOURCE_I2S2,	18,	&periph_l_regs, TEGRA_PERIPH_ON_APB, i2s2),
-	TEGRA_INIT_DATA_MUX("i2s3",	NULL,		"tegra30-i2s.3",	i2s3_parents,		CLK_SOURCE_I2S3,	101,	&periph_v_regs, TEGRA_PERIPH_ON_APB, i2s3),
-	TEGRA_INIT_DATA_MUX("i2s4",	NULL,		"tegra30-i2s.4",	i2s4_parents,		CLK_SOURCE_I2S4,	102,	&periph_v_regs, TEGRA_PERIPH_ON_APB, i2s4),
-	TEGRA_INIT_DATA_MUX("spdif_out", "spdif_out",	"tegra30-spdif",	spdif_out_parents,	CLK_SOURCE_SPDIF_OUT,	10,	&periph_l_regs, TEGRA_PERIPH_ON_APB, spdif_out),
-	TEGRA_INIT_DATA_MUX("spdif_in",	"spdif_in",	"tegra30-spdif",	spdif_in_parents,	CLK_SOURCE_SPDIF_IN,	10,	&periph_l_regs, TEGRA_PERIPH_ON_APB, spdif_in),
-	TEGRA_INIT_DATA_MUX("d_audio",	"d_audio",	"tegra30-ahub",		mux_pllacp_clkm,	CLK_SOURCE_D_AUDIO,	106,	&periph_v_regs, 0, d_audio),
-	TEGRA_INIT_DATA_MUX("dam0",	NULL,		"tegra30-dam.0",	mux_pllacp_clkm,	CLK_SOURCE_DAM0,	108,	&periph_v_regs, 0, dam0),
-	TEGRA_INIT_DATA_MUX("dam1",	NULL,		"tegra30-dam.1",	mux_pllacp_clkm,	CLK_SOURCE_DAM1,	109,	&periph_v_regs, 0, dam1),
-	TEGRA_INIT_DATA_MUX("dam2",	NULL,		"tegra30-dam.2",	mux_pllacp_clkm,	CLK_SOURCE_DAM2,	110,	&periph_v_regs, 0, dam2),
-	TEGRA_INIT_DATA_MUX("hda",	"hda",		"tegra30-hda",		mux_pllpcm_clkm,	CLK_SOURCE_HDA,		125,	&periph_v_regs, 0, hda),
-	TEGRA_INIT_DATA_MUX("hda2codec_2x", "hda2codec", "tegra30-hda",		mux_pllpcm_clkm,	CLK_SOURCE_HDA2CODEC_2X, 111,	&periph_v_regs, 0, hda2codec_2x),
-	TEGRA_INIT_DATA_MUX("sbc1",	NULL,		"spi_tegra.0",		mux_pllpcm_clkm,	CLK_SOURCE_SBC1,	41,	&periph_h_regs, TEGRA_PERIPH_ON_APB, sbc1),
-	TEGRA_INIT_DATA_MUX("sbc2",	NULL,		"spi_tegra.1",		mux_pllpcm_clkm,	CLK_SOURCE_SBC2,	44,	&periph_h_regs, TEGRA_PERIPH_ON_APB, sbc2),
-	TEGRA_INIT_DATA_MUX("sbc3",	NULL,		"spi_tegra.2",		mux_pllpcm_clkm,	CLK_SOURCE_SBC3,	46,	&periph_h_regs, TEGRA_PERIPH_ON_APB, sbc3),
-	TEGRA_INIT_DATA_MUX("sbc4",	NULL,		"spi_tegra.3",		mux_pllpcm_clkm,	CLK_SOURCE_SBC4,	68,	&periph_u_regs, TEGRA_PERIPH_ON_APB, sbc4),
-	TEGRA_INIT_DATA_MUX("sbc5",	NULL,		"spi_tegra.4",		mux_pllpcm_clkm,	CLK_SOURCE_SBC5,	104,	&periph_v_regs, TEGRA_PERIPH_ON_APB, sbc5),
-	TEGRA_INIT_DATA_MUX("sbc6",	NULL,		"spi_tegra.5",		mux_pllpcm_clkm,	CLK_SOURCE_SBC6,	105,	&periph_v_regs, TEGRA_PERIPH_ON_APB, sbc6),
-	TEGRA_INIT_DATA_MUX("sata_oob",	NULL,		"tegra_sata_oob",	mux_pllpcm_clkm,	CLK_SOURCE_SATA_OOB,	123,	&periph_v_regs, TEGRA_PERIPH_ON_APB, sata_oob),
-	TEGRA_INIT_DATA_MUX("sata",	NULL,		"tegra_sata",		mux_pllpcm_clkm,	CLK_SOURCE_SATA,	124,	&periph_v_regs, TEGRA_PERIPH_ON_APB, sata),
-	TEGRA_INIT_DATA_MUX("ndflash",	NULL,		"tegra_nand",		mux_pllpcm_clkm,	CLK_SOURCE_NDFLASH,	13,	&periph_l_regs, TEGRA_PERIPH_ON_APB, ndflash),
-	TEGRA_INIT_DATA_MUX("ndspeed",	NULL,		"tegra_nand_speed",	mux_pllpcm_clkm,	CLK_SOURCE_NDSPEED,	80,	&periph_u_regs, TEGRA_PERIPH_ON_APB, ndspeed),
-	TEGRA_INIT_DATA_MUX("vfir",	NULL,		"vfir",			mux_pllpcm_clkm,	CLK_SOURCE_VFIR,	7,	&periph_l_regs, TEGRA_PERIPH_ON_APB, vfir),
-	TEGRA_INIT_DATA_MUX("csite",	NULL,		"csite",		mux_pllpcm_clkm,	CLK_SOURCE_CSITE,	73,	&periph_u_regs, TEGRA_PERIPH_ON_APB, csite),
-	TEGRA_INIT_DATA_MUX("la",	NULL,		"la",			mux_pllpcm_clkm,	CLK_SOURCE_LA,		76,	&periph_u_regs, TEGRA_PERIPH_ON_APB, la),
-	TEGRA_INIT_DATA_MUX("owr",	NULL,		"tegra_w1",		mux_pllpcm_clkm,	CLK_SOURCE_OWR,		71,	&periph_u_regs, TEGRA_PERIPH_ON_APB, owr),
-	TEGRA_INIT_DATA_MUX("mipi",	NULL,		"mipi",			mux_pllpcm_clkm,	CLK_SOURCE_MIPI,	50,	&periph_h_regs, TEGRA_PERIPH_ON_APB, mipi),
-	TEGRA_INIT_DATA_MUX("tsensor",	NULL,		"tegra-tsensor",	mux_pllpc_clkm_clk32k,	CLK_SOURCE_TSENSOR,	100,	&periph_v_regs, TEGRA_PERIPH_ON_APB, tsensor),
-	TEGRA_INIT_DATA_MUX("i2cslow",	NULL,		"i2cslow",		mux_pllpc_clk32k_clkm,	CLK_SOURCE_I2CSLOW,	81,	&periph_u_regs, TEGRA_PERIPH_ON_APB, i2cslow),
-	TEGRA_INIT_DATA_INT("vde",	NULL,		"vde",			mux_pllpcm_clkm,	CLK_SOURCE_VDE,		61,	&periph_h_regs, 0, vde),
-	TEGRA_INIT_DATA_INT("vi",	"vi",		"tegra_camera",		mux_pllmcpa,		CLK_SOURCE_VI,		20,	&periph_l_regs, 0, vi),
-	TEGRA_INIT_DATA_INT("epp",	NULL,		"epp",			mux_pllmcpa,		CLK_SOURCE_EPP,		19,	&periph_l_regs, 0, epp),
-	TEGRA_INIT_DATA_INT("mpe",	NULL,		"mpe",			mux_pllmcpa,		CLK_SOURCE_MPE,		60,	&periph_h_regs, 0, mpe),
-	TEGRA_INIT_DATA_INT("host1x",	NULL,		"host1x",		mux_pllmcpa,		CLK_SOURCE_HOST1X,	28,	&periph_l_regs, 0, host1x),
-	TEGRA_INIT_DATA_INT("3d",	NULL,		"3d",			mux_pllmcpa,		CLK_SOURCE_3D,		24,	&periph_l_regs, TEGRA_PERIPH_MANUAL_RESET, gr3d),
-	TEGRA_INIT_DATA_INT("3d2",	NULL,		"3d2",			mux_pllmcpa,		CLK_SOURCE_3D2,		98,	&periph_v_regs, TEGRA_PERIPH_MANUAL_RESET, gr3d2),
-	TEGRA_INIT_DATA_INT("2d",	NULL,		"2d",			mux_pllmcpa,		CLK_SOURCE_2D,		21,	&periph_l_regs, 0, gr2d),
-	TEGRA_INIT_DATA_INT("se",	NULL,		"se",			mux_pllpcm_clkm,	CLK_SOURCE_SE,		127,	&periph_v_regs, 0, se),
-	TEGRA_INIT_DATA_MUX("mselect",	NULL,		"mselect",		mux_pllp_clkm,		CLK_SOURCE_MSELECT,	99,	&periph_v_regs, 0, mselect),
-	TEGRA_INIT_DATA_MUX("nor",	NULL,		"tegra-nor",		mux_pllpcm_clkm,	CLK_SOURCE_NOR,		42,	&periph_h_regs, 0, nor),
-	TEGRA_INIT_DATA_MUX("sdmmc1",	NULL,		"sdhci-tegra.0",	mux_pllpcm_clkm,	CLK_SOURCE_SDMMC1,	14,	&periph_l_regs, 0, sdmmc1),
-	TEGRA_INIT_DATA_MUX("sdmmc2",	NULL,		"sdhci-tegra.1",	mux_pllpcm_clkm,	CLK_SOURCE_SDMMC2,	9,	&periph_l_regs, 0, sdmmc2),
-	TEGRA_INIT_DATA_MUX("sdmmc3",	NULL,		"sdhci-tegra.2",	mux_pllpcm_clkm,	CLK_SOURCE_SDMMC3,	69,	&periph_u_regs, 0, sdmmc3),
-	TEGRA_INIT_DATA_MUX("sdmmc4",	NULL,		"sdhci-tegra.3",	mux_pllpcm_clkm,	CLK_SOURCE_SDMMC4,	15,	&periph_l_regs, 0, sdmmc4),
-	TEGRA_INIT_DATA_MUX("cve",	NULL,		"cve",			mux_pllpdc_clkm,	CLK_SOURCE_CVE,		49,	&periph_h_regs, 0, cve),
-	TEGRA_INIT_DATA_MUX("tvo",	NULL,		"tvo",			mux_pllpdc_clkm,	CLK_SOURCE_TVO,		49,	&periph_h_regs, 0, tvo),
-	TEGRA_INIT_DATA_MUX("tvdac",	NULL,		"tvdac",		mux_pllpdc_clkm,	CLK_SOURCE_TVDAC,	53,	&periph_h_regs, 0, tvdac),
-	TEGRA_INIT_DATA_MUX("actmon",	NULL,		"actmon",		mux_pllpc_clk32k_clkm,	CLK_SOURCE_ACTMON,	119,	&periph_v_regs, 0, actmon),
-	TEGRA_INIT_DATA_MUX("vi_sensor", "vi_sensor",	"tegra_camera",		mux_pllmcpa,		CLK_SOURCE_VI_SENSOR,	20,	&periph_l_regs, TEGRA_PERIPH_NO_RESET, vi_sensor),
-	TEGRA_INIT_DATA_DIV16("i2c1",	"div-clk",	"tegra-i2c.0",		mux_pllp_clkm,		CLK_SOURCE_I2C1,	12,	&periph_l_regs, TEGRA_PERIPH_ON_APB, i2c1),
-	TEGRA_INIT_DATA_DIV16("i2c2",	"div-clk",	"tegra-i2c.1",		mux_pllp_clkm,		CLK_SOURCE_I2C2,	54,	&periph_h_regs, TEGRA_PERIPH_ON_APB, i2c2),
-	TEGRA_INIT_DATA_DIV16("i2c3",	"div-clk",	"tegra-i2c.2",		mux_pllp_clkm,		CLK_SOURCE_I2C3,	67,	&periph_u_regs,	TEGRA_PERIPH_ON_APB, i2c3),
-	TEGRA_INIT_DATA_DIV16("i2c4",	"div-clk",	"tegra-i2c.3",		mux_pllp_clkm,		CLK_SOURCE_I2C4,	103,	&periph_v_regs,	TEGRA_PERIPH_ON_APB, i2c4),
-	TEGRA_INIT_DATA_DIV16("i2c5",	"div-clk",	"tegra-i2c.4",		mux_pllp_clkm,		CLK_SOURCE_I2C5,	47,	&periph_h_regs,	TEGRA_PERIPH_ON_APB, i2c5),
-	TEGRA_INIT_DATA_UART("uarta",	NULL,		"tegra_uart.0",		mux_pllpcm_clkm,	CLK_SOURCE_UARTA,	6,	&periph_l_regs, uarta),
-	TEGRA_INIT_DATA_UART("uartb",	NULL,		"tegra_uart.1",		mux_pllpcm_clkm,	CLK_SOURCE_UARTB,	7,	&periph_l_regs, uartb),
-	TEGRA_INIT_DATA_UART("uartc",	NULL,		"tegra_uart.2",		mux_pllpcm_clkm,	CLK_SOURCE_UARTC,	55,	&periph_h_regs, uartc),
-	TEGRA_INIT_DATA_UART("uartd",	NULL,		"tegra_uart.3",		mux_pllpcm_clkm,	CLK_SOURCE_UARTD,	65,	&periph_u_regs, uartd),
-	TEGRA_INIT_DATA_UART("uarte",	NULL,		"tegra_uart.4",		mux_pllpcm_clkm,	CLK_SOURCE_UARTE,	66,	&periph_u_regs, uarte),
-	TEGRA_INIT_DATA_MUX8("hdmi",	NULL,		"hdmi",			mux_pllpmdacd2_clkm,	CLK_SOURCE_HDMI,	51,	&periph_h_regs,	0, hdmi),
-	TEGRA_INIT_DATA_MUX8("extern1",	NULL,		"extern1",		mux_plla_clk32k_pllp_clkm_plle,	CLK_SOURCE_EXTERN1,	120,	&periph_v_regs,	0, extern1),
-	TEGRA_INIT_DATA_MUX8("extern2",	NULL,		"extern2",		mux_plla_clk32k_pllp_clkm_plle,	CLK_SOURCE_EXTERN2,	121,	&periph_v_regs,	0, extern2),
-	TEGRA_INIT_DATA_MUX8("extern3",	NULL,		"extern3",		mux_plla_clk32k_pllp_clkm_plle,	CLK_SOURCE_EXTERN3,	122,	&periph_v_regs,	0, extern3),
-	TEGRA_INIT_DATA("pwm",		NULL,		"pwm",			mux_pllpc_clk32k_clkm,	CLK_SOURCE_PWM,		28, 2, 0, 0, 8, 1, 0, &periph_l_regs, 17, periph_clk_enb_refcnt, 0, pwm),
+	TEGRA_INIT_DATA_MUX("i2s0",	NULL,		"tegra30-i2s.0",	i2s0_parents,		CLK_SOURCE_I2S0,	30,	TEGRA_PERIPH_ON_APB, i2s0),
+	TEGRA_INIT_DATA_MUX("i2s1",	NULL,		"tegra30-i2s.1",	i2s1_parents,		CLK_SOURCE_I2S1,	11,	TEGRA_PERIPH_ON_APB, i2s1),
+	TEGRA_INIT_DATA_MUX("i2s2",	NULL,		"tegra30-i2s.2",	i2s2_parents,		CLK_SOURCE_I2S2,	18,	TEGRA_PERIPH_ON_APB, i2s2),
+	TEGRA_INIT_DATA_MUX("i2s3",	NULL,		"tegra30-i2s.3",	i2s3_parents,		CLK_SOURCE_I2S3,	101,	TEGRA_PERIPH_ON_APB, i2s3),
+	TEGRA_INIT_DATA_MUX("i2s4",	NULL,		"tegra30-i2s.4",	i2s4_parents,		CLK_SOURCE_I2S4,	102,	TEGRA_PERIPH_ON_APB, i2s4),
+	TEGRA_INIT_DATA_MUX("spdif_out", "spdif_out",	"tegra30-spdif",	spdif_out_parents,	CLK_SOURCE_SPDIF_OUT,	10,	TEGRA_PERIPH_ON_APB, spdif_out),
+	TEGRA_INIT_DATA_MUX("spdif_in",	"spdif_in",	"tegra30-spdif",	spdif_in_parents,	CLK_SOURCE_SPDIF_IN,	10,	TEGRA_PERIPH_ON_APB, spdif_in),
+	TEGRA_INIT_DATA_MUX("d_audio",	"d_audio",	"tegra30-ahub",		mux_pllacp_clkm,	CLK_SOURCE_D_AUDIO,	106,	0, d_audio),
+	TEGRA_INIT_DATA_MUX("dam0",	NULL,		"tegra30-dam.0",	mux_pllacp_clkm,	CLK_SOURCE_DAM0,	108,	0, dam0),
+	TEGRA_INIT_DATA_MUX("dam1",	NULL,		"tegra30-dam.1",	mux_pllacp_clkm,	CLK_SOURCE_DAM1,	109,	0, dam1),
+	TEGRA_INIT_DATA_MUX("dam2",	NULL,		"tegra30-dam.2",	mux_pllacp_clkm,	CLK_SOURCE_DAM2,	110,	0, dam2),
+	TEGRA_INIT_DATA_MUX("hda",	"hda",		"tegra30-hda",		mux_pllpcm_clkm,	CLK_SOURCE_HDA,		125,	0, hda),
+	TEGRA_INIT_DATA_MUX("hda2codec_2x", "hda2codec", "tegra30-hda",		mux_pllpcm_clkm,	CLK_SOURCE_HDA2CODEC_2X, 111,	0, hda2codec_2x),
+	TEGRA_INIT_DATA_MUX("sbc1",	NULL,		"spi_tegra.0",		mux_pllpcm_clkm,	CLK_SOURCE_SBC1,	41,	TEGRA_PERIPH_ON_APB, sbc1),
+	TEGRA_INIT_DATA_MUX("sbc2",	NULL,		"spi_tegra.1",		mux_pllpcm_clkm,	CLK_SOURCE_SBC2,	44,	TEGRA_PERIPH_ON_APB, sbc2),
+	TEGRA_INIT_DATA_MUX("sbc3",	NULL,		"spi_tegra.2",		mux_pllpcm_clkm,	CLK_SOURCE_SBC3,	46,	TEGRA_PERIPH_ON_APB, sbc3),
+	TEGRA_INIT_DATA_MUX("sbc4",	NULL,		"spi_tegra.3",		mux_pllpcm_clkm,	CLK_SOURCE_SBC4,	68,	TEGRA_PERIPH_ON_APB, sbc4),
+	TEGRA_INIT_DATA_MUX("sbc5",	NULL,		"spi_tegra.4",		mux_pllpcm_clkm,	CLK_SOURCE_SBC5,	104,	TEGRA_PERIPH_ON_APB, sbc5),
+	TEGRA_INIT_DATA_MUX("sbc6",	NULL,		"spi_tegra.5",		mux_pllpcm_clkm,	CLK_SOURCE_SBC6,	105,	TEGRA_PERIPH_ON_APB, sbc6),
+	TEGRA_INIT_DATA_MUX("sata_oob",	NULL,		"tegra_sata_oob",	mux_pllpcm_clkm,	CLK_SOURCE_SATA_OOB,	123,	TEGRA_PERIPH_ON_APB, sata_oob),
+	TEGRA_INIT_DATA_MUX("sata",	NULL,		"tegra_sata",		mux_pllpcm_clkm,	CLK_SOURCE_SATA,	124,	TEGRA_PERIPH_ON_APB, sata),
+	TEGRA_INIT_DATA_MUX("ndflash",	NULL,		"tegra_nand",		mux_pllpcm_clkm,	CLK_SOURCE_NDFLASH,	13,	TEGRA_PERIPH_ON_APB, ndflash),
+	TEGRA_INIT_DATA_MUX("ndspeed",	NULL,		"tegra_nand_speed",	mux_pllpcm_clkm,	CLK_SOURCE_NDSPEED,	80,	TEGRA_PERIPH_ON_APB, ndspeed),
+	TEGRA_INIT_DATA_MUX("vfir",	NULL,		"vfir",			mux_pllpcm_clkm,	CLK_SOURCE_VFIR,	7,	TEGRA_PERIPH_ON_APB, vfir),
+	TEGRA_INIT_DATA_MUX("csite",	NULL,		"csite",		mux_pllpcm_clkm,	CLK_SOURCE_CSITE,	73,	TEGRA_PERIPH_ON_APB, csite),
+	TEGRA_INIT_DATA_MUX("la",	NULL,		"la",			mux_pllpcm_clkm,	CLK_SOURCE_LA,		76,	TEGRA_PERIPH_ON_APB, la),
+	TEGRA_INIT_DATA_MUX("owr",	NULL,		"tegra_w1",		mux_pllpcm_clkm,	CLK_SOURCE_OWR,		71,	TEGRA_PERIPH_ON_APB, owr),
+	TEGRA_INIT_DATA_MUX("mipi",	NULL,		"mipi",			mux_pllpcm_clkm,	CLK_SOURCE_MIPI,	50,	TEGRA_PERIPH_ON_APB, mipi),
+	TEGRA_INIT_DATA_MUX("tsensor",	NULL,		"tegra-tsensor",	mux_pllpc_clkm_clk32k,	CLK_SOURCE_TSENSOR,	100,	TEGRA_PERIPH_ON_APB, tsensor),
+	TEGRA_INIT_DATA_MUX("i2cslow",	NULL,		"i2cslow",		mux_pllpc_clk32k_clkm,	CLK_SOURCE_I2CSLOW,	81,	TEGRA_PERIPH_ON_APB, i2cslow),
+	TEGRA_INIT_DATA_INT("vde",	NULL,		"vde",			mux_pllpcm_clkm,	CLK_SOURCE_VDE,		61,	0, vde),
+	TEGRA_INIT_DATA_INT("vi",	"vi",		"tegra_camera",		mux_pllmcpa,		CLK_SOURCE_VI,		20,	0, vi),
+	TEGRA_INIT_DATA_INT("epp",	NULL,		"epp",			mux_pllmcpa,		CLK_SOURCE_EPP,		19,	0, epp),
+	TEGRA_INIT_DATA_INT("mpe",	NULL,		"mpe",			mux_pllmcpa,		CLK_SOURCE_MPE,		60,	0, mpe),
+	TEGRA_INIT_DATA_INT("host1x",	NULL,		"host1x",		mux_pllmcpa,		CLK_SOURCE_HOST1X,	28,	0, host1x),
+	TEGRA_INIT_DATA_INT("3d",	NULL,		"3d",			mux_pllmcpa,		CLK_SOURCE_3D,		24,	TEGRA_PERIPH_MANUAL_RESET, gr3d),
+	TEGRA_INIT_DATA_INT("3d2",	NULL,		"3d2",			mux_pllmcpa,		CLK_SOURCE_3D2,		98,	TEGRA_PERIPH_MANUAL_RESET, gr3d2),
+	TEGRA_INIT_DATA_INT("2d",	NULL,		"2d",			mux_pllmcpa,		CLK_SOURCE_2D,		21,	0, gr2d),
+	TEGRA_INIT_DATA_INT("se",	NULL,		"se",			mux_pllpcm_clkm,	CLK_SOURCE_SE,		127,	0, se),
+	TEGRA_INIT_DATA_MUX("mselect",	NULL,		"mselect",		mux_pllp_clkm,		CLK_SOURCE_MSELECT,	99,	0, mselect),
+	TEGRA_INIT_DATA_MUX("nor",	NULL,		"tegra-nor",		mux_pllpcm_clkm,	CLK_SOURCE_NOR,		42,	0, nor),
+	TEGRA_INIT_DATA_MUX("sdmmc1",	NULL,		"sdhci-tegra.0",	mux_pllpcm_clkm,	CLK_SOURCE_SDMMC1,	14,	0, sdmmc1),
+	TEGRA_INIT_DATA_MUX("sdmmc2",	NULL,		"sdhci-tegra.1",	mux_pllpcm_clkm,	CLK_SOURCE_SDMMC2,	9,	0, sdmmc2),
+	TEGRA_INIT_DATA_MUX("sdmmc3",	NULL,		"sdhci-tegra.2",	mux_pllpcm_clkm,	CLK_SOURCE_SDMMC3,	69,	0, sdmmc3),
+	TEGRA_INIT_DATA_MUX("sdmmc4",	NULL,		"sdhci-tegra.3",	mux_pllpcm_clkm,	CLK_SOURCE_SDMMC4,	15,	0, sdmmc4),
+	TEGRA_INIT_DATA_MUX("cve",	NULL,		"cve",			mux_pllpdc_clkm,	CLK_SOURCE_CVE,		49,	0, cve),
+	TEGRA_INIT_DATA_MUX("tvo",	NULL,		"tvo",			mux_pllpdc_clkm,	CLK_SOURCE_TVO,		49,	0, tvo),
+	TEGRA_INIT_DATA_MUX("tvdac",	NULL,		"tvdac",		mux_pllpdc_clkm,	CLK_SOURCE_TVDAC,	53,	0, tvdac),
+	TEGRA_INIT_DATA_MUX("actmon",	NULL,		"actmon",		mux_pllpc_clk32k_clkm,	CLK_SOURCE_ACTMON,	119,	0, actmon),
+	TEGRA_INIT_DATA_MUX("vi_sensor", "vi_sensor",	"tegra_camera",		mux_pllmcpa,		CLK_SOURCE_VI_SENSOR,	20,	TEGRA_PERIPH_NO_RESET, vi_sensor),
+	TEGRA_INIT_DATA_DIV16("i2c1",	"div-clk",	"tegra-i2c.0",		mux_pllp_clkm,		CLK_SOURCE_I2C1,	12,	TEGRA_PERIPH_ON_APB, i2c1),
+	TEGRA_INIT_DATA_DIV16("i2c2",	"div-clk",	"tegra-i2c.1",		mux_pllp_clkm,		CLK_SOURCE_I2C2,	54,	TEGRA_PERIPH_ON_APB, i2c2),
+	TEGRA_INIT_DATA_DIV16("i2c3",	"div-clk",	"tegra-i2c.2",		mux_pllp_clkm,		CLK_SOURCE_I2C3,	67,	TEGRA_PERIPH_ON_APB, i2c3),
+	TEGRA_INIT_DATA_DIV16("i2c4",	"div-clk",	"tegra-i2c.3",		mux_pllp_clkm,		CLK_SOURCE_I2C4,	103,	TEGRA_PERIPH_ON_APB, i2c4),
+	TEGRA_INIT_DATA_DIV16("i2c5",	"div-clk",	"tegra-i2c.4",		mux_pllp_clkm,		CLK_SOURCE_I2C5,	47,	TEGRA_PERIPH_ON_APB, i2c5),
+	TEGRA_INIT_DATA_UART("uarta",	NULL,		"tegra_uart.0",		mux_pllpcm_clkm,	CLK_SOURCE_UARTA,	6,	uarta),
+	TEGRA_INIT_DATA_UART("uartb",	NULL,		"tegra_uart.1",		mux_pllpcm_clkm,	CLK_SOURCE_UARTB,	7,	uartb),
+	TEGRA_INIT_DATA_UART("uartc",	NULL,		"tegra_uart.2",		mux_pllpcm_clkm,	CLK_SOURCE_UARTC,	55,	uartc),
+	TEGRA_INIT_DATA_UART("uartd",	NULL,		"tegra_uart.3",		mux_pllpcm_clkm,	CLK_SOURCE_UARTD,	65,	uartd),
+	TEGRA_INIT_DATA_UART("uarte",	NULL,		"tegra_uart.4",		mux_pllpcm_clkm,	CLK_SOURCE_UARTE,	66,	uarte),
+	TEGRA_INIT_DATA_MUX8("hdmi",	NULL,		"hdmi",			mux_pllpmdacd2_clkm,	CLK_SOURCE_HDMI,	51,	0, hdmi),
+	TEGRA_INIT_DATA_MUX8("extern1",	NULL,		"extern1",		mux_plla_clk32k_pllp_clkm_plle,	CLK_SOURCE_EXTERN1,	120,	0, extern1),
+	TEGRA_INIT_DATA_MUX8("extern2",	NULL,		"extern2",		mux_plla_clk32k_pllp_clkm_plle,	CLK_SOURCE_EXTERN2,	121,	0, extern2),
+	TEGRA_INIT_DATA_MUX8("extern3",	NULL,		"extern3",		mux_plla_clk32k_pllp_clkm_plle,	CLK_SOURCE_EXTERN3,	122,	0, extern3),
+	TEGRA_INIT_DATA("pwm",		NULL,		"pwm",			mux_pllpc_clk32k_clkm,	CLK_SOURCE_PWM,		28, 2, 0, 0, 8, 1, 0, 17, periph_clk_enb_refcnt, 0, pwm),
 };
 
 static struct tegra_periph_init_data tegra_periph_nodiv_clk_list[] = {
-	TEGRA_INIT_DATA_NODIV("disp1",	NULL, "tegradc.0", mux_pllpmdacd2_clkm,	     CLK_SOURCE_DISP1,	29, 3, 27, &periph_l_regs, 0, disp1),
-	TEGRA_INIT_DATA_NODIV("disp2",	NULL, "tegradc.1", mux_pllpmdacd2_clkm,      CLK_SOURCE_DISP2,	29, 3, 26, &periph_l_regs, 0, disp2),
-	TEGRA_INIT_DATA_NODIV("dsib",	NULL, "tegradc.1", mux_plld_out0_plld2_out0, CLK_SOURCE_DSIB,	25, 1, 82, &periph_u_regs, 0, dsib),
+	TEGRA_INIT_DATA_NODIV("disp1",	NULL, "tegradc.0", mux_pllpmdacd2_clkm,	     CLK_SOURCE_DISP1,	29, 3, 27, 0, disp1),
+	TEGRA_INIT_DATA_NODIV("disp2",	NULL, "tegradc.1", mux_pllpmdacd2_clkm,      CLK_SOURCE_DISP2,	29, 3, 26, 0, disp2),
+	TEGRA_INIT_DATA_NODIV("dsib",	NULL, "tegradc.1", mux_plld_out0_plld2_out0, CLK_SOURCE_DSIB,	25, 1, 82, 0, dsib),
 };
 
 static void __init tegra30_periph_clk_init(void)
@@ -1524,166 +1448,154 @@ static void __init tegra30_periph_clk_init(void)
 
 	/* apbdma */
 	clk = tegra_clk_register_periph_gate("apbdma", "clk_m", 0, clk_base, 0, 34,
-				    &periph_h_regs, periph_clk_enb_refcnt);
+				    periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "tegra-apbdma");
 	clks[apbdma] = clk;
 
 	/* rtc */
 	clk = tegra_clk_register_periph_gate("rtc", "clk_32k",
 				    TEGRA_PERIPH_NO_RESET | TEGRA_PERIPH_ON_APB,
-				    clk_base, 0, 4, &periph_l_regs,
-				    periph_clk_enb_refcnt);
+				    clk_base, 0, 4, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "rtc-tegra");
 	clks[rtc] = clk;
 
 	/* timer */
 	clk = tegra_clk_register_periph_gate("timer", "clk_m", 0, clk_base, 0,
-				    5, &periph_l_regs, periph_clk_enb_refcnt);
+				    5, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "timer");
 	clks[timer] = clk;
 
 	/* kbc */
 	clk = tegra_clk_register_periph_gate("kbc", "clk_32k",
 				    TEGRA_PERIPH_NO_RESET | TEGRA_PERIPH_ON_APB,
-				    clk_base, 0, 36, &periph_h_regs,
-				    periph_clk_enb_refcnt);
+				    clk_base, 0, 36, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "tegra-kbc");
 	clks[kbc] = clk;
 
 	/* csus */
 	clk = tegra_clk_register_periph_gate("csus", "clk_m",
 				    TEGRA_PERIPH_NO_RESET | TEGRA_PERIPH_ON_APB,
-				    clk_base, 0, 92, &periph_u_regs,
-				    periph_clk_enb_refcnt);
+				    clk_base, 0, 92, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "csus", "tengra_camera");
 	clks[csus] = clk;
 
 	/* vcp */
 	clk = tegra_clk_register_periph_gate("vcp", "clk_m", 0, clk_base, 0, 29,
-				    &periph_l_regs, periph_clk_enb_refcnt);
+				    periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "vcp", "tegra-avp");
 	clks[vcp] = clk;
 
 	/* bsea */
 	clk = tegra_clk_register_periph_gate("bsea", "clk_m", 0, clk_base, 0,
-				    62, &periph_h_regs, periph_clk_enb_refcnt);
+				    62, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "bsea", "tegra-avp");
 	clks[bsea] = clk;
 
 	/* bsev */
 	clk = tegra_clk_register_periph_gate("bsev", "clk_m", 0, clk_base, 0,
-				    63, &periph_h_regs, periph_clk_enb_refcnt);
+				    63, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "bsev", "tegra-aes");
 	clks[bsev] = clk;
 
 	/* usbd */
 	clk = tegra_clk_register_periph_gate("usbd", "clk_m", 0, clk_base, 0,
-				    22, &periph_l_regs, periph_clk_enb_refcnt);
+				    22, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "fsl-tegra-udc");
 	clks[usbd] = clk;
 
 	/* usb2 */
 	clk = tegra_clk_register_periph_gate("usb2", "clk_m", 0, clk_base, 0,
-				    58, &periph_h_regs, periph_clk_enb_refcnt);
+				    58, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "tegra-ehci.1");
 	clks[usb2] = clk;
 
 	/* usb3 */
 	clk = tegra_clk_register_periph_gate("usb3", "clk_m", 0, clk_base, 0,
-				    59, &periph_h_regs, periph_clk_enb_refcnt);
+				    59, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "tegra-ehci.2");
 	clks[usb3] = clk;
 
 	/* dsia */
 	clk = tegra_clk_register_periph_gate("dsia", "pll_d_out0", 0, clk_base,
-				    0, 48, &periph_h_regs,
-				    periph_clk_enb_refcnt);
+				    0, 48, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "dsia", "tegradc.0");
 	clks[dsia] = clk;
 
 	/* csi */
 	clk = tegra_clk_register_periph_gate("csi", "pll_p_out3", 0, clk_base,
-				    0, 52, &periph_h_regs,
-				    periph_clk_enb_refcnt);
+				    0, 52, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "csi", "tegra_camera");
 	clks[csi] = clk;
 
 	/* isp */
 	clk = tegra_clk_register_periph_gate("isp", "clk_m", 0, clk_base, 0, 23,
-				    &periph_l_regs, periph_clk_enb_refcnt);
+				    periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "isp", "tegra_camera");
 	clks[isp] = clk;
 
 	/* pcie */
 	clk = tegra_clk_register_periph_gate("pcie", "clk_m", 0, clk_base, 0,
-				    70, &periph_u_regs, periph_clk_enb_refcnt);
+				    70, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "pcie", "tegra-pcie");
 	clks[pcie] = clk;
 
 	/* afi */
 	clk = tegra_clk_register_periph_gate("afi", "clk_m", 0, clk_base, 0, 72,
-				    &periph_u_regs, periph_clk_enb_refcnt);
+				    periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "afi", "tegra-pcie");
 	clks[afi] = clk;
 
 	/* pciex */
 	clk = tegra_clk_register_periph_gate("pciex", "pll_e", 0, clk_base, 0,
-				    74, &periph_u_regs, periph_clk_enb_refcnt);
+				    74, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "pciex", "tegra-pcie");
 	clks[pciex] = clk;
 
 	/* kfuse */
 	clk = tegra_clk_register_periph_gate("kfuse", "clk_m",
 				    TEGRA_PERIPH_ON_APB,
-				    clk_base, 0, 40, &periph_h_regs,
-				    periph_clk_enb_refcnt);
+				    clk_base, 0, 40, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "kfuse-tegra");
 	clks[kfuse] = clk;
 
 	/* fuse */
 	clk = tegra_clk_register_periph_gate("fuse", "clk_m",
 				    TEGRA_PERIPH_ON_APB,
-				    clk_base, 0, 39, &periph_h_regs,
-				    periph_clk_enb_refcnt);
+				    clk_base, 0, 39, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "fuse", "fuse-tegra");
 	clks[fuse] = clk;
 
 	/* fuse_burn */
 	clk = tegra_clk_register_periph_gate("fuse_burn", "clk_m",
 				    TEGRA_PERIPH_ON_APB,
-				    clk_base, 0, 39, &periph_h_regs,
-				    periph_clk_enb_refcnt);
+				    clk_base, 0, 39, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "fuse_burn", "fuse-tegra");
 	clks[fuse_burn] = clk;
 
 	/* apbif */
 	clk = tegra_clk_register_periph_gate("apbif", "clk_m", 0,
-				    clk_base, 0, 107, &periph_v_regs,
-				    periph_clk_enb_refcnt);
+				    clk_base, 0, 107, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "apbif", "tegra30-ahub");
 	clks[apbif] = clk;
 
 	/* hda2hdmi */
 	clk = tegra_clk_register_periph_gate("hda2hdmi", "clk_m",
 				    TEGRA_PERIPH_ON_APB,
-				    clk_base, 0, 128, &periph_w_regs,
-				    periph_clk_enb_refcnt);
+				    clk_base, 0, 128, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "hda2hdmi", "tegra30-hda");
 	clks[hda2hdmi] = clk;
 
 	/* sata_cold */
 	clk = tegra_clk_register_periph_gate("sata_cold", "clk_m",
 				    TEGRA_PERIPH_ON_APB,
-				    clk_base, 0, 129, &periph_w_regs,
-				    periph_clk_enb_refcnt);
+				    clk_base, 0, 129, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "tegra_sata_cold");
 	clks[sata_cold] = clk;
 
 	/* dtv */
 	clk = tegra_clk_register_periph_gate("dtv", "clk_m",
 				    TEGRA_PERIPH_ON_APB,
-				    clk_base, 0, 79, &periph_u_regs,
-				    periph_clk_enb_refcnt);
+				    clk_base, 0, 79, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, NULL, "dtv");
 	clks[dtv] = clk;
 
@@ -1694,7 +1606,7 @@ static void __init tegra30_periph_clk_init(void)
 			       clk_base + CLK_SOURCE_EMC,
 			       30, 2, 0, NULL);
 	clk = tegra_clk_register_periph_gate("emc", "emc_mux", 0, clk_base, 0,
-				    57, &periph_h_regs, periph_clk_enb_refcnt);
+				    57, periph_clk_enb_refcnt);
 	clk_register_clkdev(clk, "emc", NULL);
 	clks[emc] = clk;
 
@@ -2006,6 +1918,9 @@ static void __init tegra30_clock_init(struct device_node *np)
 		BUG();
 	}
 
+	if (tegra_clk_set_periph_banks(TEGRA30_CLK_PERIPH_BANKS) < 0)
+		return;
+
 	tegra30_osc_clk_init();
 	tegra30_fixed_clk_init();
 	tegra30_pll_init();
diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c
index 86581ac..07f76df 100644
--- a/drivers/clk/tegra/clk.c
+++ b/drivers/clk/tegra/clk.c
@@ -21,10 +21,114 @@
 
 #include "clk.h"
 
+#define CLK_OUT_ENB_L			0x010
+#define CLK_OUT_ENB_H			0x014
+#define CLK_OUT_ENB_U			0x018
+#define CLK_OUT_ENB_V			0x360
+#define CLK_OUT_ENB_W			0x364
+#define CLK_OUT_ENB_X			0x280
+#define CLK_OUT_ENB_SET_L		0x320
+#define CLK_OUT_ENB_CLR_L		0x324
+#define CLK_OUT_ENB_SET_H		0x328
+#define CLK_OUT_ENB_CLR_H		0x32c
+#define CLK_OUT_ENB_SET_U		0x330
+#define CLK_OUT_ENB_CLR_U		0x334
+#define CLK_OUT_ENB_SET_V		0x440
+#define CLK_OUT_ENB_CLR_V		0x444
+#define CLK_OUT_ENB_SET_W		0x448
+#define CLK_OUT_ENB_CLR_W		0x44c
+#define CLK_OUT_ENB_SET_X		0x284
+#define CLK_OUT_ENB_CLR_X		0x288
+
+#define RST_DEVICES_L			0x004
+#define RST_DEVICES_H			0x008
+#define RST_DEVICES_U			0x00C
+#define RST_DFLL_DVCO			0x2F4
+#define RST_DEVICES_V			0x358
+#define RST_DEVICES_W			0x35C
+#define RST_DEVICES_X			0x28C
+#define RST_DEVICES_SET_L		0x300
+#define RST_DEVICES_CLR_L		0x304
+#define RST_DEVICES_SET_H		0x308
+#define RST_DEVICES_CLR_H		0x30c
+#define RST_DEVICES_SET_U		0x310
+#define RST_DEVICES_CLR_U		0x314
+#define RST_DEVICES_SET_V		0x430
+#define RST_DEVICES_CLR_V		0x434
+#define RST_DEVICES_SET_W		0x438
+#define RST_DEVICES_CLR_W		0x43c
+
 /* Global data of Tegra CPU CAR ops */
 static struct tegra_cpu_car_ops dummy_car_ops;
 struct tegra_cpu_car_ops *tegra_cpu_car_ops = &dummy_car_ops;
 
+static int periph_banks;
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
+};
+
+struct tegra_clk_periph_regs *get_reg_bank(int clkid)
+{
+	int reg_bank = clkid / 32;
+
+	if (reg_bank < periph_banks)
+		return &periph_regs[reg_bank];
+	else {
+		WARN_ON(1);
+		return NULL;
+	}
+}
+
+int __init tegra_clk_set_periph_banks(int num)
+{
+	if (num > ARRAY_SIZE(periph_regs))
+		return -EINVAL;
+
+	periph_banks = num;
+
+	return 0;
+}
+
 void __init tegra_init_dup_clks(struct tegra_clk_duplicate *dup_list,
 				struct clk *clks[], int clk_max)
 {
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index 07cfacd..730d37b 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -400,8 +400,7 @@ void tegra_periph_reset(struct tegra_clk_periph_gate *gate, bool assert);
 extern const struct clk_ops tegra_clk_periph_gate_ops;
 struct clk *tegra_clk_register_periph_gate(const char *name,
 		const char *parent_name, u8 gate_flags, void __iomem *clk_base,
-		unsigned long flags, int clk_num,
-		struct tegra_clk_periph_regs *pregs, int *enable_refcnt);
+		unsigned long flags, int clk_num, int *enable_refcnt);
 
 /**
  * struct clk-periph - peripheral clock
@@ -443,7 +442,7 @@ struct clk *tegra_clk_register_periph_nodiv(const char *name,
 
 #define TEGRA_CLK_PERIPH(_mux_shift, _mux_mask, _mux_flags,		\
 			 _div_shift, _div_width, _div_frac_width,	\
-			 _div_flags, _clk_num, _enb_refcnt, _regs,	\
+			 _div_flags, _clk_num, _enb_refcnt,		\
 			 _gate_flags, _table)				\
 	{								\
 		.mux = {						\
@@ -462,7 +461,6 @@ struct clk *tegra_clk_register_periph_nodiv(const char *name,
 			.flags = _gate_flags,				\
 			.clk_num = _clk_num,				\
 			.enable_refcnt = _enb_refcnt,			\
-			.regs = _regs,					\
 		},							\
 		.mux_ops = &clk_mux_ops,				\
 		.div_ops = &tegra_clk_frac_div_ops,			\
@@ -483,7 +481,7 @@ struct tegra_periph_init_data {
 
 #define TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parent_names, _offset,\
 			_mux_shift, _mux_mask, _mux_flags, _div_shift,	\
-			_div_width, _div_frac_width, _div_flags, _regs,	\
+			_div_width, _div_frac_width, _div_flags,	\
 			_clk_num, _enb_refcnt, _gate_flags, _clk_id, _table,\
 			_flags) \
 	{								\
@@ -495,7 +493,7 @@ struct tegra_periph_init_data {
 					   _mux_flags, _div_shift,	\
 					   _div_width, _div_frac_width,	\
 					   _div_flags, _clk_num,	\
-					   _enb_refcnt, _regs,		\
+					   _enb_refcnt,			\
 					   _gate_flags, _table),	\
 		.offset = _offset,					\
 		.con_id = _con_id,					\
@@ -505,12 +503,12 @@ struct tegra_periph_init_data {
 
 #define TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parent_names, _offset,\
 			_mux_shift, _mux_width, _mux_flags, _div_shift,	\
-			_div_width, _div_frac_width, _div_flags, _regs,	\
+			_div_width, _div_frac_width, _div_flags, \
 			_clk_num, _enb_refcnt, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parent_names, _offset,\
 			_mux_shift, BIT(_mux_width) - 1, _mux_flags,	\
 			_div_shift, _div_width, _div_frac_width, _div_flags, \
-			_regs, _clk_num, _enb_refcnt, _gate_flags, _clk_id,\
+			_clk_num, _enb_refcnt, _gate_flags, _clk_id,\
 			NULL, 0)
 
 /**
@@ -587,6 +585,9 @@ void tegra_init_from_table(struct tegra_clk_init_table *tbl,
 void tegra_init_dup_clks(struct tegra_clk_duplicate *dup_list,
 		struct clk *clks[], int clk_max);
 
+struct tegra_clk_periph_regs *get_reg_bank(int clkid);
+int tegra_clk_set_periph_banks(int num);
+
 void tegra114_clock_tune_cpu_trimmers_high(void);
 void tegra114_clock_tune_cpu_trimmers_low(void);
 void tegra114_clock_tune_cpu_trimmers_init(void);
-- 
1.7.7.rc0.72.g4b5ea.dirty

