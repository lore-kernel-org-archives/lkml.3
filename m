Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab3LOQrF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 11:47:05 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:41000 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab3LOQrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 11:47:01 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shaohua Li <shli@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Wang YanQing <udknight@gmail.com>, Jiang Liu <jiang.liu@huawei.com>,
        linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <trivial@kernel.org>,
        linux-arch@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v3 [resend] 17/18] smp: rename call_single_queue as call_function_queue
Date: Mon, 16 Dec 2013 00:36:39 +0800
Message-Id: <1387125400-28849-18-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1387125400-28849-1-git-send-email-liuj97@gmail.com>
References: <1387125400-28849-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Now the same list is used to serve both single and multiple function
call requests, so rename call_single_queue as call_function_queue.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Shaohua Li <shli@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Kosina <trivial@kernel.org>
Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 kernel/smp.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 144a427..413183d 100644
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
@@ -133,7 +133,7 @@ static void csd_unlock(struct call_single_data *csd)
  */
 static void generic_exec_single(int cpu, struct call_single_data *csd, int wait)
 {
-	struct call_single_queue *dst = &per_cpu(call_single_queue, cpu);
+	struct call_function_queue *dst = &per_cpu(call_function_queue, cpu);
 	unsigned long flags;
 	int ipi;
 
@@ -164,12 +164,12 @@ static void generic_exec_single(int cpu, struct call_single_data *csd, int wait)
 }
 
 /*
- * Invoked by arch to handle an IPI for call function single. Must be
+ * Invoked by arch to handle an IPI for call function. Must be
  * called from the arch with interrupts disabled.
  */
 void smp_call_function_interrupt(void)
 {
-	struct call_single_queue *q = &__get_cpu_var(call_single_queue);
+	struct call_function_queue *q = &__get_cpu_var(call_function_queue);
 	LIST_HEAD(list);
 
 	/*
@@ -396,8 +396,8 @@ void smp_call_function_many(const struct cpumask *mask,
 
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

