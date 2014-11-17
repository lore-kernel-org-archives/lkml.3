Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbaKQTJ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 14:09:27 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:47126 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbaKQTIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 14:08:38 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        kan.liang@intel.com, bp@alien8.de, maria.n.dimakopoulou@gmail.com
Subject: [PATCH v3 12/13] perf/x86: make HT bug workaround conditioned on HT enabled
Date: Mon, 17 Nov 2014 20:07:04 +0100
Message-Id: <1416251225-17721-13-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416251225-17721-1-git-send-email-eranian@google.com>
References: <1416251225-17721-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch disables the PMU HT bug when Hyperthreading (HT)
is disabled. We cannot do this test immediately when perf_events
is initialized. We need to wait until the topology information
is setup properly. As such, we register a later initcall, check
the topology and potentially disable the workaround. To do this,
we need to ensure there is no user of the PMU. At this point of
the boot, the only user is the NMI watchdog, thus we disable
it during the switch and re-enable right after.

Having the workaround disabled when it is not needed provides
some benefits by limiting the overhead is time and space.
The workaround still ensures correct scheduling of the corrupting
memory events (0xd0, 0xd1, 0xd2) when HT is off. Those events
can only be measured on counters 0-3. Something else the current
kernel did not handle correctly.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event.h       |  5 ++
 arch/x86/kernel/cpu/perf_event_intel.c | 95 ++++++++++++++++++++++++++--------
 2 files changed, 79 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index d6b0337..41f8169 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -601,6 +601,7 @@ do {									\
 #define PMU_FL_NO_HT_SHARING	0x1 /* no hyper-threading resource sharing */
 #define PMU_FL_HAS_RSP_1	0x2 /* has 2 equivalent offcore_rsp regs   */
 #define PMU_FL_EXCL_CNTRS	0x4 /* has exclusive counter requirements  */
+#define PMU_FL_EXCL_ENABLED	0x8 /* exclusive counter active */
 
 #define EVENT_VAR(_id)  event_attr_##_id
 #define EVENT_PTR(_id) &event_attr_##_id.attr.attr
@@ -834,6 +835,10 @@ int knc_pmu_init(void);
 ssize_t events_sysfs_show(struct device *dev, struct device_attribute *attr,
 			  char *page);
 
+static inline int is_ht_workaround_enabled(void)
+{
+	return !!(x86_pmu.flags & PMU_FL_EXCL_ENABLED);
+}
 #else /* CONFIG_CPU_SUP_INTEL */
 
 static inline void reserve_ds_buffers(void)
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 099dc8e..6443f02 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -12,6 +12,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/export.h>
+#include <linux/watchdog.h>
 
 #include <asm/cpufeature.h>
 #include <asm/hardirq.h>
@@ -1682,8 +1683,9 @@ intel_start_scheduling(struct cpu_hw_events *cpuc)
 	/*
 	 * nothing needed if in group validation mode
 	 */
-	if (cpuc->is_fake)
+	if (cpuc->is_fake || !is_ht_workaround_enabled())
 		return;
+
 	/*
 	 * no exclusion needed
 	 */
@@ -1720,7 +1722,7 @@ intel_stop_scheduling(struct cpu_hw_events *cpuc)
 	/*
 	 * nothing needed if in group validation mode
 	 */
-	if (cpuc->is_fake)
+	if (cpuc->is_fake || !is_ht_workaround_enabled())
 		return;
 	/*
 	 * no exclusion needed
@@ -1758,7 +1760,13 @@ intel_get_excl_constraints(struct cpu_hw_events *cpuc, struct perf_event *event,
 	 * validating a group does not require
 	 * enforcing cross-thread  exclusion
 	 */
-	if (cpuc->is_fake)
+	if (cpuc->is_fake || !is_ht_workaround_enabled())
+		return c;
+
+	/*
+	 * no exclusion needed
+	 */
+	if (!excl_cntrs)
 		return c;
 	/*
 	 * event requires exclusive counter access
@@ -2418,18 +2426,11 @@ static void intel_pmu_cpu_starting(int cpu)
 	}
 }
 
-static void intel_pmu_cpu_dying(int cpu)
+static void free_excl_cntrs(int cpu)
 {
 	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
-	struct intel_shared_regs *pc;
 	struct intel_excl_cntrs *c;
 
-	pc = cpuc->shared_regs;
-	if (pc) {
-		if (pc->core_id == -1 || --pc->refcnt == 0)
-			kfree(pc);
-		cpuc->shared_regs = NULL;
-	}
 	c = cpuc->excl_cntrs;
 	if (c) {
 		if (c->core_id == -1 || --c->refcnt == 0)
@@ -2438,14 +2439,22 @@ static void intel_pmu_cpu_dying(int cpu)
 		kfree(cpuc->constraint_list);
 		cpuc->constraint_list = NULL;
 	}
+}
 
-	c = cpuc->excl_cntrs;
-	if (c) {
-		if (c->core_id == -1 || --c->refcnt == 0)
-			kfree(c);
-		cpuc->excl_cntrs = NULL;
+static void intel_pmu_cpu_dying(int cpu)
+{
+	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
+	struct intel_shared_regs *pc;
+
+	pc = cpuc->shared_regs;
+	if (pc) {
+		if (pc->core_id == -1 || --pc->refcnt == 0)
+			kfree(pc);
+		cpuc->shared_regs = NULL;
 	}
 
+	free_excl_cntrs(cpu);
+
 	fini_debug_store_on_cpu(cpu);
 }
 
@@ -2676,18 +2685,18 @@ static __init void intel_nehalem_quirk(void)
  * HSW: HSD29
  *
  * Only needed when HT is enabled. However detecting
- * this is too difficult and model specific so we enable
- * it even with HT off for now.
+ * if HT is enabled is difficult (model specific). So instead,
+ * we enable the workaround in the early boot, and verify if
+ * it is needed in a later initcall phase once we have valid
+ * topology information to check if HT is actually enabled
  */
 static __init void intel_ht_bug(void)
 {
-	x86_pmu.flags |= PMU_FL_EXCL_CNTRS;
+	x86_pmu.flags |= PMU_FL_EXCL_CNTRS | PMU_FL_EXCL_ENABLED;
 
 	x86_pmu.commit_scheduling = intel_commit_scheduling;
 	x86_pmu.start_scheduling = intel_start_scheduling;
 	x86_pmu.stop_scheduling = intel_stop_scheduling;
-
-	pr_info("CPU erratum BJ122, BV98, HSD29 worked around\n");
 }
 
 EVENT_ATTR_STR(mem-loads,	mem_ld_hsw,	"event=0xcd,umask=0x1,ldlat=3");
@@ -3081,3 +3090,47 @@ __init int intel_pmu_init(void)
 
 	return 0;
 }
