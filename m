Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbaDWJlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 05:41:39 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37321 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbaDWJld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 05:41:33 -0400
Date: Wed, 23 Apr 2014 11:41:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Denys Vlasenko <vda.linux@googlemail.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] nohz: delayed iowait accounting for nohz idle time
 stats
Message-ID: <20140423094119.GJ11096@twins.programming.kicks-ass.net>
References: <534FA04B.8080906@jp.fujitsu.com>
 <534FA1D5.7040808@jp.fujitsu.com>
 <20140422194547.GS13658@twins.programming.kicks-ass.net>
 <53576E62.50508@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53576E62.50508@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 04:40:18PM +0900, Hidetoshi Seto wrote:
> (2014/04/23 4:45), Peter Zijlstra wrote:
> > On Thu, Apr 17, 2014 at 06:41:41PM +0900, Hidetoshi Seto wrote:
> >> [TARGET OF THIS PATCH]:
> >>
> >>   Complete rework for iowait accounting implies that some user
> >>   interfaces might be replaced completely. It will introduce new
> >>   counter or so, and kill per-cpu iowait counter which is known to
> >>   being nonsense. It will take long time to be achieved, considering
> >>   time to make the problem to a public knowledge, and also time for
> >>   interface transition. Anyway as long as linux try to be reliable OS,
> >>   such drastic change must be placed on mainline kernel in development
> >>   sooner or later.
> >>
> >>   OTOH, drastic change like above is not acceptable for conservative
> >>   environment, such as stable kernels, some distributor's kernel and
> >>   so on, due to respect for compatibility. Still these kernel expects
> >>   per-cpu iowait counter works as well as it might have been.
> >>   Therefore for such environment, applying a simple patch to fix
> >>   behavior of counter will be appreciated rather than replacing an
> >>   over-used interface or changing an existing usage/semantics.
> >>
> >>   This patch targets latter kernels mainly. It does not do too much,
> >>   but intend to fix the idle stats counters to be monotonic. I believe
> >>   that mainline kernel should pick up this patch too, because it
> >>   surely fix a hidden bug and does not intercept upcoming drastic
> >>   change.
> >>
> >>   Again, in summary, this patch does not do drastic change to cope
> >>   with problem 2. But it just fix behavior of idle/iowait counter of
> >>   /proc/stats.
> >>
> >> [WHAT THIS PATCH PROPOSED]:
> >>
> >>   The main reason of the bug is that observers have no idea to
> >>   determine the delta to be idle or iowait at the first place.
> >>
> >>   So I introduced delayed iowait accounting to allow observers to
> >>   assign delta based on status of observed cpu at idle entry.
> >>
> > 
> > So the problem I have with this is that it makes CONFIG_NOHZ=[ny]
> > kernels behave quite differently.
> 
> It is not true.
> There are already differences before applying my patches.
> The behavior of NOHZ=y kernel diverged from original since it was born.

But if you argue about not actually fixing iowait properly, then this
difference is the only actual regression.

> Please note that no one complained about this difference.

Then why are you working on this? You're the one that said there was a
regression between unnamed enterprise distro 5 and unnamed enterprise
distro 6.

> I just want to fix a counter not to go backward.
> It's a simple bug, isn't it?

Seeing how we managed to send as many patches as we did, I'd say that's
a fairly big clue as to how its not as simple.

Just make the value unconditionally 0 then. That's guaranteed not to go
backwards and just about as useful as the random fwd walk you make it.
Plus, its a lot easier.

> > Ideally NOHZ=y and NOHZ=n behave the same, my proposed solution the
> > other day does just that. This one OTOH seems to generate entirely
> > different results between those kernels.
> 
> As you know, behaviors of NOHZ=[ny] are both crap because of per-cpu
> iowait accounting.
> 
> I guess we should say:
>   Ideally NOHZ=[ny] behave the same "in the proper way."

No, the premise of NOHZ is that behaviour should not change, we found a
change in behaviour, we should make it go away.

Secondly, with or without NOHZ iowait accounting is complete crap. We
should also fix that.

> What you proposed will do too much to make one nonsense to another
> nonsense. It will be unhelpful for people...

I proposed that if you don't want to fix the actual iowait is crap
problem, you at least fix the NOHZ regression proper.

> > It also doesn't really simplify the code; there's quite a bit of
> > complexity introduced to paper over this silly stuff.
> 
> Don't complicate things. I want to talk about a small simple bug.
> 
> a) today's NOHZ=n
>    - provides per-cpu iowait counter
>      (nonsense but still loved by innocent userland)
> b) today's NOHZ=y
>    - provides per-cpu iowait counter
>    - use it's own idle time accounting different from a)
>    - have a *bug* that counter might go backward

Like said, the intent of NOHZ is to not change accounting, its often
more complicated from a because well, no ticks.

But it really should give the same number, nonsense or not. We do the
same for all other numbers -- we spend a ton of effort to fix the
loadavg a year or two ago.

loadavg is also another dubious number, fwiw.

> b') NOHZ=y + my patch
>    - provides per-cpu iowait counter
>    - use it's own idle time accounting same as b)
>    - *bug* in b) have gone
>    - instead accept gap in iowait value from b)
>      - "pending" will not bloat more than one iowait span
> 
> c) unified something for NOHZ=[ny] (you proposed)
>    - provides per-cpu iowait counter
>    - use new accounting different from a) and also b)
> 
> d) ideal goal (=not designed & realized yet)
>    - no per-cpu iowait counter any more
>    - use new proper accounting different from all of above
> 
> I just want to make b) to b') by a patch as small as possible.

I really don't see the value of b', the actual value of its result is
really no better than the constant 0, and the constant implementation is
_way_ simpler.

> What you proposed will make both of a) and b) to c).
> I think it does too much and changing a) is not required here.
> (from my conservative perspective, patch must be non-intrusive)
> 
> Our final goal must be making d) to replace all nasty things
> around there. But still there is no idea to do that.
> And such big jump will not fit to stable environments.
> 
> Again, I just want to fix a small bug here...
> 
> I believe my patch is enough simple to do a minimum fix.
> Please tell me if you have more simple/better way to fix this
> long-standing minor bug, not only for mainline in development
> but also for conservative stables like distributor's kernel.

I really think only fixing the backward motion is retarded. Its papering
over so much crap its not funny.

The fact that it does go backwards is because b does not give the
identical results from a, _that_ is a bug per the design principle of
NOHZ.

Fixing it to just return some random number that doesn't go backwards
doesn't fix it. It just makes the immediately observed problem go away;
entirely the wrong mindset.
