Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbaH2DoB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 23:44:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:22312 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbaH2Dn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 23:43:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,422,1406617200"; 
   d="scan'208";a="473683036"
Message-ID: <53FFF642.7010909@intel.com>
Date: Fri, 29 Aug 2014 11:40:50 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: peterz@infradead.org, mingo@kernel.org, rafael.j.wysocki@intel.com,
        srivatsa@mit.edu, akpm@linux-foundation.org, laijs@cn.fujitsu.com,
        toshi.kani@hp.com, todd.e.brandt@linux.intel.com,
        wangyun@linux.vnet.ibm.com, ego@linux.vnet.ibm.com, fabf@skynet.be,
        linux@arm.linux.org.uk
CC: oleg@redhat.com, srivatsa.bhat@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V2] PM/CPU: Parallel enalbing nonboot cpus with resume
 devices
References: <1408696420-2654-1-git-send-email-tianyu.lan@intel.com>
In-Reply-To: <1408696420-2654-1-git-send-email-tianyu.lan@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年08月22日 16:33, Lan Tianyu wrote:
> In the current world, all nonboot cpus are enabled serially during system
> resume. System resume sequence is that boot cpu enables nonboot cpu one by
> one and then resume devices. Before resuming devices, there are few tasks
> assigned to nonboot cpus after they are brought up. This waste cpu usage.
> 
> To accelerate S3, this patches allows boot cpu to go forward to resume
> devices after bringing up one nonboot cpu. The nonboot cpu will be in
> charge of bringing up other cpus. This makes enabling cpu2~x parallel
> with resuming devices.
> 
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> ---
> Change since V1:
> 	Remove PM_PARALLEL_CPU_UP_FOR_SUSPEND kernel config and make
> paralleling cpu as default behaviour. Add error handling for 
> failure of the first frozen cpu online.
> 
> So far, I just tested the patch on the Intel machines. It's better
> to test it on the others Arch platforms. Appreciate a lot if some
> one can help test it. 
> 

Hi All:
	Any comments on this patch?  Thanks.

>  kernel/cpu.c | 70 +++++++++++++++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 58 insertions(+), 12 deletions(-)
> 
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index a343bde..9bc8497 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -551,8 +551,42 @@ void __weak arch_enable_nonboot_cpus_end(void)
>  {
>  }
>  
> +static int _cpu_up_with_trace(int cpu)
> +{
> +	int error;
> +
> +	trace_suspend_resume(TPS("CPU_ON"), cpu, true);
> +	error = _cpu_up(cpu, 1);
> +	trace_suspend_resume(TPS("CPU_ON"), cpu, false);
> +	if (error) {
> +		pr_warn("Error taking CPU%d up: %d\n", cpu, error);
> +		return error;
> +	}
> +
> +	pr_info("CPU%d is up\n", cpu);
> +	return 0;
> +}
> +
> +static int async_enable_nonboot_cpus(void *data)
> +{
> +	int cpu;
> +
> +	cpu_maps_update_begin();
> +	arch_enable_nonboot_cpus_begin();
> +
> +	for_each_cpu(cpu, frozen_cpus) {
> +		_cpu_up_with_trace(cpu);
> +	}
> +
> +	arch_enable_nonboot_cpus_end();
> +	cpumask_clear(frozen_cpus);
> +	cpu_maps_update_done();
> +	return 0;
> +}
> +
>  void __ref enable_nonboot_cpus(void)
>  {
> +	struct task_struct *tsk;
>  	int cpu, error;
>  
>  	/* Allow everyone to use the CPU hotplug again */
> @@ -563,22 +597,34 @@ void __ref enable_nonboot_cpus(void)
>  
>  	pr_info("Enabling non-boot CPUs ...\n");
>  
> -	arch_enable_nonboot_cpus_begin();
> +	cpu = cpumask_first(frozen_cpus);
> +	cpumask_clear_cpu(cpu, frozen_cpus);
>  
> -	for_each_cpu(cpu, frozen_cpus) {
> -		trace_suspend_resume(TPS("CPU_ON"), cpu, true);
> -		error = _cpu_up(cpu, 1);
> -		trace_suspend_resume(TPS("CPU_ON"), cpu, false);
> -		if (!error) {
> -			pr_info("CPU%d is up\n", cpu);
> -			continue;
> +	error = _cpu_up_with_trace(cpu);
> +	if (cpumask_empty(frozen_cpus))
> +		goto out;
> +
> +	if (error) {
> +		/*
> +		 * If fail to bring up the first frozen cpus,
> +		 * enable the rest frozen cpus on the boot cpu.
> +		 */
> +		arch_enable_nonboot_cpus_begin();
> +		for_each_cpu(cpu, frozen_cpus) {
> +			_cpu_up_with_trace(cpu);
>  		}
> -		pr_warn("Error taking CPU%d up: %d\n", cpu, error);
> -	}
> +		arch_enable_nonboot_cpus_end();
>  
> -	arch_enable_nonboot_cpus_end();
> +	} else {
> +		tsk = kthread_create_on_cpu(async_enable_nonboot_cpus,
> +				NULL, cpu, "async-enable-nonboot-cpus");
> +		if (IS_ERR(tsk)) {
> +			pr_err("Failed to create async enable nonboot cpus thread.\n");
> +			goto out;
> +		}
>  
> -	cpumask_clear(frozen_cpus);
> +		kthread_unpark(tsk);
> +	}
>  out:
>  	cpu_maps_update_done();
>  }
> 


-- 
Best regards
Tianyu Lan
