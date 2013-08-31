Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab3HaT6l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 15:58:41 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:49320 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab3HaT6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 15:58:40 -0400
Date: Sat, 31 Aug 2013 12:58:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH 13/18 v2] ftrace: Disable the RCU unsafe checker
 when irqsoff is enabled
Message-ID: <20130831195827.GS3871@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130831051117.884125230@goodmis.org>
 <20130831051702.596618450@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130831051702.596618450@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13083119-7606-0000-0000-00000EC197ED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 31, 2013 at 01:11:30AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> The irqsoff tracer can be called during some of the RCU unsafe
> regions. The proble is that some of the internal calls that it

s/proble/problem/

> makes may also be traced. For example, it uses spin locks. But if
> the spin lock gets traced and the RCU unsafe checker runs, it will
> trigger that RCU is not safe to use. But the only reason a spin lock
> is being used in an RCU unsafe region is because the irqsoff trace
> uses it, and causes a false positive.
> 
> Disable the unsafe RCU checker when irqsoff is enabled.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Looks like a good compromise, as did the previous one involving the
function graph tracer.  Again, though, should we do something to
indicate that RCU safety checks have been disabled?

							Thanx, Paul

> ---
>  kernel/trace/trace_irqsoff.c |   16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
> index 2aefbee..62d603c 100644
> --- a/kernel/trace/trace_irqsoff.c
> +++ b/kernel/trace/trace_irqsoff.c
> @@ -584,9 +584,14 @@ static int start_irqsoff_tracer(struct trace_array *tr, int graph)
> 
>  	ret = register_irqsoff_function(graph, 0);
> 
> -	if (!ret && tracing_is_enabled())
> +	if (!ret && tracing_is_enabled()) {
> +		/*
> +		 * irqsoff tracer can cause unsafe rcu checker
> +		 * to have false positives.
> +		 */
> +		ftrace_unsafe_rcu_checker_disable();
>  		tracer_enabled = 1;
> -	else
> +	} else
>  		tracer_enabled = 0;
> 
>  	return ret;
> @@ -594,6 +599,9 @@ static int start_irqsoff_tracer(struct trace_array *tr, int graph)
> 
>  static void stop_irqsoff_tracer(struct trace_array *tr, int graph)
>  {
> +	if (tracer_enabled)
> +		ftrace_unsafe_rcu_checker_enable();
> +
>  	tracer_enabled = 0;
> 
>  	unregister_irqsoff_function(graph);
> @@ -630,11 +638,15 @@ static void irqsoff_tracer_reset(struct trace_array *tr)
> 
>  static void irqsoff_tracer_start(struct trace_array *tr)
>  {
> +	if (!tracer_enabled)
> +		ftrace_unsafe_rcu_checker_disable();
>  	tracer_enabled = 1;
>  }
> 
>  static void irqsoff_tracer_stop(struct trace_array *tr)
>  {
> +	if (tracer_enabled)
> +		ftrace_unsafe_rcu_checker_enable();
>  	tracer_enabled = 0;
>  }
> 
> -- 
> 1.7.10.4
> 
> 

