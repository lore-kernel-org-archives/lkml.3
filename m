Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab3IWO3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 10:29:23 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:17147 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab3IWO3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 10:29:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 23 Sep 2013 07:25:46 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Joseph Lo <josephl@nvidia.com>, Paul Walmsley <pwalmsley@nvidia.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH v2 02/12] clk: tegra: common periph_clk_enb_refcnt and clks
Date: Mon, 23 Sep 2013 17:24:54 +0300
Message-ID: <1379946381-20125-3-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1379946381-20125-1-git-send-email-pdeschrijver@nvidia.com>
References: <1379946381-20125-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes periph_clk_enb_refcnt a global array, dynamically allocated
at boottime. It simplifies the macros somewhat and allows clocks common to
several Tegra SoCs to be defined in a separate files. Also the clks array
becomes global and dynamically allocated which allows the DT registration to
be moved to a generic funcion.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/tegra/clk-periph.c   |    1 +
 drivers/clk/tegra/clk-tegra114.c |   59 ++++++++++---------------------------
 drivers/clk/tegra/clk-tegra20.c  |   39 +++++++------------------
 drivers/clk/tegra/clk-tegra30.c  |   43 +++++++++------------------
 drivers/clk/tegra/clk.c          |   45 +++++++++++++++++++++++++---
 drivers/clk/tegra/clk.h          |   18 ++++++-----
 6 files changed, 93 insertions(+), 112 deletions(-)

diff --git a/drivers/clk/tegra/clk-periph.c b/drivers/clk/tegra/clk-periph.c
index b2309d3..55ab4b1 100644
--- a/drivers/clk/tegra/clk-periph.c
+++ b/drivers/clk/tegra/clk-periph.c
@@ -191,6 +191,7 @@ static struct clk *_tegra_clk_register_periph(const char *name,
 	periph->mux.reg = clk_base + offset;
 	periph->divider.reg = div ? (clk_base + offset) : NULL;
 	periph->gate.clk_base = clk_base;
+	periph->gate.enable_refcnt = periph_clk_enb_refcnt;
 
 	clk = clk_register(NULL, &periph->hw);
 	if (IS_ERR(clk))
diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index 2ec3488..ccb61bc 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -57,8 +57,6 @@
 #define CPU_FINETRIM_R_FCPU_6_SHIFT	10		/* ftop */
 #define CPU_FINETRIM_R_FCPU_6_MASK	(0x3 << CPU_FINETRIM_R_FCPU_6_SHIFT)
 
-#define CLK_OUT_ENB_NUM			6
-
 #define PLLC_BASE 0x80
 #define PLLC_MISC2 0x88
 #define PLLC_MISC 0x8c
@@ -264,8 +262,6 @@ static struct cpu_clk_suspend_context {
 } tegra114_cpu_clk_sctx;
 #endif
 
-static int periph_clk_enb_refcnt[CLK_OUT_ENB_NUM * 32];
-
 static void __iomem *clk_base;
 static void __iomem *pmc_base;
 
@@ -710,78 +706,68 @@ static unsigned long tegra114_input_freq[] = {
 			    _clk_num, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
 			30, MASK(2), 0, 0, 8, 1, 0, 0,\
-			_clk_num, periph_clk_enb_refcnt, _gate_flags,\
-			 _clk_id, _parents##_idx, 0)
+			_clk_num,  _gate_flags, _clk_id, _parents##_idx, 0)
 
 #define TEGRA_INIT_DATA_MUX_FLAGS(_name, _con_id, _dev_id, _parents, _offset,\
 			    _clk_num, _gate_flags, _clk_id, flags)\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
 			30, MASK(2), 0, 0, 8, 1, 0, 0, _clk_num,	\
-			periph_clk_enb_refcnt, _gate_flags, _clk_id,	\
-			_parents##_idx, flags)
+			_gate_flags, _clk_id, _parents##_idx, flags)
 
 #define TEGRA_INIT_DATA_MUX8(_name, _con_id, _dev_id, _parents, _offset, \
 			     _clk_num, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
 			29, MASK(3), 0, 0, 8, 1, 0, 0, _clk_num,	\
-			periph_clk_enb_refcnt, _gate_flags, _clk_id,	\
-			_parents##_idx, 0)
+			_gate_flags, _clk_id, _parents##_idx, 0)
 
 #define TEGRA_INIT_DATA_INT(_name, _con_id, _dev_id, _parents, _offset,	\
 			    _clk_num, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
 			30, MASK(2), 0, 0, 8, 1, TEGRA_DIVIDER_INT, 0,\
-			_clk_num, periph_clk_enb_refcnt, _gate_flags,	\
-			_clk_id, _parents##_idx, 0)
+			_clk_num, _gate_flags, _clk_id, _parents##_idx, 0)
 
 #define TEGRA_INIT_DATA_INT_FLAGS(_name, _con_id, _dev_id, _parents, _offset,\
 			    _clk_num, _gate_flags, _clk_id, flags)\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
 			30, MASK(2), 0, 0, 8, 1, TEGRA_DIVIDER_INT, 0,\
