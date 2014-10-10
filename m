Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbaJJHrI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 03:47:08 -0400
Received: from mail-oi0-f49.google.com ([209.85.218.49]:50986 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbaJJHrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 03:47:04 -0400
MIME-Version: 1.0
In-Reply-To: <20141009153025.GY10832@worktop.programming.kicks-ass.net>
References: <1412684017-16595-1-git-send-email-vincent.guittot@linaro.org>
 <1412684017-16595-3-git-send-email-vincent.guittot@linaro.org>
 <20141009112352.GO4750@worktop.programming.kicks-ass.net> <CAKfTPtABoQFQfufYK+hTd96ufQT83uypedzuZOeWjnUd51AbaQ@mail.gmail.com>
 <20141009153025.GY10832@worktop.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Fri, 10 Oct 2014 09:46:42 +0200
Message-ID: <CAKfTPtD0se5uVJPcQE-Rh-O+GTLmjY1rHH1AcrCLSTbcXSbuqw@mail.gmail.com>
Subject: Re: [PATCH v7 2/7] sched: move cfs task on a CPU with higher capacity
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 October 2014 17:30, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Oct 09, 2014 at 04:59:36PM +0200, Vincent Guittot wrote:
>> On 9 October 2014 13:23, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Tue, Oct 07, 2014 at 02:13:32PM +0200, Vincent Guittot wrote:
>> >> +++ b/kernel/sched/fair.c
>> >> @@ -5896,6 +5896,18 @@ fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
>> >>  }
>> >>
>> >>  /*
>> >> + * Check whether the capacity of the rq has been noticeably reduced by side
>> >> + * activity. The imbalance_pct is used for the threshold.
>> >> + * Return true is the capacity is reduced
>> >> + */
>> >> +static inline int
>> >> +check_cpu_capacity(struct rq *rq, struct sched_domain *sd)
>> >> +{
>> >> +     return ((rq->cpu_capacity * sd->imbalance_pct) <
>> >> +                             (rq->cpu_capacity_orig * 100));
>> >> +}
>> >> +
>> >> +/*
>> >>   * Group imbalance indicates (and tries to solve) the problem where balancing
>> >>   * groups is inadequate due to tsk_cpus_allowed() constraints.
>> >>   *
>> >> @@ -6567,6 +6579,14 @@ static int need_active_balance(struct lb_env *env)
>> >>                */
>> >>               if ((sd->flags & SD_ASYM_PACKING) && env->src_cpu > env->dst_cpu)
>> >>                       return 1;
>> >> +
>> >> +             /*
>> >> +              * The src_cpu's capacity is reduced because of other
>> >> +              * sched_class or IRQs, we trig an active balance to move the
>> >> +              * task
>> >> +              */
>> >> +             if (check_cpu_capacity(env->src_rq, sd))
>> >> +                     return 1;
>> >>       }
>> >
>> > So does it make sense to first check if there's a better candidate at
>> > all? By this time we've already iterated the current SD while trying
>> > regular load balancing, so we could know this.
>>
>> i'm not sure to completely catch your point.
>> Normally, f_b_g and f_b_q have already looked at the best candidate
>> when we call need_active_balance. And src_cpu has been elected.
>> Or i have missed your point ?
>
> Yep you did indeed miss my point.
>
> So I've always disliked this patch for its arbitrary nature, why
> unconditionally try and active balance every time there is 'some' RT/IRQ
> usage, it could be all CPUs are over that arbitrary threshold and we'll
> end up active balancing for no point.
>
> So, since we've already iterated all CPUs in our domain back in
> update_sd_lb_stats() we could have computed the CFS fraction:
>
>         1024 * capacity / capacity_orig
>
> for every cpu and collected the min/max of this. Then we can compute if
> src is significantly (and there I suppose we can indeed use imb)
> affected compared to others.

ok, so we should put additional check in f_b_g to be sure that we will
 jump to force_balance only if there will be a real gain by moving the
task on the local group (from an available capacity for the task point
of view)
and probably in f_b_q too

>
>
