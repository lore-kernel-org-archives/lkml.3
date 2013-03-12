Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab3CLWdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:33:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60151 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933382Ab3CLWcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:32:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 027/100] SUNRPC: Dont start the retransmission timer when out of socket space
Date: Tue, 12 Mar 2013 15:31:12 -0700
Message-Id: <20130312223125.957628840@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/xprt.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -485,13 +485,17 @@ EXPORT_SYMBOL_GPL(xprt_wake_pending_task
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


