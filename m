Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbaAIRIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 12:08:54 -0500
Received: from merlin.infradead.org ([205.233.59.134]:39271 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857AbaAIRIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 12:08:47 -0500
Date: Thu, 9 Jan 2014 18:08:23 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH] lockdep: Introduce wait-type checks
Message-ID: <20140109170823.GF7572@laptop.programming.kicks-ass.net>
References: <20140109111516.GE7572@laptop.programming.kicks-ass.net>
 <20140109163120.GA8038@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109163120.GA8038@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 05:31:20PM +0100, Oleg Nesterov wrote:
> This is really minor, but it seems you can simplify it a little bit.
> We do not really need curr_inner, the main loop can do
> 
> 	for (...) {
> 		...
> 
> 		if (prev_inner && prev_inner < next_outer)
> 			return print_lock_invalid_wait_context(...);
> 	}
> 
> 	return 0;

Indeed, that might work.. My brain still finds it easier to understand
the min() version though.

> Off-topic question... I can't understand the "int check" argument of
> lock_acquire(). First of all, __lock_acquire() does
> 
> 	if (!prove_locking)
> 		check = 1;
> 
> Doesn't this mean lock_acquire_*() do not depend on CONFIG_PROVE_LOCKING?
> IOW, can't we do
> 
> 	--- x/include/linux/lockdep.h
> 	+++ x/include/linux/lockdep.h
> 	@@ -479,15 +479,9 @@ static inline void print_irqtrace_events
> 	  * on the per lock-class debug mode:
> 	  */
> 	 
> 	-#ifdef CONFIG_PROVE_LOCKING
> 	- #define lock_acquire_exclusive(l, s, t, n, i)		lock_acquire(l, s, t, 0, 2, n, i)
> 	- #define lock_acquire_shared(l, s, t, n, i)		lock_acquire(l, s, t, 1, 2, n, i)
> 	- #define lock_acquire_shared_recursive(l, s, t, n, i)	lock_acquire(l, s, t, 2, 2, n, i)
> 	-#else
> 	- #define lock_acquire_exclusive(l, s, t, n, i)		lock_acquire(l, s, t, 0, 1, n, i)
> 	- #define lock_acquire_shared(l, s, t, n, i)		lock_acquire(l, s, t, 1, 1, n, i)
> 	- #define lock_acquire_shared_recursive(l, s, t, n, i)	lock_acquire(l, s, t, 2, 1, n, i)
> 	-#endif
> 	+#define lock_acquire_exclusive(l, s, t, n, i)		lock_acquire(l, s, t, 0, 2, n, i)
> 	+#define lock_acquire_shared(l, s, t, n, i)		lock_acquire(l, s, t, 1, 2, n, i)
> 	+#define lock_acquire_shared_recursive(l, s, t, n, i)	lock_acquire(l, s, t, 2, 2, n, i)

I suppose we could; note however that the if (!prove_locking) logic was
added later.

> But what I really can't understans is what "check == 0" means? It
> seems that in fact it can be 1 or 2? Or, iow, "check == 0" is actually
> equivalent to "check == 1" ?

Hmm indeed, the comment in lockdep.h says 0 means no checks at all, but
the code doesn't actually appear to work like that. I'm not sure it ever
did or not, I'd have to go dig through history.

That said, given the current state it certainly looks like we can remove
the check argument.

Ingo?
