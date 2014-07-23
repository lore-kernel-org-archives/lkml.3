Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487AbaGWXnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 19:43:45 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:41047 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758439AbaGWXno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 19:43:44 -0400
MIME-Version: 1.0
In-Reply-To: <20140723162851.GA17665@linux.vnet.ibm.com>
References: <20140723162851.GA17665@linux.vnet.ibm.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Wed, 23 Jul 2014 19:43:12 -0400
Message-ID: <CAJhHMCB2P1c25XXTHTYecvdO+oZbtVLDuo6Vpp+r=0uoFT3HQw@mail.gmail.com>
Subject: Re: [PATCH RFC tip/core/rcu 1/2] Eliminate redundant
 rcu_sysidle_state variable
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>, tglx@linutronix.de,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, dvhart@linux.intel.com,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 12:28 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> Now that we have rcu_state_p, which references rcu_preempt_state for
> TREE_PREEMPT_RCU and rcu_sched_state for TREE_RCU, we don't need a
> separate rcu_sysidle_state variable.  This commit therefore eliminates
> rcu_preempt_state in favor of rcu_state_p.
>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>

Reviewed-by: Pranith Kumar <bobby.prani@gmail.com>


> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 24f5bd54ca9b..e31fa71c4d3a 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -2662,16 +2662,6 @@ static void __maybe_unused rcu_kick_nohz_cpu(int cpu)
>
>  #ifdef CONFIG_NO_HZ_FULL_SYSIDLE
>
> -/*
> - * Define RCU flavor that holds sysidle state.  This needs to be the
> - * most active flavor of RCU.
> - */
> -#ifdef CONFIG_PREEMPT_RCU
> -static struct rcu_state *rcu_sysidle_state = &rcu_preempt_state;
> -#else /* #ifdef CONFIG_PREEMPT_RCU */
> -static struct rcu_state *rcu_sysidle_state = &rcu_sched_state;
> -#endif /* #else #ifdef CONFIG_PREEMPT_RCU */
> -
>  static int full_sysidle_state;         /* Current system-idle state. */
>  #define RCU_SYSIDLE_NOT                0       /* Some CPU is not idle. */
>  #define RCU_SYSIDLE_SHORT      1       /* All CPUs idle for brief period. */
> @@ -2813,7 +2803,7 @@ static void rcu_sysidle_check_cpu(struct rcu_data *rdp, bool *isidle,
>          * not the flavor of RCU that tracks sysidle state, or if this
>          * is an offline or the timekeeping CPU, nothing to do.
>          */
> -       if (!*isidle || rdp->rsp != rcu_sysidle_state ||
> +       if (!*isidle || rdp->rsp != rcu_state_p ||
>             cpu_is_offline(rdp->cpu) || rdp->cpu == tick_do_timer_cpu)
>                 return;
>         if (rcu_gp_in_progress(rdp->rsp))
> @@ -2839,7 +2829,7 @@ static void rcu_sysidle_check_cpu(struct rcu_data *rdp, bool *isidle,
>   */
>  static bool is_sysidle_rcu_state(struct rcu_state *rsp)
>  {
> -       return rsp == rcu_sysidle_state;
> +       return rsp == rcu_state_p;
>  }
>
>  /*
> @@ -2917,7 +2907,7 @@ static void rcu_sysidle_cancel(void)
>  static void rcu_sysidle_report(struct rcu_state *rsp, int isidle,
>                                unsigned long maxj, bool gpkt)
>  {
> -       if (rsp != rcu_sysidle_state)
> +       if (rsp != rcu_state_p)
>                 return;  /* Wrong flavor, ignore. */
>         if (gpkt && nr_cpu_ids <= CONFIG_NO_HZ_FULL_SYSIDLE_SMALL)
>                 return;  /* Running state machine from timekeeping CPU. */
> @@ -2986,13 +2976,12 @@ bool rcu_sys_is_idle(void)
>
>                         /* Scan all the CPUs looking for nonidle CPUs. */
>                         for_each_possible_cpu(cpu) {
> -                               rdp = per_cpu_ptr(rcu_sysidle_state->rda, cpu);
> +                               rdp = per_cpu_ptr(rcu_state_p->rda, cpu);
>                                 rcu_sysidle_check_cpu(rdp, &isidle, &maxj);
>                                 if (!isidle)
>                                         break;
>                         }
> -                       rcu_sysidle_report(rcu_sysidle_state,
> -                                          isidle, maxj, false);
> +                       rcu_sysidle_report(rcu_state_p, isidle, maxj, false);
>                         oldrss = rss;
>                         rss = ACCESS_ONCE(full_sysidle_state);
>                 }
> @@ -3019,7 +3008,7 @@ bool rcu_sys_is_idle(void)
>          * provided by the memory allocator.
>          */
>         if (nr_cpu_ids > CONFIG_NO_HZ_FULL_SYSIDLE_SMALL &&
> -           !rcu_gp_in_progress(rcu_sysidle_state) &&
> +           !rcu_gp_in_progress(rcu_state_p) &&
>             !rsh.inuse && xchg(&rsh.inuse, 1) == 0)
>                 call_rcu(&rsh.rh, rcu_sysidle_cb);
>         return false;
>



-- 
Pranith
