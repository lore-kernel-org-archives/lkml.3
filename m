Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966059AbaLLKQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 05:16:47 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:51296 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965640AbaLLKQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 05:16:25 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="44952110"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 5/5] workqueue: retry on NUMA_NO_NODE when create_worker() fails
Date: Fri, 12 Dec 2014 18:19:55 +0800
Message-ID: <1418379595-6281-6-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com>
References: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A pwq bound to a specified node might be last long or even forever after
the node was offline.  Especially when this pwq has some back-to-back work
items which requeue themselves and cause the pwq can't quit.

This kinds of pwqs will cause their own pools busy and maybe create workers.
This pools will fail on create_worker() since the node is offline.

This case is extremely rare, but it is possible. And we hope create_worker()
to be fault-tolerant in this case and other different cases when the node
is lack of memory, for example, create_worker() can try to allocate memory
from the whole system rather than only the target node, the most important
thing is making some progress.

So the solution is that, when the create_worker() fails on a specified node,
it will retry with NUMA_NO_NODE for further allocation.

Cc: Tejun Heo <tj@kernel.org>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: "Gu, Zheng" <guz.fnst@cn.fujitsu.com>
Cc: tangchen <tangchen@cn.fujitsu.com>
Cc: Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 29a96c3..9e35a79 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1673,13 +1673,16 @@ static struct worker *create_worker(struct worker_pool *pool)
 	struct worker *worker = NULL;
 	int id = -1;
 	char id_buf[16];
+	int node = pool->node;
 
 	/* ID is needed to determine kthread name */
 	id = ida_simple_get(&pool->worker_ida, 0, 0, GFP_KERNEL);
 	if (id < 0)
-		goto fail;
+		return NULL;
 
-	worker = alloc_worker(pool->node);
+again:
+	if (!worker)
+		worker = alloc_worker(node);
 	if (!worker)
 		goto fail;
 
@@ -1692,7 +1695,7 @@ static struct worker *create_worker(struct worker_pool *pool)
 	else
 		snprintf(id_buf, sizeof(id_buf), "u%d:%d", pool->id, id);
 
-	worker->task = kthread_create_on_node(worker_thread, worker, pool->node,
+	worker->task = kthread_create_on_node(worker_thread, worker, node,
 					      "kworker/%s", id_buf);
 	if (IS_ERR(worker->task))
 		goto fail;
@@ -1715,8 +1718,11 @@ static struct worker *create_worker(struct worker_pool *pool)
 	return worker;
 
 fail:
-	if (id >= 0)
-		ida_simple_remove(&pool->worker_ida, id);
+	if (node != NUMA_NO_NODE) {
+		node = NUMA_NO_NODE;
+		goto again;
+	}
+	ida_simple_remove(&pool->worker_ida, id);
 	kfree(worker);
 	return NULL;
 }
-- 
1.7.4.4

