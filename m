Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab3LCIwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 03:52:42 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:40277 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab3LCIwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 03:52:38 -0500
Date: Tue, 3 Dec 2013 09:52:33 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Simon Kirby <sim@hostway.ca>, Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <Waiman.Long@hp.com>, Ian Applegate <ia@cloudflare.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Christoph Lameter <cl@gentwo.org>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] mutexes: Add CONFIG_DEBUG_MUTEX_FASTPATH=y debug variant to
 debug SMP races
Message-ID: <20131203085233.GA20179@gmail.com>
References: <CA+55aFyez7uZ6LeXrBRCqJzgJ=w4Xv+CV6QSYp5NkOJ2R9Xang@mail.gmail.com>
 <CA+55aFyhzvJrCiJOqUgL-98=MVutWePToQXaVfS2j6e5eetJSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyhzvJrCiJOqUgL-98=MVutWePToQXaVfS2j6e5eetJSw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

>  - but in the meantime, CPU1 is busy still unlocking:
> 
>                 if (!list_empty(&lock->wait_list)) {
>                         /* get the first entry from the wait-list: */
>                         struct mutex_waiter *waiter =
>                                         list_entry(lock->wait_list.next,
>                                                    struct mutex_waiter, list);
> 
>                         debug_mutex_wake_waiter(lock, waiter);
> 
>                         wake_up_process(waiter->task);
>         }
>         spin_unlock_mutex(&lock->wait_lock, flags);
> 
> and in particular notice how CPU1 wrote to the lock *after* CPU2 had 
> gotten the lock and free'd the data structure. In practice, it's 
> only really that "spin_unlock_mutex(&lock->wait_lock, flags);" that 
> happens (and this is how we got the single byte being incremented).
> 
> In other words, it's unsafe to protect reference counts inside 
> objects with anything but spinlocks and/or atomic refcounts. Or you 
> have to have the lock *outside* the object you're protecting (which 
> is often what you want for other reasons anyway, notably lookup).

Indeed: this comes from mutex->count being separate from 
mutex->wait_lock, and this should affect every architecture that has a 
mutex->count fast-path implemented (essentially every architecture 
that matters).

Such bugs should also magically go away with mutex debugging enabled.

I'd expect such bugs to be more prominent with unlucky object 
size/alignment: if mutex->count lies on a separate cache line from 
mutex->wait_lock.

Side note: this might be a valid light weight debugging technique, we 
could add padding between the two fields to force them into separate 
cache lines, without slowing it down.

Simon, would you be willing to try the fairly trivial patch below? 
Please enable CONFIG_DEBUG_MUTEX_FASTPATH=y. Does your kernel fail 
faster that way?

> So having a non-atomic refcount protected inside a sleeping lock is 
> a bug, and that's really the bug that ended up biting us for pipes.
> 
> Now, the question is: do we have other such cases? How do we 
> document this? [...]

I'd not be surprised if we had such cases, especially where 
spinlock->mutex conversions were done. About 20% of the kernel's 
critical sections use mutexes, 60% use spinlocks. (the remaining 20% 
is shared between semaphored, rwlocks and rwsems, in that order of 
frequency.)

> [...] Do we try to make mutexes and other locks safe to use for 
> things like this?

I think we try that, to make mutexes safer in general.

Can you see a way to do that fairly cheaply?

I can see two approaches, both rather radical:

1)

Eliminate mutex->count and (ab-)use mutex->wait_lock as 'the' mutex 
lock: with TICKET_SLOWPATH_FLAG used to denote waiters or so and care 
taken to not use it as a 'real' spinlock but use the raw accessors.

This would still allow a good mutex_lock() fastpath, as it would 
essentially become spin_trylock() with an asm goto slow path helper 
perhaps.

Doing this would have various advantages:

 - we'd eliminate much (all?) of per arch mutex code
 - we'd share spinlock and mutex low level implementations
 - we'd reduce struct mutex size by 4 bytes

It's still early in the morning so I might be missing something 
trivial though - this sounds suspiciously too easy ;-) Having a proper 
mutex slowpath might not be so easy without changing the spinlock 
code.

2)

Another method would be to do the opposite: eliminate mutex->wait_lock 
[for the non-debug case] and do everything via mutex->count and 
mutex->owner.

This saves even more space and potentially enables a tighter slowpath.

It probably won't hurt the massively parallel case, as we already do 
smart MCS locking via mutex->spin_mlock.

So I'd argue for #2. (Assuming it addresses the problem)

Thanks,

	Ingo

=======================>
Subject: mutexes: Add CONFIG_DEBUG_MUTEX_FASTPATH=y debug variant to debug SMP races
From: Ingo Molnar <mingo@kernel.org>

Help debug SMP ordering issues by forcing mutex->count on a separate 
cache line with mutex->wait_lock. This will make certain classes races 
more prominent, without slowing down other parts of the mutex code.

Signed-off-by: Ingo Molnar <mingo@kernel.org>

diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index d318193..6952fc4 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -49,6 +49,15 @@
 struct mutex {
 	/* 1: unlocked, 0: locked, negative: locked, possible waiters */
 	atomic_t		count;
+#ifdef CONFIG_DEBUG_MUTEX_FASTPATH
+	/*
+	 * Debug SMP ordering issues by forcing mutex->count on a separate
+	 * cache line with mutex->wait_lock. This will make certain classes
+	 * of races more prominent, without slowing down other parts of the
+	 * mutex code.
+	 */
+	u8			__cache_padding[64];
+#endif
 	spinlock_t		wait_lock;
 	struct list_head	wait_list;
 #if defined(CONFIG_DEBUG_MUTEXES) || defined(CONFIG_SMP)
@@ -58,7 +67,7 @@ struct mutex {
 	void			*spin_mlock;	/* Spinner MCS lock */
 #endif
 #ifdef CONFIG_DEBUG_MUTEXES
-	const char 		*name;
+	const char		*name;
 	void			*magic;
 #endif
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 6982094..08618a9 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -845,6 +845,18 @@ config DEBUG_SPINLOCK
 	  best used in conjunction with the NMI watchdog so that spinlock
 	  deadlocks are also debuggable.
 
+config DEBUG_MUTEX_FASTPATH
+	bool "Mutex debugging: lightweight mutex race check"
+	depends on DEBUG_KERNEL && !DEBUG_MUTEXES
+	help
+	  This debug feature simply increases struct mutex by 64 bytes and
+	  thus allows certain mutex related SMP races to be detected more
+	  easily.
+
+	  (This feature is disabled if DEBUG_MUTEXES is enabled.)
+
+	  If unsure, say N.
+
 config DEBUG_MUTEXES
 	bool "Mutex debugging: basic checks"
 	depends on DEBUG_KERNEL
