Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750980AbaGZEDV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 00:03:21 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:35684 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750810AbaGZEDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 00:03:11 -0400
X-IronPort-AV: E=Sophos;i="5.00,965,1396972800"; 
   d="scan'208";a="33803137"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH] kthread_work: remove the unused wait_queue_head
Date: Sat, 26 Jul 2014 12:04:00 +0800
Message-ID: <1406347444-4045-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wait_queue_head_t done was totally unused since the flush_kthread_work()
had been re-implemented.  So we removed it including the initialization
code.  Some LOCKDEP code also depends on this wait_queue_head, so the
LOCKDEP code is also cleanup.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/kthread.h |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index 7dcef33..790e49c 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -73,7 +73,6 @@ struct kthread_worker {
 struct kthread_work {
 	struct list_head	node;
 	kthread_work_func_t	func;
-	wait_queue_head_t	done;
 	struct kthread_worker	*worker;
 };
 
@@ -85,7 +84,6 @@ struct kthread_work {
 #define KTHREAD_WORK_INIT(work, fn)	{				\
 	.node = LIST_HEAD_INIT((work).node),				\
 	.func = (fn),							\
-	.done = __WAIT_QUEUE_HEAD_INITIALIZER((work).done),		\
 	}
 
 #define DEFINE_KTHREAD_WORKER(worker)					\
@@ -95,24 +93,21 @@ struct kthread_work {
 	struct kthread_work work = KTHREAD_WORK_INIT(work, fn)
 
 /*
- * kthread_worker.lock and kthread_work.done need their own lockdep class
- * keys if they are defined on stack with lockdep enabled.  Use the
- * following macros when defining them on stack.
+ * kthread_worker.lock need its own lockdep class key if it is defined
+ * on stack with lockdep enabled.  Use the following macros when defining
+ * it on stack.
  */
 #ifdef CONFIG_LOCKDEP
 # define KTHREAD_WORKER_INIT_ONSTACK(worker)				\
 	({ init_kthread_worker(&worker); worker; })
 # define DEFINE_KTHREAD_WORKER_ONSTACK(worker)				\
 	struct kthread_worker worker = KTHREAD_WORKER_INIT_ONSTACK(worker)
-# define KTHREAD_WORK_INIT_ONSTACK(work, fn)				\
-	({ init_kthread_work((&work), fn); work; })
-# define DEFINE_KTHREAD_WORK_ONSTACK(work, fn)				\
-	struct kthread_work work = KTHREAD_WORK_INIT_ONSTACK(work, fn)
 #else
 # define DEFINE_KTHREAD_WORKER_ONSTACK(worker) DEFINE_KTHREAD_WORKER(worker)
-# define DEFINE_KTHREAD_WORK_ONSTACK(work, fn) DEFINE_KTHREAD_WORK(work, fn)
 #endif
 
+# define DEFINE_KTHREAD_WORK_ONSTACK(work, fn) DEFINE_KTHREAD_WORK(work, fn)
+
 extern void __init_kthread_worker(struct kthread_worker *worker,
 			const char *name, struct lock_class_key *key);
 
@@ -127,7 +122,6 @@ extern void __init_kthread_worker(struct kthread_worker *worker,
 		memset((work), 0, sizeof(struct kthread_work));		\
 		INIT_LIST_HEAD(&(work)->node);				\
 		(work)->func = (fn);					\
-		init_waitqueue_head(&(work)->done);			\
 	} while (0)
 
 int kthread_worker_fn(void *worker_ptr);
-- 
1.7.4.4

