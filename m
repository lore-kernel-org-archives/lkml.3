Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873Ab3LJWWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 17:22:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40791 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab3LJWWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 17:22:13 -0500
Date: Tue, 10 Dec 2013 14:22:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Alex Thorlton <athorlton@sgi.com>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 17/18] sched: Add tracepoints related to NUMA task
 migration
Message-Id: <20131210142211.099fe782c361707ab3c04742@linux-foundation.org>
In-Reply-To: <1386690695-27380-18-git-send-email-mgorman@suse.de>
References: <1386690695-27380-1-git-send-email-mgorman@suse.de>
	<1386690695-27380-18-git-send-email-mgorman@suse.de>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013 15:51:35 +0000 Mel Gorman <mgorman@suse.de> wrote:

> This patch adds three tracepoints
>  o trace_sched_move_numa	when a task is moved to a node
>  o trace_sched_swap_numa	when a task is swapped with another task
>  o trace_sched_stick_numa	when a numa-related migration fails
> 
> The tracepoints allow the NUMA scheduler activity to be monitored and the
> following high-level metrics can be calculated
> 
>  o NUMA migrated stuck	 nr trace_sched_stick_numa
>  o NUMA migrated idle	 nr trace_sched_move_numa
>  o NUMA migrated swapped nr trace_sched_swap_numa
>  o NUMA local swapped	 trace_sched_swap_numa src_nid == dst_nid (should never happen)
>  o NUMA remote swapped	 trace_sched_swap_numa src_nid != dst_nid (should == NUMA migrated swapped)
>  o NUMA group swapped	 trace_sched_swap_numa src_ngid == dst_ngid
> 			 Maybe a small number of these are acceptable
> 			 but a high number would be a major surprise.
> 			 It would be even worse if bounces are frequent.
>  o NUMA avg task migs.	 Average number of migrations for tasks
>  o NUMA stddev task mig	 Self-explanatory
>  o NUMA max task migs.	 Maximum number of migrations for a single task
> 
> In general the intent of the tracepoints is to help diagnose problems
> where automatic NUMA balancing appears to be doing an excessive amount of
> useless work.
> 
> ...
>
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1272,11 +1272,13 @@ static int task_numa_migrate(struct task_struct *p)
>  	p->numa_scan_period = task_scan_min(p);
>  
>  	if (env.best_task == NULL) {
> -		int ret = migrate_task_to(p, env.best_cpu);
> +		if ((ret = migrate_task_to(p, env.best_cpu)) != 0)
> +			trace_sched_stick_numa(p, env.src_cpu, env.best_cpu);
>  		return ret;
>  	}
>  
> -	ret = migrate_swap(p, env.best_task);
> +	if ((ret = migrate_swap(p, env.best_task)) != 0);

I'll zap that semicolon...

> +		trace_sched_stick_numa(p, env.src_cpu, task_cpu(env.best_task));
>  	put_task_struct(env.best_task);
>  	return ret;
>  }

