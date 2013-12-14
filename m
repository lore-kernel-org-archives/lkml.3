Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab3LNNqn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 08:46:43 -0500
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:34541 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751407Ab3LNNql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 08:46:41 -0500
X-Greylist: delayed 651 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Dec 2013 08:46:41 EST
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Roman Gushchin <klamm@yandex-team.ru>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Wang YanQing <udknight@gmail.com>,
        Xie XiuQi <xiexiuqi@huawei.com>
Cc: linux-kernel@vger.kernel.org, Roman Gushchin <klamm@yandex-team.ru>
Subject: [PATCH] smp: remove cpumask_ipi
Date: Sat, 14 Dec 2013 17:34:31 +0400
Message-Id: <1387028071-31566-1-git-send-email-klamm@yandex-team.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit 9a46ad6 (smp: make smp_call_function_many() use logic
similar to smp_call_function_single()), cfd->cpumask is accessed only
in smp_call_function_many(). So there is no more need to copy it
into cfd->cpumask_ipi before putting csd into the list.
The cpumask_ipi field is obsolete and can be removed.

Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
---
 kernel/smp.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index bd9f940..dfdce07 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -23,7 +23,6 @@ enum {
 struct call_function_data {
 	struct call_single_data	__percpu *csd;
 	cpumask_var_t		cpumask;
-	cpumask_var_t		cpumask_ipi;
 };
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct call_function_data, cfd_data);
@@ -47,14 +46,8 @@ hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		if (!zalloc_cpumask_var_node(&cfd->cpumask, GFP_KERNEL,
 				cpu_to_node(cpu)))
 			return notifier_from_errno(-ENOMEM);
-		if (!zalloc_cpumask_var_node(&cfd->cpumask_ipi, GFP_KERNEL,
-				cpu_to_node(cpu))) {
-			free_cpumask_var(cfd->cpumask);
-			return notifier_from_errno(-ENOMEM);
-		}
 		cfd->csd = alloc_percpu(struct call_single_data);
 		if (!cfd->csd) {
-			free_cpumask_var(cfd->cpumask_ipi);
 			free_cpumask_var(cfd->cpumask);
 			return notifier_from_errno(-ENOMEM);
 		}
@@ -67,7 +60,6 @@ hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		free_cpumask_var(cfd->cpumask);
-		free_cpumask_var(cfd->cpumask_ipi);
 		free_percpu(cfd->csd);
 		break;
 #endif
@@ -402,13 +394,6 @@ void smp_call_function_many(const struct cpumask *mask,
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
@@ -425,7 +410,7 @@ void smp_call_function_many(const struct cpumask *mask,
 	}
 
 	/* Send a message to all CPUs in the map */
-	arch_send_call_function_ipi_mask(cfd->cpumask_ipi);
+	arch_send_call_function_ipi_mask(cfd->cpumask);
 
 	if (wait) {
 		for_each_cpu(cpu, cfd->cpumask) {
-- 
1.8.3.2

