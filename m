Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbaKQTME (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 14:12:04 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45105 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbaKQTIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 14:08:16 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        kan.liang@intel.com, bp@alien8.de, maria.n.dimakopoulou@gmail.com
Subject: [PATCH v3 05/13] perf/x86: add cross-HT counter exclusion infrastructure
Date: Mon, 17 Nov 2014 20:06:57 +0100
Message-Id: <1416251225-17721-6-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416251225-17721-1-git-send-email-eranian@google.com>
References: <1416251225-17721-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>

This patch adds a new shared_regs style structure to the
per-cpu x86 state (cpuc). It is used to coordinate access
between counters which must be used with exclusion across
HyperThreads on Intel processors. This new struct is not
needed on each PMU, thus is is allocated on demand.

Reviewed-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
---
 arch/x86/kernel/cpu/perf_event.h       | 32 +++++++++++++++
 arch/x86/kernel/cpu/perf_event_intel.c | 71 +++++++++++++++++++++++++++++++---
 2 files changed, 98 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 141c17c..b7ab4c8 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -71,6 +71,7 @@ struct event_constraint {
 #define PERF_X86_EVENT_COMMITTED	0x8 /* event passed commit_txn */
 #define PERF_X86_EVENT_PEBS_LD_HSW	0x10 /* haswell style datala, load */
 #define PERF_X86_EVENT_PEBS_NA_HSW	0x20 /* haswell style datala, unknown */
+#define PERF_X86_EVENT_EXCL		0x40 /* HT exclusivity on counter */
 
 struct amd_nb {
 	int nb_id;  /* NorthBridge id */
@@ -121,6 +122,26 @@ struct intel_shared_regs {
 	unsigned                core_id;	/* per-core: core id */
 };
 
+enum intel_excl_state_type {
+	INTEL_EXCL_UNUSED    = 0, /* counter is unused */
+	INTEL_EXCL_SHARED    = 1, /* counter can be used by both threads */
+	INTEL_EXCL_EXCLUSIVE = 2, /* counter can be used by one thread only */
+};
+
+struct intel_excl_states {
+	enum intel_excl_state_type init_state[X86_PMC_IDX_MAX];
+	enum intel_excl_state_type state[X86_PMC_IDX_MAX];
+};
+
+struct intel_excl_cntrs {
+	spinlock_t	lock;
+
+	struct intel_excl_states states[2];
+
+	int		refcnt;		/* per-core: #HT threads */
+	unsigned	core_id;	/* per-core: core id */
+};
+
 #define MAX_LBR_ENTRIES		16
 
 enum {
@@ -183,6 +204,12 @@ struct cpu_hw_events {
 	 * used on Intel NHM/WSM/SNB
 	 */
 	struct intel_shared_regs	*shared_regs;
+	/*
+	 * manage exclusive counter access between hyperthread
+	 */
+	struct event_constraint *constraint_list; /* in enable order */
+	struct intel_excl_cntrs		*excl_cntrs;
+	int excl_thread_id; /* 0 or 1 */
 
 	/*
 	 * AMD specific bits
@@ -206,6 +233,10 @@ struct cpu_hw_events {
 #define EVENT_CONSTRAINT(c, n, m)	\
 	__EVENT_CONSTRAINT(c, n, m, HWEIGHT(n), 0, 0)
 
+#define INTEL_EXCLEVT_CONSTRAINT(c, n)	\
+	__EVENT_CONSTRAINT(c, n, ARCH_PERFMON_EVENTSEL_EVENT, HWEIGHT(n),\
+			   0, PERF_X86_EVENT_EXCL)
+
 /*
  * The overlap flag marks event constraints with overlapping counter
  * masks. This is the case if the counter mask of such an event is not
@@ -543,6 +574,7 @@ do {									\
  */
 #define PMU_FL_NO_HT_SHARING	0x1 /* no hyper-threading resource sharing */
 #define PMU_FL_HAS_RSP_1	0x2 /* has 2 equivalent offcore_rsp regs   */
+#define PMU_FL_EXCL_CNTRS	0x4 /* has exclusive counter requirements  */
 
 #define EVENT_VAR(_id)  event_attr_##_id
 #define EVENT_PTR(_id) &event_attr_##_id.attr.attr
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 9b60b17..eb1d938 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1984,16 +1984,52 @@ struct intel_shared_regs *allocate_shared_regs(int cpu)
 	return regs;
 }
 
+struct intel_excl_cntrs *allocate_excl_cntrs(int cpu)
+{
+	struct intel_excl_cntrs *c;
+	int i;
+
+	c = kzalloc_node(sizeof(struct intel_excl_cntrs),
+			 GFP_KERNEL, cpu_to_node(cpu));
+	if (c) {
+		spin_lock_init(&c->lock);
+		for (i = 0; i < X86_PMC_IDX_MAX; i++) {
+			c->states[0].state[i] = INTEL_EXCL_UNUSED;
+			c->states[0].init_state[i] = INTEL_EXCL_UNUSED;
+
+			c->states[1].state[i] = INTEL_EXCL_UNUSED;
+			c->states[1].init_state[i] = INTEL_EXCL_UNUSED;
+		}
+		c->core_id = -1;
+	}
+	return c;
+}
+
 static int intel_pmu_cpu_prepare(int cpu)
 {
 	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
 
-	if (!(x86_pmu.extra_regs || x86_pmu.lbr_sel_map))
-		return NOTIFY_OK;
+	if (x86_pmu.extra_regs || x86_pmu.lbr_sel_map) {
+		cpuc->shared_regs = allocate_shared_regs(cpu);
+		if (!cpuc->shared_regs)
+			return NOTIFY_BAD;
+	}
 
-	cpuc->shared_regs = allocate_shared_regs(cpu);
-	if (!cpuc->shared_regs)
-		return NOTIFY_BAD;
+	if (x86_pmu.flags & PMU_FL_EXCL_CNTRS) {
+		size_t sz = X86_PMC_IDX_MAX * sizeof(struct event_constraint);
+
+		cpuc->constraint_list = kzalloc(sz, GFP_KERNEL);
+		if (!cpuc->constraint_list)
+			return NOTIFY_BAD;
+
+		cpuc->excl_cntrs = allocate_excl_cntrs(cpu);
+		if (!cpuc->excl_cntrs) {
+			kfree(cpuc->constraint_list);
+			kfree(cpuc->shared_regs);
+			return NOTIFY_BAD;
+		}
+		cpuc->excl_thread_id = 0;
+	}
 
 	return NOTIFY_OK;
 }
@@ -2034,12 +2070,29 @@ static void intel_pmu_cpu_starting(int cpu)
 
 	if (x86_pmu.lbr_sel_map)
 		cpuc->lbr_sel = &cpuc->shared_regs->regs[EXTRA_REG_LBR];
+
+	if (x86_pmu.flags & PMU_FL_EXCL_CNTRS) {
+		for_each_cpu(i, topology_thread_cpumask(cpu)) {
+			struct intel_excl_cntrs *c;
+
+			c = per_cpu(cpu_hw_events, i).excl_cntrs;
+			if (c && c->core_id == core_id) {
+				cpuc->kfree_on_online[1] = cpuc->excl_cntrs;
+				cpuc->excl_cntrs = c;
+				cpuc->excl_thread_id = 1;
+				break;
+			}
+		}
+		cpuc->excl_cntrs->core_id = core_id;
+		cpuc->excl_cntrs->refcnt++;
+	}
 }
 
 static void intel_pmu_cpu_dying(int cpu)
 {
 	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
 	struct intel_shared_regs *pc;
+	struct intel_excl_cntrs *c;
 
 	pc = cpuc->shared_regs;
 	if (pc) {
@@ -2047,6 +2100,14 @@ static void intel_pmu_cpu_dying(int cpu)
 			kfree(pc);
 		cpuc->shared_regs = NULL;
 	}
+	c = cpuc->excl_cntrs;
+	if (c) {
+		if (c->core_id == -1 || --c->refcnt == 0)
+			kfree(c);
+		cpuc->excl_cntrs = NULL;
+		kfree(cpuc->constraint_list);
+		cpuc->constraint_list = NULL;
+	}
 
 	fini_debug_store_on_cpu(cpu);
 }
-- 
1.9.1

