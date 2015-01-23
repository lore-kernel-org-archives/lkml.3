Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbbAWRMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 12:12:36 -0500
Received: from down.free-electrons.com ([37.187.137.238]:52704 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755490AbbAWRJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 12:09:37 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 2/5] irqchip: add dumb demultiplexer implementation
Date: Fri, 23 Jan 2015 18:09:28 +0100
Message-Id: <1422032971-14139-3-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422032971-14139-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1422032971-14139-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some interrupt controllers are multiplexing several peripheral IRQs on
a single interrupt line.
While this is not a problem for most IRQs (as long as all peripherals
request the interrupt with IRQF_SHARED flag set), multiplexing timers and
other type of peripherals will generate a WARNING (mixing IRQF_NO_SUSPEND
and !IRQF_NO_SUSPEND is prohibited).

Create a dumb irq demultiplexer which simply forwards interrupts to all
peripherals (exactly what's happening with IRQ_SHARED) but keep a unique
irq number for each peripheral, thus preventing the IRQF_NO_SUSPEND
and !IRQF_NO_SUSPEND mix on a given interrupt.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/irqchip/Kconfig          |   4 ++
 drivers/irqchip/Makefile         |   1 +
 drivers/irqchip/irq-dumb-demux.c |  72 ++++++++++++++++++++
 include/linux/irq.h              |  38 +++++++++++
 include/linux/irqdomain.h        |   1 +
 kernel/irq/Kconfig               |   5 ++
 kernel/irq/Makefile              |   1 +
 kernel/irq/chip.c                |  41 ++++++++++++
 kernel/irq/dumb-demux-chip.c     | 140 +++++++++++++++++++++++++++++++++++++++
 kernel/irq/handle.c              |  31 ++++++++-
 kernel/irq/internals.h           |   3 +
 11 files changed, 335 insertions(+), 2 deletions(-)
 create mode 100644 drivers/irqchip/irq-dumb-demux.c
 create mode 100644 kernel/irq/dumb-demux-chip.c

diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index cc79d2a..8a9df88 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -70,6 +70,10 @@ config BRCMSTB_L2_IRQ
 	select GENERIC_IRQ_CHIP
 	select IRQ_DOMAIN
 
+config DUMB_DEMUX_IRQ
+	bool
+	select DUMB_IRQ_DEMUX_CHIP
+
 config DW_APB_ICTL
 	bool
 	select GENERIC_IRQ_CHIP
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index 9516a32..77f3c51 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_ARCH_MVEBU)		+= irq-armada-370-xp.o
 obj-$(CONFIG_ARCH_MXS)			+= irq-mxs.o
 obj-$(CONFIG_ARCH_S3C24XX)		+= irq-s3c24xx.o
 obj-$(CONFIG_DW_APB_ICTL)		+= irq-dw-apb-ictl.o
+obj-$(CONFIG_DUMB_DEMUX_IRQ)		+= irq-dumb-demux.o
 obj-$(CONFIG_METAG)			+= irq-metag-ext.o
 obj-$(CONFIG_METAG_PERFCOUNTER_IRQS)	+= irq-metag.o
 obj-$(CONFIG_ARCH_MOXART)		+= irq-moxart.o
