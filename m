Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab3I3OB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 10:01:58 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55400 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439Ab3I3OAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 10:00:22 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>
CC: <tglx@linutronix.de>, <linus.walleij@linaro.org>,
        <santosh.shilimkar@ti.com>, <linux@arm.linux.org.uk>,
        <tony@atomide.com>, <rnayak@ti.com>, <marc.zyngier@arm.com>,
        <r.sricharan@ti.com>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <mark.rutland@arm.com>
Subject: [RFC PATCH 1/6] DRIVERS: IRQCHIP: IRQ-GIC: Add support for routable irqs
Date: Mon, 30 Sep 2013 19:29:19 +0530
Message-ID: <1380549564-31045-2-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1380549564-31045-1-git-send-email-r.sricharan@ti.com>
References: <1380549564-31045-1-git-send-email-r.sricharan@ti.com>
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
---
 Documentation/devicetree/bindings/arm/gic.txt |    5 +++
 arch/arm/boot/dts/dra7.dtsi                   |    1 +
 drivers/irqchip/irq-gic.c                     |   57 +++++++++++++++++++++----
 include/linux/irqchip/arm-gic.h               |    8 +++-
 4 files changed, 61 insertions(+), 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/gic.txt b/Documentation/devicetree/bindings/arm/gic.txt
index 3dfb0c0..2d8c680 100644
--- a/Documentation/devicetree/bindings/arm/gic.txt
+++ b/Documentation/devicetree/bindings/arm/gic.txt
@@ -49,6 +49,11 @@ Optional
   regions, used when the GIC doesn't have banked registers. The offset is
   cpu-offset * cpu-nr.
 
+- routable-irqs	: Total number of gic irq inputs which are not directly
+		  connected from the peripherals, but are routed dynamically
+		  by a crossbar/multiplexer preceding the GIC. The GIC irq
+		  input line is assigned dynamically when the corresponding
+		  peripheral's crossbar line is mapped.
 Example:
 
 	intc: interrupt-controller@fff11000 {
diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index a5d9350..b35cb12 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -55,6 +55,7 @@
 		compatible = "arm,cortex-a15-gic";
 		interrupt-controller;
 		#interrupt-cells = <3>;
+		routable_irqs = <160>;
 		reg = <0x48211000 0x1000>,
 		      <0x48212000 0x1000>;
 	};
diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 1760ceb..c5778ab 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -72,6 +72,8 @@ struct gic_chip_data {
 
 static DEFINE_RAW_SPINLOCK(irq_controller_lock);
 
+const struct irq_domain_ops *gic_routable_irq_domain_ops;
+
 /*
  * The GIC mapping of CPU interfaces does not necessarily match
  * the logical CPU numbering.  Let's use a mapping as returned
@@ -675,11 +677,26 @@ static int gic_irq_domain_map(struct irq_domain *d, unsigned int irq,
 		irq_set_chip_and_handler(irq, &gic_chip,
 					 handle_fasteoi_irq);
 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
+
+		if (gic_routable_irq_domain_ops &&
+		    gic_routable_irq_domain_ops->map)
+			gic_routable_irq_domain_ops->map(d, irq, hw);
 	}
 	irq_set_chip_data(irq, d->host_data);
 	return 0;
 }
 
+static void gic_irq_domain_unmap(struct irq_domain *d, unsigned int irq)
+{
+	irq_hw_number_t hw = irq_get_irq_data(irq)->hwirq;
+
+	if (hw > 32) {
+		if (gic_routable_irq_domain_ops &&
+		    gic_routable_irq_domain_ops->unmap)
+			gic_routable_irq_domain_ops->unmap(d, irq);
+	}
+}
+
 static int gic_irq_domain_xlate(struct irq_domain *d,
 				struct device_node *controller,
 				const u32 *intspec, unsigned int intsize,
@@ -694,8 +711,15 @@ static int gic_irq_domain_xlate(struct irq_domain *d,
 	*out_hwirq = intspec[1] + 16;
 
 	/* For SPIs, we need to add 16 more to get the GIC irq ID number */
-	if (!intspec[0])
-		*out_hwirq += 16;
+	if (!intspec[0]) {
+		if (gic_routable_irq_domain_ops &&
+		    gic_routable_irq_domain_ops->xlate)
+			*out_hwirq = gic_routable_irq_domain_ops->xlate(d,
+						controller, intspec, intsize,
+						out_hwirq, out_type);
+		else
+			*out_hwirq += 16;
+	}
 
 	*out_type = intspec[2] & IRQ_TYPE_SENSE_MASK;
 	return 0;
@@ -722,6 +746,7 @@ static struct notifier_block __cpuinitdata gic_cpu_notifier = {
 
 const struct irq_domain_ops gic_irq_domain_ops = {
 	.map = gic_irq_domain_map,
+	.unmap = gic_irq_domain_unmap,
 	.xlate = gic_irq_domain_xlate,
 };
 
@@ -732,6 +757,7 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 	irq_hw_number_t hwirq_base;
 	struct gic_chip_data *gic;
 	int gic_irqs, irq_base, i;
+	int nr_routable_irqs;
 
 	BUG_ON(gic_nr >= MAX_GIC_NR);
 
@@ -797,14 +823,27 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 	gic->gic_irqs = gic_irqs;
 
 	gic_irqs -= hwirq_base; /* calculate # of irqs to allocate */
-	irq_base = irq_alloc_descs(irq_start, 16, gic_irqs, numa_node_id());
-	if (IS_ERR_VALUE(irq_base)) {
-		WARN(1, "Cannot allocate irq_descs @ IRQ%d, assuming pre-allocated\n",
-		     irq_start);
-		irq_base = irq_start;
+
+	if (of_property_read_u32(node, "routable_irqs", &nr_routable_irqs)) {
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
+		if (WARN_ON(!gic_routable_irq_domain_ops))
+			return;
+
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
index 3e203eb..fd4192a 100644
--- a/include/linux/irqchip/arm-gic.h
+++ b/include/linux/irqchip/arm-gic.h
@@ -73,6 +73,12 @@ static inline void gic_init(unsigned int nr, int start,
 	gic_init_bases(nr, start, dist, cpu, 0, NULL);
 }
 
-#endif /* __ASSEMBLY */
+extern const struct irq_domain_ops *gic_routable_irq_domain_ops;
+static inline void __init register_routable_domain_ops
+					(const struct irq_domain_ops *ops)
+{
+	gic_routable_irq_domain_ops = ops;
+}
 
+#endif /* __ASSEMBLY */
 #endif
-- 
1.7.9.5

