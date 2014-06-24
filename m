Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbaFXT0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 15:26:48 -0400
Received: from forward4l.mail.yandex.net ([84.201.143.137]:58183 "EHLO
	forward4l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaFXT0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 15:26:47 -0400
X-Yandex-Uniq: 449aa291-3a17-49c2-a1b6-7622f22e8d0e
Authentication-Results: smtp11.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <53A9D0F1.5080305@yandex.ru>
Date: Tue, 24 Jun 2014 23:26:41 +0400
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: bsegall@google.com
CC: Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>, khorenko@parallels.com,
        Paul Turner <pjt@google.com>
Subject: Re: [PATCH v2 1/3] sched/fair: Disable runtime_enabled on dying rq
References: <20140624074148.8738.57690.stgit@tkhai>	<1403596432.3462.26.camel@tkhai>	<xm26wqc6z1c8.fsf@sword-of-the-dawn.mtv.corp.google.com>	<53A9CB23.1080708@yandex.ru> <xm26pphyyvbl.fsf@sword-of-the-dawn.mtv.corp.google.com>
In-Reply-To: <xm26pphyyvbl.fsf@sword-of-the-dawn.mtv.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.06.2014 23:13, bsegall@google.com wrote:
> Kirill Tkhai <tkhai@yandex.ru> writes:
> 
>> On 24.06.2014 21:03, bsegall@google.com wrote:
>>> Kirill Tkhai <ktkhai@parallels.com> writes:
>>>
>>>> We kill rq->rd on the CPU_DOWN_PREPARE stage:
>>>>
>>>> 	cpuset_cpu_inactive -> cpuset_update_active_cpus -> partition_sched_domains ->
>>>> 	-> cpu_attach_domain -> rq_attach_root -> set_rq_offline
>>>>
>>>> This unthrottles all throttled cfs_rqs.
>>>>
>>>> But the cpu is still able to call schedule() till
>>>>
>>>> 	take_cpu_down->__cpu_disable()
>>>>
>>>> is called from stop_machine.
>>>>
>>>> This case the tasks from just unthrottled cfs_rqs are pickable
>>>> in a standard scheduler way, and they are picked by dying cpu.
>>>> The cfs_rqs becomes throttled again, and migrate_tasks()
>>>> in migration_call skips their tasks (one more unthrottle
>>>> in migrate_tasks()->CPU_DYING does not happen, because rq->rd
>>>> is already NULL).
>>>>
>>>> Patch sets runtime_enabled to zero. This guarantees, the runtime
>>>> is not accounted, and the cfs_rqs won't exceed given
>>>> cfs_rq->runtime_remaining = 1, and tasks will be pickable
>>>> in migrate_tasks(). runtime_enabled is recalculated again
>>>> when rq becomes online again.
>>>>
>>>> Ben Segall also noticed, we always enable runtime in
>>>> tg_set_cfs_bandwidth(). Actually, we should do that for online
>>>> cpus only. To fix that, we check if a cpu is online when
>>>> its rq is locked. This guarantees we do not have races with
>>>> set_rq_offline(), which also requires rq->lock.
>>>>
>>>> v2: Fix race with tg_set_cfs_bandwidth().
>>>>     Move cfs_rq->runtime_enabled=0 above unthrottle_cfs_rq().
>>>>
>>>> Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
>>>> CC: Konstantin Khorenko <khorenko@parallels.com>
>>>> CC: Ben Segall <bsegall@google.com>
>>>> CC: Paul Turner <pjt@google.com>
>>>> CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
>>>> CC: Mike Galbraith <umgwanakikbuti@gmail.com>
>>>> CC: Peter Zijlstra <peterz@infradead.org>
>>>> CC: Ingo Molnar <mingo@kernel.org>
>>>> ---
>>>>  kernel/sched/core.c |   15 +++++++++++----
>>>>  kernel/sched/fair.c |   22 ++++++++++++++++++++++
>>>>  2 files changed, 33 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>>>> index 7f3063c..707a3c5 100644
>>>> --- a/kernel/sched/core.c
>>>> +++ b/kernel/sched/core.c
>>>> @@ -7842,11 +7842,18 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
>>>>  		struct rq *rq = cfs_rq->rq;
>>>>  
>>>>  		raw_spin_lock_irq(&rq->lock);
>>>> -		cfs_rq->runtime_enabled = runtime_enabled;
>>>> -		cfs_rq->runtime_remaining = 0;
>>>> +		/*
>>>> +		 * Do not enable runtime on offline runqueues. We specially
>>>> +		 * make it disabled in unthrottle_offline_cfs_rqs().
>>>> +		 */
>>>> +		if (cpu_online(i)) {
>>>> +			cfs_rq->runtime_enabled = runtime_enabled;
>>>> +			cfs_rq->runtime_remaining = 0;
>>>> +
>>>> +			if (cfs_rq->throttled)
>>>> +				unthrottle_cfs_rq(cfs_rq);
>>>> +		}
>>>
>>> We can just do for_each_online_cpu, yes? Also we probably need
>>> get_online_cpus/put_online_cpus, and/or want cpu_active_mask instead
>>> right?
>>>
>>
>> Yes, we can use for_each_online_cpu/for_each_active_cpu with
>> get_online_cpus() taken. But it adds one more lock dependence.
>> This looks worse for me.
> 
> I mean, you need get_online_cpus anyway - cpu_online is just a test
> against the same mask that for_each_online_cpu uses, and without taking
> the lock you can still race with offlining and reset runtime_enabled.
> 

Oh, I see. Thanks.
