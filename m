Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbbAZKGo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:06:44 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:16765 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbbAZKGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:06:42 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <nicolas.ferre@atmel.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alexandre.belloni@free-electrons.com>, <sylvain.rochet@finsecur.com>,
        <peda@axentia.se>, <wenyou.yang@atmel.com>,
        <Patrice.VILCHEZ@atmel.com>
Subject: [PATCH 2/7] pm: at91: pm_suspend: add the WFI support for ARMv7
Date: Mon, 26 Jan 2015 18:06:01 +0800
Message-ID: <1422266761-24487-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422266617-24381-1-git-send-email-wenyou.yang@atmel.com>
References: <1422266617-24381-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 arch/arm/mach-at91/pm_suspend.S |   54 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 53 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/pm_suspend.S b/arch/arm/mach-at91/pm_suspend.S
index 122a3f1..e796722 100644
--- a/arch/arm/mach-at91/pm_suspend.S
+++ b/arch/arm/mach-at91/pm_suspend.S
@@ -53,6 +53,58 @@ mode	.req	r6
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
+	/*
+	 * Execute an ISB instruction to ensure that all of the
+	 * CP15 register changes have been committed.
+	 */
+	dsb
+	dmb
+
+	/* Disable the processor's clock */
+	mov	tmp1, #AT91_PMC_PCK
+	str	tmp1, [pmc, #AT91_PMC_SCDR]
+
+	/* Execute a WFI instruction */
+	wfi	@ Wait For Interrupt
+
+	/*
+	 * CPU can specualatively prefetch the instructions
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
@@ -181,7 +233,7 @@ sdr_sr_done:
 
 skip_disable_main_clock:
 	/* Wait for interrupt */
-	mcr	p15, 0, tmp1, c7, c0, 4
+	_do_wfi
 
 	tst	mode, #AT91_PM_SLOW_CLOCK
 	beq	skip_enable_main_clock
-- 
1.7.9.5

