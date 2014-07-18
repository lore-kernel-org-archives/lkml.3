Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030731AbaGRRoB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 13:44:01 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:57477 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030383AbaGRRn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 13:43:59 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Baruch Siach <baruch@tkos.co.il>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>
Subject: [RFC] sched_clock: Track monotonic raw clock
Date: Fri, 18 Jul 2014 18:43:39 +0100
Message-Id: <1405705419-4194-1-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change is trying to make the sched clock "similar" to the
monotonic raw one.

The main goal is to provide some kind of unification between time
flow in kernel and in user space, mainly to achieve correlation
between perf timestamps and clock_gettime(CLOCK_MONOTONIC_RAW).
This has been suggested by Ingo and John during the latest
discussion (of many, we tried custom ioctl, custom clock etc.)
about this:

http://thread.gmane.org/gmane.linux.kernel/1611683/focus=1612554

For now I focused on the generic sched clock implementation,
but similar approach can be applied elsewhere.

Initially I just wanted to copy epoch from monotonic to sched
clock at update_clock(), but this can cause the sched clock
going backwards in certain corner cases, eg. when the sched
clock "increases faster" than the monotonic one. I believe
it's a killer issue, but feel free to ridicule me if I worry
too much :-)

In the end I tried to employ some basic control theory technique
to tune the multiplier used to calculate ns from cycles and
it seems to be be working in my system, with the average error
in the area of 2-3 clock cycles (I've got both clocks running
at 24MHz, which gives 41ns resolution).

/ # cat /sys/kernel/debug/sched_clock_error
min error: 0ns
max error: 200548913ns
100 samples moving average error: 117ns
/ # cat /sys/kernel/debug/tracing/trace
<...>
          <idle>-0     [000] d.h3  1195.102296: sched_clock_adjust: sched=1195102288457ns, mono=1195102288411ns, error=-46ns, mult_adj=65
          <idle>-0     [000] d.h3  1195.202290: sched_clock_adjust: sched=1195202282416ns, mono=1195202282485ns, error=69ns, mult_adj=38
          <idle>-0     [000] d.h3  1195.302286: sched_clock_adjust: sched=1195302278832ns, mono=1195302278861ns, error=29ns, mult_adj=47
          <idle>-0     [000] d.h3  1195.402278: sched_clock_adjust: sched=1195402271082ns, mono=1195402270872ns, error=-210ns, mult_adj=105
          <idle>-0     [000] d.h3  1195.502278: sched_clock_adjust: sched=1195502270832ns, mono=1195502270950ns, error=118ns, mult_adj=29
          <idle>-0     [000] d.h3  1195.602276: sched_clock_adjust: sched=1195602268707ns, mono=1195602268732ns, error=25ns, mult_adj=50
          <idle>-0     [000] d.h3  1195.702280: sched_clock_adjust: sched=1195702272999ns, mono=1195702272997ns, error=-2ns, mult_adj=55
          <idle>-0     [000] d.h3  1195.802276: sched_clock_adjust: sched=1195802268749ns, mono=1195802268684ns, error=-65ns, mult_adj=71
          <idle>-0     [000] d.h3  1195.902272: sched_clock_adjust: sched=1195902265207ns, mono=1195902265223ns, error=16ns, mult_adj=53
          <idle>-0     [000] d.h3  1196.002276: sched_clock_adjust: sched=1196002269374ns, mono=1196002269283ns, error=-91ns, mult_adj=78
<...>

This code definitely needs more work and testing (I'm not 100%
sure if the Kp and Ki I've picked for the proportional and
integral terms are universal), but for now wanted to see
if this approach makes any sense whatsoever.

All feedback more than appreciated!

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 include/trace/events/sched.h |  28 +++++++++
 kernel/time/sched_clock.c    | 142 ++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 162 insertions(+), 8 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 0a68d5a..4cca9bb 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -550,6 +550,34 @@ TRACE_EVENT(sched_wake_idle_without_ipi,
 
 	TP_printk("cpu=%d", __entry->cpu)
 );
+
+/*
+ * Tracepoint for sched clock adjustments
+ */
+TRACE_EVENT(sched_clock_adjust,
+
+	TP_PROTO(u64 sched, u64 mono, s32 mult_adj),
+
+	TP_ARGS(sched, mono, mult_adj),
+
+	TP_STRUCT__entry(
+		__field( u64,	sched		)
+		__field( u64,	mono		)
+		__field( s32,	mult_adj	)
+	),
+
+	TP_fast_assign(
+		__entry->sched		= sched;
+		__entry->mono		= mono;
+		__entry->mult_adj	= mult_adj;
+	),
+
+	TP_printk("sched=%lluns, mono=%lluns, error=%lldns, mult_adj=%d",
+		(unsigned long long)__entry->sched,
+		(unsigned long long)__entry->mono,
+		(unsigned long long)(__entry->mono - __entry->sched),
+		__entry->mult_adj)
+);
 #endif /* _TRACE_SCHED_H */
 
 /* This part must be outside protection */
