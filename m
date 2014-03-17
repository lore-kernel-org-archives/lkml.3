Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbaCQGE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 02:04:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:62763 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932320AbaCQF6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 01:58:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,667,1389772800"; 
   d="scan'208";a="473898260"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH v4 02/16] perf, core: introduce pmu context switch callback
Date: Mon, 17 Mar 2014 13:57:22 +0800
Message-Id: <1395035856-15411-3-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1395035856-15411-1-git-send-email-zheng.z.yan@intel.com>
References: <1395035856-15411-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The callback is invoked when process is scheduled in or out.
It provides mechanism for later patches to save/store the LBR
stack. For the schedule in case, the callback is invoked at
the same place that flush branch stack callback is invoked.
So it also can replace the flush branch stack callback. To
avoid unnecessary overhead, the callback is enabled only when
there are events use the LBR stack.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c |  7 +++++
 arch/x86/kernel/cpu/perf_event.h |  2 ++
 include/linux/perf_event.h       |  8 ++++++
 kernel/events/core.c             | 60 +++++++++++++++++++++++++++++++++++++++-
 4 files changed, 76 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index ae407f7..03e977f 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1872,6 +1872,12 @@ static const struct attribute_group *x86_pmu_attr_groups[] = {
 	NULL,
 };
 
+static void x86_pmu_sched_task(struct perf_event_context *ctx, bool sched_in)
+{
+	if (x86_pmu.sched_task)
+		x86_pmu.sched_task(ctx, sched_in);
+}
+
 static void x86_pmu_flush_branch_stack(void)
 {
 	if (x86_pmu.flush_branch_stack)
@@ -1905,6 +1911,7 @@ static struct pmu pmu = {
 
 	.event_idx		= x86_pmu_event_idx,
 	.flush_branch_stack	= x86_pmu_flush_branch_stack,
+	.sched_task		= x86_pmu_sched_task,
 };
 
 void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index b58c0ba..1e2118a 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -429,6 +429,8 @@ struct x86_pmu {
 
 	void		(*check_microcode)(void);
 	void		(*flush_branch_stack)(void);
+	void		(*sched_task)(struct perf_event_context *ctx,
+				      bool sched_in);
 
 	/*
 	 * Intel Arch Perfmon v2+
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index e56b07f..adc20f2 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -251,6 +251,12 @@ struct pmu {
 	 * flush branch stack on context-switches (needed in cpu-wide mode)
 	 */
 	void (*flush_branch_stack)	(void);
+
+	/*
+	 * PMU callback for context-switches. optional
+	 */
+	void (*sched_task)		(struct perf_event_context *ctx,
+					 bool sched_in);
 };
 
 /**
@@ -544,6 +550,8 @@ extern void perf_event_delayed_put(struct task_struct *task);
 extern void perf_event_print_debug(void);
 extern void perf_pmu_disable(struct pmu *pmu);
 extern void perf_pmu_enable(struct pmu *pmu);
+extern void perf_sched_cb_disable(struct pmu *pmu);
+extern void perf_sched_cb_enable(struct pmu *pmu);
 extern int perf_event_task_disable(void);
 extern int perf_event_task_enable(void);
 extern int perf_event_refresh(struct perf_event *event, int refresh);
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 661951a..5a24193 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -142,6 +142,7 @@ enum event_type_t {
 struct static_key_deferred perf_sched_events __read_mostly;
 static DEFINE_PER_CPU(atomic_t, perf_cgroup_events);
 static DEFINE_PER_CPU(atomic_t, perf_branch_stack_events);
+static DEFINE_PER_CPU(int, perf_sched_cb_usages);
 
 static atomic_t nr_mmap_events __read_mostly;
 static atomic_t nr_comm_events __read_mostly;
@@ -151,6 +152,7 @@ static atomic_t nr_freq_events __read_mostly;
 static LIST_HEAD(pmus);
 static DEFINE_MUTEX(pmus_lock);
 static struct srcu_struct pmus_srcu;
+static struct idr pmu_idr;
 
 /*
  * perf event paranoia level:
@@ -2358,6 +2360,57 @@ unlock:
 	}
 }
 
+void perf_sched_cb_disable(struct pmu *pmu)
+{
+	__get_cpu_var(perf_sched_cb_usages)--;
+}
+
+void perf_sched_cb_enable(struct pmu *pmu)
+{
+	__get_cpu_var(perf_sched_cb_usages)++;
+}
+
+/*
+ * This function provides the context switch callback to the lower code
+ * layer. It is invoked ONLY when the context switch callback is enabled.
+ */
+static void perf_pmu_sched_task(struct task_struct *prev,
+				struct task_struct *next,
+				bool sched_in)
+{
+	struct perf_cpu_context *cpuctx;
+	struct pmu *pmu;
+	unsigned long flags;
+
+	if (prev == next)
+		return;
+
+	local_irq_save(flags);
+
+	rcu_read_lock();
+
+	pmu = idr_find(&pmu_idr, PERF_TYPE_RAW);
+
+	if (pmu && pmu->sched_task) {
+		cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
+		pmu = cpuctx->ctx.pmu;
+
+		perf_ctx_lock(cpuctx, cpuctx->task_ctx);
+
+		perf_pmu_disable(pmu);
+
+		pmu->sched_task(cpuctx->task_ctx, sched_in);
+
+		perf_pmu_enable(pmu);
+
+		perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
+	}
+
+	rcu_read_unlock();
+
+	local_irq_restore(flags);
+}
+
 #define for_each_task_context_nr(ctxn)					\
 	for ((ctxn) = 0; (ctxn) < perf_nr_task_contexts; (ctxn)++)
 
@@ -2377,6 +2430,9 @@ void __perf_event_task_sched_out(struct task_struct *task,
 {
 	int ctxn;
 
+	if (__get_cpu_var(perf_sched_cb_usages))
+		perf_pmu_sched_task(task, next, false);
+
 	for_each_task_context_nr(ctxn)
 		perf_event_context_sched_out(task, ctxn, next);
 
@@ -2634,6 +2690,9 @@ void __perf_event_task_sched_in(struct task_struct *prev,
 	/* check for system-wide branch_stack events */
 	if (atomic_read(&__get_cpu_var(perf_branch_stack_events)))
 		perf_branch_stack_sched_in(prev, task);
+
+	if (__get_cpu_var(perf_sched_cb_usages))
+		perf_pmu_sched_task(prev, task, true);
 }
 
 static u64 perf_calculate_period(struct perf_event *event, u64 nsec, u64 count)
@@ -6359,7 +6418,6 @@ static void free_pmu_context(struct pmu *pmu)
 out:
 	mutex_unlock(&pmus_lock);
 }
-static struct idr pmu_idr;
 
 static ssize_t
 type_show(struct device *dev, struct device_attribute *attr, char *page)
-- 
1.8.5.3