-			_clk_num, periph_clk_enb_refcnt, _gate_flags,	\
-			_clk_id, _parents##_idx, flags)
+			_clk_num,  _gate_flags, _clk_id, _parents##_idx, flags)
 
 #define TEGRA_INIT_DATA_INT8(_name, _con_id, _dev_id, _parents, _offset,\
 			    _clk_num, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
 			29, MASK(3), 0, 0, 8, 1, TEGRA_DIVIDER_INT, 0,\
-			_clk_num, periph_clk_enb_refcnt, _gate_flags,	\
-			_clk_id, _parents##_idx, 0)
+			_clk_num, _gate_flags, _clk_id, _parents##_idx, 0)
 
 #define TEGRA_INIT_DATA_UART(_name, _con_id, _dev_id, _parents, _offset,\
 			     _clk_num, _clk_id)			\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
 			30, MASK(2), 0, 0, 16, 1, TEGRA_DIVIDER_UART, 0,\
-			_clk_num, periph_clk_enb_refcnt, 0, _clk_id,	\
-			_parents##_idx, 0)
+			_clk_num, 0, _clk_id, _parents##_idx, 0)
 
 #define TEGRA_INIT_DATA_I2C(_name, _con_id, _dev_id, _parents, _offset,\
 			     _clk_num, _clk_id)			\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
 			30, MASK(2), 0, 0, 16, 0, 0, 0, _clk_num,	\
-			periph_clk_enb_refcnt, 0, _clk_id, _parents##_idx, 0)
+			0, _clk_id, _parents##_idx, 0)
 
 #define TEGRA_INIT_DATA_NODIV(_name, _con_id, _dev_id, _parents, _offset, \
 			      _mux_shift, _mux_mask, _clk_num, \
 			      _gate_flags, _clk_id)			\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset,\
 			_mux_shift, _mux_mask, 0, 0, 0, 0, 0, 0,	\
-			_clk_num, periph_clk_enb_refcnt, _gate_flags,	\
-			_clk_id, _parents##_idx, 0)
+			_clk_num, _gate_flags, _clk_id, _parents##_idx, 0)
 
 #define TEGRA_INIT_DATA_XUSB(_name, _con_id, _dev_id, _parents, _offset, \
 			     _clk_num, _gate_flags, _clk_id)	 \
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parents, _offset, \
 			29, MASK(3), 0, 0, 8, 1, TEGRA_DIVIDER_INT, 0, \
-			_clk_num, periph_clk_enb_refcnt, _gate_flags,	 \
-			_clk_id, _parents##_idx, 0)
+			_clk_num, _gate_flags, _clk_id, _parents##_idx, 0)
 
 #define TEGRA_INIT_DATA_AUDIO(_name, _con_id, _dev_id, _offset,  _clk_num,\
 				 _gate_flags, _clk_id)		\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, mux_d_audio_clk,	\
 			_offset, 16, 0xE01F, 0, 0, 8, 1, 0, 0, _clk_num, \
