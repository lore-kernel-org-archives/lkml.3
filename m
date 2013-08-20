Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab3HTCHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:07:15 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:32947 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab3HTCEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:04:38 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFC 06/17] ARM: imx: remove custom .init_time hook
Date: Tue, 20 Aug 2013 04:04:20 +0200
Message-Id: <1376964271-22715-7-git-send-email-sebastian.hesselbarth@gmail.com>
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
- Although mx5_clocks_common_init() is shared with non-DT, removing
  of_clk_init(NULL) should be fine, as it only registers DT clk providers.
- For imx6q, printing of silicon revision has been moved from .init_time
  to .init_machine hook.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-imx/clk-imx51-imx53.c |   12 ------------
 arch/arm/mach-imx/common.h          |    2 --
 arch/arm/mach-imx/imx51-dt.c        |    6 ------
 arch/arm/mach-imx/mach-imx53.c      |    6 ------
 arch/arm/mach-imx/mach-imx6q.c      |   14 +++-----------
 arch/arm/mach-imx/mach-imx6sl.c     |    7 -------
 arch/arm/mach-imx/mach-vf610.c      |    9 ---------
 7 files changed, 3 insertions(+), 53 deletions(-)

diff --git a/arch/arm/mach-imx/clk-imx51-imx53.c b/arch/arm/mach-imx/clk-imx51-imx53.c
index 1a56a33..5955a54 100644
--- a/arch/arm/mach-imx/clk-imx51-imx53.c
+++ b/arch/arm/mach-imx/clk-imx51-imx53.c
@@ -131,8 +131,6 @@ static void __init mx5_clocks_common_init(unsigned long rate_ckil,
 {
 	int i;
 
-	of_clk_init(NULL);
-
 	clk[dummy] = imx_clk_fixed("dummy", 0);
 	clk[ckil] = imx_obtain_fixed_clock("ckil", rate_ckil);
 	clk[osc] = imx_obtain_fixed_clock("osc", rate_osc);
@@ -569,13 +567,3 @@ int __init mx53_clocks_init(unsigned long rate_ckil, unsigned long rate_osc,
 
 	return 0;
 }
-
-int __init mx51_clocks_init_dt(void)
-{
-	return mx51_clocks_init(0, 0, 0, 0);
-}
-
-int __init mx53_clocks_init_dt(void)
-{
-	return mx53_clocks_init(0, 0, 0, 0);
-}
diff --git a/arch/arm/mach-imx/common.h b/arch/arm/mach-imx/common.h
index 4517fd7..0ce8313 100644
--- a/arch/arm/mach-imx/common.h
+++ b/arch/arm/mach-imx/common.h
@@ -68,8 +68,6 @@ extern int mx53_clocks_init(unsigned long ckil, unsigned long osc,
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

