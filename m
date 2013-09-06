Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000Ab3IFDio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 23:38:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:6703 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758633Ab3IFDho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 23:37:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,851,1371106800"; 
   d="scan'208";a="397493417"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/4] perf, x86: Report TSX transaction abort cost as weight v3
Date: Thu,  5 Sep 2013 20:37:39 -0700
Message-Id: <1378438661-24765-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1378438661-24765-1-git-send-email-andi@firstfloor.org>
References: <1378438661-24765-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Use the existing weight reporting facility to report the transaction
abort cost, that is the number of cycles wasted in aborts.
Haswell reports this in the PEBS record.

This was in fact the original user for weight.

This is a very useful sort key to concentrate on the most
costly aborts and a good metric for TSX tuning.

v2: Add Peter's changes with minor modifications. More comments.
v3: Adjust white space.
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 55 +++++++++++++++++++++++--------
 1 file changed, 42 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 3065c57..d4ed99f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -182,16 +182,29 @@ struct pebs_record_nhm {
  * Same as pebs_record_nhm, with two additional fields.
  */
 struct pebs_record_hsw {
-	struct pebs_record_nhm nhm;
-	/*
-	 * Real IP of the event. In the Intel documentation this
-	 * is called eventingrip.
-	 */
-	u64 real_ip;
-	/*
-	 * TSX tuning information field: abort cycles and abort flags.
-	 */
-	u64 tsx_tuning;
+	u64 flags, ip;
+	u64 ax, bx, cx, dx;
+	u64 si, di, bp, sp;
+	u64 r8,  r9,  r10, r11;
+	u64 r12, r13, r14, r15;
+	u64 status, dla, dse, lat;
+	u64 real_ip; /* the actual eventing ip */
+	u64 tsx_tuning; /* TSX abort cycles and flags */
+};
+
+union hsw_tsx_tuning {
+	struct {
+		u32 cycles_last_block     : 32,
+		    hle_abort		  : 1,
+		    rtm_abort		  : 1,
+		    instruction_abort     : 1,
+		    non_instruction_abort : 1,
+		    retry		  : 1,
+		    data_conflict	  : 1,
+		    capacity_writes	  : 1,
+		    capacity_reads	  : 1;
+	};
+	u64	    value;
 };
 
 void init_debug_store_on_cpu(int cpu)
@@ -759,16 +772,26 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
 	return 0;
 }
 
+static inline u64 intel_hsw_weight(struct pebs_record_hsw *pebs)
+{
+	if (pebs->tsx_tuning) {
+		union hsw_tsx_tuning tsx = { .value = pebs->tsx_tuning };
+		return tsx.cycles_last_block;
+	}
+	return 0;
+}
+
 static void __intel_pmu_pebs_event(struct perf_event *event,
 				   struct pt_regs *iregs, void *__pebs)
 {
 	/*
 	 * We cast to pebs_record_nhm to get the load latency data
 	 * if extra_reg MSR_PEBS_LD_LAT_THRESHOLD used
+	 * We cast to the biggest PEBS record are careful not
+	 * to access out-of-bounds members.
 	 */
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	struct pebs_record_nhm *pebs = __pebs;
-	struct pebs_record_hsw *pebs_hsw = __pebs;
+	struct pebs_record_hsw *pebs = __pebs;
 	struct perf_sample_data data;
 	struct pt_regs regs;
 	u64 sample_type;
@@ -827,7 +850,7 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	regs.sp = pebs->sp;
 
 	if (event->attr.precise_ip > 1 && x86_pmu.intel_cap.pebs_format >= 2) {
-		regs.ip = pebs_hsw->real_ip;
+		regs.ip = pebs->real_ip;
 		regs.flags |= PERF_EFLAGS_EXACT;
 	} else if (event->attr.precise_ip > 1 && intel_pmu_pebs_fixup_ip(&regs))
 		regs.flags |= PERF_EFLAGS_EXACT;
@@ -838,6 +861,12 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 		x86_pmu.intel_cap.pebs_format >= 1)
 		data.addr = pebs->dla;
 
+	/* Only set the TSX weight when no memory weight was requested. */
+	if ((event->attr.sample_type & PERF_SAMPLE_WEIGHT) &&
+	    !fll &&
+	    (x86_pmu.intel_cap.pebs_format >= 2))
+		data.weight = intel_hsw_weight(pebs);
+
 	if (has_branch_stack(event))
 		data.br_stack = &cpuc->lbr_stack;
 
-- 
1.8.3.1

