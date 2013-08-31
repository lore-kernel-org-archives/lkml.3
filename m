Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab3HaTpX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 15:45:23 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:44679 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756552Ab3HaTpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 15:45:20 -0400
Date: Sat, 31 Aug 2013 12:45:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH 04/18 v2] ftrace: Add test for ops against unsafe
 RCU functions in callback
Message-ID: <20130831194506.GL3871@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130831051117.884125230@goodmis.org>
 <20130831051701.094939841@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130831051701.094939841@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13083119-9332-0000-0000-000001448DC3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 31, 2013 at 01:11:21AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> When more than one ftrace_ops is registered, the list function is
> is used to call all registered functions. It uses the filter and
> notrace hashes from the ftrace_ops to determine if the corresponding
> callback should be called or not.
> 
> Currently, it does not take into account for RCU unsafe functions.
> If multiple functions are registered, and an RCU safe callback is
> used on a RCU unsafe function, and the RCU unsafe callback says to
> trace all functions, it will end up tracing this RCU unsafe function
> and still suffer the problems when using RCU when RCU tracing is
> off.
> 
> Add a test to the multiple ops list function to test if the ops in
> question can use an RCU unsafe function or not, and if the function
> being traced happens to be an RCU unsafe function.
> 
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  kernel/trace/ftrace.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index a45deaa..06504b2 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1480,7 +1480,9 @@ ftrace_ops_test(struct ftrace_ops *ops, unsigned long ip, void *regs)
>  	if ((ftrace_hash_empty(filter_hash) ||
>  	     ftrace_lookup_ip(filter_hash, ip)) &&
>  	    (ftrace_hash_empty(notrace_hash) ||
> -	     !ftrace_lookup_ip(notrace_hash, ip)))
> +	     !ftrace_lookup_ip(notrace_hash, ip)) &&
> +	    (ops->flags & FTRACE_OPS_FL_RCU_SAFE ||
> +	     !ftrace_lookup_ip(ftrace_unsafe_rcu, ip)))
>  		ret = 1;
>  	else
>  		ret = 0;
> -- 
> 1.7.10.4
> 
> 

