Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbaE2Xzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 19:55:39 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:57346 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaE2Xzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 19:55:37 -0400
Date: Fri, 30 May 2014 01:55:33 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        viresh.kumar@linaro.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] vmstat: on demand updates from differentials V7
Message-ID: <20140529235530.GA25555@localhost.localdomain>
References: <alpine.DEB.2.10.1405291453260.2899@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405291453260.2899@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 02:56:15PM -0500, Christoph Lameter wrote:
> -static void start_cpu_timer(int cpu)
> +static void __init start_shepherd_timer(void)
>  {
> -	struct delayed_work *work = &per_cpu(vmstat_work, cpu);
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu)
> +		INIT_DEFERRABLE_WORK(per_cpu_ptr(&vmstat_work, cpu),
> +			vmstat_update);
> +
> +	cpu_stat_off = kmalloc(cpumask_size(), GFP_KERNEL);

Now you're open coding alloc_cpumask_var() ?

> +	cpumask_copy(cpu_stat_off, cpu_online_mask);
> 
> -	INIT_DEFERRABLE_WORK(work, vmstat_update);
> -	schedule_delayed_work_on(cpu, work, __round_jiffies_relative(HZ, cpu));
> +	schedule_delayed_work(&shepherd,
> +		round_jiffies_relative(sysctl_stat_interval));
>  }
> 
>  static void vmstat_cpu_dead(int node)
> @@ -1266,17 +1367,17 @@
>  	case CPU_ONLINE:
>  	case CPU_ONLINE_FROZEN:
>  		refresh_zone_stat_thresholds();
> -		start_cpu_timer(cpu);
>  		node_set_state(cpu_to_node(cpu), N_CPU);
> +		cpumask_set_cpu(cpu, cpu_stat_off);
>  		break;
>  	case CPU_DOWN_PREPARE:
>  	case CPU_DOWN_PREPARE_FROZEN:
> -		cancel_delayed_work_sync(&per_cpu(vmstat_work, cpu));
> -		per_cpu(vmstat_work, cpu).work.func = NULL;
> +		if (!cpumask_test_and_set_cpu(cpu, cpu_stat_off))
> +			cancel_delayed_work_sync(&per_cpu(vmstat_work, cpu));
>  		break;
>  	case CPU_DOWN_FAILED:
>  	case CPU_DOWN_FAILED_FROZEN:
> -		start_cpu_timer(cpu);
> +		cpumask_set_cpu(cpu, cpu_stat_off);
>  		break;
>  	case CPU_DEAD:
>  	case CPU_DEAD_FROZEN:
> @@ -1296,15 +1397,10 @@
>  static int __init setup_vmstat(void)
>  {
>  #ifdef CONFIG_SMP
> -	int cpu;
> -
>  	cpu_notifier_register_begin();
>  	__register_cpu_notifier(&vmstat_notifier);
> 
> -	for_each_online_cpu(cpu) {
> -		start_cpu_timer(cpu);
> -		node_set_state(cpu_to_node(cpu), N_CPU);
> -	}
> +	start_shepherd_timer();
>  	cpu_notifier_register_done();
>  #endif
>  #ifdef CONFIG_PROC_FS
