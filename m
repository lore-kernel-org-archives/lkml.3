Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbaJIPMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 11:12:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:40677 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbaJIPMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 11:12:16 -0400
Date: Thu, 9 Oct 2014 17:12:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
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
Subject: Re: [PATCH v7 5/7] sched: get CPU's usage statistic
Message-ID: <20141009151211.GV10832@worktop.programming.kicks-ass.net>
References: <1412684017-16595-1-git-send-email-vincent.guittot@linaro.org>
 <1412684017-16595-6-git-send-email-vincent.guittot@linaro.org>
 <20141009113614.GP4750@worktop.programming.kicks-ass.net>
 <CAKfTPtDtfhQDWNjU5i-YpX4-Ak3nT3uaOCvhqgNP-u=-La7_gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtDtfhQDWNjU5i-YpX4-Ak3nT3uaOCvhqgNP-u=-La7_gw@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 03:57:28PM +0200, Vincent Guittot wrote:
> On 9 October 2014 13:36, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, Oct 07, 2014 at 02:13:35PM +0200, Vincent Guittot wrote:
> >> Monitor the usage level of each group of each sched_domain level. The usage is
> >> the amount of cpu_capacity that is currently used on a CPU or group of CPUs.
> >> We use the utilization_load_avg to evaluate the usage level of each group.
> >>
> >> The utilization_avg_contrib only takes into account the running time but not
> >> the uArch so the utilization_load_avg is in the range [0..SCHED_LOAD_SCALE]
> >> to reflect the running load on the CPU. We have to scale the utilization with
> >> the capacity of the CPU to get the usage of the latter. The usage can then be
> >> compared with the available capacity.
> >
> > You say cpu_capacity, but in actual fact you use capacity_orig and fail
> > to justify/clarify this.
> 
> you're right it's cpu_capacity_orig no cpu_capacity
> 
> cpu_capacity is the compute capacity available for CFS task once we
> have removed the capacity that is used by RT tasks.

But why, when you compare the sum of usage against the capacity you want
matching units. Otherwise your usage will far exceed capacity in the
presence of RT tasks, that doesn't seen to make sense to me.

> We want to compare the utilization of the CPU (utilization_avg_contrib
> which is in the range [0..SCHED_LOAD_SCALE]) with available capacity
> (cpu_capacity which is in the range [0..cpu_capacity_orig])
> An utilization_avg_contrib equals to SCHED_LOAD_SCALE means that the
> CPU is fully utilized so all cpu_capacity_orig are used. so we scale
> the utilization_avg_contrib from [0..SCHED_LOAD_SCALE] into cpu_usage
> in the range [0..cpu_capacity_orig]

Right, I got that, the usage thing converts from 'utilization' to
fraction of capacity, so that we can then compare it against the total
capacity.

But if, as per the above we were to use the same capacity for both
sides, its a pointless factor and we could've immediately compared the
'utilization' number against its unit.

> >> +static int get_cpu_usage(int cpu)
> >> +{
> >> +     unsigned long usage = cpu_rq(cpu)->cfs.utilization_load_avg;
> >> +     unsigned long capacity = capacity_orig_of(cpu);
> >> +
> >> +     if (usage >= SCHED_LOAD_SCALE)
> >> +             return capacity + 1;
> >
> > Like Morten I'm confused by that +1 thing.
> 
> ok. the goal was to point out the erroneous case where usage is out of
> the range but if it generates confusion, it can remove it

Well, the fact that you clip makes that point, returning a value outside
of the specified range doesn't.
