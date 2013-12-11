Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab3LKHOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 02:14:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:40037 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415Ab3LKHLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 02:11:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,870,1378882800"; 
   d="scan'208";a="450352470"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH 06/15] perf, core: PMU specific data for perf task context
Date: Wed, 11 Dec 2013 15:10:51 +0800
Message-Id: <1386745860-21143-7-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386745860-21143-1-git-send-email-zheng.z.yan@intel.com>
References: <1386745860-21143-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

allow allocating PMU specific data for perf task context

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 include/linux/perf_event.h |  5 +++++
 kernel/events/core.c       | 19 ++++++++++++++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 96cb88b..147f9d3 100644
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
@@ -496,6 +500,7 @@ struct perf_event_context {
 	int				pin_count;
 	int				nr_cgroups;	 /* cgroup evts */
 	int				nr_branch_stack; /* branch_stack evt */
+	void				*task_ctx_data; /* pmu specific data */
 	struct rcu_head			rcu_head;
 };
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index c281265..6499dae 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -882,6 +882,15 @@ static void get_ctx(struct perf_event_context *ctx)
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
@@ -889,7 +898,7 @@ static void put_ctx(struct perf_event_context *ctx)
 			put_ctx(ctx->parent_ctx);
 		if (ctx->task)
 			put_task_struct(ctx->task);
-		kfree_rcu(ctx, rcu_head);
+		call_rcu(&ctx->rcu_head, free_ctx);
 	}
 }
 
@@ -3025,6 +3034,14 @@ alloc_perf_context(struct pmu *pmu, struct task_struct *task)
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
1.8.1.4

