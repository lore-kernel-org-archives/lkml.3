Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab3LRRXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 12:23:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59679 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043Ab3LRRXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 12:23:44 -0500
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>
Subject: [PATCH 3/3] kernel: use lockless list for smp_call_function_single()
Date: Wed, 18 Dec 2013 18:23:38 +0100
Message-Id: <1387387418-10005-7-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387387418-10005-1-git-send-email-jack@suse.cz>
References: <1387387418-10005-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Make smp_call_function_single and friends more efficient by using
a lockless list.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/elevator.h |  2 +-
 include/linux/smp.h      |  3 ++-
 kernel/smp.c             | 51 ++++++++++--------------------------------------
 3 files changed, 13 insertions(+), 43 deletions(-)

diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index 0bdfd46f4735..06860e2a25c3 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -205,7 +205,7 @@ enum {
 #define rq_entry_fifo(ptr)	list_entry((ptr), struct request, queuelist)
 #define rq_fifo_clear(rq)	do {		\
 	list_del_init(&(rq)->queuelist);	\
-	INIT_LIST_HEAD(&(rq)->csd.list);	\
+	(rq)->csd.llist.next = NULL;		\
 	} while (0)
 
 #else /* CONFIG_BLOCK */
diff --git a/include/linux/smp.h b/include/linux/smp.h
index 5da22ee42e16..9a1b8ba05924 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -11,12 +11,13 @@
 #include <linux/list.h>
 #include <linux/cpumask.h>
 #include <linux/init.h>
+#include <linux/llist.h>
 
 extern void cpu_idle(void);
 
 typedef void (*smp_call_func_t)(void *info);
 struct call_single_data {
-	struct list_head list;
+	struct llist_node llist;
 	smp_call_func_t func;
 	void *info;
 	u16 flags;
diff --git a/kernel/smp.c b/kernel/smp.c
index bd9f94028838..47b415e16c24 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -28,12 +28,7 @@ struct call_function_data {
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct call_function_data, cfd_data);
 
-struct call_single_queue {
-	struct list_head	list;
-	raw_spinlock_t		lock;
-};
-
-static DEFINE_PER_CPU_SHARED_ALIGNED(struct call_single_queue, call_single_queue);
+static DEFINE_PER_CPU_SHARED_ALIGNED(struct llist_head, call_single_queue);
 
 static int
 hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
@@ -85,12 +80,8 @@ void __init call_function_init(void)
 	void *cpu = (void *)(long)smp_processor_id();
 	int i;
 
-	for_each_possible_cpu(i) {
-		struct call_single_queue *q = &per_cpu(call_single_queue, i);
-
-		raw_spin_lock_init(&q->lock);
-		INIT_LIST_HEAD(&q->list);
-	}
+	for_each_possible_cpu(i)
+		init_llist_head(&per_cpu(call_single_queue, i));
 
 	hotplug_cfd(&hotplug_cfd_notifier, CPU_UP_PREPARE, cpu);
 	register_cpu_notifier(&hotplug_cfd_notifier);
@@ -141,18 +132,9 @@ static void csd_unlock(struct call_single_data *csd)
  */
 static void generic_exec_single(int cpu, struct call_single_data *csd, int wait)
 {
-	struct call_single_queue *dst = &per_cpu(call_single_queue, cpu);
-	unsigned long flags;
-	int ipi;
-
 	if (wait)
 		csd->flags |= CSD_FLAG_WAIT;
 
-	raw_spin_lock_irqsave(&dst->lock, flags);
-	ipi = list_empty(&dst->list);
-	list_add_tail(&csd->list, &dst->list);
-	raw_spin_unlock_irqrestore(&dst->lock, flags);
-
 	/*
 	 * The list addition should be visible before sending the IPI
 	 * handler locks the list to pull the entry off it because of
@@ -164,7 +146,7 @@ static void generic_exec_single(int cpu, struct call_single_data *csd, int wait)
 	 * locking and barrier primitives. Generic code isn't really
 	 * equipped to do the right thing...
 	 */
-	if (ipi)
+	if (llist_add(&csd->llist, &per_cpu(call_single_queue, cpu)))
 		arch_send_call_function_single_ipi(cpu);
 
 	if (wait)
@@ -177,26 +159,19 @@ static void generic_exec_single(int cpu, struct call_single_data *csd, int wait)
  */
 void generic_smp_call_function_single_interrupt(void)
 {
-	struct call_single_queue *q = &__get_cpu_var(call_single_queue);
-	LIST_HEAD(list);
+	struct llist_node *entry;
+	struct call_single_data *csd, *csd_next;
 
 	/*
 	 * Shouldn't receive this interrupt on a cpu that is not yet online.
 	 */
 	WARN_ON_ONCE(!cpu_online(smp_processor_id()));
 
-	raw_spin_lock(&q->lock);
-	list_replace_init(&q->list, &list);
-	raw_spin_unlock(&q->lock);
-
-	while (!list_empty(&list)) {
-		struct call_single_data *csd;
-
-		csd = list_entry(list.next, struct call_single_data, list);
-		list_del(&csd->list);
+	entry = llist_del_all(&__get_cpu_var(call_single_queue));
+	entry = llist_reverse_order(entry);
 
+	llist_for_each_entry_safe(csd, csd_next, entry, llist) {
 		csd->func(csd->info);
-
 		csd_unlock(csd);
 	}
 }
@@ -411,17 +386,11 @@ void smp_call_function_many(const struct cpumask *mask,
 
 	for_each_cpu(cpu, cfd->cpumask) {
 		struct call_single_data *csd = per_cpu_ptr(cfd->csd, cpu);
-		struct call_single_queue *dst =
-					&per_cpu(call_single_queue, cpu);
-		unsigned long flags;
 
 		csd_lock(csd);
 		csd->func = func;
 		csd->info = info;
-
-		raw_spin_lock_irqsave(&dst->lock, flags);
-		list_add_tail(&csd->list, &dst->list);
-		raw_spin_unlock_irqrestore(&dst->lock, flags);
+		llist_add(&csd->llist, &per_cpu(call_single_queue, cpu));
 	}
 
 	/* Send a message to all CPUs in the map */
-- 
1.8.1.4

