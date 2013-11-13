Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513Ab3KMVt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 16:49:59 -0500
Received: from mail-qe0-f53.google.com ([209.85.128.53]:56825 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab3KMVtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 16:49:51 -0500
Date: Wed, 13 Nov 2013 16:49:42 -0500
From: Matthew Whitehead <tedheadster@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        john.stultz@linaro.org, linux-kernel@vger.kernel.org,
        mwhitehe@redhat.com
Subject: Re: nohz problem with idle time on old hardware
Message-ID: <20131113214942.GA31722@mwhitehe.csb>
References: <20131113102153.5f10e6b5@gandalf.local.home>
 <20131113103134.5b8cf02f@gandalf.local.home>
 <20131113105737.3f7a0b1b@gandalf.local.home>
 <alpine.DEB.2.02.1311131706260.30673@ionos.tec.linutronix.de>
 <20131113111257.482c2955@gandalf.local.home>
 <20131113161829.GE4138@linux.vnet.ibm.com>
 <20131113112338.7d303c0f@gandalf.local.home>
 <20131113163552.GF4138@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1311132052240.30673@ionos.tec.linutronix.de>
 <20131113150745.25d597fa@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113150745.25d597fa@gandalf.local.home>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 03:07:45PM -0500, Steven Rostedt wrote:
> On Wed, 13 Nov 2013 21:01:57 +0100 (CET)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> 
> > ---------------->
> > Subject: NOHZ: Check for nohz active instead of nohz enabled
> > 
> > RCU and the fine grained idle time accounting functions check
> > tick_nohz_enabled. But that variable is merily telling that NOHZ has
> > been enabled in the config and not been disabled on the command line.
> > 
> > But it does not tell anything about nohz being active. That's what all
> > this should check for.
> > 
> > Matthew reported, that the idle accounting on his old P1 machine
> > showed bogus values, when he enabled NOHZ in the config and did not
> > disable it on the kernel command line. The reason is that his machine
> > uses (refined) jiffies as a clocksource which explains why the "fine"
> > grained accounting went into lala land, because it depends on when the
> > system goes and leaves idle relative to the jiffies increment.
> > 
> > Provide a tick_nohz_active indicator and let RCU and the accounting
> > code use this instead of tick_nohz_enable.
> > 
> > Reported-by: Matthew Whitehead <tedheadster@gmail.com>
> 
> Matthew, can you test this patch to make sure it causes the idle issue
> to go away (remember to remove nohz=off from your command line).
> 

Early testing looks good:

# Verify I haven't overridden nohz as a kernel parameter
root@host:~# grep nohz /proc/cmdline 

# See how my kernel chose its clocksource
root@host:~# dmesg | egrep "TSC|clocksource"
[    0.000000] tsc: Fast TSC calibration using PIT
[    2.492468] Switched to clocksource refined-jiffies
[   24.197356] Switched to clocksource tsc
[   26.211058] Switched to clocksource refined-jiffies

# Check idle time since the reboot
root@host:~# sar -s 16:28:00 -P ALL 
Linux 3.12.0-rc6+ (host)      11/13/2013      _i586_  (2 CPU)

04:28:26 PM       LINUX RESTART

04:32:02 PM     CPU     %user     %nice   %system   %iowait    %steal     %idle
04:34:02 PM     all      4.98      0.00      1.03      0.04      0.00     93.96
04:34:02 PM       0      4.07      0.00      0.69      0.03      0.00     95.21
04:34:02 PM       1      5.88      0.00      1.37      0.06      0.00     92.70
04:36:01 PM     all      4.12      0.00      1.13      0.02      0.00     94.73
04:36:01 PM       0      1.98      0.00      1.34      0.02      0.00     96.66
04:36:01 PM       1      6.28      0.00      0.91      0.03      0.00     92.79
04:38:01 PM     all      0.39      0.00      0.65      0.05      0.00     98.90
04:38:01 PM       0      0.33      0.00      0.54      0.03      0.00     99.09
04:38:01 PM       1      0.45      0.00      0.75      0.07      0.00     98.73
04:40:01 PM     all      0.14      0.00      0.40      0.02      0.00     99.44
04:40:01 PM       0      0.12      0.00      0.26      0.01      0.00     99.62
04:40:01 PM       1      0.16      0.00      0.55      0.02      0.00     99.27
04:42:01 PM     all      0.13      0.00      0.28      0.01      0.00     99.58
04:42:01 PM       0      0.09      0.00      0.14      0.01      0.00     99.76
04:42:01 PM       1      0.16      0.00      0.43      0.02      0.00     99.40
Average:        all      1.95      0.00      0.70      0.03      0.00     97.33
Average:          0      1.32      0.00      0.59      0.02      0.00     98.07
Average:          1      2.58      0.00      0.80      0.04      0.00     96.58

I will continue to test but I think this is good.

Tested-by: Matthew Whitehead <tedheadster@gmail.com>

- Matthew W

> Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
> 
> -- Steve
> 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > ---
> > diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> > index 3822ac0..da6e6de 100644
> > --- a/kernel/rcu/tree_plugin.h
> > +++ b/kernel/rcu/tree_plugin.h
> > @@ -1632,7 +1632,7 @@ module_param(rcu_idle_gp_delay, int, 0644);
> >  static int rcu_idle_lazy_gp_delay = RCU_IDLE_LAZY_GP_DELAY;
> >  module_param(rcu_idle_lazy_gp_delay, int, 0644);
> >  
> > -extern int tick_nohz_enabled;
> > +extern int tick_nohz_active;
> >  
> >  /*
> >   * Try to advance callbacks for all flavors of RCU on the current CPU, but
> > @@ -1729,7 +1729,7 @@ static void rcu_prepare_for_idle(int cpu)
> >  	int tne;
> >  
> >  	/* Handle nohz enablement switches conservatively. */
> > -	tne = ACCESS_ONCE(tick_nohz_enabled);
> > +	tne = ACCESS_ONCE(tick_nohz_active);
> >  	if (tne != rdtp->tick_nohz_enabled_snap) {
> >  		if (rcu_cpu_has_callbacks(cpu, NULL))
> >  			invoke_rcu_core(); /* force nohz to see update. */
> > diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> > index 3612fc7..a12df5a 100644
> > --- a/kernel/time/tick-sched.c
> > +++ b/kernel/time/tick-sched.c
> > @@ -361,8 +361,8 @@ void __init tick_nohz_init(void)
> >  /*
> >   * NO HZ enabled ?
> >   */
> > -int tick_nohz_enabled __read_mostly  = 1;
> > -
> > +static int tick_nohz_enabled __read_mostly  = 1;
> > +int tick_nohz_active  __read_mostly;
> >  /*
> >   * Enable / Disable tickless mode
> >   */
> > @@ -465,7 +465,7 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
> >  	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
> >  	ktime_t now, idle;
> >  
> > -	if (!tick_nohz_enabled)
> > +	if (!tick_nohz_active)
> >  		return -1;
> >  
> >  	now = ktime_get();
> > @@ -506,7 +506,7 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
> >  	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
> >  	ktime_t now, iowait;
> >  
> > -	if (!tick_nohz_enabled)
> > +	if (!tick_nohz_active)
> >  		return -1;
> >  
> >  	now = ktime_get();
> > @@ -799,11 +799,6 @@ void tick_nohz_idle_enter(void)
> >  	local_irq_disable();
> >  
> >  	ts = &__get_cpu_var(tick_cpu_sched);
> > -	/*
> > -	 * set ts->inidle unconditionally. even if the system did not
> > -	 * switch to nohz mode the cpu frequency governers rely on the
> > -	 * update of the idle time accounting in tick_nohz_start_idle().
> > -	 */
> >  	ts->inidle = 1;
> >  	__tick_nohz_idle_enter(ts);
> >  
> > @@ -973,7 +968,7 @@ static void tick_nohz_switch_to_nohz(void)
> >  	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
> >  	ktime_t next;
> >  
> > -	if (!tick_nohz_enabled)
> > +	if (!tick_nohz_active)
> >  		return;
> >  
> >  	local_irq_disable();
> > @@ -981,7 +976,7 @@ static void tick_nohz_switch_to_nohz(void)
> >  		local_irq_enable();
> >  		return;
> >  	}
> > -
> > +	tick_nohz_active = 1;
> >  	ts->nohz_mode = NOHZ_MODE_LOWRES;
> >  
> >  	/*
> > @@ -1139,8 +1134,10 @@ void tick_setup_sched_timer(void)
> >  	}
> >  
> >  #ifdef CONFIG_NO_HZ_COMMON
> > -	if (tick_nohz_enabled)
> > +	if (tick_nohz_enabled) {
> >  		ts->nohz_mode = NOHZ_MODE_HIGHRES;
> > +		tick_nohz_active = 1;
> > +	}
> >  #endif
> >  }
> >  #endif /* HIGH_RES_TIMERS */
> 
