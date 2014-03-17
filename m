Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbaCQF6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 01:58:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:62763 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932353AbaCQF6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 01:58:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,667,1389772800"; 
   d="scan'208";a="473898316"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH v4 05/16] perf, core: pmu specific data for perf task context
Date: Mon, 17 Mar 2014 13:57:25 +0800
Message-Id: <1395035856-15411-6-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1395035856-15411-1-git-send-email-zheng.z.yan@intel.com>
References: <1395035856-15411-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a new field to 'struct pmu' to specify the size of PMU
specific data. If the size is not zero, also allocate memory for
the PMU specific data when allocating perf task context. The PMU
specific data are initialized to zeros. Later patches will use
PMU specific data to save LBR stack.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Reviewed-by: Stephane Eranian <eranian@google.com>
---
 include/linux/perf_event.h |  5 +++++
 kernel/events/core.c       | 19 ++++++++++++++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 80ddc0c..3da433d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -252,6 +252,10 @@ struct pmu {
 	 */
 	void (*sched_task)		(struct perf_event_context *ctx,
 					 bool sched_in);
+	/*
+	 * PMU specific data size
+	 */
+	size_t				task_ctx_size;
 };
 
 /**
@@ -493,6 +497,7 @@ struct perf_event_context {
 	u64				generation;
 	int				pin_count;
 	int				nr_cgroups;	 /* cgroup evts */
+	void				*task_ctx_data; /* pmu specific data */
 	struct rcu_head			rcu_head;
 };
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index d07700a..f262c57 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -903,6 +903,15 @@ static void get_ctx(struct perf_event_context *ctx)
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
@@ -910,7 +919,7 @@ static void put_ctx(struct perf_event_context *ctx)
 			put_ctx(ctx->parent_ctx);
 		if (ctx->task)
 			put_task_struct(ctx->task);
-		kfree_rcu(ctx, rcu_head);
+		call_rcu(&ctx->rcu_head, free_ctx);
 	}
 }
 
@@ -3048,6 +3057,14 @@ alloc_perf_context(struct pmu *pmu, struct task_struct *task)
 	if (!ctx)
 		return NULL;
 
+	if (task && pmu->task_ctx_size > 0) {
+		ctx->task_ctx_data = kzalloc(pmu->task_ctx_size, GFP_KERNEL);
+		if (!ctx->task_ctx_data) {
+			kfree(ctx);
+			return NULL;
+		}
+	}
+
 	__perf_event_init_context(ctx);
 	if (task) {
 		ctx->task = task;
-- 
1.8.5.3

