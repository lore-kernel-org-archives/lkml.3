Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbaAOINd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 03:13:33 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:55844 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbaAOINa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 03:13:30 -0500
Subject: [PATCH V5 6/8] time/cpuidle: Support in tick broadcast framework in
 the absence of external clock device
To: daniel.lezcano@linaro.org, peterz@infradead.org, fweisbec@gmail.com,
        agraf@suse.de, paul.gortmaker@windriver.com, paulus@samba.org,
        mingo@kernel.org, mikey@neuling.org, shangw@linux.vnet.ibm.com,
        rafael.j.wysocki@intel.com, galak@kernel.crashing.org,
        benh@kernel.crashing.org, paulmck@linux.vnet.ibm.com, arnd@arndb.de,
        linux-pm@vger.kernel.org, rostedt@goodmis.org, michael@ellerman.id.au,
        john.stultz@linaro.org, anton@samba.org, tglx@linutronix.de,
        chenhui.zhao@freescale.com, deepthi@linux.vnet.ibm.com,
        r58472@freescale.com, geoff@infradead.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Date: Wed, 15 Jan 2014 13:39:48 +0530
Message-ID: <20140115080947.20446.30305.stgit@preeti.in.ibm.com>
In-Reply-To: <20140115080555.20446.27238.stgit@preeti.in.ibm.com>
References: <20140115080555.20446.27238.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011508-1542-0000-0000-0000053F0EF5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some architectures, in certain CPU deep idle states the local timers stop.
An external clock device is used to wakeup these CPUs. The kernel support for the
wakeup of these CPUs is provided by the tick broadcast framework by using the
external clock device as the wakeup source.

However not all implementations of architectures provide such an external
clock device such as some PowerPC ones. This patch includes support in the
broadcast framework to handle the wakeup of the CPUs in deep idle states on such
systems by queuing a hrtimer on one of the CPUs, meant to handle the wakeup of
CPUs in deep idle states. This CPU is identified as the bc_cpu.

Each time the hrtimer expires, it is reprogrammed for the next wakeup of the
CPUs in deep idle state after handling broadcast. However when a CPU is about
to enter  deep idle state with its wakeup time earlier than the time at which
the hrtimer is currently programmed, it *becomes the new bc_cpu* and restarts
the hrtimer on itself. This way the job of doing broadcast is handed around to
the CPUs that ask for the earliest wakeup just before entering deep idle
state. This is consistent with what happens in cases where an external clock
device is present. The smp affinity of this clock device is set to the CPU
with the earliest wakeup.

The important point here is that the bc_cpu cannot enter deep idle state
since it has a hrtimer queued to wakeup the other CPUs in deep idle. Hence it
cannot have its local timer stopped. Therefore for such a CPU, the
BROADCAST_ENTER notification has to fail implying that it cannot enter deep
idle state. On architectures where an external clock device is present, all
CPUs can enter deep idle.

During hotplug of the bc_cpu, the job of doing a broadcast is assigned to the
first cpu in the broadcast mask. This newly nominated bc_cpu is woken up by
an IPI so as to queue the above mentioned hrtimer on it.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 include/linux/clockchips.h   |    4 -
 kernel/time/clockevents.c    |    9 +-
 kernel/time/tick-broadcast.c |  192 ++++++++++++++++++++++++++++++++++++++----
 kernel/time/tick-internal.h  |    8 +-
 4 files changed, 186 insertions(+), 27 deletions(-)

diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 493aa02..bbda37b 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -186,9 +186,9 @@ static inline int tick_check_broadcast_expired(void) { return 0; }
 #endif
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
-extern void clockevents_notify(unsigned long reason, void *arg);
+extern int clockevents_notify(unsigned long reason, void *arg);
 #else
-static inline void clockevents_notify(unsigned long reason, void *arg) {}
+static inline int clockevents_notify(unsigned long reason, void *arg) {}
 #endif
 
 #else /* CONFIG_GENERIC_CLOCKEVENTS_BUILD */
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 086ad60..d61404e 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -524,12 +524,13 @@ void clockevents_resume(void)
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 /**
  * clockevents_notify - notification about relevant events
+ * Returns non zero on error.
  */
