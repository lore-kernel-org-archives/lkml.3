Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab3GQILu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 04:11:50 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:7181 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab3GQILq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 04:11:46 -0400
Message-ID: <1374048701.6000.21.camel@j-VirtualBox>
Subject: Re: [RFC] sched: Limit idle_balance() when it is being used too
 frequently
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
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
Date: Wed, 17 Jul 2013 01:11:41 -0700
In-Reply-To: <20130717072504.GY17211@twins.programming.kicks-ass.net>
References: <1374002463.3944.11.camel@j-VirtualBox>
	 <20130716202015.GX17211@twins.programming.kicks-ass.net>
	 <1374014881.2332.21.camel@j-VirtualBox>
	 <20130717072504.GY17211@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-17 at 09:25 +0200, Peter Zijlstra wrote:
> On Tue, Jul 16, 2013 at 03:48:01PM -0700, Jason Low wrote:
> > On Tue, 2013-07-16 at 22:20 +0200, Peter Zijlstra wrote:
> > > On Tue, Jul 16, 2013 at 12:21:03PM -0700, Jason Low wrote:
> > > > When running benchmarks on an 8 socket 80 core machine with a 3.10 kernel,
> > > > there can be a lot of contention in idle_balance() and related functions.
> > > > On many AIM7 workloads in which CPUs go idle very often and idle balance
> > > > gets called a lot, it is actually lowering performance.
> > > > 
> > > > Since idle balance often helps performance (when it is not overused), I
> > > > looked into trying to avoid attempting idle balance only when it is
> > > > occurring too frequently.
> > > > 
> > > > This RFC patch attempts to keep track of the approximate "average" time between
> > > > idle balance attempts per CPU. Each time the idle_balance() function is
> > > > invoked, it will compute the duration since the last idle_balance() for
> > > > the current CPU. The avg time between idle balance attempts is then updated
> > > > using a very similar method as how rq->avg_idle is computed. 
> > > > 
> > > > Once the average time between idle balance attempts drops below a certain
> > > > value (which in this patch is sysctl_sched_idle_balance_limit), idle_balance
> > > > for that CPU will be skipped. The average time between idle balances will
> > > > continue to be updated, even if it ends up getting skipped. The
> > > > initial/maximum average is set a lot higher though to make sure that the
> > > > avg doesn't fall below the threshold until the sample size is large and to
> > > > prevent the avg from being overestimated.
> > > 
> > > One of the things I've been talking about for a while now is how I'd
> > > like to use the idle guestimator used for cpuidle for newidle balance.
> > > 
> > > Basically based on the estimated idle time limit how far/wide you'll
> > > search for tasks to run.
> > > 
> > > You can remove the sysctl and auto-tune by measuring how long it takes
> > > on avg to do a newidle balance.
> > 
> > Hi Peter,
> > 
> > When you say how long it takes on avg to do a newidle balance, are you
> > referring to the avg time it takes for each call to CPU_NEWLY_IDLE
> > load_balance() to complete, or the avg time it takes for newidle balance
> > attempts within a domain to eventually successfully pull/move a task(s)?
> 
> Both :-), being as the completion time would be roughly equivalent for the
> top domain and the entire call.
> 
> So I suppose I was somewhat unclear :-) I initially started out with a
> simpler model, where you measure the avg time of the entire
> idle_balance() call and measure the avg idle time and compare the two.
> 
> Then I progressed to the more complex model where you measure the
> completion time of each domain in the for_each_domain() iteration of
> idle_balance() and compare that against the estimated idle time, bailing
> out of the domain iteration when the avg completion time exceeds the
> expected idle time.

Hi Peter,

For the more complex model, are you suggesting that each completion time
is the time it takes to complete 1 iteration of the for_each_domain()
loop? 

Based on some of the data I collected, a single iteration of the
for_each_domain() loop is almost always significantly lower than the
approximate CPU idle time, even in workloads where idle_balance is
lowering performance. The bigger issue is that it takes so many of these
attempts before idle_balance actually "worked" and pulls a tasks.

I initially was thinking about each "completion time" of an idle balance
as the sum total of the times of all iterations to complete until a task
is successfully pulled within each domain.

Jason

