Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab3KPPmf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 10:42:35 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:51723 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab3KPPma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 10:42:30 -0500
Date: Sat, 16 Nov 2013 16:42:26 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: vmstat: On demand vmstat workers V3
Message-ID: <20131116154224.GC18855@localhost.localdomain>
References: <000001417f6834f1-32b83f22-8bde-4b9e-b591-bc31329660e4-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001417f6834f1-32b83f22-8bde-4b9e-b591-bc31329660e4-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 05:40:40PM +0000, Christoph Lameter wrote:
> V2->V3:
> - Introduce a new tick_get_housekeeping_cpu() function. Not sure
>   if that is exactly what we want but it is a start. Thomas?

Not really. Thomas suggested an infrastructure to move CPU-local periodic
jobs handling to be offlined to set of remote housekeeping CPU.

This could be potentially useful for many kind of stats relying on
periodic updates, the scheduler tick being a candidate (I have yet to
check if we can really apply that in practice though).

Now the problem is that vmstats updates use pure local lockless
operations. It may be possible to offline this update to remote CPUs
but then we need to convert vmstats updates to use locks. Which is
potentially costly. Unless we can find some clever lockless update
scheme. Do you think this can be possible?

See below for more detailed review:

[...]
> 
>  /*
> @@ -1213,12 +1229,15 @@ static const struct file_operations proc
>  #ifdef CONFIG_SMP
>  static DEFINE_PER_CPU(struct delayed_work, vmstat_work);
>  int sysctl_stat_interval __read_mostly = HZ;
> +static struct cpumask *monitored_cpus;
> 
>  static void vmstat_update(struct work_struct *w)
>  {
> -	refresh_cpu_vm_stats();
> -	schedule_delayed_work(&__get_cpu_var(vmstat_work),
> -		round_jiffies_relative(sysctl_stat_interval));
> +	if (refresh_cpu_vm_stats())
> +		schedule_delayed_work(this_cpu_ptr(&vmstat_work),
> +			round_jiffies_relative(sysctl_stat_interval));
> +	else
> +		cpumask_set_cpu(smp_processor_id(), monitored_cpus);

That looks racy against other CPUs that may set their own bit and also
against the shepherd that clears processed monitored CPUs.

That seem to matter because a CPU could be simply entirely forgotten
by vmstat and never processed again.

>  }
> 
>  static void start_cpu_timer(int cpu)
> @@ -1226,7 +1245,70 @@ static void start_cpu_timer(int cpu)
>  	struct delayed_work *work = &per_cpu(vmstat_work, cpu);
> 
>  	INIT_DEFERRABLE_WORK(work, vmstat_update);
> -	schedule_delayed_work_on(cpu, work, __round_jiffies_relative(HZ, cpu));
> +	schedule_delayed_work_on(cpu, work,
> +		__round_jiffies_relative(sysctl_stat_interval, cpu));
> +}
> +
> +/*
> + * Check if the diffs for a certain cpu indicate that
> + * an update is needed.
> + */
> +static bool need_update(int cpu)
> +{
> +	struct zone *zone;
> +
> +	for_each_populated_zone(zone) {
> +		struct per_cpu_pageset *p = per_cpu_ptr(zone->pageset, cpu);
> +
> +		/*
> +		 * The fast way of checking if there are any vmstat diffs.
> +		 * This works because the diffs are byte sized items.
> +		 */
> +		if (memchr_inv(p->vm_stat_diff, 0, NR_VM_ZONE_STAT_ITEMS))
> +			return true;
> +	}
> +	return false;
> +}
> +
> +static void vmstat_shepherd(struct work_struct *w)
> +{
> +	int cpu;
> +	int s = tick_get_housekeeping_cpu();
> +	struct delayed_work *d = per_cpu_ptr(&vmstat_work, s);
> +
> +	refresh_cpu_vm_stats();
> +
> +	for_each_cpu(cpu, monitored_cpus)
> +		if (need_update(cpu)) {
> +			cpumask_clear_cpu(cpu, monitored_cpus);
> +			start_cpu_timer(cpu);
> +		}
> +
> +	if (s != smp_processor_id()) {
> +		/* Timekeeping was moved. Move the shepherd worker */
> +		cpumask_set_cpu(smp_processor_id(), monitored_cpus);
> +		cpumask_clear_cpu(s, monitored_cpus);
> +		cancel_delayed_work_sync(d);
> +		INIT_DEFERRABLE_WORK(d, vmstat_shepherd);
> +	}
> +
> +	schedule_delayed_work_on(s, d,
> +		__round_jiffies_relative(sysctl_stat_interval, s));

Note that on dynticks idle (CONFIG_NO_HZ_IDLE=y), the timekeeper CPU can change quickly and often.

I can imagine a nasty race there: CPU 0 is the timekeeper. It schedules the
vmstat sherpherd work in 2 seconds. But CPU 0 goes to sleep for a big while
and some other CPU takes the timekeeping duty. The shepherd timer won't be
processed until CPU 0 wakes up although we may have CPUs to monitor.

CONFIG_NO_HZ_FULL may work incidentally because CPU 0 is the only timekeeper there
but this is a temporary limitation. Expect the timekeeper to be dynamic in the future
under that config.

> +
> +}
> +
> +static void __init start_shepherd_timer(void)
> +{
> +	int cpu = tick_get_housekeeping_cpu();
> +	struct delayed_work *d = per_cpu_ptr(&vmstat_work, cpu);
> +
> +	INIT_DEFERRABLE_WORK(d, vmstat_shepherd);
> +	monitored_cpus = kmalloc(BITS_TO_LONGS(nr_cpu_ids) * sizeof(long),
> +			GFP_KERNEL);
> +	cpumask_copy(monitored_cpus, cpu_online_mask);
> +	cpumask_clear_cpu(cpu, monitored_cpus);
> +	schedule_delayed_work_on(cpu, d,
> +		__round_jiffies_relative(sysctl_stat_interval, cpu));
>  }

So another issue with the whole design of this patch, outside its races, is that
a CPU can run full dynticks, do some quick system call at some point and thus
make the shepherd disturb it after it goes back in userland in full dynticks.

So such a system that dynamically schedules timers on demand is enough if we
want to _minimize_ timers. But what we want is a strong guarantee that the
CPU won't be disturbed at least while it runs in userland, right?

I mean, we are not only interested in optimizations but also in guarantees if
we have an extreme workload that strongly depends on the CPU not beeing disturbed
at all. I know that some people in realtime want that. And I thought it's also
what your want, may be I misunderstood your usecase?
