Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719AbbAHNwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 08:52:46 -0500
Received: from down.free-electrons.com ([37.187.137.238]:60704 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754454AbbAHNwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 08:52:43 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [RFC PATCH] irqchip: add dumb demultiplexer implementation
Date: Thu,  8 Jan 2015 14:52:39 +0100
Message-Id: <1420725159-20720-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <alpine.DEB.2.11.1412162125000.17382@nanos>
References: <alpine.DEB.2.11.1412162125000.17382@nanos>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some interrupt controllers are multiplexing several peripheral IRQs on
a single interrupt line.
While this is not a problem for most IRQs (as long as all peripherals
request the interrupt with IRQF_SHARED flag set), multiplexing timers and
other type of peripherals will generate a WARNING (mixing IRQF_NO_SUSPEND
and !IRQF_NO_SUSPEND is prohibited).

Create a dumb irq demultiplexer which simply forward interrupts to all
peripherals (exactly what's happening with IRQ_SHARED) but keeps a unique
irq number for each peripheral, thus preventing the IRQF_NO_SUSPEND
and !IRQF_NO_SUSPEND mix on a given interrupt.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
Hi Thomas,

Here is a proof of concept of the dumb demux irqchip implementation
(tested on an at91 board).
This is definitely not the final implementation, but before going further,
and sending a proper patch series, I'd like to have your opinion on
several aspects.

1) Is it close to what you had in mind ?
2) I'm not sure which part of the code should go where, so don't hesitate
   to point out misplaced sections.
3) Do I need to disable the source irq (the one feeding the irqchip) when
   entering suspend (and enable it on resume) ?
4) I'm not sure of what flags should be set/cleared when mapping an
   interrupt. Should I let the caller decide of this config (something
   similar to what is done in generic-chip) ?

Best Regards,

Boris

 drivers/irqchip/Kconfig          |   4 ++
 drivers/irqchip/Makefile         |   1 +
 drivers/irqchip/irq-dumb-demux.c |  71 ++++++++++++++++++++++
 include/linux/irq.h              |  40 ++++++++++++
 include/linux/irqdomain.h        |   1 +
 kernel/irq/Makefile              |   1 +
 kernel/irq/chip.c                |  39 ++++++++++++
 kernel/irq/dumb-demux-chip.c     | 128 +++++++++++++++++++++++++++++++++++++++
 kernel/irq/handle.c              |  31 +++++++++-
 kernel/irq/internals.h           |   3 +
 10 files changed, 317 insertions(+), 2 deletions(-)
 create mode 100644 drivers/irqchip/irq-dumb-demux.c
 create mode 100644 kernel/irq/dumb-demux-chip.c

diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index cc79d2a..e315c63 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -70,6 +70,10 @@ config BRCMSTB_L2_IRQ
 	select GENERIC_IRQ_CHIP
 	select IRQ_DOMAIN
 
+config DUMB_IRQ_DEMUX
+	bool
+	select IRQ_DOMAIN
+
 config DW_APB_ICTL
 	bool
 	select GENERIC_IRQ_CHIP
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index 9516a32..6ad7441 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_ARCH_MVEBU)		+= irq-armada-370-xp.o
 obj-$(CONFIG_ARCH_MXS)			+= irq-mxs.o
 obj-$(CONFIG_ARCH_S3C24XX)		+= irq-s3c24xx.o
 obj-$(CONFIG_DW_APB_ICTL)		+= irq-dw-apb-ictl.o
+obj-$(CONFIG_DUMB_IRQ_DEMUX)		+= irq-dumb-demux.o
 obj-$(CONFIG_METAG)			+= irq-metag-ext.o
 obj-$(CONFIG_METAG_PERFCOUNTER_IRQS)	+= irq-metag.o
 obj-$(CONFIG_ARCH_MOXART)		+= irq-moxart.o
