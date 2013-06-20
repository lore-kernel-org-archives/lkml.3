Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205Ab3FTQTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 12:19:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48304 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758092Ab3FTQTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 12:19:34 -0400
Date: Thu, 20 Jun 2013 09:19:13 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-1c10adbb929936316f71df089ace699fce037e24@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fweisbec@gmail.com, vincent.weaver@maine.edu, oleg@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        vincent.weaver@maine.edu, fweisbec@gmail.com, tglx@linutronix.de,
        oleg@redhat.com
In-Reply-To: <20130620155015.GA6340@redhat.com>
References: <20130620155015.GA6340@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] hw_breakpoint: Introduce cpumask_of_bp()
Git-Commit-ID: 1c10adbb929936316f71df089ace699fce037e24
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 20 Jun 2013 09:19:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1c10adbb929936316f71df089ace699fce037e24
Gitweb:     http://git.kernel.org/tip/1c10adbb929936316f71df089ace699fce037e24
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Thu, 20 Jun 2013 17:50:15 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 20 Jun 2013 17:58:56 +0200

hw_breakpoint: Introduce cpumask_of_bp()

Add the trivial helper which simply returns cpumask_of() or
cpu_possible_mask depending on bp->cpu.

Change fetch_bp_busy_slots() and toggle_bp_slot() to always do
for_each_cpu(cpumask_of_bp) to simplify the code and avoid the
code duplication.

Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/20130620155015.GA6340@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/hw_breakpoint.c | 43 +++++++++++++++++--------------------------
 1 file changed, 17 insertions(+), 26 deletions(-)

diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index 5cd4f6d..9c71445 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -127,6 +127,13 @@ static int task_bp_pinned(int cpu, struct perf_event *bp, enum bp_type_idx type)
 	return count;
 }
 
+static const struct cpumask *cpumask_of_bp(struct perf_event *bp)
+{
+	if (bp->cpu >= 0)
+		return cpumask_of(bp->cpu);
+	return cpu_possible_mask;
+}
+
 /*
  * Report the number of pinned/un-pinned breakpoints we have in
  * a given cpu (cpu > -1) or in all of them (cpu = -1).
@@ -135,25 +142,13 @@ static void
 fetch_bp_busy_slots(struct bp_busy_slots *slots, struct perf_event *bp,
 		    enum bp_type_idx type)
 {
-	int cpu = bp->cpu;
-	struct task_struct *tsk = bp->hw.bp_target;
-
-	if (cpu >= 0) {
-		slots->pinned = per_cpu(nr_cpu_bp_pinned[type], cpu);
-		if (!tsk)
-			slots->pinned += max_task_bp_pinned(cpu, type);
-		else
-			slots->pinned += task_bp_pinned(cpu, bp, type);
-		slots->flexible = per_cpu(nr_bp_flexible[type], cpu);
-
-		return;
-	}
+	const struct cpumask *cpumask = cpumask_of_bp(bp);
+	int cpu;
 
-	for_each_possible_cpu(cpu) {
-		unsigned int nr;
+	for_each_cpu(cpu, cpumask) {
+		unsigned int nr = per_cpu(nr_cpu_bp_pinned[type], cpu);
 
-		nr = per_cpu(nr_cpu_bp_pinned[type], cpu);
-		if (!tsk)
+		if (!bp->hw.bp_target)
 			nr += max_task_bp_pinned(cpu, type);
 		else
 			nr += task_bp_pinned(cpu, bp, type);
@@ -205,25 +200,21 @@ static void
 toggle_bp_slot(struct perf_event *bp, bool enable, enum bp_type_idx type,
 	       int weight)
 {
-	int cpu = bp->cpu;
-	struct task_struct *tsk = bp->hw.bp_target;
+	const struct cpumask *cpumask = cpumask_of_bp(bp);
+	int cpu;
 
 	if (!enable)
 		weight = -weight;
 
 	/* Pinned counter cpu profiling */
-	if (!tsk) {
-		per_cpu(nr_cpu_bp_pinned[type], cpu) += weight;
+	if (!bp->hw.bp_target) {
+		per_cpu(nr_cpu_bp_pinned[type], bp->cpu) += weight;
 		return;
 	}
 
 	/* Pinned counter task profiling */
-	if (cpu >= 0) {
+	for_each_cpu(cpu, cpumask)
 		toggle_bp_task_slot(bp, cpu, type, weight);
-	} else {
-		for_each_possible_cpu(cpu)
-			toggle_bp_task_slot(bp, cpu, type, weight);
-	}
 
 	if (enable)
 		list_add_tail(&bp->hw.bp_list, &bp_task_head);
