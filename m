Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab3GQJk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 05:40:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58998 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab3GQJk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 05:40:27 -0400
Date: Wed, 17 Jul 2013 11:39:13 +0200
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
Message-ID: <20130717093913.GP23818@dyad.programming.kicks-ass.net>
References: <1374002463.3944.11.camel@j-VirtualBox>
 <20130716202015.GX17211@twins.programming.kicks-ass.net>
 <1374014881.2332.21.camel@j-VirtualBox>
 <20130717072504.GY17211@twins.programming.kicks-ass.net>
 <1374048701.6000.21.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374048701.6000.21.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 01:11:41AM -0700, Jason Low wrote:
> For the more complex model, are you suggesting that each completion time
> is the time it takes to complete 1 iteration of the for_each_domain()
> loop? 

Per sd, yes? So higher domains (or lower depending on how you model the thing
in you head) have bigger CPU spans, and thus take longer to complete. Imagine
the top domain of a 4096 cpu system, it would go look at all cpus to see if it
could find a task.

> Based on some of the data I collected, a single iteration of the
> for_each_domain() loop is almost always significantly lower than the
> approximate CPU idle time, even in workloads where idle_balance is
> lowering performance. The bigger issue is that it takes so many of these
> attempts before idle_balance actually "worked" and pulls a tasks.

I'm confused, so:

  schedule()
    if (!rq->nr_running)
      idle_balance()
        for_each_domain(sd)
          load_balance(sd)

is the entire thing, there's no other loop in there.

> I initially was thinking about each "completion time" of an idle balance
> as the sum total of the times of all iterations to complete until a task
> is successfully pulled within each domain.

So you're saying that normally idle_balance() won't find a task to pull? And we
need many times going newidle before we do get something?

Wouldn't this mean that there simply weren't enough tasks to keep all cpus busy?

If there were tasks we could've pulled, we might need to look at why they
weren't and maybe fix that. Now it could be that it things this cpu, even with
the (little) idle time it has is sufficiently loaded and we'll get a 'local'
wakeup soon enough. That's perfectly fine.

What we should avoid is spending more time looking for tasks then we have idle,
since that reduces the total time we can spend doing useful work. So that is I
think the critical cut-off point.
