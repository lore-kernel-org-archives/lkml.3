Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab3LCK22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 05:28:28 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:54652 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774Ab3LCK2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 05:28:19 -0500
From: Sricharan R <r.sricharan@ti.com>
To: <r.sricharan@ti.com>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linus.walleij@linaro.org>, <linux@arm.linux.org.uk>,
        <tony@atomide.com>, <rnayak@ti.com>, <marc.zyngier@arm.com>,
        <grant.likely@linaro.org>, <mark.rutland@arm.com>,
        <robherring2@gmail.com>, <tglx@linutronix.de>, <galak@codeaurora.org>,
        <rob.herring@calxeda.com>, <santosh.shilimkar@ti.com>, <nm@ti.com>,
        <bcousson@baylibre.com>
Subject: [PATCH V5 1/4] DRIVERS: IRQCHIP: IRQ-GIC: Add support for routable irqs
Date: Tue, 3 Dec 2013 15:57:22 +0530
Message-ID: <1386066445-28245-2-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386066445-28245-1-git-send-email-r.sricharan@ti.com>
References: <1386066445-28245-1-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some socs the gic can be preceded by a crossbar IP which
routes the peripheral interrupts to the gic inputs. The peripheral
interrupts are associated with a fixed crossbar input line and the
crossbar routes that to one of the free gic input line.

The DT entries for peripherals provides the fixed crossbar input line
as its interrupt number and the mapping code should associate this with
a free gic input line. This patch adds the support inside the gic irqchip
to handle such routable irqs. The routable irqs are registered in a linear
domain. The registered routable domain's callback should be implemented
to get a free irq and to configure the IP to route it.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Rajendra Nayak <rnayak@ti.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Signed-off-by: Sricharan R <r.sricharan@ti.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 Documentation/devicetree/bindings/arm/gic.txt |    6 ++
 drivers/irqchip/irq-gic.c                     |   82 ++++++++++++++++++++++---
 include/linux/irqchip/arm-gic.h               |    7 ++-
 3 files changed, 84 insertions(+), 11 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/gic.txt b/Documentation/devicetree/bindings/arm/gic.txt
index 3dfb0c0..5357745 100644
--- a/Documentation/devicetree/bindings/arm/gic.txt
+++ b/Documentation/devicetree/bindings/arm/gic.txt
@@ -49,6 +49,11 @@ Optional
   regions, used when the GIC doesn't have banked registers. The offset is
   cpu-offset * cpu-nr.
 
+- arm,routable-irqs : Total number of gic irq inputs which are not directly
+		  connected from the peripherals, but are routed dynamically
+		  by a crossbar/multiplexer preceding the GIC. The GIC irq
+		  input line is assigned dynamically when the corresponding
+		  peripheral's crossbar line is mapped.
 Example:
 
 	intc: interrupt-controller@fff11000 {
@@ -56,6 +61,7 @@ Example:
 		#interrupt-cells = <3>;
 		#address-cells = <1>;
 		interrupt-controller;
+		arm,routable-irqs = <160>;
 		reg = <0xfff11000 0x1000>,
 		      <0xfff10100 0x100>;
 	};
diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 9031171..5cfb602 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -824,16 +824,25 @@ static int gic_irq_domain_map(struct irq_domain *d, unsigned int irq,
 		irq_set_chip_and_handler(irq, &gic_chip,
 					 handle_fasteoi_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
+
+		gic_routable_irq_domain_ops->map(d, irq, hw);
 	}
 	irq_set_chip_data(irq, d->host_data);
 	return 0;
 }
 
