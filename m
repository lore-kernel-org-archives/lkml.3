Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbaGKNUo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:20:44 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:60321 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbaGKNUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:20:42 -0400
Date: Fri, 11 Jul 2014 15:20:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: akpm@linux-foundation.org, Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        viresh.kumar@linaro.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org
Subject: Re: vmstat: On demand vmstat workers V8
Message-ID: <20140711132032.GB26045@localhost.localdomain>
References: <alpine.DEB.2.11.1407100903130.12483@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1407100903130.12483@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 09:04:55AM -0500, Christoph Lameter wrote:
> 
> V7->V8
> - hackbench regression test shows a tiny performance increase due
>   to reduced OS processing.
> - Rediff against 3.16-rc4.
> 
> V6->V7
> - Remove /sysfs support.
> 
> V5->V6:
> - Shepherd thread as a general worker thread. This means
>   that the general mechanism to control worker thread
>   cpu use by Frederic Weisbecker is necessary to
>   restrict the shepherd thread to the cpus not used
>   for low latency tasks. Hopefully that is ready to be
>   merged soon. No need anymore to have a specific
>   cpu be the housekeeper cpu.
> 
> V4->V5:
> - Shepherd thread on a specific cpu (HOUSEKEEPING_CPU).
> - Incorporate Andrew's feedback
> - Work out the races.
> - Make visible which CPUs have stat updates switched off
>   in /sys/devices/system/cpu/stat_off
> 
> V3->V4:
> - Make the shepherd task not deferrable. It runs on the tick cpu
>   anyways. Deferral could get deltas too far out of sync if
>   vmstat operations are disabled for a certain processor.
> 
> V2->V3:
> - Introduce a new tick_get_housekeeping_cpu() function. Not sure
>   if that is exactly what we want but it is a start. Thomas?
> - Migrate the shepherd task if the output of
>   tick_get_housekeeping_cpu() changes.
> - Fixes recommended by Andrew.
> 
> V1->V2:
> - Optimize the need_update check by using memchr_inv.
> - Clean up.
> 
> vmstat workers are used for folding counter differentials into the
> zone, per node and global counters at certain time intervals.
> They currently run at defined intervals on all processors which will
> cause some holdoff for processors that need minimal intrusion by the
> OS.
> 
> The current vmstat_update mechanism depends on a deferrable timer
> firing every other second by default which registers a work queue item
> that runs on the local CPU, with the result that we have 1 interrupt
> and one additional schedulable task on each CPU every 2 seconds
> If a workload indeed causes VM activity or multiple tasks are running
> on a CPU, then there are probably bigger issues to deal with.
> 
> However, some workloads dedicate a CPU for a single CPU bound task.
> This is done in high performance computing, in high frequency
> financial applications, in networking (Intel DPDK, EZchip NPS) and with
> the advent of systems with more and more CPUs over time, this may become
> more and more common to do since when one has enough CPUs
> one cares less about efficiently sharing a CPU with other tasks and
> more about efficiently monopolizing a CPU per task.
> 
> The difference of having this timer firing and workqueue kernel thread
> scheduled per second can be enormous. An artificial test measuring the
> worst case time to do a simple "i++" in an endless loop on a bare metal
> system and under Linux on an isolated CPU with dynticks and with and
> without this patch, have Linux match the bare metal performance
> (~700 cycles) with this patch and loose by couple of orders of magnitude
> (~200k cycles) without it[*].  The loss occurs for something that just
> calculates statistics. For networking applications, for example, this
> could be the difference between dropping packets or sustaining line rate.
> 
> Statistics are important and useful, but it would be great if there
> would be a way to not cause statistics gathering produce a huge
> performance difference. This patche does just that.
> 
> This patch creates a vmstat shepherd worker that monitors the
> per cpu differentials on all processors. If there are differentials
> on a processor then a vmstat worker local to the processors
> with the differentials is created. That worker will then start
> folding the diffs in regular intervals. Should the worker
> find that there is no work to be done then it will make the shepherd
> worker monitor the differentials again.
> 
> With this patch it is possible then to have periods longer than
> 2 seconds without any OS event on a "cpu" (hardware thread).
> 
> The patch shows a very minor increased in system performance.
> 
> 
> hackbench -s 512 -l 2000 -g 15 -f 25 -P
> 
> Results before the patch:
> 
> Running in process mode with 15 groups using 50 file descriptors each (== 750 tasks)
> Each sender will pass 2000 messages of 512 bytes
> Time: 4.992
> Running in process mode with 15 groups using 50 file descriptors each (== 750 tasks)
> Each sender will pass 2000 messages of 512 bytes
> Time: 4.971
> Running in process mode with 15 groups using 50 file descriptors each (== 750 tasks)
> Each sender will pass 2000 messages of 512 bytes
> Time: 5.063
> 
> Hackbench after the patch:
> 
> Running in process mode with 15 groups using 50 file descriptors each (== 750 tasks)
> Each sender will pass 2000 messages of 512 bytes
> Time: 4.973
> Running in process mode with 15 groups using 50 file descriptors each (== 750 tasks)
> Each sender will pass 2000 messages of 512 bytes
> Time: 4.990
> Running in process mode with 15 groups using 50 file descriptors each (== 750 tasks)
> Each sender will pass 2000 messages of 512 bytes
> Time: 4.993
> 
> 
> 
> Reviewed-by: Gilad Ben-Yossef <gilad@benyossef.com>
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> 
> Index: linux/mm/vmstat.c
> ===================================================================
> --- linux.orig/mm/vmstat.c	2014-07-07 10:15:01.790099463 -0500
> +++ linux/mm/vmstat.c	2014-07-07 10:17:17.397891143 -0500
> @@ -7,6 +7,7 @@
>   *  zoned VM statistics
>   *  Copyright (C) 2006 Silicon Graphics, Inc.,
>   *		Christoph Lameter <christoph@lameter.com>
> + *  Copyright (C) 2008-2014 Christoph Lameter
>   */
>  #include <linux/fs.h>
>  #include <linux/mm.h>
> @@ -14,6 +15,7 @@
>  #include <linux/module.h>
>  #include <linux/slab.h>
>  #include <linux/cpu.h>
> +#include <linux/cpumask.h>
>  #include <linux/vmstat.h>
>  #include <linux/sched.h>
>  #include <linux/math64.h>
> @@ -419,13 +421,22 @@ void dec_zone_page_state(struct page *pa
>  EXPORT_SYMBOL(dec_zone_page_state);
>  #endif
> 
> -static inline void fold_diff(int *diff)
> +
> +/*
> + * Fold a differential into the global counters.
> + * Returns the number of counters updated.
> + */
> +static int fold_diff(int *diff)
>  {
>  	int i;
> +	int changes = 0;
> 
>  	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
> -		if (diff[i])
> +		if (diff[i]) {
>  			atomic_long_add(diff[i], &vm_stat[i]);
> +			changes++;
> +	}
> +	return changes;
>  }
> 
>  /*
> @@ -441,12 +452,15 @@ static inline void fold_diff(int *diff)
>   * statistics in the remote zone struct as well as the global cachelines
>   * with the global counters. These could cause remote node cache line
>   * bouncing and will have to be only done when necessary.
> + *
> + * The function returns the number of global counters updated.
>   */
> -static void refresh_cpu_vm_stats(void)
> +static int refresh_cpu_vm_stats(void)
>  {
>  	struct zone *zone;
>  	int i;
>  	int global_diff[NR_VM_ZONE_STAT_ITEMS] = { 0, };
> +	int changes = 0;
> 
>  	for_each_populated_zone(zone) {
>  		struct per_cpu_pageset __percpu *p = zone->pageset;
> @@ -486,15 +500,17 @@ static void refresh_cpu_vm_stats(void)
>  			continue;
>  		}
> 
> -
>  		if (__this_cpu_dec_return(p->expire))
>  			continue;
> 
> -		if (__this_cpu_read(p->pcp.count))
> +		if (__this_cpu_read(p->pcp.count)) {
>  			drain_zone_pages(zone, this_cpu_ptr(&p->pcp));
> +			changes++;
> +		}
>  #endif
>  	}
> -	fold_diff(global_diff);
> +	changes += fold_diff(global_diff);
> +	return changes;
>  }
> 
>  /*
> @@ -1228,20 +1244,105 @@ static const struct file_operations proc
>  #ifdef CONFIG_SMP
>  static DEFINE_PER_CPU(struct delayed_work, vmstat_work);
>  int sysctl_stat_interval __read_mostly = HZ;
> +struct cpumask *cpu_stat_off;

I thought you converted it?
