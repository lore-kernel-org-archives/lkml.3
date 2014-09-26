Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbaIZP5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 11:57:42 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:38177 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268AbaIZP5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 11:57:41 -0400
Date: Fri, 26 Sep 2014 16:58:03 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "riel@redhat.com" <riel@redhat.com>, "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "pjt@google.com" <pjt@google.com>,
        "bsegall@google.com" <bsegall@google.com>
Subject: Re: [PATCH v6 4/6] sched: get CPU's usage statistic
Message-ID: <20140926155803.GA23693@e103034-lin>
References: <1411488485-10025-1-git-send-email-vincent.guittot@linaro.org>
 <1411488485-10025-5-git-send-email-vincent.guittot@linaro.org>
 <54246791.9050101@arm.com>
 <CAKfTPtCzVRY4q184nqHSL7zFh1CvF009p8q8EPFCZxDFMx9TeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtCzVRY4q184nqHSL7zFh1CvF009p8q8EPFCZxDFMx9TeQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 01:17:43PM +0100, Vincent Guittot wrote:
> On 25 September 2014 21:05, Dietmar Eggemann <dietmar.eggemann@arm.com> wrote:
> > On 23/09/14 17:08, Vincent Guittot wrote:
> >> Monitor the usage level of each group of each sched_domain level. The usage is
> >> the amount of cpu_capacity that is currently used on a CPU or group of CPUs.
> >> We use the utilization_load_avg to evaluate the usage level of each group.
> >>
> >> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> >> ---
> >>  kernel/sched/fair.c | 13 +++++++++++++
> >>  1 file changed, 13 insertions(+)
> >>
> >> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> >> index 2cf153d..4097e3f 100644
> >> --- a/kernel/sched/fair.c
> >> +++ b/kernel/sched/fair.c
> >> @@ -4523,6 +4523,17 @@ static int select_idle_sibling(struct task_struct *p, int target)
> >>       return target;
> >>  }
> >>
> >> +static int get_cpu_usage(int cpu)
> >> +{
> >> +     unsigned long usage = cpu_rq(cpu)->cfs.utilization_load_avg;
> >> +     unsigned long capacity = capacity_orig_of(cpu);
> >> +
> >> +     if (usage >= SCHED_LOAD_SCALE)
> >> +             return capacity + 1;
> >
> > Why you are returning rq->cpu_capacity_orig + 1 (1025) in case
> > utilization_load_avg is greater or equal than 1024 and not usage or
> > (usage * capacity) >> SCHED_LOAD_SHIFT too?
> 
> The usage can't be higher than the full capacity of the CPU because
> it's about the running time on this CPU. Nevertheless, usage can be
> higher than SCHED_LOAD_SCALE because of unfortunate rounding in
> avg_period and running_load_avg or just after migrating tasks until
> the average stabilizes with the new running time.

I fully agree that the cpu usage should be capped to capacity, but why
do you return capacity + 1? I would just return capacity, no?

Now that you have gotten rid of 'usage' everywhere else, shouldn't this
function be renamed to get_cpu_utilization()?
