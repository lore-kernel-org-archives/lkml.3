Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbaEUCHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 22:07:33 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:10802 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751037AbaEUCHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 22:07:32 -0400
Message-ID: <1400638043.9759.5.camel@pippen.local.home>
Subject: Re: [RFC PATCH v2 1/7] tracing: Add __bitmask() macro to trace
 events to cpumasks and other bitmasks
From: Steven Rostedt <rostedt@goodmis.org>
To: Javi Merino <javi.merino@arm.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Punit.Agrawal@arm.com, Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 20 May 2014 22:07:23 -0400
In-Reply-To: <1400595057-8585-2-git-send-email-javi.merino@arm.com>
References: <1400595057-8585-1-git-send-email-javi.merino@arm.com>
	 <1400595057-8585-2-git-send-email-javi.merino@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm, I didn't think about cross tree dependencies. I already pushed this
patch to my for-next branch which is already in linux-next, and I do not
rebase this branch unless there's a really good need to.

I guess I needed to make a separate branch that you could have pulled
separately. I'm not sure how we want to proceed, unless you wait till
Linus pulls my branch before you add this to your tree.

Maybe it would be OK to cherry pick it? I'm not sure Linus would want
that.

Maybe I can make a separate branch that only has this patch and merge it
into my tree, where git will handle the duplicate. But then we have a
strange history.

How urgent is your change? Can it wait till my stuff makes it into
Linus's tree in the 3.16 merge window?


-- Steve


On Tue, 2014-05-20 at 15:10 +0100, Javi Merino wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Being able to show a cpumask of events can be useful as some events
> may affect only some CPUs. There is no standard way to record the
> cpumask and converting it to a string is rather expensive during
> the trace as traces happen in hotpaths. It would be better to record
> the raw event mask and be able to parse it at print time.
> 
> The following macros were added for use with the TRACE_EVENT() macro:
> 
>   __bitmask()
>   __assign_bitmask()
>   __get_bitmask()
> 
> To test this, I added this to the sched_migrate_task event, which
> looked like this:
> 
> TRACE_EVENT(sched_migrate_task,
> 
> 	TP_PROTO(struct task_struct *p, int dest_cpu, const struct cpumask *cpus),
> 
> 	TP_ARGS(p, dest_cpu, cpus),
> 
> 	TP_STRUCT__entry(
> 		__array(	char,	comm,	TASK_COMM_LEN	)
> 		__field(	pid_t,	pid			)
> 		__field(	int,	prio			)
> 		__field(	int,	orig_cpu		)
> 		__field(	int,	dest_cpu		)
> 		__bitmask(	cpumask, num_possible_cpus()	)
> 	),
> 
> 	TP_fast_assign(
> 		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
> 		__entry->pid		= p->pid;
> 		__entry->prio		= p->prio;
> 		__entry->orig_cpu	= task_cpu(p);
> 		__entry->dest_cpu	= dest_cpu;
> 		__assign_bitmask(cpumask, cpumask_bits(cpus), num_possible_cpus());
> 	),
> 
> 	TP_printk("comm=%s pid=%d prio=%d orig_cpu=%d dest_cpu=%d cpumask=%s",
> 		  __entry->comm, __entry->pid, __entry->prio,
> 		  __entry->orig_cpu, __entry->dest_cpu,
> 		  __get_bitmask(cpumask))
> );
> 
> With the output of:
> 
>         ksmtuned-3613  [003] d..2   485.220508: sched_migrate_task: comm=ksmtuned pid=3615 prio=120 orig_cpu=3 dest_cpu=2 cpumask=00000000,0000000f
>      migration/1-13    [001] d..5   485.221202: sched_migrate_task: comm=ksmtuned pid=3614 prio=120 orig_cpu=1 dest_cpu=0 cpumask=00000000,0000000f
>              awk-3615  [002] d.H5   485.221747: sched_migrate_task: comm=rcu_preempt pid=7 prio=120 orig_cpu=0 dest_cpu=1 cpumask=00000000,000000ff
>      migration/2-18    [002] d..5   485.222062: sched_migrate_task: comm=ksmtuned pid=3615 prio=120 orig_cpu=2 dest_cpu=3 cpumask=00000000,0000000f
> 
> Link: http://lkml.kernel.org/r/1399377998-14870-6-git-send-email-javi.merino@arm.com
> Link: http://lkml.kernel.org/r/20140506132238.22e136d1@gandalf.local.home
> 
> Suggested-by: Javi Merino <javi.merino@arm.com>
> Tested-by: Javi Merino <javi.merino@arm.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


