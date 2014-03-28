Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbaC1SD0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 14:03:26 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:60008 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211AbaC1R7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:59:35 -0400
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
To: Rob Landley <rob@landley.net>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Subject: [RFC PATCH v2 05/10] ARM: at91: make use of the new AIC driver for dt enabled boards
Date: Fri, 28 Mar 2014 18:59:03 +0100
Message-Id: <1396029548-10928-6-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396029548-10928-1-git-send-email-b.brezillon.dev@gmail.com>
References: <1396029548-10928-1-git-send-email-b.brezillon.dev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new Kconfig option for the new AIC driver
(drivers/irqchip/irq-atmel-aic.c) and remove selection of OLD_IRQ_AT91
when selecting dt boards.

Remove specific irq init code in all dt board files: this init procedure
is automatically handled in of_irq_init which is called by the arm irq core
code and is in charge of calling the appropriate aic init functions.

Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
---
 arch/arm/mach-at91/Kconfig           |   10 +++++++---
 arch/arm/mach-at91/board-dt-rm9200.c |   13 -------------
 arch/arm/mach-at91/board-dt-sam9.c   |   14 --------------
 arch/arm/mach-at91/board-dt-sama5.c  |   13 -------------
 4 files changed, 7 insertions(+), 43 deletions(-)

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 4f0b3e0..7e75c4d 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -32,6 +32,13 @@ config OLD_IRQ_AT91
 	bool
 	default false
 
+config ATMEL_AIC_IRQ
+	bool
+	default USE_OF
+	select GENERIC_IRQ_CHIP
+	select IRQ_DOMAIN
+	select MULTI_IRQ_HANDLER
+
 config AT91_SAM9_ALT_RESET
 	bool
 	default !ARCH_AT91X40
@@ -193,7 +200,6 @@ config MACH_AT91RM9200_DT
 	bool "Atmel AT91RM9200 Evaluation Kits with device-tree support"
 	depends on SOC_AT91RM9200
 	select USE_OF
-	select OLD_IRQ_AT91
 	help
 	  Select this if you want to experiment device-tree with
 	  an Atmel RM9200 Evaluation Kit.
@@ -202,7 +208,6 @@ config MACH_AT91SAM9_DT
 	bool "Atmel AT91SAM Evaluation Kits with device-tree support"
 	depends on SOC_AT91SAM9
 	select USE_OF
-	select OLD_IRQ_AT91
 	help
 	  Select this if you want to experiment device-tree with
 	  an Atmel Evaluation Kit.
@@ -211,7 +216,6 @@ config MACH_SAMA5_DT
 	bool "Atmel SAMA5 Evaluation Kits with device-tree support"
 	depends on SOC_SAMA5
 	select USE_OF
-	select OLD_IRQ_AT91
 	select PHYLIB if NETDEVICES
 	help
 	  Select this if you want to experiment device-tree with
diff --git a/arch/arm/mach-at91/board-dt-rm9200.c b/arch/arm/mach-at91/board-dt-rm9200.c
index 3a185fa..61ea214 100644
--- a/arch/arm/mach-at91/board-dt-rm9200.c
+++ b/arch/arm/mach-at91/board-dt-rm9200.c
@@ -24,17 +24,6 @@
 #include "at91_aic.h"
 #include "generic.h"
 
-
-static const struct of_device_id irq_of_match[] __initconst = {
-	{ .compatible = "atmel,at91rm9200-aic", .data = at91_aic_of_init },
-	{ /*sentinel*/ }
-};
-
-static void __init at91rm9200_dt_init_irq(void)
-{
-	of_irq_init(irq_of_match);
-}
-
 static const char *at91rm9200_dt_board_compat[] __initdata = {
 	"atmel,at91rm9200",
 	NULL
@@ -43,8 +32,6 @@ static const char *at91rm9200_dt_board_compat[] __initdata = {
 DT_MACHINE_START(at91rm9200_dt, "Atmel AT91RM9200 (Device Tree)")
 	.init_time      = at91rm9200_timer_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= at91rm9200_dt_initialize,
-	.init_irq	= at91rm9200_dt_init_irq,
 	.dt_compat	= at91rm9200_dt_board_compat,
 MACHINE_END
diff --git a/arch/arm/mach-at91/board-dt-sam9.c b/arch/arm/mach-at91/board-dt-sam9.c
index 3dab868..d4073c0 100644
--- a/arch/arm/mach-at91/board-dt-sam9.c
+++ b/arch/arm/mach-at91/board-dt-sam9.c
@@ -20,22 +20,10 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 
-#include "at91_aic.h"
 #include "board.h"
 #include "generic.h"
 
 
-static const struct of_device_id irq_of_match[] __initconst = {
-
-	{ .compatible = "atmel,at91rm9200-aic", .data = at91_aic_of_init },
-	{ /*sentinel*/ }
-};
-
-static void __init at91_dt_init_irq(void)
-{
-	of_irq_init(irq_of_match);
-}
-
 static const char *at91_dt_board_compat[] __initdata = {
 	"atmel,at91sam9",
 	NULL
@@ -45,8 +33,6 @@ DT_MACHINE_START(at91sam_dt, "Atmel AT91SAM (Device Tree)")
 	/* Maintainer: Atmel */
 	.init_time	= at91sam926x_pit_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic_handle_irq,
 	.init_early	= at91_dt_initialize,
-	.init_irq	= at91_dt_init_irq,
 	.dt_compat	= at91_dt_board_compat,
 MACHINE_END
diff --git a/arch/arm/mach-at91/board-dt-sama5.c b/arch/arm/mach-at91/board-dt-sama5.c
index 075ec05..d6fe04b 100644
--- a/arch/arm/mach-at91/board-dt-sama5.c
+++ b/arch/arm/mach-at91/board-dt-sama5.c
@@ -35,17 +35,6 @@ static void __init sama5_dt_timer_init(void)
 	at91sam926x_pit_init();
 }
 
-static const struct of_device_id irq_of_match[] __initconst = {
-
-	{ .compatible = "atmel,sama5d3-aic", .data = at91_aic5_of_init },
-	{ /*sentinel*/ }
-};
-
-static void __init at91_dt_init_irq(void)
-{
-	of_irq_init(irq_of_match);
-}
-
 static int ksz9021rn_phy_fixup(struct phy_device *phy)
 {
 	int value;
@@ -82,9 +71,7 @@ DT_MACHINE_START(sama5_dt, "Atmel SAMA5 (Device Tree)")
 	/* Maintainer: Atmel */
 	.init_time	= sama5_dt_timer_init,
 	.map_io		= at91_map_io,
-	.handle_irq	= at91_aic5_handle_irq,
 	.init_early	= at91_dt_initialize,
-	.init_irq	= at91_dt_init_irq,
 	.init_machine	= sama5_dt_device_init,
 	.dt_compat	= sama5_dt_board_compat,
 MACHINE_END
-- 
1.7.9.5

