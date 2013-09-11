Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab3IKCzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 22:55:05 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:45407 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab3IKCzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 22:55:02 -0400
Subject: [PATCH V3 5/6] cpuidle/ppc: Introduce the deep idle state in which
 the local timers stop
To: benh@kernel.crashing.org, paul.gortmaker@windriver.com, paulus@samba.org,
        shangw@linux.vnet.ibm.com, rjw@sisk.pl, galak@kernel.crashing.org,
        fweisbec@gmail.com, paulmck@linux.vnet.ibm.com, arnd@arndb.de,
        linux-pm@vger.kernel.org, rostedt@goodmis.org, michael@ellerman.id.au,
        john.stultz@linaro.org, tglx@linutronix.de, chenhui.zhao@freescale.com,
        deepthi@linux.vnet.ibm.com, r58472@freescale.com, geoff@infradead.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Date: Wed, 11 Sep 2013 08:22:08 +0530
Message-ID: <20130911025208.27726.37694.stgit@preeti.in.ibm.com>
In-Reply-To: <20130911024906.27726.4735.stgit@preeti.in.ibm.com>
References: <20130911024906.27726.4735.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091102-9332-0000-0000-000001603461
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have the basic infrastructure setup to make use of the broadcast
framework, introduce the deep idle state in which cpus need to avail the
functionality provided by this infrastructure to wake them up at their
expired timer events. On ppc this deep idle state is called sleep.
	In this patch however, we introduce longnap, which emulates sleep
state, by disabling timer interrupts. This is until such time that sleep support is
made available in the kernel.

Since on ppc, we do not have an external device that can wakeup cpus in deep
idle, the local timer of one of the cpus need to be nominated to do this job.
This cpu is called the broadcast cpu/bc_cpu. Only if the bc_cpu is nominated
will the remaining cpus be allowed to enter deep idle state after notifying
the broadcast framework about their next timer event. The bc_cpu is not allowed
to enter deep idle state.

The first cpu that enters longnap is made the bc_cpu. It queues a hrtimer onto
itself which expires after a broadcast period. The job of this
hrtimer is to call into the broadcast framework[1] using the pseudo clock device
that we have initiliazed, in which, the cpus whose wakeup times
have expired are sent an ipi.
	On each expiry of the hrtimer, it is programmed to the earlier of the
next pending timer event of the cpus in deep idle and the broadcast period, so
as to not miss any wakeups.

The broadcast period is nothing but the max duration until which the
bc_cpu need not concern itself with checking for expired timer events on cpus
in deep idle. The broadcast period is set to a jiffy in this patch for debug
purposes. Ideally it needn't be smaller than the target_residency of the deep
idle state.

But having a dedicated bc_cpu would mean overloading just one cpu with the
broadcast work which could hinder its performance apart from leading to thermal
imbalance on the chip. Therefore unassign the bc_cpu when there are no more cpus
in deep idle to be woken up. The bc_cpu is left unassigned until such a time that
a cpu enters longnap to be nominated as the bc_cpu and the above cycle repeats.

Protect the region of nomination,de-nomination and check for existence of broadcast
cpu with a lock to ensure synchronization between them.

[1] tick_handle_oneshot_broadcast() or tick_handle_periodic_broadcast().

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 arch/powerpc/include/asm/time.h     |    1 
 arch/powerpc/kernel/time.c          |    2 
 drivers/cpuidle/cpuidle-ibm-power.c |  150 +++++++++++++++++++++++++++++++++++
 3 files changed, 152 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/time.h b/arch/powerpc/include/asm/time.h
index 264dc96..38341fa 100644
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
index bda78bb..44a76de 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -129,7 +129,7 @@ EXPORT_SYMBOL(broadcast_clockevent);
 
 DEFINE_PER_CPU(u64, decrementers_next_tb);
 static DEFINE_PER_CPU(struct clock_event_device, decrementers);
