Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbaFJIxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 04:53:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:50644 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaFJIxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 04:53:38 -0400
Date: Tue, 10 Jun 2014 10:53:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Subject: Re: safety of *mutex_unlock() (Was: [BUG] signal: sighand unprotected
 when accessed by /proc)
In-Reply-To: <20140609154114.20585056@gandalf.local.home>
Message-ID: <alpine.DEB.2.10.1406101051210.3830@nanos>
References: <20140603130233.658a6a3c@gandalf.local.home> <20140603172632.GA27956@redhat.com> <CA+55aFzT5CGv_T60voAqR+4PfiMmJmsDZLid2DZ4=+X8uvF+ig@mail.gmail.com> <20140603200125.GB1105@redhat.com> <20140606203350.GU4581@linux.vnet.ibm.com>
 <20140608130718.GA11129@redhat.com> <20140609162613.GE4581@linux.vnet.ibm.com> <20140609181553.GA13681@redhat.com> <20140609142956.3d79e9d1@gandalf.local.home> <CA+55aFyO8bb7fS3AaQzfMq7geERQ1JpSdcRZ9Fbs5-tZP0oRXg@mail.gmail.com>
 <20140609154114.20585056@gandalf.local.home>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2014, Steven Rostedt wrote:
> On Mon, 9 Jun 2014 11:51:09 -0700
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> Because spinlocks are atomic, this is all fine, but if you have a
> mutex, then this is where you can have issues. I think rtmutex has an
> issue with it too. Specifically in the slow_unlock case:
> 
> 	if (!rt_mutex_has_waiters(lock)) {
> 		lock->owner = NULL;
> 		raw_spin_unlock(&lock->wait_lock);
> 		return;
> 	}

Indeed. If the fast path is enabled we have that issue. Fortunately
there is a halfways reasonable solution for this.

Thanks,

	tglx
--------------------------->
Subject: rtmutex: Plug slow unlock race
From: Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 10 Jun 2014 09:27:00 +0200

When the rtmutex fast path is enabled the slow unlock function can
create the following situation:

spin_lock(foo->m->wait_lock);
foo->m->owner = NULL;
	    			rt_mutex_lock(foo->m); <-- fast path
				free = atomic_dec_and_test(foo->refcnt);
				rt_mutex_unlock(foo->m); <-- fast path
				if (free)
				   kfree(foo);

spin_unlock(foo->m->wait_lock); <--- Use after free.

Plug the race by changing the slow unlock to the following scheme:

     while (!rt_mutex_has_waiters(m)) {
     	    /* Clear the waiters bit in m->owner */
	    clear_rt_mutex_waiters(m);
      	    owner = rt_mutex_owner(m);
      	    spin_unlock(m->wait_lock);
      	    if (cmpxchg(m->owner, owner, 0) == owner)
      	       return;
      	    spin_lock(m->wait_lock);
     }

So in case of a new waiter incoming while the owner tries the slow
path unlock we have two situations:

 unlock(wait_lock);
					lock(wait_lock);
 cmpxchg(p, owner, 0) == owner
 	    	   			mark_rt_mutex_waiters(lock);
	 				acquire(lock);

Or:

 unlock(wait_lock);
					lock(wait_lock);
	 				mark_rt_mutex_waiters(lock);
 cmpxchg(p, owner, 0) != owner
					enqueue_waiter();
					unlock(wait_lock);
 lock(wait_lock);
 wake waiter();
 unlock(wait_lock);
					lock(wait_lock);
					acquire(lock);

If the fast path is disabled, then the simple

   m->owner = NULL;
   unlock(m->wait_lock);

is sufficient as all access to m->owner is serialized via
m->wait_lock;


Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/locking/rtmutex.c |   94 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 90 insertions(+), 4 deletions(-)

Index: tip/kernel/locking/rtmutex.c
===================================================================
--- tip.orig/kernel/locking/rtmutex.c
+++ tip/kernel/locking/rtmutex.c
@@ -83,6 +83,48 @@ static inline void mark_rt_mutex_waiters
 		owner = *p;
 	} while (cmpxchg(p, owner, owner | RT_MUTEX_HAS_WAITERS) != owner);
 }
