Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbaF3Mat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:30:49 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754431AbaF3Maq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:30:46 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 160/181] genirq: Sanitize spurious interrupt detection of threaded irqs
Date: Mon, 30 Jun 2014 13:53:01 +0200
Message-Id: <652b082d06254db40f5fec53543a036ee4f4275f.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 1e77d0a1ed7417d2a5a52a7b8d32aea1833faa6c upstream.

Till reported that the spurious interrupt detection of threaded
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
Tested-by: Austin Schuh <austin@peloton-tech.com>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: Pavel Pisa <pisa@cmp.felk.cvut.cz>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: linux-can@vger.kernel.org
Link: http://lkml.kernel.org/r/alpine.LFD.2.02.1303071450130.22263@ionos
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/linux/irqdesc.h |   4 ++
 kernel/irq/manage.c     |   4 +-
 kernel/irq/spurious.c   | 106 ++++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 108 insertions(+), 6 deletions(-)

diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index 56fb646909dc..a7b4b61fc026 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
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
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 9e31fa71908d..75a976a8ed58 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -856,8 +856,8 @@ static int irq_thread(void *data)
 		irq_thread_check_affinity(desc, action);
 
 		action_ret = handler_fn(desc, action);
-		if (!noirqdebug)
-			note_interrupt(action->irq, desc, action_ret);
+		if (action_ret == IRQ_HANDLED)
+			atomic_inc(&desc->threads_handled);
 
 		wake_threads_waitq(desc);
 	}
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 7b5f012bde9d..febcee3c2aa9 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -265,21 +265,119 @@ try_misrouted_irq(unsigned int irq, struct irq_desc *desc,
 	return action && (action->flags & IRQF_IRQPOLL);
 }
 
+#define SPURIOUS_DEFERRED	0x80000000
+
 void note_interrupt(unsigned int irq, struct irq_desc *desc,
 		    irqreturn_t action_ret)
 {
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
+	 * We cannot call note_interrupt from the threaded handler
+	 * because we need to look at the compound of all handlers
+	 * (primary and threaded). Aside of that in the threaded
+	 * shared case we have no serialization against an incoming
+	 * hardware interrupt while we are dealing with a threaded
+	 * result.
+	 *
+	 * So in case a thread is woken, we just note the fact and
+	 * defer the analysis to the next hardware interrupt.
+	 *
+	 * The threaded handlers store whether they sucessfully
+	 * handled an interrupt and we check whether that number
+	 * changed versus the last invocation.
+	 *
+	 * We could handle all interrupts with the delayed by one
+	 * mechanism, but for the non forced threaded case we'd just
+	 * add pointless overhead to the straight hardirq interrupts
+	 * for the sake of a few lines less code.
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
+			/*
+			 * We use bit 31 of thread_handled_last to
+			 * denote the deferred spurious detection
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
+			 * interrupt happened.
+			 *
+			 * For simplicity we just set bit 31, as it is
+			 * set in threads_handled_last as well. So we
+			 * avoid extra masking. And we really do not
+			 * care about the high bits of the handled
+			 * count. We just care about the count being
+			 * different than the one we saw before.
+			 */
+			handled = atomic_read(&desc->threads_handled);
+			handled |= SPURIOUS_DEFERRED;
+			if (handled != desc->threads_handled_last) {
+				action_ret = IRQ_HANDLED;
+				/*
+				 * Note: We keep the SPURIOUS_DEFERRED
+				 * bit set. We are handling the
+				 * previous invocation right now.
+				 * Keep it for the current one, so the
+				 * next hardware interrupt will
+				 * account for it.
+				 */
+				desc->threads_handled_last = handled;
+			} else {
+				/*
+				 * None of the threaded handlers felt
+				 * responsible for the last interrupt
+				 *
+				 * We keep the SPURIOUS_DEFERRED bit
+				 * set in threads_handled_last as we
+				 * need to account for the current
+				 * interrupt as well.
+				 */
+				action_ret = IRQ_NONE;
+			}
+		} else {
+			/*
+			 * One of the primary handlers returned
+			 * IRQ_HANDLED. So we don't care about the
+			 * threaded handlers on the same line. Clear
+			 * the deferred detection bit.
+			 *
+			 * In theory we could/should check whether the
+			 * deferred bit is set and take the result of
+			 * the previous run into account here as
+			 * well. But it's really not worth the
+			 * trouble. If every other interrupt is
+			 * handled we never trigger the spurious
+			 * detector. And if this is just the one out
+			 * of 100k unhandled ones which is handled
+			 * then we merily delay the spurious detection
+			 * by one hard interrupt. Not a real problem.
+			 */
+			desc->threads_handled_last &= ~SPURIOUS_DEFERRED;
+		}
+	}
+
 	if (unlikely(action_ret == IRQ_NONE)) {
 		/*
 		 * If we are seeing only the odd spurious IRQ caused by
-- 
2.0.0

