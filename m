Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797AbaCEO7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:59:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41543 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758137AbaCEOhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:37:18 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <trond.myklebust@primarydata.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 05/62] SUNRPC: Fix races in xs_nospace()
Date: Wed,  5 Mar 2014 14:36:09 +0000
Message-Id: <1394030226-26652-6-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
References: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.32 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit 06ea0bfe6e6043cb56a78935a19f6f8ebc636226 upstream.

When a send failure occurs due to the socket being out of buffer space,
we call xs_nospace() in order to have the RPC task wait until the
socket has drained enough to make it worth while trying again.
The current patch fixes a race in which the socket is drained before
we get round to setting up the machinery in xs_nospace(), and which
is reported to cause hangs.

Link: http://lkml.kernel.org/r/20140210170315.33dfc621@notabene.brown
Fixes: a9a6b52ee1ba (SUNRPC: Don't start the retransmission timer...)
Reported-by: Neil Brown <neilb@suse.com>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/sunrpc/xprtsock.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 31f981d..31275e5 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -501,6 +501,7 @@ static int xs_nospace(struct rpc_task *task)
 	struct rpc_rqst *req = task->tk_rqstp;
 	struct rpc_xprt *xprt = req->rq_xprt;
 	struct sock_xprt *transport = container_of(xprt, struct sock_xprt, xprt);
+	struct sock *sk = transport->inet;
 	int ret = -EAGAIN;
 
 	dprintk("RPC: %5u xmit incomplete (%u left of %u)\n",
@@ -518,7 +519,7 @@ static int xs_nospace(struct rpc_task *task)
 			 * window size
 			 */
 			set_bit(SOCK_NOSPACE, &transport->sock->flags);
-			transport->inet->sk_write_pending++;
+			sk->sk_write_pending++;
 			/* ...and wait for more buffer space */
 			xprt_wait_for_buffer_space(task, xs_nospace_callback);
 		}
@@ -528,6 +529,9 @@ static int xs_nospace(struct rpc_task *task)
 	}
 
 	spin_unlock_bh(&xprt->transport_lock);
+
+	/* Race breaker in case memory is freed before above code is called */
+	sk->sk_write_space(sk);
 	return ret;
 }
 
-- 
1.9.0

