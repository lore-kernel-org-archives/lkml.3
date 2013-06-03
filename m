Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758357Ab3FCNny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:43:54 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:51188 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757588Ab3FCNng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:43:36 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, ulf.hansson@linaro.org,
        Lee Jones <lee.jones@linaro.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 21/21] clk: ux500: Supply provider look-up functionality to support Device Tree
Date: Mon,  3 Jun 2013 14:42:45 +0100
Message-Id: <1370266965-7901-22-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370266965-7901-1-git-send-email-lee.jones@linaro.org>
References: <1370266965-7901-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this patch we're populating a clk_data array, one clock per element to
act as a clk look-up using indexes supplied from Device Tree.

Cc: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/clk/ux500/u8500_clk.c |  154 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 153 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/ux500/u8500_clk.c b/drivers/clk/ux500/u8500_clk.c
index 80069c3..9b4d8d9 100644
--- a/drivers/clk/ux500/u8500_clk.c
+++ b/drivers/clk/ux500/u8500_clk.c
@@ -7,6 +7,7 @@
  * License terms: GNU General Public License (GPL) version 2
  */
 
+#include <linux/of.h>
 #include <linux/clk.h>
 #include <linux/clkdev.h>
 #include <linux/clk-provider.h>
@@ -14,25 +15,66 @@
 #include <linux/platform_data/clk-ux500.h>
 #include "clk.h"
 
+/*
+ * Important:
+ * Only add clocks to the end. Do not remove or change the order of the clocks.
+ */
+enum u8500_clk {
+	soc0_pll      = 0,   soc1_pll, ddr_pll, rtc_pl031, mali,
+	uart          = 5,   msp2clk, msp1clk, i2c, slim,
+	per1          = 10,  per2, per3, per5, per6,
+	per7          = 15,  lcd, bml, hdmi, apeat,
+	apetrace      = 20,  dsilink, ipi2, dsialt, dma,
+	b2r2          = 25,  tv, ssp, rngclk, uicc,
+	mtu           = 30,  sdmmc, dsihs2, dsihs0, dsihs1,
+	dsilp0        = 35,  dsilp1, dsilp2, armss, smp_twd,
+	uart0         = 40,  uart1, nmk_i2c1, msp0, msp1,
+	sdi0          = 45,  nmk_i2c2, spi3, slimbus0, gpioblock0,
+	nmk_i2c4      = 50,  msp3, nmk_i2c3, spi2, spi1,
+	pwl           = 55,  sdi4, msp2, sdi1, sdi3,
+	spi0          = 60,  hsir_hclk, hsit_hclk, gpioblock1, fsmc,
+	ssp0          = 65,  ssp1, nmk_i2c0, sdi2, ske,
+	uart2         = 70,  sdi5, gpioblock2, musb, gpioblock3,
+	rng           = 75,  crypt, hash0, pka, hash1,
+	cfgreg        = 80,  mtu0, mtu1, per1_uart0, per1_uart1,
+	per1_nmk_i2c1 = 85,  per1_msp0, per1_msp1, per1_sdi0, per1_nmk_i2c2,
+	per1_slimbus0 = 90,  per1_nmk_i2c4, per1_msp3, per2_nmk_i2c3, per2_sdi4,
+	per2_msp2     = 95,  per2_sdi1, per2_sdi3, per3_ssp0, per3_ssp1,
+	per3_nmk_i2c0 = 100, per3_sdi2, per3_ske, per3_uart2, per3_sdi5,
+	per6_rng      = 105, /* New clks go here. */ CLK_MAX,
+};
+
+struct clk *clks[CLK_MAX];
+
+const static struct of_device_id u8500_clk_of_match[] = {
+	{ .compatible = "stericsson,u8500-clk", },
+	{ },
+};
+
 void u8500_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
 		    u32 clkrst5_base, u32 clkrst6_base)
 {
 	struct prcmu_fw_version *fw_version;
 	const char *sgaclk_parent = NULL;
+	static struct clk_onecell_data clk_data;
+	struct device_node *np = NULL;
 	struct clk *clk;
 
 	/* Clock sources */
 	clk = clk_reg_prcmu_gate("soc0_pll", NULL, PRCMU_PLLSOC0,
 				CLK_IS_ROOT|CLK_IGNORE_UNUSED);
 	clk_register_clkdev(clk, "soc0_pll", NULL);
+	clks[soc0_pll] = clk;
 
 	clk = clk_reg_prcmu_gate("soc1_pll", NULL, PRCMU_PLLSOC1,
 				CLK_IS_ROOT|CLK_IGNORE_UNUSED);
 	clk_register_clkdev(clk, "soc1_pll", NULL);
+	clks[soc1_pll] = clk;
 
 	clk = clk_reg_prcmu_gate("ddr_pll", NULL, PRCMU_PLLDDR,
 				CLK_IS_ROOT|CLK_IGNORE_UNUSED);
 	clk_register_clkdev(clk, "ddr_pll", NULL);
+	clks[ddr_pll] = clk;
 
 	/* FIXME: Add sys, ulp and int clocks here. */
 
@@ -41,6 +83,7 @@ void u8500_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
 				32768);
 	clk_register_clkdev(clk, "clk32k", NULL);
 	clk_register_clkdev(clk, "apb_pclk", "rtc-pl031");
