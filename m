Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487Ab3GQHZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 03:25:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56295 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab3GQHZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 03:25:27 -0400
Date: Wed, 17 Jul 2013 09:25:04 +0200
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
Message-ID: <20130717072504.GY17211@twins.programming.kicks-ass.net>
References: <1374002463.3944.11.camel@j-VirtualBox>
 <20130716202015.GX17211@twins.programming.kicks-ass.net>
 <1374014881.2332.21.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374014881.2332.21.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 03:48:01PM -0700, Jason Low wrote:
> On Tue, 2013-07-16 at 22:20 +0200, Peter Zijlstra wrote:
> > On Tue, Jul 16, 2013 at 12:21:03PM -0700, Jason Low wrote:
> > > When running benchmarks on an 8 socket 80 core machine with a 3.10 kernel,
> > > there can be a lot of contention in idle_balance() and related functions.
> > > On many AIM7 workloads in which CPUs go idle very often and idle balance
> > > gets called a lot, it is actually lowering performance.
> > > 
> > > Since idle balance often helps performance (when it is not overused), I
> > > looked into trying to avoid attempting idle balance only when it is
> > > occurring too frequently.
> > > 
> > > This RFC patch attempts to keep track of the approximate "average" time between
> > > idle balance attempts per CPU. Each time the idle_balance() function is
> > > invoked, it will compute the duration since the last idle_balance() for
> > > the current CPU. The avg time between idle balance attempts is then updated
> > > using a very similar method as how rq->avg_idle is computed. 
> > > 
> > > Once the average time between idle balance attempts drops below a certain
> > > value (which in this patch is sysctl_sched_idle_balance_limit), idle_balance
> > > for that CPU will be skipped. The average time between idle balances will
> > > continue to be updated, even if it ends up getting skipped. The
> > > initial/maximum average is set a lot higher though to make sure that the
> > > avg doesn't fall below the threshold until the sample size is large and to
> > > prevent the avg from being overestimated.
> > 
> > One of the things I've been talking about for a while now is how I'd
> > like to use the idle guestimator used for cpuidle for newidle balance.
> > 
> > Basically based on the estimated idle time limit how far/wide you'll
> > search for tasks to run.
> > 
> > You can remove the sysctl and auto-tune by measuring how long it takes
> > on avg to do a newidle balance.
> 
> Hi Peter,
> 
> When you say how long it takes on avg to do a newidle balance, are you
> referring to the avg time it takes for each call to CPU_NEWLY_IDLE
> load_balance() to complete, or the avg time it takes for newidle balance
> attempts within a domain to eventually successfully pull/move a task(s)?

Both :-), being as the completion time would be roughly equivalent for the
top domain and the entire call.

So I suppose I was somewhat unclear :-) I initially started out with a
simpler model, where you measure the avg time of the entire
idle_balance() call and measure the avg idle time and compare the two.

Then I progressed to the more complex model where you measure the
completion time of each domain in the for_each_domain() iteration of
idle_balance() and compare that against the estimated idle time, bailing
out of the domain iteration when the avg completion time exceeds the
expected idle time.

One thing that I thought of since is that we need to consider what
happens for people with a low resolution sched_clock. IIRC there are
still platforms that are jiffy based.
