Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab3BCVIb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 16:08:31 -0500
Received: from mail-vb0-f41.google.com ([209.85.212.41]:63658 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597Ab3BCVIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 16:08:30 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        anish kumar <anish198519851985@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] irq_work: irq_work_queue function return value not used.
Date: Sun,  3 Feb 2013 22:08:23 +0100
Message-Id: <1359925703-24304-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: anish kumar <anish198519851985@gmail.com>

As no one is using the return value of irq_work_queue function
it is better to just make it void.

Acked-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: anish kumar <anish198519851985@gmail.com>
[fix stale comments, remove now unnecessary __irq_work_queue
intermediate function]
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/irq_work.h |    2 +-
 kernel/irq_work.c        |   31 ++++++++++---------------------
 2 files changed, 11 insertions(+), 22 deletions(-)

diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
index 6a9e8f5..ce60c08 100644
--- a/include/linux/irq_work.h
+++ b/include/linux/irq_work.h
@@ -16,7 +16,7 @@ void init_irq_work(struct irq_work *work, void (*func)(struct irq_work *))
 	work->func = func;
 }
 
-bool irq_work_queue(struct irq_work *work);
+void irq_work_queue(struct irq_work *work);
 void irq_work_run(void);
 void irq_work_sync(struct irq_work *work);
 
diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index 64eddd5..c9d7478 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -63,12 +63,20 @@ void __weak arch_irq_work_raise(void)
 }
 
 /*
- * Queue the entry and raise the IPI if needed.
+ * Enqueue the irq_work @entry unless it's already pending
+ * somewhere.
+ *
+ * Can be re-enqueued while the callback is still in progress.
  */
-static void __irq_work_queue(struct irq_work *work)
+void irq_work_queue(struct irq_work *work)
 {
 	bool empty;
 
+	/* Only queue if not already pending */
+	if (!irq_work_claim(work))
+		return;
+
+	/* Queue the entry and raise the IPI if needed. */
 	preempt_disable();
 
 	empty = llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
@@ -78,25 +86,6 @@ static void __irq_work_queue(struct irq_work *work)
 
 	preempt_enable();
 }
-
-/*
- * Enqueue the irq_work @entry, returns true on success, failure when the
- * @entry was already enqueued by someone else.
- *
- * Can be re-enqueued while the callback is still in progress.
- */
-bool irq_work_queue(struct irq_work *work)
-{
-	if (!irq_work_claim(work)) {
-		/*
-		 * Already enqueued, can't do!
-		 */
-		return false;
-	}
-
-	__irq_work_queue(work);
-	return true;
-}
 EXPORT_SYMBOL_GPL(irq_work_queue);
 
 /*
-- 
1.7.5.4

