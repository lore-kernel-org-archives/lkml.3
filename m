Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966025AbaFSVw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:52:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:55821 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965749AbaFSVwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:52:25 -0400
Message-Id: <20140619215140.348974921@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 19 Jun 2014 21:52:24 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Viresh Kumar <viresh.linux@gmail.com>,
        Mike Turquette <mturquette@linaro.org>, spear-devel@list.st.com
Subject: [patch 2/2] clk: spear3xx: Set proper clock parent of uart1/2 
References: <20140619214858.755664030@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=spear-clk-force-ras-apb-for-uart12.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The uarts only work when the parent is ras_ahb_clk. The stale 3.5
based ST tree does this in the board file.

Add it to the clk init function. Not pretty, but the mess there is
amazing anyway.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/clk/spear/spear3xx_clock.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

Index: linux/drivers/clk/spear/spear3xx_clock.c
===================================================================
--- linux.orig/drivers/clk/spear/spear3xx_clock.c
+++ linux/drivers/clk/spear/spear3xx_clock.c
@@ -245,7 +245,8 @@ static const char *smii0_parents[] = { "
 	"ras_syn0_gclk", };
 static const char *uartx_parents[] = { "ras_syn1_gclk", "ras_apb_clk", };
 
-static void __init spear320_clk_init(void __iomem *soc_config_base)
+static void __init spear320_clk_init(void __iomem *soc_config_base,
+				     struct clk *ras_apb_clk)
 {
 	struct clk *clk;
 
@@ -342,6 +343,8 @@ static void __init spear320_clk_init(voi
 			SPEAR320_CONTROL_REG, UART1_PCLK_SHIFT, UART1_PCLK_MASK,
 			0, &_lock);
 	clk_register_clkdev(clk, NULL, "a3000000.serial");
+	/* Enforce ras_apb_clk */
+	clk_set_parent(clk, ras_apb_clk);
 
 	clk = clk_register_mux(NULL, "uart2_clk", uartx_parents,
 			ARRAY_SIZE(uartx_parents),
@@ -349,6 +352,8 @@ static void __init spear320_clk_init(voi
 			SPEAR320_EXT_CTRL_REG, SPEAR320_UART2_PCLK_SHIFT,
 			SPEAR320_UARTX_PCLK_MASK, 0, &_lock);
 	clk_register_clkdev(clk, NULL, "a4000000.serial");
+	/* Enforce ras_apb_clk */
+	clk_set_parent(clk, ras_apb_clk);
 
 	clk = clk_register_mux(NULL, "uart3_clk", uartx_parents,
 			ARRAY_SIZE(uartx_parents),
@@ -379,12 +384,12 @@ static void __init spear320_clk_init(voi
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
@@ -613,6 +618,7 @@ void __init spear3xx_clk_init(void __iom
 	clk = clk_register_gate(NULL, "ras_apb_clk", "apb_clk", 0, RAS_CLK_ENB,
 			RAS_APB_CLK_ENB, 0, &_lock);
 	clk_register_clkdev(clk, "ras_apb_clk", NULL);
+	ras_apb_clk = clk;
 
 	clk = clk_register_gate(NULL, "ras_32k_clk", "osc_32k_clk", 0,
 			RAS_CLK_ENB, RAS_32K_CLK_ENB, 0, &_lock);
@@ -659,5 +665,5 @@ void __init spear3xx_clk_init(void __iom
 	else if (of_machine_is_compatible("st,spear310"))
 		spear310_clk_init();
 	else if (of_machine_is_compatible("st,spear320"))
-		spear320_clk_init(soc_config_base);
+		spear320_clk_init(soc_config_base, ras_apb_clk);
 }


