Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab3CBDZN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:25:13 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:46152 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab3CBDYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:24:48 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jmoyer@redhat.com, zab@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/31] workqueue: replace get_pwq() with explicit per_cpu_ptr() accesses and first_pwq()
Date: Fri,  1 Mar 2013 19:24:02 -0800
Message-Id: <1362194662-2344-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362194662-2344-1-git-send-email-tj@kernel.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_pwq() takes @cpu, which can also be WORK_CPU_UNBOUND, and @wq and
returns the matching pwq (pool_workqueue).  We want to move away from
using @cpu for identifying pools and pwqs for unbound pools with
custom attributes and there is only one user - workqueue_congested() -
which makes use of the WQ_UNBOUND conditional in get_pwq().  All other
users already know whether they're dealing with a per-cpu or unbound
workqueue.

Replace get_pwq() with explicit per_cpu_ptr(wq->cpu_pwqs, cpu) for
per-cpu workqueues and first_pwq() for unbound ones, and open-code
WQ_UNBOUND conditional in workqueue_congested().

Note that this makes workqueue_congested() behave sligntly differently
when @cpu other than WORK_CPU_UNBOUND is specified.  It ignores @cpu
for unbound workqueues and always uses the first pwq instead of
oopsing.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 79840b9..02f51b8 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -463,16 +463,9 @@ static struct worker_pool *get_std_worker_pool(int cpu, bool highpri)
 	return &pools[highpri];
 }
 
-static struct pool_workqueue *get_pwq(int cpu, struct workqueue_struct *wq)
+static struct pool_workqueue *first_pwq(struct workqueue_struct *wq)
 {
-	if (!(wq->flags & WQ_UNBOUND)) {
-		if (likely(cpu < nr_cpu_ids))
-			return per_cpu_ptr(wq->cpu_pwqs, cpu);
-	} else if (likely(cpu == WORK_CPU_UNBOUND)) {
-		return list_first_entry(&wq->pwqs, struct pool_workqueue,
-					pwqs_node);
-	}
-	return NULL;
+	return list_first_entry(&wq->pwqs, struct pool_workqueue, pwqs_node);
 }
 
 static unsigned int work_color_to_flags(int color)
@@ -1192,7 +1185,7 @@ static void __queue_work(int cpu, struct workqueue_struct *wq,
 		 * work needs to be queued on that cpu to guarantee
 		 * non-reentrancy.
 		 */
-		pwq = get_pwq(cpu, wq);
+		pwq = per_cpu_ptr(wq->cpu_pwqs, cpu);
 		last_pool = get_work_pool(work);
 
 		if (last_pool && last_pool != pwq->pool) {
@@ -1203,7 +1196,7 @@ static void __queue_work(int cpu, struct workqueue_struct *wq,
 			worker = find_worker_executing_work(last_pool, work);
 
 			if (worker && worker->current_pwq->wq == wq) {
-				pwq = get_pwq(last_pool->cpu, wq);
+				pwq = per_cpu_ptr(wq->cpu_pwqs, last_pool->cpu);
 			} else {
 				/* meh... not running there, queue here */
 				spin_unlock(&last_pool->lock);
@@ -1213,7 +1206,7 @@ static void __queue_work(int cpu, struct workqueue_struct *wq,
 			spin_lock(&pwq->pool->lock);
 		}
 	} else {
-		pwq = get_pwq(WORK_CPU_UNBOUND, wq);
+		pwq = first_pwq(wq);
 		spin_lock(&pwq->pool->lock);
 	}
 
@@ -1652,7 +1645,7 @@ static void rebind_workers(struct worker_pool *pool)
 		else
 			wq = system_wq;
 
-		insert_work(get_pwq(pool->cpu, wq), rebind_work,
+		insert_work(per_cpu_ptr(wq->cpu_pwqs, pool->cpu), rebind_work,
 			    worker->scheduled.next,
 			    work_color_to_flags(WORK_NO_COLOR));
 	}
@@ -3090,7 +3083,8 @@ static int alloc_and_link_pwqs(struct workqueue_struct *wq)
 			return -ENOMEM;
 
 		for_each_possible_cpu(cpu) {
-			struct pool_workqueue *pwq = get_pwq(cpu, wq);
+			struct pool_workqueue *pwq =
+				per_cpu_ptr(wq->cpu_pwqs, cpu);
 
 			pwq->pool = get_std_worker_pool(cpu, highpri);
 			list_add_tail(&pwq->pwqs_node, &wq->pwqs);
@@ -3345,7 +3339,12 @@ EXPORT_SYMBOL_GPL(workqueue_set_max_active);
  */
 bool workqueue_congested(int cpu, struct workqueue_struct *wq)
 {
-	struct pool_workqueue *pwq = get_pwq(cpu, wq);
+	struct pool_workqueue *pwq;
+
+	if (!(wq->flags & WQ_UNBOUND))
+		pwq = per_cpu_ptr(wq->cpu_pwqs, cpu);
+	else
+		pwq = first_pwq(wq);
 
 	return !list_empty(&pwq->delayed_works);
 }
-- 
1.8.1.2

