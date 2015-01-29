Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbbA2Giv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 01:38:51 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:48473 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbbA2Giu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 01:38:50 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <nicolas.ferre@atmel.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alexandre.belloni@free-electrons.com>, <sylvain.rochet@finsecur.com>,
        <peda@axentia.se>, <sergei.shtylyov@cogentembedded.com>,
        <linux@maxim.org.za>, <wenyou.yang@atmel.com>
Subject: [PATCH v5 02/13] pm: at91: pm_slowclock: remove clocks which are already stopped when entering slow clock mode
Date: Thu, 29 Jan 2015 14:36:52 +0800
Message-ID: <1422513412-22615-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422513316-21509-1-git-send-email-wenyou.yang@atmel.com>
References: <1422513316-21509-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sylvain Rochet <sylvain.rochet@finsecur.com>

Assume USB PLL and PLL B are already stopped before entering sleep mode,
print a warning if this isn't the case.

Removed PLL B from slow clock code, all drivers are supposed to properly
unprepare clocks.

Signed-off-by: Sylvain Rochet <sylvain.rochet@finsecur.com>
---
 arch/arm/mach-at91/pm.c           |   12 ++++++++++++
 arch/arm/mach-at91/pm_slowclock.S |   31 -------------------------------
 2 files changed, 12 insertions(+), 31 deletions(-)

diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index af8d8af..daa998d 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -100,6 +100,18 @@ static int at91_pm_verify_clocks(void)
 		}
 	}
 
+	/* Drivers should have previously suspended USB PLL */
+	if (at91_pmc_read(AT91_CKGR_UCKR) & AT91_PMC_UPLLEN) {
+		pr_err("AT91: PM - Suspend-to-RAM with USB PLL running\n");
+		return 0;
+	}
+
+	/* Drivers should have previously suspended PLL B */
+	if (at91_pmc_read(AT91_PMC_SR) & AT91_PMC_LOCKB) {
+		pr_err("AT91: PM - Suspend-to-RAM with PLL B running\n");
+		return 0;
+	}
+
 	return 1;
 }
 
diff --git a/arch/arm/mach-at91/pm_slowclock.S b/arch/arm/mach-at91/pm_slowclock.S
index 50744e7..e2bfaf5 100644
--- a/arch/arm/mach-at91/pm_slowclock.S
+++ b/arch/arm/mach-at91/pm_slowclock.S
@@ -59,15 +59,6 @@ tmp2	.req	r5
 	beq	1b
 	.endm
 
-/*
- * Wait until PLLB has locked.
- */
-	.macro wait_pllblock
-1:	ldr	tmp1, [pmc, #AT91_PMC_SR]
-	tst	tmp1, #AT91_PMC_LOCKB
-	beq	1b
-	.endm
-
 	.text
 
 /* void at91_slow_clock(void __iomem *pmc, void __iomem *sdramc,
@@ -173,13 +164,6 @@ sdr_sr_done:
 	orr	tmp1, tmp1, #(1 << 29)		/* bit 29 always set */
 	str	tmp1, [pmc, #AT91_CKGR_PLLAR]
 
-	/* Save PLLB setting and disable it */
-	ldr	tmp1, [pmc, #AT91_CKGR_PLLBR]
-	str	tmp1, .saved_pllbr
-
-	mov	tmp1, #AT91_PMC_PLLCOUNT
-	str	tmp1, [pmc, #AT91_CKGR_PLLBR]
-
 	/* Turn off the main oscillator */
 	ldr	tmp1, [pmc, #AT91_CKGR_MOR]
 	bic	tmp1, tmp1, #AT91_PMC_MOSCEN
@@ -195,18 +179,6 @@ sdr_sr_done:
 
 	wait_moscrdy
 
-	/* Restore PLLB setting */
-	ldr	tmp1, .saved_pllbr
-	str	tmp1, [pmc, #AT91_CKGR_PLLBR]
-
-	tst	tmp1, #(AT91_PMC_MUL &  0xff0000)
-	bne	1f
-	tst	tmp1, #(AT91_PMC_MUL & ~0xff0000)
-	beq	2f
-1:
-	wait_pllblock
-2:
-
 	/* Restore PLLA setting */
 	ldr	tmp1, .saved_pllar
 	str	tmp1, [pmc, #AT91_CKGR_PLLAR]
@@ -285,9 +257,6 @@ ram_restored:
 .saved_pllar:
 	.word 0
 
-.saved_pllbr:
-	.word 0
-
 .saved_sam9_lpr:
 	.word 0
 
-- 
1.7.9.5

