Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189Ab3FTTON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 15:14:13 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:15218 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758100Ab3FTTNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 15:13:44 -0400
X-IronPort-AV: E=Sophos;i="4.87,906,1363132800"; 
   d="scan'208";a="30924553"
From: David Vrabel <david.vrabel@citrix.com>
To: <xen-devel@lists.xen.org>
CC: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/2] time: add a notifier chain for when the system time is stepped
Date: Thu, 20 Jun 2013 20:13:39 +0100
Message-ID: <1371755619-25348-3-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1371755619-25348-1-git-send-email-david.vrabel@citrix.com>
References: <1371755619-25348-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Vrabel <david.vrabel@citrix.com>

The high resolution timer code gets notified of step changes to the
system time with clock_was_set() or clock_was_set_delayed() calls.  If
other parts of the kernel require similar notification there is no
clear place to hook into.

Add a clock_was_set atomic notifier chain
(clock_was_set_notifier_list) and call this in place of
clock_was_set().  If the timekeeping locks are held, the calls are
deferred to a new tasklet.

The hrtimer code adds a notifier block to this chain and uses it to
call (the now internal) clock_was_set().  Since the timekeeping code
does not call the chain from the timer irq clock_was_set_delayed() and
associated code can be removed.

For the delayed case, clock_was_set() used to be called at the
beginning of the hrtimer softirq and now it is called from a tasklet.
The tasklet softirq will be called before the hrtimer one so this
should give the same behaviour.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/hrtimer.h   |    7 -------
 include/linux/time.h      |    7 +++++++
 kernel/hrtimer.c          |   34 +++++++++++++---------------------
 kernel/time/timekeeping.c |   39 ++++++++++++++++++++++++++++++---------
 4 files changed, 50 insertions(+), 37 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 13df0fa..45e30f6 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -166,7 +166,6 @@ enum  hrtimer_base_type {
  * @lock:		lock protecting the base and associated clock bases
  *			and timers
  * @active_bases:	Bitfield to mark bases with active timers
- * @clock_was_set:	Indicates that clock was set from irq context.
  * @expires_next:	absolute time of the next event which was scheduled
  *			via clock_set_next_event()
  * @hres_active:	State of high resolution mode
@@ -180,7 +179,6 @@ enum  hrtimer_base_type {
 struct hrtimer_cpu_base {
 	raw_spinlock_t			lock;
 	unsigned int			active_bases;
-	unsigned int			clock_was_set;
 #ifdef CONFIG_HIGH_RES_TIMERS
 	ktime_t				expires_next;
 	int				hres_active;
@@ -289,8 +287,6 @@ extern void hrtimer_peek_ahead_timers(void);
 # define MONOTONIC_RES_NSEC	HIGH_RES_NSEC
 # define KTIME_MONOTONIC_RES	KTIME_HIGH_RES
 
-extern void clock_was_set_delayed(void);
-
 #else
 
 # define MONOTONIC_RES_NSEC	LOW_RES_NSEC
@@ -312,11 +308,8 @@ static inline int hrtimer_is_hres_active(struct hrtimer *timer)
 	return 0;
 }
 
-static inline void clock_was_set_delayed(void) { }
-
 #endif
 
-extern void clock_was_set(void);
 #ifdef CONFIG_TIMERFD
 extern void timerfd_clock_was_set(void);
 #else
diff --git a/include/linux/time.h b/include/linux/time.h
index d5d229b..a0c08a7 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -184,6 +184,13 @@ extern void timekeeping_clocktai(struct timespec *ts);
 struct tms;
 extern void do_sys_times(struct tms *);
 
+struct notifier_block;
+
+/*
+ * Notifier chain called when system time is stepped.
+ */
+extern int register_clock_was_set_notifier(struct notifier_block *nb);
+
 /*
  * Similar to the struct tm in userspace <time.h>, but it needs to be here so
  * that the kernel source is self contained.
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 34384b4..a853f9b 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -721,19 +721,6 @@ static int hrtimer_switch_to_hres(void)
 	return 1;
 }
 
-/*
- * Called from timekeeping code to reprogramm the hrtimer interrupt
- * device. If called from the timer interrupt context we defer it to
- * softirq context.
- */
-void clock_was_set_delayed(void)
-{
-	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
-
-	cpu_base->clock_was_set = 1;
-	__raise_softirq_irqoff(HRTIMER_SOFTIRQ);
-}
-
 #else
 
 static inline int hrtimer_hres_active(void) { return 0; }
@@ -762,7 +749,7 @@ static inline void retrigger_next_event(void *arg) { }
  * resolution timer interrupts. On UP we just disable interrupts and
  * call the high resolution interrupt code.
  */
-void clock_was_set(void)
+static void clock_was_set(void)
 {
 #ifdef CONFIG_HIGH_RES_TIMERS
 	/* Retrigger the CPU local events everywhere */
@@ -1441,13 +1428,6 @@ void hrtimer_peek_ahead_timers(void)
 
 static void run_hrtimer_softirq(struct softirq_action *h)
 {
-	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
-
-	if (cpu_base->clock_was_set) {
-		cpu_base->clock_was_set = 0;
-		clock_was_set();
-	}
-
 	hrtimer_peek_ahead_timers();
 }
 
@@ -1785,11 +1765,23 @@ static struct notifier_block __cpuinitdata hrtimers_nb = {
 	.notifier_call = hrtimer_cpu_notify,
 };
 
+static int hrtimer_clock_was_set_notify(struct notifier_block *self,
+					unsigned long action, void *data)
+{
+	clock_was_set();
+	return NOTIFY_OK;
+}
+
+static struct notifier_block hrtimers_clock_was_set_nb = {
+	.notifier_call = hrtimer_clock_was_set_notify,
+};
+
 void __init hrtimers_init(void)
 {
 	hrtimer_cpu_notify(&hrtimers_nb, (unsigned long)CPU_UP_PREPARE,
 			  (void *)(long)smp_processor_id());
 	register_cpu_notifier(&hrtimers_nb);
+	register_clock_was_set_notifier(&hrtimers_clock_was_set_nb);
 #ifdef CONFIG_HIGH_RES_TIMERS
 	open_softirq(HRTIMER_SOFTIRQ, run_hrtimer_softirq);
 #endif
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index baeeb5c..96c5c8e 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -198,6 +198,30 @@ static inline s64 timekeeping_get_ns_raw(struct timekeeper *tk)
 	return nsec + get_arch_timeoffset();
 }
 
+static ATOMIC_NOTIFIER_HEAD(clock_was_set_notifier_list);
+
+int register_clock_was_set_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_register(&clock_was_set_notifier_list, nb);
+}
+EXPORT_SYMBOL_GPL(register_clock_was_set_notifier);
+
+static void timekeeping_clock_was_set(void)
+{
+	atomic_notifier_call_chain(&clock_was_set_notifier_list, 0, NULL);
+}
+
+static void timekeeping_clock_was_set_task(unsigned long d)
+{
+	timekeeping_clock_was_set();
+}
+DECLARE_TASKLET(clock_was_set_tasklet, timekeeping_clock_was_set_task, 0);
+
+static void timekeeping_clock_was_set_delayed(void)
+{
+	tasklet_schedule(&clock_was_set_tasklet);
+}
+
 static RAW_NOTIFIER_HEAD(pvclock_gtod_chain);
 
 static void update_pvclock_gtod(struct timekeeper *tk)
@@ -513,8 +537,7 @@ int do_settimeofday(const struct timespec *tv)
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
-	/* signal hrtimers about time change */
-	clock_was_set();
+	timekeeping_clock_was_set();
 
 	return 0;
 }
@@ -557,8 +580,7 @@ error: /* even if we error out, we forwarded the time, so call update */
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
-	/* signal hrtimers about time change */
-	clock_was_set();
+	timekeeping_clock_was_set();
 
 	return ret;
 }
@@ -607,7 +629,7 @@ void timekeeping_set_tai_offset(s32 tai_offset)
 	__timekeeping_set_tai_offset(tk, tai_offset);
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
-	clock_was_set();
+	timekeeping_clock_was_set();
 }
 
 /**
@@ -877,8 +899,7 @@ void timekeeping_inject_sleeptime(struct timespec *delta)
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
-	/* signal hrtimers about time change */
-	clock_was_set();
+	timekeeping_clock_was_set();
 }
 
 /**
@@ -1260,7 +1281,7 @@ static inline void accumulate_nsecs_to_secs(struct timekeeper *tk)
 
 			__timekeeping_set_tai_offset(tk, tk->tai_offset - leap);
 
-			clock_was_set_delayed();
+			timekeeping_clock_was_set_delayed();
 		}
 	}
 }
@@ -1677,7 +1698,7 @@ int do_adjtimex(struct timex *txc)
 
 	if (tai != orig_tai) {
 		__timekeeping_set_tai_offset(tk, tai);
-		clock_was_set_delayed();
+		timekeeping_clock_was_set_delayed();
 	}
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
-- 
1.7.2.5

