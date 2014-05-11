Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213AbaEKT5J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:57:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48025 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932713AbaEKTVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:21:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steve Dickson <steved@redhat.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.14 26/83] SUNRPC: Ensure call_connect_status() deals correctly with SOFTCONN tasks
Date: Sun, 11 May 2014 21:19:27 +0200
Message-Id: <20140511191910.628589474@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191907.024339448@linuxfoundation.org>
References: <20140511191907.024339448@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve Dickson <steved@redhat.com>

commit 1fa3e2eb9db07f30a605c66d1a2fdde4b24e74d5 upstream.

Don't schedule an rpc_delay before checking to see if the task
is a SOFTCONN because the tk_callback from the delay (__rpc_atrun)
clears the task status before the rpc_exit_task can be run.

Signed-off-by: Steve Dickson <steved@redhat.com>
Fixes: 561ec1603171c (SUNRPC: call_connect_status should recheck...)
Link: http://lkml.kernel.org/r/5329CF7C.7090308@RedHat.com
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/clnt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1803,10 +1803,10 @@ call_connect_status(struct rpc_task *tas
 	case -ECONNABORTED:
 	case -ENETUNREACH:
 	case -EHOSTUNREACH:
-		/* retry with existing socket, after a delay */
-		rpc_delay(task, 3*HZ);
 		if (RPC_IS_SOFTCONN(task))
 			break;
+		/* retry with existing socket, after a delay */
+		rpc_delay(task, 3*HZ);
 	case -EAGAIN:
 		/* Check for timeouts before looping back to call_bind */
 	case -ETIMEDOUT:


