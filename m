Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933830Ab3BSUUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 15:20:33 -0500
Received: from mail-da0-f53.google.com ([209.85.210.53]:57436 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933529Ab3BSUU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 15:20:27 -0500
Date: Tue, 19 Feb 2013 12:20:23 -0800
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] workqueue: use %current instead of worker->task in
 worker_maybe_bind_and_lock()
Message-ID: <20130219202023.GV17414@htj.dyndns.org>
References: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
 <1361203940-6300-7-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361203940-6300-7-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 82bde23c1c79441e2962998d6a614f3266a50bf8 Mon Sep 17 00:00:00 2001
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Date: Tue, 19 Feb 2013 12:17:02 -0800

worker_maybe_bind_and_lock() uses both @worker->task and @current at
the same time.  As worker_maybe_bind_and_lock() can only be called by
the current worker task, they are always the same.

Update worker_maybe_bind_and_lock() to use %current consistently.

This doesn't introduce any functional change.

tj: Massaged the description.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Applied to wq/for-3.10-tmp.  Note that I'm gonna reabse the branch
once 3.9-rc1 is out.

Thanks.

 kernel/workqueue.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f4feaca..cebde5b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1513,7 +1513,7 @@ static void worker_leave_idle(struct worker *worker)
  * flushed from cpu callbacks while cpu is going down, they are
  * guaranteed to execute on the cpu.
  *
- * This function is to be used by rogue workers and rescuers to bind
+ * This function is to be used by unbound workers and rescuers to bind
  * themselves to the target cpu and may race with cpu going down or
  * coming online.  kthread_bind() can't be used because it may put the
  * worker to already dead cpu and set_cpus_allowed_ptr() can't be used
@@ -1538,7 +1538,6 @@ static bool worker_maybe_bind_and_lock(struct worker *worker)
 __acquires(&pool->lock)
 {
 	struct worker_pool *pool = worker->pool;
-	struct task_struct *task = worker->task;
 
 	while (true) {
 		/*
@@ -1548,12 +1547,12 @@ __acquires(&pool->lock)
 		 * against POOL_DISASSOCIATED.
 		 */
 		if (!(pool->flags & POOL_DISASSOCIATED))
-			set_cpus_allowed_ptr(task, get_cpu_mask(pool->cpu));
+			set_cpus_allowed_ptr(current, get_cpu_mask(pool->cpu));
 
 		spin_lock_irq(&pool->lock);
 		if (pool->flags & POOL_DISASSOCIATED)
 			return false;
-		if (task_cpu(task) == pool->cpu &&
+		if (task_cpu(current) == pool->cpu &&
 		    cpumask_equal(&current->cpus_allowed,
 				  get_cpu_mask(pool->cpu)))
 			return true;
-- 
1.8.1

