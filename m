Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbaCFJ6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 04:58:07 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49611 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbaCFJ6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:58:04 -0500
Date: Thu, 6 Mar 2014 10:57:42 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk, oleg@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
Message-ID: <20140306095742.GI9987@twins.programming.kicks-ass.net>
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com>
 <531641A8.40306@zytor.com>
 <53164824.3000704@oracle.com>
 <20140304222356.41c55bbc@alan.etchedpixels.co.uk>
 <5316574F.6040105@oracle.com>
 <alpine.DEB.2.02.1403050129570.18573@ionos.tec.linutronix.de>
 <8738ix5uyk.fsf@tassilo.jf.intel.com>
 <20140305111006.GT9987@twins.programming.kicks-ass.net>
 <531781E5.8010000@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531781E5.8010000@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 12:58:29PM -0700, Khalid Aziz wrote:
> On 03/05/2014 04:10 AM, Peter Zijlstra wrote:
> >On Tue, Mar 04, 2014 at 04:51:15PM -0800, Andi Kleen wrote:
> >>Anything else?
> >
> >Proxy execution; its a form of PI that works for arbitrary scheduling
> >policies (thus also very much including fair).
> >
> >With that what you effectively end up with is the lock holder running
> >'boosted' by the runtime of its blocked chain until the entire chain
> >runs out of time, at which point preemption doesn't matter anyhow.
> >
> 
> Hello Peter,
> 
> I read through the concept of proxy execution and it is a very interesting
> concept. I come from many years of realtime and embeddded systems
> development and I can easily recall various problems in the past that can be
> solved or helped by this. 

Yeah; there's a few nasty cases with PEP on SMP though (the reason we've
not already have it); the trivial implementation that works wonderfully
on UP ends up capable of running the same task on multiple CPUs -- which
is an obvious fail.

There's people working on this though; as the scheme also works well for
the recently added deadline scheduler.

> Looking at the current problem I am trying to
> solve with databases and JVM, I run into the same issue I described in my
> earlier email. Proxy execution is a post-contention solution. By the time
> proxy execution can do something for my case, I have already paid the price
> of contention and a context switch which is what I am trying to avoid. For a
> critical section that is very short compared to the size of execution
> thread, which is the case I am looking at, avoiding preemption in the middle
> of that short critical section helps much more than dealing with lock
> contention later on.

Like others have already stated; its likely still cheaper than the
pile-up you get now. It might not be optimally fast, but it sure takes
out the worst case you have now.

> The goal here is to avoid lock contention and
> associated cost. I do understand the cost of dealing with lock contention
> poorly and that can easily be much bigger cost, but I am looking into
> avoiding even getting there.

The thing is; unless userspace is a RT program or practises the same
discipline in such an extend as that it make no practical difference,
there's always going to be the case where you fail to cover the entire
critical section, at which point you're back to your pile-up fail.

So while the limited preemption guard helps the best cast, it doesn't
help the worst case at all.

So supposing we went with this now; you (or someone else) will come back
in a year's time and tell us that if we only just stretch this window a
little, their favourite workload will also benefit.

Where's the end of that?

And what about CONFIG_HZ; suppose you compile your kernel with HZ=100
and your 1 extra tick is sufficient. Then someone compiles their kernel
with HZ=1000 and it all comes apart.


