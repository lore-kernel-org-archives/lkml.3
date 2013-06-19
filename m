Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935130Ab3FSSjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:39:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40050 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757349Ab3FSSj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:39:27 -0400
Date: Wed, 19 Jun 2013 11:38:58 -0700
From: tip-bot for Andrew Hunter <tipbot@zytor.com>
Message-ID: <tip-43b4578071c0e6d87761e113e05d45776cc75437@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        ahh@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        ahh@google.com
In-Reply-To: <1369332423-4400-1-git-send-email-ahh@google.com>
References: <1369332423-4400-1-git-send-email-ahh@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86:
  Reduce stack usage of x86_schedule_events()
Git-Commit-ID: 43b4578071c0e6d87761e113e05d45776cc75437
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 19 Jun 2013 11:39:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  43b4578071c0e6d87761e113e05d45776cc75437
Gitweb:     http://git.kernel.org/tip/43b4578071c0e6d87761e113e05d45776cc75437
Author:     Andrew Hunter <ahh@google.com>
AuthorDate: Thu, 23 May 2013 11:07:03 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 19 Jun 2013 12:50:44 +0200

perf/x86: Reduce stack usage of x86_schedule_events()

x86_schedule_events() caches event constraints on the stack during
scheduling.  Given the number of possible events, this is 512 bytes of
stack; since it can be invoked under schedule() under god-knows-what,
this is causing stack blowouts.

Trade some space usage for stack safety: add a place to cache the
constraint pointer to struct perf_event.  For 8 bytes per event (1% of
its size) we can save the giant stack frame.

This shouldn't change any aspect of scheduling whatsoever and while in
theory the locality's a tiny bit worse, I doubt we'll see any
performance impact either.

Tested: `perf stat whatever` does not blow up and produces
results that aren't hugely obviously wrong.  I'm not sure how to run
particularly good tests of perf code, but this should not produce any
functional change whatsoever.

