Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab3C1GoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 02:44:20 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:52570 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab3C1GoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 02:44:16 -0400
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jack@suse.cz, fengguang.wu@intel.com, jmoyer@redhat.com,
        zab@redhat.com, linux-kernel@vger.kernel.org,
        herbert@gondor.hengli.com.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/14] workqueue: drop 'H' from kworker names of unbound worker pools
Date: Wed, 27 Mar 2013 23:43:29 -0700
Message-Id: <1364453020-2829-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1364453020-2829-1-git-send-email-tj@kernel.org>
References: <1364453020-2829-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, all workqueue workers which have negative nice value has
'H' postfixed to their names.  This is necessary for per-cpu workers
as they use the CPU number instead of pool->id to identify the pool
and the 'H' postfix is the only thing distinguishing normal and
highpri workers.

As workers for unbound pools use pool->id, the 'H' postfix is purely
informational.  TASK_COMM_LEN is 16 and after the static part and
delimiters, there are only five characters left for the pool and
worker IDs.  We're expecting to have more unbound pools with the
scheduled NUMA awareness support.  Let's drop the non-essential 'H'
postfix from unbound kworker name.

While at it, restructure kthread_create*() invocation to help future
NUMA related changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 54b5048..57ced49 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1644,9 +1644,10 @@ static struct worker *alloc_worker(void)
  */
 static struct worker *create_worker(struct worker_pool *pool)
 {
-	const char *pri = pool->attrs->nice < 0  ? "H" : "";
 	struct worker *worker = NULL;
+	int node = pool->cpu >= 0 ? cpu_to_node(pool->cpu) : NUMA_NO_NODE;
 	int id = -1;
+	char id_buf[16];
 
 	lockdep_assert_held(&pool->manager_mutex);
 
@@ -1672,13 +1673,13 @@ static struct worker *create_worker(struct worker_pool *pool)
 	worker->id = id;
 
 	if (pool->cpu >= 0)
-		worker->task = kthread_create_on_node(worker_thread,
-					worker, cpu_to_node(pool->cpu),
-					"kworker/%d:%d%s", pool->cpu, id, pri);
+		snprintf(id_buf, sizeof(id_buf), "%d:%d%s", pool->cpu, id,
+			 pool->attrs->nice < 0  ? "H" : "");
 	else
-		worker->task = kthread_create(worker_thread, worker,
-					      "kworker/u%d:%d%s",
-					      pool->id, id, pri);
+		snprintf(id_buf, sizeof(id_buf), "u%d:%d", pool->id, id);
+
+	worker->task = kthread_create_on_node(worker_thread, worker, node,
+					      "kworker/%s", id_buf);
 	if (IS_ERR(worker->task))
 		goto fail;
 
-- 
1.8.1.4