-void clockevents_notify(unsigned long reason, void *arg)
+int clockevents_notify(unsigned long reason, void *arg)
 {
 	struct clock_event_device *dev, *tmp;
 	unsigned long flags;
-	int cpu;
+	int cpu, ret = 0;
 
 	raw_spin_lock_irqsave(&clockevents_lock, flags);
 
@@ -542,11 +543,12 @@ void clockevents_notify(unsigned long reason, void *arg)
 
 	case CLOCK_EVT_NOTIFY_BROADCAST_ENTER:
 	case CLOCK_EVT_NOTIFY_BROADCAST_EXIT:
-		tick_broadcast_oneshot_control(reason);
+		ret = tick_broadcast_oneshot_control(reason);
 		break;
 
 	case CLOCK_EVT_NOTIFY_CPU_DYING:
 		tick_handover_do_timer(arg);
+		tick_handover_broadcast_cpu(arg);
 		break;
 
 	case CLOCK_EVT_NOTIFY_SUSPEND:
@@ -585,6 +587,7 @@ void clockevents_notify(unsigned long reason, void *arg)
 		break;
 	}
 	raw_spin_unlock_irqrestore(&clockevents_lock, flags);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(clockevents_notify);
 
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 9532690..1c23912 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -20,6 +20,7 @@
 #include <linux/sched.h>
 #include <linux/smp.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 
 #include "tick-internal.h"
 
@@ -35,6 +36,15 @@ static cpumask_var_t tmpmask;
 static DEFINE_RAW_SPINLOCK(tick_broadcast_lock);
 static int tick_broadcast_force;
 
+/*
+ * Helper variables for handling broadcast in the absence of a
+ * tick_broadcast_device.
+ * */
+static struct hrtimer *bc_hrtimer;
+static int bc_cpu = -1;
+static ktime_t bc_next_wakeup;
+static int hrtimer_initialized = 0;
+
 #ifdef CONFIG_TICK_ONESHOT
 static void tick_broadcast_clear_oneshot(int cpu);
 #else
@@ -528,6 +538,20 @@ static int tick_broadcast_set_event(struct clock_event_device *bc, int cpu,
 	return ret;
 }
 