diff --git a/drivers/irqchip/irq-dumb-demux.c b/drivers/irqchip/irq-dumb-demux.c
new file mode 100644
index 0000000..e4b8905
--- /dev/null
+++ b/drivers/irqchip/irq-dumb-demux.c
@@ -0,0 +1,72 @@
+/*
+ * Dumb irq demux chip driver
+ *
+ * Copyright (C) 2015 Atmel
+ *
+ * Author: Boris Brezillon <boris.brezillon@free-electrons.com>
+ *
+ * This file is licensed under GPLv2.
+ */
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
+	unsigned int irq;
+	u32 valid_irqs;
+	int ret;
+
+	irq = irq_of_parse_and_map(node, 0);
+	if (!irq) {
+		pr_err("Failed to retrieve dumb irq demuxer source\n");
+		return -EINVAL;
+	}
+
+	ret = of_property_read_u32(node, "irqs", &valid_irqs);
+	if (ret) {
+		pr_err("Invalid of missing 'irqs' property\n");
+		return ret;
+	}
+
+	demux = irq_alloc_dumb_demux_chip(irq, valid_irqs,
+					  IRQ_NOREQUEST | IRQ_NOPROBE |
+					  IRQ_NOAUTOEN, 0);
+	if (!demux) {
+		pr_err("Failed to allocate dumb irq demuxer struct\n");
+		return -ENOMEM;
+	}
+
+	demux->domain = irq_domain_add_linear(node, BITS_PER_LONG,
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
+	irq_set_chained_handler_nostartup(irq, irq_dumb_demux_handler);
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
+IRQCHIP_DECLARE(dumb_irq_demux, "virtual,dumb-irq-demux", dumb_irq_demux_of_init);
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 247b2d1..281bed7 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -445,6 +445,10 @@ extern void handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_edge_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_edge_eoi_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_simple_irq(unsigned int irq, struct irq_desc *desc);
+#ifdef CONFIG_DUMB_IRQ_DEMUX_CHIP
+extern irqreturn_t handle_dumb_demux_irq(unsigned int irq,
+					 struct irq_desc *desc);
+#endif
 extern void handle_percpu_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_percpu_devid_irq(unsigned int irq, struct irq_desc *desc);
 extern void handle_bad_irq(unsigned int irq, struct irq_desc *desc);
@@ -880,4 +884,38 @@ static inline u32 irq_reg_readl(struct irq_chip_generic *gc,
 		return readl(gc->reg_base + reg_offset);
 }
 
+#ifdef CONFIG_DUMB_IRQ_DEMUX_CHIP
+/**
+ * struct irq_chip_dumb_demux - Dumb demultiplexer irq chip data structure
+ * @domain:		irq domain pointer
+ * @available:		Bitfield of valid irqs
+ * @unmasked:		Bitfield containing irqs status
+ * @flags:		irq_dumb_demux_flags flags
+ * @src_irq:		irq feeding the dumb demux chip
+ *
+ * Note, that irq_chip_generic can have multiple irq_chip_type
+ * implementations which can be associated to a particular irq line of
+ * an irq_chip_generic instance. That allows to share and protect
+ * state in an irq_chip_generic instance when we need to implement
+ * different flow mechanisms (level/edge) for it.
+ */
+struct irq_chip_dumb_demux {
+	struct irq_domain *domain;
+	unsigned long available;
+	unsigned long unmasked;
+	unsigned int flags;
+	unsigned int src_irq;
+	unsigned int irq_flags_to_clear;
+	unsigned int irq_flags_to_set;
+};
+
+void irq_dumb_demux_handler(unsigned int irq, struct irq_desc *desc);
+
+struct irq_chip_dumb_demux *
+irq_alloc_dumb_demux_chip(unsigned int src_irq,
+			  unsigned long valid_irqs,
+			  unsigned int clr_flags,
+			  unsigned int set_flags);
+#endif /* CONFIG_DUMB_IRQ_DEMUX_CHIP */
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
 
diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
index 9a76e3b..d01554a 100644
--- a/kernel/irq/Kconfig
+++ b/kernel/irq/Kconfig
@@ -51,6 +51,11 @@ config GENERIC_IRQ_CHIP
        bool
        select IRQ_DOMAIN
 
+# Dumb interrupt demuxer chip implementation
+config DUMB_IRQ_DEMUX_CHIP
+	bool
+	select IRQ_DOMAIN
+
 # Generic irq_domain hw <--> linux irq number translation
 config IRQ_DOMAIN
 	bool
diff --git a/kernel/irq/Makefile b/kernel/irq/Makefile
index d121235..1cd4e42 100644
--- a/kernel/irq/Makefile
+++ b/kernel/irq/Makefile
@@ -7,3 +7,4 @@ obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_GENERIC_PENDING_IRQ) += migration.o
 obj-$(CONFIG_PM_SLEEP) += pm.o
 obj-$(CONFIG_GENERIC_MSI_IRQ) += msi.o
+obj-$(CONFIG_DUMB_IRQ_DEMUX_CHIP) += dumb-demux-chip.o
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 5de82dc0..5f516af 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -405,6 +405,47 @@ out_unlock:
 }
 EXPORT_SYMBOL_GPL(handle_simple_irq);
 
