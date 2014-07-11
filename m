Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbaGKQNw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:13:52 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:37319 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753503AbaGKQNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:13:48 -0400
Date: Fri, 11 Jul 2014 17:13:44 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>
Subject: Re: [PATCH v3 09/12] Revert "sched: Put rq's sched_avg under
 CONFIG_FAIR_GROUP_SCHED"
Message-ID: <20140711161344.GD26542@e103034-lin>
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
 <1404144343-18720-10-git-send-email-vincent.guittot@linaro.org>
 <20140710131646.GB3935@laptop>
 <CAKfTPtDzxyrzVmX016VB8j_y19wcCBVB1Rj46FYngMA+Ajft6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtDzxyrzVmX016VB8j_y19wcCBVB1Rj46FYngMA+Ajft6g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 08:51:06AM +0100, Vincent Guittot wrote:
> On 10 July 2014 15:16, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Mon, Jun 30, 2014 at 06:05:40PM +0200, Vincent Guittot wrote:
> >> This reverts commit f5f9739d7a0ccbdcf913a0b3604b134129d14f7e.
> >>
> >> We are going to use runnable_avg_sum and runnable_avg_period in order to get
> >> the utilization of the CPU. This statistic includes all tasks that run the CPU
> >> and not only CFS tasks.
> >
> > But this rq->avg is not the one that is migration aware, right? So why
> > use this?
> 
> Yes, it's not the one that is migration aware
> 
> >
> > We already compensate cpu_capacity for !fair tasks, so I don't see why
> > we can't use the migration aware one (and kill this one as Yuyang keeps
> > proposing) and compensate with the capacity factor.
> 
> The 1st point is that cpu_capacity is compensated by both !fair_tasks
> and frequency scaling and we should not take into account frequency
> scaling for detecting overload
> 
> What we have now is the the weighted load avg that is the sum of the
> weight load of entities on the run queue. This is not usable to detect
> overload because of the weight. An unweighted version of this figure
> would be more usefull but it's not as accurate as the one I use IMHO.

IMHO there is no perfect utilization metric, but I think it is
fundamentally wrong to use a metric that is migration unaware to make
migration decisions. I mentioned that during the last review as well. It
is like having a very fast controller with a really slow (large delay)
feedback loop. There is a high risk of getting an unstable balance when
you load-balance rate is faster than the feedback delay.

> The example that has been discussed during the review of the last
> version has shown some limitations
> 
> With the following schedule pattern from Morten's example
> 
>    | 5 ms | 5 ms | 5 ms | 5 ms | 5 ms | 5 ms | 5 ms | 5 ms | 5 ms |
> A:   run     rq     run  ----------- sleeping -------------  run
> B:   rq      run    rq    run   ---- sleeping -------------  rq
> 
> The scheduler will see the following values:
> Task A unweighted load value is 47%
> Task B unweight load is 60%
> The maximum Sum of unweighted load is 104%
> rq->avg load is 60%
> 
> And the real CPU load is 50%
> 
> So we will have opposite decision depending of the used values: the
> rq->avg or the Sum of unweighted load
> 
> The sum of unweighted load has the main advantage of showing
> immediately what will be the relative impact of adding/removing a
> task. In the example, we can see that removing task A or B will remove
> around half the CPU load but it's not so good for giving the current
> utilization of the CPU

You forgot to mention the issues with rq->avg that were brought up last
time :-)

Here is an load-balancing example:

Task A, B, C, and D are all running/runnable constantly. To avoid
decimals we assume the sched tick to have a 9 ms period. We have four
cpus in a single sched_domain.

rq == rq->avg
uw == unweighted tracked load

cpu0:
    | 3 ms | 3 ms | 3 ms | 3 ms | 3 ms | 3 ms | 3 ms | 3 ms | 3 ms |
 A:   run    rq     rq
 B:   rq     run    rq
 C:   rq     rq     run
 D:   rq     rq     rq     run    run    run    run    run    run
rq:  100%    100%   100%   100%   100%   100%   100%   100%   100%
uw:  400%    400%   400%   100%   100%   100%   100%   100%   100%

cpu1:
    | 3 ms | 3 ms | 3 ms | 3 ms | 3 ms | 3 ms | 3 ms | 3 ms | 3 ms |
 A:                        run    rq     run    rq     run    rq
 B:                        rq     run    rq     run    rq     run
 C:
 D:
rq:    0%      0%     0%     0%     6%    12%    18%    23%    28%
uw:    0%      0%     0%   200%   200%   200%   200%   200%   200%

cpu2:
    | 3 ms | 3 ms | 3 ms | 3 ms | 3 ms | 3 ms | 3 ms | 3 ms | 3 ms |
 A: 
 B:
 C:                        run    run    run    run    run    run
 D:
rq:    0%      0%     0%     0%     6%    12%    18%    23%    28%
uw:    0%      0%     0%   100%   100%   100%   100%   100%   100%

cpu3:
    | 3 ms | 3 ms | 3 ms | 3 ms | 3 ms | 3 ms | 3 ms | 3 ms | 3 ms |
 A: 
 B:
 C:
 D:
rq:    0%      0%     0%     0%     0%     0%     0%     0%     0%
uw:    0%      0%     0%     0%     0%     0%     0%     0%     0%

A periodic load-balance occurs on cpu1 after 9 ms. cpu0 rq->avg
indicates overload. Consequently cpu1 pulls task A and B.

Shortly after (<1 ms) cpu2 does a periodic load-balance. cpu0 rq->avg
hasn't changed so cpu0 still appears overloaded. cpu2 pulls task C.

Shortly after (<1 ms) cpu3 does a periodic load-balance. cpu0 rq->avg
still indicates overload so cpu3 tries to pull tasks but fails since
there is only task D left.

9 ms later the sched tick causes periodic load-balances on all the cpus.
cpu0 rq->avg still indicates that it has the highest load since cpu1
rq->avg has not had time to indicate overload. Consequently cpu1, 2,
and 3 will try to pull from that and fail. The balance will only change
once cpu1 rq->avg has increased enough to indicate overload.

Unweighted load will on the other hand indicate the load changes
instantaneously, so cpu3 would observe the overload of cpu1 immediately
and pull task A or B.

In this example using rq->avg leads to imbalance whereas unweighted load
would not. Correct me if I missed anything.

Coming back to the previous example. I'm not convinced that inflation of
the unweighted load sum when tasks overlap in time is a bad thing. I
have mentioned this before. The average cpu utilization over the 40ms
period is 50%. However the true compute capacity demand is 200% for the
first 15ms of the period, 100% for the next 5ms and 0% for the remaining
25ms. The cpu is actually overloaded for 15ms every 40ms. This fact is
factored into the unweighted load whereas rq->avg would give you the
same utilization no matter if the tasks are overlapped or not. Hence
unweighted load would give us an indication that the mix of tasks isn't
optimal even if the cpu has spare cycles.

If you don't care about overlap and latency, the unweighted sum of task
running time (that Peter has proposed a number of times) is better
metric, IMHO. As long the cpu isn't fully utilized.

Morten
