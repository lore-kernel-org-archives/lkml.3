Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704Ab3LLQvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 11:51:42 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:42968 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751497Ab3LLQvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 11:51:39 -0500
Date: Thu, 12 Dec 2013 11:51:37 -0500
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
Message-ID: <20131212115137.4e5d156f@gandalf.local.home>
In-Reply-To: <20131212160323.GJ21999@twins.programming.kicks-ass.net>
References: <1386810399-8973-1-git-send-email-paul.gortmaker@windriver.com>
	<1386810399-8973-2-git-send-email-paul.gortmaker@windriver.com>
	<20131212114447.GH21999@twins.programming.kicks-ass.net>
	<20131212094227.0a227f6f@gandalf.local.home>
	<20131212160323.GJ21999@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Dec 2013 17:03:23 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, Dec 12, 2013 at 09:42:27AM -0500, Steven Rostedt wrote:
> > On Thu, 12 Dec 2013 12:44:47 +0100
> > Peter Zijlstra <peterz@infradead.org> wrote:
> > > Are these two barriers matched or are they both unmatched and thus
> > > probabyl wrong?
> > 
> > Nope, the two are unrelated. The the smp_wmb() is to synchronize with
> > the swait_finish() code. When the task wakes up, it checks if w->task
> > is NULL, and if it is it does not grab the head->lock and does not
> > dequeue it, it simply exits, where the caller can then free the swaiter
> > structure.
> > 
> > Without the smp_wmb(), the curr->task can be set to NULL before we
> > dequeue it, and if the woken up process sees that NULL, it can jump
> > right to freeing the swaiter structure and cause havoc with this
> > __swait_dequeue().
> 
> And yet the swait_finish thing does not have a barrier. Unmatched
> barriers are highly suspect.

Well if it sees the task as NULL then it has nothing to do. The
smp_wmb() on the other end guarantees that. If it sees it not NULL it
then goes into the slow path and the spinlocks synchronize everything
else. That is, we don't care if it sees it as not NULL when it was NULL,
because then the slow path just does duplicate work (under a lock)
(removes itself from the queue with list_del_init() which is fine to
call twice).

Add a comment there discussing this won't hurt.

> 
> > The first smp_mb() is about the condition in:
> > 
> > +#define __swait_event(wq, condition)					\
> > +do {									\
> > +	DEFINE_SWAITER(__wait);						\
> > +									\
> > +	for (;;) {							\
> > +		swait_prepare(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
> > +		if (condition)						\
> > +			break;						\
> > +		schedule();						\
> > +	}								\
> > +	swait_finish(&wq, &__wait);					\
> > +} while (0)
> > 
> > without the smp_mb(), it is possible that the condition can leak into
> > the critical section of swait_prepare() and have the old condition seen
> > before the task is added to the wait list. My submission of this patch
> > described it in more details:
> > 
> > https://lkml.org/lkml/2013/8/19/275
> 
> still a fail, barriers should not be described in changelogs but in
> comments.

I agree.

> 
> Typically such a barrier comes from set_current_state(), the normal
> pattern is something like:
> 
>   set_current_state(TASK_UNINTERRUPTIBLE)
>   if (!cond)
>   	schedule();
>   __set_current_state(TASK_RUNNING);
> 
> vs
> 
>   cond = true;
>   wake_up_process(&foo);

Hmm, that __set_current_state() in swait_prepare() does indeed seem
buggy. I'm surprised that I didn't catch that, as I'm usually a
stickler with set_current_state() (and I'm very paranoid when it comes
to using __set_current_state()).

I'll have to dig deeper to see why I didn't change that.

Thanks,

-- Steve

