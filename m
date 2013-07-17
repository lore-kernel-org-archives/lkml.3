Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab3GQSDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 14:03:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43792 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab3GQSDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 14:03:21 -0400
Date: Wed, 17 Jul 2013 20:01:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Jason Low <jason.low2@hp.com>, Ingo Molnar <mingo@redhat.com>,
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
Subject: Re: [RFC] sched: Limit idle_balance() when it is being used too
 frequently
Message-ID: <20130717180156.GS23818@dyad.programming.kicks-ass.net>
References: <1374002463.3944.11.camel@j-VirtualBox>
 <20130716202015.GX17211@twins.programming.kicks-ass.net>
 <1374014881.2332.21.camel@j-VirtualBox>
 <20130717072504.GY17211@twins.programming.kicks-ass.net>
 <1374048701.6000.21.camel@j-VirtualBox>
 <20130717093913.GP23818@dyad.programming.kicks-ass.net>
 <1374076741.7412.35.camel@j-VirtualBox>
 <20130717161815.GR23818@dyad.programming.kicks-ass.net>
 <51E6D9B7.1030705@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E6D9B7.1030705@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 01:51:51PM -0400, Rik van Riel wrote:
> On 07/17/2013 12:18 PM, Peter Zijlstra wrote:

> >So the way I see things is that the only way newidle balance can slow down
> >things is if it runs when we could have ran something useful.
> 
> Due to contention on the runqueue locks of other CPUs,
> newidle also has the potential to keep _others_ from
> running something useful.

Right, although that should only happen when we do have an imbalance and want
to go move something. Which in Jason's case is 'rare'. But yes, I suppose
there's other scenarios where this is far more likely.

> Could we prevent that downside by measuring both the
> time spent idle, and the time spent in idle balancing,
> and making sure the idle balancing time never exceeds
> more than N% of the idle time?

Sure:

idle_balance(u64 idle_duration)
{
  u64 cost = 0;

  for_each_domain(sd) {
    if (cost + sd->cost > idle_duration/N)
      break;

    ...

    sd->cost = (sd->cost + this_cost) / 2;
    cost += this_cost;
  }
}

I would've initially suggested using something like N=2 since we're dealing
with averages and half should ensure we don't run over except for the worst
peaks. But we could easily use a bigger N.
