Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758385AbaLJX3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 18:29:00 -0500
Received: from smtprelay0063.hostedemail.com ([216.40.44.63]:56629 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758348AbaLJX26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 18:28:58 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:327:355:379:541:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:1801:2194:2198:2199:2200:2393:2559:2562:2828:2892:2895:2896:2901:2924:2926:3138:3139:3140:3141:3142:3165:3865:3866:3867:3868:3870:3871:3872:3874:4031:4250:4321:4605:5007:6119:6261:7875:7974:8660:9010:9038:10004:10848:11026:11232:11473:11658:11914:12043:12219:12294:12296:12438:12517:12519:12555:12679:13148:13161:13229:13230:13972:14096:14097:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: trip24_139eac51b6c5d
X-Filterd-Recvd-Size: 23605
Message-ID: <1418254133.18092.22.camel@perches.com>
Subject: [PATCH] treewide: Convert clockevents_notify to use int cpu
From: Joe Perches <joe@perches.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-acpi@vger.kernel.org,
        linux-pm <linux-pm@vger.kernel.org>
Date: Wed, 10 Dec 2014 15:28:53 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As far as I can tell, there's no value indirecting
the cpu passed to this function via a void *.

Update all the callers and called functions from within
clockevents_notify.

Miscellanea:

Add pr_fmt and convert one printk(KERN_ERR to pr_err

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/arm/mach-omap2/cpuidle44xx.c      |  7 +++----
 arch/arm/mach-tegra/cpuidle-tegra114.c |  4 ++--
 arch/arm/mach-tegra/cpuidle-tegra20.c  |  8 ++++----
 arch/arm/mach-tegra/cpuidle-tegra30.c  |  8 ++++----
 arch/x86/kernel/process.c              |  6 +++---
 arch/x86/xen/suspend.c                 |  2 +-
 drivers/acpi/acpi_pad.c                |  9 +++++----
 drivers/acpi/processor_idle.c          |  4 ++--
 drivers/cpuidle/driver.c               |  3 +--
 drivers/idle/intel_idle.c              |  7 +++----
 include/linux/clockchips.h             |  6 +++---
 kernel/sched/idle.c                    |  4 ++--
 kernel/time/clockevents.c              | 15 +++++++--------
 kernel/time/hrtimer.c                  |  6 ++----
 kernel/time/tick-broadcast.c           | 16 ++++++++--------
 kernel/time/tick-common.c              | 16 ++++++++--------
 kernel/time/tick-internal.h            | 18 +++++++++---------
 kernel/time/timekeeping.c              |  4 ++--
 18 files changed, 69 insertions(+), 74 deletions(-)

diff --git a/arch/arm/mach-omap2/cpuidle44xx.c b/arch/arm/mach-omap2/cpuidle44xx.c
index 01e398a..5d50aa1 100644
--- a/arch/arm/mach-omap2/cpuidle44xx.c
+++ b/arch/arm/mach-omap2/cpuidle44xx.c
@@ -112,7 +112,7 @@ static int omap_enter_idle_coupled(struct cpuidle_device *dev,
 	mpuss_can_lose_context = (cx->mpu_state == PWRDM_POWER_RET) &&
 				 (cx->mpu_logic_state == PWRDM_POWER_OFF);
 
-	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu_id);
+	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, cpu_id);
 
 	/*
 	 * Call idle CPU PM enter notifier chain so that
@@ -169,7 +169,7 @@ static int omap_enter_idle_coupled(struct cpuidle_device *dev,
 	if (dev->cpu == 0 && mpuss_can_lose_context)
 		cpu_cluster_pm_exit();
 
-	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu_id);
+	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, cpu_id);
 
 fail:
 	cpuidle_coupled_parallel_barrier(dev, &abort_barrier);
@@ -184,8 +184,7 @@ fail:
  */
 static void omap_setup_broadcast_timer(void *arg)
 {
-	int cpu = smp_processor_id();
-	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ON, &cpu);
+	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ON, smp_processor_id());
 }
 
 static struct cpuidle_driver omap4_idle_driver = {
diff --git a/arch/arm/mach-tegra/cpuidle-tegra114.c b/arch/arm/mach-tegra/cpuidle-tegra114.c
index f2b586d..3b2fc3f 100644
--- a/arch/arm/mach-tegra/cpuidle-tegra114.c
+++ b/arch/arm/mach-tegra/cpuidle-tegra114.c
@@ -44,7 +44,7 @@ static int tegra114_idle_power_down(struct cpuidle_device *dev,
 	tegra_set_cpu_in_lp2();
 	cpu_pm_enter();
 
-	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu);
+	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, dev->cpu);
 
 	call_firmware_op(prepare_idle);
 
