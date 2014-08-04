Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbaHDDTa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 23:19:30 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63379 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750929AbaHDDT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 23:19:29 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>
Subject: Re: [PATCH 1/3] irq / PM: New driver interface for wakeup interruptsn
Date: Mon, 04 Aug 2014 05:38:05 +0200
Message-ID: <1902117.DMBSnxJ5ph@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <9709483.qvfTdXg8SV@vostro.rjw.lan>
References: <20140724212620.GO3935@laptop> <1466301.X6ofroi0AB@vostro.rjw.lan> <9709483.qvfTdXg8SV@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, August 03, 2014 03:42:49 PM Rafael J. Wysocki wrote:
> On Saturday, August 02, 2014 03:31:01 AM Rafael J. Wysocki wrote:
> > On Friday, August 01, 2014 04:29:40 PM Rafael J. Wysocki wrote:
> > > On Friday, August 01, 2014 03:43:21 PM Thomas Gleixner wrote:
> > > > On Fri, 1 Aug 2014, Rafael J. Wysocki wrote:
> > > > > OK, I guess "IRQ_HANDLED from a wakeup interrupt" may be interpreted as
> > > > > IRQ_HANDLED_PMWAKE.  On the other hand, if that's going to be handled in
> > > > > handle_irq_event_percpu(), then using a special return code would save us
> > > > > a brach for IRQ_HANDLED interrupts.  We could convert it to IRQ_HANDLED
> > > > > immediately then.
> > > > 
> > > > We can handle it at the end of the function by calling
> > > > note_interrupt() unconditionally do the following there:
> > > > 
> > > >       if (suspended) {
> > > >       	 if (ret == IRQ_NONE) {
> > > > 	    if (shared)
> > > > 	       yell_and_abort_or_resume();
> > > >          } else {
> > > > 	    abort_or_resume();
> > > >          }
> > > >       }
> > > >       if (noirqdebug)
> > > >       	 return;
> > > 
> > > I see.
> > > 
> > > > > OK, I'll take a stab at the IRQF_SHARED thing if you don't mind.
> > > > 
> > > > Definitely not :)
> > > > 
> > > > > Here's my current understanding of what can be done for IRQF_NO_SUSPEND.
> > > > > 
> > > > > In suspend_device_irqs():
> > > > > 
> > > > > (1) If all actions in the list have the same setting (eg. IRQF_NO_SUSPEND unset),
> > > > >     keep the current behavior.
> > > > > (2) If the actions have different settings:
> > > > >     - Actions with IRQF_NO_SUSPEND set are not modified.
> > > > >     - Actions with IRQF_NO_SUSPEND unset are switched over to a stub handler.
> > > > >     - IRQS_SUSPEND_MODE (new flag) is set for the IRQ.
> > > > 
> > > > Can we please do that in setup_irq() and let the shared ones always
> > > > run through the stub? That keeps suspend/resume_device_irqs() simple.
> > > 
> > > OK
> > 
> > I've tried to do that, but encountered a problem.  The stub handler is called
> > with irq, dev_id as arguments and for the "interrupts are not suspended" case
> > (common) it has to use irq to find the irq_desc and then it has to use dev_id
> > to find the irqaction to call the original handler from there.  That seemed to
> > be a bit too much of a penalty to me.  Especially for people who never suspend
> > their machines. :-)
> > 
> > For this reason, I went for changing handlers in suspend_device_irqs() and
> > back in resume_device_irqs().  That's not terribly complicated (the restoration
> > in particular is pretty simple) and it should be easily reusable for the wakeup
> > interrupts case.  resume_device_irqs() wouldn't need any more changes for that,
> > for example.  It minimally affects systems that don't suspend too.
> > 
> > I also ended up adding a new interrupt handler return code (IRQ_SUSPENDED).
> > I could add a new irq_desc flag instead, but then the new code in suspend_device_irqs()
> > and the new check in note_interrupt() would need to be slightly more complicated.
> 
> Actually, if we have a global irqs_suspended state variable, it will be much
> simpler to handle wakeup interrupts going forward, because in that case we'll
> be able to keep their original interrupt handlers and IRQ_HANDLED from them
> will be interpreted as a wakeup event automatically.

