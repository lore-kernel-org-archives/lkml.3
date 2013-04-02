Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760885Ab3DBWLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:11:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32808 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab3DBWLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:11:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 001/124] SUNRPC: Add barriers to ensure read ordering in rpc_wake_up_task_queue_locked
Date: Tue,  2 Apr 2013 15:09:43 -0700
Message-Id: <20130402221104.379893358@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 1166fde6a923c30f4351515b6a9a1efc513e7d00 upstream.

We need to be careful when testing task->tk_waitqueue in
rpc_wake_up_task_queue_locked, because it can be changed while we
are holding the queue->lock.
By adding appropriate memory barriers, we can ensure that it is safe to
test task->tk_waitqueue for equality if the RPC_TASK_QUEUED bit is set.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/sched.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -180,6 +180,8 @@ static void __rpc_add_wait_queue(struct
 		list_add_tail(&task->u.tk_wait.list, &queue->tasks[0]);
 	task->tk_waitqueue = queue;
 	queue->qlen++;
+	/* barrier matches the read in rpc_wake_up_task_queue_locked() */
+	smp_wmb();
 	rpc_set_queued(task);
 
 	dprintk("RPC: %5u added to queue %p \"%s\"\n",
@@ -430,8 +432,11 @@ static void __rpc_do_wake_up_task(struct
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


