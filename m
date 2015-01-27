Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759340AbbA0SJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:09:00 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:10737 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932346AbbA0SI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:08:58 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, Arnd Bergmann <arnd@arndb.de>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 6/7] ARM: at91: remove at91_dt_initialize and machine init_early()
Date: Tue, 27 Jan 2015 19:07:25 +0100
Message-ID: <9ee9bbd1a860fc308395a47ddb4c11cccda2ac41.1422381280.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <cover.1422381280.git.nicolas.ferre@atmel.com>
References: <cover.1422381280.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Move the ramc initialization to pm.c as it is the only user left.
This allows us to get rid of at91_dt_initialize() that was the only one called
by the init_early() function pointer of struct machine_desc.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
[nicolas.ferre@atmel.com: adapt patch to newer series]
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/at91rm9200.c |  1 -
 arch/arm/mach-at91/at91sam9.c   |  3 ---
 arch/arm/mach-at91/generic.h    |  3 ---
 arch/arm/mach-at91/pm.c         | 44 ++++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-at91/sama5.c      |  2 --
 arch/arm/mach-at91/setup.c      | 45 -----------------------------------------
 6 files changed, 44 insertions(+), 54 deletions(-)

diff --git a/arch/arm/mach-at91/at91rm9200.c b/arch/arm/mach-at91/at91rm9200.c
index ec89806c9d5d..49ae3d455bd5 100644
--- a/arch/arm/mach-at91/at91rm9200.c
+++ b/arch/arm/mach-at91/at91rm9200.c
@@ -62,7 +62,6 @@ static const char *at91rm9200_dt_board_compat[] __initconst = {
 DT_MACHINE_START(at91rm9200_dt, "Atmel AT91RM9200 (Device Tree)")
 	.init_time      = at91rm9200_dt_timer_init,
 	.map_io		= at91_map_io,
-	.init_early	= at91_dt_initialize,
 	.init_machine	= rm9200_dt_device_init,
 	.dt_compat	= at91rm9200_dt_board_compat,
 MACHINE_END
diff --git a/arch/arm/mach-at91/at91sam9.c b/arch/arm/mach-at91/at91sam9.c
index 04a9af79aadb..ecbe535c2ce0 100644
--- a/arch/arm/mach-at91/at91sam9.c
+++ b/arch/arm/mach-at91/at91sam9.c
@@ -41,7 +41,6 @@ static const char *at91_dt_board_compat[] __initconst = {
 DT_MACHINE_START(at91sam_dt, "Atmel AT91SAM (Device Tree)")
 	/* Maintainer: Atmel */
 	.map_io		= at91_map_io,
-	.init_early	= at91_dt_initialize,
 	.init_machine	= sam9_dt_device_init,
 	.dt_compat	= at91_dt_board_compat,
 MACHINE_END
@@ -62,7 +61,6 @@ static const char *at91_9g45_board_compat[] __initconst = {
 DT_MACHINE_START(at91sam9g45_dt, "Atmel AT91SAM9G45")
 	/* Maintainer: Atmel */
 	.map_io		= at91_map_io,
-	.init_early	= at91_dt_initialize,
 	.init_machine	= sam9g45_dt_device_init,
 	.dt_compat	= at91_9g45_board_compat,
 MACHINE_END
@@ -84,7 +82,6 @@ static const char *at91_9x5_board_compat[] __initconst = {
 DT_MACHINE_START(at91sam9x5_dt, "Atmel AT91SAM9")
 	/* Maintainer: Atmel */
 	.map_io		= at91_map_io,
-	.init_early	= at91_dt_initialize,
 	.init_machine	= sam9x5_dt_device_init,
 	.dt_compat	= at91_9x5_board_compat,
 MACHINE_END
diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
index a8ee83ef6cd4..9c6e5b9f87ff 100644
--- a/arch/arm/mach-at91/generic.h
+++ b/arch/arm/mach-at91/generic.h
@@ -18,9 +18,6 @@
 extern void __init at91_map_io(void);
 extern void __init at91_alt_map_io(void);
 
- /* Processors */
-extern void __init at91_dt_initialize(void);
-
  /* Timer */
 extern void at91rm9200_timer_init(void);
 
diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 87c1fd8aa1b6..25bb93db8208 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -20,6 +20,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
+#include <linux/of_address.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/clk/at91_pmc.h>
@@ -41,6 +42,7 @@ static struct {
 } at91_pm_data;
 
 static void (*at91_pm_standby)(void);
+void __iomem *at91_ramc_base[2];
 
 static int at91_pm_valid_state(suspend_state_t state)
 {
@@ -224,6 +226,43 @@ void at91_pm_set_standby(void (*at91_standby)(void))
 	}
 }
 
+static struct of_device_id ramc_ids[] = {
+	{ .compatible = "atmel,at91rm9200-sdramc", .data = at91rm9200_standby },
+	{ .compatible = "atmel,at91sam9260-sdramc", .data = at91sam9_sdram_standby },
+	{ .compatible = "atmel,at91sam9g45-ddramc", .data = at91_ddr_standby },
+	{ .compatible = "atmel,sama5d3-ddramc", .data = at91_ddr_standby },
+	{ /*sentinel*/ }
+};
+
+static void at91_dt_ramc(void)
+{
+	struct device_node *np;
+	const struct of_device_id *of_id;
+	int idx = 0;
+	const void *standby = NULL;
+
+	for_each_matching_node_and_match(np, ramc_ids, &of_id) {
+		at91_ramc_base[idx] = of_iomap(np, 0);
+		if (!at91_ramc_base[idx])
+			panic(pr_fmt("unable to map ramc[%d] cpu registers\n"), idx);
+
+		if (!standby)
+			standby = of_id->data;
+
+		idx++;
+	}
+
+	if (!idx)
+		panic(pr_fmt("unable to find compatible ram controller node in dtb\n"));
+
+	if (!standby) {
+		pr_warn("ramc no standby function available\n");
+		return;
+	}
+
+	at91_pm_set_standby(standby);
+}
+
 #ifdef CONFIG_AT91_SLOW_CLOCK
 static void __init at91_pm_sram_init(void)
 {
@@ -282,6 +321,8 @@ static void __init at91_pm_init(void)
 
 void __init at91_rm9200_pm_init(void)
 {
+	at91_dt_ramc();
+
 	/*
 	 * AT91RM9200 SDRAM low-power mode cannot be used with self-refresh.
 	 */
@@ -295,6 +336,7 @@ void __init at91_rm9200_pm_init(void)
 
 void __init at91_sam9260_pm_init(void)
 {
+	at91_dt_ramc();
 	at91_pm_data.memctrl = AT91_MEMCTRL_SDRAMC;
 	at91_pm_data.uhp_udp_mask = AT91SAM926x_PMC_UHP | AT91SAM926x_PMC_UDP;
 	return at91_pm_init();
@@ -302,6 +344,7 @@ void __init at91_sam9260_pm_init(void)
 
 void __init at91_sam9g45_pm_init(void)
 {
+	at91_dt_ramc();
 	at91_pm_data.uhp_udp_mask = AT91SAM926x_PMC_UHP;
 	at91_pm_data.memctrl = AT91_MEMCTRL_DDRSDR;
 	return at91_pm_init();
@@ -309,6 +352,7 @@ void __init at91_sam9g45_pm_init(void)
 
 void __init at91_sam9x5_pm_init(void)
 {
+	at91_dt_ramc();
 	at91_pm_data.uhp_udp_mask = AT91SAM926x_PMC_UHP | AT91SAM926x_PMC_UDP;
 	at91_pm_data.memctrl = AT91_MEMCTRL_DDRSDR;
 	return at91_pm_init();
diff --git a/arch/arm/mach-at91/sama5.c b/arch/arm/mach-at91/sama5.c
index 12440096762f..0feccbfd0eb6 100644
--- a/arch/arm/mach-at91/sama5.c
+++ b/arch/arm/mach-at91/sama5.c
@@ -42,7 +42,6 @@ static const char *sama5_dt_board_compat[] __initconst = {
 DT_MACHINE_START(sama5_dt, "Atmel SAMA5 (Device Tree)")
 	/* Maintainer: Atmel */
 	.map_io		= at91_map_io,
-	.init_early	= at91_dt_initialize,
 	.init_machine	= sama5_dt_device_init,
 	.dt_compat	= sama5_dt_board_compat,
 MACHINE_END
@@ -88,7 +87,6 @@ static const char *sama5_alt_dt_board_compat[] __initconst = {
 DT_MACHINE_START(sama5_alt_dt, "Atmel SAMA5 (Device Tree)")
 	/* Maintainer: Atmel */
 	.map_io		= sama5_alt_map_io,
-	.init_early	= at91_dt_initialize,
 	.init_machine	= sama5_dt_device_init,
 	.dt_compat	= sama5_alt_dt_board_compat,
 	.l2c_aux_mask	= ~0UL,
diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index b6a903410b92..4e58bc90ed21 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -28,9 +28,6 @@
 struct at91_socinfo at91_soc_initdata;
 EXPORT_SYMBOL(at91_soc_initdata);
 
-void __iomem *at91_ramc_base[2];
-EXPORT_SYMBOL_GPL(at91_ramc_base);
-
 static struct map_desc at91_io_desc __initdata __maybe_unused = {
 	.virtual	= (unsigned long)AT91_VA_BASE_SYS,
 	.pfn		= __phys_to_pfn(AT91_BASE_SYS),
@@ -331,45 +328,3 @@ void __init at91_ioremap_matrix(u32 base_addr)
 	if (!at91_matrix_base)
 		panic(pr_fmt("Impossible to ioremap at91_matrix_base\n"));
 }
-
-static struct of_device_id ramc_ids[] = {
-	{ .compatible = "atmel,at91rm9200-sdramc", .data = at91rm9200_standby },
-	{ .compatible = "atmel,at91sam9260-sdramc", .data = at91sam9_sdram_standby },
-	{ .compatible = "atmel,at91sam9g45-ddramc", .data = at91_ddr_standby },
-	{ .compatible = "atmel,sama5d3-ddramc", .data = at91_ddr_standby },
-	{ /*sentinel*/ }
-};
-
-static void at91_dt_ramc(void)
-{
-	struct device_node *np;
-	const struct of_device_id *of_id;
-	int idx = 0;
-	const void *standby = NULL;
-
-	for_each_matching_node_and_match(np, ramc_ids, &of_id) {
-		at91_ramc_base[idx] = of_iomap(np, 0);
-		if (!at91_ramc_base[idx])
-			panic(pr_fmt("unable to map ramc[%d] cpu registers\n"), idx);
-
-		if (!standby)
-			standby = of_id->data;
-
-		idx++;
-	}
-
-	if (!idx)
-		panic(pr_fmt("unable to find compatible ram controller node in dtb\n"));
-
-	if (!standby) {
-		pr_warn("ramc no standby function available\n");
-		return;
-	}
-
-	at91_pm_set_standby(standby);
-}
-
-void __init at91_dt_initialize(void)
-{
-	at91_dt_ramc();
-}
-- 
2.1.3