diff --git a/kernel/time/sched_clock.c b/kernel/time/sched_clock.c
index 445106d..b9c9e04 100644
--- a/kernel/time/sched_clock.c
+++ b/kernel/time/sched_clock.c
@@ -17,18 +17,26 @@
 #include <linux/sched_clock.h>
 #include <linux/seqlock.h>
 #include <linux/bitops.h>
+#include <linux/debugfs.h>
+
+#include <trace/events/sched.h>
 
 struct clock_data {
 	ktime_t wrap_kt;
 	u64 epoch_ns;
+	u64 epoch_mono_ns;
 	u64 epoch_cyc;
 	seqcount_t seq;
 	unsigned long rate;
 	u32 mult;
+	s32 mult_adj;
+	s64 error_int;
 	u32 shift;
 	bool suspended;
 };
 
+#define REFRESH_PERIOD 100000000ULL /* 10^8 ns = 0.1 s */
+
 static struct hrtimer sched_clock_timer;
 static int irqtime = -1;
 
@@ -38,6 +46,45 @@ static struct clock_data cd = {
 	.mult	= NSEC_PER_SEC / HZ,
 };
 
+#ifdef DEBUG
+#define ERROR_LOG_LEN (NSEC_PER_SEC / REFRESH_PERIOD * 10) /* 10 s */
+static u64 sched_clock_error_log[ERROR_LOG_LEN];
+static int sched_clock_error_log_next;
+static int sched_clock_error_log_len;
+
+static u64 sched_clock_error_max;
+static u64 sched_clock_error_min = ~0;
+
+static int sched_clock_error_log_show(struct seq_file *m, void *p)
+{
+	u64 avg = 0;
+	int i;
+
+	for (i = 0; i < sched_clock_error_log_len; i++)
+		avg += sched_clock_error_log[i];
+	do_div(avg,  sched_clock_error_log_len);
+
+	seq_printf(m, "min error: %lluns\n", sched_clock_error_min);
+	seq_printf(m, "max error: %lluns\n", sched_clock_error_max);
+	seq_printf(m, "%d samples moving average error: %lluns\n",
+			sched_clock_error_log_len, avg);
+
+	return 0;
+}
+
+static int sched_clock_error_log_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, sched_clock_error_log_show, inode->i_private);
+}
+
+static struct file_operations sched_clock_error_log_fops = {
+	.open		= sched_clock_error_log_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+#endif
+
 static u64 __read_mostly sched_clock_mask;
 
 static u64 notrace jiffy_sched_clock_read(void)
@@ -74,7 +121,7 @@ unsigned long long notrace sched_clock(void)
 
 	cyc = read_sched_clock();
 	cyc = (cyc - epoch_cyc) & sched_clock_mask;
-	return epoch_ns + cyc_to_ns(cyc, cd.mult, cd.shift);
+	return epoch_ns + cyc_to_ns(cyc, cd.mult + cd.mult_adj, cd.shift);
 }
 
 /*
@@ -83,18 +130,72 @@ unsigned long long notrace sched_clock(void)
 static void notrace update_sched_clock(void)
 {
 	unsigned long flags;
-	u64 cyc;
+	u64 cyc, delta_cyc;
 	u64 ns;
+	u64 mono_ns = 0;
+	s64 error_ns = 0, error = 0, error_int = 0;
+	s32 mult_adj = 0;
+	struct timespec mono;
 
 	cyc = read_sched_clock();
-	ns = cd.epoch_ns +
-		cyc_to_ns((cyc - cd.epoch_cyc) & sched_clock_mask,
-			  cd.mult, cd.shift);
+	delta_cyc = (cyc - cd.epoch_cyc) & sched_clock_mask;
+	ns = cd.epoch_ns + cyc_to_ns(delta_cyc, cd.mult + cd.mult_adj,
+			cd.shift);
+
+	if (!cd.epoch_mono_ns) {
+		/* Initialize monotonic raw clock epoch */
+		getrawmonotonic(&mono);
+		mono_ns = timespec_to_ns(&mono);
+	}
+
+	if (cd.epoch_mono_ns) {
+		int sign;
+
+		/* We have a simple PI controller here */
+		getrawmonotonic(&mono);
+		mono_ns = timespec_to_ns(&mono);
+		error_ns = mono_ns - ns;
+		sign = (error_ns > 0) - (error_ns < 0);
+		error_ns = abs(error_ns);
+
+		/* Convert error in ns into "mult units" */
+		error = error_ns;
+		if (delta_cyc >> cd.shift)
+			do_div(error, delta_cyc >> cd.shift);
+		else
+			error = 0;
+
+		/* Integral term of the controller */
+		error_int = error * (mono_ns - cd.epoch_mono_ns);
+		do_div(error_int, NSEC_PER_SEC);
+		error_int = sign * error_int + cd.error_int;
+
+		/* Tune the cyc_to_ns formula */
+		mult_adj = sign * (error >> 2) + (cd.error_int >> 2);
+
+#ifdef DEBUG
+		sched_clock_error_log[sched_clock_error_log_next++] = error_ns;
+		if (sched_clock_error_log_next == ERROR_LOG_LEN)
+			sched_clock_error_log_next = 0;
+		else if (sched_clock_error_log_len < ERROR_LOG_LEN)
+			sched_clock_error_log_len++;
+
+		if (error_ns < sched_clock_error_min)
+			sched_clock_error_min = error_ns;
+		if (error_ns > sched_clock_error_max)
+			sched_clock_error_max = error_ns;
+#endif
+
+		trace_sched_clock_adjust(mono_ns, ns, mult_adj);
+	}
 
 	raw_local_irq_save(flags);
 	raw_write_seqcount_begin(&cd.seq);
 	cd.epoch_ns = ns;
