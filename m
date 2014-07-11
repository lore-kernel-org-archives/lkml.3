Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbaGKPNM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 11:13:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:41510 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbaGKPNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 11:13:10 -0400
Date: Fri, 11 Jul 2014 17:13:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [PATCH v3 09/12] Revert "sched: Put rq's sched_avg under
 CONFIG_FAIR_GROUP_SCHED"
Message-ID: <20140711151304.GD3935@laptop>
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
 <1404144343-18720-10-git-send-email-vincent.guittot@linaro.org>
 <20140710131646.GB3935@laptop>
 <CAKfTPtDzxyrzVmX016VB8j_y19wcCBVB1Rj46FYngMA+Ajft6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtDzxyrzVmX016VB8j_y19wcCBVB1Rj46FYngMA+Ajft6g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 09:51:06AM +0200, Vincent Guittot wrote:
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

dvfs could help? Also we should not use arch_scale_freq_capacity() for
things like cpufreq-ondemand etc. Because for those the compute capacity
is still the max. We should only use it when we hard limit things.

> What we have now is the the weighted load avg that is the sum of the
> weight load of entities on the run queue. This is not usable to detect
> overload because of the weight. An unweighted version of this figure
> would be more usefull but it's not as accurate as the one I use IMHO.
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

In that same discussion ISTR a suggestion about adding avg_running time,
as opposed to the current avg_runnable. The sum of avg_running should be
much more accurate, and still react correctly to migrations.


