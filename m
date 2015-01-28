Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934295AbbA1CZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:25:48 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:38651 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933308AbbA1CZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 21:25:46 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <nicolas.ferre@atmel.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alexandre.belloni@free-electrons.com>, <sylvain.rochet@finsecur.com>,
        <peda@axentia.se>, <sergei.shtylyov@cogentembedded.com>,
        <linux@maxim.org.za>, <wenyou.yang@atmel.com>
Subject: [PATCH v2 1/3] pm: at91: pm_suspend: add the WFI support for ARMv7
Date: Wed, 28 Jan 2015 10:22:37 +0800
Message-ID: <1422411757-13066-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422411707-10945-1-git-send-email-wenyou.yang@atmel.com>
References: <1422411707-10945-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the WFI support to put the cpu to the sleep state.

In the meanwhile, disable the processor's clock.

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 arch/arm/mach-at91/pm_suspend.S |   49 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/pm_suspend.S b/arch/arm/mach-at91/pm_suspend.S
index 122a3f1..aed6903 100644
--- a/arch/arm/mach-at91/pm_suspend.S
+++ b/arch/arm/mach-at91/pm_suspend.S
@@ -53,6 +53,53 @@ mode	.req	r6
 	beq	1b
 	.endm
 
+/*
+ * Put the processor to enter the WFI state
+ */
+	.macro _do_wfi
+
+#if defined(CONFIG_CPU_V7)
+	/*
+	 * Execute an ISB instruction to flush the pipeline to ensure
+	 * that all of operations have beem completed.
+	 */
+	isb
+
+	dsb
+	dmb
+
+	/* Disable the processor's clock */
+	mov	tmp1, #AT91_PMC_PCK
+	str	tmp1, [pmc, #AT91_PMC_SCDR]
+
+	wfi
+
+	/*
+	 * CPU can speculatively prefetch the instructions
+	 * so add NOPs after WFI. Sixteen NOPs as Cortex-A5 pipeline.
+	 */
+	nop
+	nop
+	nop
+	nop
+	nop
+	nop
+	nop
+	nop
+	nop
+	nop
+	nop
+	nop
+	nop
+	nop
+	nop
+	nop
+#else
+	mcr	p15, 0, tmp1, c7, c0, 4
+#endif
+
+	.endm
+
 	.text
 
 /*
@@ -181,7 +228,7 @@ sdr_sr_done:
 
 skip_disable_main_clock:
 	/* Wait for interrupt */
-	mcr	p15, 0, tmp1, c7, c0, 4
+	_do_wfi
 
 	tst	mode, #AT91_PM_SLOW_CLOCK
 	beq	skip_enable_main_clock
-- 
1.7.9.5