diff --git a/drivers/irqchip/irq-dumb-demux.c b/drivers/irqchip/irq-dumb-demux.c
new file mode 100644
index 0000000..b941b8b
--- /dev/null
+++ b/drivers/irqchip/irq-dumb-demux.c
@@ -0,0 +1,71 @@
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/of_irq.h>
+#include <linux/slab.h>
+
+#include "irqchip.h"
+
+static int __init dumb_irq_demux_of_init(struct device_node *node,
+					 struct device_node *parent)
+{
+	struct irq_chip_dumb_demux *demux;
+	struct property *prop;
+	const __be32 *propiter;
+	unsigned int irq;
+	int max_irq = -1;
+	u32 tmpval;
+	int ret;
+
+	irq = irq_of_parse_and_map(node, 0);
+	if (!irq) {
+		pr_err("Failed to retrieve dumb irq demuxer source\n");
+		return -EINVAL;
+	}
+
+	of_property_for_each_u32(node, "irqs", prop, propiter, tmpval) {
+		if (max_irq < (int)tmpval)
+			max_irq = tmpval;
+	}
+
+	if (max_irq < 0) {
+		pr_err("Missing 'irqs' property\n");
+		return -EINVAL;
+	}
+
+	demux = irq_alloc_dumb_demux_chip(0, max_irq);
+	if (!demux) {
+		pr_err("Failed to allocate dumb irq demuxer struct\n");
+		return -ENOMEM;
+	}
+
+	of_property_for_each_u32(node, "irqs", prop, propiter, tmpval)
+		set_bit(tmpval, demux->available);
+
+	demux->domain = irq_domain_add_linear(node, max_irq + 1,
+					      &irq_dumb_demux_domain_ops,
+					      demux);
+	if (!demux->domain) {
+		ret = -ENOMEM;
+		goto err_free_demux;
+	}
+
+	ret = irq_set_handler_data(irq, demux);
+	if (ret) {
+		pr_err("Failed to assign handler data\n");
+		goto err_free_domain;
+	}
+
+	irq_set_chained_handler(irq, irq_dumb_demux_handler);
+
+	return 0;
+
+err_free_domain:
+	irq_domain_remove(demux->domain);
+
+err_free_demux:
+	kfree(demux);
+
+	return ret;
+}
+IRQCHIP_DECLARE(dumb_irq_demux, "irqchip-dumb-demux", dumb_irq_demux_of_init);
diff --git a/include/linux/irq.h b/include/linux/irq.h
index d09ec7a..6217284 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -445,6 +445,8 @@ extern void handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_edge_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_edge_eoi_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_simple_irq(unsigned int irq, struct irq_desc *desc);
+extern irqreturn_t handle_dumb_demux_irq(unsigned int irq,
+					 struct irq_desc *desc);
 extern void handle_percpu_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_percpu_devid_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_bad_irq(unsigned int irq, struct irq_desc *desc);
@@ -862,4 +864,42 @@ static inline u32 irq_reg_readl(struct irq_chip_generic *gc,
 		return readl(gc->reg_base + reg_offset);
 }
 
+/**
+ * enum irq_dumb_demux_flags - Initialization flags for generic irq chips
+ * @IRQ_DD_INIT_NESTED_LOCK:	Set the lock class of the irqs to nested for
+ *				irq chips which need to call irq_set_wake() on
+ *				the parent irq. Usually GPIO implementations
+ */
+enum irq_dumb_demux_flags {
+	IRQ_DD_INIT_NESTED_LOCK		= 1 << 0,
+};
+
+/**
+ * struct irq_chip_dumb_demux - Dumb demultiplexer irq chip data structure
+ * @domain:		irq domain pointer
+ * @max_irq:		Last valid irq
+ * @available:		Bitfield of valid irqs
+ * @unmasked:		Bitfield containing irqs status
+ * @flags:		irq_dumb_demux_flags flags
+ *
+ * Note, that irq_chip_generic can have multiple irq_chip_type
+ * implementations which can be associated to a particular irq line of
+ * an irq_chip_generic instance. That allows to share and protect
+ * state in an irq_chip_generic instance when we need to implement
+ * different flow mechanisms (level/edge) for it.
+ */
+struct irq_chip_dumb_demux {
+	struct irq_domain *domain;
+	int max_irq;
+	unsigned long *available;
+	unsigned long *unmasked;
+	unsigned int flags;
+};
+
+void irq_dumb_demux_handler(unsigned int irq, struct irq_desc *desc);
+
+struct irq_chip_dumb_demux *
+irq_alloc_dumb_demux_chip(unsigned int dd_flags,
+			  unsigned int max_out_irq);
+
 #endif /* _LINUX_IRQ_H */
diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 676d730..1de3808 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -80,6 +80,7 @@ struct irq_domain_ops {
 };
 
 extern struct irq_domain_ops irq_generic_chip_ops;
+extern struct irq_domain_ops irq_dumb_demux_domain_ops;
 
 struct irq_domain_chip_generic;
 
diff --git a/kernel/irq/Makefile b/kernel/irq/Makefile
index d121235..5aad99d 100644
--- a/kernel/irq/Makefile
+++ b/kernel/irq/Makefile
@@ -7,3 +7,4 @@ obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_GENERIC_PENDING_IRQ) += migration.o
 obj-$(CONFIG_PM_SLEEP) += pm.o
 obj-$(CONFIG_GENERIC_MSI_IRQ) += msi.o
