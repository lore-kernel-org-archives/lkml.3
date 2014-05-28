Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230AbaE1PVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 11:21:16 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:57709 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbaE1PVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 11:21:15 -0400
Date: Wed, 28 May 2014 17:21:09 +0200
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
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        viresh.kumar@linaro.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org
Subject: Re: vmstat: On demand vmstat workers V5
Message-ID: <20140528152107.GB6507@localhost.localdomain>
References: <alpine.DEB.2.10.1405121317270.29911@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405121317270.29911@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 01:18:10PM -0500, Christoph Lameter wrote:
>  #ifdef CONFIG_SMP
>  static DEFINE_PER_CPU(struct delayed_work, vmstat_work);
>  int sysctl_stat_interval __read_mostly = HZ;
> +static DECLARE_BITMAP(cpu_stat_off_bits, CONFIG_NR_CPUS) __read_mostly;
> +const struct cpumask *const cpu_stat_off = to_cpumask(cpu_stat_off_bits);
> +EXPORT_SYMBOL(cpu_stat_off);

Is there no way to make it a cpumask_var_t, and allocate it from
start_shepherd_timer()?

This should really take less space overall.

> +
> +/* We need to write to cpu_stat_off here */
> +#define stat_off to_cpumask(cpu_stat_off_bits)
> 
>  static void vmstat_update(struct work_struct *w)
>  {
> +	if (refresh_cpu_vm_stats())
> +		/*
> +		 * Counters were updated so we expect more updates
> +		 * to occur in the future. Keep on running the
> +		 * update worker thread.
> +		 */
> +		schedule_delayed_work(this_cpu_ptr(&vmstat_work),
> +			round_jiffies_relative(sysctl_stat_interval));
> +	else {
> +		/*
> +		 * We did not update any counters so the app may be in
> +		 * a mode where it does not cause counter updates.
> +		 * We may be uselessly running vmstat_update.
> +		 * Defer the checking for differentials to the
> +		 * shepherd thread on a different processor.
> +		 */
> +		int r;
> +		/*
> +		 * Housekeeping cpu does not race since it never
> +		 * changes the bit if its zero
> +		 */
> +		r = cpumask_test_and_set_cpu(smp_processor_id(),
> +			stat_off);
> +		VM_BUG_ON(r);
> +	}
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
> +		BUILD_BUG_ON(sizeof(p->vm_stat_diff[0]) != 1);
> +		/*
> +		 * The fast way of checking if there are any vmstat diffs.
> +		 * This works because the diffs are byte sized items.
> +		 */
> +		if (memchr_inv(p->vm_stat_diff, 0, NR_VM_ZONE_STAT_ITEMS))
> +			return true;
> +
> +	}
> +	return false;
> +}
> +
> +
> +/*
> + * Shepherd worker thread that updates the statistics for the
> + * processor the shepherd worker is running on and checks the
> + * differentials of other processors that have their worker
> + * threads for vm statistics updates disabled because of
> + * inactivity.
> + */
> +static void vmstat_shepherd(struct work_struct *w)
> +{
> +	int cpu;
> +
>  	refresh_cpu_vm_stats();
> -	schedule_delayed_work(&__get_cpu_var(vmstat_work),
> -		round_jiffies_relative(sysctl_stat_interval));
> +
> +	/* Check processors whose vmstat worker threads have been disabled */
> +	for_each_cpu(cpu, stat_off)
> +		if (need_update(cpu) &&
> +			cpumask_test_and_clear_cpu(cpu, stat_off)) {
> +
> +			struct delayed_work *work = &per_cpu(vmstat_work, cpu);
> +
> +			INIT_DEFERRABLE_WORK(work, vmstat_update);
> +			schedule_delayed_work_on(cpu, work,
> +				__round_jiffies_relative(sysctl_stat_interval,
> +				cpu));
> +		}
> +
> +	schedule_delayed_work(this_cpu_ptr(&vmstat_work),
> +		__round_jiffies_relative(sysctl_stat_interval,
> +		HOUSEKEEPING_CPU));

Maybe you can just make the shepherd work unbound and let bind it from userspace
once we have the workqueue user affinity patchset in.

OTOH, it means you need to have a vmstat_update work on the housekeeping CPU as well.
But that's perhaps what you want since the vmstat_shepherd feature is probably not
something you want to enable without full dynticks CPU around. It probably add quite
some overhead on normal workloads to do a system wide scan.

But having two works scheduled for the whole is perhaps some overhead as well.
