Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab3F0OzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 10:55:08 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59375 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab3F0OzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 10:55:05 -0400
Date: Thu, 27 Jun 2013 16:54:58 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/8] sched: Reschedule task on preferred NUMA node once
 selected
Message-ID: <20130627145458.GU28407@twins.programming.kicks-ass.net>
References: <1372257487-9749-1-git-send-email-mgorman@suse.de>
 <1372257487-9749-7-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372257487-9749-7-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 03:38:05PM +0100, Mel Gorman wrote:
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
> +			local_irq_disable();
> +			raw_spin_lock(&rq->lock);

raw_spin_lock_irq() ?

> +			p = rq->curr;
> +			if (p->numa_preferred_nid != nid) {
> +				min_load = load;
> +				idlest_cpu = i;
> +			}
> +			raw_spin_unlock(&rq->lock);
> +			local_irq_disable();
> +		}
> +	}
> +
> +	return idlest_cpu;
> +}
