Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab3C1Goz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 02:44:55 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:56039 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983Ab3C1Gox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 02:44:53 -0400
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jack@suse.cz, fengguang.wu@intel.com, jmoyer@redhat.com,
        zab@redhat.com, linux-kernel@vger.kernel.org,
        herbert@gondor.hengli.com.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <eag0628@gmail.com>
Subject: [PATCH 10/14] workqueue: use NUMA-aware allocation for pool_workqueues
Date: Wed, 27 Mar 2013 23:43:36 -0700
Message-Id: <1364453020-2829-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1364453020-2829-1-git-send-email-tj@kernel.org>
References: <1364453020-2829-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kmem_cache_alloc_node() with @pool->node instead of
kmem_cache_zalloc() when allocating a pool_workqueue so that it's
allocated on the same node as the associated worker_pool.  As there's
no no kmem_cache_zalloc_node(), move zeroing to init_pwq().

This was suggested by Lai Jiangshan.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <eag0628@gmail.com>
---
 kernel/workqueue.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 58c7663..a4420be 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3626,12 +3626,14 @@ static void pwq_adjust_max_active(struct pool_workqueue *pwq)
 	spin_unlock_irq(&pwq->pool->lock);
 }
 
-/* initialize newly zalloced @pwq which is associated with @wq and @pool */
+/* initialize newly alloced @pwq which is associated with @wq and @pool */
 static void init_pwq(struct pool_workqueue *pwq, struct workqueue_struct *wq,
 		     struct worker_pool *pool)
 {
 	BUG_ON((unsigned long)pwq & WORK_STRUCT_FLAG_MASK);
 
+	memset(pwq, 0, sizeof(*pwq));
+
 	pwq->pool = pool;
 	pwq->wq = wq;
 	pwq->flush_color = -1;
@@ -3677,7 +3679,7 @@ static struct pool_workqueue *alloc_unbound_pwq(struct workqueue_struct *wq,
 	if (!pool)
 		return NULL;
 
-	pwq = kmem_cache_zalloc(pwq_cache, GFP_KERNEL);
+	pwq = kmem_cache_alloc_node(pwq_cache, GFP_KERNEL, pool->node);
 	if (!pwq) {
 		put_unbound_pool(pool);
 		return NULL;
-- 
1.8.1.4

