Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbaAPRoC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 12:44:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbaAPRoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 12:44:00 -0500
Date: Thu, 16 Jan 2014 18:43:48 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: check && lockdep_no_validate (Was: lockdep: Introduce
	wait-type checks)
Message-ID: <20140116174348.GA17614@redhat.com>
References: <20140109111516.GE7572@laptop.programming.kicks-ass.net> <20140109163120.GA8038@redhat.com> <20140109170823.GF7572@laptop.programming.kicks-ass.net> <20140109175448.GA17673@redhat.com> <20140112205814.GP7572@laptop.programming.kicks-ass.net> <20140113160705.GA7616@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140113160705.GA7616@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13, Oleg Nesterov wrote:
>
> On 01/12, Peter Zijlstra wrote:
> >
> > On Thu, Jan 09, 2014 at 06:54:48PM +0100, Oleg Nesterov wrote:
> > >
> > > --- a/kernel/locking/lockdep.c
> > > +++ b/kernel/locking/lockdep.c
> > > @@ -1939,7 +1939,8 @@ check_prevs_add(struct task_struct *curr, struct held_lock *next)
> > >  		 * Only non-recursive-read entries get new dependencies
> > >  		 * added:
> > >  		 */
> > > -		if (hlock->read != 2) {
> > > +		if (hlock->read != 2 &&
> > > +		    hlock->instance->key != &__lockdep_no_validate__) {
> > >  			if (!check_prev_add(curr, hlock, next,
> > >  						distance, trylock_loop))
> > >  				return 0;
> > >
> >
> > Hmm, you are quite right indeed;
>
> Thanks!
>
> > although I would write it like:
> >
> >   if (hlock->read != 2 && hlock->check == 2)
> >
> > because the __lockdep_no_validate__ thing forces the ->check value to 1.
>
> Agreed, hlock->check == 2 looks better. But this connects to another
> patch I sent which removes hlock->check...
>
> OK, I'll wait for review on that patch, then resend this one with
> ->check or __lockdep_no_validate__ depending on the result.

And I still think that we should try to remove hlock->check, but
please forget about this for the moment. I'll try to send some
patches later in any case.


OK, lets suppose we do the change above using ->key or ->check,
doesn't matter. This will fix the already discussed pattern:

		static DEFINE_MUTEX(m1);
		static DEFINE_MUTEX(m2);
		static DEFINE_MUTEX(mx);

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

before this change lockdep can't detect the trivial deadlock.

But with or without this change the following code

		static DEFINE_MUTEX(m1);
		static DEFINE_MUTEX(mx);

		lockdep_set_novalidate_class(&mx);

		// m1 -> mx
		mutex_lock(&m1);
		mutex_lock(&mx);
		mutex_unlock(&mx);
		mutex_unlock(&m1);

		// mx -> m1 ; should trigger the warning ???
		mutex_lock(&mx);
		mutex_lock(&m1);
		mutex_unlock(&m1);
		mutex_unlock(&mx);

doesn't trigger the warning too. This is correct because
lockdep_set_novalidate_class() means, well, no-validate.
The question is: do we really want to avoid all validations?

Why lockdep_set_novalidate_class() was added? Unlees I missed
something the problem is that (say) __driver_attach() can take
the "same" lock twice, drivers/base/ lacks annotations.

Perhaps we should change the meaning of lockdep_set_novalidate_class?
(perhaps with rename). What do you think about the patch below?

With this patch __lockdep_no_validate__ means "automatically nested",
although I have to remind I can hardly understand the code I am
trying to change ;)

Oleg.

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 576ba75..844d25d 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -2515,9 +2515,6 @@ mark_held_locks(struct task_struct *curr, enum mark_type mark)
 
 		BUG_ON(usage_bit >= LOCK_USAGE_STATES);
 
-		if (hlock_class(hlock)->key == __lockdep_no_validate__.subkeys)
-			continue;
-
 		if (!mark_lock(curr, hlock, usage_bit))
 			return 0;
 	}
@@ -3067,8 +3064,15 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
 		return 0;
 
-	if (lock->key == &__lockdep_no_validate__)
-		check = 1;
+	if (lock->key == &__lockdep_no_validate__) {
+		int i;
+
+		for (i = curr->lockdep_depth; --i >= 0; ) {
+			hlock = curr->held_locks + i;
+			if (hlock->instance->key == lock->key)
+				goto nested;
+		}
+	}
 
 	if (subclass < NR_LOCKDEP_CACHING_CLASSES)
 		class = lock->class_cache[subclass];
@@ -3106,6 +3110,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	if (depth) {
 		hlock = curr->held_locks + depth - 1;
 		if (hlock->class_idx == class_idx && nest_lock) {
+nested:
 			if (hlock->references)
 				hlock->references++;
 			else
@@ -3282,8 +3287,9 @@ static int match_held_lock(struct held_lock *hlock, struct lockdep_map *lock)
 		 * References, but not a lock we're actually ref-counting?
 		 * State got messed up, follow the sites that change ->references
 		 * and try to make sense of it.
+		 * FIXME: s/0/novalidate/ ?
 		 */
-		if (DEBUG_LOCKS_WARN_ON(!hlock->nest_lock))
+		if (DEBUG_LOCKS_WARN_ON(0 && !hlock->nest_lock))
 			return 0;
 
 		if (hlock->class_idx == class - lock_classes + 1)

