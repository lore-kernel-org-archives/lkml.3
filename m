Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab3FATud (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 15:50:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab3FATu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 15:50:29 -0400
Date: Sat, 1 Jun 2013 21:46:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 3/3] hw_breakpoint: Introduce cpumask_of_bp()
Message-ID: <20130601194626.GD27149@redhat.com>
References: <alpine.DEB.2.02.1305201206480.29892@vincent-weaver-1.um.maine.edu> <20130601194526.GA27149@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130601194526.GA27149@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the trivial helper which simply returns cpumask_of() or
cpu_possible_mask depending on bp->cpu.

Change fetch_bp_busy_slots() and toggle_bp_slot() to always do
for_each_cpu(cpumask_of_bp) to simplify the code and avoid the
code duplication.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/hw_breakpoint.c |   43 ++++++++++++++++------------------------
 1 files changed, 17 insertions(+), 26 deletions(-)

diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index 2f4d7c4..57efe5d 100644
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
-- 
1.5.5.1


