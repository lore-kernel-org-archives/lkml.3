Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbaCMVWr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 17:22:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:9720 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753521AbaCMVWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 17:22:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,649,1389772800"; 
   d="scan'208";a="498053665"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, eranian@google.com,
        acme@redhat.com, namhyung@kernel.org, jolsa@redhat.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/2] perf, x86: Disallow setting undefined bits for PEBS events
Date: Thu, 13 Mar 2014 14:22:12 -0700
Message-Id: <1394745733-27855-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The SDM forbids setting various event qualifiers with PEBS
events. The magic cycles:pp event uses it, but it has caused
problems in the past. We continue allowing it for cycles:pp,
but forbid it for all other events to follow the SDM.

SDM Vol 3 18.8.4:
"PEBS events are only valid when the following fields of
IA32_PERFEVTSELx are all zero: AnyThread, Edge, Invert, Cmask."

One visible change from this is that the cycles:pp event
can now only be set with "cycles:pp", but not with
raw form. If that was a problem we can allow it again.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event.h       |  2 +-
 arch/x86/kernel/cpu/perf_event_intel.c | 26 +++++++++++++++++++++++---
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 1cca3d8..cf1eda1 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -461,7 +461,7 @@ struct x86_pmu {
 	int		pebs_record_size;
 	void		(*drain_pebs)(struct pt_regs *regs);
 	struct event_constraint *pebs_constraints;
-	void		(*pebs_aliases)(struct perf_event *event);
+	void		(*pebs_aliases)(struct perf_event *event, bool *changed);
 	int 		max_pebs_events;
 
 	/*
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index bf0a64c..f42562e 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1691,7 +1691,7 @@ static void intel_put_event_constraints(struct cpu_hw_events *cpuc,
 	intel_put_shared_regs_event_constraints(cpuc, event);
 }
 
-static void intel_pebs_aliases_core2(struct perf_event *event)
+static void intel_pebs_aliases_core2(struct perf_event *event, bool *changed)
 {
 	if ((event->hw.config & X86_RAW_EVENT_MASK) == 0x003c) {
 		/*
@@ -1716,10 +1716,11 @@ static void intel_pebs_aliases_core2(struct perf_event *event)
 
 		alt_config |= (event->hw.config & ~X86_RAW_EVENT_MASK);
 		event->hw.config = alt_config;
+		*changed = true;
 	}
 }
 
-static void intel_pebs_aliases_snb(struct perf_event *event)
+static void intel_pebs_aliases_snb(struct perf_event *event, bool *changed)
 {
 	if ((event->hw.config & X86_RAW_EVENT_MASK) == 0x003c) {
 		/*
@@ -1744,18 +1745,26 @@ static void intel_pebs_aliases_snb(struct perf_event *event)
 
 		alt_config |= (event->hw.config & ~X86_RAW_EVENT_MASK);
 		event->hw.config = alt_config;
+		*changed = true;
 	}
 }
 
+#define ARCH_PERFMON_NOT_WITH_PEBS 	\
+	(ARCH_PERFMON_EVENTSEL_ANY | 	\
+	 ARCH_PERFMON_EVENTSEL_CMASK | 	\
+	 ARCH_PERFMON_EVENTSEL_EDGE | 	\
+	 ARCH_PERFMON_EVENTSEL_INV)
+
 static int intel_pmu_hw_config(struct perf_event *event)
 {
+	bool changed = false;
 	int ret = x86_pmu_hw_config(event);
 
 	if (ret)
 		return ret;
 
 	if (event->attr.precise_ip && x86_pmu.pebs_aliases)
-		x86_pmu.pebs_aliases(event);
+		x86_pmu.pebs_aliases(event, &changed);
 
 	if (intel_pmu_needs_lbr_smpl(event)) {
 		ret = intel_pmu_setup_lbr_filter(event);
@@ -1766,6 +1775,17 @@ static int intel_pmu_hw_config(struct perf_event *event)
 	if (event->attr.type != PERF_TYPE_RAW)
 		return 0;
 
+	/* 
+	 * SDM Vol 3 18.8.4: 
+	 * "PEBS events are only valid when the following fields of 
+	 * IA32_PERFEVTSELx are all zero: AnyThread, Edge, Invert, Cmask.
+	 *
+	 * We only make an exception for the magic pebs aliases.
+	 */
+	if (event->attr.precise_ip && !changed &&
+		(event->attr.config & ARCH_PERFMON_NOT_WITH_PEBS))
+		return -EINVAL;
+
 	if (!(event->attr.config & ARCH_PERFMON_EVENTSEL_ANY))
 		return 0;
 
-- 
1.8.5.3

