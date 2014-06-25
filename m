Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbaFYQwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 12:52:17 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:57935 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985AbaFYQwL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 12:52:11 -0400
From: bsegall@google.com
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>, <khorenko@parallels.com>,
        Paul Turner <pjt@google.com>, <tkhai@yandex.ru>
Subject: Re: [PATCH v2 1/3] sched/fair: Disable runtime_enabled on dying rq
References: <20140624074148.8738.57690.stgit@tkhai>
	<1403596432.3462.26.camel@tkhai>
	<xm26wqc6z1c8.fsf@sword-of-the-dawn.mtv.corp.google.com>
	<53A9CB23.1080708@yandex.ru>
	<xm26pphyyvbl.fsf@sword-of-the-dawn.mtv.corp.google.com>
	<53A9D0F1.5080305@yandex.ru> <1403682814.3462.33.camel@tkhai>
Date: Wed, 25 Jun 2014 09:52:07 -0700
In-Reply-To: <1403682814.3462.33.camel@tkhai> (Kirill Tkhai's message of "Wed,
	25 Jun 2014 11:53:34 +0400")
Message-ID: <xm26ionpyls8.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill Tkhai <ktkhai@parallels.com> writes:

> В Вт, 24/06/2014 в 23:26 +0400, Kirill Tkhai пишет:
>> On 24.06.2014 23:13, bsegall@google.com wrote:
>> > Kirill Tkhai <tkhai@yandex.ru> writes:
>> > 
>> >> On 24.06.2014 21:03, bsegall@google.com wrote:
>> >>> Kirill Tkhai <ktkhai@parallels.com> writes:
>> >>>
>> >>>> We kill rq->rd on the CPU_DOWN_PREPARE stage:
>> >>>>
>> >>>> 	cpuset_cpu_inactive -> cpuset_update_active_cpus -> partition_sched_domains ->
>> >>>> 	-> cpu_attach_domain -> rq_attach_root -> set_rq_offline
>> >>>>
>> >>>> This unthrottles all throttled cfs_rqs.
>> >>>>
>> >>>> But the cpu is still able to call schedule() till
>> >>>>
>> >>>> 	take_cpu_down->__cpu_disable()
>> >>>>
>> >>>> is called from stop_machine.
>> >>>>
>> >>>> This case the tasks from just unthrottled cfs_rqs are pickable
>> >>>> in a standard scheduler way, and they are picked by dying cpu.
>> >>>> The cfs_rqs becomes throttled again, and migrate_tasks()
>> >>>> in migration_call skips their tasks (one more unthrottle
>> >>>> in migrate_tasks()->CPU_DYING does not happen, because rq->rd
>> >>>> is already NULL).
>> >>>>
>> >>>> Patch sets runtime_enabled to zero. This guarantees, the runtime
>> >>>> is not accounted, and the cfs_rqs won't exceed given
>> >>>> cfs_rq->runtime_remaining = 1, and tasks will be pickable
>> >>>> in migrate_tasks(). runtime_enabled is recalculated again
>> >>>> when rq becomes online again.
>> >>>>
>> >>>> Ben Segall also noticed, we always enable runtime in
>> >>>> tg_set_cfs_bandwidth(). Actually, we should do that for online
>> >>>> cpus only. To fix that, we check if a cpu is online when
>> >>>> its rq is locked. This guarantees we do not have races with
>> >>>> set_rq_offline(), which also requires rq->lock.
>> >>>>
>> >>>> v2: Fix race with tg_set_cfs_bandwidth().
>> >>>>     Move cfs_rq->runtime_enabled=0 above unthrottle_cfs_rq().
>> >>>>
>> >>>> Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
>> >>>> CC: Konstantin Khorenko <khorenko@parallels.com>
>> >>>> CC: Ben Segall <bsegall@google.com>
>> >>>> CC: Paul Turner <pjt@google.com>
>> >>>> CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
>> >>>> CC: Mike Galbraith <umgwanakikbuti@gmail.com>
>> >>>> CC: Peter Zijlstra <peterz@infradead.org>
>> >>>> CC: Ingo Molnar <mingo@kernel.org>
>> >>>> ---
>> >>>>  kernel/sched/core.c |   15 +++++++++++----
>> >>>>  kernel/sched/fair.c |   22 ++++++++++++++++++++++
>> >>>>  2 files changed, 33 insertions(+), 4 deletions(-)
>> >>>>
>> >>>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> >>>> index 7f3063c..707a3c5 100644
>> >>>> --- a/kernel/sched/core.c
>> >>>> +++ b/kernel/sched/core.c
>> >>>> @@ -7842,11 +7842,18 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
>> >>>>  		struct rq *rq = cfs_rq->rq;
>> >>>>  
>> >>>>  		raw_spin_lock_irq(&rq->lock);
>> >>>> -		cfs_rq->runtime_enabled = runtime_enabled;
>> >>>> -		cfs_rq->runtime_remaining = 0;
>> >>>> +		/*
>> >>>> +		 * Do not enable runtime on offline runqueues. We specially
>> >>>> +		 * make it disabled in unthrottle_offline_cfs_rqs().
>> >>>> +		 */
>> >>>> +		if (cpu_online(i)) {
>> >>>> +			cfs_rq->runtime_enabled = runtime_enabled;
>> >>>> +			cfs_rq->runtime_remaining = 0;
>> >>>> +
>> >>>> +			if (cfs_rq->throttled)
>> >>>> +				unthrottle_cfs_rq(cfs_rq);
>> >>>> +		}
>> >>>
>> >>> We can just do for_each_online_cpu, yes? Also we probably need
>> >>> get_online_cpus/put_online_cpus, and/or want cpu_active_mask instead
>> >>> right?
>> >>>
>> >>
>> >> Yes, we can use for_each_online_cpu/for_each_active_cpu with
>> >> get_online_cpus() taken. But it adds one more lock dependence.
>> >> This looks worse for me.
>> > 
>> > I mean, you need get_online_cpus anyway - cpu_online is just a test
>> > against the same mask that for_each_online_cpu uses, and without taking
>> > the lock you can still race with offlining and reset runtime_enabled.
>> > 
>> 
>> Oh, I see. Thanks.
>
> But we can check for rq->online, don't we? How about this?

Yeah, that should work.
>
>     sched/fair: Disable runtime_enabled on dying rq
>     
>     We kill rq->rd on the CPU_DOWN_PREPARE stage:
>     
>     	cpuset_cpu_inactive -> cpuset_update_active_cpus -> partition_sched_domains ->
>     	-> cpu_attach_domain -> rq_attach_root -> set_rq_offline
>     
>     This unthrottles all throttled cfs_rqs.
>     
>     But the cpu is still able to call schedule() till
>     
>     	take_cpu_down->__cpu_disable()
>     
>     is called from stop_machine.
>     
>     This case the tasks from just unthrottled cfs_rqs are pickable
>     in a standard scheduler way, and they are picked by dying cpu.
>     The cfs_rqs becomes throttled again, and migrate_tasks()
>     in migration_call skips their tasks (one more unthrottle
>     in migrate_tasks()->CPU_DYING does not happen, because rq->rd
>     is already NULL).
>     
>     Patch sets runtime_enabled to zero. This guarantees, the runtime
>     is not accounted, and the cfs_rqs won't exceed given
>     cfs_rq->runtime_remaining = 1, and tasks will be pickable
>     in migrate_tasks(). runtime_enabled is recalculated again
>     when rq becomes online again.
>     
>     Ben Segall also noticed, we always enable runtime in
>     tg_set_cfs_bandwidth(). Actually, we should do that for online
>     cpus only. To fix that, we check if a cpu is online when
>     its rq is locked. This guarantees we do not have races with
>     set_rq_offline(), which also requires rq->lock.
>     
>     v2: Fix race with tg_set_cfs_bandwidth().
>         Move cfs_rq->runtime_enabled=0 above unthrottle_cfs_rq().
>     v3: Check for rq->online instead of cpu_active.
>     
>     Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>

Reviewed-by: Ben Segall <bsegall@google.com>
