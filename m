Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbaAIRzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 12:55:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbaAIRzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 12:55:44 -0500
Date: Thu, 9 Jan 2014 18:54:48 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: check && lockdep_no_validate (Was: lockdep: Introduce wait-type
	checks)
Message-ID: <20140109175448.GA17673@redhat.com>
References: <20140109111516.GE7572@laptop.programming.kicks-ass.net> <20140109163120.GA8038@redhat.com> <20140109170823.GF7572@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109170823.GF7572@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I changed the subject to avoid the confusion.

On 01/09, Peter Zijlstra wrote:
>
> On Thu, Jan 09, 2014 at 05:31:20PM +0100, Oleg Nesterov wrote:
>
> > 	-#ifdef CONFIG_PROVE_LOCKING
> > 	- #define lock_acquire_exclusive(l, s, t, n, i)		lock_acquire(l, s, t, 0, 2, n, i)
> > 	- #define lock_acquire_shared(l, s, t, n, i)		lock_acquire(l, s, t, 1, 2, n, i)
> > 	- #define lock_acquire_shared_recursive(l, s, t, n, i)	lock_acquire(l, s, t, 2, 2, n, i)
> > 	-#else
> > 	- #define lock_acquire_exclusive(l, s, t, n, i)		lock_acquire(l, s, t, 0, 1, n, i)
> > 	- #define lock_acquire_shared(l, s, t, n, i)		lock_acquire(l, s, t, 1, 1, n, i)
> > 	- #define lock_acquire_shared_recursive(l, s, t, n, i)	lock_acquire(l, s, t, 2, 1, n, i)
> > 	-#endif
> > 	+#define lock_acquire_exclusive(l, s, t, n, i)		lock_acquire(l, s, t, 0, 2, n, i)
> > 	+#define lock_acquire_shared(l, s, t, n, i)		lock_acquire(l, s, t, 1, 2, n, i)
> > 	+#define lock_acquire_shared_recursive(l, s, t, n, i)	lock_acquire(l, s, t, 2, 2, n, i)
>
> I suppose we could; note however that the if (!prove_locking) logic was
> added later.

OK, thanks...

> > But what I really can't understans is what "check == 0" means? It
> > seems that in fact it can be 1 or 2? Or, iow, "check == 0" is actually
> > equivalent to "check == 1" ?
>
> Hmm indeed, the comment in lockdep.h says 0 means no checks at all, but
> the code doesn't actually appear to work like that. I'm not sure it ever
> did or not, I'd have to go dig through history.
>
> That said, given the current state it certainly looks like we can remove
> the check argument.

Or yes, we can probably simply remove it. Unlikely we will need
lock_acquire(check => 0).

But this connects to lockdep_no_validate. Not sure I understand what
this class should actually do, but consider this code:

	DEFINE_MUTEX(m1);
	DEFINE_MUTEX(m2);
	DEFINE_MUTEX(mx);

	void lockdep_should_complain(void)
	{
		lockdep_set_novalidate_class(&mx);

		// m1 -> mx -> m2
		mutex_lock(&m1);
		mutex_lock(&mx);
		mutex_lock(&m2);
		mutex_unlock(&m2);
		mutex_unlock(&mx);
		mutex_unlock(&m1);


		// m2 -> m1 ; should trigger the warning
		mutex_lock(&m2);
		mutex_lock(&m1);
		mutex_unlock(&m1);
		mutex_unlock(&m2);
	}

lockdep doesn't not detect the trivial possible deadlock.

The patch below seems to work but most probably it is not right, and
I forgot everything (not too much) I knew about lockdep internals.

Oleg.

--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -1939,7 +1939,8 @@ check_prevs_add(struct task_struct *curr, struct held_lock *next)
 		 * Only non-recursive-read entries get new dependencies
 		 * added:
 		 */
-		if (hlock->read != 2) {
+		if (hlock->read != 2 &&
+		    hlock->instance->key != &__lockdep_no_validate__) {
 			if (!check_prev_add(curr, hlock, next,
 						distance, trylock_loop))
 				return 0;

