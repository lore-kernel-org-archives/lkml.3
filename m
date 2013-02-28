Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab3B1IEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 03:04:21 -0500
Received: from mout.gmx.net ([212.227.15.18]:49423 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192Ab3B1IEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 03:04:20 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18nB/8EyZYnLzueCvesTGiy3WL9ReVzBHOHhHNdrb
	e08J2ncgHonx/6
Message-ID: <1362038652.4460.124.camel@marge.simpson.net>
Subject: Re: [RFC PATCH] sched: wakeup buddy
From: Mike Galbraith <efault@gmx.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Date: Thu, 28 Feb 2013 09:04:12 +0100
In-Reply-To: <512F09D4.1020307@linux.vnet.ibm.com>
References: <512EFB4B.5040204@linux.vnet.ibm.com>
	 <1362035917.4460.105.camel@marge.simpson.net>
	 <512F09D4.1020307@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-28 at 15:40 +0800, Michael Wang wrote: 
> Hi, Mike
> 
> Thanks for your reply.
> 
> On 02/28/2013 03:18 PM, Mike Galbraith wrote:
> > On Thu, 2013-02-28 at 14:38 +0800, Michael Wang wrote:
> > 
> >> +				/*
> >> +				 * current is the only task on rq and it is
> >> +				 * going to sleep, current cpu will be a nice
> >> +				 * candidate for p to run on.
> >> +				 */
> > 
> > The sync hint only means it might be going to sleep soon, and even then,
> > there can still be enough execution overlap to be a win to schedule
> > cross core.  Sched pipe numbers will always be much prettier if you do
> > wakeup cpu affine, as it's ~100% scheduler and ~100% sync.
> 
> Hmm.. so it's the comparison between 'cache benefit - execution overlap'
> and 'latency - execution overlap'?

Yeah.  You'll always lose power cross core, and throughput breakeven and
win depends on convertible overlap, and how much L2 miss etc costs.  For
sched pipe there is no win, but for other sync hint users there is.

> I could not estimate how many latency will be added to wait for current
> going to sleep (it should be faster than access cold data, isn't it?),
> but I really like the cache benefit, unless sync doesn't means current
> is going to sleep every time, but that's the promise of WF_SYNC, isn't it?

It would be nice if it _were_ a promise, but it is not, it's a hint.

> You may lose
> > a lot on other stuff if you interpret the hint as gospel truth.
> 
> Could you please give more details on this point?

tbench, mysql+oltp, on and on use the sync hint, many things jabber on
localhost, use the sync hint, and have been shown in cold hard numbers
to benefit, some things massively from cross core scheduling.  You lose
for sure at extreme context rates, but it has to be pretty darn high to
be a guaranteed loser.

That's why select_idle_sibling() is so very damn annoying.
> > IMHO, sched pipe is a "how fat have I become" benchmark, not "how well
> > do I perform".  The scheduler performs well when it makes more work
> > happen.  Playing ping-pong with yourself is _exercise_, not a job :)
> 
> That's right, may be I'm using the wrong description, it's the ops/sec
> which has been doubled, that means 'fat', correct?

In this case, it means you're not running a kernel with nohz on a chain,
running two schedulers is more expensive than running one, and missing
L2 each and every time hurts very badly when the load is ultra skinny.

-Mike

