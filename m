Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191AbbA1DzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 22:55:00 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:36926 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbbA1Dy7 (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Tue, 27 Jan 2015 22:54:59 -0500
Message-ID: <1422417294.4604.15.camel@stgolabs.net>
Subject: Re: [PATCH 4/6] locking/rwsem: Avoid deceiving lock spinners
From: Davidlohr Bueso <dave@stgolabs.net>
To: Jason Low <jason.low2@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Michel Lespinasse <walken@google.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org
Date: Tue, 27 Jan 2015 19:54:54 -0800
In-Reply-To: <1422379430.6710.6.camel@j-VirtualBox>
References: <1422257769-14083-1-git-send-email-dave@stgolabs.net>
	 <1422257769-14083-5-git-send-email-dave@stgolabs.net>
	 <1422379430.6710.6.camel@j-VirtualBox>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-27 at 09:23 -0800, Jason Low wrote:
> On Sun, 2015-01-25 at 23:36 -0800, Davidlohr Bueso wrote:
> > When readers hold the semaphore, the ->owner is nil. As such,
> > and unlike mutexes, '!owner' does not necessarily imply that
> > the lock is free. This will cause writer spinners to potentially
> > spin excessively as they've been mislead to thinking they have
> > a chance of acquiring the lock, instead of blocking.
> > 
> > This patch therefore replaces this bogus check to solely rely on
> > the counter to know if the lock is available. Because we don't
> > hold the wait lock, we can obviously do this in an unqueued
> > manner.
> > 
> > Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
> > ---
> >  kernel/locking/rwsem-xadd.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
> > index 5e425d8..18a50da 100644
> > --- a/kernel/locking/rwsem-xadd.c
> > +++ b/kernel/locking/rwsem-xadd.c
> > @@ -335,6 +335,8 @@ static inline bool owner_running(struct rw_semaphore *sem,
> >  static noinline
> >  bool rwsem_spin_on_owner(struct rw_semaphore *sem, struct task_struct *owner)
> >  {
> > +	long count;
> > +
> >  	rcu_read_lock();
> >  	while (owner_running(sem, owner)) {
> >  		if (need_resched())
> > @@ -347,9 +349,11 @@ bool rwsem_spin_on_owner(struct rw_semaphore *sem, struct task_struct *owner)
> >  	/*
> >  	 * We break out the loop above on need_resched() or when the
> >  	 * owner changed, which is a sign for heavy contention. Return
> > -	 * success only when sem->owner is NULL.
> > +	 * success only when the lock is available in order to attempt
> > +	 * another trylock.
> >  	 */
> > -	return sem->owner == NULL;
> > +	count = READ_ONCE(sem->count);
> > +	return count == 0 || count == RWSEM_WAITING_BIAS;
> 
> If we clear the owner field right before unlocking, would this cause
> some situations where we spin until the owner is cleared (about to
> release the lock), and then the spinner return false from
> rwsem_spin_on_owner?

I'm not sure I understand your concern ;) could you rephrase that? 

So I think you're referring to the window between when we 1) clear the
->owner and 2) update the ->counter in the unlocking paths. That would
lead the function to break out of the loop ("owner changed") and return
a bogus "sem is locked, thus taken by a new owner now, continue
spinning" reason for it (counter !=0 yet, for example). 

And that's perfectly fine, really. We've never held a strict
owner-counter dependency, and the owner pointer is completely
unreliable. So all this would end up doing is causing us to perform an
extra iteration per race. This is a pretty good tradeoff for what the
patch addresses.

Thanks,
Davidlohr

