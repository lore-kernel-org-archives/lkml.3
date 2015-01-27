Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760090AbbA0V5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 16:57:31 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:43653 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834AbbA0V5a (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Tue, 27 Jan 2015 16:57:30 -0500
Message-ID: <1422395843.4604.9.camel@stgolabs.net>
Subject: Re: [PATCH 5/6] locking/rwsem: Optimize slowpath/sleeping
From: Davidlohr Bueso <dave@stgolabs.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>, Michel Lespinasse <walken@google.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org
Date: Tue, 27 Jan 2015 13:57:23 -0800
In-Reply-To: <20150127173442.GK21418@twins.programming.kicks-ass.net>
References: <1422257769-14083-1-git-send-email-dave@stgolabs.net>
	 <1422257769-14083-6-git-send-email-dave@stgolabs.net>
	 <20150127173442.GK21418@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-27 at 18:34 +0100, Peter Zijlstra wrote:
> On Sun, Jan 25, 2015 at 11:36:08PM -0800, Davidlohr Bueso wrote:
> > When blocking , we incur in multiple barriers when setting the
> > task's uninterruptable state. This is particularly bad when the
> > lock keeps getting stolen from the task trying to acquire the sem.
> > These changes propose delaying setting the task's new state until
> > we are sure that calling schedule is inevitable.
> > 
> > This implies that we do the trylock and active check (both basically
> > ->counter checks) as TASK_RUNNING. For the trylock we hold the wait
> > lock with interrupts disabled, so no risk there. And for the active
> > check, the window for which we could get interrupted is quite small
> > and makes no tangible difference.
> > 
> > This patch increases Unixbench's 'execl' throughput by 25% on a 40
> > core machine.
> > 
> > Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
> > ---
> >  kernel/locking/rwsem-xadd.c | 20 +++++++++++++++-----
> >  1 file changed, 15 insertions(+), 5 deletions(-)
> > 
> > diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
> > index 18a50da..88b3468 100644
> > --- a/kernel/locking/rwsem-xadd.c
> > +++ b/kernel/locking/rwsem-xadd.c
> > @@ -459,17 +459,27 @@ struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
> >  		count = rwsem_atomic_update(RWSEM_WAITING_BIAS, sem);
> >  
> >  	/* wait until we successfully acquire the lock */
> >  	while (true) {
> >  		if (rwsem_try_write_lock(count, sem))
> >  			break;
> > +
> > +		__set_current_state(TASK_UNINTERRUPTIBLE);
> >  		raw_spin_unlock_irq(&sem->wait_lock);
> >  
> > +		/*
> > +		 * When there are active locks after we wake up,
> > +		 * the lock was probably stolen from us. Thus,
> > +		 * go immediately back to sleep and avoid taking
> > +		 * the wait_lock.
> > +		 */
> > +		while (true) {
> >  			schedule();
> > +
> > +			count = READ_ONCE(sem->count);
> > +			if (!(count & RWSEM_ACTIVE_MASK))
> > +				break;
> > +			__set_current_state(TASK_UNINTERRUPTIBLE);
> > +		}
> 
> So its late and I'm not seeing it; why is this safe? How will we not
> miss the wakeup that makes condition true?

I was thinking preemption was disabled. But actually yeah, that's a now
stale patch. We should only get rid of the first barrier, that should be
safe.

Thanks,
Davidlohr

