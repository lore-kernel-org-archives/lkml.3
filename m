Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab3CBD1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:27:34 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:54399 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab3CBDZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:25:11 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jmoyer@redhat.com, zab@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 25/31] workqueue: perform non-reentrancy test when queueing to unbound workqueues too
Date: Fri,  1 Mar 2013 19:24:16 -0800
Message-Id: <1362194662-2344-26-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362194662-2344-1-git-send-email-tj@kernel.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because per-cpu workqueues have multiple pwqs (pool_workqueues) to
serve the CPUs, to guarantee that a single work item isn't queued on
one pwq while still executing another, __queue_work() takes a look at
the previous pool the target work item was on and if it's still
executing there, queue the work item on that pool.

To support changing workqueue_attrs on the fly, unbound workqueues too
will have multiple pwqs and thus need non-reentrancy test when
queueing.  This patch modifies __queue_work() such that the reentrancy
test is performed regardless of the workqueue type.

per_cpu_ptr(wq->cpu_pwqs, cpu) used to be used to determine the
matching pwq for the last pool.  This can't be used for unbound
workqueues and is replaced with worker->current_pwq which also happens
to be simpler.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 42 +++++++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 23 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0f0da59..4c67967 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1206,6 +1206,7 @@ static void __queue_work(int cpu, struct workqueue_struct *wq,
 			 struct work_struct *work)
 {
 	struct pool_workqueue *pwq;
+	struct worker_pool *last_pool;
 	struct list_head *worklist;
 	unsigned int work_flags;
 	unsigned int req_cpu = cpu;
@@ -1225,41 +1226,36 @@ static void __queue_work(int cpu, struct workqueue_struct *wq,
 	    WARN_ON_ONCE(!is_chained_work(wq)))
 		return;
 
-	/* determine the pwq to use */
+	/* pwq which will be used unless @work is executing elsewhere */
 	if (!(wq->flags & WQ_UNBOUND)) {
-		struct worker_pool *last_pool;
-
 		if (cpu == WORK_CPU_UNBOUND)
 			cpu = raw_smp_processor_id();
-
-		/*
-		 * It's multi cpu.  If @work was previously on a different
-		 * cpu, it might still be running there, in which case the
-		 * work needs to be queued on that cpu to guarantee
-		 * non-reentrancy.
-		 */
 		pwq = per_cpu_ptr(wq->cpu_pwqs, cpu);
-		last_pool = get_work_pool(work);
+	} else {
+		pwq = first_pwq(wq);
+	}
 
-		if (last_pool && last_pool != pwq->pool) {
-			struct worker *worker;
+	/*
+	 * If @work was previously on a different pool, it might still be
+	 * running there, in which case the work needs to be queued on that
+	 * pool to guarantee non-reentrancy.
+	 */
+	last_pool = get_work_pool(work);
+	if (last_pool && last_pool != pwq->pool) {
+		struct worker *worker;
 
-			spin_lock(&last_pool->lock);
+		spin_lock(&last_pool->lock);
 
-			worker = find_worker_executing_work(last_pool, work);
+		worker = find_worker_executing_work(last_pool, work);
 
-			if (worker && worker->current_pwq->wq == wq) {
-				pwq = per_cpu_ptr(wq->cpu_pwqs, last_pool->cpu);
-			} else {
-				/* meh... not running there, queue here */
-				spin_unlock(&last_pool->lock);
-				spin_lock(&pwq->pool->lock);
-			}
+		if (worker && worker->current_pwq->wq == wq) {
+			pwq = worker->current_pwq;
 		} else {
+			/* meh... not running there, queue here */
+			spin_unlock(&last_pool->lock);
 			spin_lock(&pwq->pool->lock);
 		}
 	} else {
-		pwq = first_pwq(wq);
 		spin_lock(&pwq->pool->lock);
 	}
 
-- 
1.8.1.2

