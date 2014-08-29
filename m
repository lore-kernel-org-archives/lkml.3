Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbaH2WO4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 18:14:56 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:58372 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbaH2WOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 18:14:52 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/12] MIPS: GIC: Add generic IPI support when using DT
Date: Fri, 29 Aug 2014 15:14:33 -0700
Message-Id: <1409350479-19108-7-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1409350479-19108-1-git-send-email-abrestic@chromium.org>
References: <1409350479-19108-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When DT-based probing is used for the GIC and the GIC is also used
for IPIs (i.e. MIPS_GIC_IPI=y), set up the last 2 * NR_CPUs GIC
interrupts as the reschedule and call IPIs.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/mips/kernel/irq-gic.c | 86 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/arch/mips/kernel/irq-gic.c b/arch/mips/kernel/irq-gic.c
index be8bea4..42558eb 100644
--- a/arch/mips/kernel/irq-gic.c
+++ b/arch/mips/kernel/irq-gic.c
@@ -10,6 +10,7 @@
 #include <linux/init.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
+#include <linux/sched.h>
 #include <linux/smp.h>
 #include <linux/interrupt.h>
 #include <linux/clocksource.h>
@@ -417,6 +418,89 @@ static inline int gic_irq_to_cpu_pin(unsigned int hwirq)
 		GIC_CPU_PIN_OFFSET;
 }
 
+#ifdef CONFIG_MIPS_GIC_IPI
+static int gic_resched_int_base;
+static int gic_call_int_base;
+
+unsigned int plat_ipi_resched_int_xlate(unsigned int cpu)
+{
+	return gic_resched_int_base + cpu;
+}
+
+unsigned int plat_ipi_call_int_xlate(unsigned int cpu)
+{
+	return gic_call_int_base + cpu;
+}
+
+static irqreturn_t ipi_resched_interrupt(int irq, void *dev_id)
+{
+	scheduler_ipi();
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t ipi_call_interrupt(int irq, void *dev_id)
+{
+	smp_call_function_interrupt();
+
+	return IRQ_HANDLED;
+}
+
+static struct irqaction irq_resched = {
+	.handler	= ipi_resched_interrupt,
+	.flags		= IRQF_PERCPU,
+	.name		= "IPI resched"
+};
+
+static struct irqaction irq_call = {
+	.handler	= ipi_call_interrupt,
+	.flags		= IRQF_PERCPU,
+	.name		= "IPI call"
+};
+
+static __init void gic_ipi_init_one(struct irq_domain *domain,
+				    unsigned int hwirq, int cpu,
+				    struct irqaction *action)
+{
+	int irq = irq_create_mapping(domain, hwirq);
+	int i;
+
+	GIC_SET_POLARITY(hwirq, GIC_POL_POS);
+	GIC_SET_TRIGGER(hwirq, GIC_TRIG_EDGE);
+	GIC_SH_MAP_TO_VPE_SMASK(hwirq, cpu);
+	GICWRITE(GIC_REG_ADDR(SHARED, GIC_SH_MAP_TO_PIN(hwirq)),
+		 GIC_MAP_TO_PIN_MSK | gic_irq_to_cpu_pin(hwirq));
+	GIC_CLR_INTR_MASK(hwirq);
+	gic_irq_flags[hwirq] |= GIC_TRIG_EDGE;
+
+	for (i = 0; i < ARRAY_SIZE(pcpu_masks); i++)
+		clear_bit(hwirq, pcpu_masks[i].pcpu_mask);
+	set_bit(hwirq, pcpu_masks[cpu].pcpu_mask);
+
+	irq_set_chip_and_handler(irq, &gic_irq_controller, handle_percpu_irq);
+	setup_irq(irq, action);
+}
+
+static __init void gic_ipi_init(struct irq_domain *domain)
+{
+	int i;
+
+	/* Use last 2 * NR_CPUS interrupts as IPIs */
+	gic_resched_int_base = GIC_NUM_INTRS - nr_cpu_ids;
+	gic_call_int_base = gic_resched_int_base - nr_cpu_ids;
+
+	for (i = 0; i < nr_cpu_ids; i++) {
+		gic_ipi_init_one(domain, gic_call_int_base + i, i, &irq_call);
+		gic_ipi_init_one(domain, gic_resched_int_base + i, i,
+				 &irq_resched);
+	}
+}
+#else
+static inline void gic_ipi_init(struct irq_domain *domain)
+{
+}
+#endif
+
 static int gic_irq_domain_map(struct irq_domain *d, unsigned int irq,
 			      irq_hw_number_t hw)
 {
@@ -515,6 +599,8 @@ int __init gic_of_init(struct device_node *node, struct device_node *parent)
 		irq_set_handler_data(gic_cpu_pin[i], domain);
 	}
 
+	gic_ipi_init(domain);
+
 	return 0;
 }
 #endif
-- 
2.1.0.rc2.206.gedb03e5

