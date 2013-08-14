Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab3HNL70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 07:59:26 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:40195 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759955Ab3HNL7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 07:59:22 -0400
Subject: [RFC V2 PATCH 6/6] cpuidle/ppc : Queue a hrtimer on bc_cpu,
 explicitly to do broadcast handling
To: fweisbec@gmail.com, paul.gortmaker@windriver.com, paulus@samba.org,
        shangw@linux.vnet.ibm.com, galak@kernel.crashing.org,
        deepthi@linux.vnet.ibm.com, benh@kernel.crashing.org,
        paulmck@linux.vnet.ibm.com, arnd@arndb.de, linux-pm@vger.kernel.org,
        rostedt@goodmis.org, rjw@sisk.pl, john.stultz@linaro.org,
        tglx@linutronix.de, chenhui.zhao@freescale.com, michael@ellerman.id.au,
        r58472@freescale.com, geoff@infradead.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Date: Wed, 14 Aug 2013 17:26:50 +0530
Message-ID: <20130814115650.5193.2677.stgit@preeti.in.ibm.com>
In-Reply-To: <20130814115311.5193.32212.stgit@preeti.in.ibm.com>
References: <20130814115311.5193.32212.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081411-3864-0000-0000-000009971042
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the current design we were depending on the timer interrupt on the
bc_cpu to trigger broadcast handling. In tickless idle, timer interrupts
could be many ticks away which could result in missed wakeups on CPUs in deep
idle states. Disabling tickless idle on the bc_cpu is not good for
powersavings.

Therefore queue a hrtimer specifically for broadcast handling. When the broadcast
CPU is chosen, it schedules this hrtimer to fire after a jiffy.
This is meant to initiate broadcast handling. For each expiration of
this hrtimer thereon, it is reprogrammed to fire at the time the next broadcast
handling has to be done. But if there is no pending broadcast handling to be
done in the future, the broadcast cpu is invalidated and the hrtimer is
cancelled. The above cycle repeats when the next CPU attempts to enter sleep state.

Of course the time at which the hrtimer fires initially can be scheduled for
time=target_residency of deep idle state instead of a jiffy, since CPUs going
into deep idle states will not have their next wakeup event before this
target_residency time of the the deep idle state.
  But this patchset is based on longnap which is now used to mimick sleep
but is actually nap with decrementer interrupts disabled. Therefore its
target_residency is the same as nap. The CPUs going into longnap, will
probably need to be woken up sooner than they would have been,had they gone into
sleep. Hence the initial scheduling of the hrtimer is held at a jiffy as of now.

There is one other significant point. On CPU hotplug, the hrtimer on the
broadcast CPU is cancelled, the bc_cpu entry is invalidated, a new
broadcast cpu is chosen as before, and an IPI is sent to it. However instead
of using a broadcast IPI to wake it up, use smp_call_function_single(),
because apart from just wakeup, the new broadcast CPU has to restart
the hrtimer on itself so as to continue broadcast handling.

Signed-off-by: Preeti U Murthy<preeti@linux.vnet.ibm.com>
---

 arch/powerpc/include/asm/time.h                 |    5 ++
 arch/powerpc/kernel/time.c                      |   47 ++++++++++++++++++++---
 arch/powerpc/platforms/powernv/processor_idle.c |   38 ++++++++++++++-----
 3 files changed, 73 insertions(+), 17 deletions(-)

diff --git a/arch/powerpc/include/asm/time.h b/arch/powerpc/include/asm/time.h
index 92260c9..b9a60eb 100644
--- a/arch/powerpc/include/asm/time.h
+++ b/arch/powerpc/include/asm/time.h
@@ -16,6 +16,7 @@
 #ifdef __KERNEL__
 #include <linux/types.h>
 #include <linux/percpu.h>
+#include <linux/ktime.h>
 
 #include <asm/processor.h>
 
@@ -26,6 +27,7 @@ extern unsigned long tb_ticks_per_sec;
 extern struct clock_event_device decrementer_clockevent;
 extern struct clock_event_device broadcast_clockevent;
 extern struct clock_event_device bc_timer;
