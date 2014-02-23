Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbaBWVkg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 16:40:36 -0500
Received: from www.linutronix.de ([62.245.132.108]:52392 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbaBWVkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 16:40:31 -0500
Message-Id: <20140223212737.099151500@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Feb 2014 21:40:12 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        arm <linux-arm-kernel@lists.infradead.org>,
        omap <linux-omap@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [patch 08/26] arm: Replace various irq_desc accesses
References: <20140223212703.511977310@linutronix.de>
Content-Disposition: inline;
 filename=arm-replace-various-irq-to-desc-accesses.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the proper functions. There is no need to fiddle with irq_desc.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: arm <linux-arm-kernel@lists.infradead.org>
Cc: omap <linux-omap@vger.kernel.org>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/mach-imx/pm-imx6q.c        |    7 +++----
 arch/arm/mach-omap1/ams-delta-fiq.c |    7 ++-----
 2 files changed, 5 insertions(+), 9 deletions(-)

Index: tip/arch/arm/mach-imx/pm-imx6q.c
===================================================================
--- tip.orig/arch/arm/mach-imx/pm-imx6q.c
+++ tip/arch/arm/mach-imx/pm-imx6q.c
@@ -120,7 +120,7 @@ static void imx6q_enable_wb(bool enable)
 
 int imx6q_set_lpm(enum mxc_cpu_pwr_mode mode)
 {
-	struct irq_desc *iomuxc_irq_desc;
+	struct irq_data *iomuxc_irq_data = irq_get_irq_data(32);
 	u32 val = readl_relaxed(ccm_base + CLPCR);
 
 	val &= ~BM_CLPCR_LPM;
@@ -167,10 +167,9 @@ int imx6q_set_lpm(enum mxc_cpu_pwr_mode
 	 * 3) Software should mask IRQ #32 right after CCM Low-Power mode
 	 *    is set (set bits 0-1 of CCM_CLPCR).
 	 */
-	iomuxc_irq_desc = irq_to_desc(32);
-	imx_gpc_irq_unmask(&iomuxc_irq_desc->irq_data);
+	imx_gpc_irq_unmask(iomuxc_irq_data);
 	writel_relaxed(val, ccm_base + CLPCR);
-	imx_gpc_irq_mask(&iomuxc_irq_desc->irq_data);
+	imx_gpc_irq_mask(iomuxc_irq_data);
 
 	return 0;
 }
Index: tip/arch/arm/mach-omap1/ams-delta-fiq.c
===================================================================
--- tip.orig/arch/arm/mach-omap1/ams-delta-fiq.c
+++ tip/arch/arm/mach-omap1/ams-delta-fiq.c
@@ -44,13 +44,10 @@ static unsigned int irq_counter[16];
 
 static irqreturn_t deferred_fiq(int irq, void *dev_id)
 {
-	struct irq_desc *irq_desc;
-	struct irq_chip *irq_chip = NULL;
 	int gpio, irq_num, fiq_count;
+	struct irq_chip *irq_chip;
 
-	irq_desc = irq_to_desc(gpio_to_irq(AMS_DELTA_GPIO_PIN_KEYBRD_CLK));
-	if (irq_desc)
-		irq_chip = irq_desc->irq_data.chip;
+	irq_chip = irq_get_irq_chip(gpio_to_irq(AMS_DELTA_GPIO_PIN_KEYBRD_CLK));
 
 	/*
 	 * For each handled GPIO interrupt, keep calling its interrupt handler


