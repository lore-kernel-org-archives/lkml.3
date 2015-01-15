Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398AbbAOWA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 17:00:27 -0500
Received: from down.free-electrons.com ([37.187.137.238]:57640 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932383AbbAOWAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 17:00:23 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Bo Shen <voice.shen@atmel.com>, Wenyou Yang <Wenyou.Yang@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 17/17] ARM: at91: remove at91_dt_initialize
Date: Thu, 15 Jan 2015 22:58:20 +0100
Message-Id: <1421359100-8930-18-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421359100-8930-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421359100-8930-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the ramc initialization to pm.c as it is the only user left. This allows to
get rid of at91_dt_initialize() and setup.c

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/Makefile     |  2 --
 arch/arm/mach-at91/at91rm9200.c |  1 -
 arch/arm/mach-at91/at91sam9.c   |  2 --
 arch/arm/mach-at91/generic.h    |  3 --
 arch/arm/mach-at91/pm.c         | 43 ++++++++++++++++++++++++++-
 arch/arm/mach-at91/sama5d3.c    |  1 -
 arch/arm/mach-at91/sama5d4.c    |  1 -
 arch/arm/mach-at91/setup.c      | 64 -----------------------------------------
 8 files changed, 42 insertions(+), 75 deletions(-)
 delete mode 100644 arch/arm/mach-at91/setup.c

diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
index 27b503defe80..be26bb8c9a9a 100644
--- a/arch/arm/mach-at91/Makefile
+++ b/arch/arm/mach-at91/Makefile
@@ -2,8 +2,6 @@
 # Makefile for the linux kernel.
 #
 
-obj-y		:= setup.o
-
 obj-$(CONFIG_SOC_AT91SAM9)	+= sam9_smc.o
 
 # CPU-specific support
diff --git a/arch/arm/mach-at91/at91rm9200.c b/arch/arm/mach-at91/at91rm9200.c
index a1d1e63fb405..4ab2e2bbdee2 100644
--- a/arch/arm/mach-at91/at91rm9200.c
+++ b/arch/arm/mach-at91/at91rm9200.c
@@ -41,7 +41,6 @@ static void __init rm9200_dt_device_init(void)
 	arm_pm_idle = at91rm9200_idle;
 	arm_pm_restart = at91rm9200_restart;
 	at91_rm9200_pm_init();
-	at91_dt_initialize();
 
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
diff --git a/arch/arm/mach-at91/at91sam9.c b/arch/arm/mach-at91/at91sam9.c
index 0aeabcf4ddb8..8223b1298510 100644
--- a/arch/arm/mach-at91/at91sam9.c
+++ b/arch/arm/mach-at91/at91sam9.c
@@ -19,7 +19,6 @@ static void __init sam9_dt_device_init(void)
 {
 	arm_pm_idle = at91sam9_idle;
 	at91_sam9260_pm_init();
-	at91_dt_initialize();
 
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
@@ -39,7 +38,6 @@ static void __init sam9g45_dt_device_init(void)
 {
 	arm_pm_idle = at91sam9_idle;
 	at91_sam9g45_pm_init();
-	at91_dt_initialize();
 
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
index 881e73a27fab..1384354e93dc 100644
--- a/arch/arm/mach-at91/generic.h
+++ b/arch/arm/mach-at91/generic.h
@@ -14,9 +14,6 @@
 #include <linux/of.h>
 #include <linux/reboot.h>
 
- /* Processors */
-extern void __init at91_dt_initialize(void);
-
  /* Timer */
 extern void at91rm9200_timer_init(void);
 
diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 11bf992838af..4aebd7ba7640 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -44,6 +44,7 @@ static struct {
 } at91_pm_data;
 
 static void (*at91_pm_standby)(void);
+static void __iomem *at91_ramc_base[2];
 
 static int at91_pm_valid_state(suspend_state_t state)
 {
@@ -227,6 +228,44 @@ void at91_pm_set_standby(void (*at91_standby)(void))
 	}
 }
 
+
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
@@ -268,7 +307,6 @@ put_node:
 }
 #endif
 
-
 static void __init at91_pm_init(void)
 {
 #ifdef CONFIG_AT91_SLOW_CLOCK
@@ -288,6 +326,7 @@ void __init at91_rm9200_pm_init(void)
 	/*
 	 * AT91RM9200 SDRAM low-power mode cannot be used with self-refresh.
 	 */
+	at91_dt_ramc();
 	at91_ramc_write(0, AT91RM9200_SDRAMC_LPR, 0);
 
 	at91_pm_data.uhp_udp_mask = AT91RM9200_PMC_UHP | AT91RM9200_PMC_UDP;
@@ -298,6 +337,7 @@ void __init at91_rm9200_pm_init(void)
 
 void __init at91_sam9260_pm_init(void)
 {
+	at91_dt_ramc();
 	at91_pm_data.memctrl = AT91_MEMCTRL_SDRAMC;
 	at91_pm_data.uhp_udp_mask = AT91SAM926x_PMC_UHP | AT91SAM926x_PMC_UDP;
 	return at91_pm_init();
@@ -305,6 +345,7 @@ void __init at91_sam9260_pm_init(void)
 
 void __init at91_sam9g45_pm_init(void)
 {
+	at91_dt_ramc();
 	at91_pm_data.uhp_udp_mask = AT91SAM926x_PMC_UHP;
 	at91_pm_data.memctrl = AT91_MEMCTRL_DDRSDR;
 	return at91_pm_init();
diff --git a/arch/arm/mach-at91/sama5d3.c b/arch/arm/mach-at91/sama5d3.c
index 752d1612ff1f..3af2b4bcc205 100644
--- a/arch/arm/mach-at91/sama5d3.c
+++ b/arch/arm/mach-at91/sama5d3.c
@@ -16,7 +16,6 @@
 static void __init sama5_dt_device_init(void)
 {
 	at91_sam9260_pm_init();
-	at91_dt_initialize();
 
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
diff --git a/arch/arm/mach-at91/sama5d4.c b/arch/arm/mach-at91/sama5d4.c
index 2f1ee08dc49f..2ec43ee3f440 100644
--- a/arch/arm/mach-at91/sama5d4.c
+++ b/arch/arm/mach-at91/sama5d4.c
@@ -52,7 +52,6 @@ static void __init sama5d4_map_io(void)
 static void __init sama5d4_dt_device_init(void)
 {
 	at91_sam9260_pm_init();
-	at91_dt_initialize();
 
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
deleted file mode 100644
index 4036e3e0ff96..000000000000
--- a/arch/arm/mach-at91/setup.c
+++ /dev/null
@@ -1,64 +0,0 @@
-/*
- * Copyright (C) 2007 Atmel Corporation.
- * Copyright (C) 2011 Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
- *
- * Under GPLv2
- */
-
-#define pr_fmt(fmt)	"AT91: " fmt
-
-#include <linux/io.h>
-#include <linux/pm.h>
-#include <linux/of_address.h>
-
-#include <asm/system_misc.h>
-
-#include <mach/hardware.h>
-
-#include "generic.h"
-#include "pm.h"
-
-void __iomem *at91_ramc_base[2];
-EXPORT_SYMBOL_GPL(at91_ramc_base);
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
2.1.0

