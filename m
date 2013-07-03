Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044Ab3GCSdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:33:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45080 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932758Ab3GCSdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:33:21 -0400
Date: Wed, 3 Jul 2013 20:32:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 13/13] sched: Account for the number of preferred tasks
 running on a node when selecting a preferred node
Message-ID: <20130703183243.GB18898@dyad.programming.kicks-ass.net>
References: <1372861300-9973-1-git-send-email-mgorman@suse.de>
 <1372861300-9973-14-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372861300-9973-14-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 03:21:40PM +0100, Mel Gorman wrote:
> ---
>  kernel/sched/fair.c  | 45 ++++++++++++++++++++++++++++++++++++++++++---
>  kernel/sched/sched.h |  4 ++++
>  2 files changed, 46 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 3c796b0..9ffdff3 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -777,6 +777,18 @@ update_stats_curr_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
>   * Scheduling class queueing methods:
>   */
>  
> +static void account_numa_enqueue(struct rq *rq, struct task_struct *p)
> +{
> +	rq->nr_preferred_running +=
> +			(cpu_to_node(task_cpu(p)) == p->numa_preferred_nid);
> +}
> +
> +static void account_numa_dequeue(struct rq *rq, struct task_struct *p)
> +{
> +	rq->nr_preferred_running -=
> +			(cpu_to_node(task_cpu(p)) == p->numa_preferred_nid);
> +}

Ah doing this requires you dequeue before changing ->numa_preferred_nid. I
don't remember seeing that change in this series.
