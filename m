Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab3DZNiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 09:38:22 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:38319 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410Ab3DZNiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 09:38:21 -0400
MIME-Version: 1.0
In-Reply-To: <20130426123827.GB13464@dyad.programming.kicks-ass.net>
References: <1366910611-20048-1-git-send-email-vincent.guittot@linaro.org>
	<1366910611-20048-4-git-send-email-vincent.guittot@linaro.org>
	<20130426123827.GB13464@dyad.programming.kicks-ass.net>
Date: Fri, 26 Apr 2013 15:38:20 +0200
Message-ID: <CAKfTPtBe1Qu7mtao-i=MZj_c2ZBOk-3q7brn5fjx3_feQB4-GA@mail.gmail.com>
Subject: Re: [PATCH 03/14] sched: pack small tasks
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Ingo Molnar <mingo@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Turner <pjt@google.com>, Santosh <santosh.shilimkar@ti.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <len.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Lukasz Majewski <l.majewski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 April 2013 14:38, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Apr 25, 2013 at 07:23:19PM +0200, Vincent Guittot wrote:
>
>> +static bool is_buddy_busy(int cpu)
>> +{
>> +     struct rq *rq = cpu_rq(cpu);
>> +     u32 sum = rq->avg.runnable_avg_sum;
>> +     u32 period = rq->avg.runnable_avg_period;
>> +
>> +     /*
>> +      * If a CPU accesses the runnable_avg_sum and runnable_avg_period
>> +      * fields of its buddy CPU while the latter updates it, it can get the
>> +      * new version of a field and the old version of the other one. This
>> +      * can generate erroneous decisions. We don't want to use a lock
>> +      * mechanism for ensuring the coherency because of the overhead in
>> +      * this critical path.
>> +      * The runnable_avg_period of a runqueue tends to the max value in
>> +      * less than 345ms after plugging a CPU, which implies that we could
>> +      * use the max value instead of reading runnable_avg_period after
>> +      * 345ms. During the starting phase, we must ensure a minimum of
>> +      * coherency between the fields. A simple rule is runnable_avg_sum <=
>> +      * runnable_avg_period.
>> +      */
>> +     sum = min(sum, period);
>> +
>> +     /*
>> +      * A busy buddy is a CPU with a high load or a small load with a lot of
>> +      * running tasks.
>> +      */
>> +     return (sum > (period / (rq->nr_running + 2)));
>> +}
>
>
> I'm still not sold on the entire nr_running thing and the comment doesn't say
> why you're doing it.

The main goal is really to minimize the scheduling latency of tasks.
If the cpu already has dozens of task in its runqueue the scheduling
latency can become quite huge. In this case it's worth using another
core

>
> I'm fairly sure there's software out there that wakes a gazillion threads at a
> time only for a gazillion-1 to go back to sleep immediately. Patterns like that
> completely defeat your heuristic.
>
> Does that matter... I don't know.
>
> What happens if you keep this thing simple and only put a cap on utilization
> (say 80%) and drop the entire nr_running magic? Have you seen it make an actual
> difference or did it just seem like a good (TM) thing to do?

It was a efficient way

>
>> +static bool is_light_task(struct task_struct *p)
>> +{
>> +     /* A light task runs less than 20% in average */
>> +     return ((p->se.avg.runnable_avg_sum  * 5) <
>> +                     (p->se.avg.runnable_avg_period));
>> +}
>
> There superfluous () and ' ' in there. Also why 20%.. seemed like a good
> number? Do we want a SCHED_DEBUG sysctl for that?

I have chosen 20% because it will ensure that the packing mechanism
will only apply on tasks that match the 2 following conditions:
- less than 10 ms during the last single run
- and for those tasks less than 20% of the time in average

These tasks are nearly never catch by the periodic load balance and
they are so small that the overall scheduling latency is nearly not
impacted while the cpu is not too busy
