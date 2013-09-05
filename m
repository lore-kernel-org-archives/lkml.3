Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab3IETgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 15:36:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59161 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704Ab3IETgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 15:36:03 -0400
Date: Thu, 5 Sep 2013 21:35:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH 14/18 v2] ftrace/lockdep: Have the RCU lockdep splat
 show what function triggered
Message-ID: <20130905193553.GG31370@twins.programming.kicks-ass.net>
References: <20130831051117.884125230@goodmis.org>
 <20130831051702.766697014@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130831051702.766697014@goodmis.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 31, 2013 at 01:11:31AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Why put RHT in there? Surely greg and jonathan know you work for them?
:-)

> When the RCU lockdep splat hits because of the unsafe RCU checker,
> the backtrace does not always show the culprit. But the culprit was
> passed to the unsafe RCU checker.
> 
> Save the ip of the function being traced in a per_cpu variable, and
> when the RCU lockdep detects a problem, it can also print out what
> function was being traced if it was caused by the unsafe RCU checker.

So the below is an example of why this_cpu_* is utter shite, what
ensures the code there isn't preemptible.

That said, I suppose you've thought about that and there's something
obvious from the callpath but I can't be bothered to go hunt through the
series if the changelog can't be bothered to clarify such things.

> @@ -592,9 +604,11 @@ ftrace_unsafe_callback(unsigned long ip, unsigned long parent_ip,
>  		      (void *)ip))
>  		goto out;
>  
> +	this_cpu_write(ftrace_rcu_func, ip);
>  	/* Should trigger a RCU splat if called from unsafe RCU function */
>  	rcu_read_lock();
>  	rcu_read_unlock();
> +	this_cpu_write(ftrace_rcu_func, 0);
>  
>  	trace_clear_recursion(bit);
>   out:

I suppose this is all ok. I haven't read the entire series and I'm not
going to during my vacation.

One quick question though, why do we have to mark functions and can't
rely on the state RCU already keeps? Surely RCU knows when its 'enabled'
and thus safe to use RCU -- if only for debuggin.

For instance that scheduler_ipi() call can happen in either state, do we
really have to disallow it always?

Anyway, I suppose ACK on both these patches you asked me to look at, not
particularly harmful it seems, just not something I feel I've got me
head round atm.
