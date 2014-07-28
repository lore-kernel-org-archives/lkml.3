Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbaG1VRd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:17:33 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33652 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbaG1VRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:17:30 -0400
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        <bcousson@baylibre.com>, <linux@arm.linux.org.uk>,
        <khilman@deeprootsystems.com>, <tglx@linutronix.de>,
        <jason@lakedaemon.net>, <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 03/35] arm: omap: irq: start to remove irq_banks array
Date: Mon, 28 Jul 2014 16:15:51 -0500
Message-ID: <1406582183-696-4-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.1.563.g66f467c
In-Reply-To: <1406582183-696-1-git-send-email-balbi@ti.com>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a single bank in that array, this patch
is in preparation to remove that array. It just
shifts everything to a new set of functions
for register IO while also removing old ones.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/mach-omap2/irq.c | 64 ++++++++++++++++++++---------------------------
 1 file changed, 27 insertions(+), 37 deletions(-)

diff --git a/arch/arm/mach-omap2/irq.c b/arch/arm/mach-omap2/irq.c
index 96073a2..83163d0 100644
--- a/arch/arm/mach-omap2/irq.c
+++ b/arch/arm/mach-omap2/irq.c
@@ -82,21 +82,20 @@ struct omap3_intc_regs {
 };
 
 /* INTC bank register get/set */
-
-static void intc_bank_write_reg(u32 val, struct omap_irq_bank *bank, u16 reg)
+static void intc_writel(u32 reg, u32 val)
 {
-	writel_relaxed(val, bank->base_reg + reg);
+	writel_relaxed(val, omap_irq_base + reg);
 }
 
-static u32 intc_bank_read_reg(struct omap_irq_bank *bank, u16 reg)
+static u32 intc_readl(u32 reg)
 {
-	return readl_relaxed(bank->base_reg + reg);
+	return readl_relaxed(omap_irq_base + reg);
 }
 
 /* XXX: FIQ and additional INTC support (only MPU at the moment) */
 static void omap_ack_irq(struct irq_data *d)
 {
-	intc_bank_write_reg(0x1, &irq_banks[0], INTC_CONTROL);
+	intc_writel(INTC_CONTROL, 0x1);
 }
 
 static void omap_mask_ack_irq(struct irq_data *d)
@@ -109,19 +108,19 @@ static void __init omap_irq_bank_init_one(struct omap_irq_bank *bank)
 {
 	unsigned long tmp;
 
-	tmp = intc_bank_read_reg(bank, INTC_REVISION) & 0xff;
+	tmp = intc_readl(INTC_REVISION) & 0xff;
 	pr_info("IRQ: Found an INTC at 0x%p (revision %ld.%ld) with %d interrupts\n",
 		bank->base_reg, tmp >> 4, tmp & 0xf, bank->nr_irqs);
 
-	tmp = intc_bank_read_reg(bank, INTC_SYSCONFIG);
+	tmp = intc_readl(INTC_SYSCONFIG);
 	tmp |= 1 << 1;	/* soft reset */
-	intc_bank_write_reg(tmp, bank, INTC_SYSCONFIG);
+	intc_writel(INTC_SYSCONFIG, tmp);
 
-	while (!(intc_bank_read_reg(bank, INTC_SYSSTATUS) & 0x1))
+	while (!(intc_readl(INTC_SYSSTATUS) & 0x1))
 		/* Wait for reset to complete */;
 
 	/* Enable autoidle */
-	intc_bank_write_reg(1 << 0, bank, INTC_SYSCONFIG);
+	intc_writel(INTC_SYSCONFIG, 1 << 0);
 }
 
 int omap_irq_pending(void)
@@ -133,7 +132,7 @@ int omap_irq_pending(void)
 		int irq;
 
 		for (irq = 0; irq < bank->nr_irqs; irq += 32)
