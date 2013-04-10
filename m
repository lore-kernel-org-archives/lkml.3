Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935906Ab3DJNg7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:36:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59258 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab3DJNg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:36:58 -0400
Date: Wed, 10 Apr 2013 06:36:33 -0700
From: tip-bot for Li Zefan <tipbot@zytor.com>
Message-ID: <tip-2e76c24d72372db35f226a49c2b99d0fd8cfd400@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
In-Reply-To: <5155366F.5060404@huawei.com>
References: <5155366F.5060404@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Split cpuacct code out of core.c
Git-Commit-ID: 2e76c24d72372db35f226a49c2b99d0fd8cfd400
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 10 Apr 2013 06:36:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2e76c24d72372db35f226a49c2b99d0fd8cfd400
Gitweb:     http://git.kernel.org/tip/2e76c24d72372db35f226a49c2b99d0fd8cfd400
Author:     Li Zefan <lizefan@huawei.com>
AuthorDate: Fri, 29 Mar 2013 14:36:31 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 10 Apr 2013 13:54:15 +0200

sched: Split cpuacct code out of core.c

Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/5155366F.5060404@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/Makefile  |   1 +
 kernel/sched/core.c    | 220 -----------------------------------------------
 kernel/sched/cpuacct.c | 227 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 228 insertions(+), 220 deletions(-)

diff --git a/kernel/sched/Makefile b/kernel/sched/Makefile
index f06d249..deaf90e 100644
--- a/kernel/sched/Makefile
+++ b/kernel/sched/Makefile
@@ -16,3 +16,4 @@ obj-$(CONFIG_SMP) += cpupri.o
 obj-$(CONFIG_SCHED_AUTOGROUP) += auto_group.o
 obj-$(CONFIG_SCHEDSTATS) += stats.o
 obj-$(CONFIG_SCHED_DEBUG) += debug.o
