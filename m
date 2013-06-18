Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab3FRDpF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 23:45:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:37037 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803Ab3FRDpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 23:45:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,886,1363158000"; 
   d="scan'208";a="331251478"
Message-ID: <51BFD787.5020708@intel.com>
Date: Tue, 18 Jun 2013 11:44:07 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>, sgruszka@redhat.com,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: Re: [patch v8 6/9] sched: compute runnable load avg in cpu_load and
 cpu_avg_load_per_task
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com> <1370589652-24549-7-git-send-email-alex.shi@intel.com> <CAPM31RKwNUh+nNcsEftD4pyP+gdwXhRK7wCRNWa8Y0sE0hf-DQ@mail.gmail.com> <CAPM31R+DBFt1wr10GCGEHDW_J_-79imdTCYEBF7YiKdFc1V7iQ@mail.gmail.com> <51BF15C4.1090906@intel.com> <CAPM31RKHtEYsNV+kzxFpH=55dLaFn1jcQcWD4qYAdHrW_xN+8A@mail.gmail.com>
In-Reply-To: <CAPM31RKHtEYsNV+kzxFpH=55dLaFn1jcQcWD4qYAdHrW_xN+8A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 07:00 AM, Paul Turner wrote:
> On Mon, Jun 17, 2013 at 6:57 AM, Alex Shi <alex.shi@intel.com> wrote:
>> > On 06/17/2013 08:17 PM, Paul Turner wrote:
>>> >> On Mon, Jun 17, 2013 at 3:51 AM, Paul Turner <pjt@google.com> wrote:
>>>> >>> On Fri, Jun 7, 2013 at 12:20 AM, Alex Shi <alex.shi@intel.com> wrote:
>>>>> >>>> They are the base values in load balance, update them with rq runnable
>>>>> >>>> load average, then the load balance will consider runnable load avg
>>>>> >>>> naturally.
>>>>> >>>>
>>>>> >>>> We also try to include the blocked_load_avg as cpu load in balancing,
>>>>> >>>> but that cause kbuild performance drop 6% on every Intel machine, and
>>>>> >>>> aim7/oltp drop on some of 4 CPU sockets machines.
>>>>> >>>>
>>>> >>>
>>>> >>> This looks fine.
>>>> >>>
>>>> >>> Did you try including blocked_load_avg in only get_rq_runnable_load()
>>>> >>> [ and not weighted_cpuload() which is called by new-idle ]?
>>> >>
>>> >> Looking at this more this feels less correct since you're taking
>>> >> averages of averages.
>>> >>
>>> >> This was previously discussed at:
>>> >>   https://lkml.org/lkml/2013/5/6/109
>>> >>
>>> >> And  you later replied suggesting this didn't seem to hurt; what's the
>>> >> current status there?
>> >
>> > Yes, your example show the blocked_load_avg value.
>> > So I had given a patch for review at that time before do detailed
>> > testing. https://lkml.org/lkml/2013/5/7/66
>> >
>> > But in detailed testing, the patch cause a big performance regression.
>> > When I look into for details. I found some cpu in kbuild just had a big
>> > blocked_load_avg, with a very small runnable_load_avg value.
>> >
>> > Seems accumulating current blocked_load_avg into cpu load isn't a good
>> > idea. Because:
> So I think this describes an alternate implementation to the one suggested in:
>   https://lkml.org/lkml/2013/5/7/66
> 
> Specifically, we _don't_ want to accumulate into cpu-load.  Taking an
> "average of the average" loses the mobility that the new
> representation allows.
> 
>> > 1, The blocked_load_avg is decayed same as runnable load, sometime is
>> > far bigger than runnable load, that drive tasks to other idle or slight
>> > load cpu, than cause both performance and power issue. But if the
>> > blocked load is decayed too fast, it lose its effect.
> This is why the idea would be to use an instantaneous load in
> weighted_cpuload() and one that incorporated averages on (wants a
> rename) get_rq_runnable_load().
> 
> For non-instaneous load-indexes we're pulling for stability.

Paul, could I summary your point here:
keep current weighted_cpu_load, but add blocked load avg in
get_rq_runnable_load?

I will test this change.
> 
>> > 2, Another issue of blocked load is that when waking up task, we can not
>> > know blocked load proportion of the task on rq. So, the blocked load is
>> > meaningless in wake affine decision.
> I think this is confusing two things:
> 
> (a) A wake-idle wake-up
> (b) A wake-affine wake-up

what's I mean the wake affine is (b). Anyway, blocked load is no help on
the scenario.
> 
> In (a) we do not care about the blocked load proportion, only whether
> a cpu is idle.
> 
> But once (a) has failed we should absolutely care how much load is
> blocked in (b) as:
> - We know we're going to queue for bandwidth on the cpu [ otherwise
> we'd be in (a) ]
> - Blocked load predicts how much _other_ work is expected to also
> share the queue with us during the quantum
> 


-- 
Thanks
    Alex