-			if (intc_bank_read_reg(bank, INTC_PENDING_IRQ0 +
+			if (intc_readl(INTC_PENDING_IRQ0 +
 					       ((irq >> 5) << 5)))
 				return 1;
 	}
@@ -307,22 +306,20 @@ void omap_intc_save_context(void)
 {
 	int ind = 0, i = 0;
 	for (ind = 0; ind < ARRAY_SIZE(irq_banks); ind++) {
-		struct omap_irq_bank *bank = irq_banks + ind;
 		intc_context[ind].sysconfig =
-			intc_bank_read_reg(bank, INTC_SYSCONFIG);
+			intc_readl(INTC_SYSCONFIG);
 		intc_context[ind].protection =
-			intc_bank_read_reg(bank, INTC_PROTECTION);
+			intc_readl(INTC_PROTECTION);
 		intc_context[ind].idle =
-			intc_bank_read_reg(bank, INTC_IDLE);
+			intc_readl(INTC_IDLE);
 		intc_context[ind].threshold =
-			intc_bank_read_reg(bank, INTC_THRESHOLD);
+			intc_readl(INTC_THRESHOLD);
 		for (i = 0; i < INTCPS_NR_IRQS; i++)
 			intc_context[ind].ilr[i] =
-				intc_bank_read_reg(bank, (0x100 + 0x4*i));
+				intc_readl((INTC_ILR0 + 0x4 * i));
 		for (i = 0; i < INTCPS_NR_MIR_REGS; i++)
 			intc_context[ind].mir[i] =
-				intc_bank_read_reg(&irq_banks[0], INTC_MIR0 +
-				(0x20 * i));
+				intc_readl(INTC_MIR0 + (0x20 * i));
 	}
 }
 
@@ -331,23 +328,16 @@ void omap_intc_restore_context(void)
 	int ind = 0, i = 0;
 
 	for (ind = 0; ind < ARRAY_SIZE(irq_banks); ind++) {
-		struct omap_irq_bank *bank = irq_banks + ind;
-		intc_bank_write_reg(intc_context[ind].sysconfig,
-					bank, INTC_SYSCONFIG);
-		intc_bank_write_reg(intc_context[ind].sysconfig,
-					bank, INTC_SYSCONFIG);
-		intc_bank_write_reg(intc_context[ind].protection,
-					bank, INTC_PROTECTION);
-		intc_bank_write_reg(intc_context[ind].idle,
-					bank, INTC_IDLE);
-		intc_bank_write_reg(intc_context[ind].threshold,
-					bank, INTC_THRESHOLD);
+		intc_writel(INTC_SYSCONFIG, intc_context[ind].sysconfig);
+		intc_writel(INTC_PROTECTION, intc_context[ind].protection);
+		intc_writel(INTC_IDLE, intc_context[ind].idle);
+		intc_writel(INTC_THRESHOLD, intc_context[ind].threshold);
 		for (i = 0; i < INTCPS_NR_IRQS; i++)
-			intc_bank_write_reg(intc_context[ind].ilr[i],
-				bank, (0x100 + 0x4*i));
+			intc_writel(INTC_ILR0 + 0x4 * i,
+					intc_context[ind].ilr[i]);
 		for (i = 0; i < INTCPS_NR_MIR_REGS; i++)
-			intc_bank_write_reg(intc_context[ind].mir[i],
-				 &irq_banks[0], INTC_MIR0 + (0x20 * i));
+			intc_writel(INTC_MIR0 + 0x20 * i,
+				intc_context[ind].mir[i]);
 	}
 	/* MIRs are saved and restore with other PRCM registers */
 }
@@ -364,13 +354,13 @@ void omap3_intc_prepare_idle(void)
 	 * Disable autoidle as it can stall interrupt controller,
 	 * cf. errata ID i540 for 3430 (all revisions up to 3.1.x)
 	 */
-	intc_bank_write_reg(0, &irq_banks[0], INTC_SYSCONFIG);
+	intc_writel(INTC_SYSCONFIG, 0);
 }
 
 void omap3_intc_resume_idle(void)
 {
 	/* Re-enable autoidle */
-	intc_bank_write_reg(1, &irq_banks[0], INTC_SYSCONFIG);
+	intc_writel(INTC_SYSCONFIG, 1);
 }
 
 asmlinkage void __exception_irq_entry omap3_intc_handle_irq(struct pt_regs *regs)
-- 
2.0.1.563.g66f467c

