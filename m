Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab3LCIYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 03:24:08 -0500
Received: from www.linutronix.de ([62.245.132.108]:49677 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab3LCIX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 03:23:56 -0500
Date: Tue, 3 Dec 2013 09:23:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] timer fixes for 3.13
Message-ID: <alpine.DEB.2.02.1312030905520.30673@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1245834718-1386059032=:30673"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1245834718-1386059032=:30673
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

Linus,

please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-urgent-for-linus

- timekeeping: Cure a subtle drift issue on GENERIC_TIME_VSYSCALL_OLD
- nohz: Make CONFIG_NO_HZ=n and nohz=off command line option behave
  the same way. Fixes a long standing load accounting wreckage.
- clocksource/ARM: Kconfig update to avoid ARM=n wreckage
- clocksource/ARM: Fixlets for the AT91 and SH clocksource/clockevents
- Trivial documentation update and kzalloc conversion from akpms pile

Thanks,

	tglx

------------------>
Andrew Morton (1):
      tick: Document tick_do_timer_cpu

Joe Perches (1):
      timer: Convert kmalloc_node(...GFP_ZERO...) to kzalloc_node(...)

Laurent Pinchart (4):
      clocksource: sh_mtu2: Release clock when sh_mtu2_register() fails
      clocksource: sh_mtu2: Add clk_prepare/unprepare support
      clocksource: sh_tmu: Release clock when sh_tmu_register() fails
      clocksource: sh_tmu: Add clk_prepare/unprepare support

Martin Schwidefsky (1):
      time: Fix 1ns/tick drift w/ GENERIC_TIME_VSYSCALL_OLD

Stephen Boyd (1):
      clocksource: arm_arch_timer: Hide eventstream Kconfig on non-ARM

Thomas Gleixner (2):
      NOHZ: Check for nohz active instead of nohz enabled
      nohz: Fix another inconsistency between CONFIG_NO_HZ=n and nohz=off

Uwe Kleine-König (1):
      ARM: at91: rm9200: switch back to clockevents_config_and_register


 arch/arm/mach-at91/at91rm9200_time.c |    7 ++-----
 drivers/clocksource/Kconfig          |    1 +
 drivers/clocksource/sh_mtu2.c        |   16 ++++++++++++++--
 drivers/clocksource/sh_tmu.c         |   20 +++++++++++++++++---
 kernel/rcu/tree_plugin.h             |    4 ++--
 kernel/time/tick-common.c            |   15 +++++++++++++++
 kernel/time/tick-sched.c             |   25 ++++++++++++-------------
 kernel/time/timekeeping.c            |    2 +-
 kernel/timer.c                       |    5 ++---
 9 files changed, 66 insertions(+), 29 deletions(-)

diff --git a/arch/arm/mach-at91/at91rm9200_time.c b/arch/arm/mach-at91/at91rm9200_time.c
index f607deb..bc7b363 100644
--- a/arch/arm/mach-at91/at91rm9200_time.c
+++ b/arch/arm/mach-at91/at91rm9200_time.c
@@ -174,7 +174,6 @@ clkevt32k_next_event(unsigned long delta, struct clock_event_device *dev)
 static struct clock_event_device clkevt = {
 	.name		= "at91_tick",
 	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
-	.shift		= 32,
 	.rating		= 150,
 	.set_next_event	= clkevt32k_next_event,
 	.set_mode	= clkevt32k_mode,
@@ -265,11 +264,9 @@ void __init at91rm9200_timer_init(void)
 	at91_st_write(AT91_ST_RTMR, 1);
 
 	/* Setup timer clockevent, with minimum of two ticks (important!!) */
-	clkevt.mult = div_sc(AT91_SLOW_CLOCK, NSEC_PER_SEC, clkevt.shift);
-	clkevt.max_delta_ns = clockevent_delta2ns(AT91_ST_ALMV, &clkevt);
-	clkevt.min_delta_ns = clockevent_delta2ns(2, &clkevt) + 1;
 	clkevt.cpumask = cpumask_of(0);
-	clockevents_register_device(&clkevt);
+	clockevents_config_and_register(&clkevt, AT91_SLOW_CLOCK,
+					2, AT91_ST_ALMV);
 
 	/* register clocksource */
 	clocksource_register_hz(&clk32k, AT91_SLOW_CLOCK);
diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index bdb953e..5c07a56 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -87,6 +87,7 @@ config ARM_ARCH_TIMER
 config ARM_ARCH_TIMER_EVTSTREAM
 	bool "Support for ARM architected timer event stream generation"
 	default y if ARM_ARCH_TIMER
+	depends on ARM_ARCH_TIMER
 	help
 	  This option enables support for event stream generation based on
 	  the ARM architected timer. It is used for waking up CPUs executing
diff --git a/drivers/clocksource/sh_mtu2.c b/drivers/clocksource/sh_mtu2.c
index 4aac9ee..3cf1283 100644
--- a/drivers/clocksource/sh_mtu2.c
+++ b/drivers/clocksource/sh_mtu2.c
@@ -313,8 +313,20 @@ static int sh_mtu2_setup(struct sh_mtu2_priv *p, struct platform_device *pdev)
 		goto err1;
 	}
 
