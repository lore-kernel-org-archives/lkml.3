Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771Ab3D3HHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 03:07:22 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:55701 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361Ab3D3HHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 03:07:21 -0400
Message-ID: <517F6CF9.7030401@linux.vnet.ibm.com>
Date: Tue, 30 Apr 2013 12:34:25 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: David VomLehn <David.VomLehn@spacex.com>
CC: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Msleep_interruptible() on a dual processor system may
 wait a long time.
References: <20130430012015.GB1504@dvomlehn-z8.spacex.com>
In-Reply-To: <20130430012015.GB1504@dvomlehn-z8.spacex.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13043006-5490-0000-0000-0000035EF321
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2013 06:50 AM, David VomLehn wrote:
> Msleep_interruptible() on a dual processor system may wait a long time.
> 
> On some reboots, calling msleep_interruptible() from CPU 1 on a dual
> processor system will not return for seconds or even minutes. This happens
> because ksoftirqd/1 migrates to CPU 0, which is allowed because its
> cpus_allowed mask is 0x3. Since ksoftirqd daemons only process the timer queue
> for their current CPU, no timer_list entries will be processed on CPU 1 until
> the ksoftirqd/1 migrates back to that CPU, which depends on system load and
> may take an arbitrary amount of time. The task associated with the
> msleep_interruptible() call may thus hang quite a while.
> 
> The root cause appears to be to a race condition between select_fallback_rq(),
> which selects a runqueue for a task, and set_cpu_active(), which sets the
> corresponding bit in cpu_active_mask for a newly active CPU. When ksoftirqd/1
> is run for the first time, its cpus_allowed mask is set to 0x2, i.e. it is
> restricted to CPU 1. The function select_task_rq() will be called, which calls
> select_task_rq_fair(). This will return a 0 for the CPU on which to run the
> task. When select_task_rq() finds the task is not allowed to run on CPU 0,
> it calls select_fallback_rq() to choose a new CPU. There are two cases:
> 
> o	If set_cpu_active() ran for CPU 1 before select_fallback_rq(), the
> 	corresponding bit in cpu_active_mask will be set, allowing ksoftirqd/1
> 	to run on that CPU.
> o	If the order of calls was reversed, select_fallback_rq() will call
> 	cpuset_cpus_allowed_fallback(), which will replace the task's
> 	cpus_allowed_mask with cpu_possible_mask, allowing ksoftirqd/1 to
> 	run on any CPU. It will also choose any CPU from the active CPUs. 
> 
> In the second case, ksoftirqd/1 will be able to roam freely across the
> system's CPUs, neglecting its responsibility to the timer queue.
> 

Which kernel version did you test this on? Thomas just fixed a nasty race
in the per-cpu kthread park/unpark code and made it such that only the unpark
code can ever wakeup a parked kthread (commit f2530dc7 in mainline).
And that means that ksoftirqd/1 will never run on anything other than CPU1.
If CPU1 goes offline, it will simply not run. Timers get migrated in the
CPU_DEAD phase of CPU offline to some other CPU. So please check if your
problem is fixed in current mainline.

Also, looking at your code, I see that you just totally broke CPU hotplug,
see below.
 
> Signed-off-by: David VomLehn <dvomlehn@spacex.com>
> ---
[...]
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index 563f136..4a11f33 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -150,7 +150,7 @@ static int __cpu_notify(unsigned long val, void *v, int nr_to_call,
>  	return notifier_to_errno(ret);
>  }
> 
> -static int cpu_notify(unsigned long val, void *v)
> +int cpu_notify(unsigned long val, void *v)
>  {
>  	return __cpu_notify(val, v, -1, NULL);
>  }
> @@ -315,9 +315,6 @@ static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
>  		goto out_notify;
>  	BUG_ON(!cpu_online(cpu));
> 
> -	/* Now call notifier in preparation. */
> -	cpu_notify(CPU_ONLINE | mod, hcpu);
> -
>  out_notify:
>  	if (ret != 0)
>  		__cpu_notify(CPU_UP_CANCELED | mod, hcpu, nr_calls, NULL);
[...]
>  static int
>  hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
>  {
> @@ -673,10 +684,17 @@ void __init smp_init(void)
[...]
> 
> +
> +	/* Now call notifier in preparation. */
> +	for_each_cpu(cpu, cpu_notify_pending_mask)
> +		cpu_notify(CPU_ONLINE, (void *)(long)cpu);
> +
>  	/* Any cleanup work */
>  	printk(KERN_INFO "Brought up %ld CPUs\n", (long)num_online_cpus());
>  	smp_cpus_done(setup_max_cpus);
> 

So you moved cpu_notify(CPU_ONLINE) from cpu_up() to the SMP boot-up code.
That means, after boot, you'll never be able to properly online any CPU, ever!

Regards,
Srivatsa S. Bhat

