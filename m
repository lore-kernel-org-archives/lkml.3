Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbaHBBM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 21:12:29 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63263 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754389AbaHBBM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 21:12:27 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>
Subject: Re: [PATCH 1/3] irq / PM: New driver interface for wakeup interruptsn
Date: Sat, 02 Aug 2014 03:31:01 +0200
Message-ID: <1466301.X6ofroi0AB@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <3855585.ek3PTQLkmN@vostro.rjw.lan>
References: <20140724212620.GO3935@laptop> <alpine.DEB.2.10.1408011533580.4997@nanos> <3855585.ek3PTQLkmN@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 01, 2014 04:29:40 PM Rafael J. Wysocki wrote:
> On Friday, August 01, 2014 03:43:21 PM Thomas Gleixner wrote:
> > On Fri, 1 Aug 2014, Rafael J. Wysocki wrote:
> > > OK, I guess "IRQ_HANDLED from a wakeup interrupt" may be interpreted as
> > > IRQ_HANDLED_PMWAKE.  On the other hand, if that's going to be handled in
> > > handle_irq_event_percpu(), then using a special return code would save us
> > > a brach for IRQ_HANDLED interrupts.  We could convert it to IRQ_HANDLED
> > > immediately then.
> > 
> > We can handle it at the end of the function by calling
> > note_interrupt() unconditionally do the following there:
> > 
> >       if (suspended) {
> >       	 if (ret == IRQ_NONE) {
> > 	    if (shared)
> > 	       yell_and_abort_or_resume();
> >          } else {
> > 	    abort_or_resume();
> >          }
> >       }
> >       if (noirqdebug)
> >       	 return;
> 
> I see.
> 
> > > OK, I'll take a stab at the IRQF_SHARED thing if you don't mind.
> > 
> > Definitely not :)
> > 
> > > Here's my current understanding of what can be done for IRQF_NO_SUSPEND.
> > > 
> > > In suspend_device_irqs():
> > > 
> > > (1) If all actions in the list have the same setting (eg. IRQF_NO_SUSPEND unset),
> > >     keep the current behavior.
> > > (2) If the actions have different settings:
> > >     - Actions with IRQF_NO_SUSPEND set are not modified.
> > >     - Actions with IRQF_NO_SUSPEND unset are switched over to a stub handler.
> > >     - IRQS_SUSPEND_MODE (new flag) is set for the IRQ.
> > 
> > Can we please do that in setup_irq() and let the shared ones always
> > run through the stub? That keeps suspend/resume_device_irqs() simple.
> 
> OK

I've tried to do that, but encountered a problem.  The stub handler is called
with irq, dev_id as arguments and for the "interrupts are not suspended" case
(common) it has to use irq to find the irq_desc and then it has to use dev_id
to find the irqaction to call the original handler from there.  That seemed to
be a bit too much of a penalty to me.  Especially for people who never suspend
their machines. :-)

For this reason, I went for changing handlers in suspend_device_irqs() and
back in resume_device_irqs().  That's not terribly complicated (the restoration
in particular is pretty simple) and it should be easily reusable for the wakeup
interrupts case.  resume_device_irqs() wouldn't need any more changes for that,
for example.  It minimally affects systems that don't suspend too.

I also ended up adding a new interrupt handler return code (IRQ_SUSPENDED).
I could add a new irq_desc flag instead, but then the new code in suspend_device_irqs()
and the new check in note_interrupt() would need to be slightly more complicated.

Below is my current prototype.  Please have a look and let me know what you
think.

I gave it a little bit of testing with success.

Of course, I'd prefer to move the IRQ suspend/resume code to pm.c and get rid
of the third argument in __disable_irq() and __enable_irq() before making these
changes for real.

Rafael


---
 drivers/base/power/main.c   |    1 +
 drivers/base/power/wakeup.c |   20 ++++++++++++++++++++
 include/linux/interrupt.h   |    2 ++
 include/linux/irqreturn.h   |    2 ++
 include/linux/suspend.h     |    3 +++
 kernel/irq/handle.c         |    3 +--
 kernel/irq/manage.c         |   35 ++++++++++++++++++++++++++++++++++-
 kernel/irq/pm.c             |    7 +++++--
 kernel/irq/spurious.c       |   16 ++++++++++++++++
 9 files changed, 84 insertions(+), 5 deletions(-)

Index: linux-pm/kernel/irq/manage.c
===================================================================
--- linux-pm.orig/kernel/irq/manage.c
+++ linux-pm/kernel/irq/manage.c
@@ -382,11 +382,36 @@ setup_affinity(unsigned int irq, struct
 }
 #endif
 
