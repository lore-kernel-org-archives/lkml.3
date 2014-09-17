Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbaIQJDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 05:03:30 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:60607 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385AbaIQJD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 05:03:27 -0400
Date: Wed, 17 Sep 2014 14:33:08 +0530
From: Gautham R Shenoy <ego@linux.vnet.ibm.com>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: peterz@infradead.org, mingo@kernel.org, rafael.j.wysocki@intel.com,
        srivatsa@mit.edu, akpm@linux-foundation.org, laijs@cn.fujitsu.com,
        toshi.kani@hp.com, todd.e.brandt@linux.intel.com,
        wangyun@linux.vnet.ibm.com, ego@linux.vnet.ibm.com, fabf@skynet.be,
        linux@arm.linux.org.uk, oleg@redhat.com,
        srivatsa.bhat@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V2] PM/CPU: Parallel enalbing nonboot cpus with
 resume devices
Message-ID: <20140917090308.GD31806@in.ibm.com>
Reply-To: ego@linux.vnet.ibm.com
References: <1408696420-2654-1-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408696420-2654-1-git-send-email-tianyu.lan@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091709-7182-0000-0000-000000790BFB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lan,

Sorry missed this repost! Couple of comments.

On Fri, Aug 22, 2014 at 04:33:40PM +0800, Lan Tianyu wrote:

[.. snip ..]
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

 If cpu fails to come up, you need to add a pr_warn() citing the
 reason why it failed to come up.


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

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ This is not good. If you fail to
create a kthread on the first non-boot cpu, that means none of the
other non-boot cpus will be brought up. 

Hence you might want to consider reordering the code in such a manner
that if the first non-boot cpu fails to come up or if you fail to
create the kthread task, then the boot cpu will boot the remaining non
boot cpus.

--
Thanks and Regards
gautham.

