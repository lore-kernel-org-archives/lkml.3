Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415AbaD1TNg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:13:36 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:56900 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932305AbaD1TN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:13:29 -0400
Message-ID: <1398705482.25549.6.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] rwsem: Support optimistic spinning
From: Davidlohr Bueso <davidlohr@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, linux-kernel@vger.kernel.org
Date: Mon, 28 Apr 2014 10:18:02 -0700
In-Reply-To: <20140428075205.GN11096@twins.programming.kicks-ass.net>
References: <1398205166.6345.7.camel@buesod1.americas.hpqcorp.net>
	 <20140428075205.GN11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-28 at 09:52 +0200, Peter Zijlstra wrote:
> On Tue, Apr 22, 2014 at 03:19:26PM -0700, Davidlohr Bueso wrote:
> > ---
> >  include/linux/rwsem.h       |   9 +-
> >  kernel/locking/rwsem-xadd.c | 213 +++++++++++++++++++++++++++++++++++++++-----
> >  kernel/locking/rwsem.c      |  31 ++++++-
> >  3 files changed, 231 insertions(+), 22 deletions(-)
> 
> rwsem-spinlock.c doesn't need changes?

I had considered this, but the spinlock variant is, of course,
completely different to the xadd one (ie it doesn't even rely on the
->count). Furthermore, any systems that should benefit from optimistic
spinning, should already be using xadd. The same was true when the
writer lock stealing was done. Note that the rwsem structure in
rwsem-spinlock.h was not changed. I will explicitly mention the spinlock
method in the changelog in v2.

> > diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
> > index cfff143..a911dbf 100644
> > --- a/kernel/locking/rwsem.c
> > +++ b/kernel/locking/rwsem.c
> > @@ -12,6 +12,27 @@

err I also noticed that in:

@@ -58,7 +63,9 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
 #define __RWSEM_INITIALIZER(name)                      \
        { RWSEM_UNLOCKED_VALUE,                         \
          __RAW_SPIN_LOCK_UNLOCKED(name.wait_lock),     \
-         LIST_HEAD_INIT((name).wait_list)              \
+         LIST_HEAD_INIT((name).wait_list),             \
+         NULL, /* owner */                             \
+         NULL /* mcs lock */        

This needs to depend on CONFIG_SMP.

> >  #include <linux/atomic.h>
> >  
> > +#ifdef CONFIG_SMP
> > +static inline void rwsem_set_owner(struct rw_semaphore *sem)
> > +{
> > +	sem->owner = current;
> > +}
> > +
> > +static inline void rwsem_clear_owner(struct rw_semaphore *sem)
> > +{
> > +	sem->owner = NULL;
> > +}
> > +
> > +#else
> > +static inline void rwsem_set_owner(struct rw_semaphore *sem)
> > +{
> > +}
> > +
> > +static inline void rwsem_clear_owner(struct rw_semaphore *sem)
> > +{
> > +}
> > +#endif
> > +
> >  /*
> >   * lock for reading
> >   */
> > @@ -48,6 +69,7 @@ void __sched down_write(struct rw_semaphore *sem)
> >  	rwsem_acquire(&sem->dep_map, 0, 0, _RET_IP_);
> >  
> >  	LOCK_CONTENDED(sem, __down_write_trylock, __down_write);
> > +	rwsem_set_owner(sem);
> >  }
> >  
> >  EXPORT_SYMBOL(down_write);
> > @@ -59,8 +81,11 @@ int down_write_trylock(struct rw_semaphore *sem)
> >  {
> >  	int ret = __down_write_trylock(sem);
> >  
> > -	if (ret == 1)
> > +	if (ret == 1) {
> >  		rwsem_acquire(&sem->dep_map, 0, 1, _RET_IP_);
> > +		rwsem_set_owner(sem);
> > +	}
> > +
> >  	return ret;
> >  }
> 
> So first acquire lock, then set owner.
> 
> > @@ -86,6 +111,7 @@ void up_write(struct rw_semaphore *sem)
> >  	rwsem_release(&sem->dep_map, 1, _RET_IP_);
> >  
> >  	__up_write(sem);
> > +	rwsem_clear_owner(sem);
> >  }
> >  
> >  EXPORT_SYMBOL(up_write);
> > @@ -100,6 +126,7 @@ void downgrade_write(struct rw_semaphore *sem)
> >  	 * dependency.
> >  	 */
> >  	__downgrade_write(sem);
> > +	rwsem_clear_owner(sem);
> >  }
> 
> But here you first release and then clear owner; this is buggy. The
> moment you release another acquire can happen and your clear will clear
> the new owner, not us.

Ah yes. The same should go for up_write(). We need to follow this order:

take lock
set owner

clear owner
release lock

Will update in v2.

Thanks,
Davidlohr

