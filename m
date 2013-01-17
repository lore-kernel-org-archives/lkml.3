Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574Ab3AQBoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 20:44:13 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:37327 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758363Ab3AQBnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 20:43:18 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 14/17] workqueue: remove worker_pool->gcwq
Date: Wed, 16 Jan 2013 17:42:46 -0800
Message-Id: <1358386969-945-15-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1358386969-945-1-git-send-email-tj@kernel.org>
References: <1358386969-945-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only remaining user of pool->gcwq is std_worker_pool_pri().
Reimplement it using get_gcwq() and remove worker_pool->gcwq.

This is part of an effort to remove global_cwq and make worker_pool
the top level abstraction, which in turn will help implementing worker
pools with user-specified attributes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 81f041f..d37db53 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -150,7 +150,6 @@ struct worker {
 };
 
 struct worker_pool {
-	struct global_cwq	*gcwq;		/* I: the owning gcwq */
 	spinlock_t		lock;		/* the pool lock */
 	unsigned int		cpu;		/* I: the associated cpu */
 	int			id;		/* I: pool ID */
@@ -478,11 +477,6 @@ static DEFINE_IDR(worker_pool_idr);
 
 static int worker_thread(void *__worker);
 
-static int std_worker_pool_pri(struct worker_pool *pool)
-{
-	return pool - pool->gcwq->pools;
-}
-
 static struct global_cwq *get_gcwq(unsigned int cpu)
 {
 	if (cpu != WORK_CPU_UNBOUND)
@@ -491,6 +485,11 @@ static struct global_cwq *get_gcwq(unsigned int cpu)
 		return &unbound_global_cwq;
 }
 
+static int std_worker_pool_pri(struct worker_pool *pool)
+{
+	return pool - get_gcwq(pool->cpu)->pools;
+}
+
 /* allocate ID and assign it to @pool */
 static int worker_pool_assign_id(struct worker_pool *pool)
 {
@@ -3827,7 +3826,6 @@ static int __init init_workqueues(void)
 		struct worker_pool *pool;
 
 		for_each_std_worker_pool(pool, cpu) {
-			pool->gcwq = get_gcwq(cpu);
 			spin_lock_init(&pool->lock);
 			pool->cpu = cpu;
 			pool->flags |= POOL_DISASSOCIATED;
-- 
1.8.0.2

