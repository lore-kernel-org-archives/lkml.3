Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbbA2BKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:10:47 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:49064 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbbA2BKZ (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Wed, 28 Jan 2015 20:10:25 -0500
Message-ID: <1422493812.4604.29.camel@stgolabs.net>
Subject: Re: [PATCH 4/6] locking/rwsem: Avoid deceiving lock spinners
From: Davidlohr Bueso <dave@stgolabs.net>
To: Jason Low <jason.low2@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Michel Lespinasse <walken@google.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org
Date: Wed, 28 Jan 2015 17:10:12 -0800
In-Reply-To: <1422479028.4111.34.camel@j-VirtualBox>
References: <1422257769-14083-1-git-send-email-dave@stgolabs.net>
	 <1422257769-14083-5-git-send-email-dave@stgolabs.net>
	 <1422379430.6710.6.camel@j-VirtualBox>
	 <1422417294.4604.15.camel@stgolabs.net>
	 <1422479028.4111.34.camel@j-VirtualBox>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-28 at 13:03 -0800, Jason Low wrote:
> On Tue, 2015-01-27 at 19:54 -0800, Davidlohr Bueso wrote:
> > On Tue, 2015-01-27 at 09:23 -0800, Jason Low wrote:
> > > On Sun, 2015-01-25 at 23:36 -0800, Davidlohr Bueso wrote:
> > > > When readers hold the semaphore, the ->owner is nil. As such,
> > > > and unlike mutexes, '!owner' does not necessarily imply that
> > > > the lock is free. This will cause writer spinners to potentially
> > > > spin excessively as they've been mislead to thinking they have
> > > > a chance of acquiring the lock, instead of blocking.
> > > > 
> > > > This patch therefore replaces this bogus check to solely rely on
> > > > the counter to know if the lock is available. Because we don't
> > > > hold the wait lock, we can obviously do this in an unqueued
> > > > manner.
> > > > 
> > > > Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
> > > > ---
> > > >  kernel/locking/rwsem-xadd.c | 8 ++++++--
> > > >  1 file changed, 6 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
> > > > index 5e425d8..18a50da 100644
> > > > --- a/kernel/locking/rwsem-xadd.c
> > > > +++ b/kernel/locking/rwsem-xadd.c
> > > > @@ -335,6 +335,8 @@ static inline bool owner_running(struct rw_semaphore *sem,
> > > >  static noinline
> > > >  bool rwsem_spin_on_owner(struct rw_semaphore *sem, struct task_struct *owner)
> > > >  {
> > > > +	long count;
> > > > +
> > > >  	rcu_read_lock();
> > > >  	while (owner_running(sem, owner)) {
> > > >  		if (need_resched())
> > > > @@ -347,9 +349,11 @@ bool rwsem_spin_on_owner(struct rw_semaphore *sem, struct task_struct *owner)
> > > >  	/*
> > > >  	 * We break out the loop above on need_resched() or when the
> > > >  	 * owner changed, which is a sign for heavy contention. Return
> > > > -	 * success only when sem->owner is NULL.
> > > > +	 * success only when the lock is available in order to attempt
> > > > +	 * another trylock.
> > > >  	 */
> > > > -	return sem->owner == NULL;
> > > > +	count = READ_ONCE(sem->count);
> > > > +	return count == 0 || count == RWSEM_WAITING_BIAS;
> > > 
> > > If we clear the owner field right before unlocking, would this cause
> > > some situations where we spin until the owner is cleared (about to
> > > release the lock), and then the spinner return false from
> > > rwsem_spin_on_owner?
> > 
> > I'm not sure I understand your concern ;) could you rephrase that? 
> 
> Sure, let me try to elaborate on that  :)
> 
> Since the unlocker clears the owner field before actually unlocking, I'm
> thinking that with this patch, the spinner in rwsem_spin_on_owner()
> would often read the count before the unlocker sets count.
> 
> When the owner releases the lock, it sets the owner field to NULL. This
> causes the spinner to break out of the loop as the owner changed. The
> spinner would then proceed to read sem->count, but before the owner
> modifies sem->count.
> 
> Thread 1(owner)		Thread 2 (spinning on owner)
> ---------------		----------------------------
> up_write()
>   rwsem_clear_owner()
> 			owner_running() // returns false
> 			count = READ_ONCE(sem->count)
>   __up_write()
> 			return (count == 0 || count == RWSEM_WAITING_BIAS) // returns false
> 			// going to slowpath

Yeah, I think that's something we'll just have to life with. Dealing
with owner and counter state will inevitable be unperfect at some point.
I think the race window is still quite small, and the change still deals
with a much more concerning problem.

After taking another look at the patch, I do think we should account for
owner before returning, though: When owner is set by the time we break
out of the loop, there's a new owner then (ie lock stolen), so we should
return true as we want to continue spinning. In this patch it would
return false. We can also return immediately when need_resched, making
rwsem_spin_on_owner() less ambiguous. What do you think of having this
instead?

bool rwsem_spin_on_owner(struct rw_semaphore *sem, struct task_struct *owner)
{
	long count;

	rcu_read_lock();
	while (owner_running(sem, owner)) {
		/* abort spinning when need_resched */
		if (need_resched()) {
			rcu_read_unlock();
			return false;
		}
		
		cpu_relax_lowlatency();
	}
	rcu_read_unlock();

	if (READ_ONCE(sem->owner))
		return true; /* new owner, continue spinning */
	
	/*
	 * When the owner is not set, the lock could be free or
	 * held by readers. Check the counter to verify the
	 * state.
	 */
	count = READ_ONCE(sem->count);
	return (count == 0 || count == RWSEM_WAITING_BIAS);
}

Thanks,
Davidlohd


