Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260Ab3GRECb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 00:02:31 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:15709 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab3GRECa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 00:02:30 -0400
Message-ID: <1374120144.1816.45.camel@j-VirtualBox>
Subject: Re: [RFC] sched: Limit idle_balance() when it is being used too
 frequently
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        aswin@hp.com, scott.norton@hp.com, chegu_vinod@hp.com
Date: Wed, 17 Jul 2013 21:02:24 -0700
In-Reply-To: <20130717180156.GS23818@dyad.programming.kicks-ass.net>
References: <1374002463.3944.11.camel@j-VirtualBox>
	 <20130716202015.GX17211@twins.programming.kicks-ass.net>
	 <1374014881.2332.21.camel@j-VirtualBox>
	 <20130717072504.GY17211@twins.programming.kicks-ass.net>
	 <1374048701.6000.21.camel@j-VirtualBox>
	 <20130717093913.GP23818@dyad.programming.kicks-ass.net>
	 <1374076741.7412.35.camel@j-VirtualBox>
	 <20130717161815.GR23818@dyad.programming.kicks-ass.net>
	 <51E6D9B7.1030705@redhat.com>
	 <20130717180156.GS23818@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-17 at 20:01 +0200, Peter Zijlstra wrote:
> On Wed, Jul 17, 2013 at 01:51:51PM -0400, Rik van Riel wrote:
> > On 07/17/2013 12:18 PM, Peter Zijlstra wrote:
> 
> > >So the way I see things is that the only way newidle balance can slow down
> > >things is if it runs when we could have ran something useful.
> > 
> > Due to contention on the runqueue locks of other CPUs,
> > newidle also has the potential to keep _others_ from
> > running something useful.
> 
> Right, although that should only happen when we do have an imbalance and want
> to go move something. Which in Jason's case is 'rare'. But yes, I suppose
> there's other scenarios where this is far more likely.
> 
> > Could we prevent that downside by measuring both the
> > time spent idle, and the time spent in idle balancing,
> > and making sure the idle balancing time never exceeds
> > more than N% of the idle time?
> 
> Sure:
> 
> idle_balance(u64 idle_duration)
> {
>   u64 cost = 0;
> 
>   for_each_domain(sd) {
>     if (cost + sd->cost > idle_duration/N)
>       break;
> 
>     ...
> 
>     sd->cost = (sd->cost + this_cost) / 2;
>     cost += this_cost;
>   }
> }
> 
> I would've initially suggested using something like N=2 since we're dealing
> with averages and half should ensure we don't run over except for the worst
> peaks. But we could easily use a bigger N.

I ran a few AIM7 workloads for the 8 socket HT enabled case and I needed
to set N to more than 20 in order to get the big performance gains.

One thing that I thought of was to have N be based on how often idle
balance attempts does not pull task(s).

For example, N can be calculated based on the number of idle balance
attempts for the CPU  since the last "successful" idle balance attempt.
So if the previous 30 idle balance attempts resulted in no tasks moved,
then n = 30 / 5. So idle balance gets less time to run as the number of
unneeded idle balance attempts increases, and thus N will not be set too
high during situations where idle balancing is "successful" more often.
Any comments on this idea?

Thanks,
Jason


