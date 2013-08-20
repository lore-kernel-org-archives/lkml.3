Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751265Ab3HTJXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 05:23:48 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:47614 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab3HTJXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 05:23:46 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFC v2] ARM: imx: remove custom .init_time hook
Date: Tue, 20 Aug 2013 11:23:50 +0200
Message-Id: <1376990630-29491-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376964271-22715-7-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376964271-22715-7-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With arch/arm calling of_clk_init(NULL) from time_init(), we can now
remove custom .init_time hooks.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Notes:
- Although mx5_clocks_common_init() is shared with non-DT, removing
  of_clk_init(NULL) should be fine, as it only registers DT clk providers.
- For imx6q, printing of silicon revision has been moved from .init_time
  to .init_machine hook.

Changelog:
v1->v2:
- added missing CLK_OF_DECLARE for imx51 and imx53 (Reported by Sascha Hauer)
  mx53_clocks_init can be converted as it is used DT only, mx51_clocks_init
  still is used by non-DT.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-imx/clk-imx51-imx53.c |   29 ++++++++++-------------------
 arch/arm/mach-imx/common.h          |    4 ----
 arch/arm/mach-imx/imx51-dt.c        |    6 ------
 arch/arm/mach-imx/mach-imx53.c      |    6 ------
 arch/arm/mach-imx/mach-imx6q.c      |   14 +++-----------
 arch/arm/mach-imx/mach-imx6sl.c     |    7 -------
 arch/arm/mach-imx/mach-vf610.c      |    9 ---------
 7 files changed, 13 insertions(+), 62 deletions(-)

diff --git a/arch/arm/mach-imx/clk-imx51-imx53.c b/arch/arm/mach-imx/clk-imx51-imx53.c
index 1a56a33..1b796db 100644
--- a/arch/arm/mach-imx/clk-imx51-imx53.c
+++ b/arch/arm/mach-imx/clk-imx51-imx53.c
@@ -11,6 +11,7 @@
 #include <linux/clk.h>
 #include <linux/io.h>
 #include <linux/clkdev.h>
+#include <linux/clk-provider.h>
 #include <linux/of.h>
 #include <linux/err.h>
 
