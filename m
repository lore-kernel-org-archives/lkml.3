Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193AbaESNH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:07:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59265 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176AbaESNHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:07:53 -0400
Date: Mon, 19 May 2014 06:07:16 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-kat4gl1m5a6dwy6nzuqox45e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, tj@kernel.org,
        tglx@linutronix.de, juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, tj@kernel.org,
        tglx@linutronix.de, juri.lelli@gmail.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/cpudl: Replace NR_CPUS arrays
Git-Commit-ID: 34af0d3f599f5f90bf92c1070698485739959536
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

Commit-ID:  34af0d3f599f5f90bf92c1070698485739959536
Gitweb:     http://git.kernel.org/tip/34af0d3f599f5f90bf92c1070698485739959536
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 14 May 2014 16:13:56 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 19 May 2014 21:47:34 +0900

sched/cpudl: Replace NR_CPUS arrays

Tejun reported that his resume was failing due to order-3 allocations
from sched_domain building.

Replace the NR_CPUS arrays in there with a dynamically allocated
array.

Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Juri Lelli <juri.lelli@gmail.com>
Reported-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-kat4gl1m5a6dwy6nzuqox45e@git.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/cpudeadline.c | 33 ++++++++++++++++++++++++---------
 kernel/sched/cpudeadline.h |  6 +++---
 2 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
index ab001b5..bd95963 100644
--- a/kernel/sched/cpudeadline.c
+++ b/kernel/sched/cpudeadline.c
@@ -13,6 +13,7 @@
 
 #include <linux/gfp.h>
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include "cpudeadline.h"
 
 static inline int parent(int i)
@@ -39,8 +40,10 @@ static void cpudl_exchange(struct cpudl *cp, int a, int b)
 {
 	int cpu_a = cp->elements[a].cpu, cpu_b = cp->elements[b].cpu;
 
-	swap(cp->elements[a], cp->elements[b]);
-	swap(cp->cpu_to_idx[cpu_a], cp->cpu_to_idx[cpu_b]);
+	swap(cp->elements[a].cpu, cp->elements[b].cpu);
+	swap(cp->elements[a].dl , cp->elements[b].dl );
+
+	swap(cp->elements[cpu_a].idx, cp->elements[cpu_b].idx);
 }
 
 static void cpudl_heapify(struct cpudl *cp, int idx)
@@ -140,7 +143,7 @@ void cpudl_set(struct cpudl *cp, int cpu, u64 dl, int is_valid)
 	WARN_ON(!cpu_present(cpu));
 
 	raw_spin_lock_irqsave(&cp->lock, flags);
-	old_idx = cp->cpu_to_idx[cpu];
+	old_idx = cp->elements[cpu].idx;
 	if (!is_valid) {
 		/* remove item */
 		if (old_idx == IDX_INVALID) {
@@ -155,8 +158,8 @@ void cpudl_set(struct cpudl *cp, int cpu, u64 dl, int is_valid)
 		cp->elements[old_idx].dl = cp->elements[cp->size - 1].dl;
 		cp->elements[old_idx].cpu = new_cpu;
 		cp->size--;
-		cp->cpu_to_idx[new_cpu] = old_idx;
-		cp->cpu_to_idx[cpu] = IDX_INVALID;
+		cp->elements[new_cpu].idx = old_idx;
+		cp->elements[cpu].idx = IDX_INVALID;
 		while (old_idx > 0 && dl_time_before(
 				cp->elements[parent(old_idx)].dl,
 				cp->elements[old_idx].dl)) {
@@ -173,7 +176,7 @@ void cpudl_set(struct cpudl *cp, int cpu, u64 dl, int is_valid)
 		cp->size++;
 		cp->elements[cp->size - 1].dl = 0;
 		cp->elements[cp->size - 1].cpu = cpu;
-		cp->cpu_to_idx[cpu] = cp->size - 1;
+		cp->elements[cpu].idx = cp->size - 1;
 		cpudl_change_key(cp, cp->size - 1, dl);
 		cpumask_clear_cpu(cpu, cp->free_cpus);
 	} else {
@@ -195,10 +198,21 @@ int cpudl_init(struct cpudl *cp)
 	memset(cp, 0, sizeof(*cp));
 	raw_spin_lock_init(&cp->lock);
 	cp->size = 0;
-	for (i = 0; i < NR_CPUS; i++)
-		cp->cpu_to_idx[i] = IDX_INVALID;
-	if (!alloc_cpumask_var(&cp->free_cpus, GFP_KERNEL))
+
+	cp->elements = kcalloc(nr_cpu_ids,
+			       sizeof(struct cpudl_item),
+			       GFP_KERNEL);
+	if (!cp->elements)
+		return -ENOMEM;
+
+	if (!alloc_cpumask_var(&cp->free_cpus, GFP_KERNEL)) {
+		kfree(cp->elements);
 		return -ENOMEM;
+	}
+
+	for_each_possible_cpu(i)
+		cp->elements[i].idx = IDX_INVALID;
+
 	cpumask_setall(cp->free_cpus);
 
 	return 0;
@@ -211,4 +225,5 @@ int cpudl_init(struct cpudl *cp)
 void cpudl_cleanup(struct cpudl *cp)
 {
 	free_cpumask_var(cp->free_cpus);
+	kfree(cp->elements);
 }
diff --git a/kernel/sched/cpudeadline.h b/kernel/sched/cpudeadline.h
index a202789..538c979 100644
--- a/kernel/sched/cpudeadline.h
+++ b/kernel/sched/cpudeadline.h
@@ -5,17 +5,17 @@
 
 #define IDX_INVALID     -1
 
-struct array_item {
+struct cpudl_item {
 	u64 dl;
 	int cpu;
+	int idx;
 };
 
 struct cpudl {
 	raw_spinlock_t lock;
 	int size;
-	int cpu_to_idx[NR_CPUS];
-	struct array_item elements[NR_CPUS];
 	cpumask_var_t free_cpus;
+	struct cpudl_item *elements;
 };
 
 
