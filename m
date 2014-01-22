Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbaAVNwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 08:52:46 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56149 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbaAVNwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 08:52:45 -0500
Date: Wed, 22 Jan 2014 14:51:59 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Luca Abeni <luca.abeni@unitn.it>
Cc: Henrik Austad <henrik@austad.us>, Juri Lelli <juri.lelli@gmail.com>,
        tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org, bruce.ashfield@windriver.com,
        rob@landley.net
Subject: Re: [PATCH] sched/deadline: Add sched_dl documentation
Message-ID: <20140122135159.GQ31570@twins.programming.kicks-ass.net>
References: <20140120112442.GA8907@austad.us>
 <52DD1377.5090201@gmail.com>
 <20140120131616.GB8907@austad.us>
 <52DD2711.9080504@unitn.it>
 <20140121102016.GA12002@austad.us>
 <52DE5B7F.8020900@unitn.it>
 <20140121123334.GJ30183@twins.programming.kicks-ass.net>
 <52DE6D21.1080602@unitn.it>
 <20140121135559.GK30183@twins.programming.kicks-ass.net>
 <52DFC196.7020301@unitn.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DFC196.7020301@unitn.it>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 02:03:18PM +0100, Luca Abeni wrote:
> >At which point I feel obliged to mention the work Jim did on statistical
> >bounded tardiness and a potential future option:
> >SCHED_FLAG_DL_AVG_RUNTIME, where we would allow tasks to somewhat exceed
> >their runtime budget provided that they meet their budget on average.

> I think I read the paper your refer to, and if I remember well it was about
> an analysis technique (using some math from queuing theory to get estimations
> of the average response time, and then using Tchebysheff to transform this result
> in a probabilistic real-time guarantee)... If I understand well, it does not
> require modifications to the scheduling algorithm (the paper presents a multiprocessor
> reservation-based scheduling algorithm, but the presented analysis applies to every
> reservation-based algorithm, including SCHED_DEADLINE without modifications).
> Am I misunderstanding something?

I must admit to not actually having read that paper; Jim talked me
through the result at some time, but yes that sounds about right.

The only thing we need to do is enforce some 'avg' on the input
(scheduling parameters) such that we are guaranteed an avg on the output
(tardiness).

And we must enforce the input because we cannot trust userspace to
actually do what it says; if it were to go overboard we'd loose all
bounds.

> Anyway, I'll propose a documentation patch adding this paper to the references
> (and if you agree I can also add some other references to probabilistic guarantees).

Right, something for the future though.

> The SCHED_FLAG_DL_AVG_RUNTIME idea also looks interesting.

Right, like said above, because we cannot trust userspace we must
enforce that the input is indeed a bounded avg, otherwise the guarantees
do not hold.

> >Another possibly extension; one proposed by Ingo; is to demote tasks to
> >SCHED_OTHER once they exceed their budget instead of the full block they
> >get now -- we could possibly call this SCHED_FLAG_DL_CBS_SOFT or such.

> I think something similar to this was mentioned in the original "resource kernels"
> paper by Rajkumar and others... It is in general very useful.

Right, esp. so when we allow unpriv. access to SCHED_DEADLINE, more on
that below.

> Another extension I implemented "locally" (but I never submitted patches because
> it is "dangerous" and potentially controversial) is the original CBS behaviour:
> when a task is depleted, do not make it unschedulable, but just postpone its
> scheduling deadline (decreasing its priority) and immediately recharge the
> runtime. This still preserves temporal isolation between SCHED_DEADLINE tasks,
> but can cause starvation of non-SCHED_DEADLINE tasks (and this is why I say this
> is dangerous and can be controversial), but can be useful in some situations.

Right, we could actually implement that but always require CAP_ADMIN if
set.

We should also again talk about what it would take to allow
unprivileged access to SCHED_DEADLINE. The things I can remember are the
obvious cap on utilization and a minimum period -- the latter so that we
don't DoS the system with a metric ton of tiny tasks.

But I seem to remember there were a few other issues.

> 
> >And of course SCHED_FLAG_DL_CBS_SIGNAL, where the task gets a signal
> >delivered if it exceeded the runtime -- I think some of the earlier
> >patches had things like this, no?
> I've seen this in some patchset, but I do not remember when. I think some of
> the "advanced features" have been removed from the first submission.

Exactly, so. Now that we have the simple stuff settled, we can again
look at the more advanced features if there's potential users.
