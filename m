Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaJSWFd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 18:05:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:48491 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961AbaJSWFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 18:05:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="402644453"
From: Kan Liang <kan.liang@intel.com>
To: a.p.zijlstra@chello.nl, eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        acme@kernel.org, jolsa@redhat.com, ak@linux.intel.com,
        Kan Liang <kan.liang@intel.com>, "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH V6 02/17] perf, core: introduce pmu context switch callback
Date: Sun, 19 Oct 2014 17:54:57 -0400
Message-Id: <1413755712-8259-3-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1413755712-8259-1-git-send-email-kan.liang@intel.com>
References: <1413755712-8259-1-git-send-email-kan.liang@intel.com>
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
Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c |  7 +++++
 arch/x86/kernel/cpu/perf_event.h |  2 ++
 include/linux/perf_event.h       |  9 +++++++
 kernel/events/core.c             | 57 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 75 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 16c7302..b42a204 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1887,6 +1887,12 @@ static const struct attribute_group *x86_pmu_attr_groups[] = {
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
@@ -1920,6 +1926,7 @@ static struct pmu pmu = {
 
 	.event_idx		= x86_pmu_event_idx,
 	.flush_branch_stack	= x86_pmu_flush_branch_stack,
+	.sched_task		= x86_pmu_sched_task,
 };
 
 void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 2d017fa..4dafbe3 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -468,6 +468,8 @@ struct x86_pmu {
 
 	void		(*check_microcode)(void);
 	void		(*flush_branch_stack)(void);
+	void		(*sched_task)(struct perf_event_context *ctx,
+				      bool sched_in);
 
 	/*
 	 * Intel Arch Perfmon v2+
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 893a0d0..40ecad1 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -263,6 +263,13 @@ struct pmu {
 	 * flush branch stack on context-switches (needed in cpu-wide mode)
 	 */
 	void (*flush_branch_stack)	(void);
+
+	/*
+	 * context-switches callback
+	 */
+	void (*sched_task)		(struct perf_event_context *ctx,
+					bool sched_in);
+
 };
 
 /**
@@ -562,6 +569,8 @@ extern void perf_event_delayed_put(struct task_struct *task);
 extern void perf_event_print_debug(void);
 extern void perf_pmu_disable(struct pmu *pmu);
 extern void perf_pmu_enable(struct pmu *pmu);
+extern void perf_sched_cb_dec(struct pmu *pmu);
+extern void perf_sched_cb_inc(struct pmu *pmu);
 extern int perf_event_task_disable(void);
 extern int perf_event_task_enable(void);
 extern int perf_event_refresh(struct perf_event *event, int refresh);
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 094df8c..362cb3a 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -154,6 +154,7 @@ enum event_type_t {
 struct static_key_deferred perf_sched_events __read_mostly;
 static DEFINE_PER_CPU(atomic_t, perf_cgroup_events);
 static DEFINE_PER_CPU(atomic_t, perf_branch_stack_events);
+static DEFINE_PER_CPU(int, perf_sched_cb_usages);
 
 static atomic_t nr_mmap_events __read_mostly;
 static atomic_t nr_comm_events __read_mostly;
@@ -2435,6 +2436,56 @@ unlock:
 	}
 }
 
+void perf_sched_cb_dec(struct pmu *pmu)
+{
+	this_cpu_dec(perf_sched_cb_usages);
+}
+
+void perf_sched_cb_inc(struct pmu *pmu)
+{
+	this_cpu_inc(perf_sched_cb_usages);
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
+	list_for_each_entry_rcu(pmu, &pmus, entry) {
+		if (pmu->sched_task) {
+			cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
+
+			perf_ctx_lock(cpuctx, cpuctx->task_ctx);
+
+			perf_pmu_disable(pmu);
+
+			pmu->sched_task(cpuctx->task_ctx, sched_in);
+
+			perf_pmu_enable(pmu);
+
+			perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
+		}
+	}
+
+	rcu_read_unlock();
+
+	local_irq_restore(flags);
+}
+
 #define for_each_task_context_nr(ctxn)					\
 	for ((ctxn) = 0; (ctxn) < perf_nr_task_contexts; (ctxn)++)
 
@@ -2454,6 +2505,9 @@ void __perf_event_task_sched_out(struct task_struct *task,
 {
 	int ctxn;
 
+	if (__this_cpu_read(perf_sched_cb_usages))
+		perf_pmu_sched_task(task, next, false);
+
 	for_each_task_context_nr(ctxn)
 		perf_event_context_sched_out(task, ctxn, next);
 
@@ -2711,6 +2765,9 @@ void __perf_event_task_sched_in(struct task_struct *prev,
 	/* check for system-wide branch_stack events */
 	if (atomic_read(&__get_cpu_var(perf_branch_stack_events)))
 		perf_branch_stack_sched_in(prev, task);
+
+	if (__this_cpu_read(perf_sched_cb_usages))
+		perf_pmu_sched_task(prev, task, true);
 }
 
 static u64 perf_calculate_period(struct perf_event *event, u64 nsec, u64 count)
-- 
1.8.3.2

