Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751048AbaGZEDZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 00:03:25 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:35684 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750884AbaGZEDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 00:03:17 -0400
X-IronPort-AV: E=Sophos;i="5.00,965,1396972800"; 
   d="scan'208";a="33803140"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Subject: [PATCH] kthread_work: add cancel_kthread_work[_sync]()
Date: Sat, 26 Jul 2014 12:04:01 +0800
Message-ID: <1406347444-4045-3-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an object or a subsystem quits, we need to destroy the kthread_work
which is used by the object or the subsystem.  We used to use
flush_kthread_work().  But flush_kthread_work() has not any guarantee
about the suspension of the work, this duty is pushed to the users.

So we introduce the cancel_kthread_work_sync() with a strict guarantee
like cancel_work_sync() (workqueue).  We also introduce cancel_kthread_work()
which can be used by users on some conditions.  And it is required for
making the implementation of the cancel_kthread_work_sync() simpler.
kthread_flush_work_fn() owns the running state of the kthread_worker
and calls cancel_kthread_work() to cancel the possible requeued work.

Both cancel_kthread_work_sync() and cancel_kthread_work() share the
code of flush_kthread_work() which also make the implementation simpler.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/kthread.h |    2 +
 kernel/kthread.c        |   78 ++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 66 insertions(+), 14 deletions(-)

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index 790e49c..3cc3377 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -129,6 +129,8 @@ int kthread_worker_fn(void *worker_ptr);
 bool queue_kthread_work(struct kthread_worker *worker,
 			struct kthread_work *work);
 void flush_kthread_work(struct kthread_work *work);
+void cancel_kthread_work(struct kthread_work *work);
+void cancel_kthread_work_sync(struct kthread_work *work);
 void flush_kthread_worker(struct kthread_worker *worker);
 
 #endif /* _LINUX_KTHREAD_H */
diff --git a/kernel/kthread.c b/kernel/kthread.c
index ef48322..b5d6844 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -622,6 +622,7 @@ EXPORT_SYMBOL_GPL(queue_kthread_work);
 
 struct kthread_flush_work {
 	struct kthread_work	work;
+	struct kthread_work	*cancel_work;
 	struct completion	done;
 };
 
@@ -629,24 +630,25 @@ static void kthread_flush_work_fn(struct kthread_work *work)
 {
 	struct kthread_flush_work *fwork =
 		container_of(work, struct kthread_flush_work, work);
+
+	/* cancel the possible requeued work for cancel_kthread_work_sync() */
+	if (fwork->cancel_work)
+		cancel_kthread_work(fwork->cancel_work);
 	complete(&fwork->done);
 }
 
-/**
- * flush_kthread_work - flush a kthread_work
- * @work: work to flush
- *
- * If @work is queued or executing, wait for it to finish execution.
- */
-void flush_kthread_work(struct kthread_work *work)
+static void __cancel_work_sync(struct kthread_work *work, bool cancel, bool sync)
 {
 	struct kthread_flush_work fwork = {
-		KTHREAD_WORK_INIT(fwork.work, kthread_flush_work_fn),
-		COMPLETION_INITIALIZER_ONSTACK(fwork.done),
+		.work = KTHREAD_WORK_INIT(fwork.work, kthread_flush_work_fn),
+		.done = COMPLETION_INITIALIZER_ONSTACK(fwork.done),
 	};
 	struct kthread_worker *worker;
 	bool noop = false;
 
+	if (WARN_ON(!cancel && !sync))
+		return;
+
 retry:
 	worker = work->worker;
 	if (!worker)
@@ -658,21 +660,69 @@ retry:
 		goto retry;
 	}
 
-	if (!list_empty(&work->node))
+	/* cancel the queued work */
+	if (cancel && !list_empty(&work->node))
+		list_del_init(&work->node);
+
+	/* cancel the work during flushing it if it is requeued */
+	if (cancel && sync)
+		fwork.cancel_work = work;
+
+	/* insert the kthread_flush_work when sync */
+	if (sync && !list_empty(&work->node))
 		insert_kthread_work(worker, &fwork.work, work->node.next);
-	else if (worker->current_work == work)
+	else if (sync && worker->current_work == work)
 		insert_kthread_work(worker, &fwork.work, worker->work_list.next);
 	else
 		noop = true;
 
 	spin_unlock_irq(&worker->lock);
 
-	if (!noop)
+	if (sync && !noop)
 		wait_for_completion(&fwork.done);
 }
+
+/**
+ * flush_kthread_work - flush a kthread_work
+ * @work: work to flush
+ *
+ * If @work is queued or executing, wait for it to finish execution.
+ */
+void flush_kthread_work(struct kthread_work *work)
+{
+	__cancel_work_sync(work, false, true);
+}
 EXPORT_SYMBOL_GPL(flush_kthread_work);
 
 /**
+ * cancel_kthread_work - cancel a kthread_work
+ * @work: work to cancel
+ *
+ * If @work is queued, cancel it. Note, the work maybe still
+ * be executing after it returns.
+ */
+void cancel_kthread_work(struct kthread_work *work)
+{
+	__cancel_work_sync(work, true, false);
+}
+EXPORT_SYMBOL_GPL(cancel_kthread_work);
+
+/**
+ * cancel_kthread_work_sync - cancel a kthread_work and sync it
+ * @work: work to cancel
+ *
+ * If @work is queued or executing, cancel the queued work and
+ * wait for the executing work to finish execution. It ensures
+ * that there is at least one point that the work is not queued
+ * nor executing.
+ */
+void cancel_kthread_work_sync(struct kthread_work *work)
+{
+	__cancel_work_sync(work, true, true);
+}
+EXPORT_SYMBOL_GPL(cancel_kthread_work_sync);
+
+/**
  * flush_kthread_worker - flush all current works on a kthread_worker
  * @worker: worker to flush
  *
@@ -682,8 +732,8 @@ EXPORT_SYMBOL_GPL(flush_kthread_work);
 void flush_kthread_worker(struct kthread_worker *worker)
 {
 	struct kthread_flush_work fwork = {
-		KTHREAD_WORK_INIT(fwork.work, kthread_flush_work_fn),
-		COMPLETION_INITIALIZER_ONSTACK(fwork.done),
+		.work = KTHREAD_WORK_INIT(fwork.work, kthread_flush_work_fn),
+		.done = COMPLETION_INITIALIZER_ONSTACK(fwork.done),
 	};
 
 	queue_kthread_work(worker, &fwork.work);
-- 
1.7.4.4

