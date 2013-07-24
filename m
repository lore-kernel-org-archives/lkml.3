Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab3GXHGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 03:06:37 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:20965 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab3GXHGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 03:06:35 -0400
Message-ID: <1374649590.2740.12.camel@j-VirtualBox>
Subject: Re: [RFC PATCH v2] sched: Limit idle_balance()
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
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
Date: Wed, 24 Jul 2013 00:06:30 -0700
In-Reply-To: <20130723110345.GX27075@twins.programming.kicks-ass.net>
References: <1374220211.5447.9.camel@j-VirtualBox>
	 <20130722070144.GC5138@linux.vnet.ibm.com>
	 <1374519467.7608.87.camel@j-VirtualBox>
	 <20130723110345.GX27075@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > Should we take the consideration of whether a idle_balance was
> > > successful or not?
> > 
> > I recently ran fserver on the 8 socket machine with HT-enabled and found
> > that load balance was succeeding at a higher than average rate, but idle
> > balance was still lowering performance of that workload by a lot.
> > However, it makes sense to allow idle balance to run longer/more often
> > when it has a higher success rate.
> > 
> > > I am not sure whats a reasonable value for n can be, but may be we could
> > > try with n=3.
> > 
> > Based on some of the data I collected, n = 10 to 20 provides much better
> > performance increases.
> 
> Right, so I'm still a bit puzzled by why this is so; maybe we're
> over-estimating the idle duration due to significant variance in the
> idle time?

This time, I also collected per domain stats on the number of load
balances that pulled a task(s) and the number of load balances that did
not pull tasks. Here are some of those numbers for a CPU when running
fserver at 8 socket Hyperthreading enabled:

CPU #2:
	| load balance	| load balance	|  # total	|  load balance
domain	| pulled task	| did not	|  attempts	|  success rate
	|		| pull tasks	|		|
--------------------------------------------------------------------------
  0	|  10574	|  175311	|  185885	|  5.69%
--------------------------------------------------------------------------
  1	|  18218	|  157092	|  175310	|  10.39%
--------------------------------------------------------------------------
  2	|  0		|  157092	|  157092	|  0%
--------------------------------------------------------------------------
  3	|  14858	|  142234	|  157092	|  9.46%
--------------------------------------------------------------------------
  4	|  8632		|  133602	|  142234	|  6.07%
--------------------------------------------------------------------------
  5	|  4570		|  129032	|  133602	|  3.42%

Note: The % load balance success rate can be a lot lower in some of the
other AIM7 workloads with 8 socket HT on.

In this case, most of the load balances which did not pull tasks were
either due to find_busiest_group() returning NULL or failing to move any
tasks after attempting to move task.

Based on this current data, one possible explanation for why average
load balance cost per domain can be a lot less than the avg CPU idle
time, yet idle balancing is still lowering performance, is because the
load balance success rate for some of these domains can be very small.
At the same time, there's still the overhead of doing
update_sd_lb_stats(), idle_cpu(), acquiring the rq->lock, ect...

So assume that the average cost of load balance on domain 0 is 30000 ns
and the CPU's average idle time is 500000 ns. The average cost of
attempting each balance on domain 0 is a lot less than the average time
the CPU remains idle. However, since load balance in domain 0 is useful
only 5.69% of the time, it is expected to pay (30000 ns / 0.0569) =
527240 ns worth of kernel time for every load balance that moved a
task(s) to this particular CPU. Additionally, domain 2 in this case is
essentially never moving tasks during its balance attempts, and so a
larger N means spending even less time balancing in a domain in which no
tasks ever gets moved.

Perhaps one of the metrics I may use for computing N is the balance
success rate for each sched domain. So in the above case, we give little
to no time for idle balancing within domain 2, but allow more time to be
spent balancing between domain 1 and domain 3 because the expected
return is greater?

Jason

