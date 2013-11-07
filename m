Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab3KGM7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 07:59:35 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:63980 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab3KGM7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 07:59:31 -0500
Date: Thu, 7 Nov 2013 13:59:26 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Galbraith <bitbucket@online.de>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: CONFIG_NO_HZ_FULL + CONFIG_PREEMPT_RT_FULL = nogo
Message-ID: <20131107125923.GB24644@localhost.localdomain>
References: <1383228427.5272.36.camel@marge.simpson.net>
 <alpine.DEB.2.02.1311061842160.23353@ionos.tec.linutronix.de>
 <1383794799.5441.16.camel@marge.simpson.net>
 <1383798668.5441.25.camel@marge.simpson.net>
 <alpine.DEB.2.02.1311071158350.23353@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311071158350.23353@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 12:21:11PM +0100, Thomas Gleixner wrote:
> Mike,
> 
> On Thu, 7 Nov 2013, Mike Galbraith wrote:
> 
> > On Thu, 2013-11-07 at 04:26 +0100, Mike Galbraith wrote: 
> > > On Wed, 2013-11-06 at 18:49 +0100, Thomas Gleixner wrote: 
> > 
> > > > I bet you are trying to work around some of the side effects of the
> > > > occasional tick which is still necessary despite of full nohz, right?
> > > 
> > > Nope, I wanted to check out cost of nohz_full for rt, and found that it
> > > doesn't work at all instead, looked, and found that the sole running
> > > task has just awakened ksoftirqd when it wants to shut the tick down, so
> > > that shutdown never happens. 
> > 
> > Like so in virgin 3.10-rt.  Box is x3550 M3 booted nowatchdog
> > rcu_nocbs=1-3 nohz_full=1-3, and CPUs1-3 are completely isolated via
> > cpusets as well.
> 
> well, that very same problem is in mainline if you add "threadirqs" to
> the command line. But we can be smart about this. The untested patch
> below should address that issue. If that works on mainline we can
> adapt it for RT (needs a trylock(&base->lock) there).
> 
> Though it's not a full solution. It needs some thought versus the
> softirq code of timers. Assume we have only one timer queued 1000
> ticks into the future. So this change will cause the timer softirq not
> to be called until that timer expires and then the timer softirq is
> going to do 1000 loops until it catches up with jiffies. That's
> anything but pretty ...
> 
> What worries me more is this one:
> 
>   pert-5229  [003] d..h1..   684.482618: softirq_raise: vec=9 [action=RCU]
> 
> The CPU has no callbacks as you shoved them over to cpu 0, so why is
> the RCU softirq raised?

I see, so the problem is that we raise the timer softirq unconditionally
from the tick?

Ok we definetly don't want to keep that behaviour, even if softirqs are not
threaded, that's an overhead. So I'm looking at that loop in __run_timers()
and I guess you mean the "base->timer_jiffies" incrementation?

That's indeed not pretty. How do we handle exit from long dynticks idle periods? Are we
doing that loop until we catch up with the new jiffies?

Then it relies on the timer cascade stuff which is very obscure code to me...
