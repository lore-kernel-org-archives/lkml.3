Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbbANOpe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:45:34 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:33915 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbbANOpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:45:32 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/2] genirq: Allow irq_desc to carry the union of stacked irq_chip flags
Date: Wed, 14 Jan 2015 14:45:17 +0000
Message-Id: <1421246717-11640-3-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421246717-11640-1-git-send-email-marc.zyngier@arm.com>
References: <1421246717-11640-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current infrastructure for stacked domains doesn't propagate
irq_chip flags, and as we only look at the top-level irq_chip,
we may miss a number of critical flags.

This patch accumulates the flags into a new set, stored at the
irq_desc level, with an additional flag to indicate that this is
a stack of irqchip. The accessor is updated to return the right one.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/linux/irq.h     |  4 ++++
 include/linux/irqdesc.h |  7 +++++++
 kernel/irq/irqdesc.c    |  3 +++
 kernel/irq/irqdomain.c  | 20 +++++++++++++++++++-
 4 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index d09ec7a..cb956f6 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -377,6 +377,7 @@ struct irq_chip {
  * IRQCHIP_SKIP_SET_WAKE:	Skip chip.irq_set_wake(), for this irq chip
  * IRQCHIP_ONESHOT_SAFE:	One shot does not require mask/unmask
  * IRQCHIP_EOI_THREADED:	Chip requires eoi() on unmask in threaded mode
+ * IRQCHIP_STACKED_CHIPS:	Pseudo flag for stacked irq chips
  */
 enum {
 	IRQCHIP_SET_TYPE_MASKED		= (1 <<  0),
@@ -386,6 +387,9 @@ enum {
 	IRQCHIP_SKIP_SET_WAKE		= (1 <<  4),
 	IRQCHIP_ONESHOT_SAFE		= (1 <<  5),
 	IRQCHIP_EOI_THREADED		= (1 <<  6),
+
+	/* The following is only valid as part of irq_desc.chip_flags */
+	IRQCHIP_STACKED_CHIPS		= (1 << 31),
 };
 
 /* This include will go away once we isolated irq_desc usage to core code */
diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index 32d9fff..f35f192 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -50,6 +50,9 @@ struct irq_desc {
 	struct irq_data		irq_data;
 	unsigned int __percpu	*kstat_irqs;
 	irq_flow_handler_t	handle_irq;
+#ifdef CONFIG_IRQ_DOMAIN_HIERARCHY
+	unsigned long		chip_flags;	/* Union of all the irqchips */
+#endif
 #ifdef CONFIG_IRQ_PREFLOW_FASTEOI
 	irq_preflow_handler_t	preflow_handler;
 #endif
@@ -109,6 +112,10 @@ static inline void *irq_desc_get_chip_data(struct irq_desc *desc)
 
 static inline unsigned long irq_desc_get_chip_flags(struct irq_desc *desc)
 {
+#ifdef CONFIG_IRQ_DOMAIN_HIERARCHY
+	if (desc->chip_flags & IRQCHIP_STACKED_CHIPS)
+		return desc->chip_flags;
+#endif
 	return desc->irq_data.chip->flags;
 }
 
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 99793b9..b916ea4 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -84,6 +84,9 @@ static void desc_set_defaults(unsigned int irq, struct irq_desc *desc, int node,
 	irq_settings_clr_and_set(desc, ~0, _IRQ_DEFAULT_INIT_FLAGS);
 	irqd_set(&desc->irq_data, IRQD_IRQ_DISABLED);
 	desc->handle_irq = handle_bad_irq;
+#ifdef CONFIG_IRQ_DOMAIN_HIERARCHY
+	desc->chip_flags = 0;
+#endif
 	desc->depth = 1;
 	desc->irq_count = 0;
 	desc->irqs_unhandled = 0;
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 7fac311..3d0e366 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -1013,6 +1013,17 @@ static void irq_domain_free_irqs_recursive(struct irq_domain *domain,
 	}
 }
 
+static void irq_desc_update_chip_flags(struct irq_domain *domain,
+				       unsigned int virq)
+{
+#ifdef CONFIG_IRQ_DOMAIN_HIERARCHY
+	struct irq_desc *desc = irq_to_desc(virq);
+	struct irq_data *data = irq_domain_get_irq_data(domain, virq);
+
+	desc->chip_flags |= data->chip->flags | IRQCHIP_STACKED_CHIPS;
+#endif
+}
+
 static int irq_domain_alloc_irqs_recursive(struct irq_domain *domain,
 					   unsigned int irq_base,
 					   unsigned int nr_irqs, void *arg)
@@ -1025,8 +1036,15 @@ static int irq_domain_alloc_irqs_recursive(struct irq_domain *domain,
 	if (recursive)
 		ret = irq_domain_alloc_irqs_recursive(parent, irq_base,
 						      nr_irqs, arg);
-	if (ret >= 0)
+	if (ret >= 0) {
 		ret = domain->ops->alloc(domain, irq_base, nr_irqs, arg);
+		if (ret >= 0) {
+			int i;
+
+			for (i = 0; i < nr_irqs; i++)
+				irq_desc_update_chip_flags(domain, irq_base + i);
+		}
+	}
 	if (ret < 0 && recursive)
 		irq_domain_free_irqs_recursive(parent, irq_base, nr_irqs);
 
-- 
2.1.4

