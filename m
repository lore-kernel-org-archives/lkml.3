Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837Ab3ILSLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:11:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37849 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756596Ab3ILSEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:04:52 -0400
Date: Thu, 12 Sep 2013 11:04:14 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-748e86aa90edfddfa6016f1cf383ff5bc6aada91@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1378438661-24765-3-git-send-email-andi@firstfloor.org>
References: <1378438661-24765-3-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86:
  Report TSX transaction abort cost as weight
Git-Commit-ID: 748e86aa90edfddfa6016f1cf383ff5bc6aada91
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 12 Sep 2013 11:04:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  748e86aa90edfddfa6016f1cf383ff5bc6aada91
Gitweb:     http://git.kernel.org/tip/748e86aa90edfddfa6016f1cf383ff5bc6aada91
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Thu, 5 Sep 2013 20:37:39 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 12 Sep 2013 19:13:34 +0200

perf/x86: Report TSX transaction abort cost as weight

Use the existing weight reporting facility to report the transaction
abort cost, that is the number of cycles wasted in aborts.
Haswell reports this in the PEBS record.

This was in fact the original user for weight.

This is a very useful sort key to concentrate on the most
costly aborts and a good metric for TSX tuning.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1378438661-24765-3-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 55 +++++++++++++++++++++++--------
 1 file changed, 42 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 63438aa..104cbba 100644
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
@@ -785,16 +798,26 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
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
@@ -853,7 +876,7 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	regs.sp = pebs->sp;
 
 	if (event->attr.precise_ip > 1 && x86_pmu.intel_cap.pebs_format >= 2) {
-		regs.ip = pebs_hsw->real_ip;
+		regs.ip = pebs->real_ip;
 		regs.flags |= PERF_EFLAGS_EXACT;
 	} else if (event->attr.precise_ip > 1 && intel_pmu_pebs_fixup_ip(&regs))
 		regs.flags |= PERF_EFLAGS_EXACT;
@@ -864,6 +887,12 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
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
 