+	clks[rtc_pl031] = clk;
 
 	/* PRCMU clocks */
 	fw_version = prcmu_get_fw_version();
@@ -63,47 +106,61 @@ void u8500_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
 		clk = clk_reg_prcmu_gate("sgclk", NULL,
 					PRCMU_SGACLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "mali");
+	clks[mali] = clk;
 
 	clk = clk_reg_prcmu_gate("uartclk", NULL, PRCMU_UARTCLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "UART");
+	clks[uart] = clk;
 
 	clk = clk_reg_prcmu_gate("msp02clk", NULL, PRCMU_MSP02CLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "MSP02");
+	clks[msp2clk] = clk;
 
 	clk = clk_reg_prcmu_gate("msp1clk", NULL, PRCMU_MSP1CLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "MSP1");
+	clks[msp1clk] = clk;
 
 	clk = clk_reg_prcmu_gate("i2cclk", NULL, PRCMU_I2CCLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "I2C");
+	clks[i2c] = clk;
 
 	clk = clk_reg_prcmu_gate("slimclk", NULL, PRCMU_SLIMCLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "slim");
+	clks[slim] = clk;
 
 	clk = clk_reg_prcmu_gate("per1clk", NULL, PRCMU_PER1CLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "PERIPH1");
+	clks[per1] = clk;
 
 	clk = clk_reg_prcmu_gate("per2clk", NULL, PRCMU_PER2CLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "PERIPH2");
+	clks[per2] = clk;
 
 	clk = clk_reg_prcmu_gate("per3clk", NULL, PRCMU_PER3CLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "PERIPH3");
+	clks[per3] = clk;
 
 	clk = clk_reg_prcmu_gate("per5clk", NULL, PRCMU_PER5CLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "PERIPH5");
+	clks[per5] = clk;
 
 	clk = clk_reg_prcmu_gate("per6clk", NULL, PRCMU_PER6CLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "PERIPH6");
+	clks[per6] = clk;
 
 	clk = clk_reg_prcmu_gate("per7clk", NULL, PRCMU_PER7CLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "PERIPH7");
+	clks[per7] = clk;
 
 	clk = clk_reg_prcmu_scalable("lcdclk", NULL, PRCMU_LCDCLK, 0,
 				CLK_IS_ROOT|CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "lcd");
 	clk_register_clkdev(clk, "lcd", "mcde");
+	clks[lcd] = clk;
 
 	clk = clk_reg_prcmu_opp_gate("bmlclk", NULL, PRCMU_BMLCLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "bml");
+	clks[bml] = clk;
 
 	clk = clk_reg_prcmu_scalable("hsitxclk", NULL, PRCMU_HSITXCLK, 0,
 				CLK_IS_ROOT|CLK_SET_RATE_GATE);