I realized that with this, suspend_device_irqs() will be racy, because it
switches handlers and modifies irqs_suspended at different times then.
I'm not sure how much of a problem that would be, but it's better to
ensure that both the handler and note_interrupt() will be "switched" at
the same time, which means addin a wrapper handler at the __setup_irq()
time, after all.

To avoid the problem mentioned above, I'm using dev_id to store the action's
address and an additional "real dev_id" field to store the original value.
This version seems to work.

Rafael

---
 drivers/base/power/main.c   |    1 
 drivers/base/power/wakeup.c |   20 ++++++++++++++++
 include/linux/interrupt.h   |    4 +++
 include/linux/irqdesc.h     |    1 
 include/linux/suspend.h     |    3 ++
 kernel/irq/handle.c         |    3 --
 kernel/irq/internals.h      |    3 ++
 kernel/irq/manage.c         |   53 ++++++++++++++++++++++++++++++++++++++++++--
 kernel/irq/pm.c             |   10 ++++----
 kernel/irq/spurious.c       |   13 ++++++++++
 10 files changed, 103 insertions(+), 8 deletions(-)

Index: linux-pm/kernel/irq/manage.c
===================================================================
--- linux-pm.orig/kernel/irq/manage.c
+++ linux-pm/kernel/irq/manage.c
@@ -385,7 +385,7 @@ setup_affinity(unsigned int irq, struct
 void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
 {
 	if (suspend) {
-		if (!desc->action || (desc->action->flags & IRQF_NO_SUSPEND))
+		if (!desc->action || desc->skip_suspend)
 			return;
 		desc->istate |= IRQS_SUSPENDED;
 	}
@@ -658,6 +658,44 @@ int irq_set_parent(int irq, int parent_i
 }
 #endif
 
+bool irqs_suspended __read_mostly;
+
+void set_irqs_suspended(bool on)
+{
+	struct irq_desc *desc;
+	int irq;
+
+	irqs_suspended = on;
+	for_each_irq_desc(irq, desc)
+		synchronize_irq(irq);
+}
+
+/*
+ * Wrapper handler for shared interrupts.
+ */
+static irqreturn_t irq_shared_wrapper_handler(int irq, void *dev_id)
+{
+	struct irqaction *action;
+
+	if (unlikely(irqs_suspended))
+		return IRQ_NONE;
+
+	action = dev_id;
+	return action->s_handler(irq, action->s_dev_id);
+}
+
+static void irq_shared_wrap_handler(struct irqaction *action)
+{
+	if (action->handler == irq_shared_wrapper_handler ||
+	    (action->flags & IRQF_NO_SUSPEND))
+		return;
+
+	action->s_handler = action->handler;
+	action->handler = irq_shared_wrapper_handler;
+	action->s_dev_id = action->dev_id;
+	action->dev_id = action;
+}
+
 /*
  * Default primary interrupt handler for threaded interrupts. Is
  * assigned as primary handler when request_threaded_irq is called
@@ -1088,6 +1126,7 @@ __setup_irq(unsigned int irq, struct irq
 
 		/* add new interrupt at end of irq queue */
 		do {
+			irq_shared_wrap_handler(old);
 			/*
 			 * Or all existing action->thread_mask bits,
 			 * so we can find the next zero bit for this
@@ -1097,6 +1136,7 @@ __setup_irq(unsigned int irq, struct irq
 			old_ptr = &old->next;
 			old = *old_ptr;
 		} while (old);
+		irq_shared_wrap_handler(new);
 		shared = 1;
 	}
 
@@ -1222,6 +1262,9 @@ __setup_irq(unsigned int irq, struct irq
 	desc->irq_count = 0;
 	desc->irqs_unhandled = 0;
 
+	if (new->flags & IRQF_NO_SUSPEND)
+		desc->skip_suspend++;
+
 	/*
 	 * Check whether we disabled the irq via the spurious handler
 	 * before. Reenable it and give it another chance.
@@ -1328,13 +1371,19 @@ static struct irqaction *__free_irq(unsi
 			return NULL;
 		}
 
-		if (action->dev_id == dev_id)
+		if (action->dev_id == dev_id || action->s_dev_id == dev_id)
 			break;
 		action_ptr = &action->next;
 	}
 
 	/* Found it - now remove it from the list of entries: */
 	*action_ptr = action->next;
+	if (action->flags & IRQF_NO_SUSPEND) {
+		desc->skip_suspend--;
+	} else if (action->handler == irq_shared_wrapper_handler) {
+		action->handler = action->s_handler;
+		action->dev_id = action->s_dev_id;
+	}
 
 	/* If this was the last handler, shut down the IRQ line: */
 	if (!desc->action) {
Index: linux-pm/include/linux/interrupt.h
===================================================================
--- linux-pm.orig/include/linux/interrupt.h
+++ linux-pm/include/linux/interrupt.h
@@ -90,8 +90,10 @@ typedef irqreturn_t (*irq_handler_t)(int
 /**
  * struct irqaction - per interrupt action descriptor
  * @handler:	interrupt handler function
+ * @s_handler:	interrupt handler function for shared interrupts
  * @name:	name of the device
  * @dev_id:	cookie to identify the device
+ * @s_dev_id:	cookie to identify the device for shared interrupts
  * @percpu_dev_id:	cookie to identify the device
  * @next:	pointer to the next irqaction for shared interrupts
  * @irq:	interrupt number
@@ -105,6 +107,8 @@ typedef irqreturn_t (*irq_handler_t)(int
 struct irqaction {
 	irq_handler_t		handler;
 	void			*dev_id;
+	irq_handler_t		s_handler;
+	void			*s_dev_id;
 	void __percpu		*percpu_dev_id;
 	struct irqaction	*next;
 	irq_handler_t		thread_fn;
Index: linux-pm/kernel/irq/handle.c
===================================================================
--- linux-pm.orig/kernel/irq/handle.c
+++ linux-pm/kernel/irq/handle.c
@@ -175,8 +175,7 @@ handle_irq_event_percpu(struct irq_desc
 
 	add_interrupt_randomness(irq, flags);
 
-	if (!noirqdebug)
-		note_interrupt(irq, desc, retval);
+	note_interrupt(irq, desc, retval);
 	return retval;
 }
 
Index: linux-pm/kernel/irq/spurious.c
===================================================================
--- linux-pm.orig/kernel/irq/spurious.c
+++ linux-pm/kernel/irq/spurious.c
@@ -13,6 +13,7 @@
 #include <linux/interrupt.h>
 #include <linux/moduleparam.h>
 #include <linux/timer.h>
+#include <linux/suspend.h>
 
 #include "internals.h"
 
@@ -275,6 +276,18 @@ try_misrouted_irq(unsigned int irq, stru
 void note_interrupt(unsigned int irq, struct irq_desc *desc,
 		    irqreturn_t action_ret)
 {
+	if (unlikely(irqs_suspended && action_ret == IRQ_NONE)) {
+		pr_err_ratelimited("IRQ %d: Unhandled while suspended\n", irq);
+		desc->istate |= IRQS_SUSPENDED;
+		desc->depth++;
+		irq_disable(desc);
+		pm_system_wakeup();
+		return;
+	}
+
+	if (noirqdebug)
+		return;
+
 	if (desc->istate & IRQS_POLL_INPROGRESS ||
 	    irq_settings_is_polled(desc))
 		return;
Index: linux-pm/include/linux/suspend.h
===================================================================
--- linux-pm.orig/include/linux/suspend.h
+++ linux-pm/include/linux/suspend.h
@@ -371,6 +371,8 @@ extern int unregister_pm_notifier(struct
 extern bool events_check_enabled;
 
 extern bool pm_wakeup_pending(void);
+extern void pm_system_wakeup(void);
+extern void pm_wakeup_clear(void);
 extern bool pm_get_wakeup_count(unsigned int *count, bool block);
 extern bool pm_save_wakeup_count(unsigned int count);
 extern void pm_wakep_autosleep_enabled(bool set);
@@ -418,6 +420,7 @@ static inline int unregister_pm_notifier
 #define pm_notifier(fn, pri)	do { (void)(fn); } while (0)
 
 static inline bool pm_wakeup_pending(void) { return false; }
+static inline void pm_system_wakeup(void) {}
 
 static inline void lock_system_sleep(void) {}
 static inline void unlock_system_sleep(void) {}
Index: linux-pm/drivers/base/power/wakeup.c
===================================================================
--- linux-pm.orig/drivers/base/power/wakeup.c
+++ linux-pm/drivers/base/power/wakeup.c
@@ -691,6 +691,8 @@ void pm_print_active_wakeup_sources(void
 }
 EXPORT_SYMBOL_GPL(pm_print_active_wakeup_sources);
 
+static bool abort_suspend;
+
 /**
  * pm_wakeup_pending - Check if power transition in progress should be aborted.
  *
@@ -712,6 +714,7 @@ bool pm_wakeup_pending(void)
 		ret = (cnt != saved_count || inpr > 0);
 		events_check_enabled = !ret;
 	}
+	ret = ret || abort_suspend;
 	spin_unlock_irqrestore(&events_lock, flags);
 
 	if (ret) {
@@ -722,6 +725,23 @@ bool pm_wakeup_pending(void)
 	return ret;
 }
 
+void pm_system_wakeup(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&events_lock, flags);
+	abort_suspend = true;
+	spin_unlock_irqrestore(&events_lock, flags);
+	freeze_wake();
+}
+
+void pm_wakeup_clear(void)
+{
+	spin_lock_irq(&events_lock);
+	abort_suspend = false;
+	spin_unlock_irq(&events_lock);
+}
+
 /**
  * pm_get_wakeup_count - Read the number of registered wakeup events.
  * @count: Address to store the value at.
Index: linux-pm/drivers/base/power/main.c
===================================================================
--- linux-pm.orig/drivers/base/power/main.c
+++ linux-pm/drivers/base/power/main.c
@@ -1648,6 +1648,7 @@ int dpm_suspend_start(pm_message_t state
 {
 	int error;
 
+	pm_wakeup_clear();
 	error = dpm_prepare(state);
 	if (error) {
 		suspend_stats.failed_prepare++;
Index: linux-pm/kernel/irq/pm.c
===================================================================
--- linux-pm.orig/kernel/irq/pm.c
+++ linux-pm/kernel/irq/pm.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/syscore_ops.h>
+#include <linux/suspend.h>
 
 #include "internals.h"
 
@@ -33,10 +34,7 @@ void suspend_device_irqs(void)
 		__disable_irq(desc, irq, true);
 		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
-
-	for_each_irq_desc(irq, desc)
-		if (desc->istate & IRQS_SUSPENDED)
-			synchronize_irq(irq);
+	set_irqs_suspended(true);
 }
 EXPORT_SYMBOL_GPL(suspend_device_irqs);
 
@@ -90,6 +88,7 @@ device_initcall(irq_pm_init_ops);
  */
 void resume_device_irqs(void)
 {
+	set_irqs_suspended(false);
 	resume_irqs(false);
 }
 EXPORT_SYMBOL_GPL(resume_device_irqs);
@@ -102,6 +101,9 @@ int check_wakeup_irqs(void)
 	struct irq_desc *desc;
 	int irq;
 
+	if (pm_wakeup_pending())
+		return -EBUSY;
+
 	for_each_irq_desc(irq, desc) {
 		/*
 		 * Only interrupts which are marked as wakeup source
Index: linux-pm/kernel/irq/internals.h
===================================================================
--- linux-pm.orig/kernel/irq/internals.h
+++ linux-pm/kernel/irq/internals.h
@@ -17,6 +17,9 @@
 #define istate core_internal_state__do_not_mess_with_it
 
 extern bool noirqdebug;
+extern bool irqs_suspended;
+
+extern void set_irqs_suspended(bool on);
 
 /*
  * Bits used by threaded handlers:
Index: linux-pm/include/linux/irqdesc.h
===================================================================
--- linux-pm.orig/include/linux/irqdesc.h
+++ linux-pm/include/linux/irqdesc.h
@@ -51,6 +51,7 @@ struct irq_desc {
 	unsigned int		core_internal_state__do_not_mess_with_it;
 	unsigned int		depth;		/* nested irq disables */
 	unsigned int		wake_depth;	/* nested wake enables */
+	unsigned int		skip_suspend;
 	unsigned int		irq_count;	/* For detecting broken IRQs */
 	unsigned long		last_unhandled;	/* Aging timer for unhandled count */
 	unsigned int		irqs_unhandled;