+extern struct hrtimer *bc_hrtimer;
 
 struct rtc_time;
 extern void to_tm(int tim, struct rtc_time * tm);
@@ -35,7 +37,10 @@ extern void decrementer_timer_interrupt(void);
 extern void generic_calibrate_decr(void);
 
 extern void set_dec_cpu6(unsigned int val);
+extern ktime_t get_next_bc_tick(void);
+extern enum hrtimer_restart handle_broadcast(struct hrtimer *hrtimer);
 extern int bc_cpu;
+extern int bc_hrtimer_initialized;
 
 /* Some sane defaults: 125 MHz timebase, 1GHz processor */
 extern unsigned long ppc_proc_freq;
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index a19c8ca..1a64d58 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -43,6 +43,8 @@
 #include <linux/kernel_stat.h>
 #include <linux/time.h>
 #include <linux/timer.h>
+#include <linux/hrtimer.h>
+#include <linux/ktime.h>
 #include <linux/init.h>
 #include <linux/profile.h>
 #include <linux/cpu.h>
@@ -128,6 +130,8 @@ EXPORT_SYMBOL(broadcast_clockevent);
 DEFINE_PER_CPU(u64, decrementers_next_tb);
 static DEFINE_PER_CPU(struct clock_event_device, decrementers);
 struct clock_event_device bc_timer;
+struct hrtimer *bc_hrtimer;
+int bc_hrtimer_initialized = 0;
 
 int bc_cpu = -1;
 #define XSEC_PER_SEC (1024*1024)
@@ -504,8 +508,6 @@ void timer_interrupt(struct pt_regs * regs)
 	struct pt_regs *old_regs;
 	u64 *next_tb = &__get_cpu_var(decrementers_next_tb);
 	struct clock_event_device *evt = &__get_cpu_var(decrementers);
-	struct clock_event_device *bc_evt = &bc_timer;
-	int cpu = smp_processor_id();
 	u64 now;
 
 	/* Ensure a positive value is written to the decrementer, or else
@@ -551,10 +553,6 @@ void timer_interrupt(struct pt_regs * regs)
 		*next_tb = ~(u64)0;
 		if (evt->event_handler)
 			evt->event_handler(evt);
-		if (cpu == bc_cpu && bc_evt->event_handler) {
-			bc_evt->event_handler(bc_evt);
-		}
-
 	} else {
 		now = *next_tb - now;
 		if (now <= DECREMENTER_MAX)
@@ -864,6 +862,42 @@ static void decrementer_timer_broadcast(const struct cpumask *mask)
 	arch_send_tick_broadcast(mask);
 }
 
+ktime_t get_next_bc_tick(void)
+{
+	u64 next_bc_ns;
+
+	next_bc_ns = (tb_ticks_per_jiffy / tb_ticks_per_usec) * 1000;
+	return ns_to_ktime(next_bc_ns);
+}
+
+enum hrtimer_restart handle_broadcast(struct hrtimer *hrtimer)
+{
+	struct clock_event_device *bc_evt = &bc_timer;
+	int cpu = smp_processor_id();
+	ktime_t interval;
+
+	u64 now = get_tb_or_rtc();
+	ktime_t now_ktime = ns_to_ktime((now / tb_ticks_per_usec) * 1000);
+
+	bc_evt->event_handler(bc_evt);
+
+	/* FIXME: There could be a race condition between the time we do this
+	 * check and invalidate the bc_cpu and CPUs check for the existence of
+	 * bc_cpu and enter longnap_loop.This region could be protected by
+	 * the longnap_idle_lock as well. But is there a better way to handle such
+	 * race conditions, like relying on the existing tick_broadcast_lock
+	 * and remove explicit locking under such circumstances as below?
+	 */
+	if (bc_evt->next_event.tv64 == KTIME_MAX) {
+		bc_cpu = -1;
+		return HRTIMER_NORESTART;
+	}
+
+	interval.tv64 = bc_evt->next_event.tv64 - now_ktime.tv64;
+	hrtimer_forward_now(hrtimer, interval);
+	return HRTIMER_RESTART;
+}
+
 static void register_decrementer_clockevent(int cpu)
 {
 	struct clock_event_device *dec = &per_cpu(decrementers, cpu);
@@ -888,7 +922,6 @@ static void register_broadcast_clockevent(int cpu)
 		    bc_evt->name, bc_evt->mult, bc_evt->shift, cpu);
 
 	clockevents_register_device(bc_evt);
