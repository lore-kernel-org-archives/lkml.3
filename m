Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235Ab3FTQTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 12:19:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48315 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757720Ab3FTQTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 12:19:52 -0400
Date: Thu, 20 Jun 2013 09:19:32 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-bde96030f438b5eb6fb74f3bdd06d9f68bb3ba00@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fweisbec@gmail.com, vincent.weaver@maine.edu, oleg@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        vincent.weaver@maine.edu, fweisbec@gmail.com, tglx@linutronix.de,
        oleg@redhat.com
In-Reply-To: <20130620155020.GA6350@redhat.com>
References: <20130620155020.GA6350@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] hw_breakpoint: Introduce "struct bp_cpuinfo"
Git-Commit-ID: bde96030f438b5eb6fb74f3bdd06d9f68bb3ba00
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 20 Jun 2013 09:19:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bde96030f438b5eb6fb74f3bdd06d9f68bb3ba00
Gitweb:     http://git.kernel.org/tip/bde96030f438b5eb6fb74f3bdd06d9f68bb3ba00
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Thu, 20 Jun 2013 17:50:20 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 20 Jun 2013 17:58:57 +0200

hw_breakpoint: Introduce "struct bp_cpuinfo"

This patch simply moves all per-cpu variables into the new
single per-cpu "struct bp_cpuinfo".

To me this looks more logical and clean, but this can also
simplify the further potential changes. In particular, I do not
think this memory should be per-cpu, it is never used "locally".
After this change it is trivial to turn it into, say,
bootmem[nr_cpu_ids].

Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/20130620155020.GA6350@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/hw_breakpoint.c | 69 ++++++++++++++++++++++---------------------
 1 file changed, 36 insertions(+), 33 deletions(-)

diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index 38418f7..1559fb0 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -46,23 +46,26 @@
 #include <linux/smp.h>
 
 #include <linux/hw_breakpoint.h>
-
-
 /*
  * Constraints data
  */
+struct bp_cpuinfo {
+	/* Number of pinned cpu breakpoints in a cpu */
+	unsigned int	cpu_pinned;
+	/* tsk_pinned[n] is the number of tasks having n+1 breakpoints */
+	unsigned int	*tsk_pinned;
+	/* Number of non-pinned cpu/task breakpoints in a cpu */
+	unsigned int	flexible; /* XXX: placeholder, see fetch_this_slot() */
+};
 
-/* Number of pinned cpu breakpoints in a cpu */
-static DEFINE_PER_CPU(unsigned int, nr_cpu_bp_pinned[TYPE_MAX]);
-
-/* Number of pinned task breakpoints in a cpu */
-static DEFINE_PER_CPU(unsigned int *, nr_task_bp_pinned[TYPE_MAX]);
-
-/* Number of non-pinned cpu/task breakpoints in a cpu */
-static DEFINE_PER_CPU(unsigned int, nr_bp_flexible[TYPE_MAX]);
-
+static DEFINE_PER_CPU(struct bp_cpuinfo, bp_cpuinfo[TYPE_MAX]);
 static int nr_slots[TYPE_MAX];
 
+static struct bp_cpuinfo *get_bp_info(int cpu, enum bp_type_idx type)
+{
+	return per_cpu_ptr(bp_cpuinfo + type, cpu);
+}
+
 /* Keep track of the breakpoints attached to tasks */
 static LIST_HEAD(bp_task_head);
 
