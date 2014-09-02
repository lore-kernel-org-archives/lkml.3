Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267AbaIBNDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 09:03:39 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45415 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216AbaIBNDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 09:03:37 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        kgdb-bugreport@lists.sourceforge.net, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Nicolas Pitre <nico@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH v11 10/19] irqchip: gic: Group 0 workaround.
Date: Tue,  2 Sep 2014 14:00:44 +0100
Message-Id: <1409662853-29313-11-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org>
References: <1408466769-20004-1-git-send-email-daniel.thompson@linaro.org>
 <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An ARM system based on GICv1 that runs by default in secure mode and
uses both group 0 and group 1 interrupts (in order to exploit FIQ)
will suffer a problem where the IRQ handler occasionally spuriously
acknowledges a group 0 (FIQ) interrupt.

This can be prevented by ensuring the IRQ handler makes non-secure
memory access to the GIC registers but this is complex because
the non-secure bits cannot be apply to 4k pages (the bit is one level
up in the page table and applies to 1MB at a time).

This workaround uses an alternative approach that spots the spurious
acknowledgment and regenerates the FIQ. This keeps the workaround
exclusively within the GIC driver (although there is a runtime
perforamnce penalty resulting from this approach).

Reported-by: Harro Haan <hrhaan@gmail.com>
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Tested-by: Harro Haan <hrhaan@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
---
 drivers/irqchip/irq-gic.c | 52 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 49 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 8834749..bda5a91 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -279,14 +279,59 @@ static int gic_set_wake(struct irq_data *d, unsigned int on)
 #define gic_set_wake	NULL
 #endif
 
+#ifdef CONFIG_FIQ
+/* This is a software emulation of the Aliased Interrupt Acknowledge Register
+ * (GIC_AIAR) found in GICv2+.
+ */
+static u32 gic_handle_spurious_group_0(struct gic_chip_data *gic, u32 irqstat)
+{
+	u32 irqnr = irqstat & GICC_IAR_INT_ID_MASK;
+	void __iomem *dist_base = gic_data_dist_base(gic);
+	u32 offset, mask;
+
+	if (!gic_data_fiq_enable(gic) || irqnr >= 1021)
+		return irqstat;
+
+	offset = irqnr / 32 * 4;
+	mask = 1 << (irqnr % 32);
+	if (readl_relaxed(dist_base + GIC_DIST_IGROUP + offset) & mask)
+		return irqstat;
+
+	/* this interrupt must be taken as a FIQ so put it back into the
+	 * pending state and end our own servicing of it.
+	 */
+	writel_relaxed(mask, dist_base + GIC_DIST_PENDING_SET + offset);
+	readl_relaxed(dist_base + GIC_DIST_PENDING_SET + offset);
+	writel_relaxed(irqstat, gic_data_cpu_base(gic) + GIC_CPU_EOI);
+
+	return 1023;
+}
+
+static u32 gic_ack_irq(struct gic_chip_data *gic)
+{
+	u32 irqstat;
+
+	local_fiq_disable();
+	irqstat = readl_relaxed(gic_data_cpu_base(gic) + GIC_CPU_INTACK);
+	irqstat = gic_handle_spurious_group_0(gic, irqstat);
+	local_fiq_enable();
+
+	return irqstat;
+}
+#else
+static u32 gic_ack_irq(struct gic_chip_data *gic)
+{
+	return readl_relaxed(gic_data_cpu_base(gic) + GIC_CPU_INTACK);
+}
+#endif
+
 static void __exception_irq_entry gic_handle_irq(struct pt_regs *regs)
 {
 	u32 irqstat, irqnr;
 	struct gic_chip_data *gic = &gic_data[0];
-	void __iomem *cpu_base = gic_data_cpu_base(gic);
 
 	do {
-		irqstat = readl_relaxed(cpu_base + GIC_CPU_INTACK);
+		irqstat = gic_ack_irq(gic);
 		irqnr = irqstat & GICC_IAR_INT_ID_MASK;
 
 		if (likely(irqnr > 15 && irqnr < 1021)) {
@@ -295,7 +340,8 @@ static void __exception_irq_entry gic_handle_irq(struct pt_regs *regs)
 			continue;
 		}
 		if (irqnr < 16) {
-			writel_relaxed(irqstat, cpu_base + GIC_CPU_EOI);
+			writel_relaxed(irqstat,
+				       gic_data_cpu_base(gic) + GIC_CPU_EOI);
 #ifdef CONFIG_SMP
 			handle_IPI(irqnr, regs);
 #endif
-- 
1.9.3

