Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab3IRMVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:21:04 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:34793 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab3IRMVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:21:01 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 22/41] clk: ux500: Copy u8500_clk_init() ready for DT enablement
Date: Wed, 18 Sep 2013 13:14:19 +0100
Message-Id: <1379506478-16625-23-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
References: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we're using the old clock initialisation function as a template.
It's necessary to remove all of the clk_register_clkdev() calls as
they don't make sense when booting with Device Tree.

Cc: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/clk/ux500/Makefile              |   1 +
 drivers/clk/ux500/u8500_of_clk.c        | 381 ++++++++++++++++++++++++++++++++
 include/linux/platform_data/clk-ux500.h |   3 +
 3 files changed, 385 insertions(+)
 create mode 100644 drivers/clk/ux500/u8500_of_clk.c

diff --git a/drivers/clk/ux500/Makefile b/drivers/clk/ux500/Makefile
index c6a806e..521483f 100644
--- a/drivers/clk/ux500/Makefile
+++ b/drivers/clk/ux500/Makefile
@@ -8,6 +8,7 @@ obj-y += clk-prcmu.o
 obj-y += clk-sysctrl.o
 
 # Clock definitions
+obj-y += u8500_of_clk.o
 obj-y += u8500_clk.o
 obj-y += u9540_clk.o
 obj-y += u8540_clk.o
