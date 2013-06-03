Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab3FCJl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 05:41:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756646Ab3FCJlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 05:41:15 -0400
Date: Mon, 3 Jun 2013 11:42:15 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH RFC -tip 3/6] perf/x86/AMD PMU: IRQ-bound performance events
Message-ID: <20130603094214.GE30878@dhcp-26-207.brq.redhat.com>
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
 arch/x86/kernel/cpu/perf_event.c     |   38 ++++++++++++++++++++++++++++-----
 arch/x86/kernel/cpu/perf_event.h     |   14 ++++++++++++
 arch/x86/kernel/cpu/perf_event_amd.c |    4 +-
 3 files changed, 48 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index d02842d..9debf09 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -496,15 +496,23 @@ void x86_pmu_disable_all(void)
 	int idx;
 
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
-		u64 val;
-
 		if (!test_bit(idx, cpuc->active_mask))
 			continue;
-		rdmsrl(x86_pmu_config_addr(idx), val);
-		if (!(val & ARCH_PERFMON_EVENTSEL_ENABLE))
+		__x86_pmu_disable_event(idx, ARCH_PERFMON_EVENTSEL_ENABLE);
+	}
+}
+
+void x86_pmu_disable_irq(int irq)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	int idx;
+
+	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
+		if (!test_bit(idx, cpuc->actirq_mask))
+			continue;
+		if (cpuc->events[idx]->irq != irq)
 			continue;
-		val &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
-		wrmsrl(x86_pmu_config_addr(idx), val);
+		__x86_pmu_disable_event(idx, ARCH_PERFMON_EVENTSEL_ENABLE);
 	}
 }
 
@@ -549,6 +557,24 @@ void x86_pmu_enable_irq_nop_int(int irq)
 {
 }
 
+void x86_pmu_enable_irq(int irq)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	int idx;
+
+	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
+		struct perf_event *event = cpuc->events[idx];
+
+		if (!test_bit(idx, cpuc->actirq_mask))
+			continue;
+		if (event->irq != irq)
+			continue;
+
+		__x86_pmu_enable_event(&event->hw,
+				       ARCH_PERFMON_EVENTSEL_ENABLE);
+	}
+}
+
 static struct pmu pmu;
 
 static inline int is_x86_event(struct perf_event *event)
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 9dd59a9..8921686 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -519,6 +519,19 @@ int x86_pmu_hw_config(struct perf_event *event);
 
 void x86_pmu_disable_all(void);
 
+void x86_pmu_disable_irq(int irq);
+
+static void inline __x86_pmu_disable_event(int idx, u64 enable_mask)
+{
+	u64 val;
+
+	rdmsrl(x86_pmu_config_addr(idx), val);
+	if (val & enable_mask) {
+		val &= ~enable_mask;
+		wrmsrl(x86_pmu_config_addr(idx), val);
+	}
+}
+
 static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc,
 					  u64 enable_mask)
 {
@@ -531,6 +544,7 @@ static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc,
 
 void x86_pmu_enable_all(int added);
 
+void x86_pmu_enable_irq(int irq);
 void x86_pmu_enable_irq_nop_int(int irq);
 
 int perf_assign_events(struct event_constraint **constraints, int n,
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 74f123a..c7381f1 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -622,8 +622,8 @@ static __initconst const struct x86_pmu amd_pmu = {
 	.handle_irq		= x86_pmu_handle_irq,
 	.disable_all		= x86_pmu_disable_all,
 	.enable_all		= x86_pmu_enable_all,
-	.disable_irq		= x86_pmu_enable_irq_nop_int,
-	.enable_irq		= x86_pmu_enable_irq_nop_int,
+	.disable_irq		= x86_pmu_disable_irq,
+	.enable_irq		= x86_pmu_enable_irq,
 	.enable			= x86_pmu_enable_event,
 	.disable		= x86_pmu_disable_event,
 	.hw_config		= amd_pmu_hw_config,
-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
