Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab3AVQoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 11:44:44 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:53605 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754963Ab3AVQoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 11:44:39 -0500
From: Afzal Mohammed <afzal@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 4/4] ARM: AM33XX: clock: SET_RATE_PARENT in lcd path
Date: Tue, 22 Jan 2013 22:14:29 +0530
Message-ID: <24c9e4241b2988e66abd053508991d96cac964b7.1358871018.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <cover.1358871018.git.afzal@ti.com>
References: <cover.1358871018.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LCDC clock node is a one that does not have set rate capability. It
just passes on the rate that is sent downstream by it's parent. While
lcdc clock parent and it's grand parent - dpll_disp_m2_ck and
dpll_disp_ck has the capability to configure rate.

And the default rates provided by LCDC clock's ancestors are not
sufficient to obtain pixel clock for current LCDC use cases, hence
currently display would not work on AM335x SoC's (with driver
modifications in platfrom independent way).

Hence inform clock framework to propogate set rate for LCDC clock as
well as it's parent - dpll_disp_m2_ck. With this change, set rate on
LCDC clock would get propogated till dpll_disp_ck via dpll_disp_m2_ck,
hence allowing the driver (same driver is used in DaVinci too) to set
rates using LCDC clock without worrying about platform dependent clock
details.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 arch/arm/mach-omap2/cclock33xx_data.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap2/cclock33xx_data.c b/arch/arm/mach-omap2/cclock33xx_data.c
index 8f7c60d..0519e91 100644
--- a/arch/arm/mach-omap2/cclock33xx_data.c
+++ b/arch/arm/mach-omap2/cclock33xx_data.c
@@ -286,10 +286,10 @@ DEFINE_STRUCT_CLK(dpll_disp_ck, dpll_core_ck_parents, dpll_ddr_ck_ops);
  * TODO: Add clksel here (sys_clkin, CORE_CLKOUTM6, PER_CLKOUTM2
  * and ALT_CLK1/2)
  */
-DEFINE_CLK_DIVIDER(dpll_disp_m2_ck, "dpll_disp_ck", &dpll_disp_ck, 0x0,
-		   AM33XX_CM_DIV_M2_DPLL_DISP, AM33XX_DPLL_CLKOUT_DIV_SHIFT,
-		   AM33XX_DPLL_CLKOUT_DIV_WIDTH, CLK_DIVIDER_MIN_DIV_DEFAULT,
-		   CLK_DIVIDER_ONE_BASED, NULL);
+DEFINE_CLK_DIVIDER(dpll_disp_m2_ck, "dpll_disp_ck", &dpll_disp_ck,
+		   CLK_SET_RATE_PARENT, AM33XX_CM_DIV_M2_DPLL_DISP,
+		   AM33XX_DPLL_CLKOUT_DIV_SHIFT, AM33XX_DPLL_CLKOUT_DIV_WIDTH,
+		   CLK_DIVIDER_MIN_DIV_DEFAULT, CLK_DIVIDER_ONE_BASED, NULL);
 
 /* DPLL_PER */
 static struct dpll_data dpll_per_dd = {
@@ -726,7 +726,8 @@ static struct clk_hw_omap lcd_gclk_hw = {
 	.clksel_mask	= AM33XX_CLKSEL_0_1_MASK,
 };
 
-DEFINE_STRUCT_CLK(lcd_gclk, lcd_ck_parents, gpio_fck_ops);
+DEFINE_STRUCT_CLK_FLAGS(lcd_gclk, lcd_ck_parents,
+			gpio_fck_ops, CLK_SET_RATE_PARENT);
 
 DEFINE_CLK_FIXED_FACTOR(mmc_clk, "dpll_per_m2_ck", &dpll_per_m2_ck, 0x0, 1, 2);
 
-- 
1.7.12

