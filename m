Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbaG1ST4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 14:19:56 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:45975 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbaG1STw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 14:19:52 -0400
Date: Mon, 28 Jul 2014 14:19:47 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH UPDATED] kthread_work: remove the unused wait_queue_head
Message-ID: <20140728181947.GE7462@htj.dyndns.org>
References: <1406347444-4045-2-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406347444-4045-2-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Hello,

Updated description and dropped DEFINE_KTHREAD_WORK_ONSTACK().
Applied to wq/for-3.17.

Thanks.
------ 8< ------
>From 95847e1bd34c0de86039408b24a05f07e788061d Mon Sep 17 00:00:00 2001
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Date: Sat, 26 Jul 2014 12:04:00 +0800
Subject: [PATCH] kthread_work: remove the unused wait_queue_head

The wait_queue_head_t kthread_work->done is unused since
flush_kthread_work() has been re-implemented.  Let's remove it
including the initialization code.  This makes
DEFINE_KTHREAD_WORK_ONSTACK() unnecessary, removed.

tj: Updated description.  Removed DEFINE_KTHREAD_WORK_ONSTACK().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/kthread.h | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index 7dcef33..13d5520 100644
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
@@ -95,22 +93,16 @@ struct kthread_work {
 	struct kthread_work work = KTHREAD_WORK_INIT(work, fn)
 
 /*
- * kthread_worker.lock and kthread_work.done need their own lockdep class
- * keys if they are defined on stack with lockdep enabled.  Use the
- * following macros when defining them on stack.
+ * kthread_worker.lock needs its own lockdep class key when defined on
+ * stack with lockdep enabled.  Use the following macros in such cases.
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
 
 extern void __init_kthread_worker(struct kthread_worker *worker,
@@ -127,7 +119,6 @@ extern void __init_kthread_worker(struct kthread_worker *worker,
 		memset((work), 0, sizeof(struct kthread_work));		\
 		INIT_LIST_HEAD(&(work)->node);				\
 		(work)->func = (fn);					\
-		init_waitqueue_head(&(work)->done);			\
 	} while (0)
 
 int kthread_worker_fn(void *worker_ptr);
-- 
1.9.3

