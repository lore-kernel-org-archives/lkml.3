Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007AbaIQV5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 17:57:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:51787 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755953AbaIQV5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 17:57:17 -0400
Date: Wed, 17 Sep 2014 14:57:11 -0700 (PDT)
From: Thomas Gleixner <tglx@linutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH/RFC] rtc: rtc-twl: Fixed nested IRQ handling in resume
 from suspend
In-Reply-To: <1410607196-3941-1-git-send-email-laurent.pinchart@ideasonboard.com>
Message-ID: <alpine.DEB.2.10.1409161318130.4247@nanos>
References: <1410607196-3941-1-git-send-email-laurent.pinchart@ideasonboard.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Sep 2014, Laurent Pinchart wrote:

> The TWL RTC interrupt is a double-nested threaded interrupt, handled
> through the TWL SIH (Secondary Interrupt Handler) and PIH (Primary
> Interrupt Handler).
> 
> When the system is woken up from suspend by a TWL RTC alarm interrupt,
> the TWL PIH and SIH are enabled first (due to the normal IRQ enabling
> sequence for the PIH and to the IRQF_EARLY_RESUME flag for the SIH)
> before the TWL RTC interrupt gets enabled. This results on the interrupt
> being processed by the TWL primary interrupt handler, forwarded to the
> nested SIH, and then marked as pending for the RTC by handle_nested_irq
> called from the SIH.
> 
> The RTC interrupt then eventually gets reenabled the kernel, which will
> try to call its top half interrupt handler. As the interrupt is a nested
> threaded IRQ, its primary handler has been set to the
> irq_nested_primary_handler function, which is never supposed to be
> called and generates a WARN_ON, without waking the IRQ thread up.

Right. It CANNOT wake up the thread, because there is no thread
associated to that particular interrupt. It's handler is called in the
context of the parent (demultiplexing) interrupt thread. Of course
twl4030 does not call irq_set_parent() for the nested
interrupts. That's there so the resend of a nested thread irq will be
targeted to its parent.
 
Using IRQF_EARLY_RESUME is really, really wrong for device drivers
simply because at the point where early resume is called the devices
have not yet been resumed, so a interrupt delivered at this point
might run into a stale device and cause a machine stall or any other
undesired side effect. It was added for a special case with Xen where
Xen needs the IPIs working early in resume. And it's definitely not
meant to solve ordering issues of interrupts on resume.

That said, looking at that twl4030 driver, there seems to be a double
nesting issue. So also the simple one level parent redirection of the
irq resend wont work. I really wonder why this only triggers in the
context of resume.

Now the resend issue is simple to fix. The resume time ordering
constraints is a bit more involved, but it should be possible w/o
inflicting anything more complex on drivers than requiring them to use
irq_set_parent(), which should be name irq_set_nested_parent().

Completely untested patch below. It applies on top of

 git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/pm

So what twl4030 needs on top of that are calls to
irq_set_nested_parent() for the nested interrupts.

That will automatically establish the nesting depth, redirect the
retrigger to the top most interrupt and solve the resume ordering.

The resume ordering is the reverse of the nesting:

    top-irq1 - nested irq10   - nested irq20 (parent = 10)
    	     | (parent = 1)   - nested irq21 (parent = 10)
	     |
    	     - nested irq11   - nested irq22 (parent = 11)	
	     | (parent = 1)   - nested irq23 (parent = 11)
	     |
	     - nested irq12   - nested irq24 (parent = 12)
	       (parent = 1)   - nested irq25 (parent = 12)

So the resume ordering is

   20-21-22-23-24-25 - 10-11-12 - 1

Thanks,

	tglx

---
 drivers/mfd/twl6030-irq.c |    3 --
 include/linux/irq.h       |    9 ------
 include/linux/irqdesc.h   |    5 +++
 kernel/irq/manage.c       |   28 ++++++++++++++++++---
 kernel/irq/pm.c           |   60 +++++++++++++++++++++++++++++++++++++++++-----
 kernel/irq/resend.c       |    4 +--
 kernel/irq/settings.h     |    5 +++
 7 files changed, 92 insertions(+), 22 deletions(-)

