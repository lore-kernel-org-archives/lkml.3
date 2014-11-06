Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbaKFPLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 10:11:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:37569 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbaKFPJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 10:09:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,326,1413270000"; 
   d="scan'208";a="627701905"
From: Kan Liang <kan.liang@intel.com>
To: a.p.zijlstra@chello.nl, eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        acme@kernel.org, jolsa@redhat.com, ak@linux.intel.com,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH V8 08/14] perf, x86: track number of events that use LBR callstack
Date: Thu,  6 Nov 2014 09:54:25 -0500
Message-Id: <1415285671-16894-9-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1415285671-16894-1-git-send-email-kan.liang@intel.com>
References: <1415285671-16894-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yan, Zheng <zheng.z.yan@intel.com>

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
index 4246053..eb584ff 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -205,9 +205,15 @@ void intel_pmu_lbr_sched_task(struct perf_event_context *ctx, bool sched_in)
 	}
 }
 
+static inline bool branch_user_callstack(unsigned br_sel)
+{
+	return (br_sel & X86_BR_USER) && (br_sel & X86_BR_CALL_STACK);
+}
+
 void intel_pmu_lbr_enable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
+	struct x86_perf_task_context *task_ctx;
 
 	if (!x86_pmu.lbr_nr)
 		return;
@@ -222,6 +228,12 @@ void intel_pmu_lbr_enable(struct perf_event *event)
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
@@ -229,10 +241,17 @@ void intel_pmu_lbr_enable(struct perf_event *event)
 void intel_pmu_lbr_disable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
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

