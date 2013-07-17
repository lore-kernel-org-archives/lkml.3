Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514Ab3GQQTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:19:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40407 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab3GQQTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:19:32 -0400
Date: Wed, 17 Jul 2013 18:18:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [RFC] sched: Limit idle_balance() when it is being used too
 frequently
Message-ID: <20130717161815.GR23818@dyad.programming.kicks-ass.net>
References: <1374002463.3944.11.camel@j-VirtualBox>
 <20130716202015.GX17211@twins.programming.kicks-ass.net>
 <1374014881.2332.21.camel@j-VirtualBox>
 <20130717072504.GY17211@twins.programming.kicks-ass.net>
 <1374048701.6000.21.camel@j-VirtualBox>
 <20130717093913.GP23818@dyad.programming.kicks-ass.net>
 <1374076741.7412.35.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374076741.7412.35.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 08:59:01AM -0700, Jason Low wrote:
> 
> So if we have the following: 
> 
> for_each_domain(sd)
> 	before = sched_clock_cpu
> 	load_balance(sd)
> 	after = sched_clock_cpu
> 	idle_balance_completion_time = after - before
> 
> At this point, the "idle_balance_completion_time" is usually a very
> small value and is usually a lot smaller than the avg CPU idle time.
> However, the vast majority of the time, load_balance returns 0.

I think the interesting question here is: is it significantly more when we do
find a task?

I would also expect sd->newidle_balance_cost (less typing there) to scale with the
number of CPUs in the domain - thus larger domains will take longer etc.

And (obviously) the cost of the entire newidle balance is the direct sum of
individual domain costs.

> Do you think its worth a try to consider each newidle balance attempt as
> the total load_balance attempts until it is able to move a task, and
> then skip balancing within the domain if a CPU's avg idle time is less
> than that avg time doing newidle balance? 

So the way I see things is that the only way newidle balance can slow down
things is if it runs when we could have ran something useful.

So all we need to ensure is to not run longer than we expect to be idle for and
things should be 'free', right?

So the problem I have with your proposal is that supposing we're successful
once every 10 newidle balances. Then the sd->newidle_balance_cost gets inflated
by a factor 10 -- for we'd count 10 of them before 'success'.

However when we're idle for that amount of time (10 times longer than it takes
to do a single newidle balance) we'd still only do a single newidle balance,
not 10.
