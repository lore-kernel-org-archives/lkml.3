Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab3HTCIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:08:52 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:53734 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab3HTCEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:04:37 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <rob.herring@calxeda.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFC 05/17] ARM: highbank: remove custom .init_time hook
Date: Tue, 20 Aug 2013 04:04:19 +0200
Message-Id: <1376964271-22715-6-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With arch/arm calling of_clk_init(NULL) from time_init(), we can now
remove custom .init_time hooks. Highbank clock provider need a reference
to system registers, as a workaround current clk driver maps those
independent of arch code now.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Notes:
- I suggest to consolidate the four single clock providers into a single
  provider with one node if possible.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-highbank/highbank.c |   23 +++++++----------------
 drivers/clk/clk-highbank.c        |   10 +++++++---
 2 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/arch/arm/mach-highbank/highbank.c b/arch/arm/mach-highbank/highbank.c
index 1894dcf..efa9496 100644
--- a/arch/arm/mach-highbank/highbank.c
+++ b/arch/arm/mach-highbank/highbank.c
@@ -27,7 +27,6 @@
 #include <linux/of_address.h>
 #include <linux/smp.h>
 #include <linux/amba/bus.h>
-#include <linux/clk-provider.h>
 
 #include <asm/cacheflush.h>
 #include <asm/cputype.h>
@@ -88,20 +87,6 @@ static void __init highbank_init_irq(void)
 #endif
 }
 
-static void __init highbank_timer_init(void)
-{
-	struct device_node *np;
-
-	/* Map system registers */
-	np = of_find_compatible_node(NULL, NULL, "calxeda,hb-sregs");
-	sregs_base = of_iomap(np, 0);
-	WARN_ON(!sregs_base);
-
-	of_clk_init(NULL);
-
-	clocksource_of_init();
-}
-
 static void highbank_power_off(void)
 {
 	highbank_set_pwr_shutdown();
@@ -160,6 +145,13 @@ static struct notifier_block highbank_platform_nb = {
 
 static void __init highbank_init(void)
 {
+	struct device_node *np;
+
+	/* Map system registers */
+	np = of_find_compatible_node(NULL, NULL, "calxeda,hb-sregs");
+	sregs_base = of_iomap(np, 0);
+	WARN_ON(!sregs_base);
+
 	pm_power_off = highbank_power_off;
 	highbank_pm_init();
 
@@ -181,7 +173,6 @@ DT_MACHINE_START(HIGHBANK, "Highbank")
 #endif
 	.smp		= smp_ops(highbank_smp_ops),
 	.init_irq	= highbank_init_irq,
-	.init_time	= highbank_timer_init,
 	.init_machine	= highbank_init,
 	.dt_compat	= highbank_match,
 	.restart	= highbank_restart,
diff --git a/drivers/clk/clk-highbank.c b/drivers/clk/clk-highbank.c
index 2e08cb0..2e7e9d9 100644
--- a/drivers/clk/clk-highbank.c
+++ b/drivers/clk/clk-highbank.c
@@ -20,8 +20,7 @@
 #include <linux/clk-provider.h>
 #include <linux/io.h>
 #include <linux/of.h>
-
-extern void __iomem *sregs_base;
+#include <linux/of_address.h>
 
 #define HB_PLL_LOCK_500		0x20000000
 #define HB_PLL_LOCK		0x10000000
@@ -280,6 +279,7 @@ static __init struct clk *hb_clk_init(struct device_node *node, const struct clk
 	const char *clk_name = node->name;
 	const char *parent_name;
 	struct clk_init_data init;
+	struct device_node *srnp;
 	int rc;
 
 	rc = of_property_read_u32(node, "reg", &reg);
@@ -290,7 +290,11 @@ static __init struct clk *hb_clk_init(struct device_node *node, const struct clk
 	if (WARN_ON(!hb_clk))
 		return NULL;
 
-	hb_clk->reg = sregs_base + reg;
+	/* Map system registers */
+	srnp = of_find_compatible_node(NULL, NULL, "calxeda,hb-sregs");
+	hb_clk->reg = of_iomap(srnp, 0);
+	BUG_ON(!hb_clk->reg);
+	hb_clk->reg += reg;
 
 	of_property_read_string(node, "clock-output-names", &clk_name);
 
-- 
1.7.10.4

