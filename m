Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933692AbbA2CW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:22:26 -0500
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:39261 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757752AbbA2CWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:22:23 -0500
Message-ID: <1422479028.4111.34.camel@j-VirtualBox>
Subject: Re: [PATCH 4/6] locking/rwsem: Avoid deceiving lock spinners
From: Jason Low <jason.low2@hp.com>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Michel Lespinasse <walken@google.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org,
        jason.low2@hp.com
Date: Wed, 28 Jan 2015 13:03:48 -0800
In-Reply-To: <1422417294.4604.15.camel@stgolabs.net>
References: <1422257769-14083-1-git-send-email-dave@stgolabs.net>
	 <1422257769-14083-5-git-send-email-dave@stgolabs.net>
	 <1422379430.6710.6.camel@j-VirtualBox>
	 <1422417294.4604.15.camel@stgolabs.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-27 at 19:54 -0800, Davidlohr Bueso wrote:
> On Tue, 2015-01-27 at 09:23 -0800, Jason Low wrote:
> > On Sun, 2015-01-25 at 23:36 -0800, Davidlohr Bueso wrote:
> > > When readers hold the semaphore, the ->owner is nil. As such,
> > > and unlike mutexes, '!owner' does not necessarily imply that
> > > the lock is free. This will cause writer spinners to potentially
> > > spin excessively as they've been mislead to thinking they have
> > > a chance of acquiring the lock, instead of blocking.
> > > 
> > > This patch therefore replaces this bogus check to solely rely on
> > > the counter to know if the lock is available. Because we don't
> > > hold the wait lock, we can obviously do this in an unqueued
> > > manner.
> > > 
> > > Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
> > > ---
> > >  kernel/locking/rwsem-xadd.c | 8 ++++++--
> > >  1 file changed, 6 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
> > > index 5e425d8..18a50da 100644
> > > --- a/kernel/locking/rwsem-xadd.c
> > > +++ b/kernel/locking/rwsem-xadd.c
> > > @@ -335,6 +335,8 @@ static inline bool owner_running(struct rw_semaphore *sem,
> > >  static noinline
> > >  bool rwsem_spin_on_owner(struct rw_semaphore *sem, struct task_struct *owner)
> > >  {
> > > +	long count;
> > > +
> > >  	rcu_read_lock();
> > >  	while (owner_running(sem, owner)) {
> > >  		if (need_resched())
> > > @@ -347,9 +349,11 @@ bool rwsem_spin_on_owner(struct rw_semaphore *sem, struct task_struct *owner)
> > >  	/*
> > >  	 * We break out the loop above on need_resched() or when the
> > >  	 * owner changed, which is a sign for heavy contention. Return
> > > -	 * success only when sem->owner is NULL.
> > > +	 * success only when the lock is available in order to attempt
> > > +	 * another trylock.
> > >  	 */
> > > -	return sem->owner == NULL;
> > > +	count = READ_ONCE(sem->count);
> > > +	return count == 0 || count == RWSEM_WAITING_BIAS;
> > 
> > If we clear the owner field right before unlocking, would this cause
> > some situations where we spin until the owner is cleared (about to
> > release the lock), and then the spinner return false from
> > rwsem_spin_on_owner?
> 
> I'm not sure I understand your concern ;) could you rephrase that? 

Sure, let me try to elaborate on that  :)

Since the unlocker clears the owner field before actually unlocking, I'm
thinking that with this patch, the spinner in rwsem_spin_on_owner()
would often read the count before the unlocker sets count.

When the owner releases the lock, it sets the owner field to NULL. This
causes the spinner to break out of the loop as the owner changed. The
spinner would then proceed to read sem->count, but before the owner
modifies sem->count.

Thread 1(owner)		Thread 2 (spinning on owner)
---------------		----------------------------
up_write()
  rwsem_clear_owner()
			owner_running() // returns false
			count = READ_ONCE(sem->count)
  __up_write()
			return (count == 0 || count == RWSEM_WAITING_BIAS) // returns false
			// going to slowpath


