Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab3HTCHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:07:10 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:42322 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab3HTCEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:04:38 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 09/17] ARM: mxs: remove custom .init_time hook
Date: Tue, 20 Aug 2013 04:04:23 +0200
Message-Id: <1376964271-22715-10-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With arch/arm calling of_clk_init(NULL) from time_init(), we can now
remove custom .init_time hooks.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Notes:
- clk-imx2[38] are converted to clocksource_of_init compatible init
  associated with fsl,imx2[38]-clkctrl

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-mxs/mach-mxs.c |   13 -------------
 drivers/clk/mxs/clk-imx23.c  |   16 +++++++---------
 drivers/clk/mxs/clk-imx28.c  |   16 ++++++++--------
 include/linux/clk/mxs.h      |    2 --
 4 files changed, 15 insertions(+), 32 deletions(-)

diff --git a/arch/arm/mach-mxs/mach-mxs.c b/arch/arm/mach-mxs/mach-mxs.c
index 98f6e2a..cc511a4 100644
--- a/arch/arm/mach-mxs/mach-mxs.c
+++ b/arch/arm/mach-mxs/mach-mxs.c
@@ -13,8 +13,6 @@
 #include <linux/clk.h>
 #include <linux/clk/mxs.h>
 #include <linux/clkdev.h>
-#include <linux/clocksource.h>
-#include <linux/clk-provider.h>
 #include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/gpio.h>
@@ -490,16 +488,6 @@ static void mxs_restart(enum reboot_mode mode, const char *cmd)
 	soft_restart(0);
 }
 
-static void __init mxs_timer_init(void)
-{
-	if (of_machine_is_compatible("fsl,imx23"))
-		mx23_clocks_init();
-	else
-		mx28_clocks_init();
-	of_clk_init(NULL);
-	clocksource_of_init();
-}
-
 static const char *mxs_dt_compat[] __initdata = {
 	"fsl,imx28",
 	"fsl,imx23",
@@ -508,7 +496,6 @@ static const char *mxs_dt_compat[] __initdata = {
 
 DT_MACHINE_START(MXS, "Freescale MXS (Device Tree)")
 	.handle_irq	= icoll_handle_irq,
-	.init_time	= mxs_timer_init,
 	.init_machine	= mxs_machine_init,
 	.init_late      = mxs_pm_init,
 	.dt_compat	= mxs_dt_compat,
diff --git a/drivers/clk/mxs/clk-imx23.c b/drivers/clk/mxs/clk-imx23.c
index c396fe3..7c2794d 100644
--- a/drivers/clk/mxs/clk-imx23.c
+++ b/drivers/clk/mxs/clk-imx23.c
@@ -12,6 +12,7 @@
 #include <linux/clk.h>
 #include <linux/clk/mxs.h>
 #include <linux/clkdev.h>
+#include <linux/clk-provider.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/io.h>
@@ -100,19 +101,17 @@ static enum imx23_clk clks_init_on[] __initdata = {
 	cpu, hbus, xbus, emi, uart,
 };
 
-int __init mx23_clocks_init(void)
+void __init mx23_clocks_init(struct device_node *np)
 {
-	struct device_node *np;
 	u32 i;
 
+	clkctrl = of_iomap(np, 0);
+	WARN_ON(!clkctrl);
+
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx23-digctl");
 	digctrl = of_iomap(np, 0);
 	WARN_ON(!digctrl);
 
-	np = of_find_compatible_node(NULL, NULL, "fsl,imx23-clkctrl");
-	clkctrl = of_iomap(np, 0);
-	WARN_ON(!clkctrl);
-
 	clk_misc_init();
 
 	clks[ref_xtal] = mxs_clk_fixed("ref_xtal", 24000000);
@@ -162,7 +161,7 @@ int __init mx23_clocks_init(void)
 		if (IS_ERR(clks[i])) {
 			pr_err("i.MX23 clk %d: register failed with %ld\n",
 				i, PTR_ERR(clks[i]));
-			return PTR_ERR(clks[i]);
+			return;
 		}
 
 	clk_data.clks = clks;
@@ -171,6 +170,5 @@ int __init mx23_clocks_init(void)
 
 	for (i = 0; i < ARRAY_SIZE(clks_init_on); i++)
 		clk_prepare_enable(clks[clks_init_on[i]]);
-
-	return 0;
 }
+CLK_OF_DECLARE(imx23_clkctrl, "fsl,imx23-clkctrl", mx23_clocks_init);
diff --git a/drivers/clk/mxs/clk-imx28.c b/drivers/clk/mxs/clk-imx28.c
index 4faf0af..5627fa2 100644
--- a/drivers/clk/mxs/clk-imx28.c
+++ b/drivers/clk/mxs/clk-imx28.c
@@ -12,6 +12,7 @@
 #include <linux/clk.h>
 #include <linux/clk/mxs.h>
 #include <linux/clkdev.h>
+#include <linux/clk-provider.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/io.h>
@@ -154,19 +155,17 @@ static enum imx28_clk clks_init_on[] __initdata = {
 	cpu, hbus, xbus, emi, uart,
 };
 
-int __init mx28_clocks_init(void)
+void __init mx28_clocks_init(struct device_node *np)
 {
-	struct device_node *np;
 	u32 i;
 
+	clkctrl = of_iomap(np, 0);
+	WARN_ON(!clkctrl);
+
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx28-digctl");
 	digctrl = of_iomap(np, 0);
 	WARN_ON(!digctrl);
 
-	np = of_find_compatible_node(NULL, NULL, "fsl,imx28-clkctrl");
-	clkctrl = of_iomap(np, 0);
-	WARN_ON(!clkctrl);
-
 	clk_misc_init();
 
 	clks[ref_xtal] = mxs_clk_fixed("ref_xtal", 24000000);
@@ -239,7 +238,7 @@ int __init mx28_clocks_init(void)
 		if (IS_ERR(clks[i])) {
 			pr_err("i.MX28 clk %d: register failed with %ld\n",
 				i, PTR_ERR(clks[i]));
-			return PTR_ERR(clks[i]);
+			return;
 		}
 
 	clk_data.clks = clks;
@@ -251,5 +250,6 @@ int __init mx28_clocks_init(void)
 	for (i = 0; i < ARRAY_SIZE(clks_init_on); i++)
 		clk_prepare_enable(clks[clks_init_on[i]]);
 
-	return 0;
+	return;
 }
+CLK_OF_DECLARE(imx28_clkctrl, "fsl,imx28-clkctrl", mx28_clocks_init);
diff --git a/include/linux/clk/mxs.h b/include/linux/clk/mxs.h
index 90c30dc..5138a90 100644
--- a/include/linux/clk/mxs.h
+++ b/include/linux/clk/mxs.h
@@ -9,8 +9,6 @@
 #ifndef __LINUX_CLK_MXS_H
 #define __LINUX_CLK_MXS_H
 
-int mx23_clocks_init(void);
-int mx28_clocks_init(void);
 int mxs_saif_clkmux_select(unsigned int clkmux);
 
 #endif
-- 
1.7.10.4