-	return sh_mtu2_register(p, (char *)dev_name(&p->pdev->dev),
-				cfg->clockevent_rating);
+	ret = clk_prepare(p->clk);
+	if (ret < 0)
+		goto err2;
+
+	ret = sh_mtu2_register(p, (char *)dev_name(&p->pdev->dev),
+			       cfg->clockevent_rating);
+	if (ret < 0)
+		goto err3;
+
+	return 0;
+ err3:
+	clk_unprepare(p->clk);
+ err2:
+	clk_put(p->clk);
  err1:
 	iounmap(p->mapbase);
  err0:
diff --git a/drivers/clocksource/sh_tmu.c b/drivers/clocksource/sh_tmu.c
index 78b8dae..63557cd 100644
--- a/drivers/clocksource/sh_tmu.c
+++ b/drivers/clocksource/sh_tmu.c
@@ -472,12 +472,26 @@ static int sh_tmu_setup(struct sh_tmu_priv *p, struct platform_device *pdev)
 		ret = PTR_ERR(p->clk);
 		goto err1;
 	}
+
+	ret = clk_prepare(p->clk);
+	if (ret < 0)
+		goto err2;
+
 	p->cs_enabled = false;
 	p->enable_count = 0;
 
-	return sh_tmu_register(p, (char *)dev_name(&p->pdev->dev),
-			       cfg->clockevent_rating,
-			       cfg->clocksource_rating);
+	ret = sh_tmu_register(p, (char *)dev_name(&p->pdev->dev),
+			      cfg->clockevent_rating,
+			      cfg->clocksource_rating);
+	if (ret < 0)
+		goto err3;
+
+	return 0;
+
+ err3:
+	clk_unprepare(p->clk);
+ err2:
+	clk_put(p->clk);
  err1:
 	iounmap(p->mapbase);
  err0:
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 6abb03d..08a7652 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1632,7 +1632,7 @@ module_param(rcu_idle_gp_delay, int, 0644);
 static int rcu_idle_lazy_gp_delay = RCU_IDLE_LAZY_GP_DELAY;
 module_param(rcu_idle_lazy_gp_delay, int, 0644);
 
-extern int tick_nohz_enabled;
+extern int tick_nohz_active;
 
 /*
  * Try to advance callbacks for all flavors of RCU on the current CPU, but
@@ -1729,7 +1729,7 @@ static void rcu_prepare_for_idle(int cpu)
 	int tne;
 
 	/* Handle nohz enablement switches conservatively. */
