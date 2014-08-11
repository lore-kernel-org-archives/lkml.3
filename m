Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbaHKNo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 09:44:58 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:58566 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753695AbaHKNoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 09:44:54 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: [PATCH 2/6 v2] irq / PM: Make IRQF_NO_SUSPEND work with shared interrupts
Date: Mon, 11 Aug 2014 15:59:26 +0200
Message-ID: <1748149.0fqmHNfelP@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <26580319.OZP7jvJnA9@vostro.rjw.lan>
References: <26580319.OZP7jvJnA9@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Since __disable_irq() only checks IRQF_NO_SUSPEND for the first
irqaction in a given irq_desc, that value of that bit for the
first irqaction affects all of the other irqactions sharing the
interrupt with it.  This is problematic in two cases.

First, if IRQF_NO_SUSPEND is set in the first irqaction and unset
in at least one of the other irqactions sharing the same IRQ, the
interrupt handlers of the irqactions with IRQF_NO_SUSPEND unset
will be invoked after suspend_device_irqs(), even though they are
not supposed to be invoked at that time.  That shouldn't be a problem
if those interrupt handlers are implemented correctly and the
corresponding devices are properly suspended, but it may lead to
functional issues otherwise.

Second, if IRQF_NO_SUSPEND is unset in the first irqaction and set
in at least one of the other irqactions sharing the same IRQ, the
interrupt handlers of the irqactions with IRQF_NO_SUSPEND set will
not be invoked after suspend_device_irqs(), although they are
supposed to be invoked at that time.  That may be a problem if
interrupts from the corresponding sources have to be properly
handled during system suspend/resume too, which is the case for
timer interrupts or the ACPI SCI, for example.

Both the situations described above have to be avoided, but the
fix should only impact the handling of interrupts during system
suspend and resume.  That means no changes to the code in
kernel/irq/handle.c and to the code called from there.  Moreover,
kernels build with CONFIG_PM_SLEEP unset should not be affected
at all.

Another thing to consider is what to do if there's an unhandled
interrupt during system suspend after suspend_device_irqs() and
the consensus here seems to be to abort the suspend it that case
(or trigger a wakeup from suspend-to-idle if already there).

Taking the above into account leads to the following approach.

During suspend_device_irqs() all of the shared IRQs that are not to
be suspended (that is, shared IRQs with at least one IRQF_NO_SUSPEND
irqaction) are switched over to a special "suspend mode" by replacing
the original interrupt handlers in their irqactions by a wrapper
handler.

That wrapper handler executes the original interrupt handlers for
the IRQF_NO_SUSPEND irqactions only and tracks their return codes.
It does that by combining the return code of the current irqaction's
handler with the return codes from all of the previous irqactions
in the chain and propagating that value to the next irqaction in the
chain with the help of the (new) prev_ret field in struct irqaction.
For the last irqaction in the chain, the combined return code is thus
equal to the final value of retval in handle_irq_event_percpu().  If
that value is IRQ_NONE, the wrapper handler regards the interrupt as
unhandled, disables the IRQ, marks it as "suspended" and triggers
system wakeup to allow it to recover from that potentially dangerous
situation.

During resume_device_irqs() all IRQs that were previously in the
"suspend mode" described above are switched back to their original
configuration.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 include/linux/interrupt.h |    8 ++++
 include/linux/irqdesc.h   |    3 +
 kernel/irq/internals.h    |   20 ++++++++++
 kernel/irq/manage.c       |   11 ++++-
 kernel/irq/pm.c           |   89 ++++++++++++++++++++++++++++++++++++++++++++--
 5 files changed, 127 insertions(+), 4 deletions(-)

