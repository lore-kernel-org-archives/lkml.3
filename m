Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab3IKQLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:11:39 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:51965 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716Ab3IKQLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:11:34 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shaohua Li <shli@kernel.org>
Cc: liuj97@gmail.com, Jiang Liu <jiang.liu@huawei.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <trivial@kernel.org>,
        Wang YanQing <udknight@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: [RFC PATCH v2 24/25] smp: rename call_single_queue as call_function_queue
Date: Thu, 12 Sep 2013 00:07:28 +0800
Message-Id: <1378915649-16395-25-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378915649-16395-1-git-send-email-liuj97@gmail.com>
References: <1378915649-16395-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Now the same list is used to serve both single and multiple function
call requests, so rename call_single_queue as call_function_queue.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
---
 kernel/smp.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 9fbf12a..f4affa4 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -27,12 +27,12 @@ struct call_function_data {
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct call_function_data, cfd_data);
 
-struct call_single_queue {
+struct call_function_queue {
 	struct list_head	list;
 	raw_spinlock_t		lock;
 };
 
-static DEFINE_PER_CPU_SHARED_ALIGNED(struct call_single_queue, call_single_queue);
+static DEFINE_PER_CPU_SHARED_ALIGNED(struct call_function_queue, call_function_queue);
 
 static int
 hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
@@ -75,11 +75,11 @@ static struct notifier_block hotplug_cfd_notifier = {
 void __init call_function_init(void)
 {
 	void *cpu = (void *)(long)smp_processor_id();
+	struct call_function_queue *q;
 	int i;
 
 	for_each_possible_cpu(i) {
-		struct call_single_queue *q = &per_cpu(call_single_queue, i);
-
+		q = &per_cpu(call_function_queue, i);
 		raw_spin_lock_init(&q->lock);
 		INIT_LIST_HEAD(&q->list);
 	}
@@ -134,7 +134,7 @@ static void csd_unlock(struct call_single_data *csd)
 static
 void generic_exec_single(int cpu, struct call_single_data *csd, int wait)
 {
-	struct call_single_queue *dst = &per_cpu(call_single_queue, cpu);
+	struct call_function_queue *dst = &per_cpu(call_function_queue, cpu);
 	unsigned long flags;
 	int ipi;
 
@@ -162,12 +162,12 @@ void generic_exec_single(int cpu, struct call_single_data *csd, int wait)
 }
 
 /*
- * Invoked by arch to handle an IPI for call function single. Must be
+ * Invoked by arch to handle an IPI for call function. Must be
  * called from the arch with interrupts disabled.
  */
 void generic_smp_call_function_interrupt(void)
 {
-	struct call_single_queue *q = &__get_cpu_var(call_single_queue);
+	struct call_function_queue *q = &__get_cpu_var(call_function_queue);
 	LIST_HEAD(list);
 
 	/*
@@ -407,8 +407,8 @@ void smp_call_function_many(const struct cpumask *mask,
 
 	for_each_cpu(cpu, cfd->cpumask) {
 		struct call_single_data *csd = per_cpu_ptr(cfd->csd, cpu);
-		struct call_single_queue *dst =
-					&per_cpu(call_single_queue, cpu);
+		struct call_function_queue *dst =
+					&per_cpu(call_function_queue, cpu);
 		unsigned long flags;
 
 		csd_lock(csd);
-- 
1.8.1.2

