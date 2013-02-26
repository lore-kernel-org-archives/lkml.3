Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab3BZH3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 02:29:48 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:56708 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab3BZH3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 02:29:46 -0500
Date: Tue, 26 Feb 2013 08:29:41 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20130226072941.GA14176@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-urgent-for-linus

   HEAD: 7f6575f1fb963d5231afbceecd3feadb6ab58cd3 cputime: Use local_clock() for full dynticks cputime accounting

 Thanks,

	Ingo

------------------>
Clark Williams (1):
      sched: Move RR_TIMESLICE from sysctl.h to rt.h

Frederic Weisbecker (1):
      cputime: Use local_clock() for full dynticks cputime accounting

Li Zhong (1):
      cputime: Constify timeval_to_cputime(timeval) argument

Nathan Zimmer (2):
      sched: Fix /proc/sched_stat failure on very very large systems
      sched: Fix /proc/sched_debug failure on very very large systems

Sha Zhengju (1):
      sched/core: Remove the obsolete and unused nr_uninterruptible() function


 include/asm-generic/cputime_nsecs.h |  2 +-
 include/linux/sched.h               |  1 -
 include/linux/sched/rt.h            |  6 +++
 include/linux/sched/sysctl.h        |  6 ---
 kernel/sched/core.c                 | 22 +--------
 kernel/sched/cputime.c              |  2 +-
 kernel/sched/debug.c                | 90 ++++++++++++++++++++++++++++++++-----
 kernel/sched/stats.c                | 79 +++++++++++++++++++++++---------
 8 files changed, 148 insertions(+), 60 deletions(-)

diff --git a/include/asm-generic/cputime_nsecs.h b/include/asm-generic/cputime_nsecs.h
index b6485ca..a8ece9a 100644
--- a/include/asm-generic/cputime_nsecs.h
+++ b/include/asm-generic/cputime_nsecs.h
@@ -76,7 +76,7 @@ static inline void cputime_to_timespec(const cputime_t ct, struct timespec *val)
 /*
  * Convert cputime <-> timeval (msec)
  */
