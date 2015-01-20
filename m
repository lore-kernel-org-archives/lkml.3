Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbbATI1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 03:27:13 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:57113 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbbATI1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 03:27:11 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <nicolas.ferre@atmel.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alexandre.belloni@free-electrons.com>, <sylvain.rochet@finsecur.com>,
        <peda@axentia.se>, <wenyou.yang@atmel.com>
Subject: [PATCH 10/12] pm: at91: remove the at91_xxx_standby() function definitions in the pm.h
Date: Tue, 20 Jan 2015 16:24:58 +0800
Message-ID: <1421742298-18391-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1421741825-18226-1-git-send-email-wenyou.yang@atmel.com>
References: <1421741825-18226-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because the the suspend to standby mode uses the sram function,
these functions will not used, remove the redundant code.

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/pm.h |  110 -----------------------------------------------
 1 file changed, 110 deletions(-)

diff --git a/arch/arm/mach-at91/pm.h b/arch/arm/mach-at91/pm.h
index fbfea42..46e18bb 100644
--- a/arch/arm/mach-at91/pm.h
+++ b/arch/arm/mach-at91/pm.h
@@ -12,7 +12,6 @@
 #define __ARCH_ARM_MACH_AT91_PM
 
 #include <asm/proc-fns.h>
-
 #include <mach/at91_ramc.h>
 
 #define AT91_PM_MEMCTRL_MASK	0x0f
@@ -21,113 +20,4 @@
 
 #define	AT91_PM_SLOW_CLOCK	0x01
 
-/*
- * On all at91 except rm9200 and x40 have the System Controller starts
- * at address 0xffffc000 and has a size of 16KiB.
- *
- * On rm9200 it's start at 0xfffe4000 of 111KiB with non reserved data starting
- * at 0xfffff000
- *
- * Removes the individual definitions of AT91_BASE_SYS and
- * replaces them with a common version at base 0xfffffc000 and size 16KiB
- * and map the same memory space
- */
-#define AT91_BASE_SYS	0xffffc000
-
-#ifdef CONFIG_PM
-extern void at91_pm_set_standby(void (*at91_standby)(void));
-#else
-static inline void at91_pm_set_standby(void (*at91_standby)(void)) { }
-#endif
-
-/*
- * The AT91RM9200 goes into self-refresh mode with this command, and will
- * terminate self-refresh automatically on the next SDRAM access.
- *
- * Self-refresh mode is exited as soon as a memory access is made, but we don't
- * know for sure when that happens. However, we need to restore the low-power
- * mode if it was enabled before going idle. Restoring low-power mode while
- * still in self-refresh is "not recommended", but seems to work.
- */
-
-static inline void at91rm9200_standby(void)
-{
-	u32 lpr = at91_ramc_read(0, AT91RM9200_SDRAMC_LPR);
-
-	asm volatile(
-		"b    1f\n\t"
-		".align    5\n\t"
-		"1:  mcr    p15, 0, %0, c7, c10, 4\n\t"
-		"    str    %0, [%1, %2]\n\t"
-		"    str    %3, [%1, %4]\n\t"
-		"    mcr    p15, 0, %0, c7, c0, 4\n\t"
-		"    str    %5, [%1, %2]"
-		:
-		: "r" (0), "r" (AT91_BASE_SYS), "r" (AT91RM9200_SDRAMC_LPR),
-		  "r" (1), "r" (AT91RM9200_SDRAMC_SRR),
-		  "r" (lpr));
-}
-
-/* We manage both DDRAM/SDRAM controllers, we need more than one value to
- * remember.
- */
-static inline void at91_ddr_standby(void)
-{
-	/* Those two values allow us to delay self-refresh activation
-	 * to the maximum. */
-	u32 lpr0, lpr1 = 0;
-	u32 saved_lpr0, saved_lpr1 = 0;
-
-	if (at91_ramc_base[1]) {
-		saved_lpr1 = at91_ramc_read(1, AT91_DDRSDRC_LPR);
-		lpr1 = saved_lpr1 & ~AT91_DDRSDRC_LPCB;
-		lpr1 |= AT91_DDRSDRC_LPCB_SELF_REFRESH;
-	}
-
-	saved_lpr0 = at91_ramc_read(0, AT91_DDRSDRC_LPR);
-	lpr0 = saved_lpr0 & ~AT91_DDRSDRC_LPCB;
-	lpr0 |= AT91_DDRSDRC_LPCB_SELF_REFRESH;
-
-	/* self-refresh mode now */
-	at91_ramc_write(0, AT91_DDRSDRC_LPR, lpr0);
-	if (at91_ramc_base[1])
-		at91_ramc_write(1, AT91_DDRSDRC_LPR, lpr1);
-
-	cpu_do_idle();
-
-	at91_ramc_write(0, AT91_DDRSDRC_LPR, saved_lpr0);
-	if (at91_ramc_base[1])
-		at91_ramc_write(1, AT91_DDRSDRC_LPR, saved_lpr1);
-}
-
-/* We manage both DDRAM/SDRAM controllers, we need more than one value to
- * remember.
- */
-static inline void at91sam9_sdram_standby(void)
-{
-	u32 lpr0, lpr1 = 0;
-	u32 saved_lpr0, saved_lpr1 = 0;
-
-	if (at91_ramc_base[1]) {
-		saved_lpr1 = at91_ramc_read(1, AT91_SDRAMC_LPR);
-		lpr1 = saved_lpr1 & ~AT91_SDRAMC_LPCB;
-		lpr1 |= AT91_SDRAMC_LPCB_SELF_REFRESH;
-	}
-
-	saved_lpr0 = at91_ramc_read(0, AT91_SDRAMC_LPR);
-	lpr0 = saved_lpr0 & ~AT91_SDRAMC_LPCB;
-	lpr0 |= AT91_SDRAMC_LPCB_SELF_REFRESH;
-
-	/* self-refresh mode now */
-	at91_ramc_write(0, AT91_SDRAMC_LPR, lpr0);
-	if (at91_ramc_base[1])
-		at91_ramc_write(1, AT91_SDRAMC_LPR, lpr1);
-
-	cpu_do_idle();
-
-	at91_ramc_write(0, AT91_SDRAMC_LPR, saved_lpr0);
-	if (at91_ramc_base[1])
-		at91_ramc_write(1, AT91_SDRAMC_LPR, saved_lpr1);
-}
-
 #endif
-- 
1.7.9.5

