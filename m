Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbaBTNvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 08:51:46 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:43213 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbaBTNvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 08:51:45 -0500
Date: Thu, 20 Feb 2014 08:51:41 -0500
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] workqueue fixes for v3.14-rc3
Message-ID: <20140220135141.GA6897@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Two workqueue fixes.  One for an unlikely but possible critical bug
during kworker shutdown and the other to make lockdep names a bit more
descriptive.

The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:

  Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.14-fixes

for you to fetch changes up to 5bdfff96c69a4d5ab9c49e60abf9e070ecd2acbb:

  workqueue: ensure @task is valid across kthread_stop() (2014-02-18 16:35:20 -0500)

Thanks.
----------------------------------------------------------------
Lai Jiangshan (1):
      workqueue: ensure @task is valid across kthread_stop()

Li Zhong (1):
      workqueue: add args to workqueue lockdep name

 include/linux/workqueue.h | 5 +----
 kernel/workqueue.c        | 7 +++++++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 594521b..704f4f6 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -419,10 +419,7 @@ __alloc_workqueue_key(const char *fmt, unsigned int flags, int max_active,
 	static struct lock_class_key __key;				\
 	const char *__lock_name;					\
 									\
-	if (__builtin_constant_p(fmt))					\
-		__lock_name = (fmt);					\
-	else								\
-		__lock_name = #fmt;					\
+	__lock_name = #fmt#args;					\
 									\
 	__alloc_workqueue_key((fmt), (flags), (max_active),		\
 			      &__key, __lock_name, ##args);		\
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 82ef9f3..193e977 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1851,6 +1851,12 @@ static void destroy_worker(struct worker *worker)
 	if (worker->flags & WORKER_IDLE)
 		pool->nr_idle--;
 
+	/*
+	 * Once WORKER_DIE is set, the kworker may destroy itself at any
+	 * point.  Pin to ensure the task stays until we're done with it.
+	 */
+	get_task_struct(worker->task);
+
 	list_del_init(&worker->entry);
 	worker->flags |= WORKER_DIE;
 
@@ -1859,6 +1865,7 @@ static void destroy_worker(struct worker *worker)
 	spin_unlock_irq(&pool->lock);
 
 	kthread_stop(worker->task);
+	put_task_struct(worker->task);
 	kfree(worker);
 
 	spin_lock_irq(&pool->lock);
