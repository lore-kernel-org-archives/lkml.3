Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbaG1VSB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:18:01 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37268 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbaG1VRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:17:38 -0400
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
Subject: [PATCH 11/35] arm: omap: irq: reorganize code a little bit
Date: Mon, 28 Jul 2014 16:15:59 -0500
Message-ID: <1406582183-696-12-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.1.563.g66f467c
In-Reply-To: <1406582183-696-1-git-send-email-balbi@ti.com>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

no functional changes, just moving code around.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/mach-omap2/irq.c | 133 +++++++++++++++++++++++-----------------------
 1 file changed, 66 insertions(+), 67 deletions(-)

diff --git a/arch/arm/mach-omap2/irq.c b/arch/arm/mach-omap2/irq.c
index adc2d33..266dc0c 100644
--- a/arch/arm/mach-omap2/irq.c
+++ b/arch/arm/mach-omap2/irq.c
@@ -57,10 +57,6 @@
  * for each bank.. when in doubt, consult the TRM.
  */
 
-static struct irq_domain *domain;
-static void __iomem *omap_irq_base;
-static int omap_nr_irqs = 96;
-
 /* Structure to save interrupt controller context */
 struct omap_intc_regs {
 	u32 sysconfig;
@@ -70,6 +66,11 @@ struct omap_intc_regs {
 	u32 ilr[INTCPS_NR_ILR_REGS];
 	u32 mir[INTCPS_NR_MIR_REGS];
 };
+static struct omap_intc_regs intc_context;
+
+static struct irq_domain *domain;
+static void __iomem *omap_irq_base;
+static int omap_nr_irqs = 96;
 
 /* INTC bank register get/set */
 static void intc_writel(u32 reg, u32 val)
@@ -82,6 +83,61 @@ static u32 intc_readl(u32 reg)
 	return readl_relaxed(omap_irq_base + reg);
 }
 
+void omap_intc_save_context(void)
+{
+	int i;
+
+	intc_context.sysconfig =
+		intc_readl(INTC_SYSCONFIG);
+	intc_context.protection =
+		intc_readl(INTC_PROTECTION);
+	intc_context.idle =
+		intc_readl(INTC_IDLE);
+	intc_context.threshold =
+		intc_readl(INTC_THRESHOLD);
+
+	for (i = 0; i < omap_nr_irqs; i++)
+		intc_context.ilr[i] =
+			intc_readl((INTC_ILR0 + 0x4 * i));
+	for (i = 0; i < INTCPS_NR_MIR_REGS; i++)
+		intc_context.mir[i] =
+			intc_readl(INTC_MIR0 + (0x20 * i));
+}
+
+void omap_intc_restore_context(void)
+{
+	int i;
+
+	intc_writel(INTC_SYSCONFIG, intc_context.sysconfig);
+	intc_writel(INTC_PROTECTION, intc_context.protection);
+	intc_writel(INTC_IDLE, intc_context.idle);
+	intc_writel(INTC_THRESHOLD, intc_context.threshold);
+
+	for (i = 0; i < omap_nr_irqs; i++)
+		intc_writel(INTC_ILR0 + 0x4 * i,
+				intc_context.ilr[i]);
+
+	for (i = 0; i < INTCPS_NR_MIR_REGS; i++)
+		intc_writel(INTC_MIR0 + 0x20 * i,
+			intc_context.mir[i]);
+	/* MIRs are saved and restore with other PRCM registers */
+}
+
+void omap3_intc_prepare_idle(void)
+{
+	/*
+	 * Disable autoidle as it can stall interrupt controller,
+	 * cf. errata ID i540 for 3430 (all revisions up to 3.1.x)
+	 */
+	intc_writel(INTC_SYSCONFIG, 0);
+}
+
+void omap3_intc_resume_idle(void)
+{
+	/* Re-enable autoidle */
+	intc_writel(INTC_SYSCONFIG, 1);
+}
+
 /* XXX: FIQ and additional INTC support (only MPU at the moment) */
 static void omap_ack_irq(struct irq_data *d)
 {
@@ -125,6 +181,12 @@ int omap_irq_pending(void)
 	return 0;
 }
 
+void omap3_intc_suspend(void)
+{
+	/* A pending interrupt would prevent OMAP from entering suspend */
+	omap_ack_irq(NULL);
+}
+
 static __init void
 omap_alloc_gc(void __iomem *base, unsigned int irq_start, unsigned int num)
 {
@@ -265,69 +327,6 @@ void __init omap_intc_of_init(void)
 	of_irq_init(irq_match);
 }
 
-static struct omap_intc_regs intc_context;
-
-void omap_intc_save_context(void)
-{
-	int i;
-
-	intc_context.sysconfig =
-		intc_readl(INTC_SYSCONFIG);
-	intc_context.protection =
-		intc_readl(INTC_PROTECTION);
-	intc_context.idle =
-		intc_readl(INTC_IDLE);
-	intc_context.threshold =
-		intc_readl(INTC_THRESHOLD);
-
-	for (i = 0; i < omap_nr_irqs; i++)
-		intc_context.ilr[i] =
-			intc_readl((INTC_ILR0 + 0x4 * i));
-	for (i = 0; i < INTCPS_NR_MIR_REGS; i++)
-		intc_context.mir[i] =
-			intc_readl(INTC_MIR0 + (0x20 * i));
-}
-
-void omap_intc_restore_context(void)
-{
-	int i;
-
-	intc_writel(INTC_SYSCONFIG, intc_context.sysconfig);
-	intc_writel(INTC_PROTECTION, intc_context.protection);
-	intc_writel(INTC_IDLE, intc_context.idle);
-	intc_writel(INTC_THRESHOLD, intc_context.threshold);
-
-	for (i = 0; i < omap_nr_irqs; i++)
-		intc_writel(INTC_ILR0 + 0x4 * i,
-				intc_context.ilr[i]);
-
-	for (i = 0; i < INTCPS_NR_MIR_REGS; i++)
-		intc_writel(INTC_MIR0 + 0x20 * i,
-			intc_context.mir[i]);
-	/* MIRs are saved and restore with other PRCM registers */
-}
-
-void omap3_intc_suspend(void)
-{
-	/* A pending interrupt would prevent OMAP from entering suspend */
-	omap_ack_irq(NULL);
-}
-
-void omap3_intc_prepare_idle(void)
-{
-	/*
-	 * Disable autoidle as it can stall interrupt controller,
-	 * cf. errata ID i540 for 3430 (all revisions up to 3.1.x)
-	 */
-	intc_writel(INTC_SYSCONFIG, 0);
-}
-
-void omap3_intc_resume_idle(void)
-{
-	/* Re-enable autoidle */
-	intc_writel(INTC_SYSCONFIG, 1);
-}
-
 asmlinkage void __exception_irq_entry omap3_intc_handle_irq(struct pt_regs *regs)
 {
 	omap_intc_handle_irq(regs);
-- 
2.0.1.563.g66f467c

