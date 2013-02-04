Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab3BDJJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 04:09:57 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:39245 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145Ab3BDJJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 04:09:55 -0500
MIME-Version: 1.0
In-Reply-To: <CAFTL4hzboD8Mv_-pRDHc+39QwXGWiT3MGtL8gJ=_ajnHdDCBcA@mail.gmail.com>
References: <1359455940-1710-1-git-send-email-vincent.guittot@linaro.org>
	<1359455940-1710-2-git-send-email-vincent.guittot@linaro.org>
	<CAFTL4hzboD8Mv_-pRDHc+39QwXGWiT3MGtL8gJ=_ajnHdDCBcA@mail.gmail.com>
Date: Mon, 4 Feb 2013 10:09:53 +0100
Message-ID: <CAKfTPtD2jRke2CUXiJdmaYYki_Voi4eTqJKgsyTnRpna7p8mJg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] sched: fix init NOHZ_IDLE flag
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 February 2013 19:03, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 2013/1/29 Vincent Guittot <vincent.guittot@linaro.org>:
>> On my smp platform which is made of 5 cores in 2 clusters,I have the
>> nr_busy_cpu field of sched_group_power struct that is not null when the
>> platform is fully idle. The root cause seems to be:
>> During the boot sequence, some CPUs reach the idle loop and set their
>> NOHZ_IDLE flag while waiting for others CPUs to boot. But the nr_busy_cpus
>> field is initialized later with the assumption that all CPUs are in the busy
>> state whereas some CPUs have already set their NOHZ_IDLE flag.
>> We clear the NOHZ_IDLE flag when nr_busy_cpus is initialized in order to
>> have a coherent configuration.
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
>>  kernel/sched/core.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 257002c..fd41924 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -5884,6 +5884,7 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
>>
>>         update_group_power(sd, cpu);
>>         atomic_set(&sg->sgp->nr_busy_cpus, sg->group_weight);
>> +       clear_bit(NOHZ_IDLE, nohz_flags(cpu));
>
> So that's a real issue indeed.  nr_busy_cpus was never correct.
>
> Now I'm still a bit worried with this solution. What if an idle task
> started in smp_init() has not yet stopped its tick, but is about to do
> so? The domains are not yet available to the task but the nohz flags
> are. When it later restarts the tick, it's going to erroneously
> increase nr_busy_cpus.

My 1st idea was to clear NOHZ_IDLE flag and nr_busy_cpus in
init_sched_groups_power instead of setting them as it is done now. If
a CPU enters idle during the init sequence, the flag is already
cleared, and nohz_flags and nr_busy_cpus will stay synced and cleared
while a NULL sched_domain is attached to the CPU thanks to patch 2.
This should solve all use cases ?

>
> It probably won't happen in practice. But then there is more: sched
> domains can be concurrently rebuild anytime, right?  So what if we
> call set_cpu_sd_state_idle() and decrease nr_busy_cpus while the
> domain is switched concurrently. Are we having a new sched group along
> the way? If so we have a bug here as well because we can have
> NOHZ_IDLE set but nr_busy_cpus accounting the CPU.

When the sched_domain are rebuilt, we set a null sched_domain during
the rebuild sequence and a new sched_group_power is created as well

>
> May be we need to set the per cpu nohz flags on the child leaf sched
> domain? This way it's initialized and stored on the same RCU pointer
> and we nohz_flags and nr_busy_cpus become sync.
>
> Also we probably still need the first patch of your previous round.
> Because the current patch may introduce situations where we have idle
> CPUs with NOHZ_IDLE flags cleared.
