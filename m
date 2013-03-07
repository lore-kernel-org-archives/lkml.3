Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab3CGNxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 08:53:48 -0500
Received: from www.linutronix.de ([62.245.132.108]:48997 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab3CGNxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 08:53:47 -0500
Date: Thu, 7 Mar 2013 14:53:45 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Till Straumann <strauman@slac.stanford.edu>
Subject: [PATCH] genirq: Sanitize spurious interrupt detection of threaded
 irqs
Message-ID: <alpine.LFD.2.02.1303071450130.22263@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Till reported that he spurious interrupt detection of threaded
interrupts is broken in two ways:

- note_interrupt() is called for each action thread of a shared
  interrupt line. That's wrong as we are only interested whether none
  of the device drivers felt responsible for the interrupt, but by
  calling multiple times for a single interrupt line we account
  IRQ_NONE even if one of the drivers felt responsible.

- note_interrupt() when called from the thread handler is not
  serialized. That leaves the members of irq_desc which are used for
  the spurious detection unprotected.

To solve this we need to defer the spurious detection of a threaded
interrupt to the next hardware interrupt context where we have
implicit serialization.

If note_interrupt is called with action_ret == IRQ_WAKE_THREAD, we
check whether the previous interrupt requested a deferred check. If
not, we request a deferred check for the next hardware interrupt and
return. 

If set, we check whether one of the interrupt threads signaled
success. Depending on this information we feed the result into the
spurious detector.

If one primary handler of a shared interrupt returns IRQ_HANDLED we
disable the deferred check of irq threads on the same line, as we have
found at least one device driver who cared.

Reported-by: Till Straumann <strauman@slac.stanford.edu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irqdesc.h |    4 +++
 kernel/irq/internals.h  |    4 +++
 kernel/irq/manage.c     |    4 +--
 kernel/irq/spurious.c   |   57 ++++++++++++++++++++++++++++++++++++++++++++----
 4 files changed, 63 insertions(+), 6 deletions(-)

Index: linux-2.6/include/linux/irqdesc.h
===================================================================
--- linux-2.6.orig/include/linux/irqdesc.h
+++ linux-2.6/include/linux/irqdesc.h
@@ -27,6 +27,8 @@ struct irq_desc;
  * @irq_count:		stats field to detect stalled irqs
  * @last_unhandled:	aging timer for unhandled count
  * @irqs_unhandled:	stats field for spurious unhandled interrupts
+ * @threads_handled:	stats field for deferred spurious detection of threaded handlers
+ * @threads_handled_last: comparator field for deferred spurious detection of theraded handlers
  * @lock:		locking for SMP
  * @affinity_hint:	hint to user space for preferred irq affinity
  * @affinity_notify:	context for notification of affinity changes
@@ -52,6 +54,8 @@ struct irq_desc {
 	unsigned int		irq_count;	/* For detecting broken IRQs */
 	unsigned long		last_unhandled;	/* Aging timer for unhandled count */
 	unsigned int		irqs_unhandled;
+	atomic_t		threads_handled;
+	int			threads_handled_last;
 	raw_spinlock_t		lock;
 	struct cpumask		*percpu_enabled;
 #ifdef CONFIG_SMP
Index: linux-2.6/kernel/irq/internals.h
===================================================================
--- linux-2.6.orig/kernel/irq/internals.h
+++ linux-2.6/kernel/irq/internals.h
@@ -55,6 +55,10 @@ enum {
 	IRQS_SUSPENDED		= 0x00000800,
 };
 
+/* Bits for spurious detection of threaded handlers */
+#define SPURIOUS_MASK		0x7fffffff
+#define SPURIOUS_DEFERRED	0x80000000
+
 #include "debug.h"
 #include "settings.h"
 
Index: linux-2.6/kernel/irq/manage.c
===================================================================
--- linux-2.6.orig/kernel/irq/manage.c
+++ linux-2.6/kernel/irq/manage.c
@@ -867,8 +867,8 @@ static int irq_thread(void *data)
 		irq_thread_check_affinity(desc, action);
 
 		action_ret = handler_fn(desc, action);
-		if (!noirqdebug)
-			note_interrupt(action->irq, desc, action_ret);
+		if (!noirqdebug && action_ret == IRQ_HANDLED)
+			atomic_inc(&desc->threads_handled);
 
 		wake_threads_waitq(desc);
 	}
Index: linux-2.6/kernel/irq/spurious.c
===================================================================
--- linux-2.6.orig/kernel/irq/spurious.c
+++ linux-2.6/kernel/irq/spurious.c
@@ -271,15 +271,64 @@ void note_interrupt(unsigned int irq, st
 	if (desc->istate & IRQS_POLL_INPROGRESS)
 		return;
 
-	/* we get here again via the threaded handler */
-	if (action_ret == IRQ_WAKE_THREAD)
-		return;
-
 	if (bad_action_ret(action_ret)) {
 		report_bad_irq(irq, desc, action_ret);
 		return;
 	}
 
+	/*
+	 * We cannot call note_interrupt from the threaded handler. So
+	 * the threaded handlers store whether they sucessfully
+	 * handled an interrupt. Here is the right place to take care
+	 * of this.
+	 */
+	if (action_ret & IRQ_WAKE_THREAD) {
+		/*
+		 * There is a thread woken. Check whether one of the
+		 * shared primary handlers returned IRQ_HANDLED. If
+		 * not we defer the spurious detection to the next
+		 * interrupt.
+		 */
+		if (action_ret == IRQ_WAKE_THREAD) {
+			int handled;
+
+			/*
+			 * We use bit 31 of thread_handled_last to
+			 * note the deferred spurious detection
+			 * active. No locking necessary as
+			 * thread_handled_last is only accessed here
+			 * and we have the guarantee that hard
+			 * interrupts are not reentrant.
+			 */
+			if (!(desc->threads_handled_last & SPURIOUS_DEFERRED)) {
+				desc->threads_handled_last |= SPURIOUS_DEFERRED;
+				return;
+			}
+			/*
+			 * Check whether one of the threaded handlers
+			 * returned IRQ_HANDLED since the last
+			 * interrupt happened. Or the spurious
+			 * deferred flag for ease of comparison and
+			 * preservation in the writeback.
+			 */
+			handled = atomic_read(&desc->threads_handled);
+			handled |= SPURIOUS_DEFERRED;
+			if (handled != desc->threads_handled_last) {
+				action_ret = IRQ_HANDLED;
+				desc->threads_handled_last = handled;
+			} else {
+				action_ret = IRQ_NONE;
+			}
+		} else {
+			/*
+			 * One of the primary handlers returned
+			 * IRQ_HANDLED. So we don't care about the
+			 * threaded handlers on the same line.
+			 */
+			desc->threads_handled_last &= ~SPURIOUS_DEFERRED;
+		}
+	}
+
 	if (unlikely(action_ret == IRQ_NONE)) {
 		/*
 		 * If we are seeing only the odd spurious IRQ caused by
