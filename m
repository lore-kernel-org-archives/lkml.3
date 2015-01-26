Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbbAZKLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:11:18 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:52919 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbbAZKLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:11:14 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <nicolas.ferre@atmel.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alexandre.belloni@free-electrons.com>, <sylvain.rochet@finsecur.com>,
        <peda@axentia.se>, <wenyou.yang@atmel.com>,
        <Patrice.VILCHEZ@atmel.com>
Subject: [PATCH 5/7] pm: at91: add disable/enable the L1/L2 cache while suspend/resume
Date: Mon, 26 Jan 2015 18:07:57 +0800
Message-ID: <1422266877-24628-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422266617-24381-1-git-send-email-wenyou.yang@atmel.com>
References: <1422266617-24381-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the sama5, disable L1 D-cache and L2 cache before the cpu go to wfi,
after wakeing up, enable L1 D-cache and L2 cache.

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 arch/arm/mach-at91/pm.c         |    9 ++++
 arch/arm/mach-at91/pm_suspend.S |  107 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 116 insertions(+)

diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index f75dc32..50cde92 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -35,6 +35,9 @@
 #include "generic.h"
 #include "pm.h"
 
+void __weak at91_disable_l1_l2_cache(void) {}
+void __weak at91_enable_l1_l2_cache(void) {}
+
 struct at91_pm_struct at91_pm_data;
 
 static int at91_pm_valid_state(suspend_state_t state)
@@ -142,8 +145,14 @@ static void at91_pm_suspend(suspend_state_t state)
 	pm_data |= (state == PM_SUSPEND_MEM) ?
 				AT91_PM_MODE(AT91_PM_SLOW_CLOCK) : 0;
 
+	/* Disable L1 D-cache and L2 cache */
+	at91_disable_l1_l2_cache();
+
 	at91_suspend_sram_fn(at91_pmc_base, at91_ramc_base[0],
 				at91_ramc_base[1], pm_data);
+
+	/* Enable L1 D-cache and L2 cache */
+	at91_enable_l1_l2_cache();
 }
 
 static int at91_pm_enter(suspend_state_t state)
diff --git a/arch/arm/mach-at91/pm_suspend.S b/arch/arm/mach-at91/pm_suspend.S
index 88cf228..e6e7f7a 100644
--- a/arch/arm/mach-at91/pm_suspend.S
+++ b/arch/arm/mach-at91/pm_suspend.S
@@ -15,6 +15,7 @@
 #include <linux/clk/at91_pmc.h>
 #include <mach/hardware.h>
 #include <mach/at91_ramc.h>
+#include <asm/hardware/cache-l2x0.h>
 
 #include "pm.h"
 
@@ -329,3 +330,109 @@ ram_restored:
 
 ENTRY(at91_pm_suspend_in_sram_sz)
 	.word .-at91_pm_suspend_in_sram
+
+/*---------------------------------------*/
+
+#if defined(CONFIG_CPU_V7)
+
+/*
+ * void at91_disable_l1_l2_cache(void)
+ *
+ * This function code disables, cleans & invalidates the L1 D-cache
+ * and cleans, invalidates & disable the L2 cache.
+ */
+ENTRY(at91_disable_l1_l2_cache)
+	stmfd	sp!, {r4 - r12, lr}
+
+	/*
+	 * Flush all data from the L1 D-cache before disabling
+	 * SCTLR.C bit.
+	 */
+	bl	v7_flush_dcache_all
+
+	/*
+	 * Clear the SCTLR.C bit to prevent further data cache
+	 * allocation. Clearing SCTLR.C would make all the data accesses
+	 * strongly ordered and would not hit the cache.
+	 */
+	mrc	p15, 0, r0, c1, c0, 0
+	bic	r0, r0, #(1 << 2)	@ Disable the C bit
+	mcr	p15, 0, r0, c1, c0, 0
+	isb
+
+	/*
+	 * Invalidate L1 D-cache. Even though only invalidate is
+	 * necessary exported flush API is used here. Doing clean
+	 * on already clean cache would be almost NOP.
+	 */
+	bl	v7_flush_dcache_all
+
+	/*
+	 * Clean and invalidate the L2 cache.
+	 * Common cache-l2x0.c functions can't be used here since it
+	 * uses spinlocks. We are out of coherency here with data cache
+	 * disabled. The spinlock implementation uses exclusive load/store
+	 * instruction which can fail without data cache being enabled.
+	 * Because of this, CPU can lead to deadlock.
+	 */
+	ldr	r1, at91_l2cc_base_addr
+	ldr	r2, [r1]
+	cmp	r2, #0
+	beq	skip_l2disable
+	mov	r0, #0xff
+	str	r0, [r2, #L2X0_CLEAN_INV_WAY]
+wait:
+	ldr	r0, [r2, #L2X0_CLEAN_INV_WAY]
+	mov	r1, #0xff
+	ands	r0, r0, r1
+	bne	wait
+
+	mov	r0, #0
+	str	r0, [r2, #L2X0_CTRL]
+
+l2x_sync:
+	ldr	r0, [r2, #L2X0_CACHE_SYNC]
+	bic	r0, r0, #0x1
+	str	r0, [r2, #L2X0_CACHE_SYNC]
+sync:
+	ldr	r0, [r2, #L2X0_CACHE_SYNC]
+	ands	r0, r0, #0x1
+	bne	sync
+
+skip_l2disable:
+	ldmfd	sp!, {r4 - r12, pc}
+ENDPROC(at91_disable_l1_l2_cache)
+
+/*
+ * void at91_enable_l1_l2_cache(void)
+ *
+ * This function code enables the L1 D-cache and the L2 cache.
+ */
+ENTRY(at91_enable_l1_l2_cache)
+	stmfd	sp!, {r4 - r12, lr}
+
+	/* Enable the L2 cache */
+	ldr	r1, at91_l2cc_base_addr
+	ldr	r2, [r1]
+	cmp	r2, #0
+	beq	skip_l2en
+	ldr	r0, [r2, #L2X0_CTRL]
+	ands	r0, r0, #L2X0_CTRL_EN
+	bne	skip_l2en	@ Skip if already enabled
+	mov	r0, #L2X0_CTRL_EN
+	str	r0, [r2, #L2X0_CTRL]
+skip_l2en:
+
+	/* Enable the L1 D-cache */
+	mrc	p15, 0, r0, c1, c0, 0
+	tst	r0, #(1 << 2)		@ Check C bit enabled?
+	orreq	r0, r0, #(1 << 2)	@ Enable the C bit
+	mcreq	p15, 0, r0, c1, c0, 0
+	isb
+
+	ldmfd	sp!, {r4 - r12, pc}
+ENDPROC(at91_enable_l1_l2_cache)
+
+at91_l2cc_base_addr:
+	.word	at91_l2cc_base
+#endif
-- 
1.7.9.5

