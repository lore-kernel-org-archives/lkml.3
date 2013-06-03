Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab3FCJlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 05:41:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150Ab3FCJlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 05:41:08 -0400
Date: Mon, 3 Jun 2013 11:42:01 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH RFC -tip 2/6] perf/x86: IRQ-bound performance events
Message-ID: <20130603094200.GD30878@dhcp-26-207.brq.redhat.com>
References: <cover.1370251263.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1370251263.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generic changes to x86 performance framework to further enable
implementations of IRQ-bound performance events.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 arch/x86/kernel/cpu/perf_event.c       |   33 +++++++++++++++++++++++++++++--
 arch/x86/kernel/cpu/perf_event.h       |    5 ++++
 arch/x86/kernel/cpu/perf_event_amd.c   |    2 +
 arch/x86/kernel/cpu/perf_event_intel.c |    4 +++
 arch/x86/kernel/cpu/perf_event_knc.c   |    2 +
 arch/x86/kernel/cpu/perf_event_p4.c    |    2 +
 arch/x86/kernel/cpu/perf_event_p6.c    |    2 +
 7 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 1025f3c..d02842d 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -525,6 +525,11 @@ static void x86_pmu_disable(struct pmu *pmu)
 	x86_pmu.disable_all();
 }
 
+static void x86_pmu__disable_irq(struct pmu *pmu, int irq)
+{
+	x86_pmu.disable_irq(irq);
+}
+
 void x86_pmu_enable_all(int added)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
@@ -540,6 +545,10 @@ void x86_pmu_enable_all(int added)
 	}
 }
 
+void x86_pmu_enable_irq_nop_int(int irq)
+{
+}
+
 static struct pmu pmu;
 
 static inline int is_x86_event(struct perf_event *event)
@@ -920,6 +929,11 @@ static void x86_pmu_enable(struct pmu *pmu)
 	x86_pmu.enable_all(added);
 }
 
