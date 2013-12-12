Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956Ab3LLOmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 09:42:35 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:34525 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751912Ab3LLOma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 09:42:30 -0500
Date: Thu, 12 Dec 2013 09:42:27 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] wait-simple: Introduce the simple waitqueue
 implementation
Message-ID: <20131212094227.0a227f6f@gandalf.local.home>
In-Reply-To: <20131212114447.GH21999@twins.programming.kicks-ass.net>
References: <1386810399-8973-1-git-send-email-paul.gortmaker@windriver.com>
	<1386810399-8973-2-git-send-email-paul.gortmaker@windriver.com>
	<20131212114447.GH21999@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Dec 2013 12:44:47 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Dec 11, 2013 at 08:06:37PM -0500, Paul Gortmaker wrote:
> > +/* Adds w to head->task_list. Must be called with head->lock locked. */
> > +static inline void __swait_enqueue(struct swait_queue_head *head,
> > +				   struct swaiter *w)
> > +{
> > +	list_add(&w->node, &head->task_list);
> > +	/* We can't let the condition leak before the setting of head */
> > +	smp_mb();
> > +}
> 
> > +unsigned int
> > +__swake_up_locked(struct swait_queue_head *head, unsigned int state,
> > +		  unsigned int num)
> > +{
> > +	struct swaiter *curr, *next;
> > +	int woken = 0;
> > +
> > +	list_for_each_entry_safe(curr, next, &head->task_list, node) {
> > +		if (wake_up_state(curr->task, state)) {
> > +			__swait_dequeue(curr);
> > +			/*
> > +			 * The waiting task can free the waiter as
> > +			 * soon as curr->task = NULL is written,
> > +			 * without taking any locks. A memory barrier
> > +			 * is required here to prevent the following
> > +			 * store to curr->task from getting ahead of
> > +			 * the dequeue operation.
> > +			 */
> > +			smp_wmb();
> > +			curr->task = NULL;
> > +			if (++woken == num)
> > +				break;
> > +		}
> > +	}
> > +	return woken;
> > +}
> 
> Are these two barriers matched or are they both unmatched and thus
> probabyl wrong?

Nope, the two are unrelated. The the smp_wmb() is to synchronize with
the swait_finish() code. When the task wakes up, it checks if w->task
is NULL, and if it is it does not grab the head->lock and does not
dequeue it, it simply exits, where the caller can then free the swaiter
structure.

Without the smp_wmb(), the curr->task can be set to NULL before we
dequeue it, and if the woken up process sees that NULL, it can jump
right to freeing the swaiter structure and cause havoc with this
__swait_dequeue().


The first smp_mb() is about the condition in:

+#define __swait_event(wq, condition)					\
+do {									\
+	DEFINE_SWAITER(__wait);						\
+									\
+	for (;;) {							\
+		swait_prepare(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
+		if (condition)						\
+			break;						\
+		schedule();						\
+	}								\
+	swait_finish(&wq, &__wait);					\
+} while (0)

without the smp_mb(), it is possible that the condition can leak into
the critical section of swait_prepare() and have the old condition seen
before the task is added to the wait list. My submission of this patch
described it in more details:

https://lkml.org/lkml/2013/8/19/275

> 
> In any case the comments need updating to be more explicit.

Yeah, I can add documentation about this as well. The smp_wmb() I think
is probably documented enough, but the two smp_mb()s need a little more
explanation.

-- Steve
