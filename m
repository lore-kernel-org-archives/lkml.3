Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab3IRRyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 13:54:16 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:44805 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab3IRRyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 13:54:11 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Barry Song <baohua.song@csr.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 04/26] clk: prima2: declare OF clock provider
Date: Wed, 18 Sep 2013 19:53:37 +0200
Message-Id: <1379526839-14798-5-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Common clock framework allows to register clock providers to get called
on of_clk_init() by using CLK_OF_DECLARE. This converts prima2 clock
provider to make use of it and get rid of the mach specific clk init
call.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Barry Song <baohua.song@csr.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-prima2/common.c |    4 ++--
 arch/arm/mach-prima2/common.h |    1 -
 drivers/clk/clk-prima2.c      |   29 ++++++-----------------------
 3 files changed, 8 insertions(+), 26 deletions(-)

diff --git a/arch/arm/mach-prima2/common.c b/arch/arm/mach-prima2/common.c
index e110b6d..9b7663d 100644
--- a/arch/arm/mach-prima2/common.c
+++ b/arch/arm/mach-prima2/common.c
@@ -6,6 +6,7 @@
  * Licensed under GPLv2 or later.
  */
 
+#include <linux/clk-provider.h>
 #include <linux/clocksource.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -23,8 +24,7 @@ void __init sirfsoc_init_late(void)
 
 static __init void sirfsoc_init_time(void)
 {
-	/* initialize clocking early, we want to set the OS timer */
-	sirfsoc_of_clk_init();
+	of_clk_init(NULL);
 	clocksource_of_init();
 }
 
diff --git a/arch/arm/mach-prima2/common.h b/arch/arm/mach-prima2/common.h
index a630485..4b76806 100644
--- a/arch/arm/mach-prima2/common.h
+++ b/arch/arm/mach-prima2/common.h
@@ -23,7 +23,6 @@ extern void sirfsoc_secondary_startup(void);
 extern void sirfsoc_cpu_die(unsigned int cpu);
 
 extern void __init sirfsoc_of_irq_init(void);
-extern void __init sirfsoc_of_clk_init(void);
 extern void sirfsoc_restart(enum reboot_mode, const char *);
 extern asmlinkage void __exception_irq_entry sirfsoc_handle_irq(struct pt_regs *regs);
 
diff --git a/drivers/clk/clk-prima2.c b/drivers/clk/clk-prima2.c
index 5ab95f1..6c15e33 100644
--- a/drivers/clk/clk-prima2.c
+++ b/drivers/clk/clk-prima2.c
@@ -1015,16 +1015,6 @@ static struct clk_std clk_usb1 = {
 	},
 };
 
-static struct of_device_id clkc_ids[] = {
-	{ .compatible = "sirf,prima2-clkc" },
-	{},
-};
-
-static struct of_device_id rsc_ids[] = {
-	{ .compatible = "sirf,prima2-rsc" },
-	{},
-};
-
 enum prima2_clk_index {
 	/* 0    1     2      3      4      5      6       7         8      9 */
 	rtc,    osc,   pll1,  pll2,  pll3,  mem,   sys,   security, dsp,   gps,
@@ -1082,24 +1072,16 @@ static struct clk_hw *prima2_clk_hw_array[maxclk] __initdata = {
 static struct clk *prima2_clks[maxclk];
 static struct clk_onecell_data clk_data;
 
-void __init sirfsoc_of_clk_init(void)
+static void __init sirfsoc_clk_init(struct device_node *np)
 {
-	struct device_node *np;
+	struct device_node *rscnp;
 	int i;
 
-	np = of_find_matching_node(NULL, rsc_ids);
-	if (!np)
-		panic("unable to find compatible rsc node in dtb\n");
-
-	sirfsoc_rsc_vbase = of_iomap(np, 0);
+	rscnp = of_find_compatible_node(NULL, NULL, "sirf,prima2-rsc");
+	sirfsoc_rsc_vbase = of_iomap(rscnp, 0);
 	if (!sirfsoc_rsc_vbase)
 		panic("unable to map rsc registers\n");
-
-	of_node_put(np);
-
-	np = of_find_matching_node(NULL, clkc_ids);
-	if (!np)
-		return;
+	of_node_put(rscnp);
 
 	sirfsoc_clk_vbase = of_iomap(np, 0);
 	if (!sirfsoc_clk_vbase)
@@ -1124,3 +1106,4 @@ void __init sirfsoc_of_clk_init(void)
 
 	of_clk_add_provider(np, of_clk_src_onecell_get, &clk_data);
 }
+CLK_OF_DECLARE(sirfsoc_clk, "sirf,prima2-clkc", sirfsoc_clk_init);
-- 
1.7.10.4

