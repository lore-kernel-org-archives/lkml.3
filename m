Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbaG2ORZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 10:17:25 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:62480 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbaG2ORX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 10:17:23 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] clk: tegra: Implement memory-controller clock
Date: Tue, 29 Jul 2014 16:17:17 +0200
Message-Id: <1406643437-15682-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The memory controller clock runs either at half or the same frequency as
the EMC clock.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/clk/tegra/clk-tegra114.c         | 15 ++++++++++++++-
 drivers/clk/tegra/clk-tegra124.c         | 15 ++++++++++++++-
 drivers/clk/tegra/clk-tegra20.c          | 16 +++++++++++++++-
 drivers/clk/tegra/clk-tegra30.c          | 15 ++++++++++++++-
 include/dt-bindings/clock/tegra114-car.h |  2 +-
 include/dt-bindings/clock/tegra124-car.h |  2 +-
 include/dt-bindings/clock/tegra20-car.h  |  2 +-
 7 files changed, 60 insertions(+), 7 deletions(-)

diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index b9c8ba258ef0..340ed898dd2a 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -166,6 +166,7 @@ static DEFINE_SPINLOCK(pll_d_lock);
 static DEFINE_SPINLOCK(pll_d2_lock);
 static DEFINE_SPINLOCK(pll_u_lock);
 static DEFINE_SPINLOCK(pll_re_lock);
