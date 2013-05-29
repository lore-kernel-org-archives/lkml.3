Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935393Ab3E2W2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 18:28:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:9631 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935313Ab3E2W2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 18:28:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,766,1363158000"; 
   d="scan'208";a="309760077"
Subject: [v3][PATCH 3/4] perf: drop sample rate when sampling is too slow
To: a.p.zijlstra@chello.nl
Cc: mingo@redhat.com, paulus@samba.org, acme@ghostprotocols.net,
        tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Wed, 29 May 2013 15:28:01 -0700
References: <20130529222756.25535229@viggo.jf.intel.com>
In-Reply-To: <20130529222756.25535229@viggo.jf.intel.com>
Message-Id: <20130529222801.37D29D6A@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

This patch keeps track of how long perf's NMI handler is taking,
and also calculates how many samples perf can take a second.  If
the sample length times the expected max number of samples exceeds
a configurable threshold, it drops the sample rate.  This way,
we don't have a runaway sampling process eating up the CPU.

This patch can tend to drop the sample rate down to level where
perf doesn't work very well.  *BUT* the alternative is that my
system hangs because it spends all of its time handling NMIs.

I'll take a busted performance tool over an entire system that's
busted and undebuggable any day.

BTW, my suspicion is that there's still an underlying bug here.
Using the HPET instead of the TSC is definitely a contributing
factor, but I suspect there are some other things going on.
But, I can't go dig down on a bug like that with my machine
hanging all the time.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/Documentation/sysctl/kernel.txt  |   26 ++++++
 linux.git-davehans/arch/x86/kernel/cpu/perf_event.c |   12 ++-
 linux.git-davehans/include/linux/perf_event.h       |    7 +
 linux.git-davehans/kernel/events/core.c             |   78 ++++++++++++++++++++
 linux.git-davehans/kernel/sysctl.c                  |    9 ++
 5 files changed, 131 insertions(+), 1 deletion(-)

diff -puN arch/x86/kernel/cpu/perf_event.c~drop-perf-samples-when-sampling-is-too-slow arch/x86/kernel/cpu/perf_event.c
--- linux.git/arch/x86/kernel/cpu/perf_event.c~drop-perf-samples-when-sampling-is-too-slow	2013-05-29 15:10:19.413671415 -0700
+++ linux.git-davehans/arch/x86/kernel/cpu/perf_event.c	2013-05-29 15:10:19.424671899 -0700
@@ -1249,10 +1249,20 @@ void perf_events_lapic_init(void)
 static int __kprobes
 perf_event_nmi_handler(unsigned int cmd, struct pt_regs *regs)
 {
+	int ret;
+	u64 start_clock;
+	u64 finish_clock;
+
 	if (!atomic_read(&active_events))
 		return NMI_DONE;
 
-	return x86_pmu.handle_irq(regs);
+	start_clock = local_clock();
+	ret = x86_pmu.handle_irq(regs);
+	finish_clock = local_clock();
+
+	perf_sample_event_took(finish_clock - start_clock);
+
+	return ret;
 }
 
 struct event_constraint emptyconstraint;
diff -puN Documentation/sysctl/kernel.txt~drop-perf-samples-when-sampling-is-too-slow Documentation/sysctl/kernel.txt
--- linux.git/Documentation/sysctl/kernel.txt~drop-perf-samples-when-sampling-is-too-slow	2013-05-29 15:10:19.414671459 -0700
+++ linux.git-davehans/Documentation/sysctl/kernel.txt	2013-05-29 15:10:19.424671899 -0700
@@ -427,6 +427,32 @@ This file shows up if CONFIG_DEBUG_STACK
 
 ==============================================================
 
+perf_cpu_time_max_percent:
+
+Hints to the kernel how much CPU time it should be allowed to
+use to handle perf sampling events.  If the perf subsystem
+is informed that its samples are exceeding this limit, it
+will drop its sampling frequency to attempt to reduce its CPU
+usage.
+
+Some perf sampling happens in NMIs.  If these samples
+unexpectedly take too long to execute, the NMIs can become
+stacked up next to each other so much that nothing else is
+allowed to execute.
+
+0: disable the mechanism.  Do not monitor or correct perf's
+   sampling rate no matter how CPU time it takes.
+
+1-100: attempt to throttle perf's sample rate to this
+   percentage of CPU.  Note: the kernel calculates an
+   "expected" length of each sample event.  100 here means
+   100% of that expected length.  Even if this is set to
+   100, you may still see sample throttling if this
+   length is exceeded.  Set to 0 if you truly do not care
+   how much CPU is consumed.
+
+==============================================================
+
 
 pid_max:
 
diff -puN include/linux/perf_event.h~drop-perf-samples-when-sampling-is-too-slow include/linux/perf_event.h
--- linux.git/include/linux/perf_event.h~drop-perf-samples-when-sampling-is-too-slow	2013-05-29 15:10:19.416671547 -0700
+++ linux.git-davehans/include/linux/perf_event.h	2013-05-29 15:10:19.425671943 -0700
@@ -696,10 +696,17 @@ static inline void perf_callchain_store(
 extern int sysctl_perf_event_paranoid;
 extern int sysctl_perf_event_mlock;
 extern int sysctl_perf_event_sample_rate;
+extern int sysctl_perf_cpu_time_max_percent;
+
+extern void perf_sample_event_took(u64 sample_len_ns);
 
 extern int perf_proc_update_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos);
