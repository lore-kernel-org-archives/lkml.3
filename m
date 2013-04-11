Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934907Ab3DKUzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:55:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22974 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935862Ab3DKUt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:28 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=64DydYcl9OoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=m-TJiOppNX4A:10 a=JDjsHSkAAAAA:8 a=VwQbUJbxAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=Hf6muOzgCGQA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202558.346332443@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 074/171 ] SUNRPC: Add barriers to ensure read ordering in
 rpc_wake_up_task_queue_locked
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0074-SUNRPC-Add-barriers-to-ensure-read-ordering-in-rpc_w.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

[ Upstream commit 1166fde6a923c30f4351515b6a9a1efc513e7d00 ]

We need to be careful when testing task->tk_waitqueue in
rpc_wake_up_task_queue_locked, because it can be changed while we
are holding the queue->lock.
By adding appropriate memory barriers, we can ensure that it is safe to
test task->tk_waitqueue for equality if the RPC_TASK_QUEUED bit is set.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/sunrpc/sched.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index 128494e..cd09810 100644
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
@@ -400,8 +402,11 @@ static void __rpc_do_wake_up_task(struct rpc_wait_queue *queue, struct rpc_task
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
1.7.10.4


