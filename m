Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397Ab3GQP7I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 11:59:08 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:1811 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280Ab3GQP7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 11:59:06 -0400
Message-ID: <1374076741.7412.35.camel@j-VirtualBox>
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
Date: Wed, 17 Jul 2013 08:59:01 -0700
In-Reply-To: <20130717093913.GP23818@dyad.programming.kicks-ass.net>
References: <1374002463.3944.11.camel@j-VirtualBox>
	 <20130716202015.GX17211@twins.programming.kicks-ass.net>
	 <1374014881.2332.21.camel@j-VirtualBox>
	 <20130717072504.GY17211@twins.programming.kicks-ass.net>
	 <1374048701.6000.21.camel@j-VirtualBox>
	 <20130717093913.GP23818@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Wed, 2013-07-17 at 11:39 +0200, Peter Zijlstra wrote:
> On Wed, Jul 17, 2013 at 01:11:41AM -0700, Jason Low wrote:
> > For the more complex model, are you suggesting that each completion time
> > is the time it takes to complete 1 iteration of the for_each_domain()
> > loop? 
> 
> Per sd, yes? So higher domains (or lower depending on how you model the thing
> in you head) have bigger CPU spans, and thus take longer to complete. Imagine
> the top domain of a 4096 cpu system, it would go look at all cpus to see if it
> could find a task.
> 
> > Based on some of the data I collected, a single iteration of the
> > for_each_domain() loop is almost always significantly lower than the
> > approximate CPU idle time, even in workloads where idle_balance is
> > lowering performance. The bigger issue is that it takes so many of these
> > attempts before idle_balance actually "worked" and pulls a tasks.
> 
> I'm confused, so:
> 
>   schedule()
>     if (!rq->nr_running)
>       idle_balance()
>         for_each_domain(sd)
>           load_balance(sd)
> 
> is the entire thing, there's no other loop in there.

So if we have the following: 

for_each_domain(sd)
	before = sched_clock_cpu
	load_balance(sd)
	after = sched_clock_cpu
	idle_balance_completion_time = after - before

At this point, the "idle_balance_completion_time" is usually a very
small value and is usually a lot smaller than the avg CPU idle time.
However, the vast majority of the time, load_balance returns 0.

> > I initially was thinking about each "completion time" of an idle balance
> > as the sum total of the times of all iterations to complete until a task
> > is successfully pulled within each domain.
> 
> So you're saying that normally idle_balance() won't find a task to pull? And we
> need many times going newidle before we do get something?

Yes, a while ago, I collected some data on the rate in which
idle_balance() does not pull tasks, and it was a very high number.

> Wouldn't this mean that there simply weren't enough tasks to keep all cpus busy?

If I remember correctly, in a lot of those load_balance attempts when
the machine is under a high Java load, there were no "imbalance" between
the groups in each sched_domain.

> If there were tasks we could've pulled, we might need to look at why they
> weren't and maybe fix that. Now it could be that it things this cpu, even with
> the (little) idle time it has is sufficiently loaded and we'll get a 'local'
> wakeup soon enough. That's perfectly fine.
> 
> What we should avoid is spending more time looking for tasks then we have idle,
> since that reduces the total time we can spend doing useful work. So that is I
> think the critical cut-off point.

Do you think its worth a try to consider each newidle balance attempt as
the total load_balance attempts until it is able to move a task, and
then skip balancing within the domain if a CPU's avg idle time is less
than that avg time doing newidle balance? 

Thanks,
Jason

