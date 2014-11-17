Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbaKQTIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 14:08:35 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:39523 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbaKQTIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 14:08:32 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        kan.liang@intel.com, bp@alien8.de, maria.n.dimakopoulou@gmail.com
Subject: [PATCH v3 10/13] perf/x86: limit to half counters to avoid exclusive mode starvation
Date: Mon, 17 Nov 2014 20:07:02 +0100
Message-Id: <1416251225-17721-11-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416251225-17721-1-git-send-email-eranian@google.com>
References: <1416251225-17721-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch limits the number of counters available to each CPU when
the HT bug workaround is enabled. This is necessary to avoid situation
of counter starvation. Such can arise from configuration where one
HT thread, HT0,  is using all 4 counters with corrupting events which
require exclusion the the sibling HT, HT1. In such case, HT1 would not
be able to schedule any event until HT0 is done. To mitigate this,
problem, this patch artificially limits the number of counters to 2.
That way, we can gurantee that at least 2 counters are not in exclusive
mode and therefore allow the sibling thread to schedule events of the
same type (system vs. per-thread). The 2 counters are not determined
in advance. We simply set the limit to two events per HT. This helps
mitigate starvation in case of events with specific counter constraints
such a PREC_DIST.

Note that this does not elimintate the starvation is all cases. But
it is better than not having it.

Solution suggested by Peter Zjilstra.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event.h       |  2 ++
 arch/x86/kernel/cpu/perf_event_intel.c | 22 ++++++++++++++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index bbb7ffd3..d6b0337 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -132,6 +132,8 @@ enum intel_excl_state_type {
 struct intel_excl_states {
 	enum intel_excl_state_type init_state[X86_PMC_IDX_MAX];
 	enum intel_excl_state_type state[X86_PMC_IDX_MAX];
+	int  num_alloc_cntrs;/* #counters allocated */
+	int  max_alloc_cntrs;/* max #counters allowed */
 	bool sched_started; /* true if scheduling has started */
 };
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 8ad25c4..099dc8e 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1694,7 +1694,7 @@ intel_start_scheduling(struct cpu_hw_events *cpuc)
 	xl = &excl_cntrs->states[tid];
 
 	xl->sched_started = true;
-
+	xl->num_alloc_cntrs = 0;
 	/*
 	 * lock shared state until we are done scheduling
 	 * in stop_event_scheduling()
@@ -1760,7 +1760,6 @@ intel_get_excl_constraints(struct cpu_hw_events *cpuc, struct perf_event *event,
 	 */
 	if (cpuc->is_fake)
 		return c;
-
 	/*
 	 * event requires exclusive counter access
 	 * across HT threads
@@ -1774,6 +1773,18 @@ intel_get_excl_constraints(struct cpu_hw_events *cpuc, struct perf_event *event,
 	xl = &excl_cntrs->states[tid];
 	xlo = &excl_cntrs->states[o_tid];
 
+	/*
+	 * do not allow scheduling of more than max_alloc_cntrs
+	 * which is set to half the available generic counters.
+	 * this helps avoid counter starvation of sibling thread
+	 * by ensuring at most half the counters cannot be in
+	 * exclusive mode. There is not designated counters for the
+	 * limits. Any N/2 counters can be used. This helps with
+	 * events with specifix counter constraints
+	 */
+	if (xl->num_alloc_cntrs++ == xl->max_alloc_cntrs)
+		return &emptyconstraint;
+
 	cx = c;
 
 	/*
@@ -2384,6 +2395,8 @@ static void intel_pmu_cpu_starting(int cpu)
 		cpuc->lbr_sel = &cpuc->shared_regs->regs[EXTRA_REG_LBR];
 
 	if (x86_pmu.flags & PMU_FL_EXCL_CNTRS) {
+		int h = x86_pmu.num_counters >> 1;
+
 		for_each_cpu(i, topology_thread_cpumask(cpu)) {
 			struct intel_excl_cntrs *c;
 
@@ -2397,6 +2410,11 @@ static void intel_pmu_cpu_starting(int cpu)
 		}
 		cpuc->excl_cntrs->core_id = core_id;
 		cpuc->excl_cntrs->refcnt++;
+		/*
+		 * set hard limit to half the number of generic counters
+		 */
+		cpuc->excl_cntrs->states[0].max_alloc_cntrs = h;
+		cpuc->excl_cntrs->states[1].max_alloc_cntrs = h;
 	}
 }
 
-- 
1.9.1

