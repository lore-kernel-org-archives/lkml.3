Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbaAXPbk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 10:31:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53021 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbaAXPbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 10:31:38 -0500
Date: Fri, 24 Jan 2014 15:31:35 +0000
From: Mel Gorman <mgorman@suse.de>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, peterz@infradead.org,
        mingo@redhat.com, chegu_vinod@hp.com
Subject: Re: [PATCH 3/9] numa,sched: track from which nodes NUMA faults are
 triggered
Message-ID: <20140124153135.GZ4963@suse.de>
References: <1390342811-11769-1-git-send-email-riel@redhat.com>
 <1390342811-11769-4-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1390342811-11769-4-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 05:20:05PM -0500, riel@redhat.com wrote:
> From: Rik van Riel <riel@redhat.com>
> 
> Track which nodes NUMA faults are triggered from, in other words
> the CPUs on which the NUMA faults happened. This uses a similar
> mechanism to what is used to track the memory involved in numa faults.
> 
> The next patches use this to build up a bitmap of which nodes a
> workload is actively running on.
> 
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Chegu Vinod <chegu_vinod@hp.com>
> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---
>  include/linux/sched.h | 10 ++++++++--
>  kernel/sched/fair.c   | 30 +++++++++++++++++++++++-------
>  2 files changed, 31 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index b8f8476..d14d9fe 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1492,6 +1492,14 @@ struct task_struct {
>  	unsigned long *numa_faults_buffer_memory;
>  
>  	/*
> +	 * Track the nodes where faults are incurred. This is not very
> +	 * interesting on a per-task basis, but it help with smarter
> +	 * numa memory placement for groups of processes.
> +	 */
> +	unsigned long *numa_faults_cpu;
> +	unsigned long *numa_faults_buffer_cpu;
> +

/*
 * Track the nodes the process was running on when a NUMA hinting fault
 * was incurred ......
 */

?

Otherwise the comment is very similar to numa_faults_memory. I'm not
that bothered because the name is descriptive enough.


> +	/*
>  	 * numa_faults_locality tracks if faults recorded during the last
>  	 * scan window were remote/local. The task scan period is adapted
>  	 * based on the locality of the faults with different weights
> @@ -1594,8 +1602,6 @@ extern void task_numa_fault(int last_node, int node, int pages, int flags);
>  extern pid_t task_numa_group_id(struct task_struct *p);
>  extern void set_numabalancing_state(bool enabled);
>  extern void task_numa_free(struct task_struct *p);
> -
> -extern unsigned int sysctl_numa_balancing_migrate_deferred;
>  #else
>  static inline void task_numa_fault(int last_node, int node, int pages,
>  				   int flags)

Should this hunk move to patch 1?

Whether you make the changes or not

Acked-by: Mel Gorman <mgorman@suse.de>

In my last review I complained about magic numbers but I see a later
patch has a subject that at least implies it deals with the numbers.

-- 
Mel Gorman
SUSE Labs
