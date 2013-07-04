Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab3GDM3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:29:15 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:45822 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643Ab3GDM0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:26:55 -0400
Date: Thu, 4 Jul 2013 17:56:44 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/13] sched: Reschedule task on preferred NUMA node once
 selected
Message-ID: <20130704122644.GA29916@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1372861300-9973-1-git-send-email-mgorman@suse.de>
 <1372861300-9973-7-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1372861300-9973-7-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070412-3620-0000-0000-00000364FD64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mel Gorman <mgorman@suse.de> [2013-07-03 15:21:33]:

> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 2a0bbc2..b9139be 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -800,6 +800,37 @@ unsigned int sysctl_numa_balancing_scan_delay = 1000;
>   */
>  unsigned int sysctl_numa_balancing_settle_count __read_mostly = 3;
> 
> +static unsigned long weighted_cpuload(const int cpu);
> +
> +static int
> +find_idlest_cpu_node(int this_cpu, int nid)
> +{
> +	unsigned long load, min_load = ULONG_MAX;
> +	int i, idlest_cpu = this_cpu;
> +
> +	BUG_ON(cpu_to_node(this_cpu) == nid);
> +
> +	for_each_cpu(i, cpumask_of_node(nid)) {
> +		load = weighted_cpuload(i);
> +
> +		if (load < min_load) {
> +			struct task_struct *p;
> +
> +			/* Do not preempt a task running on its preferred node */
> +			struct rq *rq = cpu_rq(i);
> +			raw_spin_lock_irq(&rq->lock);

Not sure why we need this spin_lock? Cant this be done in a rcu block
instead?


-- 
Thanks and Regards
Srikar Dronamraju

