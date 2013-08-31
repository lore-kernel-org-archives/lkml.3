Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab3HaT4H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 15:56:07 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41460 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878Ab3HaT4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 15:56:04 -0400
Date: Sat, 31 Aug 2013 12:55:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH 12/18 v2] ftrace: Disable RCU unsafe checker when
 function graph is enabled
Message-ID: <20130831195550.GR3871@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130831051117.884125230@goodmis.org>
 <20130831051702.436132384@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130831051702.436132384@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13083119-5806-0000-0000-000022988E5E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 31, 2013 at 01:11:29AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Having the RCU unsafe checker running when function graph is enabled
> can cause a live lock. That's because the RCU unsafe checker enables
> full lockdep debugging on RCU which does a lot of interal calls that
> may be traced by the function graph tacer. This adds quite a bit of

s/tacer/tracer/  (Yeah, yeah, picky, picky!)

> overhead and can possibly live lock the system.
> 
> Just do not do the RCU unsafe checks when function graph tracer is
> enabled.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

One question: How does the user/tester/developer know that RCU-unsafe
checks have been disabled by function-graph tracing?  Would it make
sense to print something to dmesg calling this out?  Or do the transitions
happen too often?

							Thanx, Paul

> ---
>  kernel/trace/ftrace.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 69b7f62..310b727 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -5118,6 +5118,12 @@ int register_ftrace_graph(trace_func_graph_ret_t retfunc,
>  		goto out;
>  	}
> 
> +	/*
> +	 * The Unsafe RCU checker can live lock function graph tracing.
> +	 * It's best to just disable it while doing the fgraph tracing.
> +	 */
> +	ftrace_unsafe_rcu_checker_disable();
> +
>  	ftrace_graph_return = retfunc;
>  	ftrace_graph_entry = entryfunc;
> 
> @@ -5141,6 +5147,7 @@ void unregister_ftrace_graph(void)
>  	ftrace_shutdown(&global_ops, FTRACE_STOP_FUNC_RET);
>  	unregister_pm_notifier(&ftrace_suspend_notifier);
>  	unregister_trace_sched_switch(ftrace_graph_probe_sched_switch, NULL);
> +	ftrace_unsafe_rcu_checker_enable();
> 
>   out:
>  	mutex_unlock(&ftrace_lock);
> -- 
> 1.7.10.4
> 
> 

