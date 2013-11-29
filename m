Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab3K2Kqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 05:46:44 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:45823 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906Ab3K2Kql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 05:46:41 -0500
Subject: [PATCH V4 7/9] cpuidle/powernv: Add "Fast-Sleep" CPU idle state
To: fweisbec@gmail.com, paul.gortmaker@windriver.com, paulus@samba.org,
        shangw@linux.vnet.ibm.com, rjw@sisk.pl, galak@kernel.crashing.org,
        benh@kernel.crashing.org, paulmck@linux.vnet.ibm.com, arnd@arndb.de,
        linux-pm@vger.kernel.org, rostedt@goodmis.org, michael@ellerman.id.au,
        john.stultz@linaro.org, tglx@linutronix.de, chenhui.zhao@freescale.com,
        deepthi@linux.vnet.ibm.com, r58472@freescale.com, geoff@infradead.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Date: Fri, 29 Nov 2013 16:13:19 +0530
Message-ID: <20131129104319.651.29563.stgit@preeti.in.ibm.com>
In-Reply-To: <20131129104010.651.23117.stgit@preeti.in.ibm.com>
References: <20131129104010.651.23117.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112910-0928-0000-0000-000003E708A3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fast sleep is one of the deep idle states on Power8 in which local timers of
CPUs stop. Now that the basic support for fast sleep has been added,
enable it in the cpuidle framework on PowerNV.

On ppc, since we do not have an external device that can wakeup cpus in deep
idle, the local timer of one of the CPUs needs to be nominated to do this job.
This cpu is called the broadcast cpu/bc_cpu. Only if the bc_cpu is nominated
will the remaining cpus be allowed to enter deep idle state after notifying
the broadcast framework. The bc_cpu is not allowed to enter deep idle state.

The bc_cpu queues a hrtimer onto itself to handle the wakeup of CPUs in deep
idle state. The hrtimer handler calls into the broadcast framework which takes
care of sending IPIs to all those CPUs in deep idle whose wakeup times has expired.
	On each expiry of the hrtimer, it is programmed to the earlier of the
next wakeup time of  cpus in deep idle and and a safety period so as to not miss
any wakeups. This safety period is currently maintained at a jiffy.

But having a dedicated bc_cpu would mean overloading just one cpu with the
broadcast work which could hinder its performance apart from leading to thermal
imbalance on the chip. Therefore the first CPU that enters deep idle state is
the bc_cpu. It gets unassigned when there are no more CPUs in deep idle to be
woken up. This state remains until such a time that a CPU enters the
deep idle state again to be nominated as the bc_cpu and the cycle repeats.

Protect the region of nomination,de-nomination and check for existence of broadcast
CPU with a lock to ensure synchronization between them.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 arch/powerpc/include/asm/time.h          |    1 
 arch/powerpc/kernel/time.c               |    2 
 drivers/cpuidle/cpuidle-powerpc-book3s.c |  152 ++++++++++++++++++++++++++++++
 3 files changed, 154 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/time.h b/arch/powerpc/include/asm/time.h
index 4057425..a6604b7 100644
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
index d2e582b..f0603a0 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -127,7 +127,7 @@ EXPORT_SYMBOL(broadcast_clockevent);
 
 DEFINE_PER_CPU(u64, decrementers_next_tb);
 static DEFINE_PER_CPU(struct clock_event_device, decrementers);
-static struct clock_event_device bc_timer;
+struct clock_event_device bc_timer;
 
 #define XSEC_PER_SEC (1024*1024)
 
diff --git a/drivers/cpuidle/cpuidle-powerpc-book3s.c b/drivers/cpuidle/cpuidle-powerpc-book3s.c
index 25e8a99..649c330 100644
--- a/drivers/cpuidle/cpuidle-powerpc-book3s.c
+++ b/drivers/cpuidle/cpuidle-powerpc-book3s.c
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
 
 struct cpuidle_driver powerpc_book3s_idle_driver = {
@@ -28,6 +35,26 @@ struct cpuidle_driver powerpc_book3s_idle_driver = {
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
@@ -48,6 +75,8 @@ static inline void idle_loop_epilog(unsigned long in_purr)
 	get_lppaca()->idle = 0;
 }
 
+static DEFINE_SPINLOCK(fastsleep_idle_lock);
+
 static int snooze_loop(struct cpuidle_device *dev,
 			struct cpuidle_driver *drv,
 			int index)
@@ -143,6 +172,122 @@ static int nap_loop(struct cpuidle_device *dev,
 	return index;
 }
 
+/* Functions supporting broadcasting in fastsleep */
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
+	spin_lock_irqsave(&fastsleep_idle_lock, flags);
+	bc_evt->event_handler(bc_evt);
+
+	if (bc_evt->next_event.tv64 == KTIME_MAX)
+		bc_cpu = -1;
+
+	spin_unlock_irqrestore(&fastsleep_idle_lock, flags);
+	return (bc_cpu != -1);
+}
+
+static enum hrtimer_restart handle_broadcast(struct hrtimer *hrtimer)
+{
+	struct clock_event_device *bc_evt = &bc_timer;
+	ktime_t interval, next_bc_tick, now;
+
+	now = ktime_get();
+
+	if (!restart_broadcast(bc_evt))
+		return HRTIMER_NORESTART;
+
+	interval = ktime_sub(bc_evt->next_event, now);
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
+static int fastsleep_loop(struct cpuidle_device *dev,
+				struct cpuidle_driver *drv,
+				int index)
+{
+	int cpu = dev->cpu;
+	unsigned long old_lpcr = mfspr(SPRN_LPCR);
+	unsigned long new_lpcr;
+	unsigned long flags;
+	int bc_cpu_status;
+
+	new_lpcr = old_lpcr;
+	new_lpcr &= ~(LPCR_MER | LPCR_PECE); /* lpcr[mer] must be 0 */
+
+	/* exit powersave upon external interrupt, but not decrementer
+	 * interrupt, Emulate sleep.
+	 */
+	new_lpcr |= LPCR_PECE0;
+
+	spin_lock_irqsave(&fastsleep_idle_lock, flags);
+	bc_cpu_status = can_enter_deep_idle(cpu);
+
+	if (bc_cpu_status == BROADCAST_CPU_PRESENT) {
+		mtspr(SPRN_LPCR, new_lpcr);
+		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
+		spin_unlock_irqrestore(&fastsleep_idle_lock, flags);
+		power7_sleep();
+		spin_lock_irqsave(&fastsleep_idle_lock, flags);
+		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
+		spin_unlock_irqrestore(&fastsleep_idle_lock, flags);
+	} else if (bc_cpu_status == BROADCAST_CPU_SELF) {
+		new_lpcr |= LPCR_PECE1;
+		mtspr(SPRN_LPCR, new_lpcr);
+		spin_unlock_irqrestore(&fastsleep_idle_lock, flags);
+		power7_nap();
+	} else {
+		spin_unlock_irqrestore(&fastsleep_idle_lock, flags);
+	}
+
+	mtspr(SPRN_LPCR, old_lpcr);
+	return index;
+}
+
 /*
  * States for dedicated partition case.
  */
@@ -191,6 +336,13 @@ static struct cpuidle_state powernv_states[] = {
 		.exit_latency = 10,
 		.target_residency = 100,
 		.enter = &nap_loop },
+	 { /* Fastsleep */
+		.name = "fastsleep",
+		.desc = "fastsleep",
+		.flags = CPUIDLE_FLAG_TIME_VALID,
+		.exit_latency = 10,
+		.target_residency = 100,
+		.enter = &fastsleep_loop },
 };
 
 void update_smt_snooze_delay(int cpu, int residency)