-static struct clock_event_device bc_timer;
+struct clock_event_device bc_timer;
 
 #define XSEC_PER_SEC (1024*1024)
 
diff --git a/drivers/cpuidle/cpuidle-ibm-power.c b/drivers/cpuidle/cpuidle-ibm-power.c
index f8905c3..ae47a0a 100644
--- a/drivers/cpuidle/cpuidle-ibm-power.c
+++ b/drivers/cpuidle/cpuidle-ibm-power.c
@@ -12,12 +12,19 @@
 #include <linux/cpuidle.h>
 #include <linux/cpu.h>
 #include <linux/notifier.h>
+#include <linux/clockchips.h>
+#include <linux/tick.h>
+#include <linux/hrtimer.h>
+#include <linux/ktime.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
 
 #include <asm/paca.h>
 #include <asm/reg.h>
 #include <asm/machdep.h>
 #include <asm/firmware.h>
 #include <asm/runlatch.h>
+#include <asm/time.h>
 #include <asm/plpar_wrappers.h>
 
 struct cpuidle_driver power_idle_driver = {
@@ -28,6 +35,26 @@ struct cpuidle_driver power_idle_driver = {
 static int max_idle_state;
 static struct cpuidle_state *cpuidle_state_table;
 
+static int bc_cpu = -1;
+static struct hrtimer *bc_hrtimer;
+static int bc_hrtimer_initialized = 0;
+
+/*
+ * Bits to indicate if a cpu can enter deep idle where local timer gets
+ * switched off.
+ * BROADCAST_CPU_PRESENT : Enter deep idle since bc_cpu is assigned
+ * BROADCAST_CPU_SELF	 : Do not enter deep idle since you are bc_cpu
+ * BROADCAST_CPU_ABSENT	 : Do not enter deep idle since there is no bc_cpu,
+ * 			   hence nominate yourself as bc_cpu
+ * BROADCAST_CPU_ERROR	:  Do not enter deep idle since there is no bc_cpu
+ *			   and the broadcast hrtimer could not be initialized.
+ */
+enum broadcast_cpu_status {
+	BROADCAST_CPU_PRESENT,
+	BROADCAST_CPU_SELF,
+	BROADCAST_CPU_ERROR,
+};
+
 static inline void idle_loop_prolog(unsigned long *in_purr)
 {
 	*in_purr = mfspr(SPRN_PURR);
@@ -44,6 +71,8 @@ static inline void idle_loop_epilog(unsigned long in_purr)
 	get_lppaca()->idle = 0;
 }
 
+static DEFINE_SPINLOCK(longnap_idle_lock);
+
 static int snooze_loop(struct cpuidle_device *dev,
 			struct cpuidle_driver *drv,
 			int index)
@@ -139,6 +168,120 @@ static int nap_loop(struct cpuidle_device *dev,
 	return index;
 }
 
+/* Functions supporting broadcasting in longnap */
+static ktime_t get_next_bc_tick(void)
+{
+	u64 next_bc_ns;
+
+	next_bc_ns = (tb_ticks_per_jiffy / tb_ticks_per_usec) * 1000;
+	return ns_to_ktime(next_bc_ns);
+}
+
+static int restart_broadcast(struct clock_event_device *bc_evt)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&longnap_idle_lock, flags);
+	bc_evt->event_handler(bc_evt);
+
+	if (bc_evt->next_event.tv64 == KTIME_MAX)
+		bc_cpu = -1;
+
+	spin_unlock_irqrestore(&longnap_idle_lock, flags);
+	return (bc_cpu != -1);
+}
+
+static enum hrtimer_restart handle_broadcast(struct hrtimer *hrtimer)
+{
+	struct clock_event_device *bc_evt = &bc_timer;
+	ktime_t interval, next_bc_tick;
+
+	u64 now = get_tb_or_rtc();
+	ktime_t now_ktime = ns_to_ktime((now / tb_ticks_per_usec) * 1000);
+
+	if (!restart_broadcast(bc_evt))
+		return HRTIMER_NORESTART;
+
+	interval.tv64 = bc_evt->next_event.tv64 - now_ktime.tv64;
+	next_bc_tick = get_next_bc_tick();
+
+	if (interval.tv64 < next_bc_tick.tv64)
+		hrtimer_forward_now(hrtimer, interval);
+	else
+		hrtimer_forward_now(hrtimer, next_bc_tick);
+
+	return HRTIMER_RESTART;
+}
+
+static enum broadcast_cpu_status can_enter_deep_idle(int cpu)
+{
+	if (bc_cpu != -1 && cpu != bc_cpu) {
+		return BROADCAST_CPU_PRESENT;
+	} else if (bc_cpu != -1 && cpu == bc_cpu) {
+		return BROADCAST_CPU_SELF;
+	} else {
+		if (!bc_hrtimer_initialized) {
+			bc_hrtimer = kmalloc(sizeof(*bc_hrtimer), GFP_NOWAIT);
+			if (!bc_hrtimer)
+				return BROADCAST_CPU_ERROR;
+			hrtimer_init(bc_hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_PINNED);
+			bc_hrtimer->function = handle_broadcast;
+			hrtimer_start(bc_hrtimer, get_next_bc_tick(),
+				HRTIMER_MODE_REL_PINNED);
+			bc_hrtimer_initialized = 1;
+		} else {
+			hrtimer_start(bc_hrtimer, get_next_bc_tick(), HRTIMER_MODE_REL_PINNED);
+		}
+
+		bc_cpu = cpu;
+		return BROADCAST_CPU_SELF;
+	}
+}
+
+/* Emulate sleep, with long nap.
+ * During sleep, the core does not receive decrementer interrupts.
+ * Emulate sleep using long nap with decrementers interrupts disabled.
+ * This is an initial prototype to test the broadcast framework for ppc.
+ */
+static int longnap_loop(struct cpuidle_device *dev,
+				struct cpuidle_driver *drv,
+				int index)
+{
+	int cpu = dev->cpu;
+	unsigned long lpcr = mfspr(SPRN_LPCR);
+	unsigned long flags;
+	int bc_cpu_status;
+
+	lpcr &= ~(LPCR_MER | LPCR_PECE); /* lpcr[mer] must be 0 */
+
+	/* exit powersave upon external interrupt, but not decrementer
+	 * interrupt, Emulate sleep.
+	 */
+	lpcr |= LPCR_PECE0;
+
+	spin_lock_irqsave(&longnap_idle_lock, flags);
+	bc_cpu_status = can_enter_deep_idle(cpu);
+
+	if (bc_cpu_status == BROADCAST_CPU_PRESENT) {
+		mtspr(SPRN_LPCR, lpcr);
+		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
+		spin_unlock_irqrestore(&longnap_idle_lock, flags);
+		power7_nap();
+		spin_lock_irqsave(&longnap_idle_lock, flags);
+		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
+		spin_unlock_irqrestore(&longnap_idle_lock, flags);
+	} else if (bc_cpu_status == BROADCAST_CPU_SELF) {
+		lpcr |= LPCR_PECE1;
+		mtspr(SPRN_LPCR, lpcr);
+		spin_unlock_irqrestore(&longnap_idle_lock, flags);
+		power7_nap();
+	} else {
+		spin_unlock_irqrestore(&longnap_idle_lock, flags);
+	}
+
+	return index;
+}
+
 /*
  * States for dedicated partition case.
  */
@@ -187,6 +330,13 @@ static struct cpuidle_state powernv_states[] = {
 		.exit_latency = 10,
 		.target_residency = 100,
 		.enter = &nap_loop },
+	 { /* LongNap */
+		.name = "LongNap",
+		.desc = "LongNap",
+		.flags = CPUIDLE_FLAG_TIME_VALID,
+		.exit_latency = 10,
+		.target_residency = 100,
+		.enter = &longnap_loop },
 };
 
 void update_smt_snooze_delay(int cpu, int residency)

