Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab3AVQju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 11:39:50 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:53338 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539Ab3AVQjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 11:39:47 -0500
From: Afzal Mohammed <afzal@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <spear-devel@list.st.com>
CC: Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Paul Walmsley <paul@pwsan.com>,
        Tony Lindgren <tony@atomide.com>,
        Mike Turquette <mturquette@linaro.org>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Chao Xie <xiechao.mail@gmail.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/2] clk: divider: prepare for minimum divider
Date: Tue, 22 Jan 2013 22:09:00 +0530
Message-ID: <d20165dfc67970c3429b9d95ac9631015f8b2396.1358870920.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of clocks can have a limit on minimum divider value that can be
programmed, prepare for such a support.

Add a new field min_div for the basic divider clock. Enhance runtime
registration and static definition helper of basic clock divider so
that minimum divider value can be specified and modify all call sites.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Viresh Kumar <viresh.linux@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Chao Xie <xiechao.mail@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
---

Based on v3.8-rc3, tested on am335x evm.

 arch/arm/mach-imx/clk-imx6q.c         |  4 +-
 arch/arm/mach-imx/clk.h               |  4 +-
 arch/arm/mach-omap2/cclock2420_data.c | 12 +++---
 arch/arm/mach-omap2/cclock2430_data.c |  9 ++--
 arch/arm/mach-omap2/cclock33xx_data.c | 25 ++++++-----
 arch/arm/mach-omap2/cclock3xxx_data.c | 49 +++++++++++----------
 arch/arm/mach-omap2/cclock44xx_data.c | 81 +++++++++++++++++++++--------------
 drivers/clk/clk-divider.c             | 13 +++---
 drivers/clk/clk-ls1x.c                |  9 ++--
 drivers/clk/mmp/clk-mmp2.c            | 24 +++++++----
 drivers/clk/mmp/clk-pxa168.c          |  3 +-
 drivers/clk/mmp/clk-pxa910.c          |  3 +-
 drivers/clk/spear/spear3xx_clock.c    |  6 ++-
 include/linux/clk-private.h           | 16 ++++---
 include/linux/clk-provider.h          |  7 ++-
 15 files changed, 159 insertions(+), 106 deletions(-)

diff --git a/arch/arm/mach-imx/clk-imx6q.c b/arch/arm/mach-imx/clk-imx6q.c
index 7f2c10c..aa901b2 100644
--- a/arch/arm/mach-imx/clk-imx6q.c
+++ b/arch/arm/mach-imx/clk-imx6q.c
@@ -218,8 +218,8 @@ int __init mx6q_clocks_init(void)
 	clk[pcie_ref_125m] = imx_clk_gate("pcie_ref_125m", "pcie_ref", base + 0xe0, 19);
 
 	clk[enet_ref] = clk_register_divider_table(NULL, "enet_ref", "pll6_enet", 0,
-			base + 0xe0, 0, 2, 0, clk_enet_ref_table,
-			&imx_ccm_lock);
+			base + 0xe0, 0, 2, CLK_DIVIDER_MIN_DIV_DEFAULT, 0,
+			clk_enet_ref_table, &imx_ccm_lock);
 
 	/*                                name              parent_name        reg       idx */
 	clk[pll2_pfd0_352m] = imx_clk_pfd("pll2_pfd0_352m", "pll2_bus",     base + 0x100, 0);
diff --git a/arch/arm/mach-imx/clk.h b/arch/arm/mach-imx/clk.h
index 9d1f3b9..d09e821 100644
--- a/arch/arm/mach-imx/clk.h
+++ b/arch/arm/mach-imx/clk.h
@@ -56,7 +56,9 @@ static inline struct clk *imx_clk_divider(const char *name, const char *parent,
 		void __iomem *reg, u8 shift, u8 width)
 {
 	return clk_register_divider(NULL, name, parent, CLK_SET_RATE_PARENT,
-			reg, shift, width, 0, &imx_ccm_lock);
+				    reg, shift, width,
+				    CLK_DIVIDER_MIN_DIV_DEFAULT, 0,
+				    &imx_ccm_lock);
 }
 
 static inline struct clk *imx_clk_gate(const char *name, const char *parent,
diff --git a/arch/arm/mach-omap2/cclock2420_data.c b/arch/arm/mach-omap2/cclock2420_data.c
index 7e5febe..2a3d030 100644
--- a/arch/arm/mach-omap2/cclock2420_data.c
+++ b/arch/arm/mach-omap2/cclock2420_data.c
@@ -146,12 +146,12 @@ DEFINE_STRUCT_CLK(core_ck, core_ck_parent_names, core_ck_ops);
 DEFINE_CLK_DIVIDER(core_l3_ck, "core_ck", &core_ck, 0x0,
 		   OMAP_CM_REGADDR(CORE_MOD, CM_CLKSEL1),
 		   OMAP24XX_CLKSEL_L3_SHIFT, OMAP24XX_CLKSEL_L3_WIDTH,
-		   CLK_DIVIDER_ONE_BASED, NULL);
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, CLK_DIVIDER_ONE_BASED, NULL);
 
 DEFINE_CLK_DIVIDER(l4_ck, "core_l3_ck", &core_l3_ck, 0x0,
 		   OMAP_CM_REGADDR(CORE_MOD, CM_CLKSEL1),
 		   OMAP24XX_CLKSEL_L4_SHIFT, OMAP24XX_CLKSEL_L4_WIDTH,
-		   CLK_DIVIDER_ONE_BASED, NULL);
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, CLK_DIVIDER_ONE_BASED, NULL);
 
 static struct clk aes_ick;
 
@@ -1226,7 +1226,7 @@ DEFINE_STRUCT_CLK(mmc_ick, aes_ick_parent_names, aes_ick_ops);
 DEFINE_CLK_DIVIDER(mpu_ck, "core_ck", &core_ck, 0x0,
 		   OMAP_CM_REGADDR(MPU_MOD, CM_CLKSEL),
 		   OMAP24XX_CLKSEL_MPU_SHIFT, OMAP24XX_CLKSEL_MPU_WIDTH,
-		   CLK_DIVIDER_ONE_BASED, NULL);
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, CLK_DIVIDER_ONE_BASED, NULL);
 
 static struct clk mpu_wdt_fck;
 
@@ -1470,7 +1470,8 @@ DEFINE_CLK_OMAP_MUX_GATE(sys_clkout_src, "wkup_clkdm", common_clkout_src_clksel,
 
 DEFINE_CLK_DIVIDER(sys_clkout, "sys_clkout_src", &sys_clkout_src, 0x0,
 		   OMAP2420_PRCM_CLKOUT_CTRL, OMAP24XX_CLKOUT_DIV_SHIFT,
-		   OMAP24XX_CLKOUT_DIV_WIDTH, CLK_DIVIDER_POWER_OF_TWO, NULL);
+		   OMAP24XX_CLKOUT_DIV_WIDTH, CLK_DIVIDER_MIN_DIV_DEFAULT,
+		   CLK_DIVIDER_POWER_OF_TWO, NULL);
 
 DEFINE_CLK_OMAP_MUX_GATE(sys_clkout2_src, "wkup_clkdm",
 			 common_clkout_src_clksel, OMAP2420_PRCM_CLKOUT_CTRL,
@@ -1480,7 +1481,8 @@ DEFINE_CLK_OMAP_MUX_GATE(sys_clkout2_src, "wkup_clkdm",
 
 DEFINE_CLK_DIVIDER(sys_clkout2, "sys_clkout2_src", &sys_clkout2_src, 0x0,
 		   OMAP2420_PRCM_CLKOUT_CTRL, OMAP2420_CLKOUT2_DIV_SHIFT,
-		   OMAP2420_CLKOUT2_DIV_WIDTH, CLK_DIVIDER_POWER_OF_TWO, NULL);
+		   OMAP2420_CLKOUT2_DIV_WIDTH, CLK_DIVIDER_MIN_DIV_DEFAULT,
+		   CLK_DIVIDER_POWER_OF_TWO, NULL);
 
 static struct clk uart1_fck;
 
diff --git a/arch/arm/mach-omap2/cclock2430_data.c b/arch/arm/mach-omap2/cclock2430_data.c
index eda079b..4b94eff 100644
--- a/arch/arm/mach-omap2/cclock2430_data.c
+++ b/arch/arm/mach-omap2/cclock2430_data.c
@@ -146,12 +146,12 @@ DEFINE_STRUCT_CLK(core_ck, core_ck_parent_names, core_ck_ops);
 DEFINE_CLK_DIVIDER(core_l3_ck, "core_ck", &core_ck, 0x0,
 		   OMAP_CM_REGADDR(CORE_MOD, CM_CLKSEL1),
 		   OMAP24XX_CLKSEL_L3_SHIFT, OMAP24XX_CLKSEL_L3_WIDTH,
-		   CLK_DIVIDER_ONE_BASED, NULL);
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, CLK_DIVIDER_ONE_BASED, NULL);
 
 DEFINE_CLK_DIVIDER(l4_ck, "core_l3_ck", &core_l3_ck, 0x0,
 		   OMAP_CM_REGADDR(CORE_MOD, CM_CLKSEL1),
 		   OMAP24XX_CLKSEL_L4_SHIFT, OMAP24XX_CLKSEL_L4_WIDTH,
-		   CLK_DIVIDER_ONE_BASED, NULL);
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, CLK_DIVIDER_ONE_BASED, NULL);
 
 static struct clk aes_ick;
 
