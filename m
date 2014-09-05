Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbaIERbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 13:31:36 -0400
Received: from mail-yh0-f74.google.com ([209.85.213.74]:63624 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbaIERai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 13:30:38 -0400
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
Subject: [PATCH v2 12/16] irqchip: mips-gic: Add device-tree support
Date: Fri,  5 Sep 2014 10:30:14 -0700
Message-Id: <1409938218-9026-13-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1409938218-9026-1-git-send-email-abrestic@chromium.org>
References: <1409938218-9026-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device-tree support for the MIPS GIC.  With DT, no per-platform
static device interrupt mapping is supplied and instead all device
interrupts are specified through the DT.  The GIC-to-CPU interrupts
must also be specified in the DT.

Platforms using DT-based probing of the GIC need only supply the
GIC_NUM_INTRS and, if necessary, MIPS_GIC_IRQ_BASE values and
call of_irq_init() with an of_device_id table including the GIC.

Currenlty only legacy and vecotred interrupt modes are supported.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
Changes from v1:
 - updated for change in bindings
 - set base address and enable bit in GCR_GIC_BASE
---
 arch/mips/include/asm/gic.h    |  15 ++++++
 drivers/irqchip/irq-mips-gic.c | 102 ++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 116 insertions(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/gic.h b/arch/mips/include/asm/gic.h
index 3beb4eb..3853c15 100644
--- a/arch/mips/include/asm/gic.h
+++ b/arch/mips/include/asm/gic.h
@@ -348,6 +348,10 @@ struct gic_shared_intr_map {
 #define GIC_CPU_INT3		3 /* .		      */
 #define GIC_CPU_INT4		4 /* .		      */
 #define GIC_CPU_INT5		5 /* Core Interrupt 7 */
+#define GIC_NUM_CPU_INT		6
+
+/* Add 2 to convert GIC CPU pin to core interrupt */
+#define GIC_CPU_PIN_OFFSET	2
 
 /* Local GIC interrupts. */
 #define GIC_INT_TMR		(GIC_CPU_INT5)
@@ -390,4 +394,15 @@ extern void gic_disable_interrupt(int irq_vec);
 extern void gic_irq_ack(struct irq_data *d);
 extern void gic_finish_irq(struct irq_data *d);
 extern void gic_platform_init(int irqs, struct irq_chip *irq_controller);
+
+#ifdef CONFIG_IRQ_DOMAIN
+extern int gic_of_init(struct device_node *node, struct device_node *parent);
+#else
+static inline int gic_of_init(struct device_node *node,
+			      struct device_node *parent)
+{
+	return 0;
+}
+#endif
+
 #endif /* _ASM_GICREGS_H */
diff --git a/drivers/irqchip/irq-mips-gic.c b/drivers/irqchip/irq-mips-gic.c
index c0ff749..d885749 100644
--- a/drivers/irqchip/irq-mips-gic.c
+++ b/drivers/irqchip/irq-mips-gic.c
@@ -8,17 +8,23 @@
  */
 #include <linux/bitmap.h>
 #include <linux/init.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
 #include <linux/smp.h>
-#include <linux/irq.h>
+#include <linux/interrupt.h>
 #include <linux/clocksource.h>
 
 #include <asm/io.h>
+#include <asm/irq_cpu.h>
 #include <asm/gic.h>
 #include <asm/setup.h>
+#include <asm/mips-cm.h>
 #include <asm/traps.h>
 #include <linux/hardirq.h>
 #include <asm-generic/bitops/find.h>
 
+#include "irqchip.h"
+
 unsigned int gic_frequency;
 unsigned int gic_present;
 unsigned long _gic_base;
@@ -467,3 +473,97 @@ void __init gic_init(unsigned long gic_base_addr,
 
 	gic_platform_init(numintrs, &gic_irq_controller);
 }
+
+#ifdef CONFIG_IRQ_DOMAIN
+/* CPU core IRQs used by GIC */
+static int gic_cpu_pin[GIC_NUM_CPU_INT];
+static int num_gic_cpu_pins;
+
+static int gic_irq_domain_map(struct irq_domain *d, unsigned int irq,
+			      irq_hw_number_t hw)
+{
+	int pin = gic_cpu_pin[0] - GIC_CPU_PIN_OFFSET;
+
+	irq_set_chip_and_handler(irq, &gic_irq_controller, handle_level_irq);
+
+	GICWRITE(GIC_REG_ADDR(SHARED, GIC_SH_MAP_TO_PIN(hw)),
+		 GIC_MAP_TO_PIN_MSK | pin);
+	/* Map to VPE 0 by default */
+	GIC_SH_MAP_TO_VPE_SMASK(hw, 0);
+	set_bit(hw, pcpu_masks[0].pcpu_mask);
+
+	return 0;
+}
+
+static const struct irq_domain_ops gic_irq_domain_ops = {
+	.map = gic_irq_domain_map,
+	.xlate = irq_domain_xlate_twocell,
+};
+
+static void gic_irq_dispatch(unsigned int irq, struct irq_desc *desc)
+{
+	struct irq_domain *domain = irq_get_handler_data(irq);
+	unsigned int hwirq;
+
+	while ((hwirq = gic_get_int()) != GIC_NUM_INTRS) {
+		irq = irq_linear_revmap(domain, hwirq);
+		generic_handle_irq(irq);
+	}
+}
+
+void __weak __init gic_platform_init(int irqs, struct irq_chip *irq_controller)
+{
+}
+
+int __init gic_of_init(struct device_node *node, struct device_node *parent)
+{
+	struct irq_domain *domain;
+	struct resource res;
+	int i;
+
+	if (cpu_has_veic) {
+		pr_err("GIC EIC mode not supported with DT yet\n");
+		return -ENODEV;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(gic_cpu_pin); i++) {
+		if (of_property_read_u32_index(node,
+					       "mti,available-cpu-vectors",
+					       i, &gic_cpu_pin[i]))
+			break;
+		num_gic_cpu_pins++;
+	}
+	if (!num_gic_cpu_pins) {
+		pr_err("No available CPU interrupt vectors for GIC\n");
+		return -ENODEV;
+	}
+
+	if (of_address_to_resource(node, 0, &res)) {
+		pr_err("Failed to get GIC memory range\n");
+		return -ENODEV;
+	}
+
+	if (mips_cm_present())
+		write_gcr_gic_base(res.start | CM_GCR_GIC_BASE_GICEN_MSK);
+
+	gic_init(res.start, resource_size(&res), NULL, 0, MIPS_GIC_IRQ_BASE);
+
+	domain = irq_domain_add_legacy(node, GIC_NUM_INTRS, MIPS_GIC_IRQ_BASE,
+				       0, &gic_irq_domain_ops, NULL);
+	if (!domain) {
+		pr_err("Failed to add GIC IRQ domain\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < num_gic_cpu_pins; i++) {
+		int irq;
+
+		irq = irq_create_mapping(mips_intc_domain, gic_cpu_pin[i]);
+		irq_set_chained_handler(irq, gic_irq_dispatch);
+		irq_set_handler_data(irq, domain);
+	}
+
+	return 0;
+}
+IRQCHIP_DECLARE(mips_gic, "mti,global-interrupt-controller", gic_of_init);
+#endif
-- 
2.1.0.rc2.206.gedb03e5

