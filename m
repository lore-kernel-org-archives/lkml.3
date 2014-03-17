Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbaCQOvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 10:51:51 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:45888 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616AbaCQOvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 10:51:49 -0400
Message-ID: <53270C01.6090209@linux.vnet.ibm.com>
Date: Mon, 17 Mar 2014 10:51:45 -0400
From: "Jason J. Herne" <jjherne@linux.vnet.ibm.com>
Reply-To: jjherne@linux.vnet.ibm.com
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: Subject: Warning in workqueue.c
References: <52F8F0FB.3080206@linux.vnet.ibm.com> <20140210231742.GK25350@mtj.dyndns.org> <52FB90C6.4010701@linux.vnet.ibm.com> <52FC3C83.8020303@cn.fujitsu.com> <52FD07B2.5080402@linux.vnet.ibm.com> <20140213204102.GC17608@htj.dyndns.org> <20140214160923.GK27965@twins.programming.kicks-ass.net> <20140214162556.GF31544@htj.dyndns.org> <530B5EE3.8050200@linux.vnet.ibm.com> <20140224183501.GC2522@htj.dyndns.org> <20140225103726.GJ9987@twins.programming.kicks-ass.net> <531DCE36.8010906@linux.vnet.ibm.com>
In-Reply-To: <531DCE36.8010906@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031714-7164-0000-0000-0000005DB24D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2014 10:37 AM, Jason J. Herne wrote:
> On 02/25/2014 05:37 AM, Peter Zijlstra wrote:
>> On Mon, Feb 24, 2014 at 01:35:01PM -0500, Tejun Heo wrote:
>>
>>> That's a bummer but it at least isn't a very new regression.  Peter,
>>> any ideas on debugging this?  I can make workqueue to play block /
>>> unblock dance to try to work around the issue but that'd be very
>>> yucky.  It'd be great to root cause where the cpu selection anomaly is
>>> coming from.
>>
>> I'm assuming you're using set_cpus_allowed_ptr() to flip them between
>> CPUs; the below adds some error paths to that code. In particular we
>> propagate the __migrate_task() fail (returns the number of tasks
>> migrated) through the stop_one_cpu() into set_cpus_allowed_ptr().
>>
>> This way we can see if there was a problem with the migration.
>>
>> You should be able to now reliably use the return value of
>> set_cpus_allowed_ptr() to tell if it is now running on a CPU in its
>> allowed mask.
>>
>> I've also included an #if 0 retry loop for the fail case; but I suspect
>> that that might end up deadlocking your machine if you hit that just
>> wrong, something like the waking CPU endlessly trying to migrate the
>> task over while the wakee CPU is waiting for completion of something
>> from the waking CPU.
>>
>> But its worth a prod I suppose.
>>
>>
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 84b23cec0aeb..4c384efac8b3 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -4554,18 +4554,28 @@ int set_cpus_allowed_ptr(struct task_struct
>> *p, const struct cpumask *new_mask)
>>
>>       do_set_cpus_allowed(p, new_mask);
>>
>> +again: __maybe_unused
>> +
>>       /* Can the task run on the task's current CPU? If so, we're done */
>> -    if (cpumask_test_cpu(task_cpu(p), new_mask))
>> +    if (cpumask_test_cpu(task_cpu(p), tsk_cpus_allowed(p)))
>>           goto out;
>>
>> -    dest_cpu = cpumask_any_and(cpu_active_mask, new_mask);
>> +    dest_cpu = cpumask_any_and(cpu_active_mask, tsk_cpus_allowed(p));
>>       if (p->on_rq) {
>>           struct migration_arg arg = { p, dest_cpu };
>> +
>>           /* Need help from migration thread: drop lock and wait. */
>>           task_rq_unlock(rq, p, &flags);
>> -        stop_one_cpu(cpu_of(rq), migration_cpu_stop, &arg);
>> +        ret = stop_one_cpu(cpu_of(rq), migration_cpu_stop, &arg);
>> +#if 0
>> +        if (ret) {
>> +            rq = task_rq_lock(p, &flags);
>> +            goto again;
>> +        }
>> +#endif
>>           tlb_migrate_finish(p->mm);
>> -        return 0;
>> +
>> +        return ret;
>>       }
>>   out:
>>       task_rq_unlock(rq, p, &flags);
>> @@ -4679,15 +4689,18 @@ void sched_setnuma(struct task_struct *p, int
>> nid)
>>   static int migration_cpu_stop(void *data)
>>   {
>>       struct migration_arg *arg = data;
>> +    int ret = 0;
>>
>>       /*
>>        * The original target cpu might have gone down and we might
>>        * be on another cpu but it doesn't matter.
>>        */
>>       local_irq_disable();
>> -    __migrate_task(arg->task, raw_smp_processor_id(), arg->dest_cpu);
>> +    if (!__migrate_task(arg->task, raw_smp_processor_id(),
>> arg->dest_cpu))
>> +        ret = -EAGAIN;
>>       local_irq_enable();
>> -    return 0;
>> +
>> +    return ret;
>>   }
>>
>>   #ifdef CONFIG_HOTPLUG_CPU
>>
>
> Peter,
>
> Did you intend for me to run with this patch or was it posted for
> discussion only? If you want it run, please tell me what to look for.
> Also, if I should run this, should I include any other patches, either
> the last one you posted in this thread or any of Tejun's?
>
> Thanks.
>

Ping?

-- 
-- Jason J. Herne (jjherne@linux.vnet.ibm.com)

