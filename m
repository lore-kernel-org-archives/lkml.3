Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab3FCJlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 05:41:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756780Ab3FCJlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 05:41:42 -0400
Date: Mon, 3 Jun 2013 11:42:40 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH RFC -tip 5/6] perf/x86/Intel PMU: IRQ-bound performance events
Message-ID: <20130603094239.GG30878@dhcp-26-207.brq.redhat.com>
References: <cover.1370251263.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1370251263.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c    |   74 +++++++++++++++++++++++++----
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    5 +-
 2 files changed, 68 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 0e8f183..d215408 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -878,6 +878,24 @@ static inline bool intel_pmu_needs_lbr_smpl(struct perf_event *event)
 	return false;
 }
 
+u64 __get_intel_ctrl_irq_mask(struct cpu_hw_events *cpuc, int irq)
+{
+	int idx;
+	u64 ret = 0;
+
+	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
+		struct perf_event *event = cpuc->events[idx];
+
+		if (!test_bit(idx, cpuc->actirq_mask))
+			continue;
+
+		if ((event->irq == irq) || (irq < 0))
+			ret |= (1ull << event->hw.idx);
+	}
+
+	return ret;
+}
+
 static void intel_pmu_disable_all(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
@@ -891,14 +909,14 @@ static void intel_pmu_disable_all(void)
 	intel_pmu_lbr_disable_all();
 }
 
-static void intel_pmu_enable_all(int added)
+static void __intel_pmu_enable(u64 control)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
 	intel_pmu_pebs_enable_all();
 	intel_pmu_lbr_enable_all();
-	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL,
-			x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask);
+
+	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, control);
 
 	if (test_bit(INTEL_PMC_IDX_FIXED_BTS, cpuc->active_mask)) {
 		struct perf_event *event =
@@ -911,6 +929,33 @@ static void intel_pmu_enable_all(int added)
 	}
 }
 
+static void intel_pmu_enable_all(int added)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	u64 irq_mask = __get_intel_ctrl_irq_mask(cpuc, -1);
+
+	__intel_pmu_enable(x86_pmu.intel_ctrl &
+			 ~(cpuc->intel_ctrl_guest_mask | irq_mask));
+}
+
+static void intel_pmu_disable_irq(int irq)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	u64 irq_mask = __get_intel_ctrl_irq_mask(cpuc, irq);
+
+	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL,
+		x86_pmu.intel_ctrl & ~(cpuc->intel_ctrl_guest_mask | irq_mask));
+}
+
+static void intel_pmu_enable_irq(int irq)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	u64 irq_mask = __get_intel_ctrl_irq_mask(cpuc, irq);
+
+	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL,
+		(x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask) | irq_mask);
+}
+
 /*
  * Workaround for:
  *   Intel Errata AAK100 (model 26)
@@ -992,6 +1037,15 @@ static void intel_pmu_nhm_enable_all(int added)
 	intel_pmu_enable_all(added);
 }
 
+static inline u64 intel_pmu_get_control(void)
+{
+	u64 control;
+
+	rdmsrl(MSR_CORE_PERF_GLOBAL_CTRL, control);
+
+	return control;
+}
+
 static inline u64 intel_pmu_get_status(void)
 {
 	u64 status;
@@ -1161,7 +1215,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 	struct perf_sample_data data;
 	struct cpu_hw_events *cpuc;
 	int bit, loops;
-	u64 status;
+	u64 control, status;
 	int handled;
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
@@ -1176,11 +1230,12 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 	 */
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
 
+	control = intel_pmu_get_control();
 	intel_pmu_disable_all();
 	handled = intel_pmu_drain_bts_buffer();
 	status = intel_pmu_get_status();
 	if (!status) {
-		intel_pmu_enable_all(0);
+		__intel_pmu_enable(control);
 		return handled;
 	}
 
@@ -1211,7 +1266,8 @@ again:
 
 		handled++;
 
-		if (!test_bit(bit, cpuc->active_mask))
+		if (!test_bit(bit, cpuc->active_mask) &&
+		    !test_bit(bit, cpuc->actirq_mask))
 			continue;
 
 		if (!intel_pmu_save_and_restart(event))
@@ -1234,7 +1290,7 @@ again:
 		goto again;
 
 done:
-	intel_pmu_enable_all(0);
+	__intel_pmu_enable(control);
 	return handled;
 }
 
@@ -1839,8 +1895,8 @@ static __initconst const struct x86_pmu intel_pmu = {
 	.handle_irq		= intel_pmu_handle_irq,
 	.disable_all		= intel_pmu_disable_all,
 	.enable_all		= intel_pmu_enable_all,
-	.disable_irq		= x86_pmu_enable_irq_nop_int,
-	.enable_irq		= x86_pmu_enable_irq_nop_int,
+	.disable_irq		= intel_pmu_disable_irq,
+	.enable_irq		= intel_pmu_enable_irq,
 	.enable			= intel_pmu_enable_event,
 	.disable		= intel_pmu_disable_event,
 	.hw_config		= intel_pmu_hw_config,
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 60250f6..e72769a 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -784,7 +784,7 @@ static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
 	 */
 	ds->pebs_index = ds->pebs_buffer_base;
 
-	if (!test_bit(0, cpuc->active_mask))
+	if (!test_bit(0, cpuc->active_mask) && !test_bit(0, cpuc->actirq_mask))
 		return;
 
 	WARN_ON_ONCE(!event);
@@ -836,7 +836,8 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 	for ( ; at < top; at++) {
 		for_each_set_bit(bit, (unsigned long *)&at->status, x86_pmu.max_pebs_events) {
 			event = cpuc->events[bit];
-			if (!test_bit(bit, cpuc->active_mask))
+			if (!test_bit(bit, cpuc->active_mask) &&
+			    !test_bit(bit, cpuc->actirq_mask))
 				continue;
 
 			WARN_ON_ONCE(!event);
-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
