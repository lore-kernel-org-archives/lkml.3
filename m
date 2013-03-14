Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944Ab3CNKhL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:37:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51727 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756832Ab3CNKgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:36:54 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 09/88] SUNRPC: Don't start the retransmission timer when out of socket space
Date: Thu, 14 Mar 2013 10:35:02 +0000
Message-Id: <1363257381-15900-10-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/sunrpc/xprt.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 6329ff3..b4efb51 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -485,13 +485,17 @@ EXPORT_SYMBOL_GPL(xprt_wake_pending_tasks);
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
-- 
1.8.1.2

