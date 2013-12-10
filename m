Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab3LJJqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:46:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726Ab3LJJpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:45:55 -0500
Date: Tue, 10 Dec 2013 10:06:39 +0100
From: Andrew Jones <drjones@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Alex Thorlton <athorlton@sgi.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 17/18] sched: Tracepoint task movement
Message-ID: <20131210090639.GA2370@hawk.usersys.redhat.com>
References: <1386572952-1191-1-git-send-email-mgorman@suse.de>
 <1386572952-1191-18-git-send-email-mgorman@suse.de>
 <52A611FB.7000305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A611FB.7000305@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 01:54:51PM -0500, Rik van Riel wrote:
> On 12/09/2013 02:09 AM, Mel Gorman wrote:
> > move_task() is called from move_one_task and move_tasks and is an
> > approximation of load balancer activity. We should be able to track
> > tasks that move between CPUs frequently. If the tracepoint included node
> > information then we could distinguish between in-node and between-node
> > traffic for load balancer decisions. The tracepoint allows us to track
> > local migrations, remote migrations and average task migrations.
> > 
> > Signed-off-by: Mel Gorman <mgorman@suse.de>
> 
> Does this replicate the task_sched_migrate_task tracepoint in
> set_task_cpu() ?
> 
> I know Drew has been using that tracepoint in his (still experimental)
> numatop script. Drew, does this tracepoint look better than the trace
> point that you are currently using, or is it similar enough that we do
> not really benefit from this addition?

Right, sched::sched_migrate_task only gives us pid, orig_cpu, and
dest_cpu, but all the fields below are important. The numamigtop script
has been extracting/using all that information as well, but by using the
pid and /proc, plus a cpu-node map built from /sys info. I agree with Mel
that enhancing the tracepoint is a good idea. Doing so, would allow trace
data of this sort to be analyzed without a tool, or at least with a much
simpler tool.

drew

> 
> > diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
> > index 04c3084..cf1694c 100644
> > --- a/include/trace/events/sched.h
> > +++ b/include/trace/events/sched.h
> > @@ -443,6 +443,41 @@ TRACE_EVENT(sched_process_hang,
> >  );
> >  #endif /* CONFIG_DETECT_HUNG_TASK */
> >  
> > +/*
> > + * Tracks migration of tasks from one runqueue to another. Can be used to
> > + * detect if automatic NUMA balancing is bouncing between nodes
> > + */
> > +TRACE_EVENT(sched_move_task,
> > +
> > +	TP_PROTO(struct task_struct *tsk, int src_cpu, int dst_cpu),
> > +
> > +	TP_ARGS(tsk, src_cpu, dst_cpu),
> > +
> > +	TP_STRUCT__entry(
> > +		__field( pid_t,	pid			)
> > +		__field( pid_t,	tgid			)
> > +		__field( pid_t,	ngid			)
> > +		__field( int,	src_cpu			)
> > +		__field( int,	src_nid			)
> > +		__field( int,	dst_cpu			)
> > +		__field( int,	dst_nid			)
> > +	),
> > +
> > +	TP_fast_assign(
> > +		__entry->pid		= task_pid_nr(tsk);
> > +		__entry->tgid		= task_tgid_nr(tsk);
> > +		__entry->ngid		= task_numa_group_id(tsk);
> > +		__entry->src_cpu	= src_cpu;
> > +		__entry->src_nid	= cpu_to_node(src_cpu);
> > +		__entry->dst_cpu	= dst_cpu;
> > +		__entry->dst_nid	= cpu_to_node(dst_cpu);
> > +	),
> > +
> > +	TP_printk("pid=%d tgid=%d ngid=%d src_cpu=%d src_nid=%d dst_cpu=%d dst_nid=%d",
> > +			__entry->pid, __entry->tgid, __entry->ngid,
> > +			__entry->src_cpu, __entry->src_nid,
> > +			__entry->dst_cpu, __entry->dst_nid)
> > +);
> >  #endif /* _TRACE_SCHED_H */
> >  
> >  /* This part must be outside protection */
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index 1ce1615..41021c8 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -4770,6 +4770,8 @@ static void move_task(struct task_struct *p, struct lb_env *env)
> >  	set_task_cpu(p, env->dst_cpu);
> >  	activate_task(env->dst_rq, p, 0);
> >  	check_preempt_curr(env->dst_rq, p, 0);
> > +
> > +	trace_sched_move_task(p, env->src_cpu, env->dst_cpu);
> >  }
> >  
> >  /*
> > 
> 
> 
> -- 
> All rights reversed
