Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705AbaHRONY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 10:13:24 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:48346 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaHRONR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 10:13:17 -0400
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
        Jason Cooper <jason@lakedaemon.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Sricharan R <r.sricharan@ti.com>
Subject: [PATCH v9 07/16] irqchip: gic: Add support for FIQ management
Date: Mon, 18 Aug 2014 15:12:55 +0100
Message-Id: <1408371184-12576-8-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404979427-12943-1-git-send-email-daniel.thompson@linaro.org>
References: <1404979427-12943-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces callbacks to route interrupts to or away
from the FIQ signal and registers these callbacks with the FIQ
infrastructure (if the device can supports it).

Both these aspects combine and allow a driver to deploy a FIQ handler
without any machine specific knowledge; it can be used effectively on
multi-platform kernels.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Sricharan R <r.sricharan@ti.com>
---
 drivers/irqchip/irq-gic.c | 69 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 423707c..6fa0542 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -342,6 +342,69 @@ static struct irq_chip gic_chip = {
 };
 
 #ifdef CONFIG_FIQ
+/*
+ * Shift an interrupt between Group 0 and Group 1.
+ *
+ * In addition to changing the group we also modify the priority to
+ * match what "ARM strongly recommends" for a system where no Group 1
+ * interrupt must ever preempt a Group 0 interrupt.
+ */
+static void gic_set_group_irq(struct irq_data *d, int group)
+{
+	unsigned int grp_reg = gic_irq(d) / 32 * 4;
+	u32 grp_mask = 1 << (gic_irq(d) % 32);
+	u32 grp_val;
+
+	unsigned int pri_reg = (gic_irq(d) / 4) * 4;
+	u32 pri_mask = 1 << (7 + ((gic_irq(d) % 4) * 8));
+	u32 pri_val;
+
+	raw_spin_lock(&irq_controller_lock);
+
+	grp_val = readl_relaxed(gic_dist_base(d) + GIC_DIST_IGROUP + grp_reg);
+	pri_val = readl_relaxed(gic_dist_base(d) + GIC_DIST_PRI + pri_reg);
+
+	if (group) {
+		grp_val |= grp_mask;
+		pri_val |= pri_mask;
+	} else {
+		grp_val &= ~grp_mask;
+		pri_val &= ~pri_mask;
+	}
+
+	writel_relaxed(grp_val, gic_dist_base(d) + GIC_DIST_IGROUP + grp_reg);
+	writel_relaxed(pri_val, gic_dist_base(d) + GIC_DIST_PRI + pri_reg);
+
+	raw_spin_unlock(&irq_controller_lock);
+}
+
+static void gic_enable_fiq(struct irq_data *d)
+{
+	gic_set_group_irq(d, 0);
+}
+
+static void gic_disable_fiq(struct irq_data *d)
+{
+	gic_set_group_irq(d, 1);
+}
+
+static int gic_ack_fiq(struct irq_data *d)
+{
+	struct gic_chip_data *gic = irq_data_get_irq_chip_data(d);
+	u32 irqstat, irqnr;
+
+	irqstat = readl_relaxed(gic_data_cpu_base(gic) + GIC_CPU_INTACK);
+	irqnr = irqstat & GICC_IAR_INT_ID_MASK;
+	return irq_find_mapping(gic->domain, irqnr);
+}
+
+static struct fiq_chip gic_fiq = {
+	.fiq_enable		= gic_enable_fiq,
+	.fiq_disable            = gic_disable_fiq,
+	.fiq_ack		= gic_ack_fiq,
+	.fiq_eoi		= gic_eoi_irq,
+};
+
 static void __init gic_init_fiq(struct gic_chip_data *gic,
 				irq_hw_number_t first_irq,
 				unsigned int num_irqs)
@@ -370,6 +433,12 @@ static void __init gic_init_fiq(struct gic_chip_data *gic,
 
 	if (!gic->fiq_enable)
 		return;
+
+	/*
+	 * FIQ is supported on this device! Register our chip data.
+	 */
+	for (i = 0; i < num_irqs; i++)
+		fiq_register_mapping(first_irq + i, &gic_fiq);
 }
 #else /* CONFIG_FIQ */
 static inline void gic_init_fiq(struct gic_chip_data *gic,
-- 
1.9.3

