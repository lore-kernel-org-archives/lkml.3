Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbaIMCPP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 22:15:15 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:60837 "EHLO
	homiemail-a60.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751927AbaIMCPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 22:15:13 -0400
Message-ID: <1410574435.18218.12.camel@linux-t7sj.site>
Subject: Re: [PATCH 3/9] locktorture: Support mutexes
From: Davidlohr Bueso <dave@stgolabs.net>
To: paulmck@linux.vnet.ibm.com
Cc: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 12 Sep 2014 19:13:55 -0700
In-Reply-To: <20140912191224.GL4775@linux.vnet.ibm.com>
References: <1410493224-3312-1-git-send-email-dave@stgolabs.net>
	 <1410493224-3312-4-git-send-email-dave@stgolabs.net>
	 <20140912180220.GE4775@linux.vnet.ibm.com>
	 <1410548191.12906.18.camel@linux-t7sj.site>
	 <20140912191224.GL4775@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-12 at 12:12 -0700, Paul E. McKenney wrote:
> On Fri, Sep 12, 2014 at 11:56:31AM -0700, Davidlohr Bueso wrote:
> > On Fri, 2014-09-12 at 11:02 -0700, Paul E. McKenney wrote:
> > > On Thu, Sep 11, 2014 at 08:40:18PM -0700, Davidlohr Bueso wrote:
> > > > +static void torture_mutex_delay(struct torture_random_state *trsp)
> > > > +{
> > > > +	const unsigned long longdelay_ms = 100;
> > > > +
> > > > +	/* We want a long delay occasionally to force massive contention.  */
> > > > +	if (!(torture_random(trsp) %
> > > > +	      (nrealwriters_stress * 2000 * longdelay_ms)))
> > > > +		mdelay(longdelay_ms * 5);
> > > 
> > > So let's see...  We wait 500 milliseconds about once per 200,000 operations
> > > per writer.  So if we have 5 writers, we wait 500 milliseconds per million
> > > operations.  So each writer will do about 200,000 operations, then there
> > > will be a half-second gap.  But each short operation holds the lock for
> > > 20 milliseconds, which takes several hours to work through the million
> > > operations.
> > > 
> > > So it looks to me like you are in massive contention state either way,
> > > at least until the next stutter interval shows up.
> > > 
> > > Is that the intent?  Or am I missing something here?
> > 
> > Ah, nice description. Yes, I am aiming for constant massive contention
> > (should have mentioned this, sorry). I believe it stresses the more
> > interesting parts of mutexes -- and rwsems, for that matter. If you
> > think it's excessive, we could decrease the the large wait and/or
> > increase the short one. I used the factor of the delay by the default
> > stutter value -- we could also make it always equal.
> 
> Don't get me wrong -- I am all for massive contention testing.  It is
> just that from what I can see, you aren't getting any real additional
> benefit out of the 500-millisecond wait.  Having even as few as (say)
> three tasks each repeatedly acquiring the lock and blocking for 20
> milliseconds ("else" clause below) will give you maximal contention.
> I cannot see how occasionally blocking for 500 milliseconds can do much
> of anything to increase the contention level.
> 
> Now if the common case was to acquire and then immediately release the
> lock, I could see how throwing in the occasional delay would be very
> useful. 

Right, that's what we do in the case of spinlock torturing.

> But for exclusive locks, a few tens of microseconds delay would
> probably suffice to give you a maximal contention event.  Yes, you do
> have a one-jiffy delay in the lock_torture_writer() loop, but it happens
> only one loop out of one million -- and if that is what you are worried
> about, a two-jiffy delay in the critical section would -guarantee- you
> a maximal contention event in most cases.

Ok yeah, no need to increase the jiffy delay.

> So my concern is that the large values you have are mostly slowing down
> the test and thus reducing its intensity.  But again, I could easily be
> missing something here.

You aren't. My rationale behind it was to have long and the occasional
very-long hold times. I'm thinking of either removing the 500 ms delay
altogether, or decreasing both delays by ~10x. That should provide a
more distributed contention between level between both delays. Threads
blocking for ~2ms should be quite ok for us.

Thanks,
Davidlohr