@@ -115,13 +172,16 @@ void u8500_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
 				CLK_IS_ROOT|CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "hdmi");
 	clk_register_clkdev(clk, "hdmi", "mcde");
+	clks[hdmi] = clk;
 
 	clk = clk_reg_prcmu_gate("apeatclk", NULL, PRCMU_APEATCLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "apeat");
+	clks[apeat] = clk;
 
 	clk = clk_reg_prcmu_gate("apetraceclk", NULL, PRCMU_APETRACECLK,
 				CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "apetrace");
+	clks[apetrace] = clk;
 
 	clk = clk_reg_prcmu_gate("mcdeclk", NULL, PRCMU_MCDECLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "mcde");
@@ -129,84 +189,102 @@ void u8500_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
 	clk_register_clkdev(clk, "dsisys", "dsilink.0");
 	clk_register_clkdev(clk, "dsisys", "dsilink.1");
 	clk_register_clkdev(clk, "dsisys", "dsilink.2");
+	clks[dsilink] = clk;
 
 	clk = clk_reg_prcmu_opp_gate("ipi2cclk", NULL, PRCMU_IPI2CCLK,
 				CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "ipi2");
+	clks[ipi2] = clk;
 
 	clk = clk_reg_prcmu_gate("dsialtclk", NULL, PRCMU_DSIALTCLK,
 				CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "dsialt");
+	clks[dsialt] = clk;
 
 	clk = clk_reg_prcmu_gate("dmaclk", NULL, PRCMU_DMACLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "dma40.0");
+	clks[dma] = clk;
 
 	clk = clk_reg_prcmu_gate("b2r2clk", NULL, PRCMU_B2R2CLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "b2r2");
 	clk_register_clkdev(clk, NULL, "b2r2_core");
 	clk_register_clkdev(clk, NULL, "U8500-B2R2.0");
+	clks[b2r2] = clk;
 
 	clk = clk_reg_prcmu_scalable("tvclk", NULL, PRCMU_TVCLK, 0,
 				CLK_IS_ROOT|CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "tv");
 	clk_register_clkdev(clk, "tv", "mcde");
+	clks[tv] = clk;
 
 	clk = clk_reg_prcmu_gate("sspclk", NULL, PRCMU_SSPCLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "SSP");
+	clks[ssp] = clk;
 
 	clk = clk_reg_prcmu_gate("rngclk", NULL, PRCMU_RNGCLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "rngclk");
+	clks[rngclk] = clk;
 
 	clk = clk_reg_prcmu_gate("uiccclk", NULL, PRCMU_UICCCLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "uicc");
+	clks[uicc] = clk;
 
 	clk = clk_reg_prcmu_gate("timclk", NULL, PRCMU_TIMCLK, CLK_IS_ROOT);
 	clk_register_clkdev(clk, NULL, "mtu0");
 	clk_register_clkdev(clk, NULL, "mtu1");
+	clks[mtu] = clk;
 
 	clk = clk_reg_prcmu_opp_volt_scalable("sdmmcclk", NULL, PRCMU_SDMMCCLK,
 					100000000,
 					CLK_IS_ROOT|CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "sdmmc");
+	clks[sdmmc] = clk;
 
 	clk = clk_reg_prcmu_scalable("dsi_pll", "hdmiclk",
 				PRCMU_PLLDSI, 0, CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, "dsihs2", "mcde");
 	clk_register_clkdev(clk, "dsihs2", "dsilink.2");
-
+	clks[dsihs2] = clk;
 
 	clk = clk_reg_prcmu_scalable("dsi0clk", "dsi_pll",
 				PRCMU_DSI0CLK, 0, CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, "dsihs0", "mcde");
 	clk_register_clkdev(clk, "dsihs0", "dsilink.0");
