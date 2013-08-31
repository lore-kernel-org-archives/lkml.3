Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab3HaUA7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 16:00:59 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:58747 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab3HaUA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 16:00:57 -0400
Date: Sat, 31 Aug 2013 13:00:44 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH 15/18 v2] ftrace/rcu: Mark functions that are RCU
 unsafe
Message-ID: <20130831200044.GU3871@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130831051117.884125230@goodmis.org>
 <20130831051702.922659300@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130831051702.922659300@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13083120-8236-0000-0000-0000014F5A88
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 31, 2013 at 01:11:32AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Some callbacks of the function tracer use rcu_read_lock(). This means that
> there's places that can not be traced because RCU is not tracking the CPU
> for various reasons (like NO_HZ_FULL and coming back from userspace).
> 
> Thes functions need to be marked so that callbacks that use RCU do not
> trace them.
> 
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Please let me know if you would like me to take this one.  If I don't
hear otherwise, I will assume that you are pushing it.

							Thanx, Paul

> ---
>  kernel/rcutiny.c |    1 +
>  kernel/rcutree.c |    7 +++++++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
> index aa34411..911a61c 100644
> --- a/kernel/rcutiny.c
> +++ b/kernel/rcutiny.c
> @@ -173,6 +173,7 @@ void rcu_irq_enter(void)
>  	local_irq_restore(flags);
>  }
>  EXPORT_SYMBOL_GPL(rcu_irq_enter);
> +FTRACE_UNSAFE_RCU(rcu_irq_enter);
> 
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 068de3a..ca53562 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -53,6 +53,7 @@
>  #include <linux/delay.h>
>  #include <linux/stop_machine.h>
>  #include <linux/random.h>
> +#include <linux/ftrace.h>
> 
>  #include "rcutree.h"
>  #include <trace/events/rcu.h>
> @@ -373,6 +374,7 @@ static void rcu_eqs_enter_common(struct rcu_dynticks *rdtp, long long oldval,
>  	rcu_lockdep_assert(!lock_is_held(&rcu_sched_lock_map),
>  			   "Illegal idle entry in RCU-sched read-side critical section.");
>  }
> +FTRACE_UNSAFE_RCU(rcu_eqs_enter_common);
> 
>  /*
>   * Enter an RCU extended quiescent state, which can be either the
> @@ -392,6 +394,7 @@ static void rcu_eqs_enter(bool user)
>  		rdtp->dynticks_nesting -= DYNTICK_TASK_NEST_VALUE;
>  	rcu_eqs_enter_common(rdtp, oldval, user);
>  }
> +FTRACE_UNSAFE_RCU(rcu_eqs_enter);
> 
>  /**
>   * rcu_idle_enter - inform RCU that current CPU is entering idle
> @@ -513,6 +516,7 @@ static void rcu_eqs_exit_common(struct rcu_dynticks *rdtp, long long oldval,
>  			  idle->pid, idle->comm); /* must be idle task! */
>  	}
>  }
> +FTRACE_UNSAFE_RCU(rcu_eqs_exit_common);
> 
>  /*
>   * Exit an RCU extended quiescent state, which can be either the
> @@ -553,6 +557,7 @@ void rcu_idle_exit(void)
>  	local_irq_restore(flags);
>  }
>  EXPORT_SYMBOL_GPL(rcu_idle_exit);
> +FTRACE_UNSAFE_RCU(rcu_idle_exit);
> 
>  #ifdef CONFIG_RCU_USER_QS
>  /**
> @@ -565,6 +570,7 @@ void rcu_user_exit(void)
>  {
>  	rcu_eqs_exit(1);
>  }
> +FTRACE_UNSAFE_RCU(rcu_user_exit);
> 
>  /**
>   * rcu_user_exit_after_irq - inform RCU that we won't resume to userspace
> @@ -625,6 +631,7 @@ void rcu_irq_enter(void)
>  		rcu_eqs_exit_common(rdtp, oldval, true);
>  	local_irq_restore(flags);
>  }
> +FTRACE_UNSAFE_RCU(rcu_irq_enter);
> 
>  /**
>   * rcu_nmi_enter - inform RCU of entry to NMI context
> -- 
> 1.7.10.4
> 
> 

