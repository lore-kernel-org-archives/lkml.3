Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759957Ab3HNL7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 07:59:21 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:48056 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759708Ab3HNL7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 07:59:16 -0400
Subject: [RFC V2 PATCH 5/6] cpuidle/ppc: Enable dynamic movement of the
 broadcast functionality across CPUs
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
Date: Wed, 14 Aug 2013 17:26:40 +0530
Message-ID: <20130814115640.5193.15902.stgit@preeti.in.ibm.com>
In-Reply-To: <20130814115311.5193.32212.stgit@preeti.in.ibm.com>
References: <20130814115311.5193.32212.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081422-3568-0000-0000-000004154DEF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the current design of the timer offload framework for powerpc, there is a
dedicated broadcast CPU, which is the boot CPU. But this is not good because:

a.It disallows this CPU from being hotplugged out.

b.Overburdening this CPU with the broadcast duty can take
a toll on the performance, which could worsen if this CPU
is already too busy.

c.This could lead to thermal or power imbalance within the chip.

To overcome the above constraints, float around the duty of doing a broadcast
around the CPUs. The current design proposes to choose the first CPU that
attempts to go to deep idle state to be the broadcast CPU/bc_cpu.
It is disallowed from entering deep idle state.

Let the broadcast CPU become invalidated when there are no more CPUs in
the broadcast mask. Until this point the rest of the CPUs attempting to enter
deep idle will be allowed to do so, to be woken up by the broadcast CPU.
Hence the set and unset of the bc_cpu variable is done only by the broadcast
CPU.

Protect the region of all the above activity with a lock in order to avoid
race conditions between readers and writers of the bc_cpu
entry and the broadcast cpus mask. One typical scenario could be:

CPUA				CPUB

Read bc_cpu exists		Is the bc_cpu, finds the broadcast mask
				empty,and invalidates the bc_cpu.

Enter itself into the
the broadcast mask.

Thus, CPUA  would go into deep idle when broadcast handling is inactive.

The broadcast clockevent device is now one single pseudo device capable of working for
all possible cpus (instead of being per-cpu like it was before, there is no
point in having so), due to the dynamic movement of the broadcast CPU. This
is a pseudo device and the dynamic movement of bc_cpu will therefore not affect
its functioning. The broadcast clockevent device's event handler will be called
by the bc_cpu in each of its timer interrupt.

This patchset adds hotplug notifiers to change the bc_cpu, in case it goes
offline. In this case choose the first cpu in the broadcast mask to be the
next bc_cpu and send an IPI, to wake it up to begin to handle broadcast events
thereon. This IPI is the same as the broadcast IPI.
   The idea being the intention of both these scenarios(hotplug and actual
broadcast wakeup) is to wake up a CPU in the broadcast mask, except that
they are for different reasons.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 arch/powerpc/include/asm/time.h                 |    1 
 arch/powerpc/kernel/time.c                      |   10 ++--
 arch/powerpc/platforms/powernv/processor_idle.c |   56 +++++++++++++++++++----
 3 files changed, 53 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/include/asm/time.h b/arch/powerpc/include/asm/time.h
index 936be0d..92260c9 100644
--- a/arch/powerpc/include/asm/time.h
+++ b/arch/powerpc/include/asm/time.h
@@ -25,6 +25,7 @@ extern unsigned long tb_ticks_per_usec;
 extern unsigned long tb_ticks_per_sec;
 extern struct clock_event_device decrementer_clockevent;
 extern struct clock_event_device broadcast_clockevent;
+extern struct clock_event_device bc_timer;
 
 struct rtc_time;
 extern void to_tm(int tim, struct rtc_time * tm);
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 7e858e1..a19c8ca 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -127,9 +127,9 @@ EXPORT_SYMBOL(broadcast_clockevent);
 
 DEFINE_PER_CPU(u64, decrementers_next_tb);
 static DEFINE_PER_CPU(struct clock_event_device, decrementers);
-static DEFINE_PER_CPU(struct clock_event_device, bc_timer);
+struct clock_event_device bc_timer;
 
-int bc_cpu;
+int bc_cpu = -1;
 #define XSEC_PER_SEC (1024*1024)
 
 #ifdef CONFIG_PPC64
@@ -504,7 +504,7 @@ void timer_interrupt(struct pt_regs * regs)
 	struct pt_regs *old_regs;
 	u64 *next_tb = &__get_cpu_var(decrementers_next_tb);
 	struct clock_event_device *evt = &__get_cpu_var(decrementers);
-	struct clock_event_device *bc_evt = &__get_cpu_var(bc_timer);
+	struct clock_event_device *bc_evt = &bc_timer;
 	int cpu = smp_processor_id();
 	u64 now;
 