@@ -131,8 +132,6 @@ static void __init mx5_clocks_common_init(unsigned long rate_ckil,
 {
 	int i;
 
-	of_clk_init(NULL);
-
 	clk[dummy] = imx_clk_fixed("dummy", 0);
 	clk[ckil] = imx_obtain_fixed_clock("ckil", rate_ckil);
 	clk[osc] = imx_obtain_fixed_clock("osc", rate_osc);
@@ -465,12 +464,16 @@ int __init mx51_clocks_init(unsigned long rate_ckil, unsigned long rate_osc,
 	return 0;
 }
 
-int __init mx53_clocks_init(unsigned long rate_ckil, unsigned long rate_osc,
-			unsigned long rate_ckih1, unsigned long rate_ckih2)
+static void __init mx51_clocks_init_dt(struct device_node *np)
+{
+	mx51_clocks_init(0, 0, 0, 0);
+}
+CLK_OF_DECLARE(imx51_ccm, "fsl,imx51-ccm", mx51_clocks_init_dt);
+
+static void __init mx53_clocks_init(struct device_node *np)
 {
 	int i;
 	unsigned long r;
-	struct device_node *np;
 
 	clk[pll1_sw] = imx_clk_pllv2("pll1_sw", "osc", MX53_DPLL1_BASE);
 	clk[pll2_sw] = imx_clk_pllv2("pll2_sw", "osc", MX53_DPLL2_BASE);
@@ -529,12 +532,11 @@ int __init mx53_clocks_init(unsigned long rate_ckil, unsigned long rate_osc,
 			pr_err("i.MX53 clk %d: register failed with %ld\n",
 				i, PTR_ERR(clk[i]));
 
-	np = of_find_compatible_node(NULL, NULL, "fsl,imx53-ccm");
 	clk_data.clks = clk;
 	clk_data.clk_num = ARRAY_SIZE(clk);
 	of_clk_add_provider(np, of_clk_src_onecell_get, &clk_data);
 
-	mx5_clocks_common_init(rate_ckil, rate_osc, rate_ckih1, rate_ckih2);
+	mx5_clocks_common_init(0, 0, 0, 0);
 
 	clk_register_clkdev(clk[vpu_gate], NULL, "imx53-vpu.0");
 	clk_register_clkdev(clk[i2c3_gate], NULL, "imx21-i2c.2");
@@ -566,16 +568,5 @@ int __init mx53_clocks_init(unsigned long rate_ckil, unsigned long rate_osc,
 
 	r = clk_round_rate(clk[usboh3_per_gate], 54000000);
 	clk_set_rate(clk[usboh3_per_gate], r);
-
-	return 0;
-}
-
-int __init mx51_clocks_init_dt(void)
-{
-	return mx51_clocks_init(0, 0, 0, 0);
-}
-
-int __init mx53_clocks_init_dt(void)
-{
-	return mx53_clocks_init(0, 0, 0, 0);
 }
+CLK_OF_DECLARE(imx53_ccm, "fsl,imx53-ccm", mx53_clocks_init);
diff --git a/arch/arm/mach-imx/common.h b/arch/arm/mach-imx/common.h
index 4517fd7..28e8ca0 100644
--- a/arch/arm/mach-imx/common.h
+++ b/arch/arm/mach-imx/common.h
@@ -63,13 +63,9 @@ extern int mx31_clocks_init(unsigned long fref);
 extern int mx35_clocks_init(void);
 extern int mx51_clocks_init(unsigned long ckil, unsigned long osc,
 			unsigned long ckih1, unsigned long ckih2);
-extern int mx53_clocks_init(unsigned long ckil, unsigned long osc,
-			unsigned long ckih1, unsigned long ckih2);
 extern int mx25_clocks_init_dt(void);
 extern int mx27_clocks_init_dt(void);
 extern int mx31_clocks_init_dt(void);
-extern int mx51_clocks_init_dt(void);
-extern int mx53_clocks_init_dt(void);
 extern struct platform_device *mxc_register_gpio(char *name, int id,
 	resource_size_t iobase, resource_size_t iosize, int irq, int irq_high);
 extern void mxc_set_cpu_type(unsigned int type);
diff --git a/arch/arm/mach-imx/imx51-dt.c b/arch/arm/mach-imx/imx51-dt.c
index 53e43e5..bece8a6 100644
--- a/arch/arm/mach-imx/imx51-dt.c
+++ b/arch/arm/mach-imx/imx51-dt.c
@@ -34,17 +34,11 @@ static const char *imx51_dt_board_compat[] __initdata = {
 	NULL
 };
 
-static void __init imx51_timer_init(void)
-{
-	mx51_clocks_init_dt();
-}
-
 DT_MACHINE_START(IMX51_DT, "Freescale i.MX51 (Device Tree Support)")
 	.map_io		= mx51_map_io,
 	.init_early	= imx51_init_early,
 	.init_irq	= mx51_init_irq,
 	.handle_irq	= imx51_handle_irq,
-	.init_time	= imx51_timer_init,
 	.init_machine	= imx51_dt_init,
 	.init_late	= imx51_init_late,
 	.dt_compat	= imx51_dt_board_compat,
diff --git a/arch/arm/mach-imx/mach-imx53.c b/arch/arm/mach-imx/mach-imx53.c
index 98c5894..c9c4d8d 100644
--- a/arch/arm/mach-imx/mach-imx53.c
+++ b/arch/arm/mach-imx/mach-imx53.c
@@ -36,17 +36,11 @@ static const char *imx53_dt_board_compat[] __initdata = {
 	NULL
 };
 
-static void __init imx53_timer_init(void)
-{
-	mx53_clocks_init_dt();
-}
-
 DT_MACHINE_START(IMX53_DT, "Freescale i.MX53 (Device Tree Support)")
 	.map_io		= mx53_map_io,
 	.init_early	= imx53_init_early,
 	.init_irq	= mx53_init_irq,
 	.handle_irq	= imx53_handle_irq,
-	.init_time	= imx53_timer_init,
 	.init_machine	= imx53_dt_init,
 	.init_late	= imx53_init_late,
 	.dt_compat	= imx53_dt_board_compat,
diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
index b605098..ad71738 100644
--- a/arch/arm/mach-imx/mach-imx6q.c
+++ b/arch/arm/mach-imx/mach-imx6q.c
@@ -11,9 +11,7 @@
  */
 
 #include <linux/clk.h>
-#include <linux/clk-provider.h>
 #include <linux/clkdev.h>
-#include <linux/clocksource.h>
 #include <linux/cpu.h>
 #include <linux/delay.h>
 #include <linux/export.h>
@@ -192,6 +190,9 @@ static void __init imx6q_1588_init(void)
 
 static void __init imx6q_init_machine(void)
 {
+	imx_print_silicon_rev(cpu_is_imx6dl() ? "i.MX6DL" : "i.MX6Q",
+			      imx6q_revision());
+
 	imx6q_enet_phy_init();
 
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
@@ -289,14 +290,6 @@ static void __init imx6q_init_irq(void)
 	irqchip_init();
 }
 
-static void __init imx6q_timer_init(void)
-{
-	of_clk_init(NULL);
-	clocksource_of_init();
-	imx_print_silicon_rev(cpu_is_imx6dl() ? "i.MX6DL" : "i.MX6Q",
-			      imx6q_revision());
-}
-
 static const char *imx6q_dt_compat[] __initdata = {
 	"fsl,imx6dl",
 	"fsl,imx6q",
@@ -307,7 +300,6 @@ DT_MACHINE_START(IMX6Q, "Freescale i.MX6 Quad/DualLite (Device Tree)")
 	.smp		= smp_ops(imx_smp_ops),
 	.map_io		= imx6q_map_io,
 	.init_irq	= imx6q_init_irq,
-	.init_time	= imx6q_timer_init,
 	.init_machine	= imx6q_init_machine,
 	.init_late      = imx6q_init_late,
 	.dt_compat	= imx6q_dt_compat,
diff --git a/arch/arm/mach-imx/mach-imx6sl.c b/arch/arm/mach-imx/mach-imx6sl.c
index 0d75dc5..c70bd7c 100644
--- a/arch/arm/mach-imx/mach-imx6sl.c
+++ b/arch/arm/mach-imx/mach-imx6sl.c
@@ -7,7 +7,6 @@
  *
  */
 
-#include <linux/clk-provider.h>
 #include <linux/irqchip.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
@@ -31,11 +30,6 @@ static void __init imx6sl_init_irq(void)
 	irqchip_init();
 }
 
-static void __init imx6sl_timer_init(void)
-{
-	of_clk_init(NULL);
-}
-
 static const char *imx6sl_dt_compat[] __initdata = {
 	"fsl,imx6sl",
 	NULL,
@@ -44,7 +38,6 @@ static const char *imx6sl_dt_compat[] __initdata = {
 DT_MACHINE_START(IMX6SL, "Freescale i.MX6 SoloLite (Device Tree)")
 	.map_io		= debug_ll_io_init,
 	.init_irq	= imx6sl_init_irq,
-	.init_time	= imx6sl_timer_init,
 	.init_machine	= imx6sl_init_machine,
 	.dt_compat	= imx6sl_dt_compat,
 	.restart	= mxc_restart,
diff --git a/arch/arm/mach-imx/mach-vf610.c b/arch/arm/mach-imx/mach-vf610.c
index 816991d..af0cb8a 100644
--- a/arch/arm/mach-imx/mach-vf610.c
+++ b/arch/arm/mach-imx/mach-vf610.c
@@ -8,9 +8,7 @@
  */
 
 #include <linux/of_platform.h>
-#include <linux/clocksource.h>
 #include <linux/irqchip.h>
-#include <linux/clk-provider.h>
 #include <asm/mach/arch.h>
 #include <asm/hardware/cache-l2x0.h>
 
@@ -28,12 +26,6 @@ static void __init vf610_init_irq(void)
 	irqchip_init();
 }
 
-static void __init vf610_init_time(void)
-{
-	of_clk_init(NULL);
-	clocksource_of_init();
-}
-
 static const char *vf610_dt_compat[] __initdata = {
 	"fsl,vf610",
 	NULL,
@@ -41,7 +33,6 @@ static const char *vf610_dt_compat[] __initdata = {
 
 DT_MACHINE_START(VYBRID_VF610, "Freescale Vybrid VF610 (Device Tree)")
 	.init_irq	= vf610_init_irq,
-	.init_time	= vf610_init_time,
 	.init_machine   = vf610_init_machine,
 	.dt_compat	= vf610_dt_compat,
 	.restart	= mxc_restart,
-- 
1.7.10.4

