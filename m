Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbbAUREF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 12:04:05 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:49143 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085AbbAURDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 12:03:55 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        Tim Sander <tim@krieglstein.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Will Deacon <will.deacon@arm.com>
Subject: [RFC PATCH v2 2/5] irq: Allow interrupts to routed to NMI (or similar)
Date: Wed, 21 Jan 2015 17:03:39 +0000
Message-Id: <1421859822-3621-3-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421859822-3621-1-git-send-email-daniel.thompson@linaro.org>
References: <1421166931-14134-1-git-send-email-daniel.thompson@linaro.org>
 <1421859822-3621-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some combinations of architectures and interrupt controllers make it
possible for abitrary interrupt signals to be selectively made immune to
masking by local_irq_disable(). For example, on ARM platforms, many
interrupt controllers allow interrupts to be routed to FIQ rather than IRQ.

These features could be exploited to implement debug and tracing features
that can be implemented using NMI on x86 platforms (perf, hard lockup,
kgdb).

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 include/linux/interrupt.h |  5 +++++
 include/linux/irq.h       |  2 ++
 include/linux/irqdesc.h   |  3 +++
 kernel/irq/irqdesc.c      | 48 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/irq/manage.c       | 46 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 104 insertions(+)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index d9b05b5bf8c7..839ad225bc97 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -57,6 +57,8 @@
  * IRQF_NO_THREAD - Interrupt cannot be threaded
  * IRQF_EARLY_RESUME - Resume IRQ early during syscore instead of at device
  *                resume time.
+ * IRQF_NMI - Route the interrupt to an NMI or some similar signal that is not
+ *            masked by local_irq_disable().
  */
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SHARED		0x00000080
@@ -70,8 +72,10 @@
 #define IRQF_FORCE_RESUME	0x00008000
 #define IRQF_NO_THREAD		0x00010000
 #define IRQF_EARLY_RESUME	0x00020000
+#define __IRQF_NMI		0x00040000
 
 #define IRQF_TIMER		(__IRQF_TIMER | IRQF_NO_SUSPEND | IRQF_NO_THREAD)
+#define IRQF_NMI                (__IRQF_NMI | IRQF_NO_THREAD)
 
 /*
  * These values can be returned by request_any_context_irq() and
@@ -649,5 +653,6 @@ int arch_show_interrupts(struct seq_file *p, int prec);
 extern int early_irq_init(void);
 extern int arch_probe_nr_irqs(void);
 extern int arch_early_irq_init(void);
+extern int arch_filter_nmi_handler(irq_handler_t);
 
 #endif
diff --git a/include/linux/irq.h b/include/linux/irq.h
index d09ec7a1243e..695eb37f04ae 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -307,6 +307,7 @@ static inline irq_hw_number_t irqd_to_hwirq(struct irq_data *d)
  * @irq_eoi:		end of interrupt
  * @irq_set_affinity:	set the CPU affinity on SMP machines
  * @irq_retrigger:	resend an IRQ to the CPU
+ * @irq_set_nmi_routing:set whether interrupt can act like NMI
  * @irq_set_type:	set the flow type (IRQ_TYPE_LEVEL/etc.) of an IRQ
  * @irq_set_wake:	enable/disable power-management wake-on of an IRQ
  * @irq_bus_lock:	function to lock access to slow bus (i2c) chips
@@ -341,6 +342,7 @@ struct irq_chip {
 
 	int		(*irq_set_affinity)(struct irq_data *data, const struct cpumask *dest, bool force);
 	int		(*irq_retrigger)(struct irq_data *data);
+	int		(*irq_set_nmi_routing)(struct irq_data *data, unsigned int nmi);
 	int		(*irq_set_type)(struct irq_data *data, unsigned int flow_type);
 	int		(*irq_set_wake)(struct irq_data *data, unsigned int on);
 
diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index faf433af425e..408d2e4ed40f 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -213,4 +213,7 @@ __irq_set_preflow_handler(unsigned int irq, irq_preflow_handler_t handler)
 }
 #endif
 
+int handle_nmi_irq_desc(unsigned int irq, struct irq_desc *desc);
+int handle_nmi_irq(unsigned int irq);
+
 #endif
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 99793b9b6d23..876d01a6ad74 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -646,3 +646,51 @@ unsigned int kstat_irqs_usr(unsigned int irq)
 	irq_unlock_sparse();
 	return sum;
 }
+
+/**
+ * handle_nmi_irq_desc - Call an NMI handler
+ * @irq:	the interrupt number
+ * @desc:	the interrupt description structure for this irq
+ *
+ * To the caller this function is similar in scope to generic_handle_irq_desc()
+ * but without any attempt to manage the handler flow. We assume that if the
+ * flow is complex then NMI routing is a bad idea; the caller is expected to
+ * handle the ack, clear, mask and unmask issues if necessary.
+ *
+ * Note that this function does not take any of the usual locks. Instead
+ * is relies on NMIs being prohibited from sharing interrupts (i.e.
+ * there will be exactly one irqaction) and that no call to free_irq()
+ * will be made whilst the handler is running.
+ */
+int handle_nmi_irq_desc(unsigned int irq, struct irq_desc *desc)
+{
+	struct irqaction *action = desc->action;
+
+	BUG_ON(action->next);
+
+	return action->handler(irq, action->dev_id);
+}
+EXPORT_SYMBOL_GPL(handle_nmi_irq_desc);
+
+/**
+ * handle_nmi - Call an NMI handler
+ * @irq:	the interrupt number
+ * @desc:	the interrupt description structure for this irq
+ *
+ * To the caller this function is similar in scope to generic_handle_irq(),
+ * see handle_nmi_irq_desc for more detail.
+ */
+int handle_nmi_irq(unsigned int irq)
+{
+	/*
+	 * irq_to_desc is either simple arithmetic (no locking) or a radix
+	 * tree lookup (RCU). Both are safe from NMI.
+	 */
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	if (!desc)
+		return -EINVAL;
+	handle_nmi_irq_desc(irq, desc);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(handle_nmi_irq);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 80692373abd6..96212a0493c0 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -571,6 +571,17 @@ int can_request_irq(unsigned int irq, unsigned long irqflags)
 	return canrequest;
 }
 
