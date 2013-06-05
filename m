Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab3FELwD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 07:52:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49796 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab3FELwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 07:52:01 -0400
Date: Wed, 5 Jun 2013 13:51:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH] ftrace: Use schedule_on_each_cpu() as a heavy
 synchronize_sched()
Message-ID: <20130605115147.GF8923@twins.programming.kicks-ass.net>
References: <1369785676.15552.55.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369785676.15552.55.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 08:01:16PM -0400, Steven Rostedt wrote:
> The function tracer uses preempt_disable/enable_notrace() for
> synchronization between reading registered ftrace_ops and unregistering
> them.
> 
> Most of the ftrace_ops are global permanent structures that do not
> require this synchronization. That is, ops may be added and removed from
> the hlist but are never freed, and wont hurt if a synchronization is
> missed.
> 
> But this is not true for dynamically created ftrace_ops or control_ops,
> which are used by the perf function tracing.
> 
> The problem here is that the function tracer can be used to trace
> kernel/user context switches as well as going to and from idle.
> Basically, it can be used to trace blind spots of the RCU subsystem.
> This means that even though preempt_disable() is done, a
> synchronize_sched() will ignore CPUs that haven't made it out of user
> space or idle. These can include functions that are being traced just
> before entering or exiting the kernel sections.
> 
> To implement the RCU synchronization, instead of using
> synchronize_sched() the use of schedule_on_each_cpu() is performed. This
> means that when a dynamically allocated ftrace_ops, or a control ops is
> being unregistered, all CPUs must be touched and execute a ftrace_sync()
> stub function via the work queues. This will rip CPUs out from idle or
> in dynamic tick mode. This only happens when a user disables perf
> function tracing or other dynamically allocated function tracers, but it
> allows us to continue to debug RCU and context tracking with function
> tracing.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Index: linux-trace.git/kernel/trace/ftrace.c
> ===================================================================
> --- linux-trace.git.orig/kernel/trace/ftrace.c
> +++ linux-trace.git/kernel/trace/ftrace.c
> @@ -413,6 +413,17 @@ static int __register_ftrace_function(st
>  	return 0;
>  }
>  
> +static void ftrace_sync(struct work_struct *work)
> +{
> +	/*
> +	 * This function is just a stub to implement a hard force
> +	 * of synchronize_sched(). This requires synchronizing
> +	 * tasks even in userspace and idle.
> +	 *
> +	 * Yes, function tracing is rude.
> +	 */
> +}
> +
>  static int __unregister_ftrace_function(struct ftrace_ops *ops)
>  {
>  	int ret;
> @@ -440,8 +451,12 @@ static int __unregister_ftrace_function(
>  			 * so there'll be no new users. We must ensure
>  			 * all current users are done before we free
>  			 * the control data.
> +			 * Note synchronize_sched() is not enough, as we
> +			 * use preempt_disable() to do RCU, but the function
> +			 * tracer can be called where RCU is not active
> +			 * (before user_exit()).
>  			 */
> -			synchronize_sched();
> +			schedule_on_each_cpu(ftrace_sync);
>  			control_ops_free(ops);
>  		}
>  	} else
> @@ -456,9 +471,13 @@ static int __unregister_ftrace_function(
>  	/*
>  	 * Dynamic ops may be freed, we must make sure that all
>  	 * callers are done before leaving this function.
> +	 *
> +	 * Again, normal synchronize_sched() is not good enough.
> +	 * We need to do a hard force of sched synchronization.
>  	 */
>  	if (ops->flags & FTRACE_OPS_FL_DYNAMIC)
> -		synchronize_sched();
> +		schedule_on_each_cpu(ftrace_sync);
> +
>  
>  	return 0;
>  }
> 

So what happens if schedule_on_each_cpu() returns -ENOMEM? :-)
