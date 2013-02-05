Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643Ab3BEBuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 20:50:10 -0500
Received: from mga14.intel.com ([143.182.124.37]:57228 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793Ab3BEBt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 20:49:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,602,1355126400"; 
   d="scan'208";a="252605708"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, acme@redhat.com, eranian@google.com,
        jolsa@redhat.com, namhyung@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/5] perf, x86: Add PEBSv2 record support v2
Date: Mon,  4 Feb 2013 17:49:10 -0800
Message-Id: <1360028954-16946-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1360028954-16946-1-git-send-email-andi@firstfloor.org>
References: <1360028954-16946-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add support for the v2 PEBS format. It has a superset of the v1 PEBS
fields, but has a longer record so we need to adjust the code paths.

The main advantage is the new "EventingRip" support which directly
gives the instruction, not off-by-one instruction. So with precise == 2
we use that directly and don't try to use LBRs and walking basic blocks.
This lowers the overhead significantly.

Some other features are added in later patches.

Reviewed-by: Stephane Eranian <eranian@google.com>
v2: Rename various identifiers. Add more comments. Get rid of a cast.
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event.c          |    2 +-
 arch/x86/kernel/cpu/perf_event_intel_ds.c |  113 +++++++++++++++++++++++------
 2 files changed, 91 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 6774c17..c95290a 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -397,7 +397,7 @@ int x86_pmu_hw_config(struct perf_event *event)
 		 * check that PEBS LBR correction does not conflict with
 		 * whatever the user is asking with attr->branch_sample_type
 		 */
