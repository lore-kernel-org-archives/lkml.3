Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab3LISzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 13:55:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755294Ab3LISy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 13:54:59 -0500
Message-ID: <52A611FB.7000305@redhat.com>
Date: Mon, 09 Dec 2013 13:54:51 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Alex Thorlton <athorlton@sgi.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Drew Jones <drjones@redhat.com>
Subject: Re: [PATCH 17/18] sched: Tracepoint task movement
References: <1386572952-1191-1-git-send-email-mgorman@suse.de> <1386572952-1191-18-git-send-email-mgorman@suse.de>
In-Reply-To: <1386572952-1191-18-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 02:09 AM, Mel Gorman wrote:
> move_task() is called from move_one_task and move_tasks and is an
> approximation of load balancer activity. We should be able to track
> tasks that move between CPUs frequently. If the tracepoint included node
> information then we could distinguish between in-node and between-node
> traffic for load balancer decisions. The tracepoint allows us to track
> local migrations, remote migrations and average task migrations.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Does this replicate the task_sched_migrate_task tracepoint in
set_task_cpu() ?

I know Drew has been using that tracepoint in his (still experimental)
numatop script. Drew, does this tracepoint look better than the trace
point that you are currently using, or is it similar enough that we do
not really benefit from this addition?

> diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
> index 04c3084..cf1694c 100644
> --- a/include/trace/events/sched.h
> +++ b/include/trace/events/sched.h
> @@ -443,6 +443,41 @@ TRACE_EVENT(sched_process_hang,
>  );
>  #endif /* CONFIG_DETECT_HUNG_TASK */
>  
> +/*
> + * Tracks migration of tasks from one runqueue to another. Can be used to
> + * detect if automatic NUMA balancing is bouncing between nodes
> + */
> +TRACE_EVENT(sched_move_task,
> +
> +	TP_PROTO(struct task_struct *tsk, int src_cpu, int dst_cpu),
> +
> +	TP_ARGS(tsk, src_cpu, dst_cpu),
> +
> +	TP_STRUCT__entry(
> +		__field( pid_t,	pid			)
> +		__field( pid_t,	tgid			)
> +		__field( pid_t,	ngid			)
> +		__field( int,	src_cpu			)
> +		__field( int,	src_nid			)
> +		__field( int,	dst_cpu			)
> +		__field( int,	dst_nid			)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->pid		= task_pid_nr(tsk);
> +		__entry->tgid		= task_tgid_nr(tsk);
> +		__entry->ngid		= task_numa_group_id(tsk);
> +		__entry->src_cpu	= src_cpu;
> +		__entry->src_nid	= cpu_to_node(src_cpu);
> +		__entry->dst_cpu	= dst_cpu;
> +		__entry->dst_nid	= cpu_to_node(dst_cpu);
> +	),
> +
> +	TP_printk("pid=%d tgid=%d ngid=%d src_cpu=%d src_nid=%d dst_cpu=%d dst_nid=%d",
> +			__entry->pid, __entry->tgid, __entry->ngid,
> +			__entry->src_cpu, __entry->src_nid,
> +			__entry->dst_cpu, __entry->dst_nid)
> +);
>  #endif /* _TRACE_SCHED_H */
>  
>  /* This part must be outside protection */
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 1ce1615..41021c8 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4770,6 +4770,8 @@ static void move_task(struct task_struct *p, struct lb_env *env)
>  	set_task_cpu(p, env->dst_cpu);
>  	activate_task(env->dst_rq, p, 0);
>  	check_preempt_curr(env->dst_rq, p, 0);
> +
> +	trace_sched_move_task(p, env->src_cpu, env->dst_cpu);
>  }
>  
>  /*
> 


-- 
All rights reversed
