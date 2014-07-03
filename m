Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758389AbaGCOUR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:20:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50915 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758346AbaGCOUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:20:14 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux@maxim.org.za, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        dwmw2@infradead.org, dbaryshkov@gmail.com
Cc: Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 10/18] AT91: Remove reset code the machine code
Date: Thu,  3 Jul 2014 16:14:50 +0200
Message-Id: <1404396906-25194-18-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404396906-25194-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1404396906-25194-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the transition is over and that we probe our reset driver in every
case, we can remove the legacy code from the machine directory.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-at91/Kconfig              |  8 ------
 arch/arm/mach-at91/Makefile             |  2 --
 arch/arm/mach-at91/at91sam9260.c        |  1 -
 arch/arm/mach-at91/at91sam9261.c        |  1 -
 arch/arm/mach-at91/at91sam9263.c        |  1 -
 arch/arm/mach-at91/at91sam9_alt_reset.S | 40 -----------------------------
 arch/arm/mach-at91/at91sam9g45.c        |  1 -
 arch/arm/mach-at91/at91sam9g45_reset.S  | 45 ---------------------------------
 arch/arm/mach-at91/at91sam9rl.c         |  1 -
 arch/arm/mach-at91/generic.h            |  2 --
 10 files changed, 102 deletions(-)
 delete mode 100644 arch/arm/mach-at91/at91sam9_alt_reset.S
 delete mode 100644 arch/arm/mach-at91/at91sam9g45_reset.S

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 45b55e0f0db6..d2a1ffec5e11 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -28,14 +28,6 @@ config OLD_CLK_AT91
 	bool
 	default AT91_PMC_UNIT && AT91_USE_OLD_CLK
 
-config AT91_SAM9_ALT_RESET
-	bool
-	default !ARCH_AT91X40
-
-config AT91_SAM9G45_RESET
-	bool
-	default !ARCH_AT91X40
-
 config AT91_SAM9_TIME
 	bool
 
diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
index 78e9cec282f4..2947834d93c3 100644
--- a/arch/arm/mach-at91/Makefile
+++ b/arch/arm/mach-at91/Makefile
@@ -8,8 +8,6 @@ obj-n		:=
 obj-		:=
 
 obj-$(CONFIG_OLD_CLK_AT91)	+= clock.o
-obj-$(CONFIG_AT91_SAM9_ALT_RESET) += at91sam9_alt_reset.o
-obj-$(CONFIG_AT91_SAM9G45_RESET) += at91sam9g45_reset.o
 obj-$(CONFIG_AT91_SAM9_TIME)	+= at91sam926x_time.o
 obj-$(CONFIG_SOC_AT91SAM9)	+= sam9_smc.o
 
diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
index 9ffab0cf94cd..197c0149406a 100644
--- a/arch/arm/mach-at91/at91sam9260.c
+++ b/arch/arm/mach-at91/at91sam9260.c
@@ -351,7 +351,6 @@ static void __init at91sam9260_ioremap_registers(void)
 static void __init at91sam9260_initialize(void)
 {
 	arm_pm_idle = at91sam9_idle;
-	arm_pm_restart = at91sam9_alt_restart;
 
 	at91_sysirq_mask_rtt(AT91SAM9260_BASE_RTT);
 
diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
index 41fa9b9a6f05..ef44977f1cae 100644
--- a/arch/arm/mach-at91/at91sam9261.c
+++ b/arch/arm/mach-at91/at91sam9261.c
@@ -314,7 +314,6 @@ static void __init at91sam9261_ioremap_registers(void)
 static void __init at91sam9261_initialize(void)
 {
 	arm_pm_idle = at91sam9_idle;
-	arm_pm_restart = at91sam9_alt_restart;
 
 	at91_sysirq_mask_rtt(AT91SAM9261_BASE_RTT);
 
diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
index 0c6949c342dc..cb078e150a19 100644
--- a/arch/arm/mach-at91/at91sam9263.c
+++ b/arch/arm/mach-at91/at91sam9263.c
@@ -331,7 +331,6 @@ static void __init at91sam9263_ioremap_registers(void)
 static void __init at91sam9263_initialize(void)
 {
 	arm_pm_idle = at91sam9_idle;
-	arm_pm_restart = at91sam9_alt_restart;
 
 	at91_sysirq_mask_rtt(AT91SAM9263_BASE_RTT0);
 	at91_sysirq_mask_rtt(AT91SAM9263_BASE_RTT1);
diff --git a/arch/arm/mach-at91/at91sam9_alt_reset.S b/arch/arm/mach-at91/at91sam9_alt_reset.S
deleted file mode 100644
index f039538d3bdb..000000000000
--- a/arch/arm/mach-at91/at91sam9_alt_reset.S
+++ /dev/null
@@ -1,40 +0,0 @@
-/*
- * reset AT91SAM9G20 as per errata
- *
- * (C) BitBox Ltd 2010
- *
- * unless the SDRAM is cleanly shutdown before we hit the
- * reset register it can be left driving the data bus and
- * killing the chance of a subsequent boot from NAND
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <linux/linkage.h>
-#include <mach/hardware.h>
-#include <mach/at91_ramc.h>
-#include "at91_rstc.h"
-
-			.arm
-
-			.globl	at91sam9_alt_restart
-
-at91sam9_alt_restart:	ldr	r0, =at91_ramc_base		@ preload constants
-			ldr	r0, [r0]
-			ldr	r4, =at91_rstc_base
-			ldr	r1, [r4]
-
-			mov	r2, #1
-			mov	r3, #AT91_SDRAMC_LPCB_POWER_DOWN
-			ldr	r4, =AT91_RSTC_KEY | AT91_RSTC_PERRST | AT91_RSTC_PROCRST
-
-			.balign	32				@ align to cache line
-
-			str	r2, [r0, #AT91_SDRAMC_TR]	@ disable SDRAM access
-			str	r3, [r0, #AT91_SDRAMC_LPR]	@ power down SDRAM
-			str	r4, [r1, #AT91_RSTC_CR]		@ reset processor
-
-			b	.
diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
index 61c0bc1185e9..329749eb1dff 100644
--- a/arch/arm/mach-at91/at91sam9g45.c
+++ b/arch/arm/mach-at91/at91sam9g45.c
@@ -380,7 +380,6 @@ static void __init at91sam9g45_ioremap_registers(void)
 static void __init at91sam9g45_initialize(void)
 {
 	arm_pm_idle = at91sam9_idle;
-	arm_pm_restart = at91sam9g45_restart;
 
 	at91_sysirq_mask_rtc(AT91SAM9G45_BASE_RTC);
 	at91_sysirq_mask_rtt(AT91SAM9G45_BASE_RTT);
diff --git a/arch/arm/mach-at91/at91sam9g45_reset.S b/arch/arm/mach-at91/at91sam9g45_reset.S
deleted file mode 100644
index c40c1e2ef80f..000000000000
--- a/arch/arm/mach-at91/at91sam9g45_reset.S
+++ /dev/null
@@ -1,45 +0,0 @@
-/*
- * reset AT91SAM9G45 as per errata
- *
- * Copyright (C) 2011 Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcosoft.com>
- *
- * unless the SDRAM is cleanly shutdown before we hit the
- * reset register it can be left driving the data bus and
- * killing the chance of a subsequent boot from NAND
- *
- * GPLv2 Only
- */
-
-#include <linux/linkage.h>
-#include <mach/hardware.h>
-#include <mach/at91_ramc.h>
-#include "at91_rstc.h"
-			.arm
-
-/*
- * at91_ramc_base is an array void*
- * init at NULL if only one DDR controler is present in or DT
- */
-			.globl	at91sam9g45_restart
-
-at91sam9g45_restart:
-			ldr	r5, =at91_ramc_base		@ preload constants
-			ldr	r0, [r5]
-			ldr	r5, [r5, #4]			@ ddr1
-			cmp	r5, #0
-			ldr	r4, =at91_rstc_base
-			ldr	r1, [r4]
-
-			mov	r2, #1
-			mov	r3, #AT91_DDRSDRC_LPCB_POWER_DOWN
-			ldr	r4, =AT91_RSTC_KEY | AT91_RSTC_PERRST | AT91_RSTC_PROCRST
-
-			.balign	32				@ align to cache line
-
-			strne	r2, [r5, #AT91_DDRSDRC_RTR]	@ disable DDR1 access
-			strne	r3, [r5, #AT91_DDRSDRC_LPR]	@ power down DDR1
-			str	r2, [r0, #AT91_DDRSDRC_RTR]	@ disable DDR0 access
-			str	r3, [r0, #AT91_DDRSDRC_LPR]	@ power down DDR0
-			str	r4, [r1, #AT91_RSTC_CR]		@ reset processor
-
-			b	.
diff --git a/arch/arm/mach-at91/at91sam9rl.c b/arch/arm/mach-at91/at91sam9rl.c
index 417c8b6fb85e..e0e1729fe0e4 100644
--- a/arch/arm/mach-at91/at91sam9rl.c
+++ b/arch/arm/mach-at91/at91sam9rl.c
@@ -323,7 +323,6 @@ static void __init at91sam9rl_ioremap_registers(void)
 static void __init at91sam9rl_initialize(void)
 {
 	arm_pm_idle = at91sam9_idle;
-	arm_pm_restart = at91sam9_alt_restart;
 
 	at91_sysirq_mask_rtc(AT91SAM9RL_BASE_RTC);
 	at91_sysirq_mask_rtt(AT91SAM9RL_BASE_RTT);
diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
index 4c2c96195a50..5d5e55237c41 100644
--- a/arch/arm/mach-at91/generic.h
+++ b/arch/arm/mach-at91/generic.h
@@ -66,8 +66,6 @@ extern void at91sam9_idle(void);
 
 /* reset */
 extern void at91_ioremap_rstc(u32 base_addr);
-extern void at91sam9_alt_restart(enum reboot_mode, const char *);
-extern void at91sam9g45_restart(enum reboot_mode, const char *);
 
 /* shutdown */
 extern void at91_ioremap_shdwc(u32 base_addr);
-- 
2.0.1

