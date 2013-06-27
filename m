Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab3F0JKK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:10:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45994 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab3F0JCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:02:04 -0400
Date: Thu, 27 Jun 2013 02:01:12 -0700
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-2f7f73a52078b667d64df16eaebdb97d98c9a410@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20130620164254.GA3556@quad>
References: <20130620164254.GA3556@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86:
  Fix shared register mutual exclusion enforcement
Git-Commit-ID: 2f7f73a52078b667d64df16eaebdb97d98c9a410
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 27 Jun 2013 02:01:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2f7f73a52078b667d64df16eaebdb97d98c9a410
Gitweb:     http://git.kernel.org/tip/2f7f73a52078b667d64df16eaebdb97d98c9a410
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 20 Jun 2013 18:42:54 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 26 Jun 2013 21:58:49 +0200

perf/x86: Fix shared register mutual exclusion enforcement

This patch fixes a problem with the shared registers mutual
exclusion code and incremental event scheduling by the
generic perf_event code.

There was a bug whereby the mutual exclusion on the shared
registers was not enforced because of incremental scheduling
abort due to event constraints. As an example on Intel
Nehalem, consider the following events:

group1= L1D_CACHE_LD:E_STATE,OFFCORE_RESPONSE_0:PF_RFO,L1D_CACHE_LD:I_STATE
group2= L1D_CACHE_LD:I_STATE

The L1D_CACHE_LD event can only be measured by 2 counters. Yet, there
are 3 instances here. The first group can be scheduled and is committed.
Then, the generic code tries to schedule group2 and this fails (because
there is no more counter to support the 3rd instance of L1D_CACHE_LD).
But in x86_schedule_events() error path, put_event_contraints() is invoked
on ALL the events and not just the ones that just failed. That causes the
"lock" on the shared offcore_response MSR to be released. Yet the first group
is actually scheduled and is exposed to reprogramming of that shared msr by
the sibling HT thread. In other words, there is no guarantee on what is
measured.

This patch fixes the problem by tagging committed events with the
PERF_X86_EVENT_COMMITTED tag. In the error path of x86_schedule_events(),
only the events NOT tagged have their constraint released. The tag
is eventually removed when the event in descheduled.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20130620164254.GA3556@quad
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c       | 26 +++++++++++++++++++++++++-
 arch/x86/kernel/cpu/perf_event.h       |  3 ++-
 arch/x86/kernel/cpu/perf_event_intel.c |  2 --
 3 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index afc2413..9e581c5 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -726,6 +726,7 @@ int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 {
 	struct event_constraint *c;
 	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+	struct perf_event *e;
 	int i, wmin, wmax, num = 0;
 	struct hw_perf_event *hwc;
 
@@ -770,13 +771,31 @@ int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 					 wmax, assign);
 
 	/*
+	 * Mark the event as committed, so we do not put_constraint()
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
+			 * do not put_constraint() on comitted events,
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
@@ -1156,6 +1175,11 @@ static void x86_pmu_del(struct perf_event *event, int flags)
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
index 4809f07..97e557b 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -63,11 +63,12 @@ struct event_constraint {
 	int	flags;
 };
 /*
- * struct event_constraint flags
+ * struct hw_perf_event.flags flags
  */
 #define PERF_X86_EVENT_PEBS_LDLAT	0x1 /* ld+ldlat data address sampling */
 #define PERF_X86_EVENT_PEBS_ST		0x2 /* st data address sampling */
 #define PERF_X86_EVENT_PEBS_ST_HSW	0x4 /* haswell style st data sampling */
+#define PERF_X86_EVENT_COMMITTED	0x8 /* event passed commit_txn */
 
 struct amd_nb {
 	int nb_id;  /* NorthBridge id */
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 5877f37..fbc9210 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1450,7 +1450,6 @@ x86_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 	if (x86_pmu.event_constraints) {
 		for_each_event_constraint(c, x86_pmu.event_constraints) {
 			if ((event->hw.config & c->cmask) == c->code) {
-				/* hw.flags zeroed at initialization */
 				event->hw.flags |= c->flags;
 				return c;
 			}
@@ -1498,7 +1497,6 @@ intel_put_shared_regs_event_constraints(struct cpu_hw_events *cpuc,
 static void intel_put_event_constraints(struct cpu_hw_events *cpuc,
 					struct perf_event *event)
 {
-	event->hw.flags = 0;
 	intel_put_shared_regs_event_constraints(cpuc, event);
 }
 