-static inline cputime_t timeval_to_cputime(struct timeval *val)
+static inline cputime_t timeval_to_cputime(const struct timeval *val)
 {
 	u64 ret = val->tv_sec * NSEC_PER_SEC + val->tv_usec * NSEC_PER_USEC;
 	return (__force cputime_t) ret;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 33cc421..f9ca237d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -98,7 +98,6 @@ extern int nr_threads;
 DECLARE_PER_CPU(unsigned long, process_counts);
 extern int nr_processes(void);
 extern unsigned long nr_running(void);
-extern unsigned long nr_uninterruptible(void);
 extern unsigned long nr_iowait(void);
 extern unsigned long nr_iowait_cpu(int cpu);
 extern unsigned long this_cpu_load(void);
diff --git a/include/linux/sched/rt.h b/include/linux/sched/rt.h
index 94e19ea..440434d 100644
--- a/include/linux/sched/rt.h
+++ b/include/linux/sched/rt.h
@@ -55,4 +55,10 @@ static inline bool tsk_is_pi_blocked(struct task_struct *tsk)
 extern void normalize_rt_tasks(void);
 
 
+/*
+ * default timeslice is 100 msecs (used only for SCHED_RR tasks).
+ * Timeslices get refilled after they expire.
+ */
+#define RR_TIMESLICE		(100 * HZ / 1000)
+
 #endif /* _SCHED_RT_H */
diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
index d2bb0ae..bf8086b 100644
--- a/include/linux/sched/sysctl.h
+++ b/include/linux/sched/sysctl.h
@@ -91,12 +91,6 @@ extern unsigned int sysctl_sched_cfs_bandwidth_slice;
 extern unsigned int sysctl_sched_autogroup_enabled;
 #endif
 
-/*
- * default timeslice is 100 msecs (used only for SCHED_RR tasks).
- * Timeslices get refilled after they expire.
- */
-#define RR_TIMESLICE		(100 * HZ / 1000)
-
 extern int sched_rr_timeslice;
 
 extern int sched_rr_handler(struct ctl_table *table, int write,
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 03d7784..b7b03cd 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1969,11 +1969,10 @@ context_switch(struct rq *rq, struct task_struct *prev,
 }
 
 /*
- * nr_running, nr_uninterruptible and nr_context_switches:
+ * nr_running and nr_context_switches:
  *
  * externally visible scheduler statistics: current number of runnable
- * threads, current number of uninterruptible-sleeping threads, total
- * number of context switches performed since bootup.
+ * threads, total number of context switches performed since bootup.
  */
 unsigned long nr_running(void)
 {
@@ -1985,23 +1984,6 @@ unsigned long nr_running(void)
 	return sum;
 }
 
-unsigned long nr_uninterruptible(void)
-{
-	unsigned long i, sum = 0;
-
-	for_each_possible_cpu(i)
-		sum += cpu_rq(i)->nr_uninterruptible;
-
-	/*
-	 * Since we read the counters lockless, it might be slightly
-	 * inaccurate. Do not allow it to go below zero though:
-	 */
-	if (unlikely((long)sum < 0))
-		sum = 0;
-
-	return sum;
-}
-
 unsigned long long nr_context_switches(void)
 {
 	int i;
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 9857329..ed12cbb 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -604,7 +604,7 @@ static unsigned long long vtime_delta(struct task_struct *tsk)
 {
 	unsigned long long clock;
 
-	clock = sched_clock();
+	clock = local_clock();
 	if (clock < tsk->vtime_snap)
 		return 0;
 
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 7ae4c4c..c496eb3 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -269,11 +269,11 @@ static void print_cpu(struct seq_file *m, int cpu)
 	{
 		unsigned int freq = cpu_khz ? : 1;
 
-		SEQ_printf(m, "\ncpu#%d, %u.%03u MHz\n",
+		SEQ_printf(m, "cpu#%d, %u.%03u MHz\n",
 			   cpu, freq / 1000, (freq % 1000));
 	}
 #else
-	SEQ_printf(m, "\ncpu#%d\n", cpu);
+	SEQ_printf(m, "cpu#%d\n", cpu);
 #endif
 
 #define P(x)								\
@@ -330,6 +330,7 @@ do {									\
 	print_rq(m, rq, cpu);
 	rcu_read_unlock();
 	spin_unlock_irqrestore(&sched_debug_lock, flags);
+	SEQ_printf(m, "\n");
 }
 
 static const char *sched_tunable_scaling_names[] = {
@@ -338,11 +339,10 @@ static const char *sched_tunable_scaling_names[] = {
 	"linear"
 };
 
-static int sched_debug_show(struct seq_file *m, void *v)
+static void sched_debug_header(struct seq_file *m)
 {
 	u64 ktime, sched_clk, cpu_clk;
 	unsigned long flags;
-	int cpu;
 
 	local_irq_save(flags);
 	ktime = ktime_to_ns(ktime_get());
@@ -384,33 +384,101 @@ static int sched_debug_show(struct seq_file *m, void *v)
 #undef PN
 #undef P
 
-	SEQ_printf(m, "  .%-40s: %d (%s)\n", "sysctl_sched_tunable_scaling",
+	SEQ_printf(m, "  .%-40s: %d (%s)\n",
+		"sysctl_sched_tunable_scaling",
 		sysctl_sched_tunable_scaling,
 		sched_tunable_scaling_names[sysctl_sched_tunable_scaling]);
+	SEQ_printf(m, "\n");
+}
 
-	for_each_online_cpu(cpu)
-		print_cpu(m, cpu);
+static int sched_debug_show(struct seq_file *m, void *v)
+{
+	int cpu = (unsigned long)(v - 2);
 
-	SEQ_printf(m, "\n");
+	if (cpu != -1)
+		print_cpu(m, cpu);
+	else
+		sched_debug_header(m);
 
 	return 0;
 }
 
 void sysrq_sched_debug_show(void)
 {
-	sched_debug_show(NULL, NULL);
+	int cpu;
+
+	sched_debug_header(NULL);
+	for_each_online_cpu(cpu)
+		print_cpu(NULL, cpu);
+
+}
+
+/*
+ * This itererator needs some explanation.
+ * It returns 1 for the header position.
+ * This means 2 is cpu 0.
+ * In a hotplugged system some cpus, including cpu 0, may be missing so we have
+ * to use cpumask_* to iterate over the cpus.
+ */
+static void *sched_debug_start(struct seq_file *file, loff_t *offset)
+{
+	unsigned long n = *offset;
+
+	if (n == 0)
+		return (void *) 1;
+
+	n--;
+
+	if (n > 0)
+		n = cpumask_next(n - 1, cpu_online_mask);
+	else
+		n = cpumask_first(cpu_online_mask);
+
+	*offset = n + 1;
+
+	if (n < nr_cpu_ids)
+		return (void *)(unsigned long)(n + 2);
+	return NULL;
+}
+
+static void *sched_debug_next(struct seq_file *file, void *data, loff_t *offset)
+{
+	(*offset)++;
+	return sched_debug_start(file, offset);
+}
+
+static void sched_debug_stop(struct seq_file *file, void *data)
+{
+}
+
+static const struct seq_operations sched_debug_sops = {
+	.start = sched_debug_start,
+	.next = sched_debug_next,
+	.stop = sched_debug_stop,
+	.show = sched_debug_show,
+};
+
+static int sched_debug_release(struct inode *inode, struct file *file)
+{
+	seq_release(inode, file);
+
+	return 0;
 }
 
 static int sched_debug_open(struct inode *inode, struct file *filp)
 {
-	return single_open(filp, sched_debug_show, NULL);
+	int ret = 0;
+
+	ret = seq_open(filp, &sched_debug_sops);
+
+	return ret;
 }
 
 static const struct file_operations sched_debug_fops = {
 	.open		= sched_debug_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= single_release,
+	.release	= sched_debug_release,
 };
 
 static int __init init_sched_debug_procfs(void)
diff --git a/kernel/sched/stats.c b/kernel/sched/stats.c
index 903ffa9e..e036eda 100644
--- a/kernel/sched/stats.c
+++ b/kernel/sched/stats.c
@@ -21,14 +21,17 @@ static int show_schedstat(struct seq_file *seq, void *v)
 	if (mask_str == NULL)
 		return -ENOMEM;
 
-	seq_printf(seq, "version %d\n", SCHEDSTAT_VERSION);
-	seq_printf(seq, "timestamp %lu\n", jiffies);
-	for_each_online_cpu(cpu) {
-		struct rq *rq = cpu_rq(cpu);
+	if (v == (void *)1) {
+		seq_printf(seq, "version %d\n", SCHEDSTAT_VERSION);
+		seq_printf(seq, "timestamp %lu\n", jiffies);
+	} else {
+		struct rq *rq;
 #ifdef CONFIG_SMP
 		struct sched_domain *sd;
 		int dcount = 0;
 #endif
+		cpu = (unsigned long)(v - 2);
+		rq = cpu_rq(cpu);
 
 		/* runqueue-specific stats */
 		seq_printf(seq,
@@ -77,30 +80,66 @@ static int show_schedstat(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static int schedstat_open(struct inode *inode, struct file *file)
+/*
+ * This itererator needs some explanation.
+ * It returns 1 for the header position.
+ * This means 2 is cpu 0.
+ * In a hotplugged system some cpus, including cpu 0, may be missing so we have
+ * to use cpumask_* to iterate over the cpus.
+ */
+static void *schedstat_start(struct seq_file *file, loff_t *offset)
 {
-	unsigned int size = PAGE_SIZE * (1 + num_online_cpus() / 32);
-	char *buf = kmalloc(size, GFP_KERNEL);
-	struct seq_file *m;
-	int res;
+	unsigned long n = *offset;
 
-	if (!buf)
-		return -ENOMEM;
-	res = single_open(file, show_schedstat, NULL);
-	if (!res) {
-		m = file->private_data;
-		m->buf = buf;
-		m->size = size;
-	} else
-		kfree(buf);
-	return res;
+	if (n == 0)
+		return (void *) 1;
+
+	n--;
+
+	if (n > 0)
+		n = cpumask_next(n - 1, cpu_online_mask);
+	else
+		n = cpumask_first(cpu_online_mask);
+
+	*offset = n + 1;
+
+	if (n < nr_cpu_ids)
+		return (void *)(unsigned long)(n + 2);
+	return NULL;
+}
+
+static void *schedstat_next(struct seq_file *file, void *data, loff_t *offset)
+{
+	(*offset)++;
+	return schedstat_start(file, offset);
+}
+
+static void schedstat_stop(struct seq_file *file, void *data)
+{
+}
+
+static const struct seq_operations schedstat_sops = {
+	.start = schedstat_start,
+	.next  = schedstat_next,
+	.stop  = schedstat_stop,
+	.show  = show_schedstat,
+};
+
+static int schedstat_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &schedstat_sops);
 }
 
+static int schedstat_release(struct inode *inode, struct file *file)
+{
+	return 0;
+};
+
 static const struct file_operations proc_schedstat_operations = {
 	.open    = schedstat_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
-	.release = single_release,
+	.release = schedstat_release,
 };
 
 static int __init proc_schedstat_init(void)
