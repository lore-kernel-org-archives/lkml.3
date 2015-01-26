Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbbAZJnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 04:43:13 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:47176 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085AbbAZJnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 04:43:10 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <nicolas.ferre@atmel.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alexandre.belloni@free-electrons.com>, <sylvain.rochet@finsecur.com>,
        <peda@axentia.se>, <wenyou.yang@atmel.com>
Subject: [PATCH v2 07/12] pm: at91: the standby mode uses the same sram function as the suspend to memory mode
Date: Mon, 26 Jan 2015 17:42:11 +0800
Message-ID: <1422265331-23236-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422265005-22937-1-git-send-email-wenyou.yang@atmel.com>
References: <1422265005-22937-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To simply the PM code, the suspend to standby mode uses the same sram function
as the suspend to memory mode, running in the internal SRAM,
instead of the respective code for each mode.

But for the suspend to standby mode, the master clock doesn't
switch to the slow clock,  and the main oscillator doesn't
turn off as well.

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 arch/arm/mach-at91/pm.c           |   87 +++++++++++++++++--------------------
 arch/arm/mach-at91/pm.h           |    7 +++
 arch/arm/mach-at91/pm_slowclock.S |   18 ++++++++
 3 files changed, 65 insertions(+), 47 deletions(-)

diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index dc2541b..509ac9d 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -71,11 +71,15 @@ static int at91_pm_begin(suspend_state_t state)
  * Verify that all the clocks are correct before entering
  * slow-clock mode.
  */