Index: linux-pm/include/linux/interrupt.h
===================================================================
--- linux-pm.orig/include/linux/interrupt.h
+++ linux-pm/include/linux/interrupt.h
@@ -101,6 +101,9 @@ typedef irqreturn_t (*irq_handler_t)(int
  * @thread_flags:	flags related to @thread
  * @thread_mask:	bitmask for keeping track of @thread activity
  * @dir:	pointer to the proc/irq/NN/name entry
+ * @s_handler:	original interrupt handler for suspend mode interrupts
+ * @s_dev_id:	original device identification cookie for suspend mode
+ * @prev_ret:	suspend mode return code from the previous action
  */
 struct irqaction {
 	irq_handler_t		handler;
@@ -115,6 +118,11 @@ struct irqaction {
 	unsigned long		thread_mask;
 	const char		*name;
 	struct proc_dir_entry	*dir;
+#ifdef CONFIG_PM_SLEEP
+	irq_handler_t		s_handler;
+	void			*s_dev_id;
+	irqreturn_t		prev_ret;
+#endif
 } ____cacheline_internodealigned_in_smp;
 
 extern irqreturn_t no_action(int cpl, void *dev_id);
Index: linux-pm/include/linux/irqdesc.h
===================================================================
--- linux-pm.orig/include/linux/irqdesc.h
+++ linux-pm/include/linux/irqdesc.h
@@ -71,6 +71,9 @@ struct irq_desc {
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry	*dir;
 #endif
+#ifdef CONFIG_PM_SLEEP
+	unsigned int		skip_suspend_depth;
+#endif
 	int			parent_irq;
 	struct module		*owner;
 	const char		*name;
Index: linux-pm/kernel/irq/manage.c
===================================================================
--- linux-pm.orig/kernel/irq/manage.c
+++ linux-pm/kernel/irq/manage.c
@@ -385,7 +385,9 @@ setup_affinity(unsigned int irq, struct
 void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
 {
 	if (suspend) {
-		if (!desc->action || (desc->action->flags & IRQF_NO_SUSPEND))
+		if (!desc->action)
+			return;
+		if (irq_pm_suspend_mode(desc))
 			return;
 		desc->istate |= IRQS_SUSPENDED;
 	}
@@ -445,6 +447,7 @@ EXPORT_SYMBOL(disable_irq);
 void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume)
 {
 	if (resume) {
+		irq_pm_normal_mode(desc);
 		if (!(desc->istate & IRQS_SUSPENDED)) {
 			if (!desc->action)
 				return;
@@ -1222,6 +1225,8 @@ __setup_irq(unsigned int irq, struct irq
 	desc->irq_count = 0;
 	desc->irqs_unhandled = 0;
 
+	irq_pm_setup(desc, new);
+
 	/*
 	 * Check whether we disabled the irq via the spurious handler
 	 * before. Reenable it and give it another chance.
@@ -1328,7 +1333,7 @@ static struct irqaction *__free_irq(unsi
 			return NULL;
 		}
 
-		if (action->dev_id == dev_id)
+		if (action->dev_id == dev_id || irq_pm_saved_id(action, dev_id))
 			break;
 		action_ptr = &action->next;
 	}
@@ -1336,6 +1341,8 @@ static struct irqaction *__free_irq(unsi
 	/* Found it - now remove it from the list of entries: */
 	*action_ptr = action->next;
 
+	irq_pm_cleanup(desc, action);
+
 	/* If this was the last handler, shut down the IRQ line: */
 	if (!desc->action) {
 		irq_shutdown(desc);
Index: linux-pm/kernel/irq/pm.c
===================================================================
--- linux-pm.orig/kernel/irq/pm.c
+++ linux-pm/kernel/irq/pm.c
@@ -9,10 +9,96 @@
 #include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
+#include <linux/suspend.h>
 #include <linux/syscore_ops.h>
 
 #include "internals.h"
 
+static void irq_pm_restore_handler(struct irqaction *action)
+{
+	if (action->s_handler) {
+		action->handler = action->s_handler;
+		action->s_handler = NULL;
+		action->dev_id = action->s_dev_id;
+		action->s_dev_id = NULL;
+	}
+}
+
+static void irq_pm_disable_and_wakeup(int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	desc->istate |= IRQS_SUSPENDED;
+	desc->depth++;
+	irq_disable(desc);
+	pm_system_wakeup();
+}
+
+static irqreturn_t irq_suspend_mode_handler(int irq, void *dev_id)
+{
+	struct irqaction *action = dev_id;
+	struct irqaction *next = action->next;
+	irqreturn_t ret = (action->flags & IRQF_NO_SUSPEND) ?
+		action->s_handler(irq, action->s_dev_id) : IRQ_NONE;
+
+	if (next) {
+		/* Propagate the return code. */
+		next->prev_ret = ret | action->prev_ret;
+	} else if ((ret | action->prev_ret) == IRQ_NONE) {
+		/*
+		 * This is the last action is this chain, and all of the
+		 * handlers returned IRQ_NONE.  This means an unhandled
+		 * interrupt during system suspend, so disable the IRQ and
+		 * trigger wakeup.
+		 */
+		pr_err("IRQ %d: Unhandled while suspended\n", irq);
+		irq_pm_disable_and_wakeup(irq);
+	}
+	return ret;
+}
+
+bool irq_pm_suspend_mode(struct irq_desc *desc)
+{
+	struct irqaction *action;
+
+	if (!desc->skip_suspend_depth)
+		return false;
+
+	/* No need to replace the handler if the IRQ is not shared. */
+	if (!desc->action->next)
+		return true;
+
+	for (action = desc->action; action; action = action->next) {
+		action->s_handler = action->handler;
+		action->handler = irq_suspend_mode_handler;
+		action->s_dev_id = action->dev_id;
+		action->dev_id = action;
+		action->prev_ret = IRQ_NONE;
+	}
+	return true;
+}
+
+void irq_pm_normal_mode(struct irq_desc *desc)
+{
+	struct irqaction *action;
+
+	for (action = desc->action; action; action = action->next)
+		irq_pm_restore_handler(action);
+}
+
+void irq_pm_setup(struct irq_desc *desc, struct irqaction *action)
+{
+	if (action->flags & IRQF_NO_SUSPEND)
+		desc->skip_suspend_depth++;
+}
+
+void irq_pm_cleanup(struct irq_desc *desc, struct irqaction *action)
+{
+	irq_pm_restore_handler(action);
+	if (action->flags & IRQF_NO_SUSPEND)
+		desc->skip_suspend_depth--;
+}
+
 /**
  * suspend_device_irqs - disable all currently enabled interrupt lines
  *
@@ -35,8 +121,7 @@ void suspend_device_irqs(void)
 	}
 
 	for_each_irq_desc(irq, desc)
-		if (desc->istate & IRQS_SUSPENDED)
-			synchronize_irq(irq);
+		synchronize_irq(irq);
 }
 EXPORT_SYMBOL_GPL(suspend_device_irqs);
 
Index: linux-pm/kernel/irq/internals.h
===================================================================
--- linux-pm.orig/kernel/irq/internals.h
+++ linux-pm/kernel/irq/internals.h
@@ -194,3 +194,23 @@ static inline void kstat_incr_irqs_this_
 	__this_cpu_inc(*desc->kstat_irqs);
 	__this_cpu_inc(kstat.irqs_sum);
 }
+
+#ifdef CONFIG_PM_SLEEP
+static inline bool irq_pm_saved_id(struct irqaction *action, void *dev_id)
+{
+	return action->s_dev_id == dev_id;
+}
+extern void irq_pm_setup(struct irq_desc *desc, struct irqaction *action);
+extern void irq_pm_cleanup(struct irq_desc *desc, struct irqaction *action);
+extern bool irq_pm_suspend_mode(struct irq_desc *desc);
+extern void irq_pm_normal_mode(struct irq_desc *desc);
+#else
+static inline bool irq_pm_saved_id(struct irqaction *action, void *dev_id)
+{
+	return false;
+}
+static inline void irq_pm_setup(struct irq_desc *desc, struct irqaction *action) {}
+static inline void irq_pm_cleanup(struct irq_desc *desc, struct irqaction *action) {}
+static inline bool irq_pm_suspend_mode(struct irq_desc *desc) { return false; }
+static inline void irq_pm_normal_mode(struct irq_desc *desc) {}
+#endif

