Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab3I3SJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 14:09:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48194 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108Ab3I3SJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 14:09:50 -0400
Date: Mon, 30 Sep 2013 20:09:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] sched, wait: Collapse __wait_event macros -v4
Message-ID: <20130930180939.GN15690@laptop.programming.kicks-ass.net>
References: <20130930152242.207382649@infradead.org>
 <20130930174054.GA28129@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130930174054.GA28129@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 07:40:54PM +0200, Oleg Nesterov wrote:
> Once again, of course I do not blame this series, but
> wait_event_timeout(wq, true, 0) still returns 0.


So we have:


#define ___wait_cond_timeout(condition)					\
({									\
 	bool __cond = (condition);					\
 	if (__cond && !__ret)						\
 		__ret = 1;						\
 	__cond || !__ret;						\
})

#define ___wait_event(wq, condition, state, exclusive, ret, cmd)	\
({									\
	__label__ __out;						\
	DEFINE_WAIT(__wait);						\
	long __ret = ret;						\
									\
	for (;;) {							\
		if (exclusive)						\
			prepare_to_wait_exclusive(&wq, &__wait, state); \
		else							\
			prepare_to_wait(&wq, &__wait, state);		\
									\
		if (condition)						\
			break;						\
									\
		if (___wait_signal_pending(state)) {			\
			__ret = -ERESTARTSYS;				\
			if (exclusive) {				\
				abort_exclusive_wait(&wq, &__wait, 	\
						     state, NULL); 	\
				goto __out;				\
			}						\
			break;						\
		}							\
									\
		cmd;							\
	}								\
	finish_wait(&wq, &__wait);					\
__out:	__ret;								\
})

So wait_event_timeout(wq, true, 0) turns into:

({
	DEFINE_WAIT(__wait);
	long __ret = 0;

	for (;;) {
		prepare_to_wait(&wq, &__wait, TASK_UNINTERRUPTIBLE);

		if (({
			bool __cond = (true);
			if (__cond && !__ret)
				__ret = 1;
			__cond || !__ret;
		     }))
			break;

		schedule();
	}
	finish_wait(&wq, &__wait);
	__ret;
})

Which; afaict, returns 1, not 0.

> +#define ___wait_schedule_timeout(tout)					\
> +	if (!tout)							\
> +		break;							\
> +	tout = schedule_timeout(tout)
> +

>  	___wait_event(wq, ___wait_cond_timeout(condition),		\
>  		      TASK_INTERRUPTIBLE, 0, ret,	      		\
>  		      spin_unlock_irq(&lock);				\
> -		      __ret = schedule_timeout(__ret);			\
> +		      ___wait_schedule_timeout(__ret);			\
>  		      spin_lock_irq(&lock));

You can't do that; you'll break/return without the lock held.
