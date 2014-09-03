Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbaICIyv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 04:54:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:4136 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230AbaICIys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 04:54:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,456,1406617200"; 
   d="scan'208";a="593807234"
Message-ID: <5406D691.4020009@intel.com>
Date: Wed, 03 Sep 2014 16:51:29 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, peterz@infradead.org,
        mingo@kernel.org, srivatsa@mit.edu, akpm@linux-foundation.org,
        laijs@cn.fujitsu.com, toshi.kani@hp.com, todd.e.brandt@linux.intel.com,
        wangyun@linux.vnet.ibm.com, ego@linux.vnet.ibm.com, fabf@skynet.be,
        linux@arm.linux.org.uk
CC: oleg@redhat.com, srivatsa.bhat@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V2] PM/CPU: Parallel enalbing nonboot cpus with resume
 devices
References: <1408696420-2654-1-git-send-email-tianyu.lan@intel.com> <53FFF642.7010909@intel.com> <54011932.4060405@intel.com>
In-Reply-To: <54011932.4060405@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年08月30日 08:22, Rafael J. Wysocki wrote:
> On 8/29/2014 5:40 AM, Lan Tianyu wrote:
>> On 2014年08月22日 16:33, Lan Tianyu wrote:
>>> In the current world, all nonboot cpus are enabled serially during
>>> system
>>> resume. System resume sequence is that boot cpu enables nonboot cpu
>>> one by
>>> one and then resume devices. Before resuming devices, there are few
>>> tasks
>>> assigned to nonboot cpus after they are brought up. This waste cpu
>>> usage.
>>>
>>> To accelerate S3, this patches allows boot cpu to go forward to resume
>>> devices after bringing up one nonboot cpu. The nonboot cpu will be in
>>> charge of bringing up other cpus. This makes enabling cpu2~x parallel
>>> with resuming devices.
>>>
>>> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
>>> ---
>>> Change since V1:
>>>     Remove PM_PARALLEL_CPU_UP_FOR_SUSPEND kernel config and make
>>> paralleling cpu as default behaviour. Add error handling for
>>> failure of the first frozen cpu online.
>>>
>>> So far, I just tested the patch on the Intel machines. It's better
>>> to test it on the others Arch platforms. Appreciate a lot if some
>>> one can help test it.
>>>
>> Hi All:
>>     Any comments on this patch?  Thanks.
> 
> You need to ensure that the async thing completes before
> cpufreq_resume() or bad things will happen I think.
> 

Hi Rafael:
	Thanks for reminder. You are right. I checked cpufreq code and
cpufreq_suspend will be set to false in the cpufreq_resume(). If cpu
online is later than cpufreq_resume() and cpufreq policy on the cpu will
not be recovered since cpufreq_suspend has been cleared.
cpu_maps_update_begin() can be used to wait all cpu online before
clearing cpufreq_suspend.


>>>   kernel/cpu.c | 70
>>> +++++++++++++++++++++++++++++++++++++++++++++++++-----------
>>>   1 file changed, 58 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/kernel/cpu.c b/kernel/cpu.c
>>> index a343bde..9bc8497 100644
>>> --- a/kernel/cpu.c
>>> +++ b/kernel/cpu.c
>>> @@ -551,8 +551,42 @@ void __weak arch_enable_nonboot_cpus_end(void)
>>>   {
>>>   }
>>>   +static int _cpu_up_with_trace(int cpu)
> 
> Better name?

How about _cpu_up_for_pm? The new function is only called during suspend
and hibernation.

