Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278AbaJIQfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 12:35:23 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45639 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757183AbaJIQfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 12:35:14 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        kan.liang@intel.com, bp@alien8.de, maria.n.dimakopoulou@gmail.com
Subject: [PATCH v2 01/12] perf,x86: rename er_flags to flags
Date: Thu,  9 Oct 2014 18:34:35 +0200
Message-Id: <1412872486-2930-2-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412872486-2930-1-git-send-email-eranian@google.com>
References: <1412872486-2930-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because it will be used for more than just
tracking the presence of extra registers.

Reviewed-by: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event.h       |  9 ++++++---
 arch/x86/kernel/cpu/perf_event_intel.c | 24 ++++++++++++------------
 2 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index d98a34d..8af5010 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -502,7 +502,7 @@ struct x86_pmu {
 	 * Extra registers for events
 	 */
 	struct extra_reg *extra_regs;
-	unsigned int er_flags;
+	unsigned int flags;
 
 	/*
 	 * Intel host/guest support (KVM)
@@ -519,8 +519,11 @@ do {									\
 	x86_pmu.quirks = &__quirk;					\
 } while (0)
 
-#define ERF_NO_HT_SHARING	1
-#define ERF_HAS_RSP_1		2
+/*
+ * x86_pmu flags
+ */
+#define PMU_FL_NO_HT_SHARING	0x1 /* no hyper-threading resource sharing */
+#define PMU_FL_HAS_RSP_1	0x2 /* has 2 equivalent offcore_rsp regs   */
 
 #define EVENT_VAR(_id)  event_attr_##_id
 #define EVENT_PTR(_id) &event_attr_##_id.attr.attr
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 3851def..9f79da7 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1593,7 +1593,7 @@ intel_bts_constraints(struct perf_event *event)
 
 static int intel_alt_er(int idx)
 {
-	if (!(x86_pmu.er_flags & ERF_HAS_RSP_1))
+	if (!(x86_pmu.flags & PMU_FL_HAS_RSP_1))
 		return idx;
 
 	if (idx == EXTRA_REG_RSP_0)
@@ -2157,7 +2157,7 @@ static void intel_pmu_cpu_starting(int cpu)
 	if (!cpuc->shared_regs)
 		return;
 
-	if (!(x86_pmu.er_flags & ERF_NO_HT_SHARING)) {
+	if (!(x86_pmu.flags & PMU_FL_NO_HT_SHARING)) {
 		for_each_cpu(i, topology_thread_cpumask(cpu)) {
 			struct intel_shared_regs *pc;
 
@@ -2589,7 +2589,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.event_constraints = intel_slm_event_constraints;
 		x86_pmu.pebs_constraints = intel_slm_pebs_event_constraints;
 		x86_pmu.extra_regs = intel_slm_extra_regs;
-		x86_pmu.er_flags |= ERF_HAS_RSP_1;
+		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
 		pr_cont("Silvermont events, ");
 		break;
 
@@ -2607,7 +2607,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.enable_all = intel_pmu_nhm_enable_all;
 		x86_pmu.pebs_constraints = intel_westmere_pebs_event_constraints;
 		x86_pmu.extra_regs = intel_westmere_extra_regs;
-		x86_pmu.er_flags |= ERF_HAS_RSP_1;
+		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
 
 		x86_pmu.cpu_events = nhm_events_attrs;
 
@@ -2639,8 +2639,8 @@ __init int intel_pmu_init(void)
 		else
 			x86_pmu.extra_regs = intel_snb_extra_regs;
 		/* all extra regs are per-cpu when HT is on */
-		x86_pmu.er_flags |= ERF_HAS_RSP_1;
-		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
+		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
+		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
 
 		x86_pmu.cpu_events = snb_events_attrs;
 
@@ -2674,8 +2674,8 @@ __init int intel_pmu_init(void)
 		else
 			x86_pmu.extra_regs = intel_snb_extra_regs;
 		/* all extra regs are per-cpu when HT is on */
-		x86_pmu.er_flags |= ERF_HAS_RSP_1;
-		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
+		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
+		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
 
 		x86_pmu.cpu_events = snb_events_attrs;
 
@@ -2702,8 +2702,8 @@ __init int intel_pmu_init(void)
 		x86_pmu.extra_regs = intel_snbep_extra_regs;
 		x86_pmu.pebs_aliases = intel_pebs_aliases_snb;
 		/* all extra regs are per-cpu when HT is on */
-		x86_pmu.er_flags |= ERF_HAS_RSP_1;
-		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
+		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
+		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
 
 		x86_pmu.hw_config = hsw_hw_config;
 		x86_pmu.get_event_constraints = hsw_get_event_constraints;
@@ -2724,8 +2724,8 @@ __init int intel_pmu_init(void)
 		x86_pmu.extra_regs = intel_snbep_extra_regs;
 		x86_pmu.pebs_aliases = intel_pebs_aliases_snb;
 		/* all extra regs are per-cpu when HT is on */
-		x86_pmu.er_flags |= ERF_HAS_RSP_1;
-		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
+		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
+		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
 
 		x86_pmu.hw_config = hsw_hw_config;
 		x86_pmu.get_event_constraints = hsw_get_event_constraints;
-- 
1.9.1

