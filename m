Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbaILTMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 15:12:30 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:37044 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbaILTM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 15:12:27 -0400
Date: Fri, 12 Sep 2014 12:12:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] locktorture: Support mutexes
Message-ID: <20140912191224.GL4775@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1410493224-3312-1-git-send-email-dave@stgolabs.net>
 <1410493224-3312-4-git-send-email-dave@stgolabs.net>
 <20140912180220.GE4775@linux.vnet.ibm.com>
 <1410548191.12906.18.camel@linux-t7sj.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410548191.12906.18.camel@linux-t7sj.site>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091219-7164-0000-0000-000004909370
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 11:56:31AM -0700, Davidlohr Bueso wrote:
> On Fri, 2014-09-12 at 11:02 -0700, Paul E. McKenney wrote:
> > On Thu, Sep 11, 2014 at 08:40:18PM -0700, Davidlohr Bueso wrote:
> > > +static void torture_mutex_delay(struct torture_random_state *trsp)
> > > +{
> > > +	const unsigned long longdelay_ms = 100;
> > > +
> > > +	/* We want a long delay occasionally to force massive contention.  */
> > > +	if (!(torture_random(trsp) %
> > > +	      (nrealwriters_stress * 2000 * longdelay_ms)))
> > > +		mdelay(longdelay_ms * 5);
> > 
> > So let's see...  We wait 500 milliseconds about once per 200,000 operations
> > per writer.  So if we have 5 writers, we wait 500 milliseconds per million
> > operations.  So each writer will do about 200,000 operations, then there
> > will be a half-second gap.  But each short operation holds the lock for
> > 20 milliseconds, which takes several hours to work through the million
> > operations.
> > 
> > So it looks to me like you are in massive contention state either way,
> > at least until the next stutter interval shows up.
> > 
> > Is that the intent?  Or am I missing something here?
> 
> Ah, nice description. Yes, I am aiming for constant massive contention
> (should have mentioned this, sorry). I believe it stresses the more
> interesting parts of mutexes -- and rwsems, for that matter. If you
> think it's excessive, we could decrease the the large wait and/or
> increase the short one. I used the factor of the delay by the default
> stutter value -- we could also make it always equal.

Don't get me wrong -- I am all for massive contention testing.  It is
just that from what I can see, you aren't getting any real additional
benefit out of the 500-millisecond wait.  Having even as few as (say)
three tasks each repeatedly acquiring the lock and blocking for 20
milliseconds ("else" clause below) will give you maximal contention.
I cannot see how occasionally blocking for 500 milliseconds can do much
of anything to increase the contention level.

Now if the common case was to acquire and then immediately release the
lock, I could see how throwing in the occasional delay would be very
useful.  But for exclusive locks, a few tens of microseconds delay would
probably suffice to give you a maximal contention event.  Yes, you do
have a one-jiffy delay in the lock_torture_writer() loop, but it happens
only one loop out of one million -- and if that is what you are worried
about, a two-jiffy delay in the critical section would -guarantee- you
a maximal contention event in most cases.

So my concern is that the large values you have are mostly slowing down
the test and thus reducing its intensity.  But again, I could easily be
missing something here.

> > > +	else
> > > +		mdelay(longdelay_ms / 5);
> > > +#ifdef CONFIG_PREEMPT
> > > +	if (!(torture_random(trsp) % (nrealwriters_stress * 20000)))
> > > +		preempt_schedule();  /* Allow test to be preempted. */
> > > +#endif
> > > +}
> > > +
> > > +static void torture_mutex_unlock(void) __releases(torture_mutex)
> > > +{
> > > +	mutex_unlock(&torture_mutex);
> > > +}
> > > +
> > > +static struct lock_torture_ops mutex_lock_ops = {
> > > +	.writelock	= torture_mutex_lock,
> > > +	.write_delay	= torture_mutex_delay,
> > > +	.writeunlock	= torture_mutex_unlock,
> > > +	.name		= "mutex_lock"
> > > +};
> > > +
> > >  /*
> > >   * Lock torture writer kthread.  Repeatedly acquires and releases
> > >   * the lock, checking for duplicate acquisitions.
> > > @@ -352,7 +389,7 @@ static int __init lock_torture_init(void)
> > >  	int i;
> > >  	int firsterr = 0;
> > >  	static struct lock_torture_ops *torture_ops[] = {
> > > -		&lock_busted_ops, &spin_lock_ops, &spin_lock_irq_ops,
> > > +		&lock_busted_ops, &spin_lock_ops, &spin_lock_irq_ops, &mutex_lock_ops,
> > >  	};
> > > 
> > >  	if (!torture_init_begin(torture_type, verbose, &torture_runnable))
> > > -- 
> > 
> > And I queued the following patch to catch up the scripting.
> 
> Thanks! Completely overlooked the scripting bits. I'll keep it in mind
> in the future.

No problem, and I look forward to also seeing the scripting pieces in
the future.  ;-)

							Thanx, Paul

