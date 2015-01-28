Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760650AbbA1VqF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:46:05 -0500
Received: from mga03.intel.com ([134.134.136.65]:17025 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760684AbbA1UfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:35:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,481,1418112000"; 
   d="scan'208";a="644021572"
Message-ID: <1422464493.2399.68.camel@schen9-desk2.jf.intel.com>
Subject: Re: [PATCH 4/6] locking/rwsem: Avoid deceiving lock spinners
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: Jason Low <jason.low2@hp.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Michel Lespinasse <walken@google.com>, linux-kernel@vger.kernel.org
Date: Wed, 28 Jan 2015 09:01:33 -0800
In-Reply-To: <1422417294.4604.15.camel@stgolabs.net>
References: <1422257769-14083-1-git-send-email-dave@stgolabs.net>
	 <1422257769-14083-5-git-send-email-dave@stgolabs.net>
	 <1422379430.6710.6.camel@j-VirtualBox>
	 <1422417294.4604.15.camel@stgolabs.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
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
> 
> So I think you're referring to the window between when we 1) clear the
> ->owner and 2) update the ->counter in the unlocking paths. That would
> lead the function to break out of the loop ("owner changed") and return
> a bogus "sem is locked, thus taken by a new owner now, continue
> spinning" reason for it (counter !=0 yet, for example). 
> 
> And that's perfectly fine, really. We've never held a strict
> owner-counter dependency, and the owner pointer is completely
> unreliable. So all this would end up doing is causing us to perform an
> extra iteration per race. This is a pretty good tradeoff for what the
> patch addresses.

I agree.  The counter is a more accurate and immediate indicator
of whether the lock is available, which is what we want to find out
here.

Tim