@@ -1402,7 +1402,7 @@ DEFINE_STRUCT_CLK(mmchsdb2_fck, gpio5_fck_parent_names, aes_ick_ops);
 DEFINE_CLK_DIVIDER(mpu_ck, "core_ck", &core_ck, 0x0,
 		   OMAP_CM_REGADDR(MPU_MOD, CM_CLKSEL),
 		   OMAP24XX_CLKSEL_MPU_SHIFT, OMAP24XX_CLKSEL_MPU_WIDTH,
-		   CLK_DIVIDER_ONE_BASED, NULL);
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, CLK_DIVIDER_ONE_BASED, NULL);
 
 static struct clk mpu_wdt_fck;
 
@@ -1645,7 +1645,8 @@ DEFINE_CLK_OMAP_MUX_GATE(sys_clkout_src, "wkup_clkdm", common_clkout_src_clksel,
 
 DEFINE_CLK_DIVIDER(sys_clkout, "sys_clkout_src", &sys_clkout_src, 0x0,
 		   OMAP2430_PRCM_CLKOUT_CTRL, OMAP24XX_CLKOUT_DIV_SHIFT,
-		   OMAP24XX_CLKOUT_DIV_WIDTH, CLK_DIVIDER_POWER_OF_TWO, NULL);
+		   OMAP24XX_CLKOUT_DIV_WIDTH, CLK_DIVIDER_MIN_DIV_DEFAULT,
+		   CLK_DIVIDER_POWER_OF_TWO, NULL);
 
 static struct clk uart1_fck;
 
diff --git a/arch/arm/mach-omap2/cclock33xx_data.c b/arch/arm/mach-omap2/cclock33xx_data.c
index ea64ad6..8f7c60d 100644
--- a/arch/arm/mach-omap2/cclock33xx_data.c
+++ b/arch/arm/mach-omap2/cclock33xx_data.c
@@ -137,20 +137,21 @@ DEFINE_STRUCT_CLK(dpll_core_x2_ck, dpll_core_x2_ck_parents, dpll_x2_ck_ops);
 DEFINE_CLK_DIVIDER(dpll_core_m4_ck, "dpll_core_x2_ck", &dpll_core_x2_ck,
 		   0x0, AM33XX_CM_DIV_M4_DPLL_CORE,
 		   AM33XX_HSDIVIDER_CLKOUT1_DIV_SHIFT,
-		   AM33XX_HSDIVIDER_CLKOUT1_DIV_WIDTH, CLK_DIVIDER_ONE_BASED,
+		   AM33XX_HSDIVIDER_CLKOUT1_DIV_WIDTH,
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, CLK_DIVIDER_ONE_BASED,
 		   NULL);
 
 DEFINE_CLK_DIVIDER(dpll_core_m5_ck, "dpll_core_x2_ck", &dpll_core_x2_ck,
 		   0x0, AM33XX_CM_DIV_M5_DPLL_CORE,
 		   AM33XX_HSDIVIDER_CLKOUT2_DIV_SHIFT,
 		   AM33XX_HSDIVIDER_CLKOUT2_DIV_WIDTH,
-		   CLK_DIVIDER_ONE_BASED, NULL);
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, CLK_DIVIDER_ONE_BASED, NULL);
 
 DEFINE_CLK_DIVIDER(dpll_core_m6_ck, "dpll_core_x2_ck", &dpll_core_x2_ck,
 		   0x0, AM33XX_CM_DIV_M6_DPLL_CORE,
 		   AM33XX_HSDIVIDER_CLKOUT3_DIV_SHIFT,
 		   AM33XX_HSDIVIDER_CLKOUT3_DIV_WIDTH,
-		   CLK_DIVIDER_ONE_BASED, NULL);
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, CLK_DIVIDER_ONE_BASED, NULL);
 
 
 /* DPLL_MPU */
@@ -198,7 +199,8 @@ DEFINE_STRUCT_CLK(dpll_mpu_ck, dpll_core_ck_parents, dpll_mpu_ck_ops);
  */
 DEFINE_CLK_DIVIDER(dpll_mpu_m2_ck, "dpll_mpu_ck", &dpll_mpu_ck,
 		   0x0, AM33XX_CM_DIV_M2_DPLL_MPU, AM33XX_DPLL_CLKOUT_DIV_SHIFT,
-		   AM33XX_DPLL_CLKOUT_DIV_WIDTH, CLK_DIVIDER_ONE_BASED, NULL);
+		   AM33XX_DPLL_CLKOUT_DIV_WIDTH, CLK_DIVIDER_MIN_DIV_DEFAULT,
+		   CLK_DIVIDER_ONE_BASED, NULL);
 
 /* DPLL_DDR */
 static struct dpll_data dpll_ddr_dd = {
@@ -244,7 +246,7 @@ DEFINE_STRUCT_CLK(dpll_ddr_ck, dpll_core_ck_parents, dpll_ddr_ck_ops);
 DEFINE_CLK_DIVIDER(dpll_ddr_m2_ck, "dpll_ddr_ck", &dpll_ddr_ck,
 		   0x0, AM33XX_CM_DIV_M2_DPLL_DDR,
 		   AM33XX_DPLL_CLKOUT_DIV_SHIFT, AM33XX_DPLL_CLKOUT_DIV_WIDTH,
-		   CLK_DIVIDER_ONE_BASED, NULL);
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, CLK_DIVIDER_ONE_BASED, NULL);
 
 /* emif_fck functional clock */
 DEFINE_CLK_FIXED_FACTOR(dpll_ddr_m2_div2_ck, "dpll_ddr_m2_ck", &dpll_ddr_m2_ck,
@@ -286,7 +288,8 @@ DEFINE_STRUCT_CLK(dpll_disp_ck, dpll_core_ck_parents, dpll_ddr_ck_ops);
  */
 DEFINE_CLK_DIVIDER(dpll_disp_m2_ck, "dpll_disp_ck", &dpll_disp_ck, 0x0,
 		   AM33XX_CM_DIV_M2_DPLL_DISP, AM33XX_DPLL_CLKOUT_DIV_SHIFT,
-		   AM33XX_DPLL_CLKOUT_DIV_WIDTH, CLK_DIVIDER_ONE_BASED, NULL);
+		   AM33XX_DPLL_CLKOUT_DIV_WIDTH, CLK_DIVIDER_MIN_DIV_DEFAULT,
+		   CLK_DIVIDER_ONE_BASED, NULL);
 
 /* DPLL_PER */
 static struct dpll_data dpll_per_dd = {
@@ -322,8 +325,8 @@ DEFINE_STRUCT_CLK(dpll_per_ck, dpll_core_ck_parents, dpll_ddr_ck_ops);
 /* CLKOUT: fdpll/M2 */
 DEFINE_CLK_DIVIDER(dpll_per_m2_ck, "dpll_per_ck", &dpll_per_ck, 0x0,
 		   AM33XX_CM_DIV_M2_DPLL_PER, AM33XX_DPLL_CLKOUT_DIV_SHIFT,
-		   AM33XX_DPLL_CLKOUT_DIV_WIDTH, CLK_DIVIDER_ONE_BASED,
-		   NULL);
+		   AM33XX_DPLL_CLKOUT_DIV_WIDTH, CLK_DIVIDER_MIN_DIV_DEFAULT,
+		   CLK_DIVIDER_ONE_BASED, NULL);
 
 DEFINE_CLK_FIXED_FACTOR(dpll_per_m2_div4_wkupdm_ck, "dpll_per_m2_ck",
 			&dpll_per_m2_ck, 0x0, 1, 4);
