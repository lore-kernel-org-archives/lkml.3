Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbaFDVoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 17:44:16 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:49792 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbaFDVoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 17:44:13 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        zheng.z.yan@intel.com, maria.n.dimakopoulou@gmail.com
Subject: [PATCH 5/9] perf/x86: implement cross-HT corruption bug workaround
Date: Wed,  4 Jun 2014 23:34:14 +0200
Message-Id: <1401917658-26065-6-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401917658-26065-1-git-send-email-eranian@google.com>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>

This patch implements a software workaround for a HW erratum
on Intel SandyBridge, IvyBridge and Haswell processors
with Hyperthreading enabled. The errata are documented for
each processor in their respective specification update
documents:
 - SandyBridge: BJ122
 - IvyBridge: BV98
 - Haswell: HSD29

The bug causes silent counter corruption across hyperthreads only
when measuring certain memory events (0xd0, 0xd1, 0xd2, 0xd3).
Counters measuring those events may leak counts to the sibling
counter. For instance, counter 0, thread 0 measuring event 0xd0,
may leak to counter 0, thread 1, regardless of the event measured
there. The size of the leak is not predictible. It all depends on
the workload and the state of each sibling hyper-thread. The
corrupting events do undercount as a consequence of the leak. The
leak is compensated automatically only when the sibling counter measures
the exact same corrupting event AND the workload is on the two threads
is the same. Given, there is no way to guarantee this, a work-around
is necessary. Furthermore, there is a serious problem if the leaked count
is added to a low-occurrence event. In that case the corruption on
the low occurrence event can be very large, e.g., orders of magnitude.

There is no HW or FW workaround for this problem.

The bug is very easy to reproduce on a loaded system.
Here is an example on a Haswell client, where CPU0, CPU4
are siblings. We load the CPUs with a simple triad app
streaming large floating-point vector. We use 0x81d0
corrupting event (MEM_UOPS_RETIRED:ALL_LOADS) and
0x20cc (ROB_MISC_EVENTS:LBR_INSERTS). Given we are not
using the LBR, the 0x20cc event should be zero.

 $ taskset -c 0 triad &
 $ taskset -c 4 triad &
 $ perf stat -a -C 0 -e r81d0 sleep 100 &
 $ perf stat -a -C 4 -r20cc sleep 10
 Performance counter stats for 'system wide':
       139 277 291      r20cc
      10,000969126 seconds time elapsed

In this example, 0x81d0 and r20cc ar eusing sinling counters
on CPU0 and CPU4. 0x81d0 leaks into 0x20cc and corrupts it
from 0 to 139 millions occurrences.

This patch provides a software workaround to this problem by modifying the
way events are scheduled onto counters by the kernel. The patch forces
cross-thread mutual exclusion between counters in case a corrupting event
is measured by one of the hyper-threads. If thread 0, counter 0 is measuring
event 0xd0, then nothing can be measured on counter 0, thread 1. If no corrupting
event is measured on any hyper-thread, event scheduling proceeds as before.

The same example run with the workaround enabled, yield the correct answer:
 $ taskset -c 0 triad &
 $ taskset -c 4 triad &
 $ perf stat -a -C 0 -e r81d0 sleep 100 &
 $ perf stat -a -C 4 -r20cc sleep 10
 Performance counter stats for 'system wide':
       0 r20cc
      10,000969126 seconds time elapsed

The patch does provide correctness for all non-corrupting events. It does not
"repatriate" the leaked counts back to the leaking counter. This is planned
for a second patch series. This patch series makes this repatriation more
easy by guaranteeing the sibling counter is not measuring any useful event.

The patch introduces dynamic constraints for events. That means that events which
did not have constraints, i.e., could be measured on any counters, may now be
constrained to a subset of the counters depending on what is going on the sibling
thread. The algorithm is similar to a cache coherency protocol. We call it XSU
in reference to Exclusive, Shared, Unused, the 3 possible states of a PMU
counter.

As a consequence of the workaround, users may see an increased amount of event
multiplexing, even in situtations where there are fewer events than counters
measured on a CPU.

Patch has been tested on all three impacted processors. Note that when
HT is off, there is no corruption. However, the workaround is still enabled,
yet not costing too much. Adding a dynamic detection of HT on turned out to
be complex are requiring too much to code to be justified.

This patch addresses the issue when PEBS is not used. A subsequent patch
fixes the problem when PEBS is used.

Reviewed-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
---
 arch/x86/kernel/cpu/perf_event.c       |   31 ++--
 arch/x86/kernel/cpu/perf_event.h       |    6 +
 arch/x86/kernel/cpu/perf_event_intel.c |  311 +++++++++++++++++++++++++++++++-
 3 files changed, 335 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 858a72a..314458a 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -728,7 +728,7 @@ int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 	struct event_constraint *c;
 	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	struct perf_event *e;
