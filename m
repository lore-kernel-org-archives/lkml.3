Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbaJ2ANi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 20:13:38 -0400
Received: from mail-oi0-f74.google.com ([209.85.218.74]:40350 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917AbaJ2AMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 20:12:49 -0400
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
        Qais Yousef <qais.yousef@imgtec.com>, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V3 3/4] irqchip: mips-gic: Add device-tree support
Date: Tue, 28 Oct 2014 17:12:41 -0700
Message-Id: <1414541562-10076-4-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1414541562-10076-1-git-send-email-abrestic@chromium.org>
References: <1414541562-10076-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device-tree support for the MIPS GIC.  Update the GIC irqdomain's
xlate() callback to handle the three-cell specifier described in the
MIPS GIC binding document.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
Changes from v2:
 - rebased on GIC irqchip cleanups
 - updated for change in bindings
 - only parse first CPU vector
 - allow platforms to use EIC mode
Changes from v1:
 - updated for change in bindings
 - set base address and enable bit in GCR_GIC_BASE
---
 drivers/irqchip/irq-mips-gic.c | 71 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 66 insertions(+), 5 deletions(-)

diff --git a/drivers/irqchip/irq-mips-gic.c b/drivers/irqchip/irq-mips-gic.c
index 61ac482..914d73d 100644
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
@@ -705,3 +731,38 @@ void __init gic_init(unsigned long gic_base_addr,
 
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
+	int cpu_vec;
+	struct resource res;
+
+	/* Use the first available CPU vector. */
+	if (of_property_read_u32_index(node, "mti,available-cpu-vectors", 0,
+				       &cpu_vec)) {
+		pr_err("No CPU vectors available for GIC\n");
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
+	gic_present = true;
+
+	__gic_init(res.start, resource_size(&res), cpu_vec, 0, node);
+
+	return 0;
+}
+IRQCHIP_DECLARE(mips_gic, "mti,interaptiv-gic", gic_of_init);
-- 
2.1.0.rc2.206.gedb03e5

