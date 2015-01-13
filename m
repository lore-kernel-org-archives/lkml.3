Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbbAMWzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 17:55:46 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:52526 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751409AbbAMWz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 17:55:26 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/NkFHfNtQNTKJHUt5uhkmE
From: Tony Lindgren <tony@atomide.com>
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Brian Hutchinson <b.hutchman@gmail.com>,
        Paul Walmsley <paul@pwsan.com>, Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 2/2] clk: ti: Initialize clocks for dm816x
Date: Tue, 13 Jan 2015 14:51:28 -0800
Message-Id: <1421189488-9657-3-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421189488-9657-1-git-send-email-tony@atomide.com>
References: <1421189488-9657-1-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clocks on ti81xx are not compatible with omap3. On dm816x
the clock source is a FAPLL (Flying Adder PLL), and on dm814x
there seems to be an APLL (All Digital PLL).

Let's fix up things for dm816x in preparation for adding the
FAPLL support. As we already have a dummy ti81xx_dt_clk_init()
in place, let's use that for now to avoid adding a dependency
to the omap patches.

Later on if somebody adds dm814x support we can split the
ti81xx_dt_clk_init() clock init function as needed.

Cc: Brian Hutchinson <b.hutchman@gmail.com>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Tero Kristo <t-kristo@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/clk/ti/Makefile   |  2 +-
 drivers/clk/ti/clk-3xxx.c |  8 +------
 drivers/clk/ti/clk-816x.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+), 8 deletions(-)
 create mode 100644 drivers/clk/ti/clk-816x.c

diff --git a/drivers/clk/ti/Makefile b/drivers/clk/ti/Makefile
index e55438c..36acc7d 100644
--- a/drivers/clk/ti/Makefile
+++ b/drivers/clk/ti/Makefile
@@ -3,7 +3,7 @@ obj-y					+= clk.o autoidle.o clockdomain.o
 clk-common				= dpll.o composite.o divider.o gate.o \
 					  fixed-factor.o mux.o apll.o
 obj-$(CONFIG_SOC_AM33XX)		+= $(clk-common) clk-33xx.o
-obj-$(CONFIG_SOC_TI81XX)		+= $(clk-common) fapll.o
+obj-$(CONFIG_SOC_TI81XX)		+= $(clk-common) fapll.o clk-816x.o
 obj-$(CONFIG_ARCH_OMAP2)		+= $(clk-common) interface.o clk-2xxx.o
 obj-$(CONFIG_ARCH_OMAP3)		+= $(clk-common) interface.o clk-3xxx.o
 obj-$(CONFIG_ARCH_OMAP4)		+= $(clk-common) clk-44xx.o
diff --git a/drivers/clk/ti/clk-3xxx.c b/drivers/clk/ti/clk-3xxx.c
index 0d1750a..383a06e 100644
--- a/drivers/clk/ti/clk-3xxx.c
+++ b/drivers/clk/ti/clk-3xxx.c
@@ -327,7 +327,6 @@ enum {
 	OMAP3_SOC_OMAP3430_ES1,
 	OMAP3_SOC_OMAP3430_ES2_PLUS,
 	OMAP3_SOC_OMAP3630,
-	OMAP3_SOC_TI81XX,
 };
 
 static int __init omap3xxx_dt_clk_init(int soc_type)
@@ -370,7 +369,7 @@ static int __init omap3xxx_dt_clk_init(int soc_type)
 		(clk_get_rate(clk_get_sys(NULL, "core_ck")) / 1000000),
 		(clk_get_rate(clk_get_sys(NULL, "arm_fck")) / 1000000));
 
-	if (soc_type != OMAP3_SOC_TI81XX && soc_type != OMAP3_SOC_OMAP3430_ES1)
+	if (soc_type != OMAP3_SOC_OMAP3430_ES1)
 		omap3_clk_lock_dpll5();
 
 	return 0;
@@ -390,8 +389,3 @@ int __init am35xx_dt_clk_init(void)
 {
 	return omap3xxx_dt_clk_init(OMAP3_SOC_AM35XX);
 }
-
-int __init ti81xx_dt_clk_init(void)
-{
-	return omap3xxx_dt_clk_init(OMAP3_SOC_TI81XX);
-}
diff --git a/drivers/clk/ti/clk-816x.c b/drivers/clk/ti/clk-816x.c
new file mode 100644
index 0000000..9451e65
--- /dev/null
+++ b/drivers/clk/ti/clk-816x.c
@@ -0,0 +1,53 @@
+/*
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/clk-provider.h>
+#include <linux/clk/ti.h>
+
+static struct ti_dt_clk dm816x_clks[] = {
+	DT_CLK(NULL, "sys_clkin", "sys_clkin_ck"),
+	DT_CLK(NULL, "timer_sys_ck", "sys_clkin_ck"),
+	DT_CLK(NULL, "sys_32k_ck", "sys_32k_ck"),
+	DT_CLK(NULL, "mpu_ck", "mpu_ck"),
+	DT_CLK(NULL, "timer1_fck", "timer1_fck"),
+	DT_CLK(NULL, "timer2_fck", "timer2_fck"),
+	DT_CLK(NULL, "timer3_fck", "timer3_fck"),
+	DT_CLK(NULL, "timer4_fck", "timer4_fck"),
+	DT_CLK(NULL, "timer5_fck", "timer5_fck"),
+	DT_CLK(NULL, "timer6_fck", "timer6_fck"),
+	DT_CLK(NULL, "timer7_fck", "timer7_fck"),
+	DT_CLK(NULL, "sysclk4_ck", "sysclk4_ck"),
+	DT_CLK(NULL, "sysclk5_ck", "sysclk5_ck"),
+	DT_CLK(NULL, "sysclk6_ck", "sysclk6_ck"),
+	DT_CLK(NULL, "sysclk10_ck", "sysclk10_ck"),
+	DT_CLK(NULL, "sysclk18_ck", "sysclk18_ck"),
+	DT_CLK(NULL, "sysclk24_ck", "sysclk24_ck"),
+	DT_CLK("4a100000.ethernet", "sysclk24_ck", "sysclk24_ck"),
+	{ .node_name = NULL },
+};
+
+static const char *enable_init_clks[] = {
+	"ddr_pll_clk1",
+	"ddr_pll_clk2",
+	"ddr_pll_clk3",
+};
+
+int __init ti81xx_dt_clk_init(void)
+{
+	ti_dt_clocks_register(dm816x_clks);
+	omap2_clk_disable_autoidle_all();
+	omap2_clk_enable_init_clocks(enable_init_clks,
+				     ARRAY_SIZE(enable_init_clks));
+
+	return 0;
+}
-- 
2.1.4