+	cd.epoch_mono_ns = mono_ns;
 	cd.epoch_cyc = cyc;
+	cd.mult_adj = mult_adj;
+	cd.error_int = error_int;
 	raw_write_seqcount_end(&cd.seq);
 	raw_local_irq_restore(flags);
 }
@@ -127,13 +228,15 @@ void __init sched_clock_register(u64 (*read)(void), int bits,
 
 	/* calculate how many ns until we wrap */
 	wrap = clocks_calc_max_nsecs(new_mult, new_shift, 0, new_mask);
-	new_wrap_kt = ns_to_ktime(wrap - (wrap >> 3));
+
+	/* update epoch before we wrap and at least once per refresh period */
+	new_wrap_kt = ns_to_ktime(min(wrap - (wrap >> 3), REFRESH_PERIOD));
 
 	/* update epoch for new counter and update epoch_ns from old counter*/
 	new_epoch = read();
 	cyc = read_sched_clock();
 	ns = cd.epoch_ns + cyc_to_ns((cyc - cd.epoch_cyc) & sched_clock_mask,
-			  cd.mult, cd.shift);
+			  cd.mult + cd.mult_adj, cd.shift);
 
 	raw_write_seqcount_begin(&cd.seq);
 	read_sched_clock = read;
@@ -141,6 +244,7 @@ void __init sched_clock_register(u64 (*read)(void), int bits,
 	cd.rate = rate;
 	cd.wrap_kt = new_wrap_kt;
 	cd.mult = new_mult;
+	cd.mult_adj = 0;
 	cd.shift = new_shift;
 	cd.epoch_cyc = new_epoch;
 	cd.epoch_ns = ns;
@@ -209,7 +313,29 @@ static struct syscore_ops sched_clock_ops = {
 
 static int __init sched_clock_syscore_init(void)
 {
+	int err = 0;
+
 	register_syscore_ops(&sched_clock_ops);
-	return 0;
+
+	/*
+	 * As long as not everyone is using this generic implementation,
+	 * userspace must be able to tell what does the sched_clock values
+	 * relate to (if anything).
+	 */
+	if (read_sched_clock != jiffy_sched_clock_read) {
+		static struct debugfs_blob_wrapper blob;
+
+		blob.data = "CLOCK_MONOTONIC_RAW";
+		blob.size = strlen(blob.data) + 1;
+		err = PTR_ERR_OR_ZERO(debugfs_create_blob("sched_clock_base",
+				S_IRUGO, NULL, &blob));
+	}
+
+#ifdef DEBUG
+	err = PTR_ERR_OR_ZERO(debugfs_create_file("sched_clock_error", S_IRUGO,
+				NULL, NULL, &sched_clock_error_log_fops));
+#endif
+
+	return err;
 }
 device_initcall(sched_clock_syscore_init);
-- 
1.9.1

