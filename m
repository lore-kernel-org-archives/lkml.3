Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936639Ab3DHKXz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:23:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42636 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935428Ab3DHJvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:51:17 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 012/102] SUNRPC: Add barriers to ensure read ordering in rpc_wake_up_task_queue_locked
Date: Mon,  8 Apr 2013 10:49:27 +0100
Message-Id: <1365414657-29191-13-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 1166fde6a923c30f4351515b6a9a1efc513e7d00 upstream.

We need to be careful when testing task->tk_waitqueue in
rpc_wake_up_task_queue_locked, because it can be changed while we
are holding the queue->lock.
By adding appropriate memory barriers, we can ensure that it is safe to
test task->tk_waitqueue for equality if the RPC_TASK_QUEUED bit is set.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/sunrpc/sched.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index 85b9235..72d89e1 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -143,6 +143,8 @@ static void __rpc_add_wait_queue(struct rpc_wait_queue *queue,
 		list_add_tail(&task->u.tk_wait.list, &queue->tasks[0]);
 	task->tk_waitqueue = queue;
 	queue->qlen++;
+	/* barrier matches the read in rpc_wake_up_task_queue_locked() */
+	smp_wmb();
 	rpc_set_queued(task);
 
 	dprintk("RPC: %5u added to queue %p \"%s\"\n",
@@ -399,8 +401,11 @@ static void __rpc_do_wake_up_task(struct rpc_wait_queue *queue, struct rpc_task
  */
 static void rpc_wake_up_task_queue_locked(struct rpc_wait_queue *queue, struct rpc_task *task)
 {
-	if (RPC_IS_QUEUED(task) && task->tk_waitqueue == queue)
-		__rpc_do_wake_up_task(queue, task);
+	if (RPC_IS_QUEUED(task)) {
+		smp_rmb();
+		if (task->tk_waitqueue == queue)
+			__rpc_do_wake_up_task(queue, task);
+	}
 }
 
 /*
-- 
1.8.1.2