-	bc_cpu = cpu;
 }
 
 static void __init init_decrementer_clockevent(void)
diff --git a/arch/powerpc/platforms/powernv/processor_idle.c b/arch/powerpc/platforms/powernv/processor_idle.c
index 9554da6..8386ef6 100644
--- a/arch/powerpc/platforms/powernv/processor_idle.c
+++ b/arch/powerpc/platforms/powernv/processor_idle.c
@@ -12,6 +12,7 @@
 #include <linux/clockchips.h>
 #include <linux/tick.h>
 #include <linux/spinlock.h>
+#include <linux/slab.h>
 
 #include <asm/machdep.h>
 #include <asm/runlatch.h>
@@ -98,8 +99,6 @@ static int longnap_loop(struct cpuidle_device *dev,
 			spin_unlock_irqrestore(&longnap_idle_lock, flags);
 		}
 		else {
-			if (cpumask_empty(tick_get_broadcast_oneshot_mask()))
-				bc_cpu = -1;
 			/* Wakeup on a decrementer interrupt, Do a nap */
 			lpcr |= LPCR_PECE1;
 			mtspr(SPRN_LPCR, lpcr);
@@ -107,9 +106,21 @@ static int longnap_loop(struct cpuidle_device *dev,
 			power7_nap();
 		}
 	} else {
-		/* First CPU to go to longnap, hence become the bc_cpu. Then
-		 * exit idle and re-enter to disable tickless idle on this cpu
-		 */
+		/* First CPU to go to longnap, hence become the bc_cpu.
+ 		 */
+		if (!bc_hrtimer_initialized) {
+			bc_hrtimer = kmalloc(sizeof(*bc_hrtimer), GFP_KERNEL);
+			if (!bc_hrtimer)
+				return index;
+			hrtimer_init(bc_hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_PINNED);
+			bc_hrtimer->function = handle_broadcast;
+			hrtimer_start(bc_hrtimer, get_next_bc_tick(),
+				HRTIMER_MODE_REL_PINNED);
+			bc_hrtimer_initialized = 1;
+		}
+		else
+			hrtimer_start(bc_hrtimer, get_next_bc_tick(), HRTIMER_MODE_REL_PINNED);
+
 		bc_cpu = cpu;
 		spin_unlock_irqrestore(&longnap_idle_lock, flags);
 	}
@@ -117,6 +128,11 @@ static int longnap_loop(struct cpuidle_device *dev,
 	return index;
 }
 
+static void start_hrtimer(void *data)
+{
+	hrtimer_start(bc_hrtimer, get_next_bc_tick(), HRTIMER_MODE_REL_PINNED);
+}
+
 /*
  * States for dedicated partition case.
  */
@@ -165,12 +181,14 @@ static int powernv_cpuidle_add_cpu_notifier(struct notifier_block *n,
 		case CPU_DYING:
 		case CPU_DYING_FROZEN:
 			spin_lock_irqsave(&longnap_idle_lock, flags);
-			if (hotcpu == bc_cpu)
+			if (hotcpu == bc_cpu) {
 				bc_cpu = -1;
-			if (!cpumask_empty(tick_get_broadcast_oneshot_mask())) {
-				cpu = cpumask_first(tick_get_broadcast_oneshot_mask());
-				bc_cpu = cpu;
-				arch_send_tick_broadcast(cpumask_of(cpu));
+				hrtimer_cancel(bc_hrtimer);
+				if (!cpumask_empty(tick_get_broadcast_oneshot_mask())) {
+					cpu = cpumask_first(tick_get_broadcast_oneshot_mask());
+					bc_cpu = cpu;
+					smp_call_function_single(cpu, start_hrtimer, NULL, 0);
+				}
 			}
 			spin_unlock_irqrestore(&longnap_idle_lock, flags);
 			break;