+static DEFINE_SPINLOCK(emc_lock);
 
 static struct div_nmp pllxc_nmp = {
 	.divm_shift = 0,
@@ -676,6 +677,12 @@ static const struct clk_div_table pll_re_div_table[] = {
 	{ .val = 0, .div = 0 },
 };
 
+static const struct clk_div_table mc_div_table[] = {
+	{ .val = 0, .div = 2 },
+	{ .val = 1, .div = 1 },
+	{ .val = 0, .div = 0 },
+};
+
 static struct tegra_clk tegra114_clks[tegra_clk_max] __initdata = {
 	[tegra_clk_rtc] = { .dt_id = TEGRA114_CLK_RTC, .present = true },
 	[tegra_clk_timer] = { .dt_id = TEGRA114_CLK_TIMER, .present = true },
@@ -1207,7 +1214,13 @@ static __init void tegra114_periph_clk_init(void __iomem *clk_base,
 			       ARRAY_SIZE(mux_pllmcp_clkm),
 			       CLK_SET_RATE_NO_REPARENT,
 			       clk_base + CLK_SOURCE_EMC,
-			       29, 3, 0, NULL);
+			       29, 3, 0, &emc_lock);
+
+	clk = clk_register_divider_table(NULL, "mc", "emc_mux", 0,
+					 clk_base + CLK_SOURCE_EMC,
+					 16, 1, 0, mc_div_table,
+					 &emc_lock);
+	clks[TEGRA114_CLK_MC] = clk;
 
 	tegra_periph_clk_init(clk_base, pmc_base, tegra114_clks,
 				&pll_p_params);
diff --git a/drivers/clk/tegra/clk-tegra124.c b/drivers/clk/tegra/clk-tegra124.c
index 9e9c3afab702..b88abebf2308 100644
--- a/drivers/clk/tegra/clk-tegra124.c
+++ b/drivers/clk/tegra/clk-tegra124.c
@@ -132,6 +132,7 @@ static DEFINE_SPINLOCK(pll_d2_lock);
 static DEFINE_SPINLOCK(pll_e_lock);
 static DEFINE_SPINLOCK(pll_re_lock);
 static DEFINE_SPINLOCK(pll_u_lock);
+static DEFINE_SPINLOCK(emc_lock);
 
 /* possible OSC frequencies in Hz */
 static unsigned long tegra124_input_freq[] = {
@@ -757,6 +758,12 @@ static const struct utmi_clk_param utmi_parameters[] = {
 	 .xtal_freq_count = 0xA4},
 };
 
+static const struct clk_div_table mc_div_table[] = {
+	{ .val = 0, .div = 2 },
+	{ .val = 1, .div = 1 },
+	{ .val = 0, .div = 0 },
+};
+
 static struct tegra_clk tegra124_clks[tegra_clk_max] __initdata = {
 	[tegra_clk_ispb] = { .dt_id = TEGRA124_CLK_ISPB, .present = true },
 	[tegra_clk_rtc] = { .dt_id = TEGRA124_CLK_RTC, .present = true },
@@ -1132,7 +1139,13 @@ static __init void tegra124_periph_clk_init(void __iomem *clk_base,
 	clk = clk_register_mux(NULL, "emc_mux", mux_pllmcp_clkm,
 			       ARRAY_SIZE(mux_pllmcp_clkm), 0,
 			       clk_base + CLK_SOURCE_EMC,
-			       29, 3, 0, NULL);
+			       29, 3, 0, &emc_lock);
+
+	clk = clk_register_divider_table(NULL, "mc", "emc_mux", 0,
+					 clk_base + CLK_SOURCE_EMC,
+					 16, 1, 0, mc_div_table,
+					 &emc_lock);
+	clks[TEGRA124_CLK_MC] = clk;
 
 	/* cml0 */
 	clk = clk_register_gate(NULL, "cml0", "pll_e", 0, clk_base + PLLE_AUX,
diff --git a/drivers/clk/tegra/clk-tegra20.c b/drivers/clk/tegra/clk-tegra20.c
index dace2b1b5ae6..1d1b05fcd7ec 100644
--- a/drivers/clk/tegra/clk-tegra20.c
+++ b/drivers/clk/tegra/clk-tegra20.c
@@ -140,6 +140,8 @@ static struct cpu_clk_suspend_context {
 static void __iomem *clk_base;
 static void __iomem *pmc_base;
 
+static DEFINE_SPINLOCK(emc_lock);
+
 #define TEGRA_INIT_DATA_MUX(_name, _parents, _offset,	\
 			    _clk_num, _gate_flags, _clk_id)	\
 	TEGRA_INIT_DATA(_name, NULL, NULL, _parents, _offset,	\
@@ -772,6 +774,12 @@ static const char *mux_pllpdc_clkm[] = {"pll_p", "pll_d_out0", "pll_c",
 					"clk_m"};
 static const char *mux_pllmcp_clkm[] = {"pll_m", "pll_c", "pll_p", "clk_m"};
 
+static const struct clk_div_table mc_div_table[] = {
+	{ .val = 0, .div = 2 },
+	{ .val = 1, .div = 1 },
+	{ .val = 0, .div = 0 },
+};
+
 static struct tegra_periph_init_data tegra_periph_clk_list[] = {
 	TEGRA_INIT_DATA_MUX("i2s1", i2s1_parents,     CLK_SOURCE_I2S1,   11, TEGRA_PERIPH_ON_APB, TEGRA20_CLK_I2S1),
 	TEGRA_INIT_DATA_MUX("i2s2", i2s2_parents,     CLK_SOURCE_I2S2,   18, TEGRA_PERIPH_ON_APB, TEGRA20_CLK_I2S2),
@@ -819,11 +827,17 @@ static void __init tegra20_periph_clk_init(void)
 			       ARRAY_SIZE(mux_pllmcp_clkm),
 			       CLK_SET_RATE_NO_REPARENT,
 			       clk_base + CLK_SOURCE_EMC,
-			       30, 2, 0, NULL);
+			       30, 2, 0, &emc_lock);
 	clk = tegra_clk_register_periph_gate("emc", "emc_mux", 0, clk_base, 0,
 				    57, periph_clk_enb_refcnt);
 	clks[TEGRA20_CLK_EMC] = clk;
 
+	clk = clk_register_divider_table(NULL, "mc", "emc_mux", 0,
+					 clk_base + CLK_SOURCE_EMC,
+					 16, 1, 0, mc_div_table,
+					 &emc_lock);
+	clks[TEGRA20_CLK_MC] = clk;
+
 	/* dsi */
 	clk = tegra_clk_register_periph_gate("dsi", "pll_d", 0, clk_base, 0,
 				    48, periph_clk_enb_refcnt);
diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
index 5bbacd01094f..65f0f076e124 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -177,6 +177,7 @@ static unsigned long input_freq;
 
 static DEFINE_SPINLOCK(cml_lock);
 static DEFINE_SPINLOCK(pll_d_lock);
+static DEFINE_SPINLOCK(emc_lock);
 
 #define TEGRA_INIT_DATA_MUX(_name, _parents, _offset,	\
 			    _clk_num, _gate_flags, _clk_id)	\
@@ -1115,6 +1116,12 @@ static const char *mux_plld_out0_plld2_out0[] = { "pll_d_out0",
 						  "pll_d2_out0" };
 static const char *pwm_parents[] = { "pll_p", "pll_c", "clk_32k", "clk_m" };
 
+static const struct clk_div_table mc_div_table[] = {
+	{ .val = 0, .div = 2 },
+	{ .val = 1, .div = 1 },
+	{ .val = 0, .div = 0 },
+};
+
 static struct tegra_periph_init_data tegra_periph_clk_list[] = {
 	TEGRA_INIT_DATA_MUX("spdif_out", spdif_out_parents, CLK_SOURCE_SPDIF_OUT, 10, TEGRA_PERIPH_ON_APB, TEGRA30_CLK_SPDIF_OUT),
 	TEGRA_INIT_DATA_MUX("d_audio", mux_pllacp_clkm, CLK_SOURCE_D_AUDIO, 106, 0, TEGRA30_CLK_D_AUDIO),
@@ -1157,11 +1164,17 @@ static void __init tegra30_periph_clk_init(void)
 			       ARRAY_SIZE(mux_pllmcp_clkm),
 			       CLK_SET_RATE_NO_REPARENT,
 			       clk_base + CLK_SOURCE_EMC,
-			       30, 2, 0, NULL);
+			       30, 2, 0, &emc_lock);
 	clk = tegra_clk_register_periph_gate("emc", "emc_mux", 0, clk_base, 0,
 				    57, periph_clk_enb_refcnt);
 	clks[TEGRA30_CLK_EMC] = clk;
 
+	clk = clk_register_divider_table(NULL, "mc", "emc_mux", 0,
+					 clk_base + CLK_SOURCE_EMC,
+					 16, 1, 0, mc_div_table,
+					 &emc_lock);
+	clks[TEGRA30_CLK_MC] = clk;
+
 	/* cml0 */
 	clk = clk_register_gate(NULL, "cml0", "pll_e", 0, clk_base + PLLE_AUX,
 				0, 0, &cml_lock);
diff --git a/include/dt-bindings/clock/tegra114-car.h b/include/dt-bindings/clock/tegra114-car.h
index fc12621fb432..534c03f8ad72 100644
--- a/include/dt-bindings/clock/tegra114-car.h
+++ b/include/dt-bindings/clock/tegra114-car.h
@@ -49,7 +49,7 @@
 #define TEGRA114_CLK_I2S0 30
 /* 31 */
 
-/* 32 */
+#define TEGRA114_CLK_MC 32
 /* 33 */
 #define TEGRA114_CLK_APBDMA 34
 /* 35 */
diff --git a/include/dt-bindings/clock/tegra124-car.h b/include/dt-bindings/clock/tegra124-car.h
index 8a4c5892890f..a75b9b8f0d5d 100644
--- a/include/dt-bindings/clock/tegra124-car.h
+++ b/include/dt-bindings/clock/tegra124-car.h
@@ -48,7 +48,7 @@
 #define TEGRA124_CLK_I2S0 30
 /* 31 */
 
-/* 32 */
+#define TEGRA124_CLK_MC 32
 /* 33 */
 #define TEGRA124_CLK_APBDMA 34
 /* 35 */
diff --git a/include/dt-bindings/clock/tegra20-car.h b/include/dt-bindings/clock/tegra20-car.h
index 9406207cfac8..04500b243a4d 100644
--- a/include/dt-bindings/clock/tegra20-car.h
+++ b/include/dt-bindings/clock/tegra20-car.h
@@ -49,7 +49,7 @@
 /* 30 */
 #define TEGRA20_CLK_CACHE2 31
 
-#define TEGRA20_CLK_MEM 32
+#define TEGRA20_CLK_MC 32
 #define TEGRA20_CLK_AHBDMA 33
 #define TEGRA20_CLK_APBDMA 34
 /* 35 */
-- 
2.0.2

