Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbaJIQiO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 12:38:14 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:51039 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757198AbaJIQfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 12:35:38 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        kan.liang@intel.com, bp@alien8.de, maria.n.dimakopoulou@gmail.com
Subject: [PATCH v2 04/12] perf/x86: add index param to get_event_constraint() callback
Date: Thu,  9 Oct 2014 18:34:38 +0200
Message-Id: <1412872486-2930-5-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412872486-2930-1-git-send-email-eranian@google.com>
References: <1412872486-2930-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an index parameter to the get_event_constraint()
x86_pmu callback. It is expected to represent the index of the
event in the cpuc->event_list[] array. When the callback is used
for fake_cpuc (evnet validation), then the index must be -1. The
motivation for passing the index is to use it to index into another
cpuc array.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event.c       |  4 ++--
 arch/x86/kernel/cpu/perf_event.h       |  4 +++-
 arch/x86/kernel/cpu/perf_event_amd.c   |  6 ++++--
 arch/x86/kernel/cpu/perf_event_intel.c | 15 ++++++++++-----
 4 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index ca44ba2..56b97a4 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -739,7 +739,7 @@ int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 
 	for (i = 0, wmin = X86_PMC_IDX_MAX, wmax = 0; i < n; i++) {
 		hwc = &cpuc->event_list[i]->hw;
-		c = x86_pmu.get_event_constraints(cpuc, cpuc->event_list[i]);
+		c = x86_pmu.get_event_constraints(cpuc, i, cpuc->event_list[i]);
 		hwc->constraint = c;
 
 		wmin = min(wmin, c->weight);
@@ -1731,7 +1731,7 @@ static int validate_event(struct perf_event *event)
 	if (IS_ERR(fake_cpuc))
 		return PTR_ERR(fake_cpuc);
 
-	c = x86_pmu.get_event_constraints(fake_cpuc, event);
+	c = x86_pmu.get_event_constraints(fake_cpuc, -1, event);
 
 	if (!c || !c->weight)
 		ret = -EINVAL;
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index b6848c3..667a185 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -443,6 +443,7 @@ struct x86_pmu {
 	u64		max_period;
 	struct event_constraint *
 			(*get_event_constraints)(struct cpu_hw_events *cpuc,
+						 int idx,
 						 struct perf_event *event);
 
 	void		(*put_event_constraints)(struct cpu_hw_events *cpuc,
@@ -690,7 +691,8 @@ static inline int amd_pmu_init(void)
 int intel_pmu_save_and_restart(struct perf_event *event);
 
 struct event_constraint *
-x86_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event);
+x86_get_event_constraints(struct cpu_hw_events *cpuc, int idx,
+			  struct perf_event *event);
 
 struct intel_shared_regs *allocate_shared_regs(int cpu);
 
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index a8d1a43..65b9a4b 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -430,7 +430,8 @@ static void amd_pmu_cpu_dead(int cpu)
 }
 
 static struct event_constraint *
-amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
+amd_get_event_constraints(struct cpu_hw_events *cpuc, int idx,
+			  struct perf_event *event)
 {
 	/*
 	 * if not NB event or no NB, then no constraints
@@ -538,7 +539,8 @@ static struct event_constraint amd_f15_PMC50 = EVENT_CONSTRAINT(0, 0x3F, 0);
 static struct event_constraint amd_f15_PMC53 = EVENT_CONSTRAINT(0, 0x38, 0);
 
 static struct event_constraint *
-amd_get_event_constraints_f15h(struct cpu_hw_events *cpuc, struct perf_event *event)
+amd_get_event_constraints_f15h(struct cpu_hw_events *cpuc, int idx,
+			       struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	unsigned int event_code = amd_get_event_code(hwc);
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 4b6a3b0..64bbb57 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1753,7 +1753,8 @@ intel_shared_regs_constraints(struct cpu_hw_events *cpuc,
 }
 
 struct event_constraint *
-x86_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
+x86_get_event_constraints(struct cpu_hw_events *cpuc, int idx,
+			  struct perf_event *event)
 {
 	struct event_constraint *c;
 
@@ -1770,7 +1771,8 @@ x86_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 }
 
 static struct event_constraint *
-intel_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
+intel_get_event_constraints(struct cpu_hw_events *cpuc, int idx,
+			    struct perf_event *event)
 {
 	struct event_constraint *c;
 
@@ -1786,7 +1788,7 @@ intel_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event
 	if (c)
 		return c;
 
-	return x86_get_event_constraints(cpuc, event);
+	return x86_get_event_constraints(cpuc, idx, event);
 }
 
 static void
@@ -2020,9 +2022,12 @@ static struct event_constraint counter2_constraint =
 			EVENT_CONSTRAINT(0, 0x4, 0);
 
 static struct event_constraint *
-hsw_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
+hsw_get_event_constraints(struct cpu_hw_events *cpuc, int idx,
+			  struct perf_event *event)
 {
-	struct event_constraint *c = intel_get_event_constraints(cpuc, event);
+	struct event_constraint *c;
+
+	c = intel_get_event_constraints(cpuc, idx, event);
 
 	/* Handle special quirk on in_tx_checkpointed only in counter 2 */
 	if (event->hw.config & HSW_IN_TX_CHECKPOINTED) {
-- 
1.9.1

