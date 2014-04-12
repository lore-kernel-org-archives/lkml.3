Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304AbaDLKnL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 06:43:11 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:58994 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756089AbaDLKmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 06:42:39 -0400
X-IronPort-AV: E=Sophos;i="4.97,847,1389715200"; 
   d="scan'208";a="29176932"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/6] workqueue: commit worker to pool's concurrency setting atomically.
Date: Sat, 12 Apr 2014 18:45:33 +0800
Message-ID: <1397299543-12012-5-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1397299543-12012-1-git-send-email-laijs@cn.fujitsu.com>
References: <1397299543-12012-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

workers' concurrency setting need to be coordinate with pool's
concurrency setting when create_worker()/destroy_worker()/cpu_inline()
cpu_offline().

But create_worker() handles it non-atomically(not in a single pool->lock).
This patch makes the behavior atomically.

Now bind_list is used for coordinating workers' cpumask with the pool.
worker_idr is used for coordinating workers' concurrency with the pool.

cpumask is coordinated at first and then concurrency.

We don't want to remove worker_idr and re-use bind_list.
if we do so:
1) the locking will become much complex.
2) after removing worker_idr, we need to add a ida back
   we do not save any thing.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 6c38aed..3a6be02 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -63,10 +63,6 @@ enum {
 	 * While DISASSOCIATED, the cpu may be offline and all workers have
 	 * %WORKER_UNBOUND set and concurrency management disabled, and may
 	 * be executing on any CPU.  The pool behaves as an unbound one.
-	 *
-	 * Note that DISASSOCIATED should be flipped only while holding
-	 * manager_mutex to avoid changing binding state while
-	 * create_worker() is in progress.
 	 */
 	POOL_MANAGE_WORKERS	= 1 << 0,	/* need to manage workers */
 	POOL_DISASSOCIATED	= 1 << 2,	/* cpu can't serve workers */
@@ -1745,16 +1741,10 @@ static struct worker *create_worker(struct worker_pool *pool)
 
 	bind_worker(worker, pool);
 
-	/*
-	 * The caller is responsible for ensuring %POOL_DISASSOCIATED
-	 * remains stable across this function.  See the comments above the
-	 * flag definition for details.
-	 */
+	/* successful, commit the worker to the pool's concurrency setting */
+	spin_lock_irq(&pool->lock);
 	if (pool->flags & POOL_DISASSOCIATED)
 		worker->flags |= WORKER_UNBOUND;
-
-	/* successful, commit the pointer to idr */
-	spin_lock_irq(&pool->lock);
 	idr_replace(&pool->worker_idr, worker, worker->id);
 	spin_unlock_irq(&pool->lock);
 
@@ -1841,6 +1831,7 @@ static void destroy_worker(struct worker *worker)
 
 	list_del_init(&worker->entry);
 	worker->flags |= WORKER_DIE;
+	/* release @id and leave pool's concurrency setting */
 	idr_remove(&pool->worker_idr, worker->id);
 	wake_up_process(worker->task);
 }
-- 
1.7.4.4

