Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab3FEOny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 10:43:54 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:38887 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134Ab3FEOnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 10:43:51 -0400
Date: Wed, 5 Jun 2013 16:43:46 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, jolsa@redhat.com,
        vincent.weaver@maine.edu, ak@linux.intel.com
Subject: [PATCH] perf,x86: Fix shared registers mutual exclusion bug
Message-ID: <20130605144346.GA20338@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes a problem with the shared registers mutual
exclusion code and incremental event scheduling by the
generic perf_event code.

There was a bug whereby the mutual exclusion on the shared
registers was not enforced because of incremental scheduling
abort due to event constraints.

Example on Nehalem:
group1= ref-cycles,OFFCORE_RESPONSE_0:PF_RFO
group2= ref-cycles

The ref-cycles event can only be measured by 1 counter. Yet, there
are 2 instances here. The first group can be scheduled and is committed.
Then, the generic code tries to schedule group2 and this fails (because
there is no more counter to support the 2nd instance of ref-cycles).

But in x86_schedule_events() error path, put_event_contraints() is invoked
on ALL the events and not just the ones that just failed. That causes the
"lock" on the shared offcore_response MSR to be released. Yet the first group
is actually scheduled and is exposed to reprogramming of that shared msr by
the sibling HT thread (when they are shared by HT threads). In other words,
there is no guarantee on what is measured for the offcore_response event.

This patch fixes the problem by tagging committed events with the
PERF_X86_EVENT_COMMITTED tag. In the error path of x86_schedule_events(),
only the events NOT tagged have their constraint released. The tag
is eventually removed when the event in descheduled.

Example was given with offcore_response but also applies to LBR_SELECT
and LDLAT shared registers.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event.c       |   26 +++++++++++++++++++++++++-
 arch/x86/kernel/cpu/perf_event.h       |    9 +++++----
 arch/x86/kernel/cpu/perf_event_intel.c |    2 --
 include/linux/perf_event.h             |    3 ++-
 4 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 1025f3c..d2ff6b8 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -726,6 +726,7 @@ int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 {
 	struct event_constraint *c, *constraints[X86_PMC_IDX_MAX];
 	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+	struct perf_event *e;
 	int i, wmin, wmax, num = 0;
 	struct hw_perf_event *hwc;
 
@@ -767,13 +768,31 @@ int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 		num = perf_assign_events(constraints, n, wmin, wmax, assign);
 
 	/*
+	 * Mark the event as committed, so we do not put_contraint
+	 * in case new events are added and fail scheduling.
+	 */
+	if (!num && assign) {
+		for (i = 0; i < n; i++) {
+			e = cpuc->event_list[i];
+			e->hw.flags |= PERF_X86_EVENT_COMMITTED;
+		}
+	}
+	/*
 	 * scheduling failed or is just a simulation,
 	 * free resources if necessary
 	 */
 	if (!assign || num) {
 		for (i = 0; i < n; i++) {
+			e = cpuc->event_list[i];
+			/*
+			 * do not put_contraint() on comitted events,
+			 * because they are good to go
+			 */
+			if ((e->hw.flags & PERF_X86_EVENT_COMMITTED))
+				continue;
+
 			if (x86_pmu.put_event_constraints)
-				x86_pmu.put_event_constraints(cpuc, cpuc->event_list[i]);
+				x86_pmu.put_event_constraints(cpuc, e);
 		}
 	}
 	return num ? -EINVAL : 0;
@@ -1153,6 +1172,11 @@ static void x86_pmu_del(struct perf_event *event, int flags)
 	int i;
 
 	/*
+	 * event is descheduled
+	 */
+	event->hw.flags &= ~PERF_X86_EVENT_COMMITTED;
+
+	/*
 	 * If we're called during a txn, we don't need to do anything.
 	 * The events never got scheduled and ->cancel_txn will truncate
 	 * the event_list.
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index ba9aadf..571fadb 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -60,13 +60,14 @@ struct event_constraint {
 	u64	cmask;
 	int	weight;
 	int	overlap;
-	int	flags;
+	int	flags; /* hw.flags from constraint */
 };
 /*
- * struct event_constraint flags
+ * struct hw_perf_event.flags flags
  */
-#define PERF_X86_EVENT_PEBS_LDLAT	0x1 /* ld+ldlat data address sampling */
-#define PERF_X86_EVENT_PEBS_ST		0x2 /* st data address sampling */
+#define PERF_X86_EVENT_COMMITTED	0x1 /* event passed commit_txn */
+#define PERF_X86_EVENT_PEBS_LDLAT	0x2 /* ld+ldlat data addr sampling */
+#define PERF_X86_EVENT_PEBS_ST		0x4 /* st data addr sampling */
 
 struct amd_nb {
 	int nb_id;  /* NorthBridge id */
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index f60d41f..8225c84 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1425,7 +1425,6 @@ x86_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 	if (x86_pmu.event_constraints) {
 		for_each_event_constraint(c, x86_pmu.event_constraints) {
 			if ((event->hw.config & c->cmask) == c->code) {
-				/* hw.flags zeroed at initialization */
 				event->hw.flags |= c->flags;
 				return c;
 			}
@@ -1473,7 +1472,6 @@ intel_put_shared_regs_event_constraints(struct cpu_hw_events *cpuc,
 static void intel_put_event_constraints(struct cpu_hw_events *cpuc,
 					struct perf_event *event)
 {
-	event->hw.flags = 0;
 	intel_put_shared_regs_event_constraints(cpuc, event);
 }
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 74a4e14..998b927 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -178,7 +178,8 @@ struct perf_event;
 /*
  * Common implementation detail of pmu::{start,commit,cancel}_txn
  */
-#define PERF_EVENT_TXN 0x1
+#define PERF_EVENT_TXN    0x1
+#define PERF_EVENT_COMMIT 0x2 /* event committed */
 
 /**
  * struct pmu - generic performance monitoring unit
-- 
1.7.9.5

