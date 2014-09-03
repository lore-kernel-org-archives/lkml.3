Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935393AbaICXn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:43:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:10320 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934570AbaICXnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 19:43:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,461,1406617200"; 
   d="scan'208";a="568011476"
Message-ID: <1409787800.31585.26.camel@schen9-desk2.jf.intel.com>
Subject: Re: [PATCH v5 03/12] sched: fix avg_load computation
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Date: Wed, 03 Sep 2014 16:43:20 -0700
In-Reply-To: <CAKfTPtAt_X99p4KHNmZtVAnMdYm8_QLZ796WO+McqGf5RyM+iQ@mail.gmail.com>
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org>
	 <1409051215-16788-4-git-send-email-vincent.guittot@linaro.org>
	 <5401BCDF.3040503@linux.vnet.ibm.com>
	 <CAKfTPtAt_X99p4KHNmZtVAnMdYm8_QLZ796WO+McqGf5RyM+iQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-03 at 13:09 +0200, Vincent Guittot wrote:
> On 30 August 2014 14:00, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
> > Hi Vincent,
> >
> > On 08/26/2014 04:36 PM, Vincent Guittot wrote:
> >> The computation of avg_load and avg_load_per_task should only takes into
> >> account the number of cfs tasks. The non cfs task are already taken into
> >> account by decreasing the cpu's capacity and they will be tracked in the
> >> CPU's utilization (group_utilization) of the next patches
> >>
> >> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> >> ---
> >>  kernel/sched/fair.c | 4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> >> index 87b9dc7..b85e9f7 100644
> >> --- a/kernel/sched/fair.c
> >> +++ b/kernel/sched/fair.c
> >> @@ -4092,7 +4092,7 @@ static unsigned long capacity_of(int cpu)
> >>  static unsigned long cpu_avg_load_per_task(int cpu)
> >>  {
> >>       struct rq *rq = cpu_rq(cpu);
> >> -     unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
> >> +     unsigned long nr_running = ACCESS_ONCE(rq->cfs.h_nr_running);
> >>       unsigned long load_avg = rq->cfs.runnable_load_avg;
> >>
> >>       if (nr_running)
> >> @@ -5985,7 +5985,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
> >>                       load = source_load(i, load_idx);
> >>
> >>               sgs->group_load += load;
> >> -             sgs->sum_nr_running += rq->nr_running;
> >> +             sgs->sum_nr_running += rq->cfs.h_nr_running;
> >>
> >>               if (rq->nr_running > 1)
> >>                       *overload = true;
> >>
> >
> > Why do we probe rq->nr_running while we do load balancing? Should not we
> > be probing cfs_rq->nr_running instead? We are interested after all in
> > load balancing fair tasks right? The reason I ask this is, I was
> > wondering if we need to make the above similar change in more places in
> > load balancing.
> 
> Hi Preeti,
> 
> Yes, we should probably the test   rq->cfs.h_nr_running > 0 before
> setting overload.
> 

The overload indicator is used for knowing when we can totally avoid
load balancing to a cpu that is about to go idle.  
We can avoid load balancing when no cpu has more than 1 task.  So if you
have say just one fair task and multiple deadline tasks on a cpu,
and another cpu about to go idle, you should turn on normal load
balancing in the idle path by setting overload to true. 

So setting overload should be set based on rq->nr_running and not on
rq->cfs.h_nr_running. 

Thanks.
 
Tim


