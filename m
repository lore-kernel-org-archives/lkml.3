Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbaCRNLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 09:11:43 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:62987 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913AbaCRNLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 09:11:40 -0400
From: Peng Tao <bergwolf@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Peng Tao <bergwolf@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH RFC] sched: introduce add_wait_queue_exclusive_head
Date: Tue, 18 Mar 2014 21:10:08 +0800
Message-Id: <1395148208-2209-1-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Normally wait_queue_t is a FIFO list for exclusive waiting tasks.
As a side effect, if there are many threads waiting on the same
condition (which is common for data servers like Lustre), all
threads will be waken up again and again, causing unnecessary cache
line polution. Instead of FIFO lists, we can use LIFO lists to always
wake up the most recent active threads.

Lustre implements this add_wait_queue_exclusive_head() privately but we
think it might be useful as a generic function. With it being moved to
generic layer, the rest of Lustre private wrappers for wait queue can be
all removed.

Of course there is an alternative approach to just open code it but we'd
like to ask first to see if there is objection to making it generic.

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/include/linux/libcfs/libcfs_prim.h      |    1 -
 .../lustre/lustre/libcfs/linux/linux-prim.c        |   24 --------------------
 include/linux/wait.h                               |    2 +
 kernel/sched/wait.c                                |   23 +++++++++++++++++++
 4 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/libcfs_prim.h b/drivers/staging/lustre/include/linux/libcfs/libcfs_prim.h
index e6e417a..c23b78c 100644
--- a/drivers/staging/lustre/include/linux/libcfs/libcfs_prim.h
+++ b/drivers/staging/lustre/include/linux/libcfs/libcfs_prim.h
@@ -54,7 +54,6 @@ void schedule_timeout_and_set_state(long, int64_t);
 void init_waitqueue_entry_current(wait_queue_t *link);
 int64_t waitq_timedwait(wait_queue_t *, long, int64_t);
 void waitq_wait(wait_queue_t *, long);
-void add_wait_queue_exclusive_head(wait_queue_head_t *, wait_queue_t *);
 
 void cfs_init_timer(struct timer_list *t);
 void cfs_timer_init(struct timer_list *t, cfs_timer_func_t *func, void *arg);
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c
index c7bc7fc..13b4a80 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c
@@ -53,30 +53,6 @@ init_waitqueue_entry_current(wait_queue_t *link)
 }
 EXPORT_SYMBOL(init_waitqueue_entry_current);
 
-/**
- * wait_queue_t of Linux (version < 2.6.34) is a FIFO list for exclusively
- * waiting threads, which is not always desirable because all threads will
- * be waken up again and again, even user only needs a few of them to be
- * active most time. This is not good for performance because cache can
- * be polluted by different threads.
- *
- * LIFO list can resolve this problem because we always wakeup the most
- * recent active thread by default.
- *
- * NB: please don't call non-exclusive & exclusive wait on the same
- * waitq if add_wait_queue_exclusive_head is used.
- */
-void
-add_wait_queue_exclusive_head(wait_queue_head_t *waitq, wait_queue_t *link)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&waitq->lock, flags);
-	__add_wait_queue_exclusive(waitq, link);
-	spin_unlock_irqrestore(&waitq->lock, flags);
-}
-EXPORT_SYMBOL(add_wait_queue_exclusive_head);
-
 void
 waitq_wait(wait_queue_t *link, long state)
 {
diff --git a/include/linux/wait.h b/include/linux/wait.h
index 559044c..634a49c 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -105,6 +105,8 @@ static inline int waitqueue_active(wait_queue_head_t *q)
 
 extern void add_wait_queue(wait_queue_head_t *q, wait_queue_t *wait);
 extern void add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t *wait);
+extern void add_wait_queue_exclusive_head(wait_queue_head_t *q,
+					  wait_queue_t *wait);
 extern void remove_wait_queue(wait_queue_head_t *q, wait_queue_t *wait);
 
 static inline void __add_wait_queue(wait_queue_head_t *head, wait_queue_t *new)
diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index 7d50f79..69925c3 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -30,6 +30,29 @@ void add_wait_queue(wait_queue_head_t *q, wait_queue_t *wait)
 }
 EXPORT_SYMBOL(add_wait_queue);
 
+/**
+ * wait_queue_t is a FIFO list for exclusively waiting threads, which is
+ * not always desirable because all threads will be waken up again and
+ * again, even user only needs a few of them to be active most time. This
+ * is not good for performance because cache can be polluted by different
+ * threads.
+ *
+ * LIFO list can resolve this problem because we always wakeup the most
+ * recent active thread by default.
+ *
+ * NB: please don't call non-exclusive & exclusive wait on the same
+ * waitq if add_wait_queue_exclusive_head is used.
+ */
+void add_wait_queue_exclusive_head(wait_queue_head_t *q, wait_queue_t *wait)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&q->lock, flags);
+	__add_wait_queue_exclusive(q, wait);
+	spin_unlock_irqrestore(&q->lock, flags);
+}
+EXPORT_SYMBOL(add_wait_queue_exclusive_head);
+
 void add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t *wait)
 {
 	unsigned long flags;
-- 
1.7.7.6