@@ -52,7 +52,7 @@ static int tegra114_idle_power_down(struct cpuidle_device *dev,
 	if (call_firmware_op(do_idle, 0) == -ENOSYS)
 		cpu_suspend(0, tegra30_sleep_cpu_secondary_finish);
 
-	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
+	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, dev->cpu);
 
 	cpu_pm_exit();
 	tegra_clear_cpu_in_lp2();
diff --git a/arch/arm/mach-tegra/cpuidle-tegra20.c b/arch/arm/mach-tegra/cpuidle-tegra20.c
index 4f25a7c..ab30758 100644
--- a/arch/arm/mach-tegra/cpuidle-tegra20.c
+++ b/arch/arm/mach-tegra/cpuidle-tegra20.c
@@ -136,11 +136,11 @@ static bool tegra20_cpu_cluster_power_down(struct cpuidle_device *dev,
 	if (tegra20_reset_cpu_1() || !tegra_cpu_rail_off_ready())
 		return false;
 
-	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu);
+	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, dev->cpu);
 
 	tegra_idle_lp2_last();
 
-	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
+	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, dev->cpu);
 
 	if (cpu_online(1))
 		tegra20_wake_cpu1_from_reset();
@@ -153,13 +153,13 @@ static bool tegra20_idle_enter_lp2_cpu_1(struct cpuidle_device *dev,
 					 struct cpuidle_driver *drv,
 					 int index)
 {
-	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu);
+	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, dev->cpu);
 
 	cpu_suspend(0, tegra20_sleep_cpu_secondary_finish);
 
 	tegra20_cpu_clear_resettable();
 
-	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
+	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, dev->cpu);
 
 	return true;
 }
diff --git a/arch/arm/mach-tegra/cpuidle-tegra30.c b/arch/arm/mach-tegra/cpuidle-tegra30.c
index f8815ed..67d0492 100644
--- a/arch/arm/mach-tegra/cpuidle-tegra30.c
+++ b/arch/arm/mach-tegra/cpuidle-tegra30.c
@@ -76,11 +76,11 @@ static bool tegra30_cpu_cluster_power_down(struct cpuidle_device *dev,
 		return false;
 	}
 
-	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu);
+	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, dev->cpu);
 
 	tegra_idle_lp2_last();
 
-	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
+	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, dev->cpu);
 
 	return true;
 }
@@ -90,13 +90,13 @@ static bool tegra30_cpu_core_power_down(struct cpuidle_device *dev,
 					struct cpuidle_driver *drv,
 					int index)
 {
-	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu);
+	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, dev->cpu);
 
 	smp_wmb();
 
 	cpu_suspend(0, tegra30_sleep_cpu_secondary_finish);
 
-	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
+	clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, dev->cpu);
 
 	return true;
 }
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index e127dda..09290b0 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -380,10 +380,10 @@ static void amd_e400_idle(void)
 			 * Force broadcast so ACPI can not interfere.
 			 */
 			clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_FORCE,
-					   &cpu);
+					   cpu);
 			pr_info("Switch to broadcast mode on CPU%d\n", cpu);
 		}
-		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
+		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, cpu);
 
 		default_idle();
 
@@ -392,7 +392,7 @@ static void amd_e400_idle(void)
 		 * called with interrupts disabled.
 		 */
 		local_irq_disable();
-		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
+		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, cpu);
 		local_irq_enable();
 	} else
 		default_idle();
