Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaJSWJd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 18:09:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:48491 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbaJSWFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 18:05:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="402644488"
From: Kan Liang <kan.liang@intel.com>
To: a.p.zijlstra@chello.nl, eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        acme@kernel.org, jolsa@redhat.com, ak@linux.intel.com,
        Kan Liang <kan.liang@intel.com>, "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH V6 08/17] perf, x86: track number of events that use LBR callstack
Date: Sun, 19 Oct 2014 17:55:03 -0400
Message-Id: <1413755712-8259-9-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1413755712-8259-1-git-send-email-kan.liang@intel.com>
References: <1413755712-8259-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When enabling/disabling an event, check if the event uses the LBR
callstack feature, adjust the LBR callstack usage count accordingly.
Later patch will use the usage count to decide if LBR stack should
be saved/restored.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index e0ba9c0..f9b9f2b 100644
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
@@ -220,6 +226,12 @@ void intel_pmu_lbr_enable(struct perf_event *event)
 	}
 	cpuc->br_sel = event->hw.branch_reg.reg;
 
+	if (branch_user_callstack(cpuc->br_sel) && event->ctx &&
+					event->ctx->task_ctx_data) {
+		task_ctx = event->ctx->task_ctx_data;
+		task_ctx->lbr_callstack_users++;
+	}
+
 	cpuc->lbr_users++;
 	perf_sched_cb_inc(event->ctx->pmu);
 }
@@ -227,10 +239,17 @@ void intel_pmu_lbr_enable(struct perf_event *event)
 void intel_pmu_lbr_disable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct x86_perf_task_context *task_ctx;
 
 	if (!x86_pmu.lbr_nr)
 		return;
 
+	if (branch_user_callstack(cpuc->br_sel) && event->ctx &&
+					event->ctx->task_ctx_data) {
+		task_ctx = event->ctx->task_ctx_data;
+		task_ctx->lbr_callstack_users--;
+	}
+
 	cpuc->lbr_users--;
 	WARN_ON_ONCE(cpuc->lbr_users < 0);
 	perf_sched_cb_dec(event->ctx->pmu);
-- 
1.8.3.2