@@ -759,7 +762,8 @@ static const struct clk_div_table div_1_0_2_1_rates[] = {
 DEFINE_CLK_DIVIDER_TABLE(gfx_fck_div_ck, "gfx_fclk_clksel_ck",
 			 &gfx_fclk_clksel_ck, 0x0, AM33XX_CLKSEL_GFX_FCLK,
 			 AM33XX_CLKSEL_0_0_SHIFT, AM33XX_CLKSEL_0_0_WIDTH,
-			 0x0, div_1_0_2_1_rates, NULL);
+			 CLK_DIVIDER_MIN_DIV_DEFAULT, 0x0,
+			 div_1_0_2_1_rates, NULL);
 
 static const char *sysclkout_ck_parents[] = {
 	"clk_32768_ck", "l3_gclk", "dpll_ddr_m2_ck", "dpll_per_m2_ck",
@@ -803,7 +807,8 @@ static const struct clk_div_table div8_rates[] = {
 
 DEFINE_CLK_DIVIDER_TABLE(clkout2_div_ck, "sysclkout_pre_ck", &sysclkout_pre_ck,
 			 0x0, AM33XX_CM_CLKOUT_CTRL, AM33XX_CLKOUT2DIV_SHIFT,
-			 AM33XX_CLKOUT2DIV_WIDTH, 0x0, div8_rates, NULL);
+			 AM33XX_CLKOUT2DIV_WIDTH, CLK_DIVIDER_MIN_DIV_DEFAULT,
+			 0x0, div8_rates, NULL);
 
 DEFINE_CLK_GATE(clkout2_ck, "clkout2_div_ck", &clkout2_div_ck, 0x0,
 		AM33XX_CM_CLKOUT_CTRL, AM33XX_CLKOUT2EN_SHIFT, 0x0, NULL);
diff --git a/arch/arm/mach-omap2/cclock3xxx_data.c b/arch/arm/mach-omap2/cclock3xxx_data.c
index 6ef8758..c04ce02 100644
--- a/arch/arm/mach-omap2/cclock3xxx_data.c
+++ b/arch/arm/mach-omap2/cclock3xxx_data.c
@@ -84,7 +84,8 @@ DEFINE_CLK_MUX(osc_sys_ck, osc_sys_ck_parent_names, NULL, 0x0,
 
 DEFINE_CLK_DIVIDER(sys_ck, "osc_sys_ck", &osc_sys_ck, 0x0,
 		   OMAP3430_PRM_CLKSRC_CTRL, OMAP_SYSCLKDIV_SHIFT,
-		   OMAP_SYSCLKDIV_WIDTH, CLK_DIVIDER_ONE_BASED, NULL);
+		   OMAP_SYSCLKDIV_WIDTH, CLK_DIVIDER_MIN_DIV_DEFAULT,
+		   CLK_DIVIDER_ONE_BASED, NULL);
 
 static struct dpll_data dpll3_dd = {
 	.mult_div1_reg	= OMAP_CM_REGADDR(PLL_MOD, CM_CLKSEL1),
@@ -135,7 +136,7 @@ DEFINE_CLK_DIVIDER(dpll3_m2_ck, "dpll3_ck", &dpll3_ck, 0x0,
 		   OMAP_CM_REGADDR(PLL_MOD, CM_CLKSEL1),
 		   OMAP3430_CORE_DPLL_CLKOUT_DIV_SHIFT,
 		   OMAP3430_CORE_DPLL_CLKOUT_DIV_WIDTH,
-		   CLK_DIVIDER_ONE_BASED, NULL);
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, CLK_DIVIDER_ONE_BASED, NULL);
 
 static struct clk core_ck;
 
@@ -151,12 +152,12 @@ DEFINE_STRUCT_CLK(core_ck, core_ck_parent_names, core_ck_ops);
 DEFINE_CLK_DIVIDER(l3_ick, "core_ck", &core_ck, 0x0,
 		   OMAP_CM_REGADDR(CORE_MOD, CM_CLKSEL),
 		   OMAP3430_CLKSEL_L3_SHIFT, OMAP3430_CLKSEL_L3_WIDTH,
-		   CLK_DIVIDER_ONE_BASED, NULL);
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, CLK_DIVIDER_ONE_BASED, NULL);
 
 DEFINE_CLK_DIVIDER(l4_ick, "l3_ick", &l3_ick, 0x0,
 		   OMAP_CM_REGADDR(CORE_MOD, CM_CLKSEL),
 		   OMAP3430_CLKSEL_L4_SHIFT, OMAP3430_CLKSEL_L4_WIDTH,
-		   CLK_DIVIDER_ONE_BASED, NULL);
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, CLK_DIVIDER_ONE_BASED, NULL);
 
 static struct clk security_l4_ick2;
 
@@ -277,7 +278,7 @@ DEFINE_CLK_DIVIDER(dpll1_x2m2_ck, "dpll1_x2_ck", &dpll1_x2_ck, 0x0,
 		   OMAP_CM_REGADDR(MPU_MOD, OMAP3430_CM_CLKSEL2_PLL),
 		   OMAP3430_MPU_DPLL_CLKOUT_DIV_SHIFT,
 		   OMAP3430_MPU_DPLL_CLKOUT_DIV_WIDTH,
-		   CLK_DIVIDER_ONE_BASED, NULL);
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, CLK_DIVIDER_ONE_BASED, NULL);
 
 static struct clk mpu_ck;
 
@@ -291,7 +292,7 @@ DEFINE_STRUCT_CLK(mpu_ck, mpu_ck_parent_names, core_l4_ick_ops);
 DEFINE_CLK_DIVIDER(arm_fck, "mpu_ck", &mpu_ck, 0x0,
 		   OMAP_CM_REGADDR(MPU_MOD, OMAP3430_CM_IDLEST_PLL),
 		   OMAP3430_ST_MPU_CLK_SHIFT, OMAP3430_ST_MPU_CLK_WIDTH,
-		   0x0, NULL);
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, 0x0, NULL);
 
 static struct clk cam_ick;
 
@@ -384,7 +385,7 @@ DEFINE_STRUCT_CLK(dpll4_ck, dpll3_ck_parent_names, dpll4_ck_ops);
 DEFINE_CLK_DIVIDER(dpll4_m5_ck, "dpll4_ck", &dpll4_ck, 0x0,
 		   OMAP_CM_REGADDR(OMAP3430_CAM_MOD, CM_CLKSEL),
 		   OMAP3430_CLKSEL_CAM_SHIFT, OMAP3630_CLKSEL_CAM_WIDTH,
-		   CLK_DIVIDER_ONE_BASED, NULL);
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, CLK_DIVIDER_ONE_BASED, NULL);
 
 static struct clk dpll4_m5x2_ck;
 
@@ -463,7 +464,7 @@ static const struct clksel_rate clkout2_src_96m_rates[] = {
 DEFINE_CLK_DIVIDER(dpll4_m2_ck, "dpll4_ck", &dpll4_ck, 0x0,
 		   OMAP_CM_REGADDR(PLL_MOD, OMAP3430_CM_CLKSEL3),
 		   OMAP3430_DIV_96M_SHIFT, OMAP3630_DIV_96M_WIDTH,
-		   CLK_DIVIDER_ONE_BASED, NULL);
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, CLK_DIVIDER_ONE_BASED, NULL);
 
 static struct clk dpll4_m2x2_ck;
 
@@ -519,7 +520,7 @@ static const struct clksel_rate clkout2_src_54m_rates[] = {
 DEFINE_CLK_DIVIDER(dpll4_m3_ck, "dpll4_ck", &dpll4_ck, 0x0,
 		   OMAP_CM_REGADDR(OMAP3430_DSS_MOD, CM_CLKSEL),
 		   OMAP3430_CLKSEL_TV_SHIFT, OMAP3630_CLKSEL_TV_WIDTH,
-		   CLK_DIVIDER_ONE_BASED, NULL);
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, CLK_DIVIDER_ONE_BASED, NULL);
 
 static struct clk dpll4_m3x2_ck;
 
@@ -754,7 +755,7 @@ DEFINE_STRUCT_CLK(des2_ick, aes2_ick_parent_names, aes2_ick_ops);
 DEFINE_CLK_DIVIDER(dpll1_fck, "core_ck", &core_ck, 0x0,
 		   OMAP_CM_REGADDR(MPU_MOD, OMAP3430_CM_CLKSEL1_PLL),
 		   OMAP3430_MPU_CLK_SRC_SHIFT, OMAP3430_MPU_CLK_SRC_WIDTH,
-		   CLK_DIVIDER_ONE_BASED, NULL);
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, CLK_DIVIDER_ONE_BASED, NULL);
 
 static struct clk dpll2_fck;
 
@@ -797,18 +798,18 @@ DEFINE_STRUCT_CLK(dpll2_ck, dpll3_ck_parent_names, dpll1_ck_ops);
 DEFINE_CLK_DIVIDER(dpll2_fck, "core_ck", &core_ck, 0x0,
 		   OMAP_CM_REGADDR(OMAP3430_IVA2_MOD, OMAP3430_CM_CLKSEL1_PLL),
 		   OMAP3430_IVA2_CLK_SRC_SHIFT, OMAP3430_IVA2_CLK_SRC_WIDTH,
-		   CLK_DIVIDER_ONE_BASED, NULL);
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, CLK_DIVIDER_ONE_BASED, NULL);
 
 DEFINE_CLK_DIVIDER(dpll2_m2_ck, "dpll2_ck", &dpll2_ck, 0x0,
 		   OMAP_CM_REGADDR(OMAP3430_IVA2_MOD, OMAP3430_CM_CLKSEL2_PLL),
 		   OMAP3430_IVA2_DPLL_CLKOUT_DIV_SHIFT,
 		   OMAP3430_IVA2_DPLL_CLKOUT_DIV_WIDTH,
-		   CLK_DIVIDER_ONE_BASED, NULL);
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, CLK_DIVIDER_ONE_BASED, NULL);
 
 DEFINE_CLK_DIVIDER(dpll3_m3_ck, "dpll3_ck", &dpll3_ck, 0x0,
 		   OMAP_CM_REGADDR(OMAP3430_EMU_MOD, CM_CLKSEL1),
 		   OMAP3430_DIV_DPLL3_SHIFT, OMAP3430_DIV_DPLL3_WIDTH,
-		   CLK_DIVIDER_ONE_BASED, NULL);
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, CLK_DIVIDER_ONE_BASED, NULL);
 
 static struct clk dpll3_m3x2_ck;
 
