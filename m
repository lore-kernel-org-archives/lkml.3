Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbaATQwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 11:52:32 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33608 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaATQw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 11:52:29 -0500
Date: Mon, 20 Jan 2014 17:52:05 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, chegu_vinod@hp.com,
        mgorman@suse.de, mingo@redhat.com,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 4/7] numa,sched: tracepoints for NUMA balancing active
 nodemask changes
Message-ID: <20140120165205.GJ31570@twins.programming.kicks-ass.net>
References: <1389993129-28180-1-git-send-email-riel@redhat.com>
 <1389993129-28180-5-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389993129-28180-5-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 04:12:06PM -0500, riel@redhat.com wrote:
> From: Rik van Riel <riel@redhat.com>
> 
> Being able to see how the active nodemask changes over time, and why,
> can be quite useful.
> 
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Chegu Vinod <chegu_vinod@hp.com>
> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---
>  include/trace/events/sched.h | 34 ++++++++++++++++++++++++++++++++++
>  kernel/sched/fair.c          |  8 ++++++--
>  2 files changed, 40 insertions(+), 2 deletions(-)
> 
> diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
> index 67e1bbf..91726b6 100644
> --- a/include/trace/events/sched.h
> +++ b/include/trace/events/sched.h
> @@ -530,6 +530,40 @@ TRACE_EVENT(sched_swap_numa,
>  			__entry->dst_pid, __entry->dst_tgid, __entry->dst_ngid,
>  			__entry->dst_cpu, __entry->dst_nid)
>  );
> +
> +TRACE_EVENT(update_numa_active_nodes_mask,

Please stick to the sched_ naming for these things.

Ideally we'd rename the sysctls too :/

> +++ b/kernel/sched/fair.c
> @@ -1300,10 +1300,14 @@ static void update_numa_active_node_mask(struct task_struct *p)
>  		faults = numa_group->faults_from[task_faults_idx(nid, 0)] +
>  			 numa_group->faults_from[task_faults_idx(nid, 1)];
>  		if (!node_isset(nid, numa_group->active_nodes)) {
> -			if (faults > max_faults * 4 / 10)
> +			if (faults > max_faults * 4 / 10) {
> +				trace_update_numa_active_nodes_mask(current->pid, numa_group->gid, nid, true, faults, max_faults);

While I think the tracepoint hookery is smart enough to avoid evaluating
arguments when they're disabled, it might be best to simply pass:
current and numa_group and do the dereference in fast_assign().

That said, this is the first and only numa tracepoint, I'm not sure why
this qualifies and other metrics do not.


