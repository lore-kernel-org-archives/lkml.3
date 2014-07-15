Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbaGORF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:05:58 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:65498 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756039AbaGORCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:23 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 88/94] clk: spear3xx: Set proper clock parent of uart1/2
Date: Tue, 15 Jul 2014 20:01:43 +0300
Message-Id: <1405443709-15288-88-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

The uarts only work when the parent is ras_ahb_clk. The stale 3.5
based ST tree does this in the board file.

Add it to the clk init function. Not pretty, but the mess there is
amazing anyway.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Mike Turquette <mturquette@linaro.org>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 drivers/clk/spear/spear3xx_clock.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/spear/spear3xx_clock.c b/drivers/clk/spear/spear3xx_clock.c
index 125eba8..bb5f387 100644
--- a/drivers/clk/spear/spear3xx_clock.c
+++ b/drivers/clk/spear/spear3xx_clock.c
@@ -245,7 +245,8 @@ static const char *smii0_parents[] = { "smii_125m_pad", "ras_pll2_clk",
 	"ras_syn0_gclk", };
 static const char *uartx_parents[] = { "ras_syn1_gclk", "ras_apb_clk", };
 
-static void __init spear320_clk_init(void __iomem *soc_config_base)
+static void __init spear320_clk_init(void __iomem *soc_config_base,
+				     struct clk *ras_apb_clk)
 {
 	struct clk *clk;
 
@@ -342,6 +343,8 @@ static void __init spear320_clk_init(void __iomem *soc_config_base)
 			SPEAR320_CONTROL_REG, UART1_PCLK_SHIFT, UART1_PCLK_MASK,
 			0, &_lock);
 	clk_register_clkdev(clk, NULL, "a3000000.serial");
+	/* Enforce ras_apb_clk */
+	clk_set_parent(clk, ras_apb_clk);
 
 	clk = clk_register_mux(NULL, "uart2_clk", uartx_parents,
 			ARRAY_SIZE(uartx_parents),
@@ -349,6 +352,8 @@ static void __init spear320_clk_init(void __iomem *soc_config_base)
 			SPEAR320_EXT_CTRL_REG, SPEAR320_UART2_PCLK_SHIFT,
 			SPEAR320_UARTX_PCLK_MASK, 0, &_lock);
 	clk_register_clkdev(clk, NULL, "a4000000.serial");
+	/* Enforce ras_apb_clk */
+	clk_set_parent(clk, ras_apb_clk);
 
 	clk = clk_register_mux(NULL, "uart3_clk", uartx_parents,
 			ARRAY_SIZE(uartx_parents),
@@ -379,12 +384,12 @@ static void __init spear320_clk_init(void __iomem *soc_config_base)
 	clk_register_clkdev(clk, NULL, "60100000.serial");
 }
 #else
-static inline void spear320_clk_init(void __iomem *soc_config_base) { }
+static inline void spear320_clk_init(void __iomem *sb, struct clk *rc) { }
 #endif
 
 void __init spear3xx_clk_init(void __iomem *misc_base, void __iomem *soc_config_base)
 {
-	struct clk *clk, *clk1;
+	struct clk *clk, *clk1, *ras_apb_clk;
 
 	clk = clk_register_fixed_rate(NULL, "osc_32k_clk", NULL, CLK_IS_ROOT,
 			32000);
@@ -613,6 +618,7 @@ void __init spear3xx_clk_init(void __iomem *misc_base, void __iomem *soc_config_
 	clk = clk_register_gate(NULL, "ras_apb_clk", "apb_clk", 0, RAS_CLK_ENB,
 			RAS_APB_CLK_ENB, 0, &_lock);
 	clk_register_clkdev(clk, "ras_apb_clk", NULL);
+	ras_apb_clk = clk;
 
 	clk = clk_register_gate(NULL, "ras_32k_clk", "osc_32k_clk", 0,
 			RAS_CLK_ENB, RAS_32K_CLK_ENB, 0, &_lock);
@@ -659,5 +665,5 @@ void __init spear3xx_clk_init(void __iomem *misc_base, void __iomem *soc_config_
 	else if (of_machine_is_compatible("st,spear310"))
 		spear310_clk_init();
 	else if (of_machine_is_compatible("st,spear320"))
-		spear320_clk_init(soc_config_base);
+		spear320_clk_init(soc_config_base, ras_apb_clk);
 }
-- 
1.7.10.4

