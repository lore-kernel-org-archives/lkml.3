Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab3AWLm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 06:42:27 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:49135 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755587Ab3AWLmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 06:42:25 -0500
From: Afzal Mohammed <afzal@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v2 4/4] ARM: AM33XX: clock: SET_RATE_PARENT in lcd path
Date: Wed, 23 Jan 2013 17:12:11 +0530
Message-ID: <902fb9aeaf11dab8c94af7645d9270612a5ab77f.1358937533.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <cover.1358937533.git.afzal@ti.com>
References: <cover.1358937533.git.afzal@ti.com>
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

v2: As DEFINE_CLK_DIVIDER args has no change, make it's usage as reqd.

 arch/arm/mach-omap2/cclock33xx_data.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-omap2/cclock33xx_data.c b/arch/arm/mach-omap2/cclock33xx_data.c
index ea64ad6..476b820 100644
--- a/arch/arm/mach-omap2/cclock33xx_data.c
+++ b/arch/arm/mach-omap2/cclock33xx_data.c
@@ -284,9 +284,10 @@ DEFINE_STRUCT_CLK(dpll_disp_ck, dpll_core_ck_parents, dpll_ddr_ck_ops);
  * TODO: Add clksel here (sys_clkin, CORE_CLKOUTM6, PER_CLKOUTM2
  * and ALT_CLK1/2)
  */
-DEFINE_CLK_DIVIDER(dpll_disp_m2_ck, "dpll_disp_ck", &dpll_disp_ck, 0x0,
-		   AM33XX_CM_DIV_M2_DPLL_DISP, AM33XX_DPLL_CLKOUT_DIV_SHIFT,
-		   AM33XX_DPLL_CLKOUT_DIV_WIDTH, CLK_DIVIDER_ONE_BASED, NULL);
+DEFINE_CLK_DIVIDER(dpll_disp_m2_ck, "dpll_disp_ck", &dpll_disp_ck,
+		   CLK_SET_RATE_PARENT, AM33XX_CM_DIV_M2_DPLL_DISP,
+		   AM33XX_DPLL_CLKOUT_DIV_SHIFT, AM33XX_DPLL_CLKOUT_DIV_WIDTH,
+		   CLK_DIVIDER_ONE_BASED, NULL);
 
 /* DPLL_PER */
 static struct dpll_data dpll_per_dd = {
@@ -723,7 +724,8 @@ static struct clk_hw_omap lcd_gclk_hw = {
 	.clksel_mask	= AM33XX_CLKSEL_0_1_MASK,
 };
 
-DEFINE_STRUCT_CLK(lcd_gclk, lcd_ck_parents, gpio_fck_ops);
+DEFINE_STRUCT_CLK_FLAGS(lcd_gclk, lcd_ck_parents,
+			gpio_fck_ops, CLK_SET_RATE_PARENT);
 
 DEFINE_CLK_FIXED_FACTOR(mmc_clk, "dpll_per_m2_ck", &dpll_per_m2_ck, 0x0, 1, 2);
 
-- 
1.7.12

