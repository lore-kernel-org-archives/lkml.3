Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbbATIYD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 03:24:03 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:56128 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbbATIYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 03:24:00 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <nicolas.ferre@atmel.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alexandre.belloni@free-electrons.com>, <sylvain.rochet@finsecur.com>,
        <peda@axentia.se>, <wenyou.yang@atmel.com>
Subject: [PATCH 09/12] pm: at91: rename function name: at91_slow_clock()-->at91_pm_suspend_sram_fn
Date: Tue, 20 Jan 2015 16:17:02 +0800
Message-ID: <1421741825-18226-10-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1421741825-18226-1-git-send-email-wenyou.yang@atmel.com>
References: <1421741825-18226-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the file name's renaming, rename the file name at91_slow_clock()-->
at91_pm_suspend_sram_fn, rename the function handler's name at the same time.

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/pm.c         |   23 +++++++++++------------
 arch/arm/mach-at91/pm_suspend.S |   26 ++++++++++++--------------
 2 files changed, 23 insertions(+), 26 deletions(-)

diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index a1010f0..98dfeb2 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -137,13 +137,12 @@ int at91_suspend_entering_slow_clock(void)
 }
 EXPORT_SYMBOL(at91_suspend_entering_slow_clock);
 
-
-static void (*slow_clock)(void __iomem *pmc, void __iomem *ramc0,
+static void (*at91_suspend_sram_fn)(void __iomem *pmc, void __iomem *ramc0,
 			  void __iomem *ramc1, int memctrl);
 
-extern void at91_slow_clock(void __iomem *pmc, void __iomem *ramc0,
+extern void at91_pm_suspend_in_sram(void __iomem *pmc, void __iomem *ramc0,
 			    void __iomem *ramc1, int memctrl);
-extern u32 at91_slow_clock_sz;
+extern u32 at91_pm_suspend_in_sram_sz;
 
 static void at91_pm_suspend(suspend_state_t state)
 {
@@ -152,8 +151,8 @@ static void at91_pm_suspend(suspend_state_t state)
 	pm_data |= (state == PM_SUSPEND_MEM) ?
 			(AT91_PM_SLOW_CLOCK << AT91_PM_MODE_OFFSET) : 0;
 
-	slow_clock(at91_pmc_base, at91_ramc_base[0],
-			at91_ramc_base[1], pm_data);
+	at91_suspend_sram_fn(at91_pmc_base, at91_ramc_base[0],
+				at91_ramc_base[1], pm_data);
 }
 
 static int at91_pm_enter(suspend_state_t state)
@@ -253,17 +252,19 @@ static void __init at91_pm_sram_init(void)
 		goto put_node;
 	}
 
-	sram_base = gen_pool_alloc(sram_pool, at91_slow_clock_sz);
+	sram_base = gen_pool_alloc(sram_pool, at91_pm_suspend_in_sram_sz);
 	if (!sram_base) {
 		pr_warn("%s: unable to alloc ocram!\n", __func__);
 		goto put_node;
 	}
 
 	sram_pbase = gen_pool_virt_to_phys(sram_pool, sram_base);
-	slow_clock = __arm_ioremap_exec(sram_pbase, at91_slow_clock_sz, false);
+	at91_suspend_sram_fn = __arm_ioremap_exec(sram_pbase,
+					at91_pm_suspend_in_sram_sz, false);
 
-	/* Copy slow_clock handler to SRAM, and call it */
-	memcpy(slow_clock, at91_slow_clock, at91_slow_clock_sz);
+	/* Copy pm suspend handler to SRAM, and call it */
+	memcpy(at91_suspend_sram_fn,
+		at91_pm_suspend_in_sram, at91_pm_suspend_in_sram_sz);
 
 put_node:
 	of_node_put(node);
@@ -312,8 +313,6 @@ static void __init at91_pm_init(void)
 
 	at91_pm_sram_init();
 
-	pr_info("AT91: Power Management%s\n", (slow_clock ? " (with slow clock mode)" : ""));
-
 	if (at91_cpuidle_device.dev.platform_data)
 		platform_device_register(&at91_cpuidle_device);
 
diff --git a/arch/arm/mach-at91/pm_suspend.S b/arch/arm/mach-at91/pm_suspend.S
index 420e730..6c3fc50 100644
--- a/arch/arm/mach-at91/pm_suspend.S
+++ b/arch/arm/mach-at91/pm_suspend.S
@@ -54,23 +54,21 @@ mode	.req	r6
 
 	.text
 
-/* void at91_slow_clock(void __iomem *pmc, void __iomem *sdramc,
+/*
+ * void at91_pm_suspend_in_sram(void __iomem *pmc, void __iomem *sdramc,
  *			void __iomem *ramc1, int memctrl)
+ * @input param:
+ * 	@r0: the base address of AT91_PMC
+ *  	@r1: the base address of SDRAM Controller (SDRAM, DDRSDR, or AT91_SYS)
+ *	@r2: the base address of second SDRAM Controller or 0 if not present
+ *	@r3: the pm information,
+ *		least byte: SDRAM controller type
+ *		2nd byte: 1 -> suspend to memory, 0 -> standby
  */
-ENTRY(at91_slow_clock)
+ENTRY(at91_pm_suspend_in_sram)
 	/* Save registers on stack */
 	stmfd	sp!, {r4 - r12, lr}
 
-	/*
-	 * Register usage:
-	 *  R0 = Base address of AT91_PMC
-	 *  R1 = Base address of RAM Controller (SDRAM, DDRSDR, or AT91_SYS)
-	 *  R2 = Base address of second RAM Controller or 0 if not present
-	 *  R3 = Memory controller
-	 *  R4 = temporary register
-	 *  R5 = temporary register
-	 */
-
 	/* Drain write buffer */
 	mov	tmp1, #0
 	mcr	p15, 0, tmp1, c7, c10, 4
@@ -276,5 +274,5 @@ ram_restored:
 .saved_sam9_mdr1:
 	.word 0
 
-ENTRY(at91_slow_clock_sz)
-	.word .-at91_slow_clock
+ENTRY(at91_pm_suspend_in_sram_sz)
+	.word .-at91_pm_suspend_in_sram
-- 
1.7.9.5

