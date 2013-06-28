Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab3F1BcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 21:32:24 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:20942 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652Ab3F1BcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 21:32:22 -0400
Message-ID: <1372383138.2072.42.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] mutex: do not unnecessarily deal with waiters
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 27 Jun 2013 18:32:18 -0700
In-Reply-To: <20130627090016.GA4398@gmail.com>
References: <1369353543.1770.0.camel@buesod1.americas.hpqcorp.net>
	 <20130627090016.GA4398@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-27 at 11:00 +0200, Ingo Molnar wrote:
[...]
> 
> So I tried this out yesterday, but it interacted with the Wait/Wound 
> patches in tip:core/mutexes.
> 
> Maarten Lankhorst pointed out that if this patch is applied on top of the 
> WW patches as-is, then we get this semantic merge conflict:
> 
> > > @@ -340,6 +339,14 @@ slowpath:
> > >  #endif
> > >     spin_lock_mutex(&lock->wait_lock, flags);
> > >  
> > > +   /* once more, can we acquire the lock? */
> > > +   if (MUTEX_SHOW_NO_WAITER(lock) && (atomic_xchg(&lock->count, 0) == 1)) {
> > > +           lock_acquired(&lock->dep_map, ip);
> > > +           mutex_set_owner(lock);
> > > +           spin_unlock_mutex(&lock->wait_lock, flags);
> > > +           goto done;
> > > +   }
> > >
> > ^^^^^^^^^^^^^^
> >
> > This part skips the whole if (!__builtin_constant_p(ww_ctx == NULL)) { 
> > section with the wait_lock held.

I see what you mean, I hadn't really looked at the W/W patches. BTW
those __builtin_constant_p() calls are pretty ugly/annoying to read,
plus why the negation of the NULL check? Couldn't we just do something
like:

#define is_ww_ctx(x) (__builtin_constant_p(x))
...
if (is_ww_ctxt(ww_ctx)) { ... }


Anyway, so going back to the actual patch, we need a few cleanups in
__mutex_lock_common() before we can rebase this patch - otherwise we're
going to end up duplicating a lot of code (and the function is already
big enough):

How about a new ww_mutex_set_context_slowpath() function that does the
w/w lock acquiring and wakes up any sleeping processes. We'd use this
function whenever we acquire the lock in the slowpath (with the
->wait_lock taken):

static __always_inline void
ww_mutex_set_context_slowpath(struct mutex *lock,
			      struct ww_acquire_ctx *ww_ctx, bool debug)
{
	if (!__builtin_constant_p(ww_ctx == NULL)) {
		struct mutex_waiter *cur;
		struct ww_mutex *ww = container_of(lock, struct ww_mutex, base);

		/*
		 * This branch gets optimized out for the common case,
		 * and is only important for ww_mutex_lock.
		 */
		ww_mutex_lock_acquired(ww, ww_ctx);
		ww->ctx = ww_ctx;

		/*
		 * Give any possible sleeping processes the chance to wake up,
		 * so they can recheck if they have to back off.
		 */
		list_for_each_entry(cur, &lock->wait_list, list) {
			if (debug)
				debug_mutex_wake_waiter(lock, cur);
			wake_up_process(cur->task);
		}
	}
}

In ww_mutex_set_context_fastpath() I'm a little confused with the
debug_mutex_wake_waiter() calls since we don't deal with debug in the
fast path (->wait_lock isn't held). So are these calls
correct/necessary?

For ww_mutex_set_context_slowpath(), the 'debug' parameter would be
necessary since with this patch we avoid doing the debug_mutex on a
quick attempt to grab the lock, otherwise we do the slowpath debug,
waiters, etc. For instance:

...
slowpath:
#endif
	spin_lock_mutex(&lock->wait_lock, flags);
	/* once more, can we acquire the lock? */
	if (MUTEX_SHOW_NO_WAITER(lock) && (atomic_xchg(&lock->count, 0) == 1)) {
        	lock_acquired(&lock->dep_map, ip);
	        mutex_set_owner(lock);
		ww_mutex_set_context_fastpath(lock, ww_ctx, false);
        	spin_unlock_mutex(&lock->wait_lock, flags);
	        goto done;
  	}
...

lock_acquired(&lock->dep_map, ip);
/* got the lock - rejoice! */
mutex_remove_waiter(lock, &waiter, current_thread_info());
mutex_set_owner(lock);
ww_mutex_set_context_slowpath(lock, ww_ctx, true);
...


Thanks,
Davidlohr

