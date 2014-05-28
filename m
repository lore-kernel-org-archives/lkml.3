Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156AbaE1PJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 11:09:51 -0400
Received: from service87.mimecast.com ([91.220.42.44]:32888 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbaE1PJu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 11:09:50 -0400
Message-ID: <5385FC38.3050201@arm.com>
Date: Wed, 28 May 2014 16:09:44 +0100
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "npiggin@gmail.com" <npiggin@gmail.com>
CC: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v2 02/11] sched: remove a wake_affine condition
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org> <1400860385-14555-3-git-send-email-vincent.guittot@linaro.org> <20140527124848.GQ30445@twins.programming.kicks-ass.net> <CAKfTPtAbnDdQ=C6oABtwUPr7ADhHo1qsdzt5GFsuVMncA9Q=Qw@mail.gmail.com> <20140527153937.GE19143@laptop.programming.kicks-ass.net> <CAKfTPtCZx4i5HFnma3EFYjxVHojUAkezSS7jL7KDTgwvKEVFwQ@mail.gmail.com> <CAKfTPtB_4bQxBOUJ4tCFRVqzHDRVXj3YPkyzyTv_h-sgm8NwEQ@mail.gmail.com>
In-Reply-To: <CAKfTPtB_4bQxBOUJ4tCFRVqzHDRVXj3YPkyzyTv_h-sgm8NwEQ@mail.gmail.com>
X-OriginalArrivalTime: 28 May 2014 15:09:43.0142 (UTC) FILETIME=[DAC28060:01CF7A86]
X-MC-Unique: 114052816094617401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent & Peter,

On 28/05/14 07:49, Vincent Guittot wrote:
[...]
> 
> Nick,
> 
> While doing some rework on the wake affine part of the scheduler, i
> failed to catch the use case that takes advantage of a condition that
> you added some while ago with the commit
> a3f21bce1fefdf92a4d1705e888d390b10f3ac6f
> 
> Could you help us to clarify the 2 first lines of the test that you added ?
> +                       if ((tl <= load &&
> +                               tl + target_load(cpu, idx) <=
> SCHED_LOAD_SCALE) ||
> +                               100*(tl + SCHED_LOAD_SCALE) <= imbalance*load) {
> 
> Regards,
> Vincent
>>
>>>
>>>>> commit a3f21bce1fefdf92a4d1705e888d390b10f3ac6f
>>>>>
>>>>>
>>>>> +                       if ((tl <= load &&
>>>>> +                               tl + target_load(cpu, idx) <= SCHED_LOAD_SCALE) ||
>>>>> +                               100*(tl + SCHED_LOAD_SCALE) <= imbalance*load) {
>>>>>
>>>>>
>>>>> So back when the code got introduced, it read:
>>>>>
>>>>>         target_load(prev_cpu, idx) - sync*SCHED_LOAD_SCALE < source_load(this_cpu, idx) &&
>>>>>         target_load(prev_cpu, idx) - sync*SCHED_LOAD_SCALE + target_load(this_cpu, idx) < SCHED_LOAD_SCALE
>>>>>

Shouldn't this be 

target_load(this_cpu, idx) - sync*SCHED_LOAD_SCALE <= source_load(prev_cpu, idx) &&
target_load(this_cpu, idx) - sync*SCHED_LOAD_SCALE + target_load(prev_cpu, idx) <= SCHED_LOAD_SCALE

"[PATCH] sched: implement smpnice" (2dd73a4f09beacadde827a032cf15fd8b1fa3d48)
mentions that SCHED_LOAD_BALANCE (IMHO, should be SCHED_LOAD_SCALE) represents
the load contribution of a single task. So I read the second part as if
the sum of the load of this_cpu and prev_cpu is smaller or equal to the
(maximal) load contribution (maximal possible effect) of a single task.

There is even a comment in "[PATCH] sched: tweak affine wakeups"
(a3f21bce1fefdf92a4d1705e888d390b10f3ac6f) in try_to_wake_up() when
SCHED_LOAD_SCALE gets subtracted from tl = this_load =
target_load(this_cpu, idx):

+ * If sync wakeup then subtract the (maximum possible)
+ * effect of the currently running task from the load
+ * of the current CPU:

"[PATCH] sched: implement smpnice" then replaces SCHED_LOAD_SCALE w/ 

+static inline unsigned long cpu_avg_load_per_task(int cpu)
+{
+       runqueue_t *rq = cpu_rq(cpu);
+       unsigned long n = rq->nr_running;
+
+       return n ?  rq->raw_weighted_load / n : SCHED_LOAD_SCALE;

-- Dietmar

>>>>> So while the first line makes some sense, the second line is still
>>>>> somewhat challenging.
>>>>>
>>>>> I read the second line something like: if there's less than one full
>>>>> task running on the combined cpus.
>>>>
>>>> ok. your explanation makes sense
>>>
>>> Maybe, its still slightly weird :-)
>>>
>>>>>
[...]

