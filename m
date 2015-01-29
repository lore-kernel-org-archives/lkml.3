Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbbA2GiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 01:38:09 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:48405 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbbA2GiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 01:38:08 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <nicolas.ferre@atmel.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alexandre.belloni@free-electrons.com>, <sylvain.rochet@finsecur.com>,
        <peda@axentia.se>, <sergei.shtylyov@cogentembedded.com>,
        <linux@maxim.org.za>, <wenyou.yang@atmel.com>
Subject: [PATCH v5 01/13] pm: at91: pm_slowclock: fix suspend/resume hang up in timeouts
Date: Thu, 29 Jan 2015 14:36:02 +0800
Message-ID: <1422513362-22096-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422513316-21509-1-git-send-email-wenyou.yang@atmel.com>
References: <1422513316-21509-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sylvain Rochet <sylvain.rochet@finsecur.com>

Removed timeout on XTAL, PLL lock and Master Clock Ready, hang if
something went wrong instead of continuing in unknown condition. There
is not much we can do if a PLL lock never ends, we are running in SRAM
and we will not be able to connect back the sdram or ddram in order to
be able to fire up a message or just panic.

As a bonus, not decounting the timeout register in slow clock mode
reduce cumulated suspend time and resume time from ~17ms to ~15ms.

Signed-off-by: Sylvain Rochet <sylvain.rochet@finsecur.com>
---
 arch/arm/mach-at91/pm_slowclock.S |   33 ++++-----------------------------
 1 file changed, 4 insertions(+), 29 deletions(-)

diff --git a/arch/arm/mach-at91/pm_slowclock.S b/arch/arm/mach-at91/pm_slowclock.S
index 556151e..50744e7 100644
--- a/arch/arm/mach-at91/pm_slowclock.S
+++ b/arch/arm/mach-at91/pm_slowclock.S
@@ -25,11 +25,6 @@
  */
 #undef SLOWDOWN_MASTER_CLOCK
 
-#define MCKRDY_TIMEOUT		1000
-#define MOSCRDY_TIMEOUT 	1000
-#define PLLALOCK_TIMEOUT	1000
-#define PLLBLOCK_TIMEOUT	1000
-
 pmc	.req	r0
 sdramc	.req	r1
 ramc1	.req	r2
@@ -41,56 +36,36 @@ tmp2	.req	r5
  * Wait until master clock is ready (after switching master clock source)
  */
 	.macro wait_mckrdy
-	mov	tmp2, #MCKRDY_TIMEOUT
-1:	sub	tmp2, tmp2, #1
-	cmp	tmp2, #0
-	beq	2f
-	ldr	tmp1, [pmc, #AT91_PMC_SR]
+1:	ldr	tmp1, [pmc, #AT91_PMC_SR]
 	tst	tmp1, #AT91_PMC_MCKRDY
 	beq	1b
-2:
 	.endm
 
 /*
  * Wait until master oscillator has stabilized.
  */
 	.macro wait_moscrdy
-	mov	tmp2, #MOSCRDY_TIMEOUT
-1:	sub	tmp2, tmp2, #1
-	cmp	tmp2, #0
-	beq	2f
-	ldr	tmp1, [pmc, #AT91_PMC_SR]
+1:	ldr	tmp1, [pmc, #AT91_PMC_SR]
 	tst	tmp1, #AT91_PMC_MOSCS
 	beq	1b
-2:
 	.endm
 
 /*
  * Wait until PLLA has locked.
  */
 	.macro wait_pllalock
-	mov	tmp2, #PLLALOCK_TIMEOUT
-1:	sub	tmp2, tmp2, #1
-	cmp	tmp2, #0
-	beq	2f
-	ldr	tmp1, [pmc, #AT91_PMC_SR]
+1:	ldr	tmp1, [pmc, #AT91_PMC_SR]
 	tst	tmp1, #AT91_PMC_LOCKA
 	beq	1b
-2:
 	.endm
 
 /*
  * Wait until PLLB has locked.
  */
 	.macro wait_pllblock
-	mov	tmp2, #PLLBLOCK_TIMEOUT
-1:	sub	tmp2, tmp2, #1
-	cmp	tmp2, #0
-	beq	2f
-	ldr	tmp1, [pmc, #AT91_PMC_SR]
+1:	ldr	tmp1, [pmc, #AT91_PMC_SR]
 	tst	tmp1, #AT91_PMC_LOCKB
 	beq	1b
-2:
 	.endm
 
 	.text
-- 
1.7.9.5