Signed-off-by: Andrew Hunter <ahh@google.com>
Reviewed-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1369332423-4400-1-git-send-email-ahh@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c              | 28 ++++++++++++++-------------
 arch/x86/kernel/cpu/perf_event.h              |  2 +-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 10 ++++++----
 include/linux/perf_event.h                    |  4 ++++
 4 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 1025f3c..e52a9e5 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -568,7 +568,7 @@ struct sched_state {
 struct perf_sched {
 	int			max_weight;
 	int			max_events;
-	struct event_constraint	**constraints;
+	struct perf_event	**events;
 	struct sched_state	state;
 	int			saved_states;
 	struct sched_state	saved[SCHED_STATES_MAX];
@@ -577,7 +577,7 @@ struct perf_sched {
 /*
  * Initialize interator that runs through all events and counters.
  */
-static void perf_sched_init(struct perf_sched *sched, struct event_constraint **c,
+static void perf_sched_init(struct perf_sched *sched, struct perf_event **events,
 			    int num, int wmin, int wmax)
 {
 	int idx;
@@ -585,10 +585,10 @@ static void perf_sched_init(struct perf_sched *sched, struct event_constraint **
 	memset(sched, 0, sizeof(*sched));
 	sched->max_events	= num;
 	sched->max_weight	= wmax;
-	sched->constraints	= c;
+	sched->events		= events;
 
 	for (idx = 0; idx < num; idx++) {
-		if (c[idx]->weight == wmin)
+		if (events[idx]->hw.constraint->weight == wmin)
 			break;
 	}
 
@@ -635,8 +635,7 @@ static bool __perf_sched_find_counter(struct perf_sched *sched)
 	if (sched->state.event >= sched->max_events)
 		return false;
 
-	c = sched->constraints[sched->state.event];
-
+	c = sched->events[sched->state.event]->hw.constraint;
 	/* Prefer fixed purpose counters */
 	if (c->idxmsk64 & (~0ULL << INTEL_PMC_IDX_FIXED)) {
 		idx = INTEL_PMC_IDX_FIXED;
@@ -694,7 +693,7 @@ static bool perf_sched_next_event(struct perf_sched *sched)
 			if (sched->state.weight > sched->max_weight)
 				return false;
 		}
-		c = sched->constraints[sched->state.event];
+		c = sched->events[sched->state.event]->hw.constraint;
 	} while (c->weight != sched->state.weight);
 
 	sched->state.counter = 0;	/* start with first counter */
@@ -705,12 +704,12 @@ static bool perf_sched_next_event(struct perf_sched *sched)
 /*
  * Assign a counter for each event.
  */
-int perf_assign_events(struct event_constraint **constraints, int n,
+int perf_assign_events(struct perf_event **events, int n,
 			int wmin, int wmax, int *assign)
 {
 	struct perf_sched sched;
 
-	perf_sched_init(&sched, constraints, n, wmin, wmax);
+	perf_sched_init(&sched, events, n, wmin, wmax);
 
 	do {
 		if (!perf_sched_find_counter(&sched))
@@ -724,7 +723,7 @@ int perf_assign_events(struct event_constraint **constraints, int n,
 
 int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 {
-	struct event_constraint *c, *constraints[X86_PMC_IDX_MAX];
+	struct event_constraint *c;
 	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	int i, wmin, wmax, num = 0;
 	struct hw_perf_event *hwc;
@@ -732,8 +731,10 @@ int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 	bitmap_zero(used_mask, X86_PMC_IDX_MAX);
 
 	for (i = 0, wmin = X86_PMC_IDX_MAX, wmax = 0; i < n; i++) {
+		hwc = &cpuc->event_list[i]->hw;
 		c = x86_pmu.get_event_constraints(cpuc, cpuc->event_list[i]);
-		constraints[i] = c;
+		hwc->constraint = c;
+
 		wmin = min(wmin, c->weight);
 		wmax = max(wmax, c->weight);
 	}
@@ -743,7 +744,7 @@ int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 	 */
 	for (i = 0; i < n; i++) {
 		hwc = &cpuc->event_list[i]->hw;
-		c = constraints[i];
+		c = hwc->constraint;
 
 		/* never assigned */
 		if (hwc->idx == -1)
@@ -764,7 +765,8 @@ int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 
 	/* slow path */
 	if (i != n)
-		num = perf_assign_events(constraints, n, wmin, wmax, assign);
+		num = perf_assign_events(cpuc->event_list, n, wmin,
+					 wmax, assign);
 
 	/*
 	 * scheduling failed or is just a simulation,
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index ba9aadf..6a6ca01 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -528,7 +528,7 @@ static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc,
 
 void x86_pmu_enable_all(int added);
 
-int perf_assign_events(struct event_constraint **constraints, int n,
+int perf_assign_events(struct perf_event **events, int n,
 			int wmin, int wmax, int *assign);
 int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign);
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index c0e356d..adabe6f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2723,15 +2723,16 @@ static void uncore_put_event_constraint(struct intel_uncore_box *box, struct per
 static int uncore_assign_events(struct intel_uncore_box *box, int assign[], int n)
 {
 	unsigned long used_mask[BITS_TO_LONGS(UNCORE_PMC_IDX_MAX)];
-	struct event_constraint *c, *constraints[UNCORE_PMC_IDX_MAX];
+	struct event_constraint *c;
 	int i, wmin, wmax, ret = 0;
 	struct hw_perf_event *hwc;
 
 	bitmap_zero(used_mask, UNCORE_PMC_IDX_MAX);
 
 	for (i = 0, wmin = UNCORE_PMC_IDX_MAX, wmax = 0; i < n; i++) {
+		hwc = &box->event_list[i]->hw;
 		c = uncore_get_event_constraint(box, box->event_list[i]);
-		constraints[i] = c;
+		hwc->constraint = c;
 		wmin = min(wmin, c->weight);
 		wmax = max(wmax, c->weight);
 	}
@@ -2739,7 +2740,7 @@ static int uncore_assign_events(struct intel_uncore_box *box, int assign[], int
 	/* fastpath, try to reuse previous register */
 	for (i = 0; i < n; i++) {
 		hwc = &box->event_list[i]->hw;
-		c = constraints[i];
+		c = hwc->constraint;
 
 		/* never assigned */
 		if (hwc->idx == -1)
@@ -2759,7 +2760,8 @@ static int uncore_assign_events(struct intel_uncore_box *box, int assign[], int
 	}
 	/* slow path */
 	if (i != n)
-		ret = perf_assign_events(constraints, n, wmin, wmax, assign);
+		ret = perf_assign_events(box->event_list, n,
+					 wmin, wmax, assign);
 
 	if (!assign || ret) {
 		for (i = 0; i < n; i++)
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 4bc57d0..33e8d65 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -113,6 +113,8 @@ struct hw_perf_event_extra {
 	int		idx;	/* index in shared_regs->regs[] */
 };
 
+struct event_constraint;
+
 /**
  * struct hw_perf_event - performance event hardware details:
  */
@@ -131,6 +133,8 @@ struct hw_perf_event {
 
 			struct hw_perf_event_extra extra_reg;
 			struct hw_perf_event_extra branch_reg;
+
+			struct event_constraint *constraint;
 		};
 		struct { /* software */
 			struct hrtimer	hrtimer;
