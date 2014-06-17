Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482AbaFQWx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:53:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53619 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965254AbaFQVp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:45:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steve Dickson <steved@redhat.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 002/212] SUNRPC: Ensure call_connect_status() deals correctly with SOFTCONN tasks
Date: Tue, 17 Jun 2014 14:41:36 -0700
Message-Id: <1403041506-13646-3-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

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
[ Stefan Bader: backport to 3.13-stable: context ]
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/sunrpc/clnt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 70eddf3..ed2c481 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1800,10 +1800,10 @@ call_connect_status(struct rpc_task *task)
 	case -ECONNREFUSED:
 	case -ECONNRESET:
 	case -ENETUNREACH:
-		/* retry with existing socket, after a delay */
-		rpc_delay(task, 3*HZ);
 		if (RPC_IS_SOFTCONN(task))
 			break;
+		/* retry with existing socket, after a delay */
+		rpc_delay(task, 3*HZ);
 	case -EAGAIN:
 		/* Check for timeouts before looping back to call_bind */
 	case -ETIMEDOUT:
-- 
1.9.1