+obj-$(CONFIG_DUMB_IRQ_DEMUX) += dumb-demux-chip.o
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 6f1c7a5..3318972 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -405,6 +405,45 @@ out_unlock:
 }
 EXPORT_SYMBOL_GPL(handle_simple_irq);
 
+/**
+ *	handle_dumb_demux_irq - Dumb demuxer irq handle function.
+ *	@irq:	the interrupt number
+ *	@desc:	the interrupt description structure for this irq
+ *
+ *	Dumb demux interrupts are sent from a demultiplexing interrupt handler
+ *	which is not able to decide which child interrupt interrupt handler
+ *	should be called.
+ *
+ *	Note: The caller is expected to handle the ack, clear, mask and
+ *	unmask issues if necessary.
+ */
+irqreturn_t
+handle_dumb_demux_irq(unsigned int irq, struct irq_desc *desc)
+{
+	irqreturn_t retval = IRQ_NONE;
+
+	raw_spin_lock(&desc->lock);
+
+	if (!irq_may_run(desc))
+		goto out_unlock;
+
+	desc->istate &= ~(IRQS_REPLAY | IRQS_WAITING);
+	kstat_incr_irqs_this_cpu(irq, desc);
+
+	if (unlikely(!desc->action || irqd_irq_disabled(&desc->irq_data))) {
+		desc->istate |= IRQS_PENDING;
+		goto out_unlock;
+	}
+
+	retval = handle_irq_event_no_spurious_check(desc);
+
+out_unlock:
+	raw_spin_unlock(&desc->lock);
+
+	return retval;
+}
+EXPORT_SYMBOL_GPL(handle_dumb_demux_irq);
+
 /*
  * Called unconditionally from handle_level_irq() and only for oneshot
  * interrupts from handle_fasteoi_irq()
diff --git a/kernel/irq/dumb-demux-chip.c b/kernel/irq/dumb-demux-chip.c
new file mode 100644
index 0000000..049e537
--- /dev/null
+++ b/kernel/irq/dumb-demux-chip.c
@@ -0,0 +1,128 @@
+/*
+ * Library implementing common dumb irq demux chip functions
+ *
+ * Copyright (C) 2015, Boris Brezillon
+ */
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/slab.h>
+#include <linux/export.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/irqchip/chained_irq.h>
+#include <linux/interrupt.h>
+#include <linux/kernel_stat.h>
+#include <linux/syscore_ops.h>
+
+#include "internals.h"
+
+static void irq_dumb_demux_mask(struct irq_data *d)
+{
+	struct irq_chip_dumb_demux *demux = irq_data_get_irq_chip_data(d);
+
+	clear_bit(d->hwirq, demux->unmasked);
+}
+
+static void irq_dumb_demux_unmask(struct irq_data *d)
+{
+	struct irq_chip_dumb_demux *demux = irq_data_get_irq_chip_data(d);
+
+	set_bit(d->hwirq, demux->unmasked);
+}
+
+static struct irq_chip irq_dumb_demux_chip = {
+	.name = "dumb-demux-irq",
+	.irq_mask = irq_dumb_demux_mask,
+	.irq_unmask = irq_dumb_demux_unmask,
+};
+
+/*
+ * Separate lockdep class for interrupt chip which can nest irq_desc
+ * lock.
+ */
+static struct lock_class_key irq_nested_lock_class;
+
+/*
+ * irq_map_dumb_demux_chip - Map a dumb demux chip for an irq domain
+ */
+static int irq_map_dumb_demux_chip(struct irq_domain *d,
+				   unsigned int virq,
+				   irq_hw_number_t hw_irq)
+{
+	struct irq_chip_dumb_demux *demux = d->host_data;
+
+	if (hw_irq > demux->max_irq ||
+	    !test_bit(hw_irq, demux->available))
+		return -EINVAL;
+
+	if (demux->flags & IRQ_DD_INIT_NESTED_LOCK)
+		irq_set_lockdep_class(virq, &irq_nested_lock_class);
+
+	irq_set_chip(virq, &irq_dumb_demux_chip);
+	set_irq_flags(virq, IRQF_VALID);
+	irq_set_chip_data(virq, demux);
+
+	return 0;
+}
+
+struct irq_domain_ops irq_dumb_demux_domain_ops = {
+	.map	= irq_map_dumb_demux_chip,
+	.xlate	= irq_domain_xlate_onecell,
+};
+EXPORT_SYMBOL(irq_dumb_demux_domain_ops);
+
+/**
+ * irq_dumb_demux_handler - Dumb demux flow handler
+ * @irq:		Virtual irq number
+ * @irq_desc:		irq descriptor
+ */
+void irq_dumb_demux_handler(unsigned int irq, struct irq_desc *desc)
+{
+	struct irq_chip_dumb_demux *demux = irq_get_handler_data(irq);
+	struct irq_chip *chip = irq_desc_get_chip(desc);
+	irqreturn_t ret = IRQ_NONE;
+	int i;
+
+	chained_irq_enter(chip, desc);
+	for_each_set_bit(i, demux->unmasked, demux->max_irq) {
+		int demuxed_irq = irq_find_mapping(demux->domain, i);
+		struct irq_desc *desc = irq_to_desc(demuxed_irq);
+
+		ret |= handle_dumb_demux_irq(demuxed_irq, desc);
+	}
+	chained_irq_exit(chip, desc);
+
+	if (!noirqdebug)
+		note_interrupt(irq, desc, ret);
+}
+EXPORT_SYMBOL(irq_dumb_demux_handler);
+
+/**
+ * irq_alloc_dumb_demux_chip - Allocate a dumb demux chip
+ * @dd_flags:		irq_dumb_demux_flags flags
+ * @max_out_irq:	Last valid irq number
+ */
+struct irq_chip_dumb_demux *
+irq_alloc_dumb_demux_chip(unsigned int dd_flags,
+			  unsigned int max_out_irq)
+{
+	struct irq_chip_dumb_demux *demux;
+	int max_irq = -1;
+
+	demux = kzalloc(sizeof(*demux) +
+			(DIV_ROUND_UP(max_out_irq + 1, BITS_PER_LONG) * 2),
+			GFP_KERNEL);
+	if (!demux) {
+		pr_err("Failed to allocate dumb irq demuxer struct\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	demux->available = (void *)demux + sizeof(*demux);
+	demux->unmasked = demux->available +
+			  DIV_ROUND_UP(max_irq + 1, BITS_PER_LONG);
+	demux->max_irq = max_out_irq;
+
+	return demux;
+}
+EXPORT_SYMBOL(irq_alloc_dumb_demux_chip);
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 6354802..f786850 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -131,7 +131,8 @@ void __irq_wake_thread(struct irq_desc *desc, struct irqaction *action)
 }
 
 irqreturn_t
-handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action)
+handle_irq_event_percpu_no_spurious_check(struct irq_desc *desc,
+					  struct irqaction *action)
 {
 	irqreturn_t retval = IRQ_NONE;
 	unsigned int flags = 0, irq = desc->irq_data.irq;
@@ -175,8 +176,18 @@ handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action)
 
 	add_interrupt_randomness(irq, flags);
 
