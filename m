Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbaBRGLB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 01:11:01 -0500
Received: from mga11.intel.com ([192.55.52.93]:43042 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754364AbaBRGHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 01:07:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,500,1389772800"; 
   d="scan'208";a="483239660"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH v3 05/14] perf, core: pmu specific data for perf task context
Date: Tue, 18 Feb 2014 14:07:32 +0800
Message-Id: <1392703661-15104-6-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392703661-15104-1-git-send-email-zheng.z.yan@intel.com>
References: <1392703661-15104-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a new field to 'struct pmu' to specify the size of PMU
specific data. Allocate memory for PMU specific data when allocating
perf task context. The PMU specific data are initialized to zeros.
Later patches will use PMU specific data to save LBR stack.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
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
index 202e3fd..da551c5 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -898,6 +898,15 @@ static void get_ctx(struct perf_event_context *ctx)
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
@@ -905,7 +914,7 @@ static void put_ctx(struct perf_event_context *ctx)
 			put_ctx(ctx->parent_ctx);
 		if (ctx->task)
 			put_task_struct(ctx->task);
-		kfree_rcu(ctx, rcu_head);
+		call_rcu(&ctx->rcu_head, free_ctx);
 	}
 }
 
@@ -3044,6 +3053,14 @@ alloc_perf_context(struct pmu *pmu, struct task_struct *task)
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

