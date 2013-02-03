Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab3BCOzn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:55:43 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34217 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753462Ab3BCOzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:55:39 -0500
Message-Id: <20130203144646.508344097@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:12 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Trond Myklebust <Trond.Myklebust@netapp.com>,
        Chris Perl <chris.perl@gmail.com>
Subject: [ 028/128] SUNRPC: Ensure we release the socket write lock if the rpc_task
 exits early
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sunrpc/sched.c |    3 +--
 net/sunrpc/xprt.c  |   12 ++++++++++--
 2 files changed, 11 insertions(+), 4 deletions(-)

--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -918,8 +918,7 @@ static void rpc_async_release(struct wor
 
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
@@ -1132,10 +1132,18 @@ static void xprt_request_init(struct rpc
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
 	rpc_count_iostats(task);


