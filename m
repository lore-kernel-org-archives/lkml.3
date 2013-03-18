Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab3CREaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:30:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33376 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751235Ab3CREaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:30:02 -0400
Message-Id: <20130318042144.720294013@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:21:49 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 05/82] SUNRPC: Dont start the retransmission timer when out of socket
 space
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit a9a6b52ee1baa865283a91eb8d443ee91adfca56 upstream.

If the socket is full, we're better off just waiting until it empties,
or until the connection is broken. The reason why we generally don't
want to time out is that the call to xprt->ops->release_xprt() will
trigger a connection reset, which isn't helpful...

Let's make an exception for soft RPC calls, since they have to provide
timeout guarantees.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sunrpc/xprt.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -481,13 +481,17 @@ EXPORT_SYMBOL_GPL(xprt_wake_pending_task
  * xprt_wait_for_buffer_space - wait for transport output buffer to clear
  * @task: task to be put to sleep
  * @action: function pointer to be executed after wait
+ *
+ * Note that we only set the timer for the case of RPC_IS_SOFT(), since
+ * we don't in general want to force a socket disconnection due to
+ * an incomplete RPC call transmission.
  */
 void xprt_wait_for_buffer_space(struct rpc_task *task, rpc_action action)
 {
 	struct rpc_rqst *req = task->tk_rqstp;
 	struct rpc_xprt *xprt = req->rq_xprt;
 
-	task->tk_timeout = req->rq_timeout;
+	task->tk_timeout = RPC_IS_SOFT(task) ? req->rq_timeout : 0;
 	rpc_sleep_on(&xprt->pending, task, action);
 }
 EXPORT_SYMBOL_GPL(xprt_wait_for_buffer_space);


