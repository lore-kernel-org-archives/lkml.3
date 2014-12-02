Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933164AbaLBH4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 02:56:53 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:34123 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259AbaLBH4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 02:56:47 -0500
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v7 6/7] clk: Make clk API return per-user struct clk instances
Date: Tue,  2 Dec 2014 08:54:23 +0100
Message-Id: <1417506933-8915-7-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417506933-8915-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1417506933-8915-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moves clock state to struct clk_core, but takes care to change as little API as
possible.

struct clk_hw still has a pointer to a struct clk, which is the
implementation's per-user clk instance, for backwards compatibility.

The struct clk that clk_get_parent() returns isn't owned by the caller, but by
the clock implementation, so the former shouldn't call clk_put() on it.

Because some boards in mach-omap2 still register clocks statically, their clock
registration had to be updated to take into account that the clock information
is stored in struct clk_core now.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>

---
v7:	* Add stub for __of_clk_get_by_name to fix builds without OF

v6:	* Guard against NULL pointer

v4:	* Remove unused function __clk_core_to_clk
	* Use "core" more often as the name for struct clk_core* variables
	* Make sure we don't lose information about the caller in of_clk_get_*

v3:	* Rebase on top of linux-next 20141009

v2:	* Remove exported functions that aren't really used outside clk.c
	* Rename new internal functions to clk_core_ prefix
	* Remove redundant checks for error pointers in *_get_parent
	* Change __clk_create_clk to take a struct clk_hw instead
	* Match the original error behavior in clk_get_sys
---
 arch/arm/mach-omap2/cclock3xxx_data.c   | 108 ++++--
 arch/arm/mach-omap2/clock.h             |  11 +-
 arch/arm/mach-omap2/clock_common_data.c |   5 +-
 drivers/clk/clk.c                       | 644 ++++++++++++++++++++------------
 drivers/clk/clk.h                       |   5 +
 drivers/clk/clkdev.c                    |  80 +++-
 include/linux/clk-private.h             |  35 +-
 include/linux/clk-provider.h            |   9 +-
 8 files changed, 584 insertions(+), 313 deletions(-)

diff --git a/arch/arm/mach-omap2/cclock3xxx_data.c b/arch/arm/mach-omap2/cclock3xxx_data.c
index 5c5ebb4..fe722d8 100644
--- a/arch/arm/mach-omap2/cclock3xxx_data.c
+++ b/arch/arm/mach-omap2/cclock3xxx_data.c
@@ -82,7 +82,7 @@ DEFINE_CLK_MUX(osc_sys_ck, osc_sys_ck_parent_names, NULL, 0x0,
 	       OMAP3430_PRM_CLKSEL, OMAP3430_SYS_CLKIN_SEL_SHIFT,
 	       OMAP3430_SYS_CLKIN_SEL_WIDTH, 0x0, NULL);
 
