Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502AbaHHKz4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 06:55:56 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:32777 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194AbaHHKzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 06:55:51 -0400
Date: Fri, 8 Aug 2014 16:25:02 +0530
From: Gautham R Shenoy <ego@linux.vnet.ibm.com>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: rjw@rjwysocki.net, len.brown@intel.com, pavel@ucw.cz, peterz@infradead.org,
        toshi.kani@hp.com, mingo@kernel.org, akpm@linux-foundation.org,
        todd.e.brandt@linux.intel.com, fabf@skynet.be,
        srivatsa.bhat@linux.vnet.ibm.com, ego@linux.vnet.ibm.com,
        rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [RFC PATCH] PM/CPU: Parallel enabling nonboot cpus with resume
 devices
Message-ID: <20140808105501.GA15048@in.ibm.com>
Reply-To: ego@linux.vnet.ibm.com
References: <1406106694-3306-1-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406106694-3306-1-git-send-email-tianyu.lan@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080810-7182-0000-0000-0000002827A9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lan,

On Wed, Jul 23, 2014 at 05:11:34PM +0800, Lan Tianyu wrote:
> In the current world, all nonboot cpus are enabled serially during system
> resume. System resume sequence is that boot cpu enables nonboot cpu one by
> one and then resume devices. Before resuming devices, there are few tasks
> assigned to nonboot cpus after they are brought up. This waste cpu usage.
> 
> To accelerate S3, this patches adds a new kernel configure
> PM_PARALLEL_CPU_UP_FOR_SUSPEND to allow boot cpu to go forward to resume
> devices after bringing up one nonboot cpu. The nonboot cpu will be in charge
> of bringing up other cpus. This makes enabling cpu2~x parallel with resuming
> devices. From the test result on 4 logical core laptop, the time of resume
> device almost wasn't affected by enabling nonboot cpus lately while the start
> point is almost 30ms earlier than before.
> 
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> ---
>  kernel/cpu.c         | 82 ++++++++++++++++++++++++++++++++++++++++++++++------
>  kernel/power/Kconfig | 13 +++++++++
>  2 files changed, 86 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index a343bde..d4c1353 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -551,9 +551,27 @@ void __weak arch_enable_nonboot_cpus_end(void)
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

[..snip..]
> 
> +
> +void __ref enable_nonboot_cpus(void)
> +{
> +	struct task_struct *tsk;
> +	int cpu;
> +
> +	/* Allow everyone to use the CPU hotplug again */
> +	cpu_maps_update_begin();
> +	cpu_hotplug_disabled = 0;
> +	if (cpumask_empty(frozen_cpus))
> +		goto out;
> +
> +	arch_enable_nonboot_cpus_begin();
> +
> +	cpu = cpumask_first(frozen_cpus);
> +	cpumask_clear_cpu(cpu, frozen_cpus);
> +
> +	_cpu_up_with_trace(cpu);

We should be handling the error returned by _cpu_up_with_trace() 
in case 'cpu' fails to come online. Unless it is something that I am
not aware of it doesn't make much sense to create a kthread on a cpu
that we know has failed to come online.


> +
> +	if (cpumask_empty(frozen_cpus)) {
> +		arch_enable_nonboot_cpus_end();
> +	} else {
> +		tsk = kthread_create_on_cpu(async_enable_nonboot_cpus,
> +				NULL, cpu, "async-enable-nonboot-cpus");
> +		if (IS_ERR(tsk)) {
> +			pr_err("Failed to create async enable nonboot cpus thread.\n");
> +			goto out;
> +		}
> +
> +		kthread_unpark(tsk);
> +	}
> +out:
> +	cpu_maps_update_done();
> +}
> +#endif
> +

--
Thanks and Regards
gautham.