-static int at91_pm_verify_clocks(void)
+static int at91_pm_verify_clocks(suspend_state_t state)
 {
 	unsigned long scsr;
 	int i;
 
+	/* For PM_SUSPEND_STANDBY, skip verifying the clock */
+	if (state == PM_SUSPEND_STANDBY)
+		return 1;
+
 	scsr = at91_pmc_read(AT91_PMC_SCSR);
 
 	/* USB must not be using PLLB */
@@ -137,62 +141,51 @@ extern void at91_slow_clock(void __iomem *pmc, void __iomem *ramc0,
 			    void __iomem *ramc1, int memctrl);
 extern u32 at91_slow_clock_sz;
 
+static void at91_pm_suspend(suspend_state_t state)
+{
+	unsigned int pm_data = at91_pm_data.memctrl;
+
+	pm_data |= (state == PM_SUSPEND_MEM) ?
+				AT91_PM_MODE(AT91_PM_SLOW_CLOCK) : 0;
+
+	slow_clock(at91_pmc_base, at91_ramc_base[0],
+			at91_ramc_base[1], pm_data);
+}
+
 static int at91_pm_enter(suspend_state_t state)
 {
 	at91_pinctrl_gpio_suspend();
 
 	switch (state) {
+	/*
+	 * Suspend-to-RAM is like STANDBY plus slow clock mode, so
+	 * drivers must suspend more deeply, the master clock switches
+	 * to the clk32k and turns off the main oscillator
+	 *
+	 * STANDBY mode has *all* drivers suspended; ignores irqs not
+	 * marked as 'wakeup' event sources; and reduces DRAM power.
+	 * But otherwise it's identical to PM_SUSPEND_ON:  cpu idle, and
+	 * nothing fancy done with main or cpu clocks.
+	 */
+	case PM_SUSPEND_MEM:
+	case PM_SUSPEND_STANDBY:
 		/*
-		 * Suspend-to-RAM is like STANDBY plus slow clock mode, so
-		 * drivers must suspend more deeply:  only the master clock
-		 * controller may be using the main oscillator.
+		 * Ensure that clocks are in a valid state.
 		 */
-		case PM_SUSPEND_MEM:
-			/*
-			 * Ensure that clocks are in a valid state.
-			 */
-			if (!at91_pm_verify_clocks())
-				goto error;
-
-			/*
-			 * Enter slow clock mode by switching over to clk32k and
-			 * turning off the main oscillator; reverse on wakeup.
-			 */
-			if (slow_clock) {
-				slow_clock(at91_pmc_base, at91_ramc_base[0],
-					   at91_ramc_base[1],
-					   at91_pm_data.memctrl);
-				break;
-			} else {
-				pr_info("AT91: PM - no slow clock mode enabled ...\n");
-				/* FALLTHROUGH leaving master clock alone */
-			}
+		if (!at91_pm_verify_clocks(state))
+			goto error;
 
-		/*
-		 * STANDBY mode has *all* drivers suspended; ignores irqs not
-		 * marked as 'wakeup' event sources; and reduces DRAM power.
-		 * But otherwise it's identical to PM_SUSPEND_ON:  cpu idle, and
-		 * nothing fancy done with main or cpu clocks.
-		 */
-		case PM_SUSPEND_STANDBY:
-			/*
-			 * NOTE: the Wait-for-Interrupt instruction needs to be
-			 * in icache so no SDRAM accesses are needed until the
-			 * wakeup IRQ occurs and self-refresh is terminated.
-			 * For ARM 926 based chips, this requirement is weaker
-			 * as at91sam9 can access a RAM in self-refresh mode.
-			 */
-			if (at91_pm_standby)
-				at91_pm_standby();
-			break;
+		at91_pm_suspend(state);
 
-		case PM_SUSPEND_ON:
-			cpu_do_idle();
-			break;
+		break;
 
-		default:
-			pr_debug("AT91: PM - bogus suspend state %d\n", state);
-			goto error;
+	case PM_SUSPEND_ON:
+		cpu_do_idle();
+		break;
+
+	default:
+		pr_debug("AT91: PM - bogus suspend state %d\n", state);
+		goto error;
 	}
 
 error:
diff --git a/arch/arm/mach-at91/pm.h b/arch/arm/mach-at91/pm.h
index d2c8996..5bc9c33 100644
--- a/arch/arm/mach-at91/pm.h
+++ b/arch/arm/mach-at91/pm.h
@@ -15,6 +15,13 @@
 
 #include <mach/at91_ramc.h>
 
+#define	AT91_PM_MEMCTRL_MASK	0x0f
+#define	AT91_PM_MODE_OFFSET	4
+#define	AT91_PM_MODE_MASK	0x0f
+#define	AT91_PM_MODE(x)		(((x) & AT91_PM_MODE_MASK) << AT91_PM_MODE_OFFSET)
+
+#define	AT91_PM_SLOW_CLOCK	0x01
+
 #ifdef CONFIG_PM
 extern void at91_pm_set_standby(void (*at91_standby)(void));
 #else
diff --git a/arch/arm/mach-at91/pm_slowclock.S b/arch/arm/mach-at91/pm_slowclock.S
index 4e55665..f56d114 100644
--- a/arch/arm/mach-at91/pm_slowclock.S
+++ b/arch/arm/mach-at91/pm_slowclock.S
@@ -16,12 +16,15 @@
 #include <mach/hardware.h>
 #include <mach/at91_ramc.h>
 
+#include "pm.h"
+
 pmc	.req	r0
 sdramc	.req	r1
 ramc1	.req	r2
 memctrl	.req	r3
 tmp1	.req	r4
 tmp2	.req	r5
+mode	.req	r6
 
 /*
  * Wait until master clock is ready (after switching master clock source)
@@ -73,6 +76,13 @@ ENTRY(at91_slow_clock)
 	mov	tmp1, #0
 	mcr	p15, 0, tmp1, c7, c10, 4
 
+	mov	tmp1, memctrl
+	mov	tmp2, tmp1, lsr#AT91_PM_MODE_OFFSET
+	and	mode, tmp2, #AT91_PM_MODE_MASK
+
+	mov	tmp1, memctrl
+	and	memctrl, tmp1, #AT91_PM_MEMCTRL_MASK
+
 	cmp	memctrl, #AT91_MEMCTRL_MC
 	bne	ddr_sr_enable
 
@@ -145,6 +155,9 @@ sdr_sr_enable:
 	str	tmp1, [sdramc, #AT91_SDRAMC_LPR]
 
 sdr_sr_done:
+	tst	mode, #AT91_PM_SLOW_CLOCK
+	beq	skip_disable_main_clock
+
 	/* Save Master clock setting */
 	ldr	tmp1, [pmc, #AT91_PMC_MCKR]
 	str	tmp1, .saved_mckr
@@ -170,9 +183,13 @@ sdr_sr_done:
 	bic	tmp1, tmp1, #AT91_PMC_MOSCEN
 	str	tmp1, [pmc, #AT91_CKGR_MOR]
 
+skip_disable_main_clock:
 	/* Wait for interrupt */
 	mcr	p15, 0, tmp1, c7, c0, 4
 
+	tst	mode, #AT91_PM_SLOW_CLOCK
+	beq	skip_enable_main_clock
+
 	/* Turn on the main oscillator */
 	ldr	tmp1, [pmc, #AT91_CKGR_MOR]
 	orr	tmp1, tmp1, #AT91_PMC_MOSCEN
@@ -200,6 +217,7 @@ sdr_sr_done:
 
 	wait_mckrdy
 
+skip_enable_main_clock:
 	/*
 	 * at91rm9200 Memory controller
 	 * Do nothing - self-refresh is automatically disabled.
-- 
1.7.9.5

