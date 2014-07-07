Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbaGGGbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 02:31:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:11640 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbaGGG3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 02:29:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,616,1400050800"; 
   d="scan'208";a="539565578"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH v5 08/16] perf, x86: track number of events that use LBR callstack
Date: Mon,  7 Jul 2014 14:28:39 +0800
Message-Id: <1404714527-18603-11-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404714527-18603-1-git-send-email-zheng.z.yan@intel.com>
References: <1404714527-18603-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When enabling/disabling an event, check if the event uses the LBR
callstack feature, adjust the LBR callstack usage count accordingly.
Later patch will use the usage count to decide if LBR stack should
be saved/restored.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 909f70a..9ae1875 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -204,9 +204,15 @@ void intel_pmu_lbr_sched_task(struct perf_event_context *ctx, bool sched_in)
 	}
 }
 
+static inline bool branch_user_callstack(unsigned br_sel)
+{
+	return (br_sel & X86_BR_USER) && (br_sel & X86_BR_CALL_STACK);
+}
+
 void intel_pmu_lbr_enable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct x86_perf_task_context *task_ctx;
 
 	if (!x86_pmu.lbr_nr)
 		return;
@@ -220,6 +226,10 @@ void intel_pmu_lbr_enable(struct perf_event *event)
 	}
 	cpuc->br_sel = event->hw.branch_reg.reg;
 
+	task_ctx = event->ctx ? event->ctx->task_ctx_data : NULL;
+	if (task_ctx && branch_user_callstack(cpuc->br_sel))
+		task_ctx->lbr_callstack_users++;
+
 	cpuc->lbr_users++;
 	if (cpuc->lbr_users == 1)
 		perf_sched_cb_enable(event->ctx->pmu);
@@ -228,10 +238,15 @@ void intel_pmu_lbr_enable(struct perf_event *event)
 void intel_pmu_lbr_disable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct x86_perf_task_context *task_ctx;
 
 	if (!x86_pmu.lbr_nr)
 		return;
 
+	task_ctx = event->ctx ? event->ctx->task_ctx_data : NULL;
+	if (task_ctx && branch_user_callstack(cpuc->br_sel))
+		task_ctx->lbr_callstack_users--;
+
 	cpuc->lbr_users--;
 	WARN_ON_ONCE(cpuc->lbr_users < 0);
 
-- 
1.9.3

