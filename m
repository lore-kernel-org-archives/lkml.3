Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbaHUDsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 23:48:15 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:48141 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbaHUDsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 23:48:13 -0400
Message-ID: <53F56BFB.7080602@linaro.org>
Date: Thu, 21 Aug 2014 05:48:11 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "luto@amacapital.net" <luto@amacapital.net>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "mingo@redhat.com" <mingo@redhat.com>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Changcheng" <changcheng.liu@intel.com>,
        "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        "Chakravarty, Souvik K" <souvik.k.chakravarty@intel.com>
Subject: Re: [PATCH 1/3] sched: Add new API wake_up_if_idle() to wake up the
 idle cpu
References: <1408351052-25075-1-git-send-email-chuansheng.liu@intel.com> <53F5514A.5050007@linaro.org> <27240C0AC20F114CBF8149A2696CBE4A01E5F7BC@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A01E5F7BC@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2014 04:12 AM, Liu, Chuansheng wrote:
> Hello Daniel,
>
>> -----Original Message-----
>> From: Daniel Lezcano [mailto:daniel.lezcano@linaro.org]
>> Sent: Thursday, August 21, 2014 9:54 AM
>> To: Liu, Chuansheng; luto@amacapital.net; peterz@infradead.org;
>> rjw@rjwysocki.net; mingo@redhat.com
>> Cc: linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org; Liu, Changcheng;
>> Wang, Xiaoming; Chakravarty, Souvik K
>> Subject: Re: [PATCH 1/3] sched: Add new API wake_up_if_idle() to wake up the
>> idle cpu
>>
>> On 08/18/2014 10:37 AM, Chuansheng Liu wrote:
>>> Implementing one new API wake_up_if_idle(), which is used to
>>> wake up the idle CPU.
>>
>> Is this patchset tested ? Did you check it solves the issue you were
>> facing ?
> We have done the basic test, and found the cores can exit C0 quickly with this patchset.
> Basically once the _TIF_NEED_RESCHED is set, then the poll_idle() can be broken.
>
> Please correct me if something is wrong, thanks.

Actually, it was not clear for me if this patch was a proposal or not.

I will review it.

Thanks

   -- Daniel

>>> Suggested-by: Andy Lutomirski <luto@amacapital.net>
>>> Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
>>> ---
>>>    include/linux/sched.h |    1 +
>>>    kernel/sched/core.c   |   16 ++++++++++++++++
>>>    2 files changed, 17 insertions(+)
>>>
>>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>>> index 857ba40..3f89ac1 100644
>>> --- a/include/linux/sched.h
>>> +++ b/include/linux/sched.h
>>> @@ -1024,6 +1024,7 @@ struct sched_domain_topology_level {
>>>    extern struct sched_domain_topology_level *sched_domain_topology;
>>>
>>>    extern void set_sched_topology(struct sched_domain_topology_level *tl);
>>> +extern void wake_up_if_idle(int cpu);
>>>
>>>    #ifdef CONFIG_SCHED_DEBUG
>>>    # define SD_INIT_NAME(type)		.name = #type
>>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>>> index 1211575..adf104f 100644
>>> --- a/kernel/sched/core.c
>>> +++ b/kernel/sched/core.c
>>> @@ -1620,6 +1620,22 @@ static void ttwu_queue_remote(struct
>> task_struct *p, int cpu)
>>>    	}
>>>    }
>>>
>>> +void wake_up_if_idle(int cpu)
>>> +{
>>> +	struct rq *rq = cpu_rq(cpu);
>>> +	unsigned long flags;
>>> +
>>> +	if (set_nr_if_polling(rq->idle)) {
>>> +		trace_sched_wake_idle_without_ipi(cpu);
>>> +	} else {
>>> +		raw_spin_lock_irqsave(&rq->lock, flags);
>>> +		if (rq->curr == rq->idle)
>>> +			smp_send_reschedule(cpu);
>>> +		/* Else cpu is not in idle, do nothing here */
>>> +		raw_spin_unlock_irqrestore(&rq->lock, flags);
>>> +	}
>>> +}
>>> +
>>>    bool cpus_share_cache(int this_cpu, int that_cpu)
>>>    {
>>>    	return per_cpu(sd_llc_id, this_cpu) == per_cpu(sd_llc_id, that_cpu);
>>>
>>
>>
>> --
>>    <http://www.linaro.org/> Linaro.org │ Open source software for ARM
>> SoCs
>>
>> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
>> <http://twitter.com/#!/linaroorg> Twitter |
>> <http://www.linaro.org/linaro-blog/> Blog
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