+/*
+ * Dummy handler for shared interrupts to use during system suspend.
+ */
+static irqreturn_t irq_pm_dummy_handler(int irq, void *dev_id)
+{
+	return IRQ_SUSPENDED;
+}
+
 void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
 {
 	if (suspend) {
-		if (!desc->action || (desc->action->flags & IRQF_NO_SUSPEND))
+		struct irqaction *action;
+
+		if (!desc->action)
 			return;
+
+		for (action = desc->action; action; action = action->next) {
+			if (action->flags & IRQF_NO_SUSPEND)
+				break;
+		}
+		if (action) {
+			for (action = desc->action; action; action = action->next) {
+				if (!(action->flags & IRQF_NO_SUSPEND)) {
+					action->saved_handler = action->handler;
+					action->handler = irq_pm_dummy_handler;
+				}
+			}
+			return;
+		}
+
 		desc->istate |= IRQS_SUSPENDED;
 	}
 
@@ -445,6 +470,14 @@ EXPORT_SYMBOL(disable_irq);
 void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume)
 {
 	if (resume) {
+		struct irqaction *action;
+
+		for (action = desc->action; action; action = action->next) {
+			if (action->handler == irq_pm_dummy_handler) {
+				action->handler = action->saved_handler;
+				action->saved_handler = NULL;
+			}
+		}
 		if (!(desc->istate & IRQS_SUSPENDED)) {
 			if (!desc->action)
 				return;
Index: linux-pm/include/linux/interrupt.h
===================================================================
--- linux-pm.orig/include/linux/interrupt.h
+++ linux-pm/include/linux/interrupt.h
@@ -90,6 +90,7 @@ typedef irqreturn_t (*irq_handler_t)(int
 /**
  * struct irqaction - per interrupt action descriptor
  * @handler:	interrupt handler function
+ * @saved_handler:	saved pointer to interrupt handler function
  * @name:	name of the device
  * @dev_id:	cookie to identify the device
  * @percpu_dev_id:	cookie to identify the device
@@ -104,6 +105,7 @@ typedef irqreturn_t (*irq_handler_t)(int
  */
 struct irqaction {
 	irq_handler_t		handler;
+	irq_handler_t		saved_handler;
 	void			*dev_id;
 	void __percpu		*percpu_dev_id;
 	struct irqaction	*next;
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
 
@@ -275,10 +276,25 @@ try_misrouted_irq(unsigned int irq, stru
 void note_interrupt(unsigned int irq, struct irq_desc *desc,
 		    irqreturn_t action_ret)
 {
+	if (unlikely(action_ret == IRQ_SUSPENDED)) {
+		pr_err("IRQ %d: Unhandled interrupt from suspended device\n", irq);
+
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
 
+	action_ret &= ~IRQ_SUSPENDED;
+
 	if (bad_action_ret(action_ret)) {
 		report_bad_irq(irq, desc, action_ret);
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
 
@@ -35,8 +36,7 @@ void suspend_device_irqs(void)
 	}
 
 	for_each_irq_desc(irq, desc)
-		if (desc->istate & IRQS_SUSPENDED)
-			synchronize_irq(irq);
+		synchronize_irq(irq);
 }
 EXPORT_SYMBOL_GPL(suspend_device_irqs);
 
@@ -102,6 +102,9 @@ int check_wakeup_irqs(void)
 	struct irq_desc *desc;
 	int irq;
 
+	if (pm_wakeup_pending())
+		return -EBUSY;
+
 	for_each_irq_desc(irq, desc) {
 		/*
 		 * Only interrupts which are marked as wakeup source
Index: linux-pm/include/linux/irqreturn.h
===================================================================
--- linux-pm.orig/include/linux/irqreturn.h
+++ linux-pm/include/linux/irqreturn.h
@@ -6,11 +6,13 @@
  * @IRQ_NONE		interrupt was not from this device
  * @IRQ_HANDLED		interrupt was handled by this device
  * @IRQ_WAKE_THREAD	handler requests to wake the handler thread
+ * @IRQ_SUSPENDED	interrupt has been suspended for this device
  */
 enum irqreturn {
 	IRQ_NONE		= (0 << 0),
 	IRQ_HANDLED		= (1 << 0),
 	IRQ_WAKE_THREAD		= (1 << 1),
+	IRQ_SUSPENDED		= (1 << 2),
 };
 
 typedef enum irqreturn irqreturn_t;

