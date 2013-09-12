Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab3ILSKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:10:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37876 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701Ab3ILSFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:05:17 -0400
Date: Thu, 12 Sep 2013 11:04:44 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-8q6y4davda9aawwv5yxe7klp@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/intel: Clean-up/reduce PEBS code
Git-Commit-ID: d2beea4a3419e63804094e9ac4b6d1518bc17a9b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 12 Sep 2013 11:04:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d2beea4a3419e63804094e9ac4b6d1518bc17a9b
Gitweb:     http://git.kernel.org/tip/d2beea4a3419e63804094e9ac4b6d1518bc17a9b
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 12 Sep 2013 13:00:47 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 12 Sep 2013 19:13:37 +0200

perf/x86/intel: Clean-up/reduce PEBS code

Get rid of some pointless duplication introduced by the Haswell code.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-8q6y4davda9aawwv5yxe7klp@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 94 +++++++++----------------------
 1 file changed, 26 insertions(+), 68 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 104cbba..f364c13 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -188,8 +188,7 @@ struct pebs_record_hsw {
 	u64 r8,  r9,  r10, r11;
 	u64 r12, r13, r14, r15;
 	u64 status, dla, dse, lat;
-	u64 real_ip; /* the actual eventing ip */
-	u64 tsx_tuning; /* TSX abort cycles and flags */
+	u64 real_ip, tsx_tuning;
 };
 
 union hsw_tsx_tuning {
@@ -811,10 +810,8 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 				   struct pt_regs *iregs, void *__pebs)
 {
 	/*
-	 * We cast to pebs_record_nhm to get the load latency data
-	 * if extra_reg MSR_PEBS_LD_LAT_THRESHOLD used
-	 * We cast to the biggest PEBS record are careful not
-	 * to access out-of-bounds members.
+	 * We cast to the biggest pebs_record but are careful not to
+	 * unconditionally access the 'extra' entries.
 	 */
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct pebs_record_hsw *pebs = __pebs;
@@ -884,12 +881,11 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 		regs.flags &= ~PERF_EFLAGS_EXACT;
 
 	if ((event->attr.sample_type & PERF_SAMPLE_ADDR) &&
-		x86_pmu.intel_cap.pebs_format >= 1)
+	    x86_pmu.intel_cap.pebs_format >= 1)
 		data.addr = pebs->dla;
 
 	/* Only set the TSX weight when no memory weight was requested. */
-	if ((event->attr.sample_type & PERF_SAMPLE_WEIGHT) &&
-	    !fll &&
+	if ((event->attr.sample_type & PERF_SAMPLE_WEIGHT) && !fll &&
 	    (x86_pmu.intel_cap.pebs_format >= 2))
 		data.weight = intel_hsw_weight(pebs);
 
@@ -941,17 +937,34 @@ static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
 	__intel_pmu_pebs_event(event, iregs, at);
 }
 
-static void __intel_pmu_drain_pebs_nhm(struct pt_regs *iregs, void *at,
-					void *top)
+static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct debug_store *ds = cpuc->ds;
 	struct perf_event *event = NULL;
+	void *at, *top;
 	u64 status = 0;
-	int bit;
+	int bit, n;
+
+	if (!x86_pmu.pebs_active)
+		return;
+
+	at  = (struct pebs_record_nhm *)(unsigned long)ds->pebs_buffer_base;
+	top = (struct pebs_record_nhm *)(unsigned long)ds->pebs_index;
 
 	ds->pebs_index = ds->pebs_buffer_base;
 
+	n = (top - at) / x86_pmu.pebs_record_size;
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
 	for (; at < top; at += x86_pmu.pebs_record_size) {
 		struct pebs_record_nhm *p = at;
 
@@ -979,61 +992,6 @@ static void __intel_pmu_drain_pebs_nhm(struct pt_regs *iregs, void *at,
 	}
 }
 
-static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
-{
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	struct debug_store *ds = cpuc->ds;
-	struct pebs_record_nhm *at, *top;
-	int n;
-
-	if (!x86_pmu.pebs_active)
-		return;
-
-	at  = (struct pebs_record_nhm *)(unsigned long)ds->pebs_buffer_base;
-	top = (struct pebs_record_nhm *)(unsigned long)ds->pebs_index;
-
-	ds->pebs_index = ds->pebs_buffer_base;
-
-	n = top - at;
-	if (n <= 0)
-		return;
-
-	/*
-	 * Should not happen, we program the threshold at 1 and do not
-	 * set a reset value.
-	 */
-	WARN_ONCE(n > x86_pmu.max_pebs_events,
-		  "Unexpected number of pebs records %d\n", n);
-
-	return __intel_pmu_drain_pebs_nhm(iregs, at, top);
-}
-
-static void intel_pmu_drain_pebs_hsw(struct pt_regs *iregs)
-{
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	struct debug_store *ds = cpuc->ds;
-	struct pebs_record_hsw *at, *top;
-	int n;
-
-	if (!x86_pmu.pebs_active)
-		return;
-
-	at  = (struct pebs_record_hsw *)(unsigned long)ds->pebs_buffer_base;
-	top = (struct pebs_record_hsw *)(unsigned long)ds->pebs_index;
-
-	n = top - at;
-	if (n <= 0)
-		return;
-	/*
-	 * Should not happen, we program the threshold at 1 and do not
-	 * set a reset value.
-	 */
-	WARN_ONCE(n > x86_pmu.max_pebs_events,
-		  "Unexpected number of pebs records %d\n", n);
-
-	return __intel_pmu_drain_pebs_nhm(iregs, at, top);
-}
-
 /*
  * BTS, PEBS probe and setup
  */
@@ -1068,7 +1026,7 @@ void intel_ds_init(void)
 		case 2:
 			pr_cont("PEBS fmt2%c, ", pebs_type);
 			x86_pmu.pebs_record_size = sizeof(struct pebs_record_hsw);
-			x86_pmu.drain_pebs = intel_pmu_drain_pebs_hsw;
+			x86_pmu.drain_pebs = intel_pmu_drain_pebs_nhm;
 			break;
 
 		default:
