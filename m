Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077AbaADSWk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 13:22:40 -0500
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:18128 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754729AbaADSWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 13:22:39 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.jf.intel.com>
Subject: [PATCH RFC v2 3/4] perf/x86/Intel: IRQ-bound performance events
Date: Sat,  4 Jan 2014 19:22:35 +0100
Message-Id: <0f8b702d450fb717bb05936da25c49752f28b862.1388858996.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1388858996.git.agordeev@redhat.com>
References: <cover.1388858996.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 arch/x86/kernel/cpu/perf_event.h       |    5 ++
 arch/x86/kernel/cpu/perf_event_intel.c |   72 +++++++++++++++++++++++++++----
 2 files changed, 67 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 03c9595..78aed95 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -164,6 +164,11 @@ struct cpu_hw_events {
 	struct perf_guest_switch_msr	guest_switch_msrs[X86_PMC_IDX_MAX];
 
 	/*
+	 * Intel hardware interrupt context exclude bits
+	 */
+	u64				intel_ctrl_hardirq_mask;
+
+	/*
 	 * Intel checkpoint mask
 	 */
 	u64				intel_cp_status;
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index c656997..98a4f38 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1057,14 +1057,11 @@ static void intel_pmu_disable_all(void)
 	intel_pmu_lbr_disable_all();
 }
 
-static void intel_pmu_enable_all(int added)
+static void __intel_pmu_enable(struct cpu_hw_events *cpuc, u64 control)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-
 	intel_pmu_pebs_enable_all();
 	intel_pmu_lbr_enable_all();
-	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL,
-			x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask);
+	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, control);
 
 	if (test_bit(INTEL_PMC_IDX_FIXED_BTS, cpuc->active_mask)) {
 		struct perf_event *event =
@@ -1077,6 +1074,56 @@ static void intel_pmu_enable_all(int added)
 	}
 }
 
+static void intel_pmu_enable_all(int added)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	u64 disable_mask = cpuc->intel_ctrl_guest_mask |
+			   cpuc->intel_ctrl_hardirq_mask;
+	__intel_pmu_enable(cpuc, x86_pmu.intel_ctrl & ~disable_mask);
+}
+
+u64 __get_intel_ctrl_hardirq_mask(struct perf_event *events[], int count)
+{
+	u64 ret = 0;
+	int i;
+
+	BUG_ON(count > x86_pmu.num_counters);
+
+	for (i = 0; i < count; i++) {
+		struct perf_event *event = events[i];
+		BUG_ON(!is_hardirq_event(event));
+		if (!event->hw.state)
+			ret |= (1ull << event->hw.idx);
+	}
+
+	return ret;
+}
+
+static inline u64 intel_pmu_get_control(void)
+{
+	u64 control;
+
+	rdmsrl(MSR_CORE_PERF_GLOBAL_CTRL, control);
+
+	return control;
+}
+
+static void intel_pmu_disable_hardirq(struct perf_event *events[], int count)
+{
+	u64 control = intel_pmu_get_control();
+	u64 mask = __get_intel_ctrl_hardirq_mask(events, count);
+
+	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, control & ~mask);
+}
+
+static void intel_pmu_enable_hardirq(struct perf_event *events[], int count)
+{
+	u64 control = intel_pmu_get_control();
+	u64 mask = __get_intel_ctrl_hardirq_mask(events, count);
+
+	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, control | mask);
+}
+
 /*
  * Workaround for:
  *   Intel Errata AAK100 (model 26)
@@ -1200,6 +1247,8 @@ static void intel_pmu_disable_event(struct perf_event *event)
 		return;
 	}
 
+	if (is_hardirq_event(event))
+		cpuc->intel_ctrl_hardirq_mask &= ~(1ull << hwc->idx);
 	cpuc->intel_ctrl_guest_mask &= ~(1ull << hwc->idx);
 	cpuc->intel_ctrl_host_mask &= ~(1ull << hwc->idx);
 	cpuc->intel_cp_status &= ~(1ull << hwc->idx);
@@ -1276,6 +1325,8 @@ static void intel_pmu_enable_event(struct perf_event *event)
 		cpuc->intel_ctrl_guest_mask |= (1ull << hwc->idx);
 	if (event->attr.exclude_guest)
 		cpuc->intel_ctrl_host_mask |= (1ull << hwc->idx);
+	if (is_hardirq_event(event))
+		cpuc->intel_ctrl_hardirq_mask |= (1ull << hwc->idx);
 
 	if (unlikely(event_is_checkpointed(event)))
 		cpuc->intel_cp_status |= (1ull << hwc->idx);
@@ -1347,7 +1398,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 	struct perf_sample_data data;
 	struct cpu_hw_events *cpuc;
 	int bit, loops;
-	u64 status;
+	u64 control, status;
 	int handled;
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
@@ -1358,11 +1409,12 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 	 */
 	if (!x86_pmu.late_ack)
 		apic_write(APIC_LVTPC, APIC_DM_NMI);
+	control = intel_pmu_get_control();
 	intel_pmu_disable_all();
 	handled = intel_pmu_drain_bts_buffer();
 	status = intel_pmu_get_status();
 	if (!status) {
-		intel_pmu_enable_all(0);
+		__intel_pmu_enable(cpuc, control);
 		return handled;
 	}
 
@@ -1427,7 +1479,7 @@ again:
 		goto again;
 
 done:
-	intel_pmu_enable_all(0);
+	__intel_pmu_enable(cpuc, control);
 	/*
 	 * Only unmask the NMI after the overflow counters
 	 * have been reset. This avoids spurious NMIs on
@@ -2078,8 +2130,8 @@ static __initconst const struct x86_pmu intel_pmu = {
 	.disable_all		= intel_pmu_disable_all,
 	.enable_all		= intel_pmu_enable_all,
 	.enable			= intel_pmu_enable_event,
-	.disable_hardirq	= x86_pmu_nop_hardirq,
-	.enable_hardirq		= x86_pmu_nop_hardirq,
+	.disable_hardirq	= intel_pmu_disable_hardirq,
+	.enable_hardirq		= intel_pmu_enable_hardirq,
 	.disable		= intel_pmu_disable_event,
 	.hw_config		= intel_pmu_hw_config,
 	.schedule_events	= x86_schedule_events,
-- 
1.7.7.6

