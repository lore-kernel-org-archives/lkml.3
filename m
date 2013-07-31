Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759228Ab3GaJx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 05:53:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45148 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758896Ab3GaJx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 05:53:27 -0400
Date: Wed, 31 Jul 2013 11:53:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: Ingo Molnar <mingo@redhat.com>, KML <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH] sched: Reduce overestimating avg_idle
Message-ID: <20130731095306.GY3008@twins.programming.kicks-ass.net>
References: <1375263472.3922.26.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375263472.3922.26.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 02:37:52AM -0700, Jason Low wrote:
> The avg_idle value may sometimes be overestimated, which may cause new idle
> load balance to be attempted more often than it should. Currently, when
> avg_idle gets updated, if the delta exceeds some max value (default 1000000 ns),
> the entire avg gets set to the max value, regardless of what the previous avg
> was. So if a CPU remains idle for 200,000 ns most of the time, and if the CPU
> goes idle for 1,200,000 ns, the average is then pushed up to 1,000,000 ns when
> it should be less.
> 
> Additionally, once the avg_idle is at its max, it may take a while to pull the
> avg down to a value that it should be. In the above example, after the avg idle
> is set the max value of 1000000 ns, the CPU's idle durations needs to
> be 200000 ns for the next 8 occurrences before the avg falls below the migration
> cost value.
> 
> This patch attempts to avoid these situations by always updating the avg_idle
> value first with the function call to update_avg(). Then, if the avg_idle
> exceeds the max avg value, the avg gets set to the max. Also, this patch lowers
> the max avg_idle value to migration_cost * 1.5 instead of migration_cost * 2 to
> reduce the time it takes to pull the avg idle to a lower value after long idles.

Indeed, this seems quite sensible.

> With this change, I got some decent performance boosts in AIM7 workloads on an
> 8 socket machine on the 3.10 kernel. In particular, it boosted the AIM7 fserver
> workload by about 20% when running it with a high # of users.

Nice :-)

> An avg_idle related question that I have is does migration_cost in idle balance
> need to be the same as the migration_cost in task_hot()? Can we keep
> migration_cost default value used in task_hot() the same, but have a different
> default value or increase migration_cost only when comparing it with avg_idle in
> idle balance?

No they're quite unrelated. I think you can measure the max time we've
ever spend in newidle balance and use that to clip the values.

Similarly, I've thought about how we updated the sd->avg_cost in the
previous patches and wondered if we should not track max_cost.

The 'only' down-side I could come up with is that its all ran from
SoftIRQ context which means IRQ/NMI/SMI can all stretch/warp the time it
takes to actually do the idle balance.

The idea behind using the max is that we want to reduce the chance we
overrun the averages and consume time we should have spend doing useful
work.