+obj-$(CONFIG_CGROUP_CPUACCT) += cpuacct.o
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f5e1aa5..c28222f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8043,226 +8043,6 @@ struct cgroup_subsys cpu_cgroup_subsys = {
 
 #endif	/* CONFIG_CGROUP_SCHED */
 
-#ifdef CONFIG_CGROUP_CPUACCT
-
-/*
- * CPU accounting code for task groups.
- *
- * Based on the work by Paul Menage (menage@google.com) and Balbir Singh
- * (balbir@in.ibm.com).
- */
-
-struct cpuacct root_cpuacct;
-
-/* create a new cpu accounting group */
-static struct cgroup_subsys_state *cpuacct_css_alloc(struct cgroup *cgrp)
-{
-	struct cpuacct *ca;
-
-	if (!cgrp->parent)
-		return &root_cpuacct.css;
-
-	ca = kzalloc(sizeof(*ca), GFP_KERNEL);
-	if (!ca)
-		goto out;
-
-	ca->cpuusage = alloc_percpu(u64);
-	if (!ca->cpuusage)
-		goto out_free_ca;
-
-	ca->cpustat = alloc_percpu(struct kernel_cpustat);
-	if (!ca->cpustat)
-		goto out_free_cpuusage;
-
-	return &ca->css;
-
-out_free_cpuusage:
-	free_percpu(ca->cpuusage);
-out_free_ca:
-	kfree(ca);
-out:
-	return ERR_PTR(-ENOMEM);
-}
-
-/* destroy an existing cpu accounting group */
-static void cpuacct_css_free(struct cgroup *cgrp)
-{
-	struct cpuacct *ca = cgroup_ca(cgrp);
-
-	free_percpu(ca->cpustat);
-	free_percpu(ca->cpuusage);
-	kfree(ca);
-}
-
-static u64 cpuacct_cpuusage_read(struct cpuacct *ca, int cpu)
-{
-	u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
-	u64 data;
-
-#ifndef CONFIG_64BIT
-	/*
-	 * Take rq->lock to make 64-bit read safe on 32-bit platforms.
-	 */
-	raw_spin_lock_irq(&cpu_rq(cpu)->lock);
-	data = *cpuusage;
-	raw_spin_unlock_irq(&cpu_rq(cpu)->lock);
-#else
-	data = *cpuusage;
-#endif
-
-	return data;
-}
-
-static void cpuacct_cpuusage_write(struct cpuacct *ca, int cpu, u64 val)
-{
-	u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
-
-#ifndef CONFIG_64BIT
-	/*
-	 * Take rq->lock to make 64-bit write safe on 32-bit platforms.
-	 */
-	raw_spin_lock_irq(&cpu_rq(cpu)->lock);
-	*cpuusage = val;
-	raw_spin_unlock_irq(&cpu_rq(cpu)->lock);
-#else
-	*cpuusage = val;
-#endif
-}
-
-/* return total cpu usage (in nanoseconds) of a group */
-static u64 cpuusage_read(struct cgroup *cgrp, struct cftype *cft)
-{
-	struct cpuacct *ca = cgroup_ca(cgrp);
-	u64 totalcpuusage = 0;
-	int i;
-
-	for_each_present_cpu(i)
-		totalcpuusage += cpuacct_cpuusage_read(ca, i);
-
-	return totalcpuusage;
-}
-
-static int cpuusage_write(struct cgroup *cgrp, struct cftype *cftype,
-								u64 reset)
-{
-	struct cpuacct *ca = cgroup_ca(cgrp);
-	int err = 0;
-	int i;
-
-	if (reset) {
-		err = -EINVAL;
-		goto out;
-	}
-
-	for_each_present_cpu(i)
-		cpuacct_cpuusage_write(ca, i, 0);
-
-out:
-	return err;
-}
-
-static int cpuacct_percpu_seq_read(struct cgroup *cgroup, struct cftype *cft,
-				   struct seq_file *m)
-{
-	struct cpuacct *ca = cgroup_ca(cgroup);
-	u64 percpu;
-	int i;
-
-	for_each_present_cpu(i) {
-		percpu = cpuacct_cpuusage_read(ca, i);
-		seq_printf(m, "%llu ", (unsigned long long) percpu);
-	}
-	seq_printf(m, "\n");
-	return 0;
-}
-
-static const char *cpuacct_stat_desc[] = {
-	[CPUACCT_STAT_USER] = "user",
-	[CPUACCT_STAT_SYSTEM] = "system",
-};
-
-static int cpuacct_stats_show(struct cgroup *cgrp, struct cftype *cft,
-			      struct cgroup_map_cb *cb)
-{
-	struct cpuacct *ca = cgroup_ca(cgrp);
-	int cpu;
-	s64 val = 0;
-
-	for_each_online_cpu(cpu) {
-		struct kernel_cpustat *kcpustat = per_cpu_ptr(ca->cpustat, cpu);
-		val += kcpustat->cpustat[CPUTIME_USER];
-		val += kcpustat->cpustat[CPUTIME_NICE];
-	}
-	val = cputime64_to_clock_t(val);
-	cb->fill(cb, cpuacct_stat_desc[CPUACCT_STAT_USER], val);
-
-	val = 0;
-	for_each_online_cpu(cpu) {
-		struct kernel_cpustat *kcpustat = per_cpu_ptr(ca->cpustat, cpu);
-		val += kcpustat->cpustat[CPUTIME_SYSTEM];
-		val += kcpustat->cpustat[CPUTIME_IRQ];
-		val += kcpustat->cpustat[CPUTIME_SOFTIRQ];
-	}
-
-	val = cputime64_to_clock_t(val);
-	cb->fill(cb, cpuacct_stat_desc[CPUACCT_STAT_SYSTEM], val);
-
-	return 0;
-}
-
-static struct cftype files[] = {
-	{
-		.name = "usage",
-		.read_u64 = cpuusage_read,
-		.write_u64 = cpuusage_write,
-	},
-	{
-		.name = "usage_percpu",
-		.read_seq_string = cpuacct_percpu_seq_read,
-	},
-	{
-		.name = "stat",
-		.read_map = cpuacct_stats_show,
-	},
-	{ }	/* terminate */
-};
-
-/*
- * charge this task's execution time to its accounting group.
- *
- * called with rq->lock held.
- */
-void cpuacct_charge(struct task_struct *tsk, u64 cputime)
-{
-	struct cpuacct *ca;
-	int cpu;
-
-	if (unlikely(!cpuacct_subsys.active))
-		return;
-
-	cpu = task_cpu(tsk);
-
-	rcu_read_lock();
-
-	ca = task_ca(tsk);
-
-	for (; ca; ca = parent_ca(ca)) {
-		u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
-		*cpuusage += cputime;
-	}
-
-	rcu_read_unlock();
-}
-
-struct cgroup_subsys cpuacct_subsys = {
-	.name = "cpuacct",
-	.css_alloc = cpuacct_css_alloc,
-	.css_free = cpuacct_css_free,
-	.subsys_id = cpuacct_subsys_id,
-	.base_cftypes = files,
-};
-#endif	/* CONFIG_CGROUP_CPUACCT */
-
 void dump_cpu_task(int cpu)
 {
 	pr_info("Task dump for CPU %d:\n", cpu);
diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
new file mode 100644
index 0000000..50ec24b
--- /dev/null
+++ b/kernel/sched/cpuacct.c
@@ -0,0 +1,227 @@
+#include <linux/cgroup.h>
+#include <linux/slab.h>
+#include <linux/percpu.h>
+#include <linux/spinlock.h>
+#include <linux/cpumask.h>
+#include <linux/seq_file.h>
+#include <linux/rcupdate.h>
+#include <linux/kernel_stat.h>
+
+#include "sched.h"
+
+/*
+ * CPU accounting code for task groups.
+ *
+ * Based on the work by Paul Menage (menage@google.com) and Balbir Singh
+ * (balbir@in.ibm.com).
+ */
+
+struct cpuacct root_cpuacct;
+
+/* create a new cpu accounting group */
+static struct cgroup_subsys_state *cpuacct_css_alloc(struct cgroup *cgrp)
+{
+	struct cpuacct *ca;
+
+	if (!cgrp->parent)
+		return &root_cpuacct.css;
+
+	ca = kzalloc(sizeof(*ca), GFP_KERNEL);
+	if (!ca)
+		goto out;
+
+	ca->cpuusage = alloc_percpu(u64);
+	if (!ca->cpuusage)
+		goto out_free_ca;
+
+	ca->cpustat = alloc_percpu(struct kernel_cpustat);
+	if (!ca->cpustat)
+		goto out_free_cpuusage;
+
+	return &ca->css;
+
+out_free_cpuusage:
+	free_percpu(ca->cpuusage);
+out_free_ca:
+	kfree(ca);
+out:
+	return ERR_PTR(-ENOMEM);
+}
+
+/* destroy an existing cpu accounting group */
+static void cpuacct_css_free(struct cgroup *cgrp)
+{
+	struct cpuacct *ca = cgroup_ca(cgrp);
+
+	free_percpu(ca->cpustat);
+	free_percpu(ca->cpuusage);
+	kfree(ca);
+}
+
+static u64 cpuacct_cpuusage_read(struct cpuacct *ca, int cpu)
+{
+	u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
+	u64 data;
+
+#ifndef CONFIG_64BIT
+	/*
+	 * Take rq->lock to make 64-bit read safe on 32-bit platforms.
+	 */
+	raw_spin_lock_irq(&cpu_rq(cpu)->lock);
+	data = *cpuusage;
+	raw_spin_unlock_irq(&cpu_rq(cpu)->lock);
+#else
+	data = *cpuusage;
+#endif
+
+	return data;
+}
+
+static void cpuacct_cpuusage_write(struct cpuacct *ca, int cpu, u64 val)
+{
+	u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
+
+#ifndef CONFIG_64BIT
+	/*
+	 * Take rq->lock to make 64-bit write safe on 32-bit platforms.
+	 */
+	raw_spin_lock_irq(&cpu_rq(cpu)->lock);
+	*cpuusage = val;
+	raw_spin_unlock_irq(&cpu_rq(cpu)->lock);
+#else
+	*cpuusage = val;
+#endif
+}
+
+/* return total cpu usage (in nanoseconds) of a group */
+static u64 cpuusage_read(struct cgroup *cgrp, struct cftype *cft)
+{
+	struct cpuacct *ca = cgroup_ca(cgrp);
+	u64 totalcpuusage = 0;
+	int i;
+
+	for_each_present_cpu(i)
+		totalcpuusage += cpuacct_cpuusage_read(ca, i);
+
+	return totalcpuusage;
+}
+
+static int cpuusage_write(struct cgroup *cgrp, struct cftype *cftype,
+								u64 reset)
+{
+	struct cpuacct *ca = cgroup_ca(cgrp);
+	int err = 0;
+	int i;
+
+	if (reset) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	for_each_present_cpu(i)
+		cpuacct_cpuusage_write(ca, i, 0);
+
+out:
+	return err;
+}
+
+static int cpuacct_percpu_seq_read(struct cgroup *cgroup, struct cftype *cft,
+				   struct seq_file *m)
+{
+	struct cpuacct *ca = cgroup_ca(cgroup);
+	u64 percpu;
+	int i;
+
+	for_each_present_cpu(i) {
+		percpu = cpuacct_cpuusage_read(ca, i);
+		seq_printf(m, "%llu ", (unsigned long long) percpu);
+	}
+	seq_printf(m, "\n");
+	return 0;
+}
+
+static const char * const cpuacct_stat_desc[] = {
+	[CPUACCT_STAT_USER] = "user",
+	[CPUACCT_STAT_SYSTEM] = "system",
+};
+
+static int cpuacct_stats_show(struct cgroup *cgrp, struct cftype *cft,
+			      struct cgroup_map_cb *cb)
+{
+	struct cpuacct *ca = cgroup_ca(cgrp);
+	int cpu;
+	s64 val = 0;
+
+	for_each_online_cpu(cpu) {
+		struct kernel_cpustat *kcpustat = per_cpu_ptr(ca->cpustat, cpu);
+		val += kcpustat->cpustat[CPUTIME_USER];
+		val += kcpustat->cpustat[CPUTIME_NICE];
+	}
+	val = cputime64_to_clock_t(val);
+	cb->fill(cb, cpuacct_stat_desc[CPUACCT_STAT_USER], val);
+
+	val = 0;
+	for_each_online_cpu(cpu) {
+		struct kernel_cpustat *kcpustat = per_cpu_ptr(ca->cpustat, cpu);
+		val += kcpustat->cpustat[CPUTIME_SYSTEM];
+		val += kcpustat->cpustat[CPUTIME_IRQ];
+		val += kcpustat->cpustat[CPUTIME_SOFTIRQ];
+	}
+
+	val = cputime64_to_clock_t(val);
+	cb->fill(cb, cpuacct_stat_desc[CPUACCT_STAT_SYSTEM], val);
+
+	return 0;
+}
+
+static struct cftype files[] = {
+	{
+		.name = "usage",
+		.read_u64 = cpuusage_read,
+		.write_u64 = cpuusage_write,
+	},
+	{
+		.name = "usage_percpu",
+		.read_seq_string = cpuacct_percpu_seq_read,
+	},
+	{
+		.name = "stat",
+		.read_map = cpuacct_stats_show,
+	},
+	{ }	/* terminate */
+};
+
+/*
+ * charge this task's execution time to its accounting group.
+ *
+ * called with rq->lock held.
+ */
+void cpuacct_charge(struct task_struct *tsk, u64 cputime)
+{
+	struct cpuacct *ca;
+	int cpu;
+
+	if (unlikely(!cpuacct_subsys.active))
+		return;
+
+	cpu = task_cpu(tsk);
+
+	rcu_read_lock();
+
+	ca = task_ca(tsk);
+
+	for (; ca; ca = parent_ca(ca)) {
+		u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
+		*cpuusage += cputime;
+	}
+
+	rcu_read_unlock();
+}
+
+struct cgroup_subsys cpuacct_subsys = {
+	.name = "cpuacct",
+	.css_alloc = cpuacct_css_alloc,
+	.css_free = cpuacct_css_free,
+	.subsys_id = cpuacct_subsys_id,
+	.base_cftypes = files,
+};
