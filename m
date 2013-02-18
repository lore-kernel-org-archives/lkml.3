Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab3BRQOB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:14:01 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:11917 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753724Ab3BRQN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:13:59 -0500
X-IronPort-AV: E=Sophos;i="4.84,688,1355068800"; 
   d="scan'208";a="6724945"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH V2 06/15] workqueue: use current instead of worker->task in worker_maybe_bind_and_lock()
Date: Tue, 19 Feb 2013 00:12:07 +0800
Message-Id: <1361203940-6300-7-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
References: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 00:13:21,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 00:13:21,
	Serialize complete at 2013/02/19 00:13:21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

worker_maybe_bind_and_lock() uses both @task and @current and the same time,
they are the same(worker_maybe_bind_and_lock() can only be called by current
worker task)

We make it uses @current only.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 06d6211..b47d1af 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1560,7 +1560,7 @@ static void worker_leave_idle(struct worker *worker)
  * flushed from cpu callbacks while cpu is going down, they are
  * guaranteed to execute on the cpu.
  *
- * This function is to be used by rogue workers and rescuers to bind
+ * This function is to be used by unbound workers and rescuers to bind
  * themselves to the target cpu and may race with cpu going down or
  * coming online.  kthread_bind() can't be used because it may put the
  * worker to already dead cpu and set_cpus_allowed_ptr() can't be used
@@ -1585,7 +1585,6 @@ static bool worker_maybe_bind_and_lock(struct worker *worker)
 __acquires(&pool->lock)
 {
 	struct worker_pool *pool = worker->pool;
-	struct task_struct *task = worker->task;
 
 	while (true) {
 		/*
@@ -1595,12 +1594,12 @@ __acquires(&pool->lock)
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
1.7.7.6

