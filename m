Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbbAOPBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 10:01:12 -0500
Received: from down.free-electrons.com ([37.187.137.238]:54362 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751993AbbAOO7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 09:59:38 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH v2 4/8] ARM: at91: pm: prepare for multiplatform
Date: Thu, 15 Jan 2015 15:59:27 +0100
Message-Id: <1421333971-7581-5-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421333971-7581-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421333971-7581-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split at91_pm_init() in three variants that are called by the respective SoCs
.init_machine. This allows to remove the of_machine_is_compatible() calls and
move at91_pm_init() out of arch_initcall() which is required for multiplatform.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/board-dt-rm9200.c | 11 ++++++++
 arch/arm/mach-at91/board-dt-sam9.c   | 27 ++++++++++++++++++++
 arch/arm/mach-at91/board-dt-sama5.c  |  1 +
 arch/arm/mach-at91/generic.h         | 12 +++++++++
 arch/arm/mach-at91/pm.c              | 49 ++++++++++++++++++++----------------
 5 files changed, 79 insertions(+), 21 deletions(-)

diff --git a/arch/arm/mach-at91/board-dt-rm9200.c b/arch/arm/mach-at91/board-dt-rm9200.c
index a15ab6f8de00..5f82a65153e1 100644
--- a/arch/arm/mach-at91/board-dt-rm9200.c
+++ b/arch/arm/mach-at91/board-dt-rm9200.c
@@ -14,6 +14,7 @@
 #include <linux/gpio.h>
 #include <linux/of.h>
 #include <linux/of_irq.h>
+#include <linux/of_platform.h>
 #include <linux/clk-provider.h>
 
 #include <asm/setup.h>
@@ -30,6 +31,15 @@ static void __init at91rm9200_dt_timer_init(void)
 	at91rm9200_timer_init();
 }
 
