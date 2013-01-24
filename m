Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab3AXDkN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:40:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44280 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371Ab3AXD3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:29:55 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 36/74] SUNRPC: Ensure we release the socket write lock if the rpc_task exits early
Date: Thu, 24 Jan 2013 01:26:48 -0200
Message-Id: <1358998046-613-37-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 87ed50036b866db2ec2ba16b2a7aec4a2b0b7c39 upstream.

If the rpc_task exits while holding the socket write lock before it has
allocated an rpc slot, then the usual mechanism for releasing the write
lock in xprt_release() is defeated.

The problem occurs if the call to xprt_lock_write() initially fails, so
that the rpc_task is put on the xprt->sending wait queue. If the task
exits after being assigned the lock by __xprt_lock_write_func, but
before it has retried the call to xprt_lock_and_alloc_slot(), then
it calls xprt_release() while holding the write lock, but will
immediately exit due to the test for task->tk_rqstp != NULL.

Reported-by: Chris Perl <chris.perl@gmail.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/sunrpc/sched.c |    3 +--
 net/sunrpc/xprt.c  |   12 ++++++++++--
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index fe2cf2f..85b9235 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -953,8 +953,7 @@ static void rpc_async_release(struct work_struct *work)
 
 static void rpc_release_resources_task(struct rpc_task *task)
 {
-	if (task->tk_rqstp)
-		xprt_release(task);
+	xprt_release(task);
 	if (task->tk_msg.rpc_cred) {
 		put_rpccred(task->tk_msg.rpc_cred);
 		task->tk_msg.rpc_cred = NULL;
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 2d5b811..6329ff3 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1139,10 +1139,18 @@ static void xprt_request_init(struct rpc_task *task, struct rpc_xprt *xprt)
 void xprt_release(struct rpc_task *task)
 {
 	struct rpc_xprt	*xprt;
-	struct rpc_rqst	*req;
+	struct rpc_rqst	*req = task->tk_rqstp;
 
-	if (!(req = task->tk_rqstp))
+	if (req == NULL) {
+		if (task->tk_client) {
+			rcu_read_lock();
+			xprt = rcu_dereference(task->tk_client->cl_xprt);
+			if (xprt->snd_task == task)
+				xprt_release_write(xprt, task);
+			rcu_read_unlock();
+		}
 		return;
+	}
 
 	xprt = req->rq_xprt;
 	if (task->tk_ops->rpc_count_stats != NULL)
-- 
1.7.9.5

