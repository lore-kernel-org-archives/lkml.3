Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423045Ab3FUOVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 10:21:53 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:51483 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422996Ab3FUOVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 10:21:50 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH 2/8] perf,x86: drop event->flags and use hw.constraint->flags
Date: Fri, 21 Jun 2013 16:20:42 +0200
Message-Id: <1371824448-7306-3-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371824448-7306-1-git-send-email-eranian@google.com>
References: <1371824448-7306-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we use the contraints directly from the event, we
do not need the event->flags field so drop it.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c    |  6 +-----
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 19 ++++++++++---------
 include/linux/perf_event.h                |  1 -
 3 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index a6eccf1..d04be6c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1449,11 +1449,8 @@ x86_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 
 	if (x86_pmu.event_constraints) {
 		for_each_event_constraint(c, x86_pmu.event_constraints) {
-			if ((event->hw.config & c->cmask) == c->code) {
-				/* hw.flags zeroed at initialization */
-				event->hw.flags |= c->flags;
+			if ((event->hw.config & c->cmask) == c->code)
 				return c;
-			}
 		}
 	}
 
@@ -1498,7 +1495,6 @@ intel_put_shared_regs_event_constraints(struct cpu_hw_events *cpuc,
 static void intel_put_event_constraints(struct cpu_hw_events *cpuc,
 					struct perf_event *event)
 {
-	event->hw.flags = 0;
 	intel_put_shared_regs_event_constraints(cpuc, event);
 }
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 3065c57..06d02fa 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -623,7 +623,6 @@ struct event_constraint *intel_pebs_constraints(struct perf_event *event)
 	if (x86_pmu.pebs_constraints) {
 		for_each_event_constraint(c, x86_pmu.pebs_constraints) {
 			if ((event->hw.config & c->cmask) == c->code) {
-				event->hw.flags |= c->flags;
 				return c;
 			}
 		}
@@ -636,14 +635,15 @@ void intel_pmu_pebs_enable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
+	int flags = event->hw.constraint->flags;
 
 	hwc->config &= ~ARCH_PERFMON_EVENTSEL_INT;
 
 	cpuc->pebs_enabled |= 1ULL << hwc->idx;
 
-	if (event->hw.flags & PERF_X86_EVENT_PEBS_LDLAT)
+	if (flags & PERF_X86_EVENT_PEBS_LDLAT)
 		cpuc->pebs_enabled |= 1ULL << (hwc->idx + 32);
-	else if (event->hw.flags & PERF_X86_EVENT_PEBS_ST)
+	else if (flags & PERF_X86_EVENT_PEBS_ST)
 		cpuc->pebs_enabled |= 1ULL << 63;
 }
 
@@ -651,12 +651,13 @@ void intel_pmu_pebs_disable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
+	int flags = event->hw.constraint->flags;
 
 	cpuc->pebs_enabled &= ~(1ULL << hwc->idx);
 
-	if (event->hw.constraint->flags & PERF_X86_EVENT_PEBS_LDLAT)
+	if (flags & PERF_X86_EVENT_PEBS_LDLAT)
 		cpuc->pebs_enabled &= ~(1ULL << (hwc->idx + 32));
-	else if (event->hw.constraint->flags & PERF_X86_EVENT_PEBS_ST)
+	else if (flags & PERF_X86_EVENT_PEBS_ST)
 		cpuc->pebs_enabled &= ~(1ULL << 63);
 
 	if (cpuc->enabled)
@@ -772,14 +773,14 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	struct perf_sample_data data;
 	struct pt_regs regs;
 	u64 sample_type;
+	int flags = event->hw.constraint->flags;
 	int fll, fst;
 
 	if (!intel_pmu_save_and_restart(event))
 		return;
 
-	fll = event->hw.flags & PERF_X86_EVENT_PEBS_LDLAT;
-	fst = event->hw.flags & (PERF_X86_EVENT_PEBS_ST |
-				 PERF_X86_EVENT_PEBS_ST_HSW);
+	fll = flags & PERF_X86_EVENT_PEBS_LDLAT;
+	fst = flags & (PERF_X86_EVENT_PEBS_ST | PERF_X86_EVENT_PEBS_ST_HSW);
 
 	perf_sample_data_init(&data, 0, event->hw.last_period);
 
@@ -802,7 +803,7 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 		if (sample_type & PERF_SAMPLE_DATA_SRC) {
 			if (fll)
 				data.data_src.val = load_latency_data(pebs->dse);
-			else if (event->hw.flags & PERF_X86_EVENT_PEBS_ST_HSW)
+			else if (flags & PERF_X86_EVENT_PEBS_ST_HSW)
 				data.data_src.val =
 					precise_store_data_hsw(pebs->dse);
 			else
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 4ccf846..535d89c 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -134,7 +134,6 @@ struct hw_perf_event {
 			int		event_base_rdpmc;
 			int		idx;
 			int		last_cpu;
-			int		flags;
 
 			struct hw_perf_event_extra extra_reg;
 			struct hw_perf_event_extra branch_reg;
-- 
1.8.1.2