diff --git a/drivers/clk/ux500/u8500_of_clk.c b/drivers/clk/ux500/u8500_of_clk.c
new file mode 100644
index 0000000..ceebce6
--- /dev/null
+++ b/drivers/clk/ux500/u8500_of_clk.c
@@ -0,0 +1,381 @@
+/*
+ * Clock definitions for u8500 platform.
+ *
+ * Copyright (C) 2012 ST-Ericsson SA
+ * Author: Ulf Hansson <ulf.hansson@linaro.org>
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#include <linux/clk.h>
+#include <linux/clkdev.h>
+#include <linux/clk-provider.h>
+#include <linux/mfd/dbx500-prcmu.h>
+#include <linux/platform_data/clk-ux500.h>
+#include "clk.h"
+
+void u8500_of_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
+		       u32 clkrst5_base, u32 clkrst6_base)
+{
+	struct prcmu_fw_version *fw_version;
+	const char *sgaclk_parent = NULL;
+	struct clk *clk;
+
+	/* Clock sources */
+	clk = clk_reg_prcmu_gate("soc0_pll", NULL, PRCMU_PLLSOC0,
+				CLK_IS_ROOT|CLK_IGNORE_UNUSED);
+
+	clk = clk_reg_prcmu_gate("soc1_pll", NULL, PRCMU_PLLSOC1,
+				CLK_IS_ROOT|CLK_IGNORE_UNUSED);
+
+	clk = clk_reg_prcmu_gate("ddr_pll", NULL, PRCMU_PLLDDR,
+				CLK_IS_ROOT|CLK_IGNORE_UNUSED);
+
+	/* FIXME: Add sys, ulp and int clocks here. */
+
+	clk = clk_register_fixed_rate(NULL, "rtc32k", "NULL",
+				CLK_IS_ROOT|CLK_IGNORE_UNUSED,
+				32768);
+
+	/* PRCMU clocks */
+	fw_version = prcmu_get_fw_version();
+	if (fw_version != NULL) {
+		switch (fw_version->project) {
+		case PRCMU_FW_PROJECT_U8500_C2:
+		case PRCMU_FW_PROJECT_U8520:
+		case PRCMU_FW_PROJECT_U8420:
+			sgaclk_parent = "soc0_pll";
+			break;
+		default:
+			break;
+		}
+	}
+
+	if (sgaclk_parent)
+		clk = clk_reg_prcmu_gate("sgclk", sgaclk_parent,
+					PRCMU_SGACLK, 0);
+	else
+		clk = clk_reg_prcmu_gate("sgclk", NULL,
+					PRCMU_SGACLK, CLK_IS_ROOT);
+
+	clk = clk_reg_prcmu_gate("uartclk", NULL, PRCMU_UARTCLK, CLK_IS_ROOT);
+
+	clk = clk_reg_prcmu_gate("msp02clk", NULL, PRCMU_MSP02CLK, CLK_IS_ROOT);
+
+	clk = clk_reg_prcmu_gate("msp1clk", NULL, PRCMU_MSP1CLK, CLK_IS_ROOT);
+
+	clk = clk_reg_prcmu_gate("i2cclk", NULL, PRCMU_I2CCLK, CLK_IS_ROOT);
+
+	clk = clk_reg_prcmu_gate("slimclk", NULL, PRCMU_SLIMCLK, CLK_IS_ROOT);
+
+	clk = clk_reg_prcmu_gate("per1clk", NULL, PRCMU_PER1CLK, CLK_IS_ROOT);
+
+	clk = clk_reg_prcmu_gate("per2clk", NULL, PRCMU_PER2CLK, CLK_IS_ROOT);
+
+	clk = clk_reg_prcmu_gate("per3clk", NULL, PRCMU_PER3CLK, CLK_IS_ROOT);
+
+	clk = clk_reg_prcmu_gate("per5clk", NULL, PRCMU_PER5CLK, CLK_IS_ROOT);
+
+	clk = clk_reg_prcmu_gate("per6clk", NULL, PRCMU_PER6CLK, CLK_IS_ROOT);
+
+	clk = clk_reg_prcmu_gate("per7clk", NULL, PRCMU_PER7CLK, CLK_IS_ROOT);
+
+	clk = clk_reg_prcmu_scalable("lcdclk", NULL, PRCMU_LCDCLK, 0,
+				CLK_IS_ROOT|CLK_SET_RATE_GATE);
+
+	clk = clk_reg_prcmu_opp_gate("bmlclk", NULL, PRCMU_BMLCLK, CLK_IS_ROOT);
+
+	clk = clk_reg_prcmu_scalable("hsitxclk", NULL, PRCMU_HSITXCLK, 0,
+				CLK_IS_ROOT|CLK_SET_RATE_GATE);
+
+	clk = clk_reg_prcmu_scalable("hsirxclk", NULL, PRCMU_HSIRXCLK, 0,
+				CLK_IS_ROOT|CLK_SET_RATE_GATE);
+
+	clk = clk_reg_prcmu_scalable("hdmiclk", NULL, PRCMU_HDMICLK, 0,
+				CLK_IS_ROOT|CLK_SET_RATE_GATE);
+
+	clk = clk_reg_prcmu_gate("apeatclk", NULL, PRCMU_APEATCLK, CLK_IS_ROOT);
+
+	clk = clk_reg_prcmu_gate("apetraceclk", NULL, PRCMU_APETRACECLK,
+				CLK_IS_ROOT);
+
+	clk = clk_reg_prcmu_gate("mcdeclk", NULL, PRCMU_MCDECLK, CLK_IS_ROOT);
+
+	clk = clk_reg_prcmu_opp_gate("ipi2cclk", NULL, PRCMU_IPI2CCLK,
+				CLK_IS_ROOT);
+
+	clk = clk_reg_prcmu_gate("dsialtclk", NULL, PRCMU_DSIALTCLK,
+				CLK_IS_ROOT);
+
+	clk = clk_reg_prcmu_gate("dmaclk", NULL, PRCMU_DMACLK, CLK_IS_ROOT);
+
+	clk = clk_reg_prcmu_gate("b2r2clk", NULL, PRCMU_B2R2CLK, CLK_IS_ROOT);
+
+	clk = clk_reg_prcmu_scalable("tvclk", NULL, PRCMU_TVCLK, 0,
+				CLK_IS_ROOT|CLK_SET_RATE_GATE);
+
+	clk = clk_reg_prcmu_gate("sspclk", NULL, PRCMU_SSPCLK, CLK_IS_ROOT);
+
+	clk = clk_reg_prcmu_gate("rngclk", NULL, PRCMU_RNGCLK, CLK_IS_ROOT);
+
+	clk = clk_reg_prcmu_gate("uiccclk", NULL, PRCMU_UICCCLK, CLK_IS_ROOT);
+
+	clk = clk_reg_prcmu_gate("timclk", NULL, PRCMU_TIMCLK, CLK_IS_ROOT);
+
+	clk = clk_reg_prcmu_opp_volt_scalable("sdmmcclk", NULL, PRCMU_SDMMCCLK,
+					100000000,
+					CLK_IS_ROOT|CLK_SET_RATE_GATE);
+
+	clk = clk_reg_prcmu_scalable("dsi_pll", "hdmiclk",
+				PRCMU_PLLDSI, 0, CLK_SET_RATE_GATE);
+
+
+	clk = clk_reg_prcmu_scalable("dsi0clk", "dsi_pll",
+				PRCMU_DSI0CLK, 0, CLK_SET_RATE_GATE);
+
+	clk = clk_reg_prcmu_scalable("dsi1clk", "dsi_pll",
+				PRCMU_DSI1CLK, 0, CLK_SET_RATE_GATE);
+
+	clk = clk_reg_prcmu_scalable("dsi0escclk", "tvclk",
+				PRCMU_DSI0ESCCLK, 0, CLK_SET_RATE_GATE);
+
+	clk = clk_reg_prcmu_scalable("dsi1escclk", "tvclk",
+				PRCMU_DSI1ESCCLK, 0, CLK_SET_RATE_GATE);
+
+	clk = clk_reg_prcmu_scalable("dsi2escclk", "tvclk",
+				PRCMU_DSI2ESCCLK, 0, CLK_SET_RATE_GATE);
+
+	clk = clk_reg_prcmu_scalable_rate("armss", NULL,
+				PRCMU_ARMSS, 0, CLK_IS_ROOT|CLK_IGNORE_UNUSED);
+
+	clk = clk_register_fixed_factor(NULL, "smp_twd", "armss",
+				CLK_IGNORE_UNUSED, 1, 2);
+
+	/*
+	 * FIXME: Add special handled PRCMU clocks here:
+	 * 1. clkout0yuv, use PRCMU as parent + need regulator + pinctrl.
+	 * 2. ab9540_clkout1yuv, see clkout0yuv
+	 */
+
+	/* PRCC P-clocks */
+	clk = clk_reg_prcc_pclk("p1_pclk0", "per1clk", clkrst1_base,
+				BIT(0), 0);
+
+	clk = clk_reg_prcc_pclk("p1_pclk1", "per1clk", clkrst1_base,
+				BIT(1), 0);
+
+	clk = clk_reg_prcc_pclk("p1_pclk2", "per1clk", clkrst1_base,
+				BIT(2), 0);
+
+	clk = clk_reg_prcc_pclk("p1_pclk3", "per1clk", clkrst1_base,
+				BIT(3), 0);
+
+	clk = clk_reg_prcc_pclk("p1_pclk4", "per1clk", clkrst1_base,
+				BIT(4), 0);
+
+	clk = clk_reg_prcc_pclk("p1_pclk5", "per1clk", clkrst1_base,
+				BIT(5), 0);
+
+	clk = clk_reg_prcc_pclk("p1_pclk6", "per1clk", clkrst1_base,
+				BIT(6), 0);
+
+	clk = clk_reg_prcc_pclk("p1_pclk7", "per1clk", clkrst1_base,
+				BIT(7), 0);
+
+	clk = clk_reg_prcc_pclk("p1_pclk8", "per1clk", clkrst1_base,
+				BIT(8), 0);
+
+	clk = clk_reg_prcc_pclk("p1_pclk9", "per1clk", clkrst1_base,
+				BIT(9), 0);
+
+	clk = clk_reg_prcc_pclk("p1_pclk10", "per1clk", clkrst1_base,
+				BIT(10), 0);
+
+	clk = clk_reg_prcc_pclk("p1_pclk11", "per1clk", clkrst1_base,
+				BIT(11), 0);
+
+	clk = clk_reg_prcc_pclk("p2_pclk0", "per2clk", clkrst2_base,
+				BIT(0), 0);
+
+	clk = clk_reg_prcc_pclk("p2_pclk1", "per2clk", clkrst2_base,
+				BIT(1), 0);
+
+	clk = clk_reg_prcc_pclk("p2_pclk2", "per2clk", clkrst2_base,
+				BIT(2), 0);
+
+	clk = clk_reg_prcc_pclk("p2_pclk3", "per2clk", clkrst2_base,
+				BIT(3), 0);
+
+	clk = clk_reg_prcc_pclk("p2_pclk4", "per2clk", clkrst2_base,
+				BIT(4), 0);
+
+	clk = clk_reg_prcc_pclk("p2_pclk5", "per2clk", clkrst2_base,
+				BIT(5), 0);
+
+	clk = clk_reg_prcc_pclk("p2_pclk6", "per2clk", clkrst2_base,
+				BIT(6), 0);
+
+	clk = clk_reg_prcc_pclk("p2_pclk7", "per2clk", clkrst2_base,
+				BIT(7), 0);
+
+	clk = clk_reg_prcc_pclk("p2_pclk8", "per2clk", clkrst2_base,
+				BIT(8), 0);
+
+	clk = clk_reg_prcc_pclk("p2_pclk9", "per2clk", clkrst2_base,
+				BIT(9), 0);
+
+	clk = clk_reg_prcc_pclk("p2_pclk10", "per2clk", clkrst2_base,
+				BIT(10), 0);
+
+	clk = clk_reg_prcc_pclk("p2_pclk11", "per2clk", clkrst2_base,
+				BIT(11), 0);
+
+	clk = clk_reg_prcc_pclk("p2_pclk12", "per2clk", clkrst2_base,
+				BIT(12), 0);
+
+	clk = clk_reg_prcc_pclk("p3_pclk0", "per3clk", clkrst3_base,
+				BIT(0), 0);
+
+	clk = clk_reg_prcc_pclk("p3_pclk1", "per3clk", clkrst3_base,
+				BIT(1), 0);
+
+	clk = clk_reg_prcc_pclk("p3_pclk2", "per3clk", clkrst3_base,
+				BIT(2), 0);
+
+	clk = clk_reg_prcc_pclk("p3_pclk3", "per3clk", clkrst3_base,
+				BIT(3), 0);
+
+	clk = clk_reg_prcc_pclk("p3_pclk4", "per3clk", clkrst3_base,
+				BIT(4), 0);
+
+	clk = clk_reg_prcc_pclk("p3_pclk5", "per3clk", clkrst3_base,
+				BIT(5), 0);
+
+	clk = clk_reg_prcc_pclk("p3_pclk6", "per3clk", clkrst3_base,
+				BIT(6), 0);
+
+	clk = clk_reg_prcc_pclk("p3_pclk7", "per3clk", clkrst3_base,
+				BIT(7), 0);
+
+	clk = clk_reg_prcc_pclk("p3_pclk8", "per3clk", clkrst3_base,
+				BIT(8), 0);
+
+	clk = clk_reg_prcc_pclk("p5_pclk0", "per5clk", clkrst5_base,
+				BIT(0), 0);
+
+	clk = clk_reg_prcc_pclk("p5_pclk1", "per5clk", clkrst5_base,
+				BIT(1), 0);
+
+	clk = clk_reg_prcc_pclk("p6_pclk0", "per6clk", clkrst6_base,
+				BIT(0), 0);
+
+	clk = clk_reg_prcc_pclk("p6_pclk1", "per6clk", clkrst6_base,
+				BIT(1), 0);
+
+	clk = clk_reg_prcc_pclk("p6_pclk2", "per6clk", clkrst6_base,
+				BIT(2), 0);
+
+	clk = clk_reg_prcc_pclk("p6_pclk3", "per6clk", clkrst6_base,
+				BIT(3), 0);
+
+	clk = clk_reg_prcc_pclk("p6_pclk4", "per6clk", clkrst6_base,
+				BIT(4), 0);
+
+	clk = clk_reg_prcc_pclk("p6_pclk5", "per6clk", clkrst6_base,
+				BIT(5), 0);
+
+	clk = clk_reg_prcc_pclk("p6_pclk6", "per6clk", clkrst6_base,
+				BIT(6), 0);
+
+	clk = clk_reg_prcc_pclk("p6_pclk7", "per6clk", clkrst6_base,
+				BIT(7), 0);
+
+	/* PRCC K-clocks
+	 *
+	 * FIXME: Some drivers requires PERPIH[n| to be automatically enabled
+	 * by enabling just the K-clock, even if it is not a valid parent to
+	 * the K-clock. Until drivers get fixed we might need some kind of
+	 * "parent muxed join".
+	 */
+
+	/* Periph1 */
+	clk = clk_reg_prcc_kclk("p1_uart0_kclk", "uartclk",
+			clkrst1_base, BIT(0), CLK_SET_RATE_GATE);
+
+	clk = clk_reg_prcc_kclk("p1_uart1_kclk", "uartclk",
+			clkrst1_base, BIT(1), CLK_SET_RATE_GATE);
+
+	clk = clk_reg_prcc_kclk("p1_i2c1_kclk", "i2cclk",
+			clkrst1_base, BIT(2), CLK_SET_RATE_GATE);
+
+	clk = clk_reg_prcc_kclk("p1_msp0_kclk", "msp02clk",
+			clkrst1_base, BIT(3), CLK_SET_RATE_GATE);
+
+	clk = clk_reg_prcc_kclk("p1_msp1_kclk", "msp1clk",
+			clkrst1_base, BIT(4), CLK_SET_RATE_GATE);
+
+	clk = clk_reg_prcc_kclk("p1_sdi0_kclk", "sdmmcclk",
+			clkrst1_base, BIT(5), CLK_SET_RATE_GATE);
+
+	clk = clk_reg_prcc_kclk("p1_i2c2_kclk", "i2cclk",
+			clkrst1_base, BIT(6), CLK_SET_RATE_GATE);
+
+	clk = clk_reg_prcc_kclk("p1_slimbus0_kclk", "slimclk",
+			clkrst1_base, BIT(8), CLK_SET_RATE_GATE);
+
+	clk = clk_reg_prcc_kclk("p1_i2c4_kclk", "i2cclk",
+			clkrst1_base, BIT(9), CLK_SET_RATE_GATE);
+
+	clk = clk_reg_prcc_kclk("p1_msp3_kclk", "msp1clk",
+			clkrst1_base, BIT(10), CLK_SET_RATE_GATE);
+
+	/* Periph2 */
+	clk = clk_reg_prcc_kclk("p2_i2c3_kclk", "i2cclk",
+			clkrst2_base, BIT(0), CLK_SET_RATE_GATE);
+
+	clk = clk_reg_prcc_kclk("p2_sdi4_kclk", "sdmmcclk",
+			clkrst2_base, BIT(2), CLK_SET_RATE_GATE);
+
+	clk = clk_reg_prcc_kclk("p2_msp2_kclk", "msp02clk",
+			clkrst2_base, BIT(3), CLK_SET_RATE_GATE);
+
+	clk = clk_reg_prcc_kclk("p2_sdi1_kclk", "sdmmcclk",
+			clkrst2_base, BIT(4), CLK_SET_RATE_GATE);
+
+	clk = clk_reg_prcc_kclk("p2_sdi3_kclk", "sdmmcclk",
+			clkrst2_base, BIT(5), CLK_SET_RATE_GATE);
+
+	/* Note that rate is received from parent. */
+	clk = clk_reg_prcc_kclk("p2_ssirx_kclk", "hsirxclk",
+			clkrst2_base, BIT(6),
+			CLK_SET_RATE_GATE|CLK_SET_RATE_PARENT);
+	clk = clk_reg_prcc_kclk("p2_ssitx_kclk", "hsitxclk",
+			clkrst2_base, BIT(7),
+			CLK_SET_RATE_GATE|CLK_SET_RATE_PARENT);
+
+	/* Periph3 */
+	clk = clk_reg_prcc_kclk("p3_ssp0_kclk", "sspclk",
+			clkrst3_base, BIT(1), CLK_SET_RATE_GATE);
+
+	clk = clk_reg_prcc_kclk("p3_ssp1_kclk", "sspclk",
+			clkrst3_base, BIT(2), CLK_SET_RATE_GATE);
+
+	clk = clk_reg_prcc_kclk("p3_i2c0_kclk", "i2cclk",
+			clkrst3_base, BIT(3), CLK_SET_RATE_GATE);
+
+	clk = clk_reg_prcc_kclk("p3_sdi2_kclk", "sdmmcclk",
+			clkrst3_base, BIT(4), CLK_SET_RATE_GATE);
+
+	clk = clk_reg_prcc_kclk("p3_ske_kclk", "rtc32k",
+			clkrst3_base, BIT(5), CLK_SET_RATE_GATE);
+
+	clk = clk_reg_prcc_kclk("p3_uart2_kclk", "uartclk",
+			clkrst3_base, BIT(6), CLK_SET_RATE_GATE);
+
+	clk = clk_reg_prcc_kclk("p3_sdi5_kclk", "sdmmcclk",
+			clkrst3_base, BIT(7), CLK_SET_RATE_GATE);
+
+	/* Periph6 */
+	clk = clk_reg_prcc_kclk("p3_rng_kclk", "rngclk",
+			clkrst6_base, BIT(0), CLK_SET_RATE_GATE);
+}
diff --git a/include/linux/platform_data/clk-ux500.h b/include/linux/platform_data/clk-ux500.h
index 9d98f3a..97baf83 100644
--- a/include/linux/platform_data/clk-ux500.h
+++ b/include/linux/platform_data/clk-ux500.h
@@ -10,6 +10,9 @@
 #ifndef __CLK_UX500_H
 #define __CLK_UX500_H
 
+void u8500_of_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
+		       u32 clkrst5_base, u32 clkrst6_base);
+
 void u8500_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
 		    u32 clkrst5_base, u32 clkrst6_base);
 void u9540_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
-- 
1.8.1.2

