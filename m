Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab3DTTHt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 15:07:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:41198 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523Ab3DTTGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 15:06:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,515,1363158000"; 
   d="scan'208";a="322242201"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/5] perf, x86: Add Haswell PEBS record support v5
Date: Sat, 20 Apr 2013 12:06:19 -0700
Message-Id: <1366484783-15613-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1366484783-15613-1-git-send-email-andi@firstfloor.org>
References: <1366484783-15613-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add support for the Haswell extended (fmt2) PEBS format.

It has a superset of the nhm (fmt1) PEBS fields, but has a longer record so
we need to adjust the code paths.

The main advantage is the new "EventingRip" support which directly
gives the instruction, not off-by-one instruction. So with precise == 2
we use that directly and don't try to use LBRs and walking basic blocks.
This lowers the overhead of using precise significantly.

Some other features are added in later patches.

Reviewed-by: Stephane Eranian <eranian@google.com>
v2: Rename various identifiers. Add more comments. Get rid of a cast.
v3: fmt2->hsw rename
v4: ip_of_the_event->real_ip rename
v5: use pr_cont. white space changes.
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event.c          |    3 +-
 arch/x86/kernel/cpu/perf_event_intel_ds.c |  111 +++++++++++++++++++++++------
 2 files changed, 92 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 5ed7a4c..21cfc52 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -397,7 +397,8 @@ int x86_pmu_hw_config(struct perf_event *event)
 		 * check that PEBS LBR correction does not conflict with
 		 * whatever the user is asking with attr->branch_sample_type
 		 */
-		if (event->attr.precise_ip > 1) {
+		if (event->attr.precise_ip > 1 &&
+		    x86_pmu.intel_cap.pebs_format < 2) {
 			u64 *br_type = &event->attr.branch_sample_type;
 
 			if (has_branch_stack(event)) {
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index d467561..e91d7fa 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -165,6 +165,22 @@ struct pebs_record_nhm {
 	u64 status, dla, dse, lat;
 };
 
+/*
+ * Same as pebs_record_nhm, with two additional fields.
+ */
+struct pebs_record_hsw {
+	struct pebs_record_nhm nhm;
+	/*
+	 * Real IP of the event. In the Intel documentation this
+	 * is called eventingrip.
+	 */
+	u64 real_ip;
+	/*
+	 * TSX tuning information field: abort cycles and abort flags.
+	 */
+	u64 tsx_tuning;
+};
+
 void init_debug_store_on_cpu(int cpu)
 {
 	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
@@ -696,6 +712,7 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	 */
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct pebs_record_nhm *pebs = __pebs;
+	struct pebs_record_hsw *pebs_hsw = __pebs;
 	struct perf_sample_data data;
 	struct pt_regs regs;
 	u64 sample_type;
@@ -752,7 +769,10 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	regs.bp = pebs->bp;
 	regs.sp = pebs->sp;
 
-	if (event->attr.precise_ip > 1 && intel_pmu_pebs_fixup_ip(&regs))
+	if (event->attr.precise_ip > 1 && x86_pmu.intel_cap.pebs_format >= 2) {
+		regs.ip = pebs_hsw->real_ip;
+		regs.flags |= PERF_EFLAGS_EXACT;
+	} else if (event->attr.precise_ip > 1 && intel_pmu_pebs_fixup_ip(&regs))
 		regs.flags |= PERF_EFLAGS_EXACT;
 	else
 		regs.flags &= ~PERF_EFLAGS_EXACT;
@@ -805,35 +825,22 @@ static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
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
-
-	/*
-	 * Should not happen, we program the threshold at 1 and do not
-	 * set a reset value.
-	 */
-	WARN_ONCE(n > x86_pmu.max_pebs_events, "Unexpected number of pebs records %d\n", n);
+	for ( ; at < top; at += x86_pmu.pebs_record_size) {
+		struct pebs_record_nhm *p = at;
 
-	for ( ; at < top; at++) {
-		for_each_set_bit(bit, (unsigned long *)&at->status, x86_pmu.max_pebs_events) {
+		for_each_set_bit(bit, (unsigned long *)&p->status,
+				 x86_pmu.max_pebs_events) {
 			event = cpuc->events[bit];
 			if (!test_bit(bit, cpuc->active_mask))
 				continue;
@@ -856,6 +863,61 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
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
+static void intel_pmu_drain_pebs_hsw(struct pt_regs *iregs)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct debug_store *ds = cpuc->ds;
+	struct pebs_record_hsw *at, *top;
+	int n;
+
+	if (!x86_pmu.pebs_active)
+		return;
+
+	at  = (struct pebs_record_hsw *)(unsigned long)ds->pebs_buffer_base;
+	top = (struct pebs_record_hsw *)(unsigned long)ds->pebs_index;
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
@@ -887,6 +949,13 @@ void intel_ds_init(void)
 			x86_pmu.drain_pebs = intel_pmu_drain_pebs_nhm;
 			break;
 
+		case 2:
+			pr_cont("PEBS fmt2%c, ", pebs_type);
+			x86_pmu.pebs_record_size =
+				sizeof(struct pebs_record_hsw);
+			x86_pmu.drain_pebs = intel_pmu_drain_pebs_hsw;
+			break;
+
 		default:
 			printk(KERN_CONT "no PEBS fmt%d%c, ", format, pebs_type);
 			x86_pmu.pebs = 0;
-- 
1.7.7.6

