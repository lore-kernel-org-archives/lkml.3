Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbaE1PrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 11:47:15 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:57422 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753623AbaE1PrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 11:47:14 -0400
Date: Wed, 28 May 2014 16:47:03 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v2 08/11] sched: get CPU's activity statistic
Message-ID: <20140528154703.GJ19967@e103034-lin>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-9-git-send-email-vincent.guittot@linaro.org>
 <20140528121001.GI19967@e103034-lin>
 <CAKfTPtDxeBfZK1AxCRqEG91pi--Ti1RYFoQPDhvMVnGTCspQ-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtDxeBfZK1AxCRqEG91pi--Ti1RYFoQPDhvMVnGTCspQ-g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 02:15:03PM +0100, Vincent Guittot wrote:
> On 28 May 2014 14:10, Morten Rasmussen <morten.rasmussen@arm.com> wrote:
> > On Fri, May 23, 2014 at 04:53:02PM +0100, Vincent Guittot wrote:
> >> Monitor the activity level of each group of each sched_domain level. The
> >> activity is the amount of cpu_power that is currently used on a CPU or group
> >> of CPUs. We use the runnable_avg_sum and _period to evaluate this activity
> >> level. In the special use case where the CPU is fully loaded by more than 1
> >> task, the activity level is set above the cpu_power in order to reflect the
> >> overload of the CPU
> >>
> >> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> >> ---
> >>  kernel/sched/fair.c | 22 ++++++++++++++++++++++
> >>  1 file changed, 22 insertions(+)
> >>
> >> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> >> index b7c51be..c01d8b6 100644
> >> --- a/kernel/sched/fair.c
> >> +++ b/kernel/sched/fair.c
> >> @@ -4044,6 +4044,11 @@ static unsigned long power_of(int cpu)
> >>       return cpu_rq(cpu)->cpu_power;
> >>  }
> >>
> >> +static unsigned long power_orig_of(int cpu)
> >> +{
> >> +     return cpu_rq(cpu)->cpu_power_orig;
> >> +}
> >> +
> >>  static unsigned long cpu_avg_load_per_task(int cpu)
> >>  {
> >>       struct rq *rq = cpu_rq(cpu);
> >> @@ -4438,6 +4443,18 @@ done:
> >>       return target;
> >>  }
> >>
> >> +static int get_cpu_activity(int cpu)
> >> +{
> >> +     struct rq *rq = cpu_rq(cpu);
> >> +     u32 sum = rq->avg.runnable_avg_sum;
> >> +     u32 period = rq->avg.runnable_avg_period;
> >> +
> >> +     if (sum >= period)
> >> +             return power_orig_of(cpu) + rq->nr_running - 1;
> >> +
> >> +     return (sum * power_orig_of(cpu)) / period;
> >> +}
> >
> > The rq runnable_avg_{sum, period} give a very long term view of the cpu
> > utilization (I will use the term utilization instead of activity as I
> > think that is what we are talking about here). IMHO, it is too slow to
> > be used as basis for load balancing decisions. I think that was also
> > agreed upon in the last discussion related to this topic [1].
> >
> > The basic problem is that worst case: sum starting from 0 and period
> > already at LOAD_AVG_MAX = 47742, it takes LOAD_AVG_MAX_N = 345 periods
> > (ms) for sum to reach 47742. In other words, the cpu might have been
> > fully utilized for 345 ms before it is considered fully utilized.
> > Periodic load-balancing happens much more frequently than that.
> 
> I agree that it's not really responsive but several statistics of the
> scheduler use the same kind of metrics and have the same kind of
> responsiveness.

I might be wrong, but I don't think we use anything similar to this to
estimate cpu load/utilization for load-balancing purposes except for
{source, target}_load() where it is used to bias the decisions whether
or not to balance if the difference is small. That is what the
discussion was about last time.

> I agree that it's not enough and that's why i'm not using only this
> metric but it gives information that the unweighted load_avg_contrib
> (that you are speaking about below) can't give. So i would be less
> contrasted than you and would say that we probably need additional
> metrics

