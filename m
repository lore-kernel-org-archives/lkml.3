Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940Ab3AOW3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:29:11 -0500
Received: from mail.kernel.org ([198.145.19.201]:41607 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757919Ab3AOW3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:29:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Chris Perl <chris.perl@gmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 064/221] SUNRPC: Ensure we release the socket write lock if the rpc_task exits early
Date: Tue, 15 Jan 2013 10:49:51 -0800
Message-Id: <20130115185002.672233925@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/sched.c |    3 +--
 net/sunrpc/xprt.c  |   12 ++++++++++--
 2 files changed, 11 insertions(+), 4 deletions(-)

--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -957,8 +957,7 @@ static void rpc_async_release(struct wor
 
 static void rpc_release_resources_task(struct rpc_task *task)
 {
-	if (task->tk_rqstp)
-		xprt_release(task);
+	xprt_release(task);
 	if (task->tk_msg.rpc_cred) {
 		put_rpccred(task->tk_msg.rpc_cred);
 		task->tk_msg.rpc_cred = NULL;
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1136,10 +1136,18 @@ static void xprt_request_init(struct rpc
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