-			periph_clk_enb_refcnt, _gate_flags , _clk_id,	\
-			mux_d_audio_clk_idx, 0)
+			_gate_flags , _clk_id,	mux_d_audio_clk_idx, 0)
 
 struct utmi_clk_param {
 	/* Oscillator Frequency in KHz */
@@ -946,8 +932,7 @@ static const struct clk_div_table pll_re_div_table[] = {
 	{ .val = 0, .div = 0 },
 };
 
-static struct clk *clks[TEGRA114_CLK_CLK_MAX];
-static struct clk_onecell_data clk_data;
+static struct clk **clks;
 
 static unsigned long osc_freq;
 static unsigned long pll_ref_freq;
@@ -2232,7 +2217,6 @@ EXPORT_SYMBOL(tegra114_clock_deassert_dfll_dvco_reset);
 static void __init tegra114_clock_init(struct device_node *np)
 {
 	struct device_node *node;
-	int i;
 
 	clk_base = of_iomap(np, 0);
 	if (!clk_base) {
@@ -2254,10 +2238,11 @@ static void __init tegra114_clock_init(struct device_node *np)
 		return;
 	}
 
-	if (tegra114_osc_clk_init(clk_base) < 0)
+	clks = tegra_clk_init(TEGRA114_CLK_CLK_MAX, 5);
+	if (!clks)
 		return;
 
-	if (tegra_clk_periph_banks(5) < 0)
+	if (tegra114_osc_clk_init(clk_base) < 0)
 		return;
 
 	tegra114_fixed_clk_init(clk_base);
@@ -2267,19 +2252,7 @@ static void __init tegra114_clock_init(struct device_node *np)
 	tegra114_pmc_clk_init(pmc_base);
 	tegra114_super_clk_init(clk_base);
 
-	for (i = 0; i < ARRAY_SIZE(clks); i++) {
-		if (IS_ERR(clks[i])) {
-			pr_err
-			    ("Tegra114 clk %d: register failed with %ld\n",
-			     i, PTR_ERR(clks[i]));
-		}
-		if (!clks[i])
-			clks[i] = ERR_PTR(-EINVAL);
-	}
-
-	clk_data.clks = clks;
-	clk_data.clk_num = ARRAY_SIZE(clks);
-	of_clk_add_provider(np, of_clk_src_onecell_get, &clk_data);
+	tegra_add_of_provider(np);
 
 	tegra_clk_apply_init_table = tegra114_clock_apply_init_table;
 
diff --git a/drivers/clk/tegra/clk-tegra20.c b/drivers/clk/tegra/clk-tegra20.c
index ebe94ce..1d28f49 100644
--- a/drivers/clk/tegra/clk-tegra20.c
+++ b/drivers/clk/tegra/clk-tegra20.c
@@ -188,8 +188,6 @@ static struct cpu_clk_suspend_context {
 } tegra20_cpu_clk_sctx;
 #endif
 
-static int periph_clk_enb_refcnt[CLK_OUT_ENB_NUM * 32];
-
 static void __iomem *clk_base;
 static void __iomem *pmc_base;
 
@@ -200,30 +198,26 @@ static DEFINE_SPINLOCK(sysrate_lock);
 			    _clk_num, _regs, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
 			30, 2, 0, 0, 8, 1, TEGRA_DIVIDER_ROUND_UP,	\
-			_regs, _clk_num, periph_clk_enb_refcnt,		\
-			_gate_flags, _clk_id)
+			_regs, _clk_num, _gate_flags, _clk_id)
 
 #define TEGRA_INIT_DATA_INT(_name, _con_id, _dev_id, _parents, _offset,	\
 			    _clk_num, _regs, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
 			30, 2, 0, 0, 8, 1, TEGRA_DIVIDER_INT, _regs,	\
-			_clk_num, periph_clk_enb_refcnt, _gate_flags,	\
-			_clk_id)
+			_clk_num, _gate_flags, _clk_id)
 
 #define TEGRA_INIT_DATA_DIV16(_name, _con_id, _dev_id, _parents, _offset, \
 			      _clk_num, _regs, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
 			30, 2, 0, 0, 16, 0, TEGRA_DIVIDER_ROUND_UP, _regs, \
-			_clk_num, periph_clk_enb_refcnt, _gate_flags,	\
-			_clk_id)
+			_clk_num, _gate_flags, _clk_id)
 
 #define TEGRA_INIT_DATA_NODIV(_name, _con_id, _dev_id, _parents, _offset, \
 			      _mux_shift, _mux_width, _clk_num, _regs,	\
 			      _gate_flags, _clk_id)			\
 	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
 			_mux_shift, _mux_width, 0, 0, 0, 0, 0, _regs,	\