-DEFINE_CLK_DIVIDER(sys_ck, "osc_sys_ck", &osc_sys_ck, 0x0,
+DEFINE_CLK_DIVIDER(sys_ck, "osc_sys_ck", &osc_sys_ck_core, 0x0,
 		   OMAP3430_PRM_CLKSRC_CTRL, OMAP_SYSCLKDIV_SHIFT,
 		   OMAP_SYSCLKDIV_WIDTH, CLK_DIVIDER_ONE_BASED, NULL);
 
@@ -131,7 +131,7 @@ static struct clk_hw_omap dpll3_ck_hw = {
 
 DEFINE_STRUCT_CLK(dpll3_ck, dpll3_ck_parent_names, dpll3_ck_ops);
 
-DEFINE_CLK_DIVIDER(dpll3_m2_ck, "dpll3_ck", &dpll3_ck, 0x0,
+DEFINE_CLK_DIVIDER(dpll3_m2_ck, "dpll3_ck", &dpll3_ck_core, 0x0,
 		   OMAP_CM_REGADDR(PLL_MOD, CM_CLKSEL1),
 		   OMAP3430_CORE_DPLL_CLKOUT_DIV_SHIFT,
 		   OMAP3430_CORE_DPLL_CLKOUT_DIV_WIDTH,
@@ -148,12 +148,12 @@ static const struct clk_ops core_ck_ops = {};
 DEFINE_STRUCT_CLK_HW_OMAP(core_ck, NULL);
 DEFINE_STRUCT_CLK(core_ck, core_ck_parent_names, core_ck_ops);
 
-DEFINE_CLK_DIVIDER(l3_ick, "core_ck", &core_ck, 0x0,
+DEFINE_CLK_DIVIDER(l3_ick, "core_ck", &core_ck_core, 0x0,
 		   OMAP_CM_REGADDR(CORE_MOD, CM_CLKSEL),
 		   OMAP3430_CLKSEL_L3_SHIFT, OMAP3430_CLKSEL_L3_WIDTH,
 		   CLK_DIVIDER_ONE_BASED, NULL);
 
-DEFINE_CLK_DIVIDER(l4_ick, "l3_ick", &l3_ick, 0x0,
+DEFINE_CLK_DIVIDER(l4_ick, "l3_ick", &l3_ick_core, 0x0,
 		   OMAP_CM_REGADDR(CORE_MOD, CM_CLKSEL),
 		   OMAP3430_CLKSEL_L4_SHIFT, OMAP3430_CLKSEL_L4_WIDTH,
 		   CLK_DIVIDER_ONE_BASED, NULL);
@@ -274,9 +274,9 @@ static struct clk_hw_omap dpll1_ck_hw = {
 
 DEFINE_STRUCT_CLK(dpll1_ck, dpll3_ck_parent_names, dpll1_ck_ops);
 
-DEFINE_CLK_FIXED_FACTOR(dpll1_x2_ck, "dpll1_ck", &dpll1_ck, 0x0, 2, 1);
+DEFINE_CLK_FIXED_FACTOR(dpll1_x2_ck, "dpll1_ck", &dpll1_ck_core, 0x0, 2, 1);
 
-DEFINE_CLK_DIVIDER(dpll1_x2m2_ck, "dpll1_x2_ck", &dpll1_x2_ck, 0x0,
+DEFINE_CLK_DIVIDER(dpll1_x2m2_ck, "dpll1_x2_ck", &dpll1_x2_ck_core, 0x0,
 		   OMAP_CM_REGADDR(MPU_MOD, OMAP3430_CM_CLKSEL2_PLL),
 		   OMAP3430_MPU_DPLL_CLKOUT_DIV_SHIFT,
 		   OMAP3430_MPU_DPLL_CLKOUT_DIV_WIDTH,
@@ -291,7 +291,7 @@ static const char *mpu_ck_parent_names[] = {
 DEFINE_STRUCT_CLK_HW_OMAP(mpu_ck, "mpu_clkdm");
 DEFINE_STRUCT_CLK(mpu_ck, mpu_ck_parent_names, core_l4_ick_ops);
 
-DEFINE_CLK_DIVIDER(arm_fck, "mpu_ck", &mpu_ck, 0x0,
+DEFINE_CLK_DIVIDER(arm_fck, "mpu_ck", &mpu_ck_core, 0x0,
 		   OMAP_CM_REGADDR(MPU_MOD, OMAP3430_CM_IDLEST_PLL),
 		   OMAP3430_ST_MPU_CLK_SHIFT, OMAP3430_ST_MPU_CLK_WIDTH,
 		   0x0, NULL);
@@ -423,7 +423,7 @@ static const struct clk_div_table dpll4_mx_ck_div_table[] = {
 	{ .div = 0 },
 };
 
-DEFINE_CLK_DIVIDER(dpll4_m5_ck, "dpll4_ck", &dpll4_ck, 0x0,
+DEFINE_CLK_DIVIDER(dpll4_m5_ck, "dpll4_ck", &dpll4_ck_core, 0x0,
 		   OMAP_CM_REGADDR(OMAP3430_CAM_MOD, CM_CLKSEL),
 		   OMAP3430_CLKSEL_CAM_SHIFT, OMAP3630_CLKSEL_CAM_WIDTH,
 		   CLK_DIVIDER_ONE_BASED, NULL);
@@ -465,7 +465,7 @@ static struct clk_hw_omap dpll4_m5x2_ck_hw = {
 DEFINE_STRUCT_CLK_FLAGS(dpll4_m5x2_ck, dpll4_m5x2_ck_parent_names,
 			dpll4_m5x2_ck_ops, CLK_SET_RATE_PARENT);
 
-static struct clk dpll4_m5x2_ck_3630 = {
+static struct clk_core dpll4_m5x2_ck_3630_core = {
 	.name		= "dpll4_m5x2_ck",
 	.hw		= &dpll4_m5x2_ck_hw.hw,
 	.parent_names	= dpll4_m5x2_ck_parent_names,
@@ -474,6 +474,10 @@ static struct clk dpll4_m5x2_ck_3630 = {
 	.flags		= CLK_SET_RATE_PARENT,
 };
 
+static struct clk dpll4_m5x2_ck_3630 = {
+	.core = &dpll4_m5x2_ck_3630_core,
+};
+
 static struct clk cam_mclk;
 
 static const char *cam_mclk_parent_names[] = {
@@ -489,7 +493,7 @@ static struct clk_hw_omap cam_mclk_hw = {
 	.clkdm_name	= "cam_clkdm",
 };
 
-static struct clk cam_mclk = {
+static struct clk_core cam_mclk_core = {
 	.name		= "cam_mclk",
 	.hw		= &cam_mclk_hw.hw,
 	.parent_names	= cam_mclk_parent_names,
@@ -498,6 +502,10 @@ static struct clk cam_mclk = {
 	.flags		= CLK_SET_RATE_PARENT,
 };
 
+static struct clk cam_mclk = {
+	.core = &cam_mclk_core,
+};
+
 static const struct clksel_rate clkout2_src_core_rates[] = {
 	{ .div = 1, .val = 0, .flags = RATE_IN_3XXX },
 	{ .div = 0 }
@@ -513,7 +521,7 @@ static const struct clksel_rate clkout2_src_96m_rates[] = {
 	{ .div = 0 }
 };
 
-DEFINE_CLK_DIVIDER(dpll4_m2_ck, "dpll4_ck", &dpll4_ck, 0x0,
+DEFINE_CLK_DIVIDER(dpll4_m2_ck, "dpll4_ck", &dpll4_ck_core, 0x0,
 		   OMAP_CM_REGADDR(PLL_MOD, OMAP3430_CM_CLKSEL3),
 		   OMAP3430_DIV_96M_SHIFT, OMAP3630_DIV_96M_WIDTH,
 		   CLK_DIVIDER_ONE_BASED, NULL);
@@ -537,7 +545,7 @@ static struct clk_hw_omap dpll4_m2x2_ck_hw = {
 
 DEFINE_STRUCT_CLK(dpll4_m2x2_ck, dpll4_m2x2_ck_parent_names, dpll4_m5x2_ck_ops);
 
-static struct clk dpll4_m2x2_ck_3630 = {
+static struct clk_core dpll4_m2x2_ck_3630_core = {
 	.name		= "dpll4_m2x2_ck",
 	.hw		= &dpll4_m2x2_ck_hw.hw,
 	.parent_names	= dpll4_m2x2_ck_parent_names,
@@ -545,6 +553,10 @@ static struct clk dpll4_m2x2_ck_3630 = {
 	.ops		= &dpll4_m5x2_ck_3630_ops,
 };
 
+static struct clk dpll4_m2x2_ck_3630 = {
+	.core = &dpll4_m2x2_ck_3630_core,
+};
+
 static struct clk omap_96m_alwon_fck;
 
 static const char *omap_96m_alwon_fck_parent_names[] = {
@@ -569,7 +581,7 @@ static const struct clksel_rate clkout2_src_54m_rates[] = {
 	{ .div = 0 }
 };
 
-DEFINE_CLK_DIVIDER_TABLE(dpll4_m3_ck, "dpll4_ck", &dpll4_ck, 0x0,
+DEFINE_CLK_DIVIDER_TABLE(dpll4_m3_ck, "dpll4_ck", &dpll4_ck_core, 0x0,
 		   OMAP_CM_REGADDR(OMAP3430_DSS_MOD, CM_CLKSEL),
 		   OMAP3430_CLKSEL_TV_SHIFT, OMAP3630_CLKSEL_TV_WIDTH,
 		   0, dpll4_mx_ck_div_table, NULL);
@@ -593,7 +605,7 @@ static struct clk_hw_omap dpll4_m3x2_ck_hw = {
 
 DEFINE_STRUCT_CLK(dpll4_m3x2_ck, dpll4_m3x2_ck_parent_names, dpll4_m5x2_ck_ops);
 
-static struct clk dpll4_m3x2_ck_3630 = {
+static struct clk_core dpll4_m3x2_ck_3630_core = {
 	.name		= "dpll4_m3x2_ck",
 	.hw		= &dpll4_m3x2_ck_hw.hw,
 	.parent_names	= dpll4_m3x2_ck_parent_names,
@@ -601,6 +613,10 @@ static struct clk dpll4_m3x2_ck_3630 = {
 	.ops		= &dpll4_m5x2_ck_3630_ops,
 };
 
+static struct clk dpll4_m3x2_ck_3630 = {
+	.core = &dpll4_m3x2_ck_3630_core,
+};
+
 static const char *omap_54m_fck_parent_names[] = {
 	"dpll4_m3x2_ck", "sys_altclk",
 };
@@ -676,7 +692,7 @@ static struct clk_hw_omap omap_48m_fck_hw = {
 
 DEFINE_STRUCT_CLK(omap_48m_fck, omap_48m_fck_parent_names, omap_48m_fck_ops);
 
-DEFINE_CLK_FIXED_FACTOR(omap_12m_fck, "omap_48m_fck", &omap_48m_fck, 0x0, 1, 4);
+DEFINE_CLK_FIXED_FACTOR(omap_12m_fck, "omap_48m_fck", &omap_48m_fck_core, 0x0, 1, 4);
 
 static struct clk core_12m_fck;
 
@@ -722,7 +738,7 @@ static const char *core_l3_ick_parent_names[] = {
 DEFINE_STRUCT_CLK_HW_OMAP(core_l3_ick, "core_l3_clkdm");
 DEFINE_STRUCT_CLK(core_l3_ick, core_l3_ick_parent_names, core_l4_ick_ops);
 
-DEFINE_CLK_FIXED_FACTOR(dpll3_m2x2_ck, "dpll3_m2_ck", &dpll3_m2_ck, 0x0, 2, 1);
+DEFINE_CLK_FIXED_FACTOR(dpll3_m2x2_ck, "dpll3_m2_ck", &dpll3_m2_ck_core, 0x0, 2, 1);
 
 static struct clk corex2_fck;
 
@@ -804,7 +820,7 @@ static struct clk_hw_omap des2_ick_hw = {
 
 DEFINE_STRUCT_CLK(des2_ick, aes2_ick_parent_names, aes2_ick_ops);
 
-DEFINE_CLK_DIVIDER(dpll1_fck, "core_ck", &core_ck, 0x0,
+DEFINE_CLK_DIVIDER(dpll1_fck, "core_ck", &core_ck_core, 0x0,
 		   OMAP_CM_REGADDR(MPU_MOD, OMAP3430_CM_CLKSEL1_PLL),
 		   OMAP3430_MPU_CLK_SRC_SHIFT, OMAP3430_MPU_CLK_SRC_WIDTH,
 		   CLK_DIVIDER_ONE_BASED, NULL);
@@ -847,18 +863,18 @@ static struct clk_hw_omap dpll2_ck_hw = {
 
 DEFINE_STRUCT_CLK(dpll2_ck, dpll3_ck_parent_names, dpll1_ck_ops);
 
-DEFINE_CLK_DIVIDER(dpll2_fck, "core_ck", &core_ck, 0x0,
+DEFINE_CLK_DIVIDER(dpll2_fck, "core_ck", &core_ck_core, 0x0,
 		   OMAP_CM_REGADDR(OMAP3430_IVA2_MOD, OMAP3430_CM_CLKSEL1_PLL),
 		   OMAP3430_IVA2_CLK_SRC_SHIFT, OMAP3430_IVA2_CLK_SRC_WIDTH,
 		   CLK_DIVIDER_ONE_BASED, NULL);
 
-DEFINE_CLK_DIVIDER(dpll2_m2_ck, "dpll2_ck", &dpll2_ck, 0x0,
+DEFINE_CLK_DIVIDER(dpll2_m2_ck, "dpll2_ck", &dpll2_ck_core, 0x0,
 		   OMAP_CM_REGADDR(OMAP3430_IVA2_MOD, OMAP3430_CM_CLKSEL2_PLL),
 		   OMAP3430_IVA2_DPLL_CLKOUT_DIV_SHIFT,
 		   OMAP3430_IVA2_DPLL_CLKOUT_DIV_WIDTH,
 		   CLK_DIVIDER_ONE_BASED, NULL);
 
-DEFINE_CLK_DIVIDER(dpll3_m3_ck, "dpll3_ck", &dpll3_ck, 0x0,
+DEFINE_CLK_DIVIDER(dpll3_m3_ck, "dpll3_ck", &dpll3_ck_core, 0x0,
 		   OMAP_CM_REGADDR(OMAP3430_EMU_MOD, CM_CLKSEL1),
 		   OMAP3430_DIV_DPLL3_SHIFT, OMAP3430_DIV_DPLL3_WIDTH,
 		   CLK_DIVIDER_ONE_BASED, NULL);
@@ -882,7 +898,7 @@ static struct clk_hw_omap dpll3_m3x2_ck_hw = {
 
 DEFINE_STRUCT_CLK(dpll3_m3x2_ck, dpll3_m3x2_ck_parent_names, dpll4_m5x2_ck_ops);
 
-static struct clk dpll3_m3x2_ck_3630 = {
+static struct clk_core dpll3_m3x2_ck_3630_core = {
 	.name		= "dpll3_m3x2_ck",
 	.hw		= &dpll3_m3x2_ck_hw.hw,
 	.parent_names	= dpll3_m3x2_ck_parent_names,
@@ -890,9 +906,13 @@ static struct clk dpll3_m3x2_ck_3630 = {
 	.ops		= &dpll4_m5x2_ck_3630_ops,
 };
 
-DEFINE_CLK_FIXED_FACTOR(dpll3_x2_ck, "dpll3_ck", &dpll3_ck, 0x0, 2, 1);
+static struct clk dpll3_m3x2_ck_3630 = {
+	.core = &dpll3_m3x2_ck_3630_core,
+};
+
+DEFINE_CLK_FIXED_FACTOR(dpll3_x2_ck, "dpll3_ck", &dpll3_ck_core, 0x0, 2, 1);
 
-DEFINE_CLK_DIVIDER_TABLE(dpll4_m4_ck, "dpll4_ck", &dpll4_ck, 0x0,
+DEFINE_CLK_DIVIDER_TABLE(dpll4_m4_ck, "dpll4_ck", &dpll4_ck_core, 0x0,
 		   OMAP_CM_REGADDR(OMAP3430_DSS_MOD, CM_CLKSEL),
 		   OMAP3430_CLKSEL_DSS1_SHIFT, OMAP3630_CLKSEL_DSS1_WIDTH,
 		   0, dpll4_mx_ck_div_table, NULL);
@@ -917,7 +937,7 @@ static struct clk_hw_omap dpll4_m4x2_ck_hw = {
 DEFINE_STRUCT_CLK_FLAGS(dpll4_m4x2_ck, dpll4_m4x2_ck_parent_names,
 		dpll4_m5x2_ck_ops, CLK_SET_RATE_PARENT);
 
-static struct clk dpll4_m4x2_ck_3630 = {
+static struct clk_core dpll4_m4x2_ck_3630_core = {
 	.name		= "dpll4_m4x2_ck",
 	.hw		= &dpll4_m4x2_ck_hw.hw,
 	.parent_names	= dpll4_m4x2_ck_parent_names,
@@ -926,7 +946,11 @@ static struct clk dpll4_m4x2_ck_3630 = {
 	.flags		= CLK_SET_RATE_PARENT,
 };
 
-DEFINE_CLK_DIVIDER(dpll4_m6_ck, "dpll4_ck", &dpll4_ck, 0x0,
+static struct clk dpll4_m4x2_ck_3630 = {
+	.core = &dpll4_m4x2_ck_3630_core,
+};
+
+DEFINE_CLK_DIVIDER(dpll4_m6_ck, "dpll4_ck", &dpll4_ck_core, 0x0,
 		   OMAP_CM_REGADDR(OMAP3430_EMU_MOD, CM_CLKSEL1),
 		   OMAP3430_DIV_DPLL4_SHIFT, OMAP3630_DIV_DPLL4_WIDTH,
 		   CLK_DIVIDER_ONE_BASED, NULL);
@@ -950,7 +974,7 @@ static struct clk_hw_omap dpll4_m6x2_ck_hw = {
 
 DEFINE_STRUCT_CLK(dpll4_m6x2_ck, dpll4_m6x2_ck_parent_names, dpll4_m5x2_ck_ops);
 
-static struct clk dpll4_m6x2_ck_3630 = {
+static struct clk_core dpll4_m6x2_ck_3630_core = {
 	.name		= "dpll4_m6x2_ck",
 	.hw		= &dpll4_m6x2_ck_hw.hw,
 	.parent_names	= dpll4_m6x2_ck_parent_names,
@@ -958,7 +982,11 @@ static struct clk dpll4_m6x2_ck_3630 = {
 	.ops		= &dpll4_m5x2_ck_3630_ops,
 };
 
-DEFINE_CLK_FIXED_FACTOR(dpll4_x2_ck, "dpll4_ck", &dpll4_ck, 0x0, 2, 1);
+static struct clk dpll4_m6x2_ck_3630 = {
+	.core = &dpll4_m6x2_ck_3630_core,
+};
+
+DEFINE_CLK_FIXED_FACTOR(dpll4_x2_ck, "dpll4_ck", &dpll4_ck_core, 0x0, 2, 1);
 
 static struct dpll_data dpll5_dd = {
 	.mult_div1_reg	= OMAP_CM_REGADDR(PLL_MOD, OMAP3430ES2_CM_CLKSEL4),
@@ -995,7 +1023,7 @@ static struct clk_hw_omap dpll5_ck_hw = {
 
 DEFINE_STRUCT_CLK(dpll5_ck, dpll3_ck_parent_names, dpll1_ck_ops);
 
-DEFINE_CLK_DIVIDER(dpll5_m2_ck, "dpll5_ck", &dpll5_ck, 0x0,
+DEFINE_CLK_DIVIDER(dpll5_m2_ck, "dpll5_ck", &dpll5_ck_core, 0x0,
 		   OMAP_CM_REGADDR(PLL_MOD, OMAP3430ES2_CM_CLKSEL5),
 		   OMAP3430ES2_DIV_120M_SHIFT, OMAP3430ES2_DIV_120M_WIDTH,
 		   CLK_DIVIDER_ONE_BASED, NULL);
@@ -1242,7 +1270,7 @@ static struct clk_hw_omap emu_src_ck_hw = {
 
 DEFINE_STRUCT_CLK(emu_src_ck, emu_src_ck_parent_names, emu_src_ck_ops);
 
-DEFINE_CLK_DIVIDER(atclk_fck, "emu_src_ck", &emu_src_ck, 0x0,
+DEFINE_CLK_DIVIDER(atclk_fck, "emu_src_ck", &emu_src_ck_core, 0x0,
 		   OMAP_CM_REGADDR(OMAP3430_EMU_MOD, CM_CLKSEL1),
 		   OMAP3430_CLKSEL_ATCLK_SHIFT, OMAP3430_CLKSEL_ATCLK_WIDTH,
 		   CLK_DIVIDER_ONE_BASED, NULL);
@@ -1293,7 +1321,7 @@ static struct clk_hw_omap gfx_l3_ck_hw = {
 
 DEFINE_STRUCT_CLK(gfx_l3_ck, core_l3_ick_parent_names, aes1_ick_ops);
 
-DEFINE_CLK_DIVIDER(gfx_l3_fck, "l3_ick", &l3_ick, 0x0,
+DEFINE_CLK_DIVIDER(gfx_l3_fck, "l3_ick", &l3_ick_core, 0x0,
 		   OMAP_CM_REGADDR(GFX_MOD, CM_CLKSEL),
 		   OMAP_CLKSEL_GFX_SHIFT, OMAP_CLKSEL_GFX_WIDTH,
 		   CLK_DIVIDER_ONE_BASED, NULL);
@@ -2493,7 +2521,7 @@ static struct clk_hw_omap omap_96m_alwon_fck_3630_hw = {
 	.clksel_mask	= OMAP3630_CLKSEL_96M_MASK,
 };
 
-static struct clk omap_96m_alwon_fck_3630 = {
+static struct clk_core omap_96m_alwon_fck_3630_core = {
 	.name	= "omap_96m_alwon_fck",
 	.hw	= &omap_96m_alwon_fck_3630_hw.hw,
 	.parent_names	= omap_96m_alwon_fck_3630_parent_names,
@@ -2501,6 +2529,10 @@ static struct clk omap_96m_alwon_fck_3630 = {
 	.ops	= &omap_96m_alwon_fck_3630_ops,
 };
 
+static struct clk omap_96m_alwon_fck_3630 = {
+	.core = &omap_96m_alwon_fck_3630_core,
+};
+
 static struct clk omapctrl_ick;
 
 static struct clk_hw_omap omapctrl_ick_hw = {
@@ -2516,12 +2548,12 @@ static struct clk_hw_omap omapctrl_ick_hw = {
 
 DEFINE_STRUCT_CLK(omapctrl_ick, aes2_ick_parent_names, aes2_ick_ops);
 
-DEFINE_CLK_DIVIDER(pclk_fck, "emu_src_ck", &emu_src_ck, 0x0,
+DEFINE_CLK_DIVIDER(pclk_fck, "emu_src_ck", &emu_src_ck_core, 0x0,
 		   OMAP_CM_REGADDR(OMAP3430_EMU_MOD, CM_CLKSEL1),
 		   OMAP3430_CLKSEL_PCLK_SHIFT, OMAP3430_CLKSEL_PCLK_WIDTH,
 		   CLK_DIVIDER_ONE_BASED, NULL);
 
-DEFINE_CLK_DIVIDER(pclkx2_fck, "emu_src_ck", &emu_src_ck, 0x0,
+DEFINE_CLK_DIVIDER(pclkx2_fck, "emu_src_ck", &emu_src_ck_core, 0x0,
 		   OMAP_CM_REGADDR(OMAP3430_EMU_MOD, CM_CLKSEL1),
 		   OMAP3430_CLKSEL_PCLKX2_SHIFT, OMAP3430_CLKSEL_PCLKX2_WIDTH,
 		   CLK_DIVIDER_ONE_BASED, NULL);
@@ -2553,7 +2585,7 @@ static struct clk_hw_omap pka_ick_hw = {
 
 DEFINE_STRUCT_CLK(pka_ick, pka_ick_parent_names, aes1_ick_ops);
 
-DEFINE_CLK_DIVIDER(rm_ick, "l4_ick", &l4_ick, 0x0,
+DEFINE_CLK_DIVIDER(rm_ick, "l4_ick", &l4_ick_core, 0x0,
 		   OMAP_CM_REGADDR(WKUP_MOD, CM_CLKSEL),
 		   OMAP3430_CLKSEL_RM_SHIFT, OMAP3430_CLKSEL_RM_WIDTH,
 		   CLK_DIVIDER_ONE_BASED, NULL);
@@ -2814,10 +2846,10 @@ DEFINE_CLK_OMAP_MUX_GATE(ssi_ssr_fck_3430es2, "core_l4_clkdm",
 			 ssi_ssr_fck_3430es1_ops);
 
 DEFINE_CLK_FIXED_FACTOR(ssi_sst_fck_3430es1, "ssi_ssr_fck_3430es1",
-			&ssi_ssr_fck_3430es1, 0x0, 1, 2);
+			&ssi_ssr_fck_3430es1_core, 0x0, 1, 2);
 
 DEFINE_CLK_FIXED_FACTOR(ssi_sst_fck_3430es2, "ssi_ssr_fck_3430es2",
-			&ssi_ssr_fck_3430es2, 0x0, 1, 2);
+			&ssi_ssr_fck_3430es2_core, 0x0, 1, 2);
 
 static struct clk sys_clkout1;
 
@@ -2835,7 +2867,7 @@ static struct clk_hw_omap sys_clkout1_hw = {
 
 DEFINE_STRUCT_CLK(sys_clkout1, sys_clkout1_parent_names, aes1_ick_ops);
 
-DEFINE_CLK_DIVIDER(sys_clkout2, "clkout2_src_ck", &clkout2_src_ck, 0x0,
+DEFINE_CLK_DIVIDER(sys_clkout2, "clkout2_src_ck", &clkout2_src_ck_core, 0x0,
 		   OMAP3430_CM_CLKOUT_CTRL, OMAP3430_CLKOUT2_DIV_SHIFT,
 		   OMAP3430_CLKOUT2_DIV_WIDTH, CLK_DIVIDER_POWER_OF_TWO, NULL);
 
@@ -2844,7 +2876,7 @@ DEFINE_CLK_MUX(traceclk_src_fck, emu_src_ck_parent_names, NULL, 0x0,
 	       OMAP3430_TRACE_MUX_CTRL_SHIFT, OMAP3430_TRACE_MUX_CTRL_WIDTH,
 	       0x0, NULL);
 
-DEFINE_CLK_DIVIDER(traceclk_fck, "traceclk_src_fck", &traceclk_src_fck, 0x0,
+DEFINE_CLK_DIVIDER(traceclk_fck, "traceclk_src_fck", &traceclk_src_fck_core, 0x0,
 		   OMAP_CM_REGADDR(OMAP3430_EMU_MOD, CM_CLKSEL1),
 		   OMAP3430_CLKSEL_TRACECLK_SHIFT,
 		   OMAP3430_CLKSEL_TRACECLK_WIDTH, CLK_DIVIDER_ONE_BASED, NULL);
diff --git a/arch/arm/mach-omap2/clock.h b/arch/arm/mach-omap2/clock.h
index 641337c..ccfa268 100644
--- a/arch/arm/mach-omap2/clock.h
+++ b/arch/arm/mach-omap2/clock.h
@@ -40,23 +40,29 @@ struct omap_clk {
 struct clockdomain;
 
 #define DEFINE_STRUCT_CLK(_name, _parent_array_name, _clkops_name)	\
-	static struct clk _name = {				\
+	static struct clk_core _name##_core = {			\
 		.name = #_name,					\
 		.hw = &_name##_hw.hw,				\
 		.parent_names = _parent_array_name,		\
 		.num_parents = ARRAY_SIZE(_parent_array_name),	\
 		.ops = &_clkops_name,				\
+	};							\
+	static struct clk _name = {				\
+		.core = &_name##_core,				\
 	};
 
 #define DEFINE_STRUCT_CLK_FLAGS(_name, _parent_array_name,	\
 				_clkops_name, _flags)		\
-	static struct clk _name = {				\
+	static struct clk_core _name##_core = {			\
 		.name = #_name,					\
 		.hw = &_name##_hw.hw,				\
 		.parent_names = _parent_array_name,		\
 		.num_parents = ARRAY_SIZE(_parent_array_name),	\
 		.ops = &_clkops_name,				\
 		.flags = _flags,				\
+	};							\
+	static struct clk _name = {				\
+		.core = &_name##_core,				\
 	};
 
 #define DEFINE_STRUCT_CLK_HW_OMAP(_name, _clkdm_name)		\
@@ -248,6 +254,7 @@ extern const struct clksel_rate gpt_32k_rates[];
 extern const struct clksel_rate gpt_sys_rates[];
 extern const struct clksel_rate gfx_l3_rates[];
 extern const struct clksel_rate dsp_ick_rates[];
+extern struct clk_core dummy_ck_core;
 extern struct clk dummy_ck;
 
 extern const struct clk_hw_omap_ops clkhwops_iclk_wait;
diff --git a/arch/arm/mach-omap2/clock_common_data.c b/arch/arm/mach-omap2/clock_common_data.c
index ef4d21b..febd0a2 100644
--- a/arch/arm/mach-omap2/clock_common_data.c
+++ b/arch/arm/mach-omap2/clock_common_data.c
@@ -119,8 +119,11 @@ const struct clksel_rate div31_1to31_rates[] = {
 
 static struct clk_ops dummy_ck_ops = {};
 
-struct clk dummy_ck = {
+struct clk_core dummy_ck_core = {
 	.name = "dummy_clk",
 	.ops = &dummy_ck_ops,
 	.flags = CLK_IS_BASIC,
 };
+struct clk dummy_ck = {
+	.core = &dummy_ck_core,
+};
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 44cdc47..57ae17f 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -37,6 +37,15 @@ static HLIST_HEAD(clk_root_list);
 static HLIST_HEAD(clk_orphan_list);
 static LIST_HEAD(clk_notifier_list);
 
+static long clk_core_get_accuracy(struct clk_core *clk);
+static unsigned long clk_core_get_rate(struct clk_core *clk);
+static int clk_core_get_phase(struct clk_core *clk);
+static struct clk_core *clk_core_get_parent(struct clk_core *clk);
+static bool clk_core_is_prepared(struct clk_core *clk);
+static bool clk_core_is_enabled(struct clk_core *clk);
+static long clk_core_round_rate(struct clk_core *core, unsigned long rate);
+static struct clk_core *clk_core_lookup(const char *name);
+
 /***           locking             ***/
 static void clk_prepare_lock(void)
 {
@@ -114,7 +123,7 @@ static struct hlist_head *orphan_list[] = {
 	NULL,
 };
 
-static void clk_summary_show_one(struct seq_file *s, struct clk *c, int level)
+static void clk_summary_show_one(struct seq_file *s, struct clk_core *c, int level)
 {
 	if (!c)
 		return;
@@ -122,14 +131,14 @@ static void clk_summary_show_one(struct seq_file *s, struct clk *c, int level)
 	seq_printf(s, "%*s%-*s %11d %12d %11lu %10lu %-3d\n",
 		   level * 3 + 1, "",
 		   30 - level * 3, c->name,
-		   c->enable_count, c->prepare_count, clk_get_rate(c),
-		   clk_get_accuracy(c), clk_get_phase(c));
+		   c->enable_count, c->prepare_count, clk_core_get_rate(c),
+		   clk_core_get_accuracy(c), clk_core_get_phase(c));
 }
 
-static void clk_summary_show_subtree(struct seq_file *s, struct clk *c,
+static void clk_summary_show_subtree(struct seq_file *s, struct clk_core *c,
 				     int level)
 {
-	struct clk *child;
+	struct clk_core *child;
 
 	if (!c)
 		return;
@@ -142,7 +151,7 @@ static void clk_summary_show_subtree(struct seq_file *s, struct clk *c,
 
 static int clk_summary_show(struct seq_file *s, void *data)
 {
-	struct clk *c;
+	struct clk_core *c;
 	struct hlist_head **lists = (struct hlist_head **)s->private;
 
 	seq_puts(s, "   clock                         enable_cnt  prepare_cnt        rate   accuracy   phase\n");
@@ -172,7 +181,7 @@ static const struct file_operations clk_summary_fops = {
 	.release	= single_release,
 };
 
-static void clk_dump_one(struct seq_file *s, struct clk *c, int level)
+static void clk_dump_one(struct seq_file *s, struct clk_core *c, int level)
 {
 	if (!c)
 		return;
@@ -180,14 +189,14 @@ static void clk_dump_one(struct seq_file *s, struct clk *c, int level)
 	seq_printf(s, "\"%s\": { ", c->name);
 	seq_printf(s, "\"enable_count\": %d,", c->enable_count);
 	seq_printf(s, "\"prepare_count\": %d,", c->prepare_count);
-	seq_printf(s, "\"rate\": %lu", clk_get_rate(c));
-	seq_printf(s, "\"accuracy\": %lu", clk_get_accuracy(c));
-	seq_printf(s, "\"phase\": %d", clk_get_phase(c));
+	seq_printf(s, "\"rate\": %lu", clk_core_get_rate(c));
+	seq_printf(s, "\"accuracy\": %lu", clk_core_get_accuracy(c));
+	seq_printf(s, "\"phase\": %d", clk_core_get_phase(c));
 }
 
-static void clk_dump_subtree(struct seq_file *s, struct clk *c, int level)
+static void clk_dump_subtree(struct seq_file *s, struct clk_core *c, int level)
 {
-	struct clk *child;
+	struct clk_core *child;
 
 	if (!c)
 		return;
@@ -204,7 +213,7 @@ static void clk_dump_subtree(struct seq_file *s, struct clk *c, int level)
 
 static int clk_dump(struct seq_file *s, void *data)
 {
-	struct clk *c;
+	struct clk_core *c;
 	bool first_node = true;
 	struct hlist_head **lists = (struct hlist_head **)s->private;
 
@@ -241,7 +250,7 @@ static const struct file_operations clk_dump_fops = {
 };
 
 /* caller must hold prepare_lock */
-static int clk_debug_create_one(struct clk *clk, struct dentry *pdentry)
+static int clk_debug_create_one(struct clk_core *clk, struct dentry *pdentry)
 {
 	struct dentry *d;
 	int ret = -ENOMEM;
@@ -316,7 +325,7 @@ out:
  * initialized.  Otherwise it bails out early since the debugfs clk tree
  * will be created lazily by clk_debug_init as part of a late_initcall.
  */
-static int clk_debug_register(struct clk *clk)
+static int clk_debug_register(struct clk_core *clk)
 {
 	int ret = 0;
 
@@ -341,7 +350,7 @@ unlock:
  * debugfs clk tree if clk->dentry points to debugfs created by
  * clk_debug_register in __clk_init.
  */
-static void clk_debug_unregister(struct clk *clk)
+static void clk_debug_unregister(struct clk_core *clk)
 {
 	mutex_lock(&clk_debug_lock);
 	if (!clk->dentry)
@@ -359,8 +368,8 @@ struct dentry *clk_debugfs_add_file(struct clk_hw *hw, char *name, umode_t mode,
 {
 	struct dentry *d = NULL;
 
-	if (hw->clk->dentry)
-		d = debugfs_create_file(name, mode, hw->clk->dentry, data, fops);
+	if (hw->core->dentry)
+		d = debugfs_create_file(name, mode, hw->core->dentry, data, fops);
 
 	return d;
 }
@@ -380,7 +389,7 @@ EXPORT_SYMBOL_GPL(clk_debugfs_add_file);
  */
 static int __init clk_debug_init(void)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 	struct dentry *d;
 
 	rootdir = debugfs_create_dir("clk", NULL);
@@ -419,19 +428,20 @@ static int __init clk_debug_init(void)
 }
 late_initcall(clk_debug_init);
 #else
-static inline int clk_debug_register(struct clk *clk) { return 0; }
-static inline void clk_debug_reparent(struct clk *clk, struct clk *new_parent)
+static inline int clk_debug_register(struct clk_core *clk) { return 0; }
+static inline void clk_debug_reparent(struct clk_core *clk,
+				      struct clk_core *new_parent)
 {
 }
-static inline void clk_debug_unregister(struct clk *clk)
+static inline void clk_debug_unregister(struct clk_core *clk)
 {
 }
 #endif
 
 /* caller must hold prepare_lock */
-static void clk_unprepare_unused_subtree(struct clk *clk)
+static void clk_unprepare_unused_subtree(struct clk_core *clk)
 {
-	struct clk *child;
+	struct clk_core *child;
 
 	if (!clk)
 		return;
@@ -445,7 +455,7 @@ static void clk_unprepare_unused_subtree(struct clk *clk)
 	if (clk->flags & CLK_IGNORE_UNUSED)
 		return;
 
-	if (__clk_is_prepared(clk)) {
+	if (clk_core_is_prepared(clk)) {
 		if (clk->ops->unprepare_unused)
 			clk->ops->unprepare_unused(clk->hw);
 		else if (clk->ops->unprepare)
@@ -454,9 +464,9 @@ static void clk_unprepare_unused_subtree(struct clk *clk)
 }
 
 /* caller must hold prepare_lock */
-static void clk_disable_unused_subtree(struct clk *clk)
+static void clk_disable_unused_subtree(struct clk_core *clk)
 {
-	struct clk *child;
+	struct clk_core *child;
 	unsigned long flags;
 
 	if (!clk)
@@ -478,7 +488,7 @@ static void clk_disable_unused_subtree(struct clk *clk)
 	 * sequence.  call .disable_unused if available, otherwise fall
 	 * back to .disable
 	 */
-	if (__clk_is_enabled(clk)) {
+	if (clk_core_is_enabled(clk)) {
 		if (clk->ops->disable_unused)
 			clk->ops->disable_unused(clk->hw);
 		else if (clk->ops->disable)
@@ -502,7 +512,7 @@ __setup("clk_ignore_unused", clk_ignore_unused_setup);
 
 static int clk_disable_unused(void)
 {
-	struct clk *clk;
+	struct clk_core *clk;
 
 	if (clk_ignore_unused) {
 		pr_warn("clk: Not disabling unused clocks\n");
@@ -533,48 +543,59 @@ late_initcall_sync(clk_disable_unused);
 
 const char *__clk_get_name(struct clk *clk)
 {
-	return !clk ? NULL : clk->name;
+	return !clk ? NULL : clk->core->name;
 }
 EXPORT_SYMBOL_GPL(__clk_get_name);
 
 struct clk_hw *__clk_get_hw(struct clk *clk)
 {
-	return !clk ? NULL : clk->hw;
+	return !clk ? NULL : clk->core->hw;
 }
 EXPORT_SYMBOL_GPL(__clk_get_hw);
 
 u8 __clk_get_num_parents(struct clk *clk)
 {
-	return !clk ? 0 : clk->num_parents;
+	return !clk ? 0 : clk->core->num_parents;
 }
 EXPORT_SYMBOL_GPL(__clk_get_num_parents);
 
 struct clk *__clk_get_parent(struct clk *clk)
 {
-	return !clk ? NULL : clk->parent;
+	/* TODO: Create a per-user clk and change callers to call clk_put */
+	return !clk ? NULL : clk->core->parent->hw->clk;
 }
 EXPORT_SYMBOL_GPL(__clk_get_parent);
 
-struct clk *clk_get_parent_by_index(struct clk *clk, u8 index)
+static struct clk_core *clk_core_get_parent_by_index(struct clk_core *clk,
+							 u8 index)
 {
 	if (!clk || index >= clk->num_parents)
 		return NULL;
 	else if (!clk->parents)
-		return __clk_lookup(clk->parent_names[index]);
+		return clk_core_lookup(clk->parent_names[index]);
 	else if (!clk->parents[index])
 		return clk->parents[index] =
-			__clk_lookup(clk->parent_names[index]);
+			clk_core_lookup(clk->parent_names[index]);
 	else
 		return clk->parents[index];
 }
+
+struct clk *clk_get_parent_by_index(struct clk *clk, u8 index)
+{
+	struct clk_core *parent;
+
+	parent = clk_core_get_parent_by_index(clk->core, index);
+
+	return !parent ? NULL : parent->hw->clk;
+}
 EXPORT_SYMBOL_GPL(clk_get_parent_by_index);
 
 unsigned int __clk_get_enable_count(struct clk *clk)
 {
-	return !clk ? 0 : clk->enable_count;
+	return !clk ? 0 : clk->core->enable_count;
 }
 
-unsigned long __clk_get_rate(struct clk *clk)
+static unsigned long clk_core_get_rate_nolock(struct clk_core *clk)
 {
 	unsigned long ret;
 
@@ -594,9 +615,14 @@ unsigned long __clk_get_rate(struct clk *clk)
 out:
 	return ret;
 }
+
+unsigned long __clk_get_rate(struct clk *clk)
+{
+	return clk_core_get_rate_nolock(clk->core);
+}
 EXPORT_SYMBOL_GPL(__clk_get_rate);
 
-static unsigned long __clk_get_accuracy(struct clk *clk)
+static unsigned long __clk_get_accuracy(struct clk_core *clk)
 {
 	if (!clk)
 		return 0;
@@ -606,11 +632,11 @@ static unsigned long __clk_get_accuracy(struct clk *clk)
 
 unsigned long __clk_get_flags(struct clk *clk)
 {
-	return !clk ? 0 : clk->flags;
+	return !clk ? 0 : clk->core->flags;
 }
 EXPORT_SYMBOL_GPL(__clk_get_flags);
 
-bool __clk_is_prepared(struct clk *clk)
+static bool clk_core_is_prepared(struct clk_core *clk)
 {
 	int ret;
 
@@ -631,7 +657,12 @@ out:
 	return !!ret;
 }
 
-bool __clk_is_enabled(struct clk *clk)
+bool __clk_is_prepared(struct clk *clk)
+{
+	return clk_core_is_prepared(clk->core);
+}
+
+static bool clk_core_is_enabled(struct clk_core *clk)
 {
 	int ret;
 
@@ -651,12 +682,17 @@ bool __clk_is_enabled(struct clk *clk)
 out:
 	return !!ret;
 }
+
+bool __clk_is_enabled(struct clk *clk)
+{
+	return clk_core_is_enabled(clk->core);
+}
 EXPORT_SYMBOL_GPL(__clk_is_enabled);
 
-static struct clk *__clk_lookup_subtree(const char *name, struct clk *clk)
+static struct clk_core *__clk_lookup_subtree(const char *name, struct clk_core *clk)
 {
-	struct clk *child;
-	struct clk *ret;
+	struct clk_core *child;
+	struct clk_core *ret;
 
 	if (!strcmp(clk->name, name))
 		return clk;
@@ -670,10 +706,10 @@ static struct clk *__clk_lookup_subtree(const char *name, struct clk *clk)
 	return NULL;
 }
 
-struct clk *__clk_lookup(const char *name)
+static struct clk_core *clk_core_lookup(const char *name)
 {
-	struct clk *root_clk;
-	struct clk *ret;
+	struct clk_core *root_clk;
+	struct clk_core *ret;
 
 	if (!name)
 		return NULL;
@@ -695,6 +731,13 @@ struct clk *__clk_lookup(const char *name)
 	return NULL;
 }
 
+struct clk *__clk_lookup(const char *name)
+{
+	struct clk_core *core = clk_core_lookup(name);
+
+	return !core ? NULL : core->hw->clk;
+}
+
 /*
  * Helper for finding best parent to provide a given frequency. This can be used
  * directly as a determine_rate callback (e.g. for a mux), or from a more
@@ -704,32 +747,32 @@ long __clk_mux_determine_rate(struct clk_hw *hw, unsigned long rate,
 			      unsigned long *best_parent_rate,
 			      struct clk_hw **best_parent_p)
 {
-	struct clk *clk = hw->clk, *parent, *best_parent = NULL;
+	struct clk_core *core = hw->clk->core, *parent, *best_parent = NULL;
 	int i, num_parents;
 	unsigned long parent_rate, best = 0;
 
 	/* if NO_REPARENT flag set, pass through to current parent */
-	if (clk->flags & CLK_SET_RATE_NO_REPARENT) {
-		parent = clk->parent;
-		if (clk->flags & CLK_SET_RATE_PARENT)
-			best = __clk_round_rate(parent, rate);
+	if (core->flags & CLK_SET_RATE_NO_REPARENT) {
+		parent = core->parent;
+		if (core->flags & CLK_SET_RATE_PARENT)
+			best = clk_core_round_rate(parent, rate);
 		else if (parent)
-			best = __clk_get_rate(parent);
+			best = clk_core_get_rate(parent);
 		else
-			best = __clk_get_rate(clk);
+			best = clk_core_get_rate(core);
 		goto out;
 	}
 
 	/* find the parent that can provide the fastest rate <= rate */
-	num_parents = clk->num_parents;
+	num_parents = core->num_parents;
 	for (i = 0; i < num_parents; i++) {
-		parent = clk_get_parent_by_index(clk, i);
+		parent = clk_core_get_parent_by_index(core, i);
 		if (!parent)
 			continue;
-		if (clk->flags & CLK_SET_RATE_PARENT)
-			parent_rate = __clk_round_rate(parent, rate);
+		if (core->flags & CLK_SET_RATE_PARENT)
+			parent_rate = clk_core_round_rate(parent, rate);
 		else
-			parent_rate = __clk_get_rate(parent);
+			parent_rate = clk_core_get_rate(parent);
 		if (parent_rate <= rate && parent_rate > best) {
 			best_parent = parent;
 			best = parent_rate;
@@ -747,7 +790,7 @@ EXPORT_SYMBOL_GPL(__clk_mux_determine_rate);
 
 /***        clk api        ***/
 
-void __clk_unprepare(struct clk *clk)
+static void clk_core_unprepare(struct clk_core *clk)
 {
 	if (!clk)
 		return;
@@ -763,7 +806,12 @@ void __clk_unprepare(struct clk *clk)
 	if (clk->ops->unprepare)
 		clk->ops->unprepare(clk->hw);
 
-	__clk_unprepare(clk->parent);
+	clk_core_unprepare(clk->parent);
+}
+
+void __clk_unprepare(struct clk *clk)
+{
+	clk_core_unprepare(clk->core);
 }
 
 /**
@@ -788,7 +836,7 @@ void clk_unprepare(struct clk *clk)
 }
 EXPORT_SYMBOL_GPL(clk_unprepare);
 
-int __clk_prepare(struct clk *clk)
+static int clk_core_prepare(struct clk_core *clk)
 {
 	int ret = 0;
 
@@ -796,14 +844,14 @@ int __clk_prepare(struct clk *clk)
 		return 0;
 
 	if (clk->prepare_count == 0) {
-		ret = __clk_prepare(clk->parent);
+		ret = clk_core_prepare(clk->parent);
 		if (ret)
 			return ret;
 
 		if (clk->ops->prepare) {
 			ret = clk->ops->prepare(clk->hw);
 			if (ret) {
-				__clk_unprepare(clk->parent);
+				clk_core_unprepare(clk->parent);
 				return ret;
 			}
 		}
@@ -814,6 +862,11 @@ int __clk_prepare(struct clk *clk)
 	return 0;
 }
 
+int __clk_prepare(struct clk *clk)
+{
+	return clk_core_prepare(clk->core);
+}
+
 /**
  * clk_prepare - prepare a clock source
  * @clk: the clk being prepared
@@ -838,7 +891,7 @@ int clk_prepare(struct clk *clk)
 }
 EXPORT_SYMBOL_GPL(clk_prepare);
 
-static void __clk_disable(struct clk *clk)
+static void clk_core_disable(struct clk_core *clk)
 {
 	if (!clk)
 		return;
@@ -852,7 +905,12 @@ static void __clk_disable(struct clk *clk)
 	if (clk->ops->disable)
 		clk->ops->disable(clk->hw);
 
-	__clk_disable(clk->parent);
+	clk_core_disable(clk->parent);
+}
+
+static void __clk_disable(struct clk *clk)
+{
+	clk_core_disable(clk->core);
 }
 
 /**
@@ -880,7 +938,7 @@ void clk_disable(struct clk *clk)
 }
 EXPORT_SYMBOL_GPL(clk_disable);
 
-static int __clk_enable(struct clk *clk)
+static int clk_core_enable(struct clk_core *clk)
 {
 	int ret = 0;
 
@@ -891,7 +949,7 @@ static int __clk_enable(struct clk *clk)
 		return -ESHUTDOWN;
 
 	if (clk->enable_count == 0) {
-		ret = __clk_enable(clk->parent);
+		ret = clk_core_enable(clk->parent);
 
 		if (ret)
 			return ret;
@@ -899,7 +957,7 @@ static int __clk_enable(struct clk *clk)
 		if (clk->ops->enable) {
 			ret = clk->ops->enable(clk->hw);
 			if (ret) {
-				__clk_disable(clk->parent);
+				clk_core_disable(clk->parent);
 				return ret;
 			}
 		}
@@ -909,6 +967,11 @@ static int __clk_enable(struct clk *clk)
 	return 0;
 }
 
+static int __clk_enable(struct clk *clk)
+{
+	return clk_core_enable(clk->core);
+}
+
 /**
  * clk_enable - ungate a clock
  * @clk: the clk being ungated
@@ -935,17 +998,11 @@ int clk_enable(struct clk *clk)
 }
 EXPORT_SYMBOL_GPL(clk_enable);
 
-/**
- * __clk_round_rate - round the given rate for a clk
- * @clk: round the rate of this clock
- * @rate: the rate which is to be rounded
- *
- * Caller must hold prepare_lock.  Useful for clk_ops such as .set_rate
- */
-unsigned long __clk_round_rate(struct clk *clk, unsigned long rate)
+static unsigned long clk_core_round_rate_nolock(struct clk_core *clk,
+						    unsigned long rate)
 {
 	unsigned long parent_rate = 0;
-	struct clk *parent;
+	struct clk_core *parent;
 	struct clk_hw *parent_hw;
 
 	if (!clk)
@@ -962,12 +1019,35 @@ unsigned long __clk_round_rate(struct clk *clk, unsigned long rate)
 	} else if (clk->ops->round_rate)
 		return clk->ops->round_rate(clk->hw, rate, &parent_rate);
 	else if (clk->flags & CLK_SET_RATE_PARENT)
-		return __clk_round_rate(clk->parent, rate);
+		return clk_core_round_rate_nolock(clk->parent, rate);
 	else
 		return clk->rate;
 }
+
+/**
+ * __clk_round_rate - round the given rate for a clk
+ * @clk: round the rate of this clock
+ * @rate: the rate which is to be rounded
+ *
+ * Caller must hold prepare_lock.  Useful for clk_ops such as .set_rate
+ */
+unsigned long __clk_round_rate(struct clk *clk, unsigned long rate)
+{
+	return clk_core_round_rate_nolock(clk->core, rate);
+}
 EXPORT_SYMBOL_GPL(__clk_round_rate);
 
+static long clk_core_round_rate(struct clk_core *core, unsigned long rate)
+{
+	unsigned long ret;
+
+	clk_prepare_lock();
+	ret = clk_core_round_rate_nolock(core, rate);
+	clk_prepare_unlock();
+
+	return ret;
+}
+
 /**
  * clk_round_rate - round the given rate for a clk
  * @clk: the clk for which we are rounding a rate
@@ -979,13 +1059,7 @@ EXPORT_SYMBOL_GPL(__clk_round_rate);
  */
 long clk_round_rate(struct clk *clk, unsigned long rate)
 {
-	unsigned long ret;
-
-	clk_prepare_lock();
-	ret = __clk_round_rate(clk, rate);
-	clk_prepare_unlock();
-
-	return ret;
+	return clk_core_round_rate(clk->core, rate);
 }
 EXPORT_SYMBOL_GPL(clk_round_rate);
 
@@ -1003,22 +1077,21 @@ EXPORT_SYMBOL_GPL(clk_round_rate);
  * called if all went well, or NOTIFY_STOP or NOTIFY_BAD immediately if
  * a driver returns that.
  */
-static int __clk_notify(struct clk *clk, unsigned long msg,
+static int __clk_notify(struct clk_core *clk, unsigned long msg,
 		unsigned long old_rate, unsigned long new_rate)
 {
 	struct clk_notifier *cn;
 	struct clk_notifier_data cnd;
 	int ret = NOTIFY_DONE;
 
-	cnd.clk = clk;
 	cnd.old_rate = old_rate;
 	cnd.new_rate = new_rate;
 
 	list_for_each_entry(cn, &clk_notifier_list, node) {
-		if (cn->clk == clk) {
+		if (cn->clk->core == clk) {
+			cnd.clk = cn->clk;
 			ret = srcu_notifier_call_chain(&cn->notifier_head, msg,
 					&cnd);
-			break;
 		}
 	}
 
@@ -1036,10 +1109,10 @@ static int __clk_notify(struct clk *clk, unsigned long msg,
  *
  * Caller must hold prepare_lock.
  */
-static void __clk_recalc_accuracies(struct clk *clk)
+static void __clk_recalc_accuracies(struct clk_core *clk)
 {
 	unsigned long parent_accuracy = 0;
-	struct clk *child;
+	struct clk_core *child;
 
 	if (clk->parent)
 		parent_accuracy = clk->parent->accuracy;
@@ -1054,16 +1127,7 @@ static void __clk_recalc_accuracies(struct clk *clk)
 		__clk_recalc_accuracies(child);
 }
 
-/**
- * clk_get_accuracy - return the accuracy of clk
- * @clk: the clk whose accuracy is being returned
- *
- * Simply returns the cached accuracy of the clk, unless
- * CLK_GET_ACCURACY_NOCACHE flag is set, which means a recalc_rate will be
- * issued.
- * If clk is NULL then returns 0.
- */
-long clk_get_accuracy(struct clk *clk)
+static long clk_core_get_accuracy(struct clk_core *clk)
 {
 	unsigned long accuracy;
 
@@ -1076,9 +1140,24 @@ long clk_get_accuracy(struct clk *clk)
 
 	return accuracy;
 }
+
+/**
+ * clk_get_accuracy - return the accuracy of clk
+ * @clk: the clk whose accuracy is being returned
+ *
+ * Simply returns the cached accuracy of the clk, unless
+ * CLK_GET_ACCURACY_NOCACHE flag is set, which means a recalc_rate will be
+ * issued.
+ * If clk is NULL then returns 0.
+ */
+long clk_get_accuracy(struct clk *clk)
+{
+	return clk_core_get_accuracy(clk->core);
+}
 EXPORT_SYMBOL_GPL(clk_get_accuracy);
 
-static unsigned long clk_recalc(struct clk *clk, unsigned long parent_rate)
+static unsigned long clk_recalc(struct clk_core *clk,
+				unsigned long parent_rate)
 {
 	if (clk->ops->recalc_rate)
 		return clk->ops->recalc_rate(clk->hw, parent_rate);
@@ -1099,11 +1178,11 @@ static unsigned long clk_recalc(struct clk *clk, unsigned long parent_rate)
  *
  * Caller must hold prepare_lock.
  */
-static void __clk_recalc_rates(struct clk *clk, unsigned long msg)
+static void __clk_recalc_rates(struct clk_core *clk, unsigned long msg)
 {
 	unsigned long old_rate;
 	unsigned long parent_rate = 0;
-	struct clk *child;
+	struct clk_core *child;
 
 	old_rate = clk->rate;
 
@@ -1123,15 +1202,7 @@ static void __clk_recalc_rates(struct clk *clk, unsigned long msg)
 		__clk_recalc_rates(child, msg);
 }
 
-/**
- * clk_get_rate - return the rate of clk
- * @clk: the clk whose rate is being returned
- *
- * Simply returns the cached rate of the clk, unless CLK_GET_RATE_NOCACHE flag
- * is set, which means a recalc_rate will be issued.
- * If clk is NULL then returns 0.
- */
-unsigned long clk_get_rate(struct clk *clk)
+static unsigned long clk_core_get_rate(struct clk_core *clk)
 {
 	unsigned long rate;
 
@@ -1140,14 +1211,29 @@ unsigned long clk_get_rate(struct clk *clk)
 	if (clk && (clk->flags & CLK_GET_RATE_NOCACHE))
 		__clk_recalc_rates(clk, 0);
 
-	rate = __clk_get_rate(clk);
+	rate = clk_core_get_rate_nolock(clk);
 	clk_prepare_unlock();
 
 	return rate;
 }
+EXPORT_SYMBOL_GPL(clk_core_get_rate);
+
+/**
+ * clk_get_rate - return the rate of clk
+ * @clk: the clk whose rate is being returned
+ *
+ * Simply returns the cached rate of the clk, unless CLK_GET_RATE_NOCACHE flag
+ * is set, which means a recalc_rate will be issued.
+ * If clk is NULL then returns 0.
+ */
+unsigned long clk_get_rate(struct clk *clk)
+{
+	return clk_core_get_rate(clk->core);
+}
 EXPORT_SYMBOL_GPL(clk_get_rate);
 
-static int clk_fetch_parent_index(struct clk *clk, struct clk *parent)
+static int clk_fetch_parent_index(struct clk_core *clk,
+				  struct clk_core *parent)
 {
 	int i;
 
@@ -1161,7 +1247,7 @@ static int clk_fetch_parent_index(struct clk *clk, struct clk *parent)
 	/*
 	 * find index of new parent clock using cached parent ptrs,
 	 * or if not yet cached, use string name comparison and cache
-	 * them now to avoid future calls to __clk_lookup.
+	 * them now to avoid future calls to clk_core_lookup.
 	 */
 	for (i = 0; i < clk->num_parents; i++) {
 		if (clk->parents[i] == parent)
@@ -1171,7 +1257,7 @@ static int clk_fetch_parent_index(struct clk *clk, struct clk *parent)
 			continue;
 
 		if (!strcmp(clk->parent_names[i], parent->name)) {
-			clk->parents[i] = __clk_lookup(parent->name);
+			clk->parents[i] = clk_core_lookup(parent->name);
 			return i;
 		}
 	}
@@ -1179,7 +1265,7 @@ static int clk_fetch_parent_index(struct clk *clk, struct clk *parent)
 	return -EINVAL;
 }
 
-static void clk_reparent(struct clk *clk, struct clk *new_parent)
+static void clk_reparent(struct clk_core *clk, struct clk_core *new_parent)
 {
 	hlist_del(&clk->child_node);
 
@@ -1196,10 +1282,11 @@ static void clk_reparent(struct clk *clk, struct clk *new_parent)
 	clk->parent = new_parent;
 }
 
-static struct clk *__clk_set_parent_before(struct clk *clk, struct clk *parent)
+static struct clk_core *__clk_set_parent_before(struct clk_core *clk,
+					   struct clk_core *parent)
 {
 	unsigned long flags;
-	struct clk *old_parent = clk->parent;
+	struct clk_core *old_parent = clk->parent;
 
 	/*
 	 * Migrate prepare state between parents and prevent race with
@@ -1219,9 +1306,9 @@ static struct clk *__clk_set_parent_before(struct clk *clk, struct clk *parent)
 	 * See also: Comment for clk_set_parent() below.
 	 */
 	if (clk->prepare_count) {
-		__clk_prepare(parent);
-		clk_enable(parent);
-		clk_enable(clk);
+		clk_core_prepare(parent);
+		clk_core_enable(parent);
+		clk_core_enable(clk);
 	}
 
 	/* update the clk tree topology */
@@ -1232,25 +1319,27 @@ static struct clk *__clk_set_parent_before(struct clk *clk, struct clk *parent)
 	return old_parent;
 }
 
-static void __clk_set_parent_after(struct clk *clk, struct clk *parent,
-		struct clk *old_parent)
+static void __clk_set_parent_after(struct clk_core *core,
+				   struct clk_core *parent,
+				   struct clk_core *old_parent)
 {
 	/*
 	 * Finish the migration of prepare state and undo the changes done
 	 * for preventing a race with clk_enable().
 	 */
-	if (clk->prepare_count) {
-		clk_disable(clk);
-		clk_disable(old_parent);
-		__clk_unprepare(old_parent);
+	if (core->prepare_count) {
+		clk_core_disable(core);
+		clk_core_disable(old_parent);
+		clk_core_unprepare(old_parent);
 	}
 }
 
-static int __clk_set_parent(struct clk *clk, struct clk *parent, u8 p_index)
+static int __clk_set_parent(struct clk_core *clk, struct clk_core *parent,
+			    u8 p_index)
 {
 	unsigned long flags;
 	int ret = 0;
-	struct clk *old_parent;
+	struct clk_core *old_parent;
 
 	old_parent = __clk_set_parent_before(clk, parent);
 
@@ -1264,9 +1353,9 @@ static int __clk_set_parent(struct clk *clk, struct clk *parent, u8 p_index)
 		clk_enable_unlock(flags);
 
 		if (clk->prepare_count) {
-			clk_disable(clk);
-			clk_disable(parent);
-			__clk_unprepare(parent);
+			clk_core_disable(clk);
+			clk_core_disable(parent);
+			clk_core_unprepare(parent);
 		}
 		return ret;
 	}
@@ -1292,9 +1381,10 @@ static int __clk_set_parent(struct clk *clk, struct clk *parent, u8 p_index)
  *
  * Caller must hold prepare_lock.
  */
-static int __clk_speculate_rates(struct clk *clk, unsigned long parent_rate)
+static int __clk_speculate_rates(struct clk_core *clk,
+				 unsigned long parent_rate)
 {
-	struct clk *child;
+	struct clk_core *child;
 	unsigned long new_rate;
 	int ret = NOTIFY_DONE;
 
@@ -1320,10 +1410,10 @@ out:
 	return ret;
 }
 
-static void clk_calc_subtree(struct clk *clk, unsigned long new_rate,
-			     struct clk *new_parent, u8 p_index)
+static void clk_calc_subtree(struct clk_core *clk, unsigned long new_rate,
+			     struct clk_core *new_parent, u8 p_index)
 {
-	struct clk *child;
+	struct clk_core *child;
 
 	clk->new_rate = new_rate;
 	clk->new_parent = new_parent;
@@ -1343,10 +1433,11 @@ static void clk_calc_subtree(struct clk *clk, unsigned long new_rate,
  * calculate the new rates returning the topmost clock that has to be
  * changed.
  */
-static struct clk *clk_calc_new_rates(struct clk *clk, unsigned long rate)
+static struct clk_core *clk_calc_new_rates(struct clk_core *clk,
+					   unsigned long rate)
 {
-	struct clk *top = clk;
-	struct clk *old_parent, *parent;
+	struct clk_core *top = clk;
+	struct clk_core *old_parent, *parent;
 	struct clk_hw *parent_hw;
 	unsigned long best_parent_rate = 0;
 	unsigned long new_rate;
@@ -1367,7 +1458,7 @@ static struct clk *clk_calc_new_rates(struct clk *clk, unsigned long rate)
 		new_rate = clk->ops->determine_rate(clk->hw, rate,
 						    &best_parent_rate,
 						    &parent_hw);
-		parent = parent_hw->clk;
+		parent = parent_hw ? parent_hw->core : NULL;
 	} else if (clk->ops->round_rate) {
 		new_rate = clk->ops->round_rate(clk->hw, rate,
 						&best_parent_rate);
@@ -1415,9 +1506,10 @@ out:
  * so that in case of an error we can walk down the whole tree again and
  * abort the change.
  */
-static struct clk *clk_propagate_rate_change(struct clk *clk, unsigned long event)
+static struct clk_core *clk_propagate_rate_change(struct clk_core *clk,
+						  unsigned long event)
 {
-	struct clk *child, *tmp_clk, *fail_clk = NULL;
+	struct clk_core *child, *tmp_clk, *fail_clk = NULL;
 	int ret = NOTIFY_DONE;
 
 	if (clk->rate == clk->new_rate)
@@ -1452,14 +1544,14 @@ static struct clk *clk_propagate_rate_change(struct clk *clk, unsigned long even
  * walk down a subtree and set the new rates notifying the rate
  * change on the way
  */
-static void clk_change_rate(struct clk *clk)
+static void clk_change_rate(struct clk_core *clk)
 {
-	struct clk *child;
+	struct clk_core *child;
 	struct hlist_node *tmp;
 	unsigned long old_rate;
 	unsigned long best_parent_rate = 0;
 	bool skip_set_rate = false;
-	struct clk *old_parent;
+	struct clk_core *old_parent;
 
 	old_rate = clk->rate;
 
@@ -1530,7 +1622,7 @@ static void clk_change_rate(struct clk *clk)
  */
 int clk_set_rate(struct clk *clk, unsigned long rate)
 {
-	struct clk *top, *fail_clk;
+	struct clk_core *top, *fail_clk;
 	int ret = 0;
 
 	if (!clk)
@@ -1543,13 +1635,14 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 	if (rate == clk_get_rate(clk))
 		goto out;
 
-	if ((clk->flags & CLK_SET_RATE_GATE) && clk->prepare_count) {
+	if ((clk->core->flags & CLK_SET_RATE_GATE) &&
+	    clk->core->prepare_count) {
 		ret = -EBUSY;
 		goto out;
 	}
 
 	/* calculate new rates and get the topmost changed clock */
-	top = clk_calc_new_rates(clk, rate);
+	top = clk_calc_new_rates(clk->core, rate);
 	if (!top) {
 		ret = -EINVAL;
 		goto out;
@@ -1575,6 +1668,18 @@ out:
 }
 EXPORT_SYMBOL_GPL(clk_set_rate);
 
+static struct clk_core *clk_core_get_parent(struct clk_core *core)
+{
+	struct clk_core *parent;
+
+	clk_prepare_lock();
+	parent = !core ? NULL : core->parent;
+	clk_prepare_unlock();
+
+	return parent;
+}
+EXPORT_SYMBOL_GPL(clk_core_get_parent);
+
 /**
  * clk_get_parent - return the parent of a clk
  * @clk: the clk whose parent gets returned
@@ -1583,13 +1688,11 @@ EXPORT_SYMBOL_GPL(clk_set_rate);
  */
 struct clk *clk_get_parent(struct clk *clk)
 {
-	struct clk *parent;
+	struct clk_core *parent;
 
-	clk_prepare_lock();
-	parent = __clk_get_parent(clk);
-	clk_prepare_unlock();
+	parent = clk_core_get_parent(clk->core);
 
-	return parent;
+	return !parent ? NULL : parent->hw->clk;
 }
 EXPORT_SYMBOL_GPL(clk_get_parent);
 
@@ -1600,11 +1703,11 @@ EXPORT_SYMBOL_GPL(clk_get_parent);
  *
  * For single-parent clocks without .get_parent, first check to see if the
  * .parents array exists, and if so use it to avoid an expensive tree
- * traversal.  If .parents does not exist then walk the tree with __clk_lookup.
+ * traversal.  If .parents does not exist then walk the tree.
  */
-static struct clk *__clk_init_parent(struct clk *clk)
+static struct clk_core *__clk_init_parent(struct clk_core *clk)
 {
-	struct clk *ret = NULL;
+	struct clk_core *ret = NULL;
 	u8 index;
 
 	/* handle the trivial cases */
@@ -1614,7 +1717,7 @@ static struct clk *__clk_init_parent(struct clk *clk)
 
 	if (clk->num_parents == 1) {
 		if (IS_ERR_OR_NULL(clk->parent))
-			clk->parent = __clk_lookup(clk->parent_names[0]);
+			clk->parent = clk_core_lookup(clk->parent_names[0]);
 		ret = clk->parent;
 		goto out;
 	}
@@ -1628,8 +1731,8 @@ static struct clk *__clk_init_parent(struct clk *clk)
 
 	/*
 	 * Do our best to cache parent clocks in clk->parents.  This prevents
-	 * unnecessary and expensive calls to __clk_lookup.  We don't set
-	 * clk->parent here; that is done by the calling function
+	 * unnecessary and expensive lookups.  We don't set clk->parent here;
+	 * that is done by the calling function.
 	 */
 
 	index = clk->ops->get_parent(clk->hw);
@@ -1639,37 +1742,26 @@ static struct clk *__clk_init_parent(struct clk *clk)
 			kcalloc(clk->num_parents, sizeof(struct clk *),
 					GFP_KERNEL);
 
-	ret = clk_get_parent_by_index(clk, index);
+	ret = clk_core_get_parent_by_index(clk, index);
 
 out:
 	return ret;
 }
 
-void __clk_reparent(struct clk *clk, struct clk *new_parent)
+static void clk_core_reparent(struct clk_core *clk,
+				  struct clk_core *new_parent)
 {
 	clk_reparent(clk, new_parent);
 	__clk_recalc_accuracies(clk);
 	__clk_recalc_rates(clk, POST_RATE_CHANGE);
 }
 
-/**
- * clk_set_parent - switch the parent of a mux clk
- * @clk: the mux clk whose input we are switching
- * @parent: the new input to clk
- *
- * Re-parent clk to use parent as its new input source.  If clk is in
- * prepared state, the clk will get enabled for the duration of this call. If
- * that's not acceptable for a specific clk (Eg: the consumer can't handle
- * that, the reparenting is glitchy in hardware, etc), use the
- * CLK_SET_PARENT_GATE flag to allow reparenting only when clk is unprepared.
- *
- * After successfully changing clk's parent clk_set_parent will update the
- * clk topology, sysfs topology and propagate rate recalculation via
- * __clk_recalc_rates.
- *
- * Returns 0 on success, -EERROR otherwise.
- */
-int clk_set_parent(struct clk *clk, struct clk *parent)
+void __clk_reparent(struct clk *clk, struct clk *new_parent)
+{
+	clk_core_reparent(clk->core, new_parent->core);
+}
+
+static int clk_core_set_parent(struct clk_core *clk, struct clk_core *parent)
 {
 	int ret = 0;
 	int p_index = 0;
@@ -1729,6 +1821,28 @@ out:
 
 	return ret;
 }
+
+/**
+ * clk_set_parent - switch the parent of a mux clk
+ * @clk: the mux clk whose input we are switching
+ * @parent: the new input to clk
+ *
+ * Re-parent clk to use parent as its new input source.  If clk is in
+ * prepared state, the clk will get enabled for the duration of this call. If
+ * that's not acceptable for a specific clk (Eg: the consumer can't handle
+ * that, the reparenting is glitchy in hardware, etc), use the
+ * CLK_SET_PARENT_GATE flag to allow reparenting only when clk is unprepared.
+ *
+ * After successfully changing clk's parent clk_set_parent will update the
+ * clk topology, sysfs topology and propagate rate recalculation via
+ * __clk_recalc_rates.
+ *
+ * Returns 0 on success, -EERROR otherwise.
+ */
+int clk_set_parent(struct clk *clk, struct clk *parent)
+{
+	return clk_core_set_parent(clk->core, parent->core);
+}
 EXPORT_SYMBOL_GPL(clk_set_parent);
 
 /**
@@ -1765,13 +1879,13 @@ int clk_set_phase(struct clk *clk, int degrees)
 
 	clk_prepare_lock();
 
-	if (!clk->ops->set_phase)
+	if (!clk->core->ops->set_phase)
 		goto out_unlock;
 
-	ret = clk->ops->set_phase(clk->hw, degrees);
+	ret = clk->core->ops->set_phase(clk->core->hw, degrees);
 
 	if (!ret)
-		clk->phase = degrees;
+		clk->core->phase = degrees;
 
 out_unlock:
 	clk_prepare_unlock();
@@ -1780,14 +1894,7 @@ out:
 	return ret;
 }
 
-/**
- * clk_get_phase - return the phase shift of a clock signal
- * @clk: clock signal source
- *
- * Returns the phase shift of a clock node in degrees, otherwise returns
- * -EERROR.
- */
-int clk_get_phase(struct clk *clk)
+static int clk_core_get_phase(struct clk_core *clk)
 {
 	int ret = 0;
 
@@ -1803,18 +1910,31 @@ out:
 }
 
 /**
+ * clk_get_phase - return the phase shift of a clock signal
+ * @clk: clock signal source
+ *
+ * Returns the phase shift of a clock node in degrees, otherwise returns
+ * -EERROR.
+ */
+int clk_get_phase(struct clk *clk)
+{
+	return clk_core_get_phase(clk->core);
+}
+
+/**
  * __clk_init - initialize the data structures in a struct clk
  * @dev:	device initializing this clk, placeholder for now
  * @clk:	clk being initialized
  *
- * Initializes the lists in struct clk, queries the hardware for the
+ * Initializes the lists in struct clk_core, queries the hardware for the
  * parent and rate and sets them both.
  */
-int __clk_init(struct device *dev, struct clk *clk)
+int __clk_init(struct device *dev, struct clk *clk_user)
 {
 	int i, ret = 0;
-	struct clk *orphan;
+	struct clk_core *orphan;
 	struct hlist_node *tmp2;
+	struct clk_core *clk = clk_user->core;
 
 	if (!clk)
 		return -EINVAL;
@@ -1822,7 +1942,7 @@ int __clk_init(struct device *dev, struct clk *clk)
 	clk_prepare_lock();
 
 	/* check to see if a clock with this name is already registered */
-	if (__clk_lookup(clk->name)) {
+	if (clk_core_lookup(clk->name)) {
 		pr_debug("%s: clk %s already initialized\n",
 				__func__, clk->name);
 		ret = -EEXIST;
@@ -1874,7 +1994,7 @@ int __clk_init(struct device *dev, struct clk *clk)
 		clk->parents = kcalloc(clk->num_parents, sizeof(struct clk *),
 					GFP_KERNEL);
 		/*
-		 * __clk_lookup returns NULL for parents that have not been
+		 * clk_core_lookup returns NULL for parents that have not been
 		 * clk_init'd; thus any access to clk->parents[] must check
 		 * for a NULL pointer.  We can always perform lazy lookups for
 		 * missing parents later on.
@@ -1882,7 +2002,7 @@ int __clk_init(struct device *dev, struct clk *clk)
 		if (clk->parents)
 			for (i = 0; i < clk->num_parents; i++)
 				clk->parents[i] =
-					__clk_lookup(clk->parent_names[i]);
+					clk_core_lookup(clk->parent_names[i]);
 	}
 
 	clk->parent = __clk_init_parent(clk);
@@ -1938,7 +2058,7 @@ int __clk_init(struct device *dev, struct clk *clk)
 	 */
 	if (clk->ops->recalc_rate)
 		clk->rate = clk->ops->recalc_rate(clk->hw,
-				__clk_get_rate(clk->parent));
+				clk_core_get_rate_nolock(clk->parent));
 	else if (clk->parent)
 		clk->rate = clk->parent->rate;
 	else
@@ -1953,13 +2073,13 @@ int __clk_init(struct device *dev, struct clk *clk)
 		if (orphan->num_parents && orphan->ops->get_parent) {
 			i = orphan->ops->get_parent(orphan->hw);
 			if (!strcmp(clk->name, orphan->parent_names[i]))
-				__clk_reparent(orphan, clk);
+				clk_core_reparent(orphan, clk);
 			continue;
 		}
 
 		for (i = 0; i < orphan->num_parents; i++)
 			if (!strcmp(clk->name, orphan->parent_names[i])) {
-				__clk_reparent(orphan, clk);
+				clk_core_reparent(orphan, clk);
 				break;
 			}
 	 }
@@ -1985,12 +2105,13 @@ out:
 /**
  * __clk_register - register a clock and return a cookie.
  *
- * Same as clk_register, except that the .clk field inside hw shall point to a
- * preallocated (generally statically allocated) struct clk. None of the fields
- * of the struct clk need to be initialized.
+ * Same as clk_register, except that the .core and .clk fields inside hw shall
+ * point to preallocated (generally statically allocated) struct clk_core, and
+ * struct clk (respectively). None of the fields of the struct clk_core need
+ * to be initialized.
  *
- * The data pointed to by .init and .clk field shall NOT be marked as init
- * data.
+ * The data pointed to by .init, .core and .clk field shall NOT be marked as
+ * init data.
  *
  * __clk_register is only exposed via clk-private.h and is intended for use with
  * very large numbers of clocks that need to be statically initialized.  It is
@@ -2002,9 +2123,9 @@ out:
 struct clk *__clk_register(struct device *dev, struct clk_hw *hw)
 {
 	int ret;
-	struct clk *clk;
+	struct clk_core *clk;
 
-	clk = hw->clk;
+	clk = hw->core;
 	clk->name = hw->init->name;
 	clk->ops = hw->init->ops;
 	clk->hw = hw;
@@ -2016,11 +2137,11 @@ struct clk *__clk_register(struct device *dev, struct clk_hw *hw)
 	else
 		clk->owner = NULL;
 
-	ret = __clk_init(dev, clk);
+	ret = __clk_init(dev, hw->clk);
 	if (ret)
 		return ERR_PTR(ret);
 
-	return clk;
+	return hw->clk;
 }
 EXPORT_SYMBOL_GPL(__clk_register);
 
@@ -2038,7 +2159,7 @@ EXPORT_SYMBOL_GPL(__clk_register);
 struct clk *clk_register(struct device *dev, struct clk_hw *hw)
 {
 	int i, ret;
-	struct clk *clk;
+	struct clk_core *clk;
 
 	clk = kzalloc(sizeof(*clk), GFP_KERNEL);
 	if (!clk) {
@@ -2059,7 +2180,7 @@ struct clk *clk_register(struct device *dev, struct clk_hw *hw)
 	clk->hw = hw;
 	clk->flags = hw->init->flags;
 	clk->num_parents = hw->init->num_parents;
-	hw->clk = clk;
+	hw->core = clk;
 
 	/* allocate local copy in case parent_names is __initdata */
 	clk->parent_names = kcalloc(clk->num_parents, sizeof(char *),
@@ -2083,10 +2204,12 @@ struct clk *clk_register(struct device *dev, struct clk_hw *hw)
 		}
 	}
 
-	ret = __clk_init(dev, clk);
+	hw->clk = __clk_create_clk(hw, NULL, NULL);
+	ret = __clk_init(dev, hw->clk);
 	if (!ret)
-		return clk;
+		return hw->clk;
 
+	kfree(hw->clk);
 fail_parent_names_copy:
 	while (--i >= 0)
 		kfree(clk->parent_names[i]);
@@ -2106,7 +2229,7 @@ EXPORT_SYMBOL_GPL(clk_register);
  */
 static void __clk_release(struct kref *ref)
 {
-	struct clk *clk = container_of(ref, struct clk, ref);
+	struct clk_core *clk = container_of(ref, struct clk_core, ref);
 	int i = clk->num_parents;
 
 	kfree(clk->parents);
@@ -2164,12 +2287,12 @@ void clk_unregister(struct clk *clk)
 	if (!clk || WARN_ON_ONCE(IS_ERR(clk)))
 		return;
 
-	clk_debug_unregister(clk);
+	clk_debug_unregister(clk->core);
 
 	clk_prepare_lock();
 
-	if (clk->ops == &clk_nodrv_ops) {
-		pr_err("%s: unregistered clock: %s\n", __func__, clk->name);
+	if (clk->core->ops == &clk_nodrv_ops) {
+		pr_err("%s: unregistered clock: %s\n", __func__, clk->core->name);
 		return;
 	}
 	/*
@@ -2177,24 +2300,24 @@ void clk_unregister(struct clk *clk)
 	 * a reference to this clock.
 	 */
 	flags = clk_enable_lock();
-	clk->ops = &clk_nodrv_ops;
+	clk->core->ops = &clk_nodrv_ops;
 	clk_enable_unlock(flags);
 
-	if (!hlist_empty(&clk->children)) {
-		struct clk *child;
+	if (!hlist_empty(&clk->core->children)) {
+		struct clk_core *child;
 		struct hlist_node *t;
 
 		/* Reparent all children to the orphan list. */
-		hlist_for_each_entry_safe(child, t, &clk->children, child_node)
-			clk_set_parent(child, NULL);
+		hlist_for_each_entry_safe(child, t, &clk->core->children, child_node)
+			clk_core_set_parent(child, NULL);
 	}
 
-	hlist_del_init(&clk->child_node);
+	hlist_del_init(&clk->core->child_node);
 
-	if (clk->prepare_count)
+	if (clk->core->prepare_count)
 		pr_warn("%s: unregistering prepared clock: %s\n",
-					__func__, clk->name);
-	kref_put(&clk->ref, __clk_release);
+					__func__, clk->core->name);
+	kref_put(&clk->core->ref, __clk_release);
 
 	clk_prepare_unlock();
 }
@@ -2257,33 +2380,42 @@ void devm_clk_unregister(struct device *dev, struct clk *clk)
 }
 EXPORT_SYMBOL_GPL(devm_clk_unregister);
 
+static void clk_core_put(struct clk_core *core)
+{
+	struct module *owner;
+
+	if (!core || WARN_ON_ONCE(IS_ERR(core)))
+		return;
+
+	owner = core->owner;
+
+	clk_prepare_lock();
+	kref_put(&core->ref, __clk_release);
+	clk_prepare_unlock();
+
+	module_put(owner);
+}
+
 /*
  * clkdev helpers
  */
 int __clk_get(struct clk *clk)
 {
-	if (clk) {
-		if (!try_module_get(clk->owner))
+	struct clk_core *core = !clk ? NULL : clk->core;
+
+	if (core) {
+		if (!try_module_get(core->owner))
 			return 0;
 
-		kref_get(&clk->ref);
+		kref_get(&core->ref);
 	}
 	return 1;
 }
 
 void __clk_put(struct clk *clk)
 {
-	struct module *owner;
-
-	if (!clk || WARN_ON_ONCE(IS_ERR(clk)))
-		return;
-
-	clk_prepare_lock();
-	owner = clk->owner;
-	kref_put(&clk->ref, __clk_release);
-	clk_prepare_unlock();
-
-	module_put(owner);
+	clk_core_put(clk->core);
+	kfree(clk);
 }
 
 /***        clk rate change notifiers        ***/
@@ -2338,7 +2470,7 @@ int clk_notifier_register(struct clk *clk, struct notifier_block *nb)
 
 	ret = srcu_notifier_chain_register(&cn->notifier_head, nb);
 
-	clk->notifier_count++;
+	clk->core->notifier_count++;
 
 out:
 	clk_prepare_unlock();
@@ -2375,7 +2507,7 @@ int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb)
 	if (cn->clk == clk) {
 		ret = srcu_notifier_chain_unregister(&cn->notifier_head, nb);
 
-		clk->notifier_count--;
+		clk->core->notifier_count--;
 
 		/* XXX the notifier code should handle this better */
 		if (!cn->notifier_head.head) {
@@ -2394,6 +2526,26 @@ int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb)
 }
 EXPORT_SYMBOL_GPL(clk_notifier_unregister);
 
+struct clk *__clk_create_clk(struct clk_hw *hw, const char *dev_id,
+			     const char *con_id)
+{
+	struct clk *clk;
+
+	/* This is to allow this function to be chained to others */
+	if (!hw || IS_ERR(hw))
+		return (struct clk *) hw;
+
+	clk = kzalloc(sizeof(*clk), GFP_KERNEL);
+	if (!clk)
+		return ERR_PTR(-ENOMEM);
+
+	clk->core = hw->core;
+	clk->dev_id = dev_id;
+	clk->con_id = con_id;
+
+	return clk;
+}
+
 #ifdef CONFIG_OF
 /**
  * struct of_clk_provider - Clock provider registration structure
diff --git a/drivers/clk/clk.h b/drivers/clk/clk.h
index c798138..23c44e5 100644
--- a/drivers/clk/clk.h
+++ b/drivers/clk/clk.h
@@ -9,9 +9,14 @@
  * published by the Free Software Foundation.
  */
 
+struct clk_hw;
+
 #if defined(CONFIG_OF) && defined(CONFIG_COMMON_CLK)
 struct clk *of_clk_get_by_clkspec(struct of_phandle_args *clkspec);
 struct clk *__of_clk_get_from_provider(struct of_phandle_args *clkspec);
 void of_clk_lock(void);
 void of_clk_unlock(void);
 #endif
+
+struct clk *__clk_create_clk(struct clk_hw *hw, const char *dev_id,
+			     const char *con_id);
diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index da4bda8..fac3244 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -19,6 +19,7 @@
 #include <linux/mutex.h>
 #include <linux/clk.h>
 #include <linux/clkdev.h>
+#include <linux/clk-provider.h>
 #include <linux/of.h>
 
 #include "clk.h"
@@ -53,7 +54,7 @@ struct clk *of_clk_get_by_clkspec(struct of_phandle_args *clkspec)
 	return clk;
 }
 
-struct clk *of_clk_get(struct device_node *np, int index)
+static struct clk *__of_clk_get(struct device_node *np, int index)
 {
 	struct of_phandle_args clkspec;
 	struct clk *clk;
@@ -69,20 +70,22 @@ struct clk *of_clk_get(struct device_node *np, int index)
 
 	clk = of_clk_get_by_clkspec(&clkspec);
 	of_node_put(clkspec.np);
+
+	return clk;
+}
+
+struct clk *of_clk_get(struct device_node *np, int index)
+{
+	struct clk *clk = __of_clk_get(np, index);
+
+	if (!IS_ERR(clk))
+		clk = __clk_create_clk(__clk_get_hw(clk), np->full_name, NULL);
+
 	return clk;
 }
 EXPORT_SYMBOL(of_clk_get);
 
-/**
- * of_clk_get_by_name() - Parse and lookup a clock referenced by a device node
- * @np: pointer to clock consumer node
- * @name: name of consumer's clock input, or NULL for the first clock reference
- *
- * This function parses the clocks and clock-names properties,
- * and uses them to look up the struct clk from the registered list of clock
- * providers.
- */
-struct clk *of_clk_get_by_name(struct device_node *np, const char *name)
+static struct clk *__of_clk_get_by_name(struct device_node *np, const char *name)
 {
 	struct clk *clk = ERR_PTR(-ENOENT);
 
@@ -97,7 +100,7 @@ struct clk *of_clk_get_by_name(struct device_node *np, const char *name)
 		 */
 		if (name)
 			index = of_property_match_string(np, "clock-names", name);
-		clk = of_clk_get(np, index);
+		clk = __of_clk_get(np, index);
 		if (!IS_ERR(clk))
 			break;
 		else if (name && index >= 0) {
@@ -119,7 +122,33 @@ struct clk *of_clk_get_by_name(struct device_node *np, const char *name)
 
 	return clk;
 }
+
+/**
+ * of_clk_get_by_name() - Parse and lookup a clock referenced by a device node
+ * @np: pointer to clock consumer node
+ * @name: name of consumer's clock input, or NULL for the first clock reference
+ *
+ * This function parses the clocks and clock-names properties,
+ * and uses them to look up the struct clk from the registered list of clock
+ * providers.
+ */
+struct clk *of_clk_get_by_name(struct device_node *np, const char *name)
+{
+	struct clk *clk = __of_clk_get_by_name(np, name);
+
+	if (!IS_ERR(clk))
+		clk = __clk_create_clk(__clk_get_hw(clk), np->full_name, name);
+
+	return clk;
+}
 EXPORT_SYMBOL(of_clk_get_by_name);
+
+#else /* defined(CONFIG_OF) && defined(CONFIG_COMMON_CLK) */
+
+static struct clk *__of_clk_get_by_name(struct device_node *np, const char *name)
+{
+	return ERR_PTR(-ENOENT);
+}
 #endif
 
 /*
@@ -168,14 +197,29 @@ static struct clk_lookup *clk_find(const char *dev_id, const char *con_id)
 struct clk *clk_get_sys(const char *dev_id, const char *con_id)
 {
 	struct clk_lookup *cl;
+	struct clk *clk = NULL;
 
 	mutex_lock(&clocks_mutex);
+
 	cl = clk_find(dev_id, con_id);
-	if (cl && !__clk_get(cl->clk))
+	if (!cl)
+		goto out;
+
+	if (!__clk_get(cl->clk)) {
 		cl = NULL;
+		goto out;
+	}
+
+#if defined(CONFIG_COMMON_CLK)
+	clk = __clk_create_clk(__clk_get_hw(cl->clk), dev_id, con_id);
+#else
+	clk = cl->clk;
+#endif
+
+out:
 	mutex_unlock(&clocks_mutex);
 
-	return cl ? cl->clk : ERR_PTR(-ENOENT);
+	return cl ? clk : ERR_PTR(-ENOENT);
 }
 EXPORT_SYMBOL(clk_get_sys);
 
@@ -185,9 +229,13 @@ struct clk *clk_get(struct device *dev, const char *con_id)
 	struct clk *clk;
 
 	if (dev) {
-		clk = of_clk_get_by_name(dev->of_node, con_id);
-		if (!IS_ERR(clk))
+		clk = __of_clk_get_by_name(dev->of_node, con_id);
+		if (!IS_ERR(clk)) {
+#if defined(CONFIG_COMMON_CLK)
+			clk = __clk_create_clk(__clk_get_hw(clk), dev_id, con_id);
+#endif
 			return clk;
+		}
 		if (PTR_ERR(clk) == -EPROBE_DEFER)
 			return clk;
 	}
diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
index 0ca5f60..1cdb727 100644
--- a/include/linux/clk-private.h
+++ b/include/linux/clk-private.h
@@ -28,20 +28,20 @@
 
 struct module;
 
-struct clk {
+struct clk_core {
 	const char		*name;
 	const struct clk_ops	*ops;
 	struct clk_hw		*hw;
 	struct module		*owner;
-	struct clk		*parent;
+	struct clk_core		*parent;
 	const char		**parent_names;
-	struct clk		**parents;
+	struct clk_core		**parents;
 	u8			num_parents;
 	u8			new_parent_index;
 	unsigned long		rate;
 	unsigned long		new_rate;
-	struct clk		*new_parent;
-	struct clk		*new_child;
+	struct clk_core		*new_parent;
+	struct clk_core		*new_child;
 	unsigned long		flags;
 	unsigned int		enable_count;
 	unsigned int		prepare_count;
@@ -57,6 +57,12 @@ struct clk {
 	struct kref		ref;
 };
 
+struct clk {
+	struct clk_core	*core;
+	const char *dev_id;
+	const char *con_id;
+};
+
 /*
  * DOC: Basic clock implementations common to many platforms
  *
@@ -69,6 +75,9 @@ struct clk {
 #define DEFINE_CLK(_name, _ops, _flags, _parent_names,		\
 		_parents)					\
 	static struct clk _name = {				\
+		.core = &_name##_core				\
+	};							\
+	static struct clk_core _name##_core = {			\
 		.name = #_name,					\
 		.ops = &_ops,					\
 		.hw = &_name##_hw.hw,				\
@@ -81,9 +90,11 @@ struct clk {
 #define DEFINE_CLK_FIXED_RATE(_name, _flags, _rate,		\
 				_fixed_rate_flags)		\
 	static struct clk _name;				\
+	static struct clk_core _name##_core;			\
 	static const char *_name##_parent_names[] = {};		\
 	static struct clk_fixed_rate _name##_hw = {		\
 		.hw = {						\
+			.core = &_name##_core,			\
 			.clk = &_name,				\
 		},						\
 		.fixed_rate = _rate,				\
@@ -96,14 +107,16 @@ struct clk {
 				_flags, _reg, _bit_idx,		\
 				_gate_flags, _lock)		\
 	static struct clk _name;				\
+	static struct clk_core _name##_core;			\
 	static const char *_name##_parent_names[] = {		\
 		_parent_name,					\
 	};							\
-	static struct clk *_name##_parents[] = {		\
+	static struct clk_core *_name##_parents[] = {		\
 		_parent_ptr,					\
 	};							\
 	static struct clk_gate _name##_hw = {			\
 		.hw = {						\
+			.core = &_name##_core,			\
 			.clk = &_name,				\
 		},						\
 		.reg = _reg,					\
@@ -118,14 +131,16 @@ struct clk {
 				_flags, _reg, _shift, _width,	\
 				_divider_flags, _table, _lock)	\
 	static struct clk _name;				\
+	static struct clk_core _name##_core;			\
 	static const char *_name##_parent_names[] = {		\
 		_parent_name,					\
 	};							\
-	static struct clk *_name##_parents[] = {		\
+	static struct clk_core *_name##_parents[] = {		\
 		_parent_ptr,					\
 	};							\
 	static struct clk_divider _name##_hw = {		\
 		.hw = {						\
+			.core = &_name##_core,			\
 			.clk = &_name,				\
 		},						\
 		.reg = _reg,					\
@@ -157,8 +172,10 @@ struct clk {
 				_reg, _shift, _width,		\
 				_mux_flags, _lock)		\
 	static struct clk _name;				\
+	static struct clk_core _name##_core;			\
 	static struct clk_mux _name##_hw = {			\
 		.hw = {						\
+			.core = &_name##_core,			\
 			.clk = &_name,				\
 		},						\
 		.reg = _reg,					\
@@ -174,14 +191,16 @@ struct clk {
 				_parent_ptr, _flags,		\
 				_mult, _div)			\
 	static struct clk _name;				\
+	static struct clk_core _name##_core;			\
 	static const char *_name##_parent_names[] = {		\
 		_parent_name,					\
 	};							\
-	static struct clk *_name##_parents[] = {		\
+	static struct clk_core *_name##_parents[] = {		\
 		_parent_ptr,					\
 	};							\
 	static struct clk_fixed_factor _name##_hw = {		\
 		.hw = {						\
+			.core = &_name##_core,			\
 			.clk = &_name,				\
 		},						\
 		.mult = _mult,					\
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index d936409..2e65419 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -33,6 +33,7 @@
 #define CLK_GET_ACCURACY_NOCACHE BIT(8) /* do not use the cached clk accuracy */
 
 struct clk_hw;
+struct clk_core;
 struct dentry;
 
 /**
@@ -216,13 +217,17 @@ struct clk_init_data {
  * clk_foo and then referenced by the struct clk instance that uses struct
  * clk_foo's clk_ops
  *
- * @clk: pointer to the struct clk instance that points back to this struct
- * clk_hw instance
+ * @core: pointer to the struct clk_core instance that points back to this
+ * struct clk_hw instance
+ *
+ * @clk: pointer to the per-user struct clk instance that can be used to call
+ * into the clk API
  *
  * @init: pointer to struct clk_init_data that contains the init data shared
  * with the common clock framework.
  */
 struct clk_hw {
+	struct clk_core *core;
 	struct clk *clk;
 	const struct clk_init_data *init;
 };
-- 
1.9.3