+	clks[dsihs0] = clk;
 
 	clk = clk_reg_prcmu_scalable("dsi1clk", "dsi_pll",
 				PRCMU_DSI1CLK, 0, CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, "dsihs1", "mcde");
 	clk_register_clkdev(clk, "dsihs1", "dsilink.1");
+	clks[dsihs1] = clk;
 
 	clk = clk_reg_prcmu_scalable("dsi0escclk", "tvclk",
 				PRCMU_DSI0ESCCLK, 0, CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, "dsilp0", "dsilink.0");
 	clk_register_clkdev(clk, "dsilp0", "mcde");
+	clks[dsilp0] = clk;
 
 	clk = clk_reg_prcmu_scalable("dsi1escclk", "tvclk",
 				PRCMU_DSI1ESCCLK, 0, CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, "dsilp1", "dsilink.1");
 	clk_register_clkdev(clk, "dsilp1", "mcde");
+	clks[dsilp1] = clk;
 
 	clk = clk_reg_prcmu_scalable("dsi2escclk", "tvclk",
 				PRCMU_DSI2ESCCLK, 0, CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, "dsilp2", "dsilink.2");
 	clk_register_clkdev(clk, "dsilp2", "mcde");
+	clks[dsilp2] = clk;
 
 	clk = clk_reg_prcmu_scalable_rate("armss", NULL,
 				PRCMU_ARMSS, 0, CLK_IS_ROOT|CLK_IGNORE_UNUSED);
 	clk_register_clkdev(clk, "armss", NULL);
+	clks[armss] = clk;
 
 	clk = clk_register_fixed_factor(NULL, "smp_twd", "armss",
 				CLK_IGNORE_UNUSED, 1, 2);
 	clk_register_clkdev(clk, NULL, "smp_twd");
