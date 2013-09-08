Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab3IHPWk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 11:22:40 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:37167 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab3IHPWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 11:22:38 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shaohua Li <shli@kernel.org>,
        Wang YanQing <udknight@gmail.com>
Cc: liuj97@gmail.com, Jiang Liu <jiang.liu@huawei.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        liguang <lig.fnst@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/3] SMP: kill redundant call_function_data->cpumask_ipi field
Date: Sun,  8 Sep 2013 23:22:23 +0800
Message-Id: <1378653745-8343-1-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Commit f44310b98ddb7 "smp: Fix SMP function call empty cpu mask race"
introduced field call_function_data->cpumask_ipi to resolve a race
condition in smp_call_function_many().

Later commit 9a46ad6d6df3 "smp: make smp_call_function_many() use logic
similar to smp_call_function_single()" fixed the same issue in another
way when optimizing smp_call_function_many(), which then obsoletes
changes introduced by commit f44310b98ddb7. So revert it.

We may also keep call_function_data->cpumask_ipi field and use it to
optimize smp_call_function_many() as below:
diff --git a/kernel/smp.c b/kernel/smp.c
index fe9f773..dd852fb 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -428,6 +428,8 @@ void smp_call_function_many(const struct cpumask *mask,
                csd->info = info;

                raw_spin_lock_irqsave(&dst->lock, flags);
+               if (list_empty(&dst->list))
+                       cpumask_clear_cpu(cpu, cfd->cpumask_ipi);
                list_add_tail(&csd->list, &dst->list);
                raw_spin_unlock_irqrestore(&dst->lock, flags);
        }

But I have no platforms to verify the optimization effect,
so simpify the code first.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Wang YanQing <udknight@gmail.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: liguang <lig.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
---
 kernel/smp.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index fe9f773..a034712 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -23,7 +23,6 @@ enum {
 struct call_function_data {
 	struct call_single_data	__percpu *csd;
 	cpumask_var_t		cpumask;
-	cpumask_var_t		cpumask_ipi;
 };
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct call_function_data, cfd_data);
@@ -47,9 +46,6 @@ hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		if (!zalloc_cpumask_var_node(&cfd->cpumask, GFP_KERNEL,
 				cpu_to_node(cpu)))
 			return notifier_from_errno(-ENOMEM);
-		if (!zalloc_cpumask_var_node(&cfd->cpumask_ipi, GFP_KERNEL,
-				cpu_to_node(cpu)))
-			return notifier_from_errno(-ENOMEM);
 		cfd->csd = alloc_percpu(struct call_single_data);
 		if (!cfd->csd) {
 			free_cpumask_var(cfd->cpumask);
@@ -64,7 +60,6 @@ hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		free_cpumask_var(cfd->cpumask);
-		free_cpumask_var(cfd->cpumask_ipi);
 		free_percpu(cfd->csd);
 		break;
 #endif
@@ -255,9 +250,9 @@ int smp_call_function_single(int cpu, smp_call_func_t func, void *info,
 				csd = &__get_cpu_var(csd_data);
 
 			csd_lock(csd);
-
 			csd->func = func;
 			csd->info = info;
+
 			generic_exec_single(cpu, csd, wait);
 		} else {
 			err = -ENXIO;	/* CPU not online */
@@ -410,13 +405,6 @@ void smp_call_function_many(const struct cpumask *mask,
 	if (unlikely(!cpumask_weight(cfd->cpumask)))
 		return;
 
-	/*
-	 * After we put an entry into the list, cfd->cpumask may be cleared
-	 * again when another CPU sends another IPI for a SMP function call, so
-	 * cfd->cpumask will be zero.
-	 */
-	cpumask_copy(cfd->cpumask_ipi, cfd->cpumask);
-
 	for_each_cpu(cpu, cfd->cpumask) {
 		struct call_single_data *csd = per_cpu_ptr(cfd->csd, cpu);
 		struct call_single_queue *dst =
@@ -433,7 +421,7 @@ void smp_call_function_many(const struct cpumask *mask,
 	}
 
 	/* Send a message to all CPUs in the map */
-	arch_send_call_function_ipi_mask(cfd->cpumask_ipi);
+	arch_send_call_function_ipi_mask(cfd->cpumask);
 
 	if (wait) {
 		for_each_cpu(cpu, cfd->cpumask) {
-- 
1.8.1.2