-		if (event->attr.precise_ip > 1) {
+		if (event->attr.precise_ip > 1 && x86_pmu.intel_cap.pebs_format < 2) {
 			u64 *br_type = &event->attr.branch_sample_type;
 
 			if (has_branch_stack(event)) {
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 826054a..3a828ed 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -41,6 +41,22 @@ struct pebs_record_nhm {
 	u64 status, dla, dse, lat;
 };
 
+/*
+ * Same as pebs_record_nhm, with two additional fields.
+ */
+struct pebs_record_fmt2 {
+	struct pebs_record_nhm nhm;
+	/* 
+	 * Real IP of the event. In the Intel documentation this
+	 * is called eventingrip.
+	 */
+	u64 ip_of_the_event;
+	/* 
+	 * TSX tuning information field: abort cycles and abort flags.
+	 */
+	u64 tsx_tuning;
+};
+
 void init_debug_store_on_cpu(int cpu)
 {
 	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
@@ -559,11 +575,11 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 {
 	/*
 	 * We cast to pebs_record_core since that is a subset of
-	 * both formats and we don't use the other fields in this
-	 * routine.
+	 * all formats.
 	 */
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct pebs_record_core *pebs = __pebs;
+	struct pebs_record_fmt2 *pebs_fmt2 = __pebs;
 	struct perf_sample_data data;
 	struct pt_regs regs;
 
@@ -588,7 +604,10 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	regs.bp = pebs->bp;
 	regs.sp = pebs->sp;
 
-	if (event->attr.precise_ip > 1 && intel_pmu_pebs_fixup_ip(&regs))
+	if (event->attr.precise_ip > 1 && x86_pmu.intel_cap.pebs_format >= 2) {
+		regs.ip = pebs_fmt2->ip_of_the_event;
+		regs.flags |= PERF_EFLAGS_EXACT;
+	} else if (event->attr.precise_ip > 1 && intel_pmu_pebs_fixup_ip(&regs))
 		regs.flags |= PERF_EFLAGS_EXACT;
 	else
 		regs.flags &= ~PERF_EFLAGS_EXACT;
@@ -641,35 +660,21 @@ static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
 	__intel_pmu_pebs_event(event, iregs, at);
 }
 
-static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
+static void __intel_pmu_drain_pebs_nhm(struct pt_regs *iregs, void *at,
+					void *top)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct debug_store *ds = cpuc->ds;
-	struct pebs_record_nhm *at, *top;
 	struct perf_event *event = NULL;
 	u64 status = 0;
-	int bit, n;
-
-	if (!x86_pmu.pebs_active)
-		return;
-
-	at  = (struct pebs_record_nhm *)(unsigned long)ds->pebs_buffer_base;
-	top = (struct pebs_record_nhm *)(unsigned long)ds->pebs_index;
+	int bit;
 
 	ds->pebs_index = ds->pebs_buffer_base;
 
-	n = top - at;
-	if (n <= 0)
-		return;
+	for ( ; at < top; at += x86_pmu.pebs_record_size) {
+		struct pebs_record_nhm *p = at;
 
-	/*
-	 * Should not happen, we program the threshold at 1 and do not
-	 * set a reset value.
-	 */
-	WARN_ONCE(n > x86_pmu.max_pebs_events, "Unexpected number of pebs records %d\n", n);
-
-	for ( ; at < top; at++) {
-		for_each_set_bit(bit, (unsigned long *)&at->status, x86_pmu.max_pebs_events) {
+		for_each_set_bit(bit, (unsigned long *)&p->status, x86_pmu.max_pebs_events) {
 			event = cpuc->events[bit];
 			if (!test_bit(bit, cpuc->active_mask))
 				continue;
@@ -692,6 +697,61 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 	}
 }
 
+static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct debug_store *ds = cpuc->ds;
+	struct pebs_record_nhm *at, *top;
+	int n;
+
+	if (!x86_pmu.pebs_active)
+		return;
+
+	at  = (struct pebs_record_nhm *)(unsigned long)ds->pebs_buffer_base;
+	top = (struct pebs_record_nhm *)(unsigned long)ds->pebs_index;
+
+	ds->pebs_index = ds->pebs_buffer_base;
+
+	n = top - at;
+	if (n <= 0)
+		return;
+
+	/*
+	 * Should not happen, we program the threshold at 1 and do not
+	 * set a reset value.
+	 */
+	WARN_ONCE(n > x86_pmu.max_pebs_events,
+		  "Unexpected number of pebs records %d\n", n);
+
+	return __intel_pmu_drain_pebs_nhm(iregs, at, top);
+}
+
+static void intel_pmu_drain_pebs_fmt2(struct pt_regs *iregs)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct debug_store *ds = cpuc->ds;
+	struct pebs_record_fmt2 *at, *top;
+	int n;
+
+	if (!x86_pmu.pebs_active)
+		return;
+
+	at  = (struct pebs_record_fmt2 *)(unsigned long)ds->pebs_buffer_base;
+	top = (struct pebs_record_fmt2 *)(unsigned long)ds->pebs_index;
+
+	n = top - at;
+	if (n <= 0)
+		return;
+	/*
+	 * Should not happen, we program the threshold at 1 and do not
+	 * set a reset value.
+	 */
+	WARN_ONCE(n > x86_pmu.max_pebs_events,
+		  "Unexpected number of pebs records %d\n", n);
+
+	return __intel_pmu_drain_pebs_nhm(iregs, at, top);
+}
+
 /*
  * BTS, PEBS probe and setup
  */
@@ -723,6 +783,13 @@ void intel_ds_init(void)
 			x86_pmu.drain_pebs = intel_pmu_drain_pebs_nhm;
 			break;
 
+		case 2:
+			printk(KERN_CONT "PEBS fmt2%c, ", pebs_type);
+			x86_pmu.pebs_record_size = 
+				sizeof(struct pebs_record_fmt2);
+			x86_pmu.drain_pebs = intel_pmu_drain_pebs_fmt2;
+			break;
+
 		default:
 			printk(KERN_CONT "no PEBS fmt%d%c, ", format, pebs_type);
 			x86_pmu.pebs = 0;
-- 
1.7.7.6