+static void x86_pmu__enable_irq(struct pmu *pmu, int irq)
+{
+	x86_pmu.enable_irq(irq);
+}
+
 static DEFINE_PER_CPU(u64 [X86_PMC_IDX_MAX], pmc_prev_left);
 
 /*
@@ -1065,7 +1079,12 @@ static void x86_pmu_start(struct perf_event *event, int flags)
 	event->hw.state = 0;
 
 	cpuc->events[idx] = event;
-	__set_bit(idx, cpuc->active_mask);
+	if (is_interrupt_event(event)) {
+		__set_bit(idx, cpuc->actirq_mask);
+		perf_event_irq_add(event);
+	} else {
+		__set_bit(idx, cpuc->active_mask);
+	}
 	__set_bit(idx, cpuc->running);
 	x86_pmu.enable(event);
 	perf_event_update_userpage(event);
@@ -1102,6 +1121,7 @@ void perf_event_print_debug(void)
 		pr_info("CPU#%d: pebs:       %016llx\n", cpu, pebs);
 	}
 	pr_info("CPU#%d: active:     %016llx\n", cpu, *(u64 *)cpuc->active_mask);
+	pr_info("CPU#%d: actirq:     %016llx\n", cpu, *(u64 *)cpuc->actirq_mask);
 
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		rdmsrl(x86_pmu_config_addr(idx), pmc_ctrl);
@@ -1130,8 +1150,11 @@ void x86_pmu_stop(struct perf_event *event, int flags)
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 
-	if (__test_and_clear_bit(hwc->idx, cpuc->active_mask)) {
+	if (__test_and_clear_bit(hwc->idx, cpuc->active_mask) ||
+	    __test_and_clear_bit(hwc->idx, cpuc->actirq_mask)) {
 		x86_pmu.disable(event);
+		if (unlikely(is_interrupt_event(event)))
+			perf_event_irq_del(event);
 		cpuc->events[hwc->idx] = NULL;
 		WARN_ON_ONCE(hwc->state & PERF_HES_STOPPED);
 		hwc->state |= PERF_HES_STOPPED;
@@ -1199,7 +1222,8 @@ int x86_pmu_handle_irq(struct pt_regs *regs)
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
 
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
-		if (!test_bit(idx, cpuc->active_mask)) {
+		if (!test_bit(idx, cpuc->active_mask) &&
+		    !test_bit(idx, cpuc->actirq_mask)) {
 			/*
 			 * Though we deactivated the counter some cpus
 			 * might still deliver spurious interrupts still
@@ -1826,6 +1850,9 @@ static struct pmu pmu = {
 	.pmu_enable		= x86_pmu_enable,
 	.pmu_disable		= x86_pmu_disable,
 
+	.pmu_enable_irq		= x86_pmu__enable_irq,
+	.pmu_disable_irq	= x86_pmu__disable_irq,
+
 	.attr_groups		= x86_pmu_attr_groups,
 
 	.event_init		= x86_pmu_event_init,
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index ba9aadf..9dd59a9 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -125,6 +125,7 @@ struct cpu_hw_events {
 	 */
 	struct perf_event	*events[X86_PMC_IDX_MAX]; /* in counter order */
 	unsigned long		active_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+	unsigned long		actirq_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	unsigned long		running[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	int			enabled;
 
@@ -345,6 +346,8 @@ struct x86_pmu {
 	int		(*handle_irq)(struct pt_regs *);
 	void		(*disable_all)(void);
 	void		(*enable_all)(int added);
+	void		(*disable_irq)(int irq);
+	void		(*enable_irq)(int irq);
 	void		(*enable)(struct perf_event *);
 	void		(*disable)(struct perf_event *);
 	int		(*hw_config)(struct perf_event *event);
@@ -528,6 +531,8 @@ static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc,
 
 void x86_pmu_enable_all(int added);
 
+void x86_pmu_enable_irq_nop_int(int irq);
+
 int perf_assign_events(struct event_constraint **constraints, int n,
 			int wmin, int wmax, int *assign);
 int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign);
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 4cbe032..74f123a 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -622,6 +622,8 @@ static __initconst const struct x86_pmu amd_pmu = {
 	.handle_irq		= x86_pmu_handle_irq,
 	.disable_all		= x86_pmu_disable_all,
 	.enable_all		= x86_pmu_enable_all,
+	.disable_irq		= x86_pmu_enable_irq_nop_int,
+	.enable_irq		= x86_pmu_enable_irq_nop_int,
 	.enable			= x86_pmu_enable_event,
 	.disable		= x86_pmu_disable_event,
 	.hw_config		= amd_pmu_hw_config,
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index f60d41f..74f8652 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1676,6 +1676,8 @@ static __initconst const struct x86_pmu core_pmu = {
 	.handle_irq		= x86_pmu_handle_irq,
 	.disable_all		= x86_pmu_disable_all,
 	.enable_all		= core_pmu_enable_all,
+	.disable_irq		= x86_pmu_enable_irq_nop_int,
+	.enable_irq		= x86_pmu_enable_irq_nop_int,
 	.enable			= core_pmu_enable_event,
 	.disable		= x86_pmu_disable_event,
 	.hw_config		= x86_pmu_hw_config,
@@ -1818,6 +1820,8 @@ static __initconst const struct x86_pmu intel_pmu = {
 	.handle_irq		= intel_pmu_handle_irq,
 	.disable_all		= intel_pmu_disable_all,
 	.enable_all		= intel_pmu_enable_all,
+	.disable_irq		= x86_pmu_enable_irq_nop_int,
+	.enable_irq		= x86_pmu_enable_irq_nop_int,
 	.enable			= intel_pmu_enable_event,
 	.disable		= intel_pmu_disable_event,
 	.hw_config		= intel_pmu_hw_config,
diff --git a/arch/x86/kernel/cpu/perf_event_knc.c b/arch/x86/kernel/cpu/perf_event_knc.c
index 838fa87..a2bfc16 100644
--- a/arch/x86/kernel/cpu/perf_event_knc.c
+++ b/arch/x86/kernel/cpu/perf_event_knc.c
@@ -289,6 +289,8 @@ static const struct x86_pmu knc_pmu __initconst = {
 	.handle_irq		= knc_pmu_handle_irq,
 	.disable_all		= knc_pmu_disable_all,
 	.enable_all		= knc_pmu_enable_all,
+	.disable_irq		= x86_pmu_enable_irq_nop_int,
+	.enable_irq		= x86_pmu_enable_irq_nop_int,
 	.enable			= knc_pmu_enable_event,
 	.disable		= knc_pmu_disable_event,
 	.hw_config		= x86_pmu_hw_config,
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 3486e66..3665e48 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -1286,6 +1286,8 @@ static __initconst const struct x86_pmu p4_pmu = {
 	.handle_irq		= p4_pmu_handle_irq,
 	.disable_all		= p4_pmu_disable_all,
 	.enable_all		= p4_pmu_enable_all,
+	.disable_irq		= x86_pmu_enable_irq_nop_int,
+	.enable_irq		= x86_pmu_enable_irq_nop_int,
 	.enable			= p4_pmu_enable_event,
 	.disable		= p4_pmu_disable_event,
 	.eventsel		= MSR_P4_BPU_CCCR0,
diff --git a/arch/x86/kernel/cpu/perf_event_p6.c b/arch/x86/kernel/cpu/perf_event_p6.c
index b1e2fe1..7328dae 100644
--- a/arch/x86/kernel/cpu/perf_event_p6.c
+++ b/arch/x86/kernel/cpu/perf_event_p6.c
@@ -202,6 +202,8 @@ static __initconst const struct x86_pmu p6_pmu = {
 	.handle_irq		= x86_pmu_handle_irq,
 	.disable_all		= p6_pmu_disable_all,
 	.enable_all		= p6_pmu_enable_all,
+	.disable_irq		= x86_pmu_enable_irq_nop_int,
+	.enable_irq		= x86_pmu_enable_irq_nop_int,
 	.enable			= p6_pmu_enable_event,
 	.disable		= p6_pmu_disable_event,
 	.hw_config		= x86_pmu_hw_config,
-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