Index: tip/drivers/mfd/twl6030-irq.c
===================================================================
--- tip.orig/drivers/mfd/twl6030-irq.c
+++ tip/drivers/mfd/twl6030-irq.c
@@ -350,8 +350,7 @@ static int twl6030_irq_map(struct irq_do
 
 	irq_set_chip_data(virq, pdata);
 	irq_set_chip_and_handler(virq,  &pdata->irq_chip, handle_simple_irq);
-	irq_set_nested_thread(virq, true);
-	irq_set_parent(virq, pdata->twl_irq);
+	irq_set_nested_parent(virq, pdata->twl_irq);
 
 #ifdef CONFIG_ARM
 	/*
Index: tip/include/linux/irq.h
===================================================================
--- tip.orig/include/linux/irq.h
+++ tip/include/linux/irq.h
@@ -415,14 +415,7 @@ static inline void irq_move_masked_irq(s
 
 extern int no_irq_affinity;
 
-#ifdef CONFIG_HARDIRQS_SW_RESEND
-int irq_set_parent(int irq, int parent_irq);
-#else
-static inline int irq_set_parent(int irq, int parent_irq)
-{
-	return 0;
-}
-#endif
+int irq_set_nested_parent(int irq, int parent_irq);
 
 /*
  * Built-in IRQ handlers for various IRQ types,
Index: tip/include/linux/irqdesc.h
===================================================================
--- tip.orig/include/linux/irqdesc.h
+++ tip/include/linux/irqdesc.h
@@ -41,6 +41,9 @@ struct irq_desc;
  *			IRQF_NO_SUSPEND set
  * @force_resume_depth:	number of irqactions on a irq descriptor with
  *			IRQF_FORCE_RESUME set
+ * @parent_irq:		Parent interrupt in case of nested threads
+ * @parent_top:		Top parent interrupt in case of multiple nested threads
+ * @parent_depth:	Nest level of multiple nested threads for resume ordering
  * @dir:		/proc/irq/ procfs entry
  * @name:		flow handler name for /proc/interrupts output
  */
@@ -82,6 +85,8 @@ struct irq_desc {
 	struct proc_dir_entry	*dir;
 #endif
 	int			parent_irq;
+	int			parent_depth;
+	int			parent_top;
 	struct module		*owner;
 	const char		*name;
 } ____cacheline_internodealigned_in_smp;
Index: tip/kernel/irq/manage.c
===================================================================
--- tip.orig/kernel/irq/manage.c
+++ tip/kernel/irq/manage.c
@@ -624,21 +624,41 @@ int __irq_set_trigger(struct irq_desc *d
 	return ret;
 }
 
-#ifdef CONFIG_HARDIRQS_SW_RESEND
-int irq_set_parent(int irq, int parent_irq)
+int irq_set_nested_parent(int irq, int parent_irq)
 {
+	struct irq_desc *desc;
 	unsigned long flags;
-	struct irq_desc *desc = irq_get_desc_lock(irq, &flags, 0);
+	int parent_depth, parent_top;
 
+	/*
+	 * Get the parent irq first to retrieve the parent depth and
+	 * the top level parent irq number. The depth is required for
+	 * resume ordering, the top level irq number for software
+	 * resend.
+	 */
+	desc = irq_get_desc_lock(parent_irq, &flags, 0);
+	if (!desc)
+		return -EINVAL;
+	parent_depth = desc->parent_depth;
+	parent_top = desc->parent_top;
+	irq_put_desc_unlock(desc, flags);
+
+	/* Setup the info in the child */
+	desc = irq_get_desc_lock(parent_irq, &flags, 0);
 	if (!desc)
 		return -EINVAL;
 
 	desc->parent_irq = parent_irq;
+	desc->parent_top = parent_top ? parent_top : parent_irq;
+	desc->parent_depth = parent_depth + 1;
+
+	/* Set the nested thread bit as well */
+	irq_settings_set_nested_thread(desc);
 
 	irq_put_desc_unlock(desc, flags);
+
 	return 0;
 }
-#endif
 
 /*
  * Default primary interrupt handler for threaded interrupts. Is
Index: tip/kernel/irq/pm.c
===================================================================
--- tip.orig/kernel/irq/pm.c
+++ tip/kernel/irq/pm.c
@@ -8,6 +8,7 @@
 
 #include <linux/irq.h>
 #include <linux/module.h>
+#include <linux/bitmap.h>
 #include <linux/interrupt.h>
 #include <linux/suspend.h>
 #include <linux/syscore_ops.h>
@@ -93,6 +94,37 @@ static bool suspend_device_irq(struct ir
 	return true;
 }
 
+#define IRQ_NEST_DEPTH 4
+
+struct resume_level {
+	unsigned long	map[BITS_TO_LONGS(IRQ_BITMAP_BITS)];
+	int		top;
+};
+
+static struct resume_level resume_order_lvls[IRQ_NEST_DEPTH];
+static struct resume_level resume_early_lvl;
+static int resume_order_max_depth;
+
+static void update_resume_order(struct irq_desc *desc, int irq)
+{
+	bool early = desc->action && desc->action->flags & IRQF_EARLY_RESUME;
+	int depth = desc->parent_depth;
+	struct resume_level *l;
+
+	if (!early) {
+		if (WARN_ON_ONCE(depth >= IRQ_NEST_DEPTH))
+			depth = IRQ_NEST_DEPTH - 1;
+		l = resume_order_lvls + depth;
+		if (depth > resume_order_max_depth)
+			resume_order_max_depth = depth;
+	} else {
+		WARN_ON_ONCE(depth != 0);
+		l = &resume_early_lvl;
+	}
+	set_bit(irq, l->map);
+	l->top = irq;
+}
+
 /**
  * suspend_device_irqs - disable all currently enabled interrupt lines
  *
@@ -114,11 +146,16 @@ void suspend_device_irqs(void)
 	struct irq_desc *desc;
 	int irq;
 
+	memset(resume_order_lvls, 0, sizeof(resume_order_lvls));
+	memset(resume_early_lvl, 0, sizeof(resume_early_lvl));
+	resume_order_max_depth = 0;
+
 	for_each_irq_desc(irq, desc) {
 		unsigned long flags;
 		bool sync;
 
 		raw_spin_lock_irqsave(&desc->lock, flags);
+		update_resume_order(desc, irq);
 		sync = suspend_device_irq(desc, irq);
 		raw_spin_unlock_irqrestore(&desc->lock, flags);
 
@@ -146,17 +183,16 @@ resume:
 	__enable_irq(desc, irq);
 }
 
-static void resume_irqs(bool want_early)
+static void resume_irq_lvl(struct resume_level *l)
 {
 	struct irq_desc *desc;
+	unsigned long flags;
 	int irq;
 
-	for_each_irq_desc(irq, desc) {
-		unsigned long flags;
-		bool is_early = desc->action &&
-			desc->action->flags & IRQF_EARLY_RESUME;
+	for_each_set_bit(irq, l->map, l->top + 1) {
 
-		if (!is_early && want_early)
+		desc = irq_to_desc(irq);
+		if (WARN_ON_ONCE(!desc))
 			continue;
 
 		raw_spin_lock_irqsave(&desc->lock, flags);
@@ -165,6 +201,18 @@ static void resume_irqs(bool want_early)
 	}
 }
 
+static void resume_irqs(bool early)
+{
+	int i;
+
+	if (early) {
+		resume_irq_lvl(&resume_early_lvl);
+	} else {
+		for (i = resume_order_max_depth; i >= 0; i--)
+			resume_irq_lvl(resume_order_lvls + i);
+	}
+}
+
 /**
  * irq_pm_syscore_ops - enable interrupt lines early
  *
Index: tip/kernel/irq/resend.c
===================================================================
--- tip.orig/kernel/irq/resend.c
+++ tip/kernel/irq/resend.c
@@ -79,9 +79,9 @@ void check_irq_resend(struct irq_desc *d
 			 * in the thread context of the parent irq,
 			 * retrigger the parent.
 			 */
-			if (desc->parent_irq &&
+			if (desc->parent_top &&
 			    irq_settings_is_nested_thread(desc))
-				irq = desc->parent_irq;
+				irq = desc->parent_top;
 			/* Set it pending and activate the softirq: */
 			set_bit(irq, irqs_resend);
 			tasklet_schedule(&resend_tasklet);
Index: tip/kernel/irq/settings.h
===================================================================
--- tip.orig/kernel/irq/settings.h
+++ tip/kernel/irq/settings.h
@@ -53,6 +53,11 @@ static inline void irq_settings_set_per_
 	desc->status_use_accessors |= _IRQ_PER_CPU;
 }
 
+static inline void irq_settings_set_nested_thread(struct irq_desc *desc)
+{
+	desc->status_use_accessors |= _IRQ_NESTED_THREAD;
+}
+
 static inline void irq_settings_set_no_balancing(struct irq_desc *desc)
 {
 	desc->status_use_accessors |= _IRQ_NO_BALANCING;



