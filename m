Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbaBRGHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 01:07:51 -0500
Received: from mga11.intel.com ([192.55.52.93]:48812 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754117AbaBRGHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 01:07:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,500,1389772800"; 
   d="scan'208";a="483239641"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH v3 02/14] perf, core: introduce pmu context switch callback
Date: Tue, 18 Feb 2014 14:07:29 +0800
Message-Id: <1392703661-15104-3-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392703661-15104-1-git-send-email-zheng.z.yan@intel.com>
References: <1392703661-15104-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The callback is invoked when process is scheduled in or out. It
provides mechanism for later patches to save/store the LBR stack.
It can also replace the flush branch stack callback.

To avoid unnecessary overhead, the callback is enabled dynamically

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c |  7 +++++
 arch/x86/kernel/cpu/perf_event.h |  4 +++
 include/linux/perf_event.h       |  8 ++++++
 kernel/events/core.c             | 60 +++++++++++++++++++++++++++++++++++++++-
 4 files changed, 78 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 895604f..68c0314 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1850,6 +1850,12 @@ static const struct attribute_group *x86_pmu_attr_groups[] = {
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
@@ -1883,6 +1889,7 @@ static struct pmu pmu = {
 
 	.event_idx		= x86_pmu_event_idx,
 	.flush_branch_stack	= x86_pmu_flush_branch_stack,
+	.sched_task		= x86_pmu_sched_task,
 };
 
 void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 518025e..551f09b 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -427,6 +427,8 @@ struct x86_pmu {
 
 	void		(*check_microcode)(void);
 	void		(*flush_branch_stack)(void);
+	void		(*sched_task)(struct perf_event_context *ctx,
+				      bool sched_in);
 
 	/*
 	 * Intel Arch Perfmon v2+
@@ -685,6 +687,8 @@ void intel_pmu_pebs_disable_all(void);
 
 void intel_ds_init(void);
 
+void intel_pmu_lbr_sched_task(struct perf_event_context *ctx, bool sched_in);
+
 void intel_pmu_lbr_reset(void);
 
 void intel_pmu_lbr_enable(struct perf_event *event);
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
index 2067cbb..350e566 100644
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
@@ -2353,6 +2355,57 @@ unlock:
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
 
@@ -2372,6 +2425,9 @@ void __perf_event_task_sched_out(struct task_struct *task,
 {
 	int ctxn;
 
+	if (__get_cpu_var(perf_sched_cb_usages))
+		perf_pmu_sched_task(task, next, false);
+
 	for_each_task_context_nr(ctxn)
 		perf_event_context_sched_out(task, ctxn, next);
 
@@ -2631,6 +2687,9 @@ void __perf_event_task_sched_in(struct task_struct *prev,
 	/* check for system-wide branch_stack events */
 	if (atomic_read(&__get_cpu_var(perf_branch_stack_events)))
 		perf_branch_stack_sched_in(prev, task);
+
+	if (__get_cpu_var(perf_sched_cb_usages))
+		perf_pmu_sched_task(prev, task, true);
 }
 
 static u64 perf_calculate_period(struct perf_event *event, u64 nsec, u64 count)
@@ -6356,7 +6415,6 @@ static void free_pmu_context(struct pmu *pmu)
 out:
 	mutex_unlock(&pmus_lock);
 }
-static struct idr pmu_idr;
 
 static ssize_t
 type_show(struct device *dev, struct device_attribute *attr, char *page)
-- 
1.8.5.3

