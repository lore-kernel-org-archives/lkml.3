Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbaKLTof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 14:44:35 -0500
Received: from mail-ie0-f201.google.com ([209.85.223.201]:59189 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbaKLTns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 14:43:48 -0500
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        John Crispin <blogic@openwrt.org>, David Daney <ddaney.cavm@gmail.com>,
        Qais Yousef <qais.yousef@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-mips@linux-mips.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V5 3/4] irqchip: mips-gic: Add device-tree support
Date: Wed, 12 Nov 2014 11:43:38 -0800
Message-Id: <1415821419-26974-4-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1415821419-26974-1-git-send-email-abrestic@chromium.org>
References: <1415821419-26974-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device-tree support for the MIPS GIC.  Update the GIC irqdomain's
xlate() callback to handle the three-cell specifier described in the
MIPS GIC binding document.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Jason Cooper <jason@lakedaemon.net>
---
No changes from v4.
Changes from v3:
 - use reserved-cpu-vectors property
 - read GIC base from CM if no reg property present
Changes from v2:
 - rebased on GIC irqchip cleanups
 - updated for change in bindings
 - only parse first CPU vector
 - allow platforms to use EIC mode
Changes from v1:
 - updated for change in bindings
 - set base address and enable bit in GCR_GIC_BASE
---
 drivers/irqchip/irq-mips-gic.c | 92 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 87 insertions(+), 5 deletions(-)

diff --git a/drivers/irqchip/irq-mips-gic.c b/drivers/irqchip/irq-mips-gic.c
index 61ac482..8a9ef74 100644
--- a/drivers/irqchip/irq-mips-gic.c
+++ b/drivers/irqchip/irq-mips-gic.c
@@ -12,12 +12,18 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/irqchip/mips-gic.h>
+#include <linux/of_address.h>
 #include <linux/sched.h>
 #include <linux/smp.h>
 
+#include <asm/mips-cm.h>
 #include <asm/setup.h>
 #include <asm/traps.h>
 
+#include <dt-bindings/interrupt-controller/mips-gic.h>
+
+#include "irqchip.h"
+
 unsigned int gic_present;
 
 struct gic_pcpu_mask {
@@ -662,14 +668,34 @@ static int gic_irq_domain_map(struct irq_domain *d, unsigned int virq,
 	return gic_shared_irq_domain_map(d, virq, hw);
 }
 
+static int gic_irq_domain_xlate(struct irq_domain *d, struct device_node *ctrlr,
+				const u32 *intspec, unsigned int intsize,
+				irq_hw_number_t *out_hwirq,
+				unsigned int *out_type)
+{
+	if (intsize != 3)
+		return -EINVAL;
+
+	if (intspec[0] == GIC_SHARED)
+		*out_hwirq = GIC_SHARED_TO_HWIRQ(intspec[1]);
+	else if (intspec[0] == GIC_LOCAL)
+		*out_hwirq = GIC_LOCAL_TO_HWIRQ(intspec[1]);
+	else
+		return -EINVAL;
+	*out_type = intspec[2] & IRQ_TYPE_SENSE_MASK;
+
+	return 0;
+}
+
 static struct irq_domain_ops gic_irq_domain_ops = {
 	.map = gic_irq_domain_map,
-	.xlate = irq_domain_xlate_twocell,
+	.xlate = gic_irq_domain_xlate,
 };
 
-void __init gic_init(unsigned long gic_base_addr,
-		     unsigned long gic_addrspace_size, unsigned int cpu_vec,
-		     unsigned int irqbase)
+static void __init __gic_init(unsigned long gic_base_addr,
+			      unsigned long gic_addrspace_size,
+			      unsigned int cpu_vec, unsigned int irqbase,
+			      struct device_node *node)
 {
 	unsigned int gicconfig;
 
@@ -695,7 +721,7 @@ void __init gic_init(unsigned long gic_base_addr,
 					gic_irq_dispatch);
 	}
 
-	gic_irq_domain = irq_domain_add_simple(NULL, GIC_NUM_LOCAL_INTRS +
+	gic_irq_domain = irq_domain_add_simple(node, GIC_NUM_LOCAL_INTRS +
 					       gic_shared_intrs, irqbase,
 					       &gic_irq_domain_ops, NULL);
 	if (!gic_irq_domain)
@@ -705,3 +731,59 @@ void __init gic_init(unsigned long gic_base_addr,
 
 	gic_ipi_init();
 }
+
+void __init gic_init(unsigned long gic_base_addr,
+		     unsigned long gic_addrspace_size,
+		     unsigned int cpu_vec, unsigned int irqbase)
+{
+	__gic_init(gic_base_addr, gic_addrspace_size, cpu_vec, irqbase, NULL);
+}
+
+static int __init gic_of_init(struct device_node *node,
+			      struct device_node *parent)
+{
+	struct resource res;
+	unsigned int cpu_vec, i = 0, reserved = 0;
+	phys_addr_t gic_base;
+	size_t gic_len;
+
+	/* Find the first available CPU vector. */
+	while (!of_property_read_u32_index(node, "mti,reserved-cpu-vectors",
+					   i++, &cpu_vec))
+		reserved |= BIT(cpu_vec);
+	for (cpu_vec = 2; cpu_vec < 8; cpu_vec++) {
+		if (!(reserved & BIT(cpu_vec)))
+			break;
+	}
+	if (cpu_vec == 8) {
+		pr_err("No CPU vectors available for GIC\n");
+		return -ENODEV;
+	}
+
+	if (of_address_to_resource(node, 0, &res)) {
+		/*
+		 * Probe the CM for the GIC base address if not specified
+		 * in the device-tree.
+		 */
+		if (mips_cm_present()) {
+			gic_base = read_gcr_gic_base() &
+				~CM_GCR_GIC_BASE_GICEN_MSK;
+			gic_len = 0x20000;
+		} else {
+			pr_err("Failed to get GIC memory range\n");
+			return -ENODEV;
+		}
+	} else {
+		gic_base = res.start;
+		gic_len = resource_size(&res);
+	}
+
+	if (mips_cm_present())
+		write_gcr_gic_base(gic_base | CM_GCR_GIC_BASE_GICEN_MSK);
+	gic_present = true;
+
+	__gic_init(gic_base, gic_len, cpu_vec, 0, node);
+
+	return 0;
+}
+IRQCHIP_DECLARE(mips_gic, "mti,gic", gic_of_init);
-- 
2.1.0.rc2.206.gedb03e5

