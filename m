Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935106Ab3DGXew (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:34:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46878 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935058Ab3DGXdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:33:54 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Trond Myklebust" <Trond.Myklebust@netapp.com>
Date: Sun, 07 Apr 2013 23:45:42 +0100
Message-ID: <lsq.1365374742.727870826@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [27/74] SUNRPC: Add barriers to ensure read ordering in
 rpc_wake_up_task_queue_locked
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 1166fde6a923c30f4351515b6a9a1efc513e7d00 upstream.

We need to be careful when testing task->tk_waitqueue in
rpc_wake_up_task_queue_locked, because it can be changed while we
are holding the queue->lock.
By adding appropriate memory barriers, we can ensure that it is safe to
test task->tk_waitqueue for equality if the RPC_TASK_QUEUED bit is set.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sunrpc/sched.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -139,6 +139,8 @@ static void __rpc_add_wait_queue(struct
 		list_add_tail(&task->u.tk_wait.list, &queue->tasks[0]);
 	task->tk_waitqueue = queue;
 	queue->qlen++;
+	/* barrier matches the read in rpc_wake_up_task_queue_locked() */
+	smp_wmb();
 	rpc_set_queued(task);
 
 	dprintk("RPC: %5u added to queue %p \"%s\"\n",
@@ -389,8 +391,11 @@ static void __rpc_do_wake_up_task(struct
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

