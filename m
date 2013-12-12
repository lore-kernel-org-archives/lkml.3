Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806Ab3LLQDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 11:03:47 -0500
Received: from merlin.infradead.org ([205.233.59.134]:39508 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab3LLQDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 11:03:44 -0500
Date: Thu, 12 Dec 2013 17:03:23 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] wait-simple: Introduce the simple waitqueue
 implementation
Message-ID: <20131212160323.GJ21999@twins.programming.kicks-ass.net>
References: <1386810399-8973-1-git-send-email-paul.gortmaker@windriver.com>
 <1386810399-8973-2-git-send-email-paul.gortmaker@windriver.com>
 <20131212114447.GH21999@twins.programming.kicks-ass.net>
 <20131212094227.0a227f6f@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131212094227.0a227f6f@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 09:42:27AM -0500, Steven Rostedt wrote:
> On Thu, 12 Dec 2013 12:44:47 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
> > Are these two barriers matched or are they both unmatched and thus
> > probabyl wrong?
> 
> Nope, the two are unrelated. The the smp_wmb() is to synchronize with
> the swait_finish() code. When the task wakes up, it checks if w->task
> is NULL, and if it is it does not grab the head->lock and does not
> dequeue it, it simply exits, where the caller can then free the swaiter
> structure.
> 
> Without the smp_wmb(), the curr->task can be set to NULL before we
> dequeue it, and if the woken up process sees that NULL, it can jump
> right to freeing the swaiter structure and cause havoc with this
> __swait_dequeue().

And yet the swait_finish thing does not have a barrier. Unmatched
barriers are highly suspect.

> The first smp_mb() is about the condition in:
> 
> +#define __swait_event(wq, condition)					\
> +do {									\
> +	DEFINE_SWAITER(__wait);						\
> +									\
> +	for (;;) {							\
> +		swait_prepare(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
> +		if (condition)						\
> +			break;						\
> +		schedule();						\
> +	}								\
> +	swait_finish(&wq, &__wait);					\
> +} while (0)
> 
> without the smp_mb(), it is possible that the condition can leak into
> the critical section of swait_prepare() and have the old condition seen
> before the task is added to the wait list. My submission of this patch
> described it in more details:
> 
> https://lkml.org/lkml/2013/8/19/275

still a fail, barriers should not be described in changelogs but in
comments.

Typically such a barrier comes from set_current_state(), the normal
pattern is something like:

  set_current_state(TASK_UNINTERRUPTIBLE)
  if (!cond)
  	schedule();
  __set_current_state(TASK_RUNNING);

vs

  cond = true;
  wake_up_process(&foo);

Where set_current_state() implies the mb that separates the task-state
write from the condition read, and wake_up_process() implies enough
barrier to separate the condition write from its task state read.

And this is an explicit pairing.

The only reason you even need an explicit barrier is because you're not
using set_current_state(), which is your entire problem.

> > In any case the comments need updating to be more explicit.
> 
> Yeah, I can add documentation about this as well. The smp_wmb() I think
> is probably documented enough, but the two smp_mb()s need a little more
> explanation.

No, the wmb needs to be far more explicit on why its ok (if it is indeed
ok) to not be balanced.