+	clks[smp_twd] = clk;
 
 	/*
 	 * FIXME: Add special handled PRCMU clocks here:
@@ -218,106 +296,130 @@ void u8500_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
 	clk = clk_reg_prcc_pclk("p1_pclk0", "per1clk", clkrst1_base,
 				BIT(0), 0);
 	clk_register_clkdev(clk, "apb_pclk", "uart0");
+	clks[uart0] = clk;
 
 	clk = clk_reg_prcc_pclk("p1_pclk1", "per1clk", clkrst1_base,
 				BIT(1), 0);
 	clk_register_clkdev(clk, "apb_pclk", "uart1");
+	clks[uart1] = clk;
 
 	clk = clk_reg_prcc_pclk("p1_pclk2", "per1clk", clkrst1_base,
 				BIT(2), 0);
 	clk_register_clkdev(clk, "apb_pclk", "nmk-i2c.1");
+	clks[nmk_i2c1] = clk;
 
 	clk = clk_reg_prcc_pclk("p1_pclk3", "per1clk", clkrst1_base,
 				BIT(3), 0);
 	clk_register_clkdev(clk, "apb_pclk", "msp0");
 	clk_register_clkdev(clk, "apb_pclk", "ux500-msp-i2s.0");
+	clks[msp0] = clk;
 
 	clk = clk_reg_prcc_pclk("p1_pclk4", "per1clk", clkrst1_base,
 				BIT(4), 0);
 	clk_register_clkdev(clk, "apb_pclk", "msp1");
 	clk_register_clkdev(clk, "apb_pclk", "ux500-msp-i2s.1");
+	clks[msp1] = clk;
 
 	clk = clk_reg_prcc_pclk("p1_pclk5", "per1clk", clkrst1_base,
 				BIT(5), 0);
 	clk_register_clkdev(clk, "apb_pclk", "sdi0");
+	clks[sdi0] = clk;
 
 	clk = clk_reg_prcc_pclk("p1_pclk6", "per1clk", clkrst1_base,
 				BIT(6), 0);
 	clk_register_clkdev(clk, "apb_pclk", "nmk-i2c.2");
+	clks[nmk_i2c2] = clk;
 
 	clk = clk_reg_prcc_pclk("p1_pclk7", "per1clk", clkrst1_base,
 				BIT(7), 0);
 	clk_register_clkdev(clk, NULL, "spi3");
+	clks[spi3] = clk;
 
 	clk = clk_reg_prcc_pclk("p1_pclk8", "per1clk", clkrst1_base,
 				BIT(8), 0);
 	clk_register_clkdev(clk, "apb_pclk", "slimbus0");
+	clks[slimbus0] = clk;
 
 	clk = clk_reg_prcc_pclk("p1_pclk9", "per1clk", clkrst1_base,
 				BIT(9), 0);
 	clk_register_clkdev(clk, NULL, "gpio.0");
 	clk_register_clkdev(clk, NULL, "gpio.1");
 	clk_register_clkdev(clk, NULL, "gpioblock0");
+	clks[gpioblock0] = clk;
 
 	clk = clk_reg_prcc_pclk("p1_pclk10", "per1clk", clkrst1_base,
 				BIT(10), 0);
 	clk_register_clkdev(clk, "apb_pclk", "nmk-i2c.4");
+	clks[nmk_i2c4] = clk;
 
 	clk = clk_reg_prcc_pclk("p1_pclk11", "per1clk", clkrst1_base,
 				BIT(11), 0);
 	clk_register_clkdev(clk, "apb_pclk", "msp3");
 	clk_register_clkdev(clk, "apb_pclk", "ux500-msp-i2s.3");
+	clks[msp3] = clk;
 
 	clk = clk_reg_prcc_pclk("p2_pclk0", "per2clk", clkrst2_base,
 				BIT(0), 0);
 	clk_register_clkdev(clk, "apb_pclk", "nmk-i2c.3");
+	clks[nmk_i2c3] = clk;
 
 	clk = clk_reg_prcc_pclk("p2_pclk1", "per2clk", clkrst2_base,
 				BIT(1), 0);
 	clk_register_clkdev(clk, NULL, "spi2");
+	clks[spi2] = clk;
 
 	clk = clk_reg_prcc_pclk("p2_pclk2", "per2clk", clkrst2_base,
 				BIT(2), 0);
 	clk_register_clkdev(clk, NULL, "spi1");
+	clks[spi1] = clk;
 
 	clk = clk_reg_prcc_pclk("p2_pclk3", "per2clk", clkrst2_base,
 				BIT(3), 0);
 	clk_register_clkdev(clk, NULL, "pwl");
+	clks[pwl] = clk;
 
 	clk = clk_reg_prcc_pclk("p2_pclk4", "per2clk", clkrst2_base,
 				BIT(4), 0);
 	clk_register_clkdev(clk, "apb_pclk", "sdi4");
+	clks[sdi4] = clk;
 
 	clk = clk_reg_prcc_pclk("p2_pclk5", "per2clk", clkrst2_base,
 				BIT(5), 0);
 	clk_register_clkdev(clk, "apb_pclk", "msp2");
 	clk_register_clkdev(clk, "apb_pclk", "ux500-msp-i2s.2");
+	clks[msp2] = clk;
 
 	clk = clk_reg_prcc_pclk("p2_pclk6", "per2clk", clkrst2_base,
 				BIT(6), 0);
 	clk_register_clkdev(clk, "apb_pclk", "sdi1");
+	clks[sdi1] = clk;
 
 	clk = clk_reg_prcc_pclk("p2_pclk7", "per2clk", clkrst2_base,
 				BIT(7), 0);
 	clk_register_clkdev(clk, "apb_pclk", "sdi3");
+	clks[sdi3] = clk;
 
 	clk = clk_reg_prcc_pclk("p2_pclk8", "per2clk", clkrst2_base,
 				BIT(8), 0);
 	clk_register_clkdev(clk, NULL, "spi0");
+	clks[spi0] = clk;
 
 	clk = clk_reg_prcc_pclk("p2_pclk9", "per2clk", clkrst2_base,
 				BIT(9), 0);
 	clk_register_clkdev(clk, "hsir_hclk", "ste_hsi.0");
+	clks[hsir_hclk] = clk;
 
 	clk = clk_reg_prcc_pclk("p2_pclk10", "per2clk", clkrst2_base,
 				BIT(10), 0);
 	clk_register_clkdev(clk, "hsit_hclk", "ste_hsi.0");
+	clks[hsit_hclk] = clk;
 
 	clk = clk_reg_prcc_pclk("p2_pclk11", "per2clk", clkrst2_base,
 				BIT(11), 0);
 	clk_register_clkdev(clk, NULL, "gpio.6");
 	clk_register_clkdev(clk, NULL, "gpio.7");
 	clk_register_clkdev(clk, NULL, "gpioblock1");
+	clks[gpioblock1] = clk;
 
 	clk = clk_reg_prcc_pclk("p2_pclk12", "per2clk", clkrst2_base,
 				BIT(12), 0);
@@ -326,35 +428,43 @@ void u8500_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
 				BIT(0), 0);
 	clk_register_clkdev(clk, "fsmc", NULL);
 	clk_register_clkdev(clk, NULL, "smsc911x.0");
+	clks[fsmc] = clk;
 
 	clk = clk_reg_prcc_pclk("p3_pclk1", "per3clk", clkrst3_base,
 				BIT(1), 0);
 	clk_register_clkdev(clk, "apb_pclk", "ssp0");
+	clks[ssp0] = clk;
 
 	clk = clk_reg_prcc_pclk("p3_pclk2", "per3clk", clkrst3_base,
 				BIT(2), 0);
 	clk_register_clkdev(clk, "apb_pclk", "ssp1");
+	clks[ssp1] = clk;
 
 	clk = clk_reg_prcc_pclk("p3_pclk3", "per3clk", clkrst3_base,
 				BIT(3), 0);
 	clk_register_clkdev(clk, "apb_pclk", "nmk-i2c.0");
+	clks[nmk_i2c0] = clk;
 
 	clk = clk_reg_prcc_pclk("p3_pclk4", "per3clk", clkrst3_base,
 				BIT(4), 0);
 	clk_register_clkdev(clk, "apb_pclk", "sdi2");
+	clks[sdi2] = clk;
 
 	clk = clk_reg_prcc_pclk("p3_pclk5", "per3clk", clkrst3_base,
 				BIT(5), 0);
 	clk_register_clkdev(clk, "apb_pclk", "ske");
 	clk_register_clkdev(clk, "apb_pclk", "nmk-ske-keypad");
+	clks[ske] = clk;
 
 	clk = clk_reg_prcc_pclk("p3_pclk6", "per3clk", clkrst3_base,
 				BIT(6), 0);
 	clk_register_clkdev(clk, "apb_pclk", "uart2");
+	clks[uart2] = clk;
 
 	clk = clk_reg_prcc_pclk("p3_pclk7", "per3clk", clkrst3_base,
 				BIT(7), 0);
 	clk_register_clkdev(clk, "apb_pclk", "sdi5");
+	clks[sdi5] = clk;
 
 	clk = clk_reg_prcc_pclk("p3_pclk8", "per3clk", clkrst3_base,
 				BIT(8), 0);
@@ -363,48 +473,59 @@ void u8500_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
 	clk_register_clkdev(clk, NULL, "gpio.4");
 	clk_register_clkdev(clk, NULL, "gpio.5");
 	clk_register_clkdev(clk, NULL, "gpioblock2");
+	clks[gpioblock2] = clk;
 
 	clk = clk_reg_prcc_pclk("p5_pclk0", "per5clk", clkrst5_base,
 				BIT(0), 0);
 	clk_register_clkdev(clk, "usb", "musb-ux500.0");
+	clks[musb] = clk;
 
 	clk = clk_reg_prcc_pclk("p5_pclk1", "per5clk", clkrst5_base,
 				BIT(1), 0);
 	clk_register_clkdev(clk, NULL, "gpio.8");
 	clk_register_clkdev(clk, NULL, "gpioblock3");
+	clks[gpioblock3] = clk;
 
 	clk = clk_reg_prcc_pclk("p6_pclk0", "per6clk", clkrst6_base,
 				BIT(0), 0);
 	clk_register_clkdev(clk, "apb_pclk", "rng");
+	clks[rng] = clk;
 
 	clk = clk_reg_prcc_pclk("p6_pclk1", "per6clk", clkrst6_base,
 				BIT(1), 0);
 	clk_register_clkdev(clk, NULL, "cryp0");
 	clk_register_clkdev(clk, NULL, "cryp1");
+	clks[crypt] = clk;
 
 	clk = clk_reg_prcc_pclk("p6_pclk2", "per6clk", clkrst6_base,
 				BIT(2), 0);
 	clk_register_clkdev(clk, NULL, "hash0");
+	clks[hash0] = clk;
 
 	clk = clk_reg_prcc_pclk("p6_pclk3", "per6clk", clkrst6_base,
 				BIT(3), 0);
 	clk_register_clkdev(clk, NULL, "pka");
+	clks[pka] = clk;
 
 	clk = clk_reg_prcc_pclk("p6_pclk4", "per6clk", clkrst6_base,
 				BIT(4), 0);
 	clk_register_clkdev(clk, NULL, "hash1");
+	clks[hash1] = clk;
 
 	clk = clk_reg_prcc_pclk("p6_pclk5", "per6clk", clkrst6_base,
 				BIT(5), 0);
 	clk_register_clkdev(clk, NULL, "cfgreg");
+	clks[cfgreg] = clk;
 
 	clk = clk_reg_prcc_pclk("p6_pclk6", "per6clk", clkrst6_base,
 				BIT(6), 0);
 	clk_register_clkdev(clk, "apb_pclk", "mtu0");
+	clks[mtu0] = clk;
 
 	clk = clk_reg_prcc_pclk("p6_pclk7", "per6clk", clkrst6_base,
 				BIT(7), 0);
 	clk_register_clkdev(clk, "apb_pclk", "mtu1");
+	clks[mtu1] = clk;
 
 	/* PRCC K-clocks
 	 *
@@ -418,67 +539,82 @@ void u8500_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
 	clk = clk_reg_prcc_kclk("p1_uart0_kclk", "uartclk",
 			clkrst1_base, BIT(0), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "uart0");
+	clks[per1_uart0] = clk;
 
 	clk = clk_reg_prcc_kclk("p1_uart1_kclk", "uartclk",
 			clkrst1_base, BIT(1), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "uart1");
+	clks[per1_uart1] = clk;
 
 	clk = clk_reg_prcc_kclk("p1_i2c1_kclk", "i2cclk",
 			clkrst1_base, BIT(2), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "nmk-i2c.1");
+	clks[per1_nmk_i2c1] = clk;
 
 	clk = clk_reg_prcc_kclk("p1_msp0_kclk", "msp02clk",
 			clkrst1_base, BIT(3), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "msp0");
 	clk_register_clkdev(clk, NULL, "ux500-msp-i2s.0");
+	clks[per1_msp0] = clk;
 
 	clk = clk_reg_prcc_kclk("p1_msp1_kclk", "msp1clk",
 			clkrst1_base, BIT(4), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "msp1");
 	clk_register_clkdev(clk, NULL, "ux500-msp-i2s.1");
+	clks[per1_msp1] = clk;
 
 	clk = clk_reg_prcc_kclk("p1_sdi0_kclk", "sdmmcclk",
 			clkrst1_base, BIT(5), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "sdi0");
+	clks[per1_sdi0] = clk;
 
 	clk = clk_reg_prcc_kclk("p1_i2c2_kclk", "i2cclk",
 			clkrst1_base, BIT(6), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "nmk-i2c.2");
+	clks[per1_nmk_i2c2] = clk;
 
 	clk = clk_reg_prcc_kclk("p1_slimbus0_kclk", "slimclk",
 			clkrst1_base, BIT(8), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "slimbus0");
+	clks[per1_slimbus0] = clk;
 
 	clk = clk_reg_prcc_kclk("p1_i2c4_kclk", "i2cclk",
 			clkrst1_base, BIT(9), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "nmk-i2c.4");
+	clks[per1_nmk_i2c4] = clk;
 
 	clk = clk_reg_prcc_kclk("p1_msp3_kclk", "msp1clk",
 			clkrst1_base, BIT(10), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "msp3");
 	clk_register_clkdev(clk, NULL, "ux500-msp-i2s.3");
+	clks[per1_msp3] = clk;
 
 	/* Periph2 */
 	clk = clk_reg_prcc_kclk("p2_i2c3_kclk", "i2cclk",
 			clkrst2_base, BIT(0), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "nmk-i2c.3");
