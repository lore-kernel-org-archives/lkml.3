Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab3GDMsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:48:37 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:54598 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab3GDMsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:48:33 -0400
Date: Thu, 4 Jul 2013 18:18:23 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/13] sched: Check current->mm before allocating NUMA
 faults
Message-ID: <20130704124823.GB29916@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1372861300-9973-1-git-send-email-mgorman@suse.de>
 <1372861300-9973-12-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1372861300-9973-12-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070412-3620-0000-0000-00000365075F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mel Gorman <mgorman@suse.de> [2013-07-03 15:21:38]:

> task_numa_placement checks current->mm but after buffers for faults
> have already been uselessly allocated. Move the check earlier.
> 
> [peterz@infradead.org: Identified the problem]
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
>  kernel/sched/fair.c | 22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 336074f..3c796b0 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -870,8 +870,6 @@ static void task_numa_placement(struct task_struct *p)
>  	int seq, nid, max_nid = 0;
>  	unsigned long max_faults = 0;
> 
> -	if (!p->mm)	/* for example, ksmd faulting in a user's mm */
> -		return;
>  	seq = ACCESS_ONCE(p->mm->numa_scan_seq);
>  	if (p->numa_scan_seq == seq)
>  		return;
> @@ -945,6 +943,12 @@ void task_numa_fault(int last_nid, int node, int pages, bool migrated)
>  	if (!sched_feat_numa(NUMA))
>  		return;
> 
> +	/* for example, ksmd faulting in a user's mm */
> +	if (!p->mm) {
> +		p->numa_scan_period = sysctl_numa_balancing_scan_period_max;

Naive question:
Why are we resetting the scan_period?

> +		return;
> +	}
> +
>  	/* Allocate buffer to track faults on a per-node basis */
>  	if (unlikely(!p->numa_faults)) {
>  		int size = sizeof(*p->numa_faults) * 2 * nr_node_ids;
> @@ -1072,16 +1076,18 @@ void task_numa_work(struct callback_head *work)
>  			end = ALIGN(start + (pages << PAGE_SHIFT), HPAGE_SIZE);
>  			end = min(end, vma->vm_end);
>  			nr_pte_updates += change_prot_numa(vma, start, end);
> -			pages -= (end - start) >> PAGE_SHIFT;
> -
> -			start = end;
> 
>  			/*
>  			 * Scan sysctl_numa_balancing_scan_size but ensure that
> -			 * least one PTE is updated so that unused virtual
> -			 * address space is quickly skipped
> +			 * at least one PTE is updated so that unused virtual
> +			 * address space is quickly skipped.
>  			 */
> -			if (pages <= 0 && nr_pte_updates)
> +			if (nr_pte_updates)
> +				pages -= (end - start) >> PAGE_SHIFT;
> +
> +			start = end;
> +
> +			if (pages <= 0)
>  				goto out;
>  		} while (end != vma->vm_end);
>  	}
> -- 
> 1.8.1.4
> 

-- 
Thanks and Regards
Srikar Dronamraju