+static void gic_irq_domain_unmap(struct irq_domain *d, unsigned int irq)
+{
+	gic_routable_irq_domain_ops->unmap(d, irq);
+}
+
 static int gic_irq_domain_xlate(struct irq_domain *d,
 				struct device_node *controller,
 				const u32 *intspec, unsigned int intsize,
 				unsigned long *out_hwirq, unsigned int *out_type)
 {
+	unsigned long ret = 0;
+
 	if (d->of_node != controller)
 		return -EINVAL;
 	if (intsize < 3)
@@ -843,11 +852,20 @@ static int gic_irq_domain_xlate(struct irq_domain *d,
 	*out_hwirq = intspec[1] + 16;
 
 	/* For SPIs, we need to add 16 more to get the GIC irq ID number */
-	if (!intspec[0])
-		*out_hwirq += 16;
+	if (!intspec[0]) {
+		ret = gic_routable_irq_domain_ops->xlate(d, controller,
+							 intspec,
+							 intsize,
+							 out_hwirq,
+							 out_type);
+
+		if (IS_ERR_VALUE(ret))
+			return ret;
+	}
 
 	*out_type = intspec[2] & IRQ_TYPE_SENSE_MASK;
-	return 0;
+
+	return ret;
 }
 
 #ifdef CONFIG_SMP
@@ -871,9 +889,41 @@ static struct notifier_block gic_cpu_notifier = {
 
 const struct irq_domain_ops gic_irq_domain_ops = {
 	.map = gic_irq_domain_map,
+	.unmap = gic_irq_domain_unmap,
 	.xlate = gic_irq_domain_xlate,
 };
 
+/* Default functions for routable irq domain */
+static int gic_routable_irq_domain_map(struct irq_domain *d, unsigned int irq,
+			      irq_hw_number_t hw)
+{
+	return 0;
+}
+
+static void gic_routable_irq_domain_unmap(struct irq_domain *d,
+					  unsigned int irq)
+{
+}
+
+static int gic_routable_irq_domain_xlate(struct irq_domain *d,
+				struct device_node *controller,
+				const u32 *intspec, unsigned int intsize,
+				unsigned long *out_hwirq,
+				unsigned int *out_type)
+{
+	*out_hwirq += 16;
+	return 0;
+}
+
+const struct irq_domain_ops gic_default_routable_irq_domain_ops = {
+	.map = gic_routable_irq_domain_map,
+	.unmap = gic_routable_irq_domain_unmap,
+	.xlate = gic_routable_irq_domain_xlate,
+};
+
+const struct irq_domain_ops *gic_routable_irq_domain_ops =
+					&gic_default_routable_irq_domain_ops;
+
 void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 			   void __iomem *dist_base, void __iomem *cpu_base,
 			   u32 percpu_offset, struct device_node *node)
@@ -881,6 +931,7 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 	irq_hw_number_t hwirq_base;
 	struct gic_chip_data *gic;
 	int gic_irqs, irq_base, i;
+	int nr_routable_irqs;
 
 	BUG_ON(gic_nr >= MAX_GIC_NR);
 
@@ -946,14 +997,25 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 	gic->gic_irqs = gic_irqs;
 
 	gic_irqs -= hwirq_base; /* calculate # of irqs to allocate */
-	irq_base = irq_alloc_descs(irq_start, 16, gic_irqs, numa_node_id());
-	if (IS_ERR_VALUE(irq_base)) {
-		WARN(1, "Cannot allocate irq_descs @ IRQ%d, assuming pre-allocated\n",
-		     irq_start);
-		irq_base = irq_start;
+
+	if (of_property_read_u32(node, "arm,routable-irqs",
+				 &nr_routable_irqs)) {
+		irq_base = irq_alloc_descs(irq_start, 16, gic_irqs,
+					   numa_node_id());
+		if (IS_ERR_VALUE(irq_base)) {
+			WARN(1, "Cannot allocate irq_descs @ IRQ%d, assuming pre-allocated\n",
+			     irq_start);
+			irq_base = irq_start;
+		}
+
+		gic->domain = irq_domain_add_legacy(node, gic_irqs, irq_base,
+					hwirq_base, &gic_irq_domain_ops, gic);
+	} else {
+		gic->domain = irq_domain_add_linear(node, nr_routable_irqs,
+						    &gic_irq_domain_ops,
+						    gic);
 	}
-	gic->domain = irq_domain_add_legacy(node, gic_irqs, irq_base,
-				    hwirq_base, &gic_irq_domain_ops, gic);
+
 	if (WARN_ON(!gic->domain))
 		return;
 
diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
index cac496b..fcb02d7 100644
--- a/include/linux/irqchip/arm-gic.h
+++ b/include/linux/irqchip/arm-gic.h
@@ -81,6 +81,11 @@ int gic_get_cpu_id(unsigned int cpu);
 void gic_migrate_target(unsigned int new_cpu_id);
 unsigned long gic_get_sgir_physaddr(void);
 
+extern const struct irq_domain_ops *gic_routable_irq_domain_ops;
+static inline void __init register_routable_domain_ops
+					(const struct irq_domain_ops *ops)
+{
+	gic_routable_irq_domain_ops = ops;
+}
 #endif /* __ASSEMBLY */
-
 #endif
-- 
1.7.9.5

