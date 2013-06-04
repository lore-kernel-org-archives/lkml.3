Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab3FDLDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 07:03:40 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:57274 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab3FDLDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 07:03:35 -0400
Date: Tue, 4 Jun 2013 13:03:31 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH] ftrace: Use schedule_on_each_cpu() as a heavy
 synchronize_sched()
Message-ID: <20130604110329.GA14973@somewhere>
References: <1369785676.15552.55.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369785676.15552.55.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
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

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

If ftrace were to use rcu_dereference_sched() instead of rcu_dereference_raw(), I guess
the issue would have been detected before. But I guess we want to avoid that for
tracing recursion?

Thanks.