diff --git a/arch/x86/xen/suspend.c b/arch/x86/xen/suspend.c
index c4df9db..61bab6a 100644
--- a/arch/x86/xen/suspend.c
+++ b/arch/x86/xen/suspend.c
@@ -87,7 +87,7 @@ static void xen_vcpu_notify_restore(void *data)
 	if ( smp_processor_id() == 0)
 		return;
 
-	clockevents_notify(reason, NULL);
+	clockevents_notify(reason, -1);
 }
 
 void xen_arch_resume(void)
diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
index c7b105c..63138e4 100644
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -180,17 +180,18 @@ static int power_saving_thread(void *data)
 			if (lapic_detected_unstable && !lapic_marked_unstable) {
 				int i;
 				/* LAPIC could halt in idle, so notify users */
-				for_each_online_cpu(i)
+				for_each_online_cpu(i) {
 					clockevents_notify(
 						CLOCK_EVT_NOTIFY_BROADCAST_ON,
-						&i);
+						i);
+				}
 				lapic_marked_unstable = 1;
 			}
 			local_irq_disable();
 			cpu = smp_processor_id();
 			if (lapic_marked_unstable)
 				clockevents_notify(
-					CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
+					CLOCK_EVT_NOTIFY_BROADCAST_ENTER, cpu);
 			stop_critical_timings();
 
 			mwait_idle_with_hints(power_saving_mwait_eax, 1);
@@ -198,7 +199,7 @@ static int power_saving_thread(void *data)
 			start_critical_timings();
 			if (lapic_marked_unstable)
 				clockevents_notify(
-					CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
+					CLOCK_EVT_NOTIFY_BROADCAST_EXIT, cpu);
 			local_irq_enable();
 
 			if (time_before(expire_time, jiffies)) {
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 4995365..2eaa450 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -162,7 +162,7 @@ static void __lapic_timer_propagate_broadcast(void *arg)
 	reason = pr->power.timer_broadcast_on_state < INT_MAX ?
 		CLOCK_EVT_NOTIFY_BROADCAST_ON : CLOCK_EVT_NOTIFY_BROADCAST_OFF;
 
-	clockevents_notify(reason, &pr->id);
+	clockevents_notify(reason, pr->id);
 }
 
 static void lapic_timer_propagate_broadcast(struct acpi_processor *pr)
@@ -183,7 +183,7 @@ static void lapic_timer_state_broadcast(struct acpi_processor *pr,
 
 		reason = broadcast ?  CLOCK_EVT_NOTIFY_BROADCAST_ENTER :
 			CLOCK_EVT_NOTIFY_BROADCAST_EXIT;
-		clockevents_notify(reason, &pr->id);
+		clockevents_notify(reason, pr->id);
 	}
 }
 
diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
index 2697e87..2fcc20b 100644
--- a/drivers/cpuidle/driver.c
+++ b/drivers/cpuidle/driver.c
@@ -143,8 +143,7 @@ static inline void __cpuidle_unset_driver(struct cpuidle_driver *drv)
  */
 static void cpuidle_setup_broadcast_timer(void *arg)
 {
-	int cpu = smp_processor_id();
-	clockevents_notify((long)(arg), &cpu);
+	clockevents_notify((long)arg, smp_processor_id());
 }
 
 /**
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 9cceacb..945b1f3 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -582,12 +582,12 @@ static int intel_idle(struct cpuidle_device *dev,
 		leave_mm(cpu);
 
 	if (!(lapic_timer_reliable_states & (1 << (cstate))))
-		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
+		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, cpu);
 
 	mwait_idle_with_hints(eax, ecx);
 
 	if (!(lapic_timer_reliable_states & (1 << (cstate))))
-		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
+		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, cpu);
 
 	return index;
 }
@@ -595,12 +595,11 @@ static int intel_idle(struct cpuidle_device *dev,
 static void __setup_broadcast_timer(void *arg)
 {
 	unsigned long reason = (unsigned long)arg;
-	int cpu = smp_processor_id();
 
 	reason = reason ?
 		CLOCK_EVT_NOTIFY_BROADCAST_ON : CLOCK_EVT_NOTIFY_BROADCAST_OFF;
 
-	clockevents_notify(reason, &cpu);
+	clockevents_notify(reason, smp_processor_id());
 }
 
 static int cpu_hotplug_notify(struct notifier_block *n,
diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 2e4cb67..4e03069 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -195,9 +195,9 @@ static inline void tick_setup_hrtimer_broadcast(void) {};
 #endif
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
-extern int clockevents_notify(unsigned long reason, void *arg);
+extern int clockevents_notify(unsigned long reason, int cpu);
 #else
-static inline int clockevents_notify(unsigned long reason, void *arg) { return 0; }
+static inline int clockevents_notify(unsigned long reason, int cpu) { return 0; }
 #endif
 
 #else /* CONFIG_GENERIC_CLOCKEVENTS_BUILD */
