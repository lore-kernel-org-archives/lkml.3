Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbaAIQce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 11:32:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbaAIQc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 11:32:27 -0500
Date: Thu, 9 Jan 2014 17:31:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH] lockdep: Introduce wait-type checks
Message-ID: <20140109163120.GA8038@redhat.com>
References: <20140109111516.GE7572@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109111516.GE7572@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09, Peter Zijlstra wrote:
>
> +static int check_context(struct task_struct *curr, struct held_lock *next)
> +{
> +	short next_inner = hlock_class(next)->wait_type_inner;
> +	short next_outer = hlock_class(next)->wait_type_outer;
> +	short curr_inner = LD_WAIT_MAX;
> +	int depth;
> +
> +	if (!curr->lockdep_depth || !next_inner)
> +		return 0;
> +
> +	if (!next_outer)
> +		next_outer = next_inner;
> +
> +	for (depth = 0; depth < curr->lockdep_depth; depth++) {
> +		struct held_lock *prev = curr->held_locks + depth;
> +		short prev_inner = hlock_class(prev)->wait_type_inner;
> +
> +		if (prev_inner) {
> +			/*
> +			 * we can have a bigger inner than a previous one
> +			 * when outer is smaller than inner, as with RCU.
> +			 */
> +			curr_inner = min(curr_inner, prev_inner);
> +		}
> +	}
> +
> +	if (next_outer > curr_inner)
> +		return print_lock_invalid_wait_context(curr, next);
> +
> +	return 0;
> +}

This is really minor, but it seems you can simplify it a little bit.
We do not really need curr_inner, the main loop can do

	for (...) {
		...

		if (prev_inner && prev_inner < next_outer)
			return print_lock_invalid_wait_context(...);
	}

	return 0;


Off-topic question... I can't understand the "int check" argument of
lock_acquire(). First of all, __lock_acquire() does

	if (!prove_locking)
		check = 1;

Doesn't this mean lock_acquire_*() do not depend on CONFIG_PROVE_LOCKING?
IOW, can't we do

	--- x/include/linux/lockdep.h
	+++ x/include/linux/lockdep.h
	@@ -479,15 +479,9 @@ static inline void print_irqtrace_events
	  * on the per lock-class debug mode:
	  */
	 
	-#ifdef CONFIG_PROVE_LOCKING
	- #define lock_acquire_exclusive(l, s, t, n, i)		lock_acquire(l, s, t, 0, 2, n, i)
	- #define lock_acquire_shared(l, s, t, n, i)		lock_acquire(l, s, t, 1, 2, n, i)
	- #define lock_acquire_shared_recursive(l, s, t, n, i)	lock_acquire(l, s, t, 2, 2, n, i)
	-#else
	- #define lock_acquire_exclusive(l, s, t, n, i)		lock_acquire(l, s, t, 0, 1, n, i)
	- #define lock_acquire_shared(l, s, t, n, i)		lock_acquire(l, s, t, 1, 1, n, i)
	- #define lock_acquire_shared_recursive(l, s, t, n, i)	lock_acquire(l, s, t, 2, 1, n, i)
	-#endif
	+#define lock_acquire_exclusive(l, s, t, n, i)		lock_acquire(l, s, t, 0, 2, n, i)
	+#define lock_acquire_shared(l, s, t, n, i)		lock_acquire(l, s, t, 1, 2, n, i)
	+#define lock_acquire_shared_recursive(l, s, t, n, i)	lock_acquire(l, s, t, 2, 2, n, i)
	 
	 #define spin_acquire(l, s, t, i)		lock_acquire_exclusive(l, s, t, NULL, i)
	 #define spin_acquire_nest(l, s, t, n, i)	lock_acquire_exclusive(l, s, t, n, i)


But what I really can't understans is what "check == 0" means? It
seems that in fact it can be 1 or 2? Or, iow, "check == 0" is actually
equivalent to "check == 1" ?

Oleg.