+
+/*
+ * HT bug: phase 2 init
+ * Called once we have valid topology information to check
+ * whether or not HT is enabled
+ * If HT is off, then we disable the workaround
+ */
+static __init int fixup_ht_bug(void)
+{
+	int cpu = smp_processor_id();
+	int w, c;
+	/*
+	 * problem not present on this CPU model, nothing to do
+	 */
+	if (!(x86_pmu.flags & PMU_FL_EXCL_ENABLED))
+		return 0;
+
+	w = cpumask_weight(topology_thread_cpumask(cpu));
+	if (w > 1) {
+		pr_info("PMU erratum BJ122, BV98, HSD29 worked around, HT is on\n");
+		return 0;
+	}
+
+	watchdog_nmi_disable_all();
+
+	x86_pmu.flags &= ~(PMU_FL_EXCL_CNTRS | PMU_FL_EXCL_ENABLED);
+
+	x86_pmu.commit_scheduling = NULL;
+	x86_pmu.start_scheduling = NULL;
+	x86_pmu.stop_scheduling = NULL;
+
+	watchdog_nmi_enable_all();
+
+	get_online_cpus();
+
+	for_each_online_cpu(c) {
+		free_excl_cntrs(c);
+	}
+
+	put_online_cpus();
+	pr_info("PMU erratum BJ122, BV98, HSD29 workaround disabled, HT off\n");
+	return 0;
+}
+subsys_initcall(fixup_ht_bug)
-- 
1.9.1

