Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbaLOOyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:54:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38634 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbaLOO2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:28:18 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <trond.myklebust@primarydata.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 088/168] SUNRPC: Fix locking around callback channel reply receive
Date: Mon, 15 Dec 2014 14:25:42 +0000
Message-Id: <1418653622-21105-89-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit 093a1468b6edb0e568be7311b8d2228d205702db upstream.

Both xprt_lookup_rqst() and xprt_complete_rqst() require that you
take the transport lock in order to avoid races with xprt_transmit().

Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Reviewed-by: Jeff Layton <jlayton@primarydata.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
[ luis: backported to 3.16: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/sunrpc/svcsock.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index b2437ee93657..89a4db5be155 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1000,17 +1000,12 @@ static int receive_cb_reply(struct svc_sock *svsk, struct svc_rqst *rqstp)
 	xid = *p++;
 	calldir = *p;
 
-	if (bc_xprt)
-		req = xprt_lookup_rqst(bc_xprt, xid);
-
-	if (!req) {
-		printk(KERN_NOTICE
-			"%s: Got unrecognized reply: "
-			"calldir 0x%x xpt_bc_xprt %p xid %08x\n",
-			__func__, ntohl(calldir),
-			bc_xprt, xid);
+	if (!bc_xprt)
 		return -EAGAIN;
-	}
+	spin_lock_bh(&bc_xprt->transport_lock);
+	req = xprt_lookup_rqst(bc_xprt, xid);
+	if (!req)
+		goto unlock_notfound;
 
 	memcpy(&req->rq_private_buf, &req->rq_rcv_buf, sizeof(struct xdr_buf));
 	/*
@@ -1021,11 +1016,21 @@ static int receive_cb_reply(struct svc_sock *svsk, struct svc_rqst *rqstp)
 	dst = &req->rq_private_buf.head[0];
 	src = &rqstp->rq_arg.head[0];
 	if (dst->iov_len < src->iov_len)
-		return -EAGAIN; /* whatever; just giving up. */
+		goto unlock_eagain; /* whatever; just giving up. */
 	memcpy(dst->iov_base, src->iov_base, src->iov_len);
 	xprt_complete_rqst(req->rq_task, rqstp->rq_arg.len);
 	rqstp->rq_arg.len = 0;
+	spin_unlock_bh(&bc_xprt->transport_lock);
 	return 0;
+unlock_notfound:
+	printk(KERN_NOTICE
+		"%s: Got unrecognized reply: "
+		"calldir 0x%x xpt_bc_xprt %p xid %08x\n",
+		__func__, ntohl(calldir),
+		bc_xprt, ntohl(xid));
+unlock_eagain:
+	spin_unlock_bh(&bc_xprt->transport_lock);
+	return -EAGAIN;
 }
 
 static int copy_pages_to_kvecs(struct kvec *vec, struct page **pages, int len)
-- 
2.1.3