+static void tick_broadcast_set_next_wakeup(int cpu, ktime_t expires, int force)
+{
+	struct clock_event_device *bc;
+
+	bc = tick_broadcast_device.evtdev;
+
+	if (bc) {
+		tick_broadcast_set_event(bc, cpu, expires, force);
+	} else {
+		hrtimer_start(bc_hrtimer, expires, HRTIMER_MODE_ABS_PINNED);
+		bc_cpu = cpu;
+	}
+}
+
 int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
 {
 	clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
@@ -558,15 +582,13 @@ void tick_check_oneshot_broadcast(int cpu)
 /*
  * Handle oneshot mode broadcasting
  */
-static void tick_handle_oneshot_broadcast(struct clock_event_device *dev)
+static int tick_oneshot_broadcast(void)
 {
 	struct tick_device *td;
 	ktime_t now, next_event;
 	int cpu, next_cpu = 0;
 
-	raw_spin_lock(&tick_broadcast_lock);
-again:
-	dev->next_event.tv64 = KTIME_MAX;
+	bc_next_wakeup.tv64 = KTIME_MAX;
 	next_event.tv64 = KTIME_MAX;
 	cpumask_clear(tmpmask);
 	now = ktime_get();
@@ -620,34 +642,95 @@ again:
 	 * in the event mask
 	 */
 	if (next_event.tv64 != KTIME_MAX) {
-		/*
-		 * Rearm the broadcast device. If event expired,
-		 * repeat the above
-		 */
-		if (tick_broadcast_set_event(dev, next_cpu, next_event, 0))
+		bc_next_wakeup = next_event;
+	}
+
+	return next_cpu;
+}
+
+/*
+ * Handler in oneshot mode for the external clock device
+ */
+static void tick_handle_oneshot_broadcast(struct clock_event_device *dev)
+{
+	int next_cpu;
+
+	raw_spin_lock(&tick_broadcast_lock);
+
+again:	next_cpu = tick_oneshot_broadcast();
+	/*
+	 * Rearm the broadcast device. If event expired,
+	 * repeat the above
+	 */
+	if (bc_next_wakeup.tv64 != KTIME_MAX)
+		if (tick_broadcast_set_event(dev, next_cpu, bc_next_wakeup, 0))
 			goto again;
+
+	raw_spin_unlock(&tick_broadcast_lock);
+}
+
+/*
+ * Handler in oneshot mode for the hrtimer queued when there is no external
+ * clock device.
+ */
+static enum hrtimer_restart handle_broadcast(struct hrtimer *hrtmr)
+{
+	ktime_t now, interval;
+
+	raw_spin_lock(&tick_broadcast_lock);
+	tick_oneshot_broadcast();
+
+	now = ktime_get();
+
+	if (bc_next_wakeup.tv64 != KTIME_MAX) {
+		interval = ktime_sub(bc_next_wakeup, now);
+		hrtimer_forward_now(bc_hrtimer, interval);
+		raw_spin_unlock(&tick_broadcast_lock);
+		return HRTIMER_RESTART;
 	}
 	raw_spin_unlock(&tick_broadcast_lock);
+	return HRTIMER_NORESTART;
+}
+
+/* The CPU could be asked to take over from the previous bc_cpu,
+ * if it is being hotplugged out.
+ */
+static void tick_broadcast_exit_check(int cpu)
+{
+	if (cpu == bc_cpu)
+		hrtimer_start(bc_hrtimer, bc_next_wakeup,
+				HRTIMER_MODE_ABS_PINNED);
+}
+
+static int can_enter_broadcast(int cpu)
+{
+	return cpu != bc_cpu;
 }
 
 /*
  * Powerstate information: The system enters/leaves a state, where
  * affected devices might stop
+ *
+ * Returns non zero value if the entry into broadcast framework failed
+ * This scenario can arise on certain implementations of archs which do
+ * not have an external clock device to do the broadcast. Then one of the
+ * CPUs get nominated to handle broadcasting.
+ * Such a CPU cannot enter a state where its tick device can stop.
  */
-void tick_broadcast_oneshot_control(unsigned long reason)
+int tick_broadcast_oneshot_control(unsigned long reason)
 {
-	struct clock_event_device *bc, *dev;
+	struct clock_event_device *dev;
 	struct tick_device *td;
 	unsigned long flags;
 	ktime_t now;
-	int cpu;
+	int cpu, ret = 0;
 
 	/*
 	 * Periodic mode does not care about the enter/exit of power
 	 * states
 	 */
 	if (tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC)
-		return;
+		return ret;
 
 	/*
 	 * We are called with preemtion disabled from the depth of the
@@ -658,9 +741,8 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 	dev = td->evtdev;
 
 	if (!(dev->features & CLOCK_EVT_FEAT_C3STOP))
-		return;
+		return ret;
 
-	bc = tick_broadcast_device.evtdev;
 
 	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 	if (reason == CLOCK_EVT_NOTIFY_BROADCAST_ENTER) {
@@ -676,12 +758,22 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 			 * woken by the IPI right away.
 			 */
 			if (!cpumask_test_cpu(cpu, tick_broadcast_force_mask) &&
-			    dev->next_event.tv64 < bc->next_event.tv64)
-				tick_broadcast_set_event(bc, cpu, dev->next_event, 1);
+			    dev->next_event.tv64 < bc_next_wakeup.tv64) {
+				bc_next_wakeup = dev->next_event;
+				tick_broadcast_set_next_wakeup(cpu, dev->next_event, 1);
+			}
+
+			if (!can_enter_broadcast(cpu)) {
+				cpumask_clear_cpu(cpu, tick_broadcast_oneshot_mask);
+				clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
+				ret = 1;
+			}
 		}
 	} else {
 		if (cpumask_test_and_clear_cpu(cpu, tick_broadcast_oneshot_mask)) {
 			clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
+
+			tick_broadcast_exit_check(cpu);
 			/*
 			 * The cpu which was handling the broadcast
 			 * timer marked this cpu in the broadcast
@@ -746,6 +838,7 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 	}
 out:
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
+	return ret;
 }
 
 /*
@@ -821,17 +914,57 @@ void tick_broadcast_switch_to_oneshot(void)
 {
 	struct clock_event_device *bc;
 	unsigned long flags;
+	int cpu = smp_processor_id();
 
 	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 
+	bc_next_wakeup.tv64 = KTIME_MAX;
+
 	tick_broadcast_device.mode = TICKDEV_MODE_ONESHOT;
 	bc = tick_broadcast_device.evtdev;
-	if (bc)
+	if (bc) {
 		tick_broadcast_setup_oneshot(bc);
+		bc_next_wakeup = bc->next_event;
+	} else if (hrtimer_initialized) {
+
+		/*
+		 * There may be CPUs waiting for periodic broadcast. We need
+		 * to set the oneshot bits for those and program the hrtimer
+		 * to fire at the next tick period.
+ 		 */
+		cpumask_copy(tmpmask, tick_broadcast_mask);
+		cpumask_clear_cpu(cpu, tmpmask);
+		cpumask_or(tick_broadcast_oneshot_mask,
+			   tick_broadcast_oneshot_mask, tmpmask);
+
+		if (!cpumask_empty(tmpmask)) {
+			tick_broadcast_init_next_event(tmpmask,
+						       tick_next_period);
+			hrtimer_start(bc_hrtimer, tick_next_period, HRTIMER_MODE_ABS_PINNED);
+			bc_next_wakeup = tick_next_period;
+		}
+	}
 
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
 
+/*
+ * Use the broadcast function itself to wake up the new broadcast cpu
+ */
+void tick_handover_broadcast_cpu(int *cpup)
+{
+	struct tick_device *td;
+
+	if (*cpup == bc_cpu) {
+		int cpu = cpumask_first(tick_broadcast_oneshot_mask);
+
+		bc_cpu = (cpu < nr_cpu_ids) ? cpu : -1;
+		if (bc_cpu != -1) {
+			td = &per_cpu(tick_cpu_device, bc_cpu);
+			td->evtdev->broadcast(cpumask_of(bc_cpu));
+		}
+	}
+}
 
 /*
  * Remove a dead CPU from broadcasting
@@ -868,8 +1001,29 @@ int tick_broadcast_oneshot_active(void)
 bool tick_broadcast_oneshot_available(void)
 {
 	struct clock_event_device *bc = tick_broadcast_device.evtdev;
+	bool ret = true;
+	unsigned long flags;
 
-	return bc ? bc->features & CLOCK_EVT_FEAT_ONESHOT : false;
+	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
+
+	if (bc) {
+		ret = bc->features & CLOCK_EVT_FEAT_ONESHOT;
+	} else if (!hrtimer_initialized) {
+		/* An alternative to tick_broadcast_device on archs which do not have
+		 * an external device
+		 */
+		bc_hrtimer = kmalloc(sizeof(*bc_hrtimer), GFP_NOWAIT);
+		if (!bc_hrtimer) {
+			ret = false;
+			goto out;
+		}
+		hrtimer_init(bc_hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_PINNED);
+		bc_hrtimer->function = handle_broadcast;
+		hrtimer_initialized = 1;
+	}
+
+out:	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
+	return ret;
 }
 
 #endif
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 18e71f7..9e42177 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -46,23 +46,25 @@ extern int tick_switch_to_oneshot(void (*handler)(struct clock_event_device *));
 extern void tick_resume_oneshot(void);
 # ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
 extern void tick_broadcast_setup_oneshot(struct clock_event_device *bc);
