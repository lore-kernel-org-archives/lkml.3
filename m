Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbaIZHhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 03:37:20 -0400
Received: from mail-oi0-f47.google.com ([209.85.218.47]:60586 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbaIZHhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 03:37:17 -0400
MIME-Version: 1.0
In-Reply-To: <20140925172343.GX23693@e103034-lin>
References: <1411403047-32010-1-git-send-email-morten.rasmussen@arm.com>
 <1411403047-32010-2-git-send-email-morten.rasmussen@arm.com>
 <CAKfTPtBXP7HQBHL_Z3aAfdsuLP44_0x_e_LmzEw8qVC-2g=M-w@mail.gmail.com> <20140925172343.GX23693@e103034-lin>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Fri, 26 Sep 2014 09:36:53 +0200
Message-ID: <CAKfTPtDWyf_Y0Ga2D_i7QFEddfif7h+E+xZjK6iau7-6ngSrzA@mail.gmail.com>
Subject: Re: [PATCH 1/7] sched: Introduce scale-invariant load tracking
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 September 2014 19:23, Morten Rasmussen <morten.rasmussen@arm.com> wrote:

[snip]

>> >         /* Remainder of delta accrued against u_0` */
>> >         if (runnable)
>> > -               sa->runnable_avg_sum += delta;
>> > +               sa->runnable_avg_sum += (delta * scale_cap)
>> > +                               >> SCHED_CAPACITY_SHIFT;
>>
>> If we take the example of an always running task, its runnable_avg_sum
>> should stay at the LOAD_AVG_MAX value whatever the frequency of the
>> CPU on which it runs. But your change links the max value of
>> runnable_avg_sum with the current frequency of the CPU so an always
>> running task will have a load contribution of 25%
>> your proposed scaling is fine with usage_avg_sum which reflects the
>> effective running time on the CPU but the runnable_avg_sum should be
>> able to reach LOAD_AVG_MAX whatever the current frequency is
>
> I don't think it makes sense to scale one metric and not the other. You
> will end up with two very different (potentially opposite) views of the

you have missed my point, i fully agree that scaling in-variance is a
good enhancement but IIUC your patchset doesn't solve the whole
problem.

Let me try to explain with examples :
- A task with a load of 10% on a CPU at max frequency will keep a load
of  10% if the frequency of the CPU is divided by 2 which is fine
- But an always running task with a load of 100% on a CPU at max
frequency will have a load of 50% if the frequency of the CPU is
divided by 2 which is not what we want; the load of such task should
stay at 100%
- if we have 2 identical always running tasks on CPUs with different
frequency, their load will be different

So your patchset adds scaling invariance for small tasks but add some
scaling variances for heavy tasks

Regards,
Vincent


> cpu load/utilization situation in many scenarios. As I see it,
> scale-invariance and load-balancing with scale-invariance present can be
> done in two ways:
>
> 1. Leave runnable_avg_sum unscaled and scale running_avg_sum.
> se->avg.load_avg_contrib will remain unscaled and so will
> cfs_rq->runnable_load_avg, cfs_rq->blocked_load_avg, and
> weighted_cpuload(). Essentially all the existing load-balancing code
> will continue to use unscaled load. When we want to improve cpu
> utilization and energy-awareness we will have to bypass most of this
> code as it is likely to lead us on the wrong direction since it has a
> potentially wrong view of the cpu load due to the lack of
> scale-invariance.
>
> 2. Scale both runnable_avg_sum and running_avg_sum. All existing load
> metrics including weighted_cpuload() are scaled and thus more accurate.
> The difference between se->avg.load_avg_contrib and
> se->avg.usage_avg_contrib is the priority scaling and whether or not
> runqueue waiting time is counted. se->avg.load_avg_contrib can only
> reach se->load.weight when running on the fastest cpu at the highest
> frequency, but it is now scale-invariant so we have much better idea
> about how much load we are pulling when load-balancing two cpus running
> at different frequencies. The load-balance code-path still has to be
> audited to see if anything blows up due to the scaling. I haven't
> finished doing that yet. This patch set doesn't include patches to
> address such issues (yet). IMHO, by scaling runnable_avg_sum we can more
> easily make the existing load-balancing code do the right thing.
>
> For both options we have to go through the existing load-balancing code
> to either change it to use the scale-invariant metric (running_avg_sum)
> when appropriate or to fix bits that don't work properly with a
> scale-invariant runnable_avg_sum and reuse the existing code. I think
> the latter is less intrusive, but I might be wrong.
>
> Opinions?
>
> Morten
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