> 
>>> +{
>>> +    int error;
>>> +
>>> +    trace_suspend_resume(TPS("CPU_ON"), cpu, true);
>>> +    error = _cpu_up(cpu, 1);
>>> +    trace_suspend_resume(TPS("CPU_ON"), cpu, false);
>>> +    if (error) {
>>> +        pr_warn("Error taking CPU%d up: %d\n", cpu, error);
>>> +        return error;
>>> +    }
>>> +
>>> +    pr_info("CPU%d is up\n", cpu);
>>> +    return 0;
>>> +}
>>> +
>>> +static int async_enable_nonboot_cpus(void *data)
>>> +{
>>> +    int cpu;
>>> +
>>> +    cpu_maps_update_begin();
>>> +    arch_enable_nonboot_cpus_begin();
> 
> Shouldn't you call this before trying to bring up the first one?

arch_enable_nonboot_cpus_begin() is just to set a mtrr_aps_delayed_init
flag in the mtrr code to delay all init mtrr during the following cpu
online. arch_enable_nonboot_cpus_done() will do init mtrr on the all cpus.

According SDM 11.11.8, all processors must have the same MTRR values.
Original model of system resume is that all cpus are online serially,
delay all init mtrr when one nonboot cpu is online and do it for all
cpus at the end of enabling nonboot cpus. In the parallel situation,
nonboot cpu will have task before all cpus online. So it's necessary to
do init mtrr when the target cpu is online.

Actually from my opinion, arch_enable_nonboot_cpus_begin/done() should
not use in the parallel case. I plan to write another patch to do it.

> 
>>> +
>>> +    for_each_cpu(cpu, frozen_cpus) {
>>> +        _cpu_up_with_trace(cpu);
>>> +    }
>>> +
>>> +    arch_enable_nonboot_cpus_end();
>>> +    cpumask_clear(frozen_cpus);
>>> +    cpu_maps_update_done();
>>> +    return 0;
>>> +}
>>> +
>>>   void __ref enable_nonboot_cpus(void)
>>>   {
>>> +    struct task_struct *tsk;
>>>       int cpu, error;
>>>         /* Allow everyone to use the CPU hotplug again */
>>> @@ -563,22 +597,34 @@ void __ref enable_nonboot_cpus(void)
>>>         pr_info("Enabling non-boot CPUs ...\n");
>>>   -    arch_enable_nonboot_cpus_begin();
>>> +    cpu = cpumask_first(frozen_cpus);
>>> +    cpumask_clear_cpu(cpu, frozen_cpus);
>>>   -    for_each_cpu(cpu, frozen_cpus) {
>>> -        trace_suspend_resume(TPS("CPU_ON"), cpu, true);
>>> -        error = _cpu_up(cpu, 1);
>>> -        trace_suspend_resume(TPS("CPU_ON"), cpu, false);
>>> -        if (!error) {
>>> -            pr_info("CPU%d is up\n", cpu);
>>> -            continue;
>>> +    error = _cpu_up_with_trace(cpu);
>>> +    if (cpumask_empty(frozen_cpus))
>>> +        goto out;
>>> +
>>> +    if (error) {
>>> +        /*
>>> +         * If fail to bring up the first frozen cpus,
>>> +         * enable the rest frozen cpus on the boot cpu.
>>> +         */
>>> +        arch_enable_nonboot_cpus_begin();
>>> +        for_each_cpu(cpu, frozen_cpus) {
>>> +            _cpu_up_with_trace(cpu);
>>>           }
>>> -        pr_warn("Error taking CPU%d up: %d\n", cpu, error);
>>> -    }
>>> +        arch_enable_nonboot_cpus_end();
>>>   -    arch_enable_nonboot_cpus_end();
>>> +    } else {
>>> +        tsk = kthread_create_on_cpu(async_enable_nonboot_cpus,
>>> +                NULL, cpu, "async-enable-nonboot-cpus");
> 
> Does it really need to run on the other CPU?  If the idea is to avoid
> waiting mostly, the async thread can start running on the boot CPU just
> fine I suppose.

Running "enabling nonboot cpu" on the other CPU dedicates to avoid
disturbing the start of resume task. If two threads run on one CPU, they
will compete for CPU resource. Generally, when cpu1 up and there are two
threads, they should run respectively on the cpu0 and cpu1.
Any way, I will do test to compare the difference.

Thanks for review.

> 
>>> +        if (IS_ERR(tsk)) {
>>> +            pr_err("Failed to create async enable nonboot cpus
>>> thread.\n");
>>> +            goto out;
>>> +        }
>>>   -    cpumask_clear(frozen_cpus);
>>> +        kthread_unpark(tsk);
>>> +    }
>>>   out:
>>>       cpu_maps_update_done();
>>>   }
>>>
>>
> 
> Rafael
> 


-- 
Best regards
Tianyu Lan
