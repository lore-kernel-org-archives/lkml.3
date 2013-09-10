Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab3IJBwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 21:52:55 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:26527 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab3IJBwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 21:52:54 -0400
From: Libin <huawei.libin@huawei.com>
To: <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <wangyijing@huawei.com>,
        <guohanjun@huawei.com>, <huawei.libin@huawei.com>
Subject: [PATCH] workqueue: fix pool ID allocation leakage and remove BUILD_BUG_ON() in init_workqueues
Date: Tue, 10 Sep 2013 09:52:35 +0800
Message-ID: <1378777955-8264-1-git-send-email-huawei.libin@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.74.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Bin <huawei.libin@huawei.com>

When one work starts execution, the high bits of work's data contain
pool ID. It can represent a maximum of WORK_OFFQ_POOL_NONE. Pool ID
is assigned WORK_OFFQ_POOL_NONE when the work being initialized
indicating that no pool is associated and get_work_pool() uses it to
check the associated pool. So if worker_pool_assign_id() assigns a
ID greater than or equal WORK_OFFQ_POOL_NONE to a pool, it triggers
leakage, and it may break the non-reentrance guarantee.

This patch fix this issue by modifying the worker_pool_assign_id()
function calling idr_alloc() by setting @end param WORK_OFFQ_POOL_NONE.

Furthermore, in the current implementation, the BUILD_BUG_ON() in
init_workqueues makes no sense. The number of worker pools needed
cannot be determined at compile time, because the number of backing
pools for UNBOUND workqueues is dynamic based on the assigned custom
attributes. So remove it.

Signed-off-by: Li Bin <huawei.libin@huawei.com>
---
 kernel/workqueue.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 987293d..5b4c1bd 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -518,14 +518,21 @@ static inline void debug_work_activate(struct work_struct *work) { }
 static inline void debug_work_deactivate(struct work_struct *work) { }
 #endif
 
-/* allocate ID and assign it to @pool */
+/**
+ * worker_pool_assign_id - allocate ID and assing it to @pool
+ * @pool: the pool pointer of interest
+ *
+ * Return 0 if ID assigned successful.
+ * Return non-zero if the allocation fails or the ID number out of
+ * [0, %WORK_OFFQ_POOL_NONE) range.
+ */
 static int worker_pool_assign_id(struct worker_pool *pool)
 {
 	int ret;
 
 	lockdep_assert_held(&wq_pool_mutex);
 
-	ret = idr_alloc(&worker_pool_idr, pool, 0, 0, GFP_KERNEL);
+	ret = idr_alloc(&worker_pool_idr, pool, 0, WORK_OFFQ_POOL_NONE, GFP_KERNEL);
 	if (ret >= 0) {
 		pool->id = ret;
 		return 0;
@@ -5009,10 +5016,6 @@ static int __init init_workqueues(void)
 	int std_nice[NR_STD_WORKER_POOLS] = { 0, HIGHPRI_NICE_LEVEL };
 	int i, cpu;
 
-	/* make sure we have enough bits for OFFQ pool ID */
-	BUILD_BUG_ON((1LU << (BITS_PER_LONG - WORK_OFFQ_POOL_SHIFT)) <
-		     WORK_CPU_END * NR_STD_WORKER_POOLS);
-
 	WARN_ON(__alignof__(struct pool_workqueue) < __alignof__(long long));
 
 	pwq_cache = KMEM_CACHE(pool_workqueue, SLAB_PANIC);
-- 
1.8.2.1


