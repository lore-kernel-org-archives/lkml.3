Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab3A3GbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 01:31:11 -0500
Received: from mga14.intel.com ([143.182.124.37]:57476 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519Ab3A3GbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 01:31:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,565,1355126400"; 
   d="scan'208";a="196543112"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, acme@redhat.com, eranian@google.com,
        namhyung@kernel.org, "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH 3/7] perf, x86: Introduce x86 special perf event context
Date: Wed, 30 Jan 2013 14:30:53 +0800
Message-Id: <1359527457-6837-4-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1359527457-6837-1-git-send-email-zheng.z.yan@intel.com>
References: <1359527457-6837-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

The x86 special perf event context is named x86_perf_event_context,
We can enlarge it later to store PMU special data.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c | 12 ++++++++++++
 arch/x86/kernel/cpu/perf_event.h |  4 ++++
 include/linux/perf_event.h       |  5 +++++
 kernel/events/core.c             | 28 ++++++++++++++++++----------
 4 files changed, 39 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 375498a..7981230 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1742,6 +1742,17 @@ static int x86_pmu_event_idx(struct perf_event *event)
 	return idx + 1;
 }
 
+static void *x86_pmu_event_context_alloc(struct perf_event_context *parent_ctx)
+{
+	struct perf_event_context *ctx;
+
+	ctx = kzalloc(sizeof(struct x86_perf_event_context), GFP_KERNEL);
+	if (!ctx)
+		return ERR_PTR(-ENOMEM);
+
+	return ctx;
+}
+
 static ssize_t get_attr_rdpmc(struct device *cdev,
 			      struct device_attribute *attr,
 			      char *buf)
@@ -1829,6 +1840,7 @@ static struct pmu pmu = {
 
 	.event_idx		= x86_pmu_event_idx,
 	.flush_branch_stack	= x86_pmu_flush_branch_stack,
+	.event_context_alloc	= x86_pmu_event_context_alloc,
 };
 
 void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index ed1e822..3080e10 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -421,6 +421,10 @@ enum {
 	PERF_SAMPLE_BRANCH_CALL_STACK = 1U << PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT,
 };
 
+struct x86_perf_event_context {
+	struct perf_event_context ctx;
+};
+
 #define x86_add_quirk(func_)						\
 do {									\
 	static struct x86_pmu_quirk __quirk __initdata = {		\
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c32fba3..6122b2f 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -264,6 +264,11 @@ struct pmu {
 	 * flush branch stack on context-switches (needed in cpu-wide mode)
 	 */
 	void (*flush_branch_stack)	(void);
+
+	/*
+	 * Allocate PMU special perf event context
+	 */
+	void *(*event_context_alloc)	(struct perf_event_context *parent_ctx);
 };
 
 /**
diff --git a/kernel/events/core.c b/kernel/events/core.c
index b4078a0..908f2ad 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2721,13 +2721,20 @@ static void __perf_event_init_context(struct perf_event_context *ctx)
 }
 
 static struct perf_event_context *
-alloc_perf_context(struct pmu *pmu, struct task_struct *task)
+alloc_perf_context(struct pmu *pmu, struct task_struct *task,
+		   struct perf_event_context *parent_ctx)
 {
 	struct perf_event_context *ctx;
 
-	ctx = kzalloc(sizeof(struct perf_event_context), GFP_KERNEL);
-	if (!ctx)
-		return NULL;
+	if (pmu->event_context_alloc) {
+		ctx = pmu->event_context_alloc(parent_ctx);
+		if (IS_ERR(ctx))
+			return ctx;
+	} else {
+		ctx = kzalloc(sizeof(struct perf_event_context), GFP_KERNEL);
+		if (!ctx)
+			return ERR_PTR(-ENOMEM);
+	}
 
 	__perf_event_init_context(ctx);
 	if (task) {
@@ -2813,10 +2820,11 @@ retry:
 		++ctx->pin_count;
 		raw_spin_unlock_irqrestore(&ctx->lock, flags);
 	} else {
-		ctx = alloc_perf_context(pmu, task);
-		err = -ENOMEM;
-		if (!ctx)
+		ctx = alloc_perf_context(pmu, task, NULL);
+		if (IS_ERR(ctx)) {
+			err = PTR_ERR(ctx);
 			goto errout;
+		}
 
 		err = 0;
 		mutex_lock(&task->perf_event_mutex);
@@ -7132,9 +7140,9 @@ inherit_task_group(struct perf_event *event, struct task_struct *parent,
 		 * child.
 		 */
 
-		child_ctx = alloc_perf_context(event->pmu, child);
-		if (!child_ctx)
-			return -ENOMEM;
+		child_ctx = alloc_perf_context(event->pmu, child, parent_ctx);
+		if (IS_ERR(child_ctx))
+			return PTR_ERR(child_ctx);
 
 		child->perf_event_ctxp[ctxn] = child_ctx;
 	}
-- 
1.7.11.7