+#ifdef CONFIG_DUMB_IRQ_DEMUX_CHIP
+/**
+ *	handle_dumb_demux_irq - Dumb demuxer irq handle function.
+ *	@irq:	the interrupt number
+ *	@desc:	the interrupt description structure for this irq
+ *
+ *	Dumb demux interrupts are sent from a demultiplexing interrupt handler
+ *	which is not able to decide which child interrupt handler should be
+ *	called.
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
+#endif /* CONFIG_DUMB_IRQ_DEMUX_CHIP */
+
 /*
  * Called unconditionally from handle_level_irq() and only for oneshot
  * interrupts from handle_fasteoi_irq()
diff --git a/kernel/irq/dumb-demux-chip.c b/kernel/irq/dumb-demux-chip.c
new file mode 100644
index 0000000..6b88c88
--- /dev/null
+++ b/kernel/irq/dumb-demux-chip.c
@@ -0,0 +1,140 @@
+/*
+ * Library implementing common dumb irq demux chip functions
+ *
+ * Copyright (C) 2015 Atmel
+ *
+ * Author: Boris Brezillon <boris.brezillon@free-electrons.com>
+ *
+ * This file is licensed under GPLv2.
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
+	clear_bit(d->hwirq, &demux->unmasked);
+
+	if (!demux->unmasked)
+		disable_irq_nosync(demux->src_irq);
+}
+
+static void irq_dumb_demux_unmask(struct irq_data *d)
+{
+	struct irq_chip_dumb_demux *demux = irq_data_get_irq_chip_data(d);
+	bool enable_src_irq = !demux->unmasked;
+
+	set_bit(d->hwirq, &demux->unmasked);
+
+	if (enable_src_irq)
+		enable_irq(demux->src_irq);
+}
+
+static struct irq_chip irq_dumb_demux_chip = {
+	.name =		"dumb-demux-irq",
+	.irq_mask =	irq_dumb_demux_mask,
+	.irq_unmask =	irq_dumb_demux_unmask,
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
+	if (!test_bit(hw_irq, &demux->available))
+		return -EINVAL;
+
+	irq_set_lockdep_class(virq, &irq_nested_lock_class);
+
+	irq_set_chip(virq, &irq_dumb_demux_chip);
+	irq_set_chip_data(virq, demux);
+	irq_modify_status(virq, demux->irq_flags_to_clear,
+			  demux->irq_flags_to_set);
+
+	return 0;
+}
+
+struct irq_domain_ops irq_dumb_demux_domain_ops = {
+	.map	= irq_map_dumb_demux_chip,
+	.xlate	= irq_domain_xlate_onecell,
+};
+EXPORT_SYMBOL_GPL(irq_dumb_demux_domain_ops);
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
+	for_each_set_bit(i, &demux->unmasked, BITS_PER_LONG) {
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
+EXPORT_SYMBOL_GPL(irq_dumb_demux_handler);
+
+/**
+ * irq_alloc_dumb_demux_chip - Allocate a dumb demux chip
+ * @src_irq:		irq feeding the dumb demux chip
+ * @valid_irqs:		Bitmask representing valid irqs
+ * @clr_flags:		irq_flags to clear when mapping an interrupt
+ * @set_flags:		irq_flags to set when mapping an interrupt
+ */
+struct irq_chip_dumb_demux *
+irq_alloc_dumb_demux_chip(unsigned int src_irq,
+			  unsigned long valid_irqs,
+			  unsigned int clr_flags,
+			  unsigned int set_flags)
+{
+	struct irq_chip_dumb_demux *demux;
+
+	if (!src_irq)
+		return ERR_PTR(-EINVAL);
+
+	demux = kzalloc(sizeof(*demux), GFP_KERNEL);
+	if (!demux)
+		return ERR_PTR(-ENOMEM);
+
+	demux->available = valid_irqs;
+	demux->src_irq = src_irq;
+	demux->irq_flags_to_clear = clr_flags;
+	demux->irq_flags_to_set = set_flags;
+
+	return demux;
+}
+EXPORT_SYMBOL_GPL(irq_alloc_dumb_demux_chip);
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

