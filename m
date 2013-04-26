Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab3DZLeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 07:34:36 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33904 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab3DZLed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 07:34:33 -0400
MIME-Version: 1.0
In-Reply-To: <20130426103019.GE8669@dyad.programming.kicks-ass.net>
References: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org>
	<1363955155-18382-4-git-send-email-vincent.guittot@linaro.org>
	<1364300782.5053.6.camel@laptop>
	<5152C83F.6060509@linux.vnet.ibm.com>
	<CAKfTPtCphgnT6_WSdHJR+_GcdfroL+OFhiqsr_rBFx5=apkTVQ@mail.gmail.com>
	<20130426103019.GE8669@dyad.programming.kicks-ass.net>
Date: Fri, 26 Apr 2013 13:34:32 +0200
Message-ID: <CAKfTPtAWctPEz+TO-zaJCYbn0m=3vahCJ6-jK65O5Qe06MfOXA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 3/6] sched: pack small tasks
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Ingo Molnar <mingo@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Turner <pjt@google.com>, Santosh <santosh.shilimkar@ti.com>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Alex Shi <alex.shi@intel.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <len.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 April 2013 12:30, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Mar 27, 2013 at 12:00:40PM +0100, Vincent Guittot wrote:
>> On 27 March 2013 11:21, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
>> > Hi,
>> >
>> > On 03/26/2013 05:56 PM, Peter Zijlstra wrote:
>> >> On Fri, 2013-03-22 at 13:25 +0100, Vincent Guittot wrote:
>> >>> +static bool is_buddy_busy(int cpu)
>> >>> +{
>> >>> +       struct rq *rq = cpu_rq(cpu);
>> >>> +
>> >>> +       /*
>> >>> +        * A busy buddy is a CPU with a high load or a small load with
>> >>> a lot of
>> >>> +        * running tasks.
>> >>> +        */
>> >>> +       return (rq->avg.runnable_avg_sum >
>> >>> +                       (rq->avg.runnable_avg_period / (rq->nr_running
>> >>> + 2)));
>> >>> +}
>> >>
>> >> Why does the comment talk about load but we don't see it in the
>> >> equation. Also, why does nr_running matter at all? I thought we'd
>> >> simply bother with utilization, if fully utilized we're done etc..
>>
>> By load, I mean : 100 * avg.runnable_avg_sum / avg.runnable_avg_period
>> In addition, i take into account the number of tasks already in the
>> runqueue in order to define the business of a CPU. A CPU with a load
>> of 50% without any tasks in the runqeue in not busy at this time and
>> we can migrate tasks on it but if the CPU already has 2 tasks in its
>> runqueue, it means that newly wake up task will have to share the CPU
>> with other tasks so we consider that the CPU is already busy and we
>> will fall back to default behavior. The equation considers that a CPU
>> is not busy if
>> 100 * avg.runnable_avg_sum / avg.runnable_avg_period < 100 / (nr_running + 2)
>
> I'm still somewhat confused by all this. So raising nr_running will lower the
> required utilization to be considered busy. Suppose we have 50 tasks running,
> all at 1% utilization (bulk wakeup) we'd consider the cpu busy, even though its
> picking its nose for half the time.
>
>
> I'm assuming it's mean to limit process latency or so? Why are you concerned
> with that? This seems like an arbitrary power vs performance tweak without
> solid effidence its needed or even wanted.

Yes the goal was to limit the wake up latency because this version was
only trying to modify the scheduler behavior when the system was not
busy in order to pack the small tasks like background activities but
without decreasing the performance so we were concerned by wakeup
latency.

The new version proposes a more aggressive mode that packs all tasks
until CPUs becomes full.

Vincent
