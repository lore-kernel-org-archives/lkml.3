Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905Ab3LOQkP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 11:40:15 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:61397 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab3LOQkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 11:40:12 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shaohua Li <shli@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Wang YanQing <udknight@gmail.com>, Jiang Liu <jiang.liu@huawei.com>,
        linux-kernel@vger.kernel.org
Cc: Jiang Liu <liuj97@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <trivial@kernel.org>,
        linux-arch@vger.kernel.org
Subject: [PATCH v3 [resend] 02/18] Revert "smp: Fix SMP function call empty cpu mask race"
Date: Mon, 16 Dec 2013 00:36:24 +0800
Message-Id: <1387125400-28849-3-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1387125400-28849-1-git-send-email-liuj97@gmail.com>
References: <1387125400-28849-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit f44310b98ddb7f0d06550d73ed67df5865e3eda5.

Commit f44310b98ddb7 "smp: Fix SMP function call empty cpu mask race"
introduced field call_function_data->cpumask_ipi to resolve a race
condition in smp_call_function_many().

Later commit 9a46ad6d6df3 "smp: make smp_call_function_many() use logic
similar to smp_call_function_single()" fixed the same issue in another
way when optimizing smp_call_function_many(), which then obsoletes
changes introduced by commit f44310b98ddb7. So revert it.

Acked-by: Wang YanQing <udknight@gmail.com>
Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 kernel/smp.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 442d514..25c19af 100644
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
@@ -245,9 +240,9 @@ int smp_call_function_single(int cpu, smp_call_func_t func, void *info,
 				csd = &__get_cpu_var(csd_data);
 
 			csd_lock(csd);
-
 			csd->func = func;
 			csd->info = info;
+
 			generic_exec_single(cpu, csd, wait);
 		} else {
 			err = -ENXIO;	/* CPU not online */
@@ -399,13 +394,6 @@ void smp_call_function_many(const struct cpumask *mask,
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
@@ -422,7 +410,7 @@ void smp_call_function_many(const struct cpumask *mask,
 	}
 
 	/* Send a message to all CPUs in the map */
-	arch_send_call_function_ipi_mask(cfd->cpumask_ipi);
+	arch_send_call_function_ipi_mask(cfd->cpumask);
 
 	if (wait) {
 		for_each_cpu(cpu, cfd->cpumask) {
-- 
1.8.1.2

