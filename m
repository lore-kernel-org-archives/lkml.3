Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbaB0Nef (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:34:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55064 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbaB0Ne3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:34:29 -0500
Date: Thu, 27 Feb 2014 05:33:50 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-he3819318c245j7t5e1e22tr@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        vincent.weaver@maine.edu, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        vincent.weaver@maine.edu, peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Add a few more comments
Git-Commit-ID: c347a2f1793e285b0812343e715bb7e953dbdf68
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c347a2f1793e285b0812343e715bb7e953dbdf68
Gitweb:     http://git.kernel.org/tip/c347a2f1793e285b0812343e715bb7e953dbdf68
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 24 Feb 2014 12:26:21 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Feb 2014 12:43:25 +0100

perf/x86: Add a few more comments

Add a few comments on the ->add(), ->del() and ->*_txn()
implementation.

Requested-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-he3819318c245j7t5e1e22tr@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c | 47 ++++++++++++++++++++++++++++------------
 arch/x86/kernel/cpu/perf_event.h |  8 ++++---
 2 files changed, 38 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 79f9f84..ae407f7 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -892,7 +892,6 @@ static void x86_pmu_enable(struct pmu *pmu)
 		 * hw_perf_group_sched_in() or x86_pmu_enable()
 		 *
 		 * step1: save events moving to new counters
-		 * step2: reprogram moved events into new counters
 		 */
 		for (i = 0; i < n_running; i++) {
 			event = cpuc->event_list[i];
@@ -918,6 +917,9 @@ static void x86_pmu_enable(struct pmu *pmu)
 			x86_pmu_stop(event, PERF_EF_UPDATE);
 		}
 
+		/*
+		 * step2: reprogram moved events into new counters
+		 */
 		for (i = 0; i < cpuc->n_events; i++) {
 			event = cpuc->event_list[i];
 			hwc = &event->hw;
@@ -1043,7 +1045,7 @@ static int x86_pmu_add(struct perf_event *event, int flags)
 	/*
 	 * If group events scheduling transaction was started,
 	 * skip the schedulability test here, it will be performed
-	 * at commit time (->commit_txn) as a whole
+	 * at commit time (->commit_txn) as a whole.
 	 */
 	if (cpuc->group_flag & PERF_EVENT_TXN)
 		goto done_collect;
@@ -1058,6 +1060,10 @@ static int x86_pmu_add(struct perf_event *event, int flags)
 	memcpy(cpuc->assign, assign, n*sizeof(int));
 
 done_collect:
+	/*
+	 * Commit the collect_events() state. See x86_pmu_del() and
+	 * x86_pmu_*_txn().
+	 */
 	cpuc->n_events = n;
 	cpuc->n_added += n - n0;
 	cpuc->n_txn += n - n0;
@@ -1183,28 +1189,38 @@ static void x86_pmu_del(struct perf_event *event, int flags)
 	 * If we're called during a txn, we don't need to do anything.
 	 * The events never got scheduled and ->cancel_txn will truncate
 	 * the event_list.
+	 *
+	 * XXX assumes any ->del() called during a TXN will only be on
+	 * an event added during that same TXN.
 	 */
 	if (cpuc->group_flag & PERF_EVENT_TXN)
 		return;
 
+	/*
+	 * Not a TXN, therefore cleanup properly.
+	 */
 	x86_pmu_stop(event, PERF_EF_UPDATE);
 
 	for (i = 0; i < cpuc->n_events; i++) {
-		if (event == cpuc->event_list[i]) {
+		if (event == cpuc->event_list[i])
+			break;
+	}
 
-			if (i >= cpuc->n_events - cpuc->n_added)
-				--cpuc->n_added;
+	if (WARN_ON_ONCE(i == cpuc->n_events)) /* called ->del() without ->add() ? */
+		return;
 
-			if (x86_pmu.put_event_constraints)
-				x86_pmu.put_event_constraints(cpuc, event);
+	/* If we have a newly added event; make sure to decrease n_added. */
+	if (i >= cpuc->n_events - cpuc->n_added)
+		--cpuc->n_added;
 
-			while (++i < cpuc->n_events)
-				cpuc->event_list[i-1] = cpuc->event_list[i];
+	if (x86_pmu.put_event_constraints)
+		x86_pmu.put_event_constraints(cpuc, event);
+
+	/* Delete the array entry. */
+	while (++i < cpuc->n_events)
+		cpuc->event_list[i-1] = cpuc->event_list[i];
+	--cpuc->n_events;
 
-			--cpuc->n_events;
-			break;
-		}
-	}
 	perf_event_update_userpage(event);
 }
 
@@ -1598,7 +1614,8 @@ static void x86_pmu_cancel_txn(struct pmu *pmu)
 {
 	__this_cpu_and(cpu_hw_events.group_flag, ~PERF_EVENT_TXN);
 	/*
-	 * Truncate the collected events.
+	 * Truncate collected array by the number of events added in this
+	 * transaction. See x86_pmu_add() and x86_pmu_*_txn().
 	 */
 	__this_cpu_sub(cpu_hw_events.n_added, __this_cpu_read(cpu_hw_events.n_txn));
 	__this_cpu_sub(cpu_hw_events.n_events, __this_cpu_read(cpu_hw_events.n_txn));
@@ -1609,6 +1626,8 @@ static void x86_pmu_cancel_txn(struct pmu *pmu)
  * Commit group events scheduling transaction
  * Perform the group schedulability test as a whole
  * Return 0 if success
+ *
+ * Does not cancel the transaction on failure; expects the caller to do this.
  */
 static int x86_pmu_commit_txn(struct pmu *pmu)
 {
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 4972c24..3b2f9bd 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -130,9 +130,11 @@ struct cpu_hw_events {
 	unsigned long		running[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	int			enabled;
 
-	int			n_events;
-	int			n_added;
-	int			n_txn;
+	int			n_events; /* the # of events in the below arrays */
+	int			n_added;  /* the # last events in the below arrays;
+					     they've never been enabled yet */
+	int			n_txn;    /* the # last events in the below arrays;
+					     added in the current transaction */
 	int			assign[X86_PMC_IDX_MAX]; /* event to counter assignment */
 	u64			tags[X86_PMC_IDX_MAX];
 	struct perf_event	*event_list[X86_PMC_IDX_MAX]; /* in enabled order */