@@ -96,8 +99,8 @@ static inline enum bp_type_idx find_slot_idx(struct perf_event *bp)
  */
 static unsigned int max_task_bp_pinned(int cpu, enum bp_type_idx type)
 {
+	unsigned int *tsk_pinned = get_bp_info(cpu, type)->tsk_pinned;
 	int i;
-	unsigned int *tsk_pinned = per_cpu(nr_task_bp_pinned[type], cpu);
 
 	for (i = nr_slots[type] - 1; i >= 0; i--) {
 		if (tsk_pinned[i] > 0)
@@ -146,8 +149,10 @@ fetch_bp_busy_slots(struct bp_busy_slots *slots, struct perf_event *bp,
 	int cpu;
 
 	for_each_cpu(cpu, cpumask) {
-		unsigned int nr = per_cpu(nr_cpu_bp_pinned[type], cpu);
+		struct bp_cpuinfo *info = get_bp_info(cpu, type);
+		int nr;
 
+		nr = info->cpu_pinned;
 		if (!bp->hw.bp_target)
 			nr += max_task_bp_pinned(cpu, type);
 		else
@@ -156,8 +161,7 @@ fetch_bp_busy_slots(struct bp_busy_slots *slots, struct perf_event *bp,
 		if (nr > slots->pinned)
 			slots->pinned = nr;
 
-		nr = per_cpu(nr_bp_flexible[type], cpu);
-
+		nr = info->flexible;
 		if (nr > slots->flexible)
 			slots->flexible = nr;
 	}
@@ -180,8 +184,7 @@ fetch_this_slot(struct bp_busy_slots *slots, int weight)
 static void toggle_bp_task_slot(struct perf_event *bp, int cpu,
 				enum bp_type_idx type, int weight)
 {
-	/* tsk_pinned[n-1] is the number of tasks having n>0 breakpoints */
-	unsigned int *tsk_pinned = per_cpu(nr_task_bp_pinned[type], cpu);
+	unsigned int *tsk_pinned = get_bp_info(cpu, type)->tsk_pinned;
 	int old_idx, new_idx;
 
 	old_idx = task_bp_pinned(cpu, bp, type) - 1;
@@ -208,7 +211,7 @@ toggle_bp_slot(struct perf_event *bp, bool enable, enum bp_type_idx type,
 
 	/* Pinned counter cpu profiling */
 	if (!bp->hw.bp_target) {
-		per_cpu(nr_cpu_bp_pinned[type], bp->cpu) += weight;
+		get_bp_info(bp->cpu, type)->cpu_pinned += weight;
 		return;
 	}
 
@@ -240,8 +243,8 @@ __weak void arch_unregister_hw_breakpoint(struct perf_event *bp)
  *
  *   - If attached to a single cpu, check:
  *
- *       (per_cpu(nr_bp_flexible, cpu) || (per_cpu(nr_cpu_bp_pinned, cpu)
- *           + max(per_cpu(nr_task_bp_pinned, cpu)))) < HBP_NUM
+ *       (per_cpu(info->flexible, cpu) || (per_cpu(info->cpu_pinned, cpu)
+ *           + max(per_cpu(info->tsk_pinned, cpu)))) < HBP_NUM
  *
  *       -> If there are already non-pinned counters in this cpu, it means
  *          there is already a free slot for them.
@@ -251,8 +254,8 @@ __weak void arch_unregister_hw_breakpoint(struct perf_event *bp)
  *
  *   - If attached to every cpus, check:
  *
- *       (per_cpu(nr_bp_flexible, *) || (max(per_cpu(nr_cpu_bp_pinned, *))
- *           + max(per_cpu(nr_task_bp_pinned, *)))) < HBP_NUM
+ *       (per_cpu(info->flexible, *) || (max(per_cpu(info->cpu_pinned, *))
+ *           + max(per_cpu(info->tsk_pinned, *)))) < HBP_NUM
  *
  *       -> This is roughly the same, except we check the number of per cpu
  *          bp for every cpu and we keep the max one. Same for the per tasks
@@ -263,16 +266,16 @@ __weak void arch_unregister_hw_breakpoint(struct perf_event *bp)
  *
  *   - If attached to a single cpu, check:
  *
- *       ((per_cpu(nr_bp_flexible, cpu) > 1) + per_cpu(nr_cpu_bp_pinned, cpu)
- *            + max(per_cpu(nr_task_bp_pinned, cpu))) < HBP_NUM
+ *       ((per_cpu(info->flexible, cpu) > 1) + per_cpu(info->cpu_pinned, cpu)
+ *            + max(per_cpu(info->tsk_pinned, cpu))) < HBP_NUM
  *
- *       -> Same checks as before. But now the nr_bp_flexible, if any, must keep
+ *       -> Same checks as before. But now the info->flexible, if any, must keep
  *          one register at least (or they will never be fed).
  *
  *   - If attached to every cpus, check:
  *
- *       ((per_cpu(nr_bp_flexible, *) > 1) + max(per_cpu(nr_cpu_bp_pinned, *))
- *            + max(per_cpu(nr_task_bp_pinned, *))) < HBP_NUM
+ *       ((per_cpu(info->flexible, *) > 1) + max(per_cpu(info->cpu_pinned, *))
+ *            + max(per_cpu(info->tsk_pinned, *))) < HBP_NUM
  */
 static int __reserve_bp_slot(struct perf_event *bp)
 {
@@ -622,7 +625,6 @@ static struct pmu perf_breakpoint = {
 
 int __init init_hw_breakpoint(void)
 {
-	unsigned int **task_bp_pinned;
 	int cpu, err_cpu;
 	int i;
 
@@ -631,10 +633,11 @@ int __init init_hw_breakpoint(void)
 
 	for_each_possible_cpu(cpu) {
 		for (i = 0; i < TYPE_MAX; i++) {
-			task_bp_pinned = &per_cpu(nr_task_bp_pinned[i], cpu);
-			*task_bp_pinned = kzalloc(sizeof(int) * nr_slots[i],
-						  GFP_KERNEL);
-			if (!*task_bp_pinned)
+			struct bp_cpuinfo *info = get_bp_info(cpu, i);
+
+			info->tsk_pinned = kcalloc(nr_slots[i], sizeof(int),
+							GFP_KERNEL);
+			if (!info->tsk_pinned)
 				goto err_alloc;
 		}
 	}
@@ -648,7 +651,7 @@ int __init init_hw_breakpoint(void)
  err_alloc:
 	for_each_possible_cpu(err_cpu) {
 		for (i = 0; i < TYPE_MAX; i++)
-			kfree(per_cpu(nr_task_bp_pinned[i], err_cpu));
+			kfree(get_bp_info(err_cpu, i)->tsk_pinned);
 		if (err_cpu == cpu)
 			break;
 	}
