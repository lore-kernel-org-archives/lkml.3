Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab3ITJzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 05:55:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55119 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab3ITJzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 05:55:40 -0400
Date: Fri, 20 Sep 2013 11:55:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 46/50] sched: numa: Prevent parallel updates to group
 stats during placement
Message-ID: <20130920095526.GT9326@twins.programming.kicks-ass.net>
References: <1378805550-29949-1-git-send-email-mgorman@suse.de>
 <1378805550-29949-47-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378805550-29949-47-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 10:32:26AM +0100, Mel Gorman wrote:
> Having multiple tasks in a group go through task_numa_placement
> simultaneously can lead to a task picking a wrong node to run on, because
> the group stats may be in the middle of an update. This patch avoids
> parallel updates by holding the numa_group lock during placement
> decisions.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
>  kernel/sched/fair.c | 35 +++++++++++++++++++++++------------
>  1 file changed, 23 insertions(+), 12 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 3a92c58..4653f71 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1231,6 +1231,7 @@ static void task_numa_placement(struct task_struct *p)
>  {
>  	int seq, nid, max_nid = -1, max_group_nid = -1;
>  	unsigned long max_faults = 0, max_group_faults = 0;
> +	spinlock_t *group_lock = NULL;
>  
>  	seq = ACCESS_ONCE(p->mm->numa_scan_seq);
>  	if (p->numa_scan_seq == seq)
> @@ -1239,6 +1240,12 @@ static void task_numa_placement(struct task_struct *p)
>  	p->numa_migrate_seq++;
>  	p->numa_scan_period_max = task_scan_max(p);
>  
> +	/* If the task is part of a group prevent parallel updates to group stats */
> +	if (p->numa_group) {
> +		group_lock = &p->numa_group->lock;
> +		spin_lock(group_lock);
> +	}
> +
>  	/* Find the node with the highest number of faults */
>  	for_each_online_node(nid) {
>  		unsigned long faults = 0, group_faults = 0;
> @@ -1277,20 +1284,24 @@ static void task_numa_placement(struct task_struct *p)
>  		}
>  	}
>  
> +	if (p->numa_group) {
> +		/*
> +		 * If the preferred task and group nids are different, 
> +		 * iterate over the nodes again to find the best place.
> +		 */
> +		if (max_nid != max_group_nid) {
> +			unsigned long weight, max_weight = 0;
> +
> +			for_each_online_node(nid) {
> +				weight = task_weight(p, nid) + group_weight(p, nid);
> +				if (weight > max_weight) {
> +					max_weight = weight;
> +					max_nid = nid;
> +				}
>  			}
>  		}
> +
> +		spin_unlock(group_lock);
>  	}
>  
>  	/* Preferred node as the node with the most faults */

If you're going to hold locks you can also do away with all that
atomic_long_*() nonsense :-)
