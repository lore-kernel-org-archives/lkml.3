Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853Ab3KMUHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 15:07:55 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:25593 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756278Ab3KMUHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 15:07:50 -0500
Date: Wed, 13 Nov 2013 15:07:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Matthew Whitehead <tedheadster@gmail.com>, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, mwhitehe@redhat.com
Subject: Re: nohz problem with idle time on old hardware
Message-ID: <20131113150745.25d597fa@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.02.1311132052240.30673@ionos.tec.linutronix.de>
References: <20131113113927.GA13875@mwhitehe.csb>
	<alpine.DEB.2.02.1311131453500.30673@ionos.tec.linutronix.de>
	<20131113102153.5f10e6b5@gandalf.local.home>
	<20131113103134.5b8cf02f@gandalf.local.home>
	<20131113105737.3f7a0b1b@gandalf.local.home>
	<alpine.DEB.2.02.1311131706260.30673@ionos.tec.linutronix.de>
	<20131113111257.482c2955@gandalf.local.home>
	<20131113161829.GE4138@linux.vnet.ibm.com>
	<20131113112338.7d303c0f@gandalf.local.home>
	<20131113163552.GF4138@linux.vnet.ibm.com>
	<alpine.DEB.2.02.1311132052240.30673@ionos.tec.linutronix.de>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Nov 2013 21:01:57 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> wrote:


> ---------------->
> Subject: NOHZ: Check for nohz active instead of nohz enabled
> 
> RCU and the fine grained idle time accounting functions check
> tick_nohz_enabled. But that variable is merily telling that NOHZ has
> been enabled in the config and not been disabled on the command line.
> 
> But it does not tell anything about nohz being active. That's what all
> this should check for.
> 
> Matthew reported, that the idle accounting on his old P1 machine
> showed bogus values, when he enabled NOHZ in the config and did not
> disable it on the kernel command line. The reason is that his machine
> uses (refined) jiffies as a clocksource which explains why the "fine"
> grained accounting went into lala land, because it depends on when the
> system goes and leaves idle relative to the jiffies increment.
> 
> Provide a tick_nohz_active indicator and let RCU and the accounting
> code use this instead of tick_nohz_enable.
> 
> Reported-by: Matthew Whitehead <tedheadster@gmail.com>

Matthew, can you test this patch to make sure it causes the idle issue
to go away (remember to remove nohz=off from your command line).

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 3822ac0..da6e6de 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -1632,7 +1632,7 @@ module_param(rcu_idle_gp_delay, int, 0644);
>  static int rcu_idle_lazy_gp_delay = RCU_IDLE_LAZY_GP_DELAY;
>  module_param(rcu_idle_lazy_gp_delay, int, 0644);
>  
> -extern int tick_nohz_enabled;
> +extern int tick_nohz_active;
>  
>  /*
>   * Try to advance callbacks for all flavors of RCU on the current CPU, but
> @@ -1729,7 +1729,7 @@ static void rcu_prepare_for_idle(int cpu)
>  	int tne;
>  
>  	/* Handle nohz enablement switches conservatively. */
> -	tne = ACCESS_ONCE(tick_nohz_enabled);
> +	tne = ACCESS_ONCE(tick_nohz_active);
>  	if (tne != rdtp->tick_nohz_enabled_snap) {
>  		if (rcu_cpu_has_callbacks(cpu, NULL))
>  			invoke_rcu_core(); /* force nohz to see update. */
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 3612fc7..a12df5a 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -361,8 +361,8 @@ void __init tick_nohz_init(void)
>  /*
>   * NO HZ enabled ?
>   */
> -int tick_nohz_enabled __read_mostly  = 1;
> -
> +static int tick_nohz_enabled __read_mostly  = 1;
> +int tick_nohz_active  __read_mostly;
>  /*
>   * Enable / Disable tickless mode
>   */
> @@ -465,7 +465,7 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
>  	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
>  	ktime_t now, idle;
>  
> -	if (!tick_nohz_enabled)
> +	if (!tick_nohz_active)
>  		return -1;
>  
>  	now = ktime_get();
> @@ -506,7 +506,7 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
>  	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
>  	ktime_t now, iowait;
>  
> -	if (!tick_nohz_enabled)
> +	if (!tick_nohz_active)
>  		return -1;
>  
>  	now = ktime_get();
> @@ -799,11 +799,6 @@ void tick_nohz_idle_enter(void)
>  	local_irq_disable();
>  
>  	ts = &__get_cpu_var(tick_cpu_sched);
> -	/*
> -	 * set ts->inidle unconditionally. even if the system did not
> -	 * switch to nohz mode the cpu frequency governers rely on the
> -	 * update of the idle time accounting in tick_nohz_start_idle().
> -	 */
>  	ts->inidle = 1;
>  	__tick_nohz_idle_enter(ts);
>  
> @@ -973,7 +968,7 @@ static void tick_nohz_switch_to_nohz(void)
>  	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
>  	ktime_t next;
>  
> -	if (!tick_nohz_enabled)
> +	if (!tick_nohz_active)
>  		return;
>  
>  	local_irq_disable();
> @@ -981,7 +976,7 @@ static void tick_nohz_switch_to_nohz(void)
>  		local_irq_enable();
>  		return;
>  	}
> -
> +	tick_nohz_active = 1;
>  	ts->nohz_mode = NOHZ_MODE_LOWRES;
>  
>  	/*
> @@ -1139,8 +1134,10 @@ void tick_setup_sched_timer(void)
>  	}
>  
>  #ifdef CONFIG_NO_HZ_COMMON
> -	if (tick_nohz_enabled)
> +	if (tick_nohz_enabled) {
>  		ts->nohz_mode = NOHZ_MODE_HIGHRES;
> +		tick_nohz_active = 1;
> +	}
>  #endif
>  }
>  #endif /* HIGH_RES_TIMERS */

