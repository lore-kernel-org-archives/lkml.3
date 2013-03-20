Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab3CTRIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 13:08:50 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:35852 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375Ab3CTRIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 13:08:48 -0400
Date: Wed, 20 Mar 2013 10:08:36 -0700
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jack@suse.cz, fengguang.wu@intel.com, jmoyer@redhat.com,
        zab@redhat.com, linux-kernel@vger.kernel.org,
        herbert@gondor.hengli.com.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org
Subject: [PATCH 11/10] workqueue: use NUMA-aware allocation for
 pool_workqueues workqueues
Message-ID: <20130320170836.GB26676@htj.dyndns.org>
References: <1363737629-16745-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363737629-16745-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
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
 kernel/workqueue.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3683,12 +3683,14 @@ static void pwq_adjust_max_active(struct
 	spin_unlock(&pwq->pool->lock);
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
@@ -3731,7 +3733,7 @@ static struct pool_workqueue *alloc_unbo
 	if (!pool)
 		return NULL;
 
-	pwq = kmem_cache_zalloc(pwq_cache, GFP_KERNEL);
+	pwq = kmem_cache_alloc_node(pwq_cache, GFP_KERNEL, pool->node);
 	if (!pwq) {
 		put_unbound_pool(pool);
 		return NULL;
