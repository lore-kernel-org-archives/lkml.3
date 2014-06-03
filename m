Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496AbaFCH3C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 03:29:02 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:37154 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932080AbaFCH3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 03:29:00 -0400
X-IronPort-AV: E=Sophos;i="4.98,963,1392134400"; 
   d="scan'208";a="31368544"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 1/2] workqueue: clear POOL_DISASSOCIATED in rebind_workers()
Date: Tue, 3 Jun 2014 15:33:27 +0800
Message-ID: <1401780809-12331-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit a9ab775bcadf ("workqueue: directly restore CPU affinity of workers
from CPU_ONLINE") moved the pool->lock into rebind_workers() without also
moving "pool->flags &= ~POOL_DISASSOCIATED" into.

There is no wrong that "pool->flags &= ~POOL_DISASSOCIATED" is kept outside,
but there is no benefit either. We move it into rebind_workers() and
achieve these benefits:
  1) better readability, POOL_DISASSOCIATED is cleared in rebind_workers()
     as supposed.
  2) when POOL_DISASSOCIATED is cleared, we can ensure that the running
     workers of the pool are on the local CPU (pool->cpu).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 61381a2..5ae491e 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4535,6 +4535,7 @@ static void rebind_workers(struct worker_pool *pool)
 						  pool->attrs->cpumask) < 0);
 
 	spin_lock_irq(&pool->lock);
+	pool->flags &= ~POOL_DISASSOCIATED;
 
 	for_each_pool_worker(worker, pool) {
 		unsigned int worker_flags = worker->flags;
@@ -4637,10 +4638,6 @@ static int workqueue_cpu_up_callback(struct notifier_block *nfb,
 			mutex_lock(&pool->attach_mutex);
 
 			if (pool->cpu == cpu) {
-				spin_lock_irq(&pool->lock);
-				pool->flags &= ~POOL_DISASSOCIATED;
-				spin_unlock_irq(&pool->lock);
-
 				rebind_workers(pool);
 			} else if (pool->cpu < 0) {
 				restore_unbound_workers_cpumask(pool, cpu);
-- 
1.7.4.4

