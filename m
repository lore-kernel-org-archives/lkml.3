Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbbAZKK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:10:56 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:52838 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbbAZKKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:10:52 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <nicolas.ferre@atmel.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alexandre.belloni@free-electrons.com>, <sylvain.rochet@finsecur.com>,
        <peda@axentia.se>, <wenyou.yang@atmel.com>,
        <Patrice.VILCHEZ@atmel.com>
Subject: [PATCH 7/7] pm: at91: add disable/enable the mpddrc's clock and DDR clock support
Date: Mon, 26 Jan 2015 18:08:58 +0800
Message-ID: <1422266938-24700-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422266617-24381-1-git-send-email-wenyou.yang@atmel.com>
References: <1422266617-24381-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to decrease the power consumption, when go to suspend,
disable the mpddr controller peripheral clock and the DDR clock
after the DDR enters the self-refresh mode.

Due the mpddr controller's issue, postpone the disable clocks operation,
instead of the DDR enters self-fresh mode immediately.

Enable the clocks after resume and before the DDR exits the self-refresh mode.

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 arch/arm/mach-at91/pm.c         |    4 +++
 arch/arm/mach-at91/pm.h         |    8 +++++
 arch/arm/mach-at91/pm_suspend.S |   64 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 76 insertions(+)

diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 50cde92..6bd2a6b 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -145,6 +145,10 @@ static void at91_pm_suspend(suspend_state_t state)
 	pm_data |= (state == PM_SUSPEND_MEM) ?
 				AT91_PM_MODE(AT91_PM_SLOW_CLOCK) : 0;
 
+	pm_data |= AT91_PM_DDRCK(at91_pm_data.ddrck_id);
+
+	pm_data |= AT91_PM_DDRC_ID(at91_pm_data.mpddrc_id[0]);
+
 	/* Disable L1 D-cache and L2 cache */
 	at91_disable_l1_l2_cache();
 
diff --git a/arch/arm/mach-at91/pm.h b/arch/arm/mach-at91/pm.h
index 158575e..fd4c5fc 100644
--- a/arch/arm/mach-at91/pm.h
+++ b/arch/arm/mach-at91/pm.h
@@ -19,6 +19,14 @@
 #define	AT91_PM_MODE_MASK	0x0f
 #define	AT91_PM_MODE(x)		(((x) & AT91_PM_MODE_MASK) << AT91_PM_MODE_OFFSET)
 
+#define	AT91_PM_DDRCK_OFFSET	8
+#define	AT91_PM_DDRCK_MASK	0xff
+#define	AT91_PM_DDRCK(x)	(((x) & AT91_PM_DDRCK_MASK) << AT91_PM_DDRCK_OFFSET)
+
+#define	AT91_PM_DDRC_ID_OFFSET	16
+#define	AT91_PM_DDRC_ID_MASK	0xff
+#define	AT91_PM_DDRC_ID(x)	(((x) & AT91_PM_DDRC_ID_MASK) << AT91_PM_DDRC_ID_OFFSET)
+
 #define	AT91_PM_SLOW_CLOCK	0x01
 
 #endif
diff --git a/arch/arm/mach-at91/pm_suspend.S b/arch/arm/mach-at91/pm_suspend.S
index e6e7f7a..8fb276c 100644
--- a/arch/arm/mach-at91/pm_suspend.S
+++ b/arch/arm/mach-at91/pm_suspend.S
@@ -26,6 +26,8 @@ memctrl	.req	r3
 tmp1	.req	r4
 tmp2	.req	r5
 mode	.req	r6
+ddrc_id	.req	r7
+ddrck	.req	r8
 
 /*
  * Wait until master clock is ready (after switching master clock source)
@@ -130,6 +132,16 @@ ENTRY(at91_pm_suspend_in_sram)
 	and	mode, tmp2, #AT91_PM_MODE_MASK
 
 	mov	tmp1, memctrl
+	mov	tmp2, tmp1, lsr#AT91_PM_DDRCK_OFFSET
+	mov	tmp1, #0x01
+	and	tmp2, tmp2, #AT91_PM_DDRCK_MASK
+	mov	ddrck, tmp1, lsl tmp2
+
+	mov	tmp1, memctrl
+	mov	tmp2, tmp1, lsr#AT91_PM_DDRC_ID_OFFSET
+	and	ddrc_id, tmp2, #AT91_PM_DDRC_ID_MASK
+
+	mov	tmp1, memctrl
 	and	memctrl, tmp1, #AT91_PM_MEMCTRL_MASK
 
 	cmp	memctrl, #AT91_MEMCTRL_MC
@@ -234,6 +246,32 @@ sdr_sr_done:
 	str	tmp1, [pmc, #AT91_CKGR_MOR]
 
 skip_disable_main_clock:
+
+	/*
+	 * Disable the SDRAM controller clock
+	 */
+	cmp	ddrc_id, #0
+	beq	skip_disable_ddrc_clock
+	bic	tmp2, ddrc_id, #0xe0 /* fetch least 5 bits */
+	mov	tmp1, #0x01
+	mov	tmp1, tmp1, lsl tmp2
+
+	tst	ddrc_id, #0xe0	/* > 32 ? */
+	beq	set_pmc_pcdr
+	str	tmp1, [pmc, #AT91_PMC_PCDR1]
+	b	skip_disable_ddrc_clock
+set_pmc_pcdr:
+	str	tmp1, [pmc, #AT91_PMC_PCDR]
+skip_disable_ddrc_clock:
+
+	/*
+	 * Disable SDRAM system clock
+	 */
+	cmp	ddrck, #0
+	beq	skip_disable_ddrck
+	str	ddrck, [pmc, #AT91_PMC_SCDR]
+skip_disable_ddrck:
+
 	/* Wait for interrupt */
 	_do_wfi
 
@@ -269,6 +307,32 @@ skip_disable_main_clock:
 	wait_mckrdy
 
 skip_enable_main_clock:
+
+	/*
+	 * Enable the SDRAM controller clock
+	 */
+	cmp	ddrc_id, #0
+	beq	skip_enable_ddrc_clock
+	bic	tmp2, ddrc_id, #0xe0 /* fetch lowest 5 bits */
+	mov	tmp1, #0x01
+	mov	tmp1, tmp1, lsl tmp2
+
+	tst	ddrc_id, #0xe0	/* > 32 ? */
+	beq	set_pmc_pcer
+	str	tmp1, [pmc, #AT91_PMC_PCER1]
+	b	skip_enable_ddrc_clock
+set_pmc_pcer:
+	str	tmp1, [pmc, #AT91_PMC_PCER]
+skip_enable_ddrc_clock:
+
+	/*
+	 * Enable SDRAM system clock
+	 */
+	cmp	ddrck, #0
+	beq	skip_enable_ddrck
+	str	ddrck, [pmc, #AT91_PMC_SCER]
+skip_enable_ddrck:
+
 	/*
 	 * at91rm9200 Memory controller
 	 * Do nothing - self-refresh is automatically disabled.
-- 
1.7.9.5

