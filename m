Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbaCaAQk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:16:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36386 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753027AbaC3XZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:02 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Neil Brown" <neilb@suse.com>,
        "Trond Myklebust" <trond.myklebust@primarydata.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.551465051@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 101/200] SUNRPC: Fix races in xs_nospace()
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sunrpc/xprtsock.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -501,6 +501,7 @@ static int xs_nospace(struct rpc_task *t
 	struct rpc_rqst *req = task->tk_rqstp;
 	struct rpc_xprt *xprt = req->rq_xprt;
 	struct sock_xprt *transport = container_of(xprt, struct sock_xprt, xprt);
+	struct sock *sk = transport->inet;
 	int ret = -EAGAIN;
 
 	dprintk("RPC: %5u xmit incomplete (%u left of %u)\n",
@@ -518,7 +519,7 @@ static int xs_nospace(struct rpc_task *t
 			 * window size
 			 */
 			set_bit(SOCK_NOSPACE, &transport->sock->flags);
-			transport->inet->sk_write_pending++;
+			sk->sk_write_pending++;
 			/* ...and wait for more buffer space */
 			xprt_wait_for_buffer_space(task, xs_nospace_callback);
 		}
@@ -528,6 +529,9 @@ static int xs_nospace(struct rpc_task *t
 	}
 
 	spin_unlock_bh(&xprt->transport_lock);
+
+	/* Race breaker in case memory is freed before above code is called */
+	sk->sk_write_space(sk);
 	return ret;
 }
 

