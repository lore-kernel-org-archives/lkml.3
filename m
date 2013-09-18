Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab3IRRyf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 13:54:35 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:50806 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab3IRRyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 13:54:16 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 16/26] ARM: mxs: remove custom .init_time hook
Date: Wed, 18 Sep 2013 19:53:49 +0200
Message-Id: <1379526839-14798-17-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts clk-imx2[38] clocksource_of_init compatible init
associated with fsl,imx2[38]-clkctrl. With arch/arm calling
of_clk_init(NULL) from time_init(), we can now also remove custom
.init_time hooks.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Acked-by: Mike Turquette <mturquette@linaro.org>
---
Changelog:
RFCv2->v1:
- do not reuse device_node for digctl (Reported by Shawn Guo)

Cc: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-mxs/mach-mxs.c |   13 -------------
 drivers/clk/mxs/clk-imx23.c  |   15 ++++++++-------
 drivers/clk/mxs/clk-imx28.c  |   16 ++++++++--------
 include/linux/clk/mxs.h      |    2 --
 4 files changed, 16 insertions(+), 30 deletions(-)

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
index c396fe3..9fc9359 100644
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
@@ -100,16 +101,16 @@ static enum imx23_clk clks_init_on[] __initdata = {
 	cpu, hbus, xbus, emi, uart,
 };
 
-int __init mx23_clocks_init(void)
+static void __init mx23_clocks_init(struct device_node *np)
 {
-	struct device_node *np;
+	struct device_node *dcnp;
 	u32 i;
 
-	np = of_find_compatible_node(NULL, NULL, "fsl,imx23-digctl");
-	digctrl = of_iomap(np, 0);
+	dcnp = of_find_compatible_node(NULL, NULL, "fsl,imx23-digctl");
+	digctrl = of_iomap(dcnp, 0);
 	WARN_ON(!digctrl);
+	of_node_put(dcnp);
 
-	np = of_find_compatible_node(NULL, NULL, "fsl,imx23-clkctrl");
 	clkctrl = of_iomap(np, 0);
 	WARN_ON(!clkctrl);
 
@@ -162,7 +163,7 @@ int __init mx23_clocks_init(void)
 		if (IS_ERR(clks[i])) {
 			pr_err("i.MX23 clk %d: register failed with %ld\n",
 				i, PTR_ERR(clks[i]));
-			return PTR_ERR(clks[i]);
+			return;
 		}
 
 	clk_data.clks = clks;
@@ -172,5 +173,5 @@ int __init mx23_clocks_init(void)
 	for (i = 0; i < ARRAY_SIZE(clks_init_on); i++)
 		clk_prepare_enable(clks[clks_init_on[i]]);
 
-	return 0;
 }
+CLK_OF_DECLARE(imx23_clkctrl, "fsl,imx23-clkctrl", mx23_clocks_init);
diff --git a/drivers/clk/mxs/clk-imx28.c b/drivers/clk/mxs/clk-imx28.c
index 4faf0af..a6c3501 100644
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
@@ -154,16 +155,16 @@ static enum imx28_clk clks_init_on[] __initdata = {
 	cpu, hbus, xbus, emi, uart,
 };
 
-int __init mx28_clocks_init(void)
+static void __init mx28_clocks_init(struct device_node *np)
 {
-	struct device_node *np;
+	struct device_node *dcnp;
 	u32 i;
 
-	np = of_find_compatible_node(NULL, NULL, "fsl,imx28-digctl");
-	digctrl = of_iomap(np, 0);
+	dcnp = of_find_compatible_node(NULL, NULL, "fsl,imx28-digctl");
+	digctrl = of_iomap(dcnp, 0);
 	WARN_ON(!digctrl);
+	of_node_put(dcnp);
 
-	np = of_find_compatible_node(NULL, NULL, "fsl,imx28-clkctrl");
 	clkctrl = of_iomap(np, 0);
 	WARN_ON(!clkctrl);
 
@@ -239,7 +240,7 @@ int __init mx28_clocks_init(void)
 		if (IS_ERR(clks[i])) {
 			pr_err("i.MX28 clk %d: register failed with %ld\n",
 				i, PTR_ERR(clks[i]));
-			return PTR_ERR(clks[i]);
+			return;
 		}
 
 	clk_data.clks = clks;
@@ -250,6 +251,5 @@ int __init mx28_clocks_init(void)
 
 	for (i = 0; i < ARRAY_SIZE(clks_init_on); i++)
 		clk_prepare_enable(clks[clks_init_on[i]]);
-
-	return 0;
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

