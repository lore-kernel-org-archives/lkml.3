Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936195Ab3DIPYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 11:24:07 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:10384
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935378Ab3DIPYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 11:24:03 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(z551bizzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MKZURW-02-3UE-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        <x86@kernel.org>, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, <linux-kernel@vger.kernel.org>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH RESEND 1/3] perf, amd: Further generalize NB event constraints handling logic
Date: Tue, 9 Apr 2013 10:23:52 -0500
Message-ID: <1365521034-4496-2-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365521034-4496-1-git-send-email-jacob.shin@amd.com>
References: <1365521034-4496-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for enabling AMD L2I performance counters, we will
further generalize NB event constraints handling logic to now allow
any type of shared counters. This is just a code rework, there are
no functional changes.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 arch/x86/kernel/cpu/perf_event.h     |    6 +--
 arch/x86/kernel/cpu/perf_event_amd.c |   70 +++++++++++++++++-----------------
 2 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index ba9aadf..f092dfe 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -68,8 +68,8 @@ struct event_constraint {
 #define PERF_X86_EVENT_PEBS_LDLAT	0x1 /* ld+ldlat data address sampling */
 #define PERF_X86_EVENT_PEBS_ST		0x2 /* st data address sampling */
 
-struct amd_nb {
-	int nb_id;  /* NorthBridge id */
+struct amd_shared_regs {
+	int id;
 	int refcnt; /* reference count */
 	struct perf_event *owners[X86_PMC_IDX_MAX];
 	struct event_constraint event_constraints[X86_PMC_IDX_MAX];
@@ -170,7 +170,7 @@ struct cpu_hw_events {
 	/*
 	 * AMD specific bits
 	 */
-	struct amd_nb			*amd_nb;
+	struct amd_shared_regs		*amd_nb;
 	/* Inverted mask of bits to clear in the perf_ctr ctrl registers */
 	u64				perf_ctr_virt_mask;
 
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index dfdab42..23964a6 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -292,9 +292,9 @@ static inline int amd_is_perfctr_nb_event(struct hw_perf_event *hwc)
 
 static inline int amd_has_nb(struct cpu_hw_events *cpuc)
 {
-	struct amd_nb *nb = cpuc->amd_nb;
+	struct amd_shared_regs *nb = cpuc->amd_nb;
 
-	return nb && nb->nb_id != -1;
+	return nb && nb->id != -1;
 }
 
 static int amd_pmu_hw_config(struct perf_event *event)
@@ -321,10 +321,9 @@ static int amd_pmu_hw_config(struct perf_event *event)
 	return amd_core_hw_config(event);
 }
 
-static void __amd_put_nb_event_constraints(struct cpu_hw_events *cpuc,
-					   struct perf_event *event)
+static void amd_put_shared_event_constraints(struct amd_shared_regs *regs,
+					     struct perf_event *event)
 {
-	struct amd_nb *nb = cpuc->amd_nb;
 	int i;
 
 	/*
@@ -336,7 +335,7 @@ static void __amd_put_nb_event_constraints(struct cpu_hw_events *cpuc,
 	 * when we come here
 	 */
 	for (i = 0; i < x86_pmu.num_counters; i++) {
-		if (cmpxchg(nb->owners + i, event, NULL) == event)
+		if (cmpxchg(regs->owners + i, event, NULL) == event)
 			break;
 	}
 }
@@ -386,16 +385,17 @@ static void amd_nb_interrupt_hw_config(struct hw_perf_event *hwc)
   *
   * Given that resources are allocated (cmpxchg), they must be
   * eventually freed for others to use. This is accomplished by
-  * calling __amd_put_nb_event_constraints()
+  * calling amd_put_shared_event_constraints()
   *
   * Non NB events are not impacted by this restriction.
   */
 static struct event_constraint *
-__amd_get_nb_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event,
-			       struct event_constraint *c)
+amd_get_shared_event_constraints(struct cpu_hw_events *cpuc,
+				 struct amd_shared_regs *regs,
+				 struct perf_event *event,
+				 struct event_constraint *c)
 {
 	struct hw_perf_event *hwc = &event->hw;
-	struct amd_nb *nb = cpuc->amd_nb;
 	struct perf_event *old;
 	int idx, new = -1;
 
@@ -418,8 +418,8 @@ __amd_get_nb_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *ev
 	for_each_set_bit(idx, c->idxmsk, x86_pmu.num_counters) {
 		if (new == -1 || hwc->idx == idx)
 			/* assign free slot, prefer hwc->idx */
-			old = cmpxchg(nb->owners + idx, NULL, event);
-		else if (nb->owners[idx] == event)
+			old = cmpxchg(regs->owners + idx, NULL, event);
+		else if (regs->owners[idx] == event)
 			/* event already present */
 			old = event;
 		else
@@ -430,7 +430,7 @@ __amd_get_nb_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *ev
 
 		/* reassign to this slot */
 		if (new != -1)
-			cmpxchg(nb->owners + new, event, NULL);
+			cmpxchg(regs->owners + new, event, NULL);
 		new = idx;
 
 		/* already present, reuse */
@@ -444,29 +444,29 @@ __amd_get_nb_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *ev
 	if (amd_is_perfctr_nb_event(hwc))
 		amd_nb_interrupt_hw_config(hwc);
 
-	return &nb->event_constraints[new];
+	return &regs->event_constraints[new];
 }
 
-static struct amd_nb *amd_alloc_nb(int cpu)
+static struct amd_shared_regs *amd_alloc_shared_regs(int cpu)
 {
-	struct amd_nb *nb;
+	struct amd_shared_regs *regs;
 	int i;
 
-	nb = kmalloc_node(sizeof(struct amd_nb), GFP_KERNEL | __GFP_ZERO,
-			  cpu_to_node(cpu));
-	if (!nb)
+	regs = kmalloc_node(sizeof(struct amd_shared_regs),
+			    GFP_KERNEL | __GFP_ZERO, cpu_to_node(cpu));
+	if (!regs)
 		return NULL;
 
-	nb->nb_id = -1;
+	regs->id = -1;
 
 	/*
-	 * initialize all possible NB constraints
+	 * initialize all possible constraints
 	 */
 	for (i = 0; i < x86_pmu.num_counters; i++) {
-		__set_bit(i, nb->event_constraints[i].idxmsk);
-		nb->event_constraints[i].weight = 1;
+		__set_bit(i, regs->event_constraints[i].idxmsk);
+		regs->event_constraints[i].weight = 1;
 	}
-	return nb;
+	return regs;
 }
 
 static int amd_pmu_cpu_prepare(int cpu)
@@ -478,7 +478,7 @@ static int amd_pmu_cpu_prepare(int cpu)
 	if (boot_cpu_data.x86_max_cores < 2)
 		return NOTIFY_OK;
 
-	cpuc->amd_nb = amd_alloc_nb(cpu);
+	cpuc->amd_nb = amd_alloc_shared_regs(cpu);
 	if (!cpuc->amd_nb)
 		return NOTIFY_BAD;
 
@@ -488,7 +488,7 @@ static int amd_pmu_cpu_prepare(int cpu)
 static void amd_pmu_cpu_starting(int cpu)
 {
 	struct cpu_hw_events *cpuc = &per_cpu(cpu_hw_events, cpu);
-	struct amd_nb *nb;
+	struct amd_shared_regs *nb;
 	int i, nb_id;
 
 	cpuc->perf_ctr_virt_mask = AMD64_EVENTSEL_HOSTONLY;
@@ -504,14 +504,14 @@ static void amd_pmu_cpu_starting(int cpu)
 		if (WARN_ON_ONCE(!nb))
 			continue;
 
-		if (nb->nb_id == nb_id) {
+		if (nb->id == nb_id) {
 			cpuc->kfree_on_online = cpuc->amd_nb;
 			cpuc->amd_nb = nb;
 			break;
 		}
 	}
 
-	cpuc->amd_nb->nb_id = nb_id;
+	cpuc->amd_nb->id = nb_id;
 	cpuc->amd_nb->refcnt++;
 }
 
@@ -525,9 +525,9 @@ static void amd_pmu_cpu_dead(int cpu)
 	cpuhw = &per_cpu(cpu_hw_events, cpu);
 
 	if (cpuhw->amd_nb) {
-		struct amd_nb *nb = cpuhw->amd_nb;
+		struct amd_shared_regs *nb = cpuhw->amd_nb;
 
-		if (nb->nb_id == -1 || --nb->refcnt == 0)
+		if (nb->id == -1 || --nb->refcnt == 0)
 			kfree(nb);
 
 		cpuhw->amd_nb = NULL;
@@ -543,15 +543,15 @@ amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 	if (!(amd_has_nb(cpuc) && amd_is_nb_event(&event->hw)))
 		return &unconstrained;
 
-	return __amd_get_nb_event_constraints(cpuc, event,
-					      amd_nb_event_constraint);
+	return amd_get_shared_event_constraints(cpuc, cpuc->amd_nb, event,
+						amd_nb_event_constraint);
 }
 
 static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
 				      struct perf_event *event)
 {
 	if (amd_has_nb(cpuc) && amd_is_nb_event(&event->hw))
-		__amd_put_nb_event_constraints(cpuc, event);
+		amd_put_shared_event_constraints(cpuc->amd_nb, event);
 }
 
 PMU_FORMAT_ATTR(event,	"config:0-7,32-35");
@@ -711,8 +711,8 @@ amd_get_event_constraints_f15h(struct cpu_hw_events *cpuc, struct perf_event *ev
 			return &amd_f15_PMC20;
 		}
 	case AMD_EVENT_NB:
-		return __amd_get_nb_event_constraints(cpuc, event,
-						      amd_nb_event_constraint);
+		return amd_get_shared_event_constraints(cpuc, cpuc->amd_nb,
+				event, amd_nb_event_constraint);
 	default:
 		return &emptyconstraint;
 	}
-- 
1.7.9.5