+	return retval;
+}
+
+irqreturn_t
+handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action)
+{
+	irqreturn_t retval;
+
+	retval = handle_irq_event_percpu_no_spurious_check(desc, action);
+
 	if (!noirqdebug)
-		note_interrupt(irq, desc, retval);
+		note_interrupt(desc->irq_data.irq, desc, retval);
 	return retval;
 }
 
@@ -195,3 +206,19 @@ irqreturn_t handle_irq_event(struct irq_desc *desc)
 	irqd_clear(&desc->irq_data, IRQD_IRQ_INPROGRESS);
 	return ret;
 }
+
+irqreturn_t handle_irq_event_no_spurious_check(struct irq_desc *desc)
+{
+	struct irqaction *action = desc->action;
+	irqreturn_t ret;
+
+	desc->istate &= ~IRQS_PENDING;
+	irqd_set(&desc->irq_data, IRQD_IRQ_INPROGRESS);
+	raw_spin_unlock(&desc->lock);
+
+	ret = handle_irq_event_percpu_no_spurious_check(desc, action);
+
+	raw_spin_lock(&desc->lock);
+	irqd_clear(&desc->irq_data, IRQD_IRQ_INPROGRESS);
+	return ret;
+}
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index df553b0..fe056fb 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -90,6 +90,9 @@ extern void init_kstat_irqs(struct irq_desc *desc, int node, int nr);
 
 irqreturn_t handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action);
 irqreturn_t handle_irq_event(struct irq_desc *desc);
+irqreturn_t handle_irq_event_percpu_no_spurious_check(struct irq_desc *desc,
+						      struct irqaction *action);
+irqreturn_t handle_irq_event_no_spurious_check(struct irq_desc *desc);
 
 /* Resending of interrupts :*/
 void check_irq_resend(struct irq_desc *desc, unsigned int irq);
-- 
1.9.1

