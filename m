Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab3H0V2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 17:28:30 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:61343 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab3H0V21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 17:28:27 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC v2 13/16] ARM: tegra: split tegra_pmc_init() in two
Date: Tue, 27 Aug 2013 23:28:07 +0200
Message-Id: <1377638890-371-14-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Tegra's board file currently initializes clocks much earlier than those
for most other ARM SoCs. The reason is:

* The PMC HW block is involved in the path of some interrupts (i.e. it
inverts, or not, the IRQ input pin dedicated to the PMIC).

* So, that part of the PMC must be initialized early so that the IRQ
polarity is correct.

* The PMC initialization is currently monolithic, and the PMC has some
clock inputs, so the init routine ends up calling of_clk_get_by_name(),
and hence clocks must be set up early too.

In order to defer clock initialization to the more typical location,
split out the portions of tegra_pmc_init() that are truly IRQ-related
into a separate tegra_pmc_init_irq(), which can be called from the
machine descriptor's .init_irq() function, and defer the rest until
the machine descriptor's .init_machine() function. With arch/arm calling
of_clk_init(NULL) from time_init() this also allows the removal of
.init_time() hook.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
Changelog:
v1->v2:
- took Stephen Warren's patch provided to separate Tegra's pmc_init
- sqashed in .init_time removal and reworded patch text

Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-tegra/common.c |    4 +---
 arch/arm/mach-tegra/pmc.c    |   41 ++++++++++++++++++++++-------------------
 arch/arm/mach-tegra/pmc.h    |    1 +
 arch/arm/mach-tegra/tegra.c  |    5 +++--
 4 files changed, 27 insertions(+), 24 deletions(-)

diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
index 94a119a..58dc91c5 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -24,7 +24,6 @@
 #include <linux/delay.h>
 #include <linux/reboot.h>
 #include <linux/irqchip.h>
-#include <linux/clk-provider.h>
 
 #include <asm/hardware/cache-l2x0.h>
 
@@ -61,8 +60,7 @@ u32 tegra_uart_config[4] = {
 #ifdef CONFIG_OF
 void __init tegra_dt_init_irq(void)
 {
-	of_clk_init(NULL);
-	tegra_pmc_init();
+	tegra_pmc_init_irq();
 	tegra_init_irq();
 	irqchip_init();
 	tegra_legacy_irq_syscore_init();
diff --git a/arch/arm/mach-tegra/pmc.c b/arch/arm/mach-tegra/pmc.c
index 8acb881..7916ff9 100644
--- a/arch/arm/mach-tegra/pmc.c
+++ b/arch/arm/mach-tegra/pmc.c
@@ -285,13 +285,10 @@ static const struct of_device_id matches[] __initconst = {
 	{ }
 };
 
-static void __init tegra_pmc_parse_dt(void)
+void __init tegra_pmc_init_irq(void)
 {
 	struct device_node *np;
-	u32 prop;
-	enum tegra_suspend_mode suspend_mode;
-	u32 core_good_time[2] = {0, 0};
-	u32 lp0_vec[2] = {0, 0};
+	u32 val;
 
 	np = of_find_matching_node(NULL, matches);
 	BUG_ON(!np);
@@ -300,6 +297,26 @@ static void __init tegra_pmc_parse_dt(void)
 
 	tegra_pmc_invert_interrupt = of_property_read_bool(np,
 				     "nvidia,invert-interrupt");
+
+	val = tegra_pmc_readl(PMC_CTRL);
+	if (tegra_pmc_invert_interrupt)
+		val |= PMC_CTRL_INTR_LOW;
+	else
+		val &= ~PMC_CTRL_INTR_LOW;
+	tegra_pmc_writel(val, PMC_CTRL);
+}
+
+void __init tegra_pmc_init(void)
+{
+	struct device_node *np;
+	u32 prop;
+	enum tegra_suspend_mode suspend_mode;
+	u32 core_good_time[2] = {0, 0};
+	u32 lp0_vec[2] = {0, 0};
+
+	np = of_find_matching_node(NULL, matches);
+	BUG_ON(!np);
+
 	tegra_pclk = of_clk_get_by_name(np, "pclk");
 	WARN_ON(IS_ERR(tegra_pclk));
 
@@ -365,17 +382,3 @@ static void __init tegra_pmc_parse_dt(void)
 
 	pmc_pm_data.suspend_mode = suspend_mode;
 }
-
-void __init tegra_pmc_init(void)
-{
-	u32 val;
-
-	tegra_pmc_parse_dt();
-
-	val = tegra_pmc_readl(PMC_CTRL);
-	if (tegra_pmc_invert_interrupt)
-		val |= PMC_CTRL_INTR_LOW;
-	else
-		val &= ~PMC_CTRL_INTR_LOW;
-	tegra_pmc_writel(val, PMC_CTRL);
-}
diff --git a/arch/arm/mach-tegra/pmc.h b/arch/arm/mach-tegra/pmc.h
index 549f8c7..4d5f8f3 100644
--- a/arch/arm/mach-tegra/pmc.h
+++ b/arch/arm/mach-tegra/pmc.h
@@ -39,6 +39,7 @@ bool tegra_pmc_cpu_is_powered(int cpuid);
 int tegra_pmc_cpu_power_on(int cpuid);
 int tegra_pmc_cpu_remove_clamping(int cpuid);
 
+void tegra_pmc_init_irq(void);
 void tegra_pmc_init(void);
 
 #endif
diff --git a/arch/arm/mach-tegra/tegra.c b/arch/arm/mach-tegra/tegra.c
index 5b86055..2e21928 100644
--- a/arch/arm/mach-tegra/tegra.c
+++ b/arch/arm/mach-tegra/tegra.c
@@ -16,7 +16,6 @@
  *
  */
 
-#include <linux/clocksource.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
@@ -44,6 +43,7 @@
 #include "common.h"
 #include "fuse.h"
 #include "iomap.h"
+#include "pmc.h"
 
 static void __init tegra_dt_init(void)
 {
@@ -51,6 +51,8 @@ static void __init tegra_dt_init(void)
 	struct soc_device *soc_dev;
 	struct device *parent = NULL;
 
+	tegra_pmc_init();
+
 	tegra_clocks_apply_init_table();
 
 	soc_dev_attr = kzalloc(sizeof(*soc_dev_attr), GFP_KERNEL);
@@ -119,7 +121,6 @@ DT_MACHINE_START(TEGRA_DT, "NVIDIA Tegra SoC (Flattened Device Tree)")
 	.smp		= smp_ops(tegra_smp_ops),
 	.init_early	= tegra_init_early,
 	.init_irq	= tegra_dt_init_irq,
-	.init_time	= clocksource_of_init,
 	.init_machine	= tegra_dt_init,
 	.init_late	= tegra_dt_init_late,
 	.restart	= tegra_assert_system_reset,
-- 
1.7.2.5