@@ -842,7 +843,7 @@ DEFINE_CLK_FIXED_FACTOR(dpll3_x2_ck, "dpll3_ck", &dpll3_ck, 0x0, 2, 1);
 DEFINE_CLK_DIVIDER(dpll4_m4_ck, "dpll4_ck", &dpll4_ck, 0x0,
 		   OMAP_CM_REGADDR(OMAP3430_DSS_MOD, CM_CLKSEL),
 		   OMAP3430_CLKSEL_DSS1_SHIFT, OMAP3630_CLKSEL_DSS1_WIDTH,
-		   CLK_DIVIDER_ONE_BASED, NULL);
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, CLK_DIVIDER_ONE_BASED, NULL);
 
 static struct clk dpll4_m4x2_ck;
 
@@ -874,7 +875,7 @@ static struct clk dpll4_m4x2_ck_3630 = {
 DEFINE_CLK_DIVIDER(dpll4_m6_ck, "dpll4_ck", &dpll4_ck, 0x0,
 		   OMAP_CM_REGADDR(OMAP3430_EMU_MOD, CM_CLKSEL1),
 		   OMAP3430_DIV_DPLL4_SHIFT, OMAP3630_DIV_DPLL4_WIDTH,
-		   CLK_DIVIDER_ONE_BASED, NULL);
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, CLK_DIVIDER_ONE_BASED, NULL);
 
 static struct clk dpll4_m6x2_ck;
 
@@ -943,7 +944,7 @@ DEFINE_STRUCT_CLK(dpll5_ck, dpll3_ck_parent_names, dpll1_ck_ops);
 DEFINE_CLK_DIVIDER(dpll5_m2_ck, "dpll5_ck", &dpll5_ck, 0x0,
 		   OMAP_CM_REGADDR(PLL_MOD, OMAP3430ES2_CM_CLKSEL5),
 		   OMAP3430ES2_DIV_120M_SHIFT, OMAP3430ES2_DIV_120M_WIDTH,
-		   CLK_DIVIDER_ONE_BASED, NULL);
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, CLK_DIVIDER_ONE_BASED, NULL);
 
 static struct clk dss1_alwon_fck_3430es1;
 
@@ -1188,7 +1189,7 @@ DEFINE_STRUCT_CLK(emu_src_ck, emu_src_ck_parent_names, emu_src_ck_ops);
 DEFINE_CLK_DIVIDER(atclk_fck, "emu_src_ck", &emu_src_ck, 0x0,
 		   OMAP_CM_REGADDR(OMAP3430_EMU_MOD, CM_CLKSEL1),
 		   OMAP3430_CLKSEL_ATCLK_SHIFT, OMAP3430_CLKSEL_ATCLK_WIDTH,
-		   CLK_DIVIDER_ONE_BASED, NULL);
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, CLK_DIVIDER_ONE_BASED, NULL);
 
 static struct clk fac_ick;
 
@@ -1239,7 +1240,7 @@ DEFINE_STRUCT_CLK(gfx_l3_ck, core_l3_ick_parent_names, aes1_ick_ops);
 DEFINE_CLK_DIVIDER(gfx_l3_fck, "l3_ick", &l3_ick, 0x0,
 		   OMAP_CM_REGADDR(GFX_MOD, CM_CLKSEL),
 		   OMAP_CLKSEL_GFX_SHIFT, OMAP_CLKSEL_GFX_WIDTH,
-		   CLK_DIVIDER_ONE_BASED, NULL);
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, CLK_DIVIDER_ONE_BASED, NULL);
 
 static struct clk gfx_cg1_ck;
 
@@ -2462,12 +2463,12 @@ DEFINE_STRUCT_CLK(omapctrl_ick, aes2_ick_parent_names, aes2_ick_ops);
 DEFINE_CLK_DIVIDER(pclk_fck, "emu_src_ck", &emu_src_ck, 0x0,
 		   OMAP_CM_REGADDR(OMAP3430_EMU_MOD, CM_CLKSEL1),
 		   OMAP3430_CLKSEL_PCLK_SHIFT, OMAP3430_CLKSEL_PCLK_WIDTH,
-		   CLK_DIVIDER_ONE_BASED, NULL);
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, CLK_DIVIDER_ONE_BASED, NULL);
 
 DEFINE_CLK_DIVIDER(pclkx2_fck, "emu_src_ck", &emu_src_ck, 0x0,
 		   OMAP_CM_REGADDR(OMAP3430_EMU_MOD, CM_CLKSEL1),
 		   OMAP3430_CLKSEL_PCLKX2_SHIFT, OMAP3430_CLKSEL_PCLKX2_WIDTH,
-		   CLK_DIVIDER_ONE_BASED, NULL);
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, CLK_DIVIDER_ONE_BASED, NULL);
 
 static struct clk per_48m_fck;
 
@@ -2499,7 +2500,7 @@ DEFINE_STRUCT_CLK(pka_ick, pka_ick_parent_names, aes1_ick_ops);
 DEFINE_CLK_DIVIDER(rm_ick, "l4_ick", &l4_ick, 0x0,
 		   OMAP_CM_REGADDR(WKUP_MOD, CM_CLKSEL),
 		   OMAP3430_CLKSEL_RM_SHIFT, OMAP3430_CLKSEL_RM_WIDTH,
-		   CLK_DIVIDER_ONE_BASED, NULL);
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, CLK_DIVIDER_ONE_BASED, NULL);
 
 static struct clk rng_ick;
 