+int __irq_set_nmi_routing(struct irq_desc *desc, unsigned int irq,
+			   unsigned int nmi)
+{
+	struct irq_chip *chip = desc->irq_data.chip;
+
+	if (!chip || !chip->irq_set_nmi_routing)
+		return -EINVAL;
+
+	return chip->irq_set_nmi_routing(&desc->irq_data, nmi);
+}
+
 int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 		      unsigned long flags)
 {
@@ -966,6 +977,16 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 
 	if (desc->irq_data.chip == &no_irq_chip)
 		return -ENOSYS;
+
+	if (new->flags & __IRQF_NMI) {
+		if (new->flags & IRQF_SHARED)
+			return -EINVAL;
+
+		ret = arch_filter_nmi_handler(new->handler);
+		if (ret < 0)
+			return ret;
+	}
+
 	if (!try_module_get(desc->owner))
 		return -ENODEV;
 
@@ -1153,6 +1174,19 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 
 		init_waitqueue_head(&desc->wait_for_threads);
 
+		if (new->flags & __IRQF_NMI) {
+			ret = __irq_set_nmi_routing(desc, irq, true);
+			if (ret != 1)
+				goto out_mask;
+		} else {
+			ret = __irq_set_nmi_routing(desc, irq, false);
+			if (ret == 1) {
+				pr_err("Failed to disable NMI routing for irq %d\n",
+				       irq);
+				goto out_mask;
+			}
+		}
+
 		/* Setup the type (level, edge polarity) if configured: */
 		if (new->flags & IRQF_TRIGGER_MASK) {
 			ret = __irq_set_trigger(desc, irq,
@@ -1758,3 +1792,15 @@ int request_percpu_irq(unsigned int irq, irq_handler_t handler,
 
 	return retval;
 }
+
+/*
+ * Allows architectures to deny requests to set __IRQF_NMI.
+ *
+ * Typically this is used to restrict the use of NMI handlers that do not
+ * originate from arch code. However the default implementation is
+ * extremely permissive.
+ */
+int __weak arch_filter_nmi_handler(irq_handler_t handler)
+{
+	return 0;
+}
-- 
1.9.3

