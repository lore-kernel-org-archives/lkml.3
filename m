Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370AbaGOJcH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:32:07 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:36192 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758336AbaGOJcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:32:01 -0400
X-IronPort-AV: E=Sophos;i="5.00,895,1396972800"; 
   d="scan'208";a="33286562"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH] workqueue: alloc struct worker on its local node
Date: Tue, 15 Jul 2014 17:24:15 +0800
Message-ID: <1405416264-11611-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the create_worker() is called from non-manager, the struct worker
is allocated from the node of the caller which may be different from the
node of pool->node.

So we add a node ID argument for the alloc_worker() to ensure the
struct worker is allocated from the preferable node.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index e83c42a..a4a5364 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1614,11 +1614,11 @@ static void worker_leave_idle(struct worker *worker)
 	list_del_init(&worker->entry);
 }
 
-static struct worker *alloc_worker(void)
+static struct worker *alloc_worker(int nid)
 {
 	struct worker *worker;
 
-	worker = kzalloc(sizeof(*worker), GFP_KERNEL);
+	worker = kzalloc_node(sizeof(*worker), GFP_KERNEL, nid);
 	if (worker) {
 		INIT_LIST_HEAD(&worker->entry);
 		INIT_LIST_HEAD(&worker->scheduled);
@@ -1713,7 +1713,7 @@ static struct worker *create_worker(struct worker_pool *pool)
 	if (id < 0)
 		goto fail;
 
-	worker = alloc_worker();
+	worker = alloc_worker(pool->node);
 	if (!worker)
 		goto fail;
 
@@ -4129,7 +4129,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	if (flags & WQ_MEM_RECLAIM) {
 		struct worker *rescuer;
 
-		rescuer = alloc_worker();
+		rescuer = alloc_worker(NUMA_NO_NODE);
 		if (!rescuer)
 			goto err_destroy;
 
-- 
1.7.4.4