@@ -2780,7 +2781,8 @@ DEFINE_STRUCT_CLK(sys_clkout1, sys_clkout1_parent_names, aes1_ick_ops);
 
 DEFINE_CLK_DIVIDER(sys_clkout2, "clkout2_src_ck", &clkout2_src_ck, 0x0,
 		   OMAP3430_CM_CLKOUT_CTRL, OMAP3430_CLKOUT2_DIV_SHIFT,
-		   OMAP3430_CLKOUT2_DIV_WIDTH, CLK_DIVIDER_POWER_OF_TWO, NULL);
+		   OMAP3430_CLKOUT2_DIV_WIDTH, CLK_DIVIDER_MIN_DIV_DEFAULT,
+		   CLK_DIVIDER_POWER_OF_TWO, NULL);
 
 DEFINE_CLK_MUX(traceclk_src_fck, emu_src_ck_parent_names, NULL, 0x0,
 	       OMAP_CM_REGADDR(OMAP3430_EMU_MOD, CM_CLKSEL1),
@@ -2790,7 +2792,8 @@ DEFINE_CLK_MUX(traceclk_src_fck, emu_src_ck_parent_names, NULL, 0x0,
 DEFINE_CLK_DIVIDER(traceclk_fck, "traceclk_src_fck", &traceclk_src_fck, 0x0,
 		   OMAP_CM_REGADDR(OMAP3430_EMU_MOD, CM_CLKSEL1),
 		   OMAP3430_CLKSEL_TRACECLK_SHIFT,
-		   OMAP3430_CLKSEL_TRACECLK_WIDTH, CLK_DIVIDER_ONE_BASED, NULL);
+		   OMAP3430_CLKSEL_TRACECLK_WIDTH, CLK_DIVIDER_MIN_DIV_DEFAULT,
+		   CLK_DIVIDER_ONE_BASED, NULL);
 
 static struct clk ts_fck;
 
diff --git a/arch/arm/mach-omap2/cclock44xx_data.c b/arch/arm/mach-omap2/cclock44xx_data.c
index 5789a5e..69dd52e 100644
--- a/arch/arm/mach-omap2/cclock44xx_data.c
+++ b/arch/arm/mach-omap2/cclock44xx_data.c
@@ -201,13 +201,14 @@ DEFINE_CLK_FIXED_FACTOR(abe_24m_fclk, "dpll_abe_m2x2_ck", &dpll_abe_m2x2_ck,
 
 DEFINE_CLK_DIVIDER(abe_clk, "dpll_abe_m2x2_ck", &dpll_abe_m2x2_ck, 0x0,
 		   OMAP4430_CM_CLKSEL_ABE, OMAP4430_CLKSEL_OPP_SHIFT,
-		   OMAP4430_CLKSEL_OPP_WIDTH, CLK_DIVIDER_POWER_OF_TWO, NULL);
+		   OMAP4430_CLKSEL_OPP_WIDTH, CLK_DIVIDER_MIN_DIV_DEFAULT,
+		   CLK_DIVIDER_POWER_OF_TWO, NULL);
 
 DEFINE_CLK_DIVIDER(aess_fclk, "abe_clk", &abe_clk, 0x0,
 		   OMAP4430_CM1_ABE_AESS_CLKCTRL,
 		   OMAP4430_CLKSEL_AESS_FCLK_SHIFT,
 		   OMAP4430_CLKSEL_AESS_FCLK_WIDTH,
-		   0x0, NULL);
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, 0x0, NULL);
 
 DEFINE_CLK_OMAP_HSDIVIDER(dpll_abe_m3x2_ck, "dpll_abe_x2_ck", &dpll_abe_x2_ck,
 			  0x0, OMAP4430_CM_DIV_M3_DPLL_ABE,
@@ -294,15 +295,18 @@ DEFINE_CLK_OMAP_HSDIVIDER(dpll_core_m5x2_ck, "dpll_core_x2_ck",
 
 DEFINE_CLK_DIVIDER(div_core_ck, "dpll_core_m5x2_ck", &dpll_core_m5x2_ck, 0x0,
 		   OMAP4430_CM_CLKSEL_CORE, OMAP4430_CLKSEL_CORE_SHIFT,
-		   OMAP4430_CLKSEL_CORE_WIDTH, 0x0, NULL);
+		   OMAP4430_CLKSEL_CORE_WIDTH, CLK_DIVIDER_MIN_DIV_DEFAULT,
+		   0x0, NULL);
 
 DEFINE_CLK_DIVIDER(div_iva_hs_clk, "dpll_core_m5x2_ck", &dpll_core_m5x2_ck,
 		   0x0, OMAP4430_CM_BYPCLK_DPLL_IVA, OMAP4430_CLKSEL_0_1_SHIFT,
-		   OMAP4430_CLKSEL_0_1_WIDTH, CLK_DIVIDER_POWER_OF_TWO, NULL);
+		   OMAP4430_CLKSEL_0_1_WIDTH, CLK_DIVIDER_MIN_DIV_DEFAULT,
+		   CLK_DIVIDER_POWER_OF_TWO, NULL);
 
 DEFINE_CLK_DIVIDER(div_mpu_hs_clk, "dpll_core_m5x2_ck", &dpll_core_m5x2_ck,
 		   0x0, OMAP4430_CM_BYPCLK_DPLL_MPU, OMAP4430_CLKSEL_0_1_SHIFT,
-		   OMAP4430_CLKSEL_0_1_WIDTH, CLK_DIVIDER_POWER_OF_TWO, NULL);
+		   OMAP4430_CLKSEL_0_1_WIDTH, CLK_DIVIDER_MIN_DIV_DEFAULT,
+		   CLK_DIVIDER_POWER_OF_TWO, NULL);
 
 DEFINE_CLK_OMAP_HSDIVIDER(dpll_core_m4x2_ck, "dpll_core_x2_ck",
 			  &dpll_core_x2_ck, 0x0, OMAP4430_CM_DIV_M4_DPLL_CORE,
@@ -313,7 +317,8 @@ DEFINE_CLK_FIXED_FACTOR(dll_clk_div_ck, "dpll_core_m4x2_ck", &dpll_core_m4x2_ck,
 
 DEFINE_CLK_DIVIDER(dpll_abe_m2_ck, "dpll_abe_ck", &dpll_abe_ck, 0x0,
 		   OMAP4430_CM_DIV_M2_DPLL_ABE, OMAP4430_DPLL_CLKOUT_DIV_SHIFT,
-		   OMAP4430_DPLL_CLKOUT_DIV_WIDTH, CLK_DIVIDER_ONE_BASED, NULL);
+		   OMAP4430_DPLL_CLKOUT_DIV_WIDTH, CLK_DIVIDER_MIN_DIV_DEFAULT,
+		   CLK_DIVIDER_ONE_BASED, NULL);
 
 static const struct clk_ops dmic_fck_ops = {
 	.enable		= &omap2_dflt_clk_enable,
@@ -509,7 +514,8 @@ DEFINE_STRUCT_CLK(dpll_per_ck, dpll_per_ck_parents, dpll_ck_ops);
 
 DEFINE_CLK_DIVIDER(dpll_per_m2_ck, "dpll_per_ck", &dpll_per_ck, 0x0,
 		   OMAP4430_CM_DIV_M2_DPLL_PER, OMAP4430_DPLL_CLKOUT_DIV_SHIFT,
-		   OMAP4430_DPLL_CLKOUT_DIV_WIDTH, CLK_DIVIDER_ONE_BASED, NULL);
+		   OMAP4430_DPLL_CLKOUT_DIV_WIDTH, CLK_DIVIDER_MIN_DIV_DEFAULT,
+		   CLK_DIVIDER_ONE_BASED, NULL);
 
 static const char *dpll_per_x2_ck_parents[] = {
 	"dpll_per_ck",
@@ -653,8 +659,8 @@ static const struct clk_div_table func_48m_fclk_rates[] = {
 };
 DEFINE_CLK_DIVIDER_TABLE(func_48m_fclk, "dpll_per_m2x2_ck", &dpll_per_m2x2_ck,
 			 0x0, OMAP4430_CM_SCALE_FCLK, OMAP4430_SCALE_FCLK_SHIFT,
-			 OMAP4430_SCALE_FCLK_WIDTH, 0x0, func_48m_fclk_rates,
-			 NULL);
+			 OMAP4430_SCALE_FCLK_WIDTH, CLK_DIVIDER_MIN_DIV_DEFAULT,
+			 0x0, func_48m_fclk_rates, NULL);
 
 DEFINE_CLK_FIXED_FACTOR(func_48mc_fclk,	"dpll_per_m2x2_ck", &dpll_per_m2x2_ck,
 			0x0, 1, 4);
@@ -666,8 +672,8 @@ static const struct clk_div_table func_64m_fclk_rates[] = {
 };
 DEFINE_CLK_DIVIDER_TABLE(func_64m_fclk, "dpll_per_m4x2_ck", &dpll_per_m4x2_ck,
 			 0x0, OMAP4430_CM_SCALE_FCLK, OMAP4430_SCALE_FCLK_SHIFT,
-			 OMAP4430_SCALE_FCLK_WIDTH, 0x0, func_64m_fclk_rates,
-			 NULL);
+			 OMAP4430_SCALE_FCLK_WIDTH, CLK_DIVIDER_MIN_DIV_DEFAULT,
+			 0x0, func_64m_fclk_rates, NULL);
 
 static const struct clk_div_table func_96m_fclk_rates[] = {
 	{ .div = 2, .val = 0 },
@@ -676,8 +682,8 @@ static const struct clk_div_table func_96m_fclk_rates[] = {
 };
 DEFINE_CLK_DIVIDER_TABLE(func_96m_fclk, "dpll_per_m2x2_ck", &dpll_per_m2x2_ck,
 			 0x0, OMAP4430_CM_SCALE_FCLK, OMAP4430_SCALE_FCLK_SHIFT,
-			 OMAP4430_SCALE_FCLK_WIDTH, 0x0, func_96m_fclk_rates,
-			 NULL);
+			 OMAP4430_SCALE_FCLK_WIDTH, CLK_DIVIDER_MIN_DIV_DEFAULT,
+			 0x0, func_96m_fclk_rates, NULL);
 
 static const struct clk_div_table init_60m_fclk_rates[] = {
 	{ .div = 1, .val = 0 },
@@ -687,15 +693,18 @@ static const struct clk_div_table init_60m_fclk_rates[] = {
 DEFINE_CLK_DIVIDER_TABLE(init_60m_fclk, "dpll_usb_m2_ck", &dpll_usb_m2_ck,
 			 0x0, OMAP4430_CM_CLKSEL_USB_60MHZ,
 			 OMAP4430_CLKSEL_0_0_SHIFT, OMAP4430_CLKSEL_0_0_WIDTH,
-			 0x0, init_60m_fclk_rates, NULL);
+			 CLK_DIVIDER_MIN_DIV_DEFAULT, 0x0,
+			 init_60m_fclk_rates, NULL);
 
 DEFINE_CLK_DIVIDER(l3_div_ck, "div_core_ck", &div_core_ck, 0x0,
 		   OMAP4430_CM_CLKSEL_CORE, OMAP4430_CLKSEL_L3_SHIFT,
-		   OMAP4430_CLKSEL_L3_WIDTH, 0x0, NULL);
+		   OMAP4430_CLKSEL_L3_WIDTH, CLK_DIVIDER_MIN_DIV_DEFAULT,
+		   0x0, NULL);
 
 DEFINE_CLK_DIVIDER(l4_div_ck, "l3_div_ck", &l3_div_ck, 0x0,
 		   OMAP4430_CM_CLKSEL_CORE, OMAP4430_CLKSEL_L4_SHIFT,
-		   OMAP4430_CLKSEL_L4_WIDTH, 0x0, NULL);
+		   OMAP4430_CLKSEL_L4_WIDTH, CLK_DIVIDER_MIN_DIV_DEFAULT,
+		   0x0, NULL);
 
 DEFINE_CLK_FIXED_FACTOR(lp_clk_div_ck, "dpll_abe_m2x2_ck", &dpll_abe_m2x2_ck,
 			0x0, 1, 16);