@@ -879,10 +879,10 @@ static void register_decrementer_clockevent(int cpu)
 
 static void register_broadcast_clockevent(int cpu)
 {
-	struct clock_event_device *bc_evt = &per_cpu(bc_timer, cpu);
+	struct clock_event_device *bc_evt = &bc_timer;
 
 	*bc_evt = broadcast_clockevent;
-	bc_evt->cpumask = cpumask_of(cpu);
+	bc_evt->cpumask = cpu_possible_mask;
 
 	printk_once(KERN_DEBUG "clockevent: %s mult[%x] shift[%d] cpu[%d]\n",
 		    bc_evt->name, bc_evt->mult, bc_evt->shift, cpu);
diff --git a/arch/powerpc/platforms/powernv/processor_idle.c b/arch/powerpc/platforms/powernv/processor_idle.c
index 9aca502..9554da6 100644
--- a/arch/powerpc/platforms/powernv/processor_idle.c
+++ b/arch/powerpc/platforms/powernv/processor_idle.c
@@ -10,6 +10,8 @@
 #include <linux/cpu.h>
 #include <linux/notifier.h>
 #include <linux/clockchips.h>
+#include <linux/tick.h>
+#include <linux/spinlock.h>
 
 #include <asm/machdep.h>
 #include <asm/runlatch.h>
@@ -26,6 +28,8 @@ static int max_idle_state = MAX_IDLE_STATE_COUNT - 1;
 static struct cpuidle_device __percpu *powernv_cpuidle_devices;
 static struct cpuidle_state *cpuidle_state_table;
 
+static DEFINE_SPINLOCK(longnap_idle_lock);
+
 static int snooze_loop(struct cpuidle_device *dev,
 			struct cpuidle_driver *drv,
 			int index)
@@ -70,6 +74,7 @@ static int longnap_loop(struct cpuidle_device *dev,
 	int cpu = dev->cpu;
 
 	unsigned long lpcr = mfspr(SPRN_LPCR);
+	unsigned long flags;
 
 	lpcr &= ~(LPCR_MER | LPCR_PECE); /* lpcr[mer] must be 0 */
 
@@ -78,16 +83,35 @@ static int longnap_loop(struct cpuidle_device *dev,
 	 */
 	lpcr |= LPCR_PECE0;
 
-	if (cpu != bc_cpu) {
-		mtspr(SPRN_LPCR, lpcr);
-		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
-		power7_nap();
-		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
+	spin_lock_irqsave(&longnap_idle_lock, flags);
+
+	if (bc_cpu != -1) {
+		if (cpu != bc_cpu) {
+			mtspr(SPRN_LPCR, lpcr);
+			clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
+			spin_unlock_irqrestore(&longnap_idle_lock, flags);
+
+			power7_nap();
+
+			spin_lock_irqsave(&longnap_idle_lock, flags);
+			clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
+			spin_unlock_irqrestore(&longnap_idle_lock, flags);
+		}
+		else {
+			if (cpumask_empty(tick_get_broadcast_oneshot_mask()))
+				bc_cpu = -1;
+			/* Wakeup on a decrementer interrupt, Do a nap */
+			lpcr |= LPCR_PECE1;
+			mtspr(SPRN_LPCR, lpcr);
+			spin_unlock_irqrestore(&longnap_idle_lock, flags);
+			power7_nap();
+		}
 	} else {
-		/* Wakeup on a decrementer interrupt, Do a nap */
-		lpcr |= LPCR_PECE1;
-		mtspr(SPRN_LPCR, lpcr);
-		power7_nap();
+		/* First CPU to go to longnap, hence become the bc_cpu. Then
+		 * exit idle and re-enter to disable tickless idle on this cpu
+		 */
+		bc_cpu = cpu;
+		spin_unlock_irqrestore(&longnap_idle_lock, flags);
 	}
 
 	return index;
@@ -124,6 +148,8 @@ static int powernv_cpuidle_add_cpu_notifier(struct notifier_block *n,
 			unsigned long action, void *hcpu)
 {
 	int hotcpu = (unsigned long)hcpu;
+	int cpu;
+	unsigned long flags;
 	struct cpuidle_device *dev =
 			per_cpu_ptr(powernv_cpuidle_devices, hotcpu);
 
@@ -136,6 +162,18 @@ static int powernv_cpuidle_add_cpu_notifier(struct notifier_block *n,
 			cpuidle_resume_and_unlock();
 			break;
 
+		case CPU_DYING:
+		case CPU_DYING_FROZEN:
+			spin_lock_irqsave(&longnap_idle_lock, flags);
+			if (hotcpu == bc_cpu)
+				bc_cpu = -1;
+			if (!cpumask_empty(tick_get_broadcast_oneshot_mask())) {
+				cpu = cpumask_first(tick_get_broadcast_oneshot_mask());
+				bc_cpu = cpu;
+				arch_send_tick_broadcast(cpumask_of(cpu));
+			}
+			spin_unlock_irqrestore(&longnap_idle_lock, flags);
+			break;
 		case CPU_DEAD:
 		case CPU_DEAD_FROZEN:
 			cpuidle_pause_and_lock();

