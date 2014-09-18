Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbaIRIka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 04:40:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:5060 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbaIRIk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 04:40:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,545,1406617200"; 
   d="scan'208";a="574947807"
Message-ID: <541A9999.1070607@intel.com>
Date: Thu, 18 Sep 2014 16:36:41 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: ego@linux.vnet.ibm.com
CC: peterz@infradead.org, mingo@kernel.org, rafael.j.wysocki@intel.com,
        srivatsa@mit.edu, akpm@linux-foundation.org, laijs@cn.fujitsu.com,
        toshi.kani@hp.com, todd.e.brandt@linux.intel.com,
        wangyun@linux.vnet.ibm.com, fabf@skynet.be, linux@arm.linux.org.uk,
        oleg@redhat.com, srivatsa.bhat@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V2] PM/CPU: Parallel enalbing nonboot cpus with resume
 devices
References: <1408696420-2654-1-git-send-email-tianyu.lan@intel.com> <20140917090308.GD31806@in.ibm.com>
In-Reply-To: <20140917090308.GD31806@in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年09月17日 17:03, Gautham R Shenoy wrote:
> Hi Lan,
> 
> Sorry missed this repost! Couple of comments.
> 

Np, Thanks for review :)

> On Fri, Aug 22, 2014 at 04:33:40PM +0800, Lan Tianyu wrote:
> 
> [.. snip ..]
>>
>> +static int _cpu_up_with_trace(int cpu)
>> +{
>> +	int error;
>> +
>> +	trace_suspend_resume(TPS("CPU_ON"), cpu, true);
>> +	error = _cpu_up(cpu, 1);
>> +	trace_suspend_resume(TPS("CPU_ON"), cpu, false);
>> +	if (error) {
>> +		pr_warn("Error taking CPU%d up: %d\n", cpu, error);
>> +		return error;
>> +	}
>> +
>> +	pr_info("CPU%d is up\n", cpu);
>> +	return 0;
>> +}
>> +
>> +static int async_enable_nonboot_cpus(void *data)
>> +{
>> +	int cpu;
>> +
>> +	cpu_maps_update_begin();
>> +	arch_enable_nonboot_cpus_begin();
>> +
>> +	for_each_cpu(cpu, frozen_cpus) {
>> +		_cpu_up_with_trace(cpu);
>> +	}
>> +
>> +	arch_enable_nonboot_cpus_end();
>> +	cpumask_clear(frozen_cpus);
>> +	cpu_maps_update_done();
>> +	return 0;
>> +}
>> +
>>  void __ref enable_nonboot_cpus(void)
>>  {
>> +	struct task_struct *tsk;
>>  	int cpu, error;
>>
>>  	/* Allow everyone to use the CPU hotplug again */
>> @@ -563,22 +597,34 @@ void __ref enable_nonboot_cpus(void)
>>
>>  	pr_info("Enabling non-boot CPUs ...\n");
>>
>> -	arch_enable_nonboot_cpus_begin();
>> +	cpu = cpumask_first(frozen_cpus);
>> +	cpumask_clear_cpu(cpu, frozen_cpus);
>>
>> -	for_each_cpu(cpu, frozen_cpus) {
>> -		trace_suspend_resume(TPS("CPU_ON"), cpu, true);
>> -		error = _cpu_up(cpu, 1);
>> -		trace_suspend_resume(TPS("CPU_ON"), cpu, false);
>> -		if (!error) {
>> -			pr_info("CPU%d is up\n", cpu);
>> -			continue;
>> +	error = _cpu_up_with_trace(cpu);
> 
>  If cpu fails to come up, you need to add a pr_warn() citing the
>  reason why it failed to come up.

Ok.

> 
> 
>> +	if (cpumask_empty(frozen_cpus))
>> +		goto out;
>> +
>> +	if (error) {
>> +		/*
>> +		 * If fail to bring up the first frozen cpus,
>> +		 * enable the rest frozen cpus on the boot cpu.
>> +		 */
>> +		arch_enable_nonboot_cpus_begin();
>> +		for_each_cpu(cpu, frozen_cpus) {
>> +			_cpu_up_with_trace(cpu);
>>  		}
>> -		pr_warn("Error taking CPU%d up: %d\n", cpu, error);
>> -	}
>> +		arch_enable_nonboot_cpus_end();
>>
>> -	arch_enable_nonboot_cpus_end();
>> +	} else {
>> +		tsk = kthread_create_on_cpu(async_enable_nonboot_cpus,
>> +				NULL, cpu, "async-enable-nonboot-cpus");
>> +		if (IS_ERR(tsk)) {
>> +			pr_err("Failed to create async enable nonboot cpus thread.\n");
>> +			goto out;
> 
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ This is not good. If you fail to
> create a kthread on the first non-boot cpu, that means none of the
> other non-boot cpus will be brought up. 
> 
> Hence you might want to consider reordering the code in such a manner
> that if the first non-boot cpu fails to come up or if you fail to
> create the kthread task, then the boot cpu will boot the remaining non
> boot cpus.

Yes, this sounds good and will do it in the new version.

> 
> --
> Thanks and Regards
> gautham.
> 


-- 
Best regards
Tianyu Lan
