Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab3FFNw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 09:52:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:40939 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab3FFNw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 09:52:56 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Paul Walmsley <paul@pwsan.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Philip Avinash <avinashphilip@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 1/4] ARM: AM33XX: clk: Add clock node for EHRPWM TBCLK
Date: Thu,  6 Jun 2013 15:52:36 +0200
Message-Id: <1370526759-31163-2-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370526759-31163-1-git-send-email-bigeasy@linutronix.de>
References: <1370526759-31163-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip Avinash <avinashphilip@ti.com>

EHRPWM module requires explicit clock gating of TBCLK from control
module. Hence add TBCLK clock node in clock tree for EHRPWM modules.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
[bigeasy: remove CK_AM33XX]
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/arm/mach-omap2/cclock33xx_data.c |   30 ++++++++++++++++++++++++++++++
 arch/arm/mach-omap2/control.h         |    8 ++++++++
 2 files changed, 38 insertions(+)

diff --git a/arch/arm/mach-omap2/cclock33xx_data.c b/arch/arm/mach-omap2/cclock33xx_data.c
index af3544c..0346de5 100644
--- a/arch/arm/mach-omap2/cclock33xx_data.c
+++ b/arch/arm/mach-omap2/cclock33xx_data.c
@@ -862,6 +862,33 @@ static struct clk_hw_omap wdt1_fck_hw = {
 
 DEFINE_STRUCT_CLK(wdt1_fck, wdt_ck_parents, gpio_fck_ops);
 
+static const char *pwmss_clk_parents[] = {
+	"dpll_per_m2_ck",
+};
+
+static const struct clk_ops ehrpwm_tbclk_ops = {
+	.enable		= &omap2_dflt_clk_enable,
+	.disable	= &omap2_dflt_clk_disable,
+};
+
+DEFINE_CLK_OMAP_MUX_GATE(ehrpwm0_tbclk, "l4ls_clkdm",
+			 NULL, NULL, 0,
+			 AM33XX_CTRL_REGADDR(AM33XX_PWMSS_TBCLK_CLKCTRL),
+			 AM33XX_PWMSS0_TBCLKEN_SHIFT,
+			 NULL, pwmss_clk_parents, ehrpwm_tbclk_ops);
+
+DEFINE_CLK_OMAP_MUX_GATE(ehrpwm1_tbclk, "l4ls_clkdm",
+			 NULL, NULL, 0,
+			 AM33XX_CTRL_REGADDR(AM33XX_PWMSS_TBCLK_CLKCTRL),
+			 AM33XX_PWMSS1_TBCLKEN_SHIFT,
+			 NULL, pwmss_clk_parents, ehrpwm_tbclk_ops);
+
+DEFINE_CLK_OMAP_MUX_GATE(ehrpwm2_tbclk, "l4ls_clkdm",
+			 NULL, NULL, 0,
+			 AM33XX_CTRL_REGADDR(AM33XX_PWMSS_TBCLK_CLKCTRL),
+			 AM33XX_PWMSS2_TBCLKEN_SHIFT,
+			 NULL, pwmss_clk_parents, ehrpwm_tbclk_ops);
+
 /*
  * clkdev
  */
@@ -942,6 +969,9 @@ static struct omap_clk am33xx_clks[] = {
 	CLK(NULL,	"clkout2_div_ck",	&clkout2_div_ck),
 	CLK(NULL,	"timer_32k_ck",		&clkdiv32k_ick),
 	CLK(NULL,	"timer_sys_ck",		&sys_clkin_ck),
+	CLK("48300200.ehrpwm",	"tbclk",	&ehrpwm0_tbclk),
+	CLK("48302200.ehrpwm",	"tbclk",	&ehrpwm1_tbclk),
+	CLK("48304200.ehrpwm",	"tbclk",	&ehrpwm2_tbclk),
 };
 
 
diff --git a/arch/arm/mach-omap2/control.h b/arch/arm/mach-omap2/control.h
index e6c3281..35d17a6 100644
--- a/arch/arm/mach-omap2/control.h
+++ b/arch/arm/mach-omap2/control.h
@@ -358,6 +358,14 @@
 #define AM33XX_CONTROL_STATUS_SYSBOOT1_WIDTH		0x2
 #define AM33XX_CONTROL_STATUS_SYSBOOT1_MASK		(0x3 << 22)
 
+/* AM33XX PWMSS Control register */
+#define AM33XX_PWMSS_TBCLK_CLKCTRL			0x664
+
+/* AM33XX  PWMSS Control bitfields */
+#define AM33XX_PWMSS0_TBCLKEN_SHIFT			0
+#define AM33XX_PWMSS1_TBCLKEN_SHIFT			1
+#define AM33XX_PWMSS2_TBCLKEN_SHIFT			2
+
 /* CONTROL OMAP STATUS register to identify OMAP3 features */
 #define OMAP3_CONTROL_OMAP_STATUS	0x044c
 
-- 
1.7.10.4

