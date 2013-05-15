Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759968Ab3EOTIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 15:08:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:58843 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759799Ab3EOTIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 15:08:09 -0400
Date: Wed, 15 May 2013 21:08:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: [GIT pull] timer fixes for 3.10
Message-ID: <alpine.LFD.2.02.1305152102510.1388@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-urgent-for-linus

Content:

	* Cure for not using zalloc in the first place, which leads to
          random crashes with CPUMASK_OFF_STACK.

	* Revert a user space visible change which broke udev
	
	* Add a missing cpu_online early return introduced by the new
          full dyntick conversions

	* Plug a long standing race in the timer wheel cpu hotplug
          code. Sigh...

	* Cleanup NOHZ per cpu data on cpu down to prevent stale data
          on cpu up.

Thanks,

	tglx

------------------>
John Stultz (1):
      time: Revert ALWAYS_USE_PERSISTENT_CLOCK compile time optimizaitons

Thomas Gleixner (3):
      tick: Use zalloc_cpumask_var for allocating offstack cpumasks
      tick: Cleanup NOHZ per cpu data on cpu down
      tick: Don't invoke tick_nohz_stop_sched_tick() if the cpu is offline

Tirupathi Reddy (1):
      timer: Don't reinitialize the cpu base lock during CPU_UP_PREPARE


 arch/x86/Kconfig             |    1 -
 drivers/rtc/Kconfig          |    2 --
 include/linux/time.h         |    4 ----
 kernel/time/Kconfig          |    5 -----
 kernel/time/tick-broadcast.c |   10 +++++-----
 kernel/time/tick-sched.c     |    3 ++-
 kernel/timer.c               |    2 +-
 7 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5db2117..45c4124 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -108,7 +108,6 @@ config X86
 	select GENERIC_CLOCKEVENTS_BROADCAST if X86_64 || (X86_32 && X86_LOCAL_APIC)
 	select GENERIC_TIME_VSYSCALL if X86_64
 	select KTIME_SCALAR if X86_32
-	select ALWAYS_USE_PERSISTENT_CLOCK
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
 	select HAVE_CONTEXT_TRACKING if X86_64
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 0c81915..b983813 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -20,7 +20,6 @@ if RTC_CLASS
 config RTC_HCTOSYS
 	bool "Set system time from RTC on startup and resume"
 	default y
-	depends on !ALWAYS_USE_PERSISTENT_CLOCK
 	help
 	  If you say yes here, the system time (wall clock) will be set using
 	  the value read from a specified RTC device. This is useful to avoid
@@ -29,7 +28,6 @@ config RTC_HCTOSYS
 config RTC_SYSTOHC
 	bool "Set the RTC time based on NTP synchronization"
 	default y
-	depends on !ALWAYS_USE_PERSISTENT_CLOCK
 	help
 	  If you say yes here, the system time (wall clock) will be stored
 	  in the RTC specified by RTC_HCTOSYS_DEVICE approximately every 11
diff --git a/include/linux/time.h b/include/linux/time.h
index 22d81b3..d5d229b 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -117,14 +117,10 @@ static inline bool timespec_valid_strict(const struct timespec *ts)
 
 extern bool persistent_clock_exist;
 
-#ifdef ALWAYS_USE_PERSISTENT_CLOCK
-#define has_persistent_clock()	true
-#else
 static inline bool has_persistent_clock(void)
 {
 	return persistent_clock_exist;
 }
-#endif
 
 extern void read_persistent_clock(struct timespec *ts);
 extern void read_boot_clock(struct timespec *ts);
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 24510d8..b696922 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -12,11 +12,6 @@ config CLOCKSOURCE_WATCHDOG
 config ARCH_CLOCKSOURCE_DATA
 	bool
 
-# Platforms has a persistent clock
-config ALWAYS_USE_PERSISTENT_CLOCK
-	bool
-	default n
-
 # Timekeeping vsyscall support
 config GENERIC_TIME_VSYSCALL
 	bool
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 61d00a8..d70cdc4 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -785,11 +785,11 @@ bool tick_broadcast_oneshot_available(void)
 
 void __init tick_broadcast_init(void)
 {
-	alloc_cpumask_var(&tick_broadcast_mask, GFP_NOWAIT);
-	alloc_cpumask_var(&tmpmask, GFP_NOWAIT);
+	zalloc_cpumask_var(&tick_broadcast_mask, GFP_NOWAIT);
+	zalloc_cpumask_var(&tmpmask, GFP_NOWAIT);
 #ifdef CONFIG_TICK_ONESHOT
-	alloc_cpumask_var(&tick_broadcast_oneshot_mask, GFP_NOWAIT);
-	alloc_cpumask_var(&tick_broadcast_pending_mask, GFP_NOWAIT);
-	alloc_cpumask_var(&tick_broadcast_force_mask, GFP_NOWAIT);
+	zalloc_cpumask_var(&tick_broadcast_oneshot_mask, GFP_NOWAIT);
+	zalloc_cpumask_var(&tick_broadcast_pending_mask, GFP_NOWAIT);
+	zalloc_cpumask_var(&tick_broadcast_force_mask, GFP_NOWAIT);
 #endif
 }
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 225f8bf..0121421 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -469,6 +469,7 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
 	if (unlikely(!cpu_online(cpu))) {
 		if (cpu == tick_do_timer_cpu)
 			tick_do_timer_cpu = TICK_DO_TIMER_NONE;
+		return false;
 	}
 
 	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))
@@ -904,7 +905,7 @@ void tick_cancel_sched_timer(int cpu)
 		hrtimer_cancel(&ts->sched_timer);
 # endif
 
-	ts->nohz_mode = NOHZ_MODE_INACTIVE;
+	memset(ts, 0, sizeof(*ts));
 }
 #endif
 
diff --git a/kernel/timer.c b/kernel/timer.c
index 09bca8c..7376589 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1539,12 +1539,12 @@ static int __cpuinit init_timers_cpu(int cpu)
 			boot_done = 1;
 			base = &boot_tvec_bases;
 		}
+		spin_lock_init(&base->lock);
 		tvec_base_done[cpu] = 1;
 	} else {
 		base = per_cpu(tvec_bases, cpu);
 	}
 
-	spin_lock_init(&base->lock);
 
 	for (j = 0; j < TVN_SIZE; j++) {
 		INIT_LIST_HEAD(base->tv5.vec + j);
