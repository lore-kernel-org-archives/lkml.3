Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbaIERgn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 13:36:43 -0400
Received: from mail-ig0-f201.google.com ([209.85.213.201]:36649 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbaIERgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 13:36:41 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>, Arnd Bergmann <arnd@arndb.de>,
        John Crispin <blogic@openwrt.org>, David Daney <ddaney.cavm@gmail.com>,
        linux-mips@linux-mips.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 13/16] irqchip: mips-gic: Add generic IPI support when using DT
Date: Fri,  5 Sep 2014 10:30:15 -0700
Message-Id: <1409938218-9026-14-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1409938218-9026-1-git-send-email-abrestic@chromium.org>
References: <1409938218-9026-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When DT-based probing is used for the GIC and the GIC is also used
for IPIs (i.e. MIPS_GIC_IPI=y), set up the last 2 * NR_CPUs GIC
interrupts as the reschedule and call IPIs.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
Changes from v1:
 - removed open-coding of irq_set_type
---
 drivers/irqchip/irq-mips-gic.c | 81 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/drivers/irqchip/irq-mips-gic.c b/drivers/irqchip/irq-mips-gic.c
index d885749..82a35cf 100644
--- a/drivers/irqchip/irq-mips-gic.c
+++ b/drivers/irqchip/irq-mips-gic.c
@@ -10,6 +10,7 @@
 #include <linux/init.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
+#include <linux/sched.h>
 #include <linux/smp.h>
 #include <linux/interrupt.h>
 #include <linux/clocksource.h>
@@ -479,6 +480,84 @@ void __init gic_init(unsigned long gic_base_addr,
 static int gic_cpu_pin[GIC_NUM_CPU_INT];
 static int num_gic_cpu_pins;
 
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
+	GIC_SH_MAP_TO_VPE_SMASK(hwirq, cpu);
+	for (i = 0; i < NR_CPUS; i++)
+		clear_bit(hwirq, pcpu_masks[i].pcpu_mask);
+	set_bit(hwirq, pcpu_masks[cpu].pcpu_mask);
+
+	irq_set_irq_type(irq, IRQ_TYPE_EDGE_RISING);
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
@@ -563,6 +642,8 @@ int __init gic_of_init(struct device_node *node, struct device_node *parent)
 		irq_set_handler_data(irq, domain);
 	}
 
+	gic_ipi_init(domain);
+
 	return 0;
 }
 IRQCHIP_DECLARE(mips_gic, "mti,global-interrupt-controller", gic_of_init);
-- 
2.1.0.rc2.206.gedb03e5

