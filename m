Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbaJSWFn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 18:05:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:48491 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037AbaJSWFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 18:05:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="402644475"
From: Kan Liang <kan.liang@intel.com>
To: a.p.zijlstra@chello.nl, eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        acme@kernel.org, jolsa@redhat.com, ak@linux.intel.com,
        Kan Liang <kan.liang@intel.com>, "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH V6 05/17] perf, core: pmu specific data for perf task context
Date: Sun, 19 Oct 2014 17:55:00 -0400
Message-Id: <1413755712-8259-6-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1413755712-8259-1-git-send-email-kan.liang@intel.com>
References: <1413755712-8259-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a new flag PERF_ATTACH_TASK_DATA for perf event's attach
stata. The flag is set by PMU's event_init() callback, it indicates
that perf event needs PMU specific data.

The PMU specific data are initialized to zeros. Later patches will
use PMU specific data to save LBR stack.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 include/linux/perf_event.h |  6 ++++++
 kernel/events/core.c       | 40 ++++++++++++++++++++++++++++++++++++----
 2 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c392fd5..159e092 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -264,6 +264,10 @@ struct pmu {
 	 */
 	void (*sched_task)		(struct perf_event_context *ctx,
 					bool sched_in);
+	/*
+	 * PMU specific data size
+	 */
+	size_t				task_ctx_size;
 
 };
 
@@ -300,6 +304,7 @@ struct swevent_hlist {
 #define PERF_ATTACH_CONTEXT	0x01
 #define PERF_ATTACH_GROUP	0x02
 #define PERF_ATTACH_TASK	0x04
+#define PERF_ATTACH_TASK_DATA	0x08
 
 struct perf_cgroup;
 struct ring_buffer;
@@ -509,6 +514,7 @@ struct perf_event_context {
 	u64				generation;
 	int				pin_count;
 	int				nr_cgroups;	 /* cgroup evts */
+	void				*task_ctx_data; /* pmu specific data */
 	struct rcu_head			rcu_head;
 
 	struct delayed_work		orphans_remove;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5971e7d..a7c0d5c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -895,6 +895,15 @@ static void get_ctx(struct perf_event_context *ctx)
 	WARN_ON(!atomic_inc_not_zero(&ctx->refcount));
 }
 
+static void free_ctx(struct rcu_head *head)
+{
+	struct perf_event_context *ctx;
+
+	ctx = container_of(head, struct perf_event_context, rcu_head);
+	kfree(ctx->task_ctx_data);
+	kfree(ctx);
+}
+
 static void put_ctx(struct perf_event_context *ctx)
 {
 	if (atomic_dec_and_test(&ctx->refcount)) {
@@ -902,7 +911,7 @@ static void put_ctx(struct perf_event_context *ctx)
 			put_ctx(ctx->parent_ctx);
 		if (ctx->task)
 			put_task_struct(ctx->task);
-		kfree_rcu(ctx, rcu_head);
+		call_rcu(&ctx->rcu_head, free_ctx);
 	}
 }
 
@@ -3188,12 +3197,15 @@ errout:
  * Returns a matching context with refcount and pincount.
  */
 static struct perf_event_context *
-find_get_context(struct pmu *pmu, struct task_struct *task, int cpu)
+find_get_context(struct pmu *pmu, struct task_struct *task,
+		struct perf_event *event)
 {
 	struct perf_event_context *ctx, *clone_ctx = NULL;
 	struct perf_cpu_context *cpuctx;
+	void *task_ctx_data = NULL;
 	unsigned long flags;
 	int ctxn, err;
+	int cpu = event->cpu;
 
 	if (!task) {
 		/* Must be root to operate on a CPU event: */
@@ -3221,11 +3233,24 @@ find_get_context(struct pmu *pmu, struct task_struct *task, int cpu)
 	if (ctxn < 0)
 		goto errout;
 
+	if (event->attach_state & PERF_ATTACH_TASK_DATA) {
+		task_ctx_data = kzalloc(pmu->task_ctx_size, GFP_KERNEL);
+		if (!task_ctx_data) {
+			err = -ENOMEM;
+			goto errout;
+		}
+	}
+
 retry:
 	ctx = perf_lock_task_context(task, ctxn, &flags);
 	if (ctx) {
 		clone_ctx = unclone_ctx(ctx);
 		++ctx->pin_count;
+
+		if (task_ctx_data && !ctx->task_ctx_data) {
+			ctx->task_ctx_data = task_ctx_data;
+			task_ctx_data = NULL;
+		}
 		raw_spin_unlock_irqrestore(&ctx->lock, flags);
 
 		if (clone_ctx)
@@ -3236,6 +3261,11 @@ retry:
 		if (!ctx)
 			goto errout;
 
+		if (task_ctx_data) {
+			ctx->task_ctx_data = task_ctx_data;
+			task_ctx_data = NULL;
+		}
+
 		err = 0;
 		mutex_lock(&task->perf_event_mutex);
 		/*
@@ -3262,9 +3292,11 @@ retry:
 		}
 	}
 
+	kfree(task_ctx_data);
 	return ctx;
 
 errout:
+	kfree(task_ctx_data);
 	return ERR_PTR(err);
 }
 
@@ -7344,7 +7376,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	/*
 	 * Get the target context (task or percpu):
 	 */
-	ctx = find_get_context(pmu, task, event->cpu);
+	ctx = find_get_context(pmu, task, event);
 	if (IS_ERR(ctx)) {
 		err = PTR_ERR(ctx);
 		goto err_alloc;
@@ -7513,7 +7545,7 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 
 	account_event(event);
 
-	ctx = find_get_context(event->pmu, task, cpu);
+	ctx = find_get_context(event->pmu, task, event);
 	if (IS_ERR(ctx)) {
 		err = PTR_ERR(ctx);
 		goto err_free;
-- 
1.8.3.2