+	clks[per2_nmk_i2c3] = clk;
 
 	clk = clk_reg_prcc_kclk("p2_sdi4_kclk", "sdmmcclk",
 			clkrst2_base, BIT(2), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "sdi4");
+	clks[per2_sdi4] = clk;
 
 	clk = clk_reg_prcc_kclk("p2_msp2_kclk", "msp02clk",
 			clkrst2_base, BIT(3), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "msp2");
 	clk_register_clkdev(clk, NULL, "ux500-msp-i2s.2");
+	clks[per2_msp2] = clk;
 
 	clk = clk_reg_prcc_kclk("p2_sdi1_kclk", "sdmmcclk",
 			clkrst2_base, BIT(4), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "sdi1");
+	clks[per2_sdi1] = clk;
 
 	clk = clk_reg_prcc_kclk("p2_sdi3_kclk", "sdmmcclk",
 			clkrst2_base, BIT(5), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "sdi3");
+	clks[per2_sdi3] = clk;
 
 	/* Note that rate is received from parent. */
 	clk = clk_reg_prcc_kclk("p2_ssirx_kclk", "hsirxclk",
@@ -492,34 +628,50 @@ void u8500_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
 	clk = clk_reg_prcc_kclk("p3_ssp0_kclk", "sspclk",
 			clkrst3_base, BIT(1), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "ssp0");
+	clks[per3_ssp0] = clk;
 
 	clk = clk_reg_prcc_kclk("p3_ssp1_kclk", "sspclk",
 			clkrst3_base, BIT(2), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "ssp1");
+	clks[per3_ssp1] = clk;
 
 	clk = clk_reg_prcc_kclk("p3_i2c0_kclk", "i2cclk",
 			clkrst3_base, BIT(3), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "nmk-i2c.0");
+	clks[per3_nmk_i2c0] = clk;
 
 	clk = clk_reg_prcc_kclk("p3_sdi2_kclk", "sdmmcclk",
 			clkrst3_base, BIT(4), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "sdi2");
+	clks[per3_sdi2] = clk;
 
 	clk = clk_reg_prcc_kclk("p3_ske_kclk", "rtc32k",
 			clkrst3_base, BIT(5), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "ske");
 	clk_register_clkdev(clk, NULL, "nmk-ske-keypad");
+	clks[per3_ske] = clk;
 
 	clk = clk_reg_prcc_kclk("p3_uart2_kclk", "uartclk",
 			clkrst3_base, BIT(6), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "uart2");
+	clks[per3_uart2] = clk;
 
 	clk = clk_reg_prcc_kclk("p3_sdi5_kclk", "sdmmcclk",
 			clkrst3_base, BIT(7), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "sdi5");
+	clks[per3_sdi5] = clk;
 
 	/* Periph6 */
 	clk = clk_reg_prcc_kclk("p3_rng_kclk", "rngclk",
 			clkrst6_base, BIT(0), CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "rng");
+	clks[per6_rng] = clk;
+
+	if (of_have_populated_dt())
+		np = of_find_matching_node(NULL, u8500_clk_of_match);
+	if (np) {
+		clk_data.clks = clks;
+		clk_data.clk_num = CLK_MAX;
+		of_clk_add_provider(np, of_clk_src_onecell_get, &clk_data);
+	}
 }
-- 
1.7.10.4