+
+/*
+ * Safe fastpath aware unlock:
+ * 1) Clear the waiters bit
+ * 2) Drop lock->wait_lock
+ * 3) Try to unlock the lock with cmpxchg
+ */
+static inline bool unlock_rt_mutex_safe(struct rt_mutex *lock)
+	__releases(lock->wait_lock)
+{
+	unsigned long owner, *p = (unsigned long *) &lock->owner;
+
+	owner = (unsigned long) rt_mutex_owner(lock);
+	clear_rt_mutex_waiters(lock);
+	raw_spin_unlock(&lock->wait_lock);
+	/*
+	 * If a new waiter comes in between the unlock and the cmpxchg
+	 * we have two situations:
+	 *
+	 * unlock(wait_lock);
+	 *					lock(wait_lock);
+	 * cmpxchg(p, owner, 0) == owner
+	 *					mark_rt_mutex_waiters(lock);
+	 *					acquire(lock);
+	 * or:
+	 *
+	 * unlock(wait_lock);
+	 *					lock(wait_lock);
+	 *					mark_rt_mutex_waiters(lock);
+	 *
+	 * cmpxchg(p, owner, 0) != owner
+	 *					enqueue_waiter();
+	 *					unlock(wait_lock);
+	 * lock(wait_lock);
+	 * wake waiter();
+	 * unlock(wait_lock);
+	 *					lock(wait_lock);
+	 *					acquire(lock);
+	 */
+	return rt_mutex_cmpxchg(p, owner, 0);
+}
+
 #else
 # define rt_mutex_cmpxchg(l,c,n)	(0)
 static inline void mark_rt_mutex_waiters(struct rt_mutex *lock)
@@ -90,6 +132,17 @@ static inline void mark_rt_mutex_waiters
 	lock->owner = (struct task_struct *)
 			((unsigned long)lock->owner | RT_MUTEX_HAS_WAITERS);
 }
+
+/*
+ * Simple slow path only version: owner is protected by wait_lock
+ */
+static inline bool unlock_rt_mutex_safe(struct rt_mutex *lock)
+	__releases(lock->wait_lock)
+{
+	lock->owner = NULL;
+	raw_spin_unlock(&lock->wait_lock);
+	return true;
+}
 #endif
 
 static inline int
@@ -928,10 +981,43 @@ rt_mutex_slowunlock(struct rt_mutex *loc
 
 	rt_mutex_deadlock_account_unlock(current);
 
-	if (!rt_mutex_has_waiters(lock)) {
-		lock->owner = NULL;
-		raw_spin_unlock(&lock->wait_lock);
-		return;
+	/*
+	 * We must be careful here if the fast path is enabled. If we
+	 * have no waiters queued we cannot set owner to NULL here
+	 * because of:
+	 *
+	 * foo->lock->owner = NULL;
+	 *			rtmutex_lock(foo->lock);   <- fast path
+	 *			free = atomic_dec_and_test(foo->refcnt);
+	 *			rtmutex_unlock(foo->lock); <- fast path
+	 *			if (free)
+	 *				kfree(foo);
+	 * raw_spin_unlock(foo->lock->wait_lock);
+	 *
+	 * So for the fastpath enabled kernel:
+	 *
+	 * Nothing can set the waiters bit as long as we hold
+	 * lock->wait_lock. So we do the following sequence:
+	 *
+	 *	owner = rt_mutex_owner(lock);
+	 *	clear_rt_mutex_waiters(lock);
+	 *	raw_spin_unlock(&lock->wait_lock);
+	 *	if (cmpxchg(&lock->owner, owner, 0) == owner)
+	 *		return;
+	 *	goto retry;
+	 *
+	 * The fastpath disabled variant is simple as all access to
+	 * lock->owner is serialized by lock->wait_lock:
+	 *
+	 *	lock->owner = NULL;
+	 *	raw_spin_unlock(&lock->wait_lock);
+	 */
+	while (!rt_mutex_has_waiters(lock)) {
+		/* Drops lock->wait_lock ! */
+		if (unlock_rt_mutex_safe(lock) == true)
+			return;
+		/* Relock the rtmutex and try again */
+		raw_spin_lock(&lock->wait_lock);
 	}
 
 	wakeup_next_waiter(lock);