-			_clk_num, periph_clk_enb_refcnt, _gate_flags,	\
-			_clk_id)
+			_clk_num, _gate_flags, _clk_id)
 
 /* IDs assigned here must be in sync with DT bindings definition
  * for Tegra20 clocks .
@@ -244,8 +238,7 @@ enum tegra20_clk {
 	pll_x, cop, audio, pll_ref, twd, clk_max,
 };
 
-static struct clk *clks[clk_max];
-static struct clk_onecell_data clk_data;
+static struct clk **clks;
 
 static struct tegra_clk_pll_freq_table pll_c_freq_table[] = {
 	{ 12000000, 600000000, 600, 12, 0, 8 },
@@ -853,7 +846,7 @@ static struct tegra_periph_init_data tegra_periph_clk_list[] = {
 	TEGRA_INIT_DATA_DIV16("i2c3",	"div-clk",	"tegra-i2c.2",	 mux_pllpcm_clkm,   CLK_SOURCE_I2C3,	  67,	&periph_u_regs,	TEGRA_PERIPH_ON_APB, i2c3),
 	TEGRA_INIT_DATA_DIV16("dvc",	"div-clk",	"tegra-i2c.3",	 mux_pllpcm_clkm,   CLK_SOURCE_DVC,	  47,	&periph_h_regs,	TEGRA_PERIPH_ON_APB, dvc),
 	TEGRA_INIT_DATA_MUX("hdmi",	NULL,		"hdmi",		 mux_pllpdc_clkm,   CLK_SOURCE_HDMI,	  51,	&periph_h_regs,	0, hdmi),
-	TEGRA_INIT_DATA("pwm",		NULL,		"tegra-pwm",	 pwm_parents,	    CLK_SOURCE_PWM,	  28, 3, 0, 0, 8, 1, 0, &periph_l_regs, 17, periph_clk_enb_refcnt, TEGRA_PERIPH_ON_APB, pwm),
+	TEGRA_INIT_DATA("pwm",		NULL,		"tegra-pwm",	 pwm_parents,	    CLK_SOURCE_PWM,	  28, 3, 0, 0, 8, 1, 0, &periph_l_regs, 17, TEGRA_PERIPH_ON_APB, pwm),
 };
 
 static struct tegra_periph_init_data tegra_periph_nodiv_clk_list[] = {
@@ -1289,7 +1282,6 @@ static const struct of_device_id pmc_match[] __initconst = {
 
 static void __init tegra20_clock_init(struct device_node *np)
 {
-	int i;
 	struct device_node *node;
 
 	clk_base = of_iomap(np, 0);
@@ -1310,6 +1302,10 @@ static void __init tegra20_clock_init(struct device_node *np)
 		BUG();
 	}
 
+	clks = tegra_clk_init(clk_max, 3);
+	if (!clks)
+		return;
+
 	tegra20_osc_clk_init();
 	tegra20_pmc_clk_init();
 	tegra20_fixed_clk_init();
@@ -1318,22 +1314,9 @@ static void __init tegra20_clock_init(struct device_node *np)
 	tegra20_periph_clk_init();
 	tegra20_audio_clk_init();
 
-
-	for (i = 0; i < ARRAY_SIZE(clks); i++) {
-		if (IS_ERR(clks[i])) {
-			pr_err("Tegra20 clk %d: register failed with %ld\n",
-			       i, PTR_ERR(clks[i]));
-			BUG();
-		}
-		if (!clks[i])
-			clks[i] = ERR_PTR(-EINVAL);
-	}
-
 	tegra_init_dup_clks(tegra_clk_duplicates, clks, clk_max);
 
-	clk_data.clks = clks;
-	clk_data.clk_num = ARRAY_SIZE(clks);
-	of_clk_add_provider(np, of_clk_src_onecell_get, &clk_data);
+	tegra_add_of_provider(np);
 
 	tegra_clk_apply_init_table = tegra20_clock_apply_init_table;
 
diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
index ab35040..b0fd613 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -266,8 +266,6 @@ static struct cpu_clk_suspend_context {
 } tegra30_cpu_clk_sctx;
 #endif
 
-static int periph_clk_enb_refcnt[CLK_OUT_ENB_NUM * 32];
-
 static void __iomem *clk_base;
 static void __iomem *pmc_base;
 static unsigned long input_freq;
@@ -283,41 +281,38 @@ static DEFINE_SPINLOCK(sysrate_lock);
 			    _clk_num, _regs, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
 			30, 2, 0, 0, 8, 1, 0, _regs, _clk_num,		\
-			periph_clk_enb_refcnt, _gate_flags, _clk_id)
+			 _gate_flags, _clk_id)
 
 #define TEGRA_INIT_DATA_DIV16(_name, _con_id, _dev_id, _parents, _offset, \
 			    _clk_num, _regs, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
 			30, 2, 0, 0, 16, 0, TEGRA_DIVIDER_ROUND_UP,	\
-			_regs, _clk_num, periph_clk_enb_refcnt,		\
-			_gate_flags, _clk_id)
+			_regs, _clk_num,  _gate_flags, _clk_id)
 
 #define TEGRA_INIT_DATA_MUX8(_name, _con_id, _dev_id, _parents, _offset, \
 			     _clk_num, _regs, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
 			29, 3, 0, 0, 8, 1, 0, _regs, _clk_num,		\
-			periph_clk_enb_refcnt, _gate_flags, _clk_id)
+			_gate_flags, _clk_id)
 
 #define TEGRA_INIT_DATA_INT(_name, _con_id, _dev_id, _parents, _offset,	\
 			    _clk_num, _regs, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
 			30, 2, 0, 0, 8, 1, TEGRA_DIVIDER_INT, _regs,	\
-			_clk_num, periph_clk_enb_refcnt, _gate_flags,	\
-			_clk_id)
+			_clk_num, _gate_flags, _clk_id)
 
 #define TEGRA_INIT_DATA_UART(_name, _con_id, _dev_id, _parents, _offset,\
 			     _clk_num, _regs, _clk_id)			\
 	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
 			30, 2, 0, 0, 16, 1, TEGRA_DIVIDER_UART, _regs,	\
-			_clk_num, periph_clk_enb_refcnt, 0, _clk_id)
+			_clk_num, 0, _clk_id)
 
 #define TEGRA_INIT_DATA_NODIV(_name, _con_id, _dev_id, _parents, _offset, \
 			      _mux_shift, _mux_width, _clk_num, _regs,	\
 			      _gate_flags, _clk_id)			\
 	TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parents, _offset,	\
 			_mux_shift, _mux_width, 0, 0, 0, 0, 0, _regs,	\
-			_clk_num, periph_clk_enb_refcnt, _gate_flags,	\
-			_clk_id)
+			_clk_num, _gate_flags, _clk_id)
 
 /*
  * IDs assigned here must be in sync with DT bindings definition
@@ -347,8 +342,7 @@ enum tegra30_clk {
 	hclk, pclk, clk_out_1_mux = 300, clk_max
 };
 
-static struct clk *clks[clk_max];
-static struct clk_onecell_data clk_data;
+static struct clk **clks;
 
 /*
  * Structure defining the fields for USB UTMI clocks Parameters.
@@ -1497,7 +1491,7 @@ static struct tegra_periph_init_data tegra_periph_clk_list[] = {
 	TEGRA_INIT_DATA_MUX8("extern1",	NULL,		"extern1",		mux_plla_clk32k_pllp_clkm_plle,	CLK_SOURCE_EXTERN1,	120,	&periph_v_regs,	0, extern1),
 	TEGRA_INIT_DATA_MUX8("extern2",	NULL,		"extern2",		mux_plla_clk32k_pllp_clkm_plle,	CLK_SOURCE_EXTERN2,	121,	&periph_v_regs,	0, extern2),
 	TEGRA_INIT_DATA_MUX8("extern3",	NULL,		"extern3",		mux_plla_clk32k_pllp_clkm_plle,	CLK_SOURCE_EXTERN3,	122,	&periph_v_regs,	0, extern3),
-	TEGRA_INIT_DATA("pwm",		NULL,		"pwm",			mux_pllpc_clk32k_clkm,	CLK_SOURCE_PWM,		28, 2, 0, 0, 8, 1, 0, &periph_l_regs, 17, periph_clk_enb_refcnt, 0, pwm),
+	TEGRA_INIT_DATA("pwm",		NULL,		"pwm",			mux_pllpc_clk32k_clkm,	CLK_SOURCE_PWM,		28, 2, 0, 0, 8, 1, 0, &periph_l_regs, 17, 0, pwm),
 };
 
 static struct tegra_periph_init_data tegra_periph_nodiv_clk_list[] = {
@@ -1975,7 +1969,6 @@ static const struct of_device_id pmc_match[] __initconst = {
 static void __init tegra30_clock_init(struct device_node *np)
 {
 	struct device_node *node;
-	int i;
 
 	clk_base = of_iomap(np, 0);
 	if (!clk_base) {
@@ -1995,6 +1988,12 @@ static void __init tegra30_clock_init(struct device_node *np)
 		BUG();
 	}
 
+	clks = tegra_clk_init(clk_max, 5);
+	if (!clks) {
+		WARN_ON(1);
+		return;
+	}
+
 	tegra30_osc_clk_init();
 	tegra30_fixed_clk_init();
 	tegra30_pll_init();
@@ -2003,21 +2002,9 @@ static void __init tegra30_clock_init(struct device_node *np)
 	tegra30_audio_clk_init();
 	tegra30_pmc_clk_init();
 
-	for (i = 0; i < ARRAY_SIZE(clks); i++) {
-		if (IS_ERR(clks[i])) {
-			pr_err("Tegra30 clk %d: register failed with %ld\n",
-			       i, PTR_ERR(clks[i]));
-			BUG();
-		}
-		if (!clks[i])
-			clks[i] = ERR_PTR(-EINVAL);
-	}
-
 	tegra_init_dup_clks(tegra_clk_duplicates, clks, clk_max);
 
-	clk_data.clks = clks;
-	clk_data.clk_num = ARRAY_SIZE(clks);
-	of_clk_add_provider(np, of_clk_src_onecell_get, &clk_data);
+	tegra_add_of_provider(np);
 
 	tegra_clk_apply_init_table = tegra30_clock_apply_init_table;
 
diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c
index 0508dd1..1253217 100644
--- a/drivers/clk/tegra/clk.c
+++ b/drivers/clk/tegra/clk.c
@@ -64,6 +64,9 @@ struct tegra_cpu_car_ops *tegra_cpu_car_ops = &dummy_car_ops;
 
 int *periph_clk_enb_refcnt;
 static int periph_banks;
+static struct clk **clks;
+static int clk_num;
+static struct clk_onecell_data clk_data;
 
 static struct tegra_clk_periph_regs periph_regs[] = {
 	[0] = {
@@ -120,14 +123,27 @@ struct tegra_clk_periph_regs * __init get_reg_bank(int clkid)
 	}
 }
 
-int __init tegra_clk_periph_banks(int num)
+struct clk ** __init tegra_clk_init(int num, int banks)
 {
-	if (num > ARRAY_SIZE(periph_regs))
-		return -EINVAL;
+	if (banks > ARRAY_SIZE(periph_regs)) {
+		WARN_ON(1);
+		return NULL;
+	}
+
+	periph_clk_enb_refcnt = kzalloc(32 * banks *
+				sizeof(*periph_clk_enb_refcnt), GFP_KERNEL);
+	if (!periph_clk_enb_refcnt)
+		return NULL;
+
+	periph_banks = banks;
+
+	clks = kzalloc(num * sizeof(struct clk *), GFP_KERNEL);
+	if (!clks)
+		kfree(periph_clk_enb_refcnt);
 
-	periph_banks = num;
+	clk_num = num;
 
-	return 0;
+	return clks;
 }
 
 void __init tegra_init_dup_clks(struct tegra_clk_duplicate *dup_list,
@@ -179,6 +195,25 @@ void __init tegra_init_from_table(struct tegra_clk_init_table *tbl,
 	}
 }
 
+void __init tegra_add_of_provider(struct device_node *np)
+{
+	int i;
+
+	for (i = 0; i < clk_num; i++) {
+		if (IS_ERR(clks[i])) {
+			pr_err
+			    ("Tegra clk %d: register failed with %ld\n",
+			     i, PTR_ERR(clks[i]));
+		}
+		if (!clks[i])
+			clks[i] = ERR_PTR(-EINVAL);
+	}
+
+	clk_data.clks = clks;
+	clk_data.clk_num = clk_num;
+	of_clk_add_provider(np, of_clk_src_onecell_get, &clk_data);
+}
+
 tegra_clk_apply_init_table_func tegra_clk_apply_init_table;
 
 void __init tegra_clocks_apply_init_table(void)
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index da1e01f..4fdaef4 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -37,6 +37,8 @@ struct tegra_clk_sync_source {
 	container_of(_hw, struct tegra_clk_sync_source, hw)
 
 extern const struct clk_ops tegra_clk_sync_source_ops;
+extern int *periph_clk_enb_refcnt;
+
 struct clk *tegra_clk_register_sync_source(const char *name,
 		unsigned long fixed_rate, unsigned long max_rate);
 
@@ -443,7 +445,7 @@ struct clk *tegra_clk_register_periph_nodiv(const char *name,
 
 #define TEGRA_CLK_PERIPH(_mux_shift, _mux_mask, _mux_flags,		\
 			 _div_shift, _div_width, _div_frac_width,	\
-			 _div_flags, _clk_num, _enb_refcnt, _regs,	\
+			 _div_flags, _clk_num,  _regs,			\
 			 _gate_flags, _table)				\
 	{								\
 		.mux = {						\
@@ -461,7 +463,6 @@ struct clk *tegra_clk_register_periph_nodiv(const char *name,
 		.gate = {						\
 			.flags = _gate_flags,				\
 			.clk_num = _clk_num,				\
-			.enable_refcnt = _enb_refcnt,			\
 			.regs = _regs,					\
 		},							\
 		.mux_ops = &clk_mux_ops,				\
@@ -484,8 +485,7 @@ struct tegra_periph_init_data {
 #define TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parent_names, _offset,\
 			_mux_shift, _mux_mask, _mux_flags, _div_shift,	\
 			_div_width, _div_frac_width, _div_flags, _regs,	\
-			_clk_num, _enb_refcnt, _gate_flags, _clk_id, _table,\
-			_flags) \
+			_clk_num, _gate_flags, _clk_id, _table, _flags) \
 	{								\
 		.name = _name,						\
 		.clk_id = _clk_id,					\
@@ -495,7 +495,7 @@ struct tegra_periph_init_data {
 					   _mux_flags, _div_shift,	\
 					   _div_width, _div_frac_width,	\
 					   _div_flags, _clk_num,	\
-					   _enb_refcnt, _regs,		\
+					   _regs,			\
 					   _gate_flags, _table),	\
 		.offset = _offset,					\
 		.con_id = _con_id,					\
@@ -506,11 +506,11 @@ struct tegra_periph_init_data {
 #define TEGRA_INIT_DATA(_name, _con_id, _dev_id, _parent_names, _offset,\
 			_mux_shift, _mux_width, _mux_flags, _div_shift,	\
 			_div_width, _div_frac_width, _div_flags, _regs,	\
-			_clk_num, _enb_refcnt, _gate_flags, _clk_id)	\
+			_clk_num, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA_TABLE(_name, _con_id, _dev_id, _parent_names, _offset,\
 			_mux_shift, BIT(_mux_width) - 1, _mux_flags,	\
 			_div_shift, _div_width, _div_frac_width, _div_flags, \
-			_regs, _clk_num, _enb_refcnt, _gate_flags, _clk_id,\
+			_regs, _clk_num, _gate_flags, _clk_id,\
 			NULL, 0)
 
 /**
@@ -588,7 +588,9 @@ void tegra_init_dup_clks(struct tegra_clk_duplicate *dup_list,
 		struct clk *clks[], int clk_max);
 
 struct tegra_clk_periph_regs *get_reg_bank(int clkid);
-int tegra_clk_periph_banks(int num);
+struct clk **tegra_clk_init(int num, int periph_banks);
+
+void tegra_add_of_provider(struct device_node *np);
 
 void tegra114_clock_tune_cpu_trimmers_high(void);
 void tegra114_clock_tune_cpu_trimmers_low(void);
-- 
1.7.7.rc0.72.g4b5ea.dirty