@@ -205,7 +205,7 @@ static inline int clockevents_notify(unsigned long reason, void *arg) { return 0
 static inline void clockevents_suspend(void) {}
 static inline void clockevents_resume(void) {}
 
-static inline int clockevents_notify(unsigned long reason, void *arg) { return 0; }
+static inline int clockevents_notify(unsigned long reason, int cpu) { return 0; }
 static inline int tick_check_broadcast_expired(void) { return 0; }
 static inline void tick_setup_hrtimer_broadcast(void) {};
 
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index c47fce7..e68faee 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -144,7 +144,7 @@ use_default:
 	 * fail if it is not available
 	 */
 	if (broadcast &&
-	    clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu))
+	    clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, dev->cpu))
 		goto use_default;
 
 	/* Take note of the planned idle state. */
@@ -161,7 +161,7 @@ use_default:
 	idle_set_state(this_rq(), NULL);
 
 	if (broadcast)
-		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
+		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, dev->cpu);
 
 	/*
 	 * Give the governor an opportunity to reflect on the outcome
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 5544990..69973be 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -546,11 +546,11 @@ void clockevents_resume(void)
  * clockevents_notify - notification about relevant events
  * Returns 0 on success, any other value on error
  */
-int clockevents_notify(unsigned long reason, void *arg)
+int clockevents_notify(unsigned long reason, int cpu)
 {
 	struct clock_event_device *dev, *tmp;
 	unsigned long flags;
-	int cpu, ret = 0;
+	int ret = 0;
 
 	raw_spin_lock_irqsave(&clockevents_lock, flags);
 
@@ -558,7 +558,7 @@ int clockevents_notify(unsigned long reason, void *arg)
 	case CLOCK_EVT_NOTIFY_BROADCAST_ON:
 	case CLOCK_EVT_NOTIFY_BROADCAST_OFF:
 	case CLOCK_EVT_NOTIFY_BROADCAST_FORCE:
-		tick_broadcast_on_off(reason, arg);
+		tick_broadcast_on_off(reason, cpu);
 		break;
 
 	case CLOCK_EVT_NOTIFY_BROADCAST_ENTER:
@@ -567,7 +567,7 @@ int clockevents_notify(unsigned long reason, void *arg)
 		break;
 
 	case CLOCK_EVT_NOTIFY_CPU_DYING:
-		tick_handover_do_timer(arg);
+		tick_handover_do_timer(cpu);
 		break;
 
 	case CLOCK_EVT_NOTIFY_SUSPEND:
@@ -580,9 +580,9 @@ int clockevents_notify(unsigned long reason, void *arg)
 		break;
 
 	case CLOCK_EVT_NOTIFY_CPU_DEAD:
-		tick_shutdown_broadcast_oneshot(arg);
-		tick_shutdown_broadcast(arg);
-		tick_shutdown(arg);
+		tick_shutdown_broadcast_oneshot(cpu);
+		tick_shutdown_broadcast(cpu);
+		tick_shutdown(cpu);
 		/*
 		 * Unregister the clock event devices which were
 		 * released from the users in the notify chain.
@@ -592,7 +592,6 @@ int clockevents_notify(unsigned long reason, void *arg)
 		/*
 		 * Now check whether the CPU has left unused per cpu devices
 		 */
-		cpu = *((int *)arg);
 		list_for_each_entry_safe(dev, tmp, &clockevent_devices, list) {
 			if (cpumask_test_cpu(cpu, dev->cpumask) &&
 			    cpumask_weight(dev->cpumask) == 1 &&
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 37e50aa..e8c903f 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1717,15 +1717,13 @@ static int hrtimer_cpu_notify(struct notifier_block *self,
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_DYING:
 	case CPU_DYING_FROZEN:
-		clockevents_notify(CLOCK_EVT_NOTIFY_CPU_DYING, &scpu);
+		clockevents_notify(CLOCK_EVT_NOTIFY_CPU_DYING, scpu);
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-	{
-		clockevents_notify(CLOCK_EVT_NOTIFY_CPU_DEAD, &scpu);
+		clockevents_notify(CLOCK_EVT_NOTIFY_CPU_DEAD, scpu);
 		migrate_hrtimers(scpu);
 		break;
-	}
 #endif
 
 	default:
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 066f0ec..4ede817 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -11,6 +11,9 @@
  * This code is licenced under the GPL version 2. For details see
  * kernel-base/COPYING.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/cpu.h>
 #include <linux/err.h>
 #include <linux/hrtimer.h>
@@ -396,11 +399,10 @@ out:
  * Powerstate information: The system enters/leaves a state, where
  * affected devices might stop.
  */
-void tick_broadcast_on_off(unsigned long reason, int *oncpu)
+void tick_broadcast_on_off(unsigned long reason, int oncpu)
 {
-	if (!cpumask_test_cpu(*oncpu, cpu_online_mask))
-		printk(KERN_ERR "tick-broadcast: ignoring broadcast for "
-		       "offline CPU #%d\n", *oncpu);
+	if (!cpumask_test_cpu(oncpu, cpu_online_mask))
+		pr_err("ignoring broadcast for offline CPU #%d\n", oncpu);
 	else
 		tick_do_broadcast_on_off(&reason);
 }
@@ -419,11 +421,10 @@ void tick_set_periodic_handler(struct clock_event_device *dev, int broadcast)
 /*
  * Remove a CPU from broadcasting
  */
-void tick_shutdown_broadcast(unsigned int *cpup)
+void tick_shutdown_broadcast(int cpu)
 {
 	struct clock_event_device *bc;
 	unsigned long flags;
-	unsigned int cpu = *cpup;
 
 	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 
@@ -898,10 +899,9 @@ void tick_broadcast_switch_to_oneshot(void)
 /*
  * Remove a dead CPU from broadcasting
  */
-void tick_shutdown_broadcast_oneshot(unsigned int *cpup)
+void tick_shutdown_broadcast_oneshot(int cpu)
 {
 	unsigned long flags;
-	unsigned int cpu = *cpup;
 
 	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 7efeedf..ae4b200 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -337,14 +337,14 @@ out_bc:
  *
  * Called with interrupts disabled.
  */
-void tick_handover_do_timer(int *cpup)
+void tick_handover_do_timer(int cpu)
 {
-	if (*cpup == tick_do_timer_cpu) {
-		int cpu = cpumask_first(cpu_online_mask);
+	if (cpu != tick_do_timer_cpu)
+		return;
 
-		tick_do_timer_cpu = (cpu < nr_cpu_ids) ? cpu :
-			TICK_DO_TIMER_NONE;
-	}
+	cpu = cpumask_first(cpu_online_mask);
+
+	tick_do_timer_cpu = (cpu < nr_cpu_ids) ? cpu : TICK_DO_TIMER_NONE;
 }
 
 /*
@@ -354,9 +354,9 @@ void tick_handover_do_timer(int *cpup)
  * access the hardware device itself.
  * We just set the mode and remove it from the lists.
  */
-void tick_shutdown(unsigned int *cpup)
+void tick_shutdown(int cpu)
 {
-	struct tick_device *td = &per_cpu(tick_cpu_device, *cpup);
+	struct tick_device *td = &per_cpu(tick_cpu_device, cpu);
 	struct clock_event_device *dev = td->evtdev;
 
 	td->mode = TICKDEV_MODE_PERIODIC;
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 366aeb4..57ab722 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -23,8 +23,8 @@ extern int tick_do_timer_cpu __read_mostly;
 extern void tick_setup_periodic(struct clock_event_device *dev, int broadcast);
 extern void tick_handle_periodic(struct clock_event_device *dev);
 extern void tick_check_new_device(struct clock_event_device *dev);
-extern void tick_handover_do_timer(int *cpup);
-extern void tick_shutdown(unsigned int *cpup);
+extern void tick_handover_do_timer(int cpu);
+extern void tick_shutdown(int cpu);
 extern void tick_suspend(void);
 extern void tick_resume(void);
 extern bool tick_check_replacement(struct clock_event_device *curdev,
@@ -50,7 +50,7 @@ extern void tick_resume_oneshot(void);
 extern void tick_broadcast_setup_oneshot(struct clock_event_device *bc);
 extern int tick_broadcast_oneshot_control(unsigned long reason);
 extern void tick_broadcast_switch_to_oneshot(void);
-extern void tick_shutdown_broadcast_oneshot(unsigned int *cpup);
+extern void tick_shutdown_broadcast_oneshot(int cpu);
 extern int tick_resume_broadcast_oneshot(struct clock_event_device *bc);
 extern int tick_broadcast_oneshot_active(void);
 extern void tick_check_oneshot_broadcast_this_cpu(void);
@@ -62,7 +62,7 @@ static inline void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 }
 static inline int tick_broadcast_oneshot_control(unsigned long reason) { return 0; }
 static inline void tick_broadcast_switch_to_oneshot(void) { }
-static inline void tick_shutdown_broadcast_oneshot(unsigned int *cpup) { }
+static inline void tick_shutdown_broadcast_oneshot(int cpu) { }
 static inline int tick_broadcast_oneshot_active(void) { return 0; }
 static inline void tick_check_oneshot_broadcast_this_cpu(void) { }
 static inline bool tick_broadcast_oneshot_available(void) { return true; }
@@ -90,7 +90,7 @@ static inline void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 	BUG();
 }
 static inline int tick_broadcast_oneshot_control(unsigned long reason) { return 0; }
-static inline void tick_shutdown_broadcast_oneshot(unsigned int *cpup) { }
+static inline void tick_shutdown_broadcast_oneshot(int cpu) { }
 static inline int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
 {
 	return 0;
@@ -113,8 +113,8 @@ static inline void tick_nohz_init(void) { }
 extern int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu);
 extern void tick_install_broadcast_device(struct clock_event_device *dev);
 extern int tick_is_broadcast_device(struct clock_event_device *dev);
-extern void tick_broadcast_on_off(unsigned long reason, int *oncpu);
-extern void tick_shutdown_broadcast(unsigned int *cpup);
+extern void tick_broadcast_on_off(unsigned long reason, int oncpu);
+extern void tick_shutdown_broadcast(int cpu);
 extern void tick_suspend_broadcast(void);
 extern int tick_resume_broadcast(void);
 extern void tick_broadcast_init(void);
@@ -138,8 +138,8 @@ static inline int tick_device_uses_broadcast(struct clock_event_device *dev,
 	return 0;
 }
 static inline void tick_do_periodic_broadcast(struct clock_event_device *d) { }
-static inline void tick_broadcast_on_off(unsigned long reason, int *oncpu) { }
-static inline void tick_shutdown_broadcast(unsigned int *cpup) { }
+static inline void tick_broadcast_on_off(unsigned long reason, int oncpu) { }
+static inline void tick_shutdown_broadcast(int cpu) { }
 static inline void tick_suspend_broadcast(void) { }
 static inline int tick_resume_broadcast(void) { return 0; }
 static inline void tick_broadcast_init(void) { }
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 6a93185..dc84f52 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1245,7 +1245,7 @@ static void timekeeping_resume(void)
 
 	touch_softlockup_watchdog();
 
-	clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL);
+	clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, -1);
 
 	/* Resume hrtimers */
 	hrtimers_resume();
@@ -1299,7 +1299,7 @@ static int timekeeping_suspend(void)
 	write_seqcount_end(&tk_core.seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
-	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
+	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, -1);
 	clocksource_suspend();
 	clockevents_suspend();
 