-	tne = ACCESS_ONCE(tick_nohz_enabled);
+	tne = ACCESS_ONCE(tick_nohz_active);
 	if (tne != rdtp->tick_nohz_enabled_snap) {
 		if (rcu_cpu_has_callbacks(cpu, NULL))
 			invoke_rcu_core(); /* force nohz to see update. */
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 64522ec..162b03a 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -33,6 +33,21 @@ DEFINE_PER_CPU(struct tick_device, tick_cpu_device);
  */
 ktime_t tick_next_period;
 ktime_t tick_period;
+
+/*
+ * tick_do_timer_cpu is a timer core internal variable which holds the CPU NR
+ * which is responsible for calling do_timer(), i.e. the timekeeping stuff. This
+ * variable has two functions:
+ *
+ * 1) Prevent a thundering herd issue of a gazillion of CPUs trying to grab the
+ *    timekeeping lock all at once. Only the CPU which is assigned to do the
+ *    update is handling it.
+ *
+ * 2) Hand off the duty in the NOHZ idle case by setting the value to
+ *    TICK_DO_TIMER_NONE, i.e. a non existing CPU. So the next cpu which looks
+ *    at it will take over and keep the time keeping alive.  The handover
+ *    procedure also covers cpu hotplug.
+ */
 int tick_do_timer_cpu __read_mostly = TICK_DO_TIMER_BOOT;
 
 /*
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 3612fc7..ea20f7d 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -361,8 +361,8 @@ void __init tick_nohz_init(void)
 /*
  * NO HZ enabled ?
  */
-int tick_nohz_enabled __read_mostly  = 1;
-
+static int tick_nohz_enabled __read_mostly  = 1;
+int tick_nohz_active  __read_mostly;
 /*
  * Enable / Disable tickless mode
  */
@@ -465,7 +465,7 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	ktime_t now, idle;
 
-	if (!tick_nohz_enabled)
+	if (!tick_nohz_active)
 		return -1;
 
 	now = ktime_get();
@@ -506,7 +506,7 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	ktime_t now, iowait;
 
-	if (!tick_nohz_enabled)
+	if (!tick_nohz_active)
 		return -1;
 
 	now = ktime_get();
@@ -711,8 +711,10 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
 		return false;
 	}
 
-	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))
+	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE)) {
+		ts->sleep_length = (ktime_t) { .tv64 = NSEC_PER_SEC/HZ };
 		return false;
+	}
 
 	if (need_resched())
 		return false;
@@ -799,11 +801,6 @@ void tick_nohz_idle_enter(void)
 	local_irq_disable();
 
 	ts = &__get_cpu_var(tick_cpu_sched);
-	/*
-	 * set ts->inidle unconditionally. even if the system did not
-	 * switch to nohz mode the cpu frequency governers rely on the
-	 * update of the idle time accounting in tick_nohz_start_idle().
-	 */
 	ts->inidle = 1;
 	__tick_nohz_idle_enter(ts);
 
@@ -973,7 +970,7 @@ static void tick_nohz_switch_to_nohz(void)
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 	ktime_t next;
 
-	if (!tick_nohz_enabled)
+	if (!tick_nohz_active)
 		return;
 
 	local_irq_disable();
@@ -981,7 +978,7 @@ static void tick_nohz_switch_to_nohz(void)
 		local_irq_enable();
 		return;
 	}
-
+	tick_nohz_active = 1;
 	ts->nohz_mode = NOHZ_MODE_LOWRES;
 
 	/*
@@ -1139,8 +1136,10 @@ void tick_setup_sched_timer(void)
 	}
 
 #ifdef CONFIG_NO_HZ_COMMON
-	if (tick_nohz_enabled)
+	if (tick_nohz_enabled) {
 		ts->nohz_mode = NOHZ_MODE_HIGHRES;
+		tick_nohz_active = 1;
+	}
 #endif
 }
 #endif /* HIGH_RES_TIMERS */
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 3abf534..87b4f00 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1347,7 +1347,7 @@ static inline void old_vsyscall_fixup(struct timekeeper *tk)
 	tk->xtime_nsec -= remainder;
 	tk->xtime_nsec += 1ULL << tk->shift;
 	tk->ntp_error += remainder << tk->ntp_error_shift;
-
+	tk->ntp_error -= (1ULL << tk->shift) << tk->ntp_error_shift;
 }
 #else
 #define old_vsyscall_fixup(tk)
diff --git a/kernel/timer.c b/kernel/timer.c
index 6582b82..accfd24 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1518,9 +1518,8 @@ static int init_timers_cpu(int cpu)
 			/*
 			 * The APs use this path later in boot
 			 */
-			base = kmalloc_node(sizeof(*base),
-						GFP_KERNEL | __GFP_ZERO,
-						cpu_to_node(cpu));
+			base = kzalloc_node(sizeof(*base), GFP_KERNEL,
+					    cpu_to_node(cpu));
 			if (!base)
 				return -ENOMEM;
 
--8323329-1245834718-1386059032=:30673--
