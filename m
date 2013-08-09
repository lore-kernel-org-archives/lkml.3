Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968034Ab3HIQVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 12:21:07 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:58921 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934227Ab3HIQVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 12:21:05 -0400
Date: Fri, 9 Aug 2013 18:20:59 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full 6/7] nohz_full: Add full-system-idle state
 machine
Message-ID: <20130809162057.GC13339@somewhere>
References: <20130726231848.GA12967@linux.vnet.ibm.com>
 <1374880764-14248-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1374880764-14248-6-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374880764-14248-6-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 04:19:23PM -0700, Paul E. McKenney wrote:
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index 3edae39..ff84bed 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -28,7 +28,7 @@
>  #include <linux/gfp.h>
>  #include <linux/oom.h>
>  #include <linux/smpboot.h>
> -#include <linux/tick.h>
> +#include "time/tick-internal.h"
>  
>  #define RCU_KTHREAD_PRIO 1
>  
> @@ -2395,12 +2395,12 @@ static void rcu_kick_nohz_cpu(int cpu)
>   * most active flavor of RCU.
>   */
>  #ifdef CONFIG_PREEMPT_RCU
> -static struct rcu_state __maybe_unused *rcu_sysidle_state = &rcu_preempt_state;
> +static struct rcu_state *rcu_sysidle_state = &rcu_preempt_state;
>  #else /* #ifdef CONFIG_PREEMPT_RCU */
> -static struct rcu_state __maybe_unused *rcu_sysidle_state = &rcu_sched_state;
> +static struct rcu_state *rcu_sysidle_state = &rcu_sched_state;
>  #endif /* #else #ifdef CONFIG_PREEMPT_RCU */

Ah you fixed it here. Ok :)

>  
> -static int __maybe_unused full_sysidle_state; /* Current system-idle state. */
> +static int full_sysidle_state;		/* Current system-idle state. */
>  #define RCU_SYSIDLE_NOT		0	/* Some CPU is not idle. */
>  #define RCU_SYSIDLE_SHORT	1	/* All CPUs idle for brief period. */
>  #define RCU_SYSIDLE_LONG	2	/* All CPUs idle for long enough. */
[...]
> +/*
> + * Check to see if the system is fully idle, other than the timekeeping CPU.
> + * The caller must have disabled interrupts.
> + */
> +bool rcu_sys_is_idle(void)
> +{
> +	static struct rcu_sysidle_head rsh;
> +	int rss = ACCESS_ONCE(full_sysidle_state);
> +
> +	if (WARN_ON_ONCE(smp_processor_id() != tick_do_timer_cpu))
> +		return false;
> +
> +	/* Handle small-system case by doing a full scan of CPUs. */
> +	if (nr_cpu_ids <= RCU_SYSIDLE_SMALL) {

I don't understand how the nr_cpu_ids > RCU_SYSIDLE_SMALL is handled. There don't
seem to be other calls of rcu_sysidle_check_cpu() than for small systems.
