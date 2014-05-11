Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233AbaEKT5h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:57:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48017 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932688AbaEKTVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:21:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Neil Brown <neilb@suse.de>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.14 25/83] SUNRPC: Ensure that call_connect times out correctly
Date: Sun, 11 May 2014 21:19:26 +0200
Message-Id: <20140511191910.492800268@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191907.024339448@linuxfoundation.org>
References: <20140511191907.024339448@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit 485f2251782f7c44299c491d4676a8a01428d191 upstream.

When the server is unavailable due to a networking error, etc, we want
the RPC client to respect the timeout delays when attempting to reconnect.

Reported-by: Neil Brown <neilb@suse.de>
Fixes: 561ec1603171 (SUNRPC: call_connect_status should recheck bind..)
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/clnt.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1798,10 +1798,6 @@ call_connect_status(struct rpc_task *tas
 	trace_rpc_connect_status(task, status);
 	task->tk_status = 0;
 	switch (status) {
-		/* if soft mounted, test if we've timed out */
-	case -ETIMEDOUT:
-		task->tk_action = call_timeout;
-		return;
 	case -ECONNREFUSED:
 	case -ECONNRESET:
 	case -ECONNABORTED:
@@ -1812,7 +1808,9 @@ call_connect_status(struct rpc_task *tas
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