+static void __init rm9200_dt_device_init(void)
+{
+	at91_rm9200_pm_init();
+
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+}
+
+
+
 static const char *at91rm9200_dt_board_compat[] __initdata = {
 	"atmel,at91rm9200",
 	NULL
@@ -39,5 +49,6 @@ DT_MACHINE_START(at91rm9200_dt, "Atmel AT91RM9200 (Device Tree)")
 	.init_time      = at91rm9200_dt_timer_init,
 	.map_io		= at91_map_io,
 	.init_early	= at91_dt_initialize,
+	.init_machine	= rm9200_dt_device_init,
 	.dt_compat	= at91rm9200_dt_board_compat,
 MACHINE_END
diff --git a/arch/arm/mach-at91/board-dt-sam9.c b/arch/arm/mach-at91/board-dt-sam9.c
index f99246aa9b38..0fe1ced608c5 100644
--- a/arch/arm/mach-at91/board-dt-sam9.c
+++ b/arch/arm/mach-at91/board-dt-sam9.c
@@ -13,6 +13,7 @@
 #include <linux/gpio.h>
 #include <linux/of.h>
 #include <linux/of_irq.h>
+#include <linux/of_platform.h>
 #include <linux/clk-provider.h>
 
 #include <asm/setup.h>
@@ -23,6 +24,12 @@
 
 #include "generic.h"
 
+static void __init sam9_dt_device_init(void)
+{
+	at91_sam9260_pm_init();
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+}
+
 static const char *at91_dt_board_compat[] __initdata = {
 	"atmel,at91sam9",
 	NULL
@@ -32,5 +39,25 @@ DT_MACHINE_START(at91sam_dt, "Atmel AT91SAM (Device Tree)")
 	/* Maintainer: Atmel */
 	.map_io		= at91_map_io,
 	.init_early	= at91_dt_initialize,
+	.init_machine	= sam9_dt_device_init,
 	.dt_compat	= at91_dt_board_compat,
 MACHINE_END
+
+static void __init sam9g45_dt_device_init(void)
+{
+	at91_sam9g45_pm_init();
+	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+}
+
+static const char *at91_9g45_board_compat[] __initconst = {
+	"atmel,at91sam9g45",
+	NULL
+};
+
+DT_MACHINE_START(at91sam9g45_dt, "Atmel AT91SAM9G45")
+	/* Maintainer: Atmel */
+	.map_io		= at91_map_io,
+	.init_early	= at91_dt_initialize,
+	.init_machine	= sam9g45_dt_device_init,
+	.dt_compat	= at91_9g45_board_compat,
+MACHINE_END
diff --git a/arch/arm/mach-at91/board-dt-sama5.c b/arch/arm/mach-at91/board-dt-sama5.c
index 8fb9ef5333f1..44d372a22a29 100644
--- a/arch/arm/mach-at91/board-dt-sama5.c
+++ b/arch/arm/mach-at91/board-dt-sama5.c
@@ -28,6 +28,7 @@
 
 static void __init sama5_dt_device_init(void)
 {
+	at91_sam9260_pm_init();
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
 
diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
index 54f3837a0a4d..fae7a703813c 100644
--- a/arch/arm/mach-at91/generic.h
+++ b/arch/arm/mach-at91/generic.h
@@ -31,4 +31,16 @@ extern void at91sam9_idle(void);
 
 /* Matrix */
 extern void at91_ioremap_matrix(u32 base_addr);
+
+
+#ifdef CONFIG_PM
+extern void __init at91_rm9200_pm_init(void);
+extern void __init at91_sam9260_pm_init(void);
+extern void __init at91_sam9g45_pm_init(void);
+#else
+void __init at91_rm9200_pm_init(void) { }
+void __init at91_sam9260_pm_init(void) { }
+void __init at91_sam9g45_pm_init(void) { }
+#endif
+
 #endif /* _AT91_GENERIC_H */
diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 71cc845263dc..778f11132b31 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -266,7 +266,7 @@ put_node:
 #endif
 
 
-static int __init at91_pm_init(void)
+static void __init at91_pm_init(void)
 {
 #ifdef CONFIG_AT91_SLOW_CLOCK
 	at91_pm_sram_init();
@@ -274,29 +274,36 @@ static int __init at91_pm_init(void)
 
 	pr_info("AT91: Power Management%s\n", (slow_clock ? " (with slow clock mode)" : ""));
 
-	at91_pm_data.memctrl = AT91_MEMCTRL_SDRAMC;
-	at91_pm_data.uhp_udp_mask = AT91SAM926x_PMC_UHP | AT91SAM926x_PMC_UDP;
-
-	if (of_machine_is_compatible("atmel,at91rm9200")) {
-		/*
-		 * AT91RM9200 SDRAM low-power mode cannot be used with
-		 * self-refresh.
-		 */
-		at91_ramc_write(0, AT91RM9200_SDRAMC_LPR, 0);
-
-		at91_pm_data.uhp_udp_mask = AT91RM9200_PMC_UHP |
-					    AT91RM9200_PMC_UDP;
-		at91_pm_data.memctrl = AT91_MEMCTRL_MC;
-	} else if (of_machine_is_compatible("atmel,at91sam9g45")) {
-		at91_pm_data.uhp_udp_mask = AT91RM9200_PMC_UHP;
-		at91_pm_data.memctrl = AT91_MEMCTRL_DDRSDR;
-	}
-
 	if (at91_cpuidle_device.dev.platform_data)
 		platform_device_register(&at91_cpuidle_device);
 
 	suspend_set_ops(&at91_pm_ops);
+}
 
-	return 0;
+void __init at91_rm9200_pm_init(void)
+{
+	/*
+	 * AT91RM9200 SDRAM low-power mode cannot be used with self-refresh.
+	 */
+	at91_ramc_write(0, AT91RM9200_SDRAMC_LPR, 0);
+
+	at91_pm_data.uhp_udp_mask = AT91RM9200_PMC_UHP | AT91RM9200_PMC_UDP;
+	at91_pm_data.memctrl = AT91_MEMCTRL_MC;
+
+	at91_pm_init();
+}
+
+void __init at91_sam9260_pm_init(void)
+{
+	at91_pm_data.memctrl = AT91_MEMCTRL_SDRAMC;
+	at91_pm_data.uhp_udp_mask = AT91SAM926x_PMC_UHP | AT91SAM926x_PMC_UDP;
+	return at91_pm_init();
 }
-arch_initcall(at91_pm_init);
+
+void __init at91_sam9g45_pm_init(void)
+{
+	at91_pm_data.uhp_udp_mask = AT91SAM926x_PMC_UHP;
+	at91_pm_data.memctrl = AT91_MEMCTRL_DDRSDR;
+	return at91_pm_init();
+}
+
-- 
2.1.0