I'm not saying that we shouldn't this metric at all, I'm just saying
that I don't think it is suitable for estimating the short term view cpu
utilization which is what you need to make load-balancing decisions. We
can't observe the effect of recent load-balancing decisions if the
metric is too slow to react.

I realize that what I mean by 'slow' might be unclear. Load tracking
(both task and rq) takes a certain amount of history into account in
runnable_avg_{sum, period}. This amount is determined by the 'y'-weight,
which has been chosen such that we consider the load in the past 345
time units, where the time unit is ~1 ms. The contribution is smaller
the further you go back due to y^n, which diminishes to 0 for n > 345.
So, if a task or cpu goes from having been idle for >345 ms to being
constantly busy, it will take 345 ms until the entire history that we
care about will reflect this change. Only then runnable_avg_sum will
reach 47742. The rate of change is faster to begin with since the weight
of the most recent history is higher. runnable_avg_sum will get to
47742/2 in just 32 ms.

Since we may do periodic load-balance every 10 ms or so, we will perform
a number of load-balances where runnable_avg_sum will mostly be
reflecting the state of the world before a change (new task queued or
moved a task to a different cpu). If you had have two tasks continuously
on one cpu and your other cpu is idle, and you move one of the tasks to
the other cpu, runnable_avg_sum will remain unchanged, 47742, on the
first cpu while it starts from 0 on the other one. 10 ms later it will
have increased a bit, 32 ms later it will be 47742/2, and 345 ms later
it reaches 47742. In the mean time the cpu doesn't appear fully utilized
and we might decide to put more tasks on it because we don't know if
runnable_avg_sum represents a partially utilized cpu (for example a 50%
task) or if it will continue to rise and eventually get to 47742.

IMO, we need cpu utilization to clearly represent the current
utilization of the cpu such that any changes since the last wakeup or
load-balance are clearly visible.

> 
> >
> > Also, if load-balancing actually moves tasks around it may take quite a
> > while before runnable_avg_sum actually reflects this change. The next
> > periodic load-balance is likely to happen before runnable_avg_sum has
> > reflected the result of the previous periodic load-balance.
> 
> runnable_avg_sum uses a 1ms unit step so i tend to disagree with your
> point above

See explanation above. The important thing is how much history we take
into account. That is 345x 1 ms time units. The rate at which the sum is
updated doesn't have any change anything. 1 ms after a change (wakeup,
load-balance,...) runnable_avg_sum can only change by 1024. The
remaining ~98% of your weighted history still reflects the world before
the change.

> > To avoid these problems, we need to base utilization on a metric which
> > is updated instantaneously when we add/remove tasks to a cpu (or a least
> > fast enough that we don't see the above problems). In the previous
> > discussion [1] it was suggested that a sum of unweighted task
> > runnable_avg_{sum,period} ratio instead. That is, an unweighted
> > equivalent to weighted_cpuload(). That isn't a perfect solution either.
> 
> Regarding the unweighted load_avg_contrib, you will have similar issue
> because of the slowness in the variation of each sched_entity load
> that will be added/removed in the unweighted load_avg_contrib.
> 
> The update of the runnable_avg_{sum,period}  of an sched_entity is
> quite similar to cpu utilization.

Yes, runnable_avg_{sum, period} for tasks and rqs are exactly the same.
No difference there :)

> This value is linked to the CPU on
> which it has run previously because of the time sharing with others
> tasks, so the unweighted load of a freshly migrated task will reflect
> its load on the previous CPU (with the time sharing with other tasks
> on prev CPU).

I agree that the task runnable_avg_sum is always affected by the
circumstances on the cpu where it is running, and that it takes this
history with it. However, I think cfs.runnable_load_avg leads to less
problems than using the rq runnable_avg_sum. It would work nicely for
the two tasks on two cpus example I mentioned earlier. We don't need add
something on top when the cpu is fully utilized by more than one task.
It comes more naturally with cfs.runnable_load_avg. If it is much larger
than 47742, it should be fairly safe to assume that you shouldn't stick
more tasks on that cpu.

> 
> I'm not saying that such metric is useless but it's not perfect as well.

It comes with its own set of problems, agreed. Based on my current
understanding (or lack thereof) they just seem smaller :)

Morten
