Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967998Ab3HIPpB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 11:45:01 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:63803 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967927Ab3HIPpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 11:45:00 -0400
Date: Fri, 9 Aug 2013 17:44:56 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full 4/7] nohz_full: Add full-system idle states
 and variables
Message-ID: <20130809154454.GB13339@somewhere>
References: <20130726231848.GA12967@linux.vnet.ibm.com>
 <1374880764-14248-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1374880764-14248-4-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374880764-14248-4-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 04:19:21PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> This commit adds control variables and states for full-system idle.
> The system will progress through the states in numerical order when
> the system is fully idle (other than the timekeeping CPU), and reset
> down to the initial state if any non-timekeeping CPU goes non-idle.
> The current state is kept in full_sysidle_state.
> 
> A RCU_SYSIDLE_SMALL macro is defined, and systems with this number
> of CPUs or fewer move through the states more aggressively.  The idea
> is that the resulting memory contention is less of a problem on small
> systems.  Architectures can adjust this value (which defaults to 8)
> using CONFIG_ARCH_RCU_SYSIDLE_SMALL.
> 
> One flavor of RCU will be in charge of driving the state machine,
> defined by rcu_sysidle_state.  This should be the busiest flavor of RCU.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/rcutree_plugin.h | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index 814ff47..3edae39 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -2380,6 +2380,34 @@ static void rcu_kick_nohz_cpu(int cpu)
>  #ifdef CONFIG_NO_HZ_FULL_SYSIDLE
>  
>  /*
> + * Handle small systems specially, accelerating their transition into
> + * full idle state.  Allow arches to override this code's idea of
> + * what constitutes a "small" system.
> + */
> +#ifdef CONFIG_ARCH_RCU_SYSIDLE_SMALL
> +#define RCU_SYSIDLE_SMALL CONFIG_ARCH_RCU_SYSIDLE_SMALL
> +#else /* #ifdef CONFIG_ARCH_RCU_SYSIDLE_SMALL */
> +#define RCU_SYSIDLE_SMALL 8
> +#endif
> +
> +/*
> + * Define RCU flavor that holds sysidle state.  This needs to be the
> + * most active flavor of RCU.
> + */
> +#ifdef CONFIG_PREEMPT_RCU
> +static struct rcu_state __maybe_unused *rcu_sysidle_state = &rcu_preempt_state;
> +#else /* #ifdef CONFIG_PREEMPT_RCU */
> +static struct rcu_state __maybe_unused *rcu_sysidle_state = &rcu_sched_state;
> +#endif /* #else #ifdef CONFIG_PREEMPT_RCU */

Why the maybe_unused here? Couldn't we get rid of it if those definitions were
under NO_HZ_FULL_SYSIDLE?

> +
> +static int __maybe_unused full_sysidle_state; /* Current system-idle state. */

Ditto here?

> +#define RCU_SYSIDLE_NOT		0	/* Some CPU is not idle. */
> +#define RCU_SYSIDLE_SHORT	1	/* All CPUs idle for brief period. */
> +#define RCU_SYSIDLE_LONG	2	/* All CPUs idle for long enough. */
> +#define RCU_SYSIDLE_FULL	3	/* All CPUs idle, ready for sysidle. */
> +#define RCU_SYSIDLE_FULL_NOTED	4	/* Actually entered sysidle state. */

This may be better as an enum. This way the variables that store such values can
carry this type and the review becomes easier.

> +
> +/*
>   * Invoked to note exit from irq or task transition to idle.  Note that
>   * usermode execution does -not- count as idle here!  After all, we want
>   * to detect full-system idle states, not RCU quiescent states and grace
> -- 
> 1.8.1.5
> 