+extern int perf_cpu_time_max_percent_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos);
+
 
 static inline bool perf_paranoid_tracepoint_raw(void)
 {
diff -puN kernel/events/core.c~drop-perf-samples-when-sampling-is-too-slow kernel/events/core.c
--- linux.git/kernel/events/core.c~drop-perf-samples-when-sampling-is-too-slow	2013-05-29 15:10:19.418671635 -0700
+++ linux.git-davehans/kernel/events/core.c	2013-05-29 15:10:19.427672029 -0700
@@ -166,9 +166,21 @@ int sysctl_perf_event_mlock __read_mostl
  * max perf event sample rate
  */
 #define DEFAULT_MAX_SAMPLE_RATE 100000
+#define DEFAULT_SAMPLE_PERIOD_NS	(NSEC_PER_SEC / DEFAULT_MAX_SAMPLE_RATE)
+#define DEFAULT_CPU_TIME_MAX_PERCENT 25
 int sysctl_perf_event_sample_rate __read_mostly = DEFAULT_MAX_SAMPLE_RATE;
 static int max_samples_per_tick __read_mostly =
 	DIV_ROUND_UP(DEFAULT_MAX_SAMPLE_RATE, HZ);
+static int perf_sample_period_ns __read_mostly = DEFAULT_SAMPLE_PERIOD_NS;
+static atomic_t perf_sample_allowed_ns __read_mostly = ATOMIC_INIT(
+		DEFAULT_SAMPLE_PERIOD_NS * DEFAULT_CPU_TIME_MAX_PERCENT / 100);
+
+void update_perf_cpu_limits(void)
+{
+	u64 tmp = perf_sample_period_ns;
+	tmp = tmp * sysctl_perf_cpu_time_max_percent / 100;
+	atomic_set(&perf_sample_allowed_ns, tmp);
+}
 
 int perf_proc_update_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
@@ -180,10 +192,76 @@ int perf_proc_update_handler(struct ctl_
 		return ret;
 
 	max_samples_per_tick = DIV_ROUND_UP(sysctl_perf_event_sample_rate, HZ);
+	perf_sample_period_ns = NSEC_PER_SEC / sysctl_perf_event_sample_rate;
+	update_perf_cpu_limits();
+
+	return 0;
+}
+
+int sysctl_perf_cpu_time_max_percent __read_mostly =
+					DEFAULT_CPU_TIME_MAX_PERCENT;
+int perf_cpu_time_max_percent_handler(struct ctl_table *table, int write,
+				void __user *buffer, size_t *lenp,
+				loff_t *ppos)
+{
+	int ret = proc_dointvec(table, write, buffer, lenp, ppos);
+
+	if (ret || !write)
+		return ret;
+
+	update_perf_cpu_limits();
 
 	return 0;
 }
 
+/*
+ * perf samples are done in some very critical code paths (NMIs).
+ * If they take too much CPU time, the system can lock up and not
+ * get any real work done.  This will drop the sample rate when
+ * we detect that events are taking too long.
+ */
+#define NR_ACCUMULATED_SAMPLES 128
+DEFINE_PER_CPU(u64, running_sample_length);
+void perf_sample_event_took(u64 sample_len_ns)
+{
+	u64 avg_local_sample_len;
+	u64 local_samples_len = __get_cpu_var(running_sample_length);
+
+	if (atomic_read(&perf_sample_allowed_ns) == 0)
+		return;
+
+	/* decay the counter by 1 average sample */
+	local_samples_len = __get_cpu_var(running_sample_length);
+	local_samples_len -= local_samples_len/NR_ACCUMULATED_SAMPLES;
+	local_samples_len += sample_len_ns;
+	__get_cpu_var(running_sample_length) = local_samples_len;
+
+	/*
+	 * note: this will be biased artifically low until we have
+	 * seen NR_ACCUMULATED_SAMPLES.  Doing it this way keeps us
+	 * from having to maintain a count.
+	 */
+	avg_local_sample_len = local_samples_len/NR_ACCUMULATED_SAMPLES;
+
+	if (avg_local_sample_len <= atomic_read(&perf_sample_allowed_ns))
+		return;
+
+	if (max_samples_per_tick <= 1)
+		return;
+
+	max_samples_per_tick = DIV_ROUND_UP(max_samples_per_tick, 2);
+	sysctl_perf_event_sample_rate = max_samples_per_tick * HZ;
+	perf_sample_period_ns = NSEC_PER_SEC / sysctl_perf_event_sample_rate;
+
+	printk_ratelimited(KERN_WARNING
+			"perf samples too long (%lld > %d), lowering "
+			"kernel.perf_event_max_sample_rate to %d\n",
+			sample_len_ns, atomic_read(&perf_sample_allowed_ns),
+			sysctl_perf_event_sample_rate);
+
+	update_perf_cpu_limits();
+}
+
 static atomic64_t perf_event_id;
 
 static void cpu_ctx_sched_out(struct perf_cpu_context *cpuctx,
diff -puN kernel/sysctl.c~drop-perf-samples-when-sampling-is-too-slow kernel/sysctl.c
--- linux.git/kernel/sysctl.c~drop-perf-samples-when-sampling-is-too-slow	2013-05-29 15:10:19.420671722 -0700
+++ linux.git-davehans/kernel/sysctl.c	2013-05-29 15:10:19.428672073 -0700
@@ -1044,6 +1044,15 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= perf_proc_update_handler,
 	},
+	{
+		.procname	= "perf_cpu_time_max_percent",
+		.data		= &sysctl_perf_cpu_time_max_percent,
+		.maxlen		= sizeof(sysctl_perf_cpu_time_max_percent),
+		.mode		= 0644,
+		.proc_handler	= perf_cpu_time_max_percent_handler,
+		.extra1		= &zero,
+		.extra2		= &one_hundred,
+	},
 #endif
 #ifdef CONFIG_KMEMCHECK
 	{
_
