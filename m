Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbaFDVn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 17:43:56 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:44674 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaFDVny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 17:43:54 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        zheng.z.yan@intel.com, maria.n.dimakopoulou@gmail.com
Subject: [PATCH 1/9] perf,x86: rename er_flags to flags
Date: Wed,  4 Jun 2014 23:34:10 +0200
Message-Id: <1401917658-26065-2-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401917658-26065-1-git-send-email-eranian@google.com>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because it will be used for more than just
tracking the presence of extra registers.

Reviewed-by: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event.h       |    9 ++++++---
 arch/x86/kernel/cpu/perf_event_intel.c |   20 ++++++++++----------
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 3b2f9bd..0b50cd2 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -463,7 +463,7 @@ struct x86_pmu {
 	 * Extra registers for events
 	 */
 	struct extra_reg *extra_regs;
-	unsigned int er_flags;
+	unsigned int flags;
 
 	/*
 	 * Intel host/guest support (KVM)
@@ -480,8 +480,11 @@ do {									\
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
index adb02aa..f6f8018 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1455,7 +1455,7 @@ intel_bts_constraints(struct perf_event *event)
 
 static int intel_alt_er(int idx)
 {
-	if (!(x86_pmu.er_flags & ERF_HAS_RSP_1))
+	if (!(x86_pmu.flags & PMU_FL_HAS_RSP_1))
 		return idx;
 
 	if (idx == EXTRA_REG_RSP_0)
@@ -2001,7 +2001,7 @@ static void intel_pmu_cpu_starting(int cpu)
 	if (!cpuc->shared_regs)
 		return;
 
-	if (!(x86_pmu.er_flags & ERF_NO_HT_SHARING)) {
+	if (!(x86_pmu.flags & PMU_FL_NO_HT_SHARING)) {
 		for_each_cpu(i, topology_thread_cpumask(cpu)) {
 			struct intel_shared_regs *pc;
 
@@ -2397,7 +2397,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.event_constraints = intel_slm_event_constraints;
 		x86_pmu.pebs_constraints = intel_slm_pebs_event_constraints;
 		x86_pmu.extra_regs = intel_slm_extra_regs;
-		x86_pmu.er_flags |= ERF_HAS_RSP_1;
+		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
 		pr_cont("Silvermont events, ");
 		break;
 
@@ -2415,7 +2415,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.enable_all = intel_pmu_nhm_enable_all;
 		x86_pmu.pebs_constraints = intel_westmere_pebs_event_constraints;
 		x86_pmu.extra_regs = intel_westmere_extra_regs;
-		x86_pmu.er_flags |= ERF_HAS_RSP_1;
+		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
 
 		x86_pmu.cpu_events = nhm_events_attrs;
 
@@ -2447,8 +2447,8 @@ __init int intel_pmu_init(void)
 		else
 			x86_pmu.extra_regs = intel_snb_extra_regs;
 		/* all extra regs are per-cpu when HT is on */
-		x86_pmu.er_flags |= ERF_HAS_RSP_1;
-		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
+		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
+		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
 
 		x86_pmu.cpu_events = snb_events_attrs;
 
@@ -2478,8 +2478,8 @@ __init int intel_pmu_init(void)
 		else
 			x86_pmu.extra_regs = intel_snb_extra_regs;
 		/* all extra regs are per-cpu when HT is on */
-		x86_pmu.er_flags |= ERF_HAS_RSP_1;
-		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
+		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
+		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
 
 		x86_pmu.cpu_events = snb_events_attrs;
 
@@ -2507,8 +2507,8 @@ __init int intel_pmu_init(void)
 		x86_pmu.extra_regs = intel_snb_extra_regs;
 		x86_pmu.pebs_aliases = intel_pebs_aliases_snb;
 		/* all extra regs are per-cpu when HT is on */
-		x86_pmu.er_flags |= ERF_HAS_RSP_1;
-		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
+		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
+		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
 
 		x86_pmu.hw_config = hsw_hw_config;
 		x86_pmu.get_event_constraints = hsw_get_event_constraints;
-- 
1.7.9.5