@@ -717,18 +726,21 @@ DEFINE_CLK_DIVIDER_TABLE(ocp_abe_iclk, "aess_fclk", &aess_fclk, 0x0,
 			 OMAP4430_CM1_ABE_AESS_CLKCTRL,
 			 OMAP4430_CLKSEL_AESS_FCLK_SHIFT,
 			 OMAP4430_CLKSEL_AESS_FCLK_WIDTH,
-			 0x0, ocp_abe_iclk_rates, NULL);
+			 CLK_DIVIDER_MIN_DIV_DEFAULT, 0x0,
+			 ocp_abe_iclk_rates, NULL);
 
 DEFINE_CLK_FIXED_FACTOR(per_abe_24m_fclk, "dpll_abe_m2_ck", &dpll_abe_m2_ck,
 			0x0, 1, 4);
 
 DEFINE_CLK_DIVIDER(per_abe_nc_fclk, "dpll_abe_m2_ck", &dpll_abe_m2_ck, 0x0,
 		   OMAP4430_CM_SCALE_FCLK, OMAP4430_SCALE_FCLK_SHIFT,
-		   OMAP4430_SCALE_FCLK_WIDTH, 0x0, NULL);
+		   OMAP4430_SCALE_FCLK_WIDTH, CLK_DIVIDER_MIN_DIV_DEFAULT,
+		   0x0, NULL);
 
 DEFINE_CLK_DIVIDER(syc_clk_div_ck, "sys_clkin_ck", &sys_clkin_ck, 0x0,
 		   OMAP4430_CM_ABE_DSS_SYS_CLKSEL, OMAP4430_CLKSEL_0_0_SHIFT,
-		   OMAP4430_CLKSEL_0_0_WIDTH, 0x0, NULL);
+		   OMAP4430_CLKSEL_0_0_WIDTH, CLK_DIVIDER_MIN_DIV_DEFAULT,
+		   0x0, NULL);
 
 static const char *dbgclk_mux_ck_parents[] = {
 	"sys_clkin_ck"
@@ -766,8 +778,9 @@ static const struct clk_div_table div_ts_ck_rates[] = {
 DEFINE_CLK_DIVIDER_TABLE(div_ts_ck, "l4_wkup_clk_mux_ck", &l4_wkup_clk_mux_ck,
 			 0x0, OMAP4430_CM_WKUP_BANDGAP_CLKCTRL,
 			 OMAP4430_CLKSEL_24_25_SHIFT,
-			 OMAP4430_CLKSEL_24_25_WIDTH, 0x0, div_ts_ck_rates,
-			 NULL);
+			 OMAP4430_CLKSEL_24_25_WIDTH,
+			 CLK_DIVIDER_MIN_DIV_DEFAULT,
+			 0x0, div_ts_ck_rates, NULL);
 
 DEFINE_CLK_GATE(bandgap_ts_fclk, "div_ts_ck", &div_ts_ck, 0x0,
 		OMAP4430_CM_WKUP_BANDGAP_CLKCTRL,
@@ -847,7 +860,8 @@ DEFINE_CLK_GATE(emif2_fck, "ddrphy_ck", &ddrphy_ck, 0x0,
 
 DEFINE_CLK_DIVIDER(fdif_fck, "dpll_per_m4x2_ck", &dpll_per_m4x2_ck, 0x0,
 		   OMAP4430_CM_CAM_FDIF_CLKCTRL, OMAP4430_CLKSEL_FCLK_SHIFT,
-		   OMAP4430_CLKSEL_FCLK_WIDTH, CLK_DIVIDER_POWER_OF_TWO, NULL);
+		   OMAP4430_CLKSEL_FCLK_WIDTH, CLK_DIVIDER_MIN_DIV_DEFAULT,
+		   CLK_DIVIDER_POWER_OF_TWO, NULL);
 
 DEFINE_CLK_GATE(fpka_fck, "l4_div_ck", &l4_div_ck, 0x0,
 		OMAP4430_CM_L4SEC_PKAEIP29_CLKCTRL,
@@ -929,8 +943,8 @@ DEFINE_CLK_GATE(hdq1w_fck, "func_12m_fclk", &func_12m_fclk, 0x0,
 
 DEFINE_CLK_DIVIDER(hsi_fck, "dpll_per_m2x2_ck", &dpll_per_m2x2_ck, 0x0,
 		   OMAP4430_CM_L3INIT_HSI_CLKCTRL, OMAP4430_CLKSEL_24_25_SHIFT,
-		   OMAP4430_CLKSEL_24_25_WIDTH, CLK_DIVIDER_POWER_OF_TWO,
-		   NULL);
+		   OMAP4430_CLKSEL_24_25_WIDTH, CLK_DIVIDER_MIN_DIV_DEFAULT,
+		   CLK_DIVIDER_POWER_OF_TWO, NULL);
 
 DEFINE_CLK_GATE(i2c1_fck, "func_96m_fclk", &func_96m_fclk, 0x0,
 		OMAP4430_CM_L4PER_I2C1_CLKCTRL,
@@ -1506,7 +1520,7 @@ static const struct clk_div_table usim_ck_rates[] = {
 DEFINE_CLK_DIVIDER_TABLE(usim_ck, "dpll_per_m4x2_ck", &dpll_per_m4x2_ck, 0x0,
 			 OMAP4430_CM_WKUP_USIM_CLKCTRL,
 			 OMAP4430_CLKSEL_DIV_SHIFT, OMAP4430_CLKSEL_DIV_WIDTH,
-			 0x0, usim_ck_rates, NULL);
+			 CLK_DIVIDER_MIN_DIV_DEFAULT, 0x0, usim_ck_rates, NULL);
 
 DEFINE_CLK_GATE(usim_fclk, "usim_ck", &usim_ck, 0x0,
 		OMAP4430_CM_WKUP_USIM_CLKCTRL, OMAP4430_OPTFCLKEN_FCLK_SHIFT,
@@ -1541,8 +1555,9 @@ DEFINE_CLK_MUX(pmd_trace_clk_mux_ck, pmd_stm_clock_mux_ck_parents, NULL, 0x0,
 DEFINE_CLK_DIVIDER(stm_clk_div_ck, "pmd_stm_clock_mux_ck",
 		   &pmd_stm_clock_mux_ck, 0x0, OMAP4430_CM_EMU_DEBUGSS_CLKCTRL,
 		   OMAP4430_CLKSEL_PMD_STM_CLK_SHIFT,
-		   OMAP4430_CLKSEL_PMD_STM_CLK_WIDTH, CLK_DIVIDER_POWER_OF_TWO,
-		   NULL);
+		   OMAP4430_CLKSEL_PMD_STM_CLK_WIDTH,
+		   CLK_DIVIDER_MIN_DIV_DEFAULT,
+		   CLK_DIVIDER_POWER_OF_TWO, NULL);
 
 static const char *trace_clk_div_ck_parents[] = {
 	"pmd_trace_clk_mux_ck",
@@ -1605,7 +1620,7 @@ DEFINE_CLK_OMAP_MUX_GATE(auxclk0_src_ck, NULL, auxclk_src_sel,
 
 DEFINE_CLK_DIVIDER(auxclk0_ck, "auxclk0_src_ck", &auxclk0_src_ck, 0x0,
 		   OMAP4_SCRM_AUXCLK0, OMAP4_CLKDIV_SHIFT, OMAP4_CLKDIV_WIDTH,
-		   0x0, NULL);
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, 0x0, NULL);
 
 DEFINE_CLK_OMAP_MUX_GATE(auxclk1_src_ck, NULL, auxclk_src_sel,
 			 OMAP4_SCRM_AUXCLK1, OMAP4_SRCSELECT_MASK,
@@ -1614,7 +1629,7 @@ DEFINE_CLK_OMAP_MUX_GATE(auxclk1_src_ck, NULL, auxclk_src_sel,
 
 DEFINE_CLK_DIVIDER(auxclk1_ck, "auxclk1_src_ck", &auxclk1_src_ck, 0x0,
 		   OMAP4_SCRM_AUXCLK1, OMAP4_CLKDIV_SHIFT, OMAP4_CLKDIV_WIDTH,
-		   0x0, NULL);
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, 0x0, NULL);
 
 DEFINE_CLK_OMAP_MUX_GATE(auxclk2_src_ck, NULL, auxclk_src_sel,
 			 OMAP4_SCRM_AUXCLK2, OMAP4_SRCSELECT_MASK,
@@ -1623,7 +1638,7 @@ DEFINE_CLK_OMAP_MUX_GATE(auxclk2_src_ck, NULL, auxclk_src_sel,
 
 DEFINE_CLK_DIVIDER(auxclk2_ck, "auxclk2_src_ck", &auxclk2_src_ck, 0x0,
 		   OMAP4_SCRM_AUXCLK2, OMAP4_CLKDIV_SHIFT, OMAP4_CLKDIV_WIDTH,
-		   0x0, NULL);
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, 0x0, NULL);
 
 DEFINE_CLK_OMAP_MUX_GATE(auxclk3_src_ck, NULL, auxclk_src_sel,
 			 OMAP4_SCRM_AUXCLK3, OMAP4_SRCSELECT_MASK,
@@ -1632,7 +1647,7 @@ DEFINE_CLK_OMAP_MUX_GATE(auxclk3_src_ck, NULL, auxclk_src_sel,
 
 DEFINE_CLK_DIVIDER(auxclk3_ck, "auxclk3_src_ck", &auxclk3_src_ck, 0x0,
 		   OMAP4_SCRM_AUXCLK3, OMAP4_CLKDIV_SHIFT, OMAP4_CLKDIV_WIDTH,
-		   0x0, NULL);
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, 0x0, NULL);
 
 DEFINE_CLK_OMAP_MUX_GATE(auxclk4_src_ck, NULL, auxclk_src_sel,
 			 OMAP4_SCRM_AUXCLK4, OMAP4_SRCSELECT_MASK,
@@ -1641,7 +1656,7 @@ DEFINE_CLK_OMAP_MUX_GATE(auxclk4_src_ck, NULL, auxclk_src_sel,
 
 DEFINE_CLK_DIVIDER(auxclk4_ck, "auxclk4_src_ck", &auxclk4_src_ck, 0x0,
 		   OMAP4_SCRM_AUXCLK4, OMAP4_CLKDIV_SHIFT, OMAP4_CLKDIV_WIDTH,
-		   0x0, NULL);
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, 0x0, NULL);
 
 DEFINE_CLK_OMAP_MUX_GATE(auxclk5_src_ck, NULL, auxclk_src_sel,
 			 OMAP4_SCRM_AUXCLK5, OMAP4_SRCSELECT_MASK,
@@ -1650,7 +1665,7 @@ DEFINE_CLK_OMAP_MUX_GATE(auxclk5_src_ck, NULL, auxclk_src_sel,
 
 DEFINE_CLK_DIVIDER(auxclk5_ck, "auxclk5_src_ck", &auxclk5_src_ck, 0x0,
 		   OMAP4_SCRM_AUXCLK5, OMAP4_CLKDIV_SHIFT, OMAP4_CLKDIV_WIDTH,
-		   0x0, NULL);
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, 0x0, NULL);
 
 static const char *auxclkreq_ck_parents[] = {
 	"auxclk0_ck", "auxclk1_ck", "auxclk2_ck", "auxclk3_ck", "auxclk4_ck",
diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
index a9204c6..0b34992 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -236,7 +236,7 @@ EXPORT_SYMBOL_GPL(clk_divider_ops);
 
 static struct clk *_register_divider(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
-		void __iomem *reg, u8 shift, u8 width,
+		void __iomem *reg, u8 shift, u8 width, u8 min_div,
 		u8 clk_divider_flags, const struct clk_div_table *table,
 		spinlock_t *lock)
 {
@@ -261,6 +261,7 @@ static struct clk *_register_divider(struct device *dev, const char *name,
 	div->reg = reg;
 	div->shift = shift;
 	div->width = width;
+	div->min_div = min_div;
 	div->flags = clk_divider_flags;
 	div->lock = lock;
 	div->hw.init = &init;
@@ -284,16 +285,17 @@ static struct clk *_register_divider(struct device *dev, const char *name,
  * @reg: register address to adjust divider
  * @shift: number of bits to shift the bitfield
  * @width: width of the bitfield
+ * @min_div: minimum allowable divider value
  * @clk_divider_flags: divider-specific flags for this clock
  * @lock: shared register lock for this clock
  */
 struct clk *clk_register_divider(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
-		void __iomem *reg, u8 shift, u8 width,
+		void __iomem *reg, u8 shift, u8 width, u8 min_div,
 		u8 clk_divider_flags, spinlock_t *lock)
 {
 	return _register_divider(dev, name, parent_name, flags, reg, shift,
-			width, clk_divider_flags, NULL, lock);
+			width, min_div, clk_divider_flags, NULL, lock);
 }
 
 /**
@@ -306,16 +308,17 @@ struct clk *clk_register_divider(struct device *dev, const char *name,
  * @reg: register address to adjust divider
  * @shift: number of bits to shift the bitfield
  * @width: width of the bitfield
+ * @min_div: minimum allowable divider value
  * @clk_divider_flags: divider-specific flags for this clock
  * @table: array of divider/value pairs ending with a div set to 0
  * @lock: shared register lock for this clock
  */
 struct clk *clk_register_divider_table(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
-		void __iomem *reg, u8 shift, u8 width,
+		void __iomem *reg, u8 shift, u8 width, u8 min_div,
 		u8 clk_divider_flags, const struct clk_div_table *table,
 		spinlock_t *lock)
 {
 	return _register_divider(dev, name, parent_name, flags, reg, shift,
-			width, clk_divider_flags, table, lock);
+			width, min_div, clk_divider_flags, table, lock);
 }
diff --git a/drivers/clk/clk-ls1x.c b/drivers/clk/clk-ls1x.c
index f20b750..ee844aa 100644
--- a/drivers/clk/clk-ls1x.c
+++ b/drivers/clk/clk-ls1x.c
@@ -87,19 +87,22 @@ void __init ls1x_clk_init(void)
 
 	clk = clk_register_divider(NULL, "cpu_clk", "pll_clk",
 			CLK_SET_RATE_PARENT, LS1X_CLK_PLL_DIV, DIV_CPU_SHIFT,
-			DIV_CPU_WIDTH, CLK_DIVIDER_ONE_BASED, &_lock);
+			DIV_CPU_WIDTH, CLK_DIVIDER_MIN_DIV_DEFAULT,
+			CLK_DIVIDER_ONE_BASED, &_lock);
 	clk_prepare_enable(clk);
 	clk_register_clkdev(clk, "cpu", NULL);
 
 	clk = clk_register_divider(NULL, "dc_clk", "pll_clk",
 			CLK_SET_RATE_PARENT, LS1X_CLK_PLL_DIV, DIV_DC_SHIFT,
-			DIV_DC_WIDTH, CLK_DIVIDER_ONE_BASED, &_lock);
+			DIV_DC_WIDTH, CLK_DIVIDER_MIN_DIV_DEFAULT,
+			CLK_DIVIDER_ONE_BASED, &_lock);
 	clk_prepare_enable(clk);
 	clk_register_clkdev(clk, "dc", NULL);
 
 	clk = clk_register_divider(NULL, "ahb_clk", "pll_clk",
 			CLK_SET_RATE_PARENT, LS1X_CLK_PLL_DIV, DIV_DDR_SHIFT,
-			DIV_DDR_WIDTH, CLK_DIVIDER_ONE_BASED, &_lock);
+			DIV_DDR_WIDTH, CLK_DIVIDER_MIN_DIV_DEFAULT,
+			CLK_DIVIDER_ONE_BASED, &_lock);
 	clk_prepare_enable(clk);
 	clk_register_clkdev(clk, "ahb", NULL);
 	clk_register_clkdev(clk, "stmmaceth", NULL);
diff --git a/drivers/clk/mmp/clk-mmp2.c b/drivers/clk/mmp/clk-mmp2.c
index ade4358..4f34ca6 100644
--- a/drivers/clk/mmp/clk-mmp2.c
+++ b/drivers/clk/mmp/clk-mmp2.c
@@ -330,7 +330,8 @@ void __init mmp2_clk_init(void)
 
 	clk = clk_register_divider(NULL, "sdh_div", "sdh_mux",
 				CLK_SET_RATE_PARENT, apmu_base + APMU_SDH0,
-				10, 4, CLK_DIVIDER_ONE_BASED, &clk_lock);
+				10, 4, CLK_DIVIDER_MIN_DIV_DEFAULT,
+				CLK_DIVIDER_ONE_BASED, &clk_lock);
 	clk_register_clkdev(clk, "sdh_div", NULL);
 
 	clk = mmp_clk_register_apmu("sdh0", "sdh_div", apmu_base + APMU_SDH0,
@@ -360,7 +361,8 @@ void __init mmp2_clk_init(void)
 
 	clk = clk_register_divider(NULL, "disp0_div", "disp0_mux",
 				CLK_SET_RATE_PARENT, apmu_base + APMU_DISP0,
-				8, 4, CLK_DIVIDER_ONE_BASED, &clk_lock);
+				8, 4, CLK_DIVIDER_MIN_DIV_DEFAULT,
+				CLK_DIVIDER_ONE_BASED, &clk_lock);
 	clk_register_clkdev(clk, "disp_div.0", NULL);
 
 	clk = mmp_clk_register_apmu("disp0", "disp0_div",
@@ -368,7 +370,8 @@ void __init mmp2_clk_init(void)
 	clk_register_clkdev(clk, NULL, "mmp-disp.0");
 
 	clk = clk_register_divider(NULL, "disp0_sphy_div", "disp0_mux", 0,
-				apmu_base + APMU_DISP0, 15, 5, 0, &clk_lock);
+				apmu_base + APMU_DISP0, 15, 5,
+				CLK_DIVIDER_MIN_DIV_DEFAULT, 0, &clk_lock);
 	clk_register_clkdev(clk, "disp_sphy_div.0", NULL);
 
 	clk = mmp_clk_register_apmu("disp0_sphy", "disp0_sphy_div",
@@ -382,7 +385,8 @@ void __init mmp2_clk_init(void)
 
 	clk = clk_register_divider(NULL, "disp1_div", "disp1_mux",
 				CLK_SET_RATE_PARENT, apmu_base + APMU_DISP1,
-				8, 4, CLK_DIVIDER_ONE_BASED, &clk_lock);
+				8, 4, CLK_DIVIDER_MIN_DIV_DEFAULT,
+				CLK_DIVIDER_ONE_BASED, &clk_lock);
 	clk_register_clkdev(clk, "disp_div.1", NULL);
 
 	clk = mmp_clk_register_apmu("disp1", "disp1_div",
@@ -400,7 +404,8 @@ void __init mmp2_clk_init(void)
 
 	clk = clk_register_divider(NULL, "ccic0_div", "ccic0_mux",
 				CLK_SET_RATE_PARENT, apmu_base + APMU_CCIC0,
-				17, 4, CLK_DIVIDER_ONE_BASED, &clk_lock);
+				17, 4, CLK_DIVIDER_MIN_DIV_DEFAULT,
+				CLK_DIVIDER_ONE_BASED, &clk_lock);
 	clk_register_clkdev(clk, "ccic_div.0", NULL);
 
 	clk = mmp_clk_register_apmu("ccic0", "ccic0_div",
@@ -413,7 +418,8 @@ void __init mmp2_clk_init(void)
 
 	clk = clk_register_divider(NULL, "ccic0_sphy_div", "ccic0_div",
 				CLK_SET_RATE_PARENT, apmu_base + APMU_CCIC0,
-				10, 5, 0, &clk_lock);
+				10, 5, CLK_DIVIDER_MIN_DIV_DEFAULT,
+				0, &clk_lock);
 	clk_register_clkdev(clk, "sphyclk_div", "mmp-ccic.0");
 
 	clk = mmp_clk_register_apmu("ccic0_sphy", "ccic0_sphy_div",
@@ -427,7 +433,8 @@ void __init mmp2_clk_init(void)
 
 	clk = clk_register_divider(NULL, "ccic1_div", "ccic1_mux",
 				CLK_SET_RATE_PARENT, apmu_base + APMU_CCIC1,
-				16, 4, CLK_DIVIDER_ONE_BASED, &clk_lock);
+				16, 4, CLK_DIVIDER_MIN_DIV_DEFAULT,
+				CLK_DIVIDER_ONE_BASED, &clk_lock);
 	clk_register_clkdev(clk, "ccic_div.1", NULL);
 
 	clk = mmp_clk_register_apmu("ccic1", "ccic1_div",
@@ -440,7 +447,8 @@ void __init mmp2_clk_init(void)
 
 	clk = clk_register_divider(NULL, "ccic1_sphy_div", "ccic1_div",
 				CLK_SET_RATE_PARENT, apmu_base + APMU_CCIC1,
-				10, 5, 0, &clk_lock);
+				10, 5, CLK_DIVIDER_MIN_DIV_DEFAULT,
+				0, &clk_lock);
 	clk_register_clkdev(clk, "sphyclk_div", "mmp-ccic.1");
 
 	clk = mmp_clk_register_apmu("ccic1_sphy", "ccic1_sphy_div",
diff --git a/drivers/clk/mmp/clk-pxa168.c b/drivers/clk/mmp/clk-pxa168.c
index e8d036c..95ea167 100644
--- a/drivers/clk/mmp/clk-pxa168.c
+++ b/drivers/clk/mmp/clk-pxa168.c
@@ -337,7 +337,8 @@ void __init pxa168_clk_init(void)
 
 	clk = clk_register_divider(NULL, "ccic0_sphy_div", "ccic0_mux",
 				CLK_SET_RATE_PARENT, apmu_base + APMU_CCIC0,
-				10, 5, 0, &clk_lock);
+				10, 5, CLK_DIVIDER_MIN_DIV_DEFAULT,
+				0, &clk_lock);
 	clk_register_clkdev(clk, "sphyclk_div", NULL);
 
 	clk = mmp_clk_register_apmu("ccic0_sphy", "ccic0_sphy_div",
diff --git a/drivers/clk/mmp/clk-pxa910.c b/drivers/clk/mmp/clk-pxa910.c
index 7048c31..367cc1a 100644
--- a/drivers/clk/mmp/clk-pxa910.c
+++ b/drivers/clk/mmp/clk-pxa910.c
@@ -311,7 +311,8 @@ void __init pxa910_clk_init(void)
 
 	clk = clk_register_divider(NULL, "ccic0_sphy_div", "ccic0_mux",
 				CLK_SET_RATE_PARENT, apmu_base + APMU_CCIC0,
-				10, 5, 0, &clk_lock);
+				10, 5, CLK_DIVIDER_MIN_DIV_DEFAULT,
+				0, &clk_lock);
 	clk_register_clkdev(clk, "sphyclk_div", NULL);
 
 	clk = mmp_clk_register_apmu("ccic0_sphy", "ccic0_sphy_div",
diff --git a/drivers/clk/spear/spear3xx_clock.c b/drivers/clk/spear/spear3xx_clock.c
index 33d3ac5..bee26ce 100644
--- a/drivers/clk/spear/spear3xx_clock.c
+++ b/drivers/clk/spear/spear3xx_clock.c
@@ -407,7 +407,8 @@ void __init spear3xx_clk_init(void)
 
 	clk = clk_register_divider(NULL, "ahb_clk", "pll1_clk",
 			CLK_SET_RATE_PARENT, CORE_CLK_CFG, HCLK_RATIO_SHIFT,
-			HCLK_RATIO_MASK, 0, &_lock);
+			HCLK_RATIO_MASK, CLK_DIVIDER_MIN_DIV_DEFAULT,
+			0, &_lock);
 	clk_register_clkdev(clk, "ahb_clk", NULL);
 
 	clk = clk_register_aux("uart_syn_clk", "uart_syn_gclk", "pll1_clk", 0,
@@ -536,7 +537,8 @@ void __init spear3xx_clk_init(void)
 
 	clk = clk_register_divider(NULL, "apb_clk", "ahb_clk",
 			CLK_SET_RATE_PARENT, CORE_CLK_CFG, PCLK_RATIO_SHIFT,
-			PCLK_RATIO_MASK, 0, &_lock);
+			PCLK_RATIO_MASK, CLK_DIVIDER_MIN_DIV_DEFAULT,
+			0, &_lock);
 	clk_register_clkdev(clk, "apb_clk", NULL);
 
 	clk = clk_register_gate(NULL, "amem_clk", "ahb_clk", 0, AMEM_CLK_CFG,
diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
index 9c7f580..8370b81 100644
--- a/include/linux/clk-private.h
+++ b/include/linux/clk-private.h
@@ -105,7 +105,8 @@ struct clk {
 
 #define _DEFINE_CLK_DIVIDER(_name, _parent_name, _parent_ptr,	\
 				_flags, _reg, _shift, _width,	\
-				_divider_flags, _table, _lock)	\
+				_min_div, _divider_flags,	\
+				 _table, _lock)			\
 	static struct clk _name;				\
 	static const char *_name##_parent_names[] = {		\
 		_parent_name,					\
@@ -120,6 +121,7 @@ struct clk {
 		.reg = _reg,					\
 		.shift = _shift,				\
 		.width = _width,				\
+		.min_div = _min_div,				\
 		.flags = _divider_flags,			\
 		.table = _table,				\
 		.lock = _lock,					\
@@ -129,18 +131,20 @@ struct clk {
 
 #define DEFINE_CLK_DIVIDER(_name, _parent_name, _parent_ptr,	\
 				_flags, _reg, _shift, _width,	\
-				_divider_flags, _lock)		\
+				_min_div, _divider_flags, _lock)\
 	_DEFINE_CLK_DIVIDER(_name, _parent_name, _parent_ptr,	\
 				_flags, _reg, _shift, _width,	\
-				_divider_flags, NULL, _lock)
+				_min_div, _divider_flags,	\
+				NULL, _lock)
 
 #define DEFINE_CLK_DIVIDER_TABLE(_name, _parent_name,		\
 				_parent_ptr, _flags, _reg,	\
-				_shift, _width, _divider_flags,	\
-				_table, _lock)			\
+				_shift, _width, _min_div,	\
+				_divider_flags,	_table, _lock)	\
 	_DEFINE_CLK_DIVIDER(_name, _parent_name, _parent_ptr,	\
 				_flags, _reg, _shift, _width,	\
-				_divider_flags, _table, _lock)	\
+				_min_div, _divider_flags,	\
+				_table, _lock)
 
 #define DEFINE_CLK_MUX(_name, _parent_names, _parents, _flags,	\
 				_reg, _shift, _width,		\
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 4989b8a..655dc2b 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -248,22 +248,25 @@ struct clk_divider {
 	void __iomem	*reg;
 	u8		shift;
 	u8		width;
+	u8		min_div;
 	u8		flags;
 	const struct clk_div_table	*table;
 	spinlock_t	*lock;
 };
 
+#define	CLK_DIVIDER_MIN_DIV_DEFAULT	1
+
 #define CLK_DIVIDER_ONE_BASED		BIT(0)
 #define CLK_DIVIDER_POWER_OF_TWO	BIT(1)
 
 extern const struct clk_ops clk_divider_ops;
 struct clk *clk_register_divider(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
-		void __iomem *reg, u8 shift, u8 width,
+		void __iomem *reg, u8 shift, u8 width, u8 min_div,
 		u8 clk_divider_flags, spinlock_t *lock);
 struct clk *clk_register_divider_table(struct device *dev, const char *name,
 		const char *parent_name, unsigned long flags,
-		void __iomem *reg, u8 shift, u8 width,
+		void __iomem *reg, u8 shift, u8 width, u8 min_div,
 		u8 clk_divider_flags, const struct clk_div_table *table,
 		spinlock_t *lock);
 
-- 
1.7.12

