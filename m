Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbaEVIj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 04:39:56 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:44504 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753929AbaEVIjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 04:39:52 -0400
X-IronPort-AV: E=Sophos;i="4.98,885,1392134400"; 
   d="scan'208";a="30863985"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH] workqueue: rename first_worker() to first_idle_worker()
Date: Thu, 22 May 2014 16:44:07 +0800
Message-ID: <1400748247-14131-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

first_worker() actually returns the first idle workers, the name
first_idle_worker() which is self-commnet will be better.

All the callers of first_worker() expect it returns an idle worker,
the name first_idle_worker() with "idle" notation makes reviewers happier.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 2245dc7..23f9a2b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -773,8 +773,8 @@ static bool too_many_workers(struct worker_pool *pool)
  * Wake up functions.
  */
 
-/* Return the first worker.  Safe with preemption disabled */
-static struct worker *first_worker(struct worker_pool *pool)
+/* Return the first idle worker.  Safe with preemption disabled */
+static struct worker *first_idle_worker(struct worker_pool *pool)
 {
 	if (unlikely(list_empty(&pool->idle_list)))
 		return NULL;
@@ -793,7 +793,7 @@ static struct worker *first_worker(struct worker_pool *pool)
  */
 static void wake_up_worker(struct worker_pool *pool)
 {
-	struct worker *worker = first_worker(pool);
+	struct worker *worker = first_idle_worker(pool);
 
 	if (likely(worker))
 		wake_up_process(worker->task);
@@ -867,7 +867,7 @@ struct task_struct *wq_worker_sleeping(struct task_struct *task, int cpu)
 	 */
 	if (atomic_dec_and_test(&pool->nr_running) &&
 	    !list_empty(&pool->worklist))
-		to_wakeup = first_worker(pool);
+		to_wakeup = first_idle_worker(pool);
 	return to_wakeup ? to_wakeup->task : NULL;
 }
 
@@ -3475,7 +3475,7 @@ static void put_unbound_pool(struct worker_pool *pool)
 	mutex_lock(&pool->manager_arb);
 
 	spin_lock_irq(&pool->lock);
-	while ((worker = first_worker(pool)))
+	while ((worker = first_idle_worker(pool)))
 		destroy_worker(worker);
 	WARN_ON(pool->nr_workers || pool->nr_idle);
 	spin_unlock_irq(&pool->lock);
-- 
1.7.4.4

