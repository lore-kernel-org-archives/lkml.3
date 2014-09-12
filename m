Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058AbaILS5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 14:57:50 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:50617 "EHLO
	homiemail-a38.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751467AbaILS5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 14:57:49 -0400
Message-ID: <1410548191.12906.18.camel@linux-t7sj.site>
Subject: Re: [PATCH 3/9] locktorture: Support mutexes
From: Davidlohr Bueso <dave@stgolabs.net>
To: paulmck@linux.vnet.ibm.com
Cc: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 12 Sep 2014 11:56:31 -0700
In-Reply-To: <20140912180220.GE4775@linux.vnet.ibm.com>
References: <1410493224-3312-1-git-send-email-dave@stgolabs.net>
	 <1410493224-3312-4-git-send-email-dave@stgolabs.net>
	 <20140912180220.GE4775@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-12 at 11:02 -0700, Paul E. McKenney wrote:
> On Thu, Sep 11, 2014 at 08:40:18PM -0700, Davidlohr Bueso wrote:
> > +static void torture_mutex_delay(struct torture_random_state *trsp)
> > +{
> > +	const unsigned long longdelay_ms = 100;
> > +
> > +	/* We want a long delay occasionally to force massive contention.  */
> > +	if (!(torture_random(trsp) %
> > +	      (nrealwriters_stress * 2000 * longdelay_ms)))
> > +		mdelay(longdelay_ms * 5);
> 
> So let's see...  We wait 500 milliseconds about once per 200,000 operations
> per writer.  So if we have 5 writers, we wait 500 milliseconds per million
> operations.  So each writer will do about 200,000 operations, then there
> will be a half-second gap.  But each short operation holds the lock for
> 20 milliseconds, which takes several hours to work through the million
> operations.
> 
> So it looks to me like you are in massive contention state either way,
> at least until the next stutter interval shows up.
> 
> Is that the intent?  Or am I missing something here?

Ah, nice description. Yes, I am aiming for constant massive contention
(should have mentioned this, sorry). I believe it stresses the more
interesting parts of mutexes -- and rwsems, for that matter. If you
think it's excessive, we could decrease the the large wait and/or
increase the short one. I used the factor of the delay by the default
stutter value -- we could also make it always equal.

> > +	else
> > +		mdelay(longdelay_ms / 5);
> > +#ifdef CONFIG_PREEMPT
> > +	if (!(torture_random(trsp) % (nrealwriters_stress * 20000)))
> > +		preempt_schedule();  /* Allow test to be preempted. */
> > +#endif
> > +}
> > +
> > +static void torture_mutex_unlock(void) __releases(torture_mutex)
> > +{
> > +	mutex_unlock(&torture_mutex);
> > +}
> > +
> > +static struct lock_torture_ops mutex_lock_ops = {
> > +	.writelock	= torture_mutex_lock,
> > +	.write_delay	= torture_mutex_delay,
> > +	.writeunlock	= torture_mutex_unlock,
> > +	.name		= "mutex_lock"
> > +};
> > +
> >  /*
> >   * Lock torture writer kthread.  Repeatedly acquires and releases
> >   * the lock, checking for duplicate acquisitions.
> > @@ -352,7 +389,7 @@ static int __init lock_torture_init(void)
> >  	int i;
> >  	int firsterr = 0;
> >  	static struct lock_torture_ops *torture_ops[] = {
> > -		&lock_busted_ops, &spin_lock_ops, &spin_lock_irq_ops,
> > +		&lock_busted_ops, &spin_lock_ops, &spin_lock_irq_ops, &mutex_lock_ops,
> >  	};
> > 
> >  	if (!torture_init_begin(torture_type, verbose, &torture_runnable))
> > -- 
> 
> And I queued the following patch to catch up the scripting.

Thanks! Completely overlooked the scripting bits. I'll keep it in mind
in the future.

