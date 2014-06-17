Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652AbaFQW4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:56:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53577 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965112AbaFQVp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:45:26 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <trond.myklebust@primarydata.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 001/212] SUNRPC: Ensure that call_connect times out correctly
Date: Tue, 17 Jun 2014 14:41:35 -0700
Message-Id: <1403041506-13646-2-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit 485f2251782f7c44299c491d4676a8a01428d191 upstream.

When the server is unavailable due to a networking error, etc, we want
the RPC client to respect the timeout delays when attempting to reconnect.

Reported-by: Neil Brown <neilb@suse.de>
Fixes: 561ec1603171 (SUNRPC: call_connect_status should recheck bind..)
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/sunrpc/clnt.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index e726e16..70eddf3 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1797,10 +1797,6 @@ call_connect_status(struct rpc_task *task)
 	trace_rpc_connect_status(task, status);
 	task->tk_status = 0;
 	switch (status) {
-		/* if soft mounted, test if we've timed out */
-	case -ETIMEDOUT:
-		task->tk_action = call_timeout;
-		return;
 	case -ECONNREFUSED:
 	case -ECONNRESET:
 	case -ENETUNREACH:
@@ -1809,7 +1805,9 @@ call_connect_status(struct rpc_task *task)
 		if (RPC_IS_SOFTCONN(task))
 			break;
 	case -EAGAIN:
-		task->tk_action = call_bind;
+		/* Check for timeouts before looping back to call_bind */
+	case -ETIMEDOUT:
+		task->tk_action = call_timeout;
 		return;
 	case 0:
 		clnt->cl_stats->netreconn++;
-- 
1.9.1