-extern void tick_broadcast_oneshot_control(unsigned long reason);
+extern int tick_broadcast_oneshot_control(unsigned long reason);
 extern void tick_broadcast_switch_to_oneshot(void);
 extern void tick_shutdown_broadcast_oneshot(unsigned int *cpup);
 extern int tick_resume_broadcast_oneshot(struct clock_event_device *bc);
 extern int tick_broadcast_oneshot_active(void);
 extern void tick_check_oneshot_broadcast(int cpu);
+extern void tick_handover_broadcast_cpu(int *cpup);
 bool tick_broadcast_oneshot_available(void);
 # else /* BROADCAST */
 static inline void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 {
 	BUG();
 }
-static inline void tick_broadcast_oneshot_control(unsigned long reason) { }
+static inline int tick_broadcast_oneshot_control(unsigned long reason) { }
 static inline void tick_broadcast_switch_to_oneshot(void) { }
 static inline void tick_shutdown_broadcast_oneshot(unsigned int *cpup) { }
 static inline int tick_broadcast_oneshot_active(void) { return 0; }
 static inline void tick_check_oneshot_broadcast(int cpu) { }
+static inline void tick_handover_broadcast_cpu(int *cpup) {}
 static inline bool tick_broadcast_oneshot_available(void) { return true; }
 # endif /* !BROADCAST */
 
@@ -87,7 +89,7 @@ static inline void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 {
 	BUG();
 }
-static inline void tick_broadcast_oneshot_control(unsigned long reason) { }
+static inline int tick_broadcast_oneshot_control(unsigned long reason) { }
 static inline void tick_shutdown_broadcast_oneshot(unsigned int *cpup) { }
 static inline int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
 {