-	int i, wmin, wmax, num = 0;
+	int i, wmin, wmax, unsched = 0;
 	struct hw_perf_event *hwc;
 
 	bitmap_zero(used_mask, X86_PMC_IDX_MAX);
@@ -771,14 +771,20 @@ int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 
 	/* slow path */
 	if (i != n)
-		num = perf_assign_events(cpuc->event_list, n, wmin,
-					 wmax, assign);
+		unsched = perf_assign_events(cpuc->event_list, n, wmin,
+					     wmax, assign);
 
 	/*
-	 * Mark the event as committed, so we do not put_constraint()
-	 * in case new events are added and fail scheduling.
+	 * In case of success (unsched = 0), mark events as committed,
+	 * so we do not put_constraint() in case new events are added
+	 * and fail to be scheduled
+	 *
+	 * We invoke the lower level commit callback to lock the resource
+	 *
+	 * We do not need to do all of this in case we are called to
+	 * validate an event group (assign == NULL)
 	 */
-	if (!num && assign) {
+	if (!unsched && assign) {
 		for (i = 0; i < n; i++) {
 			e = cpuc->event_list[i];
 			e->hw.flags |= PERF_X86_EVENT_COMMITTED;
@@ -786,11 +792,9 @@ int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 				x86_pmu.commit_scheduling(cpuc, e, assign[i]);
 		}
 	}
-	/*
-	 * scheduling failed or is just a simulation,
-	 * free resources if necessary
-	 */
-	if (!assign || num) {
+
+	if (!assign || unsched) {
+
 		for (i = 0; i < n; i++) {
 			e = cpuc->event_list[i];
 			/*
@@ -800,6 +804,9 @@ int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 			if ((e->hw.flags & PERF_X86_EVENT_COMMITTED))
 				continue;
 
+			/*
+			 * release events that failed scheduling
+			 */
 			if (x86_pmu.put_event_constraints)
 				x86_pmu.put_event_constraints(cpuc, e);
 		}
@@ -808,7 +815,7 @@ int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 	if (x86_pmu.stop_scheduling)
 		x86_pmu.stop_scheduling(cpuc);
 
-	return num ? -EINVAL : 0;
+	return unsched ? -EINVAL : 0;
 }
 
 /*
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 5da0a2b..c61ca4a 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -70,6 +70,7 @@ struct event_constraint {
 #define PERF_X86_EVENT_PEBS_ST_HSW	0x04 /* haswell style st data sampling */
 #define PERF_X86_EVENT_COMMITTED	0x08 /* event passed commit_txn */
 #define PERF_X86_EVENT_EXCL		0x10 /* HT exclusivity on counter */
+#define PERF_X86_EVENT_DYNAMIC		0x20 /* dynamic alloc'd constraint */
 
 struct amd_nb {
 	int nb_id;  /* NorthBridge id */
@@ -129,6 +130,7 @@ enum intel_excl_state_type {
 struct intel_excl_states {
 	enum intel_excl_state_type init_state[X86_PMC_IDX_MAX];
 	enum intel_excl_state_type state[X86_PMC_IDX_MAX];
+	bool sched_started; /* true if scheduling has started */
 };
 
 struct intel_excl_cntrs {
@@ -288,6 +290,10 @@ struct cpu_hw_events {
 #define INTEL_UEVENT_CONSTRAINT(c, n)	\
 	EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK)
 
+#define INTEL_EXCLUEVT_CONSTRAINT(c, n)	\
+	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK, \
+			   HWEIGHT(n), 0, PERF_X86_EVENT_EXCL)
+
 #define INTEL_PLD_CONSTRAINT(c, n)	\
 	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK, \
 			   HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_LDLAT)
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 380fce2..3af9745 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1632,7 +1632,7 @@ x86_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 }
 
 static struct event_constraint *
-intel_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
+__intel_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 {
 	struct event_constraint *c;
 
@@ -1652,6 +1652,256 @@ intel_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event
 }
 
 static void
+intel_start_scheduling(struct cpu_hw_events *cpuc)
+{
+	struct intel_excl_cntrs *excl_cntrs = cpuc->excl_cntrs;
+	struct intel_excl_states *xl, *xlo;
+	int tid = cpuc->excl_thread_id;
+	int o_tid = 1 - tid; /* sibling thread */
+
+	/*
+	 * nothing needed if in group validation mode
+	 */
+	if (cpuc->is_fake)
+		return;
+	/*
+	 * no exclusion needed
+	 */
+	if (!excl_cntrs)
+		return;
+
+	xlo = &excl_cntrs->states[o_tid];
+	xl = &excl_cntrs->states[tid];
+
+	xl->sched_started = true;
+
+	/*
+	 * lock shared state until we are done scheduling
+	 * in stop_event_scheduling()
+	 * makes scheduling appear as a transaction
+	 */
+	spin_lock_irqsave(&excl_cntrs->lock, excl_cntrs->lock_flags);
+
+	/*
+	 * save initial state of sibling thread
+	 */
+	memcpy(xlo->init_state, xlo->state, sizeof(xlo->init_state));
+}
+
+static void
+intel_stop_scheduling(struct cpu_hw_events *cpuc)
+{
+	struct intel_excl_cntrs *excl_cntrs = cpuc->excl_cntrs;
+	struct intel_excl_states *xl, *xlo;
+	int tid = cpuc->excl_thread_id;
+	int o_tid = 1 - tid; /* sibling thread */
+	int i;
+
+	/*
+	 * nothing needed if in group validation mode
+	 */
+	if (cpuc->is_fake)
+		return;
+	/*
+	 * no exclusion needed
+	 */
+	if (!excl_cntrs)
+		return;
+
+	xlo = &excl_cntrs->states[o_tid];
+	xl = &excl_cntrs->states[tid];
+
+	/*
+	 * make new sibling thread state visible
+	 */
+	memcpy(xlo->state, xlo->init_state, sizeof(xlo->state));
+
+	xl->sched_started = false;
+	/*
+	 * release shared state lock (lock acquire in intel_start_scheduling())
+	 */
+	spin_unlock_irqrestore(&excl_cntrs->lock, excl_cntrs->lock_flags);
+}
+
+static struct event_constraint *
+intel_get_excl_constraints(struct cpu_hw_events *cpuc, struct perf_event *event,
+			   struct event_constraint *c)
+{
+	struct event_constraint *cx;
+	struct intel_excl_cntrs *excl_cntrs = cpuc->excl_cntrs;
+	struct intel_excl_states *xl, *xlo;
+	int is_excl, i;
+	int tid = cpuc->excl_thread_id;
+	int o_tid = 1 - tid; /* alternate */
+
+	/*
+	 * validating a group does not require
+	 * enforcing cross-thread  exclusion
+	 */
+	if (cpuc->is_fake)
+		return c;
+
+	/*
+	 * event requires exclusive counter access
+	 * across HT threads
+	 */
+	is_excl = c->flags & PERF_X86_EVENT_EXCL;
+
+	/*
+	 * xl = state of current HT
+	 * xlo = state of sibling HT
+	 */
+	xl = &excl_cntrs->states[tid];
+	xlo = &excl_cntrs->states[o_tid];
+
+	cx = c;
+
+	/*
+	 * because we modify the constraint, we need
+	 * to make a copy. Static constraints come
+	 * from static const tables.
+	 *
+	 * only needed when constraint has not yet
+	 * been cloned (marked dynamic)
+	 */
+	if (!(c->flags & PERF_X86_EVENT_DYNAMIC)) {
+
+		/*
+		 * in case we fail, we assume no counter
+		 * is supported to be on the safe side
+		 */
+		cx = kmalloc(sizeof(*cx), GFP_KERNEL);
+		if (!cx)
+			return &emptyconstraint;
+
+		/*
+		 * initialize dynamic constraint
+		 * with static constraint
+		 */
+		memcpy(cx, c, sizeof(*cx));
+
+		/*
+		 * mark constraint as dynamic, so we
+		 * can free it later on
+		 */
+		cx->flags |= PERF_X86_EVENT_DYNAMIC;
+	}
+
+	/*
+	 * From here on, the constraint is dynamic.
+	 * Either it was just allocated above, or it
+	 * was allocated during a earlier invocation
+	 * of this function
+	 */
+
+	/*
+	 * Modify static constraint with current dynamic
+	 * state of thread
+	 *
+	 * EXCLUSIVE: sibling counter measuring exclusive event
+	 * SHARED   : sibling counter measuring non-exclusive event
+	 * UNUSED   : sibling counter unused
+	 */
+	for_each_set_bit(i, cx->idxmsk, X86_PMC_IDX_MAX) {
+		/*
+		 * exclusive event in sibling counter
+		 * our corresponding counter cannot be used
+		 * regardless of our event
+		 */
+		if (xl->state[i] == INTEL_EXCL_EXCLUSIVE)
+			__clear_bit(i, cx->idxmsk);
+		/*
+		 * if measuring an exclusive event, sibling
+		 * measuring non-exclusive, then counter cannot
+		 * be used
+		 */
+		if (is_excl && xl->state[i] == INTEL_EXCL_SHARED)
+			__clear_bit(i, cx->idxmsk);
+	}
+
+	/*
+	 * recompute actual bit weight for scheduling algorithm
+	 */
+	cx->weight = hweight64(cx->idxmsk64);
+
+	/*
+	 * if we return an empty mask, then switch
+	 * back to static empty constraint to avoid
+	 * the cost of freeing later on
+	 */
+	if (cx->weight == 0) {
+		kfree(cx);
+		cx = &emptyconstraint;
+	}
+
+	return cx;
+}
+
+static struct event_constraint *
+intel_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
+{
+	struct event_constraint *c = event->hw.constraint;
+
+	/*
+	 * first time only
+	 * - static constraint: no change across incremental scheduling calls
+	 * - dynamic constraint: handled by intel_get_excl_constraints()
+	 */
+	if (!c)
+		c = __intel_get_event_constraints(cpuc, event);
+
+	if (cpuc->excl_cntrs)
+		return intel_get_excl_constraints(cpuc, event, c);
+
+	return c;
+}
+
+static void intel_put_excl_constraints(struct cpu_hw_events *cpuc,
+		struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	struct intel_excl_cntrs *excl_cntrs = cpuc->excl_cntrs;
+	struct intel_excl_states *xlo, *xl;
+	unsigned long flags = 0; /* keep compiler happy */
+	int tid = cpuc->excl_thread_id;
+	int o_tid = 1 - tid;
+	int i;
+
+	/*
+	 * nothing needed if in group validation mode
+	 */
+	if (cpuc->is_fake)
+		return;
+
+	WARN_ON_ONCE(!excl_cntrs);
+
+	if (!excl_cntrs)
+		return;
+
+	xl = &excl_cntrs->states[tid];
+	xlo = &excl_cntrs->states[o_tid];
+
+	/*
+	 * put_constraint may be called from x86_schedule_events()
+	 * which already has the lock held so here make locking
+	 * conditional
+	 */
+	if (!xl->sched_started)
+		spin_lock_irqsave(&excl_cntrs->lock, flags);
+
+	/*
+	 * if event was actually assigned, then mark the
+	 * counter state as unused now
+	 */
+	if (hwc->idx >= 0)
+		xlo->state[hwc->idx] = INTEL_EXCL_UNUSED;
+
+	if (!xl->sched_started)
+		spin_unlock_irqrestore(&excl_cntrs->lock, flags);
+
+}
+
+static void
 intel_put_shared_regs_event_constraints(struct cpu_hw_events *cpuc,
 					struct perf_event *event)
 {
@@ -1669,7 +1919,59 @@ intel_put_shared_regs_event_constraints(struct cpu_hw_events *cpuc,
 static void intel_put_event_constraints(struct cpu_hw_events *cpuc,
 					struct perf_event *event)
 {
+	struct event_constraint *c = event->hw.constraint;
+
 	intel_put_shared_regs_event_constraints(cpuc, event);
+
+	/*
+	 * is PMU has exclusive counter restrictions, then
+	 * all events are subject to and must call the
+	 * put_excl_constraints() routine
+	 */
+	if (c && cpuc->excl_cntrs)
+		intel_put_excl_constraints(cpuc, event);
+
+	/* free dynamic constraint */
+	if (c && (c->flags & PERF_X86_EVENT_DYNAMIC)) {
+		kfree(event->hw.constraint);
+		event->hw.constraint = NULL;
+	}
+}
+
+static void intel_commit_scheduling(struct cpu_hw_events *cpuc,
+				    struct perf_event *event, int cntr)
+{
+	struct intel_excl_cntrs *excl_cntrs = cpuc->excl_cntrs;
+	struct event_constraint *c = event->hw.constraint;
+	struct intel_excl_states *xlo, *xl;
+	int tid = cpuc->excl_thread_id;
+	int o_tid = 1 - tid;
+	int is_excl;
+
+	if (cpuc->is_fake || !c)
+		return;
+
+	is_excl = c->flags & PERF_X86_EVENT_EXCL;
+
+	if (!(c->flags & PERF_X86_EVENT_DYNAMIC))
+		return;
+
+	WARN_ON_ONCE(!excl_cntrs);
+
+	if (!excl_cntrs)
+		return;
+
+	xl = &excl_cntrs->states[tid];
+	xlo = &excl_cntrs->states[o_tid];
+
+	WARN_ON_ONCE(!spin_is_locked(&excl_cntrs->lock));
+
+	if (cntr >= 0) {
+		if (is_excl)
+			xlo->init_state[cntr] = INTEL_EXCL_EXCLUSIVE;
+		else
+			xlo->init_state[cntr] = INTEL_EXCL_SHARED;
+	}
 }
 
 static void intel_pebs_aliases_core2(struct perf_event *event)
@@ -2087,6 +2389,13 @@ static void intel_pmu_cpu_dying(int cpu)
 		cpuc->excl_cntrs = NULL;
 	}
 
+	c = cpuc->excl_cntrs;
+	if (c) {
+		if (c->core_id == -1 || --c->refcnt == 0)
+			kfree(c);
+		cpuc->excl_cntrs = NULL;
+	}
+
 	fini_debug_store_on_cpu(cpu);
 }
 
-- 
1.7.9.5

